# RCA + recommendations — empty Hobbs at the declared clock (`20260827-1`)

**Status:** RCA accepted. Not a patch. Not SOT.  
**Sim:** `20260827-1` · tip `266aa54f` (Pass 1 on stay-pin `4ab4f5be`) · skip-Premiere · **still running** — do not stop, do not deploy.  
**Score occupancy on tiles**, not “heading to Hobbs.” Bar is **80%** (12/15, then 11/14).  
**Founder lock (still out):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12.

This file **replaces** the working papers listed at the bottom. Raw JSON stays in `20260827_challenge_miss_pack/` and `20260828_verify_pack/`.

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
