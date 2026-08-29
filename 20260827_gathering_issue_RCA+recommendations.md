# RCA + recommendations — empty Hobbs at the declared clock

## Status (2026-08-29, afternoon)

**Cause of the empty room: found and the code fix is in.** A preference list (`activity_whitelist`) was relocating people who already had the right cafe address. Reading notes tagged `study`; the cafe list does not include `study`; the nearest rooms that do are campus, one dorm, and Apartment 4. That is why the plan said Hobbs and the body walked to college. The relocating branch is **deleted** (`2dea146e`, on `railway` as `273e1f55`). The lists still *rank* places. They no longer *move* a body that already had one.

**What we already know from the two scored runs**

| Run | What we shipped | First 11:00 | Honest text | Read |
|---|---|---|---|---|
| Pass 1 `20260827-1` | Lock + 30-min invite | **3/15** | Fail (caption vs body) | Lock froze the room and invited late. **Frozen — §§1–11.** |
| 1-A `20260828-1` | Lock gone, 1-hour invite, identity, travel-anchor, ritual gate | **6/14** (day-1 **10/15**) | **Pass** | People arrive, then the list walks them off. **§12.** |

Bar is **80% on tiles** at the declared clock (12/15, then 11/14). Start-jump is already green. Do not rewrite SOT §4.7 until gather is too.

**What is not this bug:** chat, sofa re-greets, social seek, the lock (it is gone). **What is still a separate miss:** Shepard — his hour is `asleep`; the planner never booked the appointment. One person. Will not decide the gate.

**Right now**

1. **1-B is running.** `20260829-1` PID `808722` on tip `273e1f55`. Checklist: `20260829-1_checklist.md`. First look ~step 5 (plans), then dests at 10:00–11:00.
2. **Widen decided, not this score.** Sit-only `study` → **32** rooms (not 53). Same later pass: `eat` on eight home living rooms, `work` on six job sites, `play` on cafe/park/gardens. **Do not** stamp bathrooms or add lists to the ten ungated rooms. Datareq 5.
3. **Do not restore the lock. Do not add `study` everywhere.**

**How to read the rest of this file.** Two chapters. Do not mix them.

| Chapter | Sims | Status |
|---|---|---|
| **§§1–11** | `20260827-1` Pass 1 @ `266aa54f` | **Frozen.** Lock writes the caption; the plan moves the body; lock also freezes arrivals. |
| **§12** | `20260828-1` 1-A @ `acf744b8` | **Scored.** Five fixes landed; room still emptied. Cause = whitelist veto (§12.4). Veto **deleted** (§12.11). Widen is a later search-quality edit (§12.10, datareq 5). |

**Founder lock (still out):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12.

Pass 1 evidence: `20260827_challenge_miss_pack/` · `20260828_verify_pack/`.  
1-A evidence: `20260829_leave_pack/` (raw JSON). Score card: `20260828-1_checklist.md`. Key 1-A tables: **§12.9**.

---

## 1. What a viewer saw

At **11:00 on day 1**, three people are on Hobbs (Shepard, Dean, Irene). Twelve others still read “heading to Hobbs” from college, pub, pharmacy, and supply. The Hold board runs anyway. Dean wins. Twelve are recorded **absent**.

Same shape twice more on this sim:

- **Vote 20:00 day 1:** 8 on tiles. Eight real votes. Seven phantom absences. **Alex Butcher** is eliminated on a **3-vote plurality**.
- **Challenge 11:00 day 2:** **6/14**. Silent Pact. Irene holds immunity.

Do not ship gather. Do not call stay-pin or Pass 1 green.

---

## 2. Root cause (one paragraph)

**The gather lock writes the caption. The daily plan moves the body. During the lock window, the lock also freezes arrivals.**

The lock sets the on-screen sentence (“heading to / waiting at Hobbs for the survival appointment”) and a planned cafe address. Walking obeys a different field — the **target zone** (job, library, pub). The lock never writes that field. So people stand still at work while the subtitle says they are walking to the cafe.

Worse: while the lock is on, it restarts each agent’s activity timer **every step**. The daily plan cannot advance. The room stops changing until the lock lets go. Then four people arrive in five to ten minutes — too late for the board.

Pass 1 made the first morning **worse** (9/15 → **3/15**) because the same commit also told the planner “be at Hobbs from **10:30**,” not from 10:00. Five agents scheduled cafe **at/after 11:00**. They were not lost. They were invited late.

---

## 3. Scorecard (tiles at the declared clock)

Primary line is **first competitive 11:00**. Do not headline 25-1’s second morning as the compare.

| Sim | What we tried | First 11:00 | Second 11:00 | First vote 20:00 |
|---|---|---|---|---|
| `20260823-2` | Persist 6-tile reject; ~1 h lock | **8/15** | **11/14** | (prior paper) |
| `20260825-1` | Stay-pin | **9/15** | **6/14** | hit 80% under a **2 h** invitation |
| `20260827-1` Pass 1 | Lock **30 min**; fire at **11:00**; honest text; skip-Premiere | **3/15** | **6/14** | **8/15** (bar 12) · **12/15 at 20:15** |
| `20260828-1` **1-A** | Lock **deleted**; 1 h invitation; identity + travel detach + ritual gate | **10/15** | **6/14** | **9/15** · **14/15 at 20:15** · d2 vote still to score |

**`20260827-1` occupancy shape (same three times):**

| Event | Peak before lock | At lock | At deadline | 5–15 min after |
|---|---|---|---|---|
| Day-1 challenge | **9 at 10:15** | **4 at 10:30** | **3 at 11:00** | 8 at 11:10 |
| Day-1 vote | **10 at 19:10** | 9 at 19:30 | **8 at 20:00** | **12 at 20:15** |
| Day-2 challenge | **9 at 10:15** | **5 at 10:30** | **6 at 11:00** | **10 at 11:05** |

Never ≥12 before a deadline on this sim. Firing at the advertised clock did **not** throw away a full room. Do not recommend fire-when-12.

**Freeze, not drain:** during the vote lock the **same eight names** sat 19:40–20:05 (six identical readings). During the day-2 challenge lock the **same five names** sat 10:30–10:50 (five identical readings). Outside the window the roster turns over every five minutes. Inside it, nothing happens. Then +4 on release, both times.

Five of seven phantom voters (Dean, Owen, Vincent, Alexis, Andrew) walked in within fifteen minutes of losing the vote. Dean had been on cafe at 19:20.

**Health (not the miss):** persist >6 = 0 in scored windows; 15 then 14 people every step; no teleport. Spoken fourth-wall on this run: 0.

---

## 4. Mix of causes (with counts)

| Slice | Role | Evidence |
|---|---|---|
| **Caption vs body** | Primary mechanism | When the line said “heading to Hobbs” and the body was off-cafe: **66 / 589 steps (11%)** moved even one tile toward the cafe. Median walk: **zero**. Speed was **1.0** (not 0.0) — they were free to walk and did not. Marker: `movement_mode` = stationary / in_zone (runtime thinks they already arrived). Measured on **day-1 challenge + vote only** (see open gap). |
| **Lock freezes arrivals** | Why the clock is empty | Timer reset every step; plan cannot advance. Room plateaus until release. |
| **Planner invitation cut 60 → 30 min** | Why day 1 was 3/15 | Same Pass 1 commit as the lock. Day-1 first cafe block at **11:00+** for Butcher, Ivan, Nick, Owen; Mike **11:18**. |
| **Stale identity seed** | Co-cause of the same late cafe blocks — **found 08-28, not in the first RCA** | Every `currently` still reads “On premiere day in Doubland with the **full cohort of fifteen**…” on day 2, eliminated Butcher included. That string sits inside `get_str_iss()`, which is pasted into the **daily-plan prompt**. So the same call says “it is the grace day, nothing is scheduled” **and** “be at Hobbs from 10:30.” Present on 23-2 and 25-1 as well — **not** a skip-Premiere artifact. **Survives recommendation 2.** |
| **Travel anchored to the wrong place** | Why “walking to Hobbs” goes to library/park | Day 1: Alexis “walking to Hobbs” `anchor=library`. Day 2: **13** blocks, same class (park, closet, desk, dorm garden). |
| **Chat chain** | Day-1 10:32 leak only | Vincent → Diana → Alexis. Not the load-bearing miss on vote or day 2. |
| **Skip-Premiere** | Confounder for 3/15, **not** for 6/14 | Agents **did** learn: Ivan 11:00→09:00, Nick→08:00, Owen→07:00. Two of those three sat at day-2 11:00. Day 2 still **6/14** after a 10:15 peak of 9. |
| **Schedule covering the slot** | Necessary, not enough | Day 2: cafe block **covering 10:30** → **5/8 on** at fire vs **1/6** without. Lock saved **nobody**. Even 14/14 coverage at 62.5% hold ≈ **9/14**. Bar is **11**. Invitation alone cannot pass. |

**True never-sit day 1 (05:55–11:00):** Butcher, Ivan, Owen — all reachable (~25–30 tiles). Not “too far.” Mid-run “H3 = 5” was a 09:30 window error (Mike/Nick sat at dawn). Treat the late-plan five as the job cohort, not three librarians to yank.

**Irene** is staff (behind the counter). Contestant occupancy is one lower than the raw n if you exclude her.

---

## 5. What we already tried

| Attempt | What it did | Result |
|---|---|---|
| Gather lock (Jul) | Force last **hour** | Walk-in exists; does not keep (or fill) the room |
| Stay-pin `4ab4f5be` | Reject leave dest while on cafe | 9/15 then 6/14. Walked people **in**. Did not **keep** them. |
| **Pass 1** `266aa54f` | 30-min lock; fire at 11:00; honest dest text; skip-Premiere | **3/15**, **8/15 vote**, **6/14**. Shortened hang **and** invitation. Caption vs body unchanged. |
| **1-A** `acf744b8` | Delete lock; restore 1 h invite; identity; travel detach; ritual gate | Day-1 **10/15** (shape no longer a freeze). Competitive 11:00 still **6/14**. Honest text **Pass**. See **§12**. |

The wait was never the occupancy bug. Shortening it emptied the first morning and left the freeze in place.

Gather-lock tests (18 of them) assert sentence and address. **The words `target_zone` and `movement_mode` do not appear in that file at all.** That is why this shipped green three times.

---

## 6. What not to do

- Do **not** dest-rewrite never-sits / yank librarians. Giving the lock `target_zone` for everyone is the same ban, applied to 15 people.
- Do **not** fail-closed if sit < 80%.
- Do **not** lengthen the pin / all-morning curfew.
- Do **not** fire-when-12 / pull the challenge forward.
- Do **not** rewrite `sot_be-fe.md` §4.7 or `sot_survival.md` gather windows until gather **and** start-jump are green. Live code on this tip is Desired (30 min + declared clock), not last-hour SOT.
- Do **not** patch `20260827-1`. Vote **20:00 day 2** (step **2285**) is still worth scoring. Snapshot scratch before step **2525** if day-2 schedules must be re-read (this pack already has them).

---

## 7. Recommendations (next fork, not this runner)

**Shipped as 1-A** (`ivan/gather-1a` @ `acf744b8`). What each chunk actually found is in §7A. What the score sim did is **§12** — do not treat this table as the live diagnosis.

Naturalness-first. **Less** coercion first.

| # | Change | Why |
|---|---|---|
| **1** | **Turn the gather lock off** (delete or no-op) for one fork | Cheapest test. Stops the viewer lie. Stops the freeze (~**+4** at the clock if the after-surge is people who would have arrived). Opposite of a pin. |
| **2** | **Tell the planner “be at Hobbs from 10:00”** (prompt `lead_hours` **1.0**), **decoupled** from the lock | Recovers the day-1 invitation. Day 2 already self-corrected *first* cafe time; still need the **deadline slot** covered. Necessary, not sufficient. |
| **3** | **Travel tasks must anchor to the named destination** | “Walking to Hobbs” cannot inherit library / park / closet / desk. Prompt + decompose example. |
| **4** | **Refresh the `currently` identity seed** per survival day (day number, who is left) | It is *inside the daily-plan prompt* telling the planner it is premiere day with fifteen people. Contradicts (2) in the same LLM call and **survives** (2) — fix (2) alone and the late cafe blocks may not move. Same field also feeds chat and the ranker digest, so it is the one item that pays into **both** failing MVP gates. Cheapest change on this list. |
| **5** | **Gate ritual verbs on cafe tiles** (“casting vote”, “challenge briefing”) | (1) removes ~**930 of ~950** dishonest caption lines for free. The remaining **13** come from a different emit path and survive it — e.g. “Casting vote” on the pub walk, steps 859–861. `action_contract_v1.py` already matches these phrases; it just does not check position. |

**Pass bar stays tiles at the declared clock, 80%.** Do not expect 12/15 from the invitation side — (2)(3)(4) — alone. (1) is what unblocks the clock.

### Stays out of this fork — sofa / re-greet

Tempting (it is a live MVP gate row) but it must not ride along:

- **It is a deliberate, tested design**, not an oversight. `end_conversation` stamps depth tiers on purpose; `tests/test_cooldown_unification.py` exists to hold that. Changing it is a design negotiation, not a patch.
- **Chat state moves bodies.** §4’s chat-chain row is one talk walking three people off the cafe. Longer/fewer talks change who stands where at 11:00 in an unpredictable direction. Put it in this fork and the occupancy number becomes unreadable — the exact reason `20260901_launch.md` cut **seek** from Pass 1.

Also out: the two “Doubland” place-name lines (already PASS on the real bar) and overlay-copy verification (a measurement blocked on the runner dying, not a code change).

### Two runs, not four

The MVP gate lists four must-fix rows. It is **two** pieces of work: **honest caption was never independent of gather** — it is the same bug, and (1) fixes it. Do not budget it twice.

- **Run A** = recommendations 1–5. Reads gather **and** honest caption.
- **Run B** = sofa / re-greet built **on top of a green Run A tip**, so B is also the combined confirm. Not parallel.

**Pace, measured on `20260827-1`** (not estimated — `double.grid_deltas` per hour): ~**80 steps/h** average, but that average hides the shape. Overnight sleep hours run **150–290/h**; busy afternoons fall to **~50/h**. Real milestones from fork:

| Read | Step | Hours from fork |
|---|---|---|
| Day-1 vote | 845 | ~**13 h** |
| Day-2 challenge | 1745 | ~**20 h** |
| Day-2 vote | 2285 | ~**31 h** |
| `max_steps` | 4000 | ~**65 h** |

**Cut each scoring run after the day-2 vote.** Day 2 is where the compare lives (every prior sim has a day-2 number). Riding to 4000 doubles the cost for a third day nobody is comparing against. On that rule two cumulative runs ≈ **3 days** of scoring; on full runs it is closer to **5–6**. Cramming sofa into Run A saves ~1.5 days when it works and costs a third run when it does not.

**After the fork:** if occupancy still misses, *then* argue a dest-yank in the open. Do not sneak it in as “debug the pin.” Any remaining lock (or its replacement) must test **`target_zone` and `movement_mode`**, not just the sentence.

**Discriminating read on the next run:** occupancy should keep turning over through 10:30–11:00 and 19:30–20:00 (no identical-roster plateau). A surge 10 minutes *after* the clock means the freeze is still on.

---

## 7A. 1-A implementation plan

Verified in source on **2026-08-28** against tip `266aa54f`. Line numbers in §11A. One chunk → narrowest test → next chunk.

### Three fixes are smaller than §7 assumed

Read this before estimating. The machinery for three of the five already exists.

| Rec | §7 assumed | Actually |
|---|---|---|
| **5** ritual verbs | Build a position gate | `action_contract_v1.py:188` `strip_offsite_survival_ritual()` **already drops** Hobbs/challenge/vote verbs off-site. It gates on **destination**, and the lock writes Hobbs into `act_address` — so the sanitizer asks “are you going to the cafe?”, the lock has already answered “yes,” and the line passes. **That is how 930 lines got through a sanitizer built to stop them.** Deleting the lock un-poisons it. Rec 5 shrinks to the ~13 genuine cases. |
| **4** identity seed | Add a refresh | `revise_identity()` (`plan.py:4110`) **already rewrites `currently`** — but it sits at `plan.py:4247` behind **three early returns** (post-vote skip 4189, `should_skip_daily_planning` 4212, `cached_plan` 4225). Any one fires and identity never refreshes. Byte-identical text across 15 personas and 3 days confirms it never runs. Rec 4 is **un-skipping**, not building. |
| **3** travel anchor | Prompt + decompose example | Already built: `inherits_parent_location`, and a TRAVEL DEST DETACH branch at `plan.py:2165` whose comment literally names *“Vince: walking to Hobbs under a non-Hobbs parent.”* **All of it is behind `TASK_DECOMP_CONTEXTUAL_ENABLED`, which defaults to `false` in code.** See the blocking question. |

### Blocking question — ANSWERED 2026-08-28

**`TASK_DECOMP_CONTEXTUAL_ENABLED=true`.** Read from `.env.local` (cursorignored to the editor, still greppable from the shell). `plan.py:160` defaults it to `false`, so **the code default and the deployed value disagree** — worth fixing separately, but not in 1-A.

So the live branch was **On → the detach logic has a gap**, not the switch-on branch. Gap found and fixed in chunk 4; the large behavioural switch never had to be slipped into this pass.

### Chunks

**1 — Delete the gather lock.** DONE (`52aa9e74`). Remove the single call site `plan.py:6132` and the lock helpers (`_maybe_apply_gather_lock` 699, `_apply_gather_lock_action` 685, `_gather_lock_travel_duration_min`, `_dest_names_gathering` 673, `_gather_lock_destination`, `_already_at_gathering`).

- **Keep `_in_survival_gather_prewindow` (449).** It is *not* lock-only — `_maybe_apply_social_seek` (505) and `social_will.py:55` use it to pause seek in the appointment window. Deleting it silently un-pauses seek.
- **The stay-pin dies with it** (the on-cafe branch, 732–737) — and that is fine. It rewrites `act_address` and never `target_zone`, the same defect. It is why the pin “walked people in but did not keep them.” Not a loss.
- **Two embedded guards must be re-homed, not dropped:** waking sleepers for the appointment (20260713-1 RCA — check whether `apply_survival_wake_override` at 4204 already covers it) and *“always mints a complete action so movement reachability never sees None timers”* (20260715-1 RCA). **The None-timer guard is the real regression risk of this chunk.**
- *Freeze confirmed at source:* the early-return at 739–745 needs `curr_tile is None`, which never holds in a live run — so off-cafe personas get `act_start_time`/`act_duration` re-stamped **every step**, `act_check_finished` never fires, `_determine_action` never runs, `target_zone` never updates. On-cafe personas have an escape at 733. Exactly the measured plateau.
- **Test:** an off-cafe persona in the window keeps their own `target_zone` and their action expires on schedule.

**2 — Restore the invitation.** DONE (`75e4adcd`). Three corrections to what this section assumed:

- **The vote lead was 1.0 → 0.5, not 2.0 → 0.5.** The 2.0 was the *lock* lead in `plan.py`, a different mechanism. Pre-Pass-1 the prompt gave challenge **and** vote a flat one-hour invitation, so restoring both to 1.0 *is* the 23-2 / 25-1 configuration that scored the passing votes. No separate vote value is needed, and no dinner-window tradeoff to adjudicate.
- **There were two prompt sites, not one.** Pass 1 also cut the **daily-plan** fixed-events cue (`run_gpt_prompt.py:647/654`, “plan to arrive about 30 minutes earlier”) from an hour. That is the site that writes the *late cafe block* — the headline symptom — so fixing only the hourly block would have left the main cause in place.
- **A third copy of the window lived in prose.** The rule sentence hardcoded “the last 30 minutes” next to a variable-driven clock range, so the two could disagree silently. Both sites and the sentence now read one shared pair (`_SURVIVAL_ARRIVE_LEAD_HOURS` / `_LABEL`), and a wiring test re-reads the real source so the copy inside `test_hourly_schedule_calendar.py` cannot drift again.

After chunk 1, `_SURVIVAL_GATHER_LEAD_HOURS` only feeds the **seek pause**; its docstring now says so. That is the decoupling.
**Verified:** the block rendered from real source reads “be at Hobbs Cafe for an hour BEFORE each event”, challenge `10:00 am – 11:00 am`, vote `7:00 pm – 8:00 pm`; seek-pause window unchanged at 0.5. Full suite failure set **identical to baseline** (76, all pre-existing) measured same-tree via stash — a fresh `git worktree` is *not* a valid baseline here, several trailer/deployment tests depend on untracked local data.

**3 — Identity seed.** DONE (`acf744b8`). Deterministic refresh as planned, ahead of the three early returns. Two findings that made it smaller than expected:

- **The job needed no work.** `currently` is `"<scenario prefix>; <role text>"` (`souls/soul15_scenario_legend.json`), and the role text already reads *“Working as barista at Hobbs Cafe (cafe); …”*. Only the **prefix** is stale, so the fix restamps the prefix and preserves the tail — day, headcount **and** job, without touching character texture.
- **`revise_identity` is now skipped for survival entirely**, not just bypassed. Survival already owns both of its outputs: `currently` deterministically, and `daily_plan_req` through the controller's per-day lifestyle rewrite (`controller.py` Stage 2b). Saves ~4 LLM calls × 15 personas per rollover.
- The one fact the planner could not reach was the day number, so the controller now snapshots `season.current_day` next to `alive_players`. Missing day or headcount leaves `currently` untouched rather than inventing one.

**4 — Travel anchor.** DONE (`acf744b8`). **Blocking question answered: `TASK_DECOMP_CONTEXTUAL_ENABLED=true`** in `.env.local`, so this was the debug branch, not the switch-on branch.

The gap is one line downstream of the detach that already existed. TRAVEL DEST DETACH correctly fires for *“walking to Hobbs”* under a non-Hobbs parent — and then resolution runs with the **parent's own anchor still attached** (`anchor_context`, plus two repoints after it). Alexis detached and was steered to the library by the very anchor the detach was supposed to discard. Fixed by dropping the anchor **only when we override the decomp's own `inherits_parent_location=true`**; when the decomp itself declared the detach, its anchor names the other location by prompt contract and is kept. Confirmed the new test fails without the fix (`'desk' is not None`).

**5 — Ritual position gate.** DONE (`acf744b8`). Split as planned. The single destination gate is now two: travel verbs gated on destination, ritual verbs gated on presence, **unknown presence fails closed**. Both production callers already had `presence` in hand — the whole defect was one argument that was never passed. Four of the six new tests fail against the old behaviour.

**6 — Tests.** DONE. Chunk 1 retired the 18 lock tests; the **wake-sleepers** case (20260713-1) was already independently covered by `test_survival_wake_override.py`, so nothing had to be carried. Chunks 2–5 added **19**: 1 prompt-drift wiring guard, 10 identity refresh, 2 travel anchor, 6 ritual gate, plus re-pointed calendar assertions.

The “assert **`target_zone` / `movement_mode`**, not the sentence” rule still stands, but it bites on **occupancy / movement** tests — that is chunk 1's keeper (an off-cafe persona keeps its own `target_zone` and its action expires). Chunks 3–5 are not movement changes: the right assertion for the travel anchor is the **resolved address**, and for the ritual gate the sentence *is* the subject. Do not let that rule wave through a future gather test that only checks text.

### Sequencing

Code and review on a branch now; the deploy waits for `20260827-1`. Do not restart `api-gateway` under PID **533153** (and see the unattended-upgrades gotcha in the repo `AGENTS.md`).

---

## 8. Open before anyone ships code

**Historical for Pass 1.** 1-A deleted the lock anyway; on `20260828-1` the freeze plateau did **not** recur. Live open items are in **§12**.

Day-2 V4 file is **empty**. The 11% walk rate is **two windows, not three**. Day 2 has the cleanest freeze plateau.

Two possibilities:

- **(a)** Lock ran; collector filtered captions → freeze story holds; item 1 stays first.
- **(b)** Lock did **not** run (e.g. vote/challenge date stamps still blocking the window) → something else froze day 2; do not delete the lock on that morning’s evidence alone.

**One read-only query:** count “survival appointment” lines on steps 1715–1745; dump `challenge_resolved_date` / `post_vote_date` on day 2. Re-run V4 for that window only.

---

## 9. Flag only (not this ticket)

First elimination: **8 real voters**, **3-vote plurality**, seven phantoms. The three votes on Butcher were all described as probes (“person I know least,” “clean baseline,” “low-risk probe”). Occupancy failed; the vote that ran is also hard for a viewer to follow. Narrative quality — separate from gather.

---

## 10. Evidence (keep) vs working papers (delete)

**Keep**

- This file.
- `20260827_challenge_miss_pack/` — day-1 11:00 tiles. **Read with §11B — three columns in it lie.**
- `20260828_verify_pack/` — vote + day-2 + movement fields.
- `COS/tasks/2026-08-27-003/collect_from_supabase.py` — the collector. Re-run the §8 query with it.
- 1-A packs — see **§12.8**.

**Safe to delete** (folded in above)

- `20260827_challenge_miss_evidence.md`
- `20260827_handoff_challenge_miss.md`
- `20260827_RCA_challenge_miss.md`
- `20260828_handoff_rca_second_opinion.md`
- `20260828_handoff_verify_authority_hypothesis.md`
- `20260828_second_opinion_rca_challenge_miss.md`
- `20260828_verdict_authority_hypothesis.md`
- `20260828_addendum_freeze_plateau.md`

Priors unchanged: `20260825_checklist.md`, `done/20260821_checklist.md`, `20260901_launch.md`.

---

## 11. Appendix — carried over from the deleted papers

### A. Code map (for §7)

Repo `generative_agents`, tip `266aa54f`. Paths are under `reverie/backend_server/persona/` except `tests/`, which is repo root.

| What | Where | Why it matters |
|---|---|---|
| Lock lead, challenge **and** vote | `cognitive_modules/plan.py:446` `_SURVIVAL_GATHER_LEAD_HOURS = 0.5` | Was **1.0** challenge / **2.0** vote before Pass 1 |
| Planner invitation lead | `prompt_template/run_gpt_prompt.py:463` `lead_hours = 0.5` | Carries a literal `# keep in sync with plan._SURVIVAL_GATHER_LEAD_HOURS`. **This comment is the coupling recommendation 2 has to break** — that is how shortening the lock also shortened the invitation |
| The lock writer | `plan.py:685` `_apply_gather_lock_action`, called from `plan.py:699` `_maybe_apply_gather_lock` | Writes address, sentence, intent, `act_start_time`, `act_duration`. Never `target_zone`. Re-stamping the start time every step **is** the freeze |
| Only writer of the movement field | `plan.py:5278` `persona.scratch.target_zone = …`, inside `_determine_action` | `_determine_action` runs only when the current action expires — which the lock prevents |
| Movement branches | `cognitive_modules/execute.py:1492` (zone) · `:1757` (legacy address) | The zone branch wins whenever the attribute exists; the address branch is dead after the first action of the run |
| Arrival / expiry test | `memory_structures/scratch.py:1035` `act_check_finished`, `:1017` `_is_in_target_zone` | Judges arrival against the **stale** zone, so a locked agent reads as already arrived |
| Tests that passed it three times | `tests/test_survival_gather_lock.py` — 18 tests | Neither `target_zone` nor `movement_mode` appears anywhere in the file |
| Travel-anchor prompt (rec 3) | `prompt_template/v2/task_decomp_contextual_v1.txt` | Needs an example where a “walking to X” sub-task anchors to **X** |
| Identity seed (rec 4) | `memory_structures/scratch.py:834` `commonset += f"Currently: {self.currently}"` inside `get_str_iss()` | `get_str_iss()` is prompt input for `run_gpt_prompt_daily_plan` (`run_gpt_prompt.py:568`). Same field also at `run_gpt_prompt.py:3231` and `:3352–3353` (chat), and in the ranker `personality_summary` |
| Ritual-verb contract (rec 5) | `cognitive_modules/action_contract_v1.py:182` | Already matches `challenge briefing\|casting vote\|evening vote\|daily challenge` — add the on-cafe position check |

### B. How to read the kept packs

Two collector defects make three columns misleading on sight. The underlying data is fine.

- **`dest_names_hobbs` is `False` for all 15 and structurally always will be.** `dest` holds a bounding box, so a name test against it can never match. This column is **not** evidence that nobody was aiming at the cafe.
- **`dest` is coordinates, not a place name.**
- **`loc` is where the body already is** — parsed out of the `… @ …` description — **not** where the agent is going.

Read stated destination from `act` / `intent`. Read the body from `pos` / `on`.

### C. Clock, steps, sim ID

- Step **0** = **Aug 28, 05:55**. One step = one minute.
- **305** = 11:00 d1 · **845** = 20:00 d1 · **1745** = 11:00 d2 · **2285** = 20:00 d2 (still to score) · **2525** = midnight, where day-3 replanning overwrites day-2 schedules.
- Sim `20260827-1` · Supabase `simulation_id` **`a31712bf-8b45-46fa-8fd8-56ba7c3d6058`** · VPS tip `266aa54f`.

### D. Soft cells / limits of what was checked

- ~~`20260825-1`’s “vote hit 80% under a 2 h invitation” (§3)~~ — **half wrong; corrected by chunk 2.** The **2.0 → 0.5** cut in the Pass 1 diff was the *lock* lead. The *invitation* went **1.0 → 0.5**, on both appointments, in the same commit. So 25-1’s passing vote ran on a **one-hour** invitation behind a two-hour lock, and recommendation 2 restores that one hour — not two. Still derived from the diff plus that run’s checklist, not measured in these packs.
- **Recommendation 4 (identity seed).** Confirmed: the stale line reaches the daily-plan prompt, and the string never changes — same text for all 15 personas on day 2 of `20260827-1`, and the same text across days 1–3 of an unrelated older sim (`COS/tasks/2026-08-20-003/supabase_extract/`). **Not** confirmed: whether a refresh function exists and is failing, or no refresh path was ever written. Does not change the recommendation; does change the size of the fix.
- The 11% walk rate behind the primary mechanism is still **two windows, not three** — see §8.

---

## 12. 1-A (`20260828-1`) — live chapter

**Status:** the five §7 fixes **landed**. Occupancy still misses. Honest text is now **Pass**. Diagnosis **CLOSED 2026-08-29** — see §12.4. Veto **deleted** (§12.11, `2dea146e`). Remaining: deploy/score 1-B; Shepard is a separate planner miss; sit-and-read widen waits on datareq 5 (not this scoring run).

**Sim:** `20260828-1` · UUID `49f3ddd9-6cad-473a-9c96-97c82a7643ea` · tip `acf744b8` · skip-Premiere · `TASK_DECOMP_CONTEXTUAL_ENABLED=true`.  
**Score card** (checkpoints, bars, suite): `20260828-1_checklist.md`. Write verdicts here; keep numbers there.

### 12.1 What a viewer saw

Same competitive 11:00 as Pass 1: **6/14** on tiles. The room **did** fill — **10** at 10:15 — then dropped. Five of seven misses had sat and left (H2). Diana never sat (H3). Shepard was **asleep** at fire.

Day-1 challenge improved **3/15 → 10/15** and the freeze plateau is gone. Day-1 vote still late: **9 at 20:00**, **14 at 20:15**. Honest caption: 930 standing-still lies → **217 moving / 0 standing still**. Ritual off-cafe **0**.

1-A fixed attraction and the viewer lie. It did not keep the room.

### 12.2 Did the five fixes take effect?

Checked at runtime **before** occupancy (checklist §1). All five did, with one leftover:

| Chunk | Landed? |
|---|---|
| 1 lock deleted | **Yes.** 0 `GATHER LOCK` lines. Roster still turns over through 10:30. |
| 2 one-hour invitation | **Yes** for *start* time (15/15 cafe blocks ≤10:00). Coverage **at fire** is a different question — and on day 2 it is good (below). |
| 3 identity seed | Premiere / full-cohort **gone**. Headcount **14**. **Day number stuck at “On day 1”** for all 15. Season counter is 2; the planner field the restamp reads is 1. Ordering bug. |
| 4 travel dest detach | **Yes.** 13 detach lines. Residuals remain (Ivan cafe-table @ dorm blackboard; Dean cafe-seating @ supply). |
| 5 ritual position gate | **Yes.** Off-cafe ritual 13 → 0. On-cafe ritual kept. |

Seek pause was not widened (still 0.5). None-timer / wake-sleeper guards did not come back as crashes.

**§7 discriminating read is now false.** “A surge ten minutes after the clock means the freeze is still on” — the lock is gone and the 20:15 surge remains. Do not use it on the next run.

### 12.3 Ruled out (do not re-open)

| Suspect | Why dead |
|---|---|
| Lock freeze | Deleted. Room is not a frozen set. |
| Invitation missed the hour | Day 2: **13/14** Hobbs covering 10:00–11:00; **12/14** covering 19:00–20:00. Shepard `asleep`; Nick/Vince waking at home 19:00. |
| Social seek | **0/12** leave `act_address` start with `<persona>`; seek target empty. |
| Chat-end as a mechanical mint | Partners **stay** (Olivia, Dean). A close-triggered remint would move both. |
| Walk-off-together chain | One pair (Vince + Vincent). Not the load. |
| Crowding / self-limiting | Chat pairs peak at 4 while the room is at 10; evening 0 → 7 → 0 pairs on flat 9–10 headcount. |
| Reaction / perceive | No `act_event`, no react flag, no perceived list, no survival broadcast, reaction-LLM **0**. |
| Conversation named the dest | **No.** Three are two-line greetings. Andrew’s six-liner says *stay* (“I'll grab my coffee and come back”). Vince: “Getting some coffee?” → walks to **college**. |
| Chat as the clock | Reed holds Hobbs **3 empty minutes** after greeting; Vince **2**. Write lands on its own boundary. ~917 chat opens → “a chat ended 1–4 steps ago” is base rate. |
| Bare “Hobbs” vs full “Hobbs Cafe” (sector-pin gap) | **Falsified.** Stored hourlies: **128** “Hobbs Cafe” in full, **0** bare. With the full name the literal pin *does* fire. Premise was a **collector shortening**. |

**Paraphrase trap (process).** **Three times** a summarised string became load-bearing and killed a hypothesis: pack 2 “college / pub / dorm” labels (were full place paths; briefly blamed seek); pack 3 “at Hobbs” (was `Hobbs Cafe`); pack 3 again, *“walking to Oak Hill College”* listed as the **sub-task** when it was the **emit rewrite** of `Reviewing challenge notes` — that one held for a day as the file’s strongest fact (§12.5b). **When a string is the evidence, quote it verbatim inside backticks.** Asking for it that way is what finally produced §12.9 and closed the case in one pass.

**Sofa / re-greet stays deferred.** Chat was tested as the remover and cleared. The gather/sofa split holds. Greeting churn adds sub-task boundaries (more exposure to a broken resolver) — it is not the remover.

### 12.4 Cause — **CONFIRMED** (whitelist veto, 2026-08-29 16:26 ET)

**An arena `activity_whitelist` relocates a correctly-resolved body.** Every stage before it is right; a table lookup at the end overrules all of them.

| # | Stage | What happens | Verdict |
|---|---|---|---|
| 1 | Hourly | `at Hobbs Cafe reviewing challenge notes` — names the venue **in full** | correct |
| 2 | Sector pin | full name present → tree narrowed to Hobbs Cafe | correct |
| 3 | Parent setting | seals `the Ville:Hobbs Cafe:cafe` (passes `activity_type=""`, so no cascade here) | correct |
| 4 | Sub-task | `Reviewing challenge notes [mode=in_place anchor=cafe customer seating]` inherits it → tagged `parent_location_inherit_v1`, anchor live | correct |
| 5 | **Post-validate** | `activity_type=study`; cafe whitelist is `eat, social, serve, relax` → **cascade** | **the bug** |
| 6 | Cascade Tier 2 | searches for the nearest arena whose whitelist contains `study` → Oak Hill **classroom** (`study, social`) | faithful to a wrong premise |
| 7 | Emit | dest is now far → rewrites the act into `walking to Oak Hill College` | downstream |

**Why the row lies about itself.** The resolution tag is stamped at `plan.py:2069`; post-validate runs at `plan.py:2110`. The tag is never restamped. That is why the stored row reads *inherit + cafe anchor + classroom output* — three facts that look contradictory and are all true.

**`activity_type` empty in storage is a red herring.** `plan.py:2130` builds `action_family=row_activity_type or None` from the **same variable** post-validate receives twenty lines earlier. So `action_family: study` on the contract *proves* the validator was handed `study`. The empty stored `activity_type` is a different surface.

**Both controls are explained, by two different exemptions in that one function:**

| Who | Family | Why they stayed |
|---|---|---|
| **Dean** | `relax` | `relax` **is** in the cafe whitelist — the branch never fires. (His label also names the resolved object, which would have exempted him anyway.) |
| **Olivia** | `study` | `work_area` = `the Ville:Hobbs Cafe:cafe` → `is_worker` → **bypasses all three checks**. Same activity as the leavers, stays anyway. |

Six rows, no exceptions, two independent mechanisms on the control side. That is what lifts this above pattern-matching on `work_area`.

**Why the July fix does not cover it.** §3.3 named-destination protect and the Tier-4 guard both call `_named_destination_protects_address`, which **returns False immediately for non-travel acts**. `Reviewing challenge notes` is stationary, so the sector named by its own hourly protects nothing. Same class as the 2026-07-28 “Vince walking to Hobbs → Johnson Park” bug — same Vince — stationary instead of travel.

**Category error, stated plainly.** `staff_only` is a world law. Privacy is a world law. Sleep-needs-a-bed is physics. *“You cannot study in a cafe”* is a **taste judgment installed as a hard gate** — and hard gates get to move bodies. `sot_action-location.md` §3.5 already forbids this shape (“soft scoring must not override hard gates”); §7.2 already lists it as a known limitation. This is that limitation cashing in.

**Two groups of leavers (day-2 10:15–10:30):**

| Group | Who | Plan | Call |
|---|---|---|---|
| **A** — plan sends them away | Shepard, Dean, Owen | Shepard hour `asleep`. Dean “walking to Hobbs” anchored to a **blackboard**. Owen anchored to **park** then pub | Chunk-4 family, incomplete |
| **B** — plan is cafe, they left | Reed, Andrew, Vince, Vincent | Every slice cafe seating | **Whitelist veto** relocated them after a correct resolve (§12.4) |

Fixing A only gets **~9/14**. Bar is **11**. B is the pass/fail difference.

**Resolver tags at the four B flips:** Andrew `llm_location_v1` (intent “spreading out challenge notes on the table” → college classroom seating). Reed / Vincent / Vince `parent_location_inherit_v1`. One step earlier all four still pointed at Hobbs. Olivia and Dean, same minutes: dest stays Hobbs.

**Andrew's different tag does not need a different cause.** The sub-task resolve passes `activity_type=row_activity_type` into `generate_action_location`, so the LLM branch runs the *same* post-validate with the *same* `study`, and `plan.py:2110` runs it again after. Both paths converge on the veto — which is why the row that detached and the three that inherited all land in the same classroom. (His detach was most likely `LABEL↔ANCHOR RECONCILE` on the word “table”; unconfirmed, and it does not change the outcome.)

**Scale in 10:00–11:00 (all fifteen, new actions):** inherit **47**, **19** non-Hobbs; LLM **11**, **5** non-Hobbs. **24 / 58 = 41%** of resolutions that hour leave the cafe. That is the gathering failure, entire.

**Contradiction — CLOSED.** It read: *every stage says Hobbs, yet the parent is college; so either the task string is not the stored hourly, or a later pass remaps a correct pick.* It is the **second** branch. The task string was never wrong (§12.9 hex-checked it); post-validate remaps the correct pick. Both halves of the puzzle resolve at once — that is why every upstream stage audited clean.

**Day-1 plans are not a second coverage point.** By midnight the hourly had collapsed to one blob (“earlier today — survival preparations and the vote”). Coverage 0/14 both windows — snapshot artifact. **Snapshot plans at generation, not at midnight.** Coverage evidence is **n = 1** (day 2).

**Day number.** Season **2**; restamp reads planner field **1**. Source the day from the season row / sim date, not the scratch snapshot taken before `_advance_day`.

**Instrumentation.** Stored plan has label / duration / object-anchor / parent block. **Resolved address and `inherits_parent_location` are empty on every row.** `LLM_RESOLVER_DUMP` was off — prompt and tree not on disk.

### 12.5 Falsified theories (kept so we do not repeat them)

**(a) Sector-matcher gap.** Guard uses a lenient “Hobbs” match and stands down; the LLM pin requires “Hobbs Cafe” verbatim and never fires; unpinned tree → college. **Dead** once the 128/0 dump landed — the hourlies carry the full name and the pin *does* fire.

**(b) “The parent was already resolved off-site.”** Argued from Vince’s sub-task *“walking to Oak Hill College”* keeping the inherit tag when chunk-4 should have detached it. **Dead:** that string is the **emit rewrite**; the real sub-task is `Reviewing challenge notes [mode=in_place]` (§12.9). No travel label ever existed, so chunk 4 was never in play. The parent was Hobbs the whole time. This inference read as the strongest fact in the file for a day — it was a paraphrase in a fresh disguise.

**Do not over-read (a) into the real fix.** Two different crutches are in play and they must not be conflated:

| Crutch | Role | Verdict |
|---|---|---|
| Activity-type **registry guard** (`_deterministic_guard_v2`) | picks an arena from activity type *before* typed/LLM | behaved **correctly** — sector-shortcircuited and stood down. Do not demote on this evidence. |
| Activity **whitelist veto** (post-validate branch 2) | relocates an already-chosen address | **this is the bug.** |

The SOT’s proposed next demotion (hand more cases to the LLM) targets the **first** and would not have helped. §12.10 is about the **second**.

### 12.6 Verification (the bench is no longer a diagnostic)

Diagnosis is closed in §12.4, so the six-row bench demotes from *find the bug* to *confirm the prediction*. It is still worth running because the prediction is exact and falsifiable:

> With `study` in the Hobbs cafe whitelist — or with the veto disabled — Reed / Vincent / Vince / Andrew resolve to `the Ville:Hobbs Cafe:cafe:cafe customer seating`, and Olivia / Dean are unchanged.

Deterministic given four inputs: verbatim task string, persona, maze, anchor. Call `generate_action_location` on a laptop with `LLM_RESOLVER_DUMP=true`. **Strings are in §12.9.** Stochasticity is not a threat here — with the tree pinned to one sector the model cannot return the college either way.

Do not wait on step 2285 to *diagnose*; 2285 is still worth **scoring**. Reading runner **stdout files** does not touch the PID.

**Still empty on disk (logs):** `LITERAL SECTOR PIN`, `GUARD SECTOR-SHORTCIRCUIT`, `DETERMINISTIC GUARD v2`, `TRAVEL DEST DETACH`, `PARENT-INHERIT DETACH`, `LABEL↔ANCHOR RECONCILE`, `INHERIT POST-VALIDATE` for those six people 09:30–11:00. Also Andrew’s location-LLM prompt (flag was off).

**After the runner dies (once):** TELEPORT journal, overlay played/absent counts, persist at 2400.

### 12.7 1-B posture (not a patch list yet)

- **Do not** restore a gather lock, lengthen a pin, fail-closed, or fire-when-12.
- **Do not** fold sofa into the next occupancy run. Chat is not the remover.
- **Do** treat the **whitelist veto** as the remaining gather bug (§12.4). Group A (Shepard / Dean / Owen) is the chunk-4 anchor family and is **not** fixed by it.
- **Arithmetic warning — neither group alone clears the bar.** Day-2 base is **6/14**. A alone → **9**. B alone → **10**. Bar is **11**. Both → 13. The veto fix *may* recover more than the four named leavers (the hour shows **24** non-Hobbs resolutions, not 4), so the true range is **10–13** and one run clearing 11 is **not** assured. Budget Group A into the same pass unless it can be shown to move a different number.
- **Two candidate fixes, deliberately separate** (§12.10 sizes the second):
  - **Unblock:** add `study` to the Hobbs cafe whitelist. One data line. Can only ever *prevent* a cascade away from the cafe, never create a new destination, so the blast radius is near zero.
  - **Durable:** stop running the whitelist cascade on an address tagged `parent_location_inherit_v1`. Inheritance means the location was already decided with full context and a pinned sector; a sub-task's activity family should not get to relocate a body the parent already placed.
- **Do not ship both in the same scoring run.** Both move occupancy, so under the pass-sizing rule in `20260901_launch.md` they serialize. The unblock has an early observable (resolver output at step ~1700) and can be read long before the 11:00 count.
- Day-number restamp is a **separate, small** fix with its own observable (the `currently` string at step ~1445). It can ride with 1-B if it does not share the occupancy number — it doesn't.

### 12.8 Evidence (1-A)

**Keep**

- This file (narrative + **§12.9** tables).
- `20260828-1_checklist.md` — score / checkpoints only.
- `20260829_leave_pack/` — raw JSON (`data.json`, `data2.json`, `data3.json`) and the collector READMEs. Not a second diagnosis.
- `20260829_datareq_4_whitelist-strategy.md` — **live**, do not delete. Feeds the §12.10 decision. Retire it into §12.10 once answered.

**Safe to delete** (folded into §12 / §12.9)

- `20260829_datareq_leave-after-arrival.md`
- `20260829_datareq_2_finalize-fix.md`
- `20260829_datareq_3_chat-removal.md`

**Do not copy diagnosis into the checklist.** One live copy: here.

### 12.9 Key tables (1-A) — enough to bench without the datareqs

Cafe box: **x 72–83, y 19–30**. `dest` is a coordinate box — never name-test it. Parent-setting `task` is `f_daily_schedule[curr_index][0]` at decomp time; after decomp that slot is the tagged sub-task. Surviving parent string is `f_daily_schedule_hourly_org`. On these six, **item 2 does not differ from item 1.** Hex-checked: no extra whitespace on hourly / living_area / work_area.

#### Bench inputs (day 2)

| Who | Step | Hourly (`hourly_org` 10:00–11:00) | Live sub-task / emit | Anchor | Tile | `living_area` | `work_area` |
|---|---|---|---|---|---|---|---|
| Reed | 1700 | `at Hobbs Cafe reviewing challenge notes` | `reading through the challenge rules` (no rewrite) | `cafe customer seating` | (75, 26) | `the Ville:artist's co-living space:Studio Room 5` | `the Ville:Oak Hill College:library` |
| Vincent | 1701 | `at Hobbs Cafe reviewing notes before the challenge` | emit raw `Reviewing challenge notes` → rewritten `walking to Apartment 4` | `cafe customer seating` | (77, 29) | `the Ville:Apartment 4:main room` | `the Ville:Oak Hill College:classroom` |
| Vince | 1705 | `arriving at Hobbs Cafe early for the challenge` | emit raw `Reviewing challenge notes` → rewritten `walking to Oak Hill College` | `cafe customer seating` | (77, 28) | `the Ville:Apartment 5:main room` | `the Ville:Oak Hill College:classroom` |
| Andrew | 1706 | `arriving at Hobbs Cafe and reviewing challenge notes` | `spreading out challenge notes on the table` (no rewrite) | `cafe customer seating` | (77, 26) | `the Ville:artist's co-living space:Studio Room 1` | `the Ville:Oak Hill College:library` |
| Olivia | 1700–05 | `arriving at Hobbs Cafe early for the challenge` | `sitting down to have breakfast at a table` | `cafe customer seating` | (80, 21) | `the Ville:House 1:main room` | `the Ville:Hobbs Cafe:cafe` |
| Olivia | 1706 | same | `reviewing challenge strategy notes` | `cafe customer seating` | (80, 21) | same | same |
| Dean | 1700 | `arriving at Hobbs Cafe early for the challenge` | live still `walking to Hobbs Cafe` (started 10:01); clock-mapped slot already `settling in at cafe customer seating` | live `blackboard` | (74, 23) | `the Ville:artist's co-living space:Studio Room 2` | `the Ville:Harvey Oak Supply Store:supply store` |
| Dean | 1701–06 | same | `settling in at cafe customer seating` | `cafe customer seating` | (74, 23) | same | same |

Vince tagged slot at 10:15: `Reviewing challenge notes [mode=in_place anchor=cafe customer seating]`. Reed: `reading through the challenge rules [mode=in_place anchor=cafe customer seating]`. Andrew: `spreading out challenge notes on the table [mode=in_place anchor=cafe customer seating]`. Dean 10:00–10:10 tagged walk: `walking to Hobbs Cafe [mode=zone_patrol anchor=blackboard]`.

#### Flip resolution (coord row)

`inherits_parent_location` and parent address: **empty** on every stored row. First appearance of the off-site dest is the flip step itself.

| Who | Resolver | Stored anchor | Output |
|---|---|---|---|
| Reed 1700 | `parent_location_inherit_v1` | cafe seating | Oak Hill classroom **blackboard** |
| Vincent 1701 | `parent_location_inherit_v1` | cafe seating | Apartment 4 **blackboard** |
| Vince 1705 | `parent_location_inherit_v1` | cafe seating | Oak Hill classroom **seating** |
| Andrew 1706 | `llm_location_v1` | cafe seating | Oak Hill classroom **seating** |

Olivia at those minutes: `llm_location_v1` then inherit, dest **Hobbs seating**. Dean: inherit (blackboard walk, then seating), dest **Hobbs seating**.

#### `activity_type` vs whitelist

| Row | Stored `activity_type` | `action_family` |
|---|---|---|
| Reed 1700 · Vincent 1701 · Vince 1705 · Andrew 1706 · Olivia 1706 | empty | `study` |
| Dean 1701 | empty | `relax` |

Hobbs cafe whitelist: `eat, social, serve, relax`. Oak Hill classroom: `study, social`.

Hour-window new actions (1685–1745): inherit **47 / 19** non-Hobbs; LLM **11 / 5** non-Hobbs; planner 1 / 1. **24/58** leave the cafe.

#### Group A decomp (why three plans already send them away)

| Who | Parent 10:00–11:00 | First non-Hobbs-cafe **anchor** |
|---|---|---|
| Shepard | `asleep` | whole hour |
| Dean | arriving at Hobbs early | 10:00 `walking to Hobbs Cafe` · **blackboard** |
| Owen | arriving at Hobbs / notes | 10:10 `walking from Johnson Park` · **park garden**; then **bar customer seating** 10:15–10:45 |

Reed / Andrew / Vince / Vincent: **every** 10:00–11:00 slice tagged cafe seating (or `cafe`). They still left.

Mike (stayer) has 10:00–10:05 walk · **common room table** and was still on cafe at 11:00. Off-site anchor is neither necessary nor sufficient.

#### Raw `act_address` at leave-write (0/12 start with `<persona>`)

| Person | Day | Step | Raw `act_address` |
|---|---|---|---|
| Butcher | 1 | 280 | `the Ville:Oak Hill College:classroom:classroom student seating` |
| Reed | 1 | 287 | `the Ville:The Rose and Crown Pub:pub:bar customer seating` |
| Diana | 1 | 247 | `the Ville:Oak Hill College:classroom:classroom student seating` |
| Ivan | 1 | 280 | `the Ville:Dorm for Oak Hill College:Dorm Room 2:blackboard` |
| Nick | 1 | 300 | `the Ville:House 4:common room:common room table` |
| Shepard | 2 | 1599 | `the Ville:Oak Hill College:library:library table` |
| Reed | 2 | 1700 | `the Ville:Oak Hill College:classroom:blackboard` |
| Andrew | 2 | 1706 | `the Ville:Oak Hill College:classroom:classroom student seating` |
| Dean | 2 | 1717 | `the Ville:Harvey Oak Supply Store:supply store:behind the supply store counter` |
| Owen | 2 | 1718 | `the Ville:Oak Hill College:classroom:blackboard` |
| Vince | 2 | 1705 | `the Ville:Oak Hill College:classroom:classroom student seating` |
| Vincent | 2 | 1701 | `the Ville:Apartment 4:main room:blackboard` |

#### Chat (enough to keep it closed)

Reed 10:11 two-line greeting with Owen; three empty minutes; then college. Vincent 10:15 “Morning!” with Olivia — Olivia stays Hobbs. Vince 10:17 “Getting some coffee?” / “slept okay.” Andrew+Dean six-liner **ends** “I'll grab my coffee and come back” / “I'll hold the fort.” Dean stays. Same conversation id; stored script replaced at 10:19–10:20; ending text is the second script. No college / Apartment 4 in any of the four.

#### Vote cover 19:00 (12/14)

Nick and Vince: 19:00 = `waking up and starting morning routine at home`; Hobbs starts **20:00**. Dean and Mike: Hobbs **19:00–21:00**. The other ten cover 19:00. Two tests, both 12/14, not the same twelve.

---

### 12.10 Whitelist strategy — open decision (investigation running)

Adding `study` to the cafe closes *this* instance and leaves the shape intact. The global question is open. Handoff: **`20260829_datareq_4_whitelist-strategy.md`** (agent [1], read-only).

**Frame it by job, not by verb.** The whitelist does two unrelated things, and only one of them hurt us:

| Job | Where | What it does |
|---|---|---|
| **Veto** | `_validate_address_post_resolution` branch 2 | rejects an already-chosen address and **relocates the body** |
| **Search** | `_remap_for_forbidden_address` Tier 2, `_pick_nearest_accessible_arena`, `_deterministic_guard_v2` | given an activity, **find** arenas that allow it |

| Option | Effect | Read |
|---|---|---|
| **A — delete whitelists** | kills both jobs | The search may be load-bearing (`sot_action-location.md` §3.4: “eat/study routing still carries much of cafe/college placement”). But that note predates the stronger resolver — **Q5 settles whether it is still true.** |
| **B — widen everything** | looks safe, is not | If every arena allows `study`, then “nearest arena allowing study” collapses to “nearest arena.” Trades a wrong-specific-place bug for proximity noise, which is harder to see and harder to debug. |
| **C — retire the veto, keep the search** | whitelist becomes a ranking signal | **Current lean.** Restores §3.5 (“soft scoring must not override hard gates”) by demoting an opinion that was installed as a gate. World laws — `staff_only`, privacy, sleep-needs-a-bed — are untouched. |

#### Results (agent [1], 2026-08-29 16:36) — Q1–Q4 in, Q5 partial

| Finding | Number |
|---|---|
| Rooms | **63** — 53 gated, 10 ungated |
| `study` allowed in | **4** rooms: Apartment 4, one dorm room, the classroom, the library |
| `relax` allowed in | **31** rooms |
| Thinner still (unused this run) | `art` 1, `shop` 2 |
| Types the lists name but the run never emits | `sleep`, `storage`, `serve`, `shop`, `art` |
| Largest actual bucket | **empty** type (planner sleep/home contracts), then `relax`, `work`, `study`, `eat` |
| Dest leaves the sector its hourly named (day 2, inherit + planner) | **1414 / 5540** |
| Largest single slice | **Hobbs → Oak Hill classroom, tagged `study`: 343 rows** |
| Concentration | **310 / 780 at 10:00**, high through 13:00 |
| Writers | inherit 15882 · planner 8273 · location-LLM 4488 |

**`study` = 4 of 63 is the funnel, and it names Vincent's apartment.** Apartment 4 is one of only four rooms in the world where the model believes reading is permitted, and it is Vincent's own home, so it was his nearest accessible one. The oddest data point in the whole investigation — the leaver who went home instead of to campus — is just this list being four items long.

**Independent confirmation of the 41%.** 310/780 at 10:00 (39.7%) reproduces the 24/58 hand count in §12.4 from a completely different measurement. Two methods, same answer.

**Correction — “empty = 0 rooms” is not a flag.** Agent [1] flagged the empty-type bucket against the ≤3-rooms funnel rule. It does not apply: post-validate branch 2 opens with `if activity_type and …`, so **an empty type skips the veto entirely**. Those rows are *immune*, not funnelled. Same for cascade Tier 2, which falls through to work_area / living_area. **Do not “fix” empty types by assigning them one** — that would newly expose the largest bucket in the run to the veto. The real read is the opposite: the veto's damage is concentrated in the typed minority, and `study` is the worst-hit type in it.

**Vocabulary drift is real.** Five types exist only in the lists; the commonest type in the run exists only outside them. The two vocabularies were never reconciled.

**1414 is an upper bound on the veto.** It includes misses that are not this bug (Olivia's hourly says Apartment 1, body at House 1; Hobbs → pub is likely the Group A anchor family). The clean, attributable number is the **343**.

**Q5 cannot answer “what would we lose”, and the tags cannot be made to.** `resolution_source` is stamped `llm_location_v1` *before* `generate_action_location` is called, so a deterministic-guard hit is indistinguishable from a real LLM call inside that 4488. Sizing the search job needs the **stdout counters** (`DETERMINISTIC GUARD v2`, `forbidden-cascade Tier-N`) — still `deferred: PID`. Worth a separate resolution tag later.

#### Recommendation — **C. Decided and shipped 2026-08-29** (see §12.11)

Two stages of the draft plan below were dropped once the code was read. Keeping the reasoning because both looked right on paper.

| Draft stage | Verdict | Why |
|---|---|---|
| **Unblock: add `study` to the Hobbs cafe list** | **dropped** | Only worth doing as a cheap stand-in for the structural fix. The structural fix turned out to be *the same size* — one branch deleted — so the data patch buys nothing and leaves the shape intact. |
| **1-B: skip the cascade on `parent_location_inherit_v1`** | **dropped — would not have worked** | It guards one call site. Andrew's row is `llm_location_v1`, where the veto fires *inside* `generate_action_location` as well. Gating the inherit path leaves him walking to campus. Three of four leavers fixed reads like a success and is not one. |
| **Later data pass: sit-only widen** | **decided 08-29, not 1-B** | `study` → **32** sit rooms (datareq 5). Not 53. Same pass: `eat`×8 homes, `work`×6 jobs, `play` on cafe/park/gardens, `relax` on classroom, `art` on four studios. Search-quality, not a gather unblock. |

**What shipped instead: delete the branch.** Covers every caller at once, is smaller than either stage above, and removes the class rather than the instance.

**Why not A (delete the whitelists themselves).** Still unsized — the guard's fire rate is exactly what Q5 could not measure. Deleting the *veto* does not touch the *search*: Tier 2 is reached from the `staff_only`, bed and affordance cascades, which are untouched, so the search job survives intact. That is what makes C safe and A not.

**Why the veto is cheap to lose.** Its protective value is aesthetic: it stops someone reading in a pub. The hard gates that matter — `staff_only`, privacy, bed-for-non-sleep, `affordance_required` — are separate branches. Measured cost on one day: 1414 sector departures, 343 of them provably this.

**Precedent — this finishes a job that stopped one branch short.** `affordance_repick` was deleted from this same function in May for this exact reason: a soft preference has no business in a validator that relocates bodies (`sot_action-location.md` §9.1, §9.8). That cleanup left `activity_whitelist` behind, classified as a hard gate. It never was one.

---

### 12.11 1-B chunk 1 — the veto is deleted (shipped 2026-08-29)

**Change.** Branch 2 of `_validate_address_post_resolution` (`location_resolver.py`) removed. An arena's `activity_whitelist` no longer rejects an address that upstream already resolved.

**Deliberately unchanged:**

- **The search job.** `_pick_nearest_accessible_arena` and cascade Tier 2 still read whitelists. They are reached from the `staff_only`, bed and `affordance_required` gates, none of which moved.
- **Every hard gate.** `staff_only`, privacy, bed-for-non-sleep, `affordance_required`.
- **`maze_registry.json`.** No data edit. Narrow lists are now a search-quality question, not a correctness one.
- **`_named_destination_protects_address`.** Still live in cascade Tier 4 — not orphaned by the deletion.

**Tests** (`test_named_destination_travel.py`). The class went 6 → 5. The three that asserted the cascade *must* fire are retired; the three P1 keep-cases survive in intent. Added the 20260828-1 shape directly: `study` at `Hobbs Cafe:cafe customer seating` stays put.

**Non-vacuity checked.** With the branch temporarily restored, 4 of the 5 fail — including `test_study_at_cafe_stays`. The tests catch the real bug, not a tautology.

**Regression.** 191 passed across the ten location-resolution files. The 4 failures in `test_location_resolver.py` (`test_deterministic_trace_fields`, both `ActivityTypeFallback` cases, `test_infer_sleep`) reproduce identically on a stashed clean tree — pre-existing, part of the known 76.

#### Group A is almost entirely the same bug — the destinations give it away

Cross the twelve leave-writes in §12.9 against the Q1 census finding that **`study` is permitted in exactly four rooms — Apartment 4, one dorm room, the classroom, the library**:

| Leave-write destination | Rows | A `study` room? |
|---|---|---|
| `Oak Hill College:classroom` | Butcher, Diana, Reed d2, Andrew, **Owen**, Vince | yes |
| `Oak Hill College:library` | **Shepard** | yes |
| `Dorm for Oak Hill College:Dorm Room 2` | Ivan | yes |
| `Apartment 4:main room` | Vincent | yes |
| `Harvey Oak Supply Store` (**Dean**'s own `work_area`) | Dean | cascade Tier 3 |
| `The Rose and Crown Pub` / `House 4:common room` | Reed d1, Nick | no |

**Nine of twelve land in a four-room set, and a tenth lands on the work_area snap of the same cascade.** The leavers' destinations are not scattered — they reproduce the `study` allowlist. Across both days, not just the four hand-traced rows.

Two members of "Group A" reclassify on this:

| Persona | Was filed as | Actually |
|---|---|---|
| **Owen** | decomp writes him to the pub | his plan *does* name `bar customer seating` at 10:15 — but the write at 10:18 goes to the **classroom**. The pub anchor lost to a cascade. Same bug. |
| **Dean** | work pull | sat at 10:01, left 10:17 to his own `work_area` — that is cascade **Tier 3**, reached when Tier 2 finds nothing. Same function. |
| **Shepard** | asleep | **genuinely separate.** His hourly is `asleep` across 10:00–11:00; the planner never scheduled the appointment at all. (His own leave-write, library at ~08:19, may be a veto hit too, but it is not why he missed the fire.) |

**So Group A was one real bug and two mis-filings.** The remaining work is Shepard's shape — a planner that schedules sleep over a fixed event — not an anchor family.

**Occupancy expectation, revised up.** The earlier 10–13 range assumed the veto was worth only the four hand-traced rows. On the destination signature it plausibly covers ten of twelve, which would put day 2 near the top of that range. Still not a guarantee: the signature is strong but circumstantial, and Shepard is untouched.

**Cheap falsification.** If the veto was the mechanism, the next run's leave-writes should stop concentrating in those four rooms. If personas still walk to the classroom, the cascade was not the writer and this whole chain is wrong.

**Datareq 5 — what 1-B will and will not stop.** Cafe list is `eat, social, serve, relax`. So a veto can still explain cafe→pub **`play`** and cafe→home **`work`**. It cannot explain cafe→pub **`relax`/`eat`** or dorm **`eat`** (cafe already allows those), nor Dean→Harvey / Owen→Willows (job snaps; Harvey’s list does not even contain `work`), nor Shepard asleep. Those leftovers are why a green 1-B is not assured from the four `study` rooms alone.
