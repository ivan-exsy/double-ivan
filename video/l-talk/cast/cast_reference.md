# soul15 cast reference — UUID ↔ name

Use when working with `video/assets/users/cutouts/{uuid}.png` (filenames are UUIDs only).

**Source:** `manifest.json` + `cohort_trailer_cast` in Supabase. Sorted by `spotlight_order`.

---

## Full roster

| Order | Display name | UUID | Cutout filename |
|------:|--------------|------|-----------------|
| 1 | Max Shoemaker | `bcf5fb65-6e7e-464a-83bb-51668f967f77` | `bcf5fb65-6e7e-464a-83bb-51668f967f77.png` |
| 2 | Alex Butcher | `0e8d6398-bfe5-40c7-9b6d-1eae2b0abc49` | `0e8d6398-bfe5-40c7-9b6d-1eae2b0abc49.png` |
| 3 | Ivan Pitts | `42c86639-8f93-4f97-a541-8cd5baf2fea8` | `42c86639-8f93-4f97-a541-8cd5baf2fea8.png` |
| 4 | Olivia King | `87daf41e-0237-4a55-a1ad-14007cefbefe` | `87daf41e-0237-4a55-a1ad-14007cefbefe.png` |
| 5 | Diana Ogden | `021d4622-9b7e-4b73-9f94-322c4e5121da` | `021d4622-9b7e-4b73-9f94-322c4e5121da.png` |
| 6 | Andrew Abrams | `be6de09c-91e4-42c7-a936-2193977dd17c` | `be6de09c-91e4-42c7-a936-2193977dd17c.png` |
| 7 | Irene Dove | `eac7be2a-b689-40be-a3a1-b4c4426ae9dc` | `eac7be2a-b689-40be-a3a1-b4c4426ae9dc.png` |
| 8 | Dean Sanford | `e8c1b20c-dff4-4ab3-836b-cf1d86a8b958` | `e8c1b20c-dff4-4ab3-836b-cf1d86a8b958.png` |
| 9 | Alexis Reed | `0c7ff9b1-44bc-4afe-a189-52d88d2abd09` | `0c7ff9b1-44bc-4afe-a189-52d88d2abd09.png` |
| 10 | Owen Logan | `cc277da1-521b-4ba8-8f78-a7a1f09c3a32` | `cc277da1-521b-4ba8-8f78-a7a1f09c3a32.png` |
| 11 | Vince Vale | `69835d95-c543-48b1-85c0-f7d5351d845d` | `69835d95-c543-48b1-85c0-f7d5351d845d.png` |
| 12 | Mike Hooks | `77c2f157-64bb-4fa0-b451-3a644661d1a4` | `77c2f157-64bb-4fa0-b451-3a644661d1a4.png` |
| 13 | Nick Miller | `e473df98-8abb-44e9-a73f-f89771ec91d2` | `e473df98-8abb-44e9-a73f-f89771ec91d2.png` |
| 14 | Alex Shepard | `f428ae04-975d-4163-b7e6-fbaea8befd24` | `f428ae04-975d-4163-b7e6-fbaea8befd24.png` |
| 15 | Vincent Slater | `29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca` | `29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca.png` |

Cutouts path: `video/assets/users/cutouts/`

**Grok prompts:** refer to people by **cutout filename** (or attachment order: image 1, image 2, …). Grok does not know display names.

**Cast-size row layout** (authoritative: `video/cast_group_layout.py`):

| Cast size | Rows | Split |
|----------:|------|-------|
| 3–5 | 1 | all in one row (center the group when &lt;5) |
| 6 | 2 | 3 + 3 |
| 7 | 2 | 4 + 3 |
| 8 | 2 | 4 + 4 |
| 9–10 | 2 | 5 + x |
| 11 | 3 | 4 + 4 + 3 |
| 12 | 3 | 4 + 4 + 4 |
| 13 | 3 | 5 + 4 + 4 |
| 14 | 3 | 5 + 5 + 4 |
| 15 | 3 | 5 + 5 + 5 |

Soul15 (15) uses fixed rows of 5 below. Smaller cohorts use `assign_cast_to_rows()` from spotlight order.

**API vs UI:** Grok Imagine **UI** accepts 5 attachments; **API** (`/v1/images/edits`) allows **max 3** per call. Use `generate_group_photo_row.py` for API (first 3 cutouts attached; all 5 named in prompt). Manual UI runs can attach all 5.

---

## Phase 2 group photo — rows of 5 (spotlight order)

Attach cutouts in the order below so prompt “image N” matches filename.

### Row A — orders 1–5 (attach all 5)

| Image # | Display name (you only) | Attach this file |
|--------:|-------------------------|------------------|
| 1 | Max Shoemaker | `bcf5fb65-6e7e-464a-83bb-51668f967f77.png` |
| 2 | Alex Butcher | `0e8d6398-bfe5-40c7-9b6d-1eae2b0abc49.png` |
| 3 | Ivan Pitts | `42c86639-8f93-4f97-a541-8cd5baf2fea8.png` |
| 4 | Olivia King | `87daf41e-0237-4a55-a1ad-14007cefbefe.png` |
| 5 | Diana Ogden | `021d4622-9b7e-4b73-9f94-322c4e5121da.png` |

### Row B — orders 6–10

| Image # | Display name (you only) | Attach this file |
|--------:|-------------------------|------------------|
| 1 | Andrew Abrams | `be6de09c-91e4-42c7-a936-2193977dd17c.png` |
| 2 | Irene Dove | `eac7be2a-b689-40be-a3a1-b4c4426ae9dc.png` |
| 3 | Dean Sanford | `e8c1b20c-dff4-4ab3-836b-cf1d86a8b958.png` |
| 4 | Alexis Reed | `0c7ff9b1-44bc-4afe-a189-52d88d2abd09.png` |
| 5 | Owen Logan | `cc277da1-521b-4ba8-8f78-a7a1f09c3a32.png` |

### Row C — orders 11–15

| Image # | Display name (you only) | Attach this file |
|--------:|-------------------------|------------------|
| 1 | Vince Vale | `69835d95-c543-48b1-85c0-f7d5351d845d.png` |
| 2 | Mike Hooks | `77c2f157-64bb-4fa0-b451-3a644661d1a4.png` |
| 3 | Nick Miller | `e473df98-8abb-44e9-a73f-f89771ec91d2.png` |
| 4 | Alex Shepard | `f428ae04-975d-4163-b7e6-fbaea8befd24.png` |
| 5 | Vincent Slater | `29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca.png` |

---

## Group row prompts (Grok Imagine)

**Approved Row A:** `group_photo_a.png` — camera-first cast lineup + character poses.

**Save outputs:** `group_photo_a.png`, `group_photo_b.png`, `group_photo_c.png`

### Row B prompt (orders 6–10) — copy into Grok

Attach images 1–5 in Row B table order, then paste:

```text
Compose one horizontal group photo of exactly five people for a vertical trailer cast poster.

IDENTITY (preserve EXACTLY from attachments): all five attached references must appear once each, with matching face, hair, age, skin tone, and outfit:
- image 1 / be6de09c-91e4-42c7-a936-2193977dd17c.png
- image 2 / eac7be2a-b689-40be-a3a1-b4c4426ae9dc.png
- image 3 / e8c1b20c-dff4-4ab3-836b-cf1d86a8b958.png
- image 4 / 0c7ff9b1-44bc-4afe-a189-52d88d2abd09.png
- image 5 / cc277da1-521b-4ba8-8f78-a7a1f09c3a32.png

Do not add, remove, or merge people.

CAMERA RULE (most important): every person looks directly into the camera lens — clear eye contact, faces toward viewer. This is a cast announcement photo, not a candid conversation. No one looks at another person. No profile-only faces. Heads may turn slightly; eyes stay on camera.

SCENE: pure black studio, subtle floor shadow, premium editorial photo-real (not illustrated). Full body head to toe, similar scale. Match the lighting and cast-photo style of row 1 (soft key from left, gentle rim).

POSE — professional ensemble row, evenly spaced; each person has a distinct stance that fits their vibe. Bodies can differ; faces stay on camera:

- be6de09c-91e4-42c7-a936-2193977dd17c.png: contrarian confidence — relaxed shoulders, slight knowing smirk, arms crossed loosely or one hand on hip; follows incentives, not headlines energy.
- eac7be2a-b689-40be-a3a1-b4c4426ae9dc.png: warm but sharp — open friendly posture, soft smile that still looks discerning; approachable, not soft.
- e8c1b20c-dff4-4ab3-836b-cf1d86a8b958.png: candid power-caller stance — square planted feet, direct unflinching gaze, minimal gesture; sees power plainly.
- 0c7ff9b1-44bc-4afe-a189-52d88d2abd09.png: evidence-first stillness — neat composed posture, calm evaluative expression, hands quiet at sides; measured skeptic.
- cc277da1-521b-4ba8-8f78-a7a1f09c3a32.png: headline-as-script analyst — slight head tilt, one eyebrow subtly raised, dry observant expression; reads the story behind the story.

FRAMING: wide horizontal strip, five people evenly spaced in one row (not a tight huddle). Every face fully visible and readable. No overlapping faces. No text, no logos, no props.

Row 2 of 3 for a 15-person cast — keep lighting and photo-real style consistent with row 1 for later merging.
```

### Row C prompt (orders 11–15) — copy into Grok

Attach images 1–5 in Row C table order, then paste:

```text
Compose one horizontal group photo of exactly five people for a vertical trailer cast poster.

IDENTITY (preserve EXACTLY from attachments): all five attached references must appear once each, with matching face, hair, age, skin tone, and outfit:
- image 1 / 69835d95-c543-48b1-85c0-f7d5351d845d.png
- image 2 / 77c2f157-64bb-4fa0-b451-3a644661d1a4.png
- image 3 / e473df98-8abb-44e9-a73f-f89771ec91d2.png
- image 4 / f428ae04-975d-4163-b7e6-fbaea8befd24.png
- image 5 / 29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca.png

Do not add, remove, or merge people.

CAMERA RULE (most important): every person looks directly into the camera lens — clear eye contact, faces toward viewer. This is a cast announcement photo, not a candid conversation. No one looks at another person. No profile-only faces. Heads may turn slightly; eyes stay on camera.

SCENE: pure black studio, subtle floor shadow, premium editorial photo-real (not illustrated). Full body head to toe, similar scale. Match the lighting and cast-photo style of rows 1 and 2 (soft key from left, gentle rim).

POSE — professional ensemble row, evenly spaced; each person has a distinct stance that fits their vibe. Bodies can differ; faces stay on camera:

- 69835d95-c543-48b1-85c0-f7d5351d845d.png: measured realist — balanced neutral stance, calm scrutinizing gaze, hands relaxed; measures claims against reality.
- 77c2f157-64bb-4fa0-b451-3a644661d1a4.png: definitional precision — upright still posture, composed serious expression, one hand slightly raised with pinching gesture as if defining a term; argues in definitions, not slogans.
- e473df98-8abb-44e9-a73f-f89771ec91d2.png: pragmatic operator — practical grounded stance, slight forward lean, confident workable-solutions energy; wants what actually works.
- f428ae04-975d-4163-b7e6-fbaea8befd24.png: nuance and gray zones — relaxed asymmetric stance, thoughtful half-smile, open but careful expression; sees complexity others skip.
- 29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca.png: who-benefits intensity — solid guarded stance, direct piercing gaze, subtle tension in shoulders; asks who benefits every time.

FRAMING: wide horizontal strip, five people evenly spaced in one row (not a tight huddle). Every face fully visible and readable. No overlapping faces. No text, no logos, no props.

Row 3 of 3 for a 15-person cast — keep lighting and photo-real style consistent with rows 1 and 2 for later merging.
```

---

## Phase 3 — cast montage (`fifteen_spotlight_montage`) — **Done 2026-06-25**

**Approved reference:** `video/remotion/out/soul15_seed_20260224_spotlight_preview_v2.mp4`

| Beat | What | Duration |
|---|---|---:|
| Intro | Static 5×3 `MatrixIdentityGrid` | 3.5 s |
| ×15 spotlights | Tile morph → fullscreen hero + name/trait → morph back | 2.6 s each (3.0 s anchors) |
| Close | `group_photo_matrix.png` + `N DOUBLES ONLINE` | 2.5 s |

Motion rules (locked): content swap at **tile size** before/after scale; roster grid **still** (no glow pulse); caption visible during scale-up, hold, and scale-down.

```bash
python -m video.build_fifteen_spotlight_props --cohort soul15_seed_20260224
cd video/remotion
# Builder prints next versioned filename, e.g. …_spotlight_preview_v3.mp4
npx remotion render OpenerTrailer out/<printed_name>.mp4 \
  --props=props/soul15_seed_20260224__spotlight_preview.json
```

Full spec: `trailer-opening/20260625_trailer-workbook.md` § Cast montage motion grammar.
