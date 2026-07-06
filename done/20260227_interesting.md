# 2026-02-27 Interesting Sims - Realism Upgrade Scratchpad

## Goal
Make long activities feel alive (busy, purposeful, believable) without introducing fake jitter.

Primary target example: cafe work should naturally rotate through meaningful sub-activities:
- greeting customers
- taking orders
- serving machine/drinks
- bussing tables
- dish area cleanup
- quick counter reset

---

## Decision Update (2026-02-27)

Primary execution path is now:
- **Option 3: Manual role + routine assignment for all sprites** (first).

What changes in this plan:
- Role/routine seeding becomes **Phase 0 (immediate quick win)**.
- Engine changes below (sub-activity state, dual-progress guardrails) remain valuable, but move to **Phase 1/2 optimization** after we validate Phase 0.

Reason:
- Current realism failure is strongly linked to homogeneous seed grounding (same park-centric setup and generic orientation routines), not only movement execution logic.

---

## Current Setup (verified)

### What already works
- Task decomposition exists and is active in planning:
  - `plan.py` decomposes many 30+ minute actions into 5-minute chunks.
  - Decomposition has guardrails: max subtasks, nested skip, rest/activity skip, boundary gate.
- P2 action lifecycle exists:
  - persistence + extension (`P2_ACTION_*`) to avoid over-replanning churn.
  - novelty budget and attention caps to reduce noisy cognitive loops.
- Stall breaker exists in orchestration (`reverie.py`):
  - detects repeated identical stationary emissions.
  - has healthy-persistence bypass for legitimate stationary behavior.
- In-zone freeze fix exists in execution (`execute.py`):
  - non-stationary intent can keep moving in-zone.
  - stationary intent can hold.

### Why realism still degrades
- Decomposition output is mostly text-only and generic; no explicit "activity mode" semantics.
  - We know "what subtask text is", but not whether it should be:
    - in-place,
    - workstation-hop,
    - zone patrol,
    - social micro-interaction.
- P2 extension can keep the same action active without ensuring visible sub-activity progress.
- Healthy-persistence bypass currently uses broad routine keywords.
  - This can protect legitimate stationary tasks, but can also hide stale loops.
- We track repeated movement signatures, but not enough "productive progress" signals for stationary work.

---

## **✅Phase 1 - Structured Sub-Activity State (implemented summary)**

### What was implemented
- Added persistent sub-activity state to scratch so long actions can show visible progress without fake movement.
- Added optional decomposition tags (`[mode=... anchor=...]`) with backward-compatible parsing and fallback inference.
- Added mode-aware execution behaviors (`in_place`, `workstation_hop`, `zone_patrol`, `social_touch`).
- Added park locomotion roaming (sector-level targeting + seeded waypoint chains) to reduce single-point collapse.

### Core files touched
- `reverie/backend_server/persona/memory_structures/scratch.py`
- `reverie/backend_server/persona/cognitive_modules/plan.py`
- `reverie/backend_server/persona/cognitive_modules/execute.py`
- `reverie/backend_server/persona/prompt_template/v2/task_decomp_v3.txt`

### Outcome
- Better in-zone realism: agents remain purposeful while avoiding jitter.
- Park movement is more naturally distributed and still replay-stable.

---

## **✅Phase 2 - Dual-Progress Stall Guardrails (implemented summary)**

### What was implemented
- Reframed stall detection from movement-only to dual-progress:
  - `movement_progress` when movement is expected
  - `task_progress` for sub-activity advancement
- Added conservative escalation ladder:
  1) soft sub-activity nudge, 2) anchor nudge, 3) force replan.
- Updated healthy-persistence checks so stationary behavior is protected only when progress is real.
- Added crowd-aware waypoint scoring (light dispersion) on waypoint transitions to reduce local bunching.

### Core files touched
- `reverie/backend_server/reverie.py`
- `reverie/backend_server/persona/cognitive_modules/plan.py`
- `reverie/backend_server/persona/cognitive_modules/execute.py`

### Outcome
- Fewer frozen loops without harming legitimate desk/in-place work.
- Better watchability and spread, with anti-oscillation behavior intact.


---

## **✅Phase 3 - Role + Routine Assignment Pipeline (implemented summary)**

- Built a 2-step assignment workflow for baseline personas:
  1) suggest careers by Villa location,
  2) assign one career per persona using sex + profile signals.
- Kept this as artifact-driven and reusable for future rosters.

### Core scripts and artifacts
- `scripts/suggest_villa_careers.py`
  - Outputs `test-results/villa_career_suggestions_<timestamp>.json`
  - Includes non-living classification and employment-relevant filtering.
- `scripts/assign_soul15_careers.py`
  - Outputs `soul15_seed_20260224_career_assignment.json`
  - Produces 15/15 persona-career assignments.

### Generated assignment reference
- Artifact: `soul15_seed_20260224_career_assignment.json`
- Coverage: all 15 personas assigned.
- Mix: location-based jobs (cafe/library/pub/classroom/co-living) + remote roles.

## **✅Phase 4 - Scratch Seeding for Work Duties (implementation summary)**

### What was implemented
- Created `scripts/apply_career_assignment.py` to roll out career assignments safely to Supabase tables.
- Regenerated assignments using filtered location data from `villa_career_suggestions_20260301_095209.json`.
- Updated `persona_scratch` (`currently`, `daily_plan_req`) and `persona_profile_snippets` (`decision_heuristics`, `topic_attractors`) via read-modify-write.
- Added gates: location validation, manifest completeness, generic-text rejection, preflight backups, dry-run/apply/audit sequence, and rollback on failure.

### Core files touched
- `scripts/apply_career_assignment.py`
- Supabase tables: `double.persona_scratch`, `double.persona_profile_snippets`
- Artifacts: `soul15_seed_20260224_career_assignment.json`, `test-results/phase4_backups/`

### Outcome
- Full coverage: 15/15 personas updated without generic fallbacks.
- Verified integrity: dry-run, apply, and audit passed; database checks confirmed active snippets.
- Reusable commands for regeneration and application; behavioral validation pending runtime.

## **✅Phase 5 - LLM-First Contextual Sub-Activity Pipeline (implementation summary)**

### What was implemented
- Delivered end-to-end pipeline with production-safe defaults for contextual sub-activity generation.
- Integrated optional contextual decomposition in planning, with schema validation, repair, fallback, and caching.
- Added runtime prompt support, template updates, and observability for decomposition metrics.

### Core files touched
- `reverie/backend_server/persona/cognitive_modules/plan.py`
- `reverie/backend_server/persona/prompt_template/` (new templates)
- `reverie/backend_server/utils/run_gpt_prompt.py`

### Outcome
- Enabled resilient planning with context-aware task breakdown.
- Improved sub-activity progression without disrupting core flow; defaults ensure backward compatibility.

## **✅Phase 6 - Planning Resilience + Navigation Hardening**

### What was implemented
- Added contextual decomposition path in `plan.py` with validation, repair, caching, and fallback.
- Implemented no-path loop protection in `execute.py` with thresholds, forced replans, and fallback targeting.
- Made planning tolerant to missing spatial data; added spawn walkability validation and auto-relocation.
- Switched fork baselines to Supabase-primary; added `persona_scratch` inheritance for forks.
- Enabled passthrough for `stationary_intent` and `realism_trace`; tightened headless batch acceptance.
- Expanded metrics for planning, replans, progress, and traces.

### Core files touched
- `reverie/backend_server/persona/cognitive_modules/plan.py`
- `reverie/backend_server/persona/cognitive_modules/execute.py`
- `reverie/backend_server/reverie.py`
- Supabase migrations for `persona_scratch` forks
- Analysis scripts for new metrics

### Outcome
- Reduced navigation failures and startup issues; improved fork consistency and telemetry.
- Better observability for movement and planning; no regressions in core simulation flow.

## **✅Phase 7 - BE/FE Pathfinding Alignment (implementation summary)**

### What was implemented
- Validated runtime anchor incidents (e.g., Owen at step 9 in `20260305-2`) with FE path failures.
- Added end-to-end BE observability for FE blockage: preserved `blocked_reason`/`blocked_debug` in logs and payloads.
- Fixed spawn/seeding: enforced center-tile starts, walkability checks, neighbor openness, and radius relocation.
- Ran short validation sim for target personas (Owen, Vincent, etc.) in first 10-20 steps.

### Core files touched
- `reverie/backend_server/persona/cognitive_modules/execute.py` (blockage logging)
- Supabase payloads and API responses (debug preservation)
- Spawn logic in simulation startup (relocation validation)

### Outcome
- Confirmed FE A*/BFS failures with diagnostics; no obvious spawn traps.
- Improved alignment: blocked events now explainable; planned-vs-actual divergence captured.

## **✅Phase 8 - Simulation Progress Update (`20260305-4` vs `20260304-5`)**

### What was implemented
- Analyzed 120 steps from Supabase long profile; compared to prior baseline.
- Fixed data coverage artifact in analysis pipeline (pagination for range queries).
- Re-audited chat integrity and movement metrics post-fix.

### Core files touched
- Analysis scripts: `tests/analyze_sim.py` (pagination in `collect_compact_supabase_report`)
- Supabase row audits for steps 26 and 116

### Outcome
- Chat/narrative continuity strong (integrity 1.0, no issues); context carry-forward improved (64→84).
- Movement truth slightly better (low-net-progress 2→1); data gaps eliminated, but embodied quality uneven (jitter/streaks persist).
- Target personas mostly stationary; action expression weak.

## **✅Phase 9 - 2026-03-06: Last Realism Fixes**

### What was implemented
- P0: Repaired measurement layer with Supabase pagination and top-level `stationary_intent` emission.
- P1: Enhanced `in_place` decomposition (2-3 stages); added zone source tagging and `reachability_override`.
- P1.5: Added realism visibility gate in compare mode and backend target-tracing.
- Verified localhost API playback alignment.

### Core files touched
- `reverie/backend_server/reverie.py` (intent emission, pagination)
- `reverie/backend_server/persona/cognitive_modules/plan.py` (decomposition, tagging)
- `tests/analyze_sim.py` (gates, tracing)

### Outcome
- Data truth restored (no synthetic gaps, stationary ratio non-zero); localhost compare clean (0 discrepancies).
- Backend structure improved (overrides 195, subactivity switches 76.2, progressing ratio 0.67); chat integrity 1.0.
- Embodied movement still static for several personas; API visibility lags.

## **✅Phase 10 - Remaining Issues**

### What was implemented
- Analyzed experiment runs (`20260306-5/6`): localhost compare clean, low reroute pressure.
- RCA: Shifted focus to backend planning/execution loop; ruled out tile drift and narrow `in_place` guards.
- Identified operational API issue in `update_persona_coords` upsert (not main blocker).
- Pinned targets in experiment to test authoritative selection.

### Core files touched
- `lib/api.ts` (upsert path review)
- Analysis for frozen personas (Alex, Andrew, etc.)

### Outcome
- Reroute noise low (overrides 6→2); stall rate 0.0; progressing ratio 0.95.
- 10+ personas effectively frozen despite low pressure; hypothesis: false progress or untraced replan clearing.
- Proved issue not in tile drift; prioritize runtime tracing for frozen cases.

## **✅Phase 11 - Ultimate Test (Structured Forensic Capture)**

### What was implemented
- Captured full movement pipeline per persona/step into NDJSON and summary MD.
- Compared backend planning/emission, FE report, and backend acceptance.
- Instrumented stages: emit, report, interpretation; focused on frozen personas (Ivan, Katya).

### Core files touched
- `reverie/backend_server/reverie.py` (pipeline tracing)
- Artifacts: `test-results/<sim>/movement-pipeline.ndjson/md`
- Analysis for steps 0-2 in `20260306-8`

### Outcome
- Proved break in post-emission feedback: backend emits valid moves, FE returns no-op (`blocked=false`), backend accepts without escalation.
- Examples: Ivan/Katya show repeated same-tile paths despite non-stationary emits; Gosha contrasts with real movement.
- Dominant failure: Trusts `blocked=false` too much; needs "no actual move" as failure signal.

## **✅Phase 12 - FE Investigation**

- RCA: FE recomputes paths (ignores backend path); anchors on zone satisfaction or hold intent. Bug: inconsistent zone checks (tile vs pixel); over-relies on `!blocked`.
- Ivan/Katya freezes: FE zone anchor, not backend error. Conditions: speed <0.1, hold/zone anchor, BFS one-tile, occupancy interference.

**Files:** `lib/api.ts`, `AnimationManager.ts`, `hooks/useRealtime.ts`; Artifacts: `double-docs/20260306-8/movement-pipeline.*`
**Outcome:** FE misclassifies intra-zone moves as stay-put; needs explicit no-move reasons.

## **✅Phase 13 - 20260306: FE Practical Implications**

- Added `no_move_reason` and `debug_method` to FE reports; preserved raw `success`.
- Tightened net-change detection; aligned zone checks with headless coords.

**Files:** `AnimationManager.ts`, `hooks/useRealtime.ts`
**Outcome:** Precise RCA enabled for no-op on non-trivial moves. Focus: `no_progress_same_tile` for intra-zone collapses.

## **✅Phase 14 - 2026-03-07: FE RCA Results & Proposed Fixes**

- RCA: FE recomputes to zone center, collapses to stay-put if already inside.
- Explicit no-move reasons (`speed_stationary`, `zone_anchor`, etc.); preserved raw `success`; degraded if non-trivial BE move + same-tile without reason.
- Reports: `success`, `no_move_reason`, `debug_method`; net-change via backend fields.

**Files:** `AnimationManager.ts`, `hooks/useRealtime.ts`, headless execution
**Outcome:** No ambiguous `blocked=false` on no-ops; explicit degraded for Ivan/Katya patterns.

## **✅Phase 15 - 2026-03-08: FE Headless Execute Preserved Backend Intent**

- Stopped synthesizing stationary `path` from missing backend path.
- Preserved `movement`/`planned_pos` as first-class destination data; changed target fallback from `||` to `??` for valid coord `0`.

**Files:** `AnimationManager.ts`, `hooks/useRealtime.ts`, headless pipeline
**Outcome:** FE executes intra-zone intent or degrades explicitly; root cause (BE emit vs FE recompute/anchor mismatch) addressed.

## **✅Phase 16: Streamline BE-FE contract: No path in headless mode**

**Contract:**
- Headless generation: BE sends `start_pos`, `movement`, `planned_pos`, `target_zone`, `speed_multiplier`; **omit `path` entirely** (not even `path=[]`).
- Replay: API returns stored `actual_path`; browser FE replays directly, no A* recomputation.
- `realism_trace` is diagnostics-only; execution intent must survive in top-level fields end-to-end.

**Root cause:** BE still sent `path=[start_pos]`; FE gave `path[-1]` priority for destination → same-tile no-op even with valid `movement`/`planned_pos`. Confirmed in `20260308-4`: Ivan/Katya already had `movement` collapsed to `start_pos` and `planned_pos` missing before FE pathfinding.

**Sub-implementations (all ✅):**
- **16.1** `reverie.py` omits generation-time `path` in `BACKEND_INTENT_ONLY_PATH` mode including step 0; `speed_multiplier=0.0` enforced for step 0 spawn.
- **16.2** `supabase_service.py` reads `movement` from `movement_jsonb.movement` first; surfaces `planned_pos` in single-step and range readers.
- **16.3** `validation.py` preserves `planned_pos`; accepts `speed_multiplier=0.0`; `coordinate_converter.py` converts `planned_pos` to pixels alongside `movement`.
- **16.4** `useRealtime.ts` preserves `movement`/`planned_pos`; `AnimationManager.ts` resolves destination from `planned_pos → movement → x/y`, ignores backend `path`, uses `??` for coord `0`; stationarity from explicit semantics (not `path.length <= 1`); missing intent → `blocked_reason='missing_headless_intent'`.
- **16.5** `reverie.py` tracks repeated non-blocked same-tile feedback; after threshold → `force_replan_next_step` + `noop_replan_guardrail`.
- **16.6** Replay loaders prefer stored `actual_path` over legacy `path`; no A* recomputation on replay.
- **16.7** Step 0 spawn snapshot kept; generation-time `path` removed; API regression test added.

## **✅Phase 17: skipped**

## **✅Phase 18 - 2026-03-09: FE Verification & Final Escalation Fixes**

Verified Phase 16 contract via `20260308-7` and `20260309-7`. Fixed `planned_pos` transport through Supabase/API; FE preferred-target collapse for non-stationary intra-zone moves; BE escalation for blocked same-tile loops; compare analyzer to use replay `actual_path`.

**Files:** `reverie.py`, `supabase_service.py`, `analyze_sim.py`, `AnimationManager.ts`, `lib/api.ts`, `usePlayback.ts`
**Outcome:** 18.1: escalation for blocked repeats + intent clamping. 18.2: `planned_pos` loss + preferred-target collapse fixed; 81 blocked rows explicit. 18.3: compare gate aligned; replay audit closed. Material drop in duplicate stillness.

## **✅Phase 19: Static Activities**

*Ref. sim 20260309-9*

**7-stage BE-FE pipeline status:**
1. ⚠️ Start-anchor continuity healthy; target choice weak (oscillation, low net progress).
2. ✅ Intent packet complete (`start_pos`, `planned_pos`, `movement`, `target_zone`, `speed_multiplier`); no backend `path` leak.
3. ✅ API transport clean (compare mode green on 20260309-9).
4. ⚠️ Same-tile deadlock resolved (`blocked=0`, `no_progress_same_tile=0`); oscillation/low net progress remain.
5. ⚠️ `actual_pos` flows well; `actual_path` handoff not fully proven by replay evidence.
6. ⚠️ End-position overwrite healthy; replay proof of `actual_path` consumption not confirmed.
7. ✅ Next-step planning uses FE-confirmed end position; continuity clean, no duplicate-step plateaus.

**BE Updates for Stationary Realism (sim 20260312-4):**
- `_classify_healthy_persistence()` (~L6227): Protect `in_place + stationary_intent + in-zone` as `stationary_desk_work`.
- `_dual_progress_status()` (~L6174): Credit `task_progress` for stationary actions.
- `local_fallback_stationary_allowed` keywords expanded; added `_recalculate_stationary_on_continuation()` (~L3299).
- `_should_apply_noop_movement_bypass()` (~L6263): Require `stationary_intent`; set `NOOP_MOVEMENT_BYPASS_ENABLED=true`.
- `execute.py` (~L1369): Use `current_pos` from `last_actual_pos` for stationary zone check.
- `reverie.py` (~L4611): Emit `movement = start_position` for `stationary_intent=True + speed<=0`; normalize persona names.

**Results (sim 20260312-4):** `stationary_intent=True` in 111 records; `healthy_reason=stationary_desk_work` in 28; Katya/Gosha 15+ step streaks; `stationary_but_progressing_ratio=0.89`; `stall_forced_replan_rate=0.0`.

*Report on Ivan Pistsov jittery movements: `@test-results/20260312-7/report.md`*

## **✅Phase 20**

### Fix 1: Location-arrival gate (`scratch.py` + `plan.py`)
When timer expires but persona not in target zone: hold up to 10 extra minutes (`ACT_ARRIVAL_GATE_MAX_WAIT_MIN`), then force completion with `arrival_gate_expired=True`. On expiry, planner snaps `curr_tile` to actual position before `_determine_action()`; P2 extension blocked.

### Fix 2: Zone boundary coordinate unification (`AnimationManager.ts`)
Replaced three raw `Math.floor(px / tileWidth)` calls with `pixelToTile(px)` (`Math.floor((px - 16) / 32)`): zone boundary (L3442), `isPositionInZone` (L2321-2322), raw start-tile OOB check (L3510-3511). Eliminates same-position inside/outside zone inconsistency at tile boundaries.

### Fix 3: Break P2 stationary lock-in (`plan.py` + `reverie.py`)
- `_recalculate_stationary_on_continuation()`: Made bidirectional — clears `stationary_intent`/restores `speed_multiplier=1.0` when persona leaves zone or action gains travel keywords.
- `_p2_should_extend_action()`: Schedule-drift check — refuses extension when `get_f_daily_schedule_index()` points to a different action.
- `_classify_healthy_persistence()`: Same drift check — allows stall breaker through when schedule has advanced.


## **✅Phase 21**

**3 failure mechanisms in `20260312-8`** (FE correctly follows backend; BE is the source):

| # | Failure | Stage | Who | Fix |
|---|---------|-------|-----|-----|
| 1 | BE emits movement despite `stationary_intent=true` + in-zone | `movement_emit` | Katya | Check stationary intent before target selection |
| 2 | BE re-samples zone target every step → oscillation | `movement_emit` | Ivan | Pin target for unchanged in-zone action |
| 3 | `schedule_advanced_past_action` detected but never triggers replan | `stall_guardrail` | Luba | Direct `force_replan` path after 5-step grace |

**Fixes (all in `reverie.py`):**
- **Fix 1** (~L4610-4622): Stationary intent checked before `planned_pos`/`movement`; both forced to `start_position` → `stationary_emission=true`, stops `noop_replan_guardrail`.
- **Fix 2** (~L4378-4400): Target pinned when: same action + in zone + `last_planned_pos` in zone → reuse `last_planned_pos`.
- **Fix 3** (~L4844-4862): `schedule_advanced_past_action` for 5 consecutive steps → direct `force_replan_next_step` (previously only affected `healthy_persistence`).

**RCA from sim `20260313-2`:** BE sets `speed_multiplier=0.0` for traveling personas due to `act_address`/`act_description` mismatch + broad bounding-box zone containment + `IN_PLACE_ACTION_KEYWORDS` false positives. Solution: deterministic stationary classifier in `plan.py` using `current_pos`, near-anchor arrival required, address mismatches blocked; emit-time invariant guard in `reverie.py` clears invalid stationary state when `speed_multiplier<=0` conflicts with far movement.


## **Phase 22**

*Sim `20260314-1`, report: `@test-results/20260314-1/report.md`*

**Metrics:** Zone anchoring 98/120 (81.7%); movement 22/120 (18.3%); replay paths broken (`chosen_source=none`, 120/120). 64/98 stationary rows: `selected_tile != movement` (selection picks new in-zone tile, emit collapses to `start_pos`). Actions do evolve (Gosha=4, Ivan=5, Katya=2, Luba=3 transitions).

**Root causes:**
- Primary (`execute.py:1389`): In-zone block returns `ret = curr_tile` even when `stationary_intent=False`. When `curr_tile == closest_target_tile`, micro-move gate runs at 15% probability; 85% → `planned_path = [current_pos]` → `reverie.py` sees `next_tile == start_position` → `planned_pos = start_position`.
- Secondary (`execute.py:1294`): Micro-move probability 15% with cooldown gate.

**Fix (`execute.py`):**
- In-zone variation candidate filter — exclude current tile for long non-stationary in-place actions when alternatives exist.
- Let in-zone non-stationary path consumption bypass strict object-address boundary gating to prevent `consumption=0` same-tile collapse.

## **Phase 23: Structural consolidation**
`git branch local`
*Full RCA: @test-results/20260314-2/report.md*

**RCA:** 7+ independent “hold in place” mechanisms (REST LOCK, NOOP bypass, healthy-persistence keywords, target pinning, keyword tuples, in-zone variation filter, micro-move keywords, location keywords) contradict each other and cause a whack-a-mole cycle. No unified “should move?” decision point. Substring false positives (e.g., “rest” in “restocking”). Target pinning clashes with variation filters.

**4-fix structural refactor:**

### 1. LLM `movement_mode` at planning time (replaces keyword inference)
New `run_gpt_prompt_movement_mode()` — one-token output: `”stationary”` | `”in_zone”` | `”travel_to_zone”`. Called per action change post-resolution. `plan.py:~2905` sets `speed_multiplier`/`stationary_intent` from mode. Structural fallback: positional logic only (in zone → `in_zone`; outside → `travel_to_zone`; no zone → `stationary`). Transitions in `_check_movement_mode_transitions()`: arrival (`travel_to_zone` + in zone → `in_zone`), safety net (`stationary` + valid zone + not in zone → `travel_to_zone`). Legacy mechanisms rewired to `movement_mode` (Phase 23a); keyword paths behind `MOVEMENT_MODE_KEYWORD_FALLBACK=false`.

### 2. Target pinning only for `stationary_intent=True` (`reverie.py:4397`)
Added `stationary_intent` gate: stationary personas pin (no jitter); `in_zone` roamers select new targets per step. Verify `PIN_ONE_TARGET_PER_ACTION=false` in `.env.local`.

### 3. Occupancy penalty in target scoring (`execute.py:226`)
For non-stationary intent: penalize current tile after `OCCUPANCY_PENALTY_MIN_STEPS` (default 2): `penalty = 8.0 + 1.5 × steps`. Tracks `steps_at_current_tile` in scratch. Removed redundant `in_zone_variation_filter` + `IN_ZONE_VARIATION_ENABLED`/`IN_ZONE_VARIATION_MIN_ACTION_MINUTES`.

### 4. Single movement gate reads `movement_mode` (`reverie.py:~L4507`)
REST LOCK/NOOP bypass/healthy persistence rewired to `movement_mode` (Phase 23a). `execute.py` reads `should_move`; if False, in-place exit fires; if True, no downstream code collapses `ret` to `curr_tile`.

**Test results:**
- **A (fixes 2-3, `20260314-phase23.2-3.a`):** zone_anchor 101→35/120 (65% reduction); `actual_path_length > 1`: 19→85/120. Fixes #2/#3 were major root cause; fix #1 still architecturally important.
- **B (REST LOCK word-boundary, `20260314-phase23.rest_lock-a`):** Replaced “rest” substring with word-boundary regex. Composition shift: fewer Luba anchors.
- **C (fixes 1+4, `20260314-phase23-1-4-a`):** 11.2% anchoring (58/520) vs 84.2% baseline and 29.2% prior. `blocked=0`, `no_progress_same_tile=0`. 32 intentional stationary rows; 26 residual (non-stationary in-zone, concentrated in Ivan). Core direction: pass.

**Rollout checklist (all ✅):** `run_gpt_prompt_movement_mode` one-token contract; `sot_prompts.md` updated; positional-only fallback; guardrails rewired (Phase 23a); `has_valid_zone` safety net; `movement_mode` backend-only; NDJSON: `movement_mode_source: “llm”|”fallback”` (plus transition suffixes).

---
## **Phase 24: Streamlined — Clean First, Build Second**
`git branch realism`

### Design principle

Phase 23 proved that LLM-based `movement_mode` is the correct single authority for movement intent. The 8+ legacy mechanisms (REST LOCK, NOOP bypass, healthy persistence keywords, target pinning, keyword tuples, in-zone variation, micro-move keywords, location keywords) were each added to fix a symptom, but together they form a contradictory control layer that causes the whack-a-mole cycle described in Phase 23's RCA.

**Phase 24 inverts the approach**: strip the legacy control layer first, validate that `movement_mode` alone produces acceptable behavior, and only then add new features if metrics demand it.

Sequence:
1. **24a — Legacy mechanism cleanup** (remove contradictions)
2. **24b — Combined location prompt** (fix zone selection — the last confirmed root cause)
3. **24c — Validate** (Naturalness Gate on cleaned system)
4. **24d — Transit/dwell sub-plans** (only if 24c shows intra-zone behavior still needs work)

---

### *24a: Legacy mechanism cleanup*

**Goal**: Replace 8+ independent movement authorities with one decision point. After this step, `movement_mode` from scratch (set by LLM or structural fallback) is the single source of truth. One simple progress guardrail replaces the complex escalation ladder.

#### Mechanisms to disable/remove

| # | Mechanism | Location | Action | Flag / How |
|---|-----------|----------|--------|------------|
| 1 | **REST LOCK** | `reverie.py:4355-4571` | **Disable.** With `movement_mode`, a stationary persona is already protected; a moving persona should not be held by keyword matching. | `REST_STATIONARY_LOCK_ENABLED=false` (already exists) |
| 2 | **NOOP movement bypass** | `reverie.py:3698-3713, 6513-6555` | **Disable.** Skipping movement planning entirely is too aggressive — `movement_mode` already controls whether the persona moves. | `NOOP_MOVEMENT_BYPASS_ENABLED=false` (already exists, already default) |
| 3 | **Keyword tuples** | `plan.py:79-105` (`IN_PLACE_ACTION_KEYWORDS`, `TRAVEL_ACTION_KEYWORDS`) | **Dead code.** Only used in fallback paths. Mark deprecated; remove after validation. | Gate behind `MOVEMENT_MODE_KEYWORD_FALLBACK=false` (new flag, default false) |
| 4 | **`_compute_stationary_state()` keyword block** | `plan.py:610-683` | **Bypass.** `_resolve_action_movement_mode()` already sets `stationary_intent` and `speed_multiplier` from LLM. The keyword block at plan.py:610 only runs when `movement_mode` is absent. With LLM enabled, this is dead path. | Same flag as #3 |
| 5 | **`_recalculate_stationary_on_continuation_legacy()`** | `plan.py:3594-3654` | **Keep as fallback only.** The existing dispatcher (plan.py:3644-3654) already does the right thing: calls `_check_movement_mode_transitions()` first, falls through to legacy only when `movement_mode` is absent. Do NOT remove the call — it is the safety net for LLM timeout/rate-limit edge cases where `movement_mode` is missing on continuation. | No code change needed; dispatcher already correct |
| 6 | **Location keywords bypass** | `plan.py:1582-1617` (`LOCATION_KEYWORDS` dict) | **Remove.** Replaced entirely by 24b (combined location prompt). | Removed with `COMBINED_LOCATION_PROMPT_ENABLED=true` |
| 7 | **Micro-move keyword checks** | `execute.py:1290-1364` | **Simplify.** Keep micro-move/fidget logic but replace `_is_in_place_activity()` / `_is_travel_activity()` keyword checks with `movement_mode` read from scratch. | Direct code change |
| 8 | **`PIN_ONE_TARGET_PER_ACTION`** | `execute.py:56` | **Verify off.** Default is `false`; confirm `.env.local` does not set it `true`. If active, disable — it conflicts with occupancy penalty. | Env check |

#### Mechanisms to simplify

| # | Mechanism | Location | Change |
|---|-----------|----------|--------|
| 9 | **Healthy persistence** | `reverie.py:6463-6511` | **Prefer `movement_mode`, keep keyword fallback.** When `movement_mode` is set: `"stationary"` → healthy, anything else → not healthy. When `movement_mode` is absent (legacy path): keep existing `sleep_like` and `stationary_desk_work` keyword branches as safety net — they protect sleep actions from false replans during LLM fallback. |
| 10 | **Target pinning** | `reverie.py:4405-4434` | **Gate on `movement_mode == "stationary"` only.** Currently pins for any unchanged in-zone action regardless of intent. After change: stationary pins (desk/sleep), in_zone roams freely. Already specified in Phase 23 section 2 — execute it. |
| 11 | **Dual-progress escalation** | `reverie.py:4961-5013, 6370-6423` | **Keep nudge stages, simplify entry condition.** The soft nudge (advances sub-activity) and anchor nudge (refreshes waypoint) provide partial recovery without a full replan — removing them would force unnecessary action changes. Keep the 3-tier ladder (advance → anchor → force replan). Simplify `_dual_progress_status()` to read `movement_mode` instead of re-inferring from keywords when mode is set. |

#### What stays unchanged

- **`movement_mode` LLM** (`run_gpt_prompt.py:1633-1696`, `plan.py:583-607`): Primary authority. No changes.
- **`_check_movement_mode_transitions()`** (`plan.py:3552-3570`): Structural transitions (arrival, safety net). No changes.
- **`_movement_mode_structural_fallback()`** (`plan.py:566-580`): Positional fallback when LLM fails. Keep but simplify — remove keyword references, use pure position logic (in zone → `in_zone`, outside zone → `travel_to_zone`, no zone → `stationary`).
- **Occupancy penalty** (`execute.py:232-257`): Phase 23 addition, working well. No changes.
- **Phase 16 BE-FE contract**: Structural, correct. No changes.
- **Forensic tooling / NDJSON tracing**: Keep all observability.

#### Implementation checklist (24a)

- [x] Set `REST_STATIONARY_LOCK_ENABLED=false` in `.env.local`
- [x] Set `NOOP_MOVEMENT_BYPASS_ENABLED=false` in `.env.local` (verify — should already be default)
- [x] Add `MOVEMENT_MODE_KEYWORD_FALLBACK=false` env var; gate keyword tuple usage behind it in `_compute_stationary_state()` and `_recalculate_stationary_on_continuation_legacy()`
- [x] Verify `_recalculate_stationary_on_continuation()` dispatcher (plan.py:3644) keeps legacy fallback path intact — no code change needed, just confirm
- [x] Update `_classify_healthy_persistence()`: prefer `movement_mode` when set, keep keyword branches as fallback for legacy path
- [x] Gate target pinning block on `stationary_intent` (from `movement_mode`)
- [x] Simplify `_dual_progress_status()` to read `movement_mode` when set; keep 3-tier nudge ladder (advance → anchor → force replan)
- [x] Update micro-move logic to read `movement_mode` instead of keyword functions
- [x] Verify `PIN_ONE_TARGET_PER_ACTION=false` in `.env.local`
- [x] Simplify `_movement_mode_structural_fallback()` to pure positional logic
- [x] NDJSON trace: log which legacy mechanisms were skipped and why

**Risk mitigations verified**:
- Legacy continuation recalculation kept as fallback for LLM timeout/rate-limit edge cases (0% fallback in 520-step test, but edge cases exist)
- Dual-progress nudge stages (advance sub-activity, refresh waypoint) preserved — partial recovery avoids unnecessary full replans
- Healthy persistence keyword branches retained for legacy path — protects sleep actions when `movement_mode` is absent

**Expected outcome**: Fewer contradictions → fewer false freezes and false oscillations → cleaner baseline for measuring whether zone selection or intra-zone behavior need further work.


#### *Test Results @/test-results/20260316-24a-1*

- **24a technical cleanup objective:** PASS
  - legacy mechanisms are disabled/skipped as intended
  - no FE hard-failure regressions (`blocked=0`, `no_progress_same_tile=0`)
- **Behavioral realism vs reference run:** FAIL (regression)
  - zone-anchor and non-stationary no-op rates are materially worse
  - regression is concentrated in `Luba Pistsova`

---

### *24b: Combined location prompt*

**Problem**: The planning pipeline assigns actions to the persona's current zone instead of the semantically correct one. Three cascading LLM calls (`generate_action_sector` → `generate_action_arena` → `generate_action_game_object`) amplify errors forward. A keyword bypass (`LOCATION_KEYWORDS`, `plan.py:1582-1617`) short-circuits the LLM for ~60% of actions with hardcoded mappings that are incomplete and wrong in context. When the composed address fails lookup, `local_fallback` (current tile ±3) traps the persona.

Confirmed in `test-results/20260314-phase23-1-4-a`: Ivan's address stays in the bathroom across 5 action changes. Luba stays in the garden throughout.

**Solution**: One LLM call picks sector+arena from a numbered list of valid locations built from `maze.address_tiles`. Output is a number index — guaranteed to resolve.

**A. Combined location prompt** (replaces `generate_action_sector` + `generate_action_arena`)

New function `run_gpt_prompt_action_location()` in `run_gpt_prompt.py`. Template `v2/action_location_combined_v1.txt`:

```
Task: Choose the best location for this activity.

You are !<INPUT 0>!, currently at "!<INPUT 1>!".
Your next activity is: "!<INPUT 2>!"

Available locations:
!<INPUT 3>!

Pick the NUMBER of the best location for this activity.
Consider: Does the activity need a specific environment? Choose the location that fits naturally.
Stay at current location only if it genuinely suits the activity.

RESPONSE FORMAT: Output ONLY the number. No explanations, no extra text.

Answer:
```

`!<INPUT 3>!` is generated dynamically from `maze.address_tiles`:

```python
def _build_location_list(maze, act_world):
    seen = set()
    locations = []
    for addr in sorted(maze.address_tiles.keys()):
        parts = [p.strip() for p in addr.split(":") if p.strip()]
        if len(parts) < 3 or parts[0] != act_world:
            continue
        sector_arena = f"{parts[1]}: {parts[2]}"
        if sector_arena not in seen:
            seen.add(sector_arena)
            locations.append({"label": sector_arena, "sector": parts[1], "arena": parts[2]})
    return locations
```

Output: integer index. Validate range. On invalid → retry once → fallback to current location.

Net LLM cost: **saves one call** (2 → 1). Output is 1-2 tokens.

**B. Parent-address cascade** (safety net for game object hallucination)

After combined prompt picks a valid sector:arena, `generate_action_game_object` may still hallucinate a name. Before `local_fallback`, try shorter address prefixes:

```python
if not target_zone:
    addr_parts = [p.strip() for p in (new_address or "").split(":") if p.strip()]
    for trim in range(1, min(3, len(addr_parts))):
        parent_addr = ":".join(addr_parts[:-trim])
        if parent_addr and parent_addr in maze.address_tiles:
            zone_tiles = maze.address_tiles[parent_addr]
            xs, ys = [t[0] for t in zone_tiles], [t[1] for t in zone_tiles]
            target_zone = {
                "min_x": max(0, min(xs) - 2), "max_x": min(maze.maze_width, max(xs) + 2),
                "min_y": max(0, min(ys) - 2), "max_y": min(maze.maze_height, max(ys) + 2),
            }
            zone_resolution = "parent_address_fallback"
            break
    if not target_zone:
        target_zone = { ... actual_tile ± 3 ... }
        zone_resolution = "local_fallback"
```

With part A, the sector:arena is always valid. `local_fallback` becomes rare.

**C. Travel-prerequisite insertion** (gated, disabled by default)

When a new action's `target_zone` is valid and persona is outside it, insert an explicit travel action. On arrival, pop `pending_destination_action` and start the real action.

Gated behind `TRAVEL_PREREQUISITE_ENABLED=false`. Enable after A+B are validated.

#### Implementation checklist (24b)

- [x] `run_gpt_prompt_action_location()` with numbered-list prompt
- [x] `_build_location_list()` generates sector:arena list from maze data
- [x] `COMBINED_LOCATION_PROMPT_ENABLED=true` (default); `false` falls back to legacy chain
- [x] `LOCATION_KEYWORDS` bypass removed from primary path (disabled in 24a)
- [x] Parent-address cascade before `local_fallback`
- [x] `zone_resolution` traced in NDJSON
- [x] `TRAVEL_PREREQUISITE_ENABLED=false` env var and insertion logic (disabled by default)
- [x] Update `sot_prompts.md` with new prompt entry

#### *Test Results @/test-results/20260316-24b-1*

- **Technical safety posture:** PASS
  - FE stability remains clean (`blocked=0`, `no_progress_same_tile=0`)
  - no legacy mechanism reactivation observed
- **Behavioral realism vs 24a-1:** FAIL (no net improvement)
  - aggregate zone-anchor and non-stationary no-op rates are slightly worse
  - regression pattern moved from `Luba Pistsova` to `Gosha Pistsov` and `Ivan Pistsov`

Release posture: **NO-GO for 24c gate on this run**.

---

### *24x: upd - Log Collection for Movement Pipeline*

- [x] **Expand `log` mode to capture full BE+FE movement chain**
 - `reverie/backend_server/reverie.py`: Add chain-level movement artifacts (`movement-pipeline-chain.ndjson`, `movement-pipeline-chain-summary.md`) with per-step/persona stage completeness, feedback coverage, capture sequence IDs, and failure-class tagging
 - `reverie/backend_server/headless_visualization.py`: Route FE forensics trace/replay capture through the final deduped report stream submitted to backend (canonical observations, legacy fallback, degraded fallback)
 - `reverie/backend_server/fe-forensics/fe_forensics_helper.py`: Parse movement diagnostics from both top-level and `details` payloads, persist report source, and add step/persona coverage-gap reporting in FE summary

#### *Test Results @/test-results/20260316-24x-1*

- **Technical observability and FE stability:** PASS
  - full step/persona FE coverage (`120/120`)
  - no FE hard-failure regressions (`blocked=0`, `no_progress_same_tile=0`)
  - BE->FE feedback chain present for all step/persona pairs
- **Behavioral realism vs both comparison runs:** FAIL (regression)
  - zone-anchor and non-stationary no-op rates are materially worse
  - movement throughput (`actual_path_length > 1`) is worse
  - regression is concentrated in `Gosha Pistsov` and `Ivan Pistsov`

### *24y: Fixing issues from 24x — Conditional Arrival Transition (Revised)*

RCA: @test-results\20260316-24x-1\RCA.md

**First attempt (24e): Prompt redesign** — remove `travel_to_zone` from LLM vocabulary, ask only for post-arrival behavior.

**Test result (20260317-24y-opus-1): REGRESSION** — 91.7% zone-anchor rate. The new prompt overgeneralized and classified all focused work ("studying robotics and drafting CAD") as `stationary`, even activities that should roam for material access. **Lesson:** Restricting LLM output introduces prompt bias that loses information.

---

**Root cause identified:** The real issue wasn't the LLM vocabulary. It was the **unconditional arrival transition** that always converted `travel_to_zone` → `in_zone` on arrival, losing semantic context.

From 24x test data:
- **56 out of 60** movement chains show `llm:arrival_transition` (56 chains where the mode flipped from LLM's answer to hardcoded `in_zone`)
- "Wake up, stretch, make bed" → LLM says `travel_to_zone` (correct—get to bed first) → code flips to `in_zone` (wrong—should stay put once there)
- "Drawing at a table" → same problem
- "Working at desk" → same problem

**Corrected approach (24e revised):** Keep the original 3-mode prompt and LLM. Fix the arrival transition to be **conditional on existing semantic state** — `subactivity_mode` — which already distinguishes roaming from stationary work.

---

**How subactivity_mode already captures the distinction:**

The function `_infer_subactivity_mode()` maps action descriptions to:
- `in_place`: no keywords → default (desk work, bed, reading, drawing)
- `workstation_hop`: "serve", "clean", "stock", "shelv", etc. → movement between stations
- `zone_patrol`: "walk", "jog", "run", "patrol", "explore" → zone movement
- `social_touch`: "chat", "talk", "greet", "meet" → social movement

**Arrival transition (one conditional check):**

```python
# At both planning-time (line 3178) and continuation-time (line 3749)
if movement_mode == "travel_to_zone" and in_zone:
    if subactivity_mode == "in_place":
        movement_mode = "stationary"  # desk/bed/table work
    else:
        movement_mode = "in_zone"     # roaming activities (serve, patrol, etc.)
```

**Impact on the four failure cases:**

| Persona | Activity | subactivity_mode | Arrival → | Result |
|---|---|---|---|---|
| Ivan | "Wake up, stretch, make bed" | `in_place` | `stationary` | ✅ Dwell at bed |
| Gosha | "studying robotics... drafting CAD" | `in_place` | `stationary` | ✅ Dwell at desk |
| Katya | "drawing and designing cards" | `in_place` | `stationary` | ✅ Dwell at table |
| Luba | "serving coffee to regulars" | `workstation_hop` | `in_zone` | ✅ Roam while serving |

---

**Changes implemented:**

1. **Reverted prompt** to original 3-mode (`stationary`/`in_zone`/`travel_to_zone`)
2. **Reverted LLM function** to accept all 3 modes
3. **Updated both arrival transitions** to check `subactivity_mode` before switching
4. **Removed small-zone threshold** (no longer needed)

**Why this is the correct fix:**

- **Leverages existing state:** `subactivity_mode` is already set during planning; no new state or LLM calls needed
- **No prompt bias:** Keeps full LLM vocabulary; the 3-mode design is architecturally sound
- **One-line gate:** Conditional is cheaper and simpler than redesigning a prompt
- **Verifiable semantics:** Keyword inference has clear rules (e.g., "serve" → `workstation_hop` → `in_zone`)

---

**Key semantics already in the codebase:**

```
Once at "{act_address}", your activity is: "{act_description}"

Will you:
- "stationary": Stay in one spot (sleeping, desk work, reading, making bed, drawing at table)
- "roaming": Move around the area (serving customers, restocking shelves, patrolling, cleaning)

Respond with one word.
```

Then the structural code handles travel automatically (already does this — if persona is outside zone, `_check_movement_mode_transitions` safety-net forces `travel_to_zone`). On arrival, instead of blindly switching to `in_zone`, it uses the LLM's answer.

**This resolves the core failures:**

| Persona | Activity | Current LLM answer | Arrival transition | Correct answer | Result |
|---|---|---|---|---|---|
| Ivan | Wake up, stretch, make bed (at bed) | `travel_to_zone` | `in_zone` (wrong) | `stationary` | Dwell at bed |
| Gosha | Working at desk (1 tile) | `travel_to_zone` | `in_zone` (wrong) | `stationary` | Dwell at desk |
| Katya | Drawing at table | `travel_to_zone` | `in_zone` (wrong) | `stationary` | Dwell at table |
| Luba | Serving coffee (kitchen) | `travel_to_zone` | `in_zone` (wrong) | `roaming` or `stationary` | Depends on LLM judgment |

**Code changes required:**

1. **Prompt change** in `run_gpt_prompt_movement_mode()` — ask for post-arrival behavior, drop `travel_to_zone` from the LLM vocabulary
2. **Arrival transition** in `_check_movement_mode_transitions()` — on arrival, use the LLM-classified post-arrival mode instead of hardcoded `in_zone`
3. **Optional structural floor** — if zone has <= 3 walkable tiles AND LLM said `roaming`/`in_zone`, override to `stationary` (physical constraint, not a heuristic — you can't roam a 1-tile zone)

That's a prompt edit, ~5 lines in the transition function, and an optional 3-line floor. No new guardrails, no new state tracking, no new escalation paths.

#### **What this fixes vs doesn't:**

**Fixes:**
- Ivan's non-stationary no-ops (36 → 0, becomes intentional stationary)
- Gosha's stationary lock (44 → 0)
- Katya's ABAB oscillation (ends because she dwells at table instead of forced roaming)

**Doesn't fix:**
- **RC1 (Katya library vs common room)** — location selection issue, separate from movement mode
- **Luba's ABAB oscillation** — `in_zone` classification is correct, but 2-tile oscillation is a separate issue (occupancy penalty + single candidate pool)
- **Action lifecycle** — with correct stationary classification, P2 persistence and stall breaker work by design (stationary work is "healthy" and persists naturally)

**Expected gate impact:**
- Non-stationary no-op rate drops dramatically (target <=8%, 24x baseline 42.2%)
- Zone-anchor composition shifts from "bug" to "correct stationary dwell"
- FE stability remains clean (0 blocked, 0 no-progress)

#### *Test results - severe regresssion over Phase 23*

`Full report: @test-results/20260317-24y-opus-2/report.md`

Phase 24 has not made progress — it has regressed to worse-than-baseline levels and expanded the problem from one persona (Ivan) to all four. The root cause appears to be upstream of movement_emit, in the planning stages that are now universally absent from the telemetry. The stall guardrail is firing correctly but cannot recover from whatever Phase 24 changed in the planning/zone-resolution path. This run needs to be treated as a failed validation before proceeding further.


===

### *24c: Validate*

Run 24c as a **dual validation gate** on the cleaned + location-fixed system:
- **Release contract gate (authoritative go/no-go):** `@sot/sot_custom_sim_automation.md` Section 4
- **Naturalness evidence gate (required for this phase):** `@sot/sot_realism.md` C.1 (dwell/transition realism)

**Validation sim**: 60-100 steps, same roster, candidate vs baseline, run twice consecutively with identical config.

**Pass criteria**:
- [ ] Multi-venue spread: personas visit 2+ distinct sectors during the run
- [ ] Zone anchor anti-regression: total `zone_anchor` <= 20% and non-stationary `zone_anchor` <= 8%
- [ ] No metric regression > 5 percentage points versus the latest validated Phase 23 reference run under matched roster/step settings
- [ ] No FE stability regressions (`blocked=0`, `no_progress_same_tile=0`)
- [ ] `movement_mode_source` is `"llm"` for >=95% of action changes (fallback <=5%)
- [ ] No legacy mechanism reactivation in NDJSON trace (rest_lock, noop_bypass, keyword_stationary all absent)
- [ ] Section 4 Naturalness Gate contract passes per `sot_custom_sim_automation.md` (protocol + all required metrics)
- [ ] C.1 routine dwell requirement is closed per `sot_realism.md`: anchor-stable dwell windows, clear dwell->transition patterns, and stationary task progress treated as healthy (not escalated as false stall)
- [ ] All pass criteria above hold in two consecutive validation runs

**Decision point after 24c**:
- If all criteria pass in both runs (including C.1 closure) → ship as `stable`. Phase 24d remains backlog enhancement.
- If core gate passes but C.1 dwell/transition evidence is weak (personas reach correct zones but still look robotic inside them) → proceed to 24d before `stable`.
- If anchor/fallback/FE stability regressions appear → do not ship; diagnose from clean baseline first.

---


## **Phase 25: Pivot to stable phase 23"**
`git branch realism-v2`

### **Situation Summary**

  ┌─────────────────────────┬──────────────────┬───────────────────┬───────────────────┐
  │         Branch          │ Zone Anchor Rate │ Affected Personas │      Status       │
  ├─────────────────────────┼──────────────────┼───────────────────┼───────────────────┤
  │ Baseline (pre-Phase 23) │ 84.2%            │ All               │ Broken            │
  ├─────────────────────────┼──────────────────┼───────────────────┼───────────────────┤
  │ Phase 23 (local)        │ 11.2%            │ Ivan only         │ Mostly working    │
  ├─────────────────────────┼──────────────────┼───────────────────┼───────────────────┤
  │ Phase 24 (realism)      │ 90%              │ All 4             │ Severe regression │
  └─────────────────────────┴──────────────────┴───────────────────┴───────────────────┘

Phase 23 was 88.8% working with a narrow residual: Ivan's non-stationary no-op loops where in-zone movement collapsed to the current tile.

Here's why each option scores:

*Option 2 (stay on realism branch) — Reject*
- Phase 24 is a net-negative. It regressed from 11.2% to 90% anchoring and spread the problem from 1 persona to all 4. The combined location prompt is the likely culprit. Debugging this further is slower than reverting.

*Option 3 (first-principles redesign from legacy) — Reject for MVP*
The original Joon Park code has a fundamentally different architecture (backend-authoritative path, no FE loop, instant tile snapping). Your system already has a much more sophisticated BE-FE loop that Phase 23 proved works. A full redesign risks another Phase-24-style regression and will take significantly longer. The legacy docs are useful as reference, not as a new starting point.

### *Option 1 (patch Phase 23) — Recommended*
Phase 23 already solved the systemic problem. What remains is a narrow, well-diagnosed residual:

#### <Root cause:> 
When movement_mode=in_zone and the persona is already in the target zone, the in-zone tile     selection sometimes collapses to the current tile (producing a no-op emission). The stall guardrail fires   but recovery is partial.                                                                                

#### <Fix>

*Fix 1: In-zone emission guard (execute.py:392-397)*

When movement_mode is in_zone or travel_to_zone, the current tile is excluded from waypoint candidates in _choose_mode_waypoint().    
This directly prevents the root cause — tile selection collapsing to the current position when the LLM already declared the agent should be moving. Falls back gracefully if the current tile is the only option.                                                                                                                                                                                           
*Fix 2: Continuation same-tile cap (plan.py:3552-3596)*
Tracks consecutive steps where a non-stationary agent stays on the same tile during continuation. After 3 steps (configurable via  CONTINUATION_SAME_TILE_MAX), forces a micro-replan and clears the stale waypoint. This catches the arrival_transition no-op loops early — before the heavier stall breaker even needs to fire. Resets the counter on any actual tile change or when mode is      stationary.

*Fix 3: Non-stationary fast escalation (reverie.py:4982-5011)*

When the stall breaker detects movement_mode_non_stationary (the LLM said move but the agent is stuck), it skips the standard 5→8→11   step nudge ladder and instead forces a replan after just 3 flat-progress steps. Also clears the stale waypoint to ensure fresh tile   selection on recovery.

How the three fixes layer together

1. Fix 1 prevents most no-op emissions at the source (tile selection)
2. Fix 2 catches any that slip through during continuation transitions (3 steps max)
3. Fix 3 is the safety net — if an agent still gets stuck, the stall breaker fires in 3 steps instead of 11    


### **Testing Fixes: 20260317-phase23-1 vs Phase 23 Baseline**

*What went wrong with the initial three fixes*

Fix 1 (current tile exclusion in _choose_mode_waypoint) — never reached. The agents with movement_mode=in_zone had sub_mode="in_place" (from      _resolve_subactivity_mode defaulting to in_place for non-travel actions like "check emails"). The code at line 1439 gates waypoint selection behind sub_mode in ("zone_patrol", "workstation_hop", "social_touch") — "in_place" is excluded. So _choose_mode_waypoint was never called, the path buffer stayed empty, and agents fell through to curr_tile.

Fix 2 (continuation same-tile cap) — working but too late. The force replans DID fire (Luba step 23, Katya+Luba step 28), but agents re-entered   the no-op loop immediately because the same structural bug caused the re-planned action to also produce curr_tile.
                                                                                                                                                    
Fix 3 (fast escalation) — undermined by flat_count resets. The flat_count from dual_progress was resetting to 0 each step because progress_ok=True (text-only sub-activity advancement). So the flat_count >= 3 check never triggered. The repeat_count reached threshold but was gated behind the wrong counter.                                                                                                                 
  
<Root cause>

movement_mode (LLM authority: "this agent should move within zone") and sub_mode (heuristic inference: "this looks like an in-place activity")    conflicted, and the execution code let sub_mode win. Agents with actions like "check emails" or "sort card elements" got classified as in_place by keyword matching, but the LLM correctly decided they should be in_zone (moving around the workspace). The execution gate at line 1423 short-circuited motion, and the waypoint selection gate at line 1439 excluded in_place from any movement at all.

### **Round 2 - fixes applied**

1. Gate fix (execute.py:1423): When movement_mode is in_zone or travel_to_zone, the in-place stationary short-circuit is bypassed. movement_mode   is now the primary authority over sub_mode.
2. Waypoint selection fix (execute.py:1439): Expanded the waypoint selection condition to include in_place agents when movement_mode demands motion. Uses zone_patrol scoring for distance-based tile selection.
3. Escalation fix (reverie.py): Changed from flat_count to repeat_count for the non-stationary fast replan trigger, since flat_count gets reset by text-only sub-activity progress.


#### *RESULTS sim `20260317-phase23-2`*

  KPI Comparison (30-step window)                                                                                                                                 
  ┌─────────────────────────┬────────────────────────────┬─────────────────────────┬──────────────────────────────────────────────────────┬─────────────────┐      
  │         Metric          │ Phase 23 baseline (steps   │ Run 1 (pre-fix, steps   │             Run 2 (post-fix, steps 0-29)             │    Direction    │     
  │                         │           0-41)            │          0-29)          │                                                      │                 │       ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤
  │ Zone anchor rate        │ 7.1% (12/168)              │ 16.7% (20/120)          │ 30.8% (37/120)                                       │ Worse raw       │     
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤     
  │ Non-stationary no-op    │ ~3.6%                      │ 12.5% (15/120)          │ 22.5% (27/120)                                       │ Worse raw       │
  │ rate                    │                            │                         │                                                      │                 │     
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤      
  │ Personas affected       │ Ivan only                  │ Ivan, Katya, Luba       │ Ivan, Katya, Luba                                    │ Same            │
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤      
  │ Blocked rows            │ 0                          │ 0                       │ 0                                                    │ OK              │
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤      
  │ Unique tiles per        │ not measured               │ not measured            │ 23/12/20/16                                          │ New signal      │
  │ persona                 │                            │                         │                                                      │                 │
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤
  │ Spatial range (x)       │ Ivan: [130-131]            │ similar                 │ Gosha:[108-131] Ivan:[120-131] Katya:[108-126]       │ Major           │     
  │                         │                            │                         │ Luba:[116-129]                                       │ improvement     │
  ├─────────────────────────┼────────────────────────────┼─────────────────────────┼──────────────────────────────────────────────────────┼─────────────────┤
  │ Force replans that      │ ~50%                       │ ~0% (re-lock)           │ ~70% produce movement next step                      │ Major           │
  │ recover                 │                            │                         │                                                      │ improvement     │      └─────────────────────────┴────────────────────────────┴─────────────────────────┴──────────────────────────────────────────────────────┴─────────────────┘
*What improved:*
- Spatial spread is dramatically better. Agents are no longer permanently locked to their spawn tile. They travel across the map, visit multiple zones, and cover wide coordinate ranges. This is a qualitative transformation vs both previous runs where Ivan was stuck at [131,54] for 100+ steps.
- Force replans now produce recovery. Post-replan movement data shows:
  - Ivan replan@8 → step 9: travels from [131,54] to [126,51] (5 tiles)
  - Katya replan@10 → step 11: travels from [119,49] to [121,45]
  - Luba replan@10 → step 11: travels from [121,45] to [121,41]
  - Luba replan@22 → step 23: travels from [119,48] to [119,42] (6 tiles)                                                                                         

This confirms the gate fix (movement_mode overrides sub_mode) is working for new action planning. Agents get unstuck and travel to new locations.               

No-op clusters are bounded. Max cluster length is 7 (Katya early), with most clusters at 4 steps. Compare to Phase 23 Ivan's 16-step cluster. The continuation cap (Fix 2) and fast escalation (Fix 3) are breaking loops faster.

*What's still broken*
In-zone no-ops persist after arrival. All 27 non-stationary no-ops have path_len=0 and source llm:arrival_transition. The pattern is: agent travels to a new zone (works!), arrives, mode transitions to in_zone, then gets stuck for 3-7 steps until the guardrail fires again.

<Root cause:> 
The waypoint cache in _choose_mode_waypoint (lines 381-385). When an agent arrives at a zone, its subactivity_waypoint may already be set to the urrent tile (from the travel target). The cache check returns this stale waypoint before the current-tile exclusion runs. Then the pathfinding gate (tuple(waypoint) != tuple(curr_tile) at line 1482) sees waypoint == curr_tile and skips pathfinding entirely. Path stays empty → agent stays put.               
  
*Verdict*

Mixed result: the architectural fix works, but a cache invalidation gap prevents clean in-zone behavior. The raw no-op rate is worse, but the underlying spatial   behavior is fundamentally better — agents travel, recover from replans, and visit multiple locations. The remaining issue is a narrow cache invalidation bug, not a structural problem.                                                                                                                                       

### **Round 3 - Fixes Implemented**

The cache invalidation fix is applied at execute.py:383-389. When movement_mode is in_zone or travel_to_zone and the cached waypoint equals the agent's current tile, the cache is bypassed and a fresh waypoint is selected — which then goes through the existing current-tile exclusion filter at line 398.

#### *RESULTS sim `20260317-phase23-3`*
`Full report: D:\Coding\generative_agents\test-results\20260317-phase23-3\report.md`

The fix made things worse, not better. 

Recommendation: Round 4

### **Round 4 - revert the cache invalidation fix and instead target the actual bottleneck:**

*Reverted (Round 3 cache invalidation)*
Lines 385-390 no longer do the movement_mode in ("in_zone", "travel_to_zone") and tuple(existing) == tuple(curr_tile) bypass — it's back to a clean return tuple(existing).

Added (Round 4 tiny-zone min-leg floor removal): When len(zone_tiles) < 6, min_leg is forced to 0. This means candidates = zone_tiles always has the full tile set — no distance filtering that could empty the list and force a fallback that included curr_tile. The existing current-tile exclusion at lines 401-405 then reliably picks a different tile.

Why this addresses the true root cause: 
In small zones, ZONE_PATROL_MIN_LEG=5 was often larger than the zone itself, so candidates collapsed to empty → fallback to zone_tiles including curr_tile → the scoring loop could pick curr_tile if non_current was somehow bypassed, or the waypoint cache was set to curr_tile on arrival. With min_leg=0, the full zone tile set is always vailable and the current-tile exclusion has real alternatives to work with.

#### *RESULTS sim `20260317-phase23-4`*
`Full Report: D:\Coding\generative_agents\test-results\20260317-phase23-4\report.md`

Round 4 is worse than Round 2 (41.7% vs 30.8% anchor rate)

<What's still broken> 
Ivan is in a sustained force-replan loop (steps 14–29 consecutive). 15 replans in 16 steps means each replan immediately re-enters the same stuck state. Ivan's zone range is only [130–132, 50–54] — that's roughly a 3×5 = 15-tile region, which is above the < 6 threshold, so the fix never applied to Ivan.      

Root cause still active for Ivan: The tiny-zone threshold of 6 is too low. Ivan's workspace   zone likely has 6–15 tiles but still produces min-leg collapse. The threshold needs to be higher (e.g., 12 or even 20), or the min-leg should scale proportionally to zone size rather than using a hard cutoff.

### *Round 6: Baseline Phase 23 simulation `20260317-23-5`*

`git branch local`

**Assessment: 20260317-23-5 (28 steps, clean Phase 23 state)**

  KPI Summary vs Prior Runs
  │ Zone anchor rate  │ 7.1% (12/168)     │ 30.8% (37/120)  │ worse   │ 41.7% (50/120) │ 3.6% (4/112) │
  ├───────────────────┼───────────────────┼─────────────────┼─────────┼────────────────┼──────────────┤
  │ Personas affected │ Ivan only         │ Ivan,Katya,Luba │ all     │ all            │ Ivan only    │
  ├───────────────────┼───────────────────┼─────────────────┼─────────┼────────────────┼──────────────┤
  │ Force replans     │ ~50% recovery     │ ~70% recovery   │ —       │ 15+/step Ivan  │ None         │
  ├───────────────────┼───────────────────┼─────────────────┼─────────┼────────────────┼──────────────┤
  │ Blocked           │ 0                 │ 0               │ 0       │ 0              │ 0            │
  └───────────────────┴───────────────────┴─────────────────┴─────────┴────────────────┴──────────────┘

  This is the best recorded result across all runs. The 3.6% zone anchor rate beats even the Phase 23 baseline (7.1%).

*Fun fact: this simulation was ran on the original phase 23 code in 'local' branch, without any followup updates*


### **Round 7: Summary as of 2026-03-17**

Phase 23 clean code, no patches: 3.6% zone anchor rate. That's the best number in this entire history.

Every attempt to improve on it — rounds 2, 3, 4, Phase 24 — made it worse. 
The pattern is consistent: the system is at or near its local optimum. Each additional patch introduced new coupling that broke something else.

*Ivan's residuals in this run:*
  - Steps 1–23: arrival_transition source never expires → 2-tile oscillation in a 15-tile bathroom. He IS moving, not stuck. It's   
  boring but not broken.
  - Steps 24–27: LLM declared stationary → correct behavior, misclassified by the zone_anchor audit as a defect.

  The "problem" Ivan has is cosmetically minor, and partially expected (bathroom is a small zone).

  ---
  *Should You Fix or Rebuild?*
Neither in the way you're thinking. Here's why:

A)  Rebuilding from legacy — Reject
  The legacy system (0.legacyMovements.md, 0.actionLifecycleMgmt.md) is architecturally incompatible with what you have. Legacy is: 
  - Backend sends a full tile path, frontend snaps instantly
  - No headless FE execution engine
  - No zone-based movement, no movement_mode classification
  - No Supabase, no observation pipeline, no proximity reports

  You'd be rebuilding the entire BE-FE contract from zero. The result would be a simpler spatial engine that loses all the work     
  already invested in memory, conversation triggers, and observation feedback. That's not a rebase — it's a different product.      

B) More Phase 23 patches — Also Reject
  Rounds 2–4 proved the pattern: each "fix" solves one symptom and breaks two others because the system is now complex enough that  
  local changes have non-local effects. You've already found this limit.

C) What's Actually Optimal

- Declare Phase 23 the spatial baseline and stop touching movement.
- The 3.6% zone anchor rate with 3/4 personas perfect means movement is not your MVP bottleneck. The interesting.md says it plainly 
  at the top:
`Current realism failure is strongly linked to homogeneous seed grounding (same park-centric setup and generic orientation routines), not only movement execution logic.`

That was written in February. It's still true now. Movement realism is largely solved. What's blocking MVP naturalness is:        
  - Activity content quality — are the scheduled activities believable and varied?
  - Conversation triggers and quality — do personas talk to each other at the right moments?
  - Daily schedule coherence — does the day arc feel like a real person's day?

Ivan's 2-tile bathroom oscillation is invisible to an observer watching the simulation for the first time. The observation that a persona spent 6 hours on "silence alarm and sit up, check overnight messages" is the actual problem — and that's a schedule/planning issue, not a movement issue.

---
*Concrete Recommendation*

One and only one movement fix, then freeze movement code:

Ivan's arrival_transition source persisting for 23 steps is a timer bug — there's no expiry condition. Add a step counter (3–5 steps max) after which arrival_transition yields to a clean in_zone state with repeat_penalty active. That eliminates the oscillation. Don't touch anything else in execute.py.

*Then redirect effort to:*
1. Schedule quality — are 6-hour "morning routines" being generated? That's the planning prompt or duration normalization
2. Conversation quality and trigger rate — are personas actually talking at realistic frequencies?
3. Activity diversity — the role/routine seeding pipeline (Phase 3) exists; is it generating varied enough daily schedules?       

The movement engine is 96% working. The naturalness gap is above the movement layer.

---
### **FE Engineer Review (2026-03-17) — External Validation**

*Context: FE engineer reviewed Phase 23 code and docs without seeing round 2–4 patch attempts.*

**"Post-arrival behavior: the runtime is conflating 'how to get there' with 'what to do once there'"**
→ Confirmed by Ivan's trace: `arrival_transition` source persists steps 1–23 (23 steps) after arriving at the bathroom. The system has no clean semantic boundary between travel-complete and in-zone operation. Once arrived, the mode label changes but the transition state never expires.

**"Lifecycle control: duration exhaustion, P2 extension, and healthy-persistence can keep stale actions alive longer than they should"**
→ Confirmed by data: Ivan's `act_duration=6` action ran for 24 steps (4× declared duration). Healthy-persistence kept it alive well past expiry. This is why Ivan spent 6 simulated hours on "silence alarm and sit up."

**"Too many independent mechanisms influencing movement intent without one clear arbiter"**
→ Consistent with why rounds 2–4 failed. Each patch resolved one conflict but introduced coupling elsewhere. Phase 23 clean code outperforms every patched version — the system is stable when not touched.


#### His 6-stage model as a diagnostic lens

| Stage | Current state |
|---|---|
| 1. Semantic intent | Handled — LLM `movement_mode` at planning time |
| 2. Location resolution | Handled — zone resolution in `execute.py` |
| **3. Post-arrival behavior** | **Gap** — `arrival_transition` never expires; no clean in-zone steady state |
| 4. Physical execution | Handled — FE A* pathfinding |
| 5. Result validation | Handled — `feedback_applied` stage |
| **6. Lifecycle / action transition** | **Gap** — healthy-persistence keeps actions alive 4× declared duration |

Stages 3 and 6 are the only open gaps. Ivan's two residuals map exactly to these two.

#### Targeted fixes (scope-constrained)

Do not attempt full stage-separation redesign. Close only the two confirmed gaps:

**Fix A — Arrival transition expiry (Stage 3 gap)**
In `execute.py`: after N steps (3–5) with `movement_mode_source == arrival_transition`, force-expire to clean `in_zone` state and activate `repeat_penalty`. Single condition, no architectural change. This eliminates the 23-step bathroom oscillation.

**Fix B — Action duration cap (Stage 6 gap)**
In the lifecycle check: enforce a hard ceiling on how long healthy-persistence can extend an action past its declared `act_duration` (2× max recommended). This prevents 6-hour "morning routines" and is the same fix needed regardless of movement behavior.
Fix B is a planning/lifecycle issue, not a movement issue. It belongs in `plan.py` or `scratch.py`, not `execute.py`.

#### Changes made

  ---
  scratch.py — 5 locations, all for the new arrival_transition_step_count field:                                                      - __init__: initialized to 0 alongside existing P2 fields                                                                           - JSON load: int(scratch_load.get("arrival_transition_step_count", 0) or 0)                                                       
  - JSON save (×2 via replace_all): serialized alongside p2_last_extended_step                                                      
  - Supabase load: same pattern as JSON load                                                                                        
                                                                                                                                    
  plan.py — 4 changes:                                                                                                              
┌────────────────┬──────────┬────────────────────────────────────────────────────────────────────────────────────────────────┐      │      Fix       │ Location │                                             Change                                             │    
├────────────────┼──────────┼────────────────────────────────────────────────────────────────────────────────────────────────┤    
│ A env flag     │ ~line    │ ARRIVAL_TRANSITION_EXPIRY_STEPS = max(1, int(os.getenv(..., '3')))                             │ 
│                │ 146      │                                                                                                │ 
├────────────────┼──────────┼────────────────────────────────────────────────────────────────────────────────────────────────┤    
│ A              │ ~line    │ Expiry logic: counter≥3 + sub_mode==in_place → stationary:arrival_transition_expired; else     │      
│ planning-time  │ 3020     │ increment counter; non-arrival branch resets counter to 0                                      │    
├────────────────┼──────────┼────────────────────────────────────────────────────────────────────────────────────────────────┤    
│ A              │ ~line    │ Same expiry logic in _check_movement_mode_transitions; non-arrival branches also reset counter │      
│ reconciliation │ 3579     │                                                                                                │ 
├────────────────┼──────────┼────────────────────────────────────────────────────────────────────────────────────────────────┤    
│ B1             │ ~line    │ last_switch = last_switch if last_switch is not None else 0 — refresh cap now fires for first  │      │                │ 937      │ action                                                                                         │ 
├────────────────┼──────────┼────────────────────────────────────────────────────────────────────────────────────────────────┤    
│ B2             │ ~line    │ persona.scratch.p2_consecutive_extensions = 0 on action_switch_noop — breaks the every-step    │      │                │ 3800     │ churn loop                                                                                     │
└────────────────┴──────────┴────────────────────────────────────────────────────────────────────────────────────────────────┘    
  
#### *Test results @/test-results/20260317-phase23-6 - after 30 steps*

`FUll report: D:\Coding\generative_agents\test-results\20260317-phase23-6\report.md`

- Fix A (arrival_transition_expiry) — did not fire
- Fix B1 (treat p2_last_action_switch_step = None as step 0) — inconclusive, but moot
- Fix B2 (reset p2_consecutive_extensions on noop) — not verifiable

**Action: required follow-up (Fix A counter bug)**

# In _check_movement_mode_transitions (reconciliation site):                                                                      
# REMOVE this else branch:
else:
persona.scratch.arrival_transition_step_count = 0  # <-- breaks the counter every step
                                        
The reconciliation site's else fires precisely when planning-time has done its job (mode=in_zone, in_zone=True) — but it resets     the counter planning-time just set. Removing it allows the counter to accumulate and expiry to fire at step 4 onward.

Katya's 19-step arrival_transition loop is the clearest test case: with the fix, she should expire at step 4 and go stationary.     Without it, she stays in_zone for 19+ steps until the LLM independently decides to switch to stationary.

### **Round 8** 

*Done:* 
The else branch at line 3595-3596 that was resetting arrival_transition_step_count = 0 every step is removed. The counter will now accumulate as planiing-oime increments io, and the expiry at ARRIVAL_TRANSITION_EXPIRY_STEPS (d faul  3) will fire corre tly.

✻ What this changes: 
Katya's 19-step arrival_transition loop should now expire at step 4 and transition to stationary. Ivan's 2 pathological zone-anchor rows (steps 20, 23) should also  esolve.

❯ What this doesn't change: 
The 26 stationary-on-expired-schedule rows — those are the planning/lifecycle problem for your next focus area.

## **Phase 26: Capture raw llm output in logs**

### *Phase 26.0: Router-Level LLM Capture*                                                                             

Captures the raw LLM request/response at the model router level and exposes it for downstream logging.                                                                                                                              
`model_router.py` (3 edits):
  - Added self._last_llm_capture field in __init__
  - Added _store_llm_capture() helper that builds the capture dict (function_name, model, api_style, request         messages/params, raw response_payload_dict, extracted_text, timestamp)
  - Added get_last_llm_capture() getter (same pattern as existing get_last_model_used)
  - Called _store_llm_capture() at all 3 return points in _execute_text_request(): responses path,
  chat-empty-retry-responses path, and chat_completions path
                                                                                                                     
`gpt_structure.py` (2 edits):
  - Added get_last_llm_capture() module-level function delegating to model_router                                    
  - Added _maybe_capture_llm_response() — checks LLM_CAPTURE_PATH env var, reads the router's last capture, appends   as NDJSON line
  - Hooked _maybe_capture_llm_response() into safe_generate_response() after every GPT_request() call — zero-touch   for all call sites                                                                                   

`reverie.py` (2 edits):
  - Added LLM_CAPTURE_ENABLED and LLM_CAPTURE_PATH env overrides in _run_with_log_collection() (restored in finally   block by existing pattern)
  - Added NDJSON path to the log-mode banner                                                                       
                                                                                                                   
  Capture is completely inactive outside log mode — `LLM_CAPTURE_PATH` defaults to empty string, so   _maybe_capture_llm_response returns immediately.

---                                                                                                                
### *Phase 26.1: Per-Persona-Per-Step LLM Capture*
                                                                                                                   
Replaces the flat NDJSON file with structured per-step JSON files at storage/<sim_code>/llm/<step>.json, grouped by persona — mirroring the existing movement/<step>.json pattern. Adds persona and step fields to each record.      

`cognitive_capture.py` (NEW ~50 lines):
  - Thread-local accumulator: set_context(persona, step, sim_code), clear_context(), get_context(),
  record_llm_call(), flush_llm_calls()                                                                               - Thread-local design matches P1 parallel mode (each persona runs in its own thread)
                                                                                                                   
`persona.py` (~10 lines):                                                                                          
  - Wraps the cognitive sequence (perceive → retrieve → plan → reflect → execute) in set_context()/clear_context()   with try/finally, using the dual-import pattern
                                                               
`gpt_structure.py` (~15 lines):                                                                                    
  - _maybe_capture_llm_response() now checks LLM_CAPTURE_ENABLED env var (replaces LLM_CAPTURE_PATH check) and       calls record_llm_call() to accumulate in thread-local storage instead of writing NDJSON directly
              
`reverie.py` (~30 lines):                                                                                          
  - _run_with_log_collection(): Sets LLM_CAPTURE_ENABLED=true and CURRENT_SIM_CODE (removed LLM_CAPTURE_PATH);       updated banner
  - _write_llm_step_file(): New method — writes llm/<step>.json to sim folder
  - Parallel path: _compute_stage_b_intent() flushes LLM calls after persona.move(), returns them in output; after 
  futures complete, collects per-persona calls and writes step file
  - Serial path: After each persona.move(), flushes calls into _serial_llm_data dict; after persona loop ends,       writes step file (skipped when parallel mode was active)
  

### *Reconstructing the Full Chain for a Failed Step/Sprite*

All files live under `test-results/<sim_code>/`. To diagnose a failed sprite at step N, pull one record from each file and read them in order.        

#### Step 1 — BE intent (what the backend planned)

File: `movement-pipeline.ndjson`  
Filter: `step == N && persona == "<name>"`

You'll get 6 records in this order — this is the full BE pipeline:

| Stage              | What it tells you                                                                 |
|--------------------|-----------------------------------------------------------------------------------|
| plan_entry         | Starting position, position source (supabase/json), act_description, act_address, target_zone, stationary_intent, speed_multiplier, target tile selection trace |
| movement_emit      | start_pos, planned_pos, movement (next tile), path hash/length, target_zone — this is the intent contract sent to FE |
| stall_guardrail    | Whether this step was flagged as stationary repeat, healthy_persistence (true = expected), healthy_reason |
| step_carry_forward | State carried into next step: force_replan_next_step, partial state snapshot      |
| movement_report_in | FE's movement report fed back: actual_pos, actual_path, blocked, deviations       |
| feedback_applied   | Final reconciled result: blocked, blocked_reason, deviation from plan             |

#### Step 2 — FE injection (what the frontend received)

File: `fe-forensics/fe-injected-payload.ndjson`  
Filter: `step == N && persona == "<name>"`

Shows exactly what was injected into headless Phaser: `start_pos`, `movement` (target), `planned_pos`, `target_zone`, `speed_multiplier`, `path`, `description`.  

Compare `start_pos` and `planned_pos` here against `movement_emit` from Step 1 — they must match.

#### Step 3 — FE pathfinding (what actually happened on the tile map)

File: `fe-forensics/fe-pathfinding-trace.ndjson`  
Filter: `step == N && persona == "<name>"`

Shows the A* result: `start_tile`, `actual_path`, `actual_pos`, `blocked`, `blocked_reason`, `reached_target`, `is_fallback`. This is ground truth for where the sprite ended up.

Common failure signatures:  
- `blocked: true` → collision or unreachable target  
- `reached_target: false` with `actual_pos != movement_target_tile` → partial progress or reroute  
- `actual_path_length: 0` → sprite didn't move at all  

#### Step 4 — LLM calls (what the model said)

Phase 26.0 format (current run): `llm-responses.ndjson` — flat list, no persona/step fields. Records are in chronological order by `ts`. Cross-reference by timestamp against the `plan_entry.ts` for your step.

Phase 26.1 format (future runs): `storage/<sim_code>/llm/<step>.json` — structured per-step file, keyed by persona name. Each persona has a `calls[]` array with `function_name`, `model`, `request.messages`, `raw_response`, `extracted_text`, `ts`.

Key LLM functions in the cognitive cycle (in call order):

| Function                                   | Cognitive stage | What to look for                                |
|--------------------------------------------|-----------------|-------------------------------------------------|
| run_gpt_prompt_task_decomp_contextual      | plan            | Schedule decomposition — does it make sense?    |
| run_gpt_prompt_action_sector               | execute         | Sector choice — did it pick the right area?     |
| run_gpt_prompt_action_arena                | execute         | Arena within sector — narrowing to room/zone    |
| run_gpt_prompt_action_game_object          | execute         | Object selection within arena                   |
| run_gpt_prompt_movement_mode               | execute         | Moving vs stationary decision — check this first for stall bugs |
| run_gpt_prompt_event_triple                | execute         | Subject-verb-object for the action              |
| run_gpt_prompt_act_obj_event_triple        | execute         | Object-perspective event triple                 |
| run_gpt_prompt_pronunciatio                | execute         | Emoji for the action                            |
| run_gpt_prompt_insight_and_guidance        | reflect         | Memory consolidation                            |

Quick-filter one-liner (Python)

```python
import json

SIM = "20260318-1-phase25.8-26"
STEP = 5
PERSONA = "Ivan Pistsov"
ROOT = f"test-results/{SIM}"

# BE pipeline chain
with open(f"{ROOT}/movement-pipeline.ndjson", encoding="utf-8") as f:
    chain = [json.loads(l) for l in f
             if json.loads(l)["step"] == STEP
             and json.loads(l)["persona"] == PERSONA]
for r in chain:
    print(f"  [{r['stage']}] {list(r.get('data',{}).keys())[:6]}")

# FE injection
with open(f"{ROOT}/fe-forensics/fe-injected-payload.ndjson", encoding="utf-8") as f:
    inj = [json.loads(l) for l in f
           if json.loads(l)["step"] == STEP
           and json.loads(l)["persona"] == PERSONA]
print(f"  FE injected: start={inj[0]['start_pos']} planned={inj[0]['planned_pos']}")

# FE trace
with open(f"{ROOT}/fe-forensics/fe-pathfinding-trace.ndjson", encoding="utf-8") as f:
    trace = [json.loads(l) for l in f
             if json.loads(l)["step"] == STEP
             and json.loads(l)["persona"] == PERSONA]
t = trace[0]
print(f"  FE actual: pos={t['actual_pos']} blocked={t['blocked']} reached={t['reached_target']}")
```

What "failed" looks like:

| Symptom                  | Where to look                          | Likely cause                                                                 |
|--------------------------|----------------------------------------|------------------------------------------------------------------------------|
| Sprite stuck in place for 3+ steps | stall_guardrail.healthy_persistence == false | LLM movement_mode returning stationary, or rest-lock kicking in              |
| Sprite teleported        | feedback_applied.deviation is large    | BE planned_pos was far from start_pos — check plan_entry.target_zone vs actual position |
| Sprite blocked by wall   | fe-pathfinding-trace.blocked == true   | BE target tile is inside collision geometry — check plan_entry.target_tile against collision map |
| Sprite oscillating       | plan_entry shows alternating target_zone or act_address across steps | LLM replanning every step — check force_replan_next_step and cooldown        |

**Next steps for devs:** Start with Step 1's pipeline trace to isolate BE vs FE issues. If the chain looks clean but behavior is off, cross-reference LLM outputs in Step 4. Test the Python filter locally on a sample sim to build familiarity—let me know if you need a Jupyter version or more examples.

### *Test Sim Amalysis*

`Full Report: @environment/frontend_server/storage/20260318-6/report.md`

The simulation run `20260318-6` was a complete success, executing 93 steps (about 1.5 simulated hours) for the Pistsov family in the "the Ville" environment without crashes, blocks, or data inconsistencies. Logging covered the full pipeline—from backend planning and frontend execution to reflections—with strong coverage across all four personas (Gosha, Ivan, Katya, Luba). 
Zone anchoring worked effectively 34% of the time, reducing unnecessary movement and enabling focused tasks, while replanning triggered only five times for schedule shifts. 
Final positions aligned logically with activities: Gosha annotating notes in a hallway, Ivan hydrating at a sink, Katya crafting at a table, and Luba serving in the kitchen. Timings were efficient, with no timeouts, validating the recent realism patches like stationary intent handling and collision avoidance.

Behavior showed naturalistic routines, starting with early movement and shifting to stationary focus, though the high anchoring rate (potentially too static) suggests tuning for more dynamic micro-actions if needed. 
<No conversations> triggered in the final step, but proximity observations fed non-chat interactions well. 
Pipeline forensics confirmed clean handoffs, with frontend A* pathfinding respecting maze tiles—no wall-walking occurred.


# ========<DEFERRED: Ordered implementation backlog>==================

## **Remaining Phase 24 items**

### *24d: Transit/dwell sub-plans (conditional — only if 24c shows intra-zone gap)*

<Align with steps implemented in 24Y>

**Problem**: Within a single action (e.g., 20-min kitchen activity), the persona either moves continuously (`in_zone`) or stays put entirely (`stationary`) for the whole duration. Real behavior alternates: walk to fridge → stay → walk to stove → stay → walk to table → stay.

**Prerequisite**: 24a-24c must pass first. Adding sub-plan complexity on top of 8 contradicting legacy mechanisms was the mistake of Phases 1-22. On a clean system, this feature is straightforward.

**Implementation** (same design as original Sections 2-4, but executed on a clean base):

**D1. Sub-plan entries carry `movement_intent`** (`"transit"` or `"dwell"`).

For `workstation_hop` and `zone_patrol`: generate alternating transit/dwell pairs from zone game objects. For `in_place` or missing objects: all-dwell (identical to current behavior).

**D2. Sub-step transitions drive `movement_mode`**.

When `_update_subactivity_runtime` advances the sub-step index, update `movement_mode`, `stationary_intent`, and `speed_multiplier` from the new sub-step's `movement_intent`. Legacy plans without `movement_intent` → no change → backward compatible.

**D3. Anchor-to-tile resolution**.

`_resolve_anchor_to_tiles()` maps anchor labels (e.g., `"refrigerator"`) to game object tile coordinates via `maze.address_tiles`. Integrated into `_choose_mode_waypoint()` — try anchor resolution first, fall back to generic zone-tile heuristics.

**D4. Dwell safety net**.

If `movement_intent == "dwell"` but persona is not near the anchor tile, auto-promote to `in_zone` until arrived.

**Cost**: Zero additional LLM calls. Zone objects from spatial memory. Sub-plan construction is pure Python.

#### Implementation checklist (24d)

- [ ] `_build_subactivity_plan` accepts `zone_objects`, generates transit/dwell pairs
- [ ] `_get_zone_game_objects` queries spatial memory for objects under `action_address`
- [ ] `_update_subactivity_runtime` updates `movement_mode` on sub-step advancement
- [ ] `_resolve_anchor_to_tiles` with exact + substring matching
- [ ] `_choose_mode_waypoint` tries anchor resolution before heuristics
- [ ] Dwell safety net gates on `_is_near_anchor_tile()`
- [ ] NDJSON trace: `movement_intent`, `anchor_resolution`, `sub_step_transition`
- [ ] Naturalness Gate pass with transit/dwell alternation visible in trace

#### *Practical decision rule:*

- **24c passes fully (including C.1 dwell evidence)** → skip `24d` for now, ship candidate.
- **24c passes core movement metrics but C.1 still weak/robotic** → implement `24d`.
- **24c fails core metrics (anchor/no-op/regression/stability)** → fix remaining 24b issues first, then re-run 24c (don’t jump to 24d yet).

---


### *Legacy cleanup reference (code locations)*

For implementation, here is the verified mechanism map:

| Mechanism | File | Lines | Env flag | Phase 23 integrated? |
|-----------|------|-------|----------|---------------------|
| REST LOCK | `reverie.py` | 4355-4571 | `REST_STATIONARY_LOCK_ENABLED` | Yes (skips when `movement_mode` present) |
| NOOP bypass | `reverie.py` | 3698-3713, 6513-6555 | `NOOP_MOVEMENT_BYPASS_ENABLED` | Yes (requires `mode=="stationary"`) |
| Healthy persistence | `reverie.py` | 6463-6511 | — | Partial (keywords remain for `sleep_like`) |
| Target pinning | `reverie.py` | 4405-4434 | — | Via `stationary_intent` |
| Keyword tuples | `plan.py` | 79-105 | — (new: `MOVEMENT_MODE_KEYWORD_FALLBACK`) | Fallback only |
| `_compute_stationary_state` | `plan.py` | 610-683 | — | Bypassed when `movement_mode` set |
| `_recalculate_on_continuation_legacy` | `plan.py` | 3594-3654 | — | Independent (keywords) |
| Location keywords | `plan.py` | 1582-1617 | — (removed by `COMBINED_LOCATION_PROMPT_ENABLED`) | Independent |
| In-zone variation filter | `execute.py` | deprecated | — | Replaced by occupancy penalty |
| Micro-move keywords | `execute.py` | 1290-1364 | — | Independent (keywords) |
| Dual-progress escalation | `reverie.py` | 4961-5013, 6370-6423 | `DUAL_PROGRESS_GUARDRAIL_ENABLED` | Indirect |
| Movement mode LLM | `run_gpt_prompt.py` / `plan.py` | 1633-1696 / 583-607 | `MOVEMENT_MODE_LLM_ENABLED` | **Primary source** |

### *Dead code removal (Phase 24 final — after 2+ validated runs with 0% fallback)*

After 24c passes and fallback rate confirmed at 0% across multiple runs:

**Safe to remove** (no runtime path depends on them when `movement_mode` is always set):
- [ ] Remove `LOCATION_KEYWORDS` dict (plan.py:1582-1617)
- [ ] Remove `generate_action_sector()` and `generate_action_arena()` (run_gpt_prompt.py)
- [ ] Remove `_should_apply_noop_movement_bypass()` (reverie.py:6513-6555)
- [ ] Remove REST LOCK block (reverie.py:4355-4571)
- [ ] Remove `_is_in_place_activity()`, `_is_travel_activity()` keyword helpers (execute.py:58-65)

**Keep as fallback safety net** (protect against LLM failures on edge cases):
- `_recalculate_stationary_on_continuation_legacy()` — only path that sets `stationary_intent` when `movement_mode` absent on continuation
- `_compute_stationary_state()` — feeds the legacy continuation path
- `_classify_healthy_persistence()` keyword branches — protects sleep actions in legacy path
- `IN_PLACE_ACTION_KEYWORDS`, `TRAVEL_ACTION_KEYWORDS` tuples — used by above functions
- `_dual_progress_status()` and nudge ladder — partial recovery (sub-activity advance, waypoint refresh) prevents unnecessary full replans

**Docs update**:
- [ ] Update `sot_realism.md` Section C to reflect dual-authority model (LLM primary, keyword fallback)
- [ ] Document which mechanisms are disabled vs fallback-only


## *Guardrail and lifecycle tuning*

1. **BE: Fix `act_duration` exhaustion not triggering activity transitions** *(bug, identified in `20260313-2`)*
   - Ivan's `act_duration: 5` (5-minute task "turn off alarm and stretch in bed") ran for 29 steps (~145 sim-minutes) without completing or transitioning.
   - The schedule/action-completion check that should trigger the next activity when duration is exceeded is either not running or not comparing correctly on continuation steps.
   - Where: `plan.py` `_determine_action` / continuation path — audit the condition that compares elapsed steps against `act_duration` and triggers activity switch.
   - This is independent of the `speed_multiplier` fix (item 3) — even with correct movement, activities must transition when their time window expires.

2. **BE: Reduce over-extension of routine actions**
   - Lower `P2_ACTION_MAX_CONSECUTIVE_EXTENSIONS` from `3` to `1` (initial target).
   - Initialize `p2_last_action_switch_step` safely on first action set so periodic refresh is active from startup.
   - Objective: preserve coherence while avoiding long frozen routine windows.
   - Note: Phase 20 Fix 3 added schedule-drift check to `_p2_should_extend_action` which partially addresses this; tuning the extension cap is the remaining lever.

3. **BE: Tighten dual-progress escalation for "looks active but still static" cases**
   - Refine `task_progress` semantics so trivial time-linear score drift alone does not indefinitely suppress escalation.
   - Use stronger progress signal for in-place work (e.g., stage advancement, milestone crossing, or bounded score window checks).
   - Keep nudge ladder (`advance -> anchor -> force_replan`) but ensure escalation can trigger when a persona is visibly stale.

4. **BE: Add duration cap to `healthy_persistence` sleep-like bypass**
   - In `_classify_healthy_persistence(...)`, replace unconditional `sleep_like` bypass with a bounded rule.
   - Scope bypass to realistic windows only (night-hour + minimum intended sleep duration + max allowed continuous steps).
   - Ensure prolonged "resting/sleep-like" labels do not grant indefinite stall-breaker immunity.
   - Note: Phase 20 Fix 3 already added schedule-drift gating to `stationary_desk_work`; this item targets the `sleep_like` branch specifically.

## *Quality and observability*

5. **BE: Close replay authority proof for `actual_path`**
   - Persistence path is implemented (`_persist_position_update` writes `actual_pos` + `actual_path`).
   - Forensic replay audit still shows `chosen_source=none`.
   - Add BE observability marker (path source/provenance in movement payload or audit logs).

6. **BE+FE: Docs + contract cleanup**
   - Update project docs (`@docs/README.md` and corresponding SOTs):
     - headless generation mode: backend omits `path` entirely
     - replay mode: API sends stored `actual_path`
     - step `0`: no special exception in the contract
     - top-level headless execution fields (`start_pos`, `movement`, `planned_pos`, `target_zone`, `speed_multiplier`) survive intact through the runtime transport path
   - Remove or narrow older wording that still suggests generation-time backend `path` is a preferred execution input.
   - Clarify `sot_be-fe.md` Section 4.3: SOT example shows `__currentPersonaPositions.position` as pixels `[2624, 384]`, but FE investigation (2026-03-13) confirmed FE applies `pixelToTileSnap` before storing. Verify which is correct and align SOT with implementation.

7. **FE: Migrate movement reports from `__headlessReports` to `__headlessObservations`** *(contract alignment)*
   - FE investigation (2026-03-13) confirmed movement reports are written to `window.__headlessReports`, while proximity observations go to `window.__headlessObservations`.
   - `sot_be-fe.md` Section 4.1 declares `__headlessObservations` as the "single canonical event stream" for all observation types; Section 4.4 marks `__headlessReports` as deprecated.
   - BE currently handles this via fallback (tries `__headlessObservations` first, falls back to `__headlessReports`), so it works — but removing the fallback would silently break extraction.
   - FE should move movement reports into `__headlessObservations` alongside proximity events so both sides align with the SOT.

8. **API+BE: Consolidate coordinate conversion to API Gateway only** *(code hardening, no sim impact)*
   - Three conversion leaks exist outside the API Gateway boundary (identified in `20260313-2` forensic analysis):
     - `headless_visualization.py` `_normalize_step_data_for_frontend`: duplicate tile→pixel converter for JSON-file fallback path. Eliminate by routing all step data through the API, even file-sourced.
     - FE reports `actual_pos` in tiles directly (FE does its own pixel→tile conversion). Either have FE report pixels and let the API convert, or document as intentional exception in `sot_be-fe.md`.
     - `maze.py` `turn_coordinate_to_tile` uses `math.ceil(px / tile_size)` vs API's `round((px - 16) / 32)` — can diverge on edge cases. Align on one formula.
   - Update `sot_be-fe.md` to reflect that the API Gateway converts tiles→pixels before delivery (Section 2.3 currently says `movement` is `[tile_x, tile_y]`, but actual transport is pixels).
   - Principle: BE thinks tiles only, FE thinks pixels only, API Gateway is the sole conversion boundary.

### Polish (after core realism validated)

9. **BE: Micro-polish stationary liveliness**
   - Fidget logic exists in `execute.py` (~L1260-1342): short stationary = no reposition, long stationary = probabilistic adjacent-tile fidget with cooldown.
   - Fine-tune after core realism fixes are validated.

10. **Housekeeping: Clean up previous phases in this doc**
    - Review Phases 1-19 — do they provide value or should be cleaned out to streamline simulation workflow, remove unnecessary load on servers, accelerate simulation, remove slack.
    - BE and FE separately.