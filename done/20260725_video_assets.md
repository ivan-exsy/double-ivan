# 2026-07-16 — Village asset generation day plan

**Status (2026-07-20):** Interiors + **all exterior plates #1–7** + inventory housekeeping **DONE**. Remaining work = Day-1 picture pipeline (Remotion / clips / VO lock) — not more village plates.  
**Live checklist for dailies:** `double-ivan/video/TODO_video.md` Gate B.  
**Inventory:** `generative_agents/video/assets/village/interior/_room_inventory.md` → **57 DONE / 0 TODO / 6 N/A**.  
**Exterior gen script:** `generative_agents/video/assets/scripts-prompts/_gen_village_exteriors.py`

---

## Remaining TODO (knock these today)

Work top → bottom. Interiors are closed — do **not** regenerate cafe/dorm/library/apts/houses/artist/Willows/classroom plates.

### A — Optional exteriors (art only; not Day-1 blockers)

Phaser layout refs already under `video/assets/phaser/_moodboard/`. Style: `village/exterior/_style_frame_master.png`. Save under `video/assets/village/exterior/`.

| # | Done? | Asset | Save as | Phaser ref |
|---|:-----:|-------|---------|------------|
| 1 | [x] | Willows Market & Pharmacy exterior | `willows_pharmacy_exterior_wide.png` | `willows-market.png` |
| 2 | [x] | Oak Hill College facade (**not** library) | `oak_hill_college_exterior_wide.png` | `oak-hill-college-classroom.png` |
| 3 | [x] | Rose and Crown Pub exterior | `pub_exterior_wide.png` | `rose-and-crown-pub.png` |
| 4 | [x] | Harvey Oak Supply exterior | `supply_store_exterior_wide.png` | `Harvey-Oak-Supply-Store.png` |
| 5 | [x] | Artist co-living exterior *(optional)* | `artist_coliving_exterior_wide.png` | `artists-co-living.png` |
| 6 | [x] | Apartment block exterior *(P2)* | `apartments_exterior_wide.png` | `apartment-*.png` (v2 linked terrace — approved 2026-07-20) |
| 7 | [x] | Homes / cottages row *(P2)* | `homes_row_exterior_wide.png` | `house-1`…`house-6.png` |

**Skip unless you want distinct house masses:** `house4_exterior_wide.png` · `house5_exterior_wide.png` · `house6_exterior_wide.png`.  
**Already have:** Hobbs · dorm · library · Johnson Park · style frame · village overhead.

**If short on time:** ship **#1–#2 only**, then jump to B.

### B — Day-1 picture pipeline (after any exteriors you care about)

Package: `generative_agents/data/20260713-1/overview_day2&001/` · CapCut kit already proved: `trailer_ready_day2/`.

| # | Done? | Task |
|---|:-----:|------|
| 8 | [ ] | Baseline Remotion render **without** moment clips → watch once on phone |
| 9 | [ ] | Optional: moment clips A–C → `video/assets/moment_clips/20260713-1/2/beat_<scene_id>.mp4` → re-render |
| 10 | [ ] | Props check: scenes 6–9 `hero_path` resolve; optional `location` labels |
| 11 | [ ] | **Do not** re-TTS / overwrite locked VO; **do not** `lock_day_script` until Anya VO + picture both OK |

VO Gate A lives in `TODO_video.md` (founder/Anya short-VO approve) — not this file.

### C — Close this plan when A/B done enough

| # | Done? | Task |
|---|:-----:|------|
| 12 | [ ] | Tick exterior rows above as you save files |
| 13 | [ ] | If any new interiors ever appear: update `EXISTING_INTERIORS` + re-run inventory/prompt scripts |

---

## Goal (original day)

Commission every missing the_ville interior + exterior plate so future dailies never block on environment art.  
**Also ships:** P0 plates needed for Survival Day-1 picture pass (`20260713-1` / `overview_day2&001`).  
**Do not:** re-TTS / overwrite locked VO; do not `lock_day_script` today; do not invent modern kitsch that breaks the Tudor village look.

**Repos:** `generative_agents`  
**Output folders:**
- Interiors → `video/assets/village/interior/`
- Exteriors → `video/assets/village/exterior/`
- Moodboard crops → `video/assets/village/_moodboard/`
- Phaser layout refs → `video/assets/phaser/_moodboard/`

**Canonical docs:**
- Daily SOT place plates: `double-ivan/video/daily/SOT-new-daily.md` §2.1  
- Daily trailer checklist: `double-ivan/video/TODO_video.md`  
- Paste prompts: `generative_agents/video/assets/village/interior/_interior_prompts_TODO.md` (0 remaining)  
- Exterior templates: `generative_agents/video/assets/scripts-prompts/!prompts.md`  
- Maze inventory: `generative_agents/video/assets/village/interior/_room_inventory.md`

---

## Success criteria — outcome

| Tier | Plan target | Outcome (2026-07-18 / verified 2026-07-20) |
|------|-------------|-----------------------------------------------|
| **P0 interiors** | Willows + classroom | ✅ **DONE** — Willows shipped as **two** plates (not single `market_int.png`): `willows_pharmacy_int_counter.png` · `willows_market_int_aisle.png`; + `college_int_classroom.png` |
| **P0 exteriors** | Willows + college facade | ✅ **DONE** (2026-07-20 Grok Imagine batch) |
| **P1 interiors** | Pub + supply + artist studios 1–5 | ✅ **DONE** |
| **P1 exteriors** | Pub + supply (+ optional artist) | ✅ **DONE** |
| **P2 interiors** | House mains / bedrooms | ✅ **DONE** |
| **P2 exteriors** | Apts / homes row | ✅ **DONE** (apts v2 terrace approved as-is) |
| **Bonus** | Johnson Park outdoor | ✅ **DONE** — `johnson_park_exterior_wide.png` |
| **Housekeeping** | `EXISTING_INTERIORS` + scripts | ✅ **DONE** — inventory 57/0/6; prompts TODO file empty |

---

## Before you open Grok (20–30 min)

### 0. Desk setup

- [x] Open Grok Imagine (image) in a browser tab  
- [x] Open File Explorer at `D:\Coding\generative_agents\video\assets\village\`  
- [x] Open `_interior_prompts_TODO.md` (search headings as you go)  
- [x] Open `!prompts.md` for exterior skeletons  
- [x] Keep `_style_frame_master.png` pinned (path below)

**Primary style ref (every batch):**  
`video/assets/village/exterior/_style_frame_master.png`  
(also mirrored under `_moodboard/_style_frame_master_*.png`)

### 1. Refresh inventory (so prompts match maze)

From `generative_agents` root:

```bash
python video/assets/scripts-prompts/generate_room_inventory.py
python video/assets/scripts-prompts/generate_interior_prompts.py
```

- [x] Scripts run without error  
- [x] Re-open `_interior_prompts_TODO.md` — **0 remaining** after interior ship  

> Note: Willows canonical names are the two-plate set above, not `market_int.png`. Trust **files on disk** + `EXISTING_INTERIORS`.

### 2. Pre-stage reference stack (copy paths handy)

| Role | Path | Status |
|------|------|:------:|
| Style (w2.0 always) | `village/exterior/_style_frame_master.png` | ✅ |
| Cafe counter continuity | `village/interior/cafe_int_counter.png` | ✅ |
| Cafe dining continuity | `village/interior/cafe_int_dining.png` | ✅ |
| Library continuity | `village/interior/library_int_reading.png` | ✅ |
| Dorm common continuity | `village/interior/dorm_int_common.png` | ✅ |
| Bedroom continuity | `village/interior/dorm_int_bedroom_3.png` | ✅ |
| Village overhead (full) | `village/exterior/village_overhead_wide.png` | ✅ |
| Overhead crops (cafe/dorm/library only) | `village/_moodboard/village_overhead_wide-Hobbs-cafe.png` etc. | ✅ partial |
| Phaser bird’s-eye | `phaser/_moodboard/1-village-birdeye.png` | ✅ |
| Phaser property top-downs | cafe · dorm · library · willows · college · supply · pub · apts · houses · artists · park | ✅ **manual crops shipped** |

### 3. Crop exterior moodboards for missing buildings

**Superseded for interiors:** daily SOT §2.1 prefers **manual Phaser property crops** (done) over bird’s-eye auto-crops.

Bird’s-eye named crops from the original plan were **not** created (`village_overhead_wide-willows.png` etc.). Only make them if you want an extra style ref while doing exterior batch A above.

- [x] P0 Phaser layout refs (willows + college)  
- [x] P1 Phaser layout refs (pub, supply, artist, houses, apts)  
- [ ] Optional overhead moodboard crops (only if exteriors need them)

### 4. Locked rules (read once)

1. **Furniture = maze LAYOUT line** — do not invent extra furniture.  
2. **Windows/doors** — quick Phaser glance; tweak prompt in UI if wrong.  
3. **Camera interiors** — eye-level 3/4, ~1.6 m, just inside doorway, 35 mm, room fills frame.  
4. **Camera exteriors** — eye-level approach POV, slight 3/4, golden hour, building 60–70% of frame.  
5. **No people**, no vehicles, no watermarks, no modern neon, no Pinterest patio kitsch.  
6. **One archetype batch per Grok session** when possible (locked STYLE).  
7. **Persona-neutral bedrooms** — literal furniture only (no “Vince’s room” flavor).  
8. **Library exterior ≠ college exterior** — college classroom needs its own plate.  
9. Save **exact** filenames listed in Remaining TODO (pipeline expects them).  
10. **Phaser layout** — hand-crop property top-downs under `phaser/_moodboard/`; never feed labeled `raw/*` into Imagine.

---

## How to run one exterior (remaining work)

Use skeleton from `!prompts.md` (`*Exterior - Cafe*` / Dorm / Library). Pattern:

```
An eye-level photograph from the viewpoint of someone walking up the path
toward the entrance of "[BUILDING NAME]" in a small fictional village.
Camera at human eye height (~1.6m), slight upward tilt, 35mm equivalent,
slight 3/4 angle. Building fills upper 60–65% of frame. Stone path leads
INTO the frame from the foreground.

REFERENCES:
- Ref A: phaser/_moodboard/<building>.png  (LAYOUT — footprint, entrance face)
- Ref B: village/exterior/_style_frame_master.png  (STYLE — materials, palette)
- Optional: village/exterior/hobbs_cafe_exterior_wide.png or library_exterior_wide.png for approach-shot continuity

Building specs: [stories · roof type · door · windows · sign if commercial]
Surroundings: path, grass, trees, neighboring buildings consistent with village overhead
Style: prestige animated film (Pixar Up / Ghibli countryside), lightly stylized
Lighting: golden hour, sun upper-left, warm interior glow in windows

DO NOT: top-down/isometric; people/vehicles; wrong roof; modern neon;
Pinterest patio umbrellas/string lights; watermarks; copy library facade for college.
```

**Acceptance (exterior):** same building as Phaser crop when “zoomed to ground”; matches `_style_frame_master` materials; approach path readable; commercial buildings get small hand-carved wooden signs only.

---

# Batch plan — completion log

| Batch | What | Outcome |
|-------|------|---------|
| **A — P0 interiors** | Willows + classroom | ✅ Done (Willows = 2 plates) |
| **B — P0 exteriors** | Willows + college exteriors | ❌ Open → Remaining TODO #1–#2 |
| **C — P1 commerce** | Pub + supply int + ext | ✅ Interiors · ❌ exteriors #3–#4 |
| **D — Artist studios** | Studios 1–5 (+ optional ext) | ✅ Interiors · ❌ exterior #5 |
| **E — Homes** | House mains / bedrooms + row ext | ✅ Interiors · ❌ exteriors #6–#7 |
| **Bonus** | Johnson Park outdoor | ✅ Done |
| **F — Housekeeping** | Register + scripts | ✅ Done |
| **Picture pipeline** | Remotion / clips / lock | ❌ Open → Remaining TODO #8–#11 |

---

## Batch A — P0 interiors — DONE

| # | Room | Save as | Status |
|---|------|---------|:------:|
| A1 | Willows — pharmacy counter | `willows_pharmacy_int_counter.png` | ✅ |
| A1b | Willows — grocery aisle | `willows_market_int_aisle.png` | ✅ |
| A2 | Oak Hill College — classroom | `college_int_classroom.png` | ✅ |

~~Original single-file target `market_int.png`~~ — **not used**; two-camera ship matches cafe counter/dining pattern and daily SOT §2.1.

---

## Batch B — P0 exteriors — OPEN

| # | Building | Save as | Status |
|---|----------|---------|:------:|
| B1 | Willows Market & Pharmacy | `willows_pharmacy_exterior_wide.png` | [ ] |
| B2 | Oak Hill College (classroom building) | `oak_hill_college_exterior_wide.png` | [ ] |

**Paste base:** `!prompts.md` → `*Exterior - Library*` (civic) for college; `*Exterior - Cafe*` (commercial) for Willows — swap name, specs, refs.  
**Do not** reuse `library_exterior_wide.png` as the college facade.

---

## Batch C — P1 commerce / social

### Interiors — DONE

| # | Room | Save as | Status |
|---|------|---------|:------:|
| C1 | Rose and Crown Pub | `pub_int.png` | ✅ |
| C2 | Harvey Oak Supply Store | `supply_int.png` | ✅ |

### Exteriors — OPEN

| # | Building | Save as | Status |
|---|----------|---------|:------:|
| C3 | Rose and Crown Pub | `pub_exterior_wide.png` | [ ] |
| C4 | Harvey Oak Supply Store | `supply_store_exterior_wide.png` | [ ] |

---

## Batch D — Artist co-living studios — interiors DONE

Common room already existed (`artist_int_common.png`). Studios:

| # | Room | Save as | Status |
|---|------|---------|:------:|
| D1–D5 | Studio Rooms 1–5 | `artist_int_studio{1–5}.png` | ✅ all five |
| — | Studio baths 1–5 | `artist_int_studio{N}_bath.png` | ✅ |

| # | Building | Save as | Status |
|---|----------|---------|:------:|
| D6 | Artist co-living exterior | `artist_coliving_exterior_wide.png` | [ ] optional |

---

## Batch E — Remaining homes — interiors DONE

### Interiors — DONE

| # | Room | Save as | Status |
|---|------|---------|:------:|
| E1–E3 | House 1–3 main | `house{1–3}_int_main.png` | ✅ |
| E4–E5 | House 4 rooms | `house4_int_room_{1,2}.png` | ✅ |
| E6–E9 | House 5–6 bedrooms | `house5_int_*_bed.png` · `house6_int_*_bed.png` | ✅ |

(Also on disk from earlier: baths, house 4–6 commons, apt 1–5 main+bath.)

### Exteriors — OPEN

| # | Subject | Save as | Status |
|---|---------|---------|:------:|
| E10 | Apartment block | `apartments_exterior_wide.png` | [ ] |
| E11 | Homes / cottages row | `homes_row_exterior_wide.png` | [ ] |
| E12–E14 | House 4–6 separate | `house{4–6}_exterior_wide.png` | [ ] optional |

**Shipped outdoor (was skip-unless-time):** `johnson_park_exterior_wide.png` ✅

---

## Batch F — Housekeeping — DONE

### 9. Register new interiors in code

`EXISTING_INTERIORS` in `generate_room_inventory.py` includes Willows two-plate set, classroom, pub, supply, artist studios + baths, houses, apts, etc.

- [x] `EXISTING_INTERIORS` updated for all shipped interiors  

### 10. Re-run generators

- [x] `_room_inventory.md` → **DONE: 57 · TODO: 0 · N/A: 6**  
- [x] `_interior_prompts_TODO.md` → **Total prompts: 0 remaining**  

### 11. Quick visual QA

- [x] Interior P0 set usable for workplace stamps (Willows + classroom)  
- [ ] Re-check any new exteriors at phone size when shipped  

### 12. Optional — Day-1 trailer baseline

Do **not** touch VO. Picture-only:

```bash
# from generative_agents — picture pass, no --force on locked package
python -m video.generate_trailer 20260713-1 --mode day_overview --day 2 \
  --output-dir data/20260713-1/overview_day2&001
```

- [ ] Baseline MP4 watched once on phone  
- [ ] Note gaps (moment clips A–C still optional)  

### 13. Explicitly out of scope for asset day

- [x] ~~Re-TTS / edit `VO_LOCKED.md`~~ (Anya gate — still open on VO side, not art)  
- [x] ~~`lock_day_script`~~ (after picture + VO both OK)  
- [ ] Moment clips A–C (picture pipeline, not plate fill)  
- [ ] B4 clip automation  
- [ ] Day 2 overview generation  

---

## Master checklist

### Prep
- [x] Inventory + prompts regenerated  
- [x] Phaser property crops for willows + college (+ full set)  
- [ ] Optional bird’s-eye moodboard crops (only if needed for exteriors)  
- [x] Style frame + continuity refs ready  

### P0 interiors — DONE
- [x] Willows pharmacy counter + market aisle (two plates; not `market_int.png`)  
- [x] `college_int_classroom.png`  

### P0 exteriors — DONE
- [x] `willows_pharmacy_exterior_wide.png`  
- [x] `oak_hill_college_exterior_wide.png`  

### P1
- [x] `pub_int.png`  
- [x] `supply_int.png`  
- [x] `pub_exterior_wide.png`  
- [x] `supply_store_exterior_wide.png`  
- [x] `artist_int_studio1.png` … `studio5.png`  
- [x] `artist_coliving_exterior_wide.png`  

### P2
- [x] House mains 1–3  
- [x] House 4 rooms + house 5–6 bedrooms  
- [x] `apartments_exterior_wide.png` (v2 linked terrace — approved 2026-07-20)  
- [x] `homes_row_exterior_wide.png`  
- [x] `johnson_park_exterior_wide.png` (bonus)  

### Close-out
- [x] `EXISTING_INTERIORS` updated  
- [x] Scripts re-run  
- [x] This file’s checkboxes reflect reality (2026-07-20)  
- [ ] Optional: Remotion baseline watch  

---

## Gap list — current (2026-07-20)

### Interiors

**None remaining** (57 DONE / 0 TODO). Do not regenerate plates already on disk.

### Exteriors still missing

**Have:** style frame · village overhead · Hobbs · dorm · library · Johnson Park  

**Need:** Willows · Oak Hill College facade · pub · supply · artist (opt) · apartments · homes row · (optional house 4–6)

### Already on disk — do not regenerate

All cafe / library / dorm common+bedrooms+baths · apt 1–5 main+bath · artist common + studios 1–5 + baths · house 1–6 baths/commons/mains/bedrooms · Willows counter+aisle · college classroom · pub · supply · Johnson Park outdoor · Phaser property top-downs for the above.

---

## If you only have 2 hours (updated)

1. Exteriors #1–#2 (Willows + college) — 40–50 min  
2. Baseline Remotion watch (no clips) — 30–40 min  
3. Stop. Clips / remaining exteriors / VO lock another session.

---

## Session notes

### Original plan day
**Date:** 2026-07-16  
**Intent:** full interior + exterior commission day.

### Work completed (through 2026-07-18; verified 2026-07-20)

**Shipped:**
- All planned **interiors** (Willows as two plates; classroom; pub; supply; artist studios 1–5; house mains/bedrooms) plus prior baths/apts/commons.
- **Johnson Park** outdoor plate.
- Full **Phaser `_moodboard/`** property top-downs for commission targets.
- **`EXISTING_INTERIORS`** registration + inventory/prompt regen → 0 interior TODOs.

**Still missing:**
- Commercial/civic **exteriors** (Willows, college, pub, supply) and residential row exteriors.
- Day-1 **Remotion baseline** + optional moment clips A–C.
- VO / `lock_day_script` gates (see `TODO_video.md`).

**Blockers / re-roll notes:**
- Single-file `market_int.png` abandoned in favor of counter + aisle (better workplace stamps).
- Bird’s-eye named moodboard crops skipped; Phaser manual crops are the layout SOT going forward.

**Next session starts at:** Remaining TODO **#1** (Willows exterior) or jump to **#8** (Remotion baseline) if exteriors stay optional.

---

*Plan authored for Ivan · village asset day · pairs with `video/TODO_video.md` Gate B. Status pass 2026-07-20.*
