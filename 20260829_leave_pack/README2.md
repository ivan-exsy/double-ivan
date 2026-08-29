# Leave-after-arrival pack 2 — `20260828-1`

Read-only dump for `20260829_datareq_2_finalize-fix.md`. Raw rows: `data2.json`. Cafe tiles = x 72–83, y 19–30. Collected with max_step **1819** on disk (day-2 ~12:14). Runner not touched. Same answers also sit under **Responses** in the data-request file.

`dest` / `target_zone` in the JSON is a **bounding box**, not a place name. Stated destination is `act_address` / `act_description`. Body is `curr_tile`.

---

## Clarification (2026-08-29 13:46 ET)

### 1. Evening block — Query 1 and Query 2 are different tests

Not inverted. Both totals are 12/14. They are **not the same 12**.

| Test | Yes | No |
|---|---|---|
| Query 1: Hobbs block **starts at 20:00** | 12 (includes Nick, Vince) | Dean, Mike (Hobbs **19:00–21:00**) |
| Query 2: Hobbs hourly **covers 19:00–20:00** | 12 (includes Dean, Mike) | Nick, Vince |

Query 1’s lead was a **framing slip** if read as “only Dean and Mike have Hobbs at 19:00.” The table already had Hobbs at 19:00 for twelve. Query 2 is the cover-19:00 count. Hourly rows have **no address field**; Hobbs = the word in the text.

| Persona | Hobbs covers 19:00–20:00 | Text at 19:00 | Text at 20:00 |
|---|---|---|---|
| Shepard | yes | at Hobbs Cafe settling in before the evening vote | finishing dinner at Hobbs Cafe after the vote |
| Reed | yes | arriving at Hobbs Cafe for the evening vote | at at Hobbs Cafe taking part in the evening vote |
| Andrew | yes | at Hobbs Cafe for the evening vote | at Hobbs Cafe taking part in the evening vote |
| Dean | yes | at Hobbs Cafe for the evening vote (19:00–21:00) | (same block) |
| Diana | yes | at Hobbs Cafe early for the evening vote | taking part in the evening vote at Hobbs Cafe |
| Irene | yes | at Hobbs Cafe settling in before the evening vote | having dinner at Hobbs Cafe after the vote |
| Ivan | yes | having dinner at Hobbs Cafe before the vote | at Hobbs Cafe taking part in the evening vote |
| Max | yes | at Hobbs Cafe reviewing notes before the vote | at Hobbs Cafe taking part in the evening vote |
| Mike | yes | at Hobbs Cafe for the evening vote (19:00–21:00) | (same block) |
| Nick | **no** | waking up and starting morning routine at home | at Hobbs Cafe taking part in the evening vote |
| Olivia | yes | at Hobbs Cafe reviewing notes before the vote | at Hobbs Cafe for the evening vote |
| Owen | yes | at Hobbs Cafe for the evening vote | at Hobbs Cafe taking part in the evening vote |
| Vince | **no** | waking up and starting morning routine at home | at Hobbs Cafe participating in the evening vote |
| Vincent | yes | arriving at Hobbs Cafe for the vote | at Hobbs Cafe for the evening vote |

**Total: 12/14** cover 19:00–20:00 with a Hobbs hourly.

### 2. Raw `act_address` at the leave-write

Query 4’s college / pub / dorm labels were **shortenings of the raw strings**. Raw stored `act_address`:

| Person | Day | Step | Raw `act_address` | `<persona>` prefix |
|---|---|---|---|---|
| Butcher | 1 | 280 | `the Ville:Oak Hill College:classroom:classroom student seating` | no |
| Reed | 1 | 287 | `the Ville:The Rose and Crown Pub:pub:bar customer seating` | no |
| Diana | 1 | 247 | `the Ville:Oak Hill College:classroom:classroom student seating` | no |
| Ivan | 1 | 280 | `the Ville:Dorm for Oak Hill College:Dorm Room 2:blackboard` | no |
| Nick | 1 | 300 | `the Ville:House 4:common room:common room table` | no |
| Shepard | 2 | 1599 | `the Ville:Oak Hill College:library:library table` | no |
| Reed | 2 | 1700 | `the Ville:Oak Hill College:classroom:blackboard` | no |
| Andrew | 2 | 1706 | `the Ville:Oak Hill College:classroom:classroom student seating` | no |
| Dean | 2 | 1717 | `the Ville:Harvey Oak Supply Store:supply store:behind the supply store counter` | no |
| Owen | 2 | 1718 | `the Ville:Oak Hill College:classroom:blackboard` | no |
| Vince | 2 | 1705 | `the Ville:Oak Hill College:classroom:classroom student seating` | no |
| Vincent | 2 | 1701 | `the Ville:Apartment 4:main room:blackboard` | no |

**0/12** begin with `<persona>`.

Write-step `social_seek_target` / `social_seek_until_step`: **empty** on those coord rows.

### 3. Day-1 snapshot hourly coverage

14 survivors, midnight rewrite only. Block covering 10:00 and 19:00: `earlier today — survival preparations and the vote` (no Hobbs). **10:00–11:00 Hobbs: 0/14. 19:00–20:00 Hobbs: 0/14.** Original day-1 appointments in this table: **empty**.

---

## Query 1 — day-2 vote block

Live scratch (`last_planned_date=2026-08-30`), 14 remaining. Hourly 18:00–21:00 plus decomp around 20:00.

**Hobbs vote start is mixed, not one shape.**

- **12/14** have a Hobbs block that **starts at 20:00** (20:00–21:00), usually “taking part in the evening vote.” Most of those also have a **separate** Hobbs hour at 19:00–20:00 (“settling in” / “arriving” / “before the vote”).
- **Dean, Mike:** one Hobbs block **19:00–21:00** (starts an hour before the fire, spans it). The collector’s `shape` label on those two rows said `19:00-20:00`; the block itself is two hours.
- **Nick, Vince:** 19:00–20:00 is **not Hobbs** — `waking up and starting morning routine at home`. Their Hobbs vote block is **20:00–21:00**.

**Decomp at 20:00:** same text as the hourly 20:00 block. **0/14** travel verbs. **0/14** tagged `mode=in_place` (those tags appear on morning decomp, not on these evening rows). No walk-to-Hobbs sub-task at 20:00.

| Name | 18:00 | 19:00 | 20:00 | Decomp at 20:00 |
|---|---|---|---|---|
| Shepard | dinner Hobbs | settling in before vote | finishing dinner after the vote | same, no travel |
| Reed | dinner Hobbs | arriving for the vote | taking part in the vote | same, no travel |
| Andrew | dinner Hobbs | at Hobbs for the vote | taking part | same, no travel |
| Dean | dinner **Rose and Crown** | **19:00–21:00** at Hobbs for the vote | (same block) | same, no travel |
| Diana | dinner Hobbs | at Hobbs early | taking part | same, no travel |
| Irene | dinner Hobbs | settling in before vote | dinner after the vote | same, no travel |
| Ivan | dinner Hobbs | dinner before the vote | taking part | same, no travel |
| Max | dinner Hobbs | reviewing notes before vote | taking part | same, no travel |
| Mike | dinner Hobbs | **19:00–21:00** at Hobbs for the vote | (same block) | same, no travel |
| Nick | dinner Hobbs | **wake/morning routine at home** | taking part | same, no travel |
| Olivia | dinner Hobbs (from 17:00) | reviewing notes before vote | at Hobbs for the vote | same, no travel |
| Owen | dinner Hobbs | at Hobbs for the vote | taking part | same, no travel |
| Vince | dinner Hobbs | **wake/morning routine at home** | participating in the vote | same, no travel |
| Vincent | dinner Hobbs | arriving for the vote | at Hobbs for the vote | same, no travel |

Prediction on file (`20:00–21:00`, in-place, no travel): **12/14 start a Hobbs block at 20:00; decomp has no travel.** Dean/Mike start at **19:00**. Nick/Vince have a non-Hobbs 19:00 hour.

---

## Query 2 — who owns the pre-event hour

**10:00–11:00 non-Hobbs: 1/14 — Shepard only (`asleep`).** The other 13 have a Hobbs block covering 10:00.

**19:00–20:00 non-Hobbs: 2/14 — Nick and Vince (`waking up and starting morning routine at home`).** Dean’s 18:00 is Rose and Crown; his 19:00 is already Hobbs.

| Name | 09:00 | 10:00 | 11:00 |
|---|---|---|---|
| Shepard | Oak Hill library | **asleep** | Hobbs challenge |
| Reed | getting ready at home | Hobbs reviewing notes | Hobbs challenge |
| Andrew | breakfast at home | arriving Hobbs / notes | Hobbs notes |
| Dean | walking to supply store | arriving Hobbs early | Hobbs challenge |
| Diana | breakfast at home | Hobbs notes | Hobbs challenge |
| Irene | breakfast at home | arriving Hobbs early | Hobbs challenge |
| Ivan | heading to Willows | Hobbs notes | Hobbs challenge |
| Max | Hobbs lunch prep | arriving Hobbs / notes | Hobbs challenge |
| Mike | Willows register | arriving Hobbs early | Hobbs challenge |
| Nick | breakfast at Hobbs | arriving Hobbs early | Hobbs challenge |
| Olivia | walking to Hobbs shift | arriving Hobbs early | arriving Hobbs for challenge |
| Owen | Johnson Park exercise | arriving Hobbs / notes | Hobbs challenge |
| Vince | lecture prep at home | arriving Hobbs early | Hobbs notes |
| Vincent | breakfast at home | Hobbs notes | Hobbs challenge |

Evening 18/19/20: see Query 1 table.

Shepard’s 10:00 `asleep` is **one persona**, not the table.

---

## Query 3 — instruction present? **(decisive)**

Live `persona_scratch` has **no `survival` column**. Closest snapshotted `scratch.survival` is `persona_day_snapshots` **day 1**, steps **0–1084** (14 survivors). That is **end of survival day 1 / midnight**, not step 1445.

**All 14 snapshots:**

| Field | Value |
|---|---|
| `challenge_deadline_hour` | **11.0** |
| `vote_deadline_hour` | **20.0** |
| `gathering_arena` | **Hobbs Cafe** |
| `post_vote_date` | **2026-08-29** |
| `current_day` | **1** |
| `alive_players` length | **14** |

Expected `11`, `20`, Hobbs: **match** in that snapshot.

Post-vote at that snapshot: marker **is set** to calendar date **2026-08-29**. Day-2 rollover is **2026-08-30 05:55**. The marker compares equal to `curr_time`’s date and **expires when the date differs**, so on the morning of the 30th it would **not** be active (challenge line would not be dropped for that reason). **Live** `post_vote_date` at step 1445: **empty** in Supabase (no live survival blob).

**`CALENDAR DEADLINE RULE` verbatim from `run_gpt_prompt_daily_plan`: `deferred: PID`.** That string lives on the **hourly** calendar helper in code, not on the daily-plan prompt’s “arrive about an hour earlier” lines.

---

## Query 4 — what writes the departure

Walked back from last cafe tile until `act_address` first equals the away destination. `chatting_with` empty on all 12 writes. **`seek`: `deferred: PID`** (no log). None of the 12 writes fall on an hourly-block `:00` start. Tag: **`unknown` 12 / 12**.

| Person | Day | Write clock | `act_address` | `act_description` | start / dur | In 10:15–10:30 |
|---|---|---|---|---|---|---|
| Butcher | 1 | 10:35 | Oak Hill classroom seating | walking to Oak Hill College | 10:35 / 25 | no |
| Reed | 1 | 10:42 | Rose and Crown bar seating | listening to challenge rules | 10:42 / 10 | no |
| Diana | 1 | 10:02 | Oak Hill classroom seating | spread challenge notes on table | 10:02 / 5 | no |
| Ivan | 1 | 10:35 | Dorm Room 2 blackboard | walking to Dorm | 10:35 / 25 | no |
| Nick | 1 | 10:55 | House 4 common room table | at House 4 | 10:55 / 10 | no |
| Shepard | 2 | 08:34 | Oak Hill library table | walk to Oak Hill College | 08:34 / 6 | no |
| Reed | 2 | **10:15** | Oak Hill classroom blackboard | reading challenge rules | 10:15 / 10 | **yes** |
| Andrew | 2 | **10:21** | Oak Hill classroom seating | spreading challenge notes | 10:21 / 5 | **yes** |
| Dean | 2 | 10:32 | Harvey Oak supply counter | walking to supply store | 10:32 / 28 | no |
| Owen | 2 | 10:33 | Oak Hill classroom blackboard | walking to Oak Hill College | 10:33 / 7 | no |
| Vince | 2 | **10:20** | Oak Hill classroom seating | walking to Oak Hill College | 10:20 / 15 | **yes** |
| Vincent | 2 | **10:16** | Apartment 4 blackboard | walking to Apartment 4 | 10:16 / 12 | **yes** |

**Day-2 writes inside 10:15–10:30 (steps 1700–1715): 4/7** — Reed, Andrew, Vince, Vincent. Dean 10:32 and Owen 10:33 sit just after 10:30. Shepard 08:34 is earlier.

`target_zone` on each write is a coordinate box (college / pub / dorm / house / supply / apartment) — not name-tested. Full rows: `data2.json` → `query_4`.

---

## Query 5 — walk-time budget

Tiles at **10:55** (step **1740**; window 1738–1742 matches 1740). Manhattan to nearest cafe-box tile. `MAX_TILES_PER_STEP` 6 → min minutes = ceil(dist/6).

| Name | Tile | Dist | Min walk | Action at 10:55 |
|---|---|---|---|---|
| Shepard | (16, 32) | **58** | 10 min | asleep |
| Diana | (119, 22) | 36 | 6 min | organizing notes |
| Owen | (113, 30) | 30 | 5 min | “at Hobbs Cafe” (tile is **off** box) |
| Reed | (109, 20) | 26 | 5 min | rehearsing scenarios |
| Vince | (107, 32) | 26 | 5 min | rehearsing responses |
| Andrew | (108, 20) | 25 | 5 min | studying Silent Pact rules |
| Dean | (67, 44) | 19 | 4 min | “reviewing … at cafe seating” (tile **off** box) |
| Vincent | (86, 24) | **3** | 1 min | highlighting points |

**Median dist = 26** (≈ 5 min). All eight **> 0**. A block that **starts at 11:00** cannot have them **in a seat at 11:00** unless they are already on a cafe tile; none of these eight are.

---

## Query 6 — stuck day number

1. `survival_season_state.current_day` **now = 2** (phase SOCIAL, `updated_at` 2026-08-29 17:05 UTC). **History: empty** — the table does not keep versions.
2. Structured survival events with a `day` field, steps 1000–1500: **empty** in `dbl_memory`. Snapshot `day_end_step` **1084** is the midnight cut.
3. `scratch.survival["current_day"]` live column: **empty** (not stored on `persona_scratch`). From the day-1 snapshot (all 14): **`current_day` = 1**.
4. `[SURVIVAL:PHASE] NIGHT -> SLEEP` and `=== Day N ===` near step 1085: **`deferred: PID`**.

Season counter is **2** now. Snapshotted planner `current_day` at midnight was still **1**. `currently` is restamped from `scratch.survival["current_day"]` (not from the season row directly).

---

## Query 7 — day-1 plans

Rows exist. Hourly **content** is the post-vote midnight rewrite, not the original day-1 appointments. Hobbs covering 10:00–11:00: **0/14**. Hobbs covering 19:00–20:00: **0/14**. See Clarification §3.

---

## Query 8 — when the run finishes

**At ~2284:** not on disk (max_step 1819).

**After PID gone — top item first:** `[SOCIAL_SEEK:REDIRECT]` / `[SOCIAL_SEEK:ARM]` totals + lines in **1685–1745**, **785–845**, **2225–2285**; then ±3-step cross-ref to the 12 leave-writes. Then TELEPORT / persist / overlay / `GATHER LOCK` / Query 3 prompt / Query 6 phase. All **`deferred: PID`**.

---

## Gaps

- Live `persona.scratch.survival` is **not** in Supabase `persona_scratch`. Query 3 uses the **day-1 midnight snapshot**, not step 1445.
- Query 3 / 6 log lines and hourly `CALENDAR DEADLINE RULE` prompt dump: **`deferred: PID`**.
- Query 4 `seek`: **`deferred: PID`**. `chat` empty. `block_boundary` did not fire on these 12 writes.
- Query 6.2 memories 1000–1500 with `day`: **empty**.
- Season `current_day` history: **empty**.
- Query 8 occupancy / H2 / H3 / present-only / seek log: **not on disk**.
- Write-step `social_seek_target` / `social_seek_until_step`: **empty** on captured coord rows.
- Day-1 snapshot hourly is the midnight rewrite; original 10:00 / 19:00 appointments: **empty**.
- Nick/Vince hourly 19:00 text is a **morning-routine** line in the evening; left as a row, not interpreted.
- Decomp evening rows lack `mode=in_place` even when they are sit-at-Hobbs text; travel test used walking-verb regex only.
- Collector `shape` for Dean/Mike said `19:00-20:00`; the block duration is **19:00–21:00**.
- Decomp `resolved_address` / `inherits_parent_location`: **empty** on persisted `[label, minutes]` rows.

---

## Decomposition in the covered hour (day 2, 10:00–11:00)

Live scratch. `resolved_address` and `inherits_parent_location` are **empty** on every stored row. Anchor/mode from the tag. Parent = hourly block containing the sub-task start.

**Leavers — first non-Hobbs-cafe anchor** (stand-in; resolved address empty):

| Person | First non-Hobbs-anchor sub-task | Starts |
|---|---|---|
| Shepard | `asleep` (parent not Hobbs) | 10:00 |
| Dean | walking to Hobbs · **blackboard** | 10:00 |
| Owen | walking from Johnson Park · **park garden** | 10:10 |
| Reed, Andrew, Vince, Vincent | **none** — all cafe seating / cafe | — |

Owen also sits on **bar customer seating** 10:15–10:45 (pub object). Reed/Andrew/Vince/Vincent left in Query 4 while this hour’s decomp stayed cafe.

**Stayers:** Irene / Ivan / Max / Nick / Olivia — Hobbs-cafe anchors only (seating, counter, cooking area, piano). **Mike** 10:00–10:05 walk · **common room table** (home object); still on cafe at 11:00.

Full per-row tables: `20260829_datareq_2_finalize-fix.md` §Decomposition.
