> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# Pittsburgh Downtown — note from backend (for Nicolas)

**Date:** 2026-09-04 · **Update:** 2026-09-09  
**From:** Backend (`generative_agents`, branch `breakfasts`)  
**To:** Nicolas (`double-r3f`, branch `pittsburgh`)  
**Plan:** [`Pitts_Phaser.md`](../Pitts_Phaser.md) · look spec: [`MVP-0.1.md`](../../MVP-0.1.md) · cohort: [`MVP-breakfasts.md`](../../MVP-breakfasts.md) §1b

Engine work does **not** replace look. You do not wait on a Downtown sim, Supabase, or a Survival day.

---

## 2026-09-09 — livable homes (supersedes “one pad = one room”)

Same five pads. Nico **plans** livable layouts (living by the door, desk on a wall, bed private, bath behind a wall). If Roosevelt / Encore / Gateway can hold two real apartments, split them — extra street door per unit. Midtown and First & Market stay one. **Ivan stamps** walls/doors; then he furnishes. Do not pick new buildings. PPG: cafe + aisle from the door. Spec [`MVP-breakfasts.md`](../../MVP-breakfasts.md) §1b.

---

## 2026-09-07 — start Option A (shops + park)

Item 0 hollow is in. Ivan ingested the pack. **Furnish the five shops now** (PPG Cafe first), write objects into the CSVs, then Point State Park. No generator. ~96% of the map stays today’s OSM look.

- PPG door `[273, 221]`. Cafe **95** tiles / **95** walkable. Occupancy furniture is not walls; your Tiled chairs are the real furniture.
- Fifth Avenue Market door **`[286, 162]`** (old `[289, 161]` is gone).
- Cap 6. Ground floor only. Village-sized Doubles/doors are OK.
- If art and walk disagree: fix the **draw**, or ask Ivan before changing collision. **2026-09-09:** interior walls / extra home doors are an Ivan stamp from your cell list — still do not edit collision yourself.

**Homes — first pass is in (`pittsburgh-rooms`).** Next: you send wall/door cells; Ivan stamps; you furnish. Locked list is still these **five pads**. Star Loft is not a home. Do not draw Apt 1–5. Do not draw houses on `Residence 1`–`15`.

Allies will watch doubland.ai later. You still draw on `/simulations/pittsburgh-preview`. Do not merge to `vercel` / `double-front`.

---

## Paste-ready (Upwork) — **stale** (roofs / open-plan). Live lock: §1b 2026-09-09 above.

Hi Nicolas — backend status so you can keep drawing without waiting on us.

**What you see on `/simulations/pittsburgh-preview` is only an OpenStreetMap floor plan** (colored squares: brown footprints, beige roads, green park, blue river). That is **not** the product look. Please treat these as still open:

1. **Height** — not built (no towers / fake 3D).
2. **Pittsburgh outsides** — not built (no walls/windows; Phaser is coloring the grid).
3. **Rooms + village furniture** — five interiors exist in the *walk* files (PPG Cafe, market, supply, pub, college) but the preview paints them as **solid roofs**. Furniture is a few blocked squares, not chairs/counters from the small town. Do not draw houses on `Residence 1`–`15` — sidewalk start spots, not apartments.
4. **Streets that look like Pittsburgh** — walkable, look is still beige OSM strips.
5. **Living grid that updates when the sim moves a chair** — not built, **not this job** (same as the small town). If you add named furniture later, put it in the normal object layer so files match the picture.

**What backend already locked (draw on this, don’t reopen):** one walk grid, 409×437, 6 tiles per step, gathering at **PPG Cafe** (door `[273, 221]`, 95 cafe tiles / 95 walkable). Names: PPG Cafe, Fifth Avenue Market, EQT Supply Store, O’Reilly Pub, Penn College. Village Hobbs files stay village — don’t rename them.

**Files you already have in `double-r3f` (branch `pittsburgh`):** `public/assets/pittsburgh/` (walk grid) and `public/assets/the_ville/` (furniture kit to copy into the five rooms). Plan: `double-docs/R3F/Pitts_Phaser.md`.

**Do not wait on us.** Engine occupancy already walked on `20260904-1` (Luba sidewalk → PPG Cafe). That run is **not** on your preview — there are still no people on `/simulations/pittsburgh-preview`. Floor-plan walk files are enough for the engine; your job is the town picture. If art and walk disagree, fix the **draw**, or ask Ivan before changing collision. Don’t hollow more cafes. Don’t merge to `vercel` / `double-front`. Same Next on :3000.

Glance with Ivan after each phase (ground → height/outsides → five rooms → files match picture).

---

## What backend owns vs what you own

| | Backend | You |
|---|---|---|
| Walk / blocked / place names | Locked. Cap 6. PPG Cafe tiles. | Draw **on** that grid. |
| Picture of Pittsburgh | Not our job. Occupancy paint is not the town. | TODOs 1–4. |
| People / Survival / 11:00 | Engine walk **done** on `20260904-1` (not on this preview). Scored 11:00 is a founder call. Not on `railway`. | Don’t wait. Binding a live sim onto this viewer is later. |
| Collision CSV | Do not write Google polygons into it. | If walk and art disagree: fix draw, or ask Ivan. |

---

## Locks (same as `Pitts_Phaser.md`)

- One maze indoors and outdoors. No door teleport.
- PPG Cafe on One PPG Place. Do not stretch it to village Hobbs size. Do not re-hollow.
- Product assets: `/assets/pittsburgh`. `/assets/downtown` ~223×140 is an old fixture.
- Don’t clone `generative_agents` for look. Don’t use gitignored `tmp/pittsburgh-be-handoff/` unless Ivan rebuilds occupancy.
