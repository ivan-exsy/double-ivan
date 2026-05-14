# Trailer asset playbook — base_family_sim and beyond

> Asset commission punch list for opening trailers (PRD §4.2). v0 pipeline shipped 2026-05-01 against `20260430-7`; latest opener at `data/20260506-5/opener&001/output/trailer_16x9.mp4` (rendered 2026-05-11 with real anthem + 4 archetype stings; pending user-requested revisions — see "Feedback & Corrections" at the bottom of this doc). This doc says what to commission for `base_family_sim` (Pistsov family) now, and how to repeat the workflow for any new cast or new village.

---

## What to do right now (base_family_sim)

The pipeline is end-to-end working. All commissioned-asset TODOs are now closed except commissioned card frames (§TODO-E remains as drawbox placeholders) and the post-2026-05-11 revision queue below:

1. **Per-village baseline** (one-time for the_ville) — §TODO-M style frame ✓ + §TODO-N exteriors ✓ + §TODO-O interiors ✓ all DONE
2. **Per-cohort assets** (Pistsov family) — §TODO-P character sheets ✓ + §TODO-A polished sprite walkouts ✓ + §TODO-Q hero pairings ✓ all DONE
3. **Per-cohort/season audio** — §TODO-C anthem ✓ DONE 2026-05-11
4. **Per-archetype** (commission once forever, reusable across cohorts) — §TODO-D archetype stings ✓ DONE 2026-05-11 → §TODO-E commissioned card frames **STILL OPEN** (placeholder borders shipping today)
5. **Revisions pass 1** (2026-05-11): ✓ drop 9x16, ✓ drop stings, ✓ remove archetype labels — all shipped via `compose_trailer.py` flags.
6. **Narration overhaul + LLM cache** (2026-05-12): ✓ Burnett 6-beat structure automated via `narration_cache` + 6 system prompts in `showrunner.py` — see "Round 3 milestone" subsection in Feedback & Corrections.
7. **Brand wordmark locked 2026-05-12 (content) + 2026-05-13 (typography):** composite mark **`DOUBLAND — What if?`** (H1 + H2) cleared by IP counsel (non-blocking vs. Marvel's *"What If…?"*). Iconic flyover background at `video/assets/production/brand/brand_opener_iconic_still.png`. Locked typeset composition at `video/assets/production/brand/opening_wordmark.png` (Editorial centered, gold rule between H1 and H2). Remaining brand-open work: motion treatment (6c) + engineering integration (6e).
8. **Round 3 closing (DONE 2026-05-12):** single-card end card with cohort-aware content, "Day 1 starts now" closing VO, how-to-watch card retired. Shipped in `ff7cf5a0`.
9. **Still open** (full execution order in Feedback section): §TODO-S logo splash typography + motion (in flight); §TODO-T iconic flyover motion (in flight); #6 cast-intro grid restructure; #8 Phaser↔rendered fusion beat; #10 two-tier Phaser capture system.

Auto-generated each render: §TODO-B bios, §TODO-G archetypes, §TODO-H cold open, §TODO-I flyover narration, §TODO-J end card. No commission needed.

**(Re-)render trailer once assets land:**
```
python -m video.generate_trailer base_family_sim --mode opener --top 4 \
  --cohort-name "Pistsov family" --season-title "Who will stay alive"
```

---

## Trailer structure (orientation)

5 beats, ~130s. Sells the people, not the events.

| Beat | Time | Carries |
|---|---|---|
| Cold open | ~10s | Narrator names the stakes |
| Cast intros | ~90s (6 × 15s) | Sketch portrait → sprite cameo → name + bio → silent trait moment |
| Stakes montage | ~25s | Cinematic flyovers + narrator drama |
| End card | ~5–8s | Watch live + CTA |

**Cast-intro per-persona blueprint (15s each):**

| t | Element |
|---|---|
| 0.0s | Sketch portrait full-frame on archetype card frame (1.5s) |
| 1.5s | Crossfade into their sim home |
| 2.5s | Sprite walks out / waves (2–3s) |
| 5.0s | Name card + one-line bio (3s) |
| 8.0s | Silent trait moment as on-screen text (4s) |
| 12.0s | Persona sting + transition (3s) |

**Locked decisions (no re-debate):** sketch portraits, not photos · no per-persona VO (silent trait moments only) · 4 archetypes (champion / wildcard / observer / connector) · cohort = "Pistsov family", season = "Who will stay alive".

---

## Asset taxonomy

Every commissioned asset belongs to one bucket. The bucket determines when you produce it and when you can reuse it.

| Bucket | Replicate when | Items |
|---|---|---|
| **Per-village** | new village | M (style frame) · N (exteriors) · O (interiors) |
| **Per-cohort** | new cast | P (character sheets) · A (sprite walkouts) · Q (hero pairings) |
| **Per-cohort/season** | new season | C (anthem) |
| **Per-archetype** | once forever | D (stings) · E (card frames) |
| **Per-trailer / auto** | every render | B · F · G · H · I · J |

**Cross-cutting rules (apply to every commissioned asset):**

- **Lock aspect ratios first.** 1280×720 (16:9 master) + 1080×1920 (9:16 vertical). Generate references in both where they'll be cropped differently.
- **Batch within a bucket.** All exteriors in one Midjourney session with locked seeds; same for interiors; same for character sheets. Cross-session generations drift.
- **Reference saturation cap.** Feed any derivative the 2–3 strongest baseline refs — not all of them. More refs ≠ better.
- **Always cite §TODO-M.** Every other asset commission uses the style frame as primary look reference.

**Filesystem layout** (under `D:\Coding\generative_agents\`):

```
video/
├── assets/
│   ├── phaser/                          # Phaser auto-captures
│   │   ├── establish_*.png              # 6 establishing shots
│   │   ├── home_topdown_*.png           # per-persona home top-downs
│   │   └── sprite_walkout_*.webm        # native Phaser fallback (auto)
│   ├── users/                           # per-double assets
│   │   ├── headshots/                   # original photos (input to sketch gen)
│   │   ├── sketches/                    # generated sketches (front-neutral, .png or .jpg)
│   │   ├── character-sheets/{agent_id}/ # §TODO-P (8–10 views per double)
│   │   └── sprite-walkouts/             # §TODO-A polished MP4s
│   ├── scripts-prompts/                 # asset-generation tooling (universal + cohort)
│   ├── village/                         # per-village (currently: the_ville)
│   │   ├── _moodboard/                  # context crops + inspiration refs
│   │   ├── exterior/                    # §TODO-N ✓ DONE 2026-05-07
│   │   │   ├── _style_frame_master.png              # §TODO-M canonical style ref
│   │   │   ├── village_overhead_wide.png            # establisher / overhead layout
│   │   │   ├── hobbs_cafe_exterior_wide.png
│   │   │   ├── dorm_exterior_wide.png
│   │   │   ├── library_exterior_wide.png
│   │   │   └── _layout-reference_open-roofs.png    # alt: see-through-roof layout ref
│   │   └── interior/                    # §TODO-O ✓ DONE 2026-05-08 (9 files)
│   ├── cohort/                          # per-cohort
│   │   ├── hero/                        # §TODO-Q ✓ DONE 2026-05-09 (Pistsov: 4 stills in pistsov_family/)
│   │   └── how_to_watch_card_*.png      # §TODO-J
│   └── archetypes/                      # per-archetype (reusable forever)
│       ├── card_frame_{type}.png        # §TODO-E (champion / wildcard / observer)
│       └── sting_{archetype}.wav        # §TODO-D (4 archetypes)
├── audio/
│   ├── music_anthem.mp3                 # §TODO-C ✓ DONE 2026-05-11 (used by opener mode)
│   ├── music_drama.mp3                  # day-overview drama mood (one of 3 daily-recap variants)
│   ├── music_intrigue.mp3               # day-overview intrigue mood
│   ├── music_wholesome.mp3              # day-overview wholesome mood
│   ├── normalize.sh                     # two-pass loudnorm: --target sting (-12 LUFS) | --target music (-16 LUFS)
│   └── sfx/                             # general sound effects
└── fly-over/
    ├── cinematic_flyover_*.mp4          # §TODO-I (5 shipped 2026-05-04)
    ├── cinematic_village_aerial_tudor.mp4    # Phase 9 cinematic plate (2026-05-13); aerial Tudor village, on-brand storybook aesthetic, full cinematic — primary Phase 9 fusion-beat second half
    ├── cinematic_village_courtyard_dusk.mp4  # Phase 7 commission byproduct (2026-05-13); ground-level Tudor courtyard, dusk — stakes-montage atmospheric / end-card motion variant
    └── signature_flyover.mp4            # Phase 9 schematic plate (2026-05-13); pixel-art top-down village with animated sprites — Phase 9 fusion-beat first half / cold-open background / stakes-montage atmospheric
```

---

## Status snapshot

| TODO | Bucket | State | Note |
|---|---|---|---|
| §TODO-M Style frame | Per-village | **DONE 2026-05-08** | `_style_frame_master.png` is the canonical look reference; cite as primary style ref for all downstream commissions |
| §TODO-N Exteriors | Per-village | **DONE 2026-05-07** | 4 eye-level approach shots + 1 layout ref: village / cafe / dorm / library |
| §TODO-O Interiors | Per-village | **DONE 2026-05-08** | 9 Phaser-grounded interiors: cafe ×2, dorm common ×1 (+ vertical) + 4 numbered bedrooms, college library ×2. Cottages/pub/park/shops skipped — Pistsov family doesn't visit them. |
| §TODO-P Character sheets | Per-cohort | **DONE 2026-05-08** | 19 personas × 5 views = 95 PNGs in `users/character-sheets/{uuid}/`; automated via `scripts-prompts/generate_character_sheets.py` |
| §TODO-A Sprite walkouts | Per-cohort | **DONE 2026-05-08** | 19/19 MP4s in `users/sprite-walkouts/{uuid}.mp4` — Pistsov family ×4 + soul15 cohort ×15. Automated via `scripts-prompts/generate_sprite_walkouts.py` (xAI `grok-imagine-video`, async). |
| §TODO-Q Hero pairings | Per-cohort | **DONE 2026-05-09** | 4 stills in `cohort/hero/pistsov_family/` (Ivan kitchen late-morning, Luba cafe morning, Katya library afternoon, Gosha bedroom night). Automated via `scripts-prompts/generate_hero_pairings.py` (xAI multi-image-edit, up to 3 input images per call: room + persona front_neutral + style frame). Driven by external scene-config JSON (`hero_scenes_pistsov_family.json`) for cohort reuse. |
| §TODO-C Anthem track | Per-cohort/season | **DONE 2026-05-11** | 163.7s anthem at `video/audio/music_anthem.mp3`, normalized −16 LUFS / −5.4 dBTP via `normalize.sh --target music`. Opener script generator (`showrunner.py:1122`) now sets `mood="anthem"` so `_resolve_music()` picks the new file; daily-recap mood pool (drama/intrigue/wholesome) untouched. Stings ear-checked at 15s intervals: accepted as-is. |
| §TODO-D Archetype stings | Per-archetype | **DONE 2026-05-11** | 4 stings shipped at `archetypes/sting_{champion,wildcard,observer,connector}.wav`, normalized to −12 LUFS / −1 dBTP via new `video/audio/normalize.sh`. Compose path already wired (`_build_sting_overlays()` + `mix_audio(sting_overlays=...)`); files auto-overlay at name-card moment. Originals preserved in `archetypes/_raw/`. |
| §TODO-E Card frames | Per-archetype | **PARTIAL** | FFmpeg-drawn placeholders; commissioned PNGs slot in |
| §TODO-R Voice ref | Per-cohort | **DEFERRED** | No per-double VO in v1 |
| §TODO-B Bios | Auto | DONE | Tier-B LLM |
| §TODO-F Home / establishing shots | Auto | **REOPENED 2026-05-11** | `capture_static_assets.py` outputs (`establish_*.png`, `home_topdown_*.png`, `sprite_walkout_*.webm`) are stale and unfit — see Feedback & Corrections obs. #10 + suggestion #10. Being replaced by the two-tier capture system (cohort-agnostic bake + per-sim-day Tier B captures driven by showrunner LLM `atmospheric_key_steps`). |
| §TODO-G Archetypes | Auto | DONE | Tier-B LLM |
| §TODO-H Cold open | Auto | DONE | Templated + ElevenLabs |
| §TODO-I Flyovers + narration | Auto | DONE 2026-05-04 | 5 Grok flyovers + LLM narration. *Augmented 2026-05-13:* +3 Phase-7-commissioned assets — `signature_flyover.mp4` (pixel-art top-down with sprites), `cinematic_village_aerial_tudor.mp4` (aerial Tudor village, locked aesthetic), `cinematic_village_courtyard_dusk.mp4` (ground-level Tudor courtyard). The first two are Phase 9 fusion-beat plates; the third is a stakes-montage atmospheric. |
| §TODO-J End card | Auto | DONE | v2 spec: 5 lines, ~8s |
| §TODO-K Sketch normalization | Decided | DECIDED | Leave as-is for v0 |
| §TODO-L Cohort + season title | Decided | DECIDED | Pistsov family / Who will stay alive |

---

## Per-village specs

### §TODO-M. Style frame — DONE 2026-05-08

**Status:** `video/assets/village/exterior/_style_frame_master.png` is the canonical look reference for the_ville. Eye-level 3/4 view of the village square — half-timbered Tudor cottages with honey-amber timber, cream stone foundations, clay-tile roofs, golden-hour key light, warm interior glow, lanterns and string lights as cosy practicals. Every future per-village or per-cohort commission must cite it as primary style reference.

`village_overhead_wide.png` reverts to its proper role as a pure establisher / overhead layout reference — no longer the style anchor.

**For new villages:** commission the style frame *before* the exteriors, eye-level (not overhead), at the time-of-day and material palette you want every downstream asset to inherit. The establisher and the style frame are two different deliverables; don't conflate them again.

### §TODO-N. Exterior environment library — DONE 2026-05-07

**Status:** Five files commissioned for the_ville. Stored in `video/assets/village/exterior/`.

**Files:**

| File | Description |
|---|---|
| `village_overhead_wide.png` | Pure top-down aerial of the whole village, golden hour. Anchor / establisher / de facto style frame. |
| `hobbs_cafe_exterior_wide.png` | Eye-level approach POV (3/4 angle) of Hobbs Cafe with patio path. |
| `dorm_exterior_wide.png` | Eye-level approach POV of the communal dorm (entrance side; opposite face from what's visible in the village aerial). |
| `library_exterior_wide.png` | Eye-level approach POV of "Oak Hill Library" (two-wing stone-and-tile civic building). |
| `_layout-reference_open-roofs.png` | Alt take of the village overhead with see-through roofs; useful as a layout reference for commissioning interiors. |

**Approach used:**
- **Pure top-down** for the village establisher (matches the Phaser visual convention).
- **Eye-level approach POV** (3/4 angle, 35mm lens, ~1.6m camera height) for individual buildings — more cinematic and character-friendly for derivative scenes.
- **Two references per shot:** a context crop of `village_overhead_wide.png` (style anchor — saved per-building under `_moodboard/`) + the corresponding Phaser top-down ref from `video/assets/phaser/` (layout).
- **Golden hour** for all (decided 2026-05-07 to simplify; no dawn/dusk variants).

**Skipped vs original punchlist (intentionally):**
- Detail close-ups (door / window / corner shots) — not commissioned. Will revisit if hero pairings need them.
- Park exterior, village square, homes row — skipped. The four buildings above plus the village establisher cover what the trailer actually exercises.

**Reusability:** all five files are reusable for any new cast in the_ville. New villages need their own equivalent set.

**Prompt templates:** `video/assets/scripts-prompts/!prompts.md` (versioned in-repo) — use these as a starting point for new villages or re-runs.

### §TODO-O. Interior environment library — IN PROGRESS (16/57 covered as of 2026-05-09)

**Status:** Phaser-grounded interior shots commissioned for the_ville. Stored in `video/assets/village/interior/`. Coverage tracked in `_room_inventory.md`'s top-of-file dashboard (currently 16 DONE / 41 TODO / 6 N/A).

**Files (in generation order):**

| File | Subject | Arenas covered |
|---|---|---|
| `cafe_int_dining.png` | Hobbs Cafe dining hall — tables with red/yellow chairs, communal table, grand piano, kitchen pass to back | Hobbs Cafe / cafe |
| `cafe_int_counter.png` | Hobbs Cafe service counter — coffee grinder, cake stand, kitchen visible behind | Hobbs Cafe / cafe |
| `dorm_int_common.png` | Dorm common room + integrated kitchen — wood-burning stove, communal dining table | Dorm common room **+** dorm kitchen |
| `dorm_int_common_vertical.png` | 9:16 vertical companion to dorm common (for vertical trailer cuts) | Dorm common room |
| `dorm_int_bedroom_1.png` | Dorm Room 1 — Gosha (robotics workshop: mechanical device, file cabinets, post-note board, desk) | Dorm Room 1 |
| `dorm_int_bedroom_2.png` | Dorm Room 2 — Katya (whiteboard sketching: computer, whiteboard, gym bench, desk) | Dorm Room 2 |
| `dorm_int_bedroom_3.png` | Dorm Room 3 — Luba (paralegal home office: bookcase, desk, clothing rack) | Dorm Room 3 |
| `dorm_int_bedroom_4.png` | Dorm Room 4 — Ivan (gym + AI desk: multi-gym station, step mill, desk) | Dorm Room 4 |
| `library_int_reading.png` | Oak Hill College library reading room — small reading tables in rows, hanging lamps, bookshelf back wall | Oak Hill College / library |
| `library_int_stacks.png` | Oak Hill College study room — central study table, librarian's desk, chalkboard, bookshelves | Oak Hill College / library |
| `artist_int_common.png` | Artists' Co-Living combined common room + kitchen | Artists' Co-Living common room **+** kitchen |
| `house4_int_common.png` | House 4 combined common room + kitchen | House 4 common room **+** kitchen |
| `house5_int_common.png` | House 5 combined common room + kitchen | House 5 common room **+** kitchen |
| `house6_int_common.png` | House 6 combined common room + kitchen | House 6 common room **+** kitchen |

**Convention — combined common-room + kitchen shots.** When a sector's common room and kitchen are visually adjacent (small dwellings where the kitchen is in the corner of the common room), one image is commissioned with the `*_int_common.png` filename and `EXISTING_INTERIORS` maps both arenas to it. Originally a dorm-only pattern; now extended to artist co-living and houses 4–6.

**Approach used:**
- **Maze-grounded layouts.** Every interior's furniture inventory and positions came from the maze CSVs, not from eyeballed Phaser screenshots. Per-room inventory at `video/assets/village/interior/_room_inventory.md` (auto-generated by `video/assets/scripts-prompts/generate_room_inventory.py` from `arena_maze.csv` + `game_object_maze.csv`) — drop the relevant block straight into the LAYOUT line of the prompt. Phaser is now only consulted for windows/doors and visual signature (those aren't tagged in the maze).
- **Locked conventions across each batch:** time of day (late afternoon golden), wood/stone palette, beam style, plank floor, no people. Light direction locked per batch (cafe/library = camera right; dorm = camera left).
- **Reference stack:** `_style_frame_master.png` (weight 2) primary look + `hobbsCafe_outside_1.jpg` or earlier interior (weight 1) for cosy continuity.
- **Persona-room mapping** was reconciled after rendering: scratch.json + Supabase `persona_scratch.living_area` updated so each Pistsov sleeps in the room whose visual signature matches their profile (Gosha=robotics, Katya=sketching, Luba=paralegal, Ivan=gym/AI).

**Skipped intentionally for v1 trailer (Pistsov cohort):**
- Pistsov daily plans only touch dorm + cafe + library, so the v1 Pistsov trailer doesn't strictly require any other interiors. The post-v1 commissions (artist co-living + houses 4–6 combined kitchen/common rooms, plus the in-progress bathrooms / studio rooms / pub / supply store / market / classroom) are being commissioned now as a per-village baseline so future cohorts can be cast into any building without blocking on more interior generation. See `_room_inventory.md` for live coverage.

**For new villages or new cohorts:**
- **Step 1 — regenerate the room inventory.** Run `python video/assets/scripts-prompts/generate_room_inventory.py`. It reads the new village's maze CSVs and rewrites `_room_inventory.md` with every room's furniture, tile counts, positional descriptors (NW corner, against left wall, etc.) and a Status line per room (DONE / TODO / N/A). The file opens with a coverage dashboard + sector-grouped TODO list.
- **Step 2 — generate ready-to-paste prompts for the TODO rooms.** Run `python video/assets/scripts-prompts/generate_interior_prompts.py`. It emits `_interior_prompts_TODO.md` — one Grok Imagine prompt per TODO arena, grouped by archetype (bathrooms / kitchens / common rooms / studio living / bedrooms / pub / supply store / market+pharmacy / classroom) so each batch runs in a single Grok session with a locked STYLE block. Bedrooms are persona-neutral by default (literal furniture from the maze, no profession/character flavor) so the same village can host different casts without re-commissioning.
- **Step 3 — run the prompts.** Paste each block into Grok Imagine UI, save the file under the suggested name, then update `EXISTING_INTERIORS` in `generate_room_inventory.py` and re-run both scripts — the room flips to DONE and drops out of the TODO prompts file.
- **Tweaks happen in Grok UI, not in the script.** Window/door positions, persona-keyed bedroom flavor, and any room that needs special attention are easier to handle by editing the prompt manually in Grok Imagine UI than by re-templating. The script gets you to a 90% prompt; the UI does the last 10%.
- **New cohort in the_ville** (different cast) → if you want persona-keyed bedrooms (like the original Pistsov dorm rooms), hand-write those four prompts using the existing dorm bedroom prompts in `!prompts.md` as the template. Everything else stays.

**Reusability:** the persona-neutral commissions (cafe, library, dorm common+kitchen, artist+house combined kitchen/common rooms, all bathrooms, all bedrooms once filled in) are reusable for any new cohort. The original 4 dorm bedrooms (Pistsov-keyed) are persona-flavoured and would need re-commission if a future dorm cohort wants different visual signatures; new persona-neutral cohorts can also use them as-is.

**Prompt templates:** `video/assets/scripts-prompts/!prompts.md` (versioned in-repo).

---

## Per-cohort specs

### §TODO-P. Character sheets — per double — DONE 2026-05-08

**Status:** 19 personas × 5 views = 95 PNGs commissioned for the_ville (all sketches in `video/assets/users/sketches/`). Stored as `video/assets/users/character-sheets/{uuid}/{view}.png`.

**Five views per persona:**
- `front_neutral.png` — copy of the source sketch (zero drift)
- `front_smile.png` — warm closed-mouth smile, same framing
- `three_quarter_neutral.png` — body rotated 30° to camera-left, head facing camera
- `profile_neutral.png` — full side profile facing camera-right
- `full_body_standing.png` — pulled-back framing, full body, persona-specific bottoms

**Tooling:** `video/assets/scripts-prompts/generate_character_sheets.py` automates 4 of the 5 views via the xAI Imagine image-edit API (`/v1/images/edits`, model `grok-imagine-image-quality`) using the source sketch as image input + a transformation prompt that instructs the model to **preserve everything from the sketch and only change one specified attribute** (expression / body angle / framing). `front_neutral` is a free file copy. Run the script with `--skip-existing` to fill in any new persona's character sheet on demand.

**Prompt strategy** (the lesson learned): generic "describe the persona from scratch" prompts cause identity drift. The working pattern is image-to-image with explicit preservation language ("same face, same hair, same eye color, same skin tone, same age, same line weight, same colored-pencil shading style") + a single transformation directive. This is captured verbatim in `scripts-prompts/!prompts.md` and in the script's `VIEW_PROMPTS` dict.

**For new cohorts:** add new sketches to `users/sketches/{uuid}.png`, then run the script — no per-persona editing needed except optional `PERSONA_OUTFITS` overrides for full-body bottoms (default falls back to model's choice based on the sketch).

**Acceptance:** all 5 views for one persona side-by-side read as the same person. Validation by eye, re-roll any drift via `--persona <UUID> --view <view>` (omits `--skip-existing` so the bad take is overwritten).

### §TODO-A. Sprite walkouts — N × ~2.5s polished video — **DONE 2026-05-08**

**Deliverable:** `video/assets/users/sprite-walkouts/{agent_id}.mp4` per persona. 1280×720 H.264, 30fps, ~2.5s. Transparent or matching dark background. (Native Phaser fallback `.webm` lives in `video/assets/phaser/sprite_walkout_{agent_id}.webm`.)

**Inputs per persona:** front-neutral sketch + auto-captured top-down home shot (from §TODO-F).

**Tool:** Grok Imagine image-to-video API (`grok-imagine-video` model, `/v1/videos/generations` endpoint, async with polling per `/v1/videos/{request_id}`). Automated via `video/assets/scripts-prompts/generate_sprite_walkouts.py` — uses each persona's `full_body_standing.png` character sheet as the starting frame, animates a subtle action + ambient motion. Per-persona action/mood overrides live in the script's `PERSONA_CONFIG` dict (action verbs derived per-persona from the `souls/*.md` snapshots); UUIDs without an entry fall back to a generic confident-smile default. **Status: DONE 2026-05-08 — 19/19 MP4s shipped** (4 Pistsov family + 15 soul15 cohort).

**For new cohorts:** add a `name → UUID` lookup from `double.personas`, drop sketches into `users/sketches/{uuid}.png`, run `generate_character_sheets.py` (full-body view is the input to walkouts), add a `PERSONA_CONFIG` entry per UUID with action+mood pulled from the persona's profile, then run `generate_sprite_walkouts.py --skip-existing`.

**Prompt template:**

```
A friendly hand-drawn cartoon character in colored-pencil / hand-sketched
art style steps into the frame from the [LEFT|RIGHT|BACK], walks two or
three casual steps forward toward the camera, turns slightly to face the
viewer, gives a subtle [SMILE|WAVE|NOD], holds for the final beat.

Character must match the attached sketch reference exactly: same line
weight, same color palette, same shading, same hairstyle, same outfit.

Setting: [DESCRIBE THE ROOM FROM THE TOP-DOWN SCREENSHOT — ~20 words].
Background slightly out of focus. Camera locked / no pan.

Mood: [WARM | CONFIDENT | INTRIGUING | PLAYFUL — match psychological
archetype, see §TODO-G].

Duration: 2.5 seconds. Output: 1280×720, 30fps. Character fully on-frame
by 1.0s; hold final pose 2.0–2.5s.

Style: hand-drawn animation, light cel-shading, gentle ambient motion in
hair / clothing, no harsh perspective shifts.
```

**Per-persona placeholders:** alternate direction of entry per persona for visual variety; pick action from {SMILE, WAVE, NOD, TILT_HEAD, GLANCE_OVER_SHOULDER}; mood matches archetype.

**Acceptance:** character fully on-screen by 1.0s; final 0.5s holds steady (so the name-card overlay lands cleanly); no abrupt cuts inside.

**Drop-in:** composer prefers `.mp4` over `.webm` automatically. Native Phaser WebM keeps shipping until MP4s land.

### §TODO-Q. Hero pairings — 4–6 hero scene stills — **DONE 2026-05-09 (Pistsov)**

**Pistsov inventory:** 4 stills in `video/assets/cohort/hero/pistsov_family/`:
- `ivan_kitchen_late_morning.png` — dorm common kitchen, post-run, laptop on table (founder-athlete signature)
- `luba_cafe_morning.png` — Hobbs Cafe interior, behind the counter, owner-operator host energy
- `katya_library_afternoon.png` — Oak Hill Library, blue armchair, sketchbook on lap (creative absorbed)
- `gosha_bedroom_night.png` — Dorm Room 1 corner desk, lamp-lit, mechanical gears (quiet thinker)

**Tooling:** `video/assets/scripts-prompts/generate_hero_pairings.py`. Reads cohort scene-config JSON (e.g. `hero_scenes_pistsov_family.json`); for each scene calls xAI `grok-imagine-image-quality` `/v1/images/edits` with up to 3 input images: room interior + persona `front_neutral.png` + optional `_style_frame_master.png`. Idempotent via `--skip-existing`; per-scene retry via `--scene <id>`; `--dry-run` for prompt inspection.

**Workflow lessons (carry into next cohort):**
1. Pose must physically fit the locked source room — don't ask for "between stacks" if the room has a reading-table layout.
2. Interior anchoring needs to enumerate visible features and explicitly negate exteriors ("INSIDE the cafe; no sky, no exterior buildings").
3. For asymmetric rooms, anchor the camera position ("from the doorway perspective; bed in left foreground; desk in back-right corner") rather than describing what's in frame.
4. Multi-image input locks composition reasonably but leaves style fluid; color-grade in post if needed.
5. Plan one round of prompt iteration after the first calibration shot; budget ~2× ideal-case API cost.

**Deliverable:** `video/assets/cohort/hero/{scene_name}.png` × 4–6.

For the 4–6 scenes you know will appear in the final trailer (e.g. "Maria in cafe at dusk", "Ivan at council fire", "Luba in apartment morning light"), generate a single still that locks scale, lighting on face, framing, and pose. Becomes the reference input when the video version is generated downstream.

**Inputs per pairing:** §TODO-M style frame + relevant §TODO-N or §TODO-O environment shot + §TODO-P character-sheet front view of the relevant double.

**Acceptance:** held next to either component baseline (the empty cafe; the character front view), the pairing reads as recognizably both — same character, same room.

---

## Per-cohort/season specs

### §TODO-C. Anthem track — ~165s, 6 stings — **DONE 2026-05-11**

**Status:** 163.7s anthem at `video/audio/music_anthem.mp3`, normalized −16 LUFS / −5.4 dBTP via `video/audio/normalize.sh --target music`. Opener script generator (`showrunner.py:1122`) sets `mood="anthem"` so `_resolve_music()` picks the new file. Daily-recap mood pool (drama/intrigue/wholesome) intentionally untouched — `VALID_MOODS` not extended.

**Lessons (carry forward to future cohort anthems):**
1. Suno tends to overshoot the requested length — generated ~188s for a 165s request. Trim externally before normalizing.
2. The 6 stings at 15s intervals (0:30, 0:45, 1:00, 1:15, 1:30, 1:45) are hard for Suno to honor on-beat — ear-check before accepting; regenerate if they drift.
3. Apply `normalize.sh` after the trim (not before) so the final loudness target hits the trimmed asset, not the un-trimmed source.
4. Convert WAV → MP3 192 kbps as the LAST step — keep the lossless WAV in `audio/_raw/` for future re-encoding without quality loss.

**Deliverable (spec):** `video/audio/music_anthem.mp3`. ~165s, normalized −16 LUFS, MP3 192 kbps, 1.5s fade-out.

**Tool:** Suno v4 or Udio.

**Prompt:**

```
[Genre] Cinematic anthemic orchestral hybrid — reality TV grand premiere
[Tempo] 110 BPM | [Length] 165s | [Vocals] NONE
[Mood] Big, hopeful, slightly tense; reverent but kinetic
[Reference] Survivor S43; Big Brother UK 2023; "Heroes" cinematic cover
[Instrumentation] Cinematic strings, light electronic percussion, brass
                  swells for hooks, sub-bass, sparse piano

Structure:
  0:00–0:08  Cold open — sparse strings + low piano under VO
  0:08–0:16  Hook plant — drums kick in subtly under VO tail
  0:16–0:30  Stakes drop — full orchestra + percussion
  0:30–2:15  Cast intros — rhythmic motif, persistent driving beat,
             with 6 musical stings at 15s intervals (0:30, 0:45, 1:00,
             1:15, 1:30, 1:45) — each a 0.5s harmonic accent
  2:15–2:35  Build — tension rises, drums intensify
  2:35–2:50  Stakes montage — full ensemble, anthemic chorus
  2:50–2:55  Final hit + 5s tail to silence
```

**Acceptance:** generate 2–3; pick the one whose 6 stings hit cleanly at 15s intervals. Normalize via existing `video/audio/normalize.sh` to match other tracks.

**Drop-in:** drop into `video/audio/`; flip script's `mood` field to `"anthem"` (or rename file to `music_drama.mp3` for zero-config swap).

---

## Per-archetype specs (commission once forever, reusable across cohorts)

### §TODO-D. Archetype intro stings — 4 × 1.5–2.5s — **DONE 2026-05-11**

**Status:** 4 stings shipped at `video/assets/archetypes/sting_{champion,wildcard,observer,connector}.wav`. All normalized to −12 LUFS integrated / −1 dBTP peak via `video/audio/normalize.sh --target sting`. Originals backed up at `archetypes/_raw/`.

**Final specs:**

| Archetype | Duration | Peak | Mean | Source |
|---|---|---|---|---|
| Champion | 1.90s | −2.3 dBTP | −14.3 dB | Suno |
| Connector | 1.96s | −2.1 dBTP | −14.3 dB | Suno (2nd take after flat first attempt) |
| Observer | 2.71s | −1.0 dBTP | −16.7 dB | Suno (widest dynamic range — preserved on purpose) |
| Wildcard | 0.97s | −2.1 dBTP | −15.2 dB | Suno (under-spec on length but reads punchy/syncopated) |

**Lessons (carry forward):**
1. Suno is built for songs, not stingers — when generating, ask for a 6s logo/ident with explicit structure (bloom → hit → decay) rather than a long track to trim later. The "find a 2s moment in a 40s song" approach failed for Connector on the first try.
2. Pre-made libraries (Pixabay Music, Freesound, BBC Sound Effects Archive) are often faster than generative tools for short stingers — search "sting", "logo", "ident", "trailer hit".
3. Normalize last, not per-take — apply `normalize.sh --target sting` (−12 LUFS / −1 dBTP) after the full set is picked to keep relative loudness consistent.
4. Observer can stay long-tailed (2.7s) without breaking the mix because the FE compose path overlays at name-card-land; the tail decays under the next card's anthem bed.

**Deliverable:** `video/assets/archetypes/sting_{archetype}.wav` × 4. Normalized −12 LUFS peak (sits 4 dB above the ducked anthem).

Each persona maps to ONE archetype (auto-assigned by §TODO-G); matching sting plays at name-card-land.

- **Champion** (alliance leader). Cinematic sports / triumphant — brass hit + tom drum thud + cymbal crash tail. Mood: bold, decisive, victorious. Reference: NBA finals stinger, NFL opening hit. Output: 1.5–2.0s, sharp attack, tail to silence.
- **Wildcard** (chaotic, playful). Electronic / playful synth — synth zap + tape rewind + vinyl scratch. Mood: mischievous, surprising, off-kilter. Reference: Stranger Things accents, glitch-pop transitions. Output: 1.5s, syncopated, playful tail.
- **Observer** (quiet strategist). Ambient cinematic — low cello sustained note + soft cymbal swell + single piano note. Mood: pensive, deliberate, suspenseful. Reference: True Detective S1 transitions, Ozark scene-break stings. Output: 2.5s, soft attack, long tail.
- **Connector** (warm, social glue). Acoustic warm / folk-cinematic — warm piano chord + acoustic guitar pluck + gentle bell. Mood: inviting, sincere, warm. Reference: This Is Us scene transitions. Output: 2.0s, soft attack, sustaining tail.

**Acceptance:** all four sit cleanly under the anthem when ducked −6 dB; attack hits within 100ms of card-land moment.

### §TODO-E. Trading-card frames — 3 PNG overlays

**Deliverable:** `video/assets/archetypes/card_frame_{type}.png` × 3 (champion / wildcard / observer). 1280×720 transparent PNG. (Connector personas use the Champion frame in v1.)

**Common layout (all frames):**
- Sketch portrait cutout: 320×400 at (80, 160)
- Name text zone: 720×60 at (440, 200)
- Role tag zone: 200×40 at (440, 280)
- Bio text zone: 720×80 at (440, 340)
- Trait moment zone: 1100×120 at (90, 540)
- Right side (560–1280, 0–160): reserved for sprite-walkout video at 2.5s

**Frame 1 — Champion** (premium tournament aesthetic):
- 8px metallic gold/bronze border (`linear-gradient(135deg, #C8A86B, #8B6E2F)`); ornate filigree corners ~40px
- Warm radial bg #2A1810 → #0A0504
- Wax-seal role tag, "ALLIANCE LEADER" in bold serif white
- Name: bold serif (Cinzel/Trajan), white, 48pt, 0.05em tracking. Bio: italic serif #E8DCC4, 24pt. Trait: 36pt + 2px black drop-shadow.

**Frame 2 — Wildcard** (scrapbook, off-kilter):
- 6px hand-drawn line border, slight ink-bleed; whole frame rotated 1.5° clockwise
- Torn-paper / masking-tape rectangles at 2 corners; off-white #F4EBD8 paper-texture bg
- Hand-drawn rectangle role tag, "WILDCARD" in marker font, slight opposite tilt
- Name: Permanent Marker / Architects Daughter, black, 48pt. Bio: hand-drawn font, 24pt dark grey. Trait: marker, 36pt navy ink.

**Frame 3 — Observer** (minimalist editorial):
- 1px solid line border, neutral cream #E5DCC9, subtle shadow; soft gradient bg #F8F4ED → #E5DCC9
- "OBSERVER" small all-caps 14pt 0.2em tracking, lower-left corner
- Name: light sans (Inter Light / Helvetica Neue Light), charcoal #2A2A2A, 48pt. Bio: same family, 22pt mid-grey #6B6B6B. Trait: same, 32pt charcoal.
- Single 1px hairline 360px under name

**Tool options:** Figma (cleanest, ~1h/frame), Midjourney (faster, less precise on text zones), or FFmpeg drawtext + shapes (already shipped as v0 placeholder).

**Acceptance:** mock all three with one persona's sketch (use Luba's sketch — already on disk); the three frames must read as distinct personalities at 240px thumbnail width.

---

## Auto-generated each render (no commission)

| TODO | What it does | Auto-input |
|---|---|---|
| §TODO-B Bios | Tier-B LLM → 5–9 word bio | `souls/{name}.md` |
| §TODO-G Archetypes | Tier-B LLM → champion / wildcard / observer / connector | soul + scratch + relationships |
| §TODO-F Home / establishing shots | Playwright + Phaser camera screenshots | sim already running |
| §TODO-H Cold open | Templated `"{N} friends. {D} days. One survives."` + ElevenLabs TTS | cohort size, season length |
| §TODO-I Stakes-montage narration | Tier-B LLM → ~75–110 words | cohort + season |
| §TODO-J End card | FFmpeg drawtext, 5-line layout, ~8s | cohort_name, season_title |

**Your review windows (~5–10 min/cohort):** reject + regen any §TODO-B bio that reads generic; override §TODO-G archetype assignments that don't match your intuition; pick from 4 alternative §TODO-H cold-open lines if you want a different tone.

**End card v2 spec (8s, 5 lines):**

```
DAY 1 STARTS NOW                                (80pt white serif)
{cohort_name} — {season_title}                  (32pt off-white)
Watch live. Scroll back. Follow every Double.   (28pt off-white)
New trailer daily at 6:30 PM.                   (24pt off-white)
www.doubland.ai                                 (28pt gold #C8A86B)
```

---

## Decided / deferred

- **§TODO-K Sketch normalization** — DECIDED 2026-05-01: leave as-is for v0. If thumbnail consistency reads as a problem, revisit with a re-render via the redrafted `video/assets/scripts-prompts/prompt-photo-sketch.md`.
- **§TODO-L Cohort + season title** — DECIDED 2026-05-01: "Pistsov family" / "Who will stay alive".
- **§TODO-R Voice / audio reference** — DEFERRED. v1 has no per-double VO. Resume only if voice lines return to scope.

---

## Recipe — new cast in same village

When you onboard a new cohort in the_ville:

1. **Skip:** §TODO-M, §TODO-N, §TODO-O (per-village; locked once)
2. **Skip:** §TODO-D, §TODO-E (per-archetype; locked forever)
3. **Re-run per new cohort:** §TODO-P (character sheets) → §TODO-A (sprite walkouts) → §TODO-Q (hero pairings)
4. **Decide on §TODO-C:** new anthem only if season title changes; same anthem can ride multiple seasons of the same cohort
5. **Run the CLI** with new cohort name + season title; auto-generates §TODO-B, F, G, H, I, J

**Effort:** ~5–15h per cast (character sheets + sprite walkouts + hero pairings).

---

## Recipe — new village (post-MVP)

When you add a new village beyond the_ville:

1. **Re-run all per-village:** §TODO-M (style frame may carry over if you want a consistent aesthetic across villages), §TODO-N (new exteriors), §TODO-O (new interiors)
2. **Re-run all per-cohort** for the new village's first cohort (per the recipe above)
3. **Skip:** §TODO-D, §TODO-E (still reusable)

**Effort:** ~10–20h per new village (style frame + ~16 exterior shots + ~12 interior shots), then per-cohort effort on top.

---

## Feedback & Corrections

Revision queue accumulated from end-to-end render reviews. Each entry: dated observations from Ivan + concrete improvement plan. Promote a suggestion to a numbered §TODO-S/T/U… when scheduled for work.

### Trailer review — 2026-05-11 — `data/20260506-5/opener&001`

First end-to-end opener render against a real sim (Pistsov family, 4 doubles, 3000-step simulation). Pipeline succeeded after two compose-stage bug fixes (cast-intro xfade fps mismatch; `-loop` flag invalid on MP4 inputs in modern FFmpeg). Both 16x9 (130s, 20 MB) and 9x16 (130s, 44 MB) MP4s rendered.

**Ivan's observations (after watching both 16x9 and 9x16):**

1. **Drop 9x16 for now.** ✓ **DONE 2026-05-11.** A proper vertical edit needs different camera framing per beat (close-ups, vertical stacking) — not just a center-crop of the horizontal master. Out of scope for MVP. Ship 16x9 only.
2. **Stings misfire against the anthem.** ✓ **DONE 2026-05-11.** The 4 archetype stings don't land cleanly on name-card moments and clash tonally with the soundtrack's existing momentum. The anthem is dynamic enough to carry the cast-intro section on its own.
3. **Trailer is missing a brand identity opening.** Every opener should start from the same iconic intro — Doubland logo, signature establishing shot, and a fixed narrative template that explains the format to first-time viewers. The narrative is the key promotion engine: it should stick in viewers' heads and create demand for the next-day trailers, the live simulation, and eventually their own simulation with friends. Draft:
   > "[N] doubles, representing real people, met at AI simulation. Their goal: survival. Each day ends with a vote — one persona leaves. Watch alliances form, drama unfold, new bonds and betrayals — all unscripted. Follow your favorites first-hand at **doubland.ai**."
4. **Sprite walkouts loop unnecessarily.** Native walkout MP4s are 2–3s; the compose path loops them with `-stream_loop -1` to fill the longer cast-intro window. Should play once, not loop — looping reads as cheap and artificial.
5. **Archetype labels clutter the cast intros.** ✓ **DONE 2026-05-11.** "CONNECTOR" / "OBSERVER" / "CHAMPION" / "WILDCARD" badges on each persona's intro card read as game-show jargon. Drop them — the personas should speak for themselves.
6. **Cast intro flow: grid → zoom → grid → next.** Replace the current individual-cast-intro sequence with a grid-anchored flow that keeps the cohort visible throughout. Each persona's spotlight is bookended by a return to the group view:
   - Open the cast section with a full-screen grid (4-up for Pistsov; dynamic for larger cohorts): each cell shows a headshot + name badge.
   - When introducing a single double, expand their cell to full-screen: show name, character description (bio + trait moment — NOT the archetype label per #5), play the sprite walkout video **once** (per #4), then hold the walkout's final frame while narration about that double continues.
   - When that persona's narration ends, transition back to the full grid view.
   - Repeat for the next persona until all are introduced.
   This supersedes the older "cast-lineup beat" idea (a single static grid shot) — the grid becomes the home base of the cast section, not a one-off introduction.

7. **Phaser flyover captures show UI artifacts.** The green schematic map flyovers used in the stakes montage include the player UI in frame — at minimum the player timeline (bottom) and the top-right cross/close button. These need to be hidden during the Playwright capture pass so the schematic reads as a clean cinematic shot.

8. **Fuse Phaser-schematic visuals with rendered exteriors/interiors in the opening.** During the intro, transition between top-down Phaser map views and the commissioned exterior/interior renders (§TODO-N, §TODO-O) so viewers feel that real, lived-in scenes sit behind the schematic. The goal: when they later watch the live Phaser simulation, the schematic should evoke the real life it represents — the renders become the "remembered reality" the schematic stands in for. Concretely: crossfade or match-cut from a Phaser top-down of (e.g.) Hobbs Cafe to its rendered interior, then back to schematic.

9. **End cards are static and overlong.** Both end-card beats (1:36–1:51 and 1:52–2:10, ~33s combined) read as a wall of text rather than a finale. Make them dynamic by cycling a third line.

   **Current first end card (1:36–1:51):**
   ```
   The village runs 24/7.
   Watch from the very first day.
   Follow every Double — routines, conversations, alliances, vote-outs.
   New trailer daily at 6:30pm
   ```

   **Current second end card (1:52–2:10):**
   ```
   Pistsov family — Who will stay alive.
   Watch live. Scroll Back. Follow every Double.
   New trailer daily at 6:30 pm
   http://www.doubland.ai
   ```

   **Proposed dynamic end card (replaces both):**
   - Lines 1–2 appear together first:
     ```
     Survival in Doubland
     <Cohort name>            (e.g. "Pistsov Family")
     ```
   - Third line cycles every ~1 s, one phrase per beat:
     ```
     Living Drama
     Strategic Alliances
     Unexpected Bonds
     Insidious Betrayals
     Unscripted Life
     ```
   - Final beat (third line lands on):
     ```
     Watch live — at www.doubland.ai
     ```

10. **Phaser-derived assets are stale — rebuild with a sim-aware capture system.** Every auto-captured asset under `video/assets/phaser/` outside the four manually-curated reference snapshots (`1-village-birdeye.png`, `2-hobbs-cafe.png`, `3-dorm.png`, `4-oak-hill-library.png`) is unfit for the trailer:
    - `establish_*.png` (×6) — captured at fixed coordinates chosen before the Pistsov cohort was locked; views don't correspond to where the cast actually lives, works, or interacts.
    - `home_topdown_*.png` (×4) — captured but never actually composed into the opener path.
    - `sprite_walkout_*.webm` (×4) — superseded by §TODO-A polished MP4s; dead weight.

    Rebuild under a new **two-tier asset taxonomy**:

    - **Tier A — Cohort-agnostic Phaser assets** (bake once, locked forever, reused across every cohort's opener):
      Examples: signature village establishing flyover for the brand open (see §TODO-T); generic "this is the_ville" canvas recording used in the Phaser ↔ rendered fusion beat (obs. #8); reference shots that don't depend on which cast is in the sim. Stored at `video/assets/phaser/cohort-agnostic/` (new subfolder); generated once via a dedicated bake script; checked into the repo; reused unchanged across all future trailer renders.

    - **Tier B — Per-sim-day Phaser captures** (captured fresh per trailer render against the actual simulation):
      Driven by the showrunner LLM's `key_steps` selection — same logic already used in `day_overview` / `day_in_life` modes. The LLM ranks sim events (conversations, alliances, conflicts, vote-outs) and outputs N candidate step ranges; the Playwright capture pass then records both (a) canvas recordings spanning those step ranges and (b) static screenshots at the boundaries. Stored under `data/{sim}/opener&NNN/raw/` (per-render, not checked in).

    **Wall-clock pacing constraint:**
      - Playback rate: 1 sim minute = 10 s wall clock (6× sim acceleration).
      - Per-scene cap: max 3 consecutive sim steps per Tier-B capture → ~30 s wall clock per beat. Forces the LLM to pick the highest-impact moments rather than long sequences.

    **Capture-format split (asks both static + motion per beat):**
      - Some opener beats want **motion** (sprites moving, conversations bubbling) → canvas recording.
      - Some beats want a single **iconic frame** (e.g. a tense vote-out moment held on-screen) → static screenshot at the same step boundary.
      - The compose layer decides per beat whether to use the recording or the screenshot derived from the same capture pass.

    This reopens §TODO-F (currently DONE in the status table) for revision — see suggestion #10 below.

---

#### Improvement suggestions

Ordered to match the observations above. Each entry: scope, code-change estimate, risk, recommended sequencing.

**1. Drop 9x16, ship 16x9 only.** ✓ **DONE 2026-05-11.**
- *Change shipped:* Added `VERTICAL_9X16_ENABLED = False` module flag at top of `video/compose_trailer.py`; gated the `crop_vertical` call in `compose_opener_trailer` behind it. Opener-mode only — day_in_life / day_overview paths untouched. Flip the flag to `True` to re-enable.
- *Effort actual:* 6 lines (2-line constant block + 4-line if/else wrap).
- *Verified:* re-rendered opener against `data/20260506-5/opener&001/` — only `trailer_16x9.mp4` produced; no `trailer_9x16.mp4`.

**2. Drop archetype stings (disable, don't delete).** ✓ **DONE 2026-05-11.**
- *Change shipped:* Added `STINGS_ENABLED = False` module flag; `_build_sting_overlays()` early-returns `[]` when disabled. Sting WAVs preserved at `archetypes/sting_{champion,wildcard,observer,connector}.wav`. Flip the flag to re-enable.
- *Effort actual:* 2 lines.
- *Verified:* re-rendered opener — narration + anthem mix only; no sting overlays.

**3. Build the Doubland brand intro — promote to three new TODOs.**
Three sub-deliverables; commission separately to avoid bundling risk:

- **§TODO-S Doubland logo splash** *(per-app, locked forever)* — **WORDMARK LOCKED 2026-05-12.** Composite mark: `DOUBLAND — What if?` (H1 + H2 two-line lockup). Trademark cleared (see `20260512_trademark-research-request.md`). Remaining: design-team typography commission (3 positioning variants requested per `20260512_design-brand-intro-request.md` §3 Deliverable A) + 4-second motion treatment (slow zoom-out + wordmark fade-in per Option A in design brief). Brand sound (Deliverable D) deferred to v2.x — the anthem's opening note carries the audio bed for v2.1.
- **§TODO-T Iconic establishing flyover** *(per-app, locked forever)* — **STILL LOCKED 2026-05-12.** Background commissioned at `video/assets/production/brand/brand_opener_iconic_still.png` (post-prompt-1 iteration of `opening.png`: dusk village scene with cyan wireframe overlays on three foreground buildings, conveying the "real lives + simulation duality" core of the Doubland format). Remaining: 4–5 second motion treatment (slow zoom-out OR voxel→photoreal resolve, see design brief §3 Deliverable C; ship Option A for v2.1, defer Option C to v2.x).
- **§TODO-U Series narrative template** *(per-format, evolves with format)* — **EFFECTIVELY DONE via Round 3 narration cache.** The cohort-aware narration generators (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook) automated in `showrunner.py` IS the narrative template implementation. The trailer no longer has a separate ~15–20s VO over the brand splash — the brand opening is text-only (wordmark + iconic still), and narration begins with the cold-open contradiction. Downgrading §TODO-U from "commission narrative copy" to "lock the system prompts as the franchise spec" — and those prompts are already locked.

All three plug in as a single new beat ("brand open") inserted before the existing cold open. Rough new structure: brand open (~20s, §TODO-S/T/U) → cold open (~5–10s) → Phaser-rendered fusion beat (~10s, per #8) → cast section as grid-zoom-grid flow (~50–60s total, per #6) → stakes montage (~25s) → dynamic end card (~9s, per #9) ≈ 120–135s total. May want to shave the existing cold open to ~5s since the brand open now carries the orientation work.

**4. One-shot sprite walkouts (no loop).**
- *Change:* Remove `-stream_loop -1` from the video-input branch of `_compose_cast_intro_subclip` (line 433–436). The walkout plays its native ~2.5s once, then the final frame freezes for the remainder of the persona's narration window.
- *Effort:* ~5 lines in compose. Note: if #6 (grid-anchored cast intro) ships in the same revision, the old `_compose_cast_intro_subclip` likely becomes dead code — this fix migrates into the new `compose_cast_grid_intros` function instead. Either way, the "play once + hold final frame" behaviour is required.
- *Risk:* low standalone; becomes part of #6 if shipped together.
- *Sequencing:* absorbed by #6 if #6 ships at the same time, otherwise can ship independently in pass 1.

**5. Drop archetype labels from cast intros.** ✓ **DONE 2026-05-11.**
- *Change shipped:* Removed the role_label drawtext block (4 lines) from `_compose_cast_intro_subclip` in `video/compose_trailer.py`. Cast intros now show name + bio + trait moment only — no `CONNECTOR` / `OBSERVER` / `CHAMPION` / `WILDCARD` badge.
- *Effort actual:* 4 lines deleted.
- *Side note (still open):* The §TODO-G archetype classification is now unused by the opener path (since #2 also shipped). §TODO-G could be skipped for opener-mode renders to save one LLM call per render — flagged as a follow-up cleanup, not part of pass 1.

**6. Grid-anchored cast intro (replaces existing individual-intro compose).**
- *Change:* Rewrite the cast-intros stage as a single composite beat instead of N independent 15s clips. New compose function `compose_cast_grid_intros(personas, narration_per_persona, output_path)`:
  1. Render a base grid layout (4-up for Pistsov; dynamic for larger cohorts): headshot/sketch + name badge per cell on a brand-tinted background.
  2. For each persona in turn: zoom/scale their cell to full-screen (~600 ms transition), overlay name + bio + trait moment (no archetype label), play walkout MP4 once at native ~2.5s, hold final frame while narration finishes (~3–4s), then zoom back to grid (~600 ms).
  3. Repeat for the next persona until all introduced. Final state: grid visible, ready to crossfade into the stakes montage.
- *Effort:* ~80–120 LOC for the new compose function — bigger than the prior "cast-lineup" idea but absorbs the existing per-persona compose entirely (so the old `compose_cast_intro` becomes dead code). Reuses existing sketch + walkout assets.
- *Risk:* medium — the zoom/grid math needs care, and the narration-timing handoff between personas must align with the walkout's natural 2.5s + a deterministic narration window. Easy to look janky if pacing isn't tight.
- *Design open questions:*
  - Headshot source — use existing `users/sketches/{uuid}.png` (already shipped) or a new tighter crop?
  - Grid cell layout for the 4-up — 2×2 (square cells, more breathing room) or 1×4 horizontal strip (more cinematic, but loses on vertical real estate)? Recommend 2×2 for Pistsov.
  - Final-frame hold — freeze the walkout's last frame, or crossfade to the persona's sketch as a "settled" portrait while narration continues? Recommend freeze-frame to preserve continuity.

**7. Strip Phaser player UI from flyover captures.**
- *Change:* In the Playwright capture step (`capture_static_assets.py` / scene-recording pipeline), inject CSS to hide the player chrome before recording: timeline scrubber, top-right close button, any HUD elements. Likely a single `page.addStyleTag({content: ".timeline, .close-button, .hud { display: none !important; }"})` call before `page.video()` starts — exact selectors to confirm from the `double-front` repo. Re-capture the affected flyovers (or all of them if simpler).
- *Effort:* ~5 LOC + asset re-capture pass.
- *Risk:* low — visual-only fix, no runtime/sim impact. If chrome selectors change in the frontend later, this fix may regress silently — worth a small visual-diff test against a clean reference capture.

**8. Phaser-schematic ↔ rendered-reality fusion beat.**
- *Change:* New 8–12s beat in the opening, after the brand intro (§TODO-S/T/U) and before the cold open. Pick 3–4 locations from §TODO-O interiors + §TODO-N exteriors and crossfade each from its rendered version to its Phaser top-down equivalent (or vice versa). Narration over: a short line like *"Real lives, rendered in a schematic world."* Output: a single MP4 clip slotted as a new stage.
- *Effort:* ~40–60 LOC for the compose function + crossfade timing tuning. Asset side: the rendered interiors/exteriors are already shipped (§TODO-N ✓, §TODO-O ✓); the Phaser top-downs are auto-captured via §TODO-F. No new commissioning. Will need new narration line via ElevenLabs (~1 min).
- *Risk:* low–medium — depends on whether the schematic-to-render contrast reads as artful or jarring. Recommend prototyping with 2–3 locations first before committing to 4.
- *Sequencing:* lands naturally after the brand intro is in place; needs the brand-intro framework to exist as a precursor stage.

**9. Dynamic cycling end card (replaces both current end cards).**
- *Change:* New compose function `compose_dynamic_end_card(cohort_name, cycle_lines, final_line, output_path)`:
  1. ~2s fade-in of the two static lines (`Survival in Doubland` + cohort name).
  2. For each of the cycling phrases (default 5), draw the phrase as the third line and hold for 1.0s before cutting to the next.
  3. Final phrase lands on the URL line (`Watch live — at www.doubland.ai`) and holds for 2s before fade-to-black.
  4. Total runtime: 2s fade-in + N×1s cycle + 2s URL hold ≈ 9s for 5 cycle phrases. ~24s shorter than the current 33s of stacked end cards.
- *Effort:* ~60–80 LOC for the compose function (FFmpeg drawtext with sequential `enable=` time-gating, or N sub-clips concatenated). Note: prior cast-intro work avoided `enable=`-with-output-label parser issues by splitting into static-overlay subclips — same approach applies here (one subclip per cycle beat, then concat).
- *Risk:* low — purely additive; doesn't break the existing end-card path until you swap it in.
- *Copy (locked 2026-05-11):* `Living Drama` → `Strategic Alliances` → `Unexpected Bonds` → `Insidious Betrayals` → `Unscripted Life` → final lands on `Watch live — at www.doubland.ai`.
- *Sequencing:* independent of cast/brand work; ready to implement.

**10. Two-tier Phaser capture system (replaces §TODO-F).** Sized as a foundational refactor — the rest of the suggestions (especially #6, #7, #8) sit on top of it, so this should land before they're finalized.

- *Change A — folder + nomenclature split:*
  - `video/assets/phaser/cohort-agnostic/` → Tier A bake outputs (committed; reused forever).
  - `video/assets/phaser/_moodboard/` → move the 4 hand-curated reference snapshots (`1-village-birdeye.png`, `2-hobbs-cafe.png`, `3-dorm.png`, `4-oak-hill-library.png`) and the existing `raw/` subfolder here. **Locked 2026-05-11:** keep them in the Phaser tree (they are Phaser captures, just human-curated) — the `_moodboard/` subfolder marks them clearly as reference-only, not pipeline inputs.
  - `data/{sim}/opener&NNN/raw/phaser/` → Tier B captures (per-render; not committed).
  - **Delete:** all current `establish_*.png`, `home_topdown_*.png`, `sprite_walkout_*.webm` files in `video/assets/phaser/` after the bake script's new outputs land.

- *Change B — new Tier A bake script:*
  - New script: `video/assets/scripts-prompts/bake_cohort_agnostic_phaser.py`.
  - Outputs: a small, deliberately curated set of "this is the_ville" Phaser visuals — village overhead, signature flyover (canvas recording), 2–4 landmark establishing frames. Run once per village (or when the_ville layout meaningfully changes).
  - Driven by Playwright against the frontend at `?recording=true`; uses `__panCameraTo` + `__setCameraZoom` + (new) `__hidePlayerChrome()` to strip the UI artifacts (per #7).
  - All paths checked into the repo; no per-sim regeneration.

- *Change C — Tier B capture: extend showrunner + capture pipeline:*
  - **Showrunner LLM:** extend the opener script schema to include an `atmospheric_key_steps` field — a list of {step_start, step_end, label, capture_kind: "video"|"frame"} entries. Mirrors the existing `key_steps` logic in `day_overview` / `day_in_life` modes. Constraint passed to the LLM in the prompt: `step_end - step_start ≤ 3` (max 3 consecutive sim steps per beat); pick highest-impact moments only.
  - **Playwright capture pass:** new function `capture_atmospheric_beats(sim_code, atmospheric_key_steps, output_dir)`. For each entry: seek the sim viewer to `step_start`, set playback speed to 6× (the 1 sim-min = 10 s wall-clock rule), record canvas for the `(step_end - step_start) × 10 s` window if `capture_kind="video"`, or screenshot at `step_start` if `capture_kind="frame"`. Hidden chrome throughout.
  - **Compose layer:** the stakes montage and any other "show me what's happening" beat pulls from `atmospheric_key_steps` outputs instead of the old `establish_*.png` filename list. Each beat references its label, not a hard-coded filename.

- *Effort:* large — roughly:
  - Tier A bake script: ~80–120 LOC (Playwright + camera control).
  - Showrunner schema extension + prompt edits: ~30–50 LOC.
  - Tier B capture pipeline: ~100–150 LOC (new Playwright function + integration into `generate_trailer.py` Step 4).
  - Compose-layer migration (stakes montage + cold open + #8 fusion beat to consume new outputs): ~40–60 LOC.
  - Total: ~250–380 LOC across 4 files. Plan for 2–3 days end-to-end.

- *Risk:* medium. The showrunner LLM may pick uninspired step ranges on the first iteration; budget one round of prompt iteration after the first end-to-end test render. Frontend `?recording=true` must support seeking + speed control reliably — if not, that's a `double-front` repo dependency that needs to land first.

- *Open question — playback rate flexibility:* 6× (1 sim-min = 10 s wall clock) is the working default; the LLM could in principle output a per-beat speed override (`playback_speed`) for moments that want a slower pace (e.g. a quiet vote-out scene at 3×). Recommend hold-firm on 6× for v1 and revisit only if a beat demands it.

- *Reopens:* §TODO-F (Home / establishing shots). Mark as **REOPENED** in the status table once this lands — current `capture_static_assets.py` becomes obsolete and is replaced by the Tier A bake + Tier B capture pair.

---

#### Implementation plan — opener trailer v2.x

> **Last status sweep: 2026-05-12.** Phases marked ✓ DONE are shipped on `ivan/video`; phases marked 🟡 IN FLIGHT have an external dependency (designer / advisor); phases marked ⬜ OPEN are not started.

##### Phase 1 — Code-only revisions pass 1 ✓ **DONE 2026-05-11**

Three flag-gated changes in `video/compose_trailer.py` (commits `caa0b379`, `817e0943`):
- ✓ #1 — Drop 9x16 vertical render (`VERTICAL_9X16_ENABLED=False`)
- ✓ #2 — Disable archetype stings (`STINGS_ENABLED=False`)
- ✓ #5 — Remove archetype labels from cast intros

#7 (strip Phaser UI artifacts) was scoped here originally but was absorbed by Phase 7 (#10 two-tier Phaser capture) since the stale `establish_*.png` shots are slated for deletion.

##### Phase 2 — Narration overhaul + LLM cache ✓ **DONE 2026-05-12**

Four-file change (commits `553f88cd` + `132377cc` + `f21bd6f0` + `8e232e34`):
- ✓ Migration: `double.video_narration_cache` table (RLS-enabled, service-role only)
- ✓ `supabase/db_reference.md` updated
- ✓ `video/narration_cache.py` — `get_or_generate()` with hash-based invalidation + pinned overrides
- ✓ `video/showrunner.py` — 6 new Tier-B system prompts (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook); all hardcoded copy removed; Burnett 6-beat structure auto-generated per cohort
- ✓ `OPENER_NARRATION_BOUNDS` aligned across `showrunner.py` and `validate_trailer.py`
- ✓ Cache-thrash fix on cold_open + pressure_event (commit `ba846a60`): user prompts now use deterministic `scratch_compact` fields, not the stochastic regenerated bio

##### Phase 3 — Audio fixes (A1, A2) ✓ **DONE 2026-05-12**

Commit `0f957757`:
- ✓ A1 — Narration head cutoff: `[PAUSE 0.8s]` prepended to assembled narrator_script → 1.3s of head silence eliminates first-phoneme clip
- ✓ A2 — Doubland pronunciation: `TTS_PRONUNCIATION_OVERRIDES` substitutes `Doubland → Dohbland` at the ElevenLabs boundary; canonical spelling preserved in cache + script.json

##### Phase 4 — Round 3 closing card (A3, C1, C2, F1) ✓ **DONE 2026-05-12**

Commit `ff7cf5a0`:
- ✓ A3 — Habit hook rewritten as ONE 3-6 word closing line ("Day 1 starts now")
- ✓ C1 — How-to-watch card retired (zero-duration block; compose gated to skip)
- ✓ C2 — New single end card with cohort-aware staged layout: cohort label (dynamic via `cohort_name.upper()`), question (dynamic via `season_title`; **superseded by Phase 4.5 — now bare "What if?"**), URL (`doubland.ai`), cadence (`New trailer daily · 6:30 PM`)
- ✓ F1 — Silent tail resolved: "Day 1 starts now" VO at ~t=112s, end-card visual + music carry to ~t=130s
- ✓ Background asset committed (council platform shot). **Relocated 2026-05-13:** moved from `video/assets/production/end_card_background.png` → `video/assets/production/brand/brand_end_card_background.png`. The selected end-card hero composition (card 2 from the 2026-05-12 typography pass) is locked at `video/assets/production/brand/brand_end_card.png`. **Engineering note:** `END_CARD_BACKGROUND_PATH` in `video/compose_trailer.py:701` still points to the old path and must be repointed before the next render.
- ✓ `generate_opener_end_card` rewritten in `compose_trailer.py` to use background PNG + asymmetric Card-2 typography layout

##### Phase 4.5 — Brand-voice backport to v2.1 narration + end card ✓ **DONE 2026-05-12**

Lightweight pass after `concept/brand.md` ratification — pull brand Register A ("What if?") and vocabulary discipline into the v2.1 trailer without waiting for Phase 6 brand-asset delivery. Zero new visual assets; all changes are prompt-level or one-line config swaps.

`video/showrunner.py`:
- ✓ New module-level constant `OPENER_BRAND_DISCIPLINE` codifies the forbidden vocabulary list (*simulate*, *agent*, *AI twin*, *digital twin*, *virtual you*, *imagine*, *alternate reality*, *parallel life*) and the "intimate-conspiratorial / no urgency / no aspirational fluff" register from `concept/brand.md`.
- ✓ All 6 Burnett-beat system prompts append `OPENER_BRAND_DISCIPLINE` (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook). Editing this single constant invalidates the prompt_hash on all six cached artifacts at once, forcing a regen on next render — the intended cache-invalidation pivot.
- ✓ `OPENER_PERSONA_NARRATION_SYSTEM` adds *"The version of [Name] that..."* as an optional pivot (brand signature phrase from Pillar 4 / Mirror). Available, never forced; capped at one use per script.
- ✓ `OPENER_COLD_OPEN_SYSTEM` constraint text fix: "their **AI** Doubles" → "their Doubles" — the "AI" qualifier is retired per brand vocab rules.
- ✓ `end_card_block.question` (and back-compat `subtitle` field) hardcoded to bare **`What if?`** — supersedes the Phase 4 `season_title`-derived "Who will stay alive?" question per `concept/brand.md` § "End card: Bare 'What if?' (A) on screen. Remove all 'Who will stay alive?' danger text from card." `season_title` retained as trailer metadata only; no longer surfaces visually.

`video/compose_trailer.py`:
- ✓ `generate_opener_end_card` docstring updated to reflect bare-"What if?" mapping (cosmetic — no rendering logic changed).

**Net behavior change for next render:** all 6 narration cache rows on `video/narration_cache` for `20260506-5` invalidate (hash mismatch); next opener render regenerates them under the new prompts, producing tighter, on-brand copy. End card visually reads `What if?` instead of `Who will stay alive?`.

**What this does NOT change:** wordmark commission (Phase 6 still in flight), Phase 6 brand-opener stage (still ⬜), Phase 7/8/9 (still ⬜). Phase 4.5 is purely an in-place v2.1 brand-voice tightening — it does not unblock or replace any deferred phase.

##### Phase 5 — Brand wordmark content lock ✓ **DONE 2026-05-12**

Doc-only:
- ✓ Locked composite mark: **`DOUBLAND — What if?`** (H1 + H2 two-line lockup)
- ✓ Trademark cleared by IP counsel (Marvel/Disney *"What If…?"* assessed as non-blocking — see `20260512_trademark-research-request.md`)
- ✓ Iconic background still locked at `video/assets/production/brand/brand_opener_iconic_still.png` (dusk village + cyan wireframe overlays, post-prompt-1 iteration of `opening.png`)
- ✓ Typeset wordmark composition locked 2026-05-13 at `video/assets/production/brand/opening_wordmark.png` (Editorial-centered variant — see Phase 6 §6a/6b)
- ✓ §TODO-U (narrative template) effectively DONE via Phase 2's narration cache (downgraded from "commission VO copy" to "system prompts ARE the franchise spec")

##### Brand visual narrative arc (locked 2026-05-13)

The trailer's brand-visual journey expresses the product premise: **the boundary between simulation and reality dissolves over the course of watching.**

- **Opener** carries the cyan-wireframe duality (real cottages + simulated overlays). This frames the viewer's expectations: "you are about to see a mix of simulation and real life."
- **Closer** is pure cinematic — no cyan, no overlays. By the end, the duality has dissolved; everything is perceived as real life. The Doubles, the village, the consequences — all reading as lived events.

Practical consequence for motion commissions: opener clips must preserve the cyan-wireframe motif; closer clips must contain zero cyan. This is the locked brand statement for the trailer pipeline. (Worth mirroring into `D:\Coding\double-ivan\concept\brand.md` § Visual & Tone Guardrails on next pass.)

##### Phase 6 — Brand wordmark commission + motion 🟡 **IN FLIGHT (design team)**

Sequenced asks, ~10–14 day total runway:

✓ **6a — Wordmark typography commission DONE 2026-05-13:** locked content `DOUBLAND` (H1) + `What if?` (H2). Winner: "Editorial centered" composition (large display serif `DOUBLAND` cream, thin gold rule, sentence-case `What if?` below). Brief used: `20260513_brand-wordmark-typography-brief.md` (now superseded — kept for archive). Background plate: `brand_opener_iconic_still.png` unaltered. **`.ai` suffix evaluated and rejected** — primary brand mark stays pure `DOUBLAND`; URL stays on end card. Parallel "URL lockup" variant (`DOUBLAND.ai` for social/ads) noted as future asset, not in trailer scope.

✓ **6b — Winner locked at** `video/assets/production/brand/opening_wordmark.png`. Minor nit-list deferred to 6c (cyan wireframe currently grazes the gold rule + descender of `What if?`; lockup sits dead-center, could nudge ~10% upward — both fixable in the motion treatment pass).

✓ **6c — Motion direction DONE 2026-05-13** (both bookend clips locked):
- ✓ **Opener motion** `brand_opener_motion.mp4` (1280×720, 24 fps, 6.04 s, silent). Slow push-in through dusk village; cyan-wireframe duality animates throughout; locked wordmark + gold rule baked in. Brand-bible "cyan never touches wordmark" rule explicitly bent here — the duality IS the brand, brief overlap during motion is on-brand.
- ✓ **End-card motion** `brand_end_card_motion.mp4` (1280×720, 24 fps, 6.04 s, silent). Slow push-in on lantern-lit council platform; fog drift + string-light flicker; **zero cyan, zero text** — pure cinematic per duality-arc principle (simulation/reality boundary has dissolved by close). Text-free canvas — `generate_opener_end_card()` overlays cohort label, bare `What if?` (per §4.5), URL, cadence via FFmpeg drawtext.

✓ **6d — Brand assets received and locked 2026-05-13:**
- ✓ Locked typeset still: `video/assets/production/brand/opening_wordmark.png` (1280×720, Editorial centered)
- ✓ Locked opener motion: `video/assets/production/brand/brand_opener_motion.mp4` (1280×720, h.264, 24 fps, 6.04 s, silent — wordmark + gold rule baked in)
- ✓ Locked end-card motion: `video/assets/production/brand/brand_end_card_motion.mp4` (1280×720, h.264, 24 fps, 6.04 s, silent — text-free, pure cinematic per duality-arc principle)
- ⬜ SVG wordmark (deferred — only needed for web/print, not the trailer)
- ⬜ `brand_iconic_flyover.mp4` (deferred — `brand_opener_motion.mp4` may serve double duty; revisit during 6e wiring)

✓ **6e — Engineering integration DONE 2026-05-13** (`video/compose_trailer.py`):
- ✓ New `compose_brand_open(output_path, duration_sec=None)` — stream-copies `brand_opener_motion.mp4` as Stage 0 of `compose_opener_trailer`. Returns False when asset is absent so the pipeline degrades gracefully to pre-Phase-6 behavior.
- ✓ New `_prepad_narration(narration_path, lead_sec, output_path)` — prepends silence so cold-open VO still lands on its script timestamp after the brand open shifts the video timeline.
- ✓ `generate_opener_end_card` background loader now 3-tier: `brand_end_card_motion.mp4` (preferred, freeze-frame extended to fill end-card window) → `brand_end_card_background.png` → `lavfi color` flat black.
- ✓ `compose_opener_trailer` extended: brand-open prepended; `target_duration += brand_open_dur` (~130s → ~136s, within 95–180s validator bounds); narration pre-padded; sting timestamps shifted by `brand_open_dur`; intermediates cleanup includes the new artifacts. Music timeline is unshifted — anthem's opening note rides under the brand-open frame as the audio bed.
- Smoke-tested: `compose_brand_open` produces 6.04s clip from the locked asset; `_prepad_narration` produces correct duration shift on a synthetic input.

⬜ **6f — Validation render:** kick a fresh pipeline run against `20260506-5`; verify brand opener plays before cold open; confirm narration cache still hits.

**Brand sound (Deliverable D from design brief) deferred to v2.x** — the anthem's opening note carries the audio bed for v2.1.

##### Phase 7 — Two-tier Phaser capture system (#10 + #7) ⬜ **OPEN**

Foundational refactor (~2–3 days; full design in §10 of Improvement Suggestions above):
- ⬜ Migration: split `video/assets/phaser/cohort-agnostic/` (Tier A, bake once) + `data/{sim}/opener&NNN/raw/phaser/` (Tier B, per-render)
- ⬜ New `video/assets/scripts-prompts/bake_cohort_agnostic_phaser.py` (Tier A bake)
- ⬜ Showrunner schema extension: `atmospheric_key_steps` field; LLM ranks 1–3 high-impact step ranges per sim
- ⬜ New `capture_atmospheric_beats()` Playwright function for Tier B captures
- ⬜ Compose-layer migration: stakes montage + #8 fusion beat consume new outputs
- ⬜ Strip Phaser player chrome (#7) from captures via CSS injection in Playwright pass

Reopens §TODO-F (was DONE; now flagged REOPENED 2026-05-11). Gates #8 (fusion beat) and the visual layer of cast-intro restructure.

##### Phase 8 — Grid-anchored cast intros (#6 + #4) ⬜ **OPEN**

New compose function `compose_cast_grid_intros()` (~80–120 LOC):
- ⬜ Render 4-up grid layout (headshot + name badge per cell)
- ⬜ Per-persona zoom: expand cell to full-screen, show name + bio + trait moment + walkout MP4 played once (#4), hold final frame while narration finishes, zoom back to grid
- ⬜ Decision: 2×2 grid layout (recommend) vs 1×4 horizontal strip
- ⬜ Decision: freeze walkout final frame vs crossfade to sketch portrait

Subsumes #4 (walkouts-once) — the new flow plays walkouts once by design. May consume Phase 7's Tier B captures if grid cells want live sim footage; otherwise headshot + walkout is sufficient.

##### Phase 9 — Phaser↔rendered fusion beat (#8) ⬜ **OPEN** — assets locked 2026-05-13

New 8s beat in the opening, after the brand intro and before the cold open. **Scope simplified 2026-05-13:** rather than per-location crossfades (the original #8 spec), Phase 9 is now a **single 8s schematic→cinematic dissolve** using two locked Phase 7 commissioned assets. Implementation is ~20 LOC of FFmpeg `xfade` in `compose_trailer.py`.

**Architecture:**
```
[signature_flyover.mp4, 4s — schematic plate]
   ↓ xfade dissolve (2s overlap, transition=fade)
[cinematic_village_aerial_tudor.mp4, 4s — cinematic plate]
————————————————————————————————————————————————————
   = 8s Phase 9 fusion beat
```

**Compose stage (to add):**
- New function `compose_phaser_to_cinematic_fusion(schematic_path, cinematic_path, narration_path, output_path)`.
- FFmpeg filter graph: `[0:v][1:v]xfade=transition=fade:duration=2:offset=3[v]` (xfade starts 1s before halfway so the cinematic plate fully resolves by the end).
- Strip audio from both source clips with `-an`; narration overlay added at mix stage.
- Output: single MP4 clip slotted as new compose stage between brand-open and cold-open.

**Locked assets (2026-05-13):**
- *Schematic plate:* `video/fly-over/signature_flyover.mp4` — pixel-art top-down village with animated sprites walking the paths. Reads as "live simulation."
- *Cinematic plate:* `video/fly-over/cinematic_village_aerial_tudor.mp4` — aerial Tudor village in the locked Doubland storybook aesthetic (matches `_style_frame_master.png`). Reads as "real, lived-in world."

**Narration:** still TBD (short Tier-B LLM line, ~10 words, e.g. "Real lives. Rendered in a schematic world."). Adds via existing prepad-narration plumbing.

**What we tried but abandoned:** single-clip Grok schematic→cinematic morph (7+ Grok iterations 2026-05-13). Grok could deliver any 2 of {layout fidelity, schematic→cinematic morph, correct Tudor style} but never all 3 reliably. The FFmpeg-xfade approach above sidesteps the trade-off — both plates individually hit their goals, the xfade does the bridge.

**Original #8 per-location crossfade idea is deferred:** could revisit post-v2.1 as a v2.2 enhancement if the single-dissolve fusion beat reads as weaker than per-location crossfades in playback testing.

---

#### Critical path + sequencing

```
Phase 1 ✓
Phase 2 ✓
Phase 3 ✓
Phase 4 ✓
Phase 4.5 ✓ (brand-voice backport — supersedes Phase 4 end-card question)
Phase 5 ✓ ───┐
Phase 6 🟡 ──┤ ──→ v2.1 SHIPPABLE (after 6e) — brand opener integrated
             │
Phase 7 ⬜ ──┘ ──→ unblocks Phase 8 visual sources + Phase 9
Phase 8 ⬜ ──→ depends on Phase 7
Phase 9 ⬜ ──→ depends on Phase 7
```

**v2.1 ship dependency:** Phase 6 completion (design-team brand assets + engineering integration). Estimated ~2 weeks.

**v2.2+ ambitions:** Phases 7–9. Sequenceable in any order after Phase 7 lands. Estimated 3–5 working days for Phases 7–9 combined once kicked off.

**Total remaining estimated effort:** ~2 weeks of design-team runway (Phase 6) + ~3–5 days of engineering (Phases 7–9). v2.1 is the achievable next milestone; v2.2 is the polish-pass milestone.

---

### MVP path — ship v1 today (1–1.5 h)

Three moves cherry-picked from the full plan above. Goal: a watchable v1 opener live today, with the cheapest wins. Everything skipped here is deferred to the full execution order — no commitments forfeit, just sequencing.

**Step 1 — Restore the stale `establish_*.png`.** ✓ **DONE 2026-05-11.**
- *Action shipped:* `git checkout 75aa01759^ -- video/assets/phaser/establish_*.png` — restored 6 establishing PNGs (cafe_exterior, council_zone, homes_row, village_dawn, village_dusk, village_overhead) from the commit just before they were deleted in `75aa01759` ("Update video assets and enhance interior prompt management").
- *Why:* unblocks `compose_opener_trailer` (cold open + stakes montage both require at least one `establish_*.png` in `PHASER_DIR`). These are placeholder-quality and will be nuked again when #10's Tier A/B capture system lands — restoration is **temporary**, just to ship today.

**Step 2 — Perfect the narration.** ✓ **DONE 2026-05-12 — shipped as a much bigger system than originally scoped.**

Original plan was to hand-edit `data/20260506-5/opener&001/script.json` and force a narration re-render. Replaced with an **automated cohort-aware LLM generator + Supabase cache** so the same quality lift propagates to every future cohort without manual editing. See "Round 3 milestone" subsection below for the architecture; the 4-file change is committed on `ivan/video` (commits `553f88cd`, `132377cc`, `f21bd6f0`, `8e232e34`).

Sample of what the new pipeline now produces for Pistsov (verbatim from `data/20260506-5/opener&002/script.json` `narrator_script`):

> *"They're family. In Doubland, their Doubles have to survive each other.* [PAUSE 1s] *Four Doubles enter the village. Every day brings pressure and escalating stakes. Every night, they vote one contestant out.* [PAUSE 2s] *Gosha keeps everyone organized and encouraged. But under pressure, the teammate who holds the group together can quietly steer decisions — and decide who stays.* [PAUSE 1s] *Ivan plans every move with obsessive discipline. That makes him reliable. It also makes him the person who quietly calculates who to cut when efficiency threatens the group's survival.* [PAUSE 1s] *Katya is relentless about turning ideas into plans. But under pressure, the kid who always finishes what she starts can steer everyone toward her solution — and lock out alternatives.* [PAUSE 1s] *Luba keeps everyone organized and encouraged. That makes her the glue of the group. It also makes her dangerous when she controls the schedule and the decisions.* [PAUSE 2s] *Now the house narrows and every promise counts. The vote. Where loyalty becomes math, where you decide to outlast the person you raised, loved, and trusted. Who will betray blood to survive?* [PAUSE 1s] *Who feels safest enough to betray first, and who will be exposed when they stand alone?* [PAUSE 2s] *Tonight, secrets blow up on camera and you'll want the morning explanation. Tomorrow at six-thirty, catch the fallout and join the recap — watch live at doubland dot ai."*

**Step 3 — Minimum-viable brand opening (30–60 min).** Pure typography over black; ships today.
- *Add `compose_brand_open(output_path, duration_sec=4.0)` to `video/compose_trailer.py`.* Same pattern as `generate_opener_end_card`: black background via `lavfi color`, two centered `drawtext` calls (wordmark + tagline), 0.5 s fade-in at start.
- *Visual structure (4 s total):*
  - `0.0–0.5 s` — fade in from black
  - `0.5–3.0 s` — `DOUBLAND` wordmark centered (bold, gold `#C8A86B`), tagline below in lighter weight (locked copy TBD — placeholder: "Survival, unscripted")
  - `3.0–4.0 s` — hold; anthem's first beat lands at 3.0 s carrying the emotional moment
  - `4.0 s` — crossfade into existing cold open
- *Slot:* insert as new first stage in `compose_opener_trailer`, before the cold open. Add to the final-concat list; bump the stakes-montage and cast-intro `time_range_sec` values by `+4 s` in `script.json` (so narration timings still align).
- *Effort:* ~40 LOC new compose function + ~10 LOC integration. No external assets, no Midjourney cycle, no chime — anthem carries the audio bed.
- *Acceptance:* the trailer opens with a deliberate, brand-anchored beat that imprints "DOUBLAND" before any sim content appears.

**Decisions needed to start Step 3:**
1. **Brand tagline copy** (≤4 words for legibility at 3 s). Placeholder: `Survival, unscripted`.
2. **Confirm Step 2 narration text** verbatim or with tweaks before re-rendering.

**What this MVP path explicitly defers:**
- §TODO-T iconic flyover commission (Grok-Imagine render cycle — won't finish today)
- §TODO-S commissioned logo art (text-only wordmark is fine for v1; replace with a PNG later without code change)
- §TODO-U narrative template formalization (narration is hand-written for this cohort; template generalization waits)
- #6 grid-zoom cast intro restructure (1 day of work)
- #8 Phaser-rendered fusion beat (depends on Tier A bake)
- #9 dynamic end card (3–5 h — fits if everything else flies, but not blocking)
- #10 two-tier capture system (multi-day foundational refactor)

Total: ~1–1.5 h of work + your iteration time on narration listening.

---

### Round 1 Reality TV consultation — production-ready artifacts (2026-05-11)

Captured from the external advisor response to `D:\Coding\double-ivan\20260511_realityTV-expert-request.md`. These supersede the MVP-path narration draft above; the MVP-path version was a strawman before the consultation landed.

**Source:** Burnett / de Mol / Parsons "lens" framework (see `20260511_realityTV-expert-request.md` § Round 1 status for full response). Follow-up gaps queued in `20260511_realityTV-expert-followup.md`.

#### Verdict adopted

Our original 5-beat structure (concept → cast → drama → lesson → future) reads as a **format explainer**. It tells viewers about the rules before earning emotional attachment. Replaced wholesale with a **"relationship-under-pressure"** structure built around a social contradiction that lands in the first 7 seconds.

#### V2 opener beat sheet (130 s, locked)

| Time | Beat | Job |
|---|---|---|
| 0–7 s | **Cold open contradiction** | Real family / simulated betrayal |
| 7–18 s | **Format lock** | Four AI Doubles, one village, nightly vote-out |
| 18–65 s | **Cast as threats** | Each persona: virtue → danger → likely betrayal mode |
| 65–90 s | **First pressure event** | One real challenge or social rupture — not a generic montage |
| 90–112 s | **Vote-out dread** | Who is safe, who is exposed, who has motive |
| 112–130 s | **Return hook** | Named question + exact habit: "Tomorrow, 6:30 PM" |

#### Cast-intro template (locked, repeatable across cohorts)

```
[Name] is the one who [lovable strength]. But under pressure,
that could make them [danger].
```

#### Pistsov cohort sample copy (v2 narration, ready to render)

- **Gosha:** *"Gosha keeps people together. But in a survival game, the person holding the group together can also decide who gets left outside."*
- **Ivan:** *"Ivan watches everything. That makes him patient. It also makes him dangerous."*
- **Katya:** *"Katya turns plans into action. If the village needs order, she could lead it. If order becomes power, she could run it."*
- **Luba:** *"Luba organizes the room without needing the spotlight. The question is whether anyone notices before she has the votes."*

#### Cold-open narration draft (v2, 0–18 s)

```
[0–7 s — social contradiction]
This is the Pistsov family. In real life, they know each other too well.
In Doubland, their AI Doubles have one rule: survive each other.

[7–18 s — format lock]
Four Doubles enter a private village. Every day brings pressure. Every
night, they vote one of their own out.
```

#### Conflict-beat structure (Trigger → Choice → Consequence)

Every drama beat must show three visible pieces:

1. **Trigger:** what changed?
2. **Choice:** what did someone do?
3. **Consequence:** who now trusts them less?

Never use "everything changed" — show the exact social pivot. Sample landing line:

> *"Then the first challenge exposed the problem: everyone needed cooperation, but only one person could afford to be honest."*

#### Vote-dread closing (90–112 s)

Tease through **motives, not outcome**:

> *"By nightfall, the question is not who played best. It is who feels safest enough to betray first."*

Visual: three possible targets, quick flashes of contradictory dialogue, **cut before the vote reveal.**

#### Habit hook (112–130 s)

Named unresolved question + daily cadence:

> *"Tonight, one Double loses the village. Tomorrow at 6:30, the survivors explain themselves. Watch live at doubland.ai."*

#### End-card module (replaces dynamic end card #9)

Three persistent tiles at the close of every trailer (opener AND day-overview):

```
┌─────────────────┬──────────────────┬───────────────────┐
│    AT RISK      │  HOLDING POWER   │  WATCH TOMORROW   │
│  <persona name> │  <persona name>  │     6:30 PM       │
└─────────────────┴──────────────────┴───────────────────┘
```

This turns the opener from a one-off promo into the **first installment of the daily habit loop.** The same module evolves each day as new doubles fall into "at risk" or rise to "holding power."

#### Guardrail (must respect)

> Do NOT make the trailer feel like the real family is being humiliated by their AI selves. The safe dramatic frame is **"social pressure reveals surprising strategy,"** not **"your Double exposes the worst version of you."** Keep betrayal playful, consequential, and opt-in; avoid copy that implies the AI is revealing hidden real-world truth about the person.

This rules out a class of "AI knows the real you" framings that would otherwise be tempting. Active replacement framing is still open — queued as Q7 in the follow-up.

#### A/B testing protocol (lock before iterating further)

Build **two 130-second animatics** from the same footage:

- **A — current proposed 5-beat:** concept → cast → drama → lesson → future.
- **B — relationship-under-pressure:** real bond → survival rule → cast danger → rupture → vote dread → 6:30 habit.

Test with **10 cold viewers**. Ask only:

1. "What is the show?"
2. "Who do you remember?"
3. "Who do you think is dangerous?"
4. "Would you watch tomorrow's recap?"

The winning cut is **not** the one people understand best. It's the one where viewers can name a person, predict a betrayal, and ask what happens at the vote.

#### What's still open (Round 2 — see `20260511_realityTV-expert-followup.md`)

Production-blocking gaps from Round 1: narrator voice casting, music-vs-narration ratio, animated-sprite emotional weight, three reference trailers to study, vocabulary inventory, daily-recap structure, and the active dramatic frame to use *instead of* "AI exposes hidden truth."

---

### v2 production scope — locked 2026-05-11

Goal: ship v2 of the opener trailer **as fast as possible** with **zero new asset commissioning**. v2 is a narration-overhaul-only release; everything else stays on v1 assets.

**In scope for v2 (text-only changes + one render):**
- Replace `narrator_script` in `data/20260506-5/opener&001/script.json` with the Burnett 6-beat structure using Round-1 advisor copy.
- Delete `audio/narration.mp3`; re-invoke `compose_opener_trailer` to regenerate via ElevenLabs.
- Trailer compose stitches new narration into existing visual + audio scaffolding.

**Explicitly out of scope for v2** (deferred to v3+ regardless of Round 2 advisor recommendations):
- **No new ElevenLabs voice.** Current voice ID `cIO62fcmCSQhE0DE2WS2` stays. The Round-2 "mysterious-intimate female" casting brief is adopted as a *future* direction; not implementing now.
- **No new anthem / music track.** Current `video/audio/music_anthem.mp3` stays. No separate cold-open music bed, no Suno regeneration, no audio-bakeoff prototype.
- **No music-ducking change.** Current `−6 dB` under narration stays. Round-2 recommended `−9 to −12 dB`; that's a tunable, defer it.
- **No silence-moment insertions.** Round-2 recommended three silence beats (post-contradiction, pre-rupture, pre-end-card); requires audio-mix code changes, defer.
- **No 3-tile end-card module** (AT RISK / HOLDING POWER / WATCH TOMORROW). Requires new compose function, defer.
- **No voice-and-sound A/B/C bakeoff.** Skip the audio-layer test protocol; voice is locked to v1.
- **No code changes to `compose_trailer.py`.** Pass-1 flag changes (no 9x16, no stings, no archetype labels) already shipped; nothing else touched.

**Acceptance for v2:** the trailer plays end-to-end at ~130 s, opens with the social-contradiction line ("In real life, they're family. In Doubland, their Doubles have to survive each other"), introduces each Pistsov double via the social-risk template, and closes with the habit hook ("Tomorrow at 6:30, the survivors explain themselves"). Same voice, same music, same visuals.

**What this buys us:** a v2 trailer that has the **right script** without the cost of new voice casting, new music commissioning, or new compose-pipeline engineering. The Round-2 audio/code recommendations remain in the doc as the v3 backlog.

---

### Round 3 milestone — automated narration generator + Supabase cache (DONE 2026-05-12)

**Scope upgrade from v2 plan:** rather than hand-editing one trailer's `script.json` and force-rendering (the original v2 plan above), the narration overhaul shipped as an **automated cohort-aware LLM generator with cross-render caching**. Every future cohort now gets Burnett 6-beat narration automatically. The v2 plan above is technically superseded; that's documented for posterity, not for execution.

**What shipped (4 files):**

| Layer | File | Change |
|---|---|---|
| Database | `supabase/migrations/20260511180000_video_narration_cache.sql` | New `double.video_narration_cache` table. Keyed by `(sim_code, scope, artifact_key, persona_id, day_number)`. `prompt_hash` drives cache invalidation (sha256 of system + user + model); `pinned=true` rows override invalidation for hand-edited copy. RLS enabled with no policies — service_role bypass only (anon/authenticated denied). |
| DB Reference | `supabase/db_reference.md` | New Video Trailer section documenting the cache for LLM-lookup tooling. |
| Cache module | `video/narration_cache.py` | `get_or_generate(sim_code, scope, artifact_key, ..., system_prompt, user_prompt, model, llm_caller)` — checks cache, returns on hash match or pinned, calls LLM and persists on miss. Smoke-tested: MISS → HIT → STALE (prompt-change regen) → PINNED override. All 4 paths verified against live DB. |
| Showrunner | `video/showrunner.py` | Removed hardcoded `_opener_cold_open_line` + monolithic `OPENER_STAKES_SYSTEM`. Added 6 new Tier-B system prompts (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook). Added 6 cache-backed `_generate_*` helpers. Cast scenes now carry a `narration_line` field. `_opener_assemble_narrator_script` rewritten to weave the 6 beats with [PAUSE Ns] markers. `OPENER_NARRATION_BOUNDS` upper bumped 220 → 280. |

**Cache scope dimensions:**

| scope | dimensions | example artifact_keys |
|---|---|---|
| `sim` | `sim_code` | `cold_open`, `format_lock`, `pressure_event`, `vote_dread`, `habit_hook` |
| `persona` | `sim_code` + `persona_id` | `persona_narration` |
| `day` | `sim_code` + `day_number` | (reserved for day-overview trailer) |
| `day-persona` | `sim_code` + `persona_id` + `day_number` | (reserved for day-in-life trailer) |

The `day` and `day-persona` scopes are infrastructure-ready but not yet consumed; they unblock the day-overview and day-in-life trailer products without further schema work.

**LLM cost economics:**

| Scenario | LLM call count |
|---|---|
| First render of a new cohort | 11 calls (4× bio + 4× archetype + 4× trait_moment + 6× narration artifacts, paid once) |
| Re-render of same cohort, same prompts | 0 narration calls (full cache hit); bio/archetype/trait still re-call (those don't go through the cache yet) |
| Cohort identical except for one persona's profile | 1 narration regen for that persona; everything else cached |
| Iterating on a system prompt | All rows for that artifact key invalidate (prompt_hash mismatch); fresh LLM call until pinned |

**Verified working end-to-end against `20260506-5`:**
- 9 cache rows persisted: 5 sim-scope + 4 persona-scope (one per Pistsov double)
- `narrator_script` = 218 words, within `OPENER_NARRATION_BOUNDS=(60, 280)`
- `trailer_16x9.mp4` rendered at `data/20260506-5/opener&002/output/trailer_16x9.mp4` (1280×720, 130.0 s, 20 MB)

**Architectural implications for the rest of the trailer backlog:**

- **§TODO-U Series narrative template** (Round 1 Reality TV §3, subsection): no longer needs to be a hand-written template. The cohort-aware cold_open + format_lock + pressure_event generators ARE the template implementation — they take the cohort name and cast and produce franchise-consistent copy per cohort. §TODO-U could be downgraded to "lock the system prompts as the franchise spec" rather than "write narrative copy".
- **#9 Dynamic cycling end card**: the cycling third line (Living Drama / Strategic Alliances / Unexpected Bonds / Insidious Betrayals / Unscripted Life) could optionally also become an LLM-generated artifact (one new system prompt + one cache key per sim). Defer until end-card compose work happens.
- **#6 Grid-anchored cast intro**: now has per-persona `narration_line` already populated in `cast_scenes`. When #6 ships, the compose layer can use this directly — no new LLM call needed.
- **Day-overview trailer pipeline** (separate product): can reuse the same `narration_cache` infrastructure with the `day` scope. New system prompts for daily-recap narration plug in cleanly.

**What's still open (full execution order in next section):** §TODO-S logo splash, §TODO-T iconic flyover (visual asset commissions); #6 cast-intro restructure (compose function rewrite); #8 Phaser↔rendered fusion beat (new compose stage); #9 dynamic end-card module (new compose function); #10 two-tier Phaser capture system (foundational refactor). None of these are blocked by the narration work; the narration milestone is independent of all of them.
