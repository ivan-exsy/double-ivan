> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# Pittsburgh Downtown — BE handoff

**Date:** 2026-09-04  
**From:** FE (`double-r3f`, branch `pittsburgh`)  
**To:** Backend (`generative_agents`, branch `ivan/downtown-pgh` / `breakfasts`)  
**Product:** Pittsburgh Business Breakfasts — Survival at **PPG Cafe** when look is ready. **Look / occupancy:** [`MVP-0.1.md`](../../MVP-0.1.md), [`Pitts_Phaser.md`](../Pitts_Phaser.md). **Cohort onboard + village demo:** [`MVP-breakfasts.md`](../../MVP-breakfasts.md).

**Ask:** Put Doubles on the ingested Downtown maze. Do **not** re-ingest. Do **not** swap production `create-sim` / `the_ville`. Village live stays on `railway`.

---

## Current (2026-09-04)

| | |
|---|---|
| Occupancy maze | Ingest **scripts + tests** on `ivan/downtown-pgh` (`f69d59a8`). CSVs live under gitignored `environment/…/assets/downtown`. **Not** in git. **Not** in Supabase. |
| Names / cafe / homes | PPG Cafe door `[273, 221]`, **40** walkable. Smoke homes `Residence 1`–`15`. Village names must not leak. |
| Gather stay | **Done and pushed** on `ivan/downtown-pgh`. Stay keep on downtown writes `Downtown:PPG Cafe:cafe` and the PPG tile box. Leftover Hobbs arena remaps to PPG Cafe. Village Hobbs stay unchanged. Unit tests in `tests/test_gather_stay_keep.py`. |
| Git / box | Branch is **on GitHub**, in sync. Live village generation is still `railway`. Do **not** merge Downtown onto `railway` without Ivan. Do not point Nicolas at `railway` for Downtown. |
| Live Downtown sim | **Bodies walked.** `20260904-1` on openrouter, maze `downtown`. Luba reached PPG Cafe (~07:05). Cap 6, no village leaks. Stopped ~07:24 after proof. No scored Survival day. |

FE look does not wait on the rest of this file.

---

## Paste-ready (Slack / WhatsApp)

FE preview is an **OSM floor plan**, not the town. Occupancy ingest + Downtown gather stay + plant **`base_family_pittsburgh`** + fork **`20260904-1`** are on **`ivan/downtown-pgh`** (not `railway`). Stay writes **PPG Cafe** addresses. **Bodies walk:** Luba sidewalk → PPG Cafe, cap 6. Next is a founder call (optional engine Survival day vs wait for look). Do not change `create-sim`. Do not treat that sim as a Breakfasts demo until Nicolas’s look TODOs 1–4 land.

---

## Goal

A scored Downtown Survival day on this maze: bodies walk street → door → PPG Cafe, challenge 11:00 and vote 20:00 use **PPG Cafe** tiles, village `create-sim` still ships the village.

**Done when:** an opt-in sim with `maze_name=downtown` has 15 people on the smoke homes, they can reach the cafe door within cap 6, and a Survival day is scored at PPG Cafe (same occupancy bar as village). Village production path unchanged.

---

## Already done — do not re-do

| Item | Status |
|---|---|
| Maze ingest | Parallel folder `assets/downtown`. World `Downtown`. `maze_name=downtown`. Branch trail: `ivan/downtown-pgh`. |
| Names | Pittsburgh sim names on Downtown. Village Hobbs files stay village. |
| Gathering | `default_gathering_location("downtown")` → **PPG Cafe**. Door `[273, 221]`. Arena 42 / walkable **40**. Furniture `[274, 223]` and `[276, 223]` blocked. 15 sit/stand anchors. |
| Cafe zone on this maze | `maze.py` builds Downtown cafe box from `Downtown:PPG Cafe:cafe` tiles — **not** village 72–83 / 19–26. |
| Smoke homes | Fixture `tests/fixtures/downtown_smoke_homes.json`. 15 walkable `Downtown:Residence N:room` street tiles. Not apartments. |
| Occupancy walk test | 15 homes → PPG Cafe door, cap 6 (CSV / unit tests). |
| Gather stay (Downtown) | Stay keep writes `Downtown:PPG Cafe:cafe` + PPG tile box. Leftover Hobbs arena on downtown → PPG Cafe. Village stay still Hobbs. Tests in `tests/test_gather_stay_keep.py`. On **`ivan/downtown-pgh`**. **Not** on live `railway`. |
| FE look | **OSM floor contours.** Not height / outsides / visible rooms / Pittsburgh streets. Nicolas: [`Pitts_Phaser.md`](../Pitts_Phaser.md) + [`pittsburgh-nicolas.md`](./pittsburgh-nicolas.md). Occupancy files he uses: `public/assets/pittsburgh/`. Collision unchanged. Art bugs are **draw-only**. Breakfasts is **not showable** until that look lands. |
| Occupancy plant | **Done.** `base_family_pittsburgh` — same four people as `base_family_sim`, homes 1/4/7/10, Luba → PPG Cafe. Village original unchanged. Script: `scripts/plant_base_family_pittsburgh.py`. |
| Live bodies walk | **Done on `20260904-1`.** Floor plan is enough for the engine (no painted buildings / named furniture). Luba sidewalk → `Downtown:PPG Cafe:cafe` ~07:05. Cap 6. 0 village address leaks. Stopped ~07:24. Ivan still asleep (wake 10). Not a Breakfasts demo. |
| Village Survival | Engine **Pass**. Do not rewrite Survival for Pittsburgh. |

Re-ingest only if FE rebuilds `tmp/pittsburgh-be-handoff/` and says so. Packing slip is the appendix below.

---

## Work remaining (in this order)

Gather stay is **done on `ivan/downtown-pgh`**. Do not re-open it. Do not restore the deleted gather lock. Do not merge this branch onto `railway` without Ivan.

**Look is OSM contours.** An engine sim here is occupancy proof, not a Breakfasts screenshot.

### Ivan — while Nicolas draws (engine only)

1. **Boot Downtown on this machine** — **done.** Maze CSVs stay gitignored. Catalog `downtown` exists.
2. **Occupancy plant** — **done.** `base_family_pittsburgh`. Do not retarget `base_family_sim`.
3. **Fork + spawn** — **done.** `20260904-1`, four people on planted sidewalk tiles, Downtown homes/jobs, headless off.
4. **Bodies walk smoke** — **done.** `20260904-1` re-booted; Luba left home at ~06:51 and was on `Downtown:PPG Cafe:cafe` by ~07:05. Gosha/Katya also left spawn. Cap 6 (0 over-cap jumps). No village address leaks. Ivan still asleep (wake 10). Stopped ~07:24. Do not use village `double-front` as the walker.
5. **Address leak check** — **done on the walk.** Spawn homes/jobs were Downtown-only. After walking: 0 `the Ville` / Hobbs / Oak Hill strings on addresses. Luba presence `Downtown:PPG Cafe:cafe`.
6. **Engine Survival day (optional after walk)** — 11:00 / 20:00 occupancy on PPG Cafe tiles. Internal engine proof only. Do **not** send to the Breakfasts group. Do **not** rewrite village SOT until this scores green.
7. **Do not** — onboard live APIs; merge to `railway`; raise cap 6; re-hollow the cafe; wait on Nicolas to start walk; port headless tab-reuse into `double-r3f`; clone this plant per Breakfasts founder.

Detail for the sim itself is below.

### 1. Fork the occupancy plant (not create-sim)

Production `create-sim` / MVP onboard stays `the_ville`. Fork **`base_family_pittsburgh`** (already maze `downtown`, four far homes, PPG gather):

- `generation_mode: sprint` for the score run.
- Do not overlay a village fork by hand.

Do **not** point `home_assignment_service` fallback at downtown for village sims.

### 2. Engine smoke (bodies, not CSV)

4 Doubles from the plant. Cap 6. Persist `[x, y]` on the one downtown grid. **Done on `20260904-1`:** they walked; Luba reached PPG Cafe tiles. No teleports over cap 6. No street-graph node ids.

This is the first live bodies-on-map check. Occupancy paint in the FE preview is not this job.

### 3. Downtown Survival day

Same village Survival: grace day 1, challenge 11:00, vote 20:00, 80% spatial gate, leftover keep, lived board facts.

Gathering tiles = `Downtown:PPG Cafe:cafe` (40 walkable). Do not harvest village Hobbs `x 72–83, y 19–30`. Do not add `study` to the cafe list. Do not restore `_maybe_apply_gather_lock`.

Score like village: day-1 11:00 and 20:00 occupancy on PPG Cafe. 4-person is enough for leftover/stance if the full 15 is too heavy for a first pass — founder call at kickoff.

### 4. Report

Sim code, branch, occupancy counts, any leftover `the Ville` / `Hobbs Cafe` strings on Downtown addresses. Stop. Do not merge to railway / production `create-sim` without Ivan.

---

## Locks (do not reopen)

| Lock | Value |
|---|---|
| One maze | Indoor and outdoor share `[x, y]`. No door teleport. No second graph world. |
| Scale | 1 cell = 1 game metre = **4** Pittsburgh metres. Maze **409 × 437**. |
| Cap | `MAX_TILES_PER_STEP` stays **6**. |
| Gathering | **PPG Cafe** on One PPG Place. Door `[273, 221]`. **40** walkable. Village Hobbs **~74** is the pad-size recipe — **do not re-hollow**. |
| Names | `Downtown:PPG Cafe:cafe` (not `Downtown:Hobbs Cafe:cafe`). ASCII `O'Reilly Pub`. |
| Homes | `Residence 1`–`15` are street start tiles, not apartments. |
| Enterable | Five places only (table below). Everything else exterior-only. |
| Cut A | `double-r3f` `/assets/downtown` ~223×140 is an **FE fixture**, not this maze. BE assets live at `generative_agents/.../assets/downtown`. |
| Production | Do not swap `the_ville` / `create-sim`. |
| Look vs walk | FE may draw smoother than 1 m. Never write polygons into collision CSVs. |

**Bans:** unscaled ~498k Triangle; hybrid two mazes; raise cap 6; onboard live APIs; Playwright Downtown in `double-r3f` unless `FRONTEND_URL` moves; merge to `vercel` / `double-front`.

---

## Names (Downtown)

| Sim name | Host pad | Address |
|---|---|---|
| PPG Cafe | One PPG Place | `Downtown:PPG Cafe:cafe` |
| Fifth Avenue Market | Fifth Avenue Place | `Downtown:Fifth Avenue Market:store` |
| EQT Supply Store | EQT Plaza | `Downtown:EQT Supply Store:supply store` |
| O'Reilly Pub | O'Reilly Theater | `Downtown:O'Reilly Pub:pub` |
| Penn College | Penn Avenue Place | `Downtown:Penn College:classroom` |

Smoke homes: `Downtown:Residence 1:room` … `Downtown:Residence 15:room`.

Gathering address on Downtown is **`Downtown:PPG Cafe:cafe`**. Village files stay Hobbs.

---

## FE vs BE (who watches what)

| Surface | Owner |
|---|---|
| Picture of Pittsburgh | FE. Today = OSM floor coloring on `/simulations/pittsburgh-preview`. Not the town. |
| Bodies / Survival / occupancy | BE in `generative_agents`. Score from tiles + logs. |
| Headless Phaser tab | Still `double-front` / village until Ivan moves `FRONTEND_URL`. Do not port tab-reuse into `double-r3f` in this job. |
| Binding a live `sim_code` onto the Pittsburgh look | FE, after BE has a Downtown sim. Not this handoff. |

BE success is **engine occupancy on Downtown addresses**, not a pretty screenshot.

---

## Out of scope

- Extra interiors / real apartments
- `/onboard/pgh` live APIs
- Unreal / 3D
- Changing village Hobbs look-dev files to PPG / Penn
- Normative SOT rewrite until this Downtown day scores green (`sot_survival.md` still says Hobbs as the village default; Downtown is maze-name override)

---

## SOT to read

- `double-docs/sot/sot_be-fe.md` — cap 6, persist tiles
- `double-docs/sot/sot_survival.md` — gather stay Current, do not restore the lock
- `double-docs/sot/sot_action-location.md` — whitelist must not relocate a resolved cafe address
- `double-docs/sot/sot_lifecycle.md` — fork / sprint; do not silently enroll live
- `double-docs/R3F/Pitts_Phaser.md` — spatial lock
- Fixture: `generative_agents/tests/fixtures/downtown_smoke_homes.json`

---

## Appendix — ingest packing slip (historical)

Reopen only if FE rebuilds the pack.

**Rebuild (FE):** in `double-r3f`, `npx tsx scripts/package-pittsburgh-be-handoff.ts`  
**Files:** `double-r3f/tmp/pittsburgh-be-handoff/`  
**Ingest (BE):** `python scripts/ingest_downtown_maze.py`

- `collision.csv` — 409×437. Walkable `0`. Blocked `32125`.
- `sector.csv` + `sector_blocks.csv`
- `arena.csv` + `arena_blocks.csv`
- `maze_meta_info.json` — world `Downtown`, tile size 32 px
- `world.json` — bbox south 40.4325 / west -80.0168 / north 40.4482 / east -79.9975; 1 game m/cell = 4 Pittsburgh m
- `cafe_gathering_anchors.json` — 15 tiles in `Downtown:PPG Cafe:cafe`

Origin = bbox southwest. +col = east. +row = north. One grid indoors and outdoors. No door teleport.
