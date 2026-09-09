> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# R3F Ville — expert reviews (2026-08-31)

**Status:** **LOCKED 2026-08-31** (founder + expert follow-up). Recipe lives in [`R3F_TODOs.md`](./R3F_TODOs.md) §5b. Do not generate until an agent is told to run §5b first call (dining only).

**Charter:** [`R3F_TODOs.md`](./R3F_TODOs.md)  
**Reviewers:** Grok (world-model / splat stack) · GPT (same stack, tighter ops) · follow-up lock (this section)

Both overwrite charter §5 options A–E. Full texts remain below. Decision table + lock are first.

---

## Consensus (both said this)

| Topic | Both |
|-------|------|
| Look | **World Labs Marble** → Gaussian **SPZ** (not mesh-from-maze, not COLMAP) |
| Runtime | **Spark** (`@sparkjsdev/spark`) in the existing R3F canvas |
| Walk | Existing collision CSV as **hidden hull**. Splat does not walk. Marble collider GLB is **not** gameplay collision. |
| Photogrammetry (C) | Dead for current still count |
| Image-to-mesh of the **building** (B as cafe) | Dead |
| JPEG-on-box / factory as the picture | Dead |
| Cesium / 3D Tiles / Recast-on-splat | Dead |
| Stills enough to **start** Hobbs? | **Yes.** Do not stop to shoot 20–50 views first. |
| AABB-only register | **Not enough** for doors. Need named markers + **uniform** scale + yaw + translation. |
| Chisel | Right idea for maze-true layout later. **Not** first-class on the public generate API today. Do not block Hobbs. |
| World-builder UI | After Hobbs. Same API later is the door. |
| Steady-state Blender | No |
| Pilot | Three files: `hobbs_cafe_exterior_wide` / `cafe_int_dining` / `cafe_int_counter` |
| Fail | Regenerated seed or re-register. Never edit the maze. |

That is **D + Marble-splat**, not “A as written” (Luma / Polycam / Postshot as capture trainers).

---

## Where they disagreed → lock (2026-08-31)

| # | Topic | Lock |
|---|--------|------|
| 1 | Marble model | **GPT split, delayed:** first Hobbs run = `marble-1.1` only. After dining (ideally counter) passes taste, exterior = `marble-1.1-plus`. If a `1.1` exterior is clipped/too small, regenerate that asset on plus. **Do not start with plus.** Public ids: `marble-1.1`, `marble-1.1-plus`, `marble-1.0`, `marble-1.0-draft`. Always pass `model` (omit defaults to `marble-1.0`). Plus = larger outdoor coverage, not a quality synonym. |
| 2 | Meshy on Hobbs | **GPT — skip.** No parallel fridge/sign/door/piano. Buy Meshy only if a named `game_object` is empty in the splat **and** must exist as a mesh. |
| 3 | Markers | **Grok / merge — authored only week one.** Auto+raycast later. Don’t burn seeds waiting on a detector. |
| 4 | Numeric gates | **Neither — loose then GPT.** First three assets: door ≤ **0.5** cell, RMS ≤ **0.5** cell. After one room passes taste: 0.25 / 0.15. Walls may occupy blocked cells. |
| 5 | Fallback capture | **GPT — one list.** Interior: **one** 360 pano (≥2560×1280, room center). Exterior: **four cardinals** (0/90/180/270) **or** ≤30s orbit. No Grok 8–12 stills / 20–40s mix. |
| 6 | Style lock | **GPT / merge.** Style = **text only**. Never multi-image `_style_frame_master` or village overhead into Hobbs. |
| 7 | NPC taste | **GPT.** Environment pass: NPCs **off**. Walk/depth is a separate check. People in the still are poorly supported. |
| 8 | NPC lighting | **GPT.** NPC/prop IBL = generated pano. Splat stays baked / unlit. No second sun on the cottage. |
| 9 | Spark | **GPT + pin.** `@sparkjsdev/spark@2.1.0` (npm, MIT). Rust-crate vs MIT is a **later legal** check, not a Hobbs block. |
| 10 | Kill list | **GPT stands.** Dead: SHARP, VGGT, HY-World 2, HQ mesh as default, Chisel-in-Studio for Hobbs, COLMAP, Meshy-on-shell, factory-as-picture, Recast-on-splat. |

---

## Locked merge (2026-08-31)

Normative copy is [`R3F_TODOs.md`](./R3F_TODOs.md) §5b. Summary:

1. **Stack:** Marble → SPZ → Spark `@2.1.0`; maze hull hidden; collider GLB = register/debug only.  
2. **First generate:** dining only, `marble-1.1`, seed 1–4, still `cafe_int_dining.png` as media asset, required `text_prompt`, `is_pano: false`. Exterior plus only after dining (ideally counter) passes.  
3. **Generate:** one hero still + style **text**. Never multi-image overhead/style frame.  
4. **Register:** authored markers week one; uniform similarity; loose 0.5/0.5 then tighten; AABB sanity. Collider-raycast is not a week-one gate.  
5. **Meshy:** no for Hobbs.  
6. **Taste:** live stored pose vs that still. NPCs **off** for environment pass.  
7. **Fallback shoot:** GPT’s one list only.  
8. **Buy:** World Labs key already held. Meshy: no. Spark: npm.

---

## Full text — Grok

The box-factory path cannot hit those stills. The 2026 stack that can is a **world model → splat look layer**, not another mesh-from-maze loop. One pipeline for interiors and exteriors. Props are the only place image-to-mesh belongs.

## Verdict (overwrite A–E)

| Layer | Pick | Role |
|---|---|---|
| **Look (interior + exterior)** | **World Labs Marble 1.1** → Gaussian splat (`.spz` / `.ply`) | Generate the picture from the still |
| **Runtime** | **Spark** (`@sparkjsdev/spark`) in the existing R3F canvas | Draw that splat next to opaque NPCs |
| **Map / walk** | Existing collision CSV as a **hidden hull** (your D) | Characters walk. Splat does not. |
| **Discrete props only** | **Meshy 7** Image-to-3D API → compressed glTF | Fridge, sign, moving door, piano *if* the splat cannot hold them |
| **Do not use as the picture** | Factory boxes, JPEG-on-box, COLMAP, Cesium/3D Tiles, Recast-on-splat | Dead for this goal |

That is **D + Marble-splat**, with Meshy only for named objects. It is not “A as you wrote it.” Luma / Polycam / Postshot are capture trainers. You already have commissioned stills. You need a **generative world model that lifts one still into a persistent room**, not a photogrammetry orbit you do not have.

Marble is the tool that changed the answer in 2026: persistent, downloadable worlds from a **single image**, plus multi-image, video, panorama, or coarse 3D layout; exports splat + collider mesh + optional HQ mesh; public **World API**; official coding-agent skill. Spark is World Labs’ Three.js renderer and is built to composite splats with triangle meshes via the Z-buffer. That pairing is the stack, not a coincidence.

### 1. Tools

#### Primary — World Labs Marble (look)

**Why it wins now, not in 2024.** Feed-forward object meshing (Meshy / Tripo / Rodin / Hunyuan) still invents the unseen side of a *building or room*. Classic photogrammetry needs a ring of views you do not have. Marble is a **world model**: one still of Hobbs dining becomes a navigable interior with timber, light, and furniture already in the picture. Generation is ~5 minutes for a full world (~20s draft). Models as of April 2026: `marble-1.1` (default), `marble-1.1-plus` (larger worlds), `marble-1.0`, `marble-1.0-draft`. Seed is first-class.

**Inputs the API actually accepts:** text, single image (URI or uploaded media asset), multi-image, panorama, video. Image formats: jpg / jpeg / png / webp. Optional `text_prompt` beside the still to lock style (“warm Tudor cottage cafe, golden hour, timber beams, stone plinth”). Official CLI examples exist (`generate-world-from-image.js/.py`). Official agent skill: `npx skills add worldlabsai/marble-developer-api-skill`.

**Outputs to keep:**
- **Visual:** SPZ (~2M or 500k) or PLY. SPZ is native and what Spark wants. Use 500k for look-dev, full-res for the rating frame.
- **Metadata:** `semantics_metadata.metric_scale_factor` and `ground_plane_offset` — use these; do not invent scale.
- **Collider GLB (100–200k tris):** download it, **do not walk on it**. Walk stays on the maze hull.
- **HQ mesh (~600k textured / ~1M vertex-color, ~1 hr, Pro plan):** fallback only if a rating pose shows splat holes. Not the pilot default.

**License / cost (Aug 2026 ballpark):** product UI from free (generate, no export) through Standard ~$20 and Pro ~$35; World API is credit-billed separately (~$1.20–1.28 per standard world, drafts ~10× cheaper). Export requires a paid plan. Pro unlocks HQ mesh and commercial rights. Confirm current numbers on their billing page before buying; they move.

**CLI vs GUI:** World API is the automation path. Chisel (block out rooms with boxes / imported GLB, then generate) is the **layout lock** you want later. Chisel is solid in Studio; it is **not fully first-class on the public generate schema yet**. Do not block Hobbs on Chisel. Use image-only for the pilot; add Chisel when the API exposes 3D-structure generate, or run Chisel once in Studio and treat the exported world as the look asset.

#### Runtime — Spark 2.x

MIT, WebGL2, official R3F example (`sparkjsdev/spark-react-r3f`). `SparkRenderer` + `SplatMesh`. Multiple splat objects sort together and merge with opaque Three meshes through the depth buffer — that is the NPC requirement. Formats: `.spz`, `.ply`, `.splat`, `.ksplat`, `.sog`. Uniform scale only on `SplatMesh` (averages xyz) — which matches your “one uniform scale” register rule. Targets ~98% WebGL2, including phones. Desktop-only for Hobbs is fine; this does not kill a later phone village.

Three.js r186 is adding native `GaussianSplat` / `SPZLoader`. Do **not** switch mid-pilot. Spark is the World Labs pair, already composites with meshes, and is what their own examples use.

#### Props only — Meshy 7 Image-to-3D API

Meshy 7 landed on the image-to-3D and multi-image APIs in mid-August 2026. `POST /openapi/v1/image-to-3d` → poll → `model_urls.glb`. Flags you want: `enable_pbr`, `should_remesh`, `target_polycount`, `target_formats: ["glb"]`. Then `gltf-transform` (Draco + meshopt + KTX2) into the existing kit path. Paid from ~$20/mo; API key workflow. Use this for **objects**, never for the cafe shell.

Tripo and Rodin are acceptable substitutes if Meshy fails a specific prop. Hunyuan3D / TRELLIS.2 are the self-host escape hatch if you later refuse vendor lock on *props*. Do not self-host a world model for Hobbs.

#### Hidden scaffold — keep what you have

Collision cubes, sector AABB, NPC floors: **invisible when the look flag is on**. That work is not wasted. It is the map layer.

### 2. Inputs — are the attached stills enough?

**Yes to start Hobbs. No if you demand a hole-free orbit of the whole cottage.**

Marble is trained to lift **one image** into a world. Your three Hobbs stills are exactly the kind of input it wants: clear architecture, floor/walls/ceiling, furniture, lighting. The dining and counter frames already read as rooms; the exterior wide is a hero facade. Village overhead and `_style_frame_master` are style locks, not capture orbits.

What one still cannot do:
- True backside of Hobbs
- The roof volume the camera must not fall into
- Metric door width matching a 32px cell without a register step

That is acceptable **if the rating camera is the still camera** (south of storefront, below eave, through glass; dining pose; counter pose). You rate the frame the founder already painted. You do not rate a fly-through of invented walls.

**Do not stop Hobbs to shoot more pictures.** Run Marble on the three attached files first. If the live rating frame fails because of holes / wrong layout — not because of “Minecraft boxes” — then shoot the set below once.

#### One-time capture spec (only if Marble-from-stills fails taste)

Shoot this once. Agents never wait on art direction again.

**Per interior room (dining, counter, then later the other 55):**
- 20–40 seconds of handheld video, slow, overlapping, **or** 8–12 stills
- Must include: the existing hero still angle, both front corners, both back corners, doorway looking in, doorway looking out, ceiling/beams, floor plane, the counter front edge
- Same lighting as the still (warm interior, no flash)
- Optional: one 360 pano from room center (Marble accepts `is_pano`)

**Per exterior (Hobbs, then dorm/library):**
- Existing wide + overhead keep
- Add 8 stills in a half-ring on the rating side (south for Hobbs), two heights (eye + eave)
- One three-quarter of each gable end
- Do **not** need a full 360 photogrammetry orbit

**Do not shoot:** LiDAR, drone orbits, night passes, “more cameras for the box model.”

Video under 100MB is a first-class Marble input and is the cheapest way to kill backside holes.

### 3. Maze registration

**One AABB fit is not enough for doors. Three authored markers plus uniform scale is the Hobbs recipe. Chisel-from-maze-boxes is the later upgrade, not a gate.**

#### Hobbs register (close this)

Store in `look.json`, one transform per look asset:

```text
position: [x, y, z]     // Three.js world, maze origin you already use
quaternion: [x, y, z, w]
scale: s                // uniform only
```

**Fit procedure (automated, then marker refine):**

1. Take sector AABB from `sector_maze.csv` / `HOBBS_CAFE_SECTOR_BOUNDS`.
2. Load splat. Apply Marble `metric_scale_factor` and `ground_plane_offset` first.
3. Uniform-scale so the splat ground rectangle covers the sector floor AABB (2D IoU max). Y: ground plane onto maze floor Y.
4. Yaw only around Y until the storefront faces the same world +Z/−Z as the maze door cells.
5. Translate so the splat door opening sits over the maze door cell center.

**Markers (author once per room, store in `look.json`, reuse forever):**

| Marker | In the still | In the maze |
|---|---|---|
| Door center | front door / interior doorway | door cell centroid |
| Counter front edge midpoint | counter still | counter object cells |
| Two floor corners | visible room corners | corresponding walkable cells |

Three correspondences give you yaw + uniform scale + translation. That is enough. Do not let agents invent extra degrees of freedom (non-uniform scale, shear, per-vertex warp). If the look cannot hit door *and* counter without moving a maze cell → **stop and ask**. Do not edit CSVs.

**Collision rule:** splat may overlap a blocked cell in *air* (roof, beams). Splat centers must not occupy walkable-floor cells as solid furniture beyond ε unless that cell is already an object cell. Check in XZ at floor Y only. Counts stay **2064 / 58**.

**Coordinates (the footgun):**
- Three.js / R3F: Y-up, OpenGL.
- Marble world export was moved to **OpenGL** (Dec 2025 / Jan 2026). Prefer that export. If a batch comes out upside-down, the documented OpenCV→OpenGL fix is scale Y and Z by −1.
- Spark samples often set `quaternion.set(1, 0, 0, 0)` (180° about X) for Z-up captures. Try identity first on Marble OpenGL exports; keep 180° X as a `look.json` flag, not a code fork.
- `SplatMesh.scale` is uniform. Good.

**Chisel later:** export the Hobbs collision hull as a coarse GLB of boxes (already in the factory). Import as Chisel structure + the still as style. That is how layout stays maze-true while look stays still-true. Note it for the expert log; do not pause Hobbs for it.

### 4. Runtime (R3F)

Compose, in this order:

1. Hidden maze hull (no material, or `visible={false}`). Raycast/nav only.
2. `SparkRenderer` once per canvas.
3. One `SplatMesh` per look asset (`hobbs/exterior`, `hobbs/dining`, `hobbs/counter`), transform from `look.json`.
4. Existing opaque NPC meshes. They write depth. Spark composites against that Z-buffer. Do not set splat `depthTest: false`.
5. Prop glTFs only where the splat is empty and the object is a named `game_object`.
6. Rating camera from `look.json` (`?area=hobbs-cafe` loads the stored pose). HUD off unless `?debug=1`.

**Lighting:** the splat is **pre-lit** (golden hour is baked into the still). Do not add a second sun that relights the cottage. Light NPCs with a small local rig that *matches* the still’s key direction so they don’t look like plastic toys in a photograph. Do not try to make the splat PBR-respond to scene lights.

**What to load when:**
- Exterior splat for the street rating pose; hide interior splats or don’t mount them.
- Interior splat for dining/counter poses; exterior can stay as the windows’ outside if it doesn’t fight.
- Do not mount all 57 rooms at once. Sector streaming comes after Hobbs passes.

**Mobile:** Spark on WebGL2 is acceptable later. Pilot = desktop. Safari WebGPU is not required. A splat village on phone is a size/LoD problem (use 500k SPZ + Spark 2 LoD), not a “wrong engine” problem.

**Do not** replace this with Cesium, 3D Tiles, or a custom splat shader.

### 5. Automation (stills + bounds in → asset + sidecar out)

Agent loop for one room. Human only says pass/fail vs the still.

```text
1. inventory
   stills = pair(room → file)   # hobbs exterior / dining / counter
   if stills.length == 0: STOP and ask
2. generate
   upload still as media_asset
   POST /marble/v1/worlds:generate
     model: marble-1.1
     seed: recorded
     world_prompt.type: image
     text_prompt: style lock from _style_frame_master + room name
   poll Operation until done
3. export
   download SPZ (500k + full_res)
   download collider GLB (archive only)
   write look.json { tool, model, seed, world_id, still, metrics }
4. register
   apply metric_scale_factor + ground_plane_offset
   AABB fit → marker refine
   write transform into look.json
5. compose
   R3F: SplatMesh + hidden hull + NPCs
   load stored rating camera
6. machine checks
   collision counts 2064 / 58
   transform finite, uniform scale > 0
   look AABB overlaps sector AABB
   rating camera south of storefront maxZ, below eave Y (exterior)
   screenshot to artifacts
7. human
   live frame vs still. pass / fail
   fail → change asset or register, never the maze
```

**Cannot automate:** taste; buying the World Labs / Meshy keys; a look that physically cannot put a door on a door cell; Chisel-in-Studio if you choose to use it before the API grows a 3D-structure prompt.

**Do not automate:** camera hunting, palette debates, HUD, merging to production Phaser.

World Labs even documents an “Image Blaster” agent skillset (image → splat + meshes). Steal the shape, keep your maze hull.

### 6. Later path (one paragraph, not a product spec)

Keep the contract **still + optional maze boxes → Marble world → `look.json` transform → Spark**. That is already prompt-shaped: a user or agent can hand a picture (or a sentence plus the style lock) and a sector footprint to the same World API, get a splat, and snap it with the same register. Meshy’s image-to-3D API does the same for props. Do **not** pick a pipeline whose only authoring surface is “open Blender.” Chisel is the control knob for *layout* when you generate new villages; the World API is the control knob for *look*. A choice that would close that door: baking Hobbs as a one-off hand-sculpted glTF with no generator in the loop. A choice that keeps it open: Marble + Spark + `look.json`, even if Chisel stays Studio-only for six months.

### 7. NPCs

**Leave the current low-poly / Quaternius people inside the photoreal rooms for Hobbs.**

A style clash is real. It will not be why Hobbs fails. Hobbs will fail if the *room* is still boxes. Film and games live with stylized figures in photographed sets; founder has not locked a character treatment. Matching NPC look is a later ticket (image-to-mesh characters, or a splat-safe impostor). Do not commission a character pipeline before the cafe still matches.

If the rating frame makes the people look like toys and that is the *only* fail, swap them for unlit / toon-lit meshes that pick up the still’s palette. Still do not rebuild the village as people.

### 8. Kill list

| Thing | Why it’s dead here |
|---|---|
| TypeScript box factory as the picture | Category error. Maze cell ≠ cottage. |
| JPEG / still glued on a box | Still a box. |
| **Classic photogrammetry (C) as the Hobbs pipeline** | 1 exterior + 1–2 interiors is not a reconstruction set. COLMAP / RealityCapture / Polycam-mesh will hole out. |
| **Image-to-mesh of the whole cafe (B as the building)** | Back side and interior volume are invented. Fine for a mug. Fatal for a rating orbit or a window. |
| Luma / Polycam / Postshot as the *primary* look tool | Those reconstruct from *new capture*. Luma’s energy is video now; you already paid for stills. Use them only if you later shoot the video set and Marble’s image path fails. |
| Cesium / Google 3D Tiles as the village | Wrong scale, wrong license, wrong collision. Earth backdrop is a different ticket. |
| Live Recast on splat or HQ mesh | Replaces 2064/58. Forbidden. |
| Mixing Marble + Meshy-building + COLMAP on the three Hobbs rooms | Three looks, three failure modes. One recipe. |
| Waiting on Three.js r186 native splats | Spark is shipping and paired. |
| World-builder UI, prompt product, self-serve editor | After Hobbs passes. |
| Merging any of this onto production Phaser / vercel | Out of scope. |

**Strawman A** survives only as “splat in Spark,” not as “capture with Luma.” **B** survives only for props. **C** is dead for current still count. **D** stays as hull. **E** stays banned.

### Hobbs recipe to hand engineers

**Pilot assets (exactly three):**
- `hobbs_cafe_exterior_wide.png` → `look/hobbs/exterior/`
- `cafe_int_dining.png` → `look/hobbs/dining/`
- `cafe_int_counter.png` → `look/hobbs/counter/`

**Per asset:** Marble 1.1 from that file + short style prompt; export full-res SPZ; register with AABB + door/counter markers; Spark `SplatMesh`; stored rating camera; hidden maze hull; current NPCs.

**Pass criterion:** founder compares the live stored pose to that file. If it fails, regenerate (new seed) or re-register. Do not extrude another gable.

**After pass:** freeze `look.json` schema, the generate/export commands, the compose component, and the tests. Copy to the next room that already has a still. Johnson Park stays outdoor kit.

Buy: World Labs Pro (or Standard + API credits) and a Meshy key. That is the only human purchase. Everything else is agent work plus one taste gate.

---

## Full text — GPT

I reviewed the charter, the three stills actually attached here, and the current 2026 tool landscape. The charter's architectural split is correct: the maze remains the spatial truth, and the cinematic layer is a replaceable visual skin. I would preserve the 2064/58 collision invariants exactly and stop trying to derive architecture from those cells.

## Recommendation in one sentence

**Use World Labs Marble → Gaussian SPZ → Spark/Three.js as the Hobbs look pipeline, with the existing maze as the hidden map/collision layer.**

More specifically:

* **Interiors:** World Labs **Marble 1.1** → full/500k SPZ → **Spark 2.x**
* **Exteriors:** World Labs **Marble 1.1 Plus** → full/500k SPZ → **Spark 2.x**
* **Registration:** semantic anchors + one rigid/uniform similarity transform; **not AABB fit alone**
* **Collision:** your existing maze, unchanged
* **Marble collider GLB:** registration/raycast/debug only, never gameplay collision
* **Meshes:** not the primary Hobbs representation
* **Blender:** not in steady-state
* **Photogrammetry:** not for the stills you currently have

That is essentially your proposed **D + A**, but I would replace the vague "Luma / Polycam / Postshot splat capture" part with **World Labs' current generative world API**. Marble's public World API is specifically designed to turn a single image, multiple images, a panorama, or video into a navigable 3D environment and export it into downstream applications.

### 1. Tools

#### Picked stack

| Tool | Use | Automation | Cost / license | Verdict |
| ----------------------------------- | ---------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------ |
| **World Labs Marble 1.1** | Hobbs dining + counter | REST API | Standard image→world: 1,580 credits ≈ **$1.26/generation**. Paid/API outputs can be commercially used. | **Pick for interiors** |
| **World Labs Marble 1.1 Plus** | Hobbs exterior | REST API | Typically **$1.26–$2.48/generation** depending on world size. | **Pick for exteriors** |
| **Spark 2.x / `@sparkjsdev/spark`** | Render SPZ inside existing Three.js/R3F canvas | npm / code | Repository/package is presented as MIT; see licensing caveat below | **Pick for runtime** |
| Existing maze scaffold | Floor/collision/NPC paths | Already automated | Existing code | **Keep, hidden** |
| **Meshy 7** | Later: individual movable props only | API | 20 credits untextured / 30 textured; Pro has commercial rights | **Optional later; not Hobbs architecture** |

Marble 1.1 Plus is explicitly intended for larger outdoor or large-indoor worlds, which is why I would make that the fixed exterior model and normal Marble 1.1 the fixed room model. That gives engineers a deterministic rule rather than another taste decision.

The API output is unusually well suited to your architecture: it gives **100k, 500k, and full-resolution SPZ**, a panorama, scale/ground metadata, and a coarse **collider GLB** from the same generation. The typical full splat is around 2M Gaussians, with the lower tier around 500k.

World Labs' paid-account terms say paid users own their outputs and allow commercial use/API integration, subject to their TOS.

#### Why this beats image-to-mesh for your stills

The Hobbs exterior image is exactly the sort of thing object-based image-to-3D struggles with: several interconnected gables, stone/plaster/timber surfaces, landscaping, windows with interior glow, and unseen geometry wrapping behind the camera. An object generator has to invent a clean topology for all of that.

Marble does not need to pretend that the reference is a closed watertight object. It generates a **viewable environment**. That's much closer to what you actually need.

The charter correctly identifies that the look layer is visual and does not need to become the walk mesh.

#### Spark

Spark is currently designed to mix Gaussian splats with normal Three.js triangle meshes in one scene, including mobile/WebXR, rather than making you replace your R3F runtime. Spark also has exactly the depth behavior you want: splats default to `depthTest=true`, while `depthWrite` defaults false because splats are transparent. Opaque NPCs can therefore write depth and correctly occlude the splat behind them.

Spark 2.x also added LoD trees, progressive loading, paging and an offline `build-lod` path, which matters when you eventually have more than Hobbs loaded.

**Licensing caveat:** there is currently an open Spark GitHub issue asking for clarification because some Rust crates label themselves proprietary while the main repository license is MIT. Pin the exact Spark version and clear this before a production launch. It would not stop the Hobbs evaluation.

### 2. Inputs — are your stills enough?

#### For the Hobbs pilot: **yes**

Do **not** stop Hobbs and request 20–50 images.

A single image is a first-class Marble API input. Internally, World Labs' image-to-world pipeline generates a panorama when necessary and then converts that panorama into the 3D world.

So set the agent minimum to:

**Minimum to attempt a room/building = one high-quality hero still for that exact location.**

That matches the assets already commissioned and avoids making the existing 57-room library obsolete.

There is one important qualification: **one still does not contain truth about surfaces it cannot see.** Marble will invent those. That is fundamentally unavoidable. What you can require is:

1. the stored rating view matches the commissioned still;
2. critical geometry that affects the maze—door, counter, aisle—is registerable;
3. unseen invented material does not create an obvious failure when a Double walks nearby.

If those three pass, accept the asset.

#### Escalation capture, only when a room repeatedly fails

Do **not** have the agent ask for arbitrary extra art. Give it exactly one fallback:

* **Interior:** one 360° equirectangular panorama, ideally **2560×1280 or above**, from roughly the middle of the walkable room.
* **Exterior:** four coherent views of the same building at roughly **0° / 90° / 180° / 270°**, same lighting and eye height. Alternatively, a smooth ≤30-second orbit video.

World Labs specifically calls a 360 panorama its highest-control spatial input and recommends 2560px width; its API supports multi-image direction/azimuth and video.

For multi-image generation, the images should really represent **the same space**. Current guidance recommends overlapping, consistent images; Auto Layout supports up to eight.

Therefore:

**Do not feed `_style_frame_master.png` or the village overhead into Hobbs as additional "views."** They are style/context references, not photographs from another side of Hobbs. Mixing them into the multi-view geometry prompt would give Marble contradictory spatial evidence.

Use the Hobbs image to create Hobbs. Use the master image to define the fixed text/style prompt and to judge village-wide coherence.

One limitation on the GPT review: it could directly see the overhead, style frame, and Hobbs exterior attached in that chat. `cafe_int_dining.png` and `cafe_int_counter.png` were **not** attached there, so the interior tool recommendation is based on the charter's described look rather than a direct visual inspection of those two files.

### 3. Maze registration

Do **not** use AABB fit as the actual registration. AABB is a good sanity check. It is not enough to place architecture.

Consider two cottages with identical bounding boxes:

* one has its front door in the middle;
* the other has its front door three meters left.

AABB fit says both are correct. The maze says only one is.

#### Use three semantic anchors

Every `look.json` should define **three or more named registration anchors**.

For Hobbs exterior, for example:

* `main_door_center`
* `facade_left_corner`
* `facade_right_corner`

For the counter:

* `room_door_center`
* `counter_front_left`
* `counter_front_right`

The maze side of each anchor is deterministic: door cell, object cell, sector boundary, etc.

The generated-world side can be found automatically using Marble's coarse collider GLB plus machine vision:

1. render several known diagnostic views of the generated asset;
2. detect the named feature;
3. raycast through that pixel into Marble's collider;
4. obtain its local 3D coordinate.

Marble provides that collider automatically; it is roughly 100–200k triangles.

Then solve:

**uniform scale + Y rotation/yaw + X/Z translation**

by least-squares/Umeyama alignment between the Marble anchor positions and the maze anchor positions.

Do **not** allow:

* X-only scale,
* Z-only scale,
* arbitrary shearing,
* moving a maze marker.

Those would make a bad generated world appear numerically correct by deforming it.

#### Acceptance

Machine rules:

* ≥3 valid semantic anchors.
* Registration RMS error ≤ **0.25 maze cell** initially.
* Door-center error ≤ **0.15 cell**.
* Uniform scale only.
* Pitch and roll reset/normalized.
* Sector footprint overlaps correctly.
* Floor elevation resolves to the maze floor.
* No generated **walkable-looking floor** extends substantially into blocked walk cells.
* Collision CSV counts remain exactly 2064 / 58.

One subtle change to the charter wording: don't literally test "no look geometry in a blocked cell," because cottage walls **should** visually occupy many blocked cells. Test that *walkable-looking surfaces and functional objects* do not contradict the walkability map.

#### AABB becomes the secondary check

After anchor registration:

* compare generated footprint against sector AABB;
* clip generated scenery slightly outside the sector where necessary;
* allow a small epsilon for roof eaves, trim, vegetation, etc.

If semantic anchors cannot fit using one rigid/uniform transformation, the asset has the wrong geometry.

**Regenerate it. Do not edit the maze.**

#### Coordinate system footgun

Do not hard-code the old "`rotate X 180°`" rule.

World Labs' documentation is currently internally inconsistent: newer release notes say generation exports were switched to OpenGL and that coordinate-system options were added, while one export-spec page still describes the older OpenCV default.

So make basis conversion explicit and versioned:

`Marble local → normalized look-space → Three.js Y-up`

Store the source basis/version in `look.json` and have one importer normalize it.

Marble also exposes `metric_scale_factor` and `ground_plane_offset`; use those to initialize the transform, but let the maze anchors determine the final scale/location.

### 4. Runtime in R3F

The composition should be:

```text
R3F scene
├── Marble SPZ look            visible
├── maze collision hull        invisible
├── NPC meshes                 visible + depthWrite
└── rating camera              stored
```

For Spark:

* `depthTest = true`
* `depthWrite = false`
* splat is visual only
* NPCs remain ordinary opaque Three.js meshes with `depthWrite = true`
* the hidden maze is the gameplay surface

This gives normal opaque-NPC-vs-splat occlusion without forcing the transparent splat to write an unreliable Z buffer.

#### Lighting

Do **not** try to relight a splat as though it were a PBR GLB. Most of the lighting appearance is already baked into its colors.

Instead:

* use Marble's generated panorama as an R3F environment/IBL source for the **NPCs and any opaque props**;
* keep a fixed exposure/tone-mapping recipe;
* let the splat retain its generated golden-hour/interior lighting.

That should make the characters feel like they are under approximately the same illumination as the room instead of sitting in a completely different render.

#### Desktop/mobile

**Desktop-only Hobbs: green light.**

Load:

* `full_res` for the founder's rating view;
* `500k` for normal desktop development;
* `100k` or aggressive Spark LoD for phones.

Spark advertises mobile WebGL2 support and has current LoD/paging machinery, so a future mobile version is plausible.

But do **not** design a phone around loading an entire village of 2M-splat assets at once. The future mobile architecture should activate/prefetch only the current room/sector and neighbors.

Also: stay on the proven Three.js/WebGL2 Spark path for Hobbs. Do not make a WebGPU/Safari path a pilot dependency.

### 5. Automation

#### Input

```text
reference still
style-lock ID
sector AABB
collision cells
named maze anchors
rating-camera ID
room/building ID
```

#### Pipeline

**1. Validate input** — Require one hero still. Check resolution and expected named maze anchors. No still → stop.

**2. Generate**

Interior: World API `model = marble-1.1`, input = exact room still, seed recorded.

Exterior: World API `model = marble-1.1-plus`, input = exact exterior still, seed recorded.

World API is asynchronous and explicitly exposes image/multi-image/video world generation through a normal API endpoint.

**3. Download and freeze outputs**

Immediately save locally/object-storage:

```text
full.spz
500k.spz
100k.spz
reference-collider.glb
generated-pano.png
```

Do not depend permanently on temporary vendor URLs.

**4. Locate anchors** — Fixed automated render sweep → visual detection → raycast into `reference-collider.glb`.

**5. Register** — Solve the single similarity transformation. Reject any candidate that requires deformation.

**6. Retry automatically** — If registration fails, seeds 1–4. Finite predetermined retry count (start with **4**). If four worlds cannot satisfy the anchors, stop with `SOURCE_COVERAGE_INSUFFICIENT`, then request the panorama/four-view fallback. No "should I change the camera?" question.

**7. Compose** — SPZ + transform + hidden CSV hull + NPC playback + stored rating camera.

**8. Machine screenshot** — No HUD. Exact fixed dimensions. Exact fixed camera. A perceptual similarity model can be a **pre-filter** to reject obviously bad seeds; do not make CLIP/DINO/VLM similarity the acceptance gate.

**9. Human gate** — Only PASS / FAIL. Visual mismatch → new generation. Spatial mismatch → registration/regeneration. Never maze/camera redesign.

#### `look.json`

Contract roughly:

```json
{
  "pipeline": "worldlabs-marble",
  "model": "marble-1.1",
  "seed": 123456,
  "inputHash": "...",
  "worldId": "...",

  "assets": {
    "full": "full.spz",
    "lod500k": "500k.spz",
    "lod100k": "100k.spz",
    "referenceCollider": "reference-collider.glb",
    "pano": "generated-pano.png"
  },

  "sourceBasis": "...",

  "registration": {
    "anchors": [],
    "position": [0, 0, 0],
    "quaternion": [0, 0, 0, 1],
    "uniformScale": 1,
    "rmsErrorTiles": 0
  },

  "ratingCamera": "hobbs-exterior-v1"
}
```

Also record tool/API version, prompt/template version, asset hashes and generation timestamp.

#### What is not automatable enough to remove the human

1. **whether the generated environment truly has the intended taste**
2. a rare ambiguous semantic feature, e.g. "which of these three doors is the actual entrance?"

Everything else should be machine-driven.

### 6. Later path: simple UI / prompts

This choice leaves that door open better than the alternatives.

The World API already accepts **text, images, multi-image sets, panoramas and video programmatically**, so a future "add a building" or "create a room" surface could eventually call exactly the same backend the agent calls today.

There is one present limitation: World Labs also has **Chisel**, which is conceptually almost perfect for Doubland—it accepts coarse 3D blocking, walls, doorways and imported GLB/FBX geometry, then generates the detailed world over that structure. But the current public World API schema exposes text/image/multi-image/video world prompts, not Chisel/3D-structure input.

So **do not use Chisel for Hobbs**, because that turns the process back into a GUI step.

Deliberately make the internal interface vendor-neutral:

```text
generateLook(inputs) → look artifact
registerLook(artifact, maze) → transform
```

If World Labs exposes Chisel through the API later, then the invisible maze-derived structural GLB could become input to it **without rewriting the map/runtime architecture**. That could eventually give the ideal combination: exact doors/walls from the map + generated cinematic style.

That is the technology development to watch most closely.

### 7. NPCs

**Keep the current NPCs for the Hobbs engineering pilot, but do not include their visual quality in the Hobbs environment acceptance gate.**

The low-poly people are useful immediately because they prove:

* walking still works;
* depth composition works;
* scale looks right;
* NPCs don't float;
* furniture/counter placement makes functional sense.

But visibly low-poly Quaternius characters standing prominently inside a scene that looks like the attached Tudor stills will **hurt the final taste badly**. The visual gap will be obvious.

Sequence it:

**Hobbs look approval:** rate the environment with no NPC or an NPC deliberately outside the hero focus.

**Hobbs integration:** verify the existing NPC can walk it correctly.

**Before cinematic 3D replaces Phaser publicly:** give the characters a treatment compatible with the environment.

Do not turn character redesign into another blocker for proving the environment pipeline.

### 8. Kill list

#### Kill C — photogrammetry from the current still library

**COLMAP / RealityCapture / conventional photogrammetry: no.**

Those tools reconstruct consistent observations of an existing physical scene. One commissioned hero still is not a photogrammetry dataset. They cannot recover the unseen side of Hobbs because that information doesn't exist.

Use them only if you later possess a real coherent capture orbit/source scene.

#### Kill B as the primary building/room generator

**Meshy / Rodin / Tripo / Hunyuan3D should not generate Hobbs rooms or the full Hobbs cottage.**

Modern object generators are impressive—Meshy 7 is current and exposes a production API, for example—but they are still much better matched to **objects** than inhabited environments.

Use an object generator later for things that actually need to behave as traditional meshes:

* opening door
* refrigerator
* removable chair
* animated sign
* cup
* cash register

But **B is dead for Hobbs architecture**.

#### Kill Luma/Polycam/Postshot reconstruction for these commissioned stills

They make sense when you have actual capture footage. They do not solve the information problem of "one cinematic illustration and no physical room to scan."

Marble's *generative* image-to-world behavior is a better fit.

#### Kill SHARP as the world pipeline

Apple's SHARP is very impressive—it can infer a 3D Gaussian representation from one photograph extremely quickly—but it is fundamentally a nearby novel-view synthesis technique, not the right tool for inventing an entire navigable building behind a single commissioned camera.

#### Kill VGGT as the look generator

VGGT is excellent modern geometry/reconstruction technology, particularly once you have several related images. It does not solve the missing-art problem.

Potential registration utility someday; **not Hobbs look generation**.

#### Do not select HY-World 2.x for production

Tencent's HY-World 2.0 family is a serious 2026 alternative and worth benchmarking. But do not base Doubland production on it right now. The self-hosted stack is much heavier than calling Marble, and more importantly its community license explicitly excludes the **EU, UK and South Korea** from its licensed territory.

That is too awkward a long-term dependency for a consumer product.

#### Kill Chisel for the pilot

Excellent concept, wrong automation surface **today**.

When/if its structure-conditioned generation is exposed through World API, reevaluate immediately.

#### Kill Marble HQ mesh as the default

Marble can export HQ GLB, but it costs an additional **$2.80/world**, produces roughly 600k/1M-triangle variants and may take up to an hour.

Use it only where there is a specific reason a mesh is better than the SPZ.

And regardless, never use it as the gameplay collision source.

### Final engineering decision (GPT)

Rewrite the charter's proposed default to:

> **Hobbs exterior:** `marble-1.1-plus` → SPZ → Spark.
> **Hobbs dining/counter:** `marble-1.1` → SPZ → Spark.
> Existing CSV-derived maze/hulls remain invisible and authoritative for all movement/collision. Marble's collider is registration/debug data only. Register every look asset using ≥3 semantic anchors and one uniform similarity transform; AABB is a post-fit sanity check. Fixed rating camera. Four deterministic regeneration attempts before asking for a panorama/cardinal-view set. No Blender in steady state. No photogrammetry or image-to-mesh for Hobbs architecture.

**Start Hobbs with the stills you already have rather than commissioning a giant capture pack first.** The technology now exists specifically for sparse image→world generation, which is the important change from the older "capture a real place and reconstruct it" pipeline.

The strongest part of this design is that a bad generated Hobbs has nowhere to hide: either its semantic anchors fit the immutable maze and the fixed camera looks like the commissioned still, or the asset gets thrown away. That is a much cleaner autonomous loop than trying to make the collision representation gradually prettier.

GPT cited (among others): World Labs World API / docs / export specs / TOS / pricing / Chisel / OpenAPI; Spark overview / SparkRenderer / changelog; Spark GitHub license issue; Meshy API / pricing; Apple SHARP; facebookresearch/vggt; Tencent HY-World 2.0 license.

---

## Sources

- Expert replies pasted by founder 2026-08-31 (this file).
- Working charter: [`R3F_TODOs.md`](./R3F_TODOs.md).
