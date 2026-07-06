# FE UX / UI — observations (Play / viewer mode)

**Date:** 2026-05-12
**Reporter:** Nicolas
**Sim baseline:** `20260506-5` (same sim that cleared action-location MVP).
**Method:** FE visual review on `/simulations/<code>` + targeted source-code review of `double-front` (timeline scrub, URL param ingestion, playback state machine, camera controller). All findings cite the responsible code paths with file:line.
**Predecessor:** `20260508_conversation-observations.md`. With action-location and conversation-realism scoped, FE UX is the third dimension to harden before MVP playback / trailers ship to a viewer.

---

## Summary

Eight FE UX / UI issues, ordered by severity (most user-blocking first). Four were surfaced by direct visual review; four more were surfaced by a targeted code review and have a likely-reproducible shape — they are flagged for visual verification.

**Architectural pattern:** every finding lives at one of three sync boundaries — **(Redux state ↔ URL params)**, **(playback state machine ↔ user input)**, or **(Phaser camera ↔ user attention)**. The four reporter-observed bugs all sit on these boundaries, and the code review surfaced four more bugs on the same boundaries that the report should be able to verify with targeted gestures.

| # | Severity | Source | Issue |
|---|---|---|---|
| 1 | HIGH | observed | Loading spinner stuck indefinitely after URL-step load + pause cycle (sim becomes unusable without refresh) |
| 2 | HIGH | observed | `?step=N` URL param is parsed but ignored in viewer mode (deep-linking silently broken) |
| 3 | HIGH | observed | Camera auto-pan does not pause while user is observing / popover is open (attention-stealing) |
| 4 | HIGH | code-review | Race condition in fast timeline scrub (fire-and-forget `onScrubMove`) — possible visible flicker |
| 5 | MEDIUM | observed | Timeline click before first play seeks but does not auto-start playback (extra click of friction) |
| 6 | MEDIUM | code-review | Optimistic play/pause icon can desync from `playbackState` (visual mismatch, no functional loss) |
| 7 | MEDIUM | code-review | Wheel-zoom asymmetry between `tracking` and `idle` camera modes (same gesture, different outcome) |
| 8 | LOW | code-review | Error path in timeline scrub does not reset interaction refs (only reproducible under network failure) |

---

## Status (updated 2026-05-22, post Tier 3 wheel-zoom + scrub-cleanup)

Tier 1 fixes merged to `main` via `fix/20260512-ux-ui-observations` (6 commits, 2026-05-12). Tier 2 fixes merged to `main` via `fix/20260513-ux-ui-tier2` (5 commits, 2026-05-13). End-to-end visual verification on `20260506-5` confirmed all Tier 1 + Tier 2 issues resolved. Tier 3 issues 7 (wheel-zoom) and 8 (scrub error cleanup) closed on `main` 2026-05-22 (commits `ca60123`, `32ede66`). **The only item still open from this doc is the architectural layer of Issue 3** (flip `autoFollowEnabled` default to off) — held pending Ivan's confirmation it won't collide with trailer-recording. WORKLOG entries `2026-05-12 — Nicolas` and `2026-05-13 — Nicolas` hold the per-commit diagnosis with file:line citations.

| # | Status | Resolution / Notes |
|---|---|---|
| 1 | **DONE 2026-05-12** | Closed via Issue 2's fix (URL ↔ Redux desync was the upstream cause) plus a defensive 5 s timeout on `isAwaitingPlaybackStart` as belt-and-braces. Commits `0047932` + `004e506`. |
| 2 | **DONE 2026-05-12** *(spec wording corrected)* | Original spec text — *"`?step=N` is parsed but ignored"* — was incomplete. `hooks/useUrlStepSync.ts` and the seek effect at `app/simulations/[sim_code]/page.tsx:496-522` already attempt to honor `?step=N`; the audit missed them. **Actual root cause**: race between Phaser scene boot and `useSimulation`'s `setStepDataFetcher` effect — `attemptSeek` readiness guard checked only `controller._animationManager`, so `controller.seekTo()` could fire without a fetcher, silently skipping the fetch branch and leaving Redux at the URL step while sprites stayed at default positions. **Fix**: add `_stepDataFetcher` to the readiness guard on both routes. Commits `0047932` (`/simulations/<code>`) + `e32034f` (`/sim/<code>/play`). |
| 3 | **DONE 2026-05-12** *(cheap layer)* | `PersonaPopover` now calls `cameraController.enterManualMode()` on open + every 5 s while open. Required dropping `private` on `enterManualMode` plus an `idle`-mode gate to avoid the click-to-track lifecycle tearing down the just-opened card. Commits `5f5b999` + `c17957e` (SSR import deferred) + `fb0d7ba` (idle-gate). Architectural layer (flip `autoFollowEnabled` default to off) **still pending** — needs coordination with Ivan's trailer-recording workflow. |
| 4 | **DONE 2026-05-13** | Trailing 50 ms debounce on `onScrubMove` dispatch in `components/simulation/TimelineControls.tsx`. Local visual still synchronous; only the downstream cache-hit teleport is coalesced — closes the race against the consumer's ungated cache path at `hooks/useTimelineControl.ts:218`. Commit `1b6045e`. |
| 5 | **DONE 2026-05-13** *(scope extended)* | First-click branch in `TimelineControls.handleEnd` now treats `hasStartedPlayback === false` as implicit play intent (`onFirstInteraction?.()` + force `shouldResume = true`). Visual verification also surfaced a second resume failure on *recorded* sims: both seek branches treated `simulationStatus === 'stopped'` as end-of-timeline, but for recorded sims that backend state is normal throughout playback — `shouldResume` always evaluated false. Removed the misclassifying clause; only `targetStep >= totalSteps - 1` indicates real completion. Commits `e618dd7` + `ac1d285`. |
| 6 | **DONE 2026-05-13** | Removed the optimistic `setVisuallyPlaying(prev => !prev)` from `PlayerControls.handleToggle`. Icon now driven solely by the existing `playbackState`-mirroring effect; the parent's `togglePlaybackHandler` short-circuits during scrub / live mode are no longer fought by a stale optimistic flip. Commit `409aef2`. |
| 7 | **DONE 2026-05-22** | Unified `onWheel` so any wheel gesture enters manual mode in every camera mode (mirrors drag/pinch), removing the `tracking`-only early-return. Confirmed the early-return was *not* serving trailer recording — the recorder drives zoom via the Director API (`__setCameraZoom`), bypassing `onWheel` (single call site: real user `wheel` event at `MainScene.ts:1086`). In tracking mode the wheel now also closes the popover via the existing cancellation callback. `zoom_changed` has no consumers, so nothing downstream changed. Commit `ca60123`. |
| 8 | **DONE 2026-05-22** | Drag-release and click-seek handlers now reset all interaction refs (`mouseDownPos`/`hasDragged`/`scrubReady`/`isDragging`) + `dragPosition` in a `finally` block via a shared `resetInteractionState()`, so a rejected `onSeek` (network/backend error) leaves the timeline in a clean idle state instead of half-stuck until remount. `clearPendingScrubMove()` stays ahead of `onSeek` (cannot move into `finally`). Commit `32ede66`. |

**Tier 2 refactor landed:** public `controller.isReadyForSeek()` getter on `PlaybackController` (`scenes/managers/PlaybackController.ts`) now replaces the `(controller as any)._animationManager && (controller as any)._stepDataFetcher` accesses Tier 1 left in place on both routes. Pure refactor, behavior identical to Tier 1. Commit `36d9f08`.

**Semantic inconsistency flagged (Tier 3 candidate):** `simulationStatus === 'stopped'` is being used to mean "timeline exhausted" in three places. Tier 2 cleaned it up at the seek-branch decision boundary in `TimelineControls.handleEnd`. The same condition still exists at `hooks/useTimelineControl.ts:146` (`seekToPosition.isCompletedSimulation`) and `components/simulation/TimelineControls.tsx:466` (event-marker `onClick`); both are shielded from the symptom by an extra `simulationStatus === 'running'` guard but should be unified on a future pass.

**Architectural layer of Issue 3 (auto-follow opt-in by default) still pending** — flipping `MainScene.autoFollowEnabled` default to `false` could collide with trailer-recording / `?recording=true` use of auto-follow. Awaiting Ivan's confirmation on trailer impact before scheduling.

**`/sim/<code>/play` route status:** the race that Issue 1/2 describe also existed on this route (the MVP shared-link viewer); both were closed in the same Tier 1 batch. `PlayModeHud` has no timeline scrubber so Issues 4, 5, 8 do not apply there; Issues 3 and 7 share the Phaser camera code and therefore inherit the fix (Issue 3) and the open status (Issue 7).

The body sections below preserve the **pre-fix narrative** that surfaced each finding — they are the historical investigation trail, not the current state. For current state, read this Status section.

---

## Sim `20260506-5` / `/simulations/<code>` — detailed findings

### Issue 1 [HIGH] — Loading spinner stuck indefinitely after URL-step load + pause cycle

**Observed shape:** loading `/simulations/20260506-5?step=710`, clicking Play (animation begins from step 0 — per Issue 2 below — not from step 710), then clicking Pause. The pause UI never resolves — the loading spinner stays up indefinitely until the page is refreshed.

**Why it's the top severity:** the sim becomes effectively unusable from that point onward. There is no in-page recovery path; the user has to reload. Every other bug in this doc has a workaround the user can perform; this one does not.

**Root cause in code:** compound of Issue 2 (URL ↔ Redux desync) + an unresolved-await branch in the playback startup signal.

`app/simulations/[sim_code]/page.tsx:196-208`:

```
196:  useEffect(() => {
197:    const controller = PlaybackController.getInstance()
198:    return controller.subscribe((event) => {
199:      if (shouldResolvePlaybackStartup(event)) {
200:        setIsAwaitingPlaybackStart(false)
201:        dispatch(setPlaybackLoading(false))
202:        return
203:      }
204:      if (shouldCancelPlaybackStartupWait(event)) {
205:        setIsAwaitingPlaybackStart(false)
206:      }
207:    })
208:  }, [dispatch])
```

`isAwaitingPlaybackStart` is set to `true` in `togglePlaybackHandler:738` based on `controller.justSeeked`. It is only cleared if the controller emits either a "resolve" or a "cancel" event. When URL state and Redux state disagree (Issue 2 leaves them disagreeing), the expected resolve event for "playback at the seeked position" does not fire — and no cancel fires either, because no scrub/pause action looks like a cancellation. The loading flag remains true; the spinner remains visible.

**Fix shape:** fix Issue 2 first (it eliminates the URL ↔ Redux disagreement at the source). Add a defensive safety timeout in the `setIsAwaitingPlaybackStart(true)` callsites — if no resolve/cancel event arrives within N seconds, clear the flag and log a `PLAYBACK_STARTUP_TIMEOUT` warning. This stops user-visible stuck states even if a future regression re-introduces the underlying desync.

---

### Issue 2 [HIGH] — `?step=N` URL param is parsed but ignored in viewer mode

**Observed shape:** loading `/simulations/20260506-5?step=710` shows the sim at step 0; the timeline scrubber is at the leftmost position; `step=710` has no effect on the loaded view.

**Root cause in code:** `app/simulations/[sim_code]/page.tsx`

```
128:    const stepNumber = parseInt(searchParams.get('step') || '0', 10)
…
1107:          step={stepNumber} // Use URL param step for headless
…
1122:          step={stepNumber}
```

`stepNumber` is parsed on line 128 but its only two consumers (lines 1107 and 1122) live inside the `if (isHeadless)` and `if (isRecording)` branches respectively. In normal viewer mode the parsed value is dropped on the floor — there is no `useEffect` that seeds `currentStep` or calls `rewindToStep(stepNumber)` from the URL.

**Why this matters beyond the visible bug:** any link-sharing flow (e.g. *"see what happens at step 710"*) is silently broken. Same shape as the FE clock drift from action-location v2 (`?step` is a contract between URL and Redux that one side never honors). Also the root cause of Issue 1's stuck state.

**Fix shape:** add a single `useEffect` near the existing `useSimulation` hook that, on mount when `stepNumber > 0 && !isHeadless && !isRecording`, calls `rewindToStep(stepNumber)` and dispatches the corresponding `PlaybackController.advanceStep(stepNumber, 'url_param')`. Also worth deciding whether arriving via URL should pause or start playback — current behaviour after seek elsewhere is to pause.

---

### Issue 3 [HIGH] — Camera auto-pan does not pause when the user is observing or has a popover open

**Observed shape:** the user clicks on a persona to open their info panel, or hovers over a chat bubble to read it. While they are reading, the camera continues to auto-pan toward the sprite centroid, dragging the panel out of view or scrolling the bubble away.

**Root cause in code:** the definition of "user input" in `scenes/managers/CameraController.ts` is limited to drag, wheel, pinch, and keyboard — observation gestures are not counted.

```
229:        this.enterManualMode();   // drag-threshold met
277:    this.enterManualMode();        // wheel (idle mode)
288:    this.enterManualMode();        // pinch
```

`enterManualMode()` resets a 10-second timer (`scenes/managers/camera.config.ts:18 TIMEOUT_MS: 10000`) after which the camera transitions back to `idle` and `updateIdleCentroidFollow` resumes (line 783). Drag threshold is 10px (`config.ts:24 DRAG_THRESHOLD: 10`), so sub-10px nudges from a trackpad don't even register.

**What's missing as "user input":**
- Persona popover open (`PersonaCard` rendered, sprite has been clicked).
- Chat bubble visible in viewport.
- Mouse hover sustained over the canvas for >N ms with no movement.
- Persona sticker / sidebar interaction.

Any of these is a clear signal that the user's attention is on a specific spot and the camera should not move.

**Fix shape — two layers:**

1. **Cheap and immediate:** when `PersonaCard` mounts (popover open), call `cameraController.enterManualMode()` and keep the timer reset on every relevant React render. When the card unmounts, allow the timer to expire naturally.
2. **Architectural (recommended):** invert the default — `autoFollowEnabled` should be **off** by default and **on** only when the user explicitly clicks the auto-follow toggle. This matches the reporter's intuition (*"I think it should be the other way around"*) and removes an entire class of attention-stealing behaviour. The current implementation already supports this via `MainScene.autoFollowEnabled` (line 79) — flipping the default and gating the toggle in `SettingsMenu` would be a small change.

---

### Issue 4 [HIGH] — Race condition in fast timeline scrub (fire-and-forget `onScrubMove`)

**Code-review finding — visual confirmation pending.**

**Suspect path:** `components/simulation/TimelineControls.tsx:172-175`

```
172:        // Fire data fetch in background (only if scrub is ready) - DON'T await
173:        if (scrubReadyRef.current && onScrubMove) {
174:          onScrubMove(percentage); // Fire and forget - visual already updated
175:        }
```

`onScrubMove` is intentionally fire-and-forget so the visual scrubber position can update without waiting on data fetch. But under fast dragging (e.g. 0 → 100% in <500 ms), many `onScrubMove(percentage)` calls queue up. If their async resolutions arrive out of order, the rendered step number / sprite positions can briefly disagree with the visual scrubber position — a micro-flicker the user perceives as "the scrubber jumped back" or "step shown is wrong for a frame".

**How to verify on FE:** drag the scrubber as fast as possible from far left to far right and back. Watch for transient step-number / sprite-position glitches that do not match the scrubber's current visual position.

**Fix shape:** sequence the in-flight fetches with a small monotonic counter — store `lastDispatchedScrubId` and ignore any data response whose id is less than the latest dispatched. Or debounce `onScrubMove` to 30–60 ms (still visually instant; eliminates the queue).

---

### Issue 5 [MEDIUM] — Timeline click before first play seeks but does not auto-start playback

**Observed shape:** with the sim freshly loaded and started at step 0 (initial Play overlay still showing or just dismissed), clicking the timeline at step 1243 advances the scrubber to that position but does **not** start playback. The user has to click the Play button a second time to actually see the sim advance.

**Why MEDIUM (not HIGH):** the sim continues to work — the user just has to perform one extra click. No state corruption, no recovery needed. First-touch friction rather than functional break.

**Root cause in code:** `components/simulation/TimelineControls.tsx`

```
121:    wasRunningRef.current = isPlaybackMode;
…
240:    const shouldResume = wasRunning && !isCompletedSim;
241:    if (shouldResume && onStartPlayback) {
242:      onStartPlayback();
243:    }
```

The click path captures `wasRunningRef.current` from `isPlaybackMode` **before** seeking. At step 0 with no prior play, `isPlaybackMode === false`, so `wasRunning === false` after the click — `shouldResume` evaluates false and the auto-resume branch never fires.

The "click timeline to seek" gesture is implicitly treated as "scrub from a paused state", but the actual user intent on first interaction is "play from here". The state machine cannot distinguish "user has never played yet" from "user paused at step 47".

**Fix shape:** before the `shouldResume` check, treat `!hasStartedPlayback` as equivalent to "user intent to play". The handler should consume `hasStartedPlayback` (currently scoped to the parent `app/simulations/[sim_code]/page.tsx:161`) and force-start playback on first timeline interaction.

---

### Issue 6 [MEDIUM] — Optimistic play/pause icon can desync from `playbackState`

**Code-review finding — visual confirmation pending.**

**Suspect path:** `components/simulation/PlayerControls.tsx:120-129`

```
120:  const [visuallyPlaying, setVisuallyPlaying] = useState(false);
121:
122:  useEffect(() => {
123:    setVisuallyPlaying(playbackState === 'playing' || playbackState === 'seeking');
124:  }, [playbackState]);
125:
126:  const handleToggle = useCallback(() => {
127:    setVisuallyPlaying(prev => !prev);
128:    togglePlayback(false);
129:  }, [togglePlayback]);
```

`visuallyPlaying` is optimistically flipped on click for instant visual feedback. But `togglePlayback` (in `app/simulations/[sim_code]/page.tsx:679-760`) can be a no-op in several conditions — it short-circuits when `isScrubbing || controller.isScrubbing || controller.mode === 'scrubbing'` (line 683) and when `isLiveMode` is true (line 696). In those no-op paths, `playbackState` never changes, but `visuallyPlaying` has already been flipped — the icon shows the wrong state until the next external state update touches `playbackState` and re-runs the effect on line 122.

**How to verify on FE:** start dragging the scrubber and, mid-drag, click the play/pause button. Observe whether the play/pause icon flips while playback does not (the icon should remain consistent with actual state).

**Fix shape:** the optimistic flip should only happen if `togglePlayback` is going to actually do something — gate it behind the same checks that gate `togglePlayback`, or remove the optimistic flip entirely and rely on the `useEffect` to sync from `playbackState` (small visual delay but no desync).

---

### Issue 7 [MEDIUM] — Wheel-zoom asymmetry between `tracking` and `idle` camera modes

**Code-review finding — visual confirmation pending.**

**Suspect path:** `scenes/managers/CameraController.ts:260-280`

```
260:  onWheel(deltaY: number): void {
…
269:    // In tracking mode: zoom but keep following the sprite
270:    if (this._mode === 'tracking') {
271:      this._camera.setZoom(newZoom);
272:      this.notify({ type: 'zoom_changed', zoom: newZoom });
273:      return; // Don't enter manual mode - keep tracking
274:    }
275:
276:    // For other modes: enter manual mode as before
277:    this.enterManualMode();
278:    this._camera.setZoom(newZoom);
279:    this.notify({ type: 'zoom_changed', zoom: newZoom });
```

Wheel zoom behaves differently depending on camera mode:

- **`tracking` mode** (user clicked a persona): wheel zooms but **continues to track** the sprite.
- **`idle` mode** (auto-follow centroid): wheel zooms **and** pauses auto-follow for 10 s.

The intent is probably *"don't lose tracking just because the user is fine-tuning the zoom"*. But the user has no visible indicator of mode, so the same gesture behaves differently in two visually-similar states. Expected behaviour from a user model: *"if I scroll the wheel, I'm taking control of the camera"*.

**How to verify on FE:** click a persona to enter tracking mode, then mouse-wheel zoom. Watch whether the sprite stays roughly centered (tracking continues) vs whether the view stays fixed where the user pointed (manual mode). Compare with the same wheel gesture from a non-tracking starting state.

**Fix shape:** the simpler model is "any wheel zoom is a user-control signal — enter manual mode". If `tracking`-preserving zoom is a deliberate UX, add a small on-screen indicator while in `tracking` mode so the user understands why the camera behaves differently.

---

### Issue 8 [LOW] — Error path in timeline scrub does not reset interaction refs

**Code-review finding — visual confirmation pending; reproducible only under network failure.**

**Suspect path:** `components/simulation/TimelineControls.tsx:215-218`

```
215:        } catch (err) {
216:          console.error('Timeline drag release error:', err);
217:          setDragPosition(null);
218:        }
```

The catch block on the drag-release path only clears `dragPosition`. It does **not** clear `hasDraggedRef.current`, `scrubReadyRef.current`, or `isDraggingRef.current`. If `onSeek` throws (e.g. transient network failure, backend error), the timeline can be left in a half-stuck state where subsequent gestures take a different code path than intended until React re-mounts the component.

The click-handler catch block at line 244–247 has the same shape (only resets `dragPosition`).

**How to verify on FE:** disable network in DevTools, attempt a timeline scrub, re-enable network. Re-attempt a normal scrub immediately and look for unexpected behaviour (delayed seek, double-fired listeners, scrub flag persisting on subsequent clicks).

**Fix shape:** centralise the cleanup of all interaction refs in a `finally` block alongside the try/catch, so success and failure paths both reset the state.

---

## Pattern — architectural root causes

The eight findings cluster around three sync boundaries that the FE has not fully closed:

1. **Redux state ↔ URL params.** Issues 1 and 2 both originate here. The URL is a one-way input — Redux is updated from user actions but the URL is never read on mount as a seed. Any deep-linking feature is silently broken until this is closed, and Issue 1's stuck state is downstream of the same gap.

2. **Playback state machine ↔ user-input intent.** Issues 4, 5, 6 sit here. The state machine treats *"user has not started playing"* identically to *"user paused at step N"*, treats fast scrubbing as discrete-and-orderable events, and lets optimistic UI run ahead of the only source of truth (`playbackState`). The fix shape is to make the state machine richer (new state for "pre-first-play") and to gate optimistic transitions on the same guards that gate the underlying action.

3. **Phaser camera ↔ user attention.** Issues 3 and 7 sit here. The camera defines "user input" too narrowly (drag/wheel/pinch only) and applies it asymmetrically across modes. The reporter's instinct — *"camera should not auto-trigger while I'm moving / observing"* — points at the right direction architecturally: invert the default so auto-follow is **opt-in**, and treat *attention signals* (popover open, hover sustained, sidebar interaction) as input.

4. **Error-recovery hygiene.** Issue 8 is a sub-class of the above — the cleanup paths for interaction state are not symmetric with the setup paths. Centralising state into `finally` blocks closes this class of bug across the component tree (worth grepping for similar `catch { setX(null) }` patterns elsewhere).

---

## Suggested next steps

Ordered by user-facing impact, with cheap/medium markers:

### Tier 1 — visible bugs to close before any deep-link or trailer playback ships

1. **Honour `?step=N` in viewer mode (closes Issue 2 + most of Issue 1)** *(cheap)*. Add one `useEffect` near `useSimulation(simCode)` that on mount calls `rewindToStep(stepNumber)` when `stepNumber > 0 && !isHeadless && !isRecording`. Verify by loading `/simulations/<code>?step=710` and checking that timeline + canvas land on step 710.
2. **Defensive timeout on `isAwaitingPlaybackStart` (residual safety for Issue 1)** *(cheap)*. Wherever the flag is set true, also start a 5 s safety timer that clears it and logs `PLAYBACK_STARTUP_TIMEOUT`. Prevents the stuck-spinner state even if a future regression re-introduces the underlying desync.
3. **Camera-pause on observation signals (closes Issue 3 cheap layer)** *(cheap)*. When `PersonaCard` (popover) is open, call `cameraController.enterManualMode()` and keep the timer reset while mounted. Verify by opening Katya's panel and waiting 15 sim-seconds — camera should remain still.

### Tier 2 — invert defaults / harden state-machine

4. **Make auto-follow opt-in by default (closes Issue 3 architecturally)** *(cheap)*. Flip `MainScene.autoFollowEnabled` default to `false`; surface the toggle in `SettingsMenu` so the user opts in. This is the reporter's preferred shape (*"I think it should be the other way around"*) and removes Issue 3 as a class of bug rather than as instances.
5. **Sequence the timeline-scrub data fetches (closes Issue 4)** *(cheap–medium)*. Add a monotonic `lastDispatchedScrubId` ref; ignore any data response whose id is less than the latest dispatched. Or apply a 30–60 ms debounce on `onScrubMove`.
6. **Treat first timeline click as implicit play-start (closes Issue 5)** *(cheap)*. In `TimelineControls.tsx` click path, if `!hasStartedPlayback` was passed in, set it true and force `onStartPlayback()` after seek regardless of `wasRunning`.
7. **Gate the optimistic play/pause flip (closes Issue 6)** *(cheap)*. Move the `setVisuallyPlaying(prev => !prev)` call behind the same guards as `togglePlayback` (`isScrubbing`, `isLiveMode`).

### Tier 3 — small consistency and hygiene

8. **Resolve wheel-zoom asymmetry (closes Issue 7)** *(cheap)*. Simplest: make `onWheel` always call `enterManualMode()` regardless of current mode. If preserving tracking-during-zoom is intentional, add a small on-screen "tracking" indicator so the asymmetry is visible to the user.
9. **`finally` cleanup of scrub interaction refs (closes Issue 8)** *(cheap)*. Restructure the try/catch blocks in `TimelineControls.tsx` so all interaction-state resets live in `finally`. Also worth a quick grep for similar `catch { setX(null) }` patterns across `components/`.

### Tier 4 — analyzer / standing-watch

10. **Add a smoke test for `?step=N` and other URL params** *(medium)*. Playwright test that loads `/simulations/<code>?step=N` for N ∈ {0, 100, 1000} and asserts the rendered step matches the URL after scene-ready. Prevents Issue 2 from silently re-regressing.

---

## What I checked vs what is still pending

**Checked:**
- Visual review of `/simulations/20260506-5` and `/simulations/20260506-5?step=710` for the four reporter-observed issues.
- Source-code review of:
  - `app/simulations/[sim_code]/page.tsx` — URL param ingestion, `togglePlaybackHandler`, `isAwaitingPlaybackStart` subscription.
  - `components/simulation/PlayerControls.tsx` — play/pause button, optimistic `visuallyPlaying` state.
  - `components/simulation/TimelineControls.tsx` — scrub interaction, click vs drag, fire-and-forget data fetch, catch-block cleanup.
  - `scenes/managers/CameraController.ts` and `scenes/managers/camera.config.ts` — manual mode, auto-follow centroid, wheel-zoom behaviour, timeout values.
  - `components/CameraControls.tsx` — focus toggle UI.
- Cross-reference of the four code-review findings (Issues 4, 6, 7, 8) against the reporter's observed bugs to confirm the same sync-boundary pattern.

**Pending:**
- **Visual verification of Issues 4, 6, 7, 8.** The code paths are flagged with the gesture needed to reproduce; each one needs a 1-minute FE test to confirm. Until verified, treat severities as preliminary.
- **`/sim/<code>/play` route (`?t=N` param).** This doc focused on `/simulations/<code>` (the debug/viewer route Nicolas was using). The `/sim/<code>/play` route uses a different URL contract (`?t=N`, `?double=...`, `?zoom=...`, `?focus=...`) and a separate codepath. Worth a sibling pass before MVP trailer playback ships.
- **Mobile / touch interactions.** The TimelineControls handler has parallel touch listeners (`onTouchMove`, `onTouchEnd`) with their own catch points (lines 261–276). Same fix-shape probably applies to Issue 8 on touch, but not visually verified.
- **Low-bandwidth / high-latency playback** (mentioned in the predecessor scoping but not investigated here). The `useRealtime` hook, `useStatusPolling`, and `getStepData` paths have their own state-coordination logic that would need a separate pass under degraded-network conditions.
- **Cold-start time-only `09:00:00` mock null-fall** (flagged in the action-location v2 doc Issue 5 — Phase B.1 follow-up). Not re-inspected here; tracking under the existing V5 follow-up.
- **Accessibility and visual-polish issues** (color contrast, focus rings, keyboard navigation, ARIA labels). Out of scope for this pass — flagged as separate work if a viewer-facing release is on the horizon.
