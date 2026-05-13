# Design brief — Doubland brand opener wordmark composition (6a)

**To:** AI design agent
**From:** Ivan Pistsov, founder — Doubland (https://doubland.ai)
**Date:** 2026-05-13
**Phase:** Trailer pipeline §6a (`20260501_opening-trailer.md` Phase 6)
**Reply type:** 3 still-frame PNGs (1280×720) + a 1-paragraph rationale per variant.

---

## 1. The one-line job

Compose the locked wordmark **`DOUBLAND — What if?`** (H1 + H2 two-line lockup) onto the locked iconic-still background, in **3 positioning/typography variants**, so we can pick a winner and proceed to motion treatment.

Everything else — the wordmark text, the background image, the palette, the emotional register — is already locked. Your scope is **type composition only**: font choice, size, kerning, vertical/horizontal position, weight contrast between H1 and H2, optional glyph treatment, optional subtle visual furniture (rule, divider, glow). No re-painting the background. No changing the words.

---

## 2. Inputs you must consume

Provide these files to the model alongside this brief, in this order:

| # | File | Role | Why |
|---|---|---|---|
| 1 | `video/assets/production/brand/brand_opener_iconic_still.png` | **PRIMARY CANVAS** — composite over this exact image | Locked background plate: dusk village with cyan wireframe duality. The 3 variants must be composed onto this image at full resolution. |
| 2 | `video/assets/production/brand/brand_end_card.png` | **TONE / TYPOGRAPHY REFERENCE** — match this aesthetic | The selected end-card design (council platform, cream serif headline, gold underline accent, doubland.ai glow). The wordmark opener must read as a sibling to this card. |
| 3 | `video/assets/production/brand/brand_end_card_background.png` | Negative-space reference | Shows the unadorned plate the end card is built on — useful for understanding how typography sits on dark cinematic backgrounds in our system. |
| 4 | `concept/brand.md` (from `D:\Coding\double-ivan\concept\brand.md`) | **BRAND BIBLE** — register, vocabulary, "What if?" system | Read §"The 'What if?' System" and §"Visual & Tone Guardrails" before composing. |
| 5 | `done/20260512_design-brand-intro-request.md` (archived) | Historical context | Original design-team brief — palette codes and reference shows live here. Do not follow it verbatim; this brief supersedes its §3 Deliverable A. |

If any of these files cannot be loaded, stop and flag.

---

## 3. Locked elements (do NOT alter)

| Layer | Locked value | Source |
|---|---|---|
| Wordmark H1 text | **`DOUBLAND`** (all caps) | brand bible, IP-cleared 2026-05-12 |
| Wordmark H2 text | **`What if?`** (sentence case, question mark glued, no italics) | brand bible §"Visual & Tone Guardrails" |
| Lockup orientation | Two-line, H1 above H2 | locked |
| Background image | `brand_opener_iconic_still.png` — no re-paints, no crops, no recolors | locked |
| Primary cream | `#F2EBD8` (wordmark headline color) | brand bible |
| Secondary light gray | `#CCCCCC` (H2 supporting color, optional) | brand bible |
| Warm gold accent | `#C8A86B` (underlines / rules only, sparingly) | brand bible |
| Forbidden colors | red, neon, primary saturated colors, white `#FFFFFF` for headline | brand bible: "No red" + tone guardrails |
| Cyan wireframe | Never overlap with wordmark or tagline (different planes) | brand bible |
| Aspect | 1280×720 master (16:9). Each variant must also crop sanely to a 1080×1920 9:16 crop window (test mentally; do not deliver 9:16). | trailer pipeline constraint |

---

## 4. What varies across the 3 variants

You must produce **three meaningfully different** compositions. Vary across these axes — pick a coherent combination per variant, don't just nudge the same layout three times:

| Axis | Options |
|---|---|
| **Wordmark vertical position** | upper third / true center / lower third |
| **Wordmark horizontal alignment** | centered / left-aligned (like end-card 2) / right-aligned |
| **H1 weight + scale** | tall display serif vs condensed serif; large (font-size ~140–180 px @ 720p) vs restrained (~90–110 px) |
| **H2 treatment** | smaller serif of same family / contrasting sans-serif / serif italic alt / spaced caps |
| **H2 separator** | em-dash (`—`), gold underline rule between lines, vertical pipe (`|`), no separator |
| **Optional glyph** | none / small monogram mark / question-mark as standalone glyph (per brand bible: "Question mark = brand element") |
| **Negative space** | hero the village in negative space / let typography dominate / framed by atmospheric vignette |

**Suggested variant matrix** (use as a starting point; reasoned departures welcome):

- **Variant A — "Editorial centered."** Centered horizontally + vertically. Large display serif H1 (`#F2EBD8`), em-dash + H2 in slightly smaller serif italic or contrasting weight. No glyph. Treat as the "movie poster" reading.
- **Variant B — "Council-platform sibling."** Left-aligned in upper-third (mirrors `brand_end_card.png` composition). H1 cream serif with thin gold underline rule below; H2 smaller, light-gray sans-serif, sitting under the rule. Most direct sibling to the locked end card.
- **Variant C — "Question-as-mark."** Wordmark holds true center but small. The "?" of "What if?" is enlarged as a standalone glyph element — either floating above the lockup or doubling as the brand glyph at reduced opacity behind the wordmark. Riskier, more brand-distinct.

---

## 5. Constraints + no-go list

**Constraints:**
- Output 3× PNG, 1280×720, sRGB, with the wordmark composed onto the locked background as a flat raster.
- Also deliver each wordmark as a transparent-PNG layer (1280×720, alpha) so engineering can re-composite without rebaking.
- Filenames: `brand_opener_splash_variant_a.png`, `_b.png`, `_c.png`, plus `brand_opener_wordmark_variant_a_alpha.png` (etc.).
- Place final files in a flat zip — engineering will move them into `video/assets/production/brand/` after pick.

**Do not:**
- Re-paint, blur, recolor, or crop the background.
- Add weather VFX, lens flares, or motion blur — this is the static frame; motion is a separate stage (6c).
- Use any color outside the locked palette. Especially no red, no neon, no pure white headline.
- Italicize "What if?" — locked per brand bible.
- Add taglines, dates, URLs, or sub-copy. The only text on screen is `DOUBLAND` and `What if?`.
- Use SaaS / startup / tech-brand typography (Inter, SF Pro, Helvetica, Geist, monospace). Reach for cinematic editorial serifs.
- Add the cyan wireframe to the typography layer.

---

## 6. Acceptance criteria

A variant passes when:

1. A cold viewer can read `DOUBLAND` and `What if?` within the first 1.5 seconds at typical TV viewing distance.
2. The composition reads as a sibling of `brand_end_card.png` — same palette, same emotional register, same restraint.
3. Cropping the 1280×720 frame to a centered 9:16 column keeps the wordmark legible (no critical type falling outside the crop).
4. The variant respects every locked element in §3.
5. The 3 variants are **meaningfully different** — picking between them is a real design decision, not a coin flip on kerning.

---

## 7. Reply format

For each variant, deliver:

1. The composed PNG (1280×720).
2. The wordmark-only alpha PNG (1280×720).
3. A 1-paragraph rationale (≤80 words): position chosen + font choice + the single thing this variant gambles on that the others don't.

After the three, add one closing paragraph (≤120 words) with your own recommendation: which variant should we pick, and what would you change about it before sending to motion treatment (6c).

---

## 8. Out of scope (do not produce)

- Motion / animation (separate stage 6c).
- Brand sound (separate stage, deferred to v2.x).
- Updated iconic flyover video (separate Deliverable C — possibly satisfied by existing `cinematic_flyover_village_dusk_wind_down.mp4`).
- End-card redesign (already locked at `brand_end_card.png`).
- 9:16 deliverables (16:9 master only; 9:16 considered in v2.x).
