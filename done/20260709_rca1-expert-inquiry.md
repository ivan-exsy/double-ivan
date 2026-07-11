# Expert inquiry — RCA-1 post-vote recovery — **DONE**

**Status:** **DONE** (2026-07-10) · Proof sim `20260709-1` · Fix SHA `1db8cbe2`  
**Outcome:** RCA-1 **PASS** — 0 vote-prep at Hobbs steps 2,311–2,400; 14/14 bed/en-route @ 2,450; 14/14 in bed @ 2,489.  
**Plan:** [`20260709_durable_post-vote_planning_6b81b1b9.plan.md`](20260709_durable_post-vote_planning_6b81b1b9.plan.md) · Checklist: [`20260710_checklist.md`](../20260710_checklist.md)

> Historical inquiry body below (root-cause analysis on `20260708-mvp-a`). Kept for forensics after archive to `done/`.

---

## 0. RCA findings — 2026-07-09

### Verdict

**Confirmed root cause: the post-vote injection works, then the same-day planning cache restores the morning’s pre-vote schedule over it.** Directive supersession is present for all 14 survivors in the Day-2 snapshots; the residual is not an unmatched Owen wording variant in `daily_plan_req`, nor a long pre-elimination action that escaped invalidation.

The cache key is only **persona + date + wake hour**. It does not include `daily_plan_req`, `lifestyle`, Survival phase, or an input hash. `_inject_post_vote_outcome` changes those inputs and writes a safe remaining-day schedule, but also sets `last_planned_date=None`. Later in the **same simulation step** (the Survival hook runs before persona planning):

1. `schedule_validator.is_new_day()` returns `First day`.
2. `_long_term_planning()` reuses the already-cached morning plan for the same persona/date/wake hour.
3. The cache-hit branch overwrites both `f_daily_schedule` arrays and returns **before** either planning prompt reads the superseded directive.
4. `_determine_action()` therefore executes the restored pre-vote 21:00 block.

Code path: `survival/controller.py::_inject_post_vote_outcome` → `plan.py::_long_term_planning` → `planning_cache.py::get_cached_plan`. The decisive cache-hit overwrite is in `plan.py` around lines 3,658–3,669; the incomplete key is in `planning_cache.py::get_cache_key`.

**Confidence: high.** A direct VPS cache-hit log would be additional corroboration, but the Supabase snapshots and the only matching code branch already establish the causal chain.

### Runtime evidence from `20260708-mvp-a`

Forensics were run against the `double-openrouter` Supabase project on 2026-07-09.

| Evidence | Finding |
|---|---|
| Outcome delivery | Owen has the durable `vote_concluded` memory naming Vincent Slater. His action also changes at step 2,310, so injection and action invalidation fired. |
| Directive supersession | All 14 survivor Day-2 snapshots contain `(b) the vote has concluded — return home and rest` in `daily_plan_req`. H1 is not the latest-run cause. |
| Injected schedule survival | **0/14** snapshots retain the injected `earlier today — survival preparations and the vote` padding block. Every survivor’s injected schedule was replaced. |
| Owen’s restored block | Owen’s final Day-2 schedule still contains `reviewing notes at home before the vote` in the 21:00 slot, followed by pre-existing note/strategy activities. |
| Fresh-plan evidence | Owen has a morning plan memory for July 9, but no new plan memory at elimination. A fresh `_long_term_planning` path writes that memory; the cache-hit path returns before it. |
| Physical venue | Movement trace resolves Owen’s stale action to the exact target `Oak Hill College:classroom:classroom student seating`. This is a downstream action-location choice, not evidence that the post-vote state was absent. |

The same forensic check across all six full runs shows a stable schedule-overwrite layer beneath the changing symptom; the latest run identifies the cache-hit branch as its cause. “Positive steps” below use the current broad matcher:

| Run | Exact directive supersession | Injected schedule retained | Positive steps / offenders | Venue |
|---|---:|---:|---:|---|
| `20260629-1` | 0/14 | 0/14 | 67 / 12 | Hobbs |
| `20260630-1` | 14/14 | 0/14 | 59 / 2 | Hobbs |
| `20260701-1` | 14/14 | 0/14 | 23 / 3 | Hobbs |
| `20260703-or-2` | 14/14 | 0/14 | 59 / 2 | Away from Hobbs |
| `20260707-chat-probe-v3` | 14/14 | 0/14 | 5 / 1 | Away from Hobbs |
| `20260708-mvp-a` | 14/14 | 0/14 | 42 / 1 | Away from Hobbs |

Owen’s 42 hits are **two executions of the same restored hourly block**, not one uninterrupted old action:

- Steps **2,310–2,315:** `entering Hobbs Cafe and finding a seat`
- Steps **2,316–2,338:** `reviewing notes at home before the vote` at classroom seating (**23 hits**)
- Steps **2,339–2,344:** `entering Hobbs Cafe and finding a seat`
- Steps **2,345–2,363:** the same stale “before the vote” block at classroom seating (**19 hits**)

The flip-flop is amplified by `FORCE_REPLAN_SCHEDULE_ADVANCE`: the forced action selection can jump to the next cached block, then normal current-time indexing returns to the stale 21:00 block.

### Why the symptom moved from Hobbs to the classroom

The underlying defect did **not** migrate; the visible expression changed:

1. **Before injection:** the current vote-prep action could run to completion, so many survivors physically remained at Hobbs.
2. **After invalidation + directive supersession:** cache misses can generate a correct home/rest plan, while cache hits still replay the morning schedule. The residual therefore concentrates in whichever personas happened to receive a late vote-prep block that run.
3. **Across models/runs:** the morning LLM schedule wording and timing vary, so the affected cast count changes.
4. **Away from Hobbs:** the action-location resolver independently mapped Owen’s restored “reviewing notes at home” text to classroom seating. The stale planning text and the venue are separate outputs.

This explains “many at Hobbs” → “few at Hobbs” → “vote-prep wording at a classroom” without requiring chat/seek displacement. For Owen, H6 is not supported by the movement trace.

### Hypothesis disposition

| Hypothesis | Finding |
|---|---|
| H1 — supersede regex missed Owen wording | **Ruled out as primary cause for this run.** Owen’s `(b)` directive was superseded; the bad wording survived inside the cached `f_daily_schedule`. Separate `(c) … tonight's vote` and unconditional Survival calendar cues are not superseded and remain fallback-replan risks. |
| H2 — schedule/action layer copies pre-vote text | **Confirmed, refined:** the layer restores the entire cached morning schedule before action selection. |
| H3 — 2026-07-09 soft brief caused it | **Ruled out for `20260708-mvp-a`.** Owen’s snapshot contains the older “duties suspended / prepare strategically” brief; the soft-brief change was not the source of this run’s schedule. |
| H4 — long action delayed invalidation | **Ruled out for the latest failure.** Owen changes action at step 2,310. Historical runs may still have had this failure mode. |
| H5 — scorer false positive | **Ruled out for Owen.** “Before the vote” after the result is genuinely stale. The scorer has separate correctness defects below. |
| H6 — chat/seek moved the behavior | **Not supported for Owen.** The trace shows ordinary exact-address resolution to classroom seating. |

### Why the existing integration test passed

`tests/test_survival_rca_refix_20260630.py` does not reproduce production:

- It forces `planning_cache.get_cached_plan()` to return `None`, removing the failing branch.
- It uses stub Scratch/Persona objects and calls `_long_term_planning()` directly rather than the full public `plan()` / action-selection path.
- Its mocked planner only tests the exact morning directive, not a real stale cached schedule containing observed variants.
- Its assertion deliberately allows the bare word `vote`, while the release scorer fails any `\bvote\b` match.

The test proves “a cache miss can read a superseded directive.” It does not prove “post-vote injection survives the same-step production planning cycle.”

### Scorer integrity findings

The current failure is real, but the scorer cannot safely certify the next run yet:

1. **Hidden 1,000-row cap:** steps 2,311–2,400 contain **1,260 rows** (90 steps × 14 survivors), but `get_positions()` returns only the first 1,000. The current printout therefore reports 72 distinct steps and silently omits the end of the gate window. A residual confined to the final ~18 steps could falsely pass.
2. **Wrong label / redundant condition:** `if is_vote or (is_hobbs and is_vote)` is just `if is_vote`; the gate is already anywhere, while output still says “at Hobbs.”
3. **Matcher is broader than “prep”:** bare `\bvote\b` also flags legitimate `vote concluded` or post-outcome reflection. Owen fails under either interpretation, but the controller’s injected `reflect on the day's vote` block would also fail the literal current matcher.
4. **Whole-script meal output is not authoritative:** its snapshot parser expects an old schedule shape and prints 0/15. Continue using `score_rca2_meals.py` for meals.

For this MVP cycle, do not loosen the language gate while fixing the behavior. First make the scorer paginate and prove 90/90-step coverage; update the label to “anywhere.” Product intent should be locked as **zero pre-outcome / vote-prep language anywhere**, not Hobbs-only.

### Recommended fix plan

1. **Make the post-vote transition authoritative for the remainder of the day.**
   - Do not allow the generic same-day daily-plan cache to overwrite the injected schedule.
   - Recommended MVP path: persist a post-vote date marker in Scratch, guard `_long_term_planning` while it matches today, keep the deterministic post-vote schedule, stamp `last_planned_date` to the current date, invalidate the same-day planning and task-decomposition caches defensively, and select the current post-vote block without generic force-advance skipping it.
   - On process resume, recognize the persisted `vote has concluded` marker so the in-memory `_post_vote_injected_for` reset cannot restore the morning Survival brief.
   - If any fallback replan remains, suppress the residual `(c) … tonight's vote`, fixed-event vote block, and hourly-calendar vote/prep guidance after the outcome.
2. **Make executable wording gate-safe.**
   - Keep the explicit outcome in memory and plan context.
   - Use neutral executable blocks such as `head home`, `unwind`, `process the day's events`, `get ready for bed`, and `sleep`.
   - Remove `reflect on the day's vote` from the executable window unless the scorer is separately changed after product clarification; it fails today’s literal regex.
3. **Repair the scorer before accepting green.**
   - Paginate `personas_coords`.
   - Hard-fail unless all **90 steps × 14 survivors = 1,260 rows** are present.
   - Rename output from “at Hobbs” to “anywhere.”
4. **Add a fail-first production-path test.**
   - Seed the real disk planning cache with Owen’s exact failed 21:00 block and variants from Alex/Olivia/Andrew.
   - Run the real injection → `schedule_validator` → public `plan()` → `_determine_action` path with only external LLM/embedding calls replayed or mocked.
   - Assert the stale cache is not restored, the first selected action is home/recovery-oriented, no failed variant reaches the executable schedule, and the current scorer matcher has zero hits.
   - Add a resume case so a fresh controller process cannot clobber the persisted post-vote state.

Named failure modes the tests must cover: same-day cache hit; alternate wake-hour cache key; stale task-decomposition cache; process restart losing in-memory gates; force-advance skipping the first recovery block; unconditional Survival calendar/fixed-event vote cues; LLM wording reintroducing `before the vote`; and scorer pagination truncation.

### Acceptance package

RCA-1 can turn green only after all of the following:

1. Narrow tests above pass, including a **real cache-hit regression** and scorer coverage test.
2. One fresh **2,600-step sprint fork** runs on the intended Path A + OpenRouter production configuration with diagnostic capture.
3. Updated RCA scorer proves:
   - complete coverage: **1,260/1,260** survivor rows across steps 2,311–2,400;
   - **zero** current-matcher hits anywhere in that window;
   - step 2,450: ≥10/14 in bed or en route home;
   - step 2,489: ≥10/14 in bed.
4. Regression scorers remain green: dedicated meals, premiere sleep, first-vote attendance, elimination/day/open-ended P0s, and the already-accepted location/hallucination bars.
5. Save the scorer output plus Owen and one clean-survivor post-vote schedule/memory trace, then update `double-docs/15sim-polish.md` §RCA-1.

Recovery-only remains a fail.

**Date:** 2026-07-09  
**From:** Ivan (product)  
**To:** Survival / planner expert team  
**Priority:** P0 — blocks MVP sign-off and `railway` → `main`  
**Latest failing sim:** `20260708-mvp-a` (2,600 steps, VPS, Path A + OpenRouter, completed)

---

## 1. Ask (what we need from you)

Please treat this as a **fresh RCA**, not a re-apply of prior patches. We need:

1. **A causal diagnosis** of why post-elimination survivors still emit “before the vote / vote-prep” language (and/or linger in vote-related planning) after `_inject_post_vote_outcome` + directive supersession have shipped and mostly work.
2. **Why the failure mode has shifted** from “many linger at Hobbs past midnight” → “few linger at Hobbs” → “vote-prep language away from Hobbs (classroom)” across recent full runs.
3. **A fix plan with failure modes named** — including how you will catch the next residual in tests (integration path, not stubbed planner).
4. **An acceptance package** that clears the current gate on one scored 2,600-step fork.

**Do not** mark RCA-1 green on recovery-only (in bed by midnight). The trailer/MVP gate still fails if vote-prep language persists in the post-elim window.

---

## 2. Product symptom (why this matters)

After tribal / elimination (~step **2,310**, ~21:00 sim), survivors should **stop preparing for the vote** and **go home / unwind / sleep**. Trailer beats rely on that beat.

When they keep “reviewing notes before the vote” (even at school, not Hobbs), the evening still reads as **stale game-prep after the outcome is already known** — product-unacceptable for Survival Day 1 trailers.

**Current MVP status:** Chat, meals, sleep, first-vote attendance, hallucination, and Class A (revised ≤20 desk-excl.) are all green on `20260708-mvp-a`. **RCA-1 is the only remaining MVP blocker.**  
Tracker: `double-docs/20260705_close-for-mvp.md`

---

## 3. Gate definition (what “PASS” means)

Scorer: `tests/analyze_20260630_1.py` (RCA-1 section).

| Check | Target |
|-------|--------|
| Steps **2,311–2,400** | **Zero** steps where any survivor matches vote-prep language (`VOTE_PREP_RE` on description / action_family) |
| Step **2,450** (~23:20) | ≥ **10/14** in bed or en-route home |
| Step **2,489** (midnight) | ≥ **10/14** in bed |

**Scorer note (important):** gate printouts still say “zero vote-prep **at Hobbs**”, but the code flags on `is_vote` alone (`if is_vote or (is_hobbs and is_vote)` — Hobbs is redundant). So classroom “before the vote” text **correctly fails** the gate. Product intent = **anywhere**, not Hobbs-only; please tidy the label when you touch the scorer.

**Ship rule:** all three must pass. Recovery-only without clearing the post-elim vote-prep window is still a **FAIL**.

---

## 4. Failure timeline (evidence that prior fixes are incomplete)

### Phase 0 — Pre-fix (baseline bad)

| Sim | Result |
|-----|--------|
| `20260628-4` | Weak recovery; e.g. only **2/14** in bed @ 2,489 (cited as better than the first Batch-1 failure below) |

**Problem class:** post-elim survivors stay in vote world for hours.

---

### Attempt A — Batch 1 injection (shipped 2026-06-29) — **FAILED end-to-end**

**Code intent (`_inject_post_vote_outcome`):**
- Append “vote concluded” to `daily_plan_req`
- Build post-vote evening schedule (home → unwind → reflect → sleep)
- Invalidate current action → force replan next step
- Gate `_post_vote_injected_for` so `_apply_survival_lifestyle` doesn’t clobber
- Broadcast `vote_concluded` memory

**Unit tests:** 14/14 passed (stubbed planner).

**Evidence of failure — sim `20260629-1`:**

Injection **did fire** (14 `vote_concluded` memories; appended plan-req line present), but survivors still vote-prepped through midnight:

| Step | In bed | At Hobbs | Vote-prep |
|------|--------|----------|-----------|
| 2,489 (midnight) | **0/14** | 13/14 | 8/14 |
| 2,490 | 6/14 | 8/14 | 5/14 |
| 2,491 | 11/14 | 3/14 | 2/14 |

Persisted day-2 `f_daily_schedule` remained the **original morning vote-prep plan**; the post-vote evening schedule was **absent**.

**Diagnosed root cause (still important):** injection appended “vote concluded” but **did not remove** the dominant survival priority  
`(b) attend the voting block at Hobbs Cafe before the voting deadline at 20:00`.  
On `force_replan_next_step`, the planner re-read `daily_plan_req`, saw “attend vote”, and **regenerated vote-prep**, clobbering the evening schedule.  
`_post_vote_injected_for` only blocked lifestyle re-apply, **not** the regular replan loop.  
**Test gap:** unit tests stubbed the planner and never exercised **replan → reads plan-req**.

**Doc:** `double-docs/15sim-polish.md` §RCA-1

---

### Attempt B — Directive supersession re-fix (shipped 2026-06-30) — **PARTIAL; strict gate still FAIL**

**Code intent:**
- Regex-replace `(b) attend the voting block …` in `daily_plan_req` **and** `lifestyle` with  
  `(b) the vote has concluded — return home and rest`  
  (`_VOTE_DIRECTIVE_RE` / `_POST_VOTE_DIRECTIVE` in survival controller)

**Tests:** `tests/test_survival_rca_refix_20260630.py` — real replan path (`is_new_day` → `_long_term_planning`), LLM mocked; asserts no vote-prep / has home-sleep. **Passes in CI.**

**Evidence of incomplete fix — sim `20260630-1` (Run 1, OpenAI):**

| Check | Result |
|-------|--------|
| Immediate recovery | **12/14** went home (huge improve vs `20260629-1`) |
| Lingerers | **2/14 at Hobbs:** Olivia King (2,311–2,369, ~59 min “preparing talking points for the evening vote”); Andrew Abrams (2,333–2,354 + again @ 2,420 “prepare and cast evening vote”) |
| @ 2,450 | 13/14 in bed/en-route |
| @ 2,489 | **14/14** in bed |
| **Strict zero gate** | **FAIL** |

Then-hypotheses (unproven as exclusive cause):
- Long `act_duration` delaying invalidation-triggered replan past the gate window
- Replan reading original `(b)` text **before** supersede regex matched (wording drift?)
- Mechanism that worked for 12/14: `last_planned_date=None` → `is_new_day` → same-day `_long_term_planning` reading superseded `daily_plan_req`

**Doc:** `15sim-polish.md` Run 1 results + §RCA-1 re-fix

---

### Attempt C — Merged-branch / OpenRouter full runs — **recovery often green; strict language gate still brittle**

| Sim | Code / model | Strict post-elim window | Recovery @ 2,450 / 2,489 | Notes |
|-----|--------------|-------------------------|---------------------------|-------|
| `20260701-1` (Run 2) | Merged `a7cff6bc`, OpenAI | 11/14 immediate; **3 lingered**, all cleared by ~2,353 | **14/14 / 14/14** | Better than Run 1; strict zero still not clean; residual treated as pre-existing |
| `20260703-or-2` | OpenRouter / DeepSeek | Documented as mostly scorer false positives + 1 genuine lingerer; dinner-at-Hobbs after vote treated as push-later | **14/14 / 14/14** | Used as “survival green” for meals/sleep/RCA recovery; **strict zero still imperfect** |
| `20260707-chat-probe-v3` | Chat P0 live | **FAIL:** **5 steps** vote-prep **language** (Alex @ **classroom**, not Hobbs) | sleep/meals otherwise green | Pattern shifts: **wrong venue, still vote-prep wording** |
| **`20260708-mvp-a`** (current) | Path A + token budget, OpenRouter | **FAIL:** **42 steps** with vote-prep language — **Owen Logan**, desc `reviewing notes at home before the vote` @ **Oak Hill College classroom student seating** (not Hobbs) | **14/14 / 14/14** PASS | Bed recovery strong; **language gate fails hard** |

**Latest scorer excerpt (`20260708-mvp-a`):**
```
Eliminated: Vincent Slater; survivors: 14
Steps 2,311–2,400 with any survivor doing vote-prep at Hobbs: 42
  step 2316–2320… Owen Logan: 'reviewing notes at home before the vote
    @ the Ville:Oak Hill College:classroom:classroom student seating'
>>> RCA-1 OVERALL: FAIL
-- Step 2,450: in bed 13 + en-route 1 = 14 → PASS
-- Step 2,489: in bed 14 → PASS
```

**Keyword detail:** `VOTE_PREP_RE` matches `\bvote\b|voting block|vote[- ]?prep|prepare.{0,20}vote|discuss.{0,20}vote` — Owen’s “before the vote” hits `\bvote\b`. If you tighten keywords, do it *after* confirming product still wants “before the vote” cleared post-elim.

**Scorer vs label:** print says “at Hobbs”, logic is **vote-prep language anywhere** (classroom failures are real fails). Update the print string when convenient; do not loosen the gate to Hobbs-only.

---

## 5. What already works (do not break)

On `20260708-mvp-a` (same package):
- First-vote attendance **15/15** cast ballots (no thin tally)
- Meals 14/14 lunch + dinner (`score_rca2_meals.py`)
- Sleep 14/14 @ step 1,050
- Closed P0s GREEN (vote gate timing, elimination wiring, day labeling, day persistence, open-ended)
- Bed recovery after elim is strong (14/14)

So this is **not** a broad survival collapse — it is a **post-elim planning / wording residual**, concentrated on a small set of survivors (historically Olivia / Andrew; currently Owen; earlier Alex on v3).

---

## 6. Working hypotheses to investigate (non-exhaustive)

Please confirm or kill each with forensics from `20260708-mvp-a` (Scratch / `daily_plan_req` / `lifestyle` / schedule around step 2,310–2,400 for **Owen Logan**, plus spot-check other survivors):

| # | Hypothesis | Why it fits latest fail |
|---|------------|-------------------------|
| H1 | Supersede regex misses wording variants (“reviewing notes… before the vote”, classroom prep, “talking points”, etc.) so LLM regenerates vote-prep from residual brief / lifestyle | Owen text is vote-prep language without being at Hobbs |
| H2 | Post-vote schedule inject succeeds, but **hourly / determine_action** language still copies pre-vote templates | Description says “at home before the vote” while address is classroom — copy/plan mismatch |
| H3 | Soft survival day-brief / realism work (`20260709_survival_realism.md`) re-introduces note-prep language on Survival Day 1 that survives past elim | Soft brief softens jobs; may leave generic “review notes” cues |
| H4 | Invalidation / replan timing: survivor mid-long action at elim → replan late; interim actions still vote-framed | Classic Run 1 linger theory |
| H5 | Scorer false positive / over-broad keyword (“before the vote”) on non-prep travel home actions | Possible — but 42 consecutive Owen steps argue real persistence |
| H6 | Increased chat / seek activity displaces Hobbs linger but not the **verbal** vote-prep script (v3 RCA note) | Explains venue shift classroom vs Hobbs |

---

## 7. Suggested forensic package (minimum)

On VPS / Supabase for **`20260708-mvp-a`**, for **Owen Logan** (and 1–2 clean survivors as controls):

1. At elim step (~2,310): `daily_plan_req`, `lifestyle`, whether `_VOTE_DIRECTIVE_RE` matched, post-vote schedule contents.
2. Steps 2,311–2,400: action descriptions, addresses, `act_duration`, whether force-replan fired and when.
3. Whether `vote_concluded` memory exists for Owen.
4. Diff Owen’s post-elim schedule vs a survivor who went straight home (e.g. someone in the 14/14 bed set who never appears in the vote-prep dump).
5. Re-run scorer locally: `python3 tests/analyze_20260630_1.py 20260708-mvp-a` and document exact match rule for “vote-prep”.

Optional comparison runs already scored: `20260629-1`, `20260630-1`, `20260701-1`, `20260703-or-2`, `20260707-chat-probe-v3`.

---

## 8. Acceptance criteria for the next fix

1. Integration test that exercises **real replan + real plan-req text variants** seen in failed sims (not only the exact `(b) attend the voting block` string).
2. Full sim (or focused fork covering steps ≥2,300): `analyze_20260630_1.py` RCA-1 **OVERALL PASS**.
3. Explicit product clarification locked with Ivan: **zero vote-prep language anywhere** in 2,311–2,400 vs Hobbs-only — recommend **anywhere**.
4. No regression on meals / sleep / first-vote / closed P0s.
5. Short note in `15sim-polish.md` §RCA-1: what failed, what shipped, what score proved it.

---

## 9. Out of scope for this inquiry

- Class A / Path B location residual (location MVP already green on this sim)
- Soft-brief / seek realism digest polish (`20260709_survival_realism.md`) except where it **causes** H3
- Embedding reindex / OpenRouter Phase 8 / `railway`→`main` (blocked until RCA-1 green)

---

## 10. Primary references

| Doc | Why |
|-----|-----|
| `double-docs/15sim-polish.md` §RCA-1 + Run 1 results | Full attempt history + diagnosed replan/plan-req root cause |
| `double-docs/20260705_close-for-mvp.md` | Current gate status; RCA-1 only remaining blocker |
| `double-docs/20260630_merge-openrouter-railway.md` | Run 2 / `20260703-or-2` recovery notes; residual lingerer |
| `tests/test_survival_rca_refix_20260630.py` | Integration test that passed while e2e still fails |
| `tests/analyze_20260630_1.py` | Gate scorer |
| Survival controller: `_inject_post_vote_outcome`, `_VOTE_DIRECTIVE_RE`, `_POST_VOTE_DIRECTIVE` | Shipped fixes under investigation |

**Command (local, against scored sim):**
```bash
python3 tests/analyze_20260630_1.py 20260708-mvp-a
```
