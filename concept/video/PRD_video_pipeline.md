# PRD: Day-in-Life Video Pipeline

> **Status:** In Progress
> **Author:** Ivan
> **Date:** 2026-04-03
> **Updated:** 2026-04-03 — Phase 1 implementation (7 of 9 items complete)
> **Source:** [MVP Video Playbook](1.MVP_video_playbook.md)

---

## Implementation Status

| Component | Status | Location |
|---|---|---|
| **Data Extraction** | Done | `reverie/backend_server/video/extract_day_log.py` |
| **Showrunner LLM** | Done | `reverie/backend_server/video/showrunner.py` |
| **TTS Narration** | Pending | Needs ElevenLabs API key + integration |
| **Mood Music Tracks** | Pending | One-time generation on Suno/Udio |
| **Camera Scripting API** | Done | `double-front: AnimationManager.ts`, `types.d.ts` |
| **Playwright Recording** | Done | `reverie/backend_server/video/record_scenes.py` |
| **FFmpeg Compositing** | Done | `reverie/backend_server/video/compose_trailer.py` |
| **CLI Orchestrator** | Done | `reverie/backend_server/video/generate_trailer.py` |
| **End-to-end validation** | Pending | Requires all above + running frontend |

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

### FR-3: Audio Production (PENDING)

| ID | Requirement | Priority | Status |
|---|---|---|---|
| FR-3.1 | Render narrator VO from script via TTS (ElevenLabs preferred; OpenAI TTS fallback) | P0 | Pending — needs ElevenLabs API key |
| FR-3.2 | Voice profile: warm, mature (40-60 age feel), documentary narrator tone, ~2.0-2.5 words/sec | P0 | Pending |
| FR-3.3 | Honor `[PAUSE Ns]` markers as literal silence in audio | P0 | Pending |
| FR-3.4 | Select mood track from pre-generated library (intrigue/drama/wholesome) | P0 | Pending — tracks not yet generated |
| FR-3.5 | Trim mood track to 75s (15s headroom) | P1 | Pending |
| FR-3.6 | Source 12 SFX clips for transitions and emphasis (see playbook §8) | P2 | Pending |

**Music tracks:** 3 pre-generated on Suno/Udio, 75s each, instrumental only, energy arc mapped to beat sheet. See playbook Appendix A for generation prompts.

**Workaround:** The pipeline runs without audio — compositing generates a silence placeholder. Drop `narration.mp3` and/or `music_{mood}.mp3` into the `audio/` directory to include them.

### FR-4: Video Capture (Automated — Playwright Recording) — `video/record_scenes.py` (DONE)

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

### FR-4A: Frontend Camera Scripting API — `AnimationManager.ts` + `types.d.ts` (DONE)

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
| FR-5.4 | Add end card ("DAY N — THE VILLE" + subtitle) at 0:58-1:00 | P0 | Pending — needs card image generation |
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
| ElevenLabs API | **Pending** | TTS for narrator voice — needs API key |
| OpenAI TTS (fallback) | Exists | `nova` or `onyx` voice — not yet wired |
| Suno/Udio | **Pending** (one-time) | Generate 3 mood tracks |
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

### Recording script flow (per scene)

```
For each scene in showrunner script["scenes"]:
  │
  1. Create Playwright context with record_video_dir
  │
  2. Navigate to /simulations/{sim_code}?headless=true&step={start_step}
  │
  3. Wait for window.__headlessReady === true
  │
  4. Apply camera directives:
  │   await page.evaluate('window.__setCameraZoom(1.5, 0)')        # instant
  │   await page.evaluate('window.__followPersona("Katya")')       # track sprite
  │   await page.evaluate('window.__setPlaybackSpeed(10)')         # time-lapse
  │
  5. Play through step range:
  │   for step in range(start, end+1):
  │     await page.evaluate('window.__executeMovementsForStep(data)', step_data)
  │     await page.wait_for_function('window.__movementsComplete === true')
  │     await page.evaluate('window.__movementsComplete = false')
  │
  6. Close context → Playwright auto-saves WebM clip
  │
  7. Rename to scene_{id}_{label}.webm
```

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

### Phase 1: Foundation — 7/9 DONE (2026-04-03)

| # | Item | Status | File |
|---|---|---|---|
| 1 | FE: Camera scripting API (5 `window.__*` functions) | **Done** | `AnimationManager.ts` |
| 2 | FE: Type declarations | **Done** | `types.d.ts` |
| 3 | BE: Data extraction script | **Done** | `video/extract_day_log.py` |
| 4 | BE: Showrunner prompt + JSON validation | **Done** | `video/showrunner.py` |
| 5 | BE: TTS pipeline (ElevenLabs / OpenAI TTS) | Pending | Needs API key setup |
| 6 | BE: Recording script (Playwright video) | **Done** | `video/record_scenes.py` |
| 7 | BE: FFmpeg compositing scripts | **Done** | `video/compose_trailer.py` |
| 8 | Assets: Generate 3 mood tracks (Suno/Udio) | Pending | One-time manual generation |
| 9 | Validation: Produce first trailer end-to-end | Pending | Requires running frontend + all above |

**Also built:** `video/generate_trailer.py` — CLI orchestrator tying Steps 1-5 together.

### Phase 2: Polish
10. End card image generation (currently placeholder)
11. Add SFX library (12 clips)
12. Quality checklist automation (duration, word count, structure validation)
13. FR-2.7/FR-2.8 validation enforcement (silence markers, dialogue/card caps)

### Phase 3: Enhanced Recording
14. In-browser `MediaRecorder` on Phaser canvas (higher quality, native FPS)
15. Composite camera script (`window.__executeCameraScript` — single declarative JSON)
16. Built-in transition rendering (Phaser-level fade, fly-over, card-break)
17. Batch scene rendering API
