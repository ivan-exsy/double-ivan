# MVP Cleanup Tracker

**Cycle context:** the simulation reached MVP-ready state in mid-May. Since 2026-05-19 we have been polishing remaining behavioural warts rather than adding features — engine fixes through 5/21, cognitive rework 5/22-23, action-location and memory-dedup hardening 5/24, challenge-attendance prompt rework + per-sim planning-cache isolation 5/25. This doc tracks what's open, what's done, and what each verification sim has taught us.

---

## 🎯 Next steps

**Status (2026-05-26):** `20260525-5` finished. Verdict: borderline pass — Day 1 challenge 50%, Day 2 + Day 3 challenge 100% via early spatial_gate, voting 100% all days. **Promoted as MVP backend baseline.** See `environment/frontend_server/storage/20260525-5/20260525-5_report.md` for the full report.

1. **DONE — `20260525-5` promoted as MVP baseline** via `SELECT public.mark_as_baseline('20260525-5');`. Day-2/Day-3 perfection + voting clean + durable Group C wins (`dup_factor` 1.00, Class C2 = 0) outweigh the Day-1 stochastic miss. Day-1 miss isolated to hourly-LLM verb stochasticity (Luba: "arriving at" vs "settling in at" on consecutive days, same plan shape).
2. **NEXT — Merge `ivan/challenge-arrival-buffer` to `main`** per README §C: `git fetch` → rebase on `origin/main` → `git push --force-with-lease` (feature branch only) → fast-forward merge to `main` → push plain.
3. **NEXT — Run the clean-experiment sim `20260525-6`** — fork from the new `20260525-5` baseline with the 5/25 prompt rework REVERTED (keep 5/24 fixes + per-sim cache). Tests whether the prompt rework was load-bearing or over-engineering. Sharpened hypothesis: with Day-1 attendance now traced to LLM verb stochasticity (not rule wording), the prompt rework's contribution may be smaller than expected. **Full plan in `D:\Coding\double-docs\20260522_be_debt.md` (2026-05-26 entry).**
4. **If `20260525-6` ≥ Day-1 75% (matches or beats `20260525-5`)** → the prompt rework was over-engineering. Swap MVP baseline to `20260525-6`, revert the prompt complexity permanently.
5. **If `20260525-6` < Day-1 75%** → keep `20260525-5` as MVP baseline, close the experiment, justify the prompt rework as load-bearing.
6. **One-time hygiene after the merge** — wipe `reverie/backend_server/planning_cache/`. The shared folder is no longer read or written by the runtime; deletion is purely cosmetic.
7. **Two post-MVP follow-ups** filed in `D:\Coding\double-docs\20260522_be_debt.md` (2026-05-26 entry):
   - Class A new shape — kitchen-object anchor (refrigerator/toaster) lands at adjacent `cooking area` within the same kitchen. 2 of 7 Class A cases on this sim.
   - Hourly-LLM verb stochasticity for pre-event slot — fix via deterministic post-LLM rewrite OR a restricted verb enum in the prompt.
8. **Existing post-MVP queue (unchanged):** Group B (decomp anchor extraction), Phase 1 strict-schema enum for the LLM resolver.

---

## 🟡 Open issues

### 1. Day-1 / Day-3 challenge attendance dip *(RCA complete; Option-A.2 + per-sim cache landed and verified on `20260525-5`; Day-2/Day-3 clean; Day-1 residual is verb stochasticity, not rule wording — see [Open Issue #5](#5-test-whether-the-525-prompt-rework-is-load-bearing-clean-experiment) and `D:\Coding\double-docs\20260522_be_debt.md`)*
- **What viewers see:** on Day 1 and Day 3, half or more of the alive personas physically miss the challenge venue at challenge time. They still participate (the event mechanic records them), but they're not at the venue.
- **Original root cause** (traced from the controller's own deadline log + per-step movement snapshots):
  1. The survival prompt told the planner "attend the daily challenge at <cafe> at 11:00" — interpreted by the LLM as "do this action AT 11:00", not "be there BY 11:00". So daily plans scheduled "arrive at cafe" actions starting at exactly 11:00, with no travel buffer.
  2. The hourly scheduler had a rule "if the persona needs to travel, that's a separate hourly activity" — forcing the LLM to allocate a full 60-minute slot to walking, even though real walks in the village are 5–15 minutes. Either travel was over-allocated (whole hour spent walking) or skipped entirely between buckets.
  3. The controller's spatial gate threshold (80%, round-half-up) becomes 2/2 = 100% for the final-two day — Day 3 fails on a single straggler.
- **First fix attempt — landed 2026-05-25, FAILED on verification sim `20260525-1`:**
  - Calendar event wording rewritten from "attend the X at HH:MM" to "be at X by HH:MM — plan to arrive 10–15 minutes earlier", applied symmetrically to the challenge and the evening vote.
  - "Travel is a separate hourly activity" rule removed; replaced with "walking takes 5–15 minutes, fold the short walk into the destination activity".
  - Replay-cache normalization regex made flexible so it absorbs the new wording without breaking prompt-hash invariance.
  - Tests green (29 + 11 + 13 + daily-plan-cleanup), but the live sim landed **Day 1 challenge gathering 25%** — worse than the broken baseline's 50%.
- **Why the first fix didn't take (RCA from `20260525-1`, including post-mortem audit of LLM logs):**
  - Daily-plan layer worked **for the three personas whose plans were freshly generated**: Luba, Katya, Gosha all wrote an explicit earlier-arrival item before 11:00. Their daily_req captured the intent correctly.
  - **Audit finding (LLM log scan):** only 3 of 4 personas exercised the first-attempt prompt. Ivan's daily plan was served from a process-wide planning_cache entry written yesterday under the OLD prompt (well within the 24h TTL). His 10–11 slot read "walking from Dorm to Hobbs Cafe" — never saw the fix at all.
  - For the 3 who DID see the new prompt: hourly-schedule layer broke for Katya and Gosha (their 10–11 slots still mirrored travel verbs from daily_req items); Luba came through cleanly.
  - **Mechanism (hourly layer):** the hourly-schedule LLM never receives the calendar deadline as a typed/structural input — only as natural-language items buried inside the 17-item `daily_req` list. The new "fold the short walk into the destination activity" rule is advisory; when the daily_req item itself uses the verb "travel" or "walking", the hourly LLM faithfully mirrors that verb back.
  - **Mechanism (cache layer):** the process-wide planning cache keyed plans by `(persona, date, wake_hour)` with no sim isolation. A fresh fork from `base_family_sim` would inherit plans from any prior sim's run for the same in-game date as long as it was within the 24h wall-clock TTL.
  - **Compounding factor:** 1 of the 3 no-shows (Ivan) was also a Class A resolver bug — "arrive early and rehearse opening lines at cafe piano area" resolved to `Dorm Room 4:desk` via `llm_location_v1`. Unrelated to the calendar wording but reinforces that Class A count is back at 7. Tracked under Issue #2.
- **Option A fix LANDED 2026-05-25 — inject typed calendar facts into the hourly-schedule prompt itself:**
  - Added INPUT 8 slot to `v2/survival_generate_hourly_schedule_v1.txt` carrying the `(gathering_arena, challenge_deadline_hour, vote_deadline_hour)` block.
  - Imperative pre-deadline rule: "the hour SLOT ENDING at HH:MM MUST place the persona AT the event location. Travel verbs (walking, heading, leaving, going to, traveling to) are forbidden in that slot. Use 'arriving at', 'settling in at', or 'at <location>' instead."
  - 10 structural tests in `tests/test_hourly_schedule_calendar.py` cover the helper output across deadline combinations, runtime wiring, and non-survival template isolation.
- **Per-sim cache fix LANDED 2026-05-25 — eliminate cross-sim plan contamination:**
  - Each sim now owns `<sim_folder>/planning_cache/` and points the runtime singleton at that folder via `set_cache_dir`.
  - Process-wide cache at `reverie/backend_server/planning_cache/` is no longer read or written.
  - Forks always start cold — first persona wake-up triggers a fresh LLM call with the active prompt.
  - Defensive cleanup wipes any `planning_cache/` carried over by `copyanything` from a local baseline.
  - 9 structural tests in `tests/test_planning_cache_per_sim.py` cover retargeting, in-memory flush, per-sim isolation, and runtime wiring.
- **Fallback option (Option B) if Option A still leaks on clean verification:** deterministic post-LLM rewrite of any travel-verbed pre-deadline slot. Layer on top of A. Not implemented yet.
- **Full RCA + decision matrix:** `environment/frontend_server/storage/20260525-1/20260525-1_report.md`.
- **Challenge attendance through the cycle** (verified from `survival_day_summaries.json` on each sim):

  | Sim | Day 1 | Day 2 | Day 3 | Days reached | Notes |
  |---|---|---|---|---|---|
  | `20260519-1` | 100% | 100% | — | 2 of 3 | 3 500 steps insufficient for Day 3 |
  | `20260520-1` | 100% | 100% | — | 2 of 3 | Same |
  | `20260521-2` | 100% | 100% | — | 2 of 3 | Same |
  | `20260522-1` | 25% | 33% | — | 2 of 3 | Parser-broken (silent) |
  | `20260523-3` | 0% | — | — | 1 of 3 | Parser-broken (visible) |
  | `20260523-5` | 100% | 100% | 100% | 3 of 3 | First clean full season |
  | `20260524-1` | 50% | 100% | 50% | 3 of 3 | Triggered this RCA. Cache contamination scope unknown — pre-dates the audit. |
  | `20260525-1` | **25%** | — | — | 1 of 3 (stopped at 877 steps) | First fix landed partially — 3 of 4 personas saw the new prompt, Ivan served stale plan from yesterday's cache (TTL bug). Of the 3 fresh plans: 1 clean (Luba), 2 still travel-verbed (Katya, Gosha). |
  | `20260525-2` | — | — | — | invalid | Stopped at step 145. **All 4 personas served stale plans** from contaminated process-wide cache (timestamps pre-dated Option-A landing). Used as the trigger to land per-sim cache isolation. |
  | `20260525-3` | — | — | — | aborted | Failed at startup due to ordering bug in per-sim cache implementation (cache makedirs side-effect flipped `is_new_simulation` False). Fix shipped + regression test added. |
  | `20260525-4` | — | — | — | stopped pre-deadline | Option-A v1 rule wording was ambiguous — LLM put "settling in at" / "arriving at" phrases into the 11–12 challenge hour instead of the 10–11 pre-event hour. 0 of 4 personas at cafe in 10–11 slot. Stopped at step 15 after step-0 forensics revealed the wording bug. Led to Option-A.2 rewording with explicit time ranges. |
  | `20260525-5` | **50%** | **100%** | **100%** | 3 of 3 | First trustworthy verification cycle (Option-A.2 + per-sim cache). Day 2/3 challenges via early spatial_gate (10:11 / 10:10) — fix demonstrably works most of the time. Day 1 deadline fired at 11:00 with Ivan + Luba absent: Luba's 10–11 hourly slot used "arriving at" (transit verb) instead of Day-2/3's "settling in at" (present verb). Same persona, same wake, same plan template — LLM verb stochasticity. Promoted as MVP baseline 2026-05-26. |

### 2. Two remaining action-location bugs *(deferred, not blocking)*
- **"Sit on common-room sofa" → Oak Hill College classroom.** LLM jumped buildings on a sofa anchor. Phase 1 strict-schema enum will close it.
- **"Tidy bed and stash items on shelf" → grocery store shelf.** Multi-noun extraction grabbed the wrong word. Group B (decomp anchor extraction) will close it.

### 3. Day-3 conversation monoculture *(quality debt, small-cast endgame)*
- When only 2 personas remain, ~67% of Day-3 conversations are about the same topic. Small-cast artifact; no clear single lever to pull. Revisit if other priorities clear.

### 4. Cosmetic label drift *(label-only, player-invisible)*
- Apartment-N stale labels and address-field divergence both ticked up slightly in `20260524-1` (10→13, 340→376). Internal field only — never appears in viewer-visible description. Not actionable unless something downstream surfaces it.

### 5. Test whether the 5/25 prompt rework is load-bearing (clean experiment)
- **Why this exists:** we cannot retroactively confirm whether `20260524-1`'s attendance regression (100% → 50%/100%/50%) was caused by 5/24's resolver fixes or by cache contamination. If the latter, the 5/25 prompt rework (calendar wording + Option-A typed deadlines + Option-A.2 explicit time ranges) is over-engineering — permanent prompt complexity added to fix a problem that wasn't really there.
- **How to test:** after `20260525-5` is promoted as MVP baseline (assuming it passes), fork `20260525-6` from the same baseline with ONLY the 5/25 prompt rework reverted — keep the 5/24 resolver/dedup fixes and the per-sim cache fix.
- **Concrete revert (≈ 80 lines):**
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` — restore daily-plan calendar wording from "be at X by HH:MM — plan to arrive 10–15 minutes earlier" back to "attend the X at HH:MM"; remove `_build_survival_hourly_calendar_block` helper and its `prompt_input.append` call site.
  - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt` — remove INPUT 8 declaration + placeholder; restore "If the persona needs to travel to a new location, that is a separate hourly activity" rule.
  - `tests/test_hourly_schedule_calendar.py` — remove (covers code that's been reverted).
- **Decision matrix:**
  - `20260525-6` Day-1 ≥ 75% → the prompt rework was over-engineering. Swap MVP baseline to `20260525-6`. Permanent revert.
  - `20260525-6` Day-1 ~50% (matches `20260524-1`) → the 5/24 resolver fixes really did cause the regression. Prompts are load-bearing. Keep `20260525-5` as MVP, close experiment.
  - `20260525-6` Day-1 < 50% → deeper than expected. Investigate before any baseline change.
- **Cost:** one verification sim (~5 hours wall-clock, ~$1–2 LLM) + ~30 min revert + worklog entry.
- **Why this experiment matters:** the cycle's biggest meta-lesson is "don't layer prompt changes without first auditing whether the problem is real". Running this experiment now closes that loop. If the prompts aren't needed, we ship a cleaner MVP. If they are, we have a defensible answer to "why does this rule exist?"

---

## 🧭 Strategic assessment — was the 5/24–5/25 work worth it?

A retrospective written 2026-05-25 after the per-sim cache RCA revealed that prior verification cycles may have been partly invalidated by stale planning caches.

### Was `20260523-5` already MVP-quality?

**User-facing yes, internal-hygiene no.** `20260523-5` shipped 100% / 100% / 100% challenge attendance, 604 conversations, 3/3 natural eliminations — viewer-facing quality was MVP-ready. But it also shipped 8 viewer-visible Class A action-location bugs (sofa/desk/blackboard mismatches), `dup_factor=2.00` polluting Supabase, hallucination rate 6.5%, and the latent cross-sim cache contamination bug that we didn't notice for two more cycles.

### Did we find/fix real issues post-`20260523-5`?

**Mixed — three categories.**

1. **Real wins** (would do again): 5/24 Class A resolver guards (8 → 2 viewer-visible bugs), 5/24 memory dedup (`dup_factor` 2 → 1), 5/25 per-sim planning cache isolation (surfaces and closes a latent contamination bug that affected `20260523-5` too).
2. **Net firefighting** (chasing our own regression): 5/25 calendar-anchor wording, Option-A typed deadlines, Option-A.2 explicit time ranges. These chase an attendance regression that emerged in `20260524-1` — but we don't know whether that regression was real or a cache artifact.
3. **Open question** (resolved by Issue #5 above): whether the prompt rework is load-bearing. Clean experiment plan in Open Issue #5.

### Honest summary

- Days 5/24 internal fixes: clear wins, regardless of attendance outcome.
- Day 5/25 cache fix: clearest durable win of the entire cycle.
- Day 5/25 prompt rework: TBD pending the `20260525-6` experiment. Could be over-engineering, could be load-bearing — we'll know after one more sim.

The biggest meta-lesson: **cache invalidation is a verification-blocker, not a performance concern.** We spent four sims chasing an attendance regression while the cache was silently overriding our prompt changes. Every prompt change from here on must be paired with cache hygiene — which per-sim cache now handles automatically.

---

## ✅ Done in this cleanup cycle

- **MVP baseline promoted — `20260525-5`.** First trustworthy verification cycle (per-sim cache hygiene enforced). Day 2 + Day 3 challenges + all voting clean; Day 1 challenge missed due to hourly-LLM verb stochasticity (post-MVP follow-up in `D:\Coding\double-docs\20260522_be_debt.md`). *(2026-05-26)*
- **Per-sim planning_cache isolation.** Each sim owns `<sim_folder>/planning_cache/`; runtime singleton retargets via `set_cache_dir`. Process-wide cache no longer read or written. Forks always start cold. Surfaces and closes a latent cross-sim contamination bug that affected `20260523-5` and prior. *(branch: `ivan/challenge-arrival-buffer`, 2026-05-25)*
- **Survival challenge attendance — Option-A.2 typed deadlines.** Injects `(gathering_arena, challenge_deadline_hour, vote_deadline_hour)` as a structural input to the hourly-schedule prompt with explicit pre-event time ranges (e.g. "during the 10:00 am – 11:00 am hour slot"). Verified on `20260525-5`: Day 2 + Day 3 challenges via early spatial_gate. Day 1 residual is LLM verb stochasticity (tracked post-MVP). *(branch: `ivan/challenge-arrival-buffer`, 2026-05-25)*
- ~~**Survival challenge attendance — calendar anchor + travel rule rework.**~~ *(superseded by Option-A.2 above)* — first attempt reworded the daily-plan calendar block to deadline framing and removed the hourly-schedule "travel = separate slot" rule. Daily_req layer worked; hourly layer did not. Seed sim `20260525-1` came in at Day-1 challenge **25%**. Mechanism: hourly LLM never sees the typed calendar deadline; advisory fold rule is not strong enough to override travel-verb mirroring from daily_req items. *(branch: `ivan/challenge-arrival-buffer`, 2026-05-25)*
- **Action-location resolver guards (Class A bugs).** 8 → 2 bugs. Wired three existing redirect helpers into the sub-action resolution path, added a new orphan-closet helper, all four guards now apply on both contract paths. *(branch: `ivan/rca-class-a-plus-dedup`, 2026-05-24)*
- **Memory dedup for survival events.** `dup_factor` 2.00 → 1.00 for elimination_witnessed, vote_tally, challenge_outcome. Pre-compaction flush now skips nodes already written durably via the broadcast path. *(same branch)*
- **Class C2 (rest/tidy in dorm → dorm garden).** 1 → 0. Closed by the resolver guard wiring above.
- **Calendar anchoring in daily plans.** Every persona's plan now contains an explicit item for the challenge and the vote at their stated times. Eliminated the rest-spiral collapse. *(2026-05-23)*
- **Daily-plan parser crashes on gpt-5-mini responses.** `__func_clean_up` rewritten to strip trailing digits and guard against empty chunks; deleted 166 corrupted plan-cache files written while the fail-safe plan was silently active. *(2026-05-23)*
- **Cleanup parsers for insight / keyword / decomp-schedule.** Hardened against truncated LLM responses so a single bad line no longer exhausts all retries. *(2026-05-23)*
- **Conversation memory in conversations.** Each persona now sees their own recent ~5 conversations + recent reflections when starting a chat. Removed prescriptive opener/topic rules so dialogue flows from actual memory. *(2026-05-22, Step 3)*
- **Self-check + day-arc.** Throttled introspection call lets a persona's mood feed their decomposition. Self-state reaches the prompt context. *(2026-05-22, Step 2)*
- **Survival overlay reframe.** Survival mode is now context the persona weighs, not a command. Removed the deterministic small-cast guidance machinery. *(2026-05-22, Step 1)*
- **Cross-building bed redirect.** "Tidy bed" / "stretch in bed" actions no longer land inside Hobbs Cafe or the pub when the LLM picked the wrong building. Helper wired into the planner contract path. *(2026-05-21)*
- **Dorm-rest interior redirect (first version).** "Rest" / "tidy" actions no longer land in the outdoor dorm garden — they redirect to the dorm interior. Class C2 5 → 0 at this point. *(2026-05-21)*
- **OSCILLATION sleep gate.** Overnight sleep bands no longer trigger spurious oscillation warnings; only daytime stand-stills (the real signal) remain in the log. *(2026-05-21)*
- **`action_family` payload coverage.** Every persona-step payload now carries `action_family` at the documented path. Coverage 82% → 100%. *(2026-05-20)*
- **Supabase client singleton.** Backend now reuses one Supabase client across the run instead of churning short-lived ones. Removed a class of client-init errors on long runs. *(2026-05-20)*
- **Survival-memory dedup — compounding loop.** Pre-compaction flush was re-eating its own JSON-backup re-inserts, multiplying every elimination/vote memory ~8× over a run. Fixed. `dup_factor` 8.0×/4.4× → 2.0×/2.0×. (The residual 2.0× we believed was "by design" turned out to be the second-write bug closed by Group C on 2026-05-24.) *(2026-05-20)*
- **Class A anchor-repoint helper at three call sites.** Depth-3 promote and depth-4 swap fix for "anchor=bed but resolved to closet/desk" within a dorm room. Raw Class A 39 → 13 (real bugs ~20 → ~8). *(2026-05-19)*
- **4th-call-site anchor-repoint.** Planner-contract main path now also runs the repoint helper. `planner_contract_v1` Class A bugs 7 → 2 on the targeted path. *(2026-05-20)*

---

## 📜 Simulation log (this cycle)

### `20260525-5` — 2026-05-26 — 🟢 PROMOTED AS MVP BASELINE
**Verified:** Day 1 challenge 50% (deadline fire, absent=Ivan+Luba); Day 2 + Day 3 challenge 100% via **early** spatial_gate fires (10:11 and 10:10 — 49 min and 50 min before deadline); voting 100% all three days; 3/3 eliminations natural (Gosha → Ivan → Katya, Luba wins); `dup_factor` 1.00 across every survival event kind; Class C2 = 0; n=2 Day-3 hurdle hit cleanly (hardest test in the suite).
**Revealed:** Day-1 attendance gap traced to **hourly-LLM verb stochasticity**, not Option-A.2 rule wording. Same Luba (wake=6) used "arriving at Hobbs Cafe" (transit verb) on Day 1 vs "settling in at Hobbs Cafe" (present verb) on Day 2 — same plan template, different verb, different outcome. Class A regressed to 7 (vs `20260524-1`'s 2): 2 are a new shape (kitchen-object anchor → adjacent `cooking area`), 2 are bed-cases the orphan-bed helper missed (anchor != "bed"), 3 are unrelated. LLM hallucination 9.2% — inside the stochastic ~6–9% range (`20260524-1`'s 1.9% was a sample-variance low, per its own report). Both Class A new-shape and verb-stochasticity tracked as post-MVP follow-ups.
**Decision:** promoted as MVP backend baseline (`SELECT public.mark_as_baseline('20260525-5');`) despite Day-1 below pass criterion — Day-2/Day-3 perfection + voting compliance + durable infrastructure wins (dup_factor, Class C2, per-sim cache) outweigh the Day-1 verb-stochasticity miss.
**Full report:** `environment/frontend_server/storage/20260525-5/20260525-5_report.md`

### `20260525-1` — 2026-05-25 — 🔴 RED, first challenge-arrival fix attempt failed
**Verified:** voting attendance Day 1 = 100% (spatial_gate fired at step 704); no PLAN_STALL; Day-1 elimination played naturally (Gosha @ step 870); chat-cadence + OSCILLATION on-pace; `dup_factor` regression guard not yet re-measured (sim stopped early).
**Revealed:** Day-1 challenge gathering came in at **25% (1 / 4 personas at cafe)** — worse than the broken baseline's 50%. Mechanism: daily_req layer captured the earlier-arrival intent correctly (all 4 personas wrote an explicit arrival item before 11:00), but the hourly-schedule layer mirrored travel verbs from daily_req items into the 10–11 slot for 3 of 4 personas. The advisory "fold the short walk into the destination activity" rule was not enough to override the LLM's habit of mirroring "travel" / "walking" / "leaving" verbs. Additionally Class A count is back at 7 (target ≤ 5); one no-show (Ivan piano → Dorm Room 4:desk) was caused by a `llm_location_v1` resolver bug, not by planning.
**Sim stopped at 877 / 3 800 steps** — Day-1 result already disqualified the fix; no point burning ~15 more wall-clock hours on Days 2–3.
**Full report:** `environment/frontend_server/storage/20260525-1/20260525-1_report.md`

### `20260524-1` — 2026-05-25 — 🟢 GREEN, ship the fix bundle
**Verified:** Class A 8→2, Class C2 1→0, Class B 340→18, dup_factor 2.00→1.00 across all survival events. Game played out naturally (3 eliminations, Ivan wins). Voting attendance improved to 100% across all three days.
**Revealed:** Day-1 / Day-3 challenge gathering compliance dropped to 50% (was 100% in prior baseline). Not caused by the fix bundle — needs reproducibility check.
**Full report:** `environment/frontend_server/storage/20260524-1/20260524-1_report.md`

### `20260523-5` — pre-fix verification run, full cognitive stack working for the first time
**Verified:** parser fixes landed — daily plans now reach the hourly schedule. Challenge attendance 100%/100%/100%, voting 100%/100%/50%, 604 conversation chat-steps, all 3 eliminations played naturally.
**Revealed:** 8 Class A action-location bugs, 1 Class C2 (Gosha kitchen tidy → dorm garden), `dup_factor=2.00` for elimination/vote (every event written to Supabase twice). These became the targets for the Group A + Group C fixes that followed.

### `20260523-3` — parser-broken sim (diagnostic only)
**Revealed:** gpt-5-mini was returning "2)"-prefixed responses that crashed the daily-plan cleanup parser with IndexError, silently nuking every persona's plan and falling back to a 7-item static fail-safe. 0% Day-1 gathering, 0 conversations, 12 PLAN_STALL events. Fixed same day.
**Note:** all sims before this date silently had the same parser bug — they just weren't recognized as broken because the fail-safe plan looked plausible.

### `20260522-1` — first cognitive-rework sim
**Revealed:** the Step-1 survival overlay rework over-corrected. With survival anchors removed as commands, both Day-3 survivors slept in bed all day — zero conversations, zero gathering, never left their dorm rooms. Self-check (Step 2) produced excellent introspection notes but reinforced the over-rest because there was no structural anchor to balance against. Led to the 2026-05-23 calendar-anchoring fix (challenge + vote as fixed events in every daily plan).

### `20260521-2` — validated cross-building bed + dorm-rest fixes
**Verified:** cross-building bed redirect closed `planner_contract_v1` bed-in-wrong-arena cases (2 → 0). Dorm-rest interior redirect closed Class C2 (5 → 0). OSCILLATION sleep gate suppressed overnight bands cleanly. All four prior-cycle regression guards held; LLM hallucination back below 5% (8.5% → 4.5%). Day-1/Day-2 challenge + voting attendance both 100%.
**Revealed:** Day-3 conversation mode collapse — 15/15 conversations one pair, 87% one topic, 73% robotic openers, Katya spent 8 hours nonstop "pitch prep". This is what drove the 2026-05-22 conversation-quality rework. Also revealed a "5th call site" for the bed redirect: one Katya bed action still landed at the common-room sofa via `llm_location_v1`, which the redirect didn't cover at that point.
**Note:** 3 500 steps ended at Day 2 voting — Day 3 was not reached, so Day-3 attendance is not measurable in this run.

### `20260520-1` — validated four backend fixes
**Verified:** survival-memory dedup compounding loop fixed (8.0×/4.4× → 2.0×/2.0×); `action_family` payload coverage 82% → 100%; Supabase client singleton stable across 3500 steps; planner-contract Class A bugs 7 → 2 on the targeted path. Day-1/Day-2 challenge + voting attendance both 100%.
**Revealed:** the Class A fix only closed its targeted path — total Class A went up (8 → 12) because `llm_location_v1` and `parent_location_inherit_v1` paths now dominated the residual. Class C2 still at 5 (would be closed the next day). LLM hallucination crossed the 5% gate (4.0% → 8.5%), promoting strict-schema enum into the active backlog.
**Note:** 3 500 steps ended at Day 2 — Day 3 was not reached.

### `20260519-1` — first sim of this cleanup cycle, Class A anchor-repoint verified
**Verified:** depth-3 promote + depth-4 swap repoint helper at three call sites. Raw Class A 39 → 13, real bugs ~20 → ~8 (a 60% reduction). Day-1/Day-2 challenge + voting attendance both 100%.
**Revealed:** 7 of 8 remaining real bugs all came through one uncovered code path — the planner-contract main path — which the helper wasn't wired into. This became the next sim's target (closed in `20260520-1`).
**Note:** 3 500 steps ended at Day 2 — Day 3 was not reached.
