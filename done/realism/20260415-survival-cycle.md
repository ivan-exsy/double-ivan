# Implementation notes — Survival cycle fixes, 2026-04-15 → 04-16

**Author:** Nicolas
**Repo:** `ivan-exsy/generative_agents`
**Branch history:** 5 feature branches off `main`, each fast-forward merged back.
**Validation:** `past-sims-reports/20260415-5/20260415-5_report.md` (700-step sim, fork from `base_family_sim`).
**Related backlog:** `SURVIVAL-002` (resolved), `SURVIVAL-003` (partially fixed), `LOCATION-F2` (unchanged).

Purpose of this document: give a code-review-friendly walkthrough of the six commits shipped during this cycle, with root cause, design decisions, alternatives considered, and what was intentionally left untouched. For behavioral evidence see the sim report above; for brief status see `WORKLOG.md`; for open-issue context see `BACKLOG.md`.

---

## 0. Summary

Six commits, five logical fixes (Phase 8 is two commits that build on each other). All on `main`. No rollbacks. Unit tests added for every fix. Regression sweep (stationary/spatial-grounding/stasis) stable against main baseline — no new failures.

| # | Commit | Fix | Files | LOC (net) |
|---|---|---|---|---|
| 1 | `f336d21f` | Phase 8 capacity-aware redistribute | `reverie.py` | +37 |
| 2 | `25969a65` | Variante A++ round-robin tile assignment | `reverie.py` | +8 |
| 3 | `303efdb1` | Address tiebreaker by tile count | `location_resolver.py` | +1 / −1 |
| 4 | `f1b8f43c` | Gathering-location hints in schedule | `plan.py` | +20 |
| 5 | `a2856338` | `vote_history` records non-voters (SURVIVAL-002) | `controller.py`, `voting.py` | +16 |
| 6 | `e1d5fbf6` | Voting-window gather override (SURVIVAL-003, partial) | `plan.py` | +38 |

Total code delta: ~120 LOC added across 4 backend files, plus 4 new test files (~600 LOC of tests).

---

## 1. Phase 8 capacity-aware redistribute for multi-tile object groups

**Commit:** `f336d21f`
**Branch:** `fix/20260415-phase8-multi-tile-capacity`
**File:** `reverie/backend_server/reverie.py` — `_redistribute_colocated_object_addresses` (around line 7115)
**Test:** `tests/test_phase8_redistribute.py` (4 cases)

### Problem

`_redistribute_colocated_object_addresses` treated every object-level `act_address` as 1-persona capacity. It detected collisions by address-string identity and kicked the second persona to another object via `_pick_best_object_address` for every duplicate. This is wrong for object-groups where a single named address spans many walkable tiles:

| Address | Walkable tiles |
|---|---|
| `cafe customer seating` | 11 |
| `behind the cafe counter` | 4 |
| `cooking area` | 2 |

Symptom: when four personas tried to gather at Hobbs Cafe for the survival voting window, Phase 8 scattered them across the three cafe objects (customer seating, counter, cooking), capping effective cafe capacity at ~3 personas total. The fourth persona either fell through to an unrelated arena or froze. This was the upstream cause of the "only one persona at the cafe at elimination" regression observed in the `20260413-1` baseline.

### Root cause

One of the fix's explicit assumptions is that the FE A* + dynamic occupancy + `execute.py:_find_alternative_object_tile` will handle intra-address tile distribution for co-located personas. That assumption was verified to be *partially* true — the downstream placement does work when each persona has a distinct `zone_anchor`. But plain capacity relaxation is not enough; see commit 2 (Variante A++) for the complementary piece.

### Approach chosen

Add a `claimed: dict[str, int]` counter alongside the existing `assigned: dict[str, str]`. For every object-level address, compute physical capacity as `len(self.maze.address_tiles.get(addr, set()))`. When `capacity >= 2` and `claimed[addr] < capacity`, allow co-location and fall through to the existing downstream placement. Only when claims exceed physical capacity do we enter the existing overflow redistribute branch, which stays byte-identical.

The `is_bed_like_address` fast-path runs ahead of the capacity gate — beds stay 1-per-persona by design. Single-tile object addresses (capacity < 2) fall through to the unchanged collision branch, so singular objects like desks and pianos behave exactly as before.

### Alternatives considered

- **Option 2 — Leave Phase 8 alone, fix in execute.py settle check.** `_resolve_in_zone_in_place_position` does not consult dynamic occupancy when deciding `_should_settle`. Two personas arriving at the same tile both return settled. Fixing the settle check would be architecturally correct but has much wider blast radius — touches the core persona runtime loop and can create oscillation (A settles → B sees occupied → B searches alternative → A's position invalidates B's check, etc). Rejected.
- **Option 3 — Refactor address resolution to be persona-aware at plan time.** Would eliminate the collision entirely but requires changing how parallel `plan()` shares state. Too invasive for this cycle.

### Constraints preserved

- `is_bed_like_address` fast-path untouched.
- `apply_absence_penalty`, `tally_votes`, voting math untouched.
- The overflow redistribute branch (lines `7119+`) stays byte-identical.
- `pad=0` for object-level zones unchanged (updated comment explains why).

### Tests

`tests/test_phase8_redistribute.py` — 4 cases:

1. `test_four_personas_share_cafe_seating_no_redistribute` — 4 personas at 11-tile address, all retain the address, zero `_pick_best_object_address` calls.
2. `test_overflow_beyond_capacity_triggers_redistribute` — 5 personas at 3-tile address, first 3 keep it, last 2 redistribute.
3. `test_single_tile_object_still_redistributes` — 2 personas at 1-tile address, existing collision logic still fires.
4. `test_bed_like_fast_path_untouched` — bed addresses skip the capacity gate entirely.

---

## 2. Variante A++ round-robin tile assignment

**Commit:** `25969a65`
**Branch:** same as commit 1
**File:** `reverie/backend_server/reverie.py` — inside the co-location branch added in commit 1
**Test:** extended `tests/test_phase8_redistribute.py`

### Problem

The capacity gate in commit 1 allowed multi-persona co-location at object-group addresses but did not assign per-persona `zone_anchor`s. At temperature=0 all co-located personas received the same `zone_anchor` from parallel `plan()`, causing them to converge on the same physical tile even though the address had many available tiles. Verified empirically in the intermediate sim `20260415-3`: Luba and Katya both settled at tile `(78, 19)` for 17+ consecutive steps because `execute.py`'s settle check (`is_ready_to_settle_in_zone`) does not consult dynamic obstacles.

### Root cause

Phase 8 writes `scratch.act_address` for co-located personas but `zone_anchor` comes from the parallel `plan()` that already ran and is deterministic at temperature=0. Without intervention, every co-located persona inherits the same anchor.

### Approach chosen

In the co-location branch (`capacity >= 2 and claimed[addr] < capacity`), compute `sorted(self.maze.address_tiles[addr])` and assign each persona the tile at their claimed index. Updates `scratch.zone_anchor` directly before incrementing `claimed[addr]`. Downstream `path_finder` routes each persona to a separate physical location within the shared address.

### Alternatives considered

- **Modify `execute.py` settle check to consult dynamic occupancy.** Correct architecturally but much wider blast radius (risk of oscillation, runtime complexity). Rejected for this cycle; may revisit later if other settle bugs surface.
- **Use `hash(persona.name + addr)` for tile assignment** instead of round-robin by claim index. Would be persona-deterministic but coarser — no guarantee of collision-free assignments for small addresses. Round-robin is strictly better when `num_personas <= capacity`.

### Constraints preserved

- No change to Phase 8 entry condition or overflow branch.
- Assignment uses the same `address_tiles` source of truth as the capacity gate.
- Sort is deterministic — tiles are `(x, y)` tuples, Python sorts lexicographically, same input yields same output every run.

### Tests

Extended the test cases from commit 1 to assert per-persona distinct `zone_anchor` tiles in round-robin order. The four-persona cafe case now verifies four distinct `(x, y)` tuples across the four scratches.

---

## 3. Address tiebreaker by tile count

**Commit:** `303efdb1`
**Branch:** `fix/20260415-address-tiebreaker-tile-count`
**File:** `reverie/backend_server/persona/cognitive_modules/location_resolver.py:335` (and a second call site in the same file)
**Test:** `tests/test_address_tiebreaker.py` (4 cases)

### Problem

When candidate addresses tie on `(matched_tokens, score)`, the third sort key was `len(address)` — the number of characters in the address string. For the four Pistsov personas in Hobbs Cafe, this made every persona deterministically converge on `behind the cafe counter` (49 chars) over `cafe customer seating` (48 chars) — a 1-character difference with no semantic meaning. Phase 8 downstream would then re-spread them, but the resolver was biased toward the smallest-capacity object by accident.

### Root cause

The sort key was chosen without semantic intent. String length is not a proxy for how appropriate an object is for a given activity.

### Approach chosen

Replace `len(item[2])` with `len(maze.address_tiles.get(item[2], set()))` — the physical tile count of each candidate. Larger objects (communal / public) win ties over smaller objects (specialized). The change is a single line in two call sites (both sort the same candidates list); `maze` is already in scope at both call sites, no new parameters needed.

### Alternatives considered

- **Persona-specific hash tiebreaker** (`hash(persona.name + addr)`) — would distribute personas across ties but doesn't match semantic intent. The user correctly pointed out that tile count is a better proxy for "which object would a group of people naturally pick."
- **Action-aware scoring deeper in `_candidate_address_score`** — bigger surface, postponed.

### Constraints preserved

- `_candidate_address_score` untouched.
- Sort order (descending) and primary/secondary keys (`matched_tokens`, `score`) unchanged.
- Only affects ties — candidates with genuinely different scores still win by score.

### Tests

`tests/test_address_tiebreaker.py` — 4 cases verifying that tied candidates are sorted by `len(address_tiles)` descending, both sort sites agree, ties with single-tile objects still work, and the change composes with Phase 8.

---

## 4. Gathering-location hints in schedule

**Commit:** `f1b8f43c`
**Branch:** `fix/gosha-gathering-location-hint`
**File:** `reverie/backend_server/persona/cognitive_modules/plan.py` — new `_inject_gathering_location_hints` (around line 384), wired in `_long_term_planning` after schedule filter, before cache write
**Test:** `tests/test_gathering_location_hints.py`

### Problem

When the LLM paraphrases the survival directive into hourly schedule entries, it sometimes separates the travel from the activity, dropping the location. Observed with Gosha's schedule during the investigation: directive text said "Attend challenge at Hobbs Cafe by 10:00" but the generated schedule entry read `"participating in the 'Cooperate or Defect' challenge"` with no mention of Hobbs Cafe. The downstream location resolver saw no location tokens and routed Gosha to `classroom podium` or `common room table` — anywhere but the cafe. Other personas (Luba, Ivan, Katya) retained "at Hobbs Cafe" in their entries and routed correctly.

### Root cause

LLM variance at temperature=0 across personas. The scheduler prompt does not enforce preservation of directive-named locations in schedule entries. Some personas get schedules that retain the location, some don't, depending on how the LLM paraphrases.

### Approach chosen

Post-process the generated schedule in `plan.py` before the cache write. Read `SURVIVAL_GATHERING_LOCATION` from env (`Hobbs Cafe` by default). For each schedule entry, if the entry's description contains a survival keyword (`"cooperate or defect"`, `"the challenge"`, `"voting"`, `"elimination"`, `"gather at"`) but does not mention the gathering location, append `" at {location}"` to the description. This re-injects the dropped location so the downstream resolver can match it.

### Alternatives considered

- **Parse the directive text with regex to extract the location** (`"at (.+?) by"`). Rejected — fragile; breaks if the directive text changes format (e.g. "meet at Hobbs Cafe around 19:00"). Env var is a structured, stable source.
- **Use a broader keyword list** (e.g. just `"challenge"`). Rejected — too many false positives (`"SAT challenge prep"` would match). Multi-word keywords anchored to survival vocabulary are more specific.
- **Modify the scheduler LLM prompt to force location retention.** Larger surface, harder to validate, doesn't help existing sims with cached schedules.

### Constraints preserved

- No change to the directive text or survival controller.
- No regex on LLM output — env var is structured.
- Idempotent: re-running on a schedule that already has the location is a no-op.
- Called before the cache write so the next-day cache hit sees the fixed schedule.

### Tests

`tests/test_gathering_location_hints.py` covers: survival keyword without location → append, keyword with location already present → no-op, non-survival entry → untouched, empty env var → no-op, whitespace env var → no-op, idempotence under re-run.

---

## 5. `vote_history` records non-voters explicitly (SURVIVAL-002)

**Commit:** `a2856338`
**Branch:** `fix/20260415-survival-vote-history-non-voters`
**Files:** `reverie/backend_server/survival/controller.py` — `_collect_vote_decisions`; `reverie/backend_server/survival/voting.py` — `record_vote_to_state`
**Test:** `tests/test_vote_history_non_voters.py` (3 cases)

### Problem

Absent agents (not at the gathering location at the voting step) had `vote_history=[]` in their per-agent JSON file. This was indistinguishable from a persistence failure and lost the reason for the absence. Ivan originally reported it as "only 1 of N votes persisted" — interpreted as a persistence bug.

### Root cause

The original framing of Bug B was a misread. `apply_absence_penalty` (`voting.py:74-77`) correctly skips the vote LLM call for absent agents, and the vote math reconciles via phantom accounting. The actual gap was the audit trail: there was no record on disk explaining *why* a given agent's vote was missing. Auditors had to cross-reference `season_state.phantoms` against per-agent files to reconstruct absences.

### Approach chosen

Two changes:

1. **`controller.py:_collect_vote_decisions`**: in the absent-voter branch, before `continue`, append an explicit non-voter record to the agent's own `vote_history`:
   ```python
   absent_entry = {
       "day": day,
       "voted": False,
       "reason": "absent_from_gathering",
       "phantom_applied": True,
   }
   state.vote_history.append(absent_entry)
   ```
2. **`voting.py:record_vote_to_state`**: add `"voted": True` to the real-vote entry for schema symmetry.

Every agent now has exactly one entry per voting day. Reconciliation `real_votes + phantoms == vote_count` holds from per-agent files alone.

### Alternatives considered

- **Touch only `controller.py`, rely on default `entry.get("voted", True)` for consumers.** Works but leaves asymmetric schema (real entries without flag, non-voter entries with flag). Adding one line to `voting.py` gives schema symmetry with near-zero code cost.
- **Backfill historical JSONs.** Rejected — consumers use the `entry.get("voted", True)` back-compat default, so legacy files continue to work without migration.

### Constraints preserved

- `apply_absence_penalty`, `tally_votes`, vote math all untouched.
- Back-compat: consumers read `entry.get("voted", True)`, so legacy entries without the flag are treated as real votes. Historical files unchanged.
- No schema migration.
- Fail-soft: the append is wrapped in try/except with `logger.debug` on failure; audit trail is informational, not tally-critical.

### Tests

`tests/test_vote_history_non_voters.py` — 3 cases:

1. Absent voter gets non-voter entry (failing-first, fails on `main`).
2. Full cycle with present + absent voters reconciles `vote_count = real + phantoms` using the new queries (failing-first).
3. Legacy entries without `voted` flag still treated as real votes (regression guard, passes pre- and post-fix).

Also updated two downstream consumers to use `entry.get("voted", True)` to filter non-voters where relevant: `tests/analyze_sim_survival.py` and `local_docs/20260415-validation-runner.py`.

### Backlog state

`SURVIVAL-002` marked `~~RESOLVED~~` in `BACKLOG.md`. Note there retains the original "1 of N persisted" framing as history so future readers see the reclassification in context.

---

## 6. Voting-window gather override (SURVIVAL-003, partial)

**Commit:** `e1d5fbf6`
**Branch:** `fix/20260415-survival-gathering-enforcement`
**File:** `reverie/backend_server/persona/cognitive_modules/plan.py` — new `_inject_voting_gather_override` next to `_inject_gathering_location_hints`, wired in `_long_term_planning`
**Test:** `tests/test_survival_gathering_override.py` (10 cases)

### Problem

`sot_survival.md §Spatial Gates` specifies that the voting phase advances when 80% of alive agents are at `SURVIVAL_GATHERING_LOCATION`, with a 4-hour timeout fallback. In every survival sim observed to date the timeout is what fires, because nothing actively drives agents to the gathering location. The directive is LLM-visible text inside `daily_plan_req`; the hourly schedule generator routinely ignores it and produces activities like `"cook main dish"` or `"purchase gift bags"` for the 19:00–21:00 window. Voting then runs with whoever happens to be at the cafe, and `apply_absence_penalty` fills in phantom votes for the rest.

### Root cause

Gap between design and implementation. The spatial gate code is present and correct; the gathering mechanism is textual and the LLM can discard it. The 80% threshold is never reached by natural agent behavior, so the gate never fires on presence.

### Approach chosen

**Option 1 — Schedule injection (same post-processing pattern as commit 4).** Add `_inject_voting_gather_override` that replaces any hourly-schedule entry whose start-of-day minute falls in `[19*60, 21*60)` with `"gathering at {SURVIVAL_GATHERING_LOCATION} for voting"`. Invoked in `_long_term_planning` after `_inject_gathering_location_hints` and before the cache write. Hardcoded window matches `survival/controller.py:410` directive text and `survival/state.py` ELIMINATION phase boundary. `vote_deadline_hour=20` stays inside the window, so the timeout fallback still fires for personas that cannot physically reach the cafe.

### Alternatives considered

- **Option 2 — Controller-side action override.** `SurvivalController` actively overrides each alive persona's action to the gather directive during the voting window. More invasive — touches `controller.py` lifecycle, requires a latch that releases at 21:00, and must coordinate with Phase 8 / schedule cache / action sticky shortcircuits. Semantically cleaner (voting is a survival behavior enforced by survival controller) but much wider blast radius. Rejected for this cycle.
- **Option 3 — Prompt-level fix to the scheduler LLM.** Force the LLM to retain the gather directive in schedule entries during the voting window. Harder to test, harder to validate; doesn't help sims with cached schedules.

### Result (partial fix)

Works for the first 60 minutes of the gather window (19:00–20:00): `20260415-5` sim showed the first-ever 4/4 co-location at `cafe customer seating` (peak at step 600 / 20:33). But retention from peak to elimination (20:00–21:00) still drifts — task decomposition fragments the parent entry into sub-tasks (`"review voting options"`, `"gather materials for voting"`) that the LLM resolver sometimes routes outside the cafe (F2-class). By the elimination step (21:00) only one persona is still present, same as pre-fix. Spatial gate still doesn't trip; timeout still fires.

### What remains

Two candidate follow-ups, both documented in `BACKLOG.md:SURVIVAL-003`:

1. Extend `_inject_voting_gather_override` to short-circuit task decomposition for entries whose text starts with the gather directive.
2. Controller-side action override (Option 2 from above) — rejected this cycle, may revisit.

### Constraints preserved

- No change to `_check_gate`, `apply_absence_penalty`, `tally_votes`, `_collect_vote_decisions`.
- No change to survival directive text or controller lifecycle.
- Idempotent: re-running on an already-overridden schedule is a no-op.
- `vote_deadline_hour=20` timeout still inside the window, so fallback still fires.

### Tests

`tests/test_survival_gathering_override.py` — 10 cases: in-window entry gets replaced, out-of-window entries stay, idempotent re-run, empty/whitespace env var no-op, 16-entry realistic schedule only affects in-window entries, both `f_daily_schedule` and `f_daily_schedule_hourly_org` get treated. Two of the 10 are failing-first; the rest are regression guards.

### Backlog state

`SURVIVAL-003` marked `PARTIALLY FIXED` with next-step options documented. Remains P2 pending the retention follow-up.

---

## Composition

The six commits compose into a single behavioral pipeline that produces the gather scene visible in `20260415-5` (report §5):

1. **Gathering-location hints** keep "Hobbs Cafe" in the schedule text so the resolver can see it → addresses commit 4.
2. **Address tiebreaker** makes `cafe customer seating` (11 tiles) win ties against `behind the cafe counter` (4 tiles) → addresses commit 3.
3. **Phase 8 capacity gate** lets all four personas hold the same address → addresses commit 1.
4. **Round-robin tile assignment** gives each persona a distinct tile inside the shared address → addresses commit 2.
5. **Voting-gather override** keeps the gather schedule active through the voting window → addresses commit 6.
6. **Vote history audit schema** makes the voting outcome auditable from per-agent files → addresses commit 5.

Each fix closes a distinct failure mode that would have blocked the next one. Disabling any of the first four reverts the cafe gather scene to scattered or frozen; disabling commit 5 makes the voting outcome harder to audit; disabling commit 6 keeps the voting window at accidental gather.

---

## Validation

- **Unit tests:** each commit ships its own failing-first test file. All pass after the respective fix.
- **Regression sweep:** `tests/test_stationary_override.py`, `tests/test_spatial_grounding_regressions.py`, `tests/test_spatial_grounding_typed_pipeline.py`, `tests/test_stasis_bugs.py` — 15 pre-existing failures unchanged between `main` pre-cycle and post-cycle. No new failures introduced.
- **Empirical:** `20260415-5` sim (700 steps, `base_family_sim` fork, clean API Gateway run). Full artifacts at `past-sims-reports/20260415-5/`. See report §5 for the realism analysis, §3 for the per-issue mapping to Ivan's original questions.

---

## What was intentionally left untouched

- `apply_absence_penalty` and `tally_votes` — vote math is correct, out of scope.
- `_check_gate` — spatial gate logic is correct; what was missing was reaching the threshold.
- `is_bed_like_address` fast-path — beds remain 1-per-persona.
- `execute.py:_find_alternative_object_tile` and `_resolve_in_zone_in_place_position` — settle check remains unchanged; the architectural fix there was considered and rejected this cycle (see commit 2 alternatives).
- `headless_visualization.py:zone_tiles_to_pixels` coordinate encoder — latent bug identified during investigation (separate from this cycle) but only manifests when the API Gateway is down and headless falls back to local JSON. Left for a dedicated cycle.
- `pad=0` for object-level zones — unchanged (commit 1 updated the comment but kept the invariant).
- Survival directive text in `controller.py` — unchanged; the fix re-injects the location into schedules, not into the directive.
- Scheduler LLM prompt template — unchanged; prompt-level fixes are out of scope.
- Task decomposition prompt (`run_gpt_prompt_task_decomp_contextual`) — unchanged; the F2-class fragmentation of the gather entry during voting retention is tracked as residual in `SURVIVAL-003` and `LOCATION-F2`.

---

## References

- Sim report with behavioral evidence: `past-sims-reports/20260415-5/20260415-5_report.md`
- Status for quick scan: `WORKLOG.md` (2026-04-15 and 2026-04-16 entries)
- Open-issue context: `BACKLOG.md` — `SURVIVAL-002` (resolved), `SURVIVAL-003` (partial), `LOCATION-F2` (unchanged)
- SOT contract: `sot/sot_survival.md` §Spatial Gates, §Voting Contract
