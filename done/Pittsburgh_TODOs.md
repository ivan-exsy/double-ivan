# Pittsburgh — remaining todos

**2026-09-28.** Family day `20260926-2` finished all 1000 steps and closed the life-sim checks in Done. Score: [`20260926-1.md`](20260926-1.md). Do not resume `20260926-2`, `20260926-1`, `20260925-2`, `20260925-1`, `20260924-5`, `20260924-4`, `20260924-1`, `20260923-1`, or `20260923-3`. Do not Start `base_family_pittsburgh`. Do not stamp contracts from `20260924-1`. Breakfasts stays `the_ville` / Hobbs. Cap 6. Do not swap `the_ville`.

The map work from `double-r3f` is merged into `double-front`. Further player work lands there. The Pittsburgh player reached `double-front` `vercel` on 24 Sep (`23748d3`). `pittsburgh-business-breakfasts` stays `the_ville`. A new sim uses the maze named at creation. The default maze is Downtown.

What is left is the open list below. The `double-front` team owns the player steps. Engine scores stay here.

Occupancy items 1–4 are on disk. Collision is the September 22 reconcile. Handoff: [`R3F/20260922_handoff-pittsburgh-be.md`](R3F/20260922_handoff-pittsburgh-be.md). Eng ids: [`double-ivan/20260917_pre-MVP.md`](../double-ivan/20260917_pre-MVP.md) **PM-BFST-1** through **PM-BFST-3**, **PM-BFST-13**.

---

## Implemented - need testing

`double-front` owns the player steps (the `double-r3f` map is already merged there). The engine scores stay with Ivan.

- [x] **A new sim uses the maze named at creation.** Default is Downtown (`downtown`). A named other maze is kept. `pittsburgh-business-breakfasts` is not rewritten and stays `the_ville`. Do not point that page at this floor. On `ivan/create-sim-default-downtown` until that API is the one production uses.
  - How: [`double-ivan/20260917_pre-MVP.md`](../double-ivan/20260917_pre-MVP.md) §PM-BFST-1.
- [x] **First frame** (**PM-BFST-6**). `double-front`. Same opening shot on every maze. Center and zoom scale to that map.
  - Logged in, and their Double is on the map: the camera starts close on that Double.
  - Not logged in, or no Double on the map: the camera is centered on the map, zoomed in a little. Stickers stay readable when the bodies are small. A sticker click zooms in on that Double and opens the card.
  - How: [`double-ivan/TODO_post_mvp.md`](../double-ivan/TODO_post_mvp.md) **PM-BFST-6**.
- [x] **Join `living_area` onto the 20 stamped homes** (**PM-BFST-3**). The Join list is those 20 apartments, one person each, plus PPG Cafe and the four earlier jobs. A `Residence` home cannot be chosen. On `ivan/downtown-join-20-homes` until that API is the one production uses. Do not clone `base_family_pittsburgh`. No re-quiz.
  - How: [`double-ivan/20260917_pre-MVP.md`](../double-ivan/20260917_pre-MVP.md) §PM-BFST-3. Home list and doors: [`R3F/20260918_home-wave-20.md`](R3F/20260918_home-wave-20.md).
- [x] **Downtown tiles in Supabase** (**PM-BFST-2**). Copied 2026-09-24. The full 409×437 floor is on the shared shelf, including the tree stamp. PPG’s open cafe floor is 73 tiles. The three rivers stay open in the database; the engine still treats them as walls when it walks. The production run keeps reading the files on the machine.
- [x] **Switch to the permanent model.** A new run reads the shared shelf. The control is on. Checked 2026-09-28: the shelf matches the files from `20260926-2`, all 178,733 tiles. River walls and other-home walls still apply after the floor is read. A later home edit is a fresh copy of the files, then a new sim. The finished run stays on the files it already used. On `ivan/downtown-shelf-load` until that code is the one production uses. Turn the control off to read the files again.
  - How: [`double-ivan/20260917_pre-MVP.md`](../double-ivan/20260917_pre-MVP.md) §PM-BFST-2.
- [ ] **Scored Downtown Survival day** (**PM-BFST-13**). After the family day is clean. New sim. 11:00 / 20:00 occupancy on PPG Cafe (≥80% tiles). Internal only. `20260924-1` was this season by accident, so the cafe swallowing the afternoon is not a miss for the life sim.
  - How: [`double-ivan/20260917_pre-MVP.md`](../double-ivan/20260917_pre-MVP.md) §PM-BFST-13.

  
## Done

### Scored on `20260926-2`

Score: [`20260926-1.md`](20260926-1.md). `20260925-2` did not hold these (causes in [`20260925-1_pitt_vps.md`](20260925-1_pitt_vps.md)). Do not resume either run.

- [x] **Commit the engine branch** when Ivan says so. `double-r3f` `ivan/pgh-20-homes` and `ivan/pgh-player-carryover` are merged into `double-front`. Still open: `generative_agents` `ivan/downtown-nicolas-ingest`. The maze files and the pack stay out of git.
- [x] **The run is on the current floor, and an old floor is refused.** Through step 999. No village place. No `Residence` label. Every minute has a tile. Floor stamp `a6d586ace71ad3889944ee9230cd17a99a44ccd975bd545eaf73e2a990d6ab83`.
- [x] **Arrived means the body is in the destination room.** Stays name that room. Walks move. Luba is inside her apartment. Sleep is on that person’s own bed.
- [x] **Recall reads only this simulation.** The hour lists have no challenge, vote, Silent Pact, or Alliance Lock-In. MVP shortcut. The human-like version is post-MVP **PM-MEM-CTX-8**.
- [x] **The place picker refuses another person’s home.** No destination is the Roosevelt Building or another apartment. No route enters another apartment.
- [x] **A task names a real place on this map.** The anchor is one full line from the allowed list. A bare apartment, store, or workbench does not send someone to the wrong building.
- [x] **Gosha’s library table is only at Penn College.** 338 minutes. A 47-minute `library sofa` stay is inside the EQT Supply Store.
- [x] **One shift at the job on file.** Ivan 274 minutes at O’Reilly Pub, Gosha 425 at Penn College, Luba 450 at her desk, Katya 290 at the EQT Supply Store. Ivan’s bar work is at the pub.
- [x] **No pool line.** Dry diving drills are at Point State Park.
- [x] **The `Water` patches are walls.** No minute is labeled `Water` or `Residence`. Engine wall, same as the rivers. The collision file stays as it is.

Held earlier on the local family day `20260924-4`. Do not resume that sim.

- [x] **Player routes honor the extra walls.** Nobody sat on a river, and nobody’s route entered another apartment. Four Gateway Center stayed closed.
- [x] **Staff sentences stay off the customer counter.** One minute behind the EQT counter was accepted. A stay was not.
- [x] **Sleep is at that person’s own bed.** No sleep on a shop sofa or anyone else’s bed.
- [x] **A meeting closes when they part.** Every stored row closed a couple of minutes after the last minute together. A later hello is a new row.
- [x] **Survival-off fork for class and the night line.** Class is at Penn College. Nobody left the map. The challenge-on-today’s-clock line is the separate done item below.
- [x] **Exterior city blockers: 21,279 cells.** Stamped 2026-09-24 on the local floor only. Trees and other outside art. Rivers, doors, and the 22 Sep room cells were left as they were. All 25 doors still reach each other. The production machine was not touched.

**Reconcile:** 40 obsolete September 21 cells opened, 99 of **675** reviewed cells closed, 15 empty pockets sealed. `[342,174]` stays open. Do not open `[341,173]` or `[348,150]`. Do not restamp the 463 list.

### Occupancy — items 1–4

- [x] **1. Reconcile room collision.** Done 2026-09-22 on `ivan/pgh-20-homes`. `opened=40 closed=99 sealed=15 proposal=675 kept-open=342,174`. Do not run `scripts/stamp-pittsburgh-room-colliders.ts`. Do not restamp the 463 list.
  - Shop doors stay: PPG `[273, 221]`, Fifth Avenue `[286, 162]`, EQT `[346, 151]`, O’Reilly `[323, 132]`, Penn College `[267, 130]`. Midtown door stays `[349, 149]`.
- [x] **2. Prove the walk.** Done 2026-09-22. Door-walk plus the four related suites: 19 passed.
- [x] **3. Export reviewed objects.** Done 2026-09-22. Placed **868**, unknown GIDs **182**, violations **0**.
- [x] **4. Pack the BE handoff.** Done 2026-09-22. Gitignored `double-r3f/tmp/pittsburgh-be-handoff/`. 868 object cells, 46 names.

### Maze on disk

- [x] **Ingest Downtown CSVs.** Done 2026-09-22 on `ivan/downtown-nicolas-ingest`. Furniture **868** cells / **46** names. Cafe floor 95 tiles, **73** walkable. The 20 apartments stayed. Village Hobbs unchanged. Maze files stay local.
- [x] **Retire the old split test.** Done 2026-09-23. Roosevelt, Encore, and Gateway are one apartment each.
- [x] **Glance** the 20 furnished homes. Done 2026-09-23 on `/simulations/pittsburgh-preview`. PPG reads as a cafe.
- [x] **Visual pass.** Closed 2026-09-28. That glance is enough. No new issues since.
- [x] **Walk check before a sample sim.** Done 2026-09-23. All **25** doors open onto the street network. All **868** object cells are reachable. Rivers stay open in the picture. The engine treats them as walls, same as the `Water` patches scored on `20260926-2`.
- [x] **Sample roster in real apartments.** Done 2026-09-23. `base_family_pittsburgh` paused. Gosha → Gateway Tower / Penn College. Ivan → Encore on 7th / O’Reilly Pub. Luba → Six PPG Place / PPG Cafe. Katya → Midtown Tower / EQT Supply Store. Do not Start this baseline.
- [x] **Sample sim, engine walk.** Done 2026-09-23. `20260923-1` finished 300 steps. Do not resume it.

### Scored on `20260924-1` — held

Notes: [`20260923_pittsburgh_test.md`](20260923_pittsburgh_test.md), [`20260924-1_pit.md`](20260924-1_pit.md).

- [x] **Headless stores the route.** Every saved minute has a route. No landing and no saved route went past 6. 2,913 landings are a full 6 tiles.
- [x] **The day includes one shift at the job on file.** Held on the days each person was still on the map: Penn College, O’Reilly Pub, EQT Supply Store, PPG Cafe.
- [x] **Katya wakes at Midtown Tower.** First & Market never appears.
- [x] **The place on the line matches the body’s building.** On every saved minute the building in the sentence is the building of the tile. The trip line stays the walk while they are still on the way.
- [x] **The status sentence matches the room.** Until the body is in that room, the line is the walk. Held on `20260924-1`.
- [x] **Off-map life stays out of the place line.** No place and no status line names CityHigh, a pool, or poolside. Gosha’s diving block is dry drills at Point State Park.
- [x] **This player caught up with the live map.** Magic-link chat, LIVE speeds, joined list, saved transcript, working state, finger drag. `ivan/pgh-player-carryover` is merged into `double-front`.
- [x] **Video vs Phaser scale.** Locked 2026-09-21. Maze stays 4:1.
- [x] **Meet-screen copy** (**PM-BFST-15**). Done 2026-09-24. First-time Meet: “Your Double keeps your personality. Its schedule adapts to the town it lives in.” Review Meet unchanged.
- [x] **A remembered challenge or vote is not today’s appointment.** The prompt note landed 2026-09-24. Production `20260925-2` still booked Saturday and Sunday. Closed on `20260926-2`: the four hour lists do not name a challenge or a vote.

## Do not

- Restamp the 463 list, or Join, until Ivan says **go**. Do not resume `20260926-2`, `20260926-1`, `20260925-2`, `20260925-1`, `20260924-5`, `20260924-4`, `20260924-1`, `20260923-1`, `20260923-3`, or `20260923-4`. Do not Start `base_family_pittsburgh`. Not the Breakfasts watch.
- Paint the collision file to close the rivers or Two PPG Place. The walls already exist for the engine drawer.
- Hollow Star Loft, Wood Street Galleries, Academic Hall, YWCA, or Penn Avenue Library. No garage homes. No further OSM homes (Wyndham split stays founder-gated).
- Treat One Gateway Center or Two PPG Place as two homes. Two bedrooms inside one apartment is not a split.
- Raise cap 6 or change 4:1. One maze. No door teleport.
- Ask Nicolas to write `collision_maze.csv`.
