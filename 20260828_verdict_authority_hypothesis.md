# Verdict — destination-authority hypothesis (`20260827-1`)

**Date:** 2026-08-28  
**Sim:** `20260827-1` still running (step ~1800, Aug 29 11:55). Do not stop. Do not deploy. Do not patch. Do not rewrite SOT.  
**Ask:** `20260828_handoff_verify_authority_hypothesis.md`  
**Against:** `20260828_second_opinion_rca_challenge_miss.md` · `20260827_RCA_challenge_miss.md`  
**Pack:** `double-ivan/20260828_verify_pack/`  
**Denom:** day-1 **/15**; day-2 **/14** (Alex Butcher eliminated). 80% bar = **12** then **11**.

---

## 1. Pre-registered predictions

Filled from this pull **before** the rest of the paper.

| # | Prediction (H-B) | Observed | Verdict |
|---|---|---|---|
| P1 | Day-1 vote misses 80% at 20:00 | **8/15** at step 845. Bar 12. | **Confirms H-B** |
| P2 | Vote room fills 10–15 min after 20:00 | 8 at 20:05 → **11 at 20:10 → 12 at 20:15** (+4) | **Confirms H-B** |
| P3 | Lock-window “heading to Hobbs” steps mostly do not move | **66 / 589 = 11%** moved ≥1 tile toward cafe (median displacement **0**) | **Confirms H-B** |
| P4 | Frozen job bodies show `speed_multiplier` 0.0 / stationary / job `target_zone` | Job `target_zone` **yes**. `stationary` / `stationary_intent` common. Median step **0**. **No 0.0 spike** — speed is **1.0** (567 of 589) | **Mixed.** Motion matches H-B. The 0.0 fingerprint is wrong |
| P5 | Day-2 11:00 presence is predicted by the schedule block, not the lock | 10:30 cafe block: **5/8 on** at fire vs **1/6 on** without it. Three people with a cafe 10:30 block still off (Alexis, Andrew, Dean). Lock did not keep them | **Partial H-B.** Schedule is necessary, not sufficient |
| P6 | Day-2 challenge in the same band as day 1, not near 11/14 | **6/14** at 11:00. Bar 11. Same miss class as 25-1’s second morning | **Confirms H-B as written.** Read with V5b: they came earlier and still missed |

P6 + V5b: Ivan 11:00→09:00, Nick 11:00→08:00, Owen 11:00→07:00, Mike 11:18→11:00. Skip-Premiere removed a learning day. It does not explain why the day-2 room still emptied before 11:00.

---

## 2. Vote curve and day-2 curve

Fire reason is inferred: occupancy was below the bar at the declared clock, so both events are **`deadline`**, not `spatial_gate`. Day 2 re-armed (`current_day` 2, Silent Pact, 14 alive). Eight people voted; those eight were the eight on Hobbs tiles. Present-only held. Butcher was voted out **while present**.

### Day-1 vote (19:00–20:30) — /15

| Clock | Step | n |
|---|---|---|
| 19:00 | 785 | 8 |
| 19:05 | 790 | 9 |
| 19:10 | 795 | **10** (peak before lock) |
| 19:15 | 800 | 9 |
| 19:25 | 810 | 8 |
| **19:30 lock** | 815 | 9 |
| 19:45 | 830 | 8 |
| 19:55 | 840 | 8 |
| **20:00 fire** | **845** | **8** |
| 20:05 | 850 | 8 |
| 20:10 | 855 | **11** |
| **20:15** | 860 | **12** |
| 20:30 | 875 | 12 |

Same shape as the 11:00 miss: a usable room **before** the short lock, a thin room **at** the clock, a surge **after** the lock lets go. 25-1 hit 12/15 at ~19:49 under a two-hour vote invitation. This run hit 12 fifteen minutes **late**.

### Day-2 challenge (10:00–11:30) — /14

| Clock | Step | n |
|---|---|---|
| 10:00 | 1685 | 3 |
| 10:10 | 1695 | 7 |
| **10:15** | 1700 | **9** |
| 10:25 | 1710 | 8 |
| **10:30 lock** | 1715 | **5** |
| 10:50 | 1735 | 5 |
| **11:00 fire** | **1745** | **6** |
| **11:05** | 1750 | **10** |
| 11:15 | 1760 | 8 |
| 11:30 | 1775 | 7 |

On cafe at fire: Irene, Ivan, Max, Nick, Olivia, Vince. H3 never-sit: **Shepard only**. Everyone else had sat. Peak 9 at 10:15 → 5 at lock → 6 at fire → 10 five minutes after. Compare 25-1 day-2 **6/14** and 23-2 day-2 **11/14**. This is 25-1’s miss, not 23-2’s recovery.

---

## 3. The V4 number

Of persona-steps in the three lock windows whose description was **“heading to Hobbs Cafe for the survival appointment”** and whose body was **off-cafe**:

**66 of 589 (11%)** moved at least one tile toward the cafe.

| Window | Heading, off-cafe | Moved toward cafe | Median tiles/step |
|---|---|---|---|
| Day-1 challenge 10:30–11:00 | 380 | 44 (12%) | **0** |
| Day-1 vote 19:30–20:00 | 209 | 22 (11%) | **0** |
| Day-2 challenge 10:30–11:00 | **0** | — | — |
| **Combined** | **589** | **66 (11%)** | **0** |

Day-2 heading count is 0 because the emit line changed (college / pub / “at The Rose and Crown”), not because those bodies walked to Hobbs. Do not read that cell as “the lock started working.”

What the frozen steps actually look like (Butcher, step 275 — typical job freeze):

- Sentence: heading to Hobbs Cafe for the survival appointment
- Body: Harvey Oak supply-store counter
- `target_zone`: supply store `{67–69, 46}`
- `movement_mode`: `stationary` · `stationary_intent`: true
- `speed_multiplier`: **1.0** (not 0.0)
- Displacement: 0

The lock owns the caption. The job zone owns the body. Speed 1.0 with a stationary mode is still a stuck body — H-B’s mechanism stands; the predicted 0.0 spike does not.

---

## 4. V5 2×2 and V5b learning

Alive only. Cafe block **covering 10:30** vs on a cafe tile at 11:00. (The collector’s OR-flag over-counts; this table uses the 10:30 covering block.)

| | On cafe at 11:00 | Off cafe at 11:00 |
|---|---|---|
| **10:30 block is cafe** | Ivan, Vince, Olivia, Nick, Irene (**5**) | Alexis, Andrew, Dean (**3**) |
| **10:30 block is not cafe** | Max (**1**, already resident from 09:14) | Diana, Mike, Vincent, Shepard, Owen (**5**) |

Lock rescue = bottom-left without already sitting. That is **nobody**. Max was not walked in by the lock. Three people with a correct 10:30 cafe block still left (Alexis 10:26, Andrew 10:54, Dean 10:24). Same class as Diana on day 1: a good plan is not a stay.

**V5b — did the late five come earlier on day 2?**

| Who | Day-1 first cafe | Day-2 first cafe | At day-2 11:00 |
|---|---|---|---|
| Butcher | 11:00 | (eliminated; leftover scratch still says 11:00) | — |
| Ivan | 11:00 | **09:00** | **on** |
| Nick | 11:00 | **08:00** | **on** |
| Owen | 11:00 | **07:00** | off (left 10:17) |
| Mike | 11:18 | **11:00** | off (only 08:13–08:20) |

Three of four living late-planners moved earlier. Two of those three were sitting at fire. **Agents self-correct with one day of experience.** Skip-Premiere is a real confounder for the 3/15. It is not why day 2 is 6/14.

---

## 5. Counts I would not sign

| Item | Why |
|---|---|
| `post_vote_date` | Not a `persona_scratch` column. Day 2 re-armed; I did not see the stamp. |
| NDJSON `reason=` | Not in Supabase. Inferred `deadline` from occupancy below the bar. Pass 1 also sets the spatial gate to the same clock, so an early spatial fire was already impossible. |
| Collector `cafe_block_covers_1030_1100` | ORs any cafe-text overlap. Use the 10:30 covering block (table above). |
| V4 day-2 “0 heading steps” as a motion win | Emit text changed. Occupancy still 6/14. |
| Full-run persist >6 | Windows we fetched: **0**. Every step 0–1791 has 15 then 14 rows after elim (~step 905). I did not scan start→end on all 1,792 steps. |
| `GATHER_LOCK` STAY/WALK counts | Needs journalctl. Not pulled. V4 already shows the body did not walk. |
| Butcher’s day-2 schedule | Dead agent leftover. Dropped from the 2×2. |

V6 travel-anchor mismatches: **13** day-2 blocks whose *text* is “walking to Hobbs Cafe” and whose `anchor=` is park / common room / desk / closet / dorm garden. Same bug as Alexis’s library walk on day 1. Vince Vale’s 07:40 “planning morning route to Hobbs Cafe `anchor=desk`” is in-place at the desk, not travel — counted because the text names Hobbs.

V7: day-1 challenge still shows the Vincent→Diana→Alexis chain (Alexis left 10:32 chatting with Diana, who left the same step chatting with Vincent). Vote: one leave (Nick 19:36, chatting with Ivan, Ivan did not leave). Day-2 lock window: one leave (Andrew 10:54, chatting with Nick, Nick stayed). Chat contagion is **real on day 1** and **not the load-bearing miss** on vote or day 2.

V8 (windows + row counts): not a teleport bug. 15/15 then 14/14. Start→end >6 in fetched windows = 0.

---

## 6. Verdict

**H-B is the cause. H-A is the curve that cause produces.**

The lock writes the sentence. The daily plan (via `target_zone`) writes the walk. Occupancy tracks the plan. Pass 1 halved the *invitation* the planner hears in the same commit as it shortened the lock. That is why first competitive 11:00 went 9/15 → 3/15, why tonight’s vote was 8/15 at 20:00 and 12/15 at 20:15, and why day 2 peaked at 9 (10:15), sat at 5 when the lock opened, scored **6/14** at 11:00, then jumped to 10 at 11:05.

What the first RCA got right: they sit, they wait, the next block wins, the board still runs. What it ranked wrong: that is not a pin leak to debug into a dest-yank. The pin cannot move a body. Giving it `target_zone` is the banned H3 rewrite applied to everyone. Founder band-aids stay out: **no H3 dest-rewrite, no fail-closed, no longer pins, no fire-when-12.**

Do not ship gather. Do not call Pass 1 green.

**If we fork next,** the second opinion’s order still holds: restore the planner’s invitation (`lead_hours` **1.0** in the prompt, keep lock at 0.5 or off), fix travel-anchor inheritance so “walking to Hobbs” cannot anchor to the library / park / desk, then decide the lock’s fate in the open — zone authority (a dest-yank) or delete it. Add `target_zone` to the gather-lock tests either way.

Leave `20260827-1` up. Score tonight’s vote at **20:00** (step 2285) the same way when it lands. Snapshot scratch again before step **2525** if anyone still needs day-2 schedules; this pack already has them.
