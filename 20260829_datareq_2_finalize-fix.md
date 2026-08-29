# Data request 2 — finalize the schedule-shape fix (`20260828-1`)

**Follow-up to** `20260829_datareq_leave-after-arrival.md`. Same rules: collect and report, **no fix proposals**, no code edits, no touching the runner.

**Sim:** `20260828-1` · `simulation_id` **`49f3ddd9-6cad-473a-9c96-97c82a7643ea`** · tip `acf744b8` · PID `663491`

**Hard constraints**

- **Read-only.** Supabase and existing packets. No `journalctl` / SSH-poke while the PID is alive.
- Runner finishes on its own at `max_steps` **2400** (~7:45 PM ET tonight). Anything needing logs waits for the PID to be gone — mark it **`deferred: PID`** rather than skipping it.
- Empty result → report **“empty”**. Do not substitute a nearby window.
- Same three collector traps as last time: `dest` is a **coordinate box** (never name-test it), `loc` is **where the body is**, read destination from `act_address` / `intent`.

**Clock:** step 0 ≈ **Aug 29 05:55**. Step 1801 = Aug 30 11:57 (verified from the status endpoint). There is a **±1 step ambiguity** in where step 0 sits, so for any fire, sample a **5-step window** (fire−2 … fire+2), not one exact step.

| Fire | Step |
|---|---|
| Survival day 1 challenge 11:00 | ~304–305 |
| Survival day 1 vote 20:00 | ~844–845 |
| Survival day 2 challenge 11:00 | ~1744–1745 |
| **Survival day 2 vote 20:00** | **~2284–2285** (lands tonight) |

---

## What we already concluded, and what would break it

From pack 1: the day-2 **challenge** block is scheduled `11:00–12:00` — starting *at* the fire — with no travel sub-task, while the prompt asks for presence during `10:00–11:00`.

That rests on **one appointment on one day**. Everything below either widens it to a second instance or decides which of two very different fixes is correct. **Query 3 is the one that picks the fix — do it even if you run out of time on the others.**

---

## Query 1 — the day-2 **vote** block (already on disk, do first)

Written at day-2 rollover (~step 1445), so no waiting.

For all 14: from `f_daily_schedule_hourly_org` and `f_daily_schedule`, report the **evening** blocks — every block from 18:00 to 21:00.

Answer plainly:

- Is the Hobbs vote block `19:00–20:00` (before the fire) or `20:00–21:00` (starting at it)?
- Does the decomposition around 20:00 contain a **travel** sub-task, or is it `in_place` seating like the 11:00 one?

**Prediction on file:** `20:00–21:00`, in-place, no travel. If it comes back `19:00–20:00`, say so loudly — it means the morning and evening invitations behave differently and the diagnosis needs rework.

---

## Query 2 — what owns the pre-event hour

For all 14, day 2, dump the hourly blocks at **09:00, 10:00, 11:00** and at **18:00, 19:00, 20:00** — activity text plus resolved address.

Report as two tables (morning, evening) with a count: **how many of the 14 have a non-Hobbs block covering 10:00–11:00, and covering 19:00–20:00?** Name what those blocks are (work / sleep / library / etc.).

We know Shepard had a scheduled `asleep` at 10:00–11:00. We need to know whether that is one persona's quirk or the pattern.

---

## Query 3 — was the instruction present and ignored, or absent? **(decisive)**

Two fixes hang on this. If the calendar rule reached the prompt and the planner ignored it, a wording change is not reliable and the fix has to be deterministic. If the rule never reached the prompt, it is a code-path bug and much smaller.

**Do this without logs.** The prompt text is generated deterministically from three snapshotted values. For all 14 at day-2 rollover, dump from `persona.scratch.survival`:

- `challenge_deadline_hour`
- `vote_deadline_hour`
- `gathering_arena`

and separately report whether the **post-vote marker** was active at day-2 rollover (`post_vote` / post-vote recovery state). That matters because the daily-plan prompt **drops the challenge line entirely** when post-vote is active.

Expected: `11`, `20`, Hobbs, post-vote **not** active. Any deviation is the answer on its own.

**If and only if the PID is gone:** pull the raw `run_gpt_prompt_daily_plan` prompt for two personas (one who sat at 11:00, one who did not) and quote the `CALENDAR DEADLINE RULE` block verbatim. Mark **`deferred: PID`** until then.

---

## Query 4 — what writes the departure action

Pack 1 found all 12 leavers were **`replaced`**, not expiry, but the 4-step window started after the write. Widen it.

For the same 12 (day 1: Butcher, Reed, Diana, Ivan, Nick · day 2: Shepard, Reed, Andrew, Dean, Owen, Vince, Vincent):

Walk **backwards** from the last cafe tile to the step where `act_address` first became the away-destination. That step is the write. For it, report:

`step · clock · act_address · act_description · act_start_time · act_duration · target_zone · chatting_with`

Then tag each write with **all** that apply:

| Tag | Test |
|---|---|
| `block_boundary` | The step falls on an hourly-block transition in that persona's schedule |
| `seek` | A `SOCIAL_SEEK` line names that persona within ±3 steps |
| `chat` | `chatting_with` non-empty at or just before the write |
| `unknown` | None of the above |

Give the tag counts across the 12. This separates “the plan told them to leave” from “something interrupted them,” and we currently cannot tell which.

**Specifically check the 10:15–10:30 band on day 2** — the room went 10 → 4 there, and the seek pause does not start until 10:30. How many of the day-2 writes land inside it?

---

## Query 5 — walk-time budget

For the 8 personas off-cafe at the day-2 challenge fire: their `curr_tile` at **10:55** and the Manhattan tile distance to the nearest cafe tile (box x 72–83, y 19–30). Report per persona plus the median.

At `MAX_TILES_PER_STEP` 6 this converts to a minimum walk in minutes. The question: **could a block starting at 11:00 ever put them in a seat at 11:00?**

---

## Query 6 — the stuck day number (small, separate bug)

`currently` reads “On day 1” on Survival day 2 while headcount correctly reads 14. Both are written from adjacent lines of the same loop, so the day *source* is suspected stale.

Report:

1. `survival_season_state.current_day` in Supabase — current value, and its value history if the table keeps one.
2. Any structured survival event carrying a `day` field logged between steps **1000 and 1500** — we want to see whether `day` flips 1 → 2 around step **1085** (midnight).
3. `persona.scratch.survival["current_day"]` for any 3 personas, right now.
4. **`deferred: PID`** — the `[SURVIVAL:PHASE] … NIGHT -> SLEEP` line and the `=== … Day N … ===` line near step 1085.

If (1) and (3) both say **1**, the counter never advanced. If they say **2**, the counter advanced and the planner read it too early. Either answer closes it.

---

## Query 7 — day-1 recovery attempt (best effort)

Pack 1 reported day-1 `f_daily_schedule` is gone for the 14 survivors (scratch overwritten at rollover), leaving only Butcher's.

Check whether day-1 plans survive anywhere else: a planning-cache table, a daily-plan record keyed by date, or a persisted scratch snapshot from before step 1440. If nothing exists, answer **“day-1 plans are unrecoverable”** — that is a useful finding and tells us to snapshot plans per day going forward.

---

## Query 8 — when the run finishes

Two batches. Do not wait idle for these; file them when they land.

**At step ~2284 (tonight):**
- Day-2 vote occupancy, sampled across **2282–2287**, with the curve at 19:00 / 19:15 / 19:30 / 20:00 / 20:15
- H2 / H3 split, classified from 05:55
- Present-only check: ballots vs tiles

**After the PID is gone (confirm first):**
- TELEPORT journal, full run
- Full-run persist `start_pos`→tile >6 count at 2400
- Overlay LLM played / absent / last-elim injection counts
- `GATHER LOCK` line count across the whole run (expected 0 — never re-read on a live PID)
- The two `deferred: PID` items from Queries 3 and 6

---

## Deliverable

Append to `double-ivan/20260829_leave_pack/` as `data2.json` + `README2.md`. Same rules: one short table per query, a **Gaps** section for anything empty or unreachable, and **no conclusions** — observations with supporting rows only.

---

# Responses (read-only, max_step **1819** on disk, 2026-08-29 ~13:24 ET)

Cafe box x 72–83, y 19–30. `target_zone` is a coordinate box — not name-tested. Destination from `act_address` / intent. Body from `curr_tile`. Raw: `20260829_leave_pack/data2.json`.

---

## Query 1 — day-2 vote block

Hourly + decomp from live scratch (`last_planned_date=2026-08-30`), 14 remaining.

**Is the Hobbs vote `19:00–20:00` or `20:00–21:00`?** Mixed, not one shape.

- **12/14** have a Hobbs block that **starts at 20:00** (20:00–21:00), usually “taking part in the evening vote.” Most of those also have a **separate** Hobbs block at 19:00–20:00 (“settling in” / “arriving” / “before the vote”).
- **Dean, Mike:** one Hobbs block **19:00–21:00** (starts an hour before the fire, spans it).
- **Nick, Vince:** 19:00–20:00 is **not Hobbs** — text is `waking up and starting morning routine at home`. Their Hobbs vote block is **20:00–21:00**.

**Decomp around 20:00:** same text as the hourly 20:00 block. **0/14** travel verbs (`walking` / `heading to` / …). **0/14** tagged `mode=in_place` (those tags appear on morning decomp, not on these evening rows). No walk-to-Hobbs sub-task at 20:00.

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

Live `persona_scratch` has **no `survival` column**. Closest snapshotted `scratch.survival` is `persona_day_snapshots` **day 1**, steps **0–1084** (14 survivors; written at wall 11:00 UTC). That is **end of survival day 1 / midnight**, not step 1445.

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

**`CALENDAR DEADLINE RULE` verbatim from `run_gpt_prompt_daily_plan`: `deferred: PID`.** (That string lives on the **hourly** calendar block in code, not on the daily-plan prompt’s “arrive about an hour earlier” lines.)

---

## Query 4 — what writes the departure

Walked back from last cafe tile until `act_address` first equals the away destination. `chatting_with` empty on all 12 writes. **`seek`: `deferred: PID`** (no log). None of the 12 writes fall on an hourly-block `:00` start in the schedule we have. Tag: **`unknown` 12 / 12**.

| Person | Day | Write clock | `act_address` | `act_description` | start / dur |
|---|---|---|---|---|---|
| Butcher | 1 | 10:35 | Oak Hill classroom seating | walking to Oak Hill College | 10:35 / 25 |
| Reed | 1 | 10:42 | Rose and Crown bar seating | listening to challenge rules | 10:42 / 10 |
| Diana | 1 | 10:02 | Oak Hill classroom seating | spread challenge notes on table | 10:02 / 5 |
| Ivan | 1 | 10:35 | Dorm Room 2 blackboard | walking to Dorm | 10:35 / 25 |
| Nick | 1 | 10:55 | House 4 common room table | at House 4 | 10:55 / 10 |
| Shepard | 2 | 08:34 | Oak Hill library table | walk to Oak Hill College | 08:34 / 6 |
| Reed | 2 | **10:15** | Oak Hill classroom blackboard | reading challenge rules | 10:15 / 10 |
| Andrew | 2 | **10:21** | Oak Hill classroom seating | spreading challenge notes | 10:21 / 5 |
| Dean | 2 | 10:32 | Harvey Oak supply counter | walking to supply store | 10:32 / 28 |
| Owen | 2 | 10:33 | Oak Hill classroom blackboard | walking to Oak Hill College | 10:33 / 7 |
| Vince | 2 | **10:20** | Oak Hill classroom seating | walking to Oak Hill College | 10:20 / 15 |
| Vincent | 2 | **10:16** | Apartment 4 blackboard | walking to Apartment 4 | 10:16 / 12 |

**Day-2 writes inside 10:15–10:30 (steps 1700–1715): 4/7** — Reed, Andrew, Vince, Vincent. Dean 10:32 and Owen 10:33 sit just after 10:30. Shepard 08:34 is earlier.

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
2. Structured survival events with a `day` field, steps 1000–1500: **empty** in `dbl_memory` (no `meta.step` in that band with a `day` field). Snapshot `day_end_step` **1084** is the midnight cut. Season `eliminated[].day` = **1** (Butcher).
3. `scratch.survival["current_day"]` live column: **empty** (not stored on `persona_scratch`). From the day-1 snapshot (any 3, actually all 14): **`current_day` = 1**.
4. `[SURVIVAL:PHASE] NIGHT -> SLEEP` and `=== Day N ===` near step 1085: **`deferred: PID`**.

Season counter is **2** now. Snapshotted planner `current_day` at midnight was still **1**. `currently` is restamped from `scratch.survival["current_day"]` (not from the season row directly).

---

## Query 7 — day-1 plans

**Not unrecoverable.** `double.persona_day_snapshots` has **14 rows**, `day=1`, steps **0–1084**, including `f_daily_schedule` and `f_daily_schedule_hourly_org` inside `scratch_json`. **Butcher is not in that table** (eliminated); his day-1 schedule is still on **live** scratch (`last_planned_date=2026-08-29`). Full dumps: `data2.json` → `query_7`.

**Coverage pull (2026-08-29 13:46 ET):** the snapshot fields exist, but the hourly content is the **post-vote midnight rewrite**, not the original day-1 appointments. All 14: one block `00:00–21:00` = `earlier today — survival preparations and the vote` (no Hobbs token; hourly rows are `[text, minutes]` with **no address field**). Hobbs-covering **10:00–11:00: 0/14**. Hobbs-covering **19:00–20:00: 0/14**. Original day-1 10:00 / 19:00 hourly: **empty** in this table.

---

## Query 8 — when the run finishes

**At ~2284:** not on disk (max_step 1819).  
**After PID gone — top item first:**

1. `[SOCIAL_SEEK:REDIRECT]` and `[SOCIAL_SEEK:ARM]`: total count, plus every line in steps **1685–1745**, **785–845**, or **2225–2285** (persona + step). Cross-reference: for each of the 12 Query-4 leave-write steps, is there a REDIRECT for that persona within ±3 steps?
2. Then: TELEPORT / persist / overlay / `GATHER LOCK` / Query 3 prompt quote / Query 6 phase lines.

All of the above: **`deferred: PID`**.

---

## Gaps

- Live `persona.scratch.survival` is **not** in Supabase `persona_scratch`. Query 3 uses the **day-1 midnight snapshot**, not step 1445.
- Query 3 / 6 log lines and hourly `CALENDAR DEADLINE RULE` prompt dump: **`deferred: PID`**.
- Query 4 `seek`: **`deferred: PID`**. `chat` empty. `block_boundary` did not fire on these 12 writes.
- Write-step `social_seek_target` / `social_seek_until_step`: **empty** on the captured coord rows (those fields were not stored there).
- Query 6.2 memories 1000–1500 with `day`: **empty**.
- Season `current_day` history: **empty**.
- Query 8 occupancy/H2/H3/present-only + seek log: **not on disk**.
- Nick/Vince hourly 19:00 text is a **morning-routine** line in the evening; left as a row, not interpreted.
- Decomp evening rows lack `mode=in_place` even when they are sit-at-Hobbs text; travel test used walking-verb regex only.
- Day-1 snapshot hourly is the midnight rewrite; original 10:00 / 19:00 appointments: **empty**.

---

# Clarification (2026-08-29 13:46 ET) — items 1–3

Re-read of pack 2 + snapshot pull. No new live collection. No runner touch.

---

## 1. Evening block — not inverted

Query 1 and Query 2 used **different tests**. Both totals are 12/14. They are **not the same 12 people**.

| Test | Yes | No |
|---|---|---|
| Query 1: does a Hobbs block **start at 20:00**? | 12 (includes Nick, Vince; excludes Dean, Mike) | Dean, Mike (their Hobbs block starts at **19:00** and runs to 21:00) |
| Query 2: does a Hobbs hourly **cover 19:00–20:00**? | 12 (includes Dean, Mike; excludes Nick, Vince) | Nick, Vince (`waking up and starting morning routine at home`) |

**Which earlier answer was wrong?** Neither count. Query 1’s lead (“12/14 start at 20:00; Dean and Mike have Hobbs from 19:00”) is easy to read as “only those two have Hobbs at 19:00.” That was a **framing slip**, not a different field. The Query 1 table already showed Hobbs at 19:00 for twelve people. Query 2 is the correct total for “is 19:00 covered by Hobbs?”

Hourly rows in the pack have **no separate address field**. `is_hobbs` is the word “Hobbs” in the block text.

| Persona | Hobbs covers 19:00–20:00 | Text at 19:00 | Text at 20:00 |
|---|---|---|---|
| Shepard | yes | at Hobbs Cafe settling in before the evening vote | finishing dinner at Hobbs Cafe after the vote |
| Reed | yes | arriving at Hobbs Cafe for the evening vote | at at Hobbs Cafe taking part in the evening vote |
| Andrew | yes | at Hobbs Cafe for the evening vote | at Hobbs Cafe taking part in the evening vote |
| Dean | yes | at Hobbs Cafe for the evening vote (block 19:00–21:00) | (same block) |
| Diana | yes | at Hobbs Cafe early for the evening vote | taking part in the evening vote at Hobbs Cafe |
| Irene | yes | at Hobbs Cafe settling in before the evening vote | having dinner at Hobbs Cafe after the vote |
| Ivan | yes | having dinner at Hobbs Cafe before the vote | at Hobbs Cafe taking part in the evening vote |
| Max | yes | at Hobbs Cafe reviewing notes before the vote | at Hobbs Cafe taking part in the evening vote |
| Mike | yes | at Hobbs Cafe for the evening vote (block 19:00–21:00) | (same block) |
| Nick | **no** | waking up and starting morning routine at home | at Hobbs Cafe taking part in the evening vote |
| Olivia | yes | at Hobbs Cafe reviewing notes before the vote | at Hobbs Cafe for the evening vote |
| Owen | yes | at Hobbs Cafe for the evening vote | at Hobbs Cafe taking part in the evening vote |
| Vince | **no** | waking up and starting morning routine at home | at Hobbs Cafe participating in the evening vote |
| Vincent | yes | arriving at Hobbs Cafe for the vote | at Hobbs Cafe for the evening vote |

**Total Hobbs covering 19:00–20:00: 12/14.**

---

## 2. Raw `act_address` at the leave-write

Those Query 4 destinations were **short labels of the raw stored strings**, not a different field. Raw, unmodified `act_address` from the write-step coord rows:

| Person | Day | Step | Raw `act_address` | Starts with `<persona>` |
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

**Does any of the 12 begin with the literal token `<persona>`? No. 0/12.**

`social_seek_target` and `social_seek_until_step` at those write steps: **empty** — not present on the captured coord rows. (Midnight day-1 snapshots have both fields, and both are null there; that is midnight, not the write step.)

---

## 3. Day-1 hourly coverage from the snapshot table

14 survivors, `day=1`, `curr_time=2026-08-29T23:59:00`. Hourly org is `[text, minutes]`. All 14 share the same six blocks. The block that covers both 10:00 and 19:00 is `earlier today — survival preparations and the vote` (1260 minutes). No Hobbs token. No address field.

| Window | Hourly block with a Hobbs address |
|---|---|
| 10:00–11:00 | **0/14** |
| 19:00–20:00 | **0/14** |

The original day-1 10:00 / 19:00 appointments are **empty** in this snapshot. Pack 2 “recoverable” meant the rows exist; it did not mean those appointments are still in them.

---

# Decomposition in the covered hour (day 2, 10:00–11:00)

Live scratch `2026-08-30`. Stored decomp is `[label, minutes]`. **`resolved_address` and `inherits_parent_location` are empty** on every row (the contract is dropped when the schedule is saved). Anchor/mode come from the `[mode=… anchor=…]` tag. Parent = the hourly block that contains the sub-task start.

Hobbs cafe objects (for the anchor test below): cafe customer seating, behind the cafe counter, cafe, piano, cooking area, kitchen sink, refrigerator.

---

## Leavers (7)

### Shepard — parent `10:00–11:00 asleep`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–11:00 | 60 | asleep | empty | empty | empty | asleep |

### Reed — parent `10:00–11:00 at Hobbs Cafe reviewing challenge notes`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | ordering a coffee and settling in | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:05–10:25 | 20 | reading through the challenge rules | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:25–10:40 | 15 | highlighting important details | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:40–11:00 | 20 | mentally rehearsing possible scenarios | cafe customer seating | empty | empty | Hobbs reviewing notes |

### Andrew — parent `10:00–11:00 arriving at Hobbs Cafe and reviewing challenge notes`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | walking to Hobbs Cafe | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:05–10:10 | 5 | walking to Hobbs Cafe | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:10–10:15 | 5 | ordering a coffee at the counter | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:15–10:21 | 6 | walking to Hobbs Cafe | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:21–10:26 | 5 | spreading out challenge notes on the table | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:26–11:00 | 34 | studying the Silent Pact rules and considering partner options | cafe customer seating | empty | empty | arriving Hobbs / notes |

### Dean — parent `10:00–11:00 arriving at Hobbs Cafe early for the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:10 | 10 | walking to Hobbs Cafe | **blackboard** | empty | empty | arriving Hobbs early |
| 10:10–10:25 | 15 | settling in at cafe customer seating | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:25–10:32 | 7 | walking to Hobbs Cafe | cafe | empty | empty | arriving Hobbs early |
| 10:32–11:00 | 28 | reviewing challenge rules at cafe seating | cafe customer seating | empty | empty | arriving Hobbs early |

### Owen — parent `10:00–11:00 arriving at Hobbs Cafe and reviewing notes before the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:10 | 10 | walking to Hobbs Cafe | cafe | empty | empty | arriving Hobbs / notes |
| 10:10–10:15 | 5 | walking from Johnson Park to Hobbs Cafe | **park garden** | empty | empty | arriving Hobbs / notes |
| 10:15–10:20 | 5 | finding a quiet corner table | **bar customer seating** | empty | empty | arriving Hobbs / notes |
| 10:20–10:25 | 5 | ordering a hot drink | **bar customer seating** | empty | empty | arriving Hobbs / notes |
| 10:25–10:40 | 15 | reviewing the Silent Pact challenge rules | **bar customer seating** | empty | empty | arriving Hobbs / notes |
| 10:40–10:45 | 5 | highlighting key points in notes | **bar customer seating** | empty | empty | arriving Hobbs / notes |
| 10:45–11:00 | 15 | ordering a coffee and jotting down key points | cafe customer seating | empty | empty | arriving Hobbs / notes |

### Vince — parent `10:00–11:00 arriving at Hobbs Cafe early for the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:10 | 10 | walking to Hobbs Cafe | cafe | empty | empty | arriving Hobbs early |
| 10:10–10:15 | 5 | ordering a coffee at the counter | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:15–10:20 | 5 | ordering a coffee and settling in at a table | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:20–10:35 | 15 | Reviewing challenge notes | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:35–10:45 | 10 | Analyzing partner dilemma scenarios | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:45–10:50 | 5 | Making strategy notes | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:50–11:00 | 10 | mentally rehearsing possible responses and outcomes | cafe customer seating | empty | empty | arriving Hobbs early |

### Vincent — parent `10:00–11:00 at Hobbs Cafe reviewing notes before the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:10 | 10 | Ordering a coffee and settling in | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:10–10:16 | 6 | Walking to Hobbs Cafe | cafe | empty | empty | Hobbs reviewing notes |
| 10:16–10:28 | 12 | Reviewing challenge notes | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:28–10:40 | 12 | Outlining partner strategy | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:40–11:00 | 20 | Highlighting key points and mental rehearsal | cafe customer seating | empty | empty | Hobbs reviewing notes |

---

## Stayers (6) — on a cafe tile at 11:00

### Irene — parent `10:00–11:00 arriving at Hobbs Cafe early to prepare`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:15 | 15 | wiping down the counter and organizing supplies | behind the cafe counter | empty | empty | arriving Hobbs early |
| 10:15–10:25 | 10 | brewing a fresh pot of coffee | cooking area | empty | empty | arriving Hobbs early |
| 10:25–10:45 | 20 | cleaning the espresso machine | cooking area | empty | empty | arriving Hobbs early |
| 10:45–11:00 | 15 | checking inventory and restocking cups | behind the cafe counter | empty | empty | arriving Hobbs early |

### Ivan — parent `10:00–11:00 at Hobbs Cafe reviewing notes before the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:10 | 10 | settling in with a coffee at a table | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:10–10:15 | 5 | walking to Hobbs Cafe | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:15–10:20 | 5 | walking to Hobbs Cafe | cafe | empty | empty | Hobbs reviewing notes |
| 10:20–10:35 | 15 | reading through challenge notes | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:35–10:45 | 10 | highlighting key points in notes | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:45–10:50 | 5 | mentally rehearsing partner dilemma scenarios | cafe customer seating | empty | empty | Hobbs reviewing notes |
| 10:50–11:00 | 10 | taking a mental break and stretching | cafe customer seating | empty | empty | Hobbs reviewing notes |

### Max — parent `10:00–11:00 arriving at Hobbs Cafe and reviewing notes`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | ordering a coffee at the counter | behind the cafe counter | empty | empty | arriving Hobbs / notes |
| 10:05–10:20 | 15 | Organizing game notes by round | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:20–10:40 | 20 | Reviewing key player observations and challenge details | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:40–10:50 | 10 | Jotting down strategy ideas for today's challenge | cafe customer seating | empty | empty | arriving Hobbs / notes |
| 10:50–11:00 | 10 | organizing notes and preparing for the challenge | cafe customer seating | empty | empty | arriving Hobbs / notes |

### Mike — parent `10:00–11:00 arriving at Hobbs Cafe early for the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | walking from home to Hobbs Cafe | **common room table** | empty | empty | arriving Hobbs early |
| 10:05–10:10 | 5 | ordering a coffee at the counter | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:10–10:30 | 20 | reviewing challenge notes at a table | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:30–10:40 | 10 | sipping coffee while reviewing notes | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:40–10:50 | 10 | stretching arms and legs to stay loose | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:50–11:00 | 10 | watching the cafe entrance for other contestants | cafe customer seating | empty | empty | arriving Hobbs early |

### Nick — parent `10:00–11:00 Arriving at Hobbs Cafe early for the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | Ordering a coffee at the counter | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:05–10:25 | 20 | Reviewing challenge notes at a table | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:25–10:35 | 10 | Playing a short tune on the piano | piano | empty | empty | arriving Hobbs early |
| 10:35–11:00 | 25 | Sitting and observing the cafe | cafe customer seating | empty | empty | arriving Hobbs early |

### Olivia — parent `10:00–11:00 arriving at Hobbs Cafe early for the challenge`

| Clock | Dur | Label | Anchor | Inherit | Resolved | Parent |
|---|---|---|---|---|---|---|
| 10:00–10:05 | 5 | ordering a coffee and a pastry at the counter | behind the cafe counter | empty | empty | arriving Hobbs early |
| 10:05–10:20 | 15 | sitting down to have breakfast at a table | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:20–10:40 | 20 | reviewing challenge strategy notes | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:40–10:50 | 10 | meditating to calm nerves | cafe customer seating | empty | empty | arriving Hobbs early |
| 10:50–11:00 | 10 | waiting for the challenge to begin | cafe customer seating | empty | empty | arriving Hobbs early |

---

## Two answers

**1. First planned sub-task whose anchor is not a Hobbs-cafe object** (`resolved_address` is empty on all rows, so this is the stored stand-in):

| Leaver | First non-Hobbs-anchor sub-task | Starts |
|---|---|---|
| Shepard | `asleep` (parent is not Hobbs) | **10:00** |
| Dean | walking to Hobbs Cafe · anchor **blackboard** | **10:00** |
| Owen | walking from Johnson Park to Hobbs Cafe · anchor **park garden** | **10:10** |
| Reed | **none** in 10:00–11:00 — every sub-task is cafe customer seating | — |
| Andrew | **none** | — |
| Vince | **none** | — |
| Vincent | **none** | — |

Owen also has `bar customer seating` from **10:15–10:45** (that object lives on the pub, not the cafe). Reed / Andrew / Vince / Vincent still left (Query 4 writes at 10:15 / 10:21 / 10:20 / 10:16) while their decomp for those minutes stayed cafe seating.

**2. Stayers:** five of six have only Hobbs-cafe anchors (seating, counter, cooking area, piano). **Mike** has one off-site anchor: 10:00–10:05 `walking from home to Hobbs Cafe` · **common room table**. He was still on a cafe tile at 11:00. So yes — one stayer has a planned off-site anchor without leaving.

---

## Gaps (this query)

- `resolved_address` / `inherits_parent_location`: **empty** on persisted decomp.
- Body `act_address` at 10:00 is often the leftover previous action, not this slice — not used as the resolved address.
