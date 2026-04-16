# PRD: Video Trailer Pipeline

> **Status:** Day-in-life pipeline — shipped (MVP). Sim-wide trailer types — planned.
> **Author:** Ivan
> **Originated:** 2026-04-03
> **Last Updated:** 2026-04-15
> **SOT:** `D:\Coding\double-docs\sot\sot_video.md`
> **Source playbook:** `1.MVP_video_playbook.md`

---

## 0. How to Read This Doc

The day-in-life 60s pipeline is built and running. Sections 1-2 are a compact reference for what shipped. Section 3 lists what's still open on the day-in-life pipeline, ordered by urgency. Section 4 introduces three new **sim-wide** trailer types (Announce, Opening, Sim-day-overview) with implementation plans. Section 5 covers shared assets/infrastructure those new types unlock. Section 6 covers risks and acceptance criteria.

---

## 1. Shipped (Day-in-Life 60s Trailer)

**What exists today:** a 5-stage fully-automated pipeline producing a 60s Truman-Show-styled MP4 from a completed simulation day. One CLI command, ~5 minutes end-to-end, idempotent per-artifact.

```bash
python -m video.generate_trailer <sim_code> <persona_name> [--output-dir ./trailer] [--force]
```

| Stage | Module | What it does | Status |
|---|---|---|---|
| 1. Data extraction | `video/extract_day_log.py` | Supabase queries → `day_log.json`. Sim-scoped memory retrieval via `dbl_retrieve_with_rir` (10-param overload, HNSW focal-point search). Verbatim chat transcripts from `movement.chat` with importance-threshold selection (turns ≥ 3 + protagonist speaks; hard-cap 25, floor-backfill 5). Optional `--day N` scope for multi-day sims. Sim-mode auto-detection (`standard` vs `survival`) via `scratch.survival`; Survival sims additionally emit `survival_context` (alive/eliminated/immune rosters, phase, challenge). | **Done** |
| 2. Showrunner LLM | `video/showrunner.py` | Single Tier C (`gpt-5.2`) call → `script.json`. Each retry carries a unique `routing_step_id` so `TIER_C_MAX_CALLS_PER_STEP=1` cannot demote retries to Tier B. Mode-aware prompt — base for standard sims; Survival appends a HOOK→COALITION→VOTE→STINGER beat sheet with required vote scene and named stakes. "Attenborough-meets-TikTok" voice: concrete > poetic, ≤1 metaphor per scene, ~2.7 words/sec, 140-170 word target. Enforces 2-4 scenes, consecutive `key_steps` (2-5 items), 100-200 word narration, [PAUSE] marker, ≤2 dialogue excerpts *total*, ≤3 subtitle cards. 3-attempt retry with offending-scene feedback echoed back verbatim. | **Done** |
| 3. TTS narration | `video/tts.py` | ElevenLabs (voice `cIO62fcmCSQhE0DE2WS2`, stability 0.65 / clarity 0.75 / style 0.40) → OpenAI `tts-1-hd`/`onyx` fallback. Honors `[PAUSE Ns]` as FFmpeg-generated silence. | **Done** |
| 4. Video capture | `video/record_scenes.py` | Playwright records one WebM per scene. Navigates to `?recording=true`, drives playback via `window.__executeMovementsForStep` + 5 `window.__*` camera functions. | **Done** |
| 5. Compositing | `video/compose_trailer.py` | FFmpeg: concat WebM clips → MP4, mix narration + music (music ducked 6-9 dB under VO), SRT subtitles, dynamic end card (drawtext), 1920×1080 master + 1080×1920 crop, `-t 60` hard cap. | **Done** |

**Frontend:** `?recording=true` mode active in `double-front` as of 2026-04-13. Exposes 5 camera functions + `__executeMovementsForStep` on `window`, renders tilemap + sprites, suppresses Supabase realtime coord stream, hides UI chrome. Headless validator (`?headless=true`) path untouched.

**Orchestrator:** `video/generate_trailer.py` runs all 5 stages sequentially. Skips any stage whose output artifact exists; `--force` regenerates everything.

**Mood music library:** three 75s instrumental tracks in `video/audio/` — `music_intrigue.mp3`, `music_drama.mp3`, `music_wholesome.mp3`. Normalized −16 LUFS, MP3 192kbps, 1.5s fade-out.

**Output:**
```
trailer_{sim_code}_{persona}/
├── day_log.json       (stage 1, reused)
├── script.json        (stage 2, reused)
├── audio/             narration.mp3 + music_{mood}.mp3
├── raw/               scene_N_*.webm
└── output/            trailer_16x9.mp4 + trailer_9x16.mp4
```

---

## 2. Reference — Beats, Moods, Transitions, Acceptance

### 2.1 Beat sheet (60s)

| Beat | Time | Duration | Purpose | Camera | Music |
|---|---|---|---|---|---|
| Hook | 0:00-0:08 | 5-8s | Most surprising moment, no context | Tight zoom 1.5-2.0× | Atmospheric, sparse |
| Setup | 0:08-0:20 | 10-12s | Morning routine, normalcy | Bird's-eye 0.5-0.7× → zoom in | Rhythm enters |
| Development | 0:20-0:38 | 15-18s | Main thread, key interaction | Medium 1.0-1.2×, follow | Builds, melodic |
| Turn | 0:38-0:50 | 10-12s | Something shifts | Pause / slow push-in, 2-3s silence | Stop-down → swell |
| Close | 0:50-0:58 | 8-10s | Unresolved aftermath | Slow zoom to bird's-eye | Single note |
| End card | 0:58-1:00 | 2s | Title | Static | Fade |

### 2.2 Mood modes

| Mode | Trigger | Narrator tone | Music | Transitions |
|---|---|---|---|---|
| Intrigue | Mystery, hidden motives | Curious, conspiratorial | Sparse piano, electronic pulse | Focus shift, card break, fly-over |
| Drama | Conflict, emotional stakes | Urgent, empathetic | Building strings, percussion | Hard cut, silence drop, fade |
| Wholesome | Friendship, small victories | Warmest, genuine | Acoustic guitar, warm piano | Fly-over, time-lapse, gentle fades |

### 2.3 Transition library

Scene cut • Fly-over (max 1×/trailer) • Time-lapse (10-25×) • Focus shift • Card break • Fade to black.

### 2.4 Acceptance (day-in-life)

Story: protagonist named in first line · dramatic irony present · unresolved close · one "devastating observation" line.
Technical: 58-62s duration · 140-170 word narration (100-200 hard bounds) · ≥1 silence beat · ≤2 dialogue excerpts *total* · ≤3 subtitle cards · music ducked clearly · end card readable.
Social: 9:16 crop with key elements visible · subtitles readable at mobile size · first 3s thumb-stop.

### 2.5 Camera scripting API (frontend, `window.__*`)

`__setCameraZoom(level, durationMs?)` · `__panCameraTo(tileX, tileY, durationMs?)` · `__followPersona(name)` · `__unfollowPersona()` · `__setPlaybackSpeed(multiplier)` · `__executeMovementsForStep(data)` (pre-existing).

---

## 3. TODO — Day-in-Life Pipeline (Ordered by Urgency)

### P1 — Quality gates and hardening

**TODO-2c. Validate Survival-mode trailer end-to-end.** Mode-aware code shipped 2026-04-15 but only exercised on a non-Survival sim (20260413-1 is a family fork). Pick a recent true Survival sim (e.g. from `past-sims-reports/20260410-survival-800/`) and run the pipeline against it. Check: opening line names stakes, at least one scene at late-evening steps covering the vote, end-card names elimination, narration uses competition vocabulary not metaphor.

**TODO-2b. Verify chat memory persistence end-to-end.** Sim `20260413-1` has 0 rows of `memory_type='chat'` in `dbl_memory` despite 174 steps with `movement.chat` data — the real-time `add_chat` → `hybrid_memory_store` path is silently failing for at least one sim config. Write a 20-line diagnostic that, after a sim run, counts `dbl_memory` chat rows vs `movement.chat` occurrences and flags any gap. Not blocking for trailers (extractor reads `movement.chat` directly), but the cognitive loop's RIR retrieval of past-day conversations depends on this working for multi-day memory.

**TODO-4. Subtitle timing from actual narration audio.** SRT generation currently uses rough `time_range_sec` offsets from the script. Parse the produced `narration.mp3` waveform (or ElevenLabs per-word timestamps) and emit SRT from those, not script intent.

**TODO-5. Quality-gate automation.** Ship a `validate_trailer.py` that runs the §2.4 acceptance list on any produced MP4: duration bounds, narration word count (via Whisper or ElevenLabs), end-card presence, 9:16 crop check. Pass/fail gate in `generate_trailer.py`.

**TODO-6. 9:16 crop readability validation.** The crop exists but mobile-size readability hasn't been confirmed. Add a visual diff step or a manual checklist pass — verify protagonist stays in frame, subtitles legible at iPhone render size.

### P2 — Polish

**TODO-7. SFX library (12 clips).** Transition/emphasis clips per playbook §8. Currently no SFX in output. Phase-2 nice-to-have, not blocking.

**TODO-8. End-card fontconfig on Windows.** Font fallback warning on `drawtext`; card renders but font choice varies. Low priority.

**TODO-9. Batch scene rendering / camera-script API.** Single `window.__executeCameraScript(json)` call replaces per-directive calls. Low complexity, reduces Playwright orchestration code. Phase 3.

**TODO-10. In-browser `MediaRecorder` path.** Alternative capture path with higher quality and native FPS control. Medium complexity. Phase 3, only if Playwright video quality proves insufficient.

**TODO-11. Phaser-level transition rendering.** Fade/fly-over/card-break as Phaser shader overlays instead of FFmpeg post. Eliminates a compositing step. Phase 3.

### P3 — Longer horizon (day-in-life specific)

**TODO-12. Interactive timestamped descriptions.** Emit `trailer_description.md` with clickable `/simulations/{sim_code}?step={N}&focus={x,y}&zoom={level}` links for each key moment. Requires FE query-param parsing (auto-jump, pan, zoom) and optional sprite highlighting. Builds on camera API.


### Completed 2026-04-15

- **TODO-1. `record_scenes.py` → `?recording=true` mode** (commit `45c9f865`). SwiftShader arg, CSS UI-hiding injection, 30s head-trim, and Director-API guards removed.
- **TODO-2. Gosha Pistsov re-run.** End-to-end validation of `?recording=true` path + day-aware chat extractor on fresh trailer.
- **TODO-2a. Day-aware chat extraction from `movement.chat`.** Verbatim both-speaker transcripts on position rows, dedup by participant-set + opening utterance, 6 turns × 25 words trim, optional `--day N` scope piped through orchestrator.
- **Chat selection: importance-threshold.** Replaced fixed top-10 cut with substantive-first selection (turns ≥ 3 AND protagonist speaks), hard-cap 25 for context budget, floor-backfill 5 for sparse sims.
- **Showrunner retry stabilization.** HARD CONSTRAINTS block with ✓/✗ examples; unique `routing_step_id` per retry (defeats `TIER_C_MAX_CALLS_PER_STEP=1` silent tier demotion); offending-scene echo-back in retry feedback.
- **Mode-aware showrunner (Survival).** `extract_day_log` auto-detects `scratch.survival` → emits `sim_mode` + `survival_context` (alive/eliminated/immune, phase, challenge). Showrunner appends `SURVIVAL_ADDENDUM` beat sheet (HOOK→COALITION→VOTE→STINGER) with required vote scene, stakes-naming opener, competition vocabulary.
- **TikTok-paced voice rebalance.** "Attenborough meets TikTok" — concrete > poetic, ≤1 metaphor per scene, ~2.7 words/sec, 140-170 word target (was 120-150).
- **TODO-3. Schema dump regenerated.** Fresh dump at `supabase/db_schema_20260415.sql` captures the RIR sim-scope migration.

---

## 4. NEW — Sim-Wide Trailer Types

Three new trailer types, none single-protagonist. Each reuses the 5-stage pipeline but replaces stage 1 (data) and stage 2 (showrunner prompt), and may add new capture modes in stage 4.

**Guiding principle (all three):** modern fast-paced format. ≤3s average shot length, hook in first 3 seconds, silence beat every 15-20s, subtitles on every sentence, clear end-card CTA. Bake these as shared defaults in the showrunner prompts.

**Build order (recommended):**
1. **Sim-day-overview (§4.3)** first — highest frequency (one per sim day), closest to existing pipeline, validates multi-protagonist extension.
2. **Opening (§4.2)** second — reuses the multi-protagonist + ranking work from (1), adds Day-0 data mode and name-card template.
3. **Announce (§4.1)** last — most different (no sim footage), needs world-flyover capture mode and one new music track.

### 4.1 Announce Trailer — pre-sim hype teaser

**Purpose:** Introduce Survival as a concept, the setting, the rules, and the cast. Build excitement before Episode 1 drops. No sim has run yet.

**Format:** 45-60s, vertical-first (9:16 master). Fast, kinetic, reveal-style.

**Structure:**
| Beat | Time | Content |
|---|---|---|
| Hook | 0:00-0:10 | World pan over The Ville; narrator opens with a loaded question |
| Rules card | 0:10-0:15 | Survival format: goal, elimination mechanic (one kinetic title card) |
| Cast montage | 0:15-0:45 | Sprite cameos at their assigned homes, 2-3s each, name overlays |
| Drop card | 0:45-0:60 | Episode 1 drop date + CTA |

**Pipeline changes:**

*Stage 1 (new — `video/extract_announce_context.py`):*
- Reads persona soul `.md` files (`souls/*.md`) for bios and personalities.
- Reads location tree (`env_matrix` assets) for world overview.
- Loads Survival rules from a one-time-written config (`video/survival_brief.json`).
- Output: `announce_context.json` — no memory stream, no timeline.

*Stage 2 (new prompt — extend `showrunner.py` with `--mode=announce`):*
- Tier C call, prompt enforces: 60s max, 3 beats (hook / rules / cast), kinetic pacing, no protagonist (ensemble intro), CTA in end card.
- Output schema: same shape as day-in-life script.json, but scene labels become `hook | rules | cast_montage | drop`.

*Stage 4 (new capture mode — extend `record_scenes.py` with `--mode=announce`):*
- **World flyover:** scripted pan across The Ville hitting 4-5 key landmarks at 0.5-0.7× zoom.
- **Cast cameos:** for each featured persona, zoom to their home, render sprite at idle (2-3s), overlay name card. Batch via camera API.
- No `__executeMovementsForStep` calls — sprites remain idle at Day-0 spawn positions.

*Stage 5 (minor):*
- Add `music_reveal.mp3` to mood library (see §5).
- Kinetic title cards via FFmpeg `drawtext` (reuse end-card logic, extend for mid-trailer cards).

**New assets needed:** §5.1, §5.2, §5.3 (cast portraits), §5.4 (kinetic title templates), `music_reveal.mp3`.

### 4.2 Opening Trailer — Day-0 season premiere

**Purpose:** Introduce the cast individually, what makes each of them matter for Survival and what makes Survival matter for them, set the stakes, preview what viewers can expect. Sim has just started — only Day-0 state exists.

**Format:** 2:30-3:00, 16:9 master + 9:16 crop. Character-led, gives faces room to breathe.

**Structure:**
| Beat | Time | Content |
|---|---|---|
| Cold open | 0:00-0:20 | Hook on Survival — "they don't know what's coming" |
| Cast intros | 0:20-1:50 | 6 featured personas × 15s each: zoom to home, follow 3-5 steps, name card + one-line bio |
| Relationship reveal | 1:50-2:15 | Affinity graph visualization OR a "who knows whom" montage |
| Stakes montage | 2:15-2:45 | Fast cuts: alliances forming, conflicts brewing, rules ticking down |
| End card | 2:45-3:00 | "Day 1 starts tomorrow" + CTA |

**Cast selection:** Not all 15. Feature **6** (configurable) ranked by "storyline potential" score: strongest affinity extremes (highest + lowest relationships in `persona_scratch.relationship_affinities`), most distinct personality traits vs. the group mean, explicit role markers in soul file.

**Pipeline changes:**

*Stage 1 (extend `extract_day_log.py` with `--mode=season_opener`):*
- Pulls Day-0 scratch only (daily plan, relationship affinities, home assignment, schedule) for every persona.
- Reads soul `.md` files for personality summaries.
- Runs cast-scoring to pick top-6 featured personas.
- Output: `opener_context.json` with `featured_cast[]` (6 persona blocks) + full cast reference + survival rules.

*Stage 2 (extend `showrunner.py` with `--mode=opener`):*
- **Two-pass LLM:** first pass generates one 10-15s intro beat per featured persona (6 Tier C calls, parallelizable); second pass is a wrapper that writes the cold open, stakes montage, and end card, threading the 6 beats together.
- Validates: 2:30-3:00 total runtime, 6 cast scenes, cold open + stakes + end card present.

*Stage 4 (extend `record_scenes.py` with `--mode=opener`):*
- Per-persona intro clip: pan to home → `__followPersona(name)` → replay Day-0 steps 0-5 → name-card overlay.
- Ensemble relationship-reveal shot (optional): bird's-eye pan with affinity lines drawn via overlay (see §5.5).

*Stage 5:*
- Extended runtime (180s) — raise `-t` cap.
- Optional new track `music_anthem.mp3` with lift/build arc.
- Name-card template reusable across all 6 intros (see §5.4).

**New assets needed:** §5.3 (cast portraits — overlap with Announce), §5.4 (name-card template), §5.5 (affinity-graph overlay, optional), `music_anthem.mp3` (optional).

### 4.3 Sim-Day-Overview Trailer — ensemble daily recap

**Purpose:** Recap the day's most intriguing events from the perspective of 1-3 characters who drove (or were driven by) the day. Tell a story. End with a cliffhanger.

**Format:** 2:30-3:00, 16:9 master + 9:16 crop. 3 minutes is the sweet spot — long enough to tell a real arc, short enough to stay fast-paced. (Avoid 5-min; TikTok/Reels engagement drops past 3.)

**Structure:**
| Beat | Time | Content |
|---|---|---|
| Previously on… | 0:00-0:15 | Bridge card + 10s recap of prior day (skip on Day 1) |
| Spine narration | 0:15-0:25 | Narrator declares today's narrative arc |
| Protagonist arcs | 0:25-2:25 | 4-5 scenes × ~25s, interleaved across 1-3 protagonists |
| Council / vote beat | 2:25-2:45 | If any council / vote / elimination fired today, dedicated visual treatment |
| Cliffhanger + end card | 2:45-3:00 | Unresolved tension → "Tomorrow…" |

**Protagonist selection:** Extend the existing ranking logic. Score every persona by: poignancy sum of today's memories, conversation count, unique locations visited, participation in council/vote/high-novelty events. Pick **top 1-3** (1 for a quiet day, 3 for a busy one).

**Pipeline changes:**

*Stage 1 (extend `extract_day_log.py` with `--mode=day_overview`):*
- Run the existing protagonist extraction for each of the top 1-3 personas (RIR focal-point retrieval, typed chat fetch).
- Compute the shared timeline with all selected protagonists' paths marked.
- Detect trigger events: council fired? vote cast? Major alliance/conflict shift? Tag these in `day_overview_context.json`.
- Output: single context doc with `protagonists[]` (1-3 blocks) + shared `timeline` + `trigger_events[]`.

*Stage 2 (extend `showrunner.py` with `--mode=day_overview`):*
- **Two-stage LLM:**
  1. **Spine call:** "Given these 1-3 protagonists and today's events, what is the day's narrative arc?" → returns a spine sentence, mood, and which protagonist drives each scene.
  2. **Scene generation:** per-scene Tier C calls slotted into the spine. Each scene still obeys the consecutive `key_steps` constraint (existing validator carries over).
- Validates: ≤3 protagonists, ≥1 scene per protagonist, scenes fit within the total runtime budget, spine sentence present.

*Stage 4 (minor extension to `record_scenes.py`):*
- Sequential scenes per protagonist — no new capture mode needed. Camera API handles `__followPersona(name)` switches.
- **Defer** picture-in-picture / split-screen for simultaneous POV — add later if needed.

*Stage 5:*
- Raise `-t` cap to 180s.
- "Previously on…" bridge-card template (reuse end-card infra).
- **Council / vote visual treatment:** FFmpeg color-grade filter (e.g. red tint + pulse) applied to scenes tagged with council/vote trigger events. Leans into Survival tone; gives those beats signature weight. The *"the tribe has spoken"* hook in `!next.md` fits here.

**New assets needed:** §5.6 (previously-on template), §5.7 (council/vote color grade), §5.8 (ranking scorer).

---

## 5. Shared Infrastructure & Assets (Unlocks §4)

Numbered for cross-reference from §4. Most of these are small and reusable.

### 5.1 Survival format brief (one-time written copy)
`video/survival_brief.json` — rules, goal, elimination mechanic, tagline. Used by Announce (§4.1) and Opening (§4.2). Written once per season format. ~1h.

### 5.2 `music_reveal.mp3` (new mood track)
75s, big drums + kinetic pulse, reveal/hype arc. Generated on Suno/Udio, normalized −16 LUFS MP3 192kbps (same pipeline as existing three tracks). Used by Announce. ~1h.

### 5.3 Hi-res cast portrait frames
Scripted renderer: load each persona's sprite atlas, upscale 4×, render against neutral background, export PNG. Used for cast cameos (Announce) and name cards (Opening). ~2h of scripting against existing atlas files. No new art.

### 5.4 Name-card overlay template
FFmpeg drawtext + optional PNG badge. Parametric: `{name}`, `{bio_line}`, `{color_accent}`. Reusable across all trailer types. ~2h.

### 5.5 Affinity-graph overlay (optional, Opening)
Bird's-eye pan with lines drawn between featured personas colored by affinity score. Implementation options: (a) SVG rendered to PNG and FFmpeg-overlaid, (b) Phaser-side pre-roll scene with a new `window.__renderAffinityGraph(personas)` function. Option (a) is simpler and keeps FE surface area small. ~4h. **Skip in v1 if time-constrained.**

### 5.6 "Previously on…" bridge-card template
FFmpeg drawtext + 10s recap strip. Pulls 3-4 keyframes from prior day's trailer (if exists) and stitches with crossfade. Skipped on Day 1. Used by Sim-day-overview. ~3h.

### 5.7 Council / vote visual treatment
FFmpeg filter chain: red tint (`colorchannelmixer`) + subtle pulse (`eq` with brightness keyframes) + optional vignette. Applied to scenes tagged `trigger_event: council|vote|elimination`. ~2h.

### 5.8 Persona impact-ranking scorer
`video/persona_ranker.py` — shared module used by Opening (cast selection) and Sim-day-overview (protagonist selection). Inputs: persona list + day log. Scoring: poignancy sum, conversation count, unique locations, trigger-event participation, relationship-extreme indicator. Output: ranked list with scores. ~4h.

### 5.9 Showrunner mode dispatch
Refactor `showrunner.py` to accept `--mode={day_in_life|announce|opener|day_overview}` with per-mode prompt templates and per-mode validators. Prompt templates live under `video/prompts/`. ~4h, done once, all modes benefit.

### 5.10 Multi-mode orchestrator
Extend `generate_trailer.py` to `generate_trailer.py --mode={...}`. Each mode calls the appropriate stage-1 extractor, stage-2 mode, and stage-4 capture mode. Stages 3 and 5 unchanged across all modes. ~3h.

---

## 6. Risks, Dependencies, Acceptance

### 6.1 Risks (new for sim-wide trailers)

| Risk | Impact | Mitigation |
|---|---|---|
| Opening trailer at 2:30 fatigues viewers | Low retention past 60s | Ruthless edit pacing in showrunner prompt (≤3s shots, silence beats every 15-20s); A/B against a 90s cut |
| Sim-day-overview spine call returns weak arc | Flat trailer | Retry with higher temperature + focal-point nudge; fall back to single-protagonist mode if spine quality flag trips |
| Cast ranking misses obvious protagonist | Wrong featured picks | Expose ranking as a `--featured` CLI override; log top-10 scores for auditability |
| Council / vote visual too heavy-handed | Breaks tone | Make the color grade opacity configurable; test on wholesome-mood days |
| World flyover on Announce looks empty | No sprites yet | Render sprites in their spawn positions at idle; do flyover through populated zones only |

### 6.2 Carried-over risks (day-in-life)

Showrunner JSON invalidity → schema validation + 3-attempt retry (mitigated). TTS quality variance → calibration line + stability/clarity params (mitigated). Playwright framerate → timeScale tuning (mitigated). 9:16 crop clipping → `__followPersona` centering (carried — TODO-6).

### 6.3 Technical dependencies

All shipped: Supabase RPCs (`dbl_retrieve_with_rir` 10-param, `dbl_get_sim_memories`, `get_all_step_positions`, `load_persona_scratch`), ElevenLabs + OpenAI TTS, FFmpeg, Playwright, Phaser frontend with `?recording=true` mode, camera scripting API (5 `window.__*` functions), Tier C LLM access.

**New for §4:** soul `.md` reader (exists in sim engine — reuse), survival brief config file (§5.1), `music_reveal.mp3` (§5.2), persona ranker (§5.8), showrunner mode dispatch (§5.9).

### 6.4 Acceptance (per new trailer type)

**Announce:** 45-60s · no memory stream data used · all featured personas appear once · Survival rules card present · drop-date end card · 9:16 crop viable.
**Opening:** 2:30-3:00 · 6 featured personas (configurable) · one intro beat per persona · stakes montage present · cold open lands in first 3s · CTA end card.
**Sim-day-overview:** 2:30-3:00 · 1-3 protagonists · spine sentence in narration · council/vote beat present iff triggered today · cliffhanger not resolved · "previously on…" skipped iff Day 1.

All three carry over day-in-life acceptance from §2.4 (narration pacing, silence beats, subtitle caps, music ducking, end-card readability).

---

## 7. Milestone Log

| Date | Milestone |
|---|---|
| 2026-04-10 | First day-in-life trailer produced (Ivan Pistsov / `20260407-2`). |
| 2026-04-13 | FE `?recording=true` mode live — camera API + step animation active. |
| 2026-04-14 | Plan B — consecutive-step scene segments; eliminates character teleportation. |
| 2026-04-14 | Supabase-native context builder — O(constant) context size. |
| 2026-04-14 | RIR focal-point retrieval, sim-scoped (migration `20260414_dbl_retrieve_rir_sim_scope.sql`). |
| 2026-04-15 | PRD reorganized; three sim-wide trailer types added (Announce, Opening, Sim-day-overview). |
| 2026-04-15 | Day-aware chat extraction from `movement.chat` (verbatim transcripts, importance-threshold selection replacing top-10 cut, optional `--day N` scope). |
| 2026-04-15 | Showrunner retry stabilization — HARD CONSTRAINTS prompt block, per-retry `routing_step_id` pins Tier C, offending-scene echo-back in retry feedback. |
| 2026-04-15 | Mode-aware showrunner — `scratch.survival` auto-detection, Survival beat sheet (HOOK→COALITION→VOTE→STINGER), TikTok-paced voice (140-170 words @ 2.7 w/s). |
