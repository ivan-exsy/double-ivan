# Action ↔ Location regression — observations

**Date:** 2026-04-30 (updated)
**Reporter:** Nicolas
**Method:** Visual inspection of FE rendering across recent sims; primary baseline is `20260429-1` (first 200 of 800 steps reviewed).
**Status:** All three issues identified here are now addressed in code. See `<DONE>` entries below. End-to-end validation requires a fresh forked sim — fixes are forward-only and do not retro-clean `20260429-1` artifacts.

---

## Summary

Recent sims show three distinct issues at the action ↔ location boundary, **all now fixed**:

1. **Sleep ↔ morning-routine ping-pong** within the same persona — no real forward progress, oscillates between two actions for hundreds of steps. → *Fixed: survival deadlines now override late-rising personas' wake-up hour.*
2. **Action ↔ sector semantic mismatch** — actions executed in valid-but-semantically-wrong sectors (e.g. bathroom-sink action in the library). → *Fixed: inheritance fence now detaches sub-tasks whose anchor doesn't fit the parent arena.*
3. **Garbled / truncated action descriptions** — action text contains internal directives like `[mode=...]`, mojibake characters, and visibly truncated copy mid-word. → *Fixed: directive stripping generalised, `_wait_react` rewritten, mojibake bulk-cleaned.*

---

## *Ivan's TODOs*

### <DONE 2026-04-30:> Issue 3 — garbled action text — fixed.

Three forward-only fixes; existing simulation logs are not retro-cleaned. Re-run a sim to validate.

- **Planner directives** (`[mode=…] [anchor=…]`) no longer leak to the FE. Generalised `strip_action_tags` to remove `[…]` blocks anywhere in the string (was trailing-only) and applied it to the FE-bound `description` and `intent` at the movement-JSON construction site. `scratch.act_description` retains the directive for downstream parsers.
- **Malformed `(waiting to start …` fragments** (mid-word truncation, recursive `waiting to start waiting to start`) — the bug was in `plan._wait_react`, which did `act_description.split("(")[-1][:-1]` and amputated the last character when no `(` existed, and could double-prepend the prefix. Replaced with a named helper `extract_wait_target_phrase` in `action_contract_v1.py`.
- **Mojibake `Γî¢` pronunciatio** — replaced with `⌛` (U+231B). The same corrupted-UTF8 pattern persists in ~20 `print()` strings throughout `plan.py` (e.g. `≡ƒÜ¿`, `ΓÜá∩╕Å`); these are stdout-only and don't reach the FE — flagged as a bulk cleanup follow-up.
- Tests: `tests/test_action_text_sanitization.py` (11/11 pass) pins the three regression bugs against future edits. Movement-realism + spatial-grounding regression suites: 7/7 pass.

### <DONE 2026-04-30:> Issue 1 (sleep ping-pong) — three-stage fix landed after two validation sims uncovered residue.

Root cause was a conflict between the persona's identity-driven schedule and survival's morning challenge. Ivan's cached plan was built around `wake_up_hour=10` (his Uber-driver lifestyle), producing `f_daily_schedule[0] = ("sleeping", 600 min)` covering 00:00–10:00. The sim runs from 06:30, and the cognitive loop's "intentional sleep window" exemption from the stall-breaker only fires when `hour < 7`. After 7am, the various force-replan paths kept advancing the schedule index to "morning routine"; once the 60-min morning routine entry expired, `get_f_daily_schedule_index` pulled the persona back to entry 0 because elapsed minutes hadn't crossed 600. Cycle repeated every ~60 sim-minutes for hours.

Three stages of fix, each uncovered by the previous validation:

1. **Schedule-side (`apply_survival_wake_override`).** A new helper in `plan.py` clamps the persona's wake-up hour to `challenge_deadline_hour - 2` when survival mode is active. The survival controller now writes the deadline as a structured float onto `scratch.survival.challenge_deadline_hour` alongside the existing prose overlay. With the current sim (challenge at 11:00), Ivan's wake gets clamped from 10am to 9am, the schedule's first entry shrinks from 600 to 540 min. **Validation sim `20260430-1` confirmed the schedule reshape but Ivan still ping-ponged.**

2. **Runtime-side (stall-breaker `is_night_window`).** The cognitive loop's anti-stall exemption hardcoded `hour < 7`, so it stopped protecting Ivan at 07:01 even when his planned wake was 09:00. Replaced the hardcoded threshold with `max(7, persona.scratch.wake_up_hour)`, and added one line in `_long_term_planning` to persist the post-clamp wake hour onto scratch. **Validation sim `20260430-2` showed Ivan still ping-ponged.** Diagnosis from runtime scratch snapshots: the persistence line never executed because of stage 3.

3. **Persistence ordering (`_long_term_planning` early-return).** `_long_term_planning` short-circuits at `should_skip_daily_planning` for forked sims (their schedule loads from baseline as valid). The persistence line was placed after the skip check, so on every step the field stayed unset on scratch and the runtime exemption fell back to the hardcoded 7. Moved the wake-hour computation and persistence above the skip check so the field is always written on daily-planning entry.

Tests: `tests/test_survival_wake_override.py` (9/9), the wake-floor change is covered by the existing `tests/test_movement_realism.py` smoke (2/2). Existing sims (`20260429-1`, `20260430-1`, `20260430-2`) won't benefit — fixes apply to new plans only. Validation pending fresh fork.

### <DONE 2026-04-30:> Issue 2 (sector mismatch) — affordance-aware inheritance fence catches anchor / parent-arena conflicts.

Root cause was the F2 Pattern A residue. Katya's hourly entry "waking up fully and packing sketchbook for Oak Hill College library visit" got resolved by the parent-setting LLM to `Oak Hill College:library:bookshelf` because of the literal "library" mention. The LLM-driven decomp then produced 3 sub-tasks with structured anchors (`bed`, `bathroom 1: bathroom sink`, `closet`) and `inherits_parent_location=true` for all of them. The inheritance fence in `plan.py` honored that flag verbatim, no LLM call, no affordance check — pinning bed/sink/closet sub-tasks to a library tile.

Fix: when the decomp's structured `anchor` names an object the parent arena doesn't contain (or names a different arena explicitly), the fence now overrides `inherits_parent_location=false` and re-resolves independently. Travel sub-tasks ("walk to X") are exempt because their anchor is the destination by design. Single helper `_anchor_compatible_with_parent_arena` (~14 LOC, uses existing `parse_address`/`format_address`) plus a 6-line wiring change inside `_contextual_rows_to_contract_pairs`.

`tests/test_anchor_inheritance_fence.py` (15/15 pass) is the probe-set Nicolas suggested — 5 mismatch-detach cases, 4 compatible-inherit cases, 6 conservative-default cases. All adjacent regressions still green: parent-arena inheritance (4/4), movement realism (2/2), survival wake override (9/9). Existing sims (`20260429-1`) won't change — applies to new decomps only. Re-run a forked sim to validate.

### <DONE 2026-04-30:> Better fallback for missing `subtitle_card` in YouTube descriptions.

Root cause was *not* a `script.json` content gap — the showrunner prompt has a hard "MAX 2 scenes with a card" constraint to avoid card fatigue in the on-screen visual. The issue was that `generate_description.py` re-used the same `subtitle_card` field for the YouTube description label, where the constraint doesn't apply. Now falls back to first narrator line (cut at first sentence-end, truncated to 40 chars at word boundary, dangling function-words stripped). Existing trailers re-emit clean labels without re-running the LLM showrunner.

`20260428-3-ivan-day1-fixed` now reads `0:14 — By afternoon, he's at Hobbs Cafe` / `0:32 — He builds a public plan with Gosha` / `0:50 — Late night` instead of `Development / Turn / Close`. Tests at `tests/test_generate_description.py` (11/11 pass).

### <DONE 2026-04-30:> Audit of other description-output sites in `reverie.py`.

Two more user-visible code paths sanitised: the `COMPLETED.json` lifecycle marker (final-step persona state read by the FE on sim completion) and the chat-scoring path that reuses `act_description` when it contains "chat". Five other description-write sites checked; all are either internal state, test-only, marked dead code, or already-sanitised data flowing through. No new tests — covered by the existing `strip_action_tags` suite.

### <DONE 2026-04-30:> Mojibake bulk cleanup in `plan.py`.

31 corrupted-UTF8 sequences replaced with the original Unicode emoji across 12 unique patterns (e.g. `ΓÜá∩╕Å` → `⚠️`, `Γ£à` → `✅`, `≡ƒÿÉ` → `😐`). Mappings verified by byte-level CP437→UTF-8 round-trip before applying. Most sites are warning/error `print()` calls; one notable exception is the four `return "😐"` fallbacks in `generate_action_pronunciatio` — these are FE-bound (the emoji bubble shown above the persona's head when LLM emoji generation fails), so this fix has a small visible component beyond developer logs. Replacement is consistent with the 22 pre-existing real-emoji prints already in `plan.py` and with `.env.local`'s `PYTHONIOENCODING=utf-8` setting that the sim entry point loads. Regression suite 29/29 pass.

Residual pre-existing pattern (out of scope, flagged for later): the `"😐"` fallback emoji is duplicated across `plan.py` (4×), `run_gpt_prompt.py` (1×), and parallels with `execute.py:774` (`"💭"`) and `plan.py:4209` (`"⌛"`) — could be consolidated into a single named constant if the cosmetic-fallback layer ever gets refactored.



## Sim `20260429-1` — primary baseline (first 200 steps)

> **Note:** the symptoms below are the pre-fix evidence. They reproduce on `20260429-1` because that sim was generated before any of the fixes landed. A fresh forked sim should show none of these.

### Ivan — sleep ↔ morning-routine ping-pong

| Step | Action | Location | Observation |
| --- | --- | --- | --- |
| 0   | 😴 Sleeping | Dorm For Oak Hill College · Dorm Room 1 · Bed | Correct (initial state). |
| 21  | 🏃‍♀️ Completing morning routine in Apartment 1 (stretching, shower, prepare running gear) | Dorm For Oak Hill College · Bathroom 2 · Shower | Correct. |
| 82  | 😴 Sleeping | Dorm For Oak Hill College · Dorm Room 1 · Bed | Reverts back to "sleeping" — Ivan was already up at step 21. |
| 103 | 🏃‍♀️ Completing morning routine in Apartment 1 (stretching, shower, prepare running gear) | Dorm For Oak Hill College · Bathroom 2 · Shower | Reverts to morning routine again. |
| 163 | 😴 Sleeping | Dorm For Oak Hill College · Dorm Room 1 · Bed | Continues oscillating. |

**Pattern:** Ivan ping-pongs between "sleeping" and "morning routine" across the entire morning window. Each individual `(action, location)` pair is internally consistent, but the timeline is not — once a persona has progressed to morning routine, returning to "sleeping" is a regression of state, not a normal step.

### Katya — actions executed in semantically wrong location (library)

| Step | Action | Location | Mismatch |
| --- | --- | --- | --- |
| 42 | 🚿 Wash face and quick bathroom freshen (sink) | Oak Hill College · Library · Bookshelf | Bathroom action in a library. |
| 52 | 🧥🖊 Change into layered clothes and gather sketch supplies from closet | Oak Hill College · Library · Bookshelf | Wardrobe / dressing action in a library. |

**Pattern:** the chosen sector exists in Katya's tree (the library is a place she visits) but does not afford the action being performed (no sink, no closet). Same shape as earlier-sim observations below.

### Gosha — garbled / truncated action text

| Step | Action text (verbatim from FE) | Location |
| --- | --- | --- |
| ~170 | `Rework missed math problems with scratch work [mode=workstation_hop anchor=library table] (waiting to start on the way t` | Oak Hill College · Library · Library Table |
| ~175 | `Γî¢  Waiting to start waiting to start skim practi` | Oak Hill College · Library · Library Table |
| ~180 | `Rework missed math problems with scratch work [mode=workstation_hop anchor=library table] (waiting to start skim practic` | Oak Hill College · Library · Library Table |

**Issues observed:**

- Internal directives (`[mode=workstation_hop anchor=library table]`) leak into the user-visible action text — these look like prompt scaffolding that should be stripped before rendering.
- Action text is visibly truncated mid-word ("…on the way t", "…skim practi"). Suggests a hard length cap applied without a clean tokenizer.
- Step ~175 contains mojibake (`Γî¢`), consistent with a UTF-8 byte sequence decoded as Windows-1252 somewhere in the pipeline (likely an emoji that lost its encoding).
- Repeated phrasing within a single action ("waiting to start waiting to start") — duplication that suggests a string-builder concatenating the same fragment twice.

These are distinct from the action-location resolver: this is the **rendering / description pipeline**, not the sector picker.

---

## Earlier sims — historical context

(Observed before `20260429-1`; included for pattern continuity. Not re-validated against the new baseline.)

| Sim | Persona | Action | Location | Mismatch |
| --- | --- | --- | --- | --- |
| `20260427-1-stage3` | Ivan | Use bathroom sink and brush teeth | Dorm For Oak Hill College · Garden · Dorm Garden | No bathroom sink in the garden. |
| `20260427-1-stage3` | Katya | Use bathroom sink and quick shower | Dorm For Oak Hill College · Dorm Room 3 · Closet | No sink/shower in a closet. |
| `20260427-1-stage3` | Ivan | Bed → garden ping-pong (transit) | oscillating | Same ping-pong shape as Ivan in `20260429-1`. |
| `20260428-1` | Katya | Sit up and stretch in bed | Oak Hill College · Library · Bookshelf | No bed in the library. |
| `20260428-1` | Ivan | Wake up and stretch in bed | Dorm For Oak Hill College · Garden · Dorm Garden | No bed in the garden. |

---

## Pattern (root causes that produced the three symptoms)

Three orthogonal failures, all fixed:

- **Action-plan ping-pong** — late-rising persona's schedule (Ivan, `wake_up_hour=10`) plus survival's morning-challenge deadline plus the cognitive loop's "intentional sleep window" exemption only firing before 7am combined to push the persona out of bed every ~60 sim-minutes. Resolved by clamping `wake_up_hour` to `challenge_deadline - 2` when survival mode is active. Schedule no longer claims sleep past the deadline; the loop has no incentive to pull the persona back.
- **Action ↔ sector semantic mismatch** — F2 Pattern A residue. The 2026-04-21 work flipped `inherits_parent_location` to default-true to keep sub-activities co-located with the parent. That helped most cases but produced this regression when the parent's address was misresolved (e.g. "library visit" routing to the library) and the children's structured anchors (`bed`, `closet`, `bathroom sink`) didn't fit. Resolved by an affordance check in the inheritance fence — anchor must exist in the parent arena, otherwise re-resolve independently.
- **Description / rendering issues** — three independent rendering-pipeline bugs: directive `[mode=…]` blocks were only stripped at trailing position; `_wait_react` did `act_description.split("(")[-1][:-1]` and amputated the last character when no `(` existed; ~31 mojibake byte sequences from a CP437/UTF-8 round-trip lived in `plan.py` `print` strings and one FE-bound emoji fallback. All three resolved in the rendering pipeline.

---

## What landed (regression harness)

Implemented per Nicolas's three suggestions:

1. **Probe set for sector resolution** → `tests/test_anchor_inheritance_fence.py` (15 tests): 5 mismatch-detach cases (bed / closet / bathroom-sink / shower / kitchen-sink anchors with a library parent), 4 compatible-inherit cases, 6 conservative-default cases. Reproduces Issue 2 deterministically without a full sim.
2. **Action-plan stability check** → addressed at the source (wake-override) rather than as a runtime monitor. The ping-pong's mechanical cause is gone, so a stability metric isn't load-bearing for Issue 1 anymore. If a future shape needs catching, the sim's per-step `action_id` digest is already a usable flip-counter.
3. **Action-text sanitisation** → `tests/test_action_text_sanitization.py` (11 tests) pins directive stripping, `(waiting to start …)` formation, and pronunciatio glyph integrity.

Combined regression suite for the morning-routine bug shape: 30/30 tests pass (15 fence + 9 wake override + 4 parent-arena inheritance + 2 movement realism). Plus 11 action-text sanitisation tests.

## Validation pending

A fresh forked sim is needed to verify the fixes end-to-end. Any base sim works; suggested: fork `base_family_sim` into a new code, run ~200 steps, and confirm:

- Ivan no longer oscillates sleep ↔ morning routine in the morning window. His first scheduled action should last ~540 min (not 600) and end around 09:00.
- Katya's morning sub-tasks (`bed`, `bathroom sink`, `closet`) resolve into the dorm, not the library.
- Gosha's action-text rendering is clean — no `[mode=…]` blocks, no mojibake, no mid-word truncation.
