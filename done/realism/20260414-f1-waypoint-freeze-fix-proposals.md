# F1 Waypoint Freeze — Fix Proposals

**Date:** 2026-04-14
**Status:** Design proposal — not yet implemented
**Related:** `past-sims-reports/20260413-1/20260413-1_report.md` §5.3 (F1), `BACKLOG.md` MOVEMENT-001

---

## Context

During the 750-step validation run of `20260413-1` we logged three waypoint-freeze events totalling ~42 stuck steps. The pattern is consistent across all three: an agent has a valid destination, a valid plan, and a valid path — but another persona is physically standing on a tile *between* them and where they want to go, and the agent freezes in place until either the blocker moves or the schedule advances.

The canonical example from the run: Gosha wanted to reach `Dorm for Oak Hill College:common room:common room sofa` to study. Katya was sitting at the pool table, and her tile happened to be on the only A*-reachable corridor between Gosha's current position and the sofa. Gosha froze for 21 steps.

### Root cause

Backend and frontend use A* with **different collision semantics**:

- **Backend A\*** treats other personas as *soft obstacles*: they add a cost penalty to a tile, but the tile is still traversable. The backend plans a path *through* the blocker.
- **Frontend A\*** treats other personas as *hard obstacles*: the tile is non-traversable, full stop. When the backend's planned path crosses an occupied tile, the frontend rejects it with `blocked_reason="no_path_to_target_zone"` and the agent stays at `start_pos`.

The backend keeps emitting the same intent each step; the frontend keeps rejecting it the same way; the sim clock advances but the agent doesn't.

### Why existing fixes don't catch it

- **Phase 6** handles the case where the *destination tile* is occupied. Here the destination is free — the occupied tile is somewhere in the middle of the path.
- **Phase 8** handles object-level convergence (multiple agents picking the same target object). Here the two agents have different targets; their paths just happen to cross.

F1 sits in the gap between those two fixes: a pure BE↔FE pathfinding desync on intermediate waypoints.

---

## Design goals

Any fix should satisfy the following:

1. **Alignment, not invention.** The BE already has a semantics that works (soft obstacles with a cost penalty). The fix should align the FE with that semantics, not introduce a third model.
2. **No new contract round-trips.** The BE and FE already exchange intent and realized positions per step. A good fix doesn't require new messages, new state machines, or new handshake protocols.
3. **Determinism preserved.** The sim must stay reproducible across runs. Any randomness or tiebreaker needs to be seeded and ordered.
4. **Low blast radius.** The movement layer is delicate — Phase 7 failed because a well-intentioned waypoint fix interacted with unrelated subsystems (emission short-circuits, schedule advancement on replan). The winning fix should live in a single, contained code path.

---

## Option A — Dynamic FE pathfinding

**Idea.** Make the frontend A* aware of other agents' positions at plan time and replan dynamically when those positions change. Instead of computing one path and defending it, the frontend continuously re-evaluates: each step, each agent rebuilds its path using the latest world state.

### How it would work
Each tick, before moving an agent, the FE recomputes its A* path from current position to target, passing the set of occupied tiles as obstacles. If a previously-valid path is now blocked by another agent who has moved into it, the agent gets a new path that routes around them. If no alternative path exists, the agent falls back to existing freeze behavior but at least it tried.

### Pros
- Handles every variant of the waypoint problem, not just the ones we've observed.
- Feels "smart" and matches how crowd simulators typically behave.
- No BE changes; no contract changes.

### Cons
- **High complexity and high blast radius.** Path computation becomes a per-step, per-agent cost. For 4 agents it's negligible; for 20 it compounds.
- **Replan thrashing.** Two agents can oscillate: A replans around B, then B replans around A's new path, then A replans again. Without careful design this produces visible jitter or deadlocks.
- **Blocks hard obstacles in narrow spaces.** If two agents are walking in the same corridor in the same direction, dynamic replanning doesn't help — the trailing agent's A* still sees the leading agent as impassable and freezes.
- **Hides the real semantic issue.** It layers behavior on top of the hard-block rule instead of fixing the rule. The FE still disagrees with the BE about what "occupied" means.

### Difficulty
**Medium-high.** Estimate ~8 hours of FE work, plus regression validation across existing sims to confirm no path-thrashing in multi-agent gatherings.

### Risk
Medium. The FE movement layer is the same one that bit us in Phase 7; adding per-step replanning on top of the current collision model risks surfacing the same class of interaction bugs we've already paid for once.

---

## Option B — Backend target reselection

**Idea.** When the frontend reports that an agent is blocked (`blocked_reason="no_path_to_target_zone"`), the backend detects the freeze and reassigns the agent to a different target object in the same arena. Same spirit as Phase 8's object redistribution, but triggered by runtime blocking instead of upfront collision detection.

### How it would work
The movement executor checks the frontend's blocked-reason field each step. If an agent has been frozen for N consecutive steps with a waypoint-block reason, the backend runs a scaled-down version of the Phase 8 redistribution logic for that specific agent, picks an alternative object in the same arena, and emits a new intent the next step.

### Pros
- Reuses Phase 8's redistribution machinery, which is already validated and shipped.
- Keeps the collision model itself untouched — no FE path rules change.
- Natural extension of the architectural split: BE owns intention, FE owns spatial realization.

### Cons
- **Triggers after the fact.** The agent still freezes for N steps before the fix kicks in. We're hiding the symptom, not solving it — the BE/FE disagreement still exists under the hood.
- **Target reassignment isn't always semantically valid.** If Gosha specifically wants to sit on the sofa (e.g. because his schedule decomposed to "study on the sofa"), swapping the target to the pool table changes the meaning of the action. Phase 8 could get away with this because the objects were equivalent in intent ("gather at Hobbs Cafe"); here the objects may carry distinct semantics.
- **Race conditions under multi-agent blocking.** If two agents are blocking each other's paths, both may reassign simultaneously, potentially to objects that block each other *again*. The Phase 7 interaction-bug category lives in this neighborhood.
- **Doesn't generalize.** Only fires on freezes; agents can still take awkward paths or get unnecessarily rerouted when a cleaner fix exists.

### Difficulty
**Medium.** Estimate ~6 hours of BE work, plus coordination with the existing Phase 8 redistribution path to avoid double-firing.

### Risk
Medium-high. This is the same subsystem and interaction surface where Phase 7 failed. Extending runtime-triggered reassignment is exactly the kind of change that introduces subtle state-machine coupling.

---

## Option C — FE soft obstacles with destination hard-block *(recommended)*

**Idea.** Change the FE A* rule to match the BE's semantics: other personas are passable as *intermediate* tiles (with a cost penalty), but remain hard-blocked as *destination* tiles. You can walk past someone, you cannot stand on them.

### How it would work
In the FE A* cost or neighbor function, introduce a distinction:

- **Neighbor tile occupied by another persona** → traversable, add a cost penalty (for example `base_cost + 10`), so A* prefers uncluttered paths when one is available but falls back to routing through when it isn't.
- **Goal tile occupied by another persona** → hard block (today's behavior), preserving the invariant that two sprites never occupy the same tile at rest.

Combined with per-step re-planning (which we need to verify the FE already does — see Open Questions below), this mirrors the BE semantics exactly and matches how crowd simulators have handled N-agent navigation for years.

### Pros
- **Aligns FE with BE** — no more dual collision model. The disagreement that causes F1 disappears at the root.
- **Small, contained change.** Estimated ~10–30 LOC in a single A* function. One code path, one test.
- **Composes with Phase 6 and Phase 8** without stepping on them. The hard-block on destination preserves Phase 6; the cost penalty on intermediate tiles does not affect the object-level redistribution logic.
- **Deterministic.** Cost penalties are pure arithmetic — no randomness, no state machine.
- **Natural fallback behavior.** If the only viable path goes through a blocker, the agent takes it (1 step of sprite overlap during the cross, which is aesthetically fine at our current persona counts). If an alternative exists at lower cost, A* picks the alternative automatically.

### Cons
- **Transient visual overlap.** When an agent crosses an occupied tile, there's one animation frame of sprite overlap. At 3–4 personas this is imperceptible; at 20+ it could start to look messy. A cosmetic tuning question, not a correctness one.
- **Requires per-step re-planning in the FE.** If the FE currently caches A* paths aggressively and only recomputes on demand, the fix needs a small additional change to invalidate cached paths when the occupancy set changes. This is on the investigation list.
- **Does not handle every pathological case.** Two agents walking the same corridor in the same direction at the same speed could still walk "on top of each other" for the shared stretch. Mitigation: the cost penalty applied to the tile right ahead of the leader will push the follower to wait or take a parallel path during re-planning.

### Difficulty
**Low to medium.** Estimate ~2–4 hours, contained to a single file.

### Risk
Low. The change is contained to a single well-tested subsystem (A* pathfinding), does not touch the movement executor or the BE↔FE contract, and aligns FE semantics with an already-shipped BE model. If the fix misbehaves, rollback is a single-line revert of the cost penalty.

---

## Comparison

| | Option A: Dynamic FE | Option B: BE target reselection | Option C: Soft obstacles |
|---|---|---|---|
| **Aligns BE and FE semantics** | ❌ No | ❌ No | ✅ Yes |
| **Fix at root vs. at symptom** | Symptom | Symptom | Root |
| **Blast radius** | Medium-high | Medium-high | Low |
| **Lines of code (est.)** | ~200–400 | ~100–200 | ~10–30 |
| **Time estimate** | ~8h | ~6h | 2–4h |
| **Interaction risk** | Medium | Medium-high | Low |
| **Composes with Phase 6/8** | Orthogonal | Partial overlap | ✅ Cleanly |
| **Determinism preserved** | Needs care | Needs care | ✅ By construction |
| **Generalizes to future cases** | Yes | No | Yes |

---

## What this is not

This proposal does **not** cover:
- Crowd behavior at scale (15+ agents). At that scale we may need to revisit the model.
- Two-agent deadlocks in 1-tile-wide corridors where neither can yield. These are rare in our current maps and would need a separate "yield and wait" state, not a pathfinding change.
- Path visualization or debugging overlays — those are downstream of A* and not affected by this change.

These are deferred intentionally. The goal here is to close the F1 class of bugs with the minimum blast radius, not to rebuild the movement layer.

---

## Proposed approach: Option C (FE soft obstacles with destination hard-block)

A preliminary investigation pass against `double-front` confirmed Option C as the path forward. The investigation validated that the fix is contained to a single subsystem and surfaced no ripple effects into other FE subsystems. What follows is the extended analysis built from those findings — enough detail to go from design to implementation without a second discovery round.

### Feasibility

Contained change — approximately **20–50 LOC, ~2–4 hours** of focused work including tests and replay validation. Feasible exactly as proposed. No design adjustments needed; the fix fits the existing A* architecture without structural refactoring.

### Where the hard-obstacle rule lives today

All of the relevant code lives in a single file: `double-front/scenes/managers/AnimationManager.ts`.

- **Main A\*:** `aStar()` at line 5117. The neighbor expansion loop is at lines 5193–5208.
- **Occupancy check:** `inspectTileWalkability()` at lines 4591–4608. When a tile is present in `headlessDynamicOccupiedTiles` and the owner is not the current persona, the function returns `walkable: false`. This is the single point where "another persona is here" gets translated into "impassable" — semantically identical to hitting a wall.
- **Per-step rebuild:** `rebuildHeadlessDynamicOccupancy(stepData)` at line 2804 clears and repopulates the occupancy set at the start of each step, so the A* always has current positions.

The hard-block rule is therefore a single function returning a single boolean. The fix lives there and in the call sites that reference it.

### Intermediate vs destination — current state

**There is no distinction today.** `isWalkable()` at line 4764 is called uniformly for every neighbor expansion, including the goal tile. The goal check at line 5180 only compares coordinates to detect arrival — it does not bypass the occupancy check. A* currently treats "stand on this tile because it's my goal" and "cross this tile en route to somewhere else" identically.

The fix will need to:
1. Add an `isDestinationTile?: boolean` flag to the walkability function signature.
2. Pass `(nx === goalX && ny === goalY)` from the neighbor expansion at line 5196 down into the walkability check so the goal tile keeps its hard-block behavior while intermediate tiles become traversable.

### Re-planning frequency

The FE runs **a fresh A\* every step in headless mode** (lines 3396–3399: `if (this.isHeadless || this.forceAStar)` → always recompute, ignore the backend-provided path). There is no cached path. This is exactly the condition the soft-obstacle approach needs — no cache-invalidation logic is required, no background recomputation is needed, and the new cost penalty will take effect immediately on the next step after any persona moves.

In replay mode (browser playback) the frontend uses the backend-provided path, so the fix only takes effect during sim generation. This matches where the F1 symptom originates, so the scope is correct.

### Ripple effects

None of concern. The occupancy set `headlessDynamicOccupiedTiles` is read-only from A*'s perspective — it is not consumed by observation emission, proximity calculation, collision events, or any other subsystem that would be affected by a relaxation of the walkability rule. The `claimedTiles` system (F4, a separate mechanism for reserving tiles) is architecturally independent. Debug-mode metrics are diagnostic and do not gate behavior.

**The fix is 100% contained to `AnimationManager.ts`.** No other files need to change.

### Concrete changes (~30–40 LOC)

1. **Extend the walkability signature.** Add an optional `isDestinationTile?: boolean` parameter to `isWalkable()` and `inspectTileWalkability()`.
2. **Relax the occupancy rule for non-destination tiles.** In `inspectTileWalkability()` (lines 4591–4608), when a tile is occupied by another persona *and* `isDestinationTile` is false, return `{ walkable: true, reason: 'dynamic_occupancy_allowed_at_intermediate' }` instead of hard-blocking.
3. **Thread the flag through the neighbor expansion.** At line 5196, pass `(nx === goalX && ny === goalY)` as the `isDestinationTile` argument to the walkability check. The goal tile continues to hard-block; every other tile becomes soft.
4. **Add a cost penalty.** At line 5200, change `current.g + 1` to `occupied ? current.g + 10 : current.g + 1` so A* prefers free paths when available and only routes through when necessary. Exact penalty value is tuneable.
5. **Mirror the changes in `aStarDebug()`** at line 4809 for symmetry, so diagnostic runs agree with production runs.

Total surface area: two function signatures, one conditional branch, one cost expression, and the debug mirror — all in a single file.

### Open risks

1. **Destination tile remains hard-blocked.** Two personas still cannot physically occupy the same tile at rest. The fix lets A* *reach* a neighbor tile but the final move can still fail if the owner of the destination tile has not vacated it by the time the mover arrives. This is acceptable under the current interaction semantics and matches how the BE already behaves.
2. **Penalty value tuning.** The +10 cost penalty is a starting point. It needs empirical validation against the typical movement speed (1–3 tiles per step) to confirm it produces natural-looking detours without causing unnecessary rerouting. The canonical test case is replaying step ~48 of `20260413-1` where Gosha froze waiting on Katya.
3. **Multi-persona convergence on shared intermediate tiles.** If three or more agents simultaneously compute soft-obstacle routes around the same blocker, they could converge on the same intermediate tile. This is a pre-existing risk, not new — the per-step re-plan combined with the F4 `claimedTiles` system already mitigates it in practice.
4. **Contract documentation.** `sot/sot_be-fe.md` does not currently document FE pathfinding semantics explicitly, so no contract update is strictly required. Adding a short note is still recommended for track record — future contributors should understand that FE and BE now share the soft-obstacle model.

### Go-forward plan

1. **Implement** the changes above in `AnimationManager.ts` — one focused commit, approximately 30–40 LOC.
2. **Replay-test against `20260413-1`** — specifically the Dorm common room freeze around step ~48. Confirm Gosha now routes through Katya's tile rather than freezing.
3. **Live headless sim 50–100 steps** with soft-obstacle logging enabled. Confirm: (a) no path-thrashing under multi-agent scenarios, (b) freeze rate drops on F1-class events, (c) Phase 6 and Phase 8 behaviors remain unchanged.
4. **Tune the penalty value** if live testing shows either unnecessary detours (penalty too high) or visible overlap oscillation (penalty too low).
5. **Add the contract note** to `sot/sot_be-fe.md` once the behavior is stabilized.

### Recommendation

**Proceed with implementation.** The investigation eliminated every risk we flagged at design time: the fix is a contained, single-file change; the FE already re-plans per step, so no cache logic is needed; no other subsystems depend on the hard-block rule; the contract does not need to change. The remaining uncertainty is empirical penalty tuning, which is best resolved by running the fix and observing rather than by further analysis.

---

## Review comments — Ivan (2026-04-14)

**Overall:** Green-lit. Option C is the right approach and your investigation answered the questions I would have asked. Ship it.

A competing two-tier FE+BE fallback design was considered in parallel (FE tries a detour A* on block + BE reassigns target on first block report). On comparison, that design matches your Options A + B stacked — and carries the downsides of both. Your Option C fixes the underlying BE/FE semantic mismatch in one file instead of bolting recovery logic onto both sides. The architectural principle that survived from the alternative proposal — **FE owns real-time routing, BE owns target persistence** — is already honored by Option C: the routing intelligence lives in the FE A* cost function (where it belongs), and the BE's intent model is untouched. That's exactly the right split.

**Implementation asks — please treat these as part of the delivery, not post-hoc:**

1. **Penalty tuning must land with the fix, not after.** Your Open Risk #2 calls this out and your plan step #4 defers it to "if live testing shows…" — please promote it to a required step. Run the Gosha/Katya step ~48 replay, verify the detour shape looks natural, and land a tuned value in the commit. A too-low penalty (agents always cut through each other) visibly breaks realism; a too-high penalty (agents only route around) reproduces F1 in subtler ways. If +10 lands in the replay looking right, great — but state that in the PR, don't ship the starting guess unexamined.

2. **Contract note is required, not recommended.** Open Risk #4 leaves the `sot/sot_be-fe.md` update as "still recommended." Please add it. A future contributor reading the FE/BE SOT will expect the collision model to be documented; leaving it implicit now is exactly the kind of debt that generates a wrong-fix six months from now. One paragraph in §2 or §4 is enough.

3. **Confirm the headless-only scope in the commit message.** You noted in "Re-planning frequency" that replay mode uses the BE-provided path, so Option C only takes effect during sim generation. That's the right scope, but please call it out in the PR body so it's not a surprise to anyone who tests a replay and wonders why the behavior looks unchanged.

4. **Interaction with Phase 6's `blocked_tiles`.** Phase 6 already excludes occupied destination tiles from anchor selection BE-side. Option C preserves the destination hard-block FE-side. Together these are consistent, but worth one sentence in the PR to confirm no double-exclusion or drift: the BE filters before sending intent, the FE still hard-blocks on arrival, they reach the same conclusion by different routes.

5. **Validation gate.** Beyond the Gosha/Katya replay, please run one full 200–300-step fresh sim on `base_family_sim` and confirm freeze events drop from the 20260413-1 baseline (3 F1 events / 42 stuck steps). Report the number in the PR. If the fix works, F1 should effectively go to zero in that scenario; if it doesn't, the penalty is likely wrong.

**Things I deliberately did not ask for:**

- No env flag. Don't gate this behind a `FE_SOFT_OBSTACLE_ENABLED` toggle — it's a bug fix, not an experiment, and adding a flag just creates a rollback-by-config path that we'll forget to clean up.
- No yield/retry state machine. Explicitly out of scope per your "What this is not" section and I agree — that's a separate, bigger piece of work.
- No crowd-scale testing. 15+ agent behavior is a post-MVP concern; validate at current scale and we'll revisit when we hit it.

**Green light. Proceed.**
