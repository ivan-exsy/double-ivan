# FE sound system — ambient audio, per-arena, per-object, per-interaction

**Status:** Proposal, awaiting Ivan sign-off.
**Author:** Nicolas
**Filed:** 2026-05-19
**Updated:** 2026-05-20 - by Ivan 
**Target repo:** `double-front` (Phaser playback layer; no BE changes required for v1).
**Related:** `20260519_LIVE_mode.md` §7.6 (origin of this proposal), `sot_video.md` §3 Step 3 + §3 Step 5 (existing trailer audio path).
**Code audit:** grounded in a full audit of `double-front` performed 2026-05-19; all file:line references below were verified.

---

## 1. One-sentence pitch

The Phaser playback ships **completely silent today** (zero audio code in `double-front` — no `HTMLAudioElement`, no `AudioContext`, no audio assets). For a product pitched as *"watch your doubles live their day,"* silence reads as *prototype*, not *product*. A layered sound system (per-arena ambient + per-object SFX + per-interaction triggers + mood music + proximity mixing) closes the largest immersion gap and is achievable as a focused FE deliverable in roughly **~4–6 h of senior-dev coding with AI-pair programming + ~1.5 h of asset curation** for v1.

---

## 2. Why this matters (the case for MVP inclusion)

**Every shipped life-sim has it.** The Sims, Stardew Valley, Animal Crossing, RimWorld, Project Zomboid — none treat audio as a v2 polish layer. Its absence reads as conspicuously incomplete.

**The Truman-Show pitch depends on it.** The film's diegetic ambient (café chatter, page rustles, distant traffic) is what sells "watching a real person live." Without it, the canvas is a screensaver.

**Shareability collapses without audio.** TikTok / Reels / Shorts are audio-first. A muted clip of the sim has near-zero share potential.

**The trailer pipeline already benefits.** Today's trailers mix narration + music. Adding a diegetic ambient bed under narration (using the *same* audio system) pushes Episodes from "voiced screenshots" to "documentary footage" — concrete win on existing infrastructure.

---

## 3. Where this plugs into the FE codebase (audit findings)

All file paths are absolute under `double-front/`. The system is built on top of these existing hooks — no architectural rewrite needed.

### 3.1 Audio starts from zero

No prior audio code exists. Confirmed: no `HTMLAudioElement`, `AudioContext`, WebAudio, `Howler`, `Tone.js`, or `.mp3`/`.wav`/`.ogg` files anywhere in `app/`, `components/`, `scenes/`, `lib/`, `hooks/`, `public/`. This is a clean greenfield.

### 3.2 Phaser scene entry point

**`scenes/MainScene.ts:60`** — `MainScene extends Phaser.Scene`.
- `preload()` at line 326 (we add audio preloading here).
- `create()` at line 414 (we initialize the `AudioContext` and the audio manager singleton here).
- `update(time, delta)` at line 2647 (called every frame — we drive proximity gain updates here).

### 3.3 The single audio entry point per step

**`scenes/managers/AnimationManager.ts:923`** — `window.__executeMovementsForStep(stepData)`.

This is the *one* function called per simulation step with the full payload from the backend. Every audio trigger that depends on step data (chat starts, arena changes, action transitions, walking, sleeping) is dispatched from here.

There's also `setOnStepComplete()` (line ~220 in `AnimationManager.ts`) — fires after all per-step tweens resolve. Useful for cross-fade timing on arena transitions.

### 3.4 Arena lookup

**`scenes/managers/CollisionChunkManager.ts:180-183`**
```typescript
getArena(worldX: number, worldY: number): string | null {
  const data = this.getSemanticData(worldX, worldY)
  return data?.arena || null
}
```

Arenas come from `public/assets/the_ville/matrix/special_blocks/arena_blocks.csv` (63 named arenas). The arena tag is also encoded in each persona's `description` string from the BE in the format `@ the Ville:Dorm for Oak Hill College:kitchen:kitchen sink` — but doing the lookup via `CollisionChunkManager.getArena()` is more robust than parsing.

**To determine "what arena should we be ambient-playing right now?":** read the camera's current world coords (`CameraController.getInstance().camera.scrollX/scrollY`, divided by `TILE_SIZE = 32`) and pass them to `getArena()`. If the camera is following a persona, the persona's arena and the camera's arena are usually the same.

### 3.5 Persona state fields (from step payload — see `step1.json` for shape)

Every persona in a step has:

| Field | Type | Used for |
|---|---|---|
| `description` | string (e.g., "reviewing case files at the library table") | Action label, mood inference, sleep detection |
| `pronunciatio` | string (emoji shorthand, e.g., "☕📂") | Optional UX tagging |
| `chatting_with` | string \| null | Triggers conversation chatter |
| `chat` | object \| null | Active utterance |
| `facing` | "up" \| "down" \| "left" \| "right" | Animation direction (not audio-relevant) |
| `stationary_intent` | boolean | If true → no footsteps |
| `speed_multiplier` | float (0.0 = still, 1.0+ = walking) | Footstep cadence |
| `path` | array of `[x, y]` | Movement queue |

**Sleeping detection** (today, via string match): `description.toLowerCase().includes('sleep') || .includes('bed')` — see `MainScene.ts:38`. We reuse this exact predicate to trigger the snore loop.

**Walking detection:** `speed_multiplier > 0 && !stationary_intent && path.length > 0`, or `animationManager.hasActiveTweens(personaName)` (see `InteractionManager.ts:314`).

### 3.6 Walking animation hook (for footsteps)

Walk animations are named `${characterName}_${direction}_walk` (`MainScene.ts:214`), 4 frames per direction at 8 fps, looping (`MainScene.ts:226`).

Phaser sprites accept `sprite.on('animationupdate', (anim, frame) => {...})`. We hook this once per sprite at sprite creation; trigger a footfall sample on frame index 1 or 3 (downstep frames). Configurable per character; one sample is enough for v1.

### 3.7 Camera APIs (already published)

In `scenes/managers/AnimationManager.ts`:
- `window.__followPersona(name)` (line 901)
- `window.__setCameraZoom(level, durationMs?)` (line 862)
- `window.__panCameraTo(tileX, tileY, durationMs?)` (line 879)

`CameraController.trackingPersonaName` (`CameraController.ts:966`) tells us who the camera is following. The audio system uses this to scale ambient/SFX volume by distance between source sprite and camera focal point (proximity mixing).

### 3.8 Proximity / observation events

**`scenes/managers/InteractionManager.ts:51-53`** — `InteractionManager` already batches "personas near each other" per step and fires an `onObservation` callback. We piggyback this for conversation chatter: when 2+ personas are within proximity *and* in chat state, the chatter loop plays at the position midway between them.

### 3.9 Object positions (for per-object SFX)

`public/assets/the_ville/matrix/special_blocks/game_object_blocks.csv` lists 45 unique interactable objects (bed, desk, refrigerator, toaster, shower, piano, guitar, cafe counter, library sofa, etc.) — each pinned to specific tile coordinates. Objects are **stateless tiles**, not dynamic sprites; no per-object state to subscribe to.

**Approach for object SFX:** when a persona's `description` mentions an object keyword AND the persona is on or adjacent to that object's tile (via `getGameObject(x, y)` lookup analogous to `getArena`), the corresponding per-object SFX fires.

### 3.10 State management

**`store/uiSlice.ts`** (Redux) holds UI preferences: `gameViewport.zoom` (line 11), `showSubtitles` (line 14), `autoFollowEnabled` (line 15), `dramaFilterEnabled` (line 16). We add a sibling slice `store/audioSlice.ts` with `masterVolume`, `musicVolume`, `ambientVolume`, `sfxVolume`, `muted`, persisted to `localStorage`.

Controls wire into existing UI in `components/simulation/SettingsMenu.tsx` and `components/simulation/PlayerControls.tsx`.

### 3.11 Mood data (NOT YET AVAILABLE from BE)

`day_log.mood` (`intrigue | drama | wholesome`, classified by the trailer showrunner) is **not currently passed to the FE** in the per-step payload. For v1 the FE defaults to `wholesome` background music and may infer drama heuristically from `description` strings (e.g. argument keywords). A proper fix requires exposing `mood` on the day's metadata — see §15 BE asks.

### 3.12 Asset directory

No audio folder exists. Recommended path: **`public/audio/`** with subfolders:
```
public/audio/
├── ambient/        per-arena loops (~12 files, ~30–60s each, OGG mono 96kbps)
├── sfx/objects/    per-object one-shots (~25 files, OGG mono)
├── sfx/interactions/  footsteps, chatter, page turns, snore
├── music/          playback mood loops — `playback_{mood}.ogg`, see §7
└── ui/             sting/jingle for Episode drop (post-MVP)
```

`next.config.ts` requires no audio-loader changes — static files in `public/` are served as-is.

---

## 4. Per-arena audio map

The Ville maze has **63 arenas grouped under 8 sectors**. Most arenas of the same *type* share an ambient loop, so we ship ~10 distinct ambient tracks that cover all 63 arenas:

| Ambient loop | Covers these arena names (canonical from `arena_blocks.csv`) | Character |
|---|---|---|
| `cafe.ogg` | Hobbs Cafe (cafe interior + "behind the cafe counter") | Low chatter, espresso hisses, cup clinks, occasional bell |
| `pub.ogg` | The Rose and Crown Pub (cafe + behind the bar) | Heavier chatter, bottle clinks, music slightly more present |
| `store_general.ogg` | The Willows Market and Pharmacy, Harvey Oak Supply Store | Quiet retail bed: HVAC, rare register beep, faint shelf sounds |
| `library.ogg` | Oak Hill College library areas (library table, library sofa zones) | Near-silence + faint page turn + chair creak |
| `classroom.ogg` | Oak Hill College classroom (student seating + podium) | Muffled chairs, paper, faint chalk |
| `kitchen.ogg` | Any "kitchen" arena (artist's co-living, dorm kitchen) | Sizzle if cooking active, fridge hum, cutlery |
| `common_room.ogg` | "common room" arenas (co-living, dorm) | Soft chatter, TV in background, occasional laugh |
| `bedroom_quiet.ogg` | Bedroom / Dorm Room / Studio Room / Apartment main room (when no one sleeping) | Clock tick, window faint, near-silence |
| `bedroom_sleeping.ogg` | Same arenas above, when ≥1 persona has `description` matching sleep predicate | Soft snore layered on the quiet loop |
| `bathroom.ogg` | Any "bathroom" / Studio Bathroom variant | Faint plumbing hum, occasional drip |
| `outdoor_garden.ogg` | Johnson Park, dorm garden, park garden, house garden | Birds, breeze, distant traffic |
| `hallway.ogg` | "hallway" arena | Empty corridor reverb, faint distant sound from adjacent rooms |

**Selection logic (in `MainScene.update()`):**
1. Get camera focal world coord.
2. `CollisionChunkManager.getArena(x, y)` → arena name.
3. Map arena → ambient loop key via a static config object.
4. If active loop != target loop, cross-fade ~2 s.
5. For `bedroom_sleeping.ogg`: switch in when any persona present in that arena matches the sleep predicate.

**Fallback:** if `getArena()` returns `null` (outdoor, between zones, edge of map), play `outdoor_garden.ogg` at reduced volume.

---

## 5. Per-object SFX map

When a persona's `description` contains a verb tied to an object keyword AND the persona is on/adjacent to that object's tile, fire a one-shot. Mapped against the 45 game objects in `game_object_blocks.csv`:

| Object | Trigger phrase examples (from `description`) | SFX |
|---|---|---|
| bed | "going to bed", "lying down", "sleeping" | Soft mattress creak (one-shot) + snore loop activates while in state |
| desk | "writing", "studying", "working" | Light paper rustle + pencil scratch loop (low volume) |
| closet | "getting dressed", "picking out" | Hanger / fabric one-shot |
| shelf, bookshelf | "browsing", "picking up", "reading" | Soft thunk + page turn |
| easel | "painting", "sketching" | Brush stroke loop (low) |
| bathroom sink, kitchen sink | "washing", "rinsing" | Running water loop |
| shower | "taking a shower", "showering" | Shower loop |
| toilet | "using the toilet" | Flush one-shot at exit |
| refrigerator | "getting", "grabbing", "fetching" | Fridge door open + close one-shot |
| toaster | "making toast", "toasting" | Toaster ding |
| cooking area | "cooking", "preparing food", "making" | Sizzle loop while in state |
| common room table | "eating", "sitting down to eat" | Cutlery + plate clinks |
| common room sofa, library sofa | "resting", "relaxing" | Soft cushion settle one-shot |
| guitar | "playing guitar", "practicing" | Acoustic guitar loop (low volume, fades with distance) |
| piano | "playing piano" | Piano loop |
| microphone | "singing", "performing" | Voice-mic faint reverb cue |
| harp | "playing harp" | Harp loop |
| bar customer seating | "ordering a drink", "drinking" | Glass clink one-shot |
| behind the bar counter | "serving", "pouring drinks" | Bottle pour + glass slide |
| behind the cafe counter | "preparing drinks", "making coffee" | Espresso machine one-shot + steam |
| cafe customer seating | "sipping", "drinking coffee" | Cup-on-saucer clink |
| blackboard | "writing on the blackboard", "teaching" | Chalk loop (low) |
| classroom podium | "lecturing", "presenting" | Page rustle |
| game console | "playing games", "gaming" | Faint controller / game UI blip loop |
| computer, computer desk | "typing", "coding", "working on" | Keyboard typing loop |
| pool table | "playing pool" | Cue strike + ball roll one-shot |
| lifting weight | "exercising", "lifting" | Grunt + metal clink one-shot |
| store/pharmacy/grocery counters | "checking out", "buying" | Register beep |
| dorm/house/park/garden zones | n/a — covered by ambient layer | (no per-object SFX needed) |

**For v1 (MVP):** ship the **10 highest-impact** object SFX from this list (bed, sink, shower, fridge, cooking, common room table, guitar/piano, espresso machine, computer typing, register). Rest deferred to v2.

**Trigger guard:** state transitions only (don't fire one-shots every step while the persona stays in the same activity). Compare the persona's `description` between consecutive `__executeMovementsForStep` calls; fire on *change* matching a mapped phrase.

---

## 6. Per-interaction SFX

These are triggered by state events independent of arena/object.

### 6.1 Footsteps (loop, per persona)

- Hook `sprite.on('animationupdate', (anim, frame) => {...})` once on sprite creation (in `AnimationManager` where sprites are instantiated).
- On `${dir}-walk.001` or `${dir}-walk.003` frame, fire one footfall sample.
- Volume scaled by proximity to camera focal point (see §7).
- Surface differentiation (wood / tile / grass) is post-MVP.

### 6.2 Conversation chatter (loop)

- Triggered when a persona's `chatting_with !== null` AND another persona within camera-audible range is also chatting (cross-reference via `InteractionManager.onObservation` callback at `InteractionManager.ts:51`).
- Non-language murmur loop (2–3 randomized variants to avoid robotic repetition) plays at the midpoint between the two sprites.
- Fades on `chatting_with` returning to `null`.
- For groups of 3+, layer two variants for a "many voices" effect (cap voices count at 4 to avoid clutter).

### 6.3 Sleeping (loop)

- When any persona in the active arena matches `description.toLowerCase().includes('sleep') || .includes('bed')` (the existing predicate at `MainScene.ts:38`), the snore loop layers on top of the arena's quiet ambient.
- Cross-faded with `bedroom_quiet.ogg` → `bedroom_sleeping.ogg`.

### 6.4 Action transition stingers (subtle)

When `description` *changes* between consecutive steps, fire a very subtle "page turn" / "context shift" cue (~-18 dB, almost subliminal). Optional; toggleable in settings. Helps the viewer perceive that *something happened* during long scrubbing.

---

## 7. Playback soundtrack — loopable mood music

The music layer is a dedicated **playback soundtrack**: a seamless, loopable music bed that plays under live sim playback.

It is a *distinct asset set* from the trailer pipeline's mood tracks. For `intrigue` and `wholesome`, the original 75 s trailer tracks have proven suitable for seamless looping after middle-section extraction and crossfade. The drama track retains too pronounced an arc for immediate looping and is deferred to post-v1. The resulting playback beds preserve the exact instrumentation and character of the trailer masters so the brand sound stays consistent.

This section is the spec for the soundtrack assets. Producing the assets is an Ivan workstream (LIVE-mode **BE-2**); wiring the single v1 loop into playback is part of Nicolas's sound-system delivery (§10).

### 7.1 Current implementation (v1) — updated 2026-05-21

- **Asset set:** Seamless loopable versions derived directly from the original trailer masters for `intrigue` and `wholesome` (drama deferred — its arc is less loop-friendly). (The premiere `anthem` track is opener-only and is *not* part of the playback set.)
- **Wired in v1:** only the **intrigue** loop is wired. Intrigue is the playbook's default mood — "curiosity, surveillance, quiet wonder, voyeuristic intimacy" — the exact register of the "watch your doubles live their day" pitch. It plays continuously, looping, at ~-12 dB under any SFX.
- **No mood switching in v1.** No signal, no crossfade, no selection logic — one loop, always. The `wholesome` loop is produced and stored as an asset *now* so the future hybrid system (§7.2) becomes an asset-ready, wiring-only change — but it sits dormant in v1.
- **Why one loop:** mood switching needs a reliable per-scene mood signal, which does not exist today (see §7.2). Shipping one neutral loop removes the signal, the transition logic, and the jitter problem entirely — lowest-risk path to closing the silence gap.

**Source masters (for Nicolas / FE processing):**
- Intrigue: `generative_agents/video/audio/music_intrigue.mp3`
- Wholesome: `generative_agents/video/audio/music_wholesome.mp3`

**Processed asset locations:**
- Playback loops (FE repo): `public/audio/music/playback_{mood}.ogg` — OGG ~96–128 kbps.
- Lossless WAV masters (kept out of the FE repo): `video/audio/_raw/playback_{mood}.wav`.
- Processing: middle-section extraction + seamless crossfade loop + −16 LUFS normalization (same target as trailer tracks).

### 7.2 Future concept — rich hybrid mood system (post-v1)

The post-v1 target is a **two-axis** soundtrack that reacts to the scene without sounding jittery.

- **Axis 1 — emotional mood (slow, per-day): the base track.** Selects `intrigue` / `drama` / `wholesome`. The trailer showrunner *already* classifies a per-day mood; the BE would expose it to the FE via a thin per-day endpoint (mirror the `day_highlights` endpoint pattern, or fold a `mood` field into existing day metadata — this is the §15 BE ask #1). Changes at most once per day.
- **Axis 2 — activity energy (fast, per-step): within-day modulation.** Derived on the FE from the household mix of `action_family` — a structured enum (`sleep / study / work / relax / eat / cook / …`) now guaranteed in every step payload (LIVE-mode BE-1). Example mapping: whole household asleep → night/quiet; majority in conversation → warmer; majority heads-down working → focused/low. Needs **no BE work** — the FE already receives `action_family`.
- **Layered stems, not track swaps.** Each mood loop is authored as separable stems (pad/bed, rhythm, melody). Activity energy fades stems *in and out* rather than swapping whole tracks — a calm scene drops to pad-only, a social scene adds rhythm. This is why the v1 loops should be generated stem-friendly (sparse, layer-separable) even though v1 plays them flat.
- **Smooth transitions — an asset constraint, handled upfront.** All three loops are generated at the **same tempo and a shared tonal centre** (see §7.3), so a base-track crossfade on a day-mood change is harmonically clean (~3–5 s). Within-day stem fades are inherently smooth. A **minimum dwell time** (mood cannot change more than once per N sim-minutes) prevents the music flipping every few seconds as personas change activity.
- **Speed-aware:** at 6× the bed plays as designed; if the viewer slows to ~1× to inspect a moment, the diegetic SFX layer (§5–§6) rises and the music may duck slightly. Above 1× speed, SFX stays off and the music bed carries alone.
- **Live edge vs. scrub-back:** identical treatment — mood is keyed to the sim-day / segment being *viewed*, not to whether playback is at the live frontier.

This concept also subsumes the §13 roadmap item "Mood-driven music within a day."

### 7.3 Suno prompt templates (superseded for v1 intrigue & wholesome)

The prompt templates below document the original generation approach. For v1, `intrigue` and `wholesome` use direct looping of the original trailer masters (`music_intrigue.mp3`, `music_wholesome.mp3`) after middle-section extraction and seamless crossfade — these tracks proved sufficiently flat and character-rich for continuous playback. Drama remains deferred. The future hybrid (§7.2) may still benefit from the tempo/key unification described below when the other moods are added.

**Intrigue (wired in v1):**
```
Seamless looping cinematic underscore. 88 BPM, A minor. Fully instrumental.
Flat, consistent energy throughout — NO build, NO climax, NO fade-out tail;
written to loop cleanly from end back to start.
Sparse solo piano with reverb over soft sustained strings; a subtle electronic
pulse like a distant heartbeat runs underneath the entire piece.
Calm but gently moving — suited to a 6x time-lapse of daily life, not a drone.
~2.5 minutes. No drums beyond soft brushed percussion. Keep layers sparse and
separable (pad, pulse, piano) for later stem export.
Inspired by: Philip Glass, Thomas Newman, The Truman Show soundtrack.
Mood: curiosity, surveillance, quiet wonder, voyeuristic intimacy.
No vocals. No lyrics. Instrumental only.
```

**Drama:**
```
Seamless looping cinematic underscore. 88 BPM, A minor. Fully instrumental.
Flat, sustained tension throughout — NO build to a peak, NO hard silence,
NO fade-out tail; written to loop cleanly from end back to start.
Solo cello and sustained string tension chords; a low timpani heartbeat pulse
underneath; sparse piano accents.
Dark but empathetic — weight without melodrama; steady, never escalating.
~2.5 minutes. Keep layers sparse and separable (strings, timpani pulse, piano)
for later stem export.
Inspired by: Hans Zimmer (Interstellar quiet moments), Max Richter.
Mood: consequence, unease, emotional weight, something unresolved.
No vocals. No lyrics. Instrumental only.
```

**Wholesome:**
```
Seamless looping acoustic underscore. 88 BPM, C major (relative major of the
intrigue/drama loops — crossfades cleanly with them). Fully instrumental.
Flat, gentle, even warmth throughout — NO build, NO peak, NO fade-out tail;
written to loop cleanly from end back to start.
Fingerpicked acoustic guitar in a simple repeating pattern, warm piano chords,
soft glockenspiel/marimba accents, light brushed drums.
Unhurried, like a Sunday morning that never ends.
~2.5 minutes. Keep layers sparse and separable (guitar, piano, glockenspiel,
drums) for later stem export.
Inspired by: Explosions in the Sky (gentle tracks), Olafur Arnalds.
Mood: kindness, community, small good things, calm.
No vocals. No lyrics. (A wordless "ooh", very low in the mix, is acceptable.)
```

**Post-generation (per track):**
1. Generate 2–3 takes; pick the one that holds steady energy and loops most naturally.
2. Suno will not hand back a perfect loop — trim to a bar-aligned loop point in an editor and crossfade the tail into the head so the seam is click-free.
3. Normalize to −16 LUFS via `video/audio/normalize.sh --target music` (same target as the trailer tracks).
4. Export OGG ~96–128 kbps to `public/audio/music/playback_{mood}.ogg`; keep the lossless WAV master in `video/audio/_raw/playback_{mood}.wav`.
5. If the platform supports stem export, export stems — the future hybrid (§7.2) fades stems, not whole tracks.

---

## 8. Proximity mixing

Implementation: WebAudio `GainNode` per source. Per-frame in `MainScene.update()`:

```
distance = dist(source_world_xy, camera.scrollXY + camera.viewport_center)
gain = clamp(1 - distance / MAX_AUDIBLE_DISTANCE, 0, 1) ** falloff_exponent
sourceGainNode.gain.value = gain * userVolumeForCategory
```

`MAX_AUDIBLE_DISTANCE` ~= 12 tiles (configurable). `falloff_exponent` ~= 1.5.

No HRTF / 3D panning for v1. 2D top-down doesn't reward HRTF noticeably; stereo pan can be a v2 polish (left-right based on source X relative to camera center).

---

## 9. User controls

New file `store/audioSlice.ts` mirroring the shape of `store/uiSlice.ts`:

```typescript
type AudioState = {
  masterVolume: number   // 0..1, default 0.7
  musicVolume: number    // 0..1, default 0.5
  ambientVolume: number  // 0..1, default 0.6
  sfxVolume: number      // 0..1, default 0.8
  muted: boolean         // default true on first load (browser policy)
  enabledByUser: boolean // becomes true after first user gesture
}
```

Persisted to `localStorage` via the same pattern other slices use.

UI controls live in:
- `components/simulation/SettingsMenu.tsx` — 4 sliders + mute toggle
- `components/simulation/PlayerControls.tsx` — speaker icon button bound to mute, keyboard shortcut `M`

The first-time **"Tap to enable sound"** affordance is a one-time dismissible overlay (renders when `enabledByUser === false`); clicking it calls `audioContext.resume()` and sets `enabledByUser = true`.

---

## 10. MVP scope

What ships in v1 (sized at ~4–6 h coding with AI-pair + ~1.5 h asset curation — see §14 for the breakdown of *what* gets delivered):

1. **WebAudio graph + AudioManager singleton.** Instantiated in `MainScene.create()`. Owns context, master gain, sub-buses (music, ambient, sfx), category-level gain controlled by Redux.
2. **Asset preloading.** ~12 ambient OGGs + ~10 per-object OGGs + 3 music tracks + footstep + chatter + snore. Preload in `MainScene.preload()` (line 326).
3. **Per-arena ambient layer.** Logic in `MainScene.update()`; cross-fade on arena change.
4. **Per-object SFX** for the 10 highest-impact objects (bed, sink, shower, fridge, cooking, common room table, guitar, espresso machine, computer typing, register). Triggered on `description` state transitions inside `__executeMovementsForStep`.
5. **Footsteps** via `sprite.on('animationupdate')` hook.
6. **Conversation chatter** triggered by `chatting_with` state.
7. **Sleeping snore** layered onto bedroom ambient when sleep predicate matches.
8. **Playback soundtrack** — the single seamless `intrigue` loop wired and looping under playback (§7.1). The `drama` / `wholesome` loops are generated as assets but stay dormant; mood switching is post-v1 (§7.2).
9. **Proximity gain scaling** in the update loop.
10. **`audioSlice` + sliders + mute toggle + gesture overlay** wired through Redux.

**Explicitly out of v1** (see §13 for the v2 roadmap):
- The remaining 35 object SFX
- Action-transition stingers
- Time-of-day ambient variation
- Mood-driven adaptive music inside a day
- Episode drop sting
- Footstep surface differentiation
- SFX in the trailer composition pipeline (BE work)
- Voice acting / TTS per persona

---

## 11. Technical caveats

### 11.1 Browser autoplay policy

Chrome/Safari/Firefox block audio playback until user gesture. `audioContext.state` stays `"suspended"` until the gesture overlay is clicked. **Default page state must be muted.** Standard pattern.

### 11.2 iOS Safari quirks

- `AudioContext` must be created or `.resume()`d **inside** the synchronous handler of a user gesture — `setTimeout`-deferred calls are rejected.
- Background tabs aggressively suspend audio; handle `document.visibilitychange` and re-resume on foreground.
- `AudioBufferSourceNode` can't be re-started — cache `AudioBuffer`s and create a fresh source node per play.

### 11.3 Mobile voice cap

Soft-cap simultaneous voices to ~8 (iOS limit is ~12 on cellular). Priority queue:
1. Music (always plays)
2. Active arena ambient (always plays)
3. Chatter for nearest pair (one slot)
4. Footsteps + per-object SFX dropped by camera distance if cap exceeded

### 11.4 Headless mode

`MainScene.ts:332` disables asset preload in headless. The audio manager must check headless mode and no-op all triggers in that environment — confirmed safe because Playwright recording mode (`?recording=true`) is NOT headless and DOES want audio (it's how the trailer pipeline could pick up diegetic ambient in v2).

### 11.5 Bundle size

12 ambient × ~200 KB (OGG 96 kbps mono) + 10 object SFX × ~30 KB + 3 music × ~600 KB ≈ **~4.8 MB**, lazy-loaded on user gesture. Negligible.

### 11.6 SSR safety

Memory entry [[project_phaser_ssr_safety]] applies: WebAudio APIs reference `window`. The audio manager must be instantiated inside the same dynamic-import effect that loads `MainScene` — never imported statically in a React component.

---

## 12. Free audio sources

All CC0 / CC-BY (attribute if required):

- **freesound.org** — ambient room tones, footsteps, chatter
- **soundbible.com** — public-domain individual SFX
- **opengameart.org** — game-dev audio packs, often CC0
- **YouTube Audio Library** — additional ambient / music under reuse license

For **Simlish-style murmur loops**, record ~30 s of pitch-shifted gibberish ourselves — what The Sims literally did. No licensing exposure, full control.

---

## 13. Post-MVP roadmap

Ordered by value-per-hour:

| Item | What it adds | Estimate |
|---|---|---|
| Remaining 35 object SFX (full coverage of `game_object_blocks.csv`) | Every interaction in the world sounds | ~6 h (per-object recording / sourcing + integration) |
| Action-transition stingers | Helps scrubbing readability | ~2 h |
| Episode drop sting (branded `Ta-DUM`) | Brand reinforcement, ritual cue | ~2 h (asset + wire-in) |
| Time-of-day ambient variation (morning birds → night crickets) | Subtle day-feel realism | ~4 h |
| Mood-driven music *within* a day (not just per-day) | Music tracks dramatic beats live | ~6 h |
| Footstep surface differentiation (wood / tile / grass) | Realism polish | ~3 h |
| SFX layer added to trailer composition (Step 5 in `sot_video.md`) | Trailers feel like documentary | ~4 h BE on FFmpeg compose |
| Stereo pan based on source X relative to camera | Spatial polish for 2D | ~2 h |
| Spatial 3D audio with HRTF | Marginal in top-down | ~6 h |
| Voice acting / TTS per persona | Massive realism, massive cost | weeks |

---

## 14. Implementation breakdown

Two-track estimate. The "coding" column assumes a senior dev working with Claude Code as an AI pair (the actual delivery context). The "asset / human" column is orthogonal work that doesn't accelerate with AI (audio curation, recording, cross-device testing).

| Block | Coding (AI-pair) | Asset / human-only |
|---|---|---|
| WebAudio plumbing: `AudioManager` singleton, context, gain graph, gesture overlay, mute / volume persistence | ~30 min | — |
| Arena-to-loop mapping + cross-fade in `MainScene.update()` driven by `CollisionChunkManager.getArena()` | ~20 min | — |
| Per-object SFX trigger in `__executeMovementsForStep` driven by `description` state transitions | ~20 min | — |
| Footstep `animationupdate` hook on sprite creation | ~10 min | — |
| Conversation chatter via `chatting_with` + `InteractionManager.onObservation` | ~30 min | — |
| Sleeping snore layer + sleep predicate detection | ~10 min | — |
| Mood music selection + cross-fade (default `wholesome`; BE-driven if available) | ~15 min | — |
| Proximity gain scaling in `update()` | ~10 min | — |
| `audioSlice` + Redux wiring + sliders + mute toggle + gesture overlay UI | ~20 min | — |
| Asset sourcing (12 ambient + 10 object SFX + chatter + footstep + snore) from freesound.org / soundbible.com / opengameart, level-matching, encoding to OGG | — | ~1 h |
| Recording our own Simlish murmur loops | — | ~30 min |
| Cross-browser smoke testing (Chrome / Safari desktop, iOS Safari, Android Chrome) | — | ~30 min |
| **Subtotal** | **~3 h coding** | **~2 h human-only** |
| **Realistic total range with buffer for the unforeseen** | colspan | **~4–6 h coding + ~1.5 h asset work** |

The ranges build in slack for: surprise encoding quirks per audio file, an unfamiliar Phaser sprite event corner, or one cross-browser bug requiring real-device debugging. Strip the buffer and the floor is ~5 h end-to-end; with one nasty surprise it lands closer to 7.5 h. The doc carries the range, not a point estimate, on purpose.

---

## 15. BE asks (small, non-blocking)

The FE can ship v1 reading existing payloads, but two thin BE touches improve quality:

1. **Expose `mood` for the current day** (`intrigue | drama | wholesome`) on a day-metadata endpoint or as a field on the step payload. Today the showrunner already classifies this — just isn't surfaced to FE. With it, live playback music matches the Episode's music.
2. **Expose a clean `arena` field on each persona in the step payload.** Today we parse it out of `description` strings or look it up via `CollisionChunkManager.getArena()` against tile coords. Both work, but a server-set `arena` field is more robust against tilemap edge cases (between-tile gaps, doorway tiles, etc.).

Neither blocks v1.

---

## 16. Acceptance criteria

v1 ships when:

- Opening the sim page shows a clear "Tap to enable sound" affordance; tap starts audio at saved volume.
- Each of the 10+ arena types plays a distinct, seamless ambient loop on entry; cross-fades on arena change.
- The 10 MVP per-object SFX fire correctly on persona action transitions (verified for bed, sink, shower, fridge, cooking, common room table, guitar, espresso machine, computer typing, register).
- Walking sprites produce footstep ticks; cadence syncs visibly with walk frames.
- Conversations between sprites within camera range trigger chatter that fades with distance.
- Sleeping in a bedroom layers snore on top of the room's quiet ambient.
- Music background plays continuously, cross-fading on mood change (if exposed by BE).
- Master / music / ambient / sfx volumes are independent and persist across reloads.
- No audio in backgrounded tabs; resumes on foreground.
- Total audio bundle < 6 MB; loads lazily on first user gesture.
- Headless mode plays no audio (Playwright trailer recorder unaffected).
- Tested clean on Chrome desktop, Safari desktop, iOS Safari, Android Chrome.

---

## 17. Open questions for Ivan

1. **MVP approval** at the stated scope (~4–6 h coding with AI-pair + ~1.5 h asset curation) and asset strategy (CC0 / CC-BY + self-recorded Simlish).
2. **Licensing posture for shipped product** — CC0/CC-BY acceptable, or commission custom audio for brand consistency?
3. **BE asks in §15** — can `mood` and `arena` be added to the step / day payloads, or should FE infer both?
4. **Episode drop sting** — interested in commissioning a short branded motif now, or use a placeholder until later?
5. **Trailer pipeline integration timing** — do we want the SFX layer in the trailer compose step (Step 5 of `sot_video.md`) added in MVP or deferred to a follow-up?
