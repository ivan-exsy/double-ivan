# Design brief — Survival trading-card frames (§TODO-E)

**To:** AI design agent / design team
**From:** Ivan Pistsov, founder — Doubland (https://doubland.ai)
**Date:** 2026-05-14
**Phase:** Trailer pipeline §TODO-E (`20260501_opening-trailer.md`)
**Reply type:** 3 transparent PNG overlays (1280×720) + layered source files (Figma or PSD) + a 1-paragraph rationale per frame.

---

## 1. The one-line job

Design **3 archetype card frames** — Champion, Wildcard, Observer — that wrap each Double's intro card during the trailer's cast section. They currently ship as FFmpeg-drawn placeholder borders; your job is to replace those with finished, on-brand frames.

**Critical constraint:** these 3 frames are the *entire* set. They are reused unchanged across every Survival cohort and **every cast size from 4 to 15 Doubles**. There are no per-cast variants and no per-Double variants. Design them once, correctly, so they hold up whether the trailer has 4 cards or 15.

---

## 2. How the frames get used (read this before designing)

Each Double is auto-assigned one archetype (Champion / Wildcard / Observer / Connector). The matching frame is composited behind that Double's content during the cast-intro section. **Connector personas use the Champion frame in v1** — so Champion is the most-used frame; design it as the "default hero" look.

The cast section plays as a **grid → zoom → grid** flow, which means each frame is seen at **two very different sizes**:

| State | Size on screen | What must be legible |
|---|---|---|
| **Zoom state** (one Double full-screen) | Full 1280×720 | Everything — portrait, name, role tag, bio, trait moment |
| **Grid state** (whole cast at once) | Downscaled to one grid cell | Only the frame's *identity* — border treatment, palette, corner motif. Text is NOT expected to be readable here. |

The grid cell size shrinks as the cast grows. Worst case is a **15-Double cast**, which packs into roughly a 4×4 or 5×3 grid — i.e. each card is downscaled to **~256–320 px wide**. See §4 for what this demands of you.

The right-hand region of every frame (see layout below) is **reserved for a live sprite-walkout video** that plays inside the card. That zone must stay fully transparent — no border chrome, no texture, no shadow may intrude into it.

---

## 3. Common layout — identical across all 3 frames

1280×720 transparent PNG. Content zones (x, y from top-left):

| Zone | Size | Position | Holds |
|---|---|---|---|
| Sketch portrait cutout | 320×400 | (80, 160) | Double's front-neutral sketch |
| Name text | 720×60 | (440, 200) | Double's name |
| Role tag | 200×40 | (440, 280) | Archetype label |
| Bio text | 720×80 | (440, 340) | 5–9 word bio |
| Trait moment | 1100×120 | (90, 540) | ~12–20 word trait line |
| **Sprite-walkout video** | 720×160 region | right side (560–1280, 0–160) | **Keep fully transparent — no frame elements here** |

Engineering composites text and portrait into these zones at render time. Your frame art is the border, background fill, textures, corner treatments, role-tag styling, and any decorative furniture — **not** the text itself. But you must mock the text in (see §5) to prove the zones work.

---

## 4. Cast-scaling requirements (the part that's new)

This is why the brief exists. The frames must satisfy **all** of the following:

1. **Identity survives downscaling to ~256 px wide.** In the grid state with a 15-Double cast, a viewer must still be able to tell a Champion card from a Wildcard card from an Observer card *at a glance*, with no text. That means the distinction has to live in **border weight, palette, and silhouette/corner motif** — not in fine filigree that turns to mush below 320 px. Mock each frame at 256 px wide and confirm it still reads.

2. **No detail that only works at full size.** Hairline 1 px rules, sub-20 px filigree, and subtle drop-shadows are fine *as long as* the frame's core identity does not depend on them. If you remove every sub-30 px detail, the three frames must still be distinguishable.

3. **Text zones must hold worst-case content, not just sample content.** The cast is unknown at design time. Mock the name zone with a long name (~22 characters), the bio zone with a full 9-word line, and the trait zone with a 20-word line. If text overflows a zone, the zone or the type spec is wrong — fix it now, not at render time.

4. **One frame, every cohort.** Do not bake in anything cohort-specific (no family names, no season titles, no cast counts). The frames are pure archetype skins.

5. **Even visual weight across the set.** Because cast size and archetype mix vary, a grid can be all-Champion or a near-even split. No frame may visually dominate or recede when tiled next to the others — they should sit as equals in a grid.

6. **Deliver layered source.** Hand back editable Figma (preferred) or PSD with the 6 content zones on labeled, separate layers, so engineering can re-template type specs without re-commissioning art.

---

## 5. The 3 frames — style direction

### Frame 1 — Champion (premium tournament aesthetic) — *also used by Connectors*
- 8 px metallic gold/bronze border — `linear-gradient(135deg, #C8A86B, #8B6E2F)`; ornate filigree corners ~40 px (decorative only — identity must survive without them per §4.1)
- Warm radial background `#2A1810 → #0A0504`
- Wax-seal role tag; label in bold serif white
- Name: bold serif (Cinzel / Trajan), white, 48 pt, 0.05em tracking. Bio: italic serif `#E8DCC4`, 24 pt. Trait: 36 pt + 2 px black drop-shadow.

### Frame 2 — Wildcard (scrapbook, off-kilter)
- 6 px hand-drawn line border, slight ink-bleed; whole frame rotated 1.5° clockwise
- Torn-paper / masking-tape rectangles at 2 corners; off-white `#F4EBD8` paper-texture background
- Hand-drawn rectangle role tag, label in marker font, slight opposite tilt
- Name: Permanent Marker / Architects Daughter, black, 48 pt. Bio: hand-drawn font, 24 pt dark grey. Trait: marker, 36 pt navy ink.

### Frame 3 — Observer (minimalist editorial)
- 1 px solid line border, neutral cream `#E5DCC9`, subtle shadow; soft gradient background `#F8F4ED → #E5DCC9`
- Role label small all-caps 14 pt, 0.2em tracking, lower-left corner
- Name: light sans (Inter Light / Helvetica Neue Light), charcoal `#2A2A2A`, 48 pt. Bio: same family, 22 pt mid-grey `#6B6B6B`. Trait: same, 32 pt charcoal.
- Single 1 px hairline, 360 px, under the name

> **Role-tag wording:** Champion → "ALLIANCE LEADER", Wildcard → "WILDCARD", Observer → "OBSERVER". Connectors render under the Champion frame but engineering may pass a different tag string — keep the wax-seal tag legible for label strings up to ~16 characters.

---

## 6. Inputs to consume

| # | File | Role |
|---|---|---|
| 1 | `video/assets/village/exterior/_style_frame_master.png` | **PRIMARY STYLE REFERENCE** — the canonical Doubland storybook look. Every frame must read as living in this world. |
| 2 | `concept/brand.md` (`D:\Coding\double-ivan\concept\brand.md`) | Brand bible — palette discipline, tone, "no red / no neon" guardrails |
| 3 | A persona front-neutral sketch — `video/assets/users/character-sheets/<uuid>/front_neutral.png` | Mockup portrait. Any persona works; Ivan will point you at Luba's exact path if you want the canonical one. |
| 4 | `20260501_opening-trailer.md` §TODO-E | Source spec this brief expands; read for pipeline context |

If any input cannot be loaded, stop and flag.

---

## 7. Deliverables

1. `card_frame_champion.png` — 1280×720, transparent PNG
2. `card_frame_wildcard.png` — 1280×720, transparent PNG
3. `card_frame_observer.png` — 1280×720, transparent PNG
4. Layered source (Figma or PSD) with the 6 content zones on labeled layers
5. One short paragraph per frame: what carries its identity at thumbnail size, and what is decorative-only

Final filenames drop into `video/assets/archetypes/`.

---

## 8. Acceptance criteria

A frame passes only if **all** hold:

- [ ] Mocked with one persona's sketch + worst-case-length name, bio, and trait text — nothing overflows its zone
- [ ] The 3 frames read as distinct personalities at **1280×720 full-screen**
- [ ] The 3 frames are still **distinguishable from each other at 256 px wide** (15-Double grid thumbnail) with no text
- [ ] The sprite-walkout region (right side, 560–1280 × 0–160) is fully transparent — zero frame chrome intrudes
- [ ] No cohort-specific or cast-size-specific content baked in
- [ ] Layered source delivered; the 6 content zones are individually editable
- [ ] Palette stays within brand guardrails (no red, no neon, no pure-white headlines)

---

## 9. Tooling note

Figma gives the cleanest text-zone control (~1 h/frame) and the layered source we need. Midjourney is faster but imprecise on text zones — if used, the layered Figma/PSD re-build is still required for delivery. The FFmpeg-drawn placeholder is the current v0 and the baseline you are replacing.
