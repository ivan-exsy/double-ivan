# Leave-after-arrival pack — `20260828-1`

Read-only dump for the first leave-after-arrival collection. Raw rows: `data.json`. Cafe tiles = x 72–83, y 19–30. Collected with max_step **1780** on disk (day-2 ~11:35). Runner not touched. Narrative + key tables: RCA §12 / §12.9.

`dest` / `target_zone` in the JSON is a **bounding box**, not a place name. Stated destination is `act_address` / `act_description`. Body is `curr_tile`.

---

## Query A — coverage vs hold

**Day-1 hourly + decomposed plans for the 14 remaining personas: empty.** Scratch was overwritten at day-2 rollover (`last_planned_date=2026-08-30`). The only leftover day-1 schedule is **Alex Butcher** (eliminated; `last_planned_date=2026-08-29`). His hourly block at 11:00 is Hobbs; he was **off** cafe at step 305.

**Day-2 (live scratch, 14 people) — hourly**

Every remaining persona has an hourly Hobbs block **11:00–12:00** (“at Hobbs Cafe taking part in the daily challenge”). Next hourly block is lunch at Hobbs (12:00–13:00/14:00/15:00).

| Name | hourly_covers_11:00 | decomp_covers_11:00 (word “hobbs”) | decomp at 11:00 (text) | cafe_block | next hourly | on_at_1745 |
|---|---|---|---|---|---|---|
| Irene Dove | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–13:00 | yes |
| Ivan Pitts | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | yes |
| Max Shoemaker | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–13:00 | yes |
| Mike Hooks | yes | no | 11:00–11:05 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–13:00 | yes |
| Nick Miller | yes | no | 11:00–11:15 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–15:00 | yes |
| Olivia King | yes | no | 11:00–11:05 behind cafe counter | 11:00–12:00 | lunch Hobbs 12:00–13:00 | yes |
| Alex Shepard | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Alexis Reed | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Andrew Abrams | yes | no | 11:00–11:20 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Dean Sanford | yes | no | 11:00–11:15 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Diana Ogden | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–13:00 | no |
| Owen Logan | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Vince Vale | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |
| Vincent Slater | yes | no | 11:00–11:10 cafe seating | 11:00–12:00 | lunch Hobbs 12:00–14:00 | no |

**2×2 day-2, hourly covers fire vs on-tile at 1745**

|  | Held (on cafe @ 11:00) | Left (off @ 11:00) |
|---|---|---|
| Covered | Irene, Ivan, Max, Mike, Nick, Olivia (**6**) | Shepard, Reed, Andrew, Dean, Diana, Owen, Vince, Vincent (**8**) |
| Not covered | **0** | **0** |

Hold rate among hourly-covered: **6/14 = 43%**.

Same 2×2 if the decomp fire block is scored by cafe seating / cafe counter (not the word “Hobbs”): still **6/14**, uncovered **0**. Strict `decomp_covers_fire` using only the substring `hobbs` is **0/14** (see Gaps).

Day-1 2×2 for the field: **empty** (schedules gone).

---

## Query B — leave event

Last on-cafe step before fire, plus three steps after. `act_event` is **empty** on every coord row.

All twelve named leavers: **`replaced`**. At the last cafe tile the running action already has a **non-Hobbs `act_address`**, `steps_remaining > 0`, same `action_id` continues off-cafe. The Hobbs sit did not expire at that boundary. What wrote the new action is **not in this 4-step window** (`replaced_writer` = action already non-Hobbs at last on-cafe step).

| Person | Day | Last on-cafe | Leaving `act_address` | `act_start_time` | dur / rem | Label |
|---|---|---|---|---|---|---|
| Alex Butcher | 1 | 281 (10:36) | Oak Hill classroom seating | 10:35 | 25 / 24 | replaced |
| Alexis Reed | 1 | 295 (10:50) | Rose and Crown bar seating | 10:42 | 10 / 2 | replaced |
| Diana Ogden | 1 | 248 (10:03) | Oak Hill classroom seating | 10:02 | 5 / 4 | replaced |
| Ivan Pitts | 1 | 282 (10:37) | Dorm Room 2 blackboard | 10:35 | 25 / 23 | replaced |
| Nick Miller | 1 | 300 (10:55) | House 4 common room table | 10:55 | 10 / 10 | replaced |
| Alex Shepard | 2 | 1601 (08:36) | Oak Hill library table | 08:34 | 6 / 4 | replaced |
| Alexis Reed | 2 | 1702 (10:17) | Oak Hill classroom blackboard | 10:15 | 10 / 8 | replaced |
| Andrew Abrams | 2 | 1706 (10:21) | Oak Hill classroom seating | 10:21 | 5 / 5 | replaced |
| Dean Sanford | 2 | 1717 (10:32) | Harvey Oak supply counter | 10:32 | 28 / 28 | replaced |
| Owen Logan | 2 | 1722 (10:37) | Oak Hill classroom blackboard | 10:33 | 7 / 3 | replaced |
| Vince Vale | 2 | 1706 (10:21) | Oak Hill classroom seating | 10:20 | 15 / 14 | replaced |
| Vincent Slater | 2 | 1702 (10:17) | Apartment 4 blackboard | 10:16 | 12 / 11 | replaced |

Full four-step rows: `data.json` → `query_b`.

---

## Query C — Shepard asleep at day-2 11:00

Live day-2 hourly includes:

- 00:00–07:00 sleeping
- **10:00–11:00 `asleep`**
- 11:00–12:00 at Hobbs Cafe taking part in the daily challenge

Decomp matches: **10:00–11:00 `asleep`**, then 11:00–11:10 reviewing challenge rules `[anchor=cafe customer seating]`.

Action chain 1440–1745 (one row per action change): he **does** sit cafe at **1588** (`curr_tile` on cafe, `act_address` Hobbs, “wash dishes and pack bag”, started 08:17). At **1599** the action is already `walk to Oak Hill College` / library table (still on cafe for a couple of steps). At **1685** (10:00) a new action starts: **`asleep`**, duration **60**, address bed. That is still the action at 1745.

Was the 11:00 sleep a scheduled block, or a replan after arriving? The **10:00–11:00 `asleep` block is in both the hourly and decomposed day-2 schedules.** The 08:23 cafe visit is a different, earlier action (`wash dishes` with Hobbs address), then college, then the scheduled 10:00 sleep.

---

## Query D — 20:15 vote surge

Off-cafe at 845 and on-cafe by 860 (5 people). Day-2 vote 2285/2300: **not on disk** (max_step 1780).

| Name | 815 (19:30) | 830 (19:45) | 845 (20:00) | 852 (20:07) | 860 (20:15) | Walk vs fire |
|---|---|---|---|---|---|---|
| Alexis Reed | kitchen, coliving | same | breakfast common room | **on cafe**, walking to Hobbs | on cafe, eating dinner | walk **after** 845 |
| Irene Dove | dorm bed | dorm bed | dorm desk | walking to Hobbs, still off | on cafe, walking to Hobbs | walk **after** 845 |
| Mike Hooks | on cafe, walking to college | college, reviewing notes | **off**, walking to Hobbs (`act_address` Hobbs) | on cafe | on cafe | walk **at or before** 845 |
| Nick Miller | pub dinner | pub dinner | off (57,27), `act_address` already Hobbs, “evening ballot” | on cafe, casting vote | on cafe, waiting tally | walk **at or before** 845 |
| Dean Sanford | **on cafe**, walking to Hobbs | **off**, walking to college | off (99,32), `act_address` Hobbs, “Arriving at Hobbs” | on cafe | on cafe | toward-cafe **at** 845 (had left cafe after 815) |

---

## Query E — add-ons

**E1 — 217 off-cafe “heading to Hobbs” through 1754**

Count matches. By persona: Irene 36, Owen 27, Vince 25, Shepard 21, Max 20, Nick 20, Ivan 17, Dean 14, Mike 13, Diana 11, Butcher 6, Vincent 4, Andrew 3. Reed/Olivia: **0**.

`curr_tile` changed in the prior 3 steps: **217 moving / 0 standing_still**.

**E2 — `GATHER LOCK` lines:** empty this pass (sim log not re-read; brief forbids journalctl / SSH-poke of the live PID). Checkpoint stamp packets do not grep that string.

**E3 — live `currently` (exact)**

| Name | `currently` |
|---|---|
| Alex Butcher | On day 1 in Doubland with 15 players remaining; Working as logistics coordinator at Harvey Oak Supply Store (supply store); execute assigned tasks, assist visitors, and complete shift responsibilities. |
| Alex Shepard | On day 1 in Doubland with 14 players remaining; Working as archivist at Oak Hill College (library); organize collections, help visitors, and maintain records. |
| Alexis Reed | On day 1 in Doubland with 14 players remaining; Working as research assistant at Oak Hill College (library); handle requests, update task lists, and follow up on open items. |
| Andrew Abrams | On day 1 in Doubland with 14 players remaining; Working as librarian at Oak Hill College (library); organize collections, help visitors, and maintain records. |
| Dean Sanford | On day 1 in Doubland with 14 players remaining; Working as inventory manager at Harvey Oak Supply Store (supply store); execute assigned tasks, assist visitors, and complete shift responsibilities. |
| Diana Ogden | On day 1 in Doubland with 14 players remaining; Working as sales associate at Harvey Oak Supply Store (supply store); execute assigned tasks, assist visitors, and complete shift responsibilities. |
| Irene Dove | On day 1 in Doubland with 14 players remaining; Working as barista at Hobbs Cafe (cafe); prepare drinks, serve customers, and clean the counter. |
| Ivan Pitts | On day 1 in Doubland with 14 players remaining; Working as pharmacy technician at The Willows Market and Pharmacy (store); execute assigned tasks, assist visitors, and complete shift responsibilities. |
| Max Shoemaker | On day 1 in Doubland with 14 players remaining; Working as pastry chef at Hobbs Cafe (cafe); prep ingredients, cook menu items, and coordinate kitchen timing. |
| Mike Hooks | On day 1 in Doubland with 14 players remaining; Working as cashier at The Willows Market and Pharmacy (store); assist customers, manage inventory, and close daily tasks. |
| Nick Miller | On day 1 in Doubland with 14 players remaining; Working as teacher at Oak Hill College (classroom); prepare lessons, teach sessions, and review progress. |
| Olivia King | On day 1 in Doubland with 14 players remaining; Working as waitstaff at Hobbs Cafe (cafe); execute assigned tasks, assist visitors, and complete shift responsibilities. |
| Owen Logan | On day 1 in Doubland with 14 players remaining; Working as stock clerk at The Willows Market and Pharmacy (store); assist customers, manage inventory, and close daily tasks. |
| Vince Vale | On day 1 in Doubland with 14 players remaining; Working as guest lecturer at Oak Hill College (classroom); prepare lessons, teach sessions, and review progress. |
| Vincent Slater | On day 1 in Doubland with 14 players remaining; Working as curriculum developer at Oak Hill College (classroom); execute assigned tasks, assist visitors, and complete shift responsibilities. |

Headcount half: 14 remaining say **14 players**; Butcher still says **15**. Day half: all 15 still **On day 1**. Jobs present on all 15. Zero “premiere day” / “full cohort”.

---

## Gaps

- **Day-1 `f_daily_schedule` and `f_daily_schedule_hourly_org` for the 14 survivors: empty** in scratch (overwritten). Cannot compute day-1 `hourly_covers_fire` / decomp gap / day-1 2×2 from this source. Butcher only.
- **`decomp_covers_fire` using the word “Hobbs” is 0/14** while every decomp fire block is `in_place` with `anchor=cafe customer seating` or `behind the cafe counter`. Hourly at the same minute **does** say Hobbs. Observation only: the two objects disagree on the token, not necessarily on the place. Cafe-anchor 2×2 is in `data.json` as `two_by_two_day2_decomp_cafe_anchor`.
- **Query B `act_event`: empty** on coord `movement` payloads. `act_address` taken from `partial_state.action_progress.resolved_address`.
- **Query B writer of the replacement:** empty inside the requested 4 steps. Observation with rows: every leaver’s last cafe tile already shows travel/work `act_address` (college, pub, dorm, house, supply, apartment) with remaining duration. The switch happened earlier than `last_on_cafe_step`.
- **Query D day-2 (2285/2300): not on disk.**
- **Query E2 GATHER LOCK count: empty this pass** (live log not opened).
- Checkpoint packets were not copied this pass; all rows above are from Supabase `personas_coords` + live `persona_scratch`.
