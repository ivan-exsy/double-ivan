## 2026-04-18 — Review and direction pass (Ivan + Claude)

### Outcome

F2 is closed on `nicolas/f2-misroute-fixes` with two tightening edits and a clear direction for the next pass. The branch has been rebased cleanly onto current `origin/main` (10 commits ahead of Nicolas's original base) and is ready to merge once verify passes a second time.

### What we kept from Nicolas's work

All three architectural pieces stay. Staff-only objects + `work_area` on personas + universal post-resolution validator across GUARD/Typed/LLM paths — these are proper world-property gates and they close Patterns B and C end-to-end. The decomp-gate mechanism (required `inherits_parent_location` field + detach helper in `plan.py`) is the right shape for Pattern A: it attacks the bug at the decomp LLM output, not post-reject.

### What we adjusted

1. **Flipped the decomp-gate default.** `inherits_parent_location` used to default to `false` ("assume orthogonal unless LLM says otherwise"). Now defaults to `true` ("sub-tasks happen within the parent's context unless LLM flags them as genuinely orthogonal"). This matches natural decomposition: chopping vegetables stays in the kitchen, serving coffee stays at the counter. The detach path still fires when the LLM explicitly sets `false` — Pattern A's canonical voting-window case ("finalize gifts" during the gather) is still caught.
2. **Reverted the Chunk B Hobbs Cafe hunk.** Nicolas's "Strict registry expansions" commit said it only touched apartment and house cooking arenas, but the diff also added `cook` and `play` to the Hobbs Cafe whitelist. That silently loosened the canonical F2 target arena — exactly the arena the fix was meant to protect. The apartment/house cook additions remain; only the Hobbs Cafe hunk was reverted. This unblocks `test_hobbs_cafe_arena_seeded`, which was Nicolas's own guardrail for exactly this kind of drift.
3. **Confirmed contextual task-decomp is already on Tier B.** No model change needed.

### Why we made those two calls

Both came from the same read of the system: **deterministic guards layered onto a non-deterministic engine limit the emergent behaviour the system is supposed to produce.** The original Stanford design had no activity whitelists — it trusted the LLM with a filtered location tree. Every guard we've added since Phase 6 was a reaction to a specific incident, and each one ratchets the data-maintenance surface. Flipping the decomp default toward inheritance is a small step back toward trusting the LLM. Reverting the Hobbs Cafe expansion prevents the test suite from silently going out of sync with reality. Together they're the minimum edits that preserve Nicolas's architecture while holding the door open for the north-star direction (see backlog below).

### What is still deferred

- **Supabase migration for `work_area`** (BACKLOG `DB-MIGRATION-001`). The Luba hardcode in `scratch.py` stays until the column is added; everything else in the Tier-3 cascade gates on it.
- **Registry coverage** for arenas without ground truth (BACKLOG `REGISTRY-COVERAGE-001`).
- **Canonical Pattern A voting-window empirical confirmation** — requires a ≥600-step sim that reaches the gather.
- **A↔B activity loops** (separate from F2; preexisting; BACKLOG `REALISM-001`).

### New backlog items opened during this review

1. **`LOCATION-WHITELIST-SOFT-001` (P2)** — Soften `activity_whitelist` from hard reject to scoring weight. The whitelist approach doesn't scale cleanly to many maps / many personas / custom scenarios. Keeping staff-only and privacy as hard gates, everything else becomes LLM judgement + soft preference.
2. **`OBJECT-STAFF-001` (P3)** — Inherit `staff_only` from arena to activity-specific objects (e.g. `cooking area` in a commercial cafe should inherit the cafe's staff-only posture, not just `behind the cafe counter`).
3. **`RESOLVER-TIER-B-001` (P3)** — Escalation policy so the resolver can re-roll on Tier B when it lands on a penalised arena, sees a novel anchor, or is inside a survival gathering window. Dependent on `LOCATION-WHITELIST-SOFT-001`.
4. **`RESOLVER-LLM-FIRST-001` (P4, north star)** — Pure LLM-first resolver in the shape of the Stanford paper. Retire activity whitelists and keyword guards; keep only world-property gates (staff-only, access). This is how the product version should work. Intermediate steps are the three above.

### Open product question that came out of the review

Is the system supposed to be reliable first or emergent first? The honest answer shapes how far we push on `RESOLVER-LLM-FIRST-001`. Today's architecture is reliability-first (deterministic guards catch 100% of known misroute patterns at the cost of blocking interesting scenes). The Stanford architecture is emergent-first (LLM makes the call; some weirdness is accepted). The right answer for the product version is probably emergent-first with a small tolerable weirdness budget — but it's worth naming explicitly rather than drifting into it.

---

## 2026-04-18 — Implementation pass (Nicolas)

### Status

Closed Patterns B (staff_only) and D (activity-type-blind) end-to-end on a 60-step validation sim (`20260418-f2-cleanup-60`): 4/4 personas resolve correctly at step 0, 0 PLANNER CONTRACT DOWNGRADE, 0 regressions vs the main baseline (`20260417-f2-baseline-30`). Implementation lives in branch `nicolas/f2-misroute-fixes` as a single commit on top of `origin/main` (`61d1ca50`).

Pattern A (anchor bleed through decomposition) is also closed in this branch via a separate commit: decomp gating with structured `activity_type` and `inherits_parent_location` fields enforced at the LLM output, plus a detach helper that drops the sub-task anchor when the LLM emits `inherits_parent_location=false` but still bleeds the parent anchor implicitly. Your reading on Pattern A was correct — the structural fix had to live upstream in `_build_contextual_decomp_pack`, not in the resolver. ~39 LOC delta, kept as a separate commit (`c6d2bdf4`) on the same branch so the architectural distinction (resolver-side vs decomp-side) stays visible in history. End-to-end empirical confirmation requires a sim that reaches the voting window (~step 600); deferred to the next long-run validation pass.

**Deferred from this pass:**

- **Supabase migration for the `work_area` column** on `double.persona_scratch`. Currently implemented via `_WORK_AREA_DEFAULTS` hardcode in `scratch.py` (covers Luba only). Adding the column unblocks any persona with a profession to use the Tier-3 cascade. SQL ready; needs someone with DB access to run. Once applied, the hardcode block in `scratch.py:344-350` can be removed.
- **Registry coverage** for arenas without historical ground truth (Studio Rooms 2/4, Studio Bathrooms, secondary bedrooms in Houses 4–6) and commercial sectors (Harvey Supply, Willows Market). Trigger to revisit: any future sim that exercises those arenas.

Detailed rationale in `local_docs/20260417-f2-fix-validation.md` Steps 6.5 + 9.

### Why the baseline is `61d1ca50`

`origin/main` HEAD as of work start. No newer commits had landed; the branch shares an identical merge-base. Validation sims compare directly against a baseline run from the same commit, so deltas are attributable.

### Why the approach is architecturally sound for B and D

Two changes together close the LLM-path bypass that made the original PR1/PR2 work look like a post-resolution reject layer:

1. **Universal post-resolution validator** firing after GUARD, Typed scorer, and LLM paths alike. The previous `activity_whitelist` only covered GUARD; the LLM path was bypassing it — exactly as your verdict noted. That gap is closed.
2. **Registry-driven enforcement** via `staff_only` / `activity_whitelist` / `affordances`. These are properties of the world, not of any persona or sim. The same `bed`, `desk`, `closet` declarations are valid across maps and personas — populate once, reuse everywhere. A 4-tier cascade (repair → activity_type → work_area → living_area) handles partial-data cases.

A side-effect of completing the registry: the 7 SAT-specific bridge tokens previously added to `KEYWORD_MAP["work"]` were removed. With the data populated, Gosha now routes to `library:library table` (semantically more correct than the dorm desk that the keyword hack produced).

### Detailed validation log

`generative_agents-local/local_docs/20260417-f2-fix-validation.md` (Steps 1-7) — step-by-step diagnosis, smoke results, architectural review, and the registry-vs-Supabase decision.

### Adjacent observation — A→B→A→B activity loops

Looking at the 190-step validation run, several personas show repeated alternations (Katya: desk ↔ cafe; Gosha: library ↔ cafe; Ivan: sleep ↔ alarm — Ivan cycled four sleep/alarm beats in 65 steps). Same pattern is visible in `20260417-6` first 75 steps (Luba: cafe prep ↔ walk home retrieve notes; Gosha: SAT packing ↔ walk to cafe; Katya: sketch packing ↔ review challenge rules), so the F2 fix doesn't introduce or worsen it — looks like preexisting behavior on the planner/lifecycle layer, likely the `REALISM-001` activity-state-machine territory already in BACKLOG ("emergent deadlocks from 6 dispersed coordination mechanisms — historical desk→eat→desk stasis").

Worth a separate pass to confirm where the regression line actually sits — whether the Stage 0/1/2 cognitive-integration changes shifted anything, or whether the loops trace back further than that. Easy comparison: a 75-step audit on a sim from before Stage 0 lands (e.g. a sim from early April) vs `20260417-6` vs `20260418-f2-final-190` — same A↔B loop signature in all three would point clearly at "long-standing planner behavior, not regression". Not blocking F2 PR; flagging here so it doesn't get conflated with the validator work when reviewing the sim bundle.

---

## **Pre-phase**

Here is historic context as I worked on fixing location resolution - that should help with your work on F2 issue:

Here's the arc of the LLM location-grounding work, in product terms. The goal throughout: make sure the agent actually goes where its action says it's going, and never to a place that doesn't exist on the map.

### The core problem (3 flavours)
1. **Hallucinated locations** — LLM inventing places like "campus loop" or "Oak Hill study carrel" that aren't real map addresses.
2. **Wrong sector** — LLM picks the right activity type but the wrong area (sleep at library, crafting at grocery store).
3. **Anchor bleed (F2)** — LLM routes a sub-task based on the parent task's context (Katya's "finalize Christmas gift designs" ends up at Hobbs Cafe because the parent schedule entry is a cafe gather).

### Chronological approach — what was built

**Phase 3 (Mar 22) — Unified resolver.**
Collapsed 3 sequential LLM calls (sector → arena → object) into **one** holistic call: `run_gpt_prompt_action_location_unified`. Prompt template: `action_location_unified_v1.txt`. The LLM sees the full filtered location tree and picks `sector | arena | object` in one shot. Eliminates error cascading. Kept the deterministic sleep guard for generic "sleeping" actions — shortcuts to home bed, no LLM call.

**Phase 4 (Mar 23) — Stickiness + tag plumbing.**
Added location stickiness so the same action doesn't re-resolve to a different place every step, fixed tag stripping / multi-word anchor parsing, fixed movement JSON teleportation display.

**Phase 5.0 / 5.1 (Mar 26–27) — Contract-first architecture.**
Introduced `ActionContractV1` as the canonical record of the current action — stable `action_id`, `resolved_address`, `anchor_text`, `subactivity_mode`, `duration_min`. Purpose: kill the "semantic decision made twice" loop (decomp → cleaned text → re-inferred location). One contract, persisted, used by runtime/API/FE.

**Phase 6 (Mar 28) — The big pivot: LLM-first + Contract persistence.**
RCA on sim `20260327-2` found the anchor-to-address **deterministic string scorer** was causing 13.3% misroute rate (e.g., "Oak Hill" matched both `Oak Hill College` and `Dorm for Oak Hill College`, and the string-length tiebreaker sent everything to the dorm's bathroom). Key insight: **deterministic keyword matching cannot understand that "study carrel" means "library"** — only the LLM can.

Design that stuck:
- LLM is the primary resolver with the anchor as the strongest signal (PRIORITY/FALLBACK structure in the prompt).
- Contract locks the validated LLM result for the action's duration.
- Hard validation gate (`build_action_contract`) rejects any address not in `maze.address_tiles`, and rejects bed for non-sleep.
- Prompt hardened: PRIORITY rule ("explicit place in action text wins"), 8 activity-type fallbacks, explicit anti-bed rule, 4 new few-shot examples.

**Late March — Anchor hallucination defenses.**
- Replaced fictional few-shot examples ("campus loop", etc.) with **real** maze names verified against `game_object_blocks.csv` / `arena_blocks.csv`.
- Added `_build_filtered_location_tree()` — shared helper so the decomp prompt and the resolver prompt see the **same** privacy-filtered map. No more "the LLM invented a location because decomp was shown a different menu than resolution."
- Added `_validate_and_correct_anchor()` post-decomp: fuzzy-token match fictional anchors to the nearest real name, or strip to `local_anchor`. Guarded by `ANCHOR_FILTER_TREE_ENABLED` / `ANCHOR_VALIDATION_ENABLED` (both reversible).

**Apr 13 (Nicolas) — Diagnostics + Phase A short-circuit.**
- `LLM_RESOLVER_DUMP=true` flag writes JSONL of every unified-resolver call (prompt, raw response, anchor_context, activity_type, valid_sectors, resolved tuple). Zero cost when off. This is how future F2 investigations should start.
- `_deterministic_guard_v2` **short-circuit**: when the action description explicitly names a non-home public sector by label (e.g., "walk to Hobbs Cafe"), the pre-LLM guard returns `None` and defers to the LLM path instead of applying the activity-type registry fallback. Before this, the activity-type fallback routed those to the persona's home common room. **Result: Hobbs Cafe misroute rate 27.3% → 0.0% in validation.**

**Apr 14 — Multi-agent distribution + tiebreaker.**
- Address tiebreaker changed from `len(address)` to `len(maze.address_tiles[address])` — prevents longer-name sectors from winning by accident.
- `blocked_tiles` / `unavailable_addresses` threading so multiple agents targeting the same arena get distributed across different objects.

### Where things stand now (the F2 residue)

The classic F2 symptom — "walk to Oak Hill College" resolves to Hobbs Cafe — is **largely fixed** by the Phase A short-circuit. The remaining scope is the narrower case documented in [BACKLOG `LOCATION-F2`](d:\Coding\double-docs\BACKLOG.md) and seen in sim `20260415-5`:

> **Anchor inheritance from parent task to child sub-task.** When task decomposition splits a parent entry like `"gathering at Hobbs Cafe for voting"` into sub-tasks like `"review voting options"`, `"gather materials for voting"`, `"discuss voting strategy"`, the unified resolver drops the parent cafe context for some sub-tasks **and** routes others to the cafe even when they shouldn't. In Katya's case at step 315, `"finalize designs for Christmas presents"` (unrelated to the gather) resolved to `Hobbs Cafe:cafe:behind the cafe counter` because the parent survival-gather context bled through.

Two proposed fix directions, both on the backlog:

1. **Prompt-level ANCHOR-PRIMARY tightening** (recommended path in `BACKLOG.md`). Add few-shot examples to `action_location_unified_v1.txt` that explicitly decouple sub-activity anchors from parent context. Requires prompt-verify gating.
2. **Task-decomp short-circuit for gather entries** (from `20260415-5` report §3.1 recommendations). Extend `_inject_voting_gather_override` to prevent fragmentation of gather directives into sub-tasks in the first place. Heavier but closes the entire window.

### Key files Nicolas should open first

- `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt` — the prompt
- `reverie/backend_server/persona/cognitive_modules/location_resolver.py` — `_deterministic_guard_v2`, `_resolve_anchor_to_address`, `_pick_best_object_address`, `_repair_resolved_action_address`, the diagnostic dumper
- `reverie/backend_server/persona/cognitive_modules/plan.py` — `_build_filtered_location_tree`, `_validate_and_correct_anchor`, `_extract_in_place_location_hint`
- `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` — `run_gpt_prompt_action_location_unified`, `_build_location_tree_for_prompt`
- Past diagnostic artifacts: `past-sims-reports/20260413-1/20260413-1_report.md` §5.4 (F1/F2 classification), `past-sims-reports/20260415-5/20260415-5_report.md` §3.1 (F2 status today)

### Implementation-notes reading order (for full context)

1. `d:\Coding\double-docs\realism\3.llm-realism.md` — the unified resolver collapse (Phase 3), sleep guard, post-integration fixes (4A–D).
2. `d:\Coding\double-docs\realism\5.0.spatial_grounding_reconstruction_strategy.md` — contract-first architecture rationale.
3. `d:\Coding\double-docs\realism\5.1.spatial_grounding_update_2026-03-27.md` — what shipped in Phase 5.1.
4. `d:\Coding\double-docs\realism\6.llm+contract.md` — **critical** RCA that justified the LLM-first + contract-persistence decision. Has the side-by-side comparison of both approaches.
5. `d:\Coding\double-docs\realism\20260414-f1-waypoint-freeze-fix-proposals.md` — latest thinking on F1 (adjacent to F2, worth context).

The short version for Nicolas: **the system is now LLM-first with contract persistence, hard validation gates, diagnostic dumps, a deterministic guard for explicit-sector intents, and real-address few-shots.** The F2 residue is specifically about *anchor inheritance through decomposition*, and the recommended next step is a prompt-level fix to `action_location_unified_v1.txt` guarded by `prompt-verify`.


## **Current manifistation of the issue**

`F2-location issue`: See report at D:\Coding\double-docs\past-sims-reports\20260413-1\20260413-1_report.md


## **Nicolas-20260417: Latest fix attempt**

Approach:
Extended maze_registry.json with activity_whitelist (per arena) and affordances (per object) so the deterministic guard can reject incompatible action↔location pairs. Also added work_area on personas and staff_only on objects so Luba can work at the cafe while others can't go behind the counter.

Validation:
Tested on a 50-step sim. Katya's “finalize gifts” now goes to her dorm desk (not the cafe), and all post challenge actions resolve correctly.

Pending:
work_area needs a Supabase column. There’s a temporary workaround in code, but the migration SQL is ready in BACKLOG.md (DB MIGRATION 001) and just needs someone with DB access to run it.

Also flagged:
Movement regression in BACKLOG (MOVEMENT 001). Noticed in 20260416-1-surv-stage1 and 20260416-2-surv-stage2. Actions expire mid travel, causing agents to change direction before arriving. Our branch includes a travel aware timer (act_arrival_step) that handles this, worth checking if it's active on your side


### Update

F2 fix is ready on my side, but I’m not able to validate it cleanly yet. Behavior has shifted quite a bit from the last baseline, so the signal isn’t reliable.
I’ll pull it off main for now and wait for the Stage 2 report. Happy to rebase and re validate once we have a clean baseline to work from. Let me know when it’s ready.

### *Assessment*

  Pattern A — Anchor bleed through decomposition (Katya's "finalize gifts" → cafe-adjacent objects)
  - Root cause lives in task decomposition: parent gather entry's location is written into child sub-tasks' Planned place, then the resolver faithfully honours it.
  - Nicolas's activity_whitelist is a post-resolution reject layer — it catches the wrong answer after the LLM produces it, but the decomposition is still feeding
  poisoned anchors into the prompt.
  - BACKLOG LOCATION-F2 names two canonical fixes: (1) prompt-level ANCHOR-PRIMARY tightening in action_location_unified_v1.txt, or (2) extend
  _inject_voting_gather_override to short-circuit decomposition. Nicolas's fix is neither.
  - <Verdict: band-aid>. Works in his 50-step sim because rejection happens to land on the right alternative; brittle once activity types diversify.

  Pattern B — Staff-only violation (Katya behind cafe counter, step 61)
  - This is a genuine missing domain model: the map had no concept of role-restricted objects.
  - staff_only on objects + work_area on personas is the canonical representation. Once that data exists, any resolver — current or future — can respect it.
  - *Verdict: proper architectural fix*, not a band-aid. Worth merging in principle (modulo the Supabase migration he flagged).

  Pattern C — Explicit anchor IGNORED (Luba says "go to cafe", resolver routes to library)
  - Resolver prompt bug: the LLM is dropping a stated anchor, not picking an incompatible one.
  - A whitelist filter wouldn't fire here — "library" passes any reasonable activity gate for Luba's action.
  - <Verdict: not addressed at all>. Needs prompt-level work in action_location_unified_v1.txt.


## **Post F2 updates**

### *LOCATION-WHITELIST-SOFT-001*
# =========================
Failed implementation attempt on `ivan/location-whitelist-soft-001` branch
MVP: ship as-is
Post-MVP: Implement `sot\sot_sim.md`
# =========================
  <Context>                     

The location resolver currently treats activity_whitelist on arenas as a hard reject: if the activity_type the LLM produced isn't on the arena's whitelist, the arena is dropped from candidates and/or the post-resolution validator remaps the address through a 4-tier fallback cascade. This was tightened as part of the F2 misroute fix (just shipped to main on `nicolas/f2-misroute-fixes`).
     
That hardness is now the load-bearing cause of two problems:

     1. Emergent scenes get blocked. Luba can't teach a neighbour to bake at the café; nobody can "study over coffee"; trivia-night scenes at the dorm common room are rejected. These are   
     the kind of moments the system exists to produce.
     2. The registry doesn't scale. Every new map / activity / persona role requires a whitelist update, and the Chunk B Hobbs Cafe incident (whitelist silently expanded to cook/play,      
     contradicting its own test) is early evidence the approach doesn't compose.

     The soft-score path keeps a genuine world property (staff-only, privacy) as hard gates but demotes activity-fit to a scorer input — a bias, not a veto. This is also step 1 of the      
     north-star LLM-first resolver direction (RESOLVER-LLM-FIRST-001).

     Outcome: activity-whitelist becomes a tie-breaker in arena scoring. staff_only, privacy, and bed-like affordance mismatches stay hard. A small trace flag gives RESOLVER-TIER-B-001 a   
     signal to consume later, but this PR does not introduce Tier B escalation itself.

     ---
*User decisions locked in*

     - Bias strength: Light (~8% weight) — whitelist is a tie-breaker, not a preference.
     - Tier B hook: Emit a low_whitelist_match trace flag; do not consume it this PR.
     - Anchor-first GUARD route: Soften whitelist check here too, so architecture is consistent.
     - Object staff_only (cooking area, kitchen sink): Deferred to OBJECT-STAFF-001. No registry edits in this PR.

     ---
*Scope*

In-scope — code changes

     All in reverie/backend_server/persona/cognitive_modules/location_resolver.py:

     1. Add _whitelist_score component to _score_arena (line 1410).
       - Signature: _whitelist_score(arena_addr, activity_type, maze) -> float returning 1.0 (whitelisted), 0.7 (arena has no whitelist = neutral), 0.0 (whitelist miss).
       - Extend W tuple: (0.35, 0.25, 0.20, 0.10, 0.10) → (0.32, 0.23, 0.19, 0.09, 0.09, 0.08). Sum stays 1.0; distance + anchor retain dominance; whitelist is strictly a tie-breaker. ≈1   
     tile of distance or ¼ of a good anchor match.
       - Extend the SCORING_LOG print to include whitelist=....
     2. Remove hard whitelist reject in _pick_nearest_accessible_arena (lines 1455–1470).
       - Drop the filter; keep privacy + gender + sector-accessibility filters.
       - Candidate survives to scoring, where the new _whitelist_score component demotes misses.
     3. Soften _validate_address_post_resolution (lines 744–751).
       - Remove the hard-reject branch that currently routes whitelist misses into _remap_for_forbidden_address (Tier 1–4 cascade).
       - Preserve hard rejects for staff_only (line 730) and bed-like-on-non-sleep (line 737), and the affordance repick (lines 753–772).
       - When the caller passes an address whose arena has a whitelist miss and the persona isn't a worker-bypass: return the address unchanged, but emit a single diagnostic line 🟡        
     whitelist-soft miss (parity with the existing 🔄 forbidden-cascade logs).
     4. Soften _try_anchor_first_route whitelist check (lines 1610–1618).
       - Keep privacy + gender gates hard. Drop the whitelist check entirely here — anchor-first is a strong signal by design; if the LLM's anchor resolves to an arena, trust it and let the
      scorer's soft bias influence other paths.
       - Workers' work_area bypass already covered by the upstream logic; this removal doesn't break Luba.
     5. Emit low_whitelist_match trace flag.
       - In resolve_location, after the final address is chosen (step 4b-2 area, line ~2037), check the arena's whitelist. If the persona isn't a worker on that arena AND the activity_type 
     isn't in the whitelist (and the arena has a whitelist at all), set trace["low_whitelist_match"] = True.
       - No code reads this flag yet — it's a schema hook for RESOLVER-TIER-B-001.
     6. Leave _remap_for_forbidden_address Tier 2 (line 668) untouched.
       - It's a positive whitelist search ("which arenas list this activity?"), not a reject. Still a useful targeted lookup when staff_only / bed-like forces a remap. Changing it is out of
      scope.

*In-scope — tests*

     All in tests/. Use the existing Hobbs Cafe + Dorm fixture pattern from test_f2_affordance_guard.py and test_anchor_first_guard.py.

     Failing-first test (bug-workflow rule): Update test_whitelist_rejects_incompatible_activity in tests/test_f2_affordance_guard.py. Rename to
     test_whitelist_softly_demotes_incompatible_activity. Assert the arena is not filtered out and, when another whitelisted arena is equidistant, ranks lower — instead of asserting it's   
     dropped.

     New tests added to tests/test_f2_affordance_guard.py:
     - test_whitelist_soft_bias_prefers_whitelisted_when_tied — two equi-distant arenas, one on whitelist, one off. Whitelisted wins.
     - test_whitelist_soft_bias_loses_to_stronger_anchor_or_distance — non-whitelisted arena with a much better anchor match wins. Proves soft, not hard.
     - test_whitelist_miss_still_resolvable_when_only_option — single arena, whitelist miss, resolver returns it (not None). This is the scene-emergence case.
     - test_whitelist_miss_sets_low_whitelist_match_trace — trace flag is set when resolver settles on a non-whitelisted arena.
     - test_post_validator_whitelist_miss_no_longer_remaps — _validate_address_post_resolution returns the input address with reason_code="" (not "whitelist") on whitelist-only violation.  
     - test_anchor_first_route_whitelist_miss_returns_address — anchor-resolved address survives whitelist miss (non-worker persona).

     Preservation tests (must still pass):
     - test_non_worker_skips_staff_only_object — staff_only unchanged.
     - test_luba_work_at_cafe_routes_to_cafe_not_closet — worker bypass unchanged.
     - All privacy tests in test_location_resolver.py.
     - test_bed_on_non_sleep_remaps (if present; confirm by grep) — bed-like still hard.

     Out-of-scope (deferred)

     - OBJECT-STAFF-001 (cooking area / kitchen sink inheritance). Will be exposed by this PR; that's intentional per user decision.
     - Tier B consumption of low_whitelist_match. RESOLVER-TIER-B-001 owns this.
     - Any change to maze_registry.json.
     - Retiring activity_whitelist. That's the RESOLVER-LLM-FIRST-001 endgame.

     ---
     Critical files

     - Modify: reverie/backend_server/persona/cognitive_modules/location_resolver.py
       - _score_arena (line 1410) — add component
       - _pick_nearest_accessible_arena (lines 1455–1470) — drop hard filter
       - _validate_address_post_resolution (lines 744–751) — drop whitelist branch, keep diag
       - _try_anchor_first_route (lines 1610–1618) — drop whitelist check
       - resolve_location (line ~2037) — emit trace flag
     - Modify tests: tests/test_f2_affordance_guard.py (rename + add)
     - Read-only references: tests/test_anchor_first_guard.py, tests/test_work_area.py, tests/test_location_resolver.py,
     environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json

     Functions to reuse (no need to create anything new):
     - maze.get_arena_activity_whitelist(arena_addr) — registry accessor already used at three sites
     - _worker_bypass_applies semantics (via work_area.startswith(arena_addr)) — already used at lines 747, 1612
     - Existing _score_arena weight-tuple pattern and SCORING_LOG print

     ---
     Verification

     1. Unit tests: python tests/test_f2_affordance_guard.py && python tests/test_anchor_first_guard.py && python tests/test_work_area.py && python tests/test_location_resolver.py — all    
     green, with the 6 new/renamed tests passing.
     2. Registry regression guard: python tests/test_maze_registry_mvp_fields.py — confirms schema accessors intact.
     3. /verify skill — runs full behaviour-affecting verification per CLAUDE.md.
     4. Short sim smoke test (optional, post-merge after the 1500-step sim on main finishes): Fork a baseline sim, run 60 steps, confirm no Luba regressions (still routes to cafe counter   
     for work), confirm at least one non-whitelisted route lands without Tier-1 cascade firing for whitelist reasons (grep 🟡 whitelist-soft miss in stdout).

#### *Implementation results*

● All implementation, tests, verification, and worklog are done. Here's the plain-language summary:

  What changed. Activity whitelists (e.g. Hobbs Cafe's eat, social, serve, relax) no longer block agents outright — they now nudge the location scorer by about 8%. A student can study over 
  coffee; Luba can teach a neighbour to bake at the cafe. staff_only, private bedrooms, and bed-on-non-sleep still block hard. When an agent ends up in a place its activity wasn't
  whitelisted for, a small telemetry flag (low_whitelist_match) is stamped on the resolution trace so the next backlog item (Tier B escalation) can read it later.

  Verified.
  - tests/test_f2_affordance_guard.py — 19/19 pass (rename + 10 new tests for soft scoring, post-validator no-op, and the miss-detection helper).
  - tests/test_anchor_first_guard.py — 4/4 pass (inverted the one test that asserted whitelist rejection at the anchor route).
  - tests/test_work_area.py — 10/10 pass (worker bypass still works, staff_only still hard gates).
  - tests/test_location_resolver.py — 100/101 pass; the one failure (test_deterministic_trace_fields elapsed-ms flake) pre-exists on main and is unrelated.
  - tests/test_maze_registry_mvp_fields.py — 17/17 pass.
  - tests/test_movement_realism.py (per /verify backend cognition path) — 2/2 pass.

  Skipped. Frontend (not this repo), prompt-verify (no prompts changed), API gateway / storage / env-flag categories (not touched).

  Follow-ups for you.
  - Running /simplify flagged three code-quality fixes I applied: reusing parse_address/format_address in the new helper, dropping a defensive hasattr guard, and gating the two new
  soft-miss logs behind SCORING_LOG to avoid stdout spam on long sims.
  - The code is ready to commit, but I haven't staged or committed — say the word when you want it.
  - Smoke test on a 60-step fork (after the 1500-step sim on main finishes) is still recommended before merging to main.

### *P3: Inherit `staff_only` from arena to activity-specific objects (OBJECT-STAFF-001)*

#### *Context*

     LOCATION-WHITELIST-SOFT-001 just shipped (commit 73bd809b): activity_whitelist is now a soft scorer bias rather than a hard reject. That opens a specific exposure: if a non-staff persona's action has activity_type=cook and the LLM anchor lands on a commercial kitchen object, nothing stops them from walking behind the counter. The counter itself (behind the cafe counter, behind the bar counter) is already flagged staff_only: true in the registry — but the neighbouring kitchen objects (cooking area, kitchen sink, refrigerator) aren't. That's the gap this task closes.

     Two map arenas carry this gap: Hobbs Cafe:cafe and The Rose and Crown Pub:pub. Each has 3 unflagged kitchen objects. 6 objects total.

     Outcome: non-staff personas can no longer resolve to a commercial kitchen object. Soft-whitelist emergence is preserved — a student doing cook at the cafe lands at cafe customer seating (a plausible "pretending to prep" or "sharing a recipe" scene) rather than being bounced out to the dorm kitchen.

     ---
*User decisions locked in*

     - Approach: Option A — flag the 6 kitchen objects directly in maze_registry.json. Zero-code data edit. Defer the arena-level staff_only_activity_types schema field (Option B) until the
      gap compounds across more maps.
     - Emergence: On a staff_only hit in the post-validator, try an in-arena non-staff object repick before the 4-tier cascade. This preserves the arena for soft-whitelist emergent scenes. 
     - Drift guard: Two registry-fidelity tests (one per arena) asserting each of the 6 kitchen objects carries staff_only=true. Mirrors the existing test_behind_cafe_counter_is_staff_only 
     pattern. Catches Chunk-B-style silent unflagging.

     ---
#### *Scope*

     1. Registry edit — environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json

     Add "staff_only": true to these 6 object entries:

     - Hobbs Cafe:cafe:cooking area — interaction cook
     - Hobbs Cafe:cafe:kitchen sink — interaction cook
     - Hobbs Cafe:cafe:refrigerator — interaction cook
     - The Rose and Crown Pub:pub:cooking area — interaction cook
     - The Rose and Crown Pub:pub:kitchen sink — interaction cook
     - The Rose and Crown Pub:pub:refrigerator — interaction cook

     No other registry keys change. Worker bypass already works for these — Luba's work_area = the Ville:Hobbs Cafe:cafe makes arena_addr.startswith(work_area) == True, so the existing     
     enforcement allows staff through.

     2. Code tweak — reverie/backend_server/persona/cognitive_modules/location_resolver.py

     Modify _validate_address_post_resolution (currently lines 709–777) so the staff_only branch tries an in-arena repick before cascading out:

     # 1. staff_only on object → try in-arena repick first, then cascade
     if obj and not is_worker and bool(maze.get_object_staff_only(address)):
         alt = _repick_non_staff_object_in_arena(
             persona, maze, world, sector, arena, activity_type, act_desp,
             excluded_obj=obj,
         )
         if alt:
             return alt, "staff_only_inarena"
         remapped = _remap_for_forbidden_address(...)
         return (remapped or address), "staff_only"

     New helper _repick_non_staff_object_in_arena (~15 lines):

     - Read the arena's object list via persona.s_mem.get_str_accessible_arena_game_objects(arena_addr).
     - Delegate to existing _pick_object_for_interaction (already skips staff_only for non-workers) with the blocked object excluded.
     - Return format_address(world, sector, arena, picked) or None if the picker returns no viable alternative.

     Also add "staff_only_inarena" to the reason_code vocabulary in the docstring and the LocationTrace.post_validated comment (line 1222).

     No changes to _remap_for_forbidden_address (its 4-tier cascade stays untouched — only the entry path through the post-validator shifts).

     3. Tests

     Registry-fidelity (new, in tests/test_work_area.py alongside existing test_behind_cafe_counter_is_staff_only):

     - test_hobbs_cafe_kitchen_objects_are_staff_only — loads the real maze_registry.json, asserts cooking area, kitchen sink, refrigerator each have staff_only=True under Hobbs Cafe:cafe. 
     - test_rose_and_crown_kitchen_objects_are_staff_only — same assertion pattern for The Rose and Crown Pub:pub.

     Behaviour (new, in tests/test_f2_affordance_guard.py or a new tests/test_staff_only_inarena_repick.py):

     - test_staff_only_hit_repicks_within_arena — non-worker persona, activity=cook, initial address Hobbs Cafe:cafe:cooking area. Post-validator must return an address still inside Hobbs  
     Cafe:cafe (e.g. cafe customer seating), reason code staff_only_inarena. Proves the student isn't bounced to the dorm kitchen.
     - test_staff_only_worker_bypass_unchanged — worker persona (Luba) with work_area=Hobbs Cafe:cafe, address Hobbs Cafe:cafe:cooking area. Post-validator returns the input unchanged,     
     empty reason code. Proves staff still reach the kitchen.
     - test_staff_only_falls_back_to_cascade_when_no_alternative — minimal fixture with a single staff_only object in the arena and no alternatives. Repick returns None; cascade fires;     
     reason code "staff_only". Proves the existing 4-tier cascade still works when in-arena repick can't help.

#### *Preservation (must still pass):*

     - test_non_worker_skips_staff_only_object in test_work_area.py
     - test_post_validator_staff_only_still_hard_rejects in test_f2_affordance_guard.py
     - test_luba_work_at_cafe_routes_to_cafe_not_closet in test_anchor_first_guard.py

#### *Out of scope*

     - Arena-level staff_only_activity_types field (Option B) — deferred until the gap shows up on more than 2 arenas or a new map.
     - Classroom podium / teacher-role objects at Oak Hill College — not in the stated backlog scope, and not a risk under current activity vocab.
     - Any change to object affordances or interaction lists.

     ---
#### *Critical files*

     - Modify data: environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json (6 staff_only flags added).
     - Modify code: reverie/backend_server/persona/cognitive_modules/location_resolver.py (new _repick_non_staff_object_in_arena helper; modified _validate_address_post_resolution step 1;  
     docstring/trace-comment touch-up).
     - Modify tests: tests/test_work_area.py (add 2 fidelity tests), tests/test_f2_affordance_guard.py (add 3 behaviour tests).
     - Read-only: reverie/backend_server/maze.py (get_object_staff_only at line 1077 — unchanged).

     Functions to reuse (no new abstractions):

     - _pick_object_for_interaction (line 1290) — already honours staff_only + worker bypass; delegate to it with excluded_obj passed through its existing skip mechanism.
     - format_address / parse_address — the standard address plumbing.
     - Existing test fixtures: _Persona, _Scratch, _ArenaMaze in test_f2_affordance_guard.py; MockMaze in test_work_area.py.

     ---
#### *Verification*

     1. python tests/test_work_area.py — 10 existing + 2 new fidelity tests green.
     2. python tests/test_f2_affordance_guard.py — 19 existing + 3 new behaviour tests green.
     3. python tests/test_anchor_first_guard.py — Luba worker bypass preserved.
     4. python tests/test_maze_registry_mvp_fields.py — schema accessors still green after the 6 staff_only flips.
     5. /verify (backend cognition category → python tests/test_movement_realism.py).
     6. /simplify.
     7. Short sim smoke test (optional, post-merge): fork a baseline sim, run 60 steps with a non-staff persona whose plan includes a cook anchor near Hobbs Cafe — confirm no route lands on
      cooking area for non-workers, but the cafe arena is still used.

#### Implementation summary

  What shipped (2 local commits, not yet pushed):

  1. 73bd809b — LOCATION-WHITELIST-SOFT-001: activity whitelists no longer block agents; they nudge the scorer by ~8%. Students can study over coffee; Luba can     
  teach a neighbour to bake at the cafe.
  2. f2fae966 — OBJECT-STAFF-001: the six commercial kitchen objects (cooking area, kitchen sink, refrigerator × 2 arenas) are now staff-only. When a non-staff     
  persona's LLM anchor lands on one, the post-validator first tries to find them a non-staff spot in the same arena before bouncing them out — so a student's "cook 
  at the cafe" intent becomes a customer-table scene, not a teleport to the dorm kitchen.

  Verified.
  - test_f2_affordance_guard.py — 22/22 (3 new behaviour tests for in-arena repick + worker bypass + cascade fallback).
  - test_work_area.py — 12/12 (2 new registry-fidelity tests for Hobbs Cafe + Rose & Crown kitchen flags).
  - test_anchor_first_guard.py — 4/4 (worker bypass still routes Luba correctly).
  - test_location_resolver.py — 100/101 (one pre-existing timing flake, same as yesterday, not ours).
  - test_maze_registry_mvp_fields.py — 17/17 (schema accessors intact).


### *P3: Tier B escalation policy for location resolver (RESOLVER-TIER-B-001)*

#### Context

 LOCATION-WHITELIST-SOFT-001 (shipped) softened activity whitelists into a scorer bias. OBJECT-STAFF-001 (shipped) closed the commercial-kitchen gap with in-arena  
 repick. Both mean the resolver now sometimes lands on a spot it previously would have rejected — which is exactly the intent (emergent scenes), but it also means  
 the fast model (gpt-5-nano) gets asked to make subtler judgement calls than before.

 One specific failure mode is independently visible in logs: the LLM's task decomposition sometimes produces an anchor that doesn't exist anywhere on the map       
 ("visit the gazebo" when the Ville has no gazebo). The fast model, given a filtered location tree that never contains the anchor, tends to fall back to something  
 plausible-but-arbitrary — often the persona's home arena. We can detect this pre-resolution (the anchor token doesn't appear anywhere in the filtered tree) and    
 pay for a smarter model on just those cases.

 Outcome: when an action references a place that doesn't exist in the filtered tree, re-run just the LLM "where" step on Tier B (gpt-5-mini). If Tier B returns a   
 clean result (no post-validator flag, no whitelist miss) and Tier A did not, switch to Tier B. Otherwise keep Tier A. Cost is bounded: at most one Tier B call per 
  resolve_location. The trace.low_whitelist_match flag we already stamp stays a passive telemetry hook — not consumed in this PR.

 ---
#### User decisions locked in

 - Trigger: T2 only — novel anchor (anchor tokens don't appear anywhere in the filtered location tree). T1 (whitelist miss) stays passive telemetry. T3 (survival   
 window) deferred — the metabolic state doesn't exist yet. T4 (prior sub-task misroute) deferred — would need new cross-step scratch state.
 - Scope of re-run: Just the LLM "where" step on Tier B, then re-validate. Deterministic guard and typed scorer stay untouched.
 - Reconciliation: Prefer Tier B's result only if it is strictly better — Tier B has no post_validated reason and no low_whitelist_match, while Tier A did.
 Otherwise keep Tier A. Escalation never regresses.
 - Cost gate: One Tier B escalation per resolve_location call, enforced by a local guard. No cross-step scratch counter (no recursion, so no drift risk).

 ---
#### Scope

 1. Novel-anchor detection — new helper

 In reverie/backend_server/persona/cognitive_modules/location_resolver.py:

 _anchor_tokens already exists in location_resolver.py (line ~245) and handles stopword stripping. No new regex or tokeniser.

 2. Tier B escalation step — new branch in resolve_location

 Added after step 4b-2 (post-validator) and 4c (whitelist flag), before step 4d (compat gate). Shape:

 3. Tier B LLM-step wrapper — new helper

 _rerun_resolver_on_tier_b calls the existing prompt-template entry point with gpt_param["routing_candidate_tier"] = "B" to force Tier B via the existing router    
 (model_router.route_request already honours this key — no router changes needed). The helper then runs _validate_address_post_resolution on the result and returns 
  (address, post_reason).

 The gpt_param_overrides parameter is a new optional kwarg on run_gpt_prompt_action_location_unified that merges into gpt_param before routing. Small surface-area  
 change in run_gpt_prompt.py.

 4. Strictly-better reconciliation — new helper


 5. LocationTrace — new fields

 Added to the dataclass (line 1194 area):

 tier_b_attempted: bool = False
 tier_b_reason: str = ""          # "novel_anchor" | "" (future: more triggers)
 tier_b_accepted: bool = False
 tier_b_address: str = ""         # Tier B's address whether accepted or not

 These feed the existing JSONL resolver dump (_dump_llm_resolver_call) and the one-line 📍 LOCATION monitoring log for telemetry without any new sink.

 6. Prompt template

 No changes. Tier B uses the same v1/action_location_unified_v1.txt as Tier A. Model swap only. If evidence later shows gpt-5-mini needs a reasoning-prompt
 variant, that's a follow-up.

 7. Tests

 All in tests/test_location_resolver.py (or a new tests/test_tier_b_escalation.py if the existing file is crowded):

 Unit — novel-anchor detection:
 - test_anchor_novel_when_no_tokens_in_tree — anchor "gazebo" vs tree with no "gazebo" substring → True.
 - test_anchor_not_novel_when_substring_hits — anchor "cafe counter" vs tree containing "Hobbs Cafe" → False (cafe token hits).
 - test_anchor_not_novel_when_empty — empty anchor → False.
 - test_anchor_not_novel_when_only_stopwords — anchor "the a at" → False.

 Unit — strictly-better reconciliation:
 - test_tier_b_wins_when_cleans_up_dirty_a — A has post_validated="staff_only_inarena", B clean → True.
 - test_tier_b_loses_when_both_clean — both clean → False (don't switch, save cost).
 - test_tier_b_loses_when_b_dirty — B has post_validated, A clean → False.
 - test_tier_b_loses_when_b_has_whitelist_miss — A clean, B whitelist miss → False.

 Integration — full resolve_location with mocked LLM:
 - test_novel_anchor_triggers_tier_b_call — anchor "gazebo", mocked LLM returns Tier A and Tier B addresses; assert Tier B was called exactly once (mock call_count 
  == 2 for the unified fn, with Tier B's gpt_param_overrides flag).
 - test_known_anchor_skips_tier_b — anchor "cafe counter", mocked LLM returns Tier A only; assert Tier B was NOT called (mock call_count == 1).
 - test_tier_b_escalation_switches_when_strictly_better — Tier A returns a whitelist-miss address, Tier B returns a clean address; final trace has
 tier_b_accepted=True, final address is Tier B's.
 - test_tier_b_escalation_keeps_tier_a_when_not_better — Tier A returns clean, Tier B returns whitelist-miss; final address is Tier A's, tier_b_accepted=False.     
 - test_tier_b_budget_one_per_resolve — novel anchor case; confirm tier_b_attempted prevents a second escalation inside the same resolve.

 Mock pattern: patch persona.cognitive_modules.location_resolver.run_gpt_prompt_action_location_unified with a side_effect returning different tuples for the two   
 calls based on gpt_param_overrides presence.

 Preservation:
 - All test_location_resolver.py existing tests still pass (they don't pass novel anchors so Tier B won't fire).
 - test_f2_affordance_guard.py (22 tests) and test_anchor_first_guard.py (4 tests) unchanged — they don't exercise the full resolve_location LLM path.

 Out of scope

 - T1 (whitelist-miss trigger), T3 (survival window), T4 (prior misroute).
 - Per-persona / per-step escalation budgets. The per-resolve guard is enough for this PR.
 - Tier B prompt variant with reasoning instructions.
 - Telemetry aggregation / misroute-rate dashboards (flag lives on trace; consumption is a follow-up).
 - Any change to Tier A's prompt, model, or routing defaults.

 ---
 Critical files

 - Modify: reverie/backend_server/persona/cognitive_modules/location_resolver.py (new _is_anchor_novel, _rerun_resolver_on_tier_b, _tier_b_strictly_better; new     
 branch in resolve_location; 4 new LocationTrace fields).
 - Modify: reverie/backend_server/persona/prompt_template/run_gpt_prompt.py — run_gpt_prompt_action_location_unified gains one optional kwarg gpt_param_overrides   
 that merges into the existing gpt_param dict before routing. Backwards-compatible — every existing caller passes nothing.
 - Modify tests: tests/test_location_resolver.py or new tests/test_tier_b_escalation.py (≤12 new tests total).
 - Read-only references: reverie/backend_server/persona/prompt_template/model_router.py (confirm routing_candidate_tier already lives in TIER_B routing contract —  
 it does, per exploration).

 Functions / utilities reused (no new abstractions):

 - _anchor_tokens (line ~245) — tokenisation with stopword filtering.
 - _build_filtered_location_tree — already returns tree_str; the resolver usually has it in prebuilt_data.
 - _validate_address_post_resolution — re-use as-is for Tier B validation.
 - _is_whitelist_miss — re-use as-is in _tier_b_strictly_better.
 - format_address / parse_address — existing plumbing.
 - model_router.route_request — already honours gpt_params["routing_candidate_tier"]="B".

 ---
 Verification

 1. Unit tests: python tests/test_location_resolver.py — existing 100 + new Tier-B tests green. Timing-flake test still fails (pre-existing, unrelated).
 2. Behaviour regression: python tests/test_f2_affordance_guard.py and tests/test_anchor_first_guard.py and tests/test_work_area.py — all green.
 3. /verify skill: backend cognition path → movement realism 2/2.
 4. /simplify skill: reuse + quality + efficiency review.
 5. /prompt-verify skill: required since run_gpt_prompt.py changes — the kwarg addition is schema-compatible but the raw + cleanup contracts must re-verify clean.  
 6. Cost smoke test (optional, post-merge): fork a baseline sim, run 60 steps with one known novel-anchor scenario; confirm exactly one Tier B call fires per       
 trigger and no unbounded recursion; grep 🎯 TIER-B ACCEPTED to verify switch fires when expected.

#### Implementation results

● RESOLVER-TIER-B-001 shipped locally. Commit bd9bc059 on ivan/location-whitelist-soft-001.                                                                         
                                                                                                                                                                    
  What shipped. When an action mentions a place that doesn't exist on the map (the classic "visit the gazebo" when no gazebo exists), the resolver now asks           gpt-5-mini (the smarter, ~5x more expensive model) for a second opinion on just the "where?" question. It only swaps to the smarter model's answer if that answer 
  is strictly cleaner than the cheap model's — no post-validator flag, no whitelist miss. If both are clean, we keep the cheap one. If the smarter one is also        dirty, we keep the cheap one. Safe by construction.                                                                                                               
                                                                                                                                                                      Bounded cost. Trivial anchors (empty, "home", "local_anchor") short-circuit before any extra work. At most one Tier B call per resolution. Typical sims where       anchors are mundane pay zero extra cost.                                                                                                                                                                                                                                                                                                Verified.                                                                                                                                                           - tests/test_tier_b_escalation.py — 15/15 (6 novelty unit tests, 5 reconciliation unit tests, 4 integration tests with mocked Tier A/Tier B LLMs).                  - tests/test_location_resolver.py — 100/101 (same pre-existing timing flake; not ours).                                                                           
  - tests/test_f2_affordance_guard.py / test_anchor_first_guard.py / test_work_area.py / test_maze_registry_mvp_fields.py — all green.
  - tests/test_movement_realism.py (via /verify) — 2/2.
  - /simplify flagged two items, both fixed: the tree build is now lazy (short-circuits on trivial anchors) and one redundant backlog-ID comment was trimmed.       
  - /prompt-verify: prompt template + cleanup contract unchanged, only routing override added. sot_prompts.md doesn't catalogue this function so no SOT edit needed.

  Follow-ups for you.
  - Three local unpushed commits on this branch: 73bd809b (whitelist soft), f2fae966 (object-staff), bd9bc059 (tier-B). Ready to push/PR when the 1500-step
  main-branch sim is done.
  - Live probe with the real OpenAI API was skipped to avoid competing with the running sim's budget — worth doing once the sim finishes, grepping logs for 🔎      
  TIER-B TRIGGER (novel_anchor) and 🎯 TIER-B ACCEPTED to observe real novel-anchor rates and Tier B acceptance rates.
  - The low_whitelist_match trace flag we already set is still a passive hook. If escalation rates look too narrow (Tier B rarely fires because truly novel anchors 
  are rare), adding T1 as a second trigger is a follow-up.

### *P4-1: Pure LLM-first resolver — Stanford-style (RESOLVER-LLM-FIRST-001) - phase 1*

#### *Context*

     │ Three commits on this branch have already softened the location resolver: whitelist became a scorer weight (73bd809b), commercial kitchens got staff-only   │
     │ inheritance plus in-arena repick (f2fae966), and Tier B escalates on novel anchors (bd9bc059). This plan completes the Stanford-paper direction in three    │
     │ separate PRs, each shippable on its own, each with a git-revert rollback.                                                                                   │
     │                                                                                                                                                             │
     │ What this does in plain terms. Today the system decides where an agent goes by running deterministic rules first ("if 'sleep' is in the text, go to your    │
     │ bed"), a scorer second, an AI third, and then patches the AI's answer with more rules. This plan flips the order: the AI decides, with richer context, and  │
     │ deterministic rules only enforce genuine world properties (staff-only, privacy, accessibility). Emergent scenes — studying over coffee, trivia night in the │
     │  common room, napping on the couch — become reachable.                                                                                                      │
     │                                                                                                                                                             │
     │ Why three phases. Each phase is independently meaningful and independently revertable:                                                                      │
     │                                                                                                                                                             │
     │ - Phase 1 adds capability (richer prompt + observability) without retiring anything. Low risk. Produces the data we'll use to judge phases 2 and 3.         │
     │ - Phase 2 retires the smallest piece (the activity_whitelist field and its 0.08 scorer weight — already nearly a no-op). Exercises the retirement mechanism │
     │  on a safe change.                                                                                                                                          │
     │ - Phase 3 retires the real architectural weight: deterministic keyword guard, activity-type inference, compat-gate keywords, bed-like remap. This is the    │
     │ one where scene behaviour visibly shifts.                                                                                                                   │
     │                                                                                                                                                             │
     │ Each phase can stay in main for a week before the next starts; if anything looks wrong in a sim, revert that phase and pause.                               │
     │                                                                                                                                                             │
     │ ---                                                                                                                                                         │
     │ Phase 1 — Context enrichment + observability                                                                                                                │
     │                                                                                                                                                             │
     │ Goal. Give the resolver more signal and give us more visibility, without retiring anything. Deterministic guards, whitelist scorer, compat gate all still   │
     │ run.                                                                                                                                                        │
     │                                                                                                                                                             │
     │ What changes                                                                                                                                                │
     │                                                                                                                                                             │
     │ 1. New enriched prompt template. reverie/backend_server/persona/prompt_template/v2/action_location_unified_v2.txt. Same pipe-delimited SECTOR | ARENA |     │
     │ OBJECT output contract as v1. Four new INPUT slots:                                                                                                         │
     │   - Current chatting partner (from scratch.chatting_with).                                                                                                  │
     │   - Survival mode + overlay (from scratch.survival.mode, scratch.survival.identity_overlay).                                                                │
     │   - Parent-task label + anchor (needs plumbing, see 2 below).                                                                                               │
     │   - Schedule window ±1 hour (reuse _serialize_schedule_window(persona) which plan.py already computes).                                                     │
     │ 2. New prompt function. run_gpt_prompt_action_location_unified_v2 in run_gpt_prompt.py. Co-exists with v1. Resolver flips to calling v2.                    │
     │ 3. Parent-task plumbing. In plan.py, after task decomposition succeeds, store the parent label on scratch.current_action_contract (contract already carries │
     │  anchor; label is a new field). Resolver reads it for the v2 prompt.                                                                                        │
     │ 4. New LocationTrace fields.                                                                                                                                │
     │   - misroute_category: str — one of "clean", "post_validate_remap", "cascade_fallback", "tier_b_accepted", "error". Stamped once at end of resolve.         │
     │   - context_enrichment_used: bool — True when v2 ran (always True after this phase; kept for A/B post-mortem).                                              │
     │ 5. Telemetry sink. Extend the existing _emit_monitoring + LLM_RESOLVER_DUMP JSONL (no new env flag). One line per resolve with the new trace fields.        │
     │ 6. Analyzer. tests/analyze_resolver_telemetry.py <sim_code> reads the JSONL and prints daily weirdness rate, top-10 offending arena/activity pairs,         │
     │ per-persona outcome histogram, Tier B acceptance rate.                                                                                                      │
     │                                                                                                                                                             │
     │ Files touched                                                                                                                                               │
     │                                                                                                                                                             │
     │ - Create: persona/prompt_template/v2/action_location_unified_v2.txt, tests/analyze_resolver_telemetry.py, tests/test_resolver_v2_prompt.py,                 │
     │ tests/test_resolver_telemetry.py.                                                                                                                           │
     │ - Modify: persona/prompt_template/run_gpt_prompt.py (new v2 fn), persona/cognitive_modules/location_resolver.py (stamp misroute_category, route to v2),     │
     │ persona/cognitive_modules/plan.py (store parent label), persona/memory_structures/scratch.py (new contract field).                                          │
     │ - Doc: worklog entry.                                                                                                                                       │
     │                                                                                                                                                             │
     │ Verification                                                                                                                                                │
     │                                                                                                                                                             │
     │ Unit + integration tests green. /verify, /simplify, /prompt-verify (v2 is a new entry in the prompt catalog — its raw + cleanup contracts need              │
     │ verification). 100-step sim smoke with LLM_RESOLVER_DUMP=true; analyzer produces sensible output.                                                           │
     │                                                                                                                                                             │
     │ Gate before Phase 2                                                                                                                                         │
     │                                                                                                                                                             │
     │ One full day of sim (~1,440 steps) with Phase 1 live, analyzer run on the sim, baseline weirdness rate recorded. No new regressions in existing test        │
     │ suites.                                                                                                                                                     │

#### IMplementation summary

● Phase 1 shipped locally. Commit f7f75819 on ivan/location-whitelist-soft-001.                                                                                     

  What agents now see. When the resolver hits its LLM step, the prompt gets four extra pieces of context: what bigger task this sub-action belongs to, who the agent   is currently talking to, whether they're in a scenario-stress mode, and what their schedule looks like ±1 hour. Same output shape, just a smarter decider.
                                                                                                                                                                    
  What you now see. Every location resolution writes a one-line record to the existing dump file (when LLM_RESOLVER_DUMP=true) tagged with one of clean,            
  post_validate_remap, cascade_fallback, tier_b_accepted, error. The new tests/analyze_resolver_telemetry.py <sim_code> reads that file and prints daily weirdness    rate, top-10 offending arena/activity pairs, per-persona outcome histogram, Tier B acceptance rate. This is the foundation Phase 2 and Phase 3 will use to judge    retirements.                                                                                                                                                                                                                                                                                                                            Nothing retired yet. Deterministic guard, whitelist scorer, compat keyword rules — all still running exactly as before. Phase 2 removes the whitelist; Phase 3      removes the guard.                                                                                                                                                                                                                                                                                                                      Verified.                                                                                                                                                           - tests/test_resolver_v2_prompt.py — 16/16.                                                                                                                       
  - tests/test_resolver_telemetry.py — 7/7.
  - tests/test_location_resolver.py — 100/101 (same pre-existing timing flake).
  - tests/test_tier_b_escalation.py, test_f2_affordance_guard.py, test_anchor_first_guard.py, test_work_area.py — all green.
  - tests/test_movement_realism.py (via /verify backend cognition path) — 2/2.
  - /simplify flagged two items, both fixed: consolidated three dump helpers through a new _append_resolver_jsonl and tightened the schedule-window docstring.      
  - /prompt-verify: v2's raw/cleanup contracts are identical to v1's; no live OpenAI probe run (didn't want to spend tokens against the main-branch sim budget).    

  Gate to Phase 2 per the plan. One full day of sim with Phase 1 live so the analyzer can print a baseline weirdness rate. When you're ready, I'll spin up a fork or
   you can point me at an existing sim to run the analyzer against.

  Follow-ups.
  - Four local unpushed commits on this branch now (73bd809b, f2fae966, bd9bc059, f7f75819). Ready to push/PR when the main-branch sim finishes and you're good to  
  go.
  - Phase 2 is a ~150-line PR (delete the whitelist scorer + Tier-2 remap + ~53 JSON edits) when you give the word.

# ================ <TEST FOR 800 STEPS TO COMPARE WITH PREVIOUS RUN> ================

### *P4-2: Pure LLM-first resolver — Stanford-style (RESOLVER-LLM-FIRST-001) - Phase 2 — Retire activity_whitelist*

     │ Goal. Remove the whitelist field and its scorer weight. Lowest-risk retirement because the whitelist has been soft since 73bd809b (weight 0.08) — this      │
     │ phase makes that softness a hard zero.                                                                                                                      │
     │                                                                                                                                                             │
     │ What changes                                                                                                                                                │
     │                                                                                                                                                             │
     │ 1. Delete from the resolver:                                                                                                                                │
     │   - _whitelist_score function.                                                                                                                              │
     │   - Whitelist component from _score_arena's weight tuple. Rebalance remaining 5 weights to sum to 1.0.                                                      │
     │   - _is_whitelist_miss helper.                                                                                                                              │
     │   - LocationTrace.low_whitelist_match field.                                                                                                                │
     │   - Tier 2 of _remap_for_forbidden_address (the activity_whitelist-driven arena search — no data to operate on once the field is gone).                     │
     │   - All whitelist-miss logging lines in _validate_address_post_resolution and _try_anchor_first_route.                                                      │
     │ 2. Delete from the registry: activity_whitelist field from every arena in environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json (~53  │
     │ arenas).                                                                                                                                                    │
     │ 3. Retire tests: rewrite or delete any test asserting whitelist hard-or-soft behaviour.                                                                     │
     │                                                                                                                                                             │
     │ Files touched                                                                                                                                               │
     │                                                                                                                                                             │
     │ - Modify: persona/cognitive_modules/location_resolver.py, environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json,                      │
     │ tests/test_f2_affordance_guard.py (rewrite whitelist assertions), tests/test_tier_b_escalation.py (remove low_whitelist_match assertions).                  │
     │ - Doc: worklog entry. Note in D:\Coding\double-docs\sot\sot_realism.md that activity_whitelist is retired.                                                  │
     │                                                                                                                                                             │
     │ Verification                                                                                                                                                │
     │                                                                                                                                                             │
     │ All affected test suites green. /verify, /simplify. Analyzer (from Phase 1) run on a 100-step sim shows weirdness rate within ±2 percentage points of the   │
     │ Phase 1 baseline. If it jumps, investigate before merging.                                                                                                  │
     │                                                                                                                                                             │
     │ Gate before Phase 3                                                                                                                                         │
     │                                                                                                                                                             │
     │ One week of Phase 2 on main with daily analyzer checks. Weirdness rate stable. No arena/activity pair shows >10% misroute rate.                             │

### *P4-3: Pure LLM-first resolver — Stanford-style (RESOLVER-LLM-FIRST-001) - Phase 2 — Retire deterministic guard + keyword rules*

     │ Goal. The real architectural shift. LLM becomes the primary decider; deterministic code handles only world-property gates.                                  │
     │                                                                                                                                                             │
     │ What changes                                                                                                                                                │
     │                                                                                                                                                             │
     │ 1. Delete from the resolver:                                                                                                                                │
     │   - _deterministic_guard_v2 (~108 lines across 6 branches).                                                                                                 │
     │   - _infer_activity_type_from_description (76-keyword map).                                                                                                 │
     │   - _try_anchor_first_route (superseded by the enriched v2 prompt — LLM anchors directly).                                                                  │
     │   - _apply_activity_location_compatibility_gate's keyword rules (hygiene→bathroom, cook→kitchen).                                                           │
     │   - _remap_to_compatible_zone.                                                                                                                              │
     │   - Bed-like-on-non-sleep branch in _validate_address_post_resolution (keyword-based; same retirement criterion).                                           │
     │ 2. Restructure resolve_location step numbering.                                                                                                             │
     │   - Old Step 1 (deterministic guard) → removed.                                                                                                             │
     │   - Old Step 2 (typed scorer) → new Step 1.                                                                                                                 │
     │   - Old Step 3 (LLM) → new Step 2 (always runs if typed scorer didn't catch).                                                                               │
     │   - Step 4 sub-steps (privacy, repair, post-validate, compat-gate-now-no-op, Tier B, privacy re-check, maze validation, fallback cascade) → keep, with      │
     │ compat gate reduced to a no-op placeholder for one release before full removal.                                                                             │
     │ 3. Remove v1 prompt entirely. run_gpt_prompt_action_location_unified (v1) deleted. Only v2 remains. action_location_unified_v1.txt template deleted.        │
     │ 4. What stays — confirmed hard gates:                                                                                                                       │
     │   - staff_only on objects (post-validator branch + in-arena repick).                                                                                        │
     │   - Privacy / access (_validate_privacy, _is_private_sector, _is_private_room).                                                                             │
     │   - Fallback cascade (_fallback_cascade) — must always produce SOME address.                                                                                │
     │   - Maze-tile validation (address in maze.address_tiles).                                                                                                   │
     │   - Park-roaming override (data-driven, not keyword).                                                                                                       │
     │   - Contract / persistence layer.                                                                                                                           │
     │   - Affordance repick in post-validator (token-based preference, not keyword reject).                                                                       │
     │ 5. Retire / rewrite tests:                                                                                                                                  │
     │   - Tests asserting _deterministic_guard_v2 (sleep→bed hardcode, keyword inference) — delete.                                                               │
     │   - Tests asserting compat-gate keyword remap — delete.                                                                                                     │
     │   - Tests asserting bed-like-on-non-sleep — delete.                                                                                                         │
     │   - Preservation tests (staff_only, privacy, Tier B, fallback cascade) — keep.                                                                              │
     │                                                                                                                                                             │
     │ Files touched                                                                                                                                               │
     │                                                                                                                                                             │
     │ - Modify: persona/cognitive_modules/location_resolver.py (big deletion), persona/prompt_template/run_gpt_prompt.py (delete v1 fn).                          │
     │ - Delete: persona/prompt_template/v1/action_location_unified_v1.txt.                                                                                        │
     │ - Create: D:\Coding\double-docs\resolver_llm_first_arch.md — the architecture doc + troubleshooting runbook.                                                │
     │ - Doc: Update D:\Coding\double-docs\sot\sot_realism.md (rewrite resolver section for the new architecture), D:\Coding\double-docs\sot\sot_prompts.md        │
     │ (remove v1, keep v2). Worklog entry.                                                                                                                        │
     │ - Tests: delete retired tests, add coverage for new step numbering.                                                                                         │
     │                                                                                                                                                             │
     │ Verification                                                                                                                                                │
     │                                                                                                                                                             │
     │ All test suites green. /verify (backend cognition path — run both test_movement_realism.py AND reverie/backend_server/tests/agent_behavior_tests.py since   │
     │ the deletion touches enough of the planning path to warrant it). /simplify. /prompt-verify — no contract change since v2 was already verified in Phase 1.   │
     │                                                                                                                                                             │
     │ Sim smoke: fork a baseline, 500 steps with Phase 3 live. Expect weirdness rate <10% (backlog target is <3%; we tune down in follow-ups). Sample 20 random   │
     │ scenes qualitatively — if any look truly wrong (rather than plausibly emergent), tune the v2 prompt before merging.                                         │
     │                                                                                                                                                             │
     │ Gate before merge                                                                                                                                           │
     │                                                                                                                                                             │
     │ Ivan reads the new arch doc end-to-end. If he can't picture how he'd diagnose a hypothetical misroute from the doc + analyzer, the doc gets more detail     │
     │ first.                                                                                                                                                      │
     │                                                                                                                                                             │
     │ ---                                                                                                                                                         │
     │ What stays forever (after Phase 3)                                                                                                                          │
     │                                                                                                                                                             │
     │ - staff_only (hard gate).                                                                                                                                   │
     │ - Privacy / access gates.                                                                                                                                   │
     │ - Fallback cascade + maze-tile validation.                                                                                                                  │
     │ - Affordance repick (soft, token-based — not a keyword rule).                                                                                               │
     │ - In-arena staff_only repick (shipped in f2fae966).                                                                                                         │
     │ - Tier B escalation on novel anchor (shipped in bd9bc059).                                                                                                  │
     │ - The LLM-first v2 prompt itself.                                                                                                                           │
     │                                                                                                                                                             │
     │ ---                                                                                                                                                         │
     │ Rollback posture                                                                                                                                            │
     │                                                                                                                                                             │
     │ Every phase reverts cleanly with git revert. No feature flags. Rollback decisions informed by the analyzer added in Phase 1.                                │
     │                                                                                                                                                             │
     │ Estimated sizing                                                                                                                                            │
     │                                                                                                                                                             │
     │ - Phase 1: ~400 LOC added (v2 prompt fn, analyzer, 2 test files, enrichment plumbing). Medium PR.                                                           │
     │ - Phase 2: ~100 LOC removed, ~50 JSON edits. Small PR.                                                                                                      │
     │ - Phase 3: ~1,000 LOC removed, ~200 lines of doc added, ~150 LOC of tests rewritten. Largest PR, but most of it is deletion.                                │
     │                                                                                                                                                             │
     │ Net over three phases: smaller code surface, richer observability, Stanford-style resolver.                                                                 │
