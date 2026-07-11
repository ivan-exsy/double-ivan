# 15-Sim Polish — Survival Release Readiness — **DONE**

> **Goal:** bring a 15-player Survival Game sim (`soul15_seed_20260224`, `the_ville`) to trailer-ready state. Fork fresh → run on VPS via the API gateway → score against the release-ready checklist → sign off or loop back.
> **MVP SIGN-OFF (2026-07-10):** Proof sim **`20260709-1`** (VPS, SHA `1db8cbe2`, durable post-vote planning). **RCA-1 PASS** (0 vote-prep@Hobbs 2311–2400; 14/14 bed @2450 & 2489). Meals **15/15** Day-1 snapshots; sleep **14/14** @1050; first-vote **15/15**; P0s GREEN; halluc **0.0%**; Class A desk-excl. **17** ≤20. Checklist: `double-ivan/20260710_checklist.md`. Tracker: `20260705_close-for-mvp.md` → **DONE**.
>
> **Prior baseline — `20260708-mvp-a`** (2,600 steps, scored 2026-07-09): location/halluc/meals/sleep/P0s/first-vote green; **RCA-1 FAIL** (Owen classroom vote-prep language) — closed by the durable post-vote fix on `20260709-1`.
>
> **Historical notes below** (Run 1 / merge path) retained for forensics; do not treat as current blockers.
>
> **Follow-up (post-MVP):** Path B location residual · OpenRouter Phase 8 (embedding reindex / gateway / retire `OPENAI_API_KEY`) · `railway`→`main` ops.

---

## Release-ready definition (5 gates)

1. Post-vote recovery ≤ 5 sim minutes — zero vote-prep at Hobbs at steps 2,311–2,400; ≥ 12/14 en-route home or in bed by step 2,420.
2. Post-vote plan is realistic (descriptions read "leave Hobbs" / "walk home" / "unwind" / "sleep", not a single 1,440-min sleep block).
3. Premiere day: ≥ 11/14 in bed at step 1,050; ≥ 13/15 personas with an explicit lunch block and ≥ 13/15 with a dinner block.
4. Open-ended season — no `SURVIVAL_TOTAL_DAYS` cap; sim runs until one winner remains; stall-safety after 2 dry days.
5. All previously-closed P0 fixes stay green (vote gate timing, overlay, day persistence, labeling, elimination wiring).

---

## Current status

| Batch | Track | Status |
|-------|-------|--------|
| **1** — post-vote plan lag | §RCA-1 | ✅ **PASS on `20260709-1`** — durable post-vote planning (`1db8cbe2`); 0 vote-prep@Hobbs; 14/14 bed @2450 & 2489. (Prior FAIL on mvp-a closed.) |
| **2** — open-ended seasons | — | ✅ **Re-confirmed `20260709-1`** — `total_days=0`, elimination wiring intact. |
| **3a** — premiere meals | §RCA-2 | ✅ **PASS `20260709-1`** — lunch **15/15**, dinner **15/15** (Day-1 snapshots). |
| **3b** — premiere sleep invariant | — | ✅ **PASS `20260709-1`** — 14/14 in bed @ step 1,050. |
| **4** — validation + sign-off | — | ✅ **MVP SIGNED OFF 2026-07-10** on `20260709-1`. |

**Bottom line:** Survival MVP **signed off**. Post-MVP: Path B location · OpenRouter Phase 8 · `railway`→`main`.

### Closed P0 fixes (re-confirmed green on `20260630-1`)

| ID | Fix | `20260629-1` validation | `20260630-1` re-confirmation |
|----|-----|-------------------------|-------------------------------|
| P0-1 vote gate | Time-boxed to `vote_deadline_hour - 1` (19:00) | Elimination at step 2,310 (~21:00 sim), not 18:00 | Elimination recorded for survival day 1 (Max Shoemaker, 4 votes); 14 remain. GREEN. |
| P0-2 zombie player | N/A — wiring was correct | Max last coord 2,309; 14 survivors from 2,310 | 1 eliminated, 14 `remaining_players` — wiring intact. GREEN. |
| P0-4 overlay staleness | Overlay uses `current_day`; cache cleared at elimination | Day-2 overlay: "Day 1 — 14 players remain. Eliminated so far: Max Shoemaker." | `day_highlights`: day 1 `is_grace=True label='Premiere'`, day 2 `season_day=1 label='Survival Day 1'`. GREEN. |
| P1 day persistence | `_advance_day` calls `_persist_state()` | `current_day = 2` at sim end | `survival_season_state.current_day = 2`. GREEN. |
| P0-6 day labeling | BE labels + FE HUD/chapter list | Day 1 = "Premiere"; Day 2 = "Survival Day 1"; memory prose "Survival Day 1 (engine Day 2)" | `day_label` column: "Premiere" / "Survival Day 1" — matches. GREEN. |
| Batch 2 open-ended | `total_days=0` default; day-cap win gated on `total_days > 0` | `total_days=0`, no premature winner | `total_days=0`, `winner=None` at step 2,600. GREEN. |
| Deploy / API | `/survival` mounted; rogue uvicorn killed; `double-api` serves current code | Gateway returns survival + status fields throughout | Run completed end-to-end on VPS `66331d37`; season state + day_highlights + snapshots all persisted. GREEN. |

---

## Run 1 results — `20260630-1` (scored 2026-07-01)

> 2,600 steps · VPS · OpenAI · code `66331d37` · completed 2026-07-01 ~01:50 sim · data from Supabase (`survival_season_state`, `day_highlights`, `personas_coords`, `persona_day_snapshots`). Scorer: `tests/analyze_20260630_1.py`.

### Run at a glance

- **Status:** completed, step 2,600, sim clock ended 01:50 on engine Day 2.
- **Season:** open-ended (`total_days=0`), 1 elimination (Max Shoemaker, survival day 1, 4 votes), 14 survivors, no winner — exactly as designed.
- **Closed P0 fixes: all 5 GREEN** (table above) — vote-gate timing, day labeling, day persistence, elimination wiring, open-ended overlay.

### Gate: RCA-1 (P0, decisive) — partial pass

| Check | Target | Result |
|---|---|---|
| Vote-prep at Hobbs, steps 2,311–2,400 | 0 survivors | **2/14 lingered** — Olivia King (steps 2,311–2,369, ~59 min of "preparing talking points for the evening vote" at Hobbs) and Andrew Abrams (steps 2,333–2,354, then again 2,420 "prepare and cast evening vote"). The other 12/14 went home immediately. |
| In bed / en-route home by step 2,450 (23:20 sim) | ≥10/14 | **13/14** ✓ (Irene Dove making alliance notes at the library — the lone holdout) |
| In bed at step 2,489 (midnight) | ≥10/14 | **14/14** ✓ |

**Read:** The supersede-vote-directive fix worked for 12/14 — a night-and-day change vs `20260629-1` (13/14 still doing vote-prep at midnight). But 2 survivors (Olivia, Andrew) weren't superseded in time and lingered 30–90 min before going home. Both were in bed by midnight. Strict "zero" gate fails; recovery gates pass strongly.

**Likely root cause of the 2 lingerers:** long action duration delayed the invalidation-triggered replan past the linger window, or the replan re-read the original `(b) attend the voting block` directive before the supersede regex fired. Needs targeted investigation on the merged branch — check `_inject_post_vote_outcome` timing vs the survivor's `act_duration` at the elimination step, and whether the supersede regex matched the directive text Olivia/Andrew actually had.

### Gate: Meals (premiere day plan) — lunch borderline, dinner regressed

| Meal | Target | Result | Missing |
|---|---|---|---|
| Lunch (~12:00 block) | ~14/15, accept ≥13 | **12/15** | Vince Vale, Ivan Pitts, Vincent Slater (all working through noon — lecture prep, pharmacy shift, lesson draft) |
| Dinner (~18:00 block) | ~10/15, accept ≥10 | **5/15** by word "dinner", **6/15** by broad eat-at-18:00 detection | 9–10 working through 18:00 — counting register, restocking shelves, reviewing lesson drafts, editing slides |
| Sleep block in plan | ≥11/15 (3b) | **15/15** ✓ | — |

**Read:** The `daily_req` cleanup fix (`05b3a107`) deployed correctly — every persona's `daily_req` is now a multi-item breakdown that explicitly includes "have lunch at 12:00 pm" and "have dinner at 6:00 pm" (e.g. Diana's plan: `[3] have lunch at Hobbs Cafe at 12:00 pm`, `[7] have dinner at Harvey Oak Supply Store or nearby at 6:00 pm`). The hourly decomposer honors lunch for 12/15. But at 18:00, work-shift-close momentum wins for ~10/15 — they fill the dinner hour with "count cash drawer," "restock product shelf," "review lesson draft" instead of eating. This is the residual gap the polish doc already acknowledged, but **worse than the diag7/8/9 baseline** (13/15 dinner) — a real regression, not just the accepted residual.

**Fix direction:** the "FOLLOW THE PLAN" rule (`0f198b8f`) needs more teeth at the 18:00 work→dinner handover for shift-workers. The `daily_req` item is present; the hourly LLM is overriding it with work momentum. Tighten before Run 2 — don't defer.

### Gate: Batch 3b sleep — PASS

- **Plan-level:** 15/15 personas have a sleep block in `f_daily_schedule` (target ≥11).
- **Runtime @ step 1,050 (midnight after premiere):** 13/14 in bed (target ≥11). Dean Sanford was still drafting a stocking plan at the Harvey Oak Supply Store counter — the lone holdout.

### MVP gate decision

Per the original OpenAI run-budget table, this is **Run 1, two failures with clear and small root causes** → fix and re-run. **Deviation from the original plan:** instead of Run 2 on `railway`/OpenAI, merge first (per `20260630_merge-openrouter-railway.md` — integration branch `ivan/openrouter-railway-merge` already coherent, Phases 2–3 done) and fix the two residuals on the unified branch. This enters Phase B early by choice (merge is complete, unified branch is the natural place to work), not by the Run-3-failed escape clause. OpenAI confound-avoidance no longer justifies $14/run now that the integration branch tests green.

**Run 2 target (on the merged branch):** RCA-1 strict zero vote-prep at Hobbs 2,311–2,400 · lunch ≥13/15 · dinner ≥10/15 · sleep ≥11/14 @ step 1,050 · all closed P0s green. Model recommendation: OpenAI for the survival gates (matches RCA baseline); OpenRouter for the 250-step plumbing smoke (merge doc Phase 5).

---

## Path to MVP (Option 2 — finish survival on `railway`/OpenAI, integrate OpenRouter after)

> **⚠ Update 2026-07-01:** Phase A ended after Run 1 (`20260630-1`) — partial pass, not a clean sign-off. Per the decision above, we deviate from the original "close on OpenAI first" sequence and **enter Phase B early by choice** (not the Run-3-failed escape clause): the integration branch `ivan/openrouter-railway-merge` is already coherent, so we merge, fix the RCA-1 linger + dinner regression on the unified branch, then run Run 2 there. The OpenAI run-budget table below is retained for reference but no longer governs — Run 2 happens on the merged branch, model per Phase 5 of the merge doc.

> **Goal:** release the 15-person survival sim MVP ASAP. The MVP is a behavior-ready sim that produces trailer footage. The OpenRouter migration (cost reduction: ~$8/day on OpenAI vs ~$1.50/day on OpenRouter) is **not on the MVP critical path** — it lands after sign-off, on its own budget.
>
> **Why validate on OpenAI first:** the RCA was done on OpenAI (`20260629-1`), so a validation failure cleanly points at the fix — no "is it the fix or the model?" confound. Batch 3a (meal prompt) is model-dependent; validating it on DeepSeek before the fix is confirmed would risk an ambiguous failure and a wasted ~10 h run.

### Phase A — close the MVP on `railway` (OpenAI)

1. Ship **RCA-1** (Batch 1 re-fix: supersede the vote instruction in `daily_plan_req` at injection time). Add an integration-style test that runs the real planner replan path (not a stub) — closes the test gap that let the original Batch 1 ship.
2. Ship **RCA-2** (Batch 3a re-fix: dedicated REQUIRED MEAL SLOTS section in `daily_planning_v6.txt` for prompt salience).
3. Fork fresh 15-player sim from `soul15_seed_20260224` via the API gateway (`fork` → `start` with `max_steps: 2600`), VPS, **OpenAI**.
4. Score against the two re-run verification targets (RCA-1: zero vote-prep 2,311–2,400, ≥10/14 in bed @ 2,489; RCA-2: ≥13/15 lunch + dinner in premiere plan). Fold Batch 3b (premiere sleep) into the same run if its RCA is ready.
5. **MVP gate:** both targets pass → sign off the 15-person sim.

### OpenAI run-budget decision point

**Budget: up to 3 OpenAI validation runs** (~$8/day × ~1.8 sim-days per 2,600-step run ≈ $14/run; ~$42 worst case).

| After run N | Outcome | Action |
|-------------|---------|--------|
| **Run 1** | Both RCA-1 + RCA-2 targets pass | ✅ Sign off MVP → Phase B |
| **Run 1** | One or both fail, root cause clear and small | Fix on `railway`, run again (Run 2) |
| **Run 2** | Pass | ✅ Sign off MVP → Phase B |
| **Run 2** | Fail, root cause clear and small | Fix on `railway`, run again (Run 3 — last OpenAI attempt) |
| **Run 3** | Pass | ✅ Sign off MVP → Phase B |
| **Run 3** | **Still failing** | **Stop OpenAI spending. Integrate OpenRouter (Phase B early) and continue survival fixes on the unified branch with DeepSeek.** Rationale: at 3× the cost per run, the OpenAI confound-avoidance benefit no longer justifies the spend; switch to the cheaper model and accept the diagnostic confound (mitigate by isolating fixes one at a time on DeepSeek). |

**Hard rule:** dont exceed 4 OpenAI validation runs for Phase A. If the survival fixes aren't landing by Run 4, the problem is no longer "clean signal vs confound" — it's a deeper fix-design issue, and iterating at $14/run on OpenAI is not worth it. Cut over to OpenRouter and iterate at ~$2.50/run instead.

### Phase B — integrate OpenRouter onto `railway` (after MVP sign-off, or early if Run 3 fails)

1. Rebase `ivan/openrouter-deepseek-v4` onto the updated `railway` (expect a small conflict in `reverie.py`; survival + LLM files are mostly disjoint — only 2 files overlap).
2. **Clean up the ~30 `supabase/_tmp_*.sql/py` scratch files** on the OpenRouter branch before merging — temp schema-extraction scripts that shouldn't land in the repo.
3. Merge to `railway`; run a 250-step OpenRouter smoke to confirm Run 1c config survived the merge.
4. If entering Phase B early (Run 3 failed): re-run the survival validation on DeepSeek, isolating RCA-1 and RCA-2 fixes one at a time to control the confound.

### Phase C — finish the OpenRouter migration (post-MVP, its own budget)

Per `D:\Coding\double-ivan\20260627_openrouter.md`: Tier 1 location code (label↔anchor, staff gates) → embedding reindex (point of no return) → gateway cutover (Chat with Double) → longer OpenRouter validation → VPS deploy with OpenRouter env → retire `OPENAI_API_KEY` → 24 h monitor.

---

**Out of scope for this release:** `daily_plan_req` dilution check (P2 — defer until a sim reaches Survival Day 5+); FE survival HUD; old-sim highlight relabeling (ops/FE tracks).

## RCA — failing items

### RCA-1: Batch 1 — post-vote plan lag (P0, highest priority)

**The issue:** After a player is eliminated (~step 2,310, 21:00 sim), survivors keep doing "vote-prep" at Hobbs for the rest of the evening instead of going home. This is the trailer-blocking behavior bug — 3+ hours of stale vote preparation after the outcome is decided.

**What we tried (Batch 1, shipped 2026-06-29):** `_inject_post_vote_outcome` now (a) appends a "vote concluded" line to `daily_plan_req`, (b) builds a post-vote evening schedule (head home → unwind → reflect → sleep), (c) invalidates the current action so the next step replans, (d) sets a `_post_vote_injected_for` gate so `_apply_survival_lifestyle` doesn't clobber it, (e) broadcasts a `vote_concluded` memory. 14/14 unit tests pass.

**What's still failing (`20260629-1`):** The injection **fired** — confirmed by 14 `vote_concluded` memory broadcasts and the appended `daily_plan_req` line. But survivors continued vote-prep through midnight:

| Step | In bed | At Hobbs | Vote-prep |
|------|--------|----------|-----------|
| 2,489 (midnight) | **0/14** | 13/14 | 8/14 |
| 2,490 | 6/14 | 8/14 | 5/14 |
| 2,491 | 11/14 | 3/14 | 2/14 |

This is **worse** than the prior run `20260628-4` (2/14 in bed @ 2,489). The persisted day-2 `f_daily_schedule` is the **original morning vote-prep plan** — the post-vote evening schedule the fix built is absent.

**Root cause:** The fix appends the "vote concluded" line to `daily_plan_req` but does **not** remove the original survival priority "(b) attend the voting block at Hobbs Cafe before the voting deadline at 20:00." When `force_replan_next_step` triggers a replan, the planner reads the full `daily_plan_req`, sees the dominant "attend vote at Hobbs by 20:00" instruction, and regenerates vote-prep — clobbering the post-vote evening schedule. The `_post_vote_injected_for` gate only blocks `_apply_survival_lifestyle`, not the regular planner replan. **Unit tests missed this because they stubbed the planner and never exercised the replan-reads-plan-req loop.**

**Fix plan (recommended — option 1 of 3):** Supersede the vote instruction in `daily_plan_req` at injection time — drop "(b) attend the voting block" and replace with "(b) the vote has concluded — return home and rest." The planner then reads a plan req whose dominant instruction matches the post-vote state. Pair with an **integration-style test** that runs the real planner replan path (not a stub) and asserts the post-vote schedule contains "head home"/"sleep" and zero "vote" blocks past the elimination step.

*Alternatives considered:* (2) suppress the replan and force `_determine_action` to read the post-vote schedule directly — bypasses the planner, risk of schedule drift; (3) post-generation validator that rejects vote-prep schedules and re-prompts — robust but extra LLM cost per step.

**Re-run verification target:** zero vote-prep at Hobbs for steps 2,311–2,400; ≥ 10/14 in bed or en-route home by step 2,450; ≥ 10/14 in bed at step 2,489.

**Re-fix (2026-06-30, shipped):** Implemented option 1 — at injection time, regex-replace the `(b) attend the voting block …` clause in `daily_plan_req` and `lifestyle` with `(b) the vote has concluded — return home and rest` (controller `_VOTE_DIRECTIVE_RE` / `_POST_VOTE_DIRECTIVE`). Added `tests/test_survival_rca_refix_20260630.py` — an **integration-style test** that runs the real replan path (`schedule_validator.is_new_day` → `_long_term_planning`) with only the LLM calls mocked, asserting the post-vote schedule has no vote-prep and contains home/sleep. This closes the test gap that let the original Batch 1 ship green. Integration test passes.

**End-to-end result — `20260630-1` (Run 1, 2026-07-01):** The supersede fired for **12/14 survivors** (immediate home) — a decisive improvement vs `20260629-1` (13/14 vote-prep at midnight). But **2/14 lingered** at Hobbs: Olivia King (steps 2,311–2,369) and Andrew Abrams (steps 2,333–2,354 + 2,420). Both went home and were in bed by midnight (14/14 @ step 2,489). Strict "zero vote-prep 2,311–2,400" gate **fails**; recovery gates pass (13/14 @ 2,450, 14/14 @ 2,489). The mechanism — `last_planned_date=None` → `is_new_day` "First day" → same-day `_long_term_planning` reads `daily_plan_req` — is confirmed in code and worked for 12/14. The 2 lingerers point at a timing edge: long `act_duration` delaying the invalidation-triggered replan, or the replan re-reading the original directive before the supersede regex fired. **Fix on the merged branch before Run 2.**

### RCA-2: Batch 3a — premiere meals (P1)

**The issue:** On the premiere (engine Day 1, grace day), agents don't plan explicit lunch or dinner blocks — the day reads as work-only/fasting, which looks unnatural in the trailer.

**What we tried (Batch 3a, shipped 2026-06-29):** Added ACTIVITY RULES to `v2/daily_planning_v6.txt` making a ~12:00 pm lunch block and a ~6:00 pm dinner block mandatory ("MUST include… not skippable, not pushable past 2/8 pm; breakfast does not satisfy either"). 6 prompt-shape tests pass.

**What's still failing (`20260629-1`):** Checked the premiere day-1 plan (`persona_day_snapshots` `f_daily_schedule`). Only **2/15** personas have a lunch block (Alex Butcher, Diana Ogden); only **1/15** have a dinner block (Diana Ogden). Target was ≥ 13/15 each.

**Root cause:** The "MUST include" meal rules are buried among the general ACTIVITY RULES; the LLM ignores them when the lifestyle/work context dominates plan generation. The rules lack prompt salience.

**Fix plan (recommended — option 1 of 3):** Promote meals to a dedicated "REQUIRED MEAL SLOTS" section near the top of the prompt (before the plan-generation seed), listing lunch (~12:00) and dinner (~18:00) as structural constraints separate from the general rules. If a follow-up run still shows < 13/15, escalate to a post-generation plan validator (option 2).

*Alternatives considered:* (2) post-generation validator that re-prompts if lunch/dinner missing — guaranteed but extra LLM call; (3) hardcode meal slots into the schedule skeleton — deterministic but overrides agent autonomy and conflicts with naturalistic decomposition goals.

**Re-run verification target:** ≥ 13/15 personas with an explicit lunch block and ≥ 13/15 with a dinner block in the premiere day-1 `f_daily_schedule`.

**Re-fix history (2026-06-30):** Three iterations to reach the target — a useful forensic trail.
1. **Salience in the daily-plan template** (`daily_planning_v6.txt` → dedicated REQUIRED MEAL SLOTS section). 50-step diag `20260630-diag2`: 2/15 lunch, 1/15 dinner — no change. **Wrong template:** the survival premiere routes to `survival_daily_plan_v1.txt` (via `resolve_template` because `persona.survival_mode=True`), which had no meal rules. The grace day, though, uses the baseline template (`on_step` returns early on day 1, so `survival_mode` stays False) — so the baseline edit was reaching the premiere but meals still didn't land.
2. **Meal guidance in the HOURLY templates** (`generate_hourly_schedule_v2.txt` + `survival_generate_hourly_schedule_v1.txt`) — natural phrasing ("normally eat lunch ~12:00… skip if urgent"). diag `20260630-diag4`: 4/15 lunch, 7/15 dinner. **Forensic capture proved** the meal guidance IS in the live hourly prompt (the ACTIVITY RULES block is only stripped in the capture/dump normalization, not the live request), but the LLM ignores it at lunch ~11/15 — at 12:00 PM it produces "travel to The Willows Market" because work momentum + prior_schedule dominate one guidance line. Prompt-only plateaued.
3. **Deterministic post-generation meal pass** (`plan.py::_ensure_meal_blocks`) — after `generate_hourly_schedule`, split the 12:00 and 18:00 blocks and insert a 60-min meal block when the covering block is not already a meal or an urgent/immovable event (challenge, vote, sleep). diag `20260630-diag5`: **14/15 lunch, 15/15 dinner — PASS.** This was a **crutch (C-1)** — it shipped meals but bypassed the persona's cognition.

4. **Elegant fix (replaced the crutch, 2026-06-30):** forensic capture on `20260630-diag4`/`diag5` proved the daily-plan LLM *was* generating meals + sleep all along, but the cleanup discarded the response (it expected a `1) 2) 3)` numbered list; gpt-5-mini emitted a time-anchored plan with a preamble), collapsing `daily_req` to the 1-item seed. Two fixes resolved the root cause and let the crutch be removed:
   - **Daily-plan cleanup** (`05b3a107`): module-level `_clean_up_daily_plan_response` with a time-anchored fallback + a strong RESPONSE FORMAT block in the baseline template → `daily_req` is now multi-item with meals + sleep naturally (15/15 lunch, 13/15 dinner, 12/15 sleep on `20260630-diag7`).
   - **Hourly "FOLLOW THE PLAN" rule** (`0f198b8f`): makes the hourly schedule LLM treat `daily_req` as authoritative — each hour matches the breakdown item covering that time, including meals and the bedtime/sleep item. `20260630-diag8`: 11/15 sleep at 23:00 (was 3/15), organic dinner blocks.
   - **Crutch removed** (`66331d37`): `_ensure_meal_blocks` deleted; meals + sleep now emerge from the persona's own cognition. `20260630-diag9` re-confirms meals land ≥13/15 with no pass. C-1 is no longer in the crutch registry (active crutches: none).

**End-to-end result — `20260630-1` (Run 1, 2026-07-01):** The cleanup fix deployed correctly — every persona's `daily_req` is now the multi-item breakdown (11–15 items) with explicit lunch + dinner + sleep items. But the hourly decomposer honors dinner for only **5–6/15** at 18:00 (vs 13/15 on diag7) — a **regression** at full scale. 9–10 personas fill 18:00 with work-shift-close tasks (counting register, restocking, reviewing lesson drafts) instead of eating. Lunch holds at **12/15** (3 working through noon). Sleep is **15/15** plan + **13/14** runtime @ step 1,050 — the FOLLOW THE PLAN rule landed sleep solidly. The dinner regression shows the FOLLOW THE PLAN rule is strong enough at the bedtime handover but not at the 18:00 work→dinner handover for shift-workers. **Tighten on the merged branch before Run 2 — don't defer.**

---

## Fixed items — brief summaries

**Batch 2 — open-ended seasons (validated `20260629-1`).** Dropped the `SURVIVAL_TOTAL_DAYS` env flag and `total_days` config key; `state.py` defaults `total_days=0` (open-ended); day-cap win gated on `total_days > 0` (legacy capped sims keep their cap via the persisted DB column); stall-safety falls back to a stats-based winner after 2 dry days; challenge compact-vs-full schedule selected from `initial_player_count` (≤6 → compact); identity overlay + day narrative use open-ended phrasing ("Day N — X players remain"). 18 open-ended + 4 challenge-schedule tests; 140/140 suite pass. Backwards-compatible (no migration). Docs: `sot_survival.md`, `db_reference.md` updated.

**Vote gate timing (P0-1).** Vote spatial gate was firing at 18:00 (start of VOTING) because the morning challenge quorum still satisfied it. Time-boxed the vote gate to `vote_deadline_hour - 1` (19:00); challenge gate unchanged. Confirmed: elimination now at step 2,310 (~21:00 sim), not 18:00.

**Elimination wiring (P0-2).** Originally flagged as "zombie eliminated player." Was a false positive — wall-clock vs sim-time confusion. Wiring correctly removes the eliminated persona at the ELIMINATION phase step (last coord at 20:59 sim, removed at 21:00 sim). No code fix needed.

**Identity overlay (P0-4).** Overlay showed "Day 0" and "eliminated: none" after an elimination. Fixed: overlay uses `season.current_day`; `_identity_overlay_cache` cleared at elimination. Confirmed: "Day 1 — 14 players remain. Eliminated so far: Max Shoemaker."

**Day persistence (P1).** `_advance_day` incremented the in-memory counter but didn't persist to Supabase. Fixed: `_advance_day` now calls `_persist_state()`. Confirmed: `current_day = 2` at sim end.

**Day labeling (P0-6).** Engine-day vs survival-season-day was conflated on every operator surface. Fixed across BE (`day_highlights` `season_day_number`/`is_grace_day`/`day_label`, API fields, memory prose, CLI aliases) + FE (HUD pill, chapter list). Confirmed: "Premiere" / "Survival Day 1" / "Survival Day 1 (engine Day 2)".

**Deploy / API.** `/survival` endpoint was in an unmounted router file; moved to the mounted path. A rogue manual uvicorn was holding VPS port 8001 and serving stale code; killed it so systemd `double-api` could bind. Gateway verified live throughout the run.

---
