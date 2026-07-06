# Frontend Implementation Request: Recording Mode for Video Capture

> **Date:** 2026-04-13 (supersedes 2026-04-10 draft)
> **Author:** Ivan
> **Priority:** P0 — unblocks end-to-end trailer generation
> **PRD:** `D:\Coding\double-ivan\video\PRD_video_pipeline.md`
> **Relevant FR:** FR-4, FR-4A, Recording Flow (§14)

---

## TL;DR

1. The 5 camera functions and `__executeMovementsForStep` **already exist** in `double-front/scenes/managers/AnimationManager.ts` — no rebuild needed.
2. **Do not** extend `?headless=true` to render visuals. That mode is a deliberately lightweight validator used for simulation generation at scale (no tilemap, no atlases, no input, no texture manifest). Loading assets there regresses step throughput.
3. Introduce a **new third mode** — `?recording=true` — that renders visuals like normal mode but swaps the Supabase-driven playback for the step-driver + camera API used by Playwright.

---

## State of the repo (verified 2026-04-13)

| Capability | Location | Status |
|---|---|---|
| `window.__setCameraZoom` | `AnimationManager.ts:834` | Exists, unconditional |
| `window.__panCameraTo` | `AnimationManager.ts:848` | Exists, unconditional |
| `window.__followPersona` | `AnimationManager.ts:867` | Exists, unconditional |
| `window.__unfollowPersona` | `AnimationManager.ts:875` | Exists, unconditional |
| `window.__setPlaybackSpeed` | `AnimationManager.ts:882` | Exists, unconditional |
| `window.__executeMovementsForStep` | `AnimationManager.ts:888` | Exists, unconditional |
| `window.__headlessReady` | `AnimationManager.ts:451` | Set only when headless preconditions pass |
| TypeScript declarations | `types.d.ts` | Present |

The PRD's Known Issue "Director API only initializes in headless mode" appears to be inaccurate for the functions themselves — they are set in the AnimationManager constructor regardless of mode. What is mode-gated is (a) the `__headlessReady` readiness signal, and (b) whether the Supabase playback stream will fight `__executeMovementsForStep` for control of sprite positions.

---

## Why headless cannot be the recording mode

`scenes/MainScene.ts` explicitly short-circuits in headless:

- `preload()` — skips all asset loads (`main-scene:headless-preload-skip`, line 330).
- `create()` — skips tilemap, tilesets, layers, collisions, input setup (line 420, 513, 1028).
- `fetchSpriteManifest()` — skips texture manifest fetch (line 269).
- Bounds are reconstructed from JSON/meta rather than the rendered map (line 517).

That is the correct design for the validator: it keeps per-step cost low enough to generate simulations at scale. Adding tilemap rendering into `?headless=true` would defeat the primary use case. So the video pipeline needs a sibling mode.

---

## Proposed mode matrix

| Mode | Tilemap + assets | Supabase playback stream | Step driver (`__executeMovementsForStep`) | Camera API | Input/UI chrome | Purpose |
|---|---|---|---|---|---|---|
| `?headless=true` | no | no | yes | yes (unused) | no | Backend validator (keep as-is) |
| Normal (no flag) | yes | yes | yes (unused) | yes | yes | LIVE + Standard Playback viewer |
| `?recording=true` (new) | yes | **no** | yes | yes | **no** | Playwright video capture |

`?recording=true` is essentially "normal mode minus the browser-driven playback minus the UI chrome, plus the backend-driven step driver."

---

## Implementation plan

### Step 1 — add a recording-mode detector

**File:** `lib/headlessConfig.ts`

Extend the existing module rather than creating a new one. Add:

```ts
export function isRecordingMode(): boolean {
  if (typeof window === 'undefined') return false;
  return new URLSearchParams(window.location.search).get('recording') === 'true';
}

export function isBackendDrivenMode(): boolean {
  return isHeadlessMode() || isRecordingMode();
}
```

`isBackendDrivenMode()` is the predicate for "step timeline is owned by `__executeMovementsForStep`, not Supabase." Use it anywhere the codebase currently gates Supabase playback on `!isHeadlessMode()`.

### Step 2 — keep tilemap + sprites in recording mode

**File:** `scenes/MainScene.ts`

The file currently uses literal `.get('headless') === 'true'` checks in four places (lines 269, 328, 420, 1028). Replace them with calls to the helpers:

- `preload()` and `create()` — gate the heavy tilemap/asset work on `isHeadlessMode()`, **not** `isBackendDrivenMode()`. Recording mode needs the visuals.
- `fetchSpriteManifest()` — gate on `isHeadlessMode()`. Recording mode needs sprite atlases.
- Input/camera keyboard setup (line 1028) — gate on `isBackendDrivenMode()`. Playwright shouldn't receive key events.

Net effect: `?recording=true` goes through the full rendering path identical to normal mode.

### Step 3 — suppress the Supabase-driven playback stream

**Files:** `hooks/useSimulation.ts`, `hooks/usePlayback.ts`, `hooks/useSupabaseCoords.ts`, `components/GameCanvas.tsx`

These hooks currently decide whether to subscribe to Supabase realtime coords and drive sprite tweens from the coord stream. In recording mode we need the Supabase subscription **off** so `__executeMovementsForStep` is the only thing moving sprites — otherwise the two systems race and camera follow jitters.

Action: where the code currently reads `isHeadless`, switch to `isBackendDrivenMode()` for the subscription/driver gating. The UI state (selected persona, notifications) can stay mounted — recording-mode CSS will hide it.

### Step 4 — fire `__headlessReady` with the right semantic

**File:** `scenes/managers/AnimationManager.ts`

Today, `__headlessReady` signals "validator is ready to receive a step" (collision data loaded, etc.). For recording we want "scene is painted and sprites are at their start positions."

Smallest-change path:
- Keep `__headlessReady` as-is for `?headless=true`.
- In `?recording=true`, set `__headlessReady = true` once: tilemap layers created, initial sprites placed at their Supabase-fetched start positions, one render tick has flushed. A single `scene.events.once('render', …)` after sprite spawn is sufficient.

Reusing the same flag name keeps the Playwright script unchanged.

### Step 5 — hide UI chrome in recording mode

**File:** `app/simulations/[sim_code]/page.tsx` (or the simulation layout)

Add a `data-recording="true"` attribute on the root when `isRecordingMode()` is true, and a small CSS block that hides the playback controls, top bar, bottom gradient, notifications, and debug panels. This replaces the Python-side `page.add_style_tag()` hack currently in `record_scenes.py` and makes the clean-frame contract a frontend responsibility.

Keep the Phaser canvas at 100vw/100vh and zero margin in this mode.

### Step 6 — types + docs

**File:** `types.d.ts` — already lists the 5 camera functions and `__executeMovementsForStep`. No changes needed unless new globals are added.

**File:** `CLAUDE.md` — add `?recording=true` to the viewing-modes table (currently Headless / LIVE / Standard Playback; becomes a four-row table).

---

## What the backend changes

Minimal:

1. `reverie/backend_server/video/record_scenes.py` — change the navigation URL from `?headless=true` to `?recording=true`.
2. Remove the `page.add_style_tag()` UI-hiding block (frontend owns it now).
3. Remove the `if Director API available` guard — it will always be available.
4. The `--use-gl=swiftshader` browser arg and the FFmpeg 30s head-trim are no longer needed once recording mode renders promptly and signals `__headlessReady`.

`showrunner.py`, `compose_trailer.py`, `tts.py`, `generate_trailer.py` — unchanged.

---

## Validation

**Smoke test before shipping (5 min):** Open `http://localhost:3000/simulations/{sim_code}?recording=true&step=100` in a normal Chrome. Expect:

- Tilemap + sprites render within ~2s.
- No playback controls, no top bar, no debug overlays visible.
- DevTools: `window.__headlessReady === true`.
- DevTools: `window.__setCameraZoom(1.5, 1000)` smoothly zooms in.
- DevTools: `window.__followPersona("Ivan Pistsov")` tracks the sprite.
- Supabase Network tab shows no realtime coord subscription (or it's inactive).

**End-to-end:**

```bash
python -m reverie.backend_server.video.record_scenes 20260407-2 \
  reverie/backend_server/video/trailer_ivan_day1/script.json \
  --output-dir ./test_recording
```

Success: WebM clips show the Phaser tilemap with sprites moving, camera zoom/pan/follow executing as scripted — no static frames, no UI chrome, no 30s loading head to trim.

**Regression guard (scale use case):** Re-run an existing headless simulation generation (`?headless=true` via the backend's `headless_visualization.py`) and confirm step latency is unchanged. The tilemap-skip path must remain the default for `?headless=true`.

---

## Scope

- No new Phaser subsystems, no new `window.__*` functions — the camera API and step driver are reused as-is.
- ~5 files touched in `double-front`, all localized gating changes plus one CSS block.
- Zero changes to sim-execution correctness (validator path is untouched).
- The `?recording=true` mode is the "director mode" previously listed as a post-MVP enhancement in the PRD (§14).
