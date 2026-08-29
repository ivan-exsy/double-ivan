# Data request 4 — arena `activity_whitelist`: keep, widen, or retire

**To:** agent [1] · **Mode:** read-only measurement · **Sim:** `20260828-1` (still running — do not touch the runner)
**Date:** 2026-08-29

---

## Why this exists

We closed the gathering bug. Chain, confirmed:

1. Hourly block names the venue in full (`at Hobbs Cafe reviewing challenge notes`) → sector pin fires → parent seals `the Ville:Hobbs Cafe:cafe`.
2. Sub-task `Reviewing challenge notes` inherits it with anchor `cafe customer seating`. Row is honestly tagged `parent_location_inherit_v1`.
3. Post-validate runs on that inherited address with `activity_type=study`. The cafe's whitelist is `["eat","social","serve","relax"]` — no `study` — so it **cascades**.
4. The cascade's first tier searches for the nearest arena whose whitelist *does* contain `study`. `the Ville:Oak Hill College:classroom` is `["study","social"]`. Body walks to campus.
5. Emit rewrites the act into `walking to Oak Hill College`.

Both people who stayed are explained by the same function: **Dean** is `relax`, which the cafe allows, so the check never fires; **Olivia** is `study` but works at Hobbs Cafe, and workers bypass the check.

Adding `study` to the cafe unblocks this instance. It does not stop the next one. This request is to size the global decision.

## The decision this feeds

The whitelist does **two different jobs**. Keep them separate in everything you report.

| Job | Where | What it does |
|---|---|---|
| **Veto** | `_validate_address_post_resolution` branch 2 | Rejects an already-chosen address and relocates the body |
| **Search** | `_remap_for_forbidden_address` Tier 2, `_pick_nearest_accessible_arena`, `_deterministic_guard_v2` | Given an activity, find arenas that allow it |

The veto caused this bug. The search may be load-bearing. Three candidate directions:

- **A — Delete whitelists.** Kills both jobs.
- **B — Widen every whitelist toward "most activities allowed."** Neuters the veto, but also flattens the search index — "nearest arena allowing X" degrades to "nearest arena."
- **C — Retire the veto, keep the search.** Whitelist becomes a ranking signal, not a relocation trigger.

We need numbers to pick. **Do not recommend one** — just measure.

## Rules

- **Read-only.** Do not touch the runner, do not restart, do not set flags on the live process.
- Reading a log file a process is writing to is safe. Opening files is fine.
- **Quote strings verbatim**, inside backticks. Do not shorten, clean up, or make paths readable. Three hypotheses in this investigation died on a summarised string.
- **Empty means empty.** Say `empty` or `absent`, do not infer.
- Anything needing live stdout → mark `deferred: PID` and move on.
- No fix proposals. Observations are welcome; designs are not.

---

## Q1 — Registry census (available now, no sim)

From `maze_registry.json`:

1. Total arena count.
2. How many arenas have an `activity_whitelist` key, and how many do not (absent or `null`). Absent is a meaningful answer — it means no gate.
3. The complete set of distinct activity strings appearing anywhere in any whitelist, as a sorted list.
4. For each activity string in that set: how many arenas allow it.
5. Paste the full `(arena address, whitelist)` table. All of it, verbatim.

## Q2 — What the world actually does

Across every step of `20260828-1` on disk:

1. Distribution of `action_family` on stored contracts — every distinct value with a count.
2. Any `action_family` value that appears in the run but is **not** in the Q1 activity set. Those can never match any whitelist.

## Q3 — The funnel check

For the **five most common** `action_family` values from Q2, list every arena that allows it (from Q1).

Flag any family allowed by three arenas or fewer. A scarce family is a funnel: everyone doing it gets pulled to the same handful of places.

## Q4 — Sizing the harm

The veto's reason code may not be stored. Use this proxy across the whole run:

Rows where **both** hold:
- the resolution tag is `parent_location_inherit_v1` **or** `planner_contract_v1`, and
- the final address **sector** differs from the sector named verbatim in that persona's hourly block for that hour.

Report:
1. Total count, and as a share of all rows with a sector-naming hourly block.
2. The top 15 `(from sector:arena, to sector:arena, action_family)` triples by frequency, with counts.
3. Per day, and per hour-of-day, so we can see whether this concentrates around the 10:00 and 19:00 appointments or is uniform.

## Q5 — Sizing what we would lose

1. Distribution of `resolution_source` across every stored contract in the run: `llm_location_v1`, `parent_location_inherit_v1`, `planner_contract_v1`, anything else. Counts and shares.
2. From the runner log once the PID is gone: counts of `DETERMINISTIC GUARD v2`, `forbidden-cascade Tier-1`, `Tier-1b`, `Tier-2`, `Tier-3`, `Tier-4`, and `POST-VALIDATE keep named dest`. Mark `deferred: PID` if not yet readable.

---

## Output

Same shape as before — answers inline under a **Responses** heading in this file, tables mirrored in `20260829_leave_pack/README4.md`, raw rows in `data4.json`.

Q1, Q2 and Q3 need no runner access and are the ones that unblock the decision. Do those first and report them even if Q4 and Q5 are still in flight.

---

## Responses

Collected ~16:35 ET, 2026-08-29. Sim still running: max_step **2030**, clock **15:45** day 2. Runner not touched. Raw: `20260829_leave_pack/data4.json`. Tables also in `20260829_leave_pack/README4.md`. Counts moved by a few dozen rows while the sim wrote; Q2 `n=29325`, Q5 `n=29339`.

No recommendation. Veto and search kept separate.

---

### Q1 — Registry census

From `maze_registry.json`.

1. Total arenas: **63**
2. `activity_whitelist` key **present: 53**. Key **absent: 10**. Present-and-`null`: **0**. Present-and-`[]`: **0**.
3. Distinct activity strings, sorted:
`art` `cook` `eat` `exercise` `hygiene` `play` `relax` `serve` `shop` `sleep` `social` `storage` `study` `work`
4. Arenas allowing each:

| activity | n arenas |
|---|---|
| `art` | 1 |
| `cook` | 14 |
| `eat` | 12 |
| `exercise` | 6 |
| `hygiene` | 13 |
| `play` | 16 |
| `relax` | 31 |
| `serve` | 4 |
| `shop` | 2 |
| `sleep` | 18 |
| `social` | 20 |
| `storage` | 18 |
| `study` | 4 |
| `work` | 18 |

5. Full `(arena address, whitelist)` table. Key-absent rows are `null` here (no gate).

| address | whitelist |
|---|---|
| `the Ville:Apartment 1:bathroom` | `["hygiene"]` |
| `the Ville:Apartment 1:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:Apartment 2:bathroom` | `["hygiene"]` |
| `the Ville:Apartment 2:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:Apartment 3:bathroom` | `["hygiene"]` |
| `the Ville:Apartment 3:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:Apartment 4:bathroom` | `["hygiene"]` |
| `the Ville:Apartment 4:main room` | `["sleep", "work", "storage", "play", "relax", "cook", "study"]` |
| `the Ville:Apartment 5:bathroom` | `["hygiene"]` |
| `the Ville:Apartment 5:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:Dorm for Oak Hill College:Dorm Room 1` | `["sleep", "storage", "work", "play", "relax"]` |
| `the Ville:Dorm for Oak Hill College:Dorm Room 2` | `["sleep", "study", "storage", "work", "relax"]` |
| `the Ville:Dorm for Oak Hill College:Dorm Room 3` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:Dorm for Oak Hill College:Dorm Room 4` | `["sleep", "storage", "work", "play", "exercise", "relax"]` |
| `the Ville:Dorm for Oak Hill College:bathroom 1` | `["hygiene"]` |
| `the Ville:Dorm for Oak Hill College:bathroom 2` | `["hygiene"]` |
| `the Ville:Dorm for Oak Hill College:common room` | `["social", "relax", "eat", "play"]` |
| `the Ville:Dorm for Oak Hill College:garden` | `["relax", "exercise", "social"]` |
| `the Ville:Dorm for Oak Hill College:kitchen` | `["cook", "eat", "social"]` |
| `the Ville:Harvey Oak Supply Store:supply store` | `["shop", "serve"]` |
| `the Ville:Hobbs Cafe:cafe` | `["eat", "social", "serve", "relax"]` |
| `the Ville:House 1:bathroom` | `["hygiene"]` |
| `the Ville:House 1:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:House 2:bathroom` | `["hygiene"]` |
| `the Ville:House 2:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:House 3:bathroom` | `["hygiene"]` |
| `the Ville:House 3:main room` | `["sleep", "work", "storage", "play", "relax", "cook"]` |
| `the Ville:House 4:Room 1` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:House 4:Room 2` | absent (`null`) |
| `the Ville:House 4:bathroom` | `["hygiene"]` |
| `the Ville:House 4:common room` | `["social", "relax", "eat", "play"]` |
| `the Ville:House 4:garden` | `["relax", "exercise", "social"]` |
| `the Ville:House 4:kitchen` | `["cook", "eat", "social"]` |
| `the Ville:House 5:Main Bedroom` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:House 5:Second Bedroom` | absent (`null`) |
| `the Ville:House 5:bathroom` | `["hygiene"]` |
| `the Ville:House 5:common room` | `["social", "relax", "eat", "play"]` |
| `the Ville:House 5:garden` | `["relax", "exercise", "social"]` |
| `the Ville:House 5:kitchen` | `["cook", "eat", "social"]` |
| `the Ville:House 6:Main Bedroom` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:House 6:Second Bedroom` | absent (`null`) |
| `the Ville:House 6:bathroom` | `["hygiene"]` |
| `the Ville:House 6:common room` | `["social", "relax", "eat", "play"]` |
| `the Ville:House 6:garden` | `["relax", "exercise", "social"]` |
| `the Ville:House 6:kitchen` | `["cook", "eat", "social"]` |
| `the Ville:Johnson Park:park` | `["relax", "exercise", "social"]` |
| `the Ville:Oak Hill College:classroom` | `["study", "social"]` |
| `the Ville:Oak Hill College:hallway` | `["social"]` |
| `the Ville:Oak Hill College:library` | `["study", "relax", "social"]` |
| `the Ville:The Rose and Crown Pub:pub` | `["eat", "social", "serve", "relax", "play", "cook"]` |
| `the Ville:The Willows Market and Pharmacy:store` | `["shop", "serve"]` |
| `the Ville:artist's co-living space:Studio Bathroom 1` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Bathroom 2` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Bathroom 3` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Bathroom 4` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Bathroom 5` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Room 1` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:artist's co-living space:Studio Room 2` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Room 3` | `["sleep", "storage", "work", "relax"]` |
| `the Ville:artist's co-living space:Studio Room 4` | absent (`null`) |
| `the Ville:artist's co-living space:Studio Room 5` | `["sleep", "storage", "work", "art", "relax"]` |
| `the Ville:artist's co-living space:common room` | `["social", "relax", "eat", "play"]` |
| `the Ville:artist's co-living space:kitchen` | `["cook", "eat", "social"]` |

---

### Q2 — What the world actually does

Every stored coord row on disk (`n=29325`). `action_family` from `action_progress`. Empty string is empty.

| `action_family` | rows |
|---|---|
| empty | 8969 |
| `relax` | 6834 |
| `work` | 4806 |
| `study` | 2770 |
| `eat` | 2731 |
| `hygiene` | 1052 |
| `play` | 879 |
| `cook` | 696 |
| `social` | 579 |
| `exercise` | 9 |

Of the 8969 empty-family rows, **8273** are `planner_contract_v1`. The other **696** have empty `resolution_source`.

In the run but **not** in the Q1 set: empty only.

In the Q1 set but **not** in the run: `art` `serve` `shop` `sleep` `storage`.

---

### Q3 — Funnel check (top five families)

| family | arenas that allow it | ≤3? |
|---|---|---|
| empty | **0** | **flag** |
| `relax` | **31** | no |
| `work` | **18** | no |
| `study` | **4** | no (just above the bar) |
| `eat` | **12** | no |

`study` arenas, verbatim:
- `the Ville:Apartment 4:main room`
- `the Ville:Dorm for Oak Hill College:Dorm Room 2`
- `the Ville:Oak Hill College:classroom`
- `the Ville:Oak Hill College:library`

`relax` arenas (31):
`the Ville:Apartment 1:main room` · `the Ville:Apartment 2:main room` · `the Ville:Apartment 3:main room` · `the Ville:Apartment 4:main room` · `the Ville:Apartment 5:main room` · `the Ville:Dorm for Oak Hill College:Dorm Room 1` · `the Ville:Dorm for Oak Hill College:Dorm Room 2` · `the Ville:Dorm for Oak Hill College:Dorm Room 3` · `the Ville:Dorm for Oak Hill College:Dorm Room 4` · `the Ville:Dorm for Oak Hill College:common room` · `the Ville:Dorm for Oak Hill College:garden` · `the Ville:Hobbs Cafe:cafe` · `the Ville:House 1:main room` · `the Ville:House 2:main room` · `the Ville:House 3:main room` · `the Ville:House 4:Room 1` · `the Ville:House 4:common room` · `the Ville:House 4:garden` · `the Ville:House 5:Main Bedroom` · `the Ville:House 5:common room` · `the Ville:House 5:garden` · `the Ville:House 6:Main Bedroom` · `the Ville:House 6:common room` · `the Ville:House 6:garden` · `the Ville:Johnson Park:park` · `the Ville:Oak Hill College:library` · `the Ville:The Rose and Crown Pub:pub` · `the Ville:artist's co-living space:Studio Room 1` · `the Ville:artist's co-living space:Studio Room 3` · `the Ville:artist's co-living space:Studio Room 5` · `the Ville:artist's co-living space:common room`

`work` arenas (18):
`the Ville:Apartment 1:main room` · `the Ville:Apartment 2:main room` · `the Ville:Apartment 3:main room` · `the Ville:Apartment 4:main room` · `the Ville:Apartment 5:main room` · `the Ville:Dorm for Oak Hill College:Dorm Room 1` · `the Ville:Dorm for Oak Hill College:Dorm Room 2` · `the Ville:Dorm for Oak Hill College:Dorm Room 3` · `the Ville:Dorm for Oak Hill College:Dorm Room 4` · `the Ville:House 1:main room` · `the Ville:House 2:main room` · `the Ville:House 3:main room` · `the Ville:House 4:Room 1` · `the Ville:House 5:Main Bedroom` · `the Ville:House 6:Main Bedroom` · `the Ville:artist's co-living space:Studio Room 1` · `the Ville:artist's co-living space:Studio Room 3` · `the Ville:artist's co-living space:Studio Room 5`

`eat` arenas (12):
`the Ville:Dorm for Oak Hill College:common room` · `the Ville:Dorm for Oak Hill College:kitchen` · `the Ville:Hobbs Cafe:cafe` · `the Ville:House 4:common room` · `the Ville:House 4:kitchen` · `the Ville:House 5:common room` · `the Ville:House 5:kitchen` · `the Ville:House 6:common room` · `the Ville:House 6:kitchen` · `the Ville:The Rose and Crown Pub:pub` · `the Ville:artist's co-living space:common room` · `the Ville:artist's co-living space:kitchen`

Outside this top five, Q1 also has `art` = 1 and `shop` = 2 (≤3). Those families have **0** rows in this run.

---

### Q4 — Sizing the harm (proxy)

**Day 1 original hourly: empty.** Rollover snapshots store a six-block lump (`earlier today — survival preparations and the vote` for 1260 minutes, then leave / unwind / reflect / bed / sleep). Those texts name **no** registry sector. Day 1 is not scored.

**Day 2** uses live scratch hourlies. Clock through ~15:36 (vote 19:00 not on disk yet). Sector named = longest exact registry sector string inside the hourly text. `from` arena = empty (hourly does not name an arena string). Dest sector/arena = parts 2 and 3 of `resolved_address`.

Mismatch = `resolution_source` is `parent_location_inherit_v1` or `planner_contract_v1`, **and** dest sector ≠ named sector.

| | count |
|---|---|
| Day-2 rows | 13160 |
| Rows whose hourly names a sector | **5540** |
| Mismatch | **1414** |
| Share | **1414 / 5540** |
| Distinct `action_id`s in the 1414 | 90 |

This proxy also fires when the hourly names the wrong home (Olivia 07:00: hourly `Apartment 1`, dest `House 1`). It is not veto-only.

Top 15 `(from sector:arena, to sector:arena, action_family)` — `from` arena empty:

| n | from | to | family |
|---|---|---|---|
| 343 | `Hobbs Cafe:` | `Oak Hill College:classroom` | `study` |
| 105 | `Hobbs Cafe:` | `The Rose and Crown Pub:pub` | `play` |
| 102 | `Hobbs Cafe:` | `Apartment 4:main room` | `study` |
| 90 | `Hobbs Cafe:` | `The Rose and Crown Pub:pub` | `relax` |
| 76 | `Hobbs Cafe:` | `The Rose and Crown Pub:pub` | `eat` |
| 61 | `Hobbs Cafe:` | `Oak Hill College:library` | `study` |
| 58 | `Apartment 1:` | `Johnson Park:park` | empty |
| 50 | `Apartment 1:` | `House 1:bathroom` | `hygiene` |
| 47 | `Hobbs Cafe:` | `Apartment 5:main room` | `work` |
| 44 | `Hobbs Cafe:` | `Apartment 4:main room` | `work` |
| 35 | `Hobbs Cafe:` | `Dorm for Oak Hill College:Dorm Room 2` | `study` |
| 35 | `Hobbs Cafe:` | `The Willows Market and Pharmacy:store` | empty |
| 33 | `Hobbs Cafe:` | `Oak Hill College:library` | `relax` |
| 31 | `Hobbs Cafe:` | `Dorm for Oak Hill College:common room` | `eat` |
| 30 | `Hobbs Cafe:` | `Harvey Oak Supply Store:supply store` | `work` |

Per calendar day: day 1 **empty** (no sector-naming hourly). Day 2 = table above.

Per hour of day (day 2 only):

| hour | sector-naming rows | mismatch |
|---|---|---|
| 0–6 | 0 | 0 |
| 7 | 60 | 60 |
| 8 | 240 | 1 |
| 9 | 540 | 71 |
| **10** | **780** | **310** |
| 11 | 840 | 258 |
| 12 | 840 | 242 |
| 13 | 840 | 244 |
| 14 | 840 | 142 |
| 15 | 574 | 88 (partial hour on disk) |
| 16–23 | empty on disk | empty |

Hour 7’s 60/60 is Olivia: hourly `finishing breakfast and getting ready at Apartment 1`, dest `House 1`. Hour 10 is the thickest slice.

---

### Q5 — Sizing what we would lose

1. `resolution_source` on every stored row (`n=29339`):

| source | rows | share |
|---|---|---|
| `parent_location_inherit_v1` | 15882 | 15882/29339 |
| `planner_contract_v1` | 8273 | 8273/29339 |
| `llm_location_v1` | 4488 | 4488/29339 |
| empty | 696 | 696/29339 |

2. Runner log counts (`DETERMINISTIC GUARD v2`, `forbidden-cascade Tier-1`, `Tier-1b`, `Tier-2`, `Tier-3`, `Tier-4`, `POST-VALIDATE keep named dest`): **deferred: PID**.

---

## Gaps

- Day 1 original hourly: **empty**.
- Q5.2 log counts: **deferred: PID**.
- Day-2 vote hour (19:00): **empty** on disk (sim at 15:45).
