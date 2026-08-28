# RCA — Empty Hobbs at declared 11:00 (`20260827-1`)

**Date:** 2026-08-27  
**Status:** Evidence complete. Not a patch. Not SOT. Sim **still running** — do not stop, do not deploy.  
**Tip:** `origin/railway` @ **`266aa54f`** (Pass 1 on stay-pin `4ab4f5be`)  
**Sim:** `20260827-1` · skip-Premiere · first competitive 11:00 = engine day 2  
**Pack:** `double-ivan/20260827_challenge_miss_evidence.md`  
**Handoff:** `double-ivan/20260827_handoff_challenge_miss.md`

Do not ship gather. Do not call stay-pin or Pass 1 green.

---

## 1. One-sentence product read

At 11:00 the viewer sees three people on Hobbs tiles (Shepard, Dean, Irene) and twelve others still “heading to Hobbs” from the college, the pub, the pharmacy, and the supply store — then the Hold board runs anyway.

---

## 2. Root cause class

**Mixed. Primary A, then B+C+D, with a job-stuck E tail.**

They sit, they wait, the daily plan wins, they walk. Same miss class as 23-2 and 25-1. Pass 1 made the first competitive 11:00 **worse** (9/15 → **3/15**) because the 30-min lock **started after the sit** and **did not move the job bodies**.

| Slice | Count | Class | What the tiles show |
|---|---|---|---|
| On cafe at 11:00 | **3** | held / last-minute return | Irene never left. Shepard + Dean left at 10:20, walked back at the clock. |
| Sat, then gone **before** 10:30 | **5** | **A** (unpinned morning) | Max last on 10:25; Vince 10:14; Vincent 10:29; Mike 07:47; Nick 07:59. Peak **9 at 10:15 → 4 at lock**. |
| On cafe in the 10:30–11:00 pin, then left | **4** | **B + C + D** | Alexis 10:32, Diana 10:32, Andrew 10:41, Olivia 10:46. STAY text, college/pub dest. **3/4 chatting_with** (lock skip). |
| Never on a Hobbs tile 05:55–11:00 | **3** | **E** (reachable, did not walk) | Butcher, Ivan, Owen. Manhattan 25–30. WALK text on; dest bbox stayed the job; Ivan did not move. |

Mid-run H3 **5** was wrong: Mike and Nick sat at dawn. True never-sit is **3**, not 5. Do not treat this miss as “five librarians to yank.”

**Killed / bounded:**

- **H** — occupancy never hit 12. Firing at declared 11:00 did **not** throw away a full room. Do not recommend fire-when-12; just record that.
- **F** as “they never found the cafe” — **killed.** Peak 9 at 10:15. Skip-Premiere is a colder job morning vs 25-1, not a lost map.
- **E** as “30 min is too far” — **killed.** All three true H3 were inside ~30 tiles. The walk did not start.
- Start-jump / persist — **not the cause** (E9: 0 over-6, 15/15 through 305).

**G** (honest text) is coupled, not the occupancy miss: lock sets the Hobbs sentence; the body stays on the job dest. Viewer lie and dest-based pin no-op are the same mechanism.

---

## 3. Comparison — first competitive 11:00 only

Do not headline 25-1’s day-2 **6/14**. Primary line is first competitive morning:

| Sim | Tip | Lock | Fire | Sit | H2 / H3 (full morning) |
|---|---|---|---|---|---|
| `20260823-2` | `53ace4c5` persist | ~1 h from 10:00 | 11:00 `deadline` | **8/15** | H2 already the class (5 of 7 absentees had sat) |
| `20260825-1` | `4ab4f5be` stay-pin | 10:00–11:00 | 11:00 `deadline` | **9/15** | H2: Andrew, Diana, Ivan, Nick, Owen · H3: Shepard |
| `20260827-1` | `266aa54f` Pass 1 | **10:30–11:00** | 11:00 `deadline` (spatial pull-forward **off**) | **3/15** | H2: **9** · H3: **3** (Butcher, Ivan, Owen) · Premiere day: **none** |

Deltas vs 25-1 day-1: lock 30 min later; no grace day; Ivan/Nick/Owen **not** walked in during the job hour (they **were** on 25-1). Shepard **did** sit this time. Room still empty at the clock.

---

## 4. What we already tried — why Pass 1 did not move the needle

| Attempt | What it did | This morning |
|---|---|---|
| Gather lock (Jul) | Force-walk last **hour** | Walk-in exists; does not keep the room |
| Stay-pin `4ab4f5be` | On cafe, reject leave dest until fire | Walked people **in**. Did not **keep** them. 9/15 then 6/14 |
| **Pass 1** `266aa54f` | Lock only **30 min**; fire at **11:00**; honest dest text; skip-Premiere | Short window arrived to **4** people. Pin leaked those 4. Jobs never left. **3/15** |

Founder bet (2026-08-27): the wait *is* the bug. Shorten the hang; fire at the advertised clock; naturalness first.

The wait is still the bug. Shortening the hang **without** holding dest or owning the 10:30 hour of the daily plan **unpinned** the 10:15 sit and **stopped walking the shift**. First score is worse, not better.

Honest text + thin talk + skip-Premiere are confounders. Occupancy failed on tiles even if those had been perfect.

---

## 5. What not to do

Founder lock. Still out:

- H3 dest-rewrite / yank librarians (Butcher / Ivan / Owen at work is life if dest **and** text match the job — they do not, today)
- Fail-closed if sit < 80%
- Longer pins / all-morning curfew
- Fire-when-12 / pull the challenge forward

Do not rewrite `sot_be-fe.md` §4.7 or `sot_survival.md` gather windows on this miss. Live code on this tip is Desired (30 min + declared clock), not the last-hour SOT.

Do not patch `20260827-1`. Vote at **20:00** on this run is still worth scoring when it fires.

---

## 6. Recommended next experiment

**One bet, next sim, not this runner.**

Debug the 30-min pin so it matches what the founder already asked: last half hour is the appointment, bodies that are on cafe **stay**, bodies that are off cafe **walk**. Do not lengthen the window.

Testable on the next fork:

1. **STAY actually holds dest.** If `curr_tile` is on Hobbs and the next dest is college/pub, rewrite dest **and** the FE target zone. Chat must not skip that. (B/C/D — 4 in-window leavers.)
2. **WALK actually moves the job.** If the sentence is “heading to Hobbs” and the dest bbox is still the pharmacy, that is a failed walk, not a skip. (E — Ivan stood still 10:30–11:00.)
3. **Hourly plan owns 10:30–11:00.** Today’s decompose still schedules the shift until 11:00 and the cafe **after** fire (Ivan / Nick / Owen / Butcher). Pin then fights a live job block and loses. Putting the appointment in that hour is not a longer curfew and not an H3 yank.

Pass bar stays **tiles at declared 11:00**, 80% the TV target, skips allowed. Do not expect 12/15 from (1)(2) alone — lock only saw 4 on cafe. (3) is what would have walked the 25-1 job trio without moving the lock back to 10:00.

---

## 7. Open questions

- VPS `survival_phase_trigger.ndjson` and `[GATHER_LOCK:]` journal counts were not grepped (runner left up). Season + lock **sentences** already prove deadline + WALK/STAY text.
- Emit path: lock sets `act_address` / description; coords store a **target_zone bbox**. Which layer dropped the cafe dest for Ivan / Nick / Owen is not proven from tiles alone.
- Whether `chatting_with` is the main in-window leak or only 3/5 — Olivia and Vincent left with no chat.
- Vote occupancy at **20:00** on this sim — still ahead; score it when it fires.
- How much skip-Premiere (no grace day) vs the 10:30 cut moved Ivan/Owen. 25-1 had both a Premiere day **and** a 10:00 lock.

---

**Call:** gather **FAIL**. Stay-pin **FAIL**. Pass 1 **FAIL** on first competitive 11:00 (**3/15**). Naturalness-first next, not a band-aid.
