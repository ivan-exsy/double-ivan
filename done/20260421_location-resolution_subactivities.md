# Sub-Activities Location Resolution

**Date:** 2026-04-21  
**Owner:** Ivan (product) / Claude (impl)  
**Branch:** `ivan/survival`  
**Related:** [SOT Realism](sot_realism.md), [SOT Prompts](sot_prompts.md)

## 1. Problem

Sub-activities resolved locations independently against the full world, causing mismatches (e.g., "checking the stove" in "cooking dinner at home" landing at a restaurant). The `inherits_parent_location` flag was optional and unenforced spatially.  

**Intent:** Sub-activities must stay within the core activity's sector/arena unless explicitly orthogonal.

## 2. Changes Implemented

Two fixes on `ivan/survival`:

### A. Decomposition Prompt Anchored to Parent Setting
- Pre-resolve core activity's sector/arena/address once per decomposition.
- Inject as "physical setting" into decomposition templates.
- Tighten rules: Default `inherits_parent_location=true` for micro-steps; flip only for distinct activities.
- Updated templates: `task_decomp_contextual_v1.txt`, survival variant, repair variant.

### B. Resolver Enforces Inheritance
- Pass `parent_address` to contract generation.
- If inheriting or travel verb: Reuse parent address (no LLM call).
- Otherwise: Resolve sub-activity independently.
- New counters for observability.
- Files: `plan.py` (core logic), `run_gpt_prompt.py` (wrappers), tests.

## 3. Cost
+0.7 LLM calls/step (~7% increase); acceptable for one extra resolution per hour.

## 4. Evidence from `20260420-1-subactions` Sim (900 steps, 4 personas)
- 65% contracts inherit parent location (59-72% per persona).
- Sub-activities stay in parent arena (e.g., library block fully contained).
- No naturalness regression: Step duration 22.9s (vs 26.0s baseline), full zone coverage.

## 5. Surfaced Issue: Voting Compliance 0% (from 25%)
All 4 agents missed Hobbs Cafe voting (step 660):
- 3 at library (studying/prepping), 1 at wrong pub.
- Survival overlay correct (Hobbs Cafe at 20:00), but not propagated to resolver.
- Daily plans mention Hobbs, but hourly schedules lack survival refs; deadline drifts to 19:00.
- Resolver ignores literal "Hobbs Cafe" in 28/28 cases (prefers library fallback).
- Fence amplifies: Wrong parent dooms whole block.

**Root Causes:**
1. No gathering location anchor in resolver.
2. Weak priority rule vs. fallbacks in nano model.
3. Inheritance propagates errors.

## 6. Recommended Fixes
### A. Quick Patch (~10 min)
Pass survival `gathering_location` as `anchor_context` in `_resolve_parent_setting` for voting keywords.

### B. Strengthen Resolver Prompt
Add rule: Explicit venue in text overrides fallbacks. Add regression test.

### C. Planner Enhancement
Emit explicit "travel to Hobbs Cafe" schedule item before voting.

**Priority:** A stops regression; B improves hygiene; C ensures determinism.

## 7. Ship Status
Fix verified (tests pass, profiled). 50 test failures pre-existing. Ready to merge; voting as follow-on.

## Plan: Schedule-Layer Proper Names
**Goal:** Use full sector names (e.g., "Hobbs Cafe") in daily/hourly plans to prevent resolver drift.

**Changes (6 files):**
- New helper: `_get_accessible_sector_list_str` (persona-only).
- Wire into daily/hourly wrappers (`run_gpt_prompt.py`).
- Add INPUT slot + naming rule to 4 templates (daily/hourly, standard/survival).

**Expected:** Proper nouns in schedules trigger literal short-circuit; decomp inherits correctly. No contract changes.

**Verification:** Smoke tests, short sim run, /verify, /prompt-verify.

## 9. Prompt / Model Variation Probe — 2026-04-21 evening

**Harness:** `tests/test_action_location_variants.py` — replays the resolver LLM call across {prompt variant × model} for 7 phrases (3 drift + 4 controls) plus 4 NEVER-rule edge probes, using OpenAI Responses API directly and bypassing the literal-sector short-circuit so only the LLM's judgement is measured.

### 9.1 Final sweep — strict pass rates (11 cases)

| variant | gpt-5-nano | gpt-5-mini |
|---|---|---|
| V0_baseline (current production prompt) | 3/11 | 9/11 |
| V1_no_fallback (drop FALLBACK list) | 4/11 | **5/11 regression** |
| **V2_few_examples (10→4 examples, rules kept)** | 3/11 | **10/11 ← shipped** |
| V3_priority_only (keep only PRIORITY rule) | 7/11 | 9/11 |
| V4_examples_only (no RULES section at all) | 4/11 | 10/11 (fails safety edge) |
| V5_tight (terse rewrite) | 4/11 | 9/11 |

### 9.2 Key findings

- **Fewer examples, same rules = best outcome on mini.** V2 (V0 minus 6 examples) scores 10/11. The single miss is "getting coffee → Dorm" — a weak-signal case V0 also misses intermittently.
- **V4 is unsafe despite tying V2 at 10/11.** It routes "stretching and doing pushups" to the Dorm because the removed `NEVER indoor exercise` rule was load-bearing. Rules earn their keep on safety edges even when they don't help on normal cases.
- **V1 regression replicated.** Removing FALLBACK while keeping NEVER rules consistently degrades mini to 5/11. The two rule blocks depend on each other — remove both or neither.
- **Nano has a hard ceiling (~7/11 best on V3).** No prompt variant closes the gap. Nano fails "stretching → Johnson Park" on all 6 variants. Model choice, not prompt, is the lever.
- **The Luba drift case** ("supervising morning staff and prepping cafe for midday rush" → Hobbs Cafe) passes on mini for 5 of 6 variants. Fixes are duplicate: `literal-sector short-circuit (§8.1)` + `schedule-layer proper names (§8.2)` + `mini+V2 LLM fallback (§9.3)` together give redundant coverage.
- **V5 terseness broke format compliance.** Mini began emitting prose refusals ("You didn't provide an activity…") when the `RESPONSE FORMAT:` line was loosened. Keep the strict format contract verbatim.

### 9.3 Implemented solution

Two changes on `ivan/survival`:

1. **Prompt template**: `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt` — replaced the 10-example block with the V2 4-example set (park run, library math, cafe customer, home desk). All rules (PRIORITY, FALLBACK, NEVER, "use exact names") kept intact.
2. **Model routing**: `reverie/backend_server/persona/prompt_template/model_router.py` — moved `run_gpt_prompt_action_location_unified` out of `TIER_A_TASKS` and into `TIER_B_TASKS`. The resolver LLM now runs on `gpt-5-mini` (Tier B) instead of `gpt-5-nano` (Tier A). The short-circuit at stage [A] continues to handle all verbatim-sector matches for free; only the ambiguous cases reach the LLM.

Verification: 56/57 tests pass in `tests/test_location_resolver.py` (the 1 pre-existing failure, `TestTraceCompleteness::test_deterministic_trace_fields`, also fails on clean `HEAD` and is unrelated). Router smoke test returns `{"tier":"B", "reason_code":"contract_tier_b"}` and model `gpt-5-mini`. Template smoke test produces exactly 4 example separators.

### 9.4 Pending verification — 900-step sim (day 1, 06:30–21:00)

Forking `base_family_sim` to exercise both the schedule-layer fix (§8.2) and the V2+mini resolver end-to-end across a full wake-to-voting window. Expected signals to watch:

- Luba's morning block resolves to Hobbs Cafe (not library) from first schedule item on.
- Step 60-style sub-activity regression (§8.3, new failure mode) no longer fires — correct LLM pick should survive through emit.
- Voting compliance at 19:00–20:00: all four personas at Hobbs Cafe.
- No naturalness-gate regression vs baseline.

### 9.5 Open decision — drop the inheritance fence?

Deferred until after §9.4 results. The fence was introduced in §2 to contain sub-activity drift, and §8.3 showed it can override a correct LLM pick when the parent is wrong. With mini+V2 now producing correct parent addresses, two outcomes possible:

- Parent resolution is reliably right → fence adds cost without benefit → consider dropping.
- Parent still misses occasionally → fence remains load-bearing → keep.

===============================================

## **TESTING**

### *900-step run complete: Tier B + V2 active; work_area=None caused 4/5 Luba cascades to Dorm. No regressions; defer fence drop.* see - `20260421-4-tierB\20260421-4-tierB_report.md`

1. **Luba morning:** Mini picked Hobbs Cafe correctly from step 0, but validation rejected staff areas (work_area=None) → 4 cascades to Dorm Room 2. Aggregate: 45% steps at Hobbs Cafe via short-circuit/inheritance.

2. **Step-60 regression:** None observed—short-circuit + typed_scorer resolved 93% without LLM.

3. **Voting compliance:** 100%—all four at Hobbs Cafe customer seating for 19:00-20:00 (2-2 tie, Ivan eliminated).

4. **Naturalness:** 3 plausible oscillations (sleep/nap/prep); std dev 2.1 tiles/step, within band.

5. **Inheritance-fence:** No correct-child overrides seen (cascades validation-driven). Defer drop until work_area-fixed run shows zero cascades.

#### *work_area propagation fixed — bootstrap now carries field through round-trip.*

**Changes shipped in `reverie/backend_server/reverie.py` (_bootstrap_missing_fork_from_supabase):**

1. Added `work_area` to the `persona_scratch` SELECT column list (~line 2019).
2. Added `"work_area": (scratch_row or {}).get("work_area")` to the `scratch_json` dict written to local `bootstrap_memory/scratch.json` (~line 2147).

No changes to `fork_simulation` RPC (already correct), no new files/config.

**Why this fixes the problem**

The failure was a side-channel null-out:

- `fork_simulation` RPC correctly copied Luba's `work_area='the Ville:Hobbs Cafe:cafe'` to the new fork row ✅.
- But `reverie.py` bootstrap read `persona_scratch` without `work_area` → local `scratch.json` omitted the field.
- Persona loaded from local file → `self.work_area = None`.
- Runtime saved scratch back via `save_persona_scratch` (includes `work_area`) → overwrote Supabase with `None` ❌.

After the fix: Bootstrap SELECT includes `work_area`, local file carries it, persona loads it, and save-back preserves it. Full round-trip stays clean.

**Verification**

End-to-end live test on throwaway fork:

1. Forked `base_family_sim` → Supabase row: `work_area = 'the Ville:Hobbs Cafe:cafe'` ✅.
2. Updated SELECT returns `work_area` in result set ✅.
3. `_bootstrap_missing_fork_from_supabase` completed successfully ✅.
4. Local `scratch.json`: `work_area = 'the Ville:Hobbs Cafe:cafe'` ✅.

Regression suite: `tests/test_location_resolver.py` — 56/57 passed (1 pre-existing unrelated failure).

**What's now complete end-to-end**

Luba's "supervises cafe" role survives the full pipeline:

Supabase baseline → `fork_simulation` RPC → Supabase fork row →  
bootstrap read → local `scratch.json` → persona load →  
`staff_only` validator bypass (`is_worker=True`) → LLM pick survives.

On the next sim run from a fresh fork, Luba's mini+V2 pick of behind the cafe counter will pass validation instead of cascading to Dorm Room 2. This removes the 4/5 cascades observed in `20260421-4-tierB`.

Worklog entry prepended under today's `ivan/survival` header in `worklog.md`.

### *Day 2 continuation: 20260422-1-tierB-day2*