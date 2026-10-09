# 20261007-1 — 15 Doubles checklist

Premiere day of the L-Talks cast on Downtown. Fork of `l-talks-pit`. Survival is on in the server flag, and day 1 stays dormant, so there is no challenge and no vote yet. Sprint. Cap 6. Gather, when it starts, is PPG Cafe.

Read against the finished 6-person tape `20261001-2` (skip-premiere, Survival on from the first morning, stopped at step 4500). The shared window is steps 0–660, sim clock 06:30–17:30. This run was still generating. The caption totals below were taken at step 675, clock 17:45.

The 6-person pub worker is the family double. His roster name is now Ivan Pistsov. The busser on this run is a different person, Ivan Pitts.

## **SUMMARY:** Three things are worse than `20261001-2` on this same afternoon. The rest of the day holds, or it is the same miss.

- **The park line is far more common, and people freeze under it.** `walking to Point State Park @ Downtown:Street:ground` already appears 409 times by step 675. The whole finished 6-person tape had 159. Alex Shepard and Ivan Pitts each sit on tile (134, 193) for 65 minutes with that line and move 0 tiles. That tile is a street tile inside the park garden's rectangle. `outside_zone_safety_net` keeps them in travel, and the anchor stays on the street tile. Katya froze on that same tile for 31 minutes. This cast aims at the garden much more often, so the latch runs longer and more times.
  - **Check 2026-10-08:** The counts and freezes hold. The anchor is not what holds the tile. `(134, 193)` is the exact centre of the garden rectangle. While a person is not yet in the garden, the movement step walks them to that centre and calls standing on it arrival. Writer and corrected falsification are in the RCA below. "This cast aims at the garden more often" was not re-counted.
- **The line says they are walking to the park when they are already in it.** That form appears 153 times by step 675. The older tape had 9 in 4,500 steps. `relabel_to_landed` keeps the travel verb and only changes the @ room when the reported tile is the park. Irene's 28 minutes in the garden under `walking to EQT Supply Store` is the same safety net, aimed at EQT, while her tile does not move.
  - **Check 2026-10-08:** The caption writer is right. The count mostly comes from the street latch: 111 of the 154 rows aim the step at `(134, 193)`, and 20 more at `(134, 192)`. These are people inside the park being walked back out to the street centre. This is the same body writer as the first bullet. Irene's frozen tile is not explained yet. The backend sends her a 6-tile step north every step, and the body does not take it.
- **The Market shift was written, then deleted.** Mike Hooks (cashier) and Owen Logan (stock clerk) are the two people on `Downtown:Fifth Avenue Market:store`. Their day plan named that shop. `OFFMAP_BLOCK` then rewrote Mike's shift to PPG Cafe and Owen's shift to EQT Supply Store. The street sector Fifth Avenue matches inside the words Fifth Avenue Market, so the pass treats the shop as a place that cannot be used. The bodies followed the rewritten plan. Through 17:30 the Market is empty on both tapes. The cause on this run is the rewrite. The older tape did not write the shift and then remove it.
  - **Check 2026-10-08:** Confirmed. Run on the live code, the place check flags `Fifth Avenue` inside both of Mike's `at Fifth Avenue Market` lines. The stored plans say PPG Cafe (Mike) and EQT Supply Store (Owen).

## What held

- Nobody jumps. Both tapes have 0 steps over 6 tiles in this window.
- No village names in the captions. The word `pool` does not appear in the captions.
- Nobody is asleep from 12:00 to 17:30.
- Talk has the same shape as the older afternoon. No conversation lasts past 2 minutes. This run is less one-sided: 88 of 264 bursts, against 31 of 51.
- EQT and Penn College are fuller than on the 6-person afternoon. The three EQT staff are in the store for 369 to 393 of about 480 steps from 09:00 to 17:00. Katya was there for 196. Nick Miller and Alexis Reed are at the college for about 390 steps. Gosha was there for 223.
- The 13:00 cafe crowd is not new. Eleven of fifteen are at PPG Cafe at 13:00, and they have scattered by 14:00. On the older tape five of six were still at the cafe at 13:00, because the challenge had pulled all six there at 11:00. This premiere day is spread across the workplaces at 11:00.

## Regressions

- [ ] **The street caption is worse than the accepted tape.** Same line as the MVP accept: `walking to Point State Park @ Downtown:Street:ground`.
  - Shared window, steps 0–660: this run 382, the older run 75 (Katya 42, Nicolás 33). By step 675 this run is at 409. The finished older tape ended at 159.
  - This run, that window: Alex Shepard 149, Ivan Pitts 88, Mike Hooks 44, Vince Vale 38, Irene Dove 15, Owen Logan 13, Olivia King 12, Alexis Reed 10, Diana Ogden 7, Vincent Slater 6.
  - Zero tiles moved, same caption, 20 minutes or more, all on tile (134, 193) except where noted:
    - Older tape: Katya Fox, 12:29–12:59, 31 minutes.
    - This run: Alex Shepard 09:21–09:47 (27), 13:50–14:54 (65), and 15:22–15:54 (33). Ivan Pitts 15:55–16:59 (65). Vince Vale 13:29–13:49 (21). Mike Hooks 17:00–17:30 (31), still on that tile when the window closed.
  - The one-step form, a real step along the street, stays inside the MVP accept. The regression is the latch. Writer and falsification are in the RCA below.
  - **Check 2026-10-08** (Supabase `personas_coords`, run at step 717):
    - Counts: 382 against 75 in the window, and 159 for the whole older tape. These match. Through step 675 inclusive the count is 411, not 409.
    - Every zero-move run above matches to the step. Mike's run is now 60 minutes (steps 630–689) and still on the tile.
    - The runs hand off. Vince ends at step 439 and Alex starts at 440. Alex ends at 564 and Ivan starts at 565. Ivan ends at 629 and Mike starts at 630. One body holds the centre tile at a time.

- [ ] **A walk line names the park while the body is already in the park.**
  - `walking to Point State Park @ Downtown:Point State Park` appears 153 times by step 675. The older tape has 9 across all 4,500 steps.
  - Inside the window: Mike Hooks, 16:33–16:59, 27 minutes, 46 tiles, address already the park. Olivia King, 15:34–16:09, 36 minutes, 60 tiles, same.
  - Irene Dove, 15:03–15:30, 28 minutes, 0 tiles, in the park garden, line `walking to EQT Supply Store`. Writer and falsification are in the RCA below.
  - **Check 2026-10-08:**
    - Counts: 154 through step 675 inclusive, and 9 on the older tape. These match.
    - Step targets behind these rows: 111 are `(134, 193)`, 20 are `(134, 192)`, and the rest are single rows. Most of this line is the approach to the street latch from inside the park, not a separate miss.
    - Irene's run is confirmed: steps 513–540, `(141, 180)`, 28 rows.

- [ ] **The Market shift is deleted before anyone walks.**
  - On file: Mike Hooks, cashier, Four Gateway Center, `Downtown:Fifth Avenue Market:store`. Owen Logan, stock clerk, Three PNC Plaza, the same `work_area`. `daily_plan_req` names the Market for both.
  - The first draft of the day named it too. The sim log, then the stored plan:
    - Mike Hooks: `ring up purchases and balance the drawer at Fifth Avenue Market from 8:00 am to 12:00 pm` became `ring up purchases and balance the drawer at PPG Cafe from 8:00 am to 12:00 pm`. `return to Fifth Avenue Market for the afternoon shift from 12:30 pm to 4:00 pm` became `return to PPG Cafe for the afternoon shift from 12:30 pm to 4:00 pm`.
    - Owen Logan: `work the stock clerk shift at Fifth Avenue Market from 7:30 am to 11:30 am` and `from 5:00 pm to 6:00 pm` both became `work the stock clerk shift at EQT Supply Store` for those same hours.
  - The writer is `OFFMAP_BLOCK` (`_ground_schedule_to_map`), after the day plan and before the walk. It flags a map sector that has nothing to use. Fifth Avenue is a street. The check matches `at Fifth Avenue` inside `at Fifth Avenue Market`. The repair is told that building cannot be used, keeps the duty, and picks another shop: a register goes to PPG Cafe, stocking goes to EQT Supply Store.
  - The bodies follow that text. Mike is at PPG Cafe from step 99 (`Walking to PPG Cafe`, anchor `PPG Cafe > cafe > cafe customer seating`). Owen is at the EQT door from step 107 (`walking to EQT Supply Store for the shift`). Through step 700, no action text and no address says Fifth Avenue Market. This is not a failed walk.
  - The same pass also removed the Market from meals and errands that other people had written: Dean Sanford and Alex Butcher and Ivan Pitts, lunch; Max Shoemaker and Andrew Abrams, dinner; Alex Shepard, a walk. Each `real=` line names Fifth Avenue Market. Each `map=` line names PPG Cafe, O'Reilly Pub, or Point State Park.
  - Owen's afternoon at Penn College is a different line. The plan itself says `study market-structure notes at Penn College from 2:30 pm to 4:30 pm`. The word market became a class topic. That one was not an `OFFMAP_BLOCK` rewrite.
  - Andrew Abrams at EQT is also a different line. His plan says `walk to EQT Supply Store to pick up bar supplies from 10:30 to 11:15 am`, and the pub shift stays at 1:00 pm. The older pub worker did not make that supply run. It is not the Market rewrite.
  - Through 17:30 the tile count is still zero on both tapes. Yevgenia was at PPG Cafe for 424 steps with no Market line in the plan to delete. The older tape first steps inside the Market at step 1784, day 2 at 12:15. On this run the pass will strip the name again whenever a new plan says `at Fifth Avenue Market`. A day-2 visit only counts if the shift text survives that pass.
  - Falsification: if the place check does not match a shorter sector once a longer usable name continues it, those `OFFMAP_BLOCK` lines do not fire, and the stored shift still says Fifth Avenue Market.
  - **Check 2026-10-08:** Confirmed.
    - `persona_scratch` for both still has `work_area` `Downtown:Fifth Avenue Market:store`. Mike's `daily_req` says `ring up purchases and balance the drawer at PPG Cafe from 8:00 am to 12:00 pm` and `return to PPG Cafe for the afternoon shift from 12:30 pm to 4:00 pm`. Owen's says `work the stock clerk shift at EQT Supply Store` for both shifts.
    - `Fifth Avenue` (50110) and `Fifth Avenue Market` (50113) are both sectors in the Pittsburgh `sector_blocks.csv`.
    - The raw `OFFMAP_BLOCK` log lines live only on the server and were not re-read.

## RCA

Read at step 711, sim clock 18:21, still generating. No code change. The three writers are separate. A caption edit does not move the tile. A zone-box edit does not put the Market shift back.

> **Check 2026-10-08:** There are two body writers, not three. The street latch and most of the park-@ lines share one: the walk to the rectangle centre. The @ swap is still its own caption writer. The Market rewrite is separate, as stated.

### The street latch

Product lie: the line is `walking to Point State Park @ Downtown:Street:ground` for most of an hour, and the tile does not change.

Sample, Alex Shepard, step 500 (14:50). Body `(134, 193)`. Address `Downtown:Street:ground`. Raw act `Clearing away dead foliage and debris`. `movement_mode` `travel_to_zone`. Source `keyword_in_place:outside_zone_safety_net`. `zone_detail` `Downtown:Point State Park:ground:park garden`. Zone rectangle x 74–194, y 163–224. `planned_pos` and the saved tile are both `(134, 193)`. Emit cause `premature_inplace`: the garden task was replaced with `walking to Point State Park`.

Same shape on Ivan Pitts step 600 (raw act `watching the park visitors and thinking about the experiment's impact`), Vince Vale step 419 (raw act `Inspecting leaves for pests and disease`), Mike Hooks step 630, and Alex Shepard steps 171, 440, and 532. The approach steps that do move are one tile onto `(134, 193)` from `(134, 191)`, `(134, 190)`, or `(136, 191)`, and then they stop.

Two checks disagree. `is_tile_in_semantic_zone` says a tile has arrived only when its address is the target or a child of it. `(134, 193)` is `Downtown:Street:ground`, so it is not the garden. The comment in that function is the sidewalk case: the rectangle around a room includes the sidewalk, and the sidewalk is not arrival. `resolve_arrival_movement_mode` then forces `travel_to_zone` with source `outside_zone_safety_net` whenever the act had settled to `stationary` or `in_zone`.

The anchor picker does the other thing. `choose_zone_anchor` may keep the previous anchor when `is_tile_in_zone` says it is inside the rectangle. `(134, 193)` is inside x 74–194, y 163–224. The next step aims at the same street tile. The safety net fires again. The travel emit runs again.

> **Check 2026-10-08:** Wrong writer. `choose_zone_anchor` has no caller in the live engine; only `tests/replay/test_spatial_occupancy_policy.py` calls it. The live anchor in `plan.py` takes the garden tile nearest the centre, not the street tile.
>
> The writer that holds the tile is the zone speed-cap block in `execute.py` `_execute`. When the tile is not semantically in the target, it paths to `zone_center`, which is the midpoint of the rectangle. When the body already stands on that midpoint, it logs `ZONE ARRIVAL: … already at zone center` and returns the same tile. The garden rectangle x 74–194, y 163–224 has its midpoint at `(134, 193)`, which is `Downtown:Street:ground`. `is_tile_in_semantic_zone` correctly says not arrived, and the safety net re-issues travel. The walk to the centre then returns the same tile again.
>
> Evidence from Alex Shepard, steps 439, 440, and 500:
> - `target_selection.selected_tile` is `(135, 181)`, authority `Downtown:Point State Park:ground:park garden`, path length 14.
> - The emitted `planned_pos` is `(134, 193)` on all three steps. The chosen garden tile is never sent.
> - Step 439 lands on `(134, 191)` with address `Downtown:Point State Park:ground`. Step 440 walks out of the park, `(134, 191)` to `(134, 193)`, and stops.
>
> `reverie.py` passes the tile through unchanged. The reachability check returns `reachable` on steps 439 and 440, and `not_applicable` on step 500, where start equals target. `emit_validation.reason` is `as_is` on all three steps.

`build_presence_intent_description` is the caption writer. While `travel_to_zone` is on, presence is the street, and the planned address is the garden, the line is `walking to Point State Park @ Downtown:Street:ground`. That replacement is what the honesty trace calls `premature_inplace`.

Why this tape is worse than `20261001-2`: the choke is the same tile Katya sat on for 31 minutes. This cast has two park jobs, and the day plans send other people to the garden as well. Each trip can latch. One latch is an hour, not one step.

Falsification: if the anchor cannot be a tile whose address is outside the target, `(134, 193)` stops being `planned_pos` on the following step, and the hour-long zero-move runs end. A single street step whose next tile changes can still say `walking to Point State Park`. That single step stays in the MVP accept.

> **Check 2026-10-08, corrected falsification:** Changing the anchor would not move this number, because the anchor is not on this path. The corrected test: if a body outside its target walks toward the selected target tile (`target_selection.selected_tile`) instead of the rectangle midpoint, `(134, 193)` stops being `planned_pos` and the hour-long zero-move runs end. The park-@ count should also fall sharply, because those bodies are no longer walked out of the park. If the park-@ count does not fall, this diagnosis is wrong for that line.

Stays out: rewriting the travel sentence, padding the rectangle, and pinning people in the garden.

### The park @ and the EQT line

Product lie: `walking to Point State Park @ Downtown:Point State Park:...` (153 times by step 675). And Irene Dove, `walking to EQT Supply Store @ Downtown:Point State Park:ground:park garden`, tile frozen.

Olivia King, step 544 (15:34). Raw act `leaving the cafe and walking to Point State Park`. Emit cause `premature_inplace`, emitted act `walking to Point State Park`. Saved address `Downtown:Point State Park:ground`. Saved tile `(137, 192)`. Step target `(134, 193)`, the same street anchor. `relabel_to_landed` runs on the movement report. It changes the @ room to the landed address and does not change the verb. The test for that function is the same shape: `walking to EQT Supply Store @ Downtown:Two PPG Place:apartment:bed` becomes `walking to EQT Supply Store @ Downtown:Street:ground`. Here the landed room is the park, so the verb still says the trip and the @ says the park. `emit_honesty` is not rebuilt, which is why the trace still says the pre-landing rewrite.

> **Check 2026-10-08:** The caption mechanism is confirmed. `relabel_to_landed` only swaps the `@` part. The step target in this sample is the clue to the count. Olivia is inside the park at `(137, 192)` and is being sent to `(134, 193)`, the street midpoint. Across all 154 park-@ rows through step 675, 111 aim at `(134, 193)` and 20 at `(134, 192)`. Most of this line is bodies inside the park being walked out to the street latch, which is the same body writer as the chapter above. A caption fix alone would hide the walk-out.

Irene Dove, steps 513 and 530. Body stays `(141, 180)`. Address `Downtown:Point State Park:ground:park garden`. Raw act `Ordering a coffee at the supply store counter`. Source `keyword_in_place:outside_zone_safety_net`. Zone is the EQT shelf, about x 331–335, y 156–159. Step target `(141, 174)`, six tiles north, and the saved tile never takes it. She is not at EQT, so the safety net holds `travel_to_zone`. Presence is the garden and the planned address is the shelf, so the line is `walking to EQT Supply Store @ Downtown:Point State Park:ground:park garden`.

> **Check 2026-10-08:** The caption part is confirmed. The frozen body is not explained.
> - On steps 511–515, `start_pos` is `(141, 180)` and `planned_pos` is `(141, 174)`. `actual_path` is only `[[141, 180]]`.
> - `reachability_override.reason` is `reachable`, and `emit_validation.reason` is `emit_travel_keep_waypoint`.
> - The step target is closer to EQT than her tile: `zone_distance_planned` 204–205, against `zone_distance_start` 210–211.
>
> So the backend sends a valid, closer 6-tile step every minute, and the body does not take it. The refusal happens after emit: in frontend A*, the movement report, or report acceptance. That writer is not named yet.

Falsification: if `relabel_to_landed` drops a leading trip once the landed address is the destination sector, the 153 park-@ lines become `at Point State Park`. If the safety net does not re-issue travel when the new step target is no closer to the room than the tile she is on, Irene's garden line stops refreshing while `(141, 180)` stays put.

> **Check 2026-10-08, corrected falsification:**
> - **Park-@:** run the street-latch falsification first. The `relabel_to_landed` test only applies to whatever park-@ lines remain after that.
> - **Irene:** the "no closer" condition is false in the data, because her step target is closer every step. Silencing the line would hide a body that does not move. Next, find why a reachable 6-tile step from `(141, 180)` to `(141, 174)` comes back as a zero-tile report.

Stays out: a second caption pass on top of the latch fix. Irene's line and the street latch share the safety net. The @ swap is its own writer.

### The Market shift

Product lie: Mike Hooks and Owen Logan never enter Fifth Avenue Market. Their jobs are that shop.

The day plan named it. The log then shows the rewrite:

- `OFFMAP_BLOCK Mike Hooks real='ring up purchases and balance the drawer at Fifth Avenue Market from 8:00 am to 12:00 pm' map='ring up purchases and balance the drawer at PPG Cafe from 8:00 am to 12:00 pm'`
- `OFFMAP_BLOCK Mike Hooks real='return to Fifth Avenue Market for the afternoon shift from 12:30 pm to 4:00 pm' map='return to PPG Cafe for the afternoon shift from 12:30 pm to 4:00 pm'`
- `OFFMAP_BLOCK Owen Logan real='work the stock clerk shift at Fifth Avenue Market from 7:30 am to 11:30 am' map='work the stock clerk shift at EQT Supply Store from 7:30 am to 11:30 am'`
- `OFFMAP_BLOCK Owen Logan real='work the stock clerk shift at Fifth Avenue Market from 5:00 pm to 6:00 pm' map='work the stock clerk shift at EQT Supply Store from 5:00 pm to 6:00 pm'`

Writer: `_ground_schedule_to_map`. A map sector with nothing to use, written after `at`, `to`, or `in`, is sent to `offmap_block_check_v1.txt` as a building that cannot be used. Fifth Avenue is a street sector. The pattern matches `at Fifth Avenue` inside `at Fifth Avenue Market`. The repair keeps the duty and picks a listed shop. A register goes to PPG Cafe. Stocking goes to EQT Supply Store. The hourly anchors follow the rewritten sentence. Mike is at PPG Cafe from step 99. Owen is at the EQT door from step 107. Through step 700 no address says Fifth Avenue Market.

The same pass rewrote other people's Market meals and errands. Dean Sanford, Alex Butcher, and Ivan Pitts lost a lunch there. Max Shoemaker and Andrew Abrams lost a dinner. Alex Shepard lost a walk. Those `real=` lines name Fifth Avenue Market.

Owen's `study market-structure notes at Penn College from 2:30 pm to 4:30 pm` was in the plan before this pass. Andrew's `walk to EQT Supply Store to pick up bar supplies from 10:30 to 11:15 am` was too. Those two are not this writer.

The older tape also has nobody in the Market through 17:30. It did not write the shift and then delete it. Yevgenia had no Market line to strip. This pass will strip the name on every later day whose plan says `at Fifth Avenue Market`.

Falsification: if a shorter sector does not match once a longer usable name continues it, those four `OFFMAP_BLOCK` lines do not fire, and the stored shift still says Fifth Avenue Market.

> **Check 2026-10-08:** Writer and falsification confirmed.
> - **Reproduced on live code:** `_offmap_map_names` returns `['Fifth Avenue']` for both of Mike's lines. It returns `[]` for `study market-structure notes at Penn College from 2:30 pm to 4:30 pm` and for `walk down Fifth Avenue to the cafe`.
> - **Why the street wins:** the check goes longest name first and skips usable names. `Fifth Avenue Market` is skipped because it is Mike's own work sector, so `Fifth Avenue` is checked next and matches on the word boundary before ` Market`.
> - **Second failure mode:** if the model rewrite call fails, the backup path strips ` at Fifth Avenue` with a regex. That would leave broken text such as `ring up purchases and balance the drawer Market from 8:00 am to 12:00 pm`. The same fix removes both.

Stays out: moving Mike and Owen by hand, and treating the empty afternoon tile count as the same miss as Yevgenia's.

## Same shape, not a regression

> **Check 2026-10-08:** The 2026-10-08 check did not re-score this section, "What held", or the workplace table below.

- [x] **Movement cap holds.** 0 steps over 6 tiles on either tape through step 660.
- [x] **Captions do not name the village, and they do not say pool.** Both tapes, this window.
- [x] **No afternoon sleep.** Both tapes, 12:00–17:30.
- [x] **Talk still dies inside 2 minutes.** Older afternoon: 51 bursts, 48 of them one minute, 3 of them two minutes, 31 one-sided. This afternoon: 264 bursts, 252 of them one minute, 12 of them two minutes, 88 one-sided. Everyone on this cast spoke at least once. The length limit is the same. The one-sided share is lower.

## Fuller than the 6-person afternoon

Work window is 09:00–17:00, about 480 steps.

| Workplace | Older tape | This run |
|---|---|---|
| EQT Supply Store | Katya 196 | Alex Butcher 389, Dean Sanford 369, Diana Ogden 393 |
| Penn College | Gosha 223 | Nick Miller 393, Alexis Reed 392, Vincent Slater 322 |
| O'Reilly Pub | Ivan Pistsov 214 | Ivan Pitts 259, Andrew Abrams 232 |
| PPG Cafe | Luba 416, and only four places all day | Olivia King 362, Irene Dove 243, Max Shoemaker 182 |
| Point State Park | no job on that cast | Vince Vale 377, Alex Shepard 253 |
| Fifth Avenue Market | Yevgenia 0 | Mike Hooks 0, Owen Logan 0. The shift was written, then `OFFMAP_BLOCK` moved it. |

Luba's first day was the cafe, her home, and the street. Olivia's day adds the park. Irene and Max leave the cafe for long stretches. That part of the older miss is lighter here. Max is at the cafe for only 182 steps, then the college and the pub, so the pastry shift itself is thin.

At 10:00 this cast is already in the shops: EQT 4, PPG Cafe 4, Penn College 2, the park 1, the pub 1. The older cast is all six in PPG Cafe at 11:00 and still there at 12:00. That gather is the challenge. This day does not run one.

## Not scored yet

Premiere day. Survival stays asleep until day 2. Do not fail these on this afternoon.

- [ ] **20:00 ballots.** The older tape's three votes are not re-scored here. This run has not reached a vote.
- [ ] **A promise shows up as a meeting before 20:00.** No pledges have been asked for.
- [ ] **The ally check can count Nicolás.** Different cast. Not this tape.
- [ ] **Day 2 opens Fifth Avenue Market.** The older tape's first body inside is step 1784. On this run that visit counts only if the plan line still says Fifth Avenue Market after `OFFMAP_BLOCK`.
- [ ] **Watch step-panel links, and Downtown Join.** Not exercised.

## Accepted for MVP

Accepted 2026-09-30. Recorded here. The accept stays. The rate is scored above as a regression.

- [ ] **A stay names the room they are in.** The street line is back: 409 times by step 675, against 159 on the finished older tape.
  - **Check 2026-10-08:** 411 through step 675 inclusive. 159 confirmed.
- [ ] **No pool line in the captions.** Clear through step 660. The older pool line lived in a stored promise, which this day has not written.

## Sim stall issues

The slowdown is a stall inside the think-and-write window. A healthy step is already about 14 seconds for both this 15-person run and the 6-person run. Steps of two minutes or more are 22% of 20261007-1 and 60% of its wall clock.

Recommendation: cap the silent network waits, and write positions once per step. That is the change that removes the tail. I have not changed any code.

Through step 732 the clock splits like this. The browser is in blocking mode on every step, which is the documented VPS default, and it returns in about a second because the tab is reused.

┌───────────────────────────────────┬──────────────┬─────────────────────────────┬──────────────────────┐
│ Slice                             │ Healthy step │ Typical daytime step (~40s) │ Stall (5 min and up) │
├───────────────────────────────────┼──────────────┼─────────────────────────────┼──────────────────────┤
│ Browser wait                      │         0.3s │                          3s │                   2s │
├───────────────────────────────────┼──────────────┼─────────────────────────────┼──────────────────────┤
│ Scratch and metadata              │         2.5s │                          3s │                   3s │
├───────────────────────────────────┼──────────────┼─────────────────────────────┼──────────────────────┤
│ Think, path check, position write │          11s │                         33s │             6–12 min │
└───────────────────────────────────┴──────────────┴─────────────────────────────┴──────────────────────┘

The 11-second think window is the same with 6 people and with 15. Fifteen people cost more because more steps leave that path: 29% of steps ran over a minute here, against 6% on the smaller cast.

Inside a long step, logged model calls stay small. A 492-second step had 15 seconds of them. The 12-minute step's longest logged call was 11 seconds. Path search is also small on this maze: a successful downtown search is about 0.11 seconds, and a search of the whole walkable map is 10 seconds. The 492-second step did two target tests and one reroute.

Two calls in that window can sit for minutes without a line in the sim log:

• Embeddings use the OpenRouter client with no timeout, so the SDK waits up to 10 minutes. Those calls are omitted from LLM_METRIC.
• Position writes are one HTTP call per person on a shared HTTP/2 client, timeout 120 seconds, up to 3 attempts. A failure goes to the logger, not this sim log. The same log prints Server disconnected on every step: about 30 on a healthy step, about 175 on a stalled one.

Options

1. Cap the waits and batch the position write (recommended). Give embeddings a 10–15 second timeout. The code already falls back to a zero vector. Give the position write a 10 second timeout and one attempt, and send the whole cast in one call. This removes the multi-minute tail, which is 60% of the wall. The healthy step is already 14 seconds. The risk is a blank vector on a timed-out memory, or Supabase left one step behind the movement file until the next write. Both are existing fallbacks. Do it on the next sim. This run is stopped: no runner, last movement file is step 732. Size is a small patch and a short local test.

2. Also cap the zone search at the first reachable tile, or at 8, instead of 100. A miss costs about 10 seconds and the cap is 100 samples. That saves a few seconds on steps that already log a reroute. It leaves the 8-minute steps alone. The anchor can then be the first reachable sample rather than the closest of 100. Worth folding into option 1.

3. Leave the browser, the worker count, and pathfinding as they are. The browser is 1–3 seconds of a step. Workers are already one per person. A closed-set pathfinder matched the current search at about 0.11 seconds on downtown corridors. The 5-minute planning pause never fired on either tape.

I could not see which of the two silent calls held a given step, because neither one prints into this log and the process is already gone. The deadlines in the code line up with the stalls. A single timing line around the position batch, plus embedding lines in LLM_METRIC, on the next run would name the call.

### Check 2026-10-08 (stall section)

The size of the problem is right. The two suspect calls are real risks in the code, but the evidence does not pick either one. One part of option 1 conflicts with the SOT: a single attempt on the position write would turn a slow step into a stopped sim. The cheapest next step needs no new run. Read the profiler summaries that are already in the sim log for the 24 steps of 5 minutes or more.

Sources: step timing comes from `personas_coords.recorded_at` in Supabase, using the first row of each step. Everything else is the current backend code. I did not read the sim log, which lives on the server.

**Confirmed**

- Steps of 2 minutes or more are 21.9% of steps and 60.0% of the wall clock. Steps over a minute are 29.5% here, against 6.0% on `20261001-2`. There are 24 steps of 5 minutes or more. The longest is 745 seconds, at step 690. The run is `stopped` at step 732.
- The embedding client is the OpenRouter client, built without a timeout. Correction on the size: the SDK default (openai 2.21) is a 600-second read timeout plus 2 automatic retries. One call can wait about 30 minutes, not 10.
- Embeddings are missing from `LLM_METRIC` only because `LLM_COMPACT_METRICS_INCLUDE_EMBEDDINGS` defaults to `false`. That flag already exists, so turning it on needs no code.
- The zero-vector fallback exists, and the 1536-length zeros are compressed to 768. A zero vector drops out of similarity search, so a timed-out memory is stored but never recalled.
- The position write is one `update_avatar_position_dev` call per person, one after another. It goes through supabase-py, which has HTTP/2 on and a default timeout of 120 seconds. It makes up to 3 attempts. Errors from each attempt go to the logger.
- The zone search runs up to 100 path searches. It keeps going after the first success unless that tile is within 3 tiles of the person.
- Option 2 does not move the tail. I agree with that. A reroute happens about once a step in every speed bucket: 61% of fast steps have one, and 63–69% of slow steps. No step logged `no_reachable_tile_in_zone`.

**Corrections**

1. **The fast step is not the same size for both casts.** On the 6-person tape, the fastest tenth of steps take 5.5 seconds, and the median step is 10 seconds. On this run they take 18 and 45 seconds. Every step is about three times slower here, not only the tail. Suppose every step of 2 minutes or more became a median step. The wall clock would fall from 15.7 hours to about 8.3 hours. That is about 1.9 times faster, and the median step would still be 45 seconds against 10. The cost of the larger cast is a second problem, separate from the stall.
2. **The 6-person tape stalls too.** It has 6 steps of 5 minutes or more, and the longest is 884 seconds. Steps of 2 minutes or more are 34% of its wall clock. The mechanism is probably the same, and the larger cast makes it more frequent.
3. **The evidence against the position write is weak.**
   - The write function stamps `recorded_at` with the current time on every write.
   - Within a step, the 15 rows land with a median spread of 2.5 seconds. The largest spread across all 732 steps is 8.8 seconds.
   - Those timestamps come from the movement-report write after the browser step. It uses the same client, the same function and the same one-by-one loop, and it never stalled partway through a step.
   - The earlier write of the step's targets is not measured directly, because the later write overwrites its timestamp. So it is not ruled out, but its twin never hung.
4. **A suspect is missing: database calls during the think phase.**
   - Memory reads and writes go through `DoubleMemoryClient`. That is a separate supabase-py client with the same 120-second HTTP/2 default.
   - Its setting `max_query_timeout_s = 15` is never applied anywhere.
   - These calls run inside the parallel think stage, where the time goes. That stage waits for every person's worker with no time limit, so one stuck call holds the whole step.
   - `Server disconnected` is the error httpx raises when an HTTP/2 connection drops. Any of these clients can raise it, not only the position write.
5. **"Neither prints into this log" is only partly true.**
   - The step profiler is on by default (`ENABLE_STEP_PROFILER=true`).
   - Every step it prints `TOTAL TIME`. It prints `LLM CALLS` with the slowest call and a per-function breakdown, and that includes `get_embedding`, because the profiler does not apply the `LLM_METRIC` embedding filter. It also prints `MEMORY RETRIEVALS` with the slowest retrieval.
   - It prints `OBS_PIPE_STEP_SUMMARY` with `supabase_update_position_ms`.
   - The step's position write prints `SUPABASE SOT: n/15 positions written`, and it prints `Partial write` when people are missing.
   - The log file outlives the process. If the slowest model call and the slowest retrieval are small on the 24 long steps, the time is in a database call that has no timer.
   - One limit: the per-person profiler timers cover the sequential pass, not the parallel think stage. The think stage shows only as the total minus the timed phases.
6. **One attempt on the position write conflicts with `sot_be-fe.md` §4.8.**
   - A partial write is a hard stop by design. `INTENT_PERSIST_HARD_FAIL` defaults to `true`, and `.env.local` sets `SUPABASE_COORD_REQUIRED=true`.
   - With one 10-second attempt, a blip that a retry fixes today would end the run with `INTENT_PERSIST_INCOMPLETE`.
   - "Supabase one step behind" is not an existing fallback. The SOT forbids it.
   - Keep 3 attempts and shorten each one, for example 10–15 seconds each.
7. **"Send the whole cast in one call" is not a small patch.** No batch function exists in the database. It needs a new migration with a multi-row write and the `grid_deltas` inserts, an update to `db_reference.md`, and a test. Do it as its own step, after the timeout fix has proven out.
8. **Option 3, leaving pathfinding alone, holds for the tail but not for the steady cost.**
   - Every path search rebuilds a cost grid for the whole map, about 0.1 seconds on a 409×437 grid. It also checks whether a tile is already queued by scanning a list.
   - A reroute can run up to 100 searches, and there is about one reroute per step. So the steady cost is a few seconds per step, which adds to correction 1 but not to the tail.
   - On a local synthetic grid of downtown's size, a successful search took 0.19 seconds. A failed search took 0.56 seconds on narrow corridors and 4.2 seconds on a fully open grid.

**Suggested order**

1. **No code.** Pull the existing sim log for the 24 steps of 5 minutes or more and read their profiler summaries: the slowest call, `get_embedding`, the slowest memory retrieval, and `supabase_update_position_ms`. That either names the call or narrows it to a database call with no timer.
2. **Next run.** Set `LLM_COMPACT_METRICS_INCLUDE_EMBEDDINGS=true`. Add one timing print around the step's position write and one around the parallel think stage.
3. **Fix.**
   - Embedding client: timeout 10–15 seconds, at most 1 retry. The zero-vector fallback already exists.
   - Both Supabase clients, position and memory: pass `postgrest_client_timeout` of 10–15 seconds through `ClientOptions`. If `Server disconnected` keeps appearing, also pass an httpx client with `http2=False`.
   - Keep 3 attempts on the position write (§4.8).
   - A stall of 6–12 minutes fits either a 600-second embedding read or several 120-second database timeouts. Step 1 decides which one to fix first.
4. **Later, separately.** The batch write, which needs a migration. The cost of the larger cast (correction 1), as its own investigation.
