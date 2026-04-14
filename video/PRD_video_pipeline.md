# PRD: Day-in-Life Video Pipeline

> **Status:** In Progress
> **Author:** Ivan
> **Date:** 2026-04-03
> **Updated:** 2026-04-14 — Context pipeline and showrunner quality overhaul complete. See milestones below.
> **Source:** [MVP Video Playbook](1.MVP_video_playbook.md)

### Milestone log

| Date | Milestone |
|---|---|
| 2026-04-10 | First end-to-end trailer produced (Ivan Pistsov / `20260407-2`). 5 scene clips + music + subtitles + end card → MP4. |
| 2026-04-13 | Frontend `?recording=true` mode live (`double-front` branch `local`): camera API + `__executeMovementsForStep` active, Supabase stream suppressed, UI chrome hidden. Headless validator path untouched. |
| 2026-04-14 | **Plan B** — Consecutive-step segments: showrunner now produces 2–4 clips with `key_steps` as consecutive integers (e.g. `[12,13,14]`); eliminates character teleportation between clips; validator enforces consecutiveness and 2–4 scene count. |
| 2026-04-14 | **Supabase-native context builder** — `extract_day_log.py` replaced raw memory dump with typed, sim-scoped `dbl_get_sim_memories` queries + activity-transition timeline downsampling (~60–100 entries vs all 750). Context size is now O(constant) regardless of sim length. |
| 2026-04-14 | **RIR focal-point retrieval** — `dbl_retrieve_with_rir` extended with optional `p_simulation_id` (backward-compatible 10-param overload, migration `20260414_dbl_retrieve_rir_sim_scope.sql`). `extract_day_log.py` now uses three showrunner-specific focal points to retrieve the most dramatically relevant memories via the HNSW vector index; falls back to poignancy-only if embeddings unavailable. |

---

## TODOs

1. **Mood tracks (asset work)** — **Done (2026-04-09)** — Three 75s instrumental tracks processed and placed in `reverie/backend_server/video/audio/`.
2. **End-to-end validation** — **Done (2026-04-10)** — First trailer produced for sim `20260407-2` / Ivan Pistsov. 5 scene clips + music + subtitles + end card → MP4 output. See "Known issues" below for quality gaps.
3. **Camera API integration** — **Done (2026-04-13)** — Introduced `?recording=true` mode in `double-front` that renders tilemap + sprites, exposes the 5 camera functions and `__executeMovementsForStep`, suppresses the Supabase realtime coord stream, and hides UI chrome. `?headless=true` validator path (lightweight, no tilemap) is preserved for simulation generation at scale. **Remaining:** update `record_scenes.py` to navigate to `?recording=true` (drop `?headless=true`, the SwiftShader flag, the CSS UI-hiding injection, and the 30s FFmpeg head-trim), then remove the `if Director API available` guards.
4. **Narration** — ElevenLabs TTS fallback to OpenAI now works (401 → auto-retry with OpenAI). Ivan fixed ElevenLabs auth in a parallel branch. Next pass will include voice-over.
5. **SFX library** — Source 12 clips for transitions and emphasis (see playbook §8). Phase 2.
6. **Quality checklist automation** — Automated pass/fail gate on output duration, word count, structure. Phase 2.

### Known issues (from first trailer, 2026-04-10)

- **No camera scripting in recorded footage** — **Resolved on FE (2026-04-13)** via `?recording=true` mode. Awaiting `record_scenes.py` URL swap to take effect in produced trailers.
- **Static scenes** — **Resolved on FE (2026-04-13)** — `__executeMovementsForStep` is active in recording mode. Awaiting `record_scenes.py` URL swap.
- **Subtitles timing approximate** — SRT generation uses rough offsets from `time_range_sec` rather than actual narration timing. Will improve once narration audio is included.
- **End card font warning** — Fontconfig error on Windows ("Cannot load default config file"). End card still renders but font fallback may vary. Low priority.

---

## Implementation Status

| Component | Status | Location |
|---|---|---|
| **Data Extraction** | Done | `reverie/backend_server/video/extract_day_log.py` |
| **Showrunner LLM** | Done | `reverie/backend_server/video/showrunner.py` |
| **TTS Narration** | Done | `reverie/backend_server/video/tts.py` — ElevenLabs (ID: cIO62fcmCSQhE0DE2WS2) + OpenAI fallback |
| **Mood Music Tracks** | Done | Three 75s instrumental tracks in `reverie/backend_server/video/audio/` — `music_intrigue.mp3`, `music_drama.mp3`, `music_wholesome.mp3` |
| **Camera Scripting API** | Done (2026-04-13) | `double-front: AnimationManager.ts`, `types.d.ts`; 5 `window.__*` functions + `__executeMovementsForStep` active in `?recording=true` mode. Headless validator path preserved. |
| **Playwright Recording** | Done | `reverie/backend_server/video/record_scenes.py` — uses normal mode + SwiftShader + CSS UI hiding + FFmpeg trim |
| **FFmpeg Compositing** | Done | `reverie/backend_server/video/compose_trailer.py` — absolute paths for concat, `-vn` for MP3 cover art, tail-of-stderr logging |
| **CLI Orchestrator** | Done | `reverie/backend_server/video/generate_trailer.py` — music library fallback + auto-copy |
| **End-to-end validation** | **Done (2026-04-10)** | First trailer produced: 5 scenes with real Phaser tilemap + music + subtitles + end card. Camera directives not yet connected (see Known Issues). |

**Merge note:** All backend code is in a new `reverie/backend_server/video/` package with zero overlap against Nicolas's `integration/20260330-local-hardening-rebuild` branch. Frontend changes are additive-only appends in a separate repo.

---

## 1. Problem Statement

Double generates rich simulation data — personas plan, move, converse, reflect — but there is no way to turn a completed simulation day into a shareable artifact. Users and the team lack a fast path from "simulation finished" to "60-second trailer I can post."

## 2. Product Vision

Truman Show-styled 60-second day-in-life trailers, generated semi-automatically from simulation data. A warm omniscient narrator tells the story; top-down gameplay footage provides visual evidence. The output is a social-ready MP4 (9:16 vertical + 16:9 landscape).

**Core storytelling principle:** The sprites are *evidence*. The narrator is the *storyteller*. The viewer watches surveillance footage narrated by someone who knows everything.

## 3. Goals & Success Metrics

| Goal | Metric | Target |
|---|---|---|
| Time to trailer | End-to-end production time | < 5 min fully automated |
| Story quality | Dramatic irony present; open-ended close | 100% of trailers pass quality checklist |
| Shareability | 9:16 crop with readable subtitles at mobile size | Every trailer exports both aspect ratios |
| Engagement proxy | First 3 seconds would stop a thumb-scroller | Validated via internal review |

## 4. Users & Personas

| User | Need |
|---|---|
| **Internal team** (MVP) | Produce demo trailers from completed sims for marketing/investor content |
| **Simulation operator** | Generate a trailer for any sim day with minimal manual work |
| **End user** (future) | Receive auto-generated day recap videos of their personas |

## 5. Scope

### 5.1 In scope (MVP)

- Single protagonist, single simulation day
- 5-step fully automated pipeline: Data Extraction → Showrunner LLM → Audio Production → Video Capture → Compositing
- **Automated video capture** via Playwright headless recording + frontend camera scripting API
- Automated data extraction from Supabase
- Automated LLM showrunner call producing structured trailer script (JSON)
- Automated TTS narration rendering
- Pre-generated mood music library (3 tracks)
- FFmpeg-based compositing and export
- Two output formats: 16:9 master + 9:16 social crop

### 5.2 Out of scope (MVP)

- Multi-protagonist or ensemble trailers
- Real-time generation during simulation
- User-facing UI for trailer configuration
- Multi-day or season recap trailers
- In-browser `MediaRecorder` canvas export (Playwright video recording is sufficient)

---

## 6. Pipeline Architecture

```
Simulation day completes
  │
  ▼
┌───────────────────────────┐
│  STEP 1: Data Extraction  │  Automated (~5s)
│  Supabase queries         │  → day_log JSON
└───────────┬───────────────┘
            ▼
┌───────────────────────────┐
│  STEP 2: Showrunner LLM   │  Automated (~30-60s)
│  Single Tier C call       │  → trailer script JSON
└───────────┬───────────────┘
            ▼
┌───────────────────────────┐
│  STEP 3: Audio Production  │  Automated (~30s)
│  TTS + mood track select  │  → narration.mp3 + music
└───────────┬───────────────┘
            ▼
┌───────────────────────────┐
│  STEP 4: Video Capture     │  Automated (~2-3 min)
│  Playwright + camera API  │  → scene clips (WebM)
└───────────┬───────────────┘
            ▼
┌───────────────────────────┐
│  STEP 5: Compositing       │  Automated (~2 min)
│  FFmpeg assembly          │  → final MP4 (16:9 + 9:16)
└───────────────────────────┘
```

**Total pipeline time: ~5 minutes, fully automated.** No manual screen recording.

---

## 7. Functional Requirements

### FR-1: Data Extraction — `video/extract_day_log.py` (DONE)

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-1.1 | Query `dbl_memory` for protagonist's day: events, thoughts, chats (up to 500 memories) | P0 | Done |
| FR-1.2 | Query `personas_coords` for full position history (all steps in sim day) | P0 | Done |
| FR-1.3 | Query `persona_scratch` for daily plan, schedule, relationship affinities | P0 | Done |
| FR-1.4 | Query all personas' positions for proximity/co-location detection | P1 | Done |
| FR-1.5 | Assemble into a single `day_log` JSON with sections: protagonist profile, timeline, conversations, reflections, highlight_stats | P0 | Done |
| FR-1.6 | Include `highlight_stats`: total events, total conversations, total reflections, max-poignancy event, unique locations, personas interacted with | P1 | Done |

**Output schema:** See playbook §3c for full `day_log` JSON structure.
**CLI:** `python -m reverie.backend_server.video.extract_day_log <sim_code> <persona_name> [--output day_log.json]`

### FR-2: Showrunner LLM — `video/showrunner.py` (DONE)

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-2.1 | Single LLM call using Tier C model (gpt-5.2 or equivalent) | P0 | Done — routes via `GPT_request` with direct OpenAI fallback |
| FR-2.2 | System prompt enforces: 60s duration, 5 scenes max, one protagonist, omniscient 3rd person, dramatic irony, open-ended close | P0 | Done |
| FR-2.3 | Output is valid JSON matching trailer script schema: title, mood, logline, narrator_script (with `[PAUSE]` and `[SCENE]` markers), scenes array, end_card | P0 | Done — schema validation + retry |
| FR-2.4 | Each scene specifies: label (hook/setup/development/turn/close), time_range_sec, step_range, camera directives, transitions, narrator_lines, optional subtitle_card and key_dialogue | P0 | Done |
| FR-2.5 | Mood selection from three options: intrigue, drama, wholesome | P0 | Done — validated |
| FR-2.6 | Narration word count constrained to 120-150 words | P0 | Done — validated (80-200 tolerance with warning) |
| FR-2.7 | At least one 2-3s silence marker in the script | P1 | Prompt-enforced, not validated |
| FR-2.8 | Maximum 2 dialogue excerpts, maximum 3 subtitle cards | P1 | Prompt-enforced, not validated |

**CLI:** `python -m reverie.backend_server.video.showrunner <day_log.json> [--output script.json]`

### FR-3: Audio Production (Done)

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-3.1 | Render narrator VO from script via TTS (ElevenLabs preferred; OpenAI TTS fallback) | P0 | **Done** — `video/tts.py`: ElevenLabs narration generation (ID: cIO62fcmCSQhE0DE2WS2) + OpenAI tts-1-hd fallback; metadata stripping and Audio Tags mapping implemented for dynamic tone |
| FR-3.2 | Voice profile: warm, mature (40-60 age feel), documentary narrator tone, ~2.0-2.5 words/sec (ElevenLabs ID: cIO62fcmCSQhE0DE2WS2) | P0 | **Done** — stability=0.65, clarity=0.75, style=0.40; OpenAI fallback uses "onyx" voice at speed=0.9 |
| FR-3.3 | Honor `[PAUSE Ns]` markers as literal silence in audio | P0 | **Done** — `parse_narrator_script()` splits on `[PAUSE Ns]` and `[SCENE N]` markers; silence generated via FFmpeg |
| FR-3.4 | Select mood track from pre-generated library (intrigue/drama/wholesome) | P0 | **Done** — three 75s instrumental tracks in `video/audio/` (`music_intrigue.mp3`, `music_drama.mp3`, `music_wholesome.mp3`); code selection logic in `generate_trailer.py` |
| FR-3.5 | Trim mood track to 75s (15s headroom) | P1 | **Done (2026-04-09)** — trimmed/normalized via FFmpeg (–16 LUFS, MP3 192 kbps, 1.5s fade-out) |
| FR-3.6 | Source 12 SFX clips for transitions and emphasis (see playbook §8) | P2 | Pending |

**Generated Assets (Mood Tracks – Initial Versions):**
- **Intrigue (80-95 BPM, C minor):** 38s v5.5 [Reverie Watch](https://suno.com/s/eS6DTP7ugNrG5H8h) (expressive base); 3:11 v4.5 [Glasswatch Reliquary](https://suno.com/s/ktRAlf0JHSigf1oq) (free longer var). Notes: Good sparse piano; needs extension for full arc/silence.
- **Drama (100-115 BPM, D minor):** 1:00 [Cello Drought](https://suno.com/s/j5YDuTDi7E3wCSod) (slow build); 3:53 [Dminor Timpani](https://suno.com/s/ceFm24756iRdI8rm) (similar mood, longer). Notes: Cello lead promising but lacks punch/escalation; full rewrite recommended.
- **Wholesome (90-105 BPM, G major):** 0:31 v5.5 [Kindness Meter](https://suno.com/s/T5CofHlIDJTcp75S) (warm, nice!); 3:00 v4.5 [Ginger Cake](https://suno.com/s/PSpChKRDa7lSypBI) (free, almost as good). Notes: Strong acoustic feel; extend for gentle peak/resolve.

**Music tracks:** 3 pre-generated on Suno/Udio, trimmed and normalized to 75s each via FFmpeg (–16 LUFS, MP3 192 kbps), instrumental only, energy arc mapped to beat sheet. Final tracks in `reverie/backend_server/video/audio/`. See playbook Appendix A for generation prompts.

**Workaround:** The pipeline runs without audio — compositing generates a silence placeholder. Drop `narration.mp3` and/or `music_{mood}.mp3` into the `audio/` directory to include them.

### FR-4: Video Capture (Automated — Playwright Recording) — `video/record_scenes.py` (DONE — normal mode workaround)

Video capture is fully automated using two components: a **camera scripting API** exposed on the frontend (5 new `window.__*` functions), and **Playwright's built-in video recording** which captures the rendered Phaser canvas at the compositor level — including sprite animations, camera tweens, and zoom/pan — without needing `MediaRecorder` or canvas access.

**How it works:** For each scene in the showrunner script, a Playwright browser context is created with `record_video_dir` enabled. The recording script navigates to the simulation playback URL, applies camera directives (zoom, follow, pan) via the exposed `window.__*` functions, then plays through the step range using the existing `window.__executeMovementsForStep()`. When the context closes, Playwright auto-saves the video clip.

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-4.1 | Record each scene as a separate clip via Playwright video recording (one browser context per scene) | P0 | Done |
| FR-4.2 | Parse showrunner JSON to extract per-scene camera directives: step_range, zoom, follow target, playback speed | P0 | Done |
| FR-4.3 | Capture at 1920x1080, output as WebM (converted to MP4 in compositing step) | P0 | Done |
| FR-4.4 | Apply camera directives before playback: initial zoom, follow persona, pan to coordinates | P0 | Done |
| FR-4.5 | Play through step range using `window.__executeMovementsForStep()` per step | P0 | Done |
| FR-4.6 | Animate zoom transitions (start_zoom → end_zoom) during scene playback | P1 | Done — tween at end of scene |
| FR-4.7 | Handle transitions: time-lapse via `__setPlaybackSpeed`, focus-shift via sequential follow/unfollow | P1 | Done — speed via directive |
| FR-4.8 | Fallback: screenshot + Ken Burns (key-frame stills with slow zoom animation) if Playwright video unavailable | P2 | Pending |

**CLI:** `python -m reverie.backend_server.video.record_scenes <sim_code> <script.json> [--output-dir ./trailer/raw]`

### FR-4A: Frontend Camera Scripting API — `AnimationManager.ts` + `types.d.ts` (DONE — 2026-04-13, active in `?recording=true` mode)

Five new functions exposed on `window` in `AnimationManager.ts`, following the existing `window.__executeMovementsForStep` pattern. These extend the existing `CameraController` — no new Phaser subsystems needed.

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-4A.1 | `window.__setCameraZoom(level, durationMs?)` — tween camera to target zoom (0.5-2.0) with `Sine.easeInOut` | P0 | Done |
| FR-4A.2 | `window.__panCameraTo(tileX, tileY, durationMs?)` — tween camera scroll to center on tile coordinates | P0 | Done |
| FR-4A.3 | `window.__followPersona(personaName)` — start camera tracking on named sprite via existing `CameraController.startTracking()` | P0 | Done |
| FR-4A.4 | `window.__unfollowPersona()` — release camera tracking via existing `CameraController.stopTracking()` | P0 | Done |
| FR-4A.5 | `window.__setPlaybackSpeed(multiplier)` — set `scene.tweens.timeScale` to control animation speed (1x, 2x, 5x, 10x, 25x) | P0 | Done |
| FR-4A.6 | Add TypeScript declarations for all 5 functions to `types.d.ts` | P0 | Done |

**Implementation reference:**

```typescript
// In AnimationManager.ts constructor, alongside existing window.__executeMovementsForStep

window.__setCameraZoom = (level: number, durationMs: number = 1000) => {
  const cam = this.scene.cameras.main;
  this.scene.tweens.add({
    targets: cam, zoom: level,
    duration: durationMs, ease: 'Sine.easeInOut'
  });
};

window.__panCameraTo = (tileX: number, tileY: number, durationMs: number = 1000) => {
  const cam = this.scene.cameras.main;
  const px = tileX * TILE_SIZE, py = tileY * TILE_SIZE;
  this.scene.tweens.add({
    targets: cam,
    scrollX: px - cam.width / 2, scrollY: py - cam.height / 2,
    duration: durationMs, ease: 'Sine.easeInOut'
  });
};

window.__followPersona = (name: string) => {
  const sprite = this.spriteMap.get(name);
  if (sprite) this.cameraController.startTracking(sprite, name, false);
};

window.__unfollowPersona = () => {
  this.cameraController.stopTracking(true);
};

window.__setPlaybackSpeed = (multiplier: number) => {
  this.scene.tweens.timeScale = multiplier;
};
```

### FR-5: Compositing & Export — `video/compose_trailer.py` (DONE)

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-5.1 | Concatenate scene clips with crossfade transitions via FFmpeg | P0 | Done — concat demuxer |
| FR-5.2 | Mix audio: narration + music, music ducked 6-9 dB under VO | P0 | Done — amix with volume ducking |
| FR-5.3 | Overlay subtitle/dialogue text (SRT/ASS format, timed from showrunner output) | P1 | Done — SRT generated from script.json |
| FR-5.4 | Add end card ("DAY N — THE VILLE" + subtitle) at 0:58-1:00 | P0 | **Done** — FFmpeg drawtext in `compose_trailer.py:generate_end_card()` |
| FR-5.5 | Export 16:9 master (1920x1080) | P0 | Done |
| FR-5.6 | Export 9:16 social crop (1080x1920, center-cropped) | P0 | Done |
| FR-5.7 | Total duration: 58-62 seconds | P0 | Done — `-t 60` flag |

**CLI:** `python -m reverie.backend_server.video.compose_trailer <trailer_dir> [--output trailer_16x9.mp4]`

---

## 8. Beat Sheet (60-Second Structure)

Every trailer follows this rhythm. The showrunner LLM produces scenes mapping to these beats:

| Beat | Time | Duration | Purpose | Camera | Music |
|---|---|---|---|---|---|
| **Hook** | 0:00-0:08 | 5-8s | Most surprising moment, no context | Tight zoom (1.5-2.0x) | Atmospheric, sparse |
| **Setup** | 0:08-0:20 | 10-12s | Morning routine, establish normalcy | Bird's-eye (0.5-0.7x) → zoom in | Rhythm enters |
| **Development** | 0:20-0:38 | 15-18s | Main thread unfolds, key interaction | Medium (1.0-1.2x), follow | Builds, melodic |
| **Turn** | 0:38-0:50 | 10-12s | Something shifts, reframes the day | Pause or slow push-in, 2-3s silence | Stop-down → swell |
| **Close** | 0:50-0:58 | 8-10s | Unresolved aftermath | Slow zoom out to bird's-eye | Resolve to single note |
| **End card** | 0:58-1:00 | 2s | Day/village title | Static | Fade or silence |

---

## 9. Mood Modes

| Mode | Trigger | Narrator Tone | Music | Transitions |
|---|---|---|---|---|
| **Intrigue** | Mystery, hidden motives, quiet revelation | Curious, conspiratorial | Sparse piano, electronic pulse | Focus shift, card break, fly-over |
| **Drama** | Conflict, confrontation, emotional stakes | Urgent, empathetic, short sentences | Building strings, percussion | Hard scene cut, silence drop, fade |
| **Wholesome** | Friendship, kindness, small victories | Warmest, genuine affection | Acoustic guitar, warm piano | Fly-over, time lapse, gentle fades |

---

## 10. Transition Library

Six transition types available to the showrunner:

| Transition | Use Case | Duration | Audio |
|---|---|---|---|
| **Scene Cut** | Between any scenes (workhorse) | 0 frames | Optional soft whoosh |
| **Fly-Over** | Major location change (max 1x/trailer) | 3-4s | Slow whoosh + ambient |
| **Time Lapse** | Compress routine/transit (10-25x speed) | 3-6s | Clock tick sequence |
| **Focus Shift** | Same location, shift between sprites | 1-2s | None |
| **Card Break** | Time jumps, context, dramatic emphasis | 1.5-2.5s | Typing SFX |
| **Fade to Black** | Act breaks, before/after turn | 1.5-2.5s | Music continues or stops |

---

## 11. Output Artifacts

Per trailer, the pipeline produces:

```
trailer_{sim_code}_day{N}/
├── raw/                        # Scene clips (Playwright auto-capture)
│   ├── scene_1_hook.webm
│   ├── scene_2_setup.webm
│   ├── scene_3_development.webm
│   ├── scene_4_turn.webm
│   └── scene_5_close.webm
├── audio/
│   ├── narration.mp3           # TTS output
│   ├── music_{mood}.mp3        # Selected mood track (75s)
│   └── sfx/                    # Transition sounds
├── cards/
│   ├── title_card.png          # End card
│   └── card_*.png              # Subtitle cards
├── output/
│   ├── trailer_16x9.mp4        # Master (1920x1080)
│   └── trailer_9x16.mp4        # Social crop (1080x1920)
├── description.md              # Timestamped links to key moments (Post-MVP: clickable with step/focus/zoom)
├── day_log.json                # Extracted simulation data
└── script.json                 # Showrunner LLM output
```

---

## 12. Quality Checklist (Acceptance Criteria)

### Story
- [ ] Hook is the most surprising/loaded moment, shown without context
- [ ] Protagonist named in first narrator line
- [ ] Dramatic irony present (viewer knows something character doesn't)
- [ ] Story does NOT fully resolve — ends on open question or quiet image
- [ ] One "devastating observation" line from the narrator
- [ ] Logline would make someone curious in one sentence

### Technical
- [ ] Duration: 58-62 seconds
- [ ] Narration: 120-150 words
- [ ] At least one 2-3s silence (visual-only beat)
- [ ] Max 2 dialogue excerpts as text overlay
- [ ] Max 3 subtitle cards (including end card)
- [ ] Music ducked under narration (voice clearly audible)
- [ ] No clipping or audio distortion
- [ ] End card present and readable

### Pacing
- [ ] No scene longer than 18 seconds
- [ ] Speed ramps only during transit/routine, never during emotional moments
- [ ] Fly-over used max once
- [ ] Stop-down at the turn (~0:38-0:42)

### Social Readiness
- [ ] 9:16 vertical crop exists, key elements visible in crop
- [ ] Subtitles readable at mobile size
- [ ] First 3 seconds compelling (thumb-stop test)

---

## 13. Technical Dependencies

| Dependency | Status | Notes |
|---|---|---|
| Supabase `dbl_memory` table | Exists | Wired in `extract_day_log.py` |
| Supabase `personas_coords` table | Exists | Wired in `extract_day_log.py` |
| Supabase `persona_scratch` table | Exists | Wired in `extract_day_log.py` |
| Tier C LLM access | Exists | Wired in `showrunner.py` via `GPT_request` + direct fallback |
| ElevenLabs API | **Done** | TTS for narrator voice — voice created (ID: cIO62fcmCSQhE0DE2WS2); full integration with key, fallback, and tone controls active |
| OpenAI TTS (fallback) | **Done** | `onyx` voice at 0.9x speed — auto-fallback when ElevenLabs returns 401 |
| Suno/Udio | **Done** | Three 75s instrumental mood tracks generated and finalized in `video/audio/` |
| FFmpeg | Local install | Wired in `compose_trailer.py` |
| Playwright | Exists | Wired in `record_scenes.py` with `record_video_dir` |
| Phaser frontend playback | Exists | Simulation viewer |
| `window.__executeMovementsForStep` | Exists | Used by `record_scenes.py` |
| `CameraController` | Exists | Wrapped by Director API |
| Camera scripting API (`window.__*`) | **Done** | 5 functions in `AnimationManager.ts` + `types.d.ts` |

---

## 14. Auto-Recording Architecture

### How Playwright video recording works

Playwright captures video at the **compositor level** — not DOM screenshots, but actual rendered frames of the browser viewport including the Phaser WebGL canvas. This means sprite animations, camera tweens, and zoom/pan are all captured in full motion without any frontend `MediaRecorder` code.

```python
# Playwright creates a video for each browser context automatically
context = await browser.new_context(
    viewport={"width": 1920, "height": 1080},
    record_video_dir="./trailer/raw/",
    record_video_size={"width": 1920, "height": 1080}
)
page = await context.new_page()
# ... navigate, set camera, play steps ...
await page.close()
await context.close()
# Video file is now saved in record_video_dir
```

### Recording script flow (per scene) — target flow with `?recording=true` (FE done 2026-04-13, BE swap pending)

```
For each scene in showrunner script["scenes"]:
  │
  1. Create Playwright context with record_video_dir (1920x1080)
  │
  2. Navigate to /simulations/{sim_code}?recording=true&step={start_step}
  │     Recording mode renders tilemap + sprites, exposes camera API, suppresses
  │     Supabase playback stream, and hides UI chrome via the frontend itself.
  │
  3. Wait: window.__headlessReady === true  (up to 30s)
  │     Fires after the first render tick — tilemap painted, sprites placed at step N.
  │
  4. Apply camera directives:
  │     window.__setCameraZoom(start_zoom, 0)
  │     window.__setPlaybackSpeed(speed)   (if speed != 1)
  │     window.__followPersona(name)  OR  window.__panCameraTo(x, y, 0)
  │     Wait 500ms for camera settle.
  │
  5. For each step in [start_step..end_step]:
  │     window.__movementsComplete = false
  │     window.__executeMovementsForStep(stepData)
  │     Wait: window.__movementsComplete === true  (up to 120s)
  │
  6. Final zoom transition: window.__setCameraZoom(end_zoom, 2000); wait 2200ms.
  │
  7. Close context → Playwright auto-saves raw WebM clip.
  │
  8. Rename to scene_{id}_{label}.webm
```

**Deprecated workarounds (no longer needed):** `--use-gl=swiftshader` browser arg, `page.add_style_tag()` UI-hiding CSS, the 30s FFmpeg head-trim, and the `if Director API available` guard checks.

### Existing infrastructure leveraged

| Component | Location | Reused How |
|---|---|---|
| Playwright browser launch | `headless_visualization.py:639` | Same Chromium args, port scanning, URL resolution |
| `__executeMovementsForStep` | `AnimationManager.ts:835` | Drives step playback identically to sim execution |
| `__headlessReady` / `__movementsComplete` | `AnimationManager.ts` | Same readiness and completion signals |
| `CameraController` | `CameraController.ts` | `startTracking`, `stopTracking`, zoom — wrapped by 5 new `window.__*` functions |
| Step data fetch | API Gateway `/api/simulations/{sim}/step/{N}` | Same endpoint used during headless sim runs |

### Post-MVP enhancements

| Enhancement | Value | Complexity |
|---|---|---|
| **In-browser `MediaRecorder`** on Phaser canvas | Higher quality, native FPS control | Medium — ~200 lines FE, `?director=true` param |
| **Batch scene rendering** (`window.__renderScenes`) | Single call renders all scenes | Low — wrapper over camera API + MediaRecorder |
| **Built-in transition rendering** (fade, fly-over, card-break) | Eliminates FFmpeg transition step | Medium — Phaser shader/overlay effects |
| **Composite camera script** (`window.__executeCameraScript`) | Single declarative JSON replaces per-call directives | Low — loop over directives with setTimeout |

---

## 15. Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Showrunner LLM produces invalid JSON | Blocks pipeline | Schema validation + retry with error feedback |
| TTS voice quality varies across narration lengths | Poor audio | Test calibration line; tune stability/clarity params |
| Playwright video framerate too low for smooth animation | Choppy footage | Reduce `HEADLESS_SPEED_MULTIPLIER`; slow tween timeScale during recording |
| Camera tween completes before recording starts | Missed visual | Use `durationMs=0` for initial setup; start tweens only after first step executes |
| Music energy arc doesn't align with beat sheet | Pacing feels off | Pre-test each track against sample narration |
| 9:16 crop cuts off important sprites | Social version unusable | `__followPersona` keeps protagonist centered; validate crop |
| Narration pacing too fast/slow for 60s | Duration overrun | Enforce 120-150 word budget; TTS speed tuning |
| WebM → MP4 conversion adds time | Minor delay | FFmpeg remux is ~1s; negligible |

---

## 16. Implementation Phases

### Phase 1: Foundation — 9/9 DONE (2026-04-10)

| # | Item | Status | File |
|---|---|---|---|
| 1 | FE: Camera scripting API (5 `window.__*` functions) | **Done (2026-04-13)** | `AnimationManager.ts` — active in `?recording=true` mode (separate from `?headless=true` validator) |
| 2 | FE: Type declarations | **Done** | `types.d.ts` |
| 3 | BE: Data extraction script | **Done** | `video/extract_day_log.py` |
| 4 | BE: Showrunner prompt + JSON validation | **Done** | `video/showrunner.py` |
| 5 | BE: TTS pipeline (ElevenLabs / OpenAI TTS) | **Done** | `video/tts.py` — ElevenLabs + OpenAI fallback, [PAUSE] parsing, silence gen |
| 6 | BE: Recording script (Playwright video) | **Done** | `video/record_scenes.py` |
| 7 | BE: FFmpeg compositing scripts | **Done** | `video/compose_trailer.py` |
| 8 | Assets: Generate 3 mood tracks (Suno/Udio) | **Done (2026-04-09)** | Three 75s instrumental tracks in `video/audio/` |
| 9 | Validation: Produce first trailer end-to-end | **Done (2026-04-10)** | Sim `20260407-2` / Ivan Pistsov — 5 scene clips with Phaser tilemap + music + end card. Camera directives and step animation now unblocked by FE `?recording=true` (2026-04-13); re-run after `record_scenes.py` URL swap. |

**Also built:** `video/generate_trailer.py` — CLI orchestrator tying Steps 1-5 together.

### Phase 2: Polish
10. ~~End card image generation~~ **Done** — FFmpeg drawtext in `compose_trailer.py:generate_end_card()`
11. Add SFX library (12 clips)
12. Quality checklist automation (duration, word count, structure validation)
13. ~~FR-2.7/FR-2.8 validation enforcement~~ **Done** — pause markers, dialogue/card caps in `showrunner.py:validate_script()`

### Phase 3: Enhanced Recording
14. In-browser `MediaRecorder` on Phaser canvas (higher quality, native FPS)
15. Composite camera script (`window.__executeCameraScript` — single declarative JSON)
16. Built-in transition rendering (Phaser-level fade, fly-over, card-break)
17. Batch scene rendering API

### Phase 4: Interactive Timestamps & Links (Post-MVP)
18. **Timestamped Video Descriptions**: Generate a shareable description (Markdown/JSON) with clickable timestamps linking to key moments in the trailer or full sim playback. Each link includes step reference, focus point (tile coordinates), and zoom level for precise scene recreation.
   - **BE Updates**: Extend `generate_trailer.py` to output `trailer_description.md` or JSON. Add API endpoint `/api/simulations/{sim_code}/trailer/{day}/description` that embeds links like `/simulations/{sim_code}?step={N}&focus={x,y}&zoom={level}&mode=playback`.
   - **FE Updates**: Parse query params in simulation viewer to auto-jump to step, pan to focus coords, and set camera zoom. Highlight points of interest (e.g., glow on sprites/locations).
   - **Value**: Enables social sharing with "jump to the drama at 0:38" links; boosts engagement by letting viewers explore exact angles/scenes.
   - **Out of Scope (Initial)**: Dynamic highlighting during playback (e.g., AR overlays); multi-link playlists.
   - **Dependencies**: Builds on camera scripting API (FR-4A) and playback URL params.
   - **Metrics**: 100% of key scenes (hook/turn/close) get auto-generated links; validate link accuracy in end-to-end tests.

### Phase 5: Simulation-Level Trailers (Post-MVP)
19. **Opening Trailer**: A motivational intro video (30-45s) introducing the cast of characters, sim setup, and teaser for expected drama/arcs. Builds anticipation for daily updates.
   - **Content**: Montage of sprites in their homes/environments; quick bios (name, role, quirk); high-level "what's at stake" narration (e.g., "In The Ville, alliances form and secrets unfold—watch Day 1 tomorrow").
   - **BE Updates**: New CLI `generate_opening.py` pulling sim metadata (personas, souls, baseline events) into a simplified showrunner prompt. Use existing extraction/recording/compositing pipeline with multi-protagonist support.
   - **FE Updates**: Extend camera API for ensemble shots (e.g., multi-follow, village fly-over). Add intro-specific highlights (e.g., name tags on sprites).
   - **Value**: Hooks viewers early, motivates subscription to daily content; positions sim as a "series" worth following.
   - **Out of Scope (Initial)**: Custom user branding; interactive cast bios.
   - **Dependencies**: Multi-persona data extraction (extend FR-1); ensemble camera controls.
   - **Metrics**: Viewer retention on first trailer >70%; qualitative feedback on "motivation to watch more."

20. **Sim Day Summary Trailer**: A 60-90s ensemble recap of the day's major events across 3-5 sprites. Highlights key dramas, ends with evening "voting results" (e.g., affinity shifts, unresolved tensions). Leaves anticipation for the next day.
   - **Content**: Parallel storylines (e.g., "While Katya studied, Gosha plotted..."); cross-cut between protagonists; narrator teases "Tomorrow, the fallout begins."
   - **BE Updates**: Extend showrunner to handle multi-sprite day_logs (e.g., top 3-5 by poignancy). CLI `generate_day_summary.py` with aggregated extraction.
   - **FE Updates**: Support parallel scene rendering (batch multiple personas); add split-screen or quick-cuts for ensemble pacing.
   - **Value**: Builds communal viewing—viewers catch up on the "big picture" daily; reinforces social dynamics and cliffhangers.
   - **Out of Scope (Initial)**: Real-time generation (post-day only); viewer-voted highlights.
   - **Dependencies**: Phase 3 batch rendering; extended LLM prompts for ensemble narratives.
   - **Metrics**: Coverage of top dramas (80% of high-poignancy events); end-of-trailer "anticipation score" via internal review.

21. **Sim Overview (Closing) Trailer**: A longer (90-120s) finale recapping the entire simulation. Reuses opening elements (cast refresh); spotlights impactful days/characters; weaves human-value stories (e.g., growth, kindness, conflict resolution). Ends with a call-to-action: "Create your own story in The Ville."
   - **Content**: Arc overview (e.g., "From alliances to betrayals..."); memorable vignettes; reflective narration on themes (e.g., "In 17 days, they showed us resilience"); showcase top characters/stories.
   - **BE Updates**: New CLI `generate_overview.py` aggregating multi-day logs. Showrunner variant for longer format (more scenes, deeper analysis); include voting/election results if applicable.
   - **FE Updates**: Extended runtime support (e.g., multi-day step ranges); thematic highlights (e.g., value-based filters like "kindness moments").
   - **Value**: Provides closure and inspiration—viewers feel they've witnessed an "amazing story"; drives trials ("What a hell! I should try it too!").
   - **Out of Scope (Initial)**: User-customized overviews; export to social reels.
   - **Dependencies**: Full sim data aggregation (extend FR-1 for multi-day); longer compositing (FFmpeg tweaks for 2min+).
   - **Metrics**: Length adherence (90-120s); emotional impact (e.g., 90% "memorable/inspiring" in feedback); CTA click-through if embedded.