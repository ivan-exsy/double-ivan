> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# R3F Ville — 3D spatial (updated 2026-09-02)

**Status (2026-09-04):** **Active look = Pittsburgh 4:1 Golden Triangle** ([`Pitts_Phaser.md`](./Pitts_Phaser.md)). Preview is **OSM floor contours** (colored squares). Height / Pittsburgh outsides / visible rooms / street art **not built**. BE: ingest + gather stay + plant + **`20260904-1` bodies walk** (Luba → PPG Cafe) on `ivan/downtown-pgh`. Floor plan is enough for the engine; not a Breakfasts screenshot. Playwright / headless still village. Cut A fixture: `/assets/downtown`. Production `the_ville` not swapped. BE→Nicolas: [`handoff/pittsburgh-nicolas.md`](./handoff/pittsburgh-nicolas.md).

**Status (2026-09-03, historical):** Look v1 on `/simulations/pittsburgh-preview`. Full Downtown bbox, 1 game m/cell = 4 Pittsburgh m, Ville sim buildings on matching OSM pads. Playwright skipped that pass.

**Status (2026-09-01 evening, still true for Cut A code):** **Phase 1 / Cut A** stays **one 4 m occupancy maze** (~223 × 140). Phaser **may draw** smoother OSM footprints; Doubles still walk the 4 m collision CSV. Do **not** write polygons into collision or address tiles. Uniform **1 m** Golden Triangle is the right *shape* later, **not this year’s Downtown tape**. Hybrid no. Cap 6. Cut B out. Production `the_ville` does not swap.

**Names:** **Path 1** = Quaternius experiment (archive). **Phase 1** = Phaser 2D downtown (now). **Phase 2** = 3D on those ids (later).

**Repo:** https://github.com/ivan-exsy/double-r3f (`main` = last accepted code). Local: `D:\Coding\double-r3f`.

---

## Founder decision: four goals (2026-09-02)

Scratchpad. Not a new occupancy emit. Not a BE contract change. Production `the_ville` still does not swap until a separate cutover.

### Goals (verbatim intent)

1. Replace the Phaser village **layout** with Pittsburgh Golden Triangle, or **a part of it**.
2. Rendering quality **at least on-par** with today’s village (CuteRPG / Hobbs bar — **not** Cut A occupancy paint).
3. Interiors with enough **resolution** for **20+ Doubles** in a room (stand, circulate, not one-body-per-pad).
4. **Current** pathfinding engine (full A\* to far zone, then prefix 6; Python `execute` + Phaser tab; 120 s all-agent wait). Existing hardware. No big new search cost.

### Bind (cannot have all four on the full Triangle)

Live search still walks the **whole maze** every travelling step, then keeps 6 tiles. Proven cell count is `the_ville` **140 × 100 ≈ 14k**. Cut A 4 m is **~223 × 140 ≈ 31k** (~2×, FE 10k-iter cap already a risk on Point→Grant). Full Triangle at 1 m is **~890 × 560 ≈ 498k** — refused as this year’s tape; Python emit **and** the 120 s tab both die.

One occupancy maze, one cell size. Hybrid (4 m street + 1 m room + door hop) is **refused**. Cap 6 stays one number. Look may already ignore the occupancy snap (polygons / tileset). Occupancy paint is **not** the visual bar.

**20+ Doubles in a room** needs walkable **tiles**, not square metres of footprint:

| Occupancy | Same physical cafe ~20 m × 15 m | 20 bodies | Furniture / Hobbs-like |
|-----------|----------------------------------|-----------|------------------------|
| **1 m** (Ville-like) | ~20 × 15 = **300** cells | Fits with circulation | Yes. Talk = **3 m**. |
| **4 m** (Cut A) | ~5 × 4 = **20** cells | Packed wall-to-wall, no chairs | No. Talk = **12 m**. A later 4 m “cafe” is **~3 × 2** — **not** Hobbs. |

Hobbs Cafe is **14 × 10** cells with tens of walkable tiles. That is the resolution bar for goal 3.

Goal 2 is **draw**, not cell size: Ville-class tileset + building sprites/OSM polygons. Streets can look on-par at 4 m occupancy. **Rooms** at 4 m cannot look on-par with Hobbs.

### Options

| Id | Do | Goal 1 map | Goal 2 look | Goal 3 interiors | Goal 4 engine | Cost / risk |
|----|----|------------|-------------|------------------|---------------|-------------|
| **A** | Full Triangle **4 m** occupancy. Upgrade **draw** (tileset/polygons). Pads stay locked, or later weak 4 m halls. | Whole ~890 × 560. Point→Grant ~37 min. | Streets **can** match Ville if we stop painting occupancy. | **Fail** (or only plaza-scale halls). | Likely OK at ~31k; 10k-iter cap may miss long paths. | Least contract risk. Matches Cut A emit. Goal 3 slips. |
| **B** | **Crop** to a Triangle **fragment** at **~1 m**, grid **≤ ~14k–31k** cells (e.g. Market Square + a few blocks, ~140 m × 100 m up to ~220 m × 140 m). Hollow **one maze**. 1–3 enterable buildings Hobbs-scale. Ville-class tileset. | **Part of** it, not Point-to-Grant. | Rooms **and** streets can match Ville. | **Pass** if rooms have ~80+ walkable 1 m cells. | Same engine, same hardware as Ville / Cut A cell count. | **Only option that hits 1+2+3+4 without engine rewrite or hybrid.** New bbox (founder must freeze). Not the 2026-09-01 “do not emit 1 m this year” tape — that ban was for the **full** 498k grid. |
| **C** | Full Triangle 4 m **now** (A), then later **rebuild whole map at 1 m** after street-graph overlay in `execute` **and** generation Phaser. | Whole map, delayed interiors. | Streets first; rooms after rebuild. | Later. | **Not** current engine. Overlay is Current-**legal** (BE 2026-09-02: not hybrid if persist is only occupancy `[x, y]`). | Two occupancy generations. Addresses should stay place names so Phase 2 can reuse ids. |
| **D** | Reopen **hybrid**: 4 m city + 1 m rooms + door. | Whole map + Hobbs rooms. | Can match. | Pass. | New contract; two persist spaces; BE refused. | Months. Do not pick unless founder asks BE to lift the ban. |
| **E** | Full Triangle 4 m, hollow large footprints so 20 bodies stand on 4 m cells (hall / park). | Whole map. | Streets can match; interiors look like chess pieces. | Capacity **yes**, resolution **no**. | Same as A. | Only if “20+ Doubles” means headcount, not Hobbs furniture. |

**Do not pick:** full Triangle at 1 m with current A\*. Raise cap 6 to “make 1 m finish” (cafe crosses in one step). Occupancy paint as the ship look. Swap production `the_ville` before a cutover. Park the movement expert only in `double-r3f` while generation A\* still runs in the Playwright Phaser tab (`double-front` unless FRONTEND_URL moved).

### Recommendation (agent)

If goal 3 is load-bearing: **B**. Say the product is “Market Square Doubland” (or Point, or Grant wall — one crop), not “the whole Triangle this year.” Keep cap 6. Keep one maze. Spend the art budget on Ville-class tiles, not 4 m interiors.

If the **whole** Triangle on screen this year matters more than Hobbs rooms: **A**, and slip goal 3. Draw upgrade is still required for goal 2.

If they want whole Triangle **and** Hobbs rooms **and** current engine: **impossible**. Next honest path is **C** (engine work) or **D** (ask BE to lift hybrid).

### Open pick

- [ ] **A** full 4 m Triangle, look upgrade, interiors later/never on this grid
- [ ] **B → B+** cropped 1 m fragment (superseded 2026-09-02 evening)
- [ ] **C** A now, overlay + 1 m rebuild later
- [ ] **D** ask BE to reopen hybrid
- [ ] **E** 4 m halls for headcount only
- [x] **4:1 full Triangle + Ville-sized pads** (locked 2026-09-02 after size check; river-frame 2026-09-03; see charter)

Active emit: 4:1 river-frame Triangle (~409×437), Point + both rivers + woods far shores, park east of Grant, interiors on OSM pads ≥ Hobbs/Supply/Willows/Pub/College. Cut A 4 m downtown remains a 223×140 fixture.

---

## Summary (read this first)

Long-term architecture does not change: **BE writes a scenario → a runtime walks it once and tapes transforms to Supabase → viewers replay the tape.** Phase 1 uses **Phaser** as that runtime on a **new** downtown maze. Phase 2 moves jobs 2–3 to 3D on the **same** addresses. Production `the_ville` Phaser stays **[B]** until founder cuts over.

1. **Path 1 — Quaternius kit village (frozen, not Phase 1).** MegaKit walls, then Medieval Village Pack. Watchable **toy medieval green**, not Pittsburgh. Keep the CSV / placement pattern. Do not BE-cutover Doubland names. Do not spend more art on this village. Detail: [Path 1 experiment closeout](#path-1--experiment-closeout-2026-09-01).

2. **Phase 1 — Phaser 2D Golden Triangle (now).** One **4 m** walk grid. Occupancy paint is a first preview, not the visual bar. **Look** may be OSM polygons / tileset; **walk** stays the 4 m CSV. Addresses `Downtown:<name>:ground` on that grid. No 1 m interiors this year. Agent plan: [Phase 1](#phase-1--phaser-2d-golden-triangle-locked).

3. **Phase 2 — 3D Pittsburgh (later, same ids).** Extrude every Phase 1 footprint. Google 3D Tiles are look-only. Hobbs-like rooms are a **later funded pass** (weak 4 m rooms on this grid, or rebuild at 1 m, or a real hybrid contract with maze id). Do not mix those into Phase 1. Agent plan: [Phase 2](#phase-2--3d-pittsburgh-later-same-ids).

4. **Unreal City Sample — aspirational north star only.** Poster on the wall for quality. Not a practical engine, not a phone binary, not a GPU farm behind every Telegram viewer.

---

## Investigation and exploration (1 Sep 2026)

### What we were actually optimizing for

A **holistic 3D village** the scenario writer can address, that records a day and replays it. Ideal first draft matching *both* the existing maze *and* the video stills is **not automatic**: stills are not a photogrammetry set, and no API takes CSV + sparse stills → one village.

Three quality levels we ranked:

| Level | Match | Auto? | Call |
|-------|--------|-------|------|
| 1 | Existing maze **and** photos | No | Stills aren’t overlapping views of one volume. Marble invents unseen sides. |
| 2 | Existing maze **and** photo *style* | Max if we **keep** `the_ville` | Kit + retexture; game village, not dining-through-glass. |
| 3 | **New** 3D village + **new** maze/CSV, style from refs | Max auto / walkable volume | Invert: 3D first, rasterize maze. Existing souls need new addresses. **Superseded the same evening:** Phase 1 is **Phaser 2D OSM first**; Phase 2 3D reuses those ids. |

### Hobbs / Marble — proven and killed

- Box factory (PRs 2–8 on `main`, PR 9 draft **do not merge**): maze-accurate cubes. Founder: cave mouth, black roof lid, interior through a roof crack, pixelated furniture. **Category error:** collision cubes ≠ cottage photos.
- Dining splat world `90f5a1bc-1fd5-4e75-b8c3-6c34e0f5fffd` (`marble-1.1`, `cafe_int_dining.png`): can pass taste as a **room**. Does **not** make one walkable cafe. Locked “don’t merge three rooms into one generate” produces **three pictures on a map**. Studio Compose is **GUI only** (no public compose API, ~2M splat cap). Chisel is Studio GUI, not World API.
- **Founder: dead end** for the real goal. Spark `@sparkjsdev/spark@2.1.0` in R3F still stands as the splat *renderer*. Maze CSVs stay unchanged for Phaser [B].

### Architecture (Unreal, R3F, or kit — same three jobs)

1. BE writes a scenario (who should do what).
2. A **hidden 3D run** walks it once (nav, walls, doors) and writes time + positions to Supabase. This run is a PC (or GPU box), not the phone.
3. **Viewer** does not think. It reads the tape and moves bodies. Native app, or browser R3F, or (later) Pixel Stream.

Unreal **can** own jobs 2 and 3 (one project, record vs play modes). That is a spatial rewrite, not a scheme rewrite. The phone still has to **render the set**. Positions are cheap; the village mesh is not.

### Unreal on phones (why City Sample is a poster)

- **Native iOS/Android:** Unreal still packages phone apps. Those use the **mobile renderer** (baked lights, traditional meshes). Nanite, Lumen, virtual shadows — the City Sample stack — are desktop/console. Epic’s City Sample rec: 12-core CPU, **64 GB RAM**, **RTX 2080 / Radeon 6000**, 8 GB VRAM, DirectX 12, SSD. Same tech as *The Matrix Awakens* (PS5 / Series X). ~4 km, Houdini procedural city, Mass crowds, MetaHumans.
- **Web:** there is **no** Unreal-in-Safari runtime like `double-r3f`. Official path is **Pixel Streaming**: a GPU box runs Unreal, the phone gets a live video + input. ~1 GPU session per concurrent explorer. Cost line, not a free group viewer.
- Fortnite-on-phone is a decade of mobile-renderer craft, not a drop-in of City Sample.

**Min-resource Unreal:** optional later **show** (one demo camera). Not the Doubland client.

### OSM Downtown Pittsburgh

Live pull (2026-09-01), Golden Triangle core ~0.6 km (Grant / Market Square / PPG): **206 buildings**. **9%** have meter height; **36%** have floor count; **64%** would be guessed (~3 m/floor). **Zero `indoor=room`** (39 indoor tags, almost all underground transit walls/corridors). Named buildings and the street graph are the win. County WPRDC footprints = roof outlines, **no height column**. LiDAR is terrain, not facades.

**Twitter “AI city” clips are usually not OSM→Unreal:**

1. **Google Photorealistic 3D Tiles** (Cesium / `3d-tiles-renderer` in R3F) — Google Earth flyover. Smeary at sidewalk height, no insides, LoD pops. Overlay your own objects only if **not** traced from Google. **Recording occupancy / measurements from those tiles is prohibited** (derivative). Fine as **postcard backdrop** only, with attribution.
2. **Marble / Gaussian** from a photo or clip — room/plaza scale. No “download Pittsburgh bbox.”
3. **Research city builders** (UrbanWorld 2.0): OSM + street-view + Hunyuan → GLTF block city. Papers: cuboids, weak volume, occluded facades. Street-view APIs have their own ToS. Not a phone interior sim.

**Honest OSM stack:** OSM hull = sim + CSV + tape. **Phase 1 Cut A** rasters that hull to **one** Phaser maze at 4 m/cell (water + streets + locked pads). No second room grid. **Phase 2** extrudes the same footprints; Google tiles = look-only. Interiors wait on a later contract. Do **not** Hunyuan-every-parcel hoping it becomes Matrix.

### Photo → Gaussian interior into a mesh city (path 2 caveats)

This is real for **a few hero ground-floor rooms** if **you** shoot them (not Street View).

Do **not** fuse splat + OSM into one mesh. Register the splat into the city frame, **cut a portal** in the extruded building, hybrid-render: mesh = city, Gaussians = interior. (Independent expert rec 2026-09-01; matches Hobbs: two representations, not a boolean union.)

- One photo set ≈ **one room**. Unseen sides get invented (Hobbs dining).
- **Same metric frame.** OSM extrusion is meters in a local east-north-up (or engine) frame. A splat is usually unscaled COLMAP/Marble space. Recover similarity transform T = (scale, rotation, translation) and **bake it into the splat file**. Do not leave it as a runtime parent unless covariances rotate correctly (anisotropic Gaussians are not “just move the actor”).
- **How to get T:** 3+ surveyed correspondences (door corners, sill, tape on the floor) is best; else floor-plane + measured room width vs OSM interior width + yaw from the long wall; else interactive 3-point snap. Residual **cm to tens of cm** is OK for watch; not for measurement. Align the **door plane / jamb**, not the building centroid (a 20 cm miss at the door is what people see).
- **Open the shell.** The OSM box is watertight. If you drop the splat inside, mesh walls hide it. Boolean a door/window, or hide interior faces and keep the street façade, plus a portal/stencil through the door rectangle. **Clip** the splat to the room AABB (+ ~10 cm), below the floor and above the ceiling, so COLMAP/Marble halo Gaussians do not leak into the street or poke the roof.
- **Runtime:** hybrid scene (mesh + one Spark `SplatMesh`) for a handful of heroes. City-scale: splat **only when the camera is inside or looking through that portal** (do not keep millions of Gaussians per building). Baking splat → textured mesh is the fallback if a destination cannot splat; quality dies on glass/plants. Interchange later: glTF + `KHR_gaussian_splatting`, not one giant PLY. Spark/SPZ remains our web renderer.
- **Collision.** Splats have none. Hidden hull (`splat-transform` collision GLB or boxes: floor, walls, furniture), same T. Do not Recast the splat. Do not walk Google tiles. Tape stays on the OSM/kit hull.
- **Lighting.** Splat lighting is baked from capture time; OSM city is a different sun. They will not match. Capture similar time-of-day, grade the splat, or keep the portal darker so the eye does not compare. Do not expect the splat to receive city sunlight or cast sidewalk shadows.
- **Fails:** scale ~1.1–1.5× (never made metric); Z-up vs Y-up room on its side; street-visible floaters; converting the **whole city** to one splat; fusing three rooms in Studio Compose (GUI, ~2M cap, not an API).
- Citywide interiors: **no** this year. Stream each interior as a georeferenced child of its footprint, same math, instanced per building.

### R3F / phone budget (unchanged)

Tiles/splats as backdrop. Collision on a pre-baked hull that does not pop with LoD. Instantiated props, not Mass crowds. WebGL2 / Spark for reach; WebGPU is a bonus. PWA first.

---

## Path 1 — experiment closeout (2026-09-01)

**Founder call:** stop investing in this intermediary as a product look. It is **not** Phase 1. Keep production Phaser [B] on `the_ville`. Next product world is **Phase 1 Phaser 2D Golden Triangle**, then Phase 2 3D on the same ids.

### What we ran

| Attempt | Result |
|---------|--------|
| MegaKit modular walls on a packer grid | Cookie-cutter plaster boxes on empty grass. Not the kit marketing still. |
| Drop 140×100; Medieval Village Pack whole FBX (~19 buildings + Wholefoods stalls, park, paths, sport yard) on 80×80 | After FBX **cm × 32** was fixed (`tileSize * 0.01`), a stylized village is visible: cottage, well, stone paths, fenced yard, forest. |
| First FBX frame (`Screenshot 2026-09-01 161000.png`) | Camera inside one house. Pack mesh nodes are Blender scale 100; Phong Kd looked grey from inside. |
| Overview (`Screenshot 2026-09-01 164438.png`) | Honest ceiling: toy medieval green. Nature glTF still at scale 32, so bushes/trees dwarf cottages and read as red blobs. |

Names used: **Starbucks**, **Wholefoods**, rest generic. Output: `public/assets/kit-village/` + `lib/kit-village/`. Viewer: `/simulations/kit-preview`. User Next on **:3000**; do not start a second `next dev`.

### Keep (transfers to Phase 1 / Phase 2)

- CSV hull in the old *shape* (collision, sector, arena, game_object, spawn)
- Emit occupancy from the **same** footprints the later 3D pass extrudes
- Spark `@sparkjsdev/spark@2.1.0` as splat renderer (later), not as the city
- Production Phaser [B] on vercel `the_ville` until a separate cutover
- Recipe interiors / door portals: **not Phase 1** (BE rejected hybrid 2026-09-01)

### Do not do next

- Polish Quaternius layout, tree scale, or MegaKit walls
- BE cutover to Doubland `Starbucks:dining`
- Copy `public/quaternius/` into git
- Merge onto `double-front` / vercel
- Treat OSM as photoreal downtown

Kits and name tables below stay as **archive** of the experiment.

---

## Path 1 — archive (kits, names, script)

**Founder lock 2026-09-01 (packs, names, script). Frozen the same evening.**

### Kits (complete look)

Three Quaternius MegaKits, all **CC0** (personal / educational / commercial). Download from [quaternius.com](https://quaternius.com/) or itch.io. Prefer **Source** on each pack when we want per-model collision. Do **not** confuse with in-repo dressing at `public/assets/the_ville/3d/quaternius/` (trees, fences, door, plants, chest only).

| Job | Pack | Notes |
|-----|------|--------|
| Buildings | **Medieval Village MegaKit** (304) | Walls with inside+outside, roofs, doors, floors |
| Furniture / stalls / fixtures | **Fantasy Props MegaKit** (211, June 2025) | Beds, tables, chairs, chests, books, market stalls. Same textured style. |
| Park / trees | **Stylized Nature MegaKit** (116, July 2024) | Trees, grass, plants, rocks. Same nature set the village kit demos use. |

**Do not** use as the main interior set: Ultimate House Interior (modern house), Ultimate Furniture 2019 (20 untextured pieces).

Fridge, guitar, piano, computer: map to the closest medieval stand-in, or leave the slot empty. Do not mix a photoreal fridge into this village.

- [x] Human drops the three kits on disk (`public/quaternius/`). Village **Pro** 304 glTF + Fantasy Props **Standard** 94 + Stylized Nature **Standard** 68. Source collisions not in this drop.
- [x] Copy kits into `public/assets/`: **do not** (gitignored `/quaternius/`; Path 1 frozen).

### Destination names (not `the_ville`)

Do **not** keep `the Ville`, `Hobbs Cafe`, or old cell addresses. Keep **destination kinds** (cafe, grocery, pub, dorm, house, apartment, library, store, park, …). Add new kinds if needed.

**Name rule (locked):** common US names when a clear reference exists. Founder examples: cafe → **Starbucks**; grocery → **Wholefoods**. If no generally recognizable US reference exists, use a **generic** name (`Town Library`, `North Dorm`, `House 2`).

Locked so far:

| Kind | Name | Reference |
|------|------|-----------|
| cafe | Starbucks | Starbucks |
| grocery | Wholefoods | Whole Foods |

Houses, apartments, dorm rooms, college, library, park, pub, hardware: **generic until named**. Souls get new homes on the new instances. BE still needs addresses in `Place:room` shape (`Starbucks:dining`), not the old Hobbs strings.

- [x] Founder names / Doubland CSV cutover: **cancelled** (Path 1 frozen).

### Placement script

Input is a **village program** (destination kinds + counts + the names above), not the old maze CSVs.

The script:

1. Packs footprints on a grid (streets between them).
2. Builds each footprint from Village MegaKit modules (recipe per kind).
3. Fills rooms from Fantasy Props (bed, table, seating, stall/counter, shelf).
4. Scatters Stylized Nature on park and street edges.
5. Writes CSVs in the old *shape* (collision, sector, arena/room, game_object, spawn) plus an R3F placement list from the **same** transforms.

- [x] Write the script after the three kits are on disk (bind recipes to real glTF names). `lib/kit-village/` + `scripts/place-kit-village.ts`. Tests: `__tests__/kitVillage*.test.ts`.
- [x] Emit CSVs in the old *shape* plus `placement.json` (same transforms). Output dir `public/assets/kit-village/`. BE cutover not done.
- [x] R3F loads `placement.json` kits; hidden hull from kit-village CSV. `npm run dev` sets `NEXT_PUBLIC_USE_R3F_VIEWER=true`. Phaser: `npm run dev:phaser`.
- [x] Record/play tape: **not this track** (cancelled with Path 1 freeze).
- [x] Phaser [B] stays live — still true; kit village is not the cutover.

**Do not:** resume Hobbs box factory, merge PR 9, three-splat Compose as the village, Meshy-the-cafe-shell, Recast-on-splat, JPEG-on-box, Google tiles as occupancy.

---

## Phase 1 — Phaser 2D Golden Triangle (locked)

**Founder lock 2026-09-01:** Phase 1 is **Phaser 2D** of the real Pittsburgh Golden Triangle. It **replaces** simplified R3F / Quaternius as the next product world. Stay on **Pittsburgh**. Do not build Doubland on Tokyo PLATEAU, Espoo, or another city’s mesh.

**BE lock 2026-09-01 (updated same evening):** Stay on Cut A **4 m occupancy**. Phaser may draw smoother footprints. Doubles still walk **one** 4 m collision maze — that is valid Current movement. Uniform 1 m is Ville *shape* later, not this year’s Downtown tape. Hybrid **no**. Cap **6**. Cut B **out**. `create-sim` still `the_ville`. Collision CSV is occupancy SOT. Do **not** write OSM polygons into collision or address tiles. If picture and pad disagree, that is a **draw** miss, not a movement-contract miss. Talk start is **3 tiles = 12 m**. One body per 4 m cell at rest.

**Cuts**

| Cut | What “done” means | Who |
|-----|-------------------|-----|
| **A — recognize it** | Overhead (and a walk from Point toward Grant) reads as the Triangle: Point, two rivers, Market Square, Grant Street wall. Buildings locked. | FE auto-mode. Machine tests + founder glance. **Not** a live sim — preview only |
| **B — recorded day** | A scenario uses `Downtown:` addresses | **Not this quarter.** New BE world (allowlist, planner, homes), not “load CSVs” |

**Stack (Phase 1 Cut A only)**

| Layer | Job | Source |
|-------|-----|--------|
| Water | Rivers / confluence (paint + walkable) | OSM `natural=water`, `waterway`, `water=*` |
| Streets | Walk graph | OSM highways (incl. `footway` / `pedestrian` / `steps` / `path`) |
| Park / Point | Open ground at Point | OSM `leisure=park` (walkable) |
| Buildings | ~200 locked pads | OSM footprints, **solid blocked**, cannot enter |

Street geography is **real**. Labels are OSM names or `Building {osm_id}`. Do **not** invent tenants or recipe rooms in this pass.

**Goal:** a new Phaser maze under `public/assets/downtown/` that keeps Triangle **shape**. Do **not** replace production `the_ville` 140×100 / Hobbs until a separate cutover.

Machine tasks: `tasks.json` (track `phase1-downtown-phaser`). Agent skill: `.cursor/skills/osm-pittsburgh/SKILL.md`.

### Agent contract (read before any edit)

| | |
|--|--|
| **World name** | `Downtown` (preview maze only; create-sim still `the_ville`) |
| **Addresses** | `Downtown:<OSM name or Building {osm_id}>:ground` on **this one grid**. Shape `World:Sector:Arena` is valid; do **not** emit `:dining` rooms in Cut A |
| **1 tile** | **4 meters** (BE lock). `sq_tile_size` stays 32 (pixels only) |
| **Mazes** | **One.** No second 1 m interior maze. No door table |
| **Grid** | `ceil(east-span / 4)` × `ceil(north-span / 4)` ≈ **223 × 140**. **Do not** squash the Triangle into 160×120 |
| **Alt grid** | **5.5 m/cell** ≈ 162×102 **only** if Phaser cannot hold ~220×140 — **founder gate**, not agent choice |
| **Origin** | bbox southwest; +col = east; +row = north |
| **Default viewer** | do **not** switch `npm run dev` off kit/Phaser `the_ville` until founder says |
| **Preview** | Phaser loads downtown CSVs (`/simulations/downtown-preview` or `?world=downtown`). User owns **:3000**; do not start a second Next |
| **Tests** | committed **mini fixture** only; **never** call Overpass from Vitest |
| **Live fetch** | `scripts/fetch-osm-downtown.ts` writes **gitignored** extract; founder/CI opt-in |
| **Physics** | CSV collision hull (same *shape* as kit-village emit). Do **not** add Rapier as occupancy |
| **Merge** | do not merge to `vercel` / `double-front` |
| **Production maze** | do **not** overwrite `public/assets/the_ville/` |

### Frozen bbox (Golden Triangle core)

Do not change these numbers without founder.

```
south  40.4375
west  -80.0080
north  40.4425
east  -79.9975
```

~890 m east × ~560 m north. Expected live pull (2026-09-01): ~200 building ways. Unnamed buildings are allowed.

### Occupancy rule (Phase 1)

- Map border: blocked
- Building footprint: **blocked** (solid pad; **zero** interior cells; cannot enter)
- Highway ways (foot/pedestrian/residential/service/unclassified/tertiary/secondary/primary + `footway`/`steps`/`path`): **walkable** corridor (one cell at 4 m, or way width if tagged)
- Water: **walkable** (BE 2026-09-01) but **painted** as water so the two rivers and the Point still read
- `leisure=park`: walkable
- Everything else: walkable unless it is a building

A Point → Grant walk is ~220 tiles ≈ **37 steps** at `MAX_TILES_PER_STEP` 6 (~37 minutes of clock). That is this year’s day length. Keep cap 6 and accept ~148-step / ~2.5 h on a 1 m map is Current math and **not** this year’s Downtown tape.

### Look vs occupancy

- **Occupancy / addresses / talk:** 4 m CSV only. `Downtown:<name>:ground` on the pad.
- **Look:** OSM polygons or a tileset may ignore the 4 m snap. Do not raster those polygons into collision.
- Occupancy **paint** (Cut A screenshot) is a debug still, not the Ville visual bar.

### Interiors (not this year on Downtown)

Do **not** hollow pads. Do **not** emit a second 1 m maze. Do **not** teleport at doors. Do **not** wire recipe interiors into a live day.

Hobbs-like rooms need ~1 m cells **inlined** on one maze, or a new hybrid contract. A later cafe of about **3 × 2** cells on 4 m is still Current and **not** Hobbs. Uniform 1 m Golden Triangle = right shape **later**, not this year’s tape.

**Emit next:** keep the **4 m** collision maze (~223 × 140). Upgrade **draw** only. Do **not** emit a 1 m occupancy grid.

If we later rebuild **one** 1 m maze (~890 × 560), Backend (complete 2026-09-01):

| Lever | Current? | Effect |
|-------|----------|--------|
| Keep cap 6, accept ~148-step / ~2.5 h Point→Grant | Yes | City crawls. Same bargain already refused for Cut A. |
| Raise `MAX_TILES_PER_STEP` | Yes, **one** number | Street and room use the same cap. 24 tiles ≈ today’s 24 m/step; a Hobbs-sized cafe then crosses in **one** step. Persist bar rises with the cap. |
| Plan at sector/arena, walk 6 tiles of 1 m | Already Current | `target_zone` may be far; this-step end stays 6. It does **not** shorten the day. A second coarse `[x, y]` would be hybrid. |
| Crop the raster, or stay 4 m | Yes | Do **not** change step length (1 step = 1 min). Do **not** put meters on the bundle. |

Object pick / spatial memory / proximity still work if a building is **one arena** with many 1 m cells. Capacity is tile count. The address tree must stay **place names**, not hundreds of cell ids. At 1 m, talk range becomes **3 m** (Ville sofa), not 12 m sidewalk.

Hard risks at ~890 × 560: FE A* on ~498k cells **per person per step** (headless step budget is **120 s** for everyone); maze init pulling the full viewport; prompt sector lists if ~200 buildings each grow rooms. Chunk RPC (~126 chunks of 64) and persist `[x, y]` are **not** the kill.

### Hard bans

- Hybrid: city grid + room grids, door teleport, maze id invented in FE
- Emit a 1 m occupancy grid this year
- Meters on the movement bundle; change 1 step = 1 min
- Recipe interiors / enterable select in Cut A
- Simplified R3F / Quaternius as Phase 1
- Squash bbox into 160×120 (distorts the Triangle)
- Replace production `the_ville` 140×100 / Hobbs
- Hand-author Tiled interiors
- Google / Cesium 3D tiles as occupancy, nav, or measurement
- Street View / scraping photos
- Recast on splats; walking Google tiles
- Resuming Quaternius layout or Hobbs box factory
- Committing Overpass dumps, API keys, or `.env`
- `git push` / merge to production tracks
- Starting a second `next dev` while the user is on :3000
- Phase 2 3D extrude / tiles / splat before Cut A tests are green
- Cut B / create-sim `Downtown` / scenario gen this quarter

### ODbL

Credit `OpenStreetMap contributors` in the downtown viewer chrome or a visible attribution line. Do not relicense OSM geometry as original art.

### Autonomous loop (agent may run)

Fixture-first. Each task ≤3 files + one test. Stop on fail. Max 8 implement rounds then hand back.

| id | Do | Acceptance |
|----|----|------------|
| `p1-bbox-origin` | Constants: bbox, origin, world `Downtown`, **4 m/cell** | Origin at SW; maze cols/rows = ceil(east m / 4) × ceil(north m / 4); **not** 160×120; east/north meters match equirectangular at origin lat (±1 m on mini) |
| `p1-parse-fixture` | Parse Overpass-like JSON → buildings + highways + **water** + parks | Mini: ≥3 buildings, ≥1 highway, ≥1 water; keep verbatim `name` and `osm_id` |
| `p1-project-enu` | WGS84 → local meters (x east, z north) | A lon/lat east of origin has x>0 and z≥0 |
| `p1-raster-csv` | Raster water, highways, parks, pads → collision/sector/arena CSVs | Mini cells = width×height; highway walkable; water walkable and painted; **every** building blocked with **zero** interior cells; address `Downtown:…:ground`; blocked id **32125** |
| `p1-phaser-preview` | Phaser loads `public/assets/downtown/` CSVs | Preview route exists; `the_ville` 140×100 **untouched**; `npm run dev` default unchanged; not create-sim |
| `p1-live-script` | Optional Overpass fetch to gitignored path | Script documents URL + bbox; QL includes **water**; Vitest still uses mini.json |

**Overpass QL (live script only):**

```
[out:json][timeout:60];
(
  way["building"]({{bbox}});
  relation["building"]({{bbox}});
  way["highway"]({{bbox}});
  way["natural"="water"]({{bbox}});
  way["waterway"]({{bbox}});
  way["water"]({{bbox}});
  relation["natural"="water"]({{bbox}});
  relation["water"]({{bbox}});
  way["leisure"="park"]({{bbox}});
  relation["leisure"="park"]({{bbox}});
);
out body;
>;
out skel qt;
```

**Suggested paths**

- `lib/osm-downtown/` — parse, project, rasterize, emit (no recipe interiors)
- `scripts/fetch-osm-downtown.ts` — live pull
- `scripts/place-osm-downtown.ts` — fixture or extract → `public/assets/downtown/`
- `__tests__/fixtures/osm-downtown/mini.json` (must include a water way)
- `__tests__/osmDowntown*.test.ts`

Reuse kit-village **CSV shape** (`maze_meta_info.json`, collision/sector/arena/game_object/spawn + blocks). Collision blocked id stays **32125**. Sector ids from **50001** are optional for humans (BE: not required by the database).

**Primary stop:** remaining `p1-*` tasks `done` (not the cancelled interior tasks) and listed tests green (Cut A machine gate). Founder glance: Point → Grant is obvious. Buildings cannot be entered.

**Escalate to founder:** Overpass down; bbox yields 0 buildings; want 5.5 m/cell or any squash; replace `the_ville`; **derive** occupancy from tiles; switch default viewer; Phase 2 3D/splat/Marble; city change (Tokyo/Espoo); hybrid / door teleport; Cut B; hollow buildings.

### Cut B — scenario gen (not this quarter)

BE 2026-09-01: **no** Downtown scenario gen this quarter, including insides. Village talk is still the live Backend chapter. `create-sim` still only allows `the_ville`. Do not start Cut B in this loop.

---

## Phase 2 — 3D Pittsburgh (later; same ids)

**Do not start until Phase 1 Cut A tests are green.** Reuse Phase 1 footprints, CSVs, and `Downtown:` addresses. Do **not** re-parse a second city.

**Founder lock 2026-09-01:** stay on **Pittsburgh**. Do not switch to Tokyo PLATEAU, Espoo, Bmap-as-another-city, or Vexcel/Aerometrex meshes.

**Stack**

| Layer | Job | Source |
|-------|-----|--------|
| A — hull | Walk, names, collision, tape | **Phase 1 CSVs** (unchanged occupancy) |
| A′ — extrude | 3D boxes | Same footprints; height rule below |
| B — look | Skyline / far street | Google Photorealistic 3D Tiles, **display only** |
| C — rooms | Enterable interiors | **Later funded pass**, not Phase 1. Weak 4 m rooms on this grid, or 1 m rebuild, or hybrid contract. Not FE door teleports |

Google tiles of Pittsburgh already give the photo outside. Switching city does **not** raise that look.

**Honest look:** Phaser/CSV underfoot in Phase 1; OSM boxes underfoot in Phase 2; Google Earth from the air; splat rooms at a few doors. Not City Sample sidewalks.

**1 tile (Phase 2 extrude only):** height is meters. Plan-grid stays Phase 1’s 4 m/cell (do not silently change to 1 m/cell and break addresses).

### Height rule (extrude look only; occupancy stays Phase 1)

1. OSM `height` (meters, strip `m`)
2. else `building:levels` × 3
3. else **12** m

Do not invent façades, windows, or Hunyuan meshes.

### Phase 2 tasks (after Cut A)

| id | Do | Acceptance |
|----|----|------------|
| `p2-extrude` | Footprint + height rule → extrusion records | Unnamed → `Building {osm_id}`; height 12 if no tags; ids match Phase 1 |
| `p2-r3f-layer` | R3F box extrusions + hidden Phase 1 hull; preview | Layer reads generated JSON; no kit FBX; `npm run dev` default unchanged |
| `p2-google-tiles` | Display-only tiles, same camera as hull | Attribution Google + OSM; CSV **unchanged**; no bake of heights or footprints from tiles |
| `p2-hero-splat` | Pittsburgh photos → SPZ → door-plane T → look-only splat | **Blocked.** Needs a later interiors pass on **one** maze. Not Tokyo. Not FE hybrid |

**Suggested extra path:** `components/r3f-village/OsmDowntownLayer.tsx` (Phase 2 only).

### Phase 2 B — Google tiles (display only)

Founder: collaborating Google engineers said **display** of Photorealistic 3D Tiles is allowed for this project. That is **not** a right to bake meshes, heights, or collision from tiles.

- `3d-tiles-renderer` (or Cesium) in the downtown R3F scene, same camera as the OSM hull.
- Attribution: Google + `OpenStreetMap contributors`.
- Hull remains the tape. Ghost or hide extrusions when tiles are on if the boxes fight the mesh; occupancy **unchanged**.
- Do not walk tiles. Do not Recast tiles. Do not write CSV from tile geometry.

### Phase 2 C — blocked (human capture)

Team shoots accessible ground-floor rooms in **Pittsburgh** (not Street View, not Tokyo) only after a **later** interiors pass exists on **one** maze. Marble/SPZ → bake T at the **door plane** → look-only splat. Collision stays Phase 1 CSV. One room per splat. See caveats above. Do not invent 10–15 enterable doors in Cut A.

---

## Path 3 — City Sample (reference only)

- [ ] Keep stills / Matrix-city frames as the **taste ceiling**, not a checkout.
- [ ] Do not stand up Unreal + Houdini + MetaHumans + Mass as the sim.
- [ ] Pixel Stream a slice only if we ever need a **single** investor/press camera. Not every viewer.

---

## Open local notes

- Stash on this clone: `cos: local wip before PR7 Hobbs interiors` — leave it.
- Expert reviews (historical): [`R3F_expert_reviews_20260831.md`](./R3F_expert_reviews_20260831.md).
- Dining Marble world id (historical): `90f5a1bc-1fd5-4e75-b8c3-6c34e0f5fffd`.
- Collision counts on **old** maze (Phaser [B] `the_ville` only): **2064** blocked / Hobbs **58**. Downtown Phase 1 gets **new** counts from OSM raster. Do not expect 2064 on the new maze.

---


# Archive: Hobbs cinematic-on-maze (29 Aug–1 Sep 2026)

**Status (archived 2026-09-01):** Historical Hobbs look recipe. **Superseded** by the three-layer plan at the top of this file. Do not run §5b as the village path. Reviews: [`R3F_expert_reviews_20260831.md`](./R3F_expert_reviews_20260831.md).

**Repo:** https://github.com/ivan-exsy/double-r3f (`main` is the last accepted code). Local: `D:\Coding\double-r3f`.
**Do not merge this work onto** `double-front` / the production `vercel` project. Phaser stays the live spatial view until a 3D viewer actually looks like the stills.

---

## 1. Goal

Ship **cinematic-quality 3D renderings of the existing maze** — the same 140×100 ville, the same buildings, the same rooms. Doubles still walk that maze. The 3D layer is a **skin**. The maze is the **body**.

This is **not** a new village, a new art direction, or a low-poly / Phaser-pixel look. The live 3D for each building and each room must match the **quality and style** of the still already commissioned for that place.

**Look source [A] — the quality bar** (art stills, not meshes; not in this git). Rate live 3D against **that building’s / that room’s file**, not a generic “3D village” look.

| Kind | Path |
|------|------|
| **Exteriors** (per-building wides + village overhead + style lock) | `D:\Coding\double-video\video\assets\village\exterior` |
| **Interiors** (one still per room) | `D:\Coding\double-video\video\assets\village\interior` |

**How to pair.** Exterior of Hobbs Cafe → `hobbs_cafe_exterior_wide.png`. Dining → `cafe_int_dining.png`. Counter → `cafe_int_counter.png`. Same 1:1 rule for dorm, library, houses, apartments, artist studios, pub, supply, Willows, college classroom, and every other file in those folders. Village-wide style lock: `exterior/_style_frame_master.png`. Room inventory (which interior files exist): `interior/_room_inventory.md` (57 rooms DONE).

**What “match” means.** Same architecture (timber, stone, plaster, multi-gable roofs — not extruded maze cubes). Same materials and lighting (warm cinematic / golden-hour, interior glow, PBR wood and stone). Same mood as the still. If the still and the live frame disagree, the still wins.

Phaser 2D is **[B]** — the map the pictures must sit on. Production stays on Phaser until the 3D look layer actually looks like [A].

Do **not** change:

- Maze size and cells (140×100, 32px tiles)
- Collision / walkability (`collision_maze.csv`, id 32125: **2064** blocked ville-wide, Hobbs Cafe **58**)
- Sector names and footprints (`sector_maze.csv`)
- Object names and cell locations (`game_object_maze.csv` and the matching Supabase rows)
- Tiled map `public/assets/the_ville/visuals/the_ville_dec31.json`
- Persona positions, paths, and playback (Supabase + existing movement)

**North star (do not block the near-term task).** This Hobbs → village work should leave behind a **repeatable process**: add a new 3D look asset, register it to maze cells, keep style and function aligned with the stills and the map layer. Later that same process should expand this ville, stand up **new villages for new sims**, and eventually let users build or extend worlds through a **simple interface or prompts** — with freedom to make new assets, as long as they stay stylistically and functionally in the established pipeline. That product is **not** in the Hobbs pilot. Do not design a world-builder UI, prompt product, or self-serve editor before Hobbs passes taste. When choosing tools and writing `look.json` / the recipe, prefer work that a later simple UI or prompt can drive; do not pause or widen the near-term path to get there.

---

## 2. What we tried (29–31 Aug 2026)

Agents built a **low-poly village from the maze**: instanced wall cubes, grass/path/floor tiles, a 46-name object kit, then factory building shells, then a custom Hobbs Cafe of boxes and a look-dev camera. Human input was meant to be taste-only; in practice the look never left “Minecraft cafe.”

| When | What | Where |
|------|------|--------|
| Pass 1 | Collision walls + grass/path/floor, AABB boxes removed | PR 2, `main` |
| Pass 2 | 46 `game_object` kit placements (fridge GLB kept) | PR 2, `main` |
| Hobbs exterior | Custom low-poly on Phaser footprint (brick, glass, awning, sign, pitched roof) | PR 3, `main` |
| Factory shells | Dorm + library distinctive; 16 gable/shed; Johnson Park outdoor only | PR 4, `main` |
| Canvas / debug | Keep WebGL from collapsing; Klaus overlay kill | PRs 5–6, `main` |
| Hobbs interiors + tooling | Tiled dining/counter massing, `tasks.json`, factory skill, look-dev camera | PR 7, `main` |
| Hobbs “opaque storefront” | Hide collision-cave walls, solid roof, south camera | PR 8, `main` |
| Hobbs street camera | Polar/minDistance + south-facing gables | **PR 9, draft, not merged** — founder stopped here |

**Machine checks that still hold on `main`:** collision **2064 / Hobbs 58**. Tests around walls, factory shells, and Hobbs boxes are green. NPCs can still be seen inside a hollow shell. Phaser on `double-front` was never edited.

### Founder results (the quality bar)

Live `?area=hobbs-cafe` (3D flag on, ports 3000 and 3001, same `main` / PR 8 code):

1. First rate: camera in the door hole, brown collision slabs as a “cave mouth,” translucent red/grey roofs, HUD on.
2. After PR 8: cream “Hobbs Cafe” box with a giant black roof plane (camera looking down onto the gable), floating ground tiles.
3. Port 3001: camera inside the roof volume, interior visible through a **crack in the roof**. Furniture is pixelated boxes. **Nothing close to the cinematic stills.**
4. PR 9 street-camera pass: founder: **worse**. Stop.

**Verdict:** the shipped 3D Hobbs is the work that was built. There is no hidden cinematic version. It is maze-accurate and not watchable.

Open local WIP (leave it): stash `cos: local wip before PR7 Hobbs interiors` on this clone. Do not pop it onto `main` blindly.

---

## 3. Why that path cannot reach the goal

The factory treated **collision cubes as architecture** and treated stills as a palette. A still of Hobbs is a photographed cottage (multi-gable, stone, timber, glass, interior furniture). A maze cell is a 32px square. Extruding squares, then tinting them cream, will never look like the picture. More camera passes will not fix that. That is the category error.

Two jobs were mixed:

| Job | Source of truth | What we did |
|-----|-----------------|-------------|
| **Where** (walk, rooms, object cells) | Maze + Tiled + Supabase | Correct, keep |
| **How it looks** (cottage, dining room, light) | Village stills [A] | Wrong: generated from the maze |

Agents also had no **look asset** to load — only TypeScript boxes — so the only loop was “tweak boxes + camera” and ask a human. That is not a taste-final workflow; it is a modeling workflow with the human as art director.

**Stop doing:** per-sector box shells as the path to cinematic. Keep the maze/kit code as a **placement and collision scaffold**, not as the picture.

---

## 4. Architecture to evaluate (two layers)

```
  ┌─────────────────────────────────────────┐
  │  LOOK layer  (new)                      │
  │  cinematic mesh / Gaussian splat /      │
  │  photogrammetry aligned to the sector   │
  │  visual only — does not walk            │
  └─────────────────────────────────────────┘
  ┌─────────────────────────────────────────┐
  │  MAP layer  (keep)                      │
  │  collision CSV, sector AABB,            │
  │  game_object cells, NPC paths           │
  │  invisible or cheap hulls for click/nav │
  └─────────────────────────────────────────┘
```

Three.js / React Three Fiber stays the **runtime** (already in `double-r3f`). The missing piece is **authored look assets**, produced by third-party reconstructors, then **registered** (moved, scaled, rotated) onto the Phaser AABB.

- If a look asset disagrees with a still → fix the asset.
- If a look asset disagrees with the maze (door in a wall cell, table in a blocked cell) → re-register, do not edit the CSV.
- JPEG glued onto a box is still a box. Do not do that.
- Splats and photoreal tiles are **not** walkable worlds. Collision stays on the CSV (or on a hull **baked offline** from that CSV). Same rule as Spark / 3D Tiles in the mobile-worlds skill.

Phaser remains spatial **[B]** on production until the 3D look layer passes taste on Hobbs, then one more sector.

The Hobbs recipe (`look.json` + register + compose) is the seed of that later process: same steps for a new room, a new building on this maze, or a new sim village. Agents implement it for Hobbs and then copy it. They do not build the user-facing interface now.

---

## 5. Options for the expert team (historical)

**Locked.** Strawman below is kept so the kill list stays readable. Agents follow **§5b** only.

### A. Gaussian splat interiors (default to evaluate first)

**Tools:** [Spark](https://sparkjs.dev/) (`@sparkjsdev/spark`) in the existing R3F canvas; capture from stills via Luma / Polycam / Postshot / World Labs Marble (or equivalent) if we can feed the existing pictures, or a short capture pass if stills are too few for a stable splat.

**Fit:** interiors (`cafe_int_dining`, `cafe_int_counter`) and hero rooms. Splats sit in the same scene as opaque NPC meshes (`depthTest: true`, NPC writes depth). Visual only.

**Needs:** origin + quaternion (captured Z-up → Three Y-up, often 180° on X) and a scale that maps the room to the Hobbs AABB. Optional: `splat-transform` CLI to bake a **hidden** collision hull; do **not** Recast the splat itself.

**Risk:** few stills → holes, fly-throughs, “crack in the roof.” Expert team must say whether current village stills are enough or we need 20–50 more views per room.

### B. Image-to-mesh (object and facade kits)

**Tools:** Meshy / Rodin / Tripo / Hunyuan3D / similar, plus in-repo Quaternius for generic props. Output compressed glTF (Draco + meshopt + KTX2 via `gltf-transform`).

**Fit:** furniture and distinctive facades when we have a clean still of **that object**. Place with `game_object_maze.csv` cells (same as today’s kit).

**Risk:** one still → wrong back side. Use only where the camera will not orbit the missing side, or generate a turntable first.

### C. Multi-view photogrammetry → glTF

**Tools:** COLMAP / RealityCapture / Polycam mesh export, then Blender cleanup.

**Fit:** exteriors if we get a ring of views. Current overhead + one Hobbs wide shot is probably **not** enough. Expert team: still count vs mesh quality.

### D. Keep low-poly factory (current `main`) as **scaffold only**

Cheap collision/occlusion hulls and NPC floors so Doubles do not float. Hidden or very simple when the look layer is on. **Not** the picture the founder rates.

### E. Do not use (as walkable world)

Cesium / Google 3D Tiles as the village you walk. Earth backdrop is a later, separate ticket. Do not replace `collision_maze.csv` with live Recast on splats or tiles. Do not merge onto `double-front` `vercel`.

**Historical strawman (superseded 2026-08-31).** A survives only as “splat in Spark.” B is dead for the cafe shell (Meshy not on Hobbs). C is dead for current stills. D stays as hidden hull. E stays banned. Locked recipe: **§5b**.

---

## 5b. Locked Hobbs recipe (2026-08-31)

**Stack:** World Labs Marble → Gaussian SPZ → Spark `@sparkjsdev/spark@2.1.0` in the existing R3F canvas. Maze collision CSV = **hidden hull** (walk). Marble collider GLB = **register/debug only**, never gameplay collision. Rating camera is a **stored pose**. Human gate = pass/fail vs the still.

**Public Marble model ids:** `marble-1.1`, `marble-1.1-plus`, `marble-1.0`, `marble-1.0-draft`. Always pass `model` (omit still defaults to `marble-1.0`). Plus = larger outdoor coverage, not a quality synonym.

**Model sequence (do not skip):**
1. First Hobbs run = **`marble-1.1` only** (dining).
2. After dining (and ideally counter) **passes taste**, exterior = `marble-1.1-plus`.
3. If a `1.1` exterior is clipped / too small, regenerate **that asset** on plus. **Do not start with plus.**

**Meshy:** **no** for Hobbs. Buy only if a named `game_object` is empty in the splat **and** must exist as a mesh. No parallel fridge/sign/door/piano.

**Register (week one):** authored markers only (door center, counter edge / floor corners as applicable). Uniform scale + yaw + translation. No non-uniform scale, shear, or CSV edits. AABB is a sanity check. Collider-raycast auto-detect is **not** a week-one gate.

**Numeric gates:** first three assets **loose** — door ≤ **0.5** cell, RMS ≤ **0.5** cell. After one room passes taste, tighten to door ≤ **0.15** cell, RMS ≤ **0.25** cell. Walls **may** occupy blocked cells. Test walkable-looking floor and functional objects vs walkability. Collision counts stay **2064 / 58**.

**Style:** `text_prompt` required in our recipe. Never multi-image `_style_frame_master` or village overhead into Hobbs.

**Taste:** environment pass with **NPCs off**. Walk/depth is a separate check. NPC/prop IBL = generated pano. Splat stays baked / unlit. No second sun on the cottage.

**Fallback capture (only if 4 seeds fail taste or register).** Agents may request **only** this: interior — one 360 pano (≥2560×1280, room center); exterior — four cardinals (0/90/180/270) **or** ≤30s orbit. No 8–12 stills / 20–40s mix.

**Spark:** pin `@sparkjsdev/spark@2.1.0` (npm, MIT). Rust-crate vs MIT = later legal, not a Hobbs block.

**Dead:** SHARP, VGGT, HY-World 2, HQ mesh as default, Chisel-in-Studio for Hobbs, COLMAP, Meshy-on-shell, factory-as-picture, Recast-on-splat, JPEG-on-box, `marble-1.0-draft` for a rating frame.

**Buy:** World Labs key already in local env `MARBLE_API_KEY` (never commit, never paste into chat/docs). Meshy: no. Spark: npm.

**Later door (do not close):** one still + style text + sector footprint → same generate → same `look.json` register. Do not lock non-uniform scale, Blender-as-SOT, or a hand-sculpted cafe with no generator. Chisel is layout-later, not this recipe.

### First generate (do this, nothing else)

One room: **dining**. Still: `cafe_int_dining.png`. Upload as a **media asset** (do not `uri` a local path). `is_pano: false`. Output dir: `public/assets/the_ville/3d/look/hobbs/dining/` (untracked stills stay in `tmp-stills/`; **do not commit** stills or API keys).

```
POST /marble/v1/worlds:generate
model: "marble-1.1"
seed: 1
display_name: "hobbs-dining-seed1"
world_prompt.type: "image"
world_prompt.image_prompt.source: "media_asset"
world_prompt.is_pano: false
world_prompt.text_prompt:
  "Same cafe interior as the photo. Warm Tudor cottage, timber beams, plaster walls, stone plinth, golden-hour interior light, wooden tables and chairs. Do not change the room layout, materials, or camera. No people, no animals, no extra storefront."
```

Seeds **1–4** then stop. Same still, same prompt, only `seed` changes. `display_name`: `hobbs-dining-seed{N}`.

**Download immediately** (do not keep vendor URLs):
- Rating: `full` SPZ (`spz_urls.full_res`)
- Look-dev iterate: `500k` SPZ
- Skip `100k` except debug
- Collider GLB (register/debug only)
- `imagery.pano_url`
- Write `semantics_metadata` (`metric_scale_factor`, `ground_plane_offset`) into `look.json`
- Do **not** HQ / full-res mesh export

**`look.json.coord_basis` from day one** (`opencv` | `opengl` | `unknown`). Current export-specs still say OpenCV (+X left, +Y down, +Z forward); other notes say OpenGL. Try **identity** in Three. If the room is upside-down, apply Y×−1 and Z×−1, set basis to `opencv_to_opengl`, freeze it. Do **not** hard-code 180° X.

**Stop (do not retry the same body):**
- HTTP `400` content policy / unreadable image
- `402` credits
- `422` schema
- operation `done` + `error` (empty/missing `spz_urls`)
- 4 seeds, still fail taste or register
- ToS / commercial-use rejection

Backoff only on `429` and one `500`. Log `request_id`, **redact the key**.

**Do not:** Chisel GUI, HQ mesh, plus on this first call, three rooms in one world, style-lock/overhead as extra images, Meshy, whole village, `marble-1.0-draft` “to save money” for a rating frame.

---

## 6. Agent workflow (human = taste only)

One sector/room at a time. Hobbs Cafe is the pilot until it **passes**. Do not factory the other 18 interiors on the old box recipe.

### Inputs (agents may read; they must not invent)

| Input | Where |
|-------|--------|
| Maze / collision / objects | `public/assets/the_ville/matrix/maze/*.csv` + Tiled JSON |
| Stills [A] | Exterior: `D:\Coding\double-video\video\assets\village\exterior`. Interior: `D:\Coding\double-video\video\assets\village\interior`. Copy into untracked `tmp-stills/` for the job; **never commit**. Pair each 3D room to **that file**. |
| Sector AABB | `sector_maze.csv` cluster; Hobbs helper `HOBBS_CAFE_SECTOR_BOUNDS` |
| Object cells | `game_object_maze.csv` |
| Runtime | `double-r3f` R3F canvas, flag `NEXT_PUBLIC_USE_R3F_VIEWER=true` |

### Steps (every room)

Follow **§5b**. First room is dining only until that generate is explicitly kicked off.

1. **Inventory** — one hero still for this room. If missing, **stop**. Do not extrude the maze. Do not use style-lock/overhead as extra images.
2. **Generate look** — Marble World API per §5b (`marble-1.1` until the model sequence allows plus). Write SPZ + collider + pano + `look.json` under `public/assets/the_ville/3d/look/<sector>/<room>/`.
3. **Register to maze** — authored markers; uniform scale + yaw + translation. Loose 0.5/0.5 until one room passes taste. Walls may occupy blocked cells. Collision counts stay **2064 / 58**. Fail register after 4 seeds → stop; request only the §5b fallback capture.
4. **Compose** — Spark `SplatMesh` + hidden hull + generated-pano IBL for NPCs/props. Splat unlit. **NPCs off** in the environment rating frame. No factory gables in the rating frame.
5. **Rating camera** — stored pose (dining vs counter vs south-of-storefront exterior). HUD off unless `?debug=1`.
6. **Machine checks** — vitest: collision counts; `look.json` present (seed, model, `coord_basis`, metrics); transform finite, uniform scale > 0.
7. **Human taste** — founder compares live vs still. Pass / fail. Fail → new seed or re-register, never the maze.

After Hobbs **pass**, copy `look.json` + the compose step into the factory skill and run the next sector that has stills. Johnson Park stays outdoor kit only.

### What agents must not ask the human

Camera math, palette, whether to hide debug, which Tiled layer, whether to merge to vercel, whether to edit collision. Those are closed.

### What agents must stop and ask

- Stills missing
- HTTP 400/402/422, operation error, ToS rejection, or 4 seeds fail (§5b stop list)
- A look asset that cannot hit door/counter without moving a maze cell
- Fallback capture only after 4 seeds fail (pano / four cardinals — nothing else)
- Anything that would edit `double-front`, production `vercel`, or Supabase maze rows
- Meshy / plus-on-first-call / HQ mesh / Chisel — those are closed **no**, not questions

Do **not** stop Hobbs to spec or build a user world-builder, prompt-to-village product, or self-serve editor. That is later. If a tool choice would make that later path impossible, note it once for the expert team and keep shipping the pilot.

---

## 7. Clear path

### Now (locked recipe; no more box-factory)

- [x] Pause Hobbs TypeScript-box iteration (PRs 7–8 on `main` are a scaffold; **do not merge PR 9**)
- [x] Expert team: two written picks + follow-up lock ([`R3F_expert_reviews_20260831.md`](./R3F_expert_reviews_20260831.md), charter §5b)
- [x] **Founder lock 2026-08-31** — suggested merge with row 2 (start `1.1` only) and row 4 (loose gates week one)
- [x] **First generate:** dining `marble-1.1` seed 1 world `90f5a1bc-1fd5-4e75-b8c3-6c34e0f5fffd`. Taste pending.
- [ ] Dining taste pass (NPCs off) → counter on `marble-1.1` → exterior on `marble-1.1-plus`. If a `1.1` exterior is clipped / too small, regen **that** asset on plus. Never start the Hobbs sequence on plus.
- [ ] Register with authored markers; Spark 2.1.0 compose; freeze `look.json` + tests after first pass
- [ ] Then factory other rooms **that have stills**, same recipe, no per-building taste forks

### After the village reads as the stills

- [ ] Playback polish (idle/walk on existing characters; paths still on collision CSV)
- [ ] Optional dedicated preview URL — not required to keep coding
- [ ] Only then discuss replacing Phaser [B] on `double-front`

### Explicitly later

- [ ] **World expansion / user worlds** — same look+map process to add assets to this maze, build new sim villages, then a simple interface or prompts so users can expand or create worlds. Style and function stay aligned with the established stills and registration pipeline. Freedom to author new assets; not a free-for-all that bypasses the maze or the look bar. **Not a Hobbs blocker.**
- [ ] Photoreal Earth / Cesium / Google 3D Tiles as a walkable world
- [ ] Recast replacing `collision_maze.csv`
- [ ] Spark Rust-crate vs MIT license check — before production launch, not a Hobbs block
- [ ] Self-serve Double / MatrAIx as a **product** surface (Spark/Marble as **look tools** for this village are in scope per §5b)

---

## 8. Expert questions — closed 2026-08-31

Lock: [`R3F_expert_reviews_20260831.md`](./R3F_expert_reviews_20260831.md) + §5b.

1. Stills enough to start Hobbs: **yes**. Fallback only after 4 seeds: one 360 pano (interior) or four cardinals / ≤30s orbit (exterior).
2. NPCs: **off** for environment taste. Walk/depth separate. Character treatment later, before Phaser is replaced.
3. Mobile: desktop-only for Hobbs. Spark WebGL2 later; not WebGPU Safari as a pilot dependency.
4. Unattended: Marble World API. Spark `@2.1.0`. No Blender in steady state.
5. Register: authored markers week one; AABB sanity; loose 0.5 then GPT 0.25/0.15. Not AABB-only.
6. Later door: one still + style text + sector footprint → same generate → same `look.json`. Chisel later. No world-builder UI before Hobbs passes.

---

## 9. DONE (keep; newest last)

These remain true as **map-layer** work. They are not the cinematic look.

- [x] Dedicated R3F repo + local clone (`ivan-exsy/double-r3f`, `D:\Coding\double-r3f`)
- [x] Flag-gated R3F canvas, 140×100 CSVs, 19 sector footprints, 46 prefab names, Hobbs fixture NPC
- [x] Pass 1 — Phaser-matching walls and ground (PR 2)
- [x] Pass 2 — 46 game_object kit (PR 2)
- [x] Hollow AABB shells superseded by pass 1 (PR 1)
- [x] Hobbs low-poly exterior on Phaser footprint (PR 3) — **scaffold; failed taste as the picture**
- [x] Factory shells for remaining sectors (PR 4) — **scaffold; same**
- [x] Hobbs interiors + look-dev camera tooling (PR 7–8) — **scaffold; founder stop 2026-08-31**
- [x] Look pipeline lock 2026-08-31 — Marble → SPZ → Spark 2.1.0; first call = dining `marble-1.1` (§5b)
- [ ] PR 9 street camera — **not merged; do not continue this loop**

---

## 10. Review helpers

```bash
cd D:\Coding\double-r3f
git checkout main
$env:NEXT_PUBLIC_USE_R3F_VIEWER="true"
npx next dev -p 3001
```

- Current (failed) 3D Hobbs: http://localhost:3001/simulations/demo?area=hobbs-cafe
- Dorm / library scaffolds: `?focus=dorm` `?focus=library`
- Phaser [B] production stays on `double-front`. Do not point the 3D flag at vercel.

When a look-layer pilot exists, add its URL here and **that** is what the founder rates against the stills.
