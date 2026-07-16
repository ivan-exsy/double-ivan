# 2026-07-16 — Village asset generation day plan

**Goal:** Commission every missing the_ville interior + exterior plate so future dailies never block on environment art.  
**Also ships:** P0 plates needed for Survival Day-1 picture pass (`20260713-1` / `overview_day2&001`).  
**Do not:** re-TTS / overwrite locked VO; do not `lock_day_script` today; do not invent modern kitsch that breaks the Tudor village look.

**Repos:** `generative_agents`  
**Output folders:**
- Interiors → `video/assets/village/interior/`
- Exteriors → `video/assets/village/exterior/`
- Moodboard crops → `video/assets/village/_moodboard/`
- Phaser layout refs → `video/assets/phaser/_moodboard/` (or crops from bird’s-eye)

**Canonical docs (read only if stuck):**
- Workflow history: `double-ivan/video/archive/sot-video-history.md` §TODO-M / N / O  
- Paste prompts (interiors): `generative_agents/video/assets/village/interior/_interior_prompts_TODO.md`  
- Exterior templates: `generative_agents/video/assets/scripts-prompts/!prompts.md`  
- Maze inventory: `generative_agents/video/assets/village/interior/_room_inventory.md`  
- Daily trailer checklist: `double-ivan/video/TODO_video.md`

---

## Success criteria (end of day)

| Tier | Done means |
|------|------------|
| **Must ship (P0)** | `market_int.png` · `college_int_classroom.png` · `willows_pharmacy_exterior_wide.png` · `oak_hill_college_exterior_wide.png` on disk |
| **Should ship (P1)** | Pub + supply interiors + exteriors; artist studio rooms 1–5 (interiors) |
| **Nice (P2)** | Remaining house mains / bedrooms + homes-row / apt exteriors |
| **Housekeeping** | `EXISTING_INTERIORS` updated; inventory + prompt scripts re-run; checklist at bottom ticked |

If time dies, **stop after P0** and still do the 15-min housekeeping pass so tomorrow’s Remotion baseline can run.

---

## Before you open Grok (20–30 min)

### 0. Desk setup

- [ ] Open Grok Imagine (image) in a browser tab  
- [ ] Open File Explorer at `D:\Coding\generative_agents\video\assets\village\`  
- [ ] Open `_interior_prompts_TODO.md` (search headings as you go)  
- [ ] Open `!prompts.md` for exterior skeletons  
- [ ] Keep `_style_frame_master.png` pinned (path below)

**Primary style ref (every batch):**  
`video/assets/village/exterior/_style_frame_master.png`  
(also mirrored under `_moodboard/_style_frame_master_*.png`)

### 1. Refresh inventory (so prompts match maze)

From `generative_agents` root:

```bash
python video/assets/scripts-prompts/generate_room_inventory.py
python video/assets/scripts-prompts/generate_interior_prompts.py
```

- [ ] Scripts run without error  
- [ ] Re-open `_interior_prompts_TODO.md` — use **this** file as paste source for the day  

> Note: inventory dashboard may still under-count DONE rooms until you update `EXISTING_INTERIORS` in Step 9. Trust **files on disk** + “Save as” names, not the old “16 DONE” line.

### 2. Pre-stage reference stack (copy paths handy)

| Role | Path |
|------|------|
| Style (w2.0 always) | `village/exterior/_style_frame_master.png` |
| Cafe counter continuity | `village/interior/cafe_int_counter.png` |
| Cafe dining continuity | `village/interior/cafe_int_dining.png` |
| Library continuity | `village/interior/library_int_reading.png` |
| Dorm common continuity | `village/interior/dorm_int_common.png` |
| Bedroom continuity | `village/interior/dorm_int_bedroom_3.png` |
| Village overhead (full) | `village/exterior/village_overhead_wide.png` |
| Overhead crops (existing) | `village/_moodboard/village_overhead_wide-Hobbs-cafe.png` etc. |
| Phaser bird’s-eye | `phaser/_moodboard/1-village-birdeye.png` |
| Phaser cafe / dorm / library | `phaser/_moodboard/2-hobbs-cafe.png` · `3-dorm.png` · `4-oak-hill-library.png` |

### 3. Crop exterior moodboards for missing buildings (15 min)

You already have overhead crops for cafe / dorm / library only. For each new exterior, crop **one tight plate** of that building from:

- `village/exterior/village_overhead_wide.png`, or  
- `village/_moodboard/village_overhead_wide_high-res2.png`, or  
- `phaser/_moodboard/1-village-birdeye.png` (layout-only if style crop is weak)

Save under `video/assets/village/_moodboard/`:

| Crop file to create | Building |
|---------------------|----------|
| `village_overhead_wide-willows.png` | Willows Market & Pharmacy |
| `village_overhead_wide-college.png` | Oak Hill College (classroom / main college mass — **not** library) |
| `village_overhead_wide-pub.png` | Rose and Crown Pub |
| `village_overhead_wide-supply.png` | Harvey Oak Supply Store |
| `village_overhead_wide-artist.png` | Artist co-living |
| `village_overhead_wide-apts.png` | Apartment block (1–5) |
| `village_overhead_wide-homes.png` | House row / cottages (1–3 and/or 4–6) |

Optional Phaser close-ups (if you can capture or crop today): same names under `phaser/_moodboard/`. If not, use bird’s-eye + open-roof layout ref:

`village/exterior/_layout-reference_open-roofs.png`

- [ ] All P0 crops exist (willows + college)  
- [ ] P1 crops exist if you plan Batch 3 today  

### 4. Locked rules (read once)

1. **Furniture = maze LAYOUT line** — do not invent extra furniture.  
2. **Windows/doors** — quick Phaser glance; tweak prompt in UI if wrong.  
3. **Camera interiors** — eye-level 3/4, ~1.6 m, just inside doorway, 35 mm, room fills frame.  
4. **Camera exteriors** — eye-level approach POV, slight 3/4, golden hour, building 60–70% of frame.  
5. **No people**, no vehicles, no watermarks, no modern neon, no Pinterest patio kitsch.  
6. **One archetype batch per Grok session** when possible (locked STYLE).  
7. **Persona-neutral bedrooms** — literal furniture only (no “Vince’s room” flavor).  
8. **Library exterior ≠ college exterior** — college classroom needs its own plate.  
9. Save **exact** filenames listed below (pipeline + inventory expect them).

---

## How to run one interior (repeat)

1. Find heading in `_interior_prompts_TODO.md`.  
2. Copy camera line + **LAYOUT** + **STYLE** + **Negative**.  
3. Attach references with the weights listed in that section (style always w2).  
4. Generate; re-roll if: wrong camera (top-down), wrong roof/palette, people, modern clutter, empty wrong room.  
5. Save PNG to `video/assets/village/interior/<Save as name>`.  
6. Tick the checkbox in this file.

**Acceptance (interior):** recognizably Tudor village; furniture matches LAYOUT positions at a glance; same material language as cafe/dorm; usable as a trailer still at phone size.

---

## How to run one exterior (repeat)

Use skeleton from `!prompts.md` (`*Exterior - Cafe*` / Dorm / Library). Pattern:

```
An eye-level photograph from the viewpoint of someone walking up the path
toward the entrance of "[BUILDING NAME]" in a small fictional village.
Camera at human eye height (~1.6m), slight upward tilt, 35mm equivalent,
slight 3/4 angle. Building fills upper 60–65% of frame. Stone path leads
INTO the frame from the foreground.

REFERENCES:
- Ref A: village/_moodboard/village_overhead_wide-<building>.png
  → STYLE only (roof material, stone, wood, palette, scale, biome)
- Ref B: Phaser top-down or open-roof crop
  → LAYOUT (footprint, wings, which face is the entrance)
- Optional: style frame for global continuity

Building specs: [stories · roof type · door · windows · sign if commercial]
Surroundings: path, grass, trees, neighboring buildings consistent with Ref A
Style: prestige animated film (Pixar Up / Ghibli countryside), lightly stylized
Lighting: golden hour, sun upper-left, warm interior glow in windows

DO NOT: top-down/isometric; people/vehicles; wrong roof; modern neon;
Pinterest patio umbrellas/string lights; watermarks; copy wrong architecture
from any non-A reference.
```

**Acceptance (exterior):** same building as overhead crop when “zoomed to ground”; matches `_style_frame_master` materials; approach path readable; commercial buildings get small hand-carved wooden signs only.

---

# Batch plan (suggested clock)

| When | Batch | What | ~Time |
|------|-------|------|-------|
| Morning | **A — P0 interiors** | Willows + classroom | 45–60 min |
| Late morning | **B — P0 exteriors** | Willows + college exteriors | 45–60 min |
| Midday | **C — P1 commerce** | Pub + supply (int + ext) | 60–90 min |
| Afternoon | **D — Artist studios** | 5 studio living rooms | 60–90 min |
| Late afternoon | **E — Homes** | House mains / bedrooms | 60–90 min |
| End of day | **F — Housekeeping + optional trailer check** | Register files; optional Remotion | 30–45 min |

Skip E if behind. Do **not** skip A + B if the Day-1 trailer is the goal.

---

## Batch A — P0 interiors (this trailer)

| # | Room | Save as | Prompt section in `_interior_prompts_TODO.md` | Refs |
|---|------|---------|-----------------------------------------------|------|
| A1 | Willows Market & Pharmacy — store | `market_int.png` | *Interior - The Willows Market and Pharmacy - store* | style w2 · `cafe_int_counter` w1 |
| A2 | Oak Hill College — classroom | `college_int_classroom.png` | *Interior - Oak Hill College - classroom* | style w2 · `library_int_reading` w1 |

- [ ] A1 `market_int.png`  
- [ ] A2 `college_int_classroom.png`  

**Tip:** Willows LAYOUT is long (grocery + pharmacy counters). Prefer the shot that shows **both** sides of the store if possible; if Grok collapses it, keep pharmacy counter readable (Ivan’s workplace stamp).

---

## Batch B — P0 exteriors (this trailer)

| # | Building | Save as | Ref A crop | Notes |
|---|----------|---------|------------|-------|
| B1 | Willows Market & Pharmacy | `willows_pharmacy_exterior_wide.png` | `village_overhead_wide-willows.png` | Commercial: small hand-carved “Willows Market” / pharmacy sign; not a cafe patio |
| B2 | Oak Hill College (classroom building) | `oak_hill_college_exterior_wide.png` | `village_overhead_wide-college.png` | **Not** `library_exterior_wide.png`. Civic/school mass; taller windows OK |

- [ ] B1 willows exterior  
- [ ] B2 college exterior  

**Paste base:** start from `!prompts.md` → `*Exterior - Library*` (civic) for college; `*Exterior - Cafe*` (commercial) for Willows — swap name, specs, refs.

---

## Batch C — P1 commerce / social

### Interiors

| # | Room | Save as | Refs |
|---|------|---------|------|
| C1 | Rose and Crown Pub | `pub_int.png` | style w2 · `cafe_int_dining` w1 |
| C2 | Harvey Oak Supply Store | `supply_int.png` | style w2 · `cafe_int_counter` w1 |

- [ ] C1 `pub_int.png`  
- [ ] C2 `supply_int.png`  

### Exteriors

| # | Building | Save as |
|---|----------|---------|
| C3 | Rose and Crown Pub | `pub_exterior_wide.png` |
| C4 | Harvey Oak Supply Store | `supply_store_exterior_wide.png` |

- [ ] C3 pub exterior  
- [ ] C4 supply exterior  

---

## Batch D — Artist co-living studios (interiors only)

Common room already exists (`artist_int_common.png`). Generate living/sleep studios:

| # | Room | Save as |
|---|------|---------|
| D1 | Studio Room 1 | `artist_int_studio1.png` |
| D2 | Studio Room 2 | `artist_int_studio2.png` |
| D3 | Studio Room 3 | `artist_int_studio3.png` |
| D4 | Studio Room 4 | `artist_int_studio4.png` |
| D5 | Studio Room 5 | `artist_int_studio5.png` |

Refs (batch): style w2 · `dorm_int_common` w1 · `dorm_int_bedroom_3` w0.5  

- [ ] D1 … D5 all five files  

Optional same session:

| # | Building | Save as |
|---|----------|---------|
| D6 | Artist co-living exterior | `artist_coliving_exterior_wide.png` |

- [ ] D6 exterior (optional)

---

## Batch E — Remaining homes (P2)

### Interiors

| # | Room | Save as |
|---|------|---------|
| E1 | House 1 main | `house1_int_main.png` |
| E2 | House 2 main | `house2_int_main.png` |
| E3 | House 3 main | `house3_int_main.png` |
| E4 | House 4 Room 1 | `house4_int_room_1.png` |
| E5 | House 4 Room 2 | `house4_int_room_2.png` |
| E6 | House 5 Main Bedroom | `house5_int_main_bed.png` |
| E7 | House 5 Second Bedroom | `house5_int_second_bed.png` |
| E8 | House 6 Main Bedroom | `house6_int_main_bed.png` |
| E9 | House 6 Second Bedroom | `house6_int_second_bed.png` |

Refs: style w2 · bedroom stack (`dorm_int_bedroom_3` w1 · optional bedroom_1 w0.5) or studio_living stack for combined mains.

- [ ] E1–E9  

### Exteriors (one plate each is enough)

| # | Subject | Save as |
|---|---------|---------|
| E10 | Apartment block | `apartments_exterior_wide.png` |
| E11 | Homes / cottages row | `homes_row_exterior_wide.png` |
| E12 | House 4 (optional separate) | `house4_exterior_wide.png` |
| E13 | House 5 (optional) | `house5_exterior_wide.png` |
| E14 | House 6 (optional) | `house6_exterior_wide.png` |

- [ ] E10–E11 minimum if doing exteriors  
- [ ] E12–E14 only if houses read as distinct masses  

**Skip today unless time:** Johnson Park outdoor plate (`johnson_park_exterior_wide.png`), garden-only stamps.

---

## Batch F — Housekeeping (mandatory, even if art incomplete)

### 9. Register new interiors in code

Edit `video/assets/scripts-prompts/generate_room_inventory.py` → `EXISTING_INTERIORS`.

Add (or merge) entries for everything **on disk after today**, at least:

```python
("The Willows Market and Pharmacy", "store"): ["market_int.png"],
("Oak Hill College", "classroom"): ["college_int_classroom.png"],
("The Rose and Crown Pub", "pub"): ["pub_int.png"],
("Harvey Oak Supply Store", "supply store"): ["supply_int.png"],
# apartments (if not already):
("Apartment 1", "main room"): ["apt1_int_main.png"],
("Apartment 1", "bathroom"): ["apt1_int_bath.png"],
# … same pattern apt2–5, all baths already on disk …
# artist studios when done:
("artist's co-living space", "Studio Room 1"): ["artist_int_studio1.png"],
# … Studio Room 2–5 …
# houses:
("House 1", "main room"): ["house1_int_main.png"],
("House 1", "bathroom"): ["house1_int_bath.png"],
# … etc.
```

Also register **already-on-disk** baths/apts that the inventory still lists as TODO (dashboard is stale).

- [ ] `EXISTING_INTERIORS` updated for all new + previously unregistered files  

### 10. Re-run generators

```bash
python video/assets/scripts-prompts/generate_room_inventory.py
python video/assets/scripts-prompts/generate_interior_prompts.py
```

- [ ] `_room_inventory.md` coverage numbers look right  
- [ ] `_interior_prompts_TODO.md` remaining list only has real gaps  

### 11. Quick visual QA (5 min)

Open folder in grid view. Reject/re-roll any plate that:

- is top-down or isometric  
- has people / UI / watermarks  
- has modern plastic / neon / glass-curtain walls  
- does not match style frame materials  
- for Willows/classroom: unusable as a workplace stamp on phone  

- [ ] P0 set passes phone-size glance  

### 12. Optional — Day-1 trailer baseline (if P0 done and energy remains)

Do **not** touch VO. Picture-only:

```bash
# from generative_agents — picture pass, no --force on locked package
python -m video.generate_trailer 20260713-1 --mode day_overview --day 2 \
  --output-dir data/20260713-1/overview_day2&001
```

(Or project Remotion entrypoint if that is your usual path.)

- [ ] Baseline MP4 watched once on phone  
- [ ] Note gaps for tomorrow (moment clips A–C still optional; do **not** block on them tonight)

### 13. Explicitly out of scope today

- [ ] ~~Re-TTS / edit `VO_LOCKED.md`~~ (Anya gate)  
- [ ] ~~`lock_day_script`~~ (after picture + VO both OK)  
- [ ] ~~Moment clips A–C~~ (tomorrow after baseline)  
- [ ] ~~B4 clip automation~~  
- [ ] ~~Day 2 overview generation~~  

---

## Master checklist (tick as you finish)

### Prep
- [ ] Inventory + prompts regenerated  
- [ ] Moodboard crops for willows + college  
- [ ] Style frame + continuity refs ready  

### P0 (ship or day fails)
- [ ] `market_int.png`  
- [ ] `college_int_classroom.png`  
- [ ] `willows_pharmacy_exterior_wide.png`  
- [ ] `oak_hill_college_exterior_wide.png`  

### P1
- [ ] `pub_int.png`  
- [ ] `supply_int.png`  
- [ ] `pub_exterior_wide.png`  
- [ ] `supply_store_exterior_wide.png`  
- [ ] `artist_int_studio1.png` … `studio5.png`  
- [ ] `artist_coliving_exterior_wide.png` (optional)  

### P2
- [ ] House mains 1–3  
- [ ] House 4 rooms + house 5–6 bedrooms  
- [ ] `apartments_exterior_wide.png`  
- [ ] `homes_row_exterior_wide.png`  

### Close-out
- [ ] `EXISTING_INTERIORS` updated  
- [ ] Scripts re-run  
- [ ] This file’s checkboxes reflect reality  
- [ ] Optional: Remotion baseline watch  

---

## Full gap list (source of truth for this day)

### Interiors still missing at plan start (18)

`market_int.png` · `college_int_classroom.png` · `pub_int.png` · `supply_int.png` ·  
`artist_int_studio1.png` … `artist_int_studio5.png` ·  
`house1_int_main.png` · `house2_int_main.png` · `house3_int_main.png` ·  
`house4_int_room_1.png` · `house4_int_room_2.png` ·  
`house5_int_main_bed.png` · `house5_int_second_bed.png` ·  
`house6_int_main_bed.png` · `house6_int_second_bed.png`

### Exteriors still missing at plan start

**Have:** style frame · village overhead · Hobbs · dorm · library  

**Need:** Willows · Oak Hill College · pub · supply · artist · apartments · homes row · (optional house 4–6, park)

### Already on disk — do not regenerate

All cafe / library / dorm common+bedrooms+baths · apt 1–5 main+bath · artist common + 5 studio baths · house 1–6 baths · house 4–6 commons.

---

## If you only have 2 hours

1. Prep crops (willows + college) — 10 min  
2. A1 + A2 interiors — 40 min  
3. B1 + B2 exteriors — 40 min  
4. Housekeeping register + re-run scripts — 15 min  
5. Stop. Tomorrow: Remotion baseline → clips.

---

## End-of-day note (fill before you stop)

**Date:** 2026-07-16  
**Shipped:**  
**Still missing:**  
**Blockers / re-roll notes:**  
**Next session starts at:** Batch ___  

---

*Plan authored for Ivan · village asset day · pairs with `video/TODO_video.md` Gate B.*
