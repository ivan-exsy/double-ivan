# Data request 5 — which activities to widen, which to leave narrow

**To:** agent [1] · **Mode:** read-only measurement · **Do not edit** `maze_registry.json` or any other file
**Date:** 2026-08-29
**Depends on:** `20260829_datareq_4_whitelist-strategy.md` (Q1–Q4 already in). Reuse those tables. Do not re-collect Q1.

---

## Why this exists

The gather veto is gone. An arena list no longer *relocates* a body that already had a place. The lists still do one job: **search**. When the system needs “the nearest room that allows activity X,” it only considers rooms whose whitelist contains `X`.

We are deciding a **search-quality** edit, not a gather fix. The founder’s intent: people should be able to **read** in ordinary rooms (cafe, pub, park, home, common room), not only in the four rooms that currently list `study`.

That is **not** the same as putting `study` on every arena. Putting it on bathrooms, stores, and hallways collapses “nearest room that allows reading” into “nearest room.” We need a proposed **include / leave-out** set for `study`, and the same question for every other activity.

**Do not implement. Do not recommend a product call.** Measure, then propose candidate sets with counts. We will decide.

---

## Decision (2026-08-29, after responses)

**Approve sit-only `study` (32 rooms). Reject 53.** Do it on a **later** run than 1-B occupancy — not in the same score.

Also approve, same later data pass: `eat` on the eight home living rooms; `work` on the six job sites; `relax` on the classroom; `play` on cafe / park / gardens; `art` on the other four studios.

**Do not:** put `study` on bathrooms, kitchens, hallway, or stores. Do not add a first whitelist to the ten ungated rooms (that would *narrow* them). Do not touch `sleep`, `shop`, `serve`. Do not pull `cook` off living rooms until a run shows it hurts.

**1-B will not fix every Hobbs leave.** Cafe already allows `relax` and `eat`, so pub `relax`/`eat` and dorm `eat` are something else. Dean→Harvey and Owen→Willows are job snaps. Shepard is still `asleep`. The veto *does* explain cafe→pub `play` and cafe→home `work` (cafe list has neither).

---

## Vocabulary (do not invent keys)

The registry key is `` `study` ``. There is no `` `reading` `` key.

In the resolver, “reading / reviewing notes / homework / researching / studying” all map to `` `study` ``. If you add a new string `` `reading` ``, nothing that already emits `` `study` `` will match it.

Quote every activity string inside backticks. Do not shorten arena paths.

---

## Rules

- **Read-only.** Do not touch the runner, do not edit the registry, do not restart anything.
- Reuse Q1 from data request 4. If the file on disk disagrees with that table, **stop and quote both** — do not silently pick one.
- Empty means `empty` or `absent`. Do not infer.
- Live stdout still `deferred: PID` if the process is writing.
- No designs. Candidate *sets* (lists of arena addresses) are measurement output, not a patch.

---

## Q1 — `study`: realistic sit-and-read vs literally every room

From the Q1 table in data request 4 (63 arenas).

**Already has `` `study` `` (4):**
- `the Ville:Apartment 4:main room`
- `the Ville:Dorm for Oak Hill College:Dorm Room 2`
- `the Ville:Oak Hill College:classroom`
- `the Ville:Oak Hill College:library`

Split **every other arena** into exactly one bucket. Use the arena address as the row key. Buckets:

| Bucket | Meaning |
|---|---|
| `sit` | A person could sit here with a book or notes without looking absurd (living rooms, bedrooms, studios, common rooms, gardens, park, cafe, pub, library, classroom, dorm rooms) |
| `pass` | A place you walk through or do something else (hallway, bathrooms, kitchens, stores, supply store) |
| `ungated` | whitelist key **absent** (the 10 `null` rows) |

Report:

1. Count per bucket.
2. The full address list per bucket, verbatim.
3. After a **`sit`-only** widen (add `` `study` `` to every `sit` arena that lacks it, leave `pass` and `ungated` alone): how many arenas would then allow `` `study` ``? (current 4 + new `sit` count.)
4. After an **everywhere-gated** widen (add `` `study` `` to all 53 arenas that already have a list): same count. This is the “63 minus the 10 ungated” number — confirm it.
5. Flag any `sit` row you almost put in `pass`, and any `pass` row you almost put in `sit`. One sentence each. Do not move them after the fact — just flag.

Do **not** add `` `study` `` to bathrooms in any candidate set.

---

## Q2 — Same split for every other activity that is scarce or unused

For each activity in this list, repeat the Q1 bucket idea **only as counts**, plus a one-line “would widen into” note. Do not dump 63 rows again unless a bucket is ≤8 addresses (then paste those).

Activities:

| activity | current n (Q1) | Why we care |
|---|---|---|
| `play` | 16 | Q4: 105 rows Hobbs → pub tagged `play` |
| `eat` | 12 | Q4: 76 rows Hobbs → pub tagged `eat`. Homes’ main rooms mostly **lack** `eat` |
| `social` | 20 | Missing from most bedrooms / apartments? |
| `work` | 18 | Homes only. Cafe / college / stores are jobs, not “work” on the list |
| `exercise` | 6 | Thin; Q2 only 9 rows this run |
| `art` | 1 | Unused this run; one studio |
| `shop` | 2 | Unused this run; both stores |
| `serve` | 4 | Unused this run; staff-shaped |
| `sleep` | 18 | **Must stay narrow.** Confirm no bathroom / cafe / park has it |
| `hygiene` | 13 | **Must stay bathrooms.** Confirm no living room has it |
| `cook` | 14 | Should stay kitchens (+ pub if it already has it) |
| `storage` | 18 | Unused this run |
| `relax` | 31 | Already the widest typed list — say whether anything obvious is missing |

For each: `sit` / `pass` / `already-on-list` / `must-not-widen` counts. If you would **narrow** an existing list (activity is on a room that should not have it), list those addresses verbatim.

---

## Q3 — What the run actually typed, vs what the lists believe

From data request 4 Q2 (or a fresh count if the sim has grown — say which):

1. Paste the `action_family` distribution again (counts).
2. Families in the run that are **not** in the registry list: only `empty` last time — confirm or quote new ones.
3. Families in the registry that the run **never** emitted: last time `art` `serve` `shop` `sleep` `storage`. Confirm.
4. For `empty` (largest bucket): do **not** propose assigning them a type. Say only whether any of those rows have a non-empty hourly that names a sector (count). We already know empty skips old veto; we need to know if search ever sees them.

---

## Q4 — Remaining Q4 triples that are not `study`

From data request 4 Q4 top 15, the non-`study` rows were:

- Hobbs → pub `play` 105
- Hobbs → pub `relax` 90
- Hobbs → pub `eat` 76
- Apartment 1 → House 1 bathroom `hygiene` 50
- Hobbs → Apartment 5 / 4 `work` 47 / 44
- Hobbs → Willows empty 35
- Hobbs → library `relax` 33
- Hobbs → dorm common `eat` 31
- Hobbs → Harvey `work` 30
- Apartment 1 → park empty 58

For each triple, answer from disk (verbatim dest path):

1. Does the **destination** arena’s whitelist contain that `action_family`? (`yes` / `no` / `absent`)
2. Does the **source** (Hobbs cafe, or the named home) whitelist contain it?
3. One line: is this “list pulled them to a room that allows X” or “something else” (home-name mismatch, work_area snap, unknown)?

If you cannot tell, say `unknown` — do not guess.

---

## Q5 — Still deferred if the runner is up

Stdout counts from data request 4 Q5.2 (`DETERMINISTIC GUARD v2`, cascade Tier-1 / 1b / 2 / 3 / 4). Same rule: `deferred: PID` if still live.

We will not approve an “everywhere” edit until we know how often search actually fires.

---

## Output

Answers under **Responses** in this file. Tables also in `20260829_leave_pack/README5.md`. Raw counts in `data5.json` if you have any new tallies.

Q1 and Q2 unblock the `study` decision. Do those first.

---

## Responses

Collected ~17:15 ET, 2026-08-29. Registry vs data request 4 Q1 table: **equal** (63 rows, same lists). Sim still running: max_step **2071**, clock **16:26** day 2. Registry not edited. Raw: `20260829_leave_pack/data5.json`. Tables also in `20260829_leave_pack/README5.md`.

No product call. Candidate sets only.

---

### Q1 — `study`: sit vs every gated room

Already has `` `study` `` (4), not re-bucketed:
- `the Ville:Apartment 4:main room`
- `the Ville:Dorm for Oak Hill College:Dorm Room 2`
- `the Ville:Oak Hill College:classroom`
- `the Ville:Oak Hill College:library`

Every other arena is in exactly one of `sit` / `pass` / `ungated`.

| bucket | n |
|---|---|
| `sit` | **28** |
| `pass` | **21** |
| `ungated` | **10** |

`sit` (28) — add-`` `study` `` candidate if we widen sit-only:
- `the Ville:Apartment 1:main room`
- `the Ville:Apartment 2:main room`
- `the Ville:Apartment 3:main room`
- `the Ville:Apartment 5:main room`
- `the Ville:Dorm for Oak Hill College:Dorm Room 1`
- `the Ville:Dorm for Oak Hill College:Dorm Room 3`
- `the Ville:Dorm for Oak Hill College:Dorm Room 4`
- `the Ville:Dorm for Oak Hill College:common room`
- `the Ville:Dorm for Oak Hill College:garden`
- `the Ville:Hobbs Cafe:cafe`
- `the Ville:House 1:main room`
- `the Ville:House 2:main room`
- `the Ville:House 3:main room`
- `the Ville:House 4:Room 1`
- `the Ville:House 4:common room`
- `the Ville:House 4:garden`
- `the Ville:House 5:Main Bedroom`
- `the Ville:House 5:common room`
- `the Ville:House 5:garden`
- `the Ville:House 6:Main Bedroom`
- `the Ville:House 6:common room`
- `the Ville:House 6:garden`
- `the Ville:Johnson Park:park`
- `the Ville:The Rose and Crown Pub:pub`
- `the Ville:artist's co-living space:Studio Room 1`
- `the Ville:artist's co-living space:Studio Room 3`
- `the Ville:artist's co-living space:Studio Room 5`
- `the Ville:artist's co-living space:common room`

`pass` (21) — left out of a sit-only set (includes every gated bathroom; no bathroom is in `sit`):
- `the Ville:Apartment 1:bathroom`
- `the Ville:Apartment 2:bathroom`
- `the Ville:Apartment 3:bathroom`
- `the Ville:Apartment 4:bathroom`
- `the Ville:Apartment 5:bathroom`
- `the Ville:Dorm for Oak Hill College:bathroom 1`
- `the Ville:Dorm for Oak Hill College:bathroom 2`
- `the Ville:Dorm for Oak Hill College:kitchen`
- `the Ville:Harvey Oak Supply Store:supply store`
- `the Ville:House 1:bathroom`
- `the Ville:House 2:bathroom`
- `the Ville:House 3:bathroom`
- `the Ville:House 4:bathroom`
- `the Ville:House 4:kitchen`
- `the Ville:House 5:bathroom`
- `the Ville:House 5:kitchen`
- `the Ville:House 6:bathroom`
- `the Ville:House 6:kitchen`
- `the Ville:Oak Hill College:hallway`
- `the Ville:The Willows Market and Pharmacy:store`
- `the Ville:artist's co-living space:kitchen`

`ungated` (10) — key absent, left alone:
- `the Ville:House 4:Room 2`
- `the Ville:House 5:Second Bedroom`
- `the Ville:House 6:Second Bedroom`
- `the Ville:artist's co-living space:Studio Bathroom 1`
- `the Ville:artist's co-living space:Studio Bathroom 2`
- `the Ville:artist's co-living space:Studio Bathroom 3`
- `the Ville:artist's co-living space:Studio Bathroom 4`
- `the Ville:artist's co-living space:Studio Bathroom 5`
- `the Ville:artist's co-living space:Studio Room 2`
- `the Ville:artist's co-living space:Studio Room 4`

3. Sit-only widen: **32** arenas would then allow `` `study` `` (current 4 + 28).
4. Everywhere-gated widen: **53** (63 − 10 ungated). Confirmed.
5. Flags (not moved): `sit` almost `pass` — the four gardens and the park are outdoor, left in `sit` because the bucket text names them. `pass` almost `sit` — the five kitchens have tables, left in `pass` because the bucket text names kitchens.

---

### Q2 — Other activities (counts + one line)

Same 63 addresses. `already-on-list` = has the string today. `sit` = lacks it and would be a search-widen candidate. `must-not-widen` = lacks it and should not gain it. `pass` = the rest that lack it. Ungated rooms sit in `must-not-widen` unless named below.

| activity | already | sit | pass | must-not | would widen into | would narrow (already on, should not be) |
|---|---|---|---|---|---|---|
| `play` | 16 | 16 | 21 | 10 | cafe, park, four gardens, remaining bedrooms/studios, classroom, library | empty |
| `eat` | 12 | 8 | 32 | 11 | the eight home main rooms that lack it | empty |
| `social` | 20 | 18 | 15 | 10 | apartment / house / dorm / studio rooms that lack it | empty |
| `work` | 18 | 6 | 29 | 10 | job sites that lack `work` | empty |
| `exercise` | 6 | 0 | 47 | 10 | empty (every garden and the park already have it) | `the Ville:Dorm for Oak Hill College:Dorm Room 4` |
| `art` | 1 | 4 | 48 | 10 | the other four studios | empty |
| `shop` | 2 | 0 | 0 | 61 | empty | empty |
| `serve` | 4 | 0 | 0 | 59 | empty | empty |
| `sleep` | 18 | 0 | 0 | 45 | empty — stays narrow | empty |
| `hygiene` | 13 | 5 | 0 | 45 | the five ungated studio bathrooms | empty |
| `cook` | 14 | 0 | 31 | 18 | empty — kitchens + pub already have it | eight living rooms (below) |
| `storage` | 18 | 0 | 35 | 10 | empty | empty |
| `relax` | 31 | 1 | 21 | 10 | classroom | empty |

Buckets ≤8, pasted:

`eat` sit (8):
- `the Ville:Apartment 1:main room`
- `the Ville:Apartment 2:main room`
- `the Ville:Apartment 3:main room`
- `the Ville:Apartment 4:main room`
- `the Ville:Apartment 5:main room`
- `the Ville:House 1:main room`
- `the Ville:House 2:main room`
- `the Ville:House 3:main room`

`work` sit (6):
- `the Ville:Hobbs Cafe:cafe`
- `the Ville:Oak Hill College:classroom`
- `the Ville:Oak Hill College:library`
- `the Ville:The Rose and Crown Pub:pub`
- `the Ville:Harvey Oak Supply Store:supply store`
- `the Ville:The Willows Market and Pharmacy:store`

`art` sit (4):
- `the Ville:artist's co-living space:Studio Room 1`
- `the Ville:artist's co-living space:Studio Room 2`
- `the Ville:artist's co-living space:Studio Room 3`
- `the Ville:artist's co-living space:Studio Room 4`

`hygiene` sit (5):
- `the Ville:artist's co-living space:Studio Bathroom 1`
- `the Ville:artist's co-living space:Studio Bathroom 2`
- `the Ville:artist's co-living space:Studio Bathroom 3`
- `the Ville:artist's co-living space:Studio Bathroom 4`
- `the Ville:artist's co-living space:Studio Bathroom 5`

`relax` sit (1):
- `the Ville:Oak Hill College:classroom`

`cook` would-narrow (8 living rooms that already list `cook`):
- `the Ville:Apartment 1:main room`
- `the Ville:Apartment 2:main room`
- `the Ville:Apartment 3:main room`
- `the Ville:Apartment 4:main room`
- `the Ville:Apartment 5:main room`
- `the Ville:House 1:main room`
- `the Ville:House 2:main room`
- `the Ville:House 3:main room`

`sleep` confirm: no bathroom, cafe, or park lists `sleep`. The 18 are bedrooms / dorm rooms / apartment and house main rooms / three gated studios.

`hygiene` confirm: no living room lists `hygiene`. The 13 are gated bathrooms only.

`relax`: the only sit-shaped gated room that lacks it is the classroom.

---

### Q3 — Run types vs lists

Fresh count at step **2071** (data request 4 was 29325 at ~2030).

| `action_family` | rows |
|---|---|
| empty | 8995 |
| `relax` | 7028 |
| `work` | 5097 |
| `study` | 2802 |
| `eat` | 2747 |
| `hygiene` | 1052 |
| `play` | 879 |
| `cook` | 711 |
| `social` | 579 |
| `exercise` | 9 |

In the run, not in the registry set: empty only.

In the registry, never emitted: `art` `serve` `shop` `sleep` `storage`. Confirmed (still 0).

Empty rows whose hourly names a sector: **185** (day 2 only). Day 1 empty rows **2917** — hourly source empty, not scored. No type assigned to empty.

---

### Q4 — Non-`study` triples

Source list for Hobbs rows: `the Ville:Hobbs Cafe:cafe` = `["eat", "social", "serve", "relax"]`. Apartment 1 home list checked as `the Ville:Apartment 1:main room` (hourly names the sector only). Dest path is the stored `resolved_address` arena, verbatim.

| triple | dest path | dest has family | source has family | one line |
|---|---|---|---|---|
| Hobbs → pub `play` 105 | `the Ville:The Rose and Crown Pub:pub:bar customer seating` | **yes** | **no** | list pulled them to a room that allows `play` |
| Hobbs → pub `relax` 90 | `the Ville:The Rose and Crown Pub:pub:bar customer seating` | **yes** | **yes** | something else (both lists already allow `relax`) |
| Hobbs → pub `eat` 76 | `the Ville:The Rose and Crown Pub:pub:bar customer seating` | **yes** | **yes** | something else (both lists already allow `eat`) |
| Apt 1 → House 1 bathroom `hygiene` 50 | `the Ville:House 1:bathroom:bathroom sink` (34) and `…:shower` (16) | **yes** | **no** on `Apartment 1:main room` | home-name mismatch (Olivia lives at House 1; hourly says Apartment 1) |
| Hobbs → Apt 5 `work` 47 | `the Ville:Apartment 5:main room:desk` | **yes** | **no** | list pulled them to a room that allows `work` (Vince’s home) |
| Hobbs → Apt 4 `work` 44 | `the Ville:Apartment 4:main room:desk` | **yes** | **no** | list pulled them to a room that allows `work` (Vincent’s home) |
| Hobbs → Willows empty 35 | `the Ville:The Willows Market and Pharmacy:store:grocery store shelf` | **no** (list is `shop`,`serve`; empty is not a key) | **no** | work_area snap (Owen’s job is that store) |
| Hobbs → library `relax` 33 | `the Ville:Oak Hill College:library:bookshelf` (18 Shepard) and `…:library table` (15 Reed) | **yes** | **yes** | something else — dest is each person’s `work_area`; both lists already allow `relax` |
| Hobbs → dorm common `eat` 31 | `the Ville:Dorm for Oak Hill College:common room:common room table` | **yes** | **yes** | something else (both lists already allow `eat`) |
| Hobbs → Harvey `work` 30 | `the Ville:Harvey Oak Supply Store:supply store:behind the supply store counter` (29) and `…:supply store counter` (1) | **no** (list is `shop`,`serve`) | **no** | work_area snap (Dean’s job is that store) |
| Apt 1 → park empty 58 | `the Ville:Johnson Park:park:park garden` | **no** (empty is not a key) | **no** | unknown |

---

### Q5 — Search-fire log counts

**deferred: PID.** Runner still writing (step 2071).

---

## Gaps

- Q5.2 cascade / guard counts: **deferred: PID**.
- Day 1 empty-family hourly: **empty**.
