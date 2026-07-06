# Action ↔ Location regression — observations (v2)

## TODO — remaining work (mirror `generative_agents/.../20260430-7_issues.md`)

Authoritative backlog: **§6 Prioritization** + **§4.6** / **§4.6.1** in `20260430-7_issues.md`. Check off here when product confirms.

### P0 (trailer)

- [x] **V5 — FE clock vs `meta.curr_time`:** **Phase A + B + B.1 shipped in `double-front`** (branch `local`, 3 commits: `81c304c`, `1360b8e`, `480c7f9`). **Phase A** (`PlayModeHud.tsx`, `StoryTab.tsx`, `lib/api.ts`): exported **`parseLocalizedDate`**; both display sites pin naive strings to UTC and read `getUTCHours/getUTCMinutes` only — no `toLocaleTimeString` on sim clock. **Phase B** (`lib/api.ts`, `store/simulationSlice.ts`): added **`toCanonicalSimIso(raw)`** (handles all 4 input shapes — naive localized, Postgres-style, naive ISO, ISO-Z) and **`formatSimClock(raw, mode)`** as the single display formatter; canonicalizes at every FE ingest boundary — slice reducers (`setCurrentStepTimestamp`, `setLatestStepTimestamp`), `fetchSteps` per-step + per-persona timestamps, `getStep` return + persona timestamp, `getPersonaDetails` (`currentTime`, `memoryEvents[].created`, `thoughts[].created`, `conversationHistory[].created`). **Phase B.1** (`personaMapping.ts`, two `page.tsx` files): un-deferred `action_start_time` canonicalization after BE confirmed it sources from `scratch.curr_time` (sim-clock, mirrors `curr_time`); also closed a missed `execute_next` ingest gap on per-persona `timestamp`. **Declined (with rationale):** cross-repo `sim_time_iso` SOT field rename — BE-coordinated work without UX gain over the FE-only canonicalization (per BE team approval); BE-side cold-start fallback fix at `supabase_service.py:2285` — FE normalizer handles microsecond-ISO cleanly via the `(\.\d+)?` capture, decoupling is a feature; test-fixture flip on `personaDetails.test.ts` / `playbackStateDesync.characterization.test.ts` / etc. — those tests exercise format-agnostic helpers that bypass the normalization layer; flipping risks shifting parser-policy-dependent comparisons in `toComparableTimestamp`. **Pending:** two-TZ Vitest matrix (UTC vs UTC+5 should render identical HUD + Story beats); one-Playwright headless smoke run to confirm `__headlessObservations` / `__movementsComplete` still fire on canonical inputs; one persona panel with `memoryEvents` spanning the current step to confirm `projectMemoryStreamForStep` temporal filter still gates correctly. **Known soft gap (not fixed):** cold-start step-0 mock `09:00:00` (time-only, no date) → null fall-through → display reverts to step-derived clock (`Day 1 · 00:00`); brand-new sims, brief window before first real movement write — not trailer-relevant, not worth a phantom-date workaround.

### P1 — engineering / realism

- [x] **Validate shipped backend mitigations on a fresh sim export (V1–V4 Phase A)** — done on `20260505-2` (300 steps). V1 ✓, V3 ✓ across all 300 steps × 3 fields × 4 personas. V2 + V4 surfaced specific deficiencies → A.5 follow-ups shipped (see below). Long-run patterns (Group 1 overnight, Bugs A/B/C) not reachable at 300 steps. Full report: `generative_agents/.../storage/20260505-2/20260505-2_report.md`.
- [x] **V2 + V4 Phase A.5 — surgical follow-ups (2026-05-05).** Registry data fix (`"play piano"` → `"piano"` to eliminate role-play false-overlap) and V4 gate widening (`if self.step == 0:` removed; relabel also applied to `realism_trace.act_description`). Tests: `test_affordance_required` 5/5, `test_action_text_sanitization` 25/25. Issues doc §4.6.3.
- [x] **A.5 + long verification (`20260506-5`, 3000 steps, 2026-05-07).** Full report: `generative_agents/environment/frontend_server/storage/20260506-5/20260506-5_report.md`. **Met:** 0 stale `Apartment N` / V4 hits across all fields; V1 sleep-window sampling comparable (no ping-pong regression); V3 held (0 `<waiting>`, 0 known truncations); Gap 2 (`affordance_repick`) **0** bypasses vs 209 baseline; daily-plan **`Home:`** on 15/15 calls, 0 `Apartment` in outputs. **Partial:** V2 piano **1** residual hit (Katya step 879 — soft semantic miss, not staff-safety); **5** Gosha persona-steps show `address_label` = cooking area while `@`-suffix still customer seating (field divergence ~0.05%, SOT §7.2 upstream-emit path). See **§ *Test Sim 20260506-5*** below.
- [x] **Bugs A / B / C — verified on `20260506-5` long export (LLM-aided follow-up 2026-05-07).** **Bug A** 0 hits over 3000 steps (baseline window 1924–2043 covered); **Bug B** 0 nested/unclosed wait seeds; **Bug C** does not reproduce — analyzer's first-pass cadence hit (Gosha 167–199) was a false positive on transit through tile boundaries (verified by step-by-step pos trace; stationarity filter added to detector). Baseline reproduction windows for A/C are both inside this 3000-step run; treat as regression-cleared. See **§ *Follow-up LLM-aided inspection on `20260506-5`*** below.

  - [ ] **Bug A — travel-verb action stuck as `in-place` (Ivan PLAN_STALL 1924–2043, ~120 steps, sim-time 14:34→16:34).**
    - **Visible symptom:** caption reads "riding to Hobbs Cafe to prepare notes and rest before voting" while Ivan stands frozen on a single tile inside Dorm Room 1 for ~2 sim-hours.
    - **Mechanism:** action decomposition labels travel actions as `in-place` (the default). Location resolver pins to current address (dorm) instead of routing to cafe, because the in-place classifier short-circuits before any travel-verb check. Travel-hint check exists in `plan.py` mode resolver but runs *after* the early return that's catching these cases.
    - **Same shape as V2 (description ↔ resolved-location mismatch) but at building level, not object level.** V2 fix doesn't help.
    - **Fix shape:** narrow re-ordering in `plan.py` mode resolver — when action description starts with a travel verb ("riding to", "going to", "walking to", "heading to"), the in-place classifier shouldn't win. ~1 file + 1 test, scoped before commit.
    - **Validation requires ≥2 000-step sim** (Bug A's reproduction window in baseline). **`20260506-5` (3000 steps):** **0** Bug A hits — regression guard only; baseline window not re-exercised here. Recommend bundling with the next long sim if the caption freeze resurfaces.
    - **Priority:** P1 — loudest visual impact of the three; on-screen for 2 sim-hours of mismatched caption.

  - [ ] **Bug B — nested wait-state churn (Katya OSC 2266–2299, 34 steps, ~20:15 sim-time).**
    - **Visible symptom:** Katya bounces between two adjacent cafe tiles with captions showing nested wait clauses: `"waiting to start monitor seating patterns and record who sits where (waiting to start scan…"`. V3 sanitizer scrubs the displayed text but the underlying state churn — and the visible tile-flapping — remain.
    - **Mechanism:** subtask gets re-wrapped in wait state every time it expires before its target was reached, so the action description grows nested wait clauses while the persona oscillates. Planner-lifecycle re-entrancy in `_wait_react` or its caller.
    - **Different from V3 (text scrubbing only).** V3 hides the textual evidence; the lifecycle bug persists.
    - **Fix shape:** wait state should not be re-entered if the persona is already in wait state for the same target. **Investigation required before committing to a fix shape** — touches planner lifecycle, higher regression risk than V2/V4/Bug A.
    - **Defer until:** Bug A's long-sim verification surfaces a fresh reproduction trace, *and* a focused investigation has scoped the `_wait_react` re-entrancy logic.
    - **Priority:** P1 (visible flapping) but trickier than A.
    - **`20260506-5` (3000 steps):** **0** nested-wait / unclosed-wait seeds; **53** long idle bands originally classified benign — LLM-aided follow-up confirmed **6 are overnight sleep** (false alarm; detector now suppresses them) and the remaining ~47 are Survival-Mode "gathering at cafe / classroom" idle, no bug shape.

  - [ ] **Bug C — cafe staff-zone subtask cadence + stale `Apartment N` mid-run (Luba OSC 2054–2173, 120 steps, sim-time 16:43→18:43).**
    - **Visible symptom:** Luba (cafe owner; staff zones legal for her) flips every ~3 minutes between `cooking area` and `behind the cafe counter`, captions rotating through "stock dinner mise en place" / "monitor voting block and update tally sheet" / "clean up service area". Each subtask plausible alone; the every-3-minute cadence isn't.
    - **Bonus finding:** the very next step after this band shows description "resting and watching TV at Apartment 1" — **independent confirmation that the V4 step-0 gate was too narrow.**
    - **Apartment N half: addressed by V4 A.5 + daily-plan `Home:` (verified `20260506-5`, 0 V4 hits).** Cadence half still a separate planner issue if it reproduces.
    - **Cadence half: pending.** Fix shape (per §8 of `20260505-2_report.md`): when planner generates a new subtask whose target is the same arena as the current one, it shouldn't immediately reset position. Worth a deeper trace before committing — same kind of planner-lifecycle scope as Bug B.
    - **Defer cadence half until:** a long sim freshly reproduces the Luba cadence pattern for tracing (Apartment-N text closed — **`20260506-5`**).
    - **Priority:** P1 (Apartment half is now zero-cost via A.5; cadence half is a separate planner-cadence issue worth scoping after Bug A).

  - [ ] **Detector follow-up (low priority, separate from Bugs A/B/C).** PLAN_STALL false positive in `analyze_sim_realism.py` — flagged Katya's legitimate pre-challenge rest at cafe customer seating (steps 3403–3502 in baseline). Detector should distinguish "stuck" from "intentionally idle in the right place" by adding a movement-variance gate alongside description-repeat. Affects analysis tool noise, not sim behavior.

- [ ] **V3 Phase B:** Split **internal planner text** vs **display text** (`act_internal_state` / `act_display_text`) once Phase A proves stable (**§4.6** structural track).
- [ ] **V3 Phase A extension candidates (only if leaks reproduce)** — **`reverie.py` chat-scoring observation** (~9106; bare `strip_action_tags`) and **constrained-movement intermediate dict** (~8839; raw `act_description`) — not the main per-step movement emit path (**§4.6.1**).
- [ ] **Long-run realism:** PLAN_STALL + OSCILLATION bands (`analysis/summary.json` — §3); largely re-attributed to Bugs A/B/C above after `20260505-2` cross-analysis. Group 1 (4/8 of original `20260430-7` warnings, dorm-internal sleep ping-pongs) **expected to be cleared by V1** — **`20260506-5`** is a 3000-step regression export (not a dedicated one full in-sim-day Group 1 replay); confirm Group 1 explicitly on a ≥1 440-step narrative if product still wants that gate.

### P2 — reliability / cleanliness

- [ ] **`wake_up_hour` hygiene:** Stall-breaker E2E vs schedule-derived **`effective_wake_hour`**, optional `[WAKE_DERIVED]` telemetry, planning-cache round-trip test gaps — consolidate with `sot_prompts.md` / `sot_memory.md` wake semantics and **§4.1** secondary debt in `20260430-7_issues.md`.

---

**Date:** 2026-05-04 (consolidated with investigation & fixes: **2026-05-05**; **V2 partial ship** on **affordance_required**, same day; **`ivan/action-location` bundle verified** on **`20260506-5`**, **2026-05-07**)
**Reporter:** Nicolas
**Sim baseline:** `20260430-7` (post-merge of `ivan/video-trailer-fixes` into `ivan/video`; reported as green by Ivan in `20260430-7_report.md`).
**Method:** FE visual review of the first ~180 steps + verbatim cross-check against `movement/<step>.json` files.
**Predecessor:** `done/20260430_action-location-observations.md` — that doc closed three issues as `<DONE 2026-04-30>`. This v2 documents new findings on the same baseline that suggest two of those fixes are incomplete and surface two issues not covered by the original doc.

**Deep-dive & implementation log (Ivan):** `generative_agents/environment/frontend_server/storage/20260430-7/20260430-7_issues.md` — executive verdict, automated summary flags, per-issue RCAs, shipped V1–V4 + **§6** backlog. Normative wake semantics: `double-docs/sot/sot_prompts.md`, `sot_memory.md`.

---

## Consolidated status (2026-05-05; verified 2026-05-07 on sim `20260506-5`)

| Nicolas issue | Internal ID | Evidence in this doc | RCA / fix posture |
| --- | --- | --- | --- |
| **1** Sleep ↔ Hobbs ping-pong | **V1** | § Issue 1 table | **Root cause confirmed:** `proactive_periodic_refresh` during an **active sleep** row + `FORCE_REPLAN_SCHEDULE_ADVANCE` advancing `act_index` **before** the sleep block elapses by sim-time — alternates with time-based index still on sleep (bed ↔ café). **Not** a bad survival wake clamp (that was investigated and **retracted**). **Fix shipped** (`plan.py`): skip refresh when current schedule row is sleep-like; block force-replan schedule advance past a sleep-like `curr_index`. Tests: `tests/test_sleep_window_protection.py`. **Post-fix run:** Ivan stays in bed through the sleep window; dorm↔café oscillation **0** in that window; first clean café arrival ~step ~158. **`20260506-5` (3000 steps):** Ivan sleep-window sampling comparable to pre-fix; **no ping-pong regression** flagged. `20260430-7` movement JSON remains **pre-fix** narrative baseline for step-level tables in this doc. |
| **2** Affordance fence (staff / prep / piano) | **V2** | § Issue 2 | **RCA:** fence was **existence-shaped**; piano case was **action × affordance** on a real object. **Shipped (~2026-05-05):** **`affordance_required`** on restricted-use world objects (e.g. **piano**, **microphone**) + resolver **hard reject / remap** (`location_resolver.py`, `maze_registry.json`). **20260506-5 (3000 steps):** **`affordance_repick`** removed from post-validator → Gap 2 **209 → 0** sim-step bypasses; curated LLM tree drops `staff_only` objects for non-workers (**0** in action-location prompts); long runs at refrigerator / pub bar / kitchen sink **did not recur**. **Residuals:** **1** piano off-target hit (Katya step 879, −75% vs baseline 4); **5** Gosha steps — `address_label` cooking area vs description `@` customer seating (field divergence, SOT §7.2). Tests: `tests/test_affordance_required.py`. |
| **3** Truncation / `<waiting>` leak | **V3** | § Issue 3 | **RCA:** porous boundary planner ↔ presentation. **Phase A shipped (~2026-05-05):** **`sanitize_emit_text`** on movement `description`/`intent`, **`realism_trace.act_description`**, **`COMPLETED.json`**, nested **`partial_state.action_progress.action_description`** (`20260430-7_issues.md` §4.6.1). This **`20260430-7`** excerpt is **pre-fix** narrative. **`20260506-5`:** **0** `<waiting>` / known truncation patterns across **9182** persona-steps × fields. **Open:** Phase B split + optional extension to **§4.6.1** ancillary emit paths if leaks recur. |
| **4** Stale “Apartment 1” | **V4** | § Issue 4 | **RCA:** inherited text vs resolver. **Phase A shipped:** **`relabel_stale_place_text`** (gate widened post–step-0). **Source fix shipped:** daily-plan prompt **`Home:`** (sector + arena) + ACTIVITY RULE (`run_gpt_prompt.py`, survival + v6 templates). **`20260506-5`:** **0** V4 / `Apartment N` hits across all fields; **15/15** daily-plan prompts include the **Home:** line; outputs use dorm naming with **zero** `Apartment` references. |
| **5** FE clock vs `curr_time` | **V5** | § Issue 5 | **RCA:** mixed FE-BE time contract. **Phase A + B + B.1 shipped (`double-front`, branch `local`):** display sites (`PlayModeHud`, `StoryTab`) UTC-only; canonicalization at all FE ingest boundaries (slice reducers, `fetchSteps`, `getStep`, `getPersonaDetails`, `personaMapping`, `execute_next` dispatch path); `action_start_time` canonicalized after BE confirmed sim-clock semantics. Cross-repo `sim_time_iso` SOT rename **declined** — FE-only canonicalization is sufficient (BE team approval). Details: `20260430-7_issues.md` **§4.6.2**, FE worklog **2026-05-05** entry. **Open:** two-TZ Vitest matrix; one Playwright headless smoke run. **Soft gap:** cold-start time-only `09:00:00` mock null-falls to step-derived clock — not trailer-relevant. |

**Secondary debt (related to Issue 1 family, not the ping-pong root cause):** `wake_up_hour` scratch scalar vs schedule-driven index — **schedule is runtime SoT** for “what row is active.” **`effective_wake_hour(persona)`** from leading sleep blocks, stall-breaker **`max(7, derived)`**, scalar write removed from `_long_term_planning` — norms in **`double-docs/sot/sot_prompts.md`**, **`sot_memory.md`**. **TODO (P2)** lists remaining test/telemetry gaps vs **§4.1** in `20260430-7_issues.md`.

**Written report correction:** `20260430-7_report.md` described sleep ping-pong as “cosmetic” / stationary in bed — **contradicted** by movement JSON (real locomotion). Survival-themed subtask text was a surface improvement; structural cause was refresh + force-advance (above).

**Automated summary (full run, `analysis/summary.json`):** 8 warnings — 2× PLAN_STALL, 6× OSCILLATION (long-run Katya/Luba tile pairs, Ivan “riding to Hobbs…” stall band, etc.). Survival season bookkeeping completed; **`survival_issues` empty** is not a human-realism gate.

---

## Summary

Five issues observed in the first ~180 steps of `20260430-7`. The first four are on the action ↔ location boundary; the fifth is a clock-display discrepancy between FE and the underlying simulation `curr_time`:

1. **Sleep ↔ "walk into Hobbs Cafe" ping-pong consumes Ivan's entire morning (escalates Issue 1 residual).** On this **pre-fix** export, Ivan walks back and forth between `Dorm Room 1:bed` and `Hobbs Cafe:cafe:behind the cafe counter` from 06:51 sim-time (step 21) until 09:18 sim-time (step 168) — **~2h 27min of in-game time** lost to cross-village travel during what should be his sleep + arrival window. The cycle finally breaks at step 168 when he properly walks to `cafe customer seating`. The previous doc downgraded this to "cosmetic"; in practice it eats his entire morning before the survival challenge. **Mitigation shipped 2026-05-05** (sleep refresh skip + no force-advance past sleep row); confirm on a **new** movement export — see **Consolidated status** above.
2. **Affordance fence does not cover staff-only / private arenas (extends previous Issue 2).** On this **`20260430-7` export,** personas still show staff zones, customer-seating prep, and the **piano / poker-face** exemplar (step 179). **Update ~2026-05-05:** restricted-use objects (notably **piano**, **microphone**) now carry **`affordance_required`**; the resolver **rejects** mismatched actions and **remaps** so “poker face at the piano” should not recur for tagged instruments. Other observations in § Issue 2 (bar, fridge from seating, behind counter while “sleeping” with Issue 1) may still appear until re-run on a **post-fix** export or further registry/prompt work.
3. **Action-text truncation regressions (Issue 3 not fully fixed).** On this **`20260430-7` export,** patterns like `(waiting to star`, `<waiting> …` etc. **Backend Phase A shipped ~2026-05-05** (`sanitize_emit_text` — see **TODO** / `20260430-7_issues.md` §4.6.1); **re-validate** on a new export; **Phase B** and **ancillary emit paths** remain on the **TODO** list.
4. **Stale "Apartment 1" reference in action descriptions (new).** At step 0 in this export, Luba and Katya still show **Apartment** wording. **Backend Phase A shipped** (`relabel_stale_place_text`, step 0 only); confirm on a new export; widen gate if needed (**TODO**).
5. **FE clock vs authoritative `curr_time` (new).** On the **`20260430-7` baseline**, the timeline HUD could disagree with `meta.curr_time` (JSON morning vs HUD past “11:00,” etc.). **Phase A + B + B.1 shipped in `double-front` (branch `local`, 3 commits).** Display sites pinned to UTC; `toCanonicalSimIso` canonicalizes at every FE ingest boundary (slice reducers, all API normalizers, `personaMapping`, `execute_next` dispatch); `action_start_time` canonicalized post-BE-confirmation that it sources from `scratch.curr_time`. Cross-repo `sim_time_iso` rename **declined** in favor of FE-only canonicalization (BE team approval). See **`20260430-7_issues.md` §4.6.2** and FE worklog **2026-05-05**. **Pending smoke checks:** two-TZ browser parity, one Playwright headless run, one memory-temporal-filter spot-check.

A sixth pattern — the internal `address_label` field carrying a different leaf (`:kitchen sink`) than the `@`-suffix in `description` (`:behind the cafe counter`) — is **not user-visible** because the FE renders the description's suffix, not `address_label`. Flagged in the **Pattern** section below as a data-integrity concern only.

*Remaining work is tracked explicitly in **TODO — remaining work** at the top; **Consolidated status** summarizes posture per Nicolas issue.*

---

## Sim `20260430-7` — first 150 steps

### Issue 1 — Ivan: sleep ↔ "walk into Hobbs Cafe" cross-building ping-pong (sustained)

The sim starts 2026-05-01 06:30. Ivan's first non-sleep schedule entry is "walk into Hobbs Cafe" — he correctly initiates that walk at step 21 (06:51). Instead of arriving and staying, he ping-pongs between bed and Hobbs Cafe staff arenas for 147 sim-minutes until the loop finally breaks at step 168 (09:18).

The full cycle, with sim-time and arrival/departure points, verified verbatim against `movement/<step>.json`:

| Step | Sim time | FE-visible location | Description (verbatim) | Phase |
| --- | --- | --- | --- | --- |
| 0 | 06:30 | Dorm Room 1 · Bed | `sleeping` | Initial sleep — correct |
| 21 | 06:51 | Hobbs Cafe · Cafe · Cafe Customer Seating | `walk into Hobbs Cafe and find a seat near the counter` | First (correct) walk to cafe begins |
| 41 | 07:11 | Dorm Room 1 · Bed | `sleeping (on the way to sleepin)` | Reverts; heading back to bed |
| 57 | 07:27 | Dorm Room 1 · Bed | `sleeping (on the way to sleepin)` | Arrives back at bed |
| 62 | 07:32 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | `sleeping (waiting to start walk into Hobbs Cafe …)` | Heading back out — staff-only arena |
| 78 | 07:48 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | same | Arrives behind counter |
| 80 | 07:50 | Dorm Room 1 · Bed | `sleeping (on the way to sleepin)` | Heading back to bed |
| 97 | 08:07 | Dorm Room 1 · Bed | same | Arrives at bed |
| 102 | 08:12 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | `sleeping (waiting to start walk into Hobbs Cafe …)` | Heading out again |
| 120 | 08:30 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | same | Arrives behind counter |
| 122 | 08:32 | Dorm Room 1 · Bed | `sleeping (on the way to sleepin)` | Heading back |
| 139 | 08:49 | Dorm Room 1 · Bed | same | Arrives at bed |
| 145 | 08:55 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | `sleeping (waiting to start walk into Hobbs Cafe …)` | Heading out |
| 162 | 09:12 | Hobbs Cafe · Cafe · **Behind The Cafe Counter** | same | Arrives behind counter |
| **168** | **09:18** | **Hobbs Cafe · Cafe · Cafe Customer Seating** | `walk into Hobbs Cafe and find a seat near the counter` | **Loop breaks — proper walk to customer seating** |

**Total wasted in-game time: ~2h 27min** (06:51 → 09:18). 4 full round-trips dorm ↔ cafe before the loop resolves itself.

**Pattern observed:**
1. The oscillation runs across the entire morning, not as isolated incidents. Each half-cycle lasts ~17–22 steps.
2. Cycle period ≈ 20 steps matches the previous doc's "every ~21 sim-min" `proactive_periodic_refresh` cadence.
3. The "anticipatory" sub-task during refresh always resolves to `behind the cafe counter` (a staff-only arena) — never to a public-customer cafe seat. The previous doc said the survival fix made the revert content "thematically correct"; the location resolution is not.
4. `(waiting to start walk into Hobbs Cafe …)` is logically incoherent during cafe-arrival phases: the persona is already rendered inside Hobbs Cafe in those steps, but the description still says "waiting to walk into" it.
5. The persona physically walks the full path between buildings each cycle (`actual_path` in `movement/<step>.json` shows multi-tile movement per step). The sprite is not teleporting — Ivan literally spends the morning walking dorm ↔ cafe ↔ dorm ↔ cafe instead of sleeping.

This is the same issue the previous doc downgraded to "cosmetic, not fixed." In `20260430-7` it consumes Ivan's entire arrival window before the survival challenge.

**RCA & mitigation (Ivan, 2026-05-05 — aligns with V1 in `20260430-7_issues.md`):** Nicolas’s pattern (refresh cadence ≈ 20 steps, sleep vs next-block content) matches code: **`proactive_periodic_refresh`** intended for **non-sleep** stagnation at destination had **no sleep exemption** (unlike stall-breaker in `reverie.py`, which skips `is_sleep_like`). When refresh fires **in bed**, it sets **`force_replan_next_step`**; with **`FORCE_REPLAN_SCHEDULE_ADVANCE`**, `act_index` can jump to **`curr_index + 1`** **without** the sleep row having finished in sim-time → next block’s decomposed action (walk to Hobbs / staff arenas) runs. When a short café sub-task **expires**, **force-advance may be absent** → `_determine_action` follows **time-based** schedule index → still **sleep** before 09:00 → persona returns **to bed**. Loop continues until **09:00** boundary makes index **1** the natural active row (~step 168 here). Investigation **retracted** the hypothesis that **`wake_up_hour` / clamp failed to propagate** into the schedule — morning **`[sleeping, 540 min]`** and **`get_f_daily_schedule_index`** are consistent; failure is **replan coupling**, not wrong sleep duration. **Mitigation shipped:** skip refresh while current schedule row is sleep-like (`[LIFECYCLE:REFRESH_SKIP]`); **do not** force-advance past `curr_index` when that row is sleep-like (`STALL BREAKER SKIP … not advancing`). **Post-fix run:** **0** dorm↔café trips during scheduled sleep window. **Outstanding:** regenerate movement/analysis from a post-fix export to retire this baseline. **Wake SoT / resume:** see **TODO P2** + **`sot_prompts.md`** / **`sot_memory.md`** (**`effective_wake_hour`**, scratch scalar removal).

---

### Issue 2 — Affordance fence does not catch staff-only / private arenas

The previous doc's fix (`_anchor_compatible_with_parent_arena`) checks whether a sub-task's anchor object exists in the parent arena. It does not appear to filter arenas semantically marked as staff-only.

#### Gosha — annotation work behind a pub bar

| Step range | Description (verbatim) | `address_label` | Mismatch |
| --- | --- | --- | --- |
| 110–115 | `annotate counterarguments and jot contingency moves (on the way to a @ …The Rose and Crown Pub:pub:behind the bar counter` | alternates `…:behind the bar counter` / `…:refrigerator` | Strategy-notes work routed to staff-only behind-the-bar zone of a pub. |
| 116–131 | `annotate counterarguments and jot contingency moves (waiting to star @ …pub:behind the bar counter` | alternates `…:behind the bar counter` / `…:refrigerator` / `…:pub` | Same arena, sustained 16 steps. |

She is a customer of the pub at most — she should not be standing behind the bar.

#### Ivan — sleeping behind a cafe counter / at a kitchen sink

Steps 62–80, 103–121, 145–150 (table above). `Hobbs Cafe:cafe:behind the cafe counter` and `:kitchen sink` are staff-only objects. Sleeping there is a triple semantic violation: wrong building (he has a bed), wrong arena (staff-only), wrong action for the object (sleep on a sink).

#### Gosha — food preparation in customer seating

| Step range | Description (verbatim) | `address_label` | Mismatch |
| --- | --- | --- | --- |
| 21–49 | `gather breakfast items from fridge and pack into bag @ …Hobbs Cafe:cafe:cafe customer seating` | `Hobbs Cafe:cafe` | Fridge access from a customer seat. The fridge is not in customer seating. |
| 50–64 | `prepare quick sandwich and portion fruit in container @ …cafe customer seating` | `…:cafe customer seating` | Food prep at a customer seat. No counter, no prep surface, no knife storage. |

Same arena (`cafe customer seating`) hosts a long sequence of activities (waking, packing, prep, sandwich, fruit, strategy notes) that span breakfast prep, dressing, study and food-portioning. The arena passes the existence check (`cafe customer seating` exists in `Hobbs Cafe:cafe`) but does not afford most of these actions.

#### Katya — poker-face practice on a piano

| Step | Description (verbatim) | `address_label` | Mismatch |
| --- | --- | --- | --- |
| 179 | `practice poker-face and body language (waiting to start review betrayal gam @ …Hobbs Cafe:cafe:piano` | `…:Hobbs Cafe:cafe:piano` | Poker-face / body-language practice resolved to the piano. The piano does not afford either action. |

Both `description` and `address_label` agree on `:piano` here, so the FE shows Katya standing on top of the piano practising poker faces. This case is interesting because it does not involve a staff-only arena — it is a regular object-anchor mismatch. The decomp's anchor for "practice poker-face" picked `piano` from somewhere in the cafe arena's object list, the existence check passed (`piano` does exist in `Hobbs Cafe:cafe`), and the fence honoured it. The action is not afforded by the object.

**Status (engineering, 2026-05-05):** **Mitigated** for **tagged restricted-use** objects — `affordance_required` + resolver remapping closes this **exemplar** class (`tests/test_affordance_required.py`, `20260430-7_issues.md` §4.2.2). This **`20260430-7`** excerpt remains **pre–V2 gate** evidence.

---

### Issue 3 — Action-text truncation regressions

The 2026-04-30 doc reported Issue 3 fixed via `strip_action_tags` generalisation + `extract_wait_target_phrase` rewrite of `_wait_react`. New truncation patterns appear in this sim that those fixes do not cover.

| Pattern | Example (verbatim, with offending suffix in **bold**) | Location of evidence | Length of cut |
| --- | --- | --- | --- |
| `(waiting to start …)` truncated and unclosed | `annotate counterarguments and jot contingency moves` **`(waiting to star`** | Gosha steps 116–131 | Cuts at 17 chars after `(`, drops `t...)` |
| `(waiting to start review betrayal gam …)` truncated and unclosed | `practice poker-face and body language` **`(waiting to start review betrayal gam`** | Katya step 179 | Cuts mid-word at `gam`, no closing paren. Different cut length than the 17-char one. |
| `(on the way to sleepin)` | `sleeping` **`(on the way to sleepin)`** | Ivan steps 41, 80, 122 | Cuts last `g` of `sleeping`. Closing paren intact, so this is a different truncator than the unclosed ones. |
| `(on the way to a …)` | `annotate counterarguments and jot contingency moves` **`(on the way to a`** | Gosha steps 96–100, 110 | Cuts at 17 chars after `(`. |
| `<waiting>` pseudo-address leaks into description | `waiting to start walk into Hobbs Cafe and find a seat near the counter` **`@ <waiting> 72 25`** | Ivan steps 23–40, Gosha steps 91–95 | The internal "waiting" sentinel + raw tile coords reach the FE-bound description string. |

The truncation appears not just in the FE-bound `description` field but also in `intent` and in `realism_trace.act_description` (the upstream "raw" field). Verified verbatim at Gosha step 97:

```
description:    "annotate counterarguments and jot contingency moves (on the way to a @ ..."
intent:         "annotate counterarguments and jot contingency moves (on the way to a"
act_description: "annotate counterarguments and jot contingency moves (on the way to a"
```

→ This rules out FE rendering as the cause. The truncation lives in the planner / contract pipeline and is written to disk truncated. Whatever helper produces the `(on the way to …)` / `(waiting to start …)` parenthetical is not the same code path the 2026-04-30 fix patched (`_wait_react` / `extract_wait_target_phrase`).

---

### Issue 5 — FE clock vs `curr_time` desync

**Pre-fix observation (`20260430-7` export + FE at time of report):** The clock the FE rendered on the timeline did not agree with authoritative `meta.curr_time` in movement JSON:

| Source | Step 0 | Step 117 | Step 168 |
| --- | --- | --- | --- |
| JSON `meta.curr_time` (authoritative) | `May 01, 2026, 06:30:00` | `08:27:00` | `09:18:00` |
| FE timeline display (observed) | ~09:00 | ~11:00–11:45 | (later than dialogue assumes) |

**Symptom in dialogue:** at sim_time 08:07–08:27 (steps 97 / 117), the Katya↔Luba chat references a vote scheduled for "tonight" and a "check in before 7pm" — coherent with the JSON time being morning. The challenge that the survival controller schedules at sim time 11:00 is referenced as a future event in dialogues at JSON sim_time ~08:00–10:00. **But the FE clock at those same steps already showed past 11:00**, making the dialogues read as if characters were planning a meeting that already happened.

**Applied solution — Phase A + B + B.1, all shipped in `double-front` (branch `local`, 2026-05-05):**

- **Phase A (`81c304c`)** — display sites: `app/sim/[sim_code]/play/PlayModeHud.tsx` (bottom-left day clock) and `components/persona-card/StoryTab.tsx` (per-beat timestamp). Both routed through the existing **`parseLocalizedDate`** (now exported from `lib/api.ts`); read **`getUTCHours`** / **`getUTCMinutes`** only — no `toLocaleTimeString` on sim clock. This is the V5 trailer-blocker fix.
- **Phase B (`1360b8e`)** — FE-internal canonicalization. `lib/api.ts` adds **`toCanonicalSimIso(raw): string | null`** (handles all 4 input shapes — naive localized `Month DD, YYYY, HH:MM:SS`, Postgres-style `YYYY-MM-DD HH:MM:SS`, naive ISO `YYYY-MM-DDTHH:MM:SS`, ISO-Z) and **`formatSimClock(raw, mode)`** as the single display formatter. Canonicalizes at every FE ingest boundary: Redux slice reducers (`setCurrentStepTimestamp`, `setLatestStepTimestamp`), `fetchSteps` per-step + per-persona, `getStep` return + persona, `getPersonaDetails` (`currentTime` / `memoryEvents[].created` / `thoughts[].created` / `conversationHistory[].created`).
- **Phase B.1 (`480c7f9`)** — un-deferred `action_start_time` canonicalization after BE team confirmed sim-clock semantics (sources from `scratch.curr_time` at `action_contract_v1.py:339` and `scratch.py:905`; naive ISO comes from `.isoformat()` vs `meta.curr_time`'s `strftime`). Same change closed a missed `execute_next` ingest gap on per-persona `timestamp` (path bypassed the `fetchSteps`/`getStep` normalizers Phase B wired). Sites: `lib/personaMapping.ts`, `app/simulations/[sim_code]/page.tsx`, `app/sim/[sim_code]/play/page.tsx`.

**BE team verification (recap):** `curr_time` emit is uniform across the production hot path (movement JSON, STATUS.json, COMPLETED.json, fork-bootstrap meta, `_compute_step_time`). Three non-hot-path edge shapes verified safe via the FE normalizer's null fall-through: cold-start microsecond ISO at `supabase_service.py:2285` (matched and canonicalized cleanly via the regex's `(\.\d+)?` capture); step-0 mock time-only `09:00:00` (brand-new sims, brief window) (null fall-through → step-derived clock); parse-failure empty string (null fall-through). BE offered a one-line cold-start fallback fix to emit naive localized; **declined** as the FE handles it gracefully and decoupling is a feature.

**Declined / explicitly out of scope:**
- Cross-repo SOT field rename (`sim_time_iso` + `sim_time_display`) — would force a coordinated BE-FE wire change without UX gain over the FE-only canonicalization. BE team agreed this was the right call.
- Test-fixture flip on `personaDetails.test.ts` / `personaDetailsContract.test.ts` / `playbackStateDesync.characterization.test.ts` / `displayedChatsLedger.test.ts` — those tests exercise format-agnostic helpers (`buildStepAwarePersonaPanel`, `appendSpeechBubbleToLedger`) that bypass the API normalizer / slice reducer where Phase B canonicalizes. Flipping them risks shifting parser-policy-dependent comparisons inside `toComparableTimestamp`. Optional follow-up if a future contract test wants to assert post-Phase-B wire shape.
- Phantom-date workaround for the cold-start `09:00:00` case — would lie about the simulation start; null fall-through is the correct behavior.

**Pending smoke checks (post-merge before sim ships):**
1. Two-TZ browser parity — DevTools → Sensors → set timezone to UTC and to UTC+5; reload Play page; HUD + Story beats should render identical strings.
2. One Playwright headless run with `?headless=true` — confirm `__headlessObservations` populates and `__movementsComplete` fires on canonical inputs.
3. One persona panel with `memoryEvents` spanning the current step — confirm `projectMemoryStreamForStep` temporal filter still gates correctly with canonical inputs on both sides (the previous "accident" of comparison working because both sides shared a parser frame is now replaced by deterministic UTC comparison).

Full FE implementation log: `D:\Coding\double-docs\worklog.md` **2026-05-05** — Frontend — branch: local. BE-side §4.6.2 of `20260430-7_issues.md` retains the contract narrative.

**Why this matters beyond cosmetics:**
1. Trailer/playback timing references the FE clock; if it drifts, scene captions and "11:00 challenge" beat will not land where they should.
2. User-facing observation reports become hard to write — the time the user sees and the time the JSON records are not the same, so step↔time references mix the two systems.
3. Dialogue↔display contradictions (characters anticipating events that the visible clock has already passed) erode immersion.

---

### Issue 4 — Stale "Apartment 1" reference at sim start

At step 0 (06:30 sim-time), Luba's and Katya's morning-routine descriptions name a location that does not exist anywhere in this sim's address tree:

| Persona | Description (verbatim) | `address_label` | Discrepancy |
| --- | --- | --- | --- |
| Luba | `waking up and doing morning routine at Apartment 1 @ the Ville:Dorm for Oak Hill College:Dorm Room 2:blackboard` | `the Ville:Dorm for Oak Hill College:kitchen` | Description names `Apartment 1`; physical location is `Dorm for Oak Hill College`. Description's `@`-suffix and `address_label` also disagree (blackboard vs kitchen). |
| Katya | `waking up and doing morning routine in Apartment 1 @ the Ville:Dorm for Oak Hill College:Dorm Room 3:closet` | `the Ville:Dorm for Oak Hill College:Dorm Room 2` | Same — description names `Apartment 1`; physical location is `Dorm Room 3:closet`. |

There is no "Apartment 1" sector in `Dorm for Oak Hill College`. Looks like a stale phrase the daily-plan LLM produced (perhaps from an earlier base sim or an unrelated lifestyle template) that survived the survival lifestyle rewrite and into the action description without being normalised against the persona's actual address tree.

This is a smaller-blast-radius issue (only the action *text* — the location resolver does the right thing physically), but worth flagging as part of the same family of "the description string says one thing, the persona is doing another."

---

## Pattern — hypothesised root causes vs investigation (2026-05-05)

1. **(**Nicolas**)** Survival lifestyle rewrite + refresh + location leak. **(**Investigation**)** **Confirmed** as **refresh during active sleep** + **force-replan schedule advance** fighting **time-based** sleep index — “location leak” and staff counter are **symptoms** of pulling **next block** early, not a separate resolver bug for Issue 1. **Gating refresh** (and **blocking advance past sleep**) is the implemented fix; “pin address during sleep” alone would be a narrower workaround.

2. **Affordance fence is existence-only, not permission-aware.** **Confirmed** historically; **V2 ship:** **`affordance_required`**, **`staff_only`** registry + validator, **`affordance_repick` removed** (2026-05-06+). **`20260506-5`:** Gap 2 **209 → 0**; curated trees **0** `staff_only` in LLM picks; **5** residual field-level divergences (Gosha / cooking area vs customer seating) — **SOT §7.2** upstream-emit path, not LLM tree failure.

3. **Action-text truncation / wait internals.** **Confirmed** upstream in `act_description`; **refined** diagnosis: **porous** internal vs presentation contract (`_wait_react`, `extract_wait_target_phrase`, emit path). **Phase A/B** fix plan in issues doc.

4. **Internal data-integrity note (not always user-visible).** `address_label` vs description `@`-suffix divergence remains a pipeline concern; **`20260506-5`** quantifies a **5-step** Gosha episode (~**0.05%** of persona-steps) on the §7.2 path — intent (customer seating) preserved in text while label shows **cooking area**.

---

## Suggested next steps (updated 2026-05-05; `20260506-5` 2026-05-07)

1. **Issue 1 / V1 — DONE (code).** Refresh skip + no force-advance past sleep row — **shipped** in `plan.py`; tests in `test_sleep_window_protection.py`. **`20260506-5`:** Ivan sleep-window sampling comparable to pre-fix; **no ping-pong regression** flagged. **Remaining (optional):** further exports if product wants an explicit 1 440-step narrative replay.

2. **Issue 5 / V5 — Phase A + B + B.1 done (`double-front`, branch `local`, 3 commits).** Display UTC-pinned; canonicalization at every FE ingest boundary; `action_start_time` canonicalized after BE confirmed sim-clock. Cross-repo `sim_time_iso` rename **declined** in favor of FE-only canonicalization. **Remaining:** two-TZ Vitest, one Playwright headless smoke run, one memory-temporal-filter spot-check (see Issue 5 detail block).

3. **Issue 3 / V3 — largely shipped (emit + nested field); Phase B still P1.** Phase A sanitizer + nested `partial_state.action_progress` path; **`20260506-5`:** **0** hits. **Open:** split internal vs display action strings (**§4.6**).

4. **Issue 4 / V4 — shipped + verified.** Relabel + daily-plan **`Home:`**; **`20260506-5`:** **0** V4 / `Apartment N` hits across all fields. **Optional:** analyzer tuning so address-tree fields don’t false-positive on real sectors named `Apartment N`.

5. **Issue 2 / V2 — merge-ready per `20260506-5`.** `affordance_required`, **no** `affordance_repick`, curated non-worker trees, registry `staff_only` where intended. **Residuals:** **5** Gosha `address_label` vs `@`-suffix divergences (**SOT §7.2**); **1** piano semantic miss (step 879). **Next:** targeted emit-path audit for §7.2; optional literal-sector pin per SOT §9.5.

6. **Wake / resume hygiene — P2.** `effective_wake_hour` (**implemented** — see **TODO** P2 + **`sot_prompts.md`** / **`sot_memory.md`** / `20260430-7_issues.md` §4.1).

7. **Long-run realism (from `analysis/summary.json`):** PLAN_STALL bands (Ivan "riding…", Katya resting) and OSCILLATION spans (Katya/Luba two-tile loops) — separate from Issue 1–5; track as follow-up naturalness work.

---

## What I checked vs what is still pending

- Reviewed steps 0–~180 of `20260430-7` against `movement/<step>.json`. All evidence above is verbatim (**pre-fix** movement for Issue 1 relative to the 2026-05-05 sleep guards).
- Did **not** review steps 180 → 3000. **Issue 1 (ping-pong):** code mitigation targets the same mechanism; Ivan’s guards should suppress sleep-window ping-pong on new exports — **long-run OSCILLATION / PLAN_STALL** metrics in `analysis/summary.json` are **separate** follow-ups (see **Suggested next steps** item 7).
- Did **not** systematically trace Katya and Luba beyond spot-checks. Step 117 shows Katya doing observation in `cafe customer seating` (ok) and Luba doing cashier work behind the cafe counter (ok for her — she's the cafe owner). Step 0's "Apartment 1" reference and step 179's piano exemplar motivated V2 **`affordance_required`**; re-validate on a **post–V2** export.
- Did **not** validate any trailer scenes against the affected steps. If a Day 1 trailer scene anchors on Ivan's morning sleep window, the rendering will show him walking back and forth.


## *Sim 20260505-2 results*

● Fixed (validated in 300-step sim):
  - V1 — Sleep ping-pong: Ivan stayed in bed for the full 150-step sleep window, woke up cleanly at 09:00. Down from ~4 dorm↔cafe round-trips pre-fix.
  - V3 — Broken display text: Zero <waiting> markers, zero mid-word truncations across 300 steps × 4 personas × 3 text fields.
                                                                                                                                                                                                                         Half-fixed (shipped but didn't work as intended; one-line follow-up identified):
  - V2 — Piano/microphone affordance gate: Code is correct, but the registry stores piano's affordance as "play piano" — and the word "play" accidentally matches "role-play" in Katya's actions, fooling the          
  validator. She spent 26 steps "role-playing at the piano". One-character fix: change "play piano" to "piano" in maze_registry.json.
  - V4 — Stale "Apartment 1" relabel: Step 0 itself is clean. But I gated the relabel to step 0 only, and stale text actually persists for the first 20 steps (until the action transitions). 60 stale hits per persona
   for Gosha/Katya/Luba. One-line fix: remove the if self.step == 0: gate.

  Still broken (not addressed by V1–V5 — three new bugs surfaced in the prior baseline analysis, none reachable at 300 steps):
  - Bug A — Travel-verb misclassified as in-place: Ivan's caption reads "riding to Hobbs Cafe" while he stands frozen in the dorm for 2 sim-hours. Movement-mode resolver short-circuits before checking travel verbs. 
  Loudest visual problem.
  - Bug B — Nested wait-state churn: Katya bounces between two cafe tiles with captions like "waiting to start … (waiting to start scan…" — V3 cleans the text but the underlying tile-flapping remains.
  Planner-lifecycle re-entrancy issue.
  - Bug C — Subtask cadence + late "Apartment 1" leak: Luba flips between cafe cooking area and counter every ~3 minutes for 2 hours; right after that, an "Apartment 1" caption reappears mid-run. The "Apartment 1"  
  half is the same V4 gate-widening one-liner; the cadence half is a separate planner issue.

  Separate repo (now shipped):
  - V5 — FE clock vs sim-time: **shipped in `double-front` (branch `local`, 3 commits)** post-`20260505-2`. Phase A + B + B.1 cover display sites (UTC-pinned), all FE ingest boundaries (slice + API normalizers + `personaMapping` + `execute_next` dispatch), and `action_start_time` (BE-confirmed sim-clock). Cross-repo `sim_time_iso` rename declined in favor of FE-only canonicalization. Pending smoke checks (two-TZ parity, headless run, memory-filter spot-check) — see Issue 5 detail block above and FE worklog 2026-05-05.

  Net: 2 of 5 fully shipped, 2 with one-line follow-ups identified, **V5 now shipped on FE post-`20260505-2`**. 3 newly-surfaced bugs (A/B/C) need their own work.


## *Sim 20260506-1 Results*

  - V1, V2, V3 surface, V4 surface, V5 BE-side — all ✅ confirmed working in this sim.
  - V3 + V4 share one remaining gap: the nested partial_state.action_progress.action_description field carries a parallel copy of the action string that bypasses both the sanitizer and the relabel helper.     
  Closing it is one ~4-line change at the contract emit site.
  - Bug B (nested wait-state churn) reproduced at sim-step 191 — much earlier than the baseline's ≥1 900. It's now investigable on a 250-step sim instead of needing a 2 000-step run.
  - Bug A and Bug C weren't reachable at this length; defer to the next long sim.
  - Issue 2 broader staff zones (Gosha at refrigerator 55 steps, behind pub bar 11 steps) still leak — V2 only addressed piano/microphone, as the v2 doc Consolidated Status correctly anticipated.

┌───────────────────────────────────────────────┬─────────────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────────────────┐    
│                  What to fix                  │                     Evidence in 20260506-1                      │                                 Why no new sim needed                                 │  
├───────────────────────────────────────────────┼─────────────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────┤
│ V3 + V4 nested-field gap (one ~4-line change  │ 24 V3 hits at Gosha 191–222; 42 V4 hits at Katya/Luba 0–20      │ Both leak in the same field (partial_state.action_progress.action_description); fix   │    
│ closes both)                                  │                                                                 │ is at the contract emit site                                                          │    
├───────────────────────────────────────────────┼─────────────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────┤    
│ Bug B planner-lifecycle re-entrancy           │ Gosha 191–222, tile-flap [72,24] ↔ [74,23], nested (waiting to  │ Reproduces at step 191 — clean trace site, 32 steps of evidence                       │    
│                                               │ start X (waiting to start Y clauses                             │                                                                                       │    
├───────────────────────────────────────────────┼─────────────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────┤    
│ Issue 2 broader staff zones (refrigerator,    │ Gosha at refrigerator 55 steps doing study/notes; Gosha behind  │ Both classic Issue-2 patterns, present in this run                                    │    
│ pub bar)                                      │ pub bar 11 steps "memorize key lines"                           │                                                                                       │    
├───────────────────────────────────────────────┼─────────────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────┤    
│ Stale-description-after-arrival (cosmetic)    │ 74 step-records of mode=stationary with travel verbs            │ Distinct from Bug A; reproducible immediately                                         │    
└───────────────────────────────────────────────┴─────────────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────────────────────────────────┘    

  Defer until the next ≥2 000-step sim:
  - Bug A (Ivan frozen with "riding to" caption) — baseline reproduction at sim-step 1 924, not reachable at 250.
  - Bug C (Luba 3-min subtask cadence + late "Apartment 1") — reproduces at sim-step 2 054 in baseline.

  Suggested sequence:

### [x] *Fix 1: V3 + V4 nested-field gap*

```scratch.py:

  description = progress.get('action_description')
  if description:
      progress['action_description'] = relabel_stale_place_text(
          sanitize_emit_text(description),
          progress.get('resolved_address'),
          self.living_area,
      )
```

### [x] *Bug B: Faulty “waiting to start …” wrap*

When a persona enters wait state and the planner re-decomposes the schedule, prior (subtask) decorators are now stripped from the existing entries instead of compounding. The wait-target parser also handles unclosed parens gracefully (treats them as malformed, takes the pre-paren content).
This stops the nested "waiting to start X (waiting to start Y (waiting to start Z..." cascade and the underlying tile-flapping that grew with each cycle.

### [p] *Issue 2 (action-location mismatch)*
  Existing taxonomy (already shipped):
  - staff_only: True is a per-object flag in maze_registry.json                                           
  - Already tagged: behind the cafe counter, behind the bar counter, behind the supply store counter,
  behind the grocery counter, behind the pharmacy counter
  - Resolver has post-resolution validator (_validate_address_post_resolution in location_resolver.py:709)
   that cascades non-workers off staff_only objects to a fallback (work_area → living_area → activity-type
   alternative)
  - work_area is per-persona; non-workers (work_area=None) are subject to the check

<Two gaps:>

#### [X] Gap 1 — registry coverage (Gosha at cafe refrigerator, 55 steps)

  Commercial-kitchen objects in cafe + pub are NOT tagged staff_only:
  - Hobbs Cafe:cafe:refrigerator, cooking area, kitchen sink
  - Rose and Crown Pub:pub:refrigerator, cooking area, kitchen sink

  Residential equivalents (apartments, dorm, co-living kitchen) correctly stay untagged — those are       
  personal/shared kitchens. Fix is data-only: add staff_only: True to those 6 entries. The existing       
  resolver check fires automatically.

#### [?] Gap 2 — (if Gap 1 alone is not enough)

  behind the bar counter IS already tagged staff_only: True, Gosha's work_area = None (confirmed from her 
  bootstrap scratch), so the check should fire — but the trace shows zone_resolution = "exact_address" and
   the address landed without being remapped. Some path is producing this address without going through   
  _validate_address_post_resolution. Could be:
  - A cached / inherited address path (chat target, observed neighbor, bootstrap seed) that bypasses the  
  resolver
  - The cascade fired and Tier 4 (living_area = Dorm Room 4) failed silently and returned the original    
  - A pre-existing code path that sets act_address directly

## *Test Sim 20260506-4*

  Headline: 5 of 6 fixes confirmed working in the wild. The one open issue is the Gap 2 resolver bypass we already knew about — and it's now demonstrably letting Gap 1   leak too on the same code path.
                                                                                                                                                                        
  ✅ Confirmed working                                                                                                                                                  

  ┌──────────────────────────┬────────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐   
  │           Fix            │ Result │                                                          Evidence                                                           │   
  ├──────────────────────────┼────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤   
  │ V1 sleep ping-pong       │ Clean  │ Ivan in bed 149/150 sleep-window steps; clean walk-out at step 150                                                          │   
  ├──────────────────────────┼────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤   
  │ V3 text sanitization     │ Clean  │ 0 <waiting> markers, 0 truncations across 1200 step-records × all fields                                                    │   
  │ (surface AND nested)     │        │                                                                                                                             │   
  ├──────────────────────────┼────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤   
  │ V4 Apartment relabel     │ Clean  │ 0 hits in description / intent / act_description / nested progress.action_description                                       │   
  │ (display text)           │        │                                                                                                                             │   
  ├──────────────────────────┼────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤   
  │ Bug B wait-wrap          │ Clean  │ 0 nested-wait clauses, 0 unclosed-wait seeds across 300 steps × 4 personas. All 10 long-stationary tile-flap bands now      │   
  │ compounding              │        │ classified "benign idle" — no wait-wrap text co-occurs in any of them. Pre-fix 20260506-1 had 24+ hits in a 32-step window. │   
  ├──────────────────────────┼────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤   
  │ Issue 2 Gap 1 — cafe     │ Clean  │ Gosha at cafe-customer-seating across her morning study window, NOT at refrigerator. Pre-fix: 55 steps at refrigerator.     │   
  │ side                     │        │                                                                                                                             │   
  └──────────────────────────┴────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘   

  🟡 Two small residuals — not actionable

  V2 piano: 1 stray hit. Katya step 210, address resolved to piano while doing "skim final strategy notes for clarity". Description's @-suffix says cafe customer       
  seating (different from address_label). 1 hit in 1200 step-records (~0.08%), down from 4 in 20260505-3 and 26 in 20260505-2. Persistent edge case, not a regression.  

  V4: 2 "Apartment 2" hits at Ivan step 279. Investigated — this is a single transit frame during Ivan walking back to the cafe (step 280: "walk to Hobbs Cafe and find 
  a seat"). The address fields briefly resolved to the Ville:Apartment 2:main room for one step. These are structural address-tree references, not display-text leaks — 
  Apartment 2 is a real sector in this sim, and the surface description correctly says "walk to Hobbs Cafe". My Fix 1 correctly doesn't relabel address strings (would  
  corrupt real addresses). The analyzer is over-reporting here; tightening V4 detection to display-text fields only is a small follow-up.

  ❌ Confirmed open: Issue 2 Gap 2 (and Gap 1 partial leak via same path)

  Ivan steps 258–278: one connected episode demonstrates the same bypass for both gaps.

  ┌────────────┬────────────────────────────────────────────────────┬───────────────────────────┬─────────────────────┐
  │ Step range │                      Address                       │          Tagged?          │        Type         │
  ├────────────┼────────────────────────────────────────────────────┼───────────────────────────┼─────────────────────┤
  │ 260–270    │ Hobbs Cafe:cafe:behind the cafe counter            │ Pre-existing staff_only   │ Gap 2 (11 hits)     │
  ├────────────┼────────────────────────────────────────────────────┼───────────────────────────┼─────────────────────┤
  │ 271–278    │ Rose and Crown Pub:pub:cooking area / kitchen sink │ New staff_only (this fix) │ Gap 1 leak (8 hits) │
  └────────────┴────────────────────────────────────────────────────┴───────────────────────────┴─────────────────────┘

  Action description: "prepare short talking points for challenge". All hits show zone_resolution = exact_address, meaning the address was resolved upstream via a path 
  that bypassed _validate_address_post_resolution. Same architectural bug for both gaps.

  This is now a clean reproduction site for the Gap 2 investigation: Ivan's challenge-prep flow at step ~260 onward. That's roughly 4 sim-hours into a sim — much       
  earlier than I'd assumed (was concerned it might need 1900+ steps).

  What this means for sequencing

  - The five-fix bundle (Fix 1 + Bug B + Issue 2 Gap 1 registry) is ship-ready based on this run. Ivan's bypass episode doesn't undo any of them — it just exposes that 
  Gap 2 is real and now also affecting Gap 1's new tags.
  - Gap 2 investigation is the next concrete piece of work if you want full Issue 2 closure. The reproduction site is at step ~260 of a 300-step fork — no need for a   
  long sim.
  - One small follow-up: tighten the analyzer's V4 detection to skip address-tree fields (current_action, resolved_address) — they're structural, not display text. ~2  
  lines.

### [X] *Fix: delete the `affordance_repick` branch from `_validate_address_post_resolution`*

- [x] **Removed affordance_repick from post-resolution validator (closes Issue 2 Gap 2 + Gap 1 residual leaks)**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Deleted the soft affordance-repick branch in `_validate_address_post_resolution`; kept the staff_only / bed_non_sleep / activity_whitelist hard gates and the `affordance_required` hard reject. Repick was rewriting safe upstream answers (e.g. `cafe customer seating`) into staff-only zones (e.g. `behind the cafe counter`) on stem-token matches like "prepare". 3000-step replay on 20260505-3 shows ~209 sim-step bypasses eliminated, 0 safety regressions, 14/155 unique guard resolves go from unsafe to safe; LLM-pick replay (151 calls) confirms zero corruption events on the LLM path. Aligns with `sot_action-location.md` §2.3/§2.4 (hard gates only; soft scoring must not override hard gates).


### *Then more*
  - [x] **Daily-plan prompt: tell the LLM where the persona LIVES (closes Apartment N leak at the source)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_daily_plan` now derives `home_label` from `persona.scratch.living_area` (formatted `<sector>: <arena>`, e.g. `Dorm for Oak Hill College: Dorm Room 3`) and appends it as INPUT 7 of the daily-plan prompt.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: added `Home: !<INPUT 7>!` line directly after "In general, …" and a new ACTIVITY RULE pinning sleep / wake-up / breakfast / evening wind-down / "in my room" activities to the persona's Home (preserves anonymized asset names like `Apartment N`, just stops the LLM from picking the wrong one as a persona's home).
   - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: same two changes applied to the non-survival template.
   - Why: replay of 20260505-3 daily-plan dumps showed the prompt listed all 19 accessible sectors but never identified which was the persona's home; LLM picked Apartment 2 / Apartment 1 / etc. as Katya's and Gosha's home, leaking "at Apartment 2" into hourly schedule entries → activity text → action_location_unified prompts. Edge cases verified (full address, sector-only, empty, None all map to a sensible label).

- [x] **Curated context: drop staff_only objects from LLM location tree for non-workers**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: `_build_filtered_location_tree` now reads `persona.scratch.work_area` and filters `staff_only` objects out of each arena's object list unless the arena address is prefixed by `work_area` (worker bypass — Luba keeps cafe workspace; Ivan/Gosha/Katya never see `behind the cafe counter`, `cooking area`, `kitchen sink`, `refrigerator`, `behind the bar counter`, `shelf`, etc.). Mirrors the validator's `staff_only` check exactly so the LLM literally cannot pick what the hard gate would reject — defense-in-depth, prevention before rescue. Verified: smoke tests pass (Ivan tree contains zero staff-only objects across all 12 registry-tagged addresses; Luba still sees cafe workspace, not pub); existing test suites green (`test_affordance_required` 5/5, `test_action_text_sanitization` 35/35, `test_movement_realism` exit 0).

## *Test Sim 20260506-5* (authoritative: `generative_agents/environment/frontend_server/storage/20260506-5/20260506-5_report.md`)

**Purpose**: Validate three surgical fixes on branch `ivan/action-location` against a fresh **3000-step** Survival sim, vs pre-fix baseline **`20260505-3`**.

1. **`affordance_repick`** removed from `_validate_address_post_resolution` (post-validator hard-gates only).  
2. **Curated context:** `staff_only` objects omitted from the action-location LLM tree for non-workers (`work_area` bypass for Luba).  
3. **Daily-plan `Home:`** — persona home (sector + arena) in prompt + ACTIVITY RULE pinning sleep / wake / breakfast / evening to home.

**Method**: Fork `20260506-5` with inherited `daily_req`; day rollovers ~24h / ~48h (≈ steps 1050 and 2490) exercise daily-plan regeneration; analyzer `python tests/analyze_v1_v4.py 20260506-5`; cross-check `logs/llm/*.json` for `Home:` and `Apartment` text. *Generated 2026-05-07.*

### TL;DR (report table)

| | 20260505-3 (pre-fix) | 20260506-5 (post-fix) | Δ |
| --- | --- | --- | --- |
| **Persona-step events at staff-only zones (non-workers)** | **209** | **5** | **−97.6%** |
| Daily-plan outputs containing `Apartment N` (residential leak) | many | **0 / 15 calls** | closed |
| Stale-`Apartment N` / V4 analyzer across fields | non-zero | **0** | closed |
| Wait-wrap nested clauses (Bug B) | (closed earlier) | **0** | held |
| Piano off-target (V2) | 4 | **1** | −75% |
| Travel-verb in-place (Bug A) | (closed earlier) | **0** | held |

**Verdict (report):** Steps 1–3 behave as intended end-to-end. The **5** residuals are **one Gosha episode** (~86-step window): `address_label` stamped `cooking area` while the visible `@`-suffix still says **`cafe customer seating`** — field divergence on a path that likely **bypasses** `_validate_address_post_resolution`, as in **`sot_action-location.md` §7.2**. **Recommend:** merge `ivan/action-location` to `main` per README §C; track the 5-step episode under §7.2; optional research follow-up per SOT §9.

### Fix 1 — no `affordance_repick` (Issue 2 Gap 2)

| | 20260505-3 | 20260506-5 |
| --- | --- | --- |
| Non-worker resolutions to **Gap 2** objects (pre-tagged `staff_only`) | 209 sim-step bypasses | **0** |

Baseline worst offenders (do **not** recur on `20260506-5`): e.g. Gosha 150 steps at `Hobbs Cafe:cafe:refrigerator` (steps 2850–2999); Katya 120 steps at pub `behind the bar counter` (375–494); Gosha 34 steps at `kitchen sink` (1491–1524).

### Fix 2 — curated LLM tree (Gap 1)

| | 20260506-5 |
| --- | --- |
| **`staff_only` in `action_location_unified` trees** (strict match; non-workers) | **0** |
| Non-worker hits on newly tagged Gap-1-class objects (analyzer) | **5** records — **not** LLM picks; see residual sample |

**Residual sample** (`movement/<step>.json`): step **2218** — `address_label` = `…Hobbs Cafe:cafe:cooking area`, description = `…@ …Hobbs Cafe:cafe:cafe customer seating`. Steps **2300–2304**: same pattern for a second caption. **~5 / 9182** persona-steps (~**0.05%**); intent remains customer seating; issue is **dual-field stamping**, not gross planner routing.

### Fix 3 — daily-plan `Home:`

**15** `run_gpt_prompt_daily_plan` calls — **15/15** prompts include **`Home: <sector>: <arena>`**; **0** outputs contain **`Apartment`**. Example post-fix schedule line (Katya, step 2490): activities anchored **in Dorm for Oak Hill College** vs pre-fix **at Apartment 2**. V4 analyzer: **Total Apartment-N hits across all fields: 0**.

### Other regression checks (report)

| Check | Result | Notes |
| --- | --- | --- |
| **V1** sleep ping-pong (Ivan 0–200) | Comparable to pre-fix | 201 steps sampled; 149/201 within 3 tiles of bed; no ping-pong regression |
| **V3** sanitization | **0** `<waiting>`, **0** known truncations | Held |
| **V4** stale relabel | **0** across **9182** persona-steps × all fields | Held + source closure |
| **Bug B** wait-wrap | **0** nested / unclosed seeds | Held |
| **Bug A** travel-verb | **0** hits | Held |
| **Idle bands** | **53** bands ≥30 steps, ≤3 tiles | All classified **benign idle** (no wait-wrap co-occurrence) |

### Comparison summary (report)

| Metric | 20260505-3 | 20260506-5 |
| --- | --- | --- |
| Non-worker bypasses (total persona-steps) | 209 | **5** |
| Gap 2 bypasses | 209 | **0** |
| Gap 1 contexts | 14 unique (pre-fix replay) | **5** records, one persona, one episode |
| Daily-plan `Apartment` leak | many | **0 / 15** |
| V2 piano off-target | 4 | **1** |

**Persona record counts:** Ivan **871**, Gosha **2311**, Katya **3000**, Luba **3000** — **expected behaviour, not dropout**: in Survival Mode, voted-out sprites stop participating in subsequent phases. Same pattern as `20260505-3`. No follow-up needed.

---

## *Follow-up LLM-aided inspection on `20260506-5`* (2026-05-07)

After the report shipped, three new analyzer signals were added (`tests/analyze_action-location.py`) and verified by sampling actual movement JSONs. The signals classified, then re-classified, what was previously called open. Net: **all four open items below are either zero, transit-only, or worker-shuffle data integrity. Nothing is shipping-blocking.**

### Address-field divergence (`address_label` ≠ description's `@`-suffix)

Detector finds **353** divergent persona-steps across the run. Sampling consecutive steps around 5 cases shows two patterns:

| Sub-class | Count | Severity | What it really is |
| --- | --- | --- | --- |
| `cross_sector` (different building) | 202 (57%) | **None** | One-step transit lag at task transitions: new action's `@` carries the *target*; `address_label` still reflects pos at end of last step. Verified on Luba step 21 (`Dorm` → `Hobbs Cafe`) — by step 22 both fields agree. |
| `cross_arena` (same building, different room) | 37 (10.5%) | **None–Low** | Same transit-lag mechanism + step-0 initial-state mismatches (waking up routine pointing at one dorm-room object while addr_label resolved to another). |
| `same_arena_leaf` (same arena, different leaf object) | 114 (32%) | **Low–Medium** | This is the §7.2-style pattern. **103 / 114 are Luba** (cafe owner) bouncing between staff stations within the cafe (`kitchen sink` / `cooking area` / `behind the cafe counter`). Not a safety leak (she's the worker), but a real data-integrity issue: planner picks one station, addr_label resolves to another within the same arena. The remaining ~11 (mostly Gosha) include the originally documented 5-step cooking-area episode. |

**Net real residual on the §7.2 path: ~11 non-worker persona-steps over 9182 (0.12%).** Down from the report's narrow "5" framing only because the broader scan picked up small clusters elsewhere; they all share the same upstream-emit-path mechanism.

### Long idle bands — false alarms (overnight sleep)

Detector now suppresses overnight sleep bands. **6 of the 53 originally-reported "benign idle" bands are characters sleeping in bed at night** (sim-time 22:00–06:00). Verified by sampling: every step has `description: "sleeping @ …:bed"` with `pos` drifting 1–3 tiles from sleep animation. Not a behavioural problem; the detector was over-reporting.

The remaining ~47 daytime "benign idle" bands are Survival-Mode "gathering at cafe / classroom" — characters stationary while doing strategy / observation tasks. Inspected, not bug-shaped (no wait-wrap text, descriptions evolve naturally).

### Bug C cadence — does **not** reproduce in `20260506-5`

The original baseline pattern (Luba flipping cafe stations every ~3 min for 2h) does not appear in this run. The detector's first hit (Gosha steps 167–199, dorm common room) was **a false positive on transit**: Gosha walked from pos 86,33 to 119,49 across the dorm; the leaf field flapped between `common room` and `common room table` as he crossed tile boundaries. Stationarity filter (pos range ≤3 tiles) added to the detector — closes this false positive.

**Plausible explanation for non-reproduction**: Fix 3's `Home:` daily-plan anchor scrubbed `Apartment N` keyword leakage, which in turn changed how Luba's hourly tasks decompose. The cafe-cadence behaviour was likely downstream of the same daily-plan leak.

### Hallucination cluster — covered in `20260507_pure-llm-resolver-research.md` §11.4

6 of 251 LLM picks (2.4%) are invented addresses, all clustered to 2 outlier persona-steps (Luba's `Dorm Room 2:refrigerator` × 3 at step 1453; Luba's `Hobbs Cafe:kitchen|cooking area|...:refrigerator` × 3 at step 575). All caught by `__func_validate` retry + fail_safe; none reach the FE. Pure-LLM Phase 1 (strict-schema enum) closes this class by construction.

### Severity & sequencing summary

| Open item | Severity | Action |
| --- | --- | --- |
| §7.2 same-arena-leaf (Luba worker shuffling + ~11 non-worker) | **Low–Medium** | Track under SOT §7.2's known-limitation umbrella; not blocking. Pure-LLM Phase 1 doesn't fix it (different code path). Defer alongside pure-LLM rollout. |
| Hallucination cluster (2.4 % LLM picks) | **Low** | Below "worth fixing" threshold (5 %) per `20260507_pure-llm-resolver-research.md` §11.2. Defer to pure-LLM Phase 1 trigger. |
| Bug A (travel-verb in-place) | **None observed** | 0 hits in 3000 steps; baseline reproduction window covered. Close as regression-cleared on this run. |
| Bug C cadence | **None observed** | Does not reproduce. Likely downstream of Fix 3. Monitor on next long sim. |
| Long idle bands | **None — detector noise** | False alarm on overnight sleep. Detector filter added. |

**Recommendation:** ship `ivan/action-location` to `main`. The §7.2 residual and the hallucination cluster ride along with the pure-LLM rollout per `20260507_pure-llm-resolver-research.md` §11.5 trigger gates — neither warrants its own fix round.

*Detector additions in `tests/analyze_action-location.py`: persona record counts, sub-arena cadence detector with stationarity filter, address-field divergence detector with prefix-aware comparison, overnight-sleep-band suppression. Worklog 2026-05-07.*