# Evidence pack — 11:00 challenge miss (`20260827-1`)

**Date:** 2026-08-27  
**Sim:** `20260827-1` still running (do not stop). PID **533153**. Tip `266aa54f`.  
**Tiles, not labels.** Occupancy = Hobbs Cafe maze tiles (`tile_is_at_gathering`), not “heading to Hobbs.”  
**Morning window:** step **0 = 05:55** through step **305 = 11:00**.  
**Source:** read-only Supabase `personas_coords` + `survival_season_state` (project `kkjhsozszgoorwehhsdg`) and local maze. Raw JSON: `double-ivan/20260827_challenge_miss_pack/`. VPS movement JSON / journal were not opened (runner left up; no deploy).

Skip-Premiere clock: step 0 = 05:55, lock **275 = 10:30**, fire **305 = 11:00**.

---

## E1 — Confirm the fire

Season row at collection (`curr_time` **2026-08-28 12:38**, step **403**, `is_generating` true):

| Field | Value |
|---|---|
| Survival day | **1** · phase **SOCIAL** · status running |
| Alive | **15/15** · `eliminated` **[]** |
| Challenge | **Hold for the Shield** · winner **Dean Sanford** (card 3) |
| Claimants recorded | 15 (12 of those `reasoning: absent`) |

**Present-only cards (played):** Alex Shepard (fold 1), Dean Sanford (hold 3), Irene Dove (fold 2).  
**Absent (12):** Alex Butcher, Alexis Reed, Andrew Abrams, Diana Ogden, Ivan Pitts, Max Shoemaker, Mike Hooks, Nick Miller, Olivia King, Owen Logan, Vince Vale, Vincent Slater.

That 12 matches the tile absentees at step 305.

**Reason = `deadline` at 11:00, no earlier `spatial_gate`:**

- Live code fires challenge only when `gate_open_hour = challenge_deadline_hour` (11:00). Spatial cannot pull forward.
- Occupancy never reached 12 any time 08:00–11:15 (peak **9/15** at 10:15). Spatial quorum was not met at 11:00.
- Therefore the fire is **deadline**, not `spatial_gate`.

NDJSON file on the VPS was not grepped this pass. Season + tiles + code are enough for reason and the absent list.

---

## E2 — H2 / H3 from 05:55 (not 09:30)

Mid-run scorer (lock−60 = 09:30) said H2 **7** / H3 **5**. Reclass below uses **05:55–11:00** tiles.

| Who | Full morning 05:55–11:00 | Lock window 10:30–11:00 | First Hobbs | Last Hobbs | On-count | Notes |
|---|---|---|---|---|---|---|
| Alex Shepard | **ON_AT_FIRE** | ON_AT_FIRE | 10:09 | 11:00 | 16 | Left 10:20 to college; back at fire |
| Dean Sanford | **ON_AT_FIRE** | ON_AT_FIRE | 07:12 | 11:00 | 101 | Left 10:20 to college (chat Vince); back at fire |
| Irene Dove | **ON_AT_FIRE** | ON_AT_FIRE | 09:18 | 11:00 | 103 | Staff; never left |
| Alexis Reed | **H2** | H2 | 10:09 | 10:31 | 23 | Leave 10:32 college · chat Diana |
| Andrew Abrams | **H2** | H2 | 10:01 | 10:40 | 40 | Leave 10:41 · text “waiting at Hobbs” · dest classroom · chat Irene |
| Diana Ogden | **H2** | H2 | 10:15 | 10:31 | 17 | Leave 10:32 · text “waiting at Hobbs” · dest library · chat Vincent |
| Olivia King | **H2** | H2 | 09:38 | 10:45 | 48 | Off at 10:30 (pub); came back; leave 10:46 dest pub |
| Max Shoemaker | **H2** | H3 | 08:05 | 10:25 | 56 | Last leave 10:26 to pub · chat Irene |
| Vince Vale | **H2** | H3 | 10:04 | 10:14 | 11 | Leave 10:15 to college · chat Dean |
| Vincent Slater | **H2** | H3 | 10:09 | 10:29 | 21 | Leave **10:30** · text “waiting at Hobbs” · dest library |
| Mike Hooks | **H2** | H3 | 07:29 | 07:47 | 19 | Dawn cafe → market. Mid-run labelled **H3** |
| Nick Miller | **H2** | H3 | 07:49 | 07:59 | 11 | Dawn cafe → college. Mid-run labelled **H3** |
| Alex Butcher | **H3** | H3 | — | — | 0 | Supply store all morning |
| Ivan Pitts | **H3** | H3 | — | — | 0 | Pharmacy all morning |
| Owen Logan | **H3** | H3 | — | — | 0 | Market all morning |

**Flip:** mid-run H3 **5** → true never-sit **3**. **Mike** and **Nick** flip to H2 (dawn sit, gone before 09:30).

**Counts at fire:** 3 on tiles · **9 H2** · **3 H3**.

Lock window (did the 30-min pin ever see them on cafe?): H2/on-fire **7** (the 3 sitters + Alexis, Andrew, Diana, Olivia). Lock-window H3 **8**.

---

## E3 — Occupancy every 5 min (08:00–11:15)

| Clock | n/15 | On cafe |
|---|---|---|
| 08:00 | 0 | — |
| 08:05–08:20 | 1 | Max |
| 08:25–08:30 | 0 | — |
| 08:35–08:50 | 1 | Dean |
| 08:55 | 0 | — |
| 09:00–09:15 | 1 | Max |
| 09:20 | 2 | Irene, Max |
| 09:25–09:35 | 1 | Irene |
| 09:40–10:00 | 3 | Dean, Irene, Olivia |
| 10:05 | 5 | +Andrew, Vince |
| **10:10** | **8** | +Shepard, Alexis, Vincent |
| **10:15** | **9** peak | +Diana, Max; Vince gone |
| 10:20 | 6 | Shepard, Dean, Olivia, Vince gone |
| 10:25 | 6 | same six |
| **10:30 lock** | **4** | Alexis, Andrew, Diana, Irene |
| 10:35 | 2 | Andrew, Irene |
| 10:40 | 3 | +Olivia back |
| 10:45 | 2 | Irene, Olivia |
| 10:50–10:55 | 1 | Irene |
| **11:00 fire** | **3** | Shepard, Dean, Irene |
| 11:05 | 3 | same |
| 11:10 | 8 | walk-back after fire |
| 11:15 | 8 | still filling |

**~4 at lock is exact: 4/15 at 10:30.**

Read:

- The room was **not** full all morning. It filled **10:05–10:15** (peak 9), then emptied **before** the 10:30 lock (9 → 4).
- It did **not** fill after 10:30. Inside the pin it fell 4 → 1, then 3 at the clock (Shepard + Dean walked in at the last minutes).
- Never ≥12. After fire, 8 at 11:10 — too late.

---

## E4 — Pin vs plan

Journal `[GATHER_LOCK:]` was not grepped (VPS left alone). Movement **sentences** show the lock ran:

**WALK text** at 10:30 (`heading to Hobbs Cafe for the survival appointment`) on off-cafe bodies: Butcher, Shepard, Ivan, Max, Mike, Nick, Olivia, Owen, …  
**STAY text** (`waiting at Hobbs Cafe for the survival appointment`) on in-window leavers: Vincent 10:30, Diana 10:32, Andrew 10:41, Olivia 10:46.

Leaves **at/after 10:30** (pin should hold if on cafe):

| Who | Clock | Act text | Dest bbox | `chatting_with` |
|---|---|---|---|---|
| Vincent Slater | **10:30** | waiting at Hobbs… | library | none |
| Alexis Reed | 10:32 | walking to Oak Hill College | library | **Diana Ogden** |
| Diana Ogden | 10:32 | waiting at Hobbs… | library | **Vincent Slater** |
| Andrew Abrams | 10:41 | waiting at Hobbs… | classroom | **Irene Dove** |
| Olivia King | 10:46 | waiting at Hobbs… | pub | none |

Pin’s first minute: Vincent already stepping off (10:30). Dest is college/pub **while** STAY text says waiting at Hobbs.

Chat skip (`chatting_with` returns before dest rewrite): **3 of 5** in-window leaves.

Olivia + Vincent: no chat, still left with off-cafe dest. STAY did not keep the body.

Off-cafe WALK: several people (Ivan, Butcher, Owen, Nick, Mike) kept **job** dest bboxes and **did not move**. Shepard/Dean did walk back (college → cafe by 11:00).

---

## E5 — Daily plan at 10:30

Coords at 10:00–10:30 (what they were **doing**), plus current `f_daily_schedule` (same calendar day, still on disk at 12:38):

| Who | 10:00 body | 10:30 body | Schedule 10:00–11:00 | Cafe block starts |
|---|---|---|---|---|
| Ivan | pharmacy restock | pharmacy · WALK text | pharmacy until **11:00** | **11:00** “finding a seat” |
| Owen | market boxes | market · WALK text | market until **11:00** | **11:00** coffee |
| Nick | classroom podium | classroom · WALK text | lecture until **11:00** | **11:00** “settling into cafe” |
| Butcher | supply counter | supply · WALK text | store until **11:00** | **11:00** “reviewing instructions” |
| Mike | market register | market · WALK text | grocery until **11:06** | **11:18** wait |
| Diana | library notes | **on cafe** | plan **was** cafe 10:00–11:00 wait | she still left 10:32 |
| Andrew | leaving co-living | **on cafe** | plan **was** cafe 10:00–11:00 | he still left 10:41 |

**Vs `20260825-1` day-1 trails (§12):**

| Who | 25-1 first competitive 11:00 | 27-1 first competitive 11:00 |
|---|---|---|
| Shepard | **H3** library all morning | **On cafe at fire** (sat 10:09, left 10:20, back) |
| Andrew | H2 brief 09:39–09:45 | H2 sat 10:01–10:40, left |
| Diana | H2 cafe 09:49–10:15 | H2 cafe 10:15–10:31, left |
| Ivan | H2 cafe **10:05–10:40** | **H3** pharmacy never sat |
| Nick | H2 cafe **10:27–10:54** | H2 dawn only 07:49–07:59; college at lock |
| Owen | H2 cafe **10:05–10:28** | **H3** market never sat |

25-1’s **10:00** lock walked Ivan / Nick / Owen in during the job hour. 27-1’s **10:30** lock left that hour as the shift. Decompose puts the appointment **at/after 11:00** for the job people.

---

## E6 — True H3 walk time (after E2)

True never-sit 05:55–11:00: **Butcher, Ivan, Owen** (3). All reachable under `MAX_TILES_PER_STEP=6` (max ~180 tiles in 30 min):

| Who | 10:30 tile | Manhattan to cafe ~ (76,24) | Moved by 11:00? |
|---|---|---|---|
| Alex Butcher | (68,46) supply | 30 | no (68,44) |
| Ivan Pitts | (75,52) pharmacy | 29 | **no** (75,52) |
| Owen Logan | (76,49) market | 25 | 2 tiles (76,47) |

The short window did **not** create an unreachable class. They could have arrived. They did not start. WALK text was on; dest bbox stayed the job.

Mike / Nick are **not** this class (dawn H2).

---

## E7 — Honest text at fire (sample + all 12 absentees)

Strip keys off **dest**. Gather lock sets planned dest / sentence to Hobbs. Viewer sentence can match dest and lie about the body.

At step 305:

| Who | On cafe? | Body loc | Act | Dest bbox |
|---|---|---|---|---|
| Shepard | yes | Hobbs cafe | heading to Hobbs… | cafe seating |
| Dean | yes | cafe seating | heading to Hobbs… | cafe seating |
| Irene | yes | behind counter | clean / restock | counter |
| **Butcher** | no | supply store | heading to Hobbs… | **supply** |
| Alexis | no | library | heading to Hobbs… | **library** |
| Andrew | no | classroom | heading to Hobbs… | **classroom** |
| Diana | no | classroom | heading to Hobbs… | cafe (walking back) |
| Ivan | no | pharmacy counter | heading to Hobbs… | **pharmacy** |
| Max | no | pub | heading to Hobbs… | **pub** |
| Mike | no | market | heading to Hobbs… | **market** |
| Nick | no | classroom podium | heading to Hobbs… | **podium** |
| Olivia | no | pub seating | heading to Hobbs… | **pub** |
| Owen | no | market | heading to Hobbs… | **market** |
| Vince | no | street | walking to Hobbs Cafe | cafe |
| Vincent | no | street | heading to Hobbs… | cafe |

**11/12 absentees** still have the lock sentence (Vince: “walking to Hobbs Cafe”). Dest bbox is the **job** for 9 of them — strip never sees a Hobbs **address**, but the emit path still printed the lock line. For Diana / Vince / Vincent dest is already cafe and the body is still off-tile (late walk).

This is not the occupancy miss. It is why the viewer still sees a lie, and it matches dest-based pin no-ops (C/G).

---

## E8 — Skip-Premiere

- Step 0 `curr_time` **August 28, 2026, 05:55** · `day_number` **2** · `start_date` still **2026-08-27**.
- Survival season **Day 1**. Challenge row exists → Survival armed.
- 06:00 (step 5): everyone **sleeping** / just waking. No “directive” string in movement text (overlay, not an action).
- First Hobbs visits: Dean 07:12, Mike 07:29, Nick 07:49, Max 08:05, Irene 09:18, then the 10:05–10:15 fill.

Skip-Premiere is **not** “they never found the cafe.” Peak 9 at 10:15. It **is** a colder first competitive morning vs 25-1: Ivan / Owen never sat; Nick only sat at dawn. 25-1’s 10:00 lock had already walked those jobs in.

---

## E9 — Held bars through the challenge window

Steps **0–305**, 15 people, **4590** persona-steps (`personas_coords`):

| Bar | Result |
|---|---|
| 15/15 every step | **yes** (0 missing) |
| start→end >6 | **0** |
| consecutive step >6 | **0** |
| TELEPORT / traceback | not re-logged this pass; mid-run TRACEBACK 0 · TELEPORT 0 |

Occupancy miss is not a teleport / persist bug.

---

## E10 — Prior artifacts (attached by cite, not re-scored)

- `double-ivan/20260825_checklist.md` — stay-pin FAIL; §2 H2/H3; **§12** day-1 trails (Ivan, Nick, Owen, Diana, Shepard)
- `double-ivan/20260827_checklist.md` — this sim’s mid-run table (H2/H3 provisional)
- `double-ivan/20260901_launch.md` — Pass 1 cut
- `COS/tasks/2026-08-27-002/mvp-cut.md`
- `COS/tasks/2026-08-27-001/final.md` — 25-1 score
- `double-ivan/done/20260821_checklist.md` — 23-2 first competitive 11:00 **8/15** (file lives under `done/`, not repo root)
- Code on this tip: `plan.py` `_SURVIVAL_GATHER_LEAD_HOURS = 0.5`, `_maybe_apply_gather_lock` (chat skip; dest-names-Hobbs no-op); `survival/controller.py` `gate_open_hour=self.challenge_deadline_hour`; `action_contract_v1.strip_offsite_survival_ritual`

Raw dump: `double-ivan/20260827_challenge_miss_pack/` (`e1_season.json`, `e2_trails.json`, `e3_occupancy.json`, …).

---

## Hypothesis score (not the RCA)

| ID | Call |
|---|---|
| **A** | **Hit.** Peak 9 at 10:15, **4 at 10:30**. Short lock arrived after the sit. |
| **B** | **Hit (5 people).** In-window leaves after 10:30. |
| **C** | **Hit.** STAY text + college/pub dest bbox. |
| **D** | **Hit (3/5).** Chat skip on Alexis / Diana / Andrew. |
| **E** | **Partial.** 3 true H3, all reachable, did not walk. Not a distance problem. |
| **F** | **Partial.** Cafe was found (peak 9). Job trio colder than 25-1 day-1. |
| **G** | **Hit.** Lock sentence on off-cafe bodies at fire. |
| **H** | **Hit as “did not cost a full room.”** Never ≥12. Declared-time fire did not throw away a seated 12. |

RCA: `double-ivan/20260827_RCA_challenge_miss.md`.
