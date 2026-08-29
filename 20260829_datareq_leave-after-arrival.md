# Data request — leave-after-arrival (`20260828-1`)

**For:** a data-collection pass, not an analysis pass. Collect and report. Do **not** propose fixes, edit code, or touch the runner.

**Sim:** `20260828-1` · Supabase `simulation_id` **`49f3ddd9-6cad-473a-9c96-97c82a7643ea`** · tip `acf744b8` · PID `663491`

**Hard constraints**

- **Read-only.** No writes, no restarts, no `git` on the box.
- Runner may still be up (`max_steps` 2400, vote at 2285). Do **not** `journalctl` or SSH-poke the live PID. Supabase and the existing checkpoint packets only.
- If a query returns empty, say **“empty”**. Do not substitute a nearby window and do not infer. An empty answer is a finding.

**Clock:** step 0 = day-1 05:55, one step = one minute.

| Step | Clock | Step | Clock |
|---|---|---|---|
| 245 | 10:00 d1 | 1685 | 10:00 d2 |
| 260 | 10:15 d1 | 1700 | 10:15 d2 |
| 275 | 10:30 d1 | 1715 | 10:30 d2 |
| **305** | **11:00 d1 — challenge** | **1745** | **11:00 d2 — challenge** |
| 315 | 11:10 d1 | 1754 | 11:09 d2 |
| 785 | 19:00 d1 | 2225 | 19:00 d2 |
| **845** | **20:00 d1 — vote** | **2285** | **20:00 d2 — vote** |
| 860 | 20:15 d1 | 2300 | 20:15 d2 |

**Cafe tiles:** rectangle **x 72–83, y 19–30**. On-cafe = `curr_tile` inside that box. Nothing else counts as present.

**Three collector traps — do not repeat them (RCA §11B)**

- `dest` is a **bounding box of coordinates**, not a place name. A name test against it always fails. Never report `dest_names_hobbs`.
- `loc` parsed out of `… @ …` is **where the body already is**, not where it is going.
- Read stated destination from `act_address` / `intent`; read the body from `curr_tile`.

---

## Why we are asking

Attraction is fixed. On day 1 **every one of the 15** stood on a cafe tile at some point (H3 = 0); on day 2, 13 of 14 did. Both mornings the room reached **10** at 10:15. Then it fell — to 6 at 10:30 on day 1, to 4 on day 2.

So the remaining failure is **hold**, not arrival. The question this pass must answer is narrow:

> **What ends the cafe action for someone who is already sitting at Hobbs, 15–45 minutes before the event they came for?**

Everything below serves that one question.

---

## Query A — coverage vs hold (highest value, do this first)

For **all 15** personas, both days, pull the plan as generated at rollover (day 1 step ~5, day 2 step ~1445):

- `f_daily_schedule_hourly_org` — the **hourly** plan
- `f_daily_schedule` — the **decomposed** minute-level plan
- `scratch.currently`

**Dump both.** They are different objects and the difference is the point: if the hourly plan says “10:00–11:00 at Hobbs” but the decomposed plan says “10:00 walk to Hobbs (15) / 10:15 order coffee (15) / 10:30 head back to the store (30)”, the loss happens in **decomposition**, not planning.

For each persona × day, report:

| Field | Meaning |
|---|---|
| `hourly_covers_fire` | Does the **hourly** plan have a Hobbs block spanning the fire minute (305 / 1745)? |
| `decomp_covers_fire` | Does the **decomposed** plan? |
| `cafe_block_start`, `cafe_block_end` | Clock span of the last Hobbs block before the fire |
| `next_block` | The activity immediately after it, and its address |
| `on_at_fire` | Was `curr_tile` on cafe at the fire step? |

Then give the **2×2**: covered vs not, held vs left. We need the **hold rate among the covered** — Pass 1 measured it at **62.5%** and predicted that even perfect coverage lands ~9/14 against a bar of 11. Confirm or refute that number on this run.

---

## Query B — the leave event

Subjects — these are the people who sat and then left:

- **Day 1 (5):** Butcher, Reed, Diana, Ivan, Nick
- **Day 2 (7):** Shepard, Reed, Andrew, Dean, Owen, Vince, Vincent

For each: find the **last step on a cafe tile** before their fire. At that step and the following three, report:

`step · curr_tile · act_address · act_description · act_start_time · act_duration · target_zone · movement_mode · speed_multiplier · chatting_with · act_event`

**The one question this must answer:** did the cafe action **expire** (`act_start_time + act_duration` reached, so `act_check_finished` fired and the planner moved to the next block), or was it **replaced mid-flight** (a new action written while the old one still had time left)?

Label each leaver **`expiry`** or **`replaced`**, and if replaced, name what wrote the new action. That single label splits the next fix in two, so do not leave it blank — if the data cannot tell, say so and show the rows.

---

## Query C — Shepard asleep at the day-2 fire

He sat at Hobbs around **08:23** on day 2 and was **asleep** at 11:00. Steps **1440–1745**: his full action chain (same fields as B, one row per action change, not per step), plus his day-2 hourly and decomposed schedule.

Answer: was the sleep a **scheduled block**, or did something re-plan him into it after he arrived?

---

## Query D — the 20:15 vote surge

Day-1 vote sat at **9/15** at 20:00 and **14/15** at 20:15. Identify the people who were off-cafe at 845 and on-cafe by 860. For each, report `act_address` / `target_zone` / `curr_tile` at steps **815, 830, 845, 852, 860**.

Answer: **when did the walk start?** If it started at or after 845, the fire itself released them and the schedule never aimed at 20:00. If it started around 830 and simply took time, it is walk duration.

Repeat for the day-2 vote (2285 / 2300) **only if step 2300 is on disk** — otherwise report “not on disk”.

---

## Query E — cheap add-ons

1. The **217** off-cafe “heading to Hobbs” lines through step 1754: which personas, which steps, and were they **moving** (`curr_tile` changed in the prior 3 steps) or **standing still**? A standing-still majority means a leftover caption path we have not found.
2. Confirm **0** `GATHER LOCK` lines across the whole run.
3. Day-2 `currently` for all 15: exact string. We know the headcount rolled to 14 but the day string stayed “On day 1” — we want the literal text to see which half of the restamp fired.

---

## Deliverable

Two files under `double-ivan/20260829_leave_pack/`:

- `data.json` — raw rows, one object per query (A–E), keyed by persona and step.
- `README.md` — one short table per query, plus a **Gaps** section listing anything that came back empty or that you could not reach.

**Do not** write conclusions, recommendations, or a proposed fix. If something looks like a cause, put it under **Gaps** as an observation with the rows that support it.

---

## After the runner stops

`max_steps` is **2400**, so the run self-terminates shortly after the day-2 vote. Once the PID is gone (confirm first), these become available and are worth a second small pass:

- TELEPORT journal for the full run
- Overlay LLM played / absent / last-elim injection counts
- Full-run persist check at 2400
