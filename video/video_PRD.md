# PRD: Video Trailer Pipeline — Engineering Reference

> **Audience:** experienced developers picking up shipped or open-trailer work.
> **Producer's spec (the "why" + creative direction):** `D:\Coding\double-ivan\video\video_playbook.md`
> **SOT:** `D:\Coding\double-docs\sot\sot_video.md`
> **Status:** Day-in-life — shipped (MVP, hardened 2026-05-01). Sim-day-overview (§2.2) — **shipped MVP 2026-05-01**. Sim-opening (§2.3) — **shipped MVP 2026-05-01** (pending manual asset/copy curation). Sim-announce (§2.4) — planned.
> **Author:** Ivan
> **Originated:** 2026-04-03
> **Last Updated:** 2026-05-04

---

## 0. How to Read This Doc

This PRD is the engineering reference for the video pipeline. It tracks what's been built, where it lives in code, what's still open, and the design decisions behind non-obvious choices.

**For "why this trailer exists / what it's supposed to feel like / mood / beat sheet,"** read the playbook at `D:\Coding\double-ivan\video\video_playbook.md`. This PRD only references creative spec, never duplicates it.

- **§0.1** — Open TODO list, prioritized
- **§1** — Architecture (5-stage pipeline, module map, mode dispatch, output layout)
- **§2** — Per-trailer-type engineering reference (data extraction, LLM prompt, capture path, validators per type)
- **§3** — Open TODOs (full bodies) + completed log by date
- **§4** — Shared infrastructure (RIR retrieval, persona ranker, mode dispatch, validators)
- **§5** — Design decisions / divergences (the non-obvious calls)
- **§6** — Risks, acceptance, dependencies
- **§7** — Milestone log

### 0.1 Open TODO List (current priorities)

> Done items live in §3 Completed sub-sections (by date) and the §7 Milestone Log. Architecture is in §1; per-type engineering in §2.

**P0 — §2.3 Sim-Opening trailer manual asset commissions (do these before switching to other Video PRD tasks).** v0 ships working with placeholders; commissioned drops upgrade quality with ~1h of wiring once assets land. Full prompts, drop-in paths, and acceptance criteria are in **`d:\Coding\double-ivan\20260501_opening-trailer.md`** under each §TODO heading.

- **§TODO-A. Sprite walk-out micro-videos** — Grok Imagine, 6 × 2.5s. Commission per-persona MP4s using each sketch + their top-down room screenshot. Drop into `video/assets/opening/sprite_walkout_{agent_id}.mp4`; composer prefers `.mp4` over the native Phaser `.webm` fallback automatically. ~2-4h × cast size.
- **§TODO-C. Anthem music track** — Suno, ~165s with 6 stings at 15s intervals. Currently using `music_drama.mp3` placeholder. Drop `music_anthem.mp3` into `video/audio/`; flip script's `mood` to `"anthem"` (or rename file to `music_drama.mp3` for zero-config swap). ~1-2h.
- **§TODO-E. Trading-card frame PNGs** — Figma or Midjourney, 3 archetypes (Champion / Wildcard / Observer). Placeholder FFmpeg `drawbox` borders are functional but utilitarian. Drop `card_frame_{archetype}.png` into `video/assets/opening/`; ~10 LOC change in `compose_cast_intro` to layer the PNG. ~3-6h.
- **§TODO-D. Archetype intro stings** — Suno, 4 × 1.5-2.5s WAVs. Archetype classification shipped; sting playback not yet wired. Drop `sting_{archetype}.wav` into `video/assets/opening/` plus ~20 LOC in `compose_cast_intro` to play sting at scene-out. ~1-2h.
- **§TODO-I. Cinematic atmospheric clips** — Grok Imagine, 4-6 × 3-5s MP4s for the stakes montage. Drop `cinematic_*.mp4` into `video/assets/opening/`; add filenames to script's `stakes_montage.atmospheric_clips` array — composer mixes PNG/MP4 sources transparently. ~2-3h.
- **§TODO-J. How-to-watch card templates** — Figma or FFmpeg drawtext, 2-3 cards covering "The village runs 24/7. / Watch from the very first day. / New trailer daily at 6:30 PM." (per playbook §4.6). Drop into `video/assets/opening/how_to_watch_card_*.png`. Pairs with TODO-13 (engineering wiring). ~2-3h.
- **Field-test on a real Day-0 sim** once the polished assets land. The v0 smoke test ran against `20260430-7` (4-persona Pistsov family); a real cohort of 6-8 personas hasn't been exercised yet.

**Total commissioned-asset effort:** ~10-17h of asset work + ~1h of code wiring. v0 demo trailer at `data/20260430-7/opener&001/output/trailer_16x9.mp4` is shippable for internal review without any of these.

**P1 — Accuracy / data correctness:**
- **TODO-2b.** Verify chat memory persistence end-to-end. Sim `20260413-1` had 0 rows of `memory_type='chat'` in `dbl_memory` despite 174 steps with `movement.chat` data. Independent of trailer pipeline (extractor reads `movement.chat` directly), but the cognitive loop's RIR retrieval of past-day conversations depends on this for multi-day memory. **MVP release-gate item §7 #8** — see `d:\Coding\double-ivan\20260507_mvp-release-gate.md` lines 34-35; gate guidance is "keep deferred unless the survival smoke surfaces it." See §3.

**P1 — Quality gates / polish:**
- **TODO-4.** Subtitle timing from actual narration audio. Replace script-offset SRT timing with audio-derived (Whisper or ElevenLabs per-word timestamps). See §3.
- **TODO-6.** 9:16 crop readability validation. Dimensions are auto-validated; only the mobile-render eyeball check remains. **MVP release-gate item §7 #7** — paired with the now-shipped TODO-5 under the gate's "minimal trailer quality gate (duration + 9:16 readable + end-card present)" line; TODO-5 closed 2026-04-30, TODO-6 is the remaining mobile-readability eyeball pass. See `d:\Coding\double-ivan\20260507_mvp-release-gate.md` lines 34-35 and §3.

**P2 — Polish (open):**
- **TODO-7.** SFX library (12 clips per playbook §1.5). See §3.
- **TODO-8.** End-card fontconfig on Windows (drawtext font fallback warning). See §3.
- **TODO-9.** Batch scene rendering / single `__executeCameraScript(json)` API call. See §3.
- **TODO-10.** In-browser `MediaRecorder` capture path (alternative to Playwright). See §3.
- **TODO-11.** Phaser-level transition rendering (shader overlays vs FFmpeg post). See §3.

**P3 — Longer horizon:**
- **TODO-12.** Interactive timestamped trailer descriptions with `/simulations/{sim_code}?step=&focus=&zoom=` deep-links. See §3.

**Sim-wide trailers — last remaining type:**
- **§2.4 Sim-Announce trailer.** Pre-sim hype, 45-60s, kinetic. Most different from existing pipeline (no sim footage; world flyover + cast cameos at idle Day-0 spawn positions). Reuses §4.8 persona ranker + §4.9 mode dispatch already shipped with §2.2/§2.3. New assets: §4.1 survival brief, §4.2 `music_reveal.mp3`, §4.3 cast portraits (overlap with §2.3), §4.4 kinetic title-card templates.

---

## 1. Architecture Overview

A 5-stage pipeline, mode-aware. One CLI command per trailer; ~5 minutes end-to-end for day-in-life, ~5-10 min for sim-day-overview and sim-opening (longer due to multi-stage LLM + more capture). Idempotent per-artifact — re-running skips any stage whose output already exists; `--force` regenerates everything.

### 1.1 The 5 stages

| Stage | Module | What it does (mode-aware) |
|---|---|---|
| 1. Data extraction | `video/extract_day_log.py` | Supabase queries → context JSON. Mode-dispatched: `extract_day_log` (day-in-life), `extract_day_overview` (sim-day-overview), `extract_opener_context` (sim-opening). |
| 2. Showrunner LLM | `video/showrunner.py` | LLM call(s) → `script.json`. Mode-dispatched: single Tier C call (day-in-life), two-stage spine + per-scene (sim-day-overview), two-pass per-persona + wrapper (sim-opening). |
| 3. TTS narration | `video/tts.py` | ElevenLabs (voice `cIO62fcmCSQhE0DE2WS2`, stability 0.65 / clarity 0.75 / style 0.40) → OpenAI `tts-1-hd`/`onyx` fallback. Honors `[PAUSE Ns]` markers as FFmpeg-generated silence. |
| 4. Video capture | `video/record_scenes.py` + `video/capture_static_assets.py` | Playwright records WebM per scene from `?recording=true` mode. Sim-opening additionally captures static establish_*.png + sprite_walkout_*.webm assets. Camera API: 5 `window.__*` functions + `__executeMovementsForStep`. |
| 5. Compositing | `video/compose_trailer.py` | FFmpeg: concat scene clips → MP4, mix narration + music (ducked 6-9 dB under VO), SRT subtitles, end card, 16:9 master + 9:16 crop. Mode-aware duration cap. |
| (6.) YouTube description | `video/generate_description.py` | Optional Stage 6: emits per-scene timecode deep-links with `?t=&double=&zoom=&focus=&speed=` params + watch-live CTA (`www.doubland.ai`). Shipped variant still emits a waitlist CTA; v2 alignment with TODO-13 swaps to watch-live framing. |
| (7.) Validator | `video/validate_trailer.py` | Optional Stage 7: mode-aware duration + word-count + dimension checks. Best-effort — failures don't block artifact delivery. |

### 1.2 Mode dispatch

`video/generate_trailer.py` is the orchestrator. Modes:

```bash
# Day-in-life (single protagonist, 60s)
python -m video.generate_trailer <sim_code> <persona_name> [--day N] [--output-dir ./trailer] [--force]

# Sim-day-overview (1-3 protagonists, 2:30-3:00)
python -m video.generate_trailer <sim_code> --mode day_overview --day N [--top {1,2,3}]

# Sim-opening (Day-0 ensemble, 2:30-3:00)
python -m video.generate_trailer <sim_code> --mode opener --cohort-name <name> --season-title <title> [--top 6]

# Sim-announce (planned — not yet implemented)
python -m video.generate_trailer <sim_code> --mode announce --cohort-name <name>
```

`persona_name` is required for day-in-life, ignored for the others. `--day N` is required for sim-day-overview, ignored for sim-opening. `--top` controls cast/protagonist size where applicable (1-3 for day_overview, 1-6 for opener).

### 1.3 Output layout

```
trailer_{sim_code}_{persona_or_mode}/
├── day_log.json | day_overview_context.json | opener_context.json   (stage 1)
├── script.json                                                       (stage 2)
├── audio/        narration.mp3 + music_{mood}.mp3
├── raw/          scene_N_*.webm
├── output/       trailer_16x9.mp4 + trailer_9x16.mp4 + validation_report.json
└── description.md                                                    (stage 6, optional)
```

### 1.4 Frontend dependencies

- **`?recording=true` mode** in `double-front` (live as of 2026-04-13). Exposes 5 camera functions + `__executeMovementsForStep` on `window`, renders tilemap + sprites, suppresses Supabase realtime coord stream, hides UI chrome. Headless validator (`?headless=true`) path untouched.
- **Camera scripting API:** `__setCameraZoom(level, durationMs?)` · `__panCameraTo(tileX, tileY, durationMs?)` · `__followPersona(name)` · `__unfollowPersona()` · `__setPlaybackSpeed(multiplier)` · `__executeMovementsForStep(data)` (pre-existing).
- **Capture gate:** `__headlessReady && __cameraSettled` must both fire before capture starts; `_assert_first_frame_not_white` defensive guard catches any missed gate.

### 1.5 Mood music library

Three 75s instrumental tracks ship in `video/audio/`: `music_intrigue.mp3`, `music_drama.mp3`, `music_wholesome.mp3`. Normalized −16 LUFS, MP3 192 kbps, 1.5s fade-out tail. A fourth `music_anthem.mp3` for sim-opening is on the open-asset commission list (§0.1 P0 §TODO-C). See playbook Appendix A for Suno/Udio generation prompts.

---

## 2. Per-Trailer-Type Engineering Reference

Each subsection below is a self-contained engineering brief: what stage 1 extracts, how stage 2 prompts the LLM, what stage 4 captures, what the validator enforces. **Creative spec (purpose, beat sheet, mood, narration rules) lives in the playbook** at `D:\Coding\double-ivan\video\video_playbook.md` §2-§5.

### 2.1 Day-in-Life Trailer

> **60s · 1 protagonist · 1 sim-day · single Tier C LLM call · ~5 min E2E**
> **Playbook reference:** §2 (purpose, beat sheet, narrator rules, acceptance)

**Stage 1 — `video/extract_day_log.py:extract_day_log()`**

- Queries Supabase for full day log: memories (`dbl_get_sim_memories`), positions (`get_all_step_positions` paginated past PostgREST 1000-row cap), scratch (`load_persona_scratch`), chat transcripts from `movement.chat`.
- Sim-scoped memory retrieval via `dbl_retrieve_with_rir` (10-param overload, HNSW focal-point search).
- Verbatim chat transcripts with **importance-threshold selection** (turns ≥ 3 + protagonist speaks; hard-cap 25, floor-backfill 5 for sparse sims).
- Optional `--day N` scope; reads `persona_day_snapshots` for boundary alignment + `memory_cutoff_time` filter.
- **Sim-mode auto-detection** (`standard` vs `survival`) via `scratch.survival` AND `survival_season_state` row presence (the latter catches eliminated personas whose scratch was cleared).
- Survival sims emit `survival_context` (alive/eliminated/immune rosters, phase, challenge, today_elimination with verbatim final_statement, season_eliminated[] filtered to trailer day).
- Output: `day_log.json`.

**Stage 2 — `video/showrunner.py:_generate_day_in_life_script()`**

- Single Tier C (`gpt-5.2`) call. Each retry carries a unique `routing_step_id` so `TIER_C_MAX_CALLS_PER_STEP=1` cannot demote retries to Tier B.
- **Mode-aware prompt:** base for standard sims; Survival appends `SURVIVAL_ADDENDUM` (HOOK→COALITION→VOTE→STINGER beat sheet, required vote scene, named stakes, stakes-naming opener, competition vocabulary).
- **Required schema fields:** `title`, `mood`, `protagonist`, `logline`, `narrator_script` (with `[PAUSE Ns]` + `[SCENE N]` markers), `scenes[]`, `end_card`, `shareable_moment` (top-level), `vote_outcome_line` (Survival, null on non-vote days).
- **PROTAGONIST IDENTITY block** prepended to user prompt (name + personality summary + 1-2 daily-plan items + max-poignancy event). Validator requires ≥1 narrator-line content-token match against the identity block.
- **HARD CONSTRAINTS** in system prompt with ✓/✗ examples enforce: 2-4 scenes, consecutive `key_steps` (2-5 items), 100-200 word narration, ≥1 `[PAUSE]`, ≤2 dialogue excerpts total, ≤3 subtitle cards, shareable_moment in scene 1 or final, vote_outcome_line surfaces in final-scene narration on vote days, eliminated-protagonist `final_statement` quoted close-to-verbatim.
- **3-attempt retry** with offending-scene feedback echoed back verbatim + per-retry `routing_step_id`.

**Stage 4 — `video/record_scenes.py`**

- Per scene: navigate to `?recording=true`, drive playback via `window.__executeMovementsForStep` + camera API. Gate on `__headlessReady && __cameraSettled`; capture `t_payload_start` post-first-`__movementsComplete`; FFmpeg head-trim accurate (no `-c copy`); `_assert_first_frame_not_white` guard.
- Output: one WebM per scene in `raw/`.

**Stage 5 — `video/compose_trailer.py`**

- Concat WebMs → MP4, mix narration + music (ducked), SRT subtitles, dynamic end card via FFmpeg drawtext.
- Hard cap: `-t 60`. Output: 1280×720 master + 1080×1920 (9:16) crop.

**Validator — `video/validate_trailer.py`**

- 16:9 MP4 exists + 1280×720 + 58-62s · 9:16 MP4 exists + 1080×1920 + 58-62s · narration 100-200 words after stripping markers · end card present.
- Writes `output/validation_report.json`. Best-effort; failures log but don't abort.

### 2.2 Sim-Day-Overview Trailer

> **2:30-3:00 · 1-3 protagonists · 1 sim-day · two-stage LLM (spine + per-scene) · ensemble recap**
> **Playbook reference:** §3 (purpose, beat sheet, Today's Pressure, variable inserts, cafe ceremony, post-MVP editorial vision)
> **Shipped:** 2026-05-01, commit `a977a7e6`. Verified against `20260430-7` Day 2.
>
> **v2 spec divergence (playbook §3 updated 2026-05-04, implementation pending — tracked as TODO-14).** Playbook now defines an **8-beat structure** (cold hook → previously-on → Today's Pressure → spine → protagonist arcs → variable inserts → cafe ceremony → cliffhanger) with new modules: 3-5s cold hook, 5-10s Today's Pressure framing, 1-2 POV/omniscient variable inserts, structured 8-step cafe ceremony beat, thread-driven 3-line bridge card, "Tomorrow: {question}" end card, +15 pressure/vote bonuses on persona ranker. Shipped v0 implements a 5-beat baseline. Gaps are flagged inline; the description reflects shipped state, not the v2 target.

**Stage 1 — `video/extract_day_log.py:extract_day_overview()`**

- Runs the existing protagonist extraction for each top 1-3 personas (RIR focal-point retrieval, typed chat fetch).
- Computes shared timeline with all selected protagonists' paths marked.
- Detects trigger events: council fired, vote cast, alliance/conflict shift. Tags in `day_overview_context.json`.
- Builds `prior_day_summary` (from prior day's `survival_season_state.eliminated[]`) — empty on Day 1.
- Output: `protagonists[]` (1-3 blocks) + shared `timeline` + `trigger_events[]` + `prior_day_summary` + `survival_context`.

**Stage 2 — `video/showrunner.py:_generate_day_overview_script()`**

- **Two-stage LLM:**
  1. **Spine call** (configurable tier via `VIDEO_SPINE_TIER` env flag — Tier B / `gpt-5-mini` in dev for ~$0.008, Tier C / `gpt-5.2` in prod for ~$0.50). Returns spine sentence, mood, per-scene `focus_persona`.
  2. **Per-scene generation** (Tier C calls slotted into the spine). Each scene still obeys consecutive `key_steps` constraint.
- **Required schema fields** (extends day-in-life): `protagonists[]`, `prior_day_summary`, beat sheet (`previously_on → setup → development × 2-3 → council_vote → cliffhanger`), per-scene `trigger_event` tag, per-scene `focus_persona` (so `generate_description.py` rotating `?double=` deep-links work unchanged). **v2 gap (TODO-14):** schema must add `cold_hook` (0:00-0:05), `todays_pressure` (0:15-0:25, 5-10s pressure statement per playbook §3.5), and optional `variable_inserts[]` (≤2 per trailer; type ∈ {`pov`, `omniscient`}, per playbook §3.6).
- **Validator** enforces: 1-3 protagonists, ≥1 scene per protagonist, scenes fit 2:30-3:00 budget, spine sentence present, required scenes (`previously_on` skipped iff Day 1, `council_vote` present iff trigger fired), 50-90 words narration per scene. **v2 gap (TODO-14):** require cold_hook lands in first 5s, Today's Pressure module present, ≤2 variable inserts, ≤1 flyover transition, vote-day override forces inclusion of eliminated/decider/position-changer per playbook §3.7.

**Stage 4 — `video/record_scenes.py`** (no new capture mode)

- Sequential scenes per protagonist; camera API handles `__followPersona(name)` switches across scene boundaries.
- Picture-in-picture / split-screen for simultaneous POV deferred.

**Stage 5 — `video/compose_trailer.py`** (parameterized for 165s)

- **"Previously on…" bridge card** (`generate_previously_on_card`) — 10s WebM/vp9 card with text recap. Skipped on Day 1. See §5.3 for why WebM/vp9 instead of MP4/libx264. **v2 gap (TODO-14):** drive the 3-line content from active threads (continuity / unresolved fact / consequence) per playbook §3.10, not generic prior-day eliminated[]. Tighten duration to 6-10s.
- **Council/vote color grade** (`apply_council_grade`) — `colorchannelmixer=rr=1.05:gg=0.85:bb=0.82,eq=brightness=-0.06` applied per-scene to clips whose script entry has `trigger_event ∈ {vote, elimination, council}` before they enter `concat_scenes`. **v2 gap (TODO-14):** color grade is the visual layer; playbook §3.8 now specifies a full 8-step cafe-ceremony beat (slow push or flyover into cafe → all remaining Doubles visible → red grade ✓ → narrator names social consequence → 2-3 selected vote explanations → announce selected Double → quote farewell line ✓ → end on silence/empty-chair). Items 1, 2, 4, 5, 6, 8 not yet wired.
- **v2 gap (TODO-14):** end card today is generic; playbook §3.9 specifies "DAY {N} — {VILLAGE_NAME} / Tomorrow: / {unresolved question} / Doubland.ai" with explicit Tomorrow-question line. Logo placement: closing only, optional 0.5-1.0s flash after cold hook.

**Validator** — mode-aware bounds: 148-180s duration, 300-470 words narration.

**CLI:**
```bash
python -m video.generate_trailer 20260430-7 --mode day_overview --day 2 --top 3
```

### 2.3 Sim-Opening Trailer

> **2:30-3:00 · ensemble (1-6 cast slots) · Day-0 only · two-pass LLM (per-persona + wrapper) · season premiere + how-to-watch CTA**
> **Playbook reference:** §4 (purpose, six emotions in order, cast intros, stakes montage, how-to-watch, asset inventory)
> **Asset commission detail:** `d:\Coding\double-ivan\20260501_opening-trailer.md`
> **Shipped:** 2026-05-01, commit `f6f7017b` ("pending manual tasks" — see §0.1 P0).
>
> **v2 spec divergence (playbook §4 updated 2026-05-04, implementation pending — tracked as TODO-13).** Playbook now defines a 5-beat structure (cold open → cast intros → stakes montage → **how-to-watch** → CTA end card) and revises copy. The shipped v0 implementation uses a 4-beat structure. Gaps below are flagged inline; the description reflects shipped state, not the v2 target.

**Stage 1 — `video/extract_day_log.py:extract_opener_context()`**

- Pulls Day-0 scratch only (daily plan, relationship_affinities, home assignment, schedule) for every persona.
- Reads soul `.md` files for personality summaries.
- Runs `persona_ranker` to pick top-N featured personas (configurable 1-6 via `--top`).
- Resolves spawn `xy` from step-0 position rows.
- Output: `opener_context.json` with `featured_cast[]` + per-persona scratch + sketch_path + home_xy + survival rules.

**Stage 2 — `video/showrunner.py:_generate_opener_script()`**

- **Two-pass LLM:**
  1. Per-persona pass: 4 Tier-B helpers (`_generate_one_line_bio`, `_classify_archetype`, `_generate_trait_moment`, `_generate_stakes_montage_narration`).
  2. Wrapper pass: assembles cold open + cast intros + stakes montage + end card. **v2 gap (TODO-13):** add a how-to-watch beat between stakes montage and end card; see playbook §4.6 for templated copy ("The village runs 24/7. / Watch from the very first day. / New trailer daily at 6:30 PM.") — likely a 5th templated helper, not an LLM call.
- **Cold open is templated**, not LLM-generated: shipped wording `"{N} friends. {D} days. One survives."` (or `"{N} friends. One game. One survives."` when season length is unknown). **v2 gap (TODO-13):** playbook §4.2 revises to `"{N} Doubles. One village. One survives."` (Doubles vs friends; village vs days/game).
- **Archetype classification** assigns `champion` / `wildcard` / `observer` / `connector` per persona — drives trading-card frame border + per-persona sting selection.
- Validator (`_validate_opener_script`): 1-6 cast scenes, cold open + stakes + end card present, 95-180s total runtime. **v2 gap (TODO-13):** require how-to-watch beat present (5-beat enforcement).

**Stage 4 — `video/record_scenes.py` + `video/capture_static_assets.py`**

- **`capture_static_assets.py`** (235-line module): Playwright + Phaser camera-API screenshots. Idempotent (skips already-captured PNGs unless `--force`). Produces:
  - Per-persona top-down home stills: `video/assets/opening/home_topdown_{agent_id}.png`
  - 6 establishing shots: `establish_village_overhead.png`, `establish_cafe_exterior.png`, `establish_homes_row.png`, `establish_council_zone.png`, `establish_village_dawn.png`, `establish_village_dusk.png`
- **Sprite walk-out capture** (`record_sprite_walkout` + `record_sprite_walkouts`): per-persona 2.5s WebM/vp9 captures via Playwright, gated by `__headlessReady && __cameraSettled` and protected by `_assert_first_frame_not_white`. Composer prefers `.mp4` (commissioned Grok Imagine) then falls back to `.webm` (native Phaser).

**Stage 5 — `video/compose_trailer.py` opener composers**

- 5 opener-mode composers + orchestrator: `compose_cast_intro` (15s two-subclip crossfade per persona), `compose_opener_cold_open` (slow zoom on establishing shot), `compose_opener_stakes_montage` (6-8 ken-burns subclips, mixes PNG + MP4 sources transparently), `generate_opener_end_card` (3-line: title + cohort/season + CTA — shipped v0 emits `doubland.ai/waitlist`; v2 swaps to multi-line watch-live CTA per TODO-13), `compose_opener_trailer` (assembly).
- **Council-grade NOT applied** here — the opener has no vote events.
- **v2 gap (TODO-13):** add `compose_opener_how_to_watch` composer (~12-18s sequence; composes 2-3 cards from `video/assets/opening/how_to_watch_card_*.png` per playbook §4.6 + TTS narration). Update `generate_opener_end_card` to multi-line CTA per playbook §4.7 — "DAY 1 STARTS NOW / {cohort} — {season} / Watch live. Scroll back. Follow every Double. / New trailer daily at 6:30 PM. / www.doubland.ai" — replacing the single-line `doubland.ai/waitlist`. Likely bumps end-card duration ~5s → ~8s.

**Validator** — opener bounds: 95-180s duration, 60-220 words narration (cold open + stakes only — cast intros are silent).

**CLI:**
```bash
python -m video.generate_trailer 20260430-7 --mode opener --top 4 \
  --cohort-name "Pistsov family" --season-title "Who will stay alive"
```

### 2.4 Sim-Announce Trailer (Planned)

> **45-60s · ensemble · pre-sim hype · vertical-first 9:16 master**
> **Playbook reference:** §5 (purpose, beat sheet, asset inventory)
> **Status:** not yet implemented. Most different from existing pipeline (no sim footage; world flyover + cast cameos at idle Day-0 spawn positions).

**Stage 1 (new — `video/extract_announce_context.py`):**
- Reads persona soul `.md` files for bios and personalities.
- Reads location tree (`env_matrix` assets) for world overview.
- Loads Survival rules from one-time-written config (`video/survival_brief.json` — see §4.1).
- Output: `announce_context.json` — no memory stream, no timeline.

**Stage 2 (extend `showrunner.py` with `--mode=announce`):**
- Tier C call. Prompt enforces: 60s max, 3 beats (hook / rules / cast), kinetic pacing, no protagonist (ensemble intro), CTA in end card.
- Output schema: same shape as day-in-life `script.json`, but scene labels become `hook | rules | cast_montage | drop`.

**Stage 4 (extend `record_scenes.py` with `--mode=announce`):**
- **World flyover:** scripted pan across The Ville hitting 4-5 key landmarks at 0.5-0.7× zoom.
- **Cast cameos:** for each featured persona, zoom to their home, render sprite at idle (2-3s), overlay name card. Batch via camera API.
- No `__executeMovementsForStep` calls — sprites remain idle at Day-0 spawn positions.

**Stage 5 (minor):**
- Add `music_reveal.mp3` to mood library (§4.2 — open commission).
- Kinetic title cards via FFmpeg drawtext (reuse end-card logic, extend for mid-trailer cards — §4.4).

**New assets needed:** §4.1 (survival brief), §4.2 (`music_reveal.mp3`), §4.3 (cast portraits — overlap with §2.3), §4.4 (kinetic title-card templates).

---

## 3. Open TODOs + Completed Log

### Open — P1 quality gates

**TODO-2b. Verify chat memory persistence end-to-end.** Sim `20260413-1` has 0 rows of `memory_type='chat'` in `dbl_memory` despite 174 steps with `movement.chat` data — the real-time `add_chat` → `hybrid_memory_store` path is silently failing for at least one sim config. Write a 20-line diagnostic that, after a sim run, counts `dbl_memory` chat rows vs `movement.chat` occurrences and flags any gap. Not blocking for trailers (extractor reads `movement.chat` directly), but the cognitive loop's RIR retrieval of past-day conversations depends on this working for multi-day memory.

**TODO-4. Subtitle timing from actual narration audio.** SRT generation currently uses rough `time_range_sec` offsets from the script. Parse the produced `narration.mp3` waveform (or ElevenLabs per-word timestamps) and emit SRT from those, not script intent.

**TODO-6. 9:16 crop readability validation.** The crop exists but mobile-size readability hasn't been confirmed. Add a visual diff step or a manual checklist pass — verify protagonist stays in frame, subtitles legible at iPhone render size.

### Open — P2 polish

**TODO-7. SFX library (12 clips).** Transition/emphasis clips per playbook §1.5. Currently no SFX in output. Phase-2 nice-to-have, not blocking.

**TODO-8. End-card fontconfig on Windows.** Font fallback warning on `drawtext`; card renders but font choice varies. Low priority.

**TODO-9. Batch scene rendering / camera-script API.** Single `window.__executeCameraScript(json)` call replaces per-directive calls. Low complexity, reduces Playwright orchestration code. Phase 3.

**TODO-10. In-browser `MediaRecorder` path.** Alternative capture path with higher quality and native FPS control. Medium complexity. Phase 3, only if Playwright video quality proves insufficient.

**TODO-11. Phaser-level transition rendering.** Fade/fly-over/card-break as Phaser shader overlays instead of FFmpeg post. Eliminates a compositing step. Phase 3.

### Open — P3 longer horizon

**TODO-12. Interactive timestamped descriptions.** Emit `trailer_description.md` with clickable `/simulations/{sim_code}?step={N}&focus={x,y}&zoom={level}` links for each key moment. Requires FE query-param parsing (auto-jump, pan, zoom) and optional sprite highlighting. Builds on camera API.

### Open — Sim-Day-Overview v2 spec implementation

**TODO-14. Sim-Day-Overview v2 spec — 8-beat structure + cafe ceremony + Today's Pressure + variable inserts + ranker scoring update.** Playbook §3 (updated 2026-05-04) revises sim-day-overview from a 5-beat to an 8-beat structure with new modules and refined editorial rules. Engineering work to land:

- **Cold hook scene (0:00-0:05).** New beat slot at the very front. 3-5s most-loaded moment with no full context — solo-after-conflict / group-before-vote / loaded subtitle / consequence-line / silent aftermath. Validator must enforce hook lands in first 5s. Optional 0.5-1.0s Doubland.ai logo flash after the hook.
- **Today's Pressure module (0:15-0:25).** New compose function `compose_todays_pressure_card` (~5-10s). Templated copy: `"Today's pressure: {action}. But {consequence}."` (per playbook §3.5). Source data: today's challenge + social-constraint extraction. Acceptance: every Sim-Day-Overview emits one pressure statement.
- **Variable inserts: POV / omniscient (≤2 per trailer).** New scene type with two subtypes per playbook §3.6:
  - **POV insert** — `"From {Double}'s point of view, {interpretation}. What {Double} could not see was {missing context}."` Triggered when a Double misreads the room or alliance hinges on one belief.
  - **Omniscient insert** — `"What no one knew yet was {hidden scenario}. By nightfall, {consequence}."` Triggered when audience needs hidden-dilemma context. Schema: `variable_inserts[]: [{type: "pov"|"omniscient", at_step, content}]`. Validator caps at 2.
- **Cafe ceremony 8-step sequence (TODO-14a, blocking on cafe-as-default-stage decision).** Replace the bare red-grade with the full sequence per playbook §3.8: (1) slow push or flyover into cafe, (2) all remaining Doubles visible, (3) red-push grade ✓ shipped, (4) narrator names social consequence, (5) 2-3 selected vote explanations surfaced, (6) selected Double announced, (7) farewell line quoted ✓ shipped, (8) end on silence / reaction / empty-chair shot. Items (1), (2), (4), (5), (6), (8) need new compose function `compose_cafe_ceremony` and an LLM helper for vote-explanation selection. Constraint: cap vote-explanations at 2-3 ("hide enough motive to make tomorrow interesting").
- **Bridge card 3-line thread-driven format.** Update `generate_previously_on_card` content to playbook §3.10's `"Previously in the village: / {one unresolved social fact} / {one consequence still active today}"`. Source must be active-thread state, not the prior day's `eliminated[]` row. Duration tighten to 6-10s. (Thread state machine itself is post-MVP per §5.10 and playbook §3.13 — interim: surface the most-recent unresolved high-poignancy event from prior day, not the full eliminated[] dump.)
- **End card v2 format.** Update day-overview end card to playbook §3.9: `"DAY {N} — {VILLAGE_NAME} / Tomorrow: / {unresolved question} / Doubland.ai"`. Requires generating the `unresolved_question` (LLM-derived from the cliffhanger scene's `trigger_event` + protagonist arc, or templated from `script.cliffhanger_question` field).
- **Persona ranker v2 scoring** (`video/persona_ranker.py`). Add two new bonus terms per playbook §3.7:
  - `+15` Pressure-relevance bonus (persona directly affected today's challenge outcome)
  - `+15` Vote-relevance bonus (persona received votes, influenced votes, or changed coalition position)

  Plus **vote-day override**: if a vote-out fired, the cohort returned must include the eliminated Double + the deciding voter + the Double whose social position changed most. Update §4.8 in this PRD with the new formula.
- **Pacing rule additions** (validator). Per playbook §3.11: ≤4 dialogue excerpts total, ≤6 subtitle cards, ≤2 variable inserts, ≤1 flyover transition, no scene > 25s, ≥1 silence beat 2-3s.
- **Acceptance gates** (validator + manual). Per playbook §3.12: cold hook lands in first 5s, Today's Pressure module present, spine sentence present, "Previously on…" skipped iff Day 1, cafe ceremony snapshot used iff vote fired, vote explanations 2-3 max, eliminated farewell quoted if available, end card includes Day number / village name + Tomorrow-question + Doubland.ai logo.

**Sequencing:** the 5 mid-tier items (cold hook, Today's Pressure, variable inserts, end-card v2, ranker scoring) are independent and can ship in parallel. The cafe-ceremony 8-step sequence is the largest item and should land alongside an explicit cafe-as-default-stage decision; until then, the existing red-grade beat continues to work as a degraded fallback. Bridge-card 3-line format requires either thread-state plumbing (post-MVP) or an interim heuristic for "active threads," whichever lands first.

Acceptance: end-to-end run on a Day-N (vote-day) of `20260430-7` produces an 8-beat trailer; validator PASS at 148-180s; cafe ceremony reads as a recurring ritual; cold hook stops a thumb-scroller in 3s; Tomorrow-question lands at end card.

### Open — Sim-Opening v2 spec implementation

**TODO-13. Sim-Opening v2 spec — how-to-watch beat + revised end card + cold-open copy refresh.** Playbook §4 (updated 2026-05-04) revises sim-opening from a 4-beat to a 5-beat structure and refreshes end-card / cold-open copy. Engineering work to land:

- **`compose_opener_how_to_watch` (NEW composer in `video/compose_trailer.py`).** ~12-18s sequence between stakes montage and end card. Composes 2-3 cards from `video/assets/opening/how_to_watch_card_*.png` (asset commission §TODO-J in §0.1 P0) with templated narration: "The village runs 24/7. / Watch from the very first day. / Follow every Double — routines, conversations, alliances, and vote-outs. / New trailer daily at 6:30 PM." (or shorter alt per playbook §4.6).
- **`_generate_opener_script` wrapper pass** must emit a 5th scene between stakes_montage and end_card; templated narration helper (no LLM call needed since copy is fixed).
- **Cold-open template wording** in `_opener_cold_open_line()`: change `"{N} friends. {D} days. One survives."` → `"{N} Doubles. One village. One survives."` (per playbook §4.2). One-line fix.
- **`generate_opener_end_card`** revise to multi-line CTA per playbook §4.7: "DAY 1 STARTS NOW / {cohort_name} — {season_title} / Watch live. Scroll back. Follow every Double. / New trailer daily at 6:30 PM. / www.doubland.ai" (replaces single-line `doubland.ai/waitlist`). Bump card duration ~5s → ~8s to give the extra copy reading time.
- **`_validate_opener_script`** require how-to-watch beat present (5-beat enforcement). Duration window 95-180s likely still covers; new target ~170s.
- **Tone rule** (per playbook §4.6): how-to-watch copy must frame access as "follow every Double inside a shared simulation," never "look into every action / spy on real friends." Validator-level keyword guard optional.

Acceptance: end-to-end run on `20260430-7` produces a 5-beat opener trailer; validator PASS; how-to-watch cards readable at 9:16; end card holds long enough to read all five lines at mobile size.


### Completed 2026-05-01 (`ivan/video-trailer-fixes` branch)

- **§2.2 Sim-Day-Overview trailer (commit `a977a7e6`).** Multi-protagonist 2:30-3:00 ensemble recap with "Previously on…" bridge card, council/vote tint, cliffhanger end card. Two-stage LLM (spine + per-scene) on `VIDEO_SPINE_TIER` env flag (Tier B in dev / C in prod). Verified end-to-end against `20260430-7` Day 2: validator PASS at 154.72s × 1280×720 + 1080×1920, narration 342 words, council tint applied to Luba's elimination scene, prior_day_summary correctly references Gosha's elimination. Day-in-life regression check: PASS. ~$0.008 LLM cost on Tier B (gpt-5-mini) per trailer; ~$0.50 on Tier C in production. CLI: `python -m video.generate_trailer <sim_code> --mode day_overview --day N [--top {1,2,3}]`. Files: `video/persona_ranker.py` (new — §4.8), `video/showrunner.py` (+678 lines — §4.9 mode dispatch), `video/extract_day_log.py` (+256 lines), `video/compose_trailer.py` (+173 lines — `generate_previously_on_card` §4.6 + `apply_council_grade` §4.7), `video/generate_trailer.py` (+77 lines — §4.10), `video/validate_trailer.py` (+68 lines, mode-aware checks). Three intentional divergences captured in §5.

- **§2.3 Sim-Opening trailer (commit `f6f7017b`, "pending manual tasks").** Day-0 cast-intro 2:30-3:00 with cold open, 6-persona cast scenes, stakes montage, end card. Reuses §4.8 ranker + §4.9 mode dispatch from §2.2. Files: `video/capture_static_assets.py` (new, 235 lines — renders `establish_*.png` and `topdown_*.png` assets), `video/assets/opening/` (rendered establish frames + per-persona walkout WebMs), `video/showrunner.py` (+513 lines — opener mode + prompt template), `video/extract_day_log.py` (+228 lines — `extract_opener_context`), `video/compose_trailer.py` (+598 lines), `video/record_scenes.py` (+165 lines — world flyover + cast cameo paths), `video/generate_trailer.py` (+176 lines). CLI: `python -m video.generate_trailer <sim_code> --mode opener --cohort-name <name> --season-title <title>`. Pending manual follow-ups per commit message: soul/copy curation for cast bios, optional `music_anthem.mp3` sourcing, field test on a real Day-0 sim.

### Completed 2026-04-30 (`ivan/video-trailer-fixes` branch)

All four P1 accuracy/correctness items from the 2026-04-29 review shipped and verified end-to-end against sim `20260430-7` Gosha-Day-1 trailer (eliminated-protagonist case).

- **TODO-0a. Day-boundary semantics + day-1 timeline truncation.** Without these, the Gosha trailer would have rendered scene 4 as blank video for steps 871-874 (eliminated mid-Day 1) and the extractor would have truncated at ~step 245.
  - **#1 Defensive validator** in `showrunner.py:validate_script` — every scene's `key_steps` must intersect at least one actual position row in the day_log timeline; rejects and retries on failure.
  - **#2 Paginated position fetch** in `extract_day_log.py:_fetch_positions` — replaced single-shot call (capped at PostgREST 1000-row limit) with pagination loop. Sole root cause of the day-1 timeline truncation.
  - **#3 Real game-clock day boundaries.** `_compute_day_range` walks paginated rows and uses real game-clock midnight crossings as authoritative day boundaries, not arithmetic 1,440-step blocks.
  - **#4 Snapshot writer fix** in `_maybe_save_persona_day_snapshots` (`reverie.py`) — applies the same game-clock walk so future snapshots store accurate `day_start_step`/`day_end_step`.
- **TODO-2c. Survival vote-outcome line + verbatim `final_statement` quoting.** Required `vote_outcome_line` field in script schema; eliminated-protagonist trailers quote the verbatim `final_statement` from `survival_season_state.eliminated[]`. Gosha's farewell quoted in scene 4 narration; `vote_outcome_line: "Gosha Pistsov goes home — three votes to zero."`; end-card "DAY 1 — ONE GONE".
- **TODO-2d. Personality + top-poignancy memory in narration.** PROTAGONIST IDENTITY block injected into showrunner system prompt; validator requires ≥1 content-token match. Gosha's "SAT prep" / "alliance cues" / "strategy notes" identity threads through the trailer.
- **TODO-2e. Shareable-moment field.** Required top-level `shareable_moment` field in script schema; validator places it in scene 1 or final scene narration.
- **TODO-5. Quality-gate automation.** `video/validate_trailer.py` shipped with mode-aware duration + narration word-count + dimension checks; wired into `generate_trailer.py` step 7.

### Completed 2026-04-29 (Nicolas, `nicolas/*` branches)

- **TODO-1. Smooth scene transitions / blank-screen prefix fix.** Root cause: scenes started recording before the headless camera had settled, leaving a white-frame prefix that the FFmpeg head-trim approximated rather than measured. Fix: gate on `__headlessReady && __cameraSettled`, capture `t_payload_start` post-first-`__movementsComplete`, accurate FFmpeg head-trim (no `-c copy`), `_assert_first_frame_not_white` defensive guard. Verified across multi-protagonist day-overview trailer (6 scenes, 3 protagonist switches, all brightness checks pass).
- **YouTube description generator** (`video/generate_description.py`) — emits per-scene timecode deep-links with `?t=&double=&zoom=&focus=&speed=` params + waitlist CTA.
- **YouTube upload helper** (`video/youtube_upload_helper.py`) — runbook + helper script.
- Trailer-quality review of `20260428-3-ivan-day1` produced TODO-0a (day-boundary semantics + timeline truncation), TODO-2c (Survival prominence + farewell quoting), TODO-2d (personality + top-poignancy in narration), TODO-2e (shareable-moment field) — all subsequently shipped 2026-04-30.

### Completed 2026-04-28

- **End-of-day persona snapshots.** `persona_day_snapshots` table (migration `20260428125500_persona_day_snapshots.sql`) keyed by `(simulation_id, persona_id, day)` with `day_start_step`, `day_end_step`, `scratch_json`, `survival_context_json`, `memory_cutoff_time`, `schema_version`. `save_persona_day_snapshot` / `load_persona_day_snapshot` RPCs. `_maybe_save_persona_day_snapshots` in `reverie.py` fires at every day boundary. `extract_day_log.py` reads the snapshot for scratch + survival_context and filters memory by `memory_cutoff_time`; degrades to latest scratch when no snapshot. `showrunner.py` passes `valid_step_start`/`valid_step_end` from `day_step_range` into prompt + validator. Schema documented in `supabase/db_reference.md`. Verified for sim `20260428-3` on 2026-04-29 (3 alive personas × 1 day rows). Boundary-computation + timeline-truncation follow-ups closed under TODO-0a on 2026-04-30.

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

## 4. Shared Infrastructure & Assets

Cross-cut components reused across trailer types. Numbered for cross-reference from §2.

### 4.1 Survival format brief (one-time written copy)
`video/survival_brief.json` — rules, goal, elimination mechanic, tagline. Used by §2.4 Sim-Announce and §2.3 Sim-Opening. Written once per season format. Open. ~1h.

### 4.2 `music_reveal.mp3` (new mood track for Sim-Announce)
75s, big drums + kinetic pulse, reveal/hype arc. Generated on Suno/Udio, normalized −16 LUFS MP3 192kbps (same pipeline as existing three tracks). Open. ~1h.

### 4.3 Hi-res cast portrait frames
Scripted renderer: load each persona's sprite atlas, upscale 4×, render against neutral background, export PNG. Used for cast cameos (§2.4 Sim-Announce) and name cards (§2.3 Sim-Opening). Open. ~2h of scripting against existing atlas files. No new art.

### 4.4 Name-card overlay template
FFmpeg drawtext + optional PNG badge. Parametric: `{name}`, `{bio_line}`, `{color_accent}`. Reusable across all trailer types. Open. ~2h.

### 4.5 Affinity-graph overlay (optional, Sim-Opening)
Bird's-eye pan with lines drawn between featured personas colored by affinity score. Implementation options: (a) SVG rendered to PNG and FFmpeg-overlaid, (b) Phaser-side pre-roll scene with a new `window.__renderAffinityGraph(personas)` function. Option (a) simpler. Open / **skipped in v1** as a deliberate scope cut. ~4h.

### 4.6 "Previously on…" bridge-card template — **SHIPPED 2026-05-01 (text-only v1)**
FFmpeg drawtext + 10s WebM/vp9 card. Skipped on Day 1. Driven by `script.prior_day_summary` (built from prior day's `survival_season_state.eliminated[]` row). Image keyframes from prior trailer **deferred to v2** — text-only is what ships now. `video/compose_trailer.py:generate_previously_on_card`. See §5.3 for the WebM/vp9 vs MP4/libx264 design call.

### 4.7 Council / vote visual treatment — **SHIPPED 2026-05-01**
FFmpeg `colorchannelmixer=rr=1.05:gg=0.85:bb=0.82,eq=brightness=-0.06` chain. Applied per-scene to clips whose script entry has `trigger_event ∈ {vote, elimination, council}` before they enter `concat_scenes`. `video/compose_trailer.py:apply_council_grade`.

### 4.8 Persona impact-ranking scorer — **SHIPPED 2026-05-01**
`video/persona_ranker.py` — public module. Scoring formula:

```
score = top_5_poignancy
      + 0.5 × conversation_count
      + 0.2 × unique_locations
      + 50  × trigger_event_bonus       (eliminated this day)
      + 10  × relationship_extreme      (top-10% or bottom-10% affinity in cohort)
```

Returns top 1-3 with quiet-day fallback (top-1 only when score spread is tight: top-bottom delta < 1.5×). CLI: `python -m video.persona_ranker <sim_code> --day N --top {1,2,3}`. Verified against `20260430-7`: Day 1 → Gosha #1, Day 2 → Luba #1. See §5.1 for the top-5-poignancy-vs-all-events design call.

### 4.9 Showrunner mode dispatch — **SHIPPED 2026-05-01**
`video/showrunner.py:generate_script(day_log, mode={day_in_life|day_overview|opener})`. Per-mode entry-points (`_generate_day_in_life_script`, `_generate_day_overview_script`, `_generate_opener_script`) with new prompt templates inline (no separate `video/prompts/` directory yet — defer that refactor until §2.4 Sim-Announce adds a fourth mode). Per-mode validators live alongside their generators. `VALID_MODES = ("day_in_life", "day_overview", "opener")`.

### 4.10 Multi-mode orchestrator — **SHIPPED 2026-05-01**
`video/generate_trailer.py --mode={day_in_life|day_overview|opener}` dispatches stage 1 to the matching extractor and threads `mode` through stage 2; `persona_name` is now optional (ignored for day_overview / opener). `--top` arg controls ensemble size for day_overview (1-3) and opener (1-6). `--cohort-name` and `--season-title` are required for opener. Adding `--mode announce` is a small additive change.

---

## 5. Design Decisions / Divergences

The non-obvious calls. Read this when arriving fresh and wondering "why is it like this."

### 5.1 Persona scoring uses TOP-5 poignancy sum, not ALL events
**Where:** `video/persona_ranker.py`. Sim-Day-Overview protagonist selection (§4.8).

**Original plan:** sum poignancy across all of today's memories per persona, add the +50 trigger-event bonus, rank.

**Problem found:** active personas accumulate hundreds of low-poignancy ambient events on a busy day. Their poignancy sum (~2200) trivially overwhelmed the +50 trigger-event bonus for an eliminated persona. Eliminated personas — the day's actual story — ranked behind active ones who happened to walk around a lot.

**Fix:** cap to top-5 events per persona before summing. Captures dramatic peaks instead of total mass; the elimination event (poignancy 8) lands inside the top-5 window and the +50 bonus is now decisive.

### 5.2 Trigger-event step anchored on persona's last position row, not `day_end_step`
**Where:** `video/extract_day_log.py:_build_trigger_events()`. Sim-Day-Overview spine LLM input.

**Problem:** the vote happens late-day, but eliminated personas drop out of the movement stream the moment they're voted out. Anchoring trigger-event step on `day_end_step` (e.g. 2489 on Day 2) lands the spine LLM outside the persona's data range — Luba's last step is 2310 — so the validator rejected every spine attempt for "no position rows at requested step."

**Fix:** anchor trigger-event step on the eliminated persona's actual last-position row. Keeps the council_vote scene inside recordable territory; spine LLM converges first try.

### 5.3 "Previously on…" bridge card written as WebM/vp9, not MP4/libx264
**Where:** `video/compose_trailer.py:generate_previously_on_card()`. Sim-Day-Overview compose.

**Problem:** xfade rejects mixed timebases. The H.264 bridge card defaulted to timebase 1/12800; recorded scene WebMs use 1/1000. The mismatch crashed compose with cryptic ffmpeg errors.

**Fix:** write the bridge card as WebM/vp9 to match recorded scene format; concat works cleanly. Image-keyframe v2 (PRD §4.6 spec) deferred — text-only ships now.

### 5.4 PostgREST pagination is required for any sim with > ~333 steps × cast
**Where:** `video/extract_day_log.py:_fetch_positions()`.

**Why:** PostgREST returns 1000 rows max per request unless paginated. A 4-persona × 2400-step sim has 9600 position rows; an unpaginated `get_all_step_positions` call returns the first 1000 (ordered by `(step, name)`), silently truncating each persona's day-1 timeline at ~step 245. The day_log's `total_steps` reads correctly but the timeline samples are wrong.

**Fix:** cursor-based pagination loop: advance cursor to max step in each chunk, dedupe boundary rows by `(step, persona_name)`, exit on empty page or chunk < 1000. Deployed 2026-04-30 with TODO-0a #2.

### 5.5 Day boundaries computed from real game-clock midnights, not arithmetic step blocks
**Where:** `video/extract_day_log.py:_compute_day_range()` and `reverie/backend_server/reverie.py:_maybe_save_persona_day_snapshots()`.

**Why:** sims rarely start at midnight. A sim that starts at ~06:00 sim-time has its true Day-1 midnight crossing at step ~1080, not step 1440. Arithmetic `[0, 1439]` boundaries pass scenes outside the actual day to the spine LLM (which then picks `key_steps` from Day 2 or beyond) and lead to blank-video scenes.

**Fix:** walk paginated position rows, find game-clock midnight crossings, use those as authoritative boundaries. Honor `persona_day_snapshots` row only when its boundaries align with actual data; otherwise recompute and warn. Sims that actually start at midnight still get `[0, 1439]` correctly.

### 5.6 Eliminated personas' sim_mode must be detected via season_state, not just scratch
**Where:** `video/extract_day_log.py:_detect_sim_mode()`.

**Why:** an eliminated persona's scratch has `survival` cleared by `_clear_survival_mode()`. If `_detect_sim_mode()` only reads `scratch.survival`, an elimination-day trailer for that persona returns `"standard"` and bypasses the entire survival pipeline (no SURVIVAL_ADDENDUM, no vote_outcome_line, no farewell quoting). This is the most dramatic trailer day to lose.

**Fix:** detect survival mode via `survival_season_state` row presence in addition to scratch. Promote `sim_mode` to `"survival"` when either signal is present.

### 5.7 Sim-opening cold-open line is templated, not LLM-generated
**Where:** `video/showrunner.py:_opener_cold_open_line()`.

**Why:** the cold-open line is the trailer's first impression. Tier-C LLM output for "give me one cold-open line" was inconsistent across runs — some attempts came back generic, some too long, some too clever. Templating gives reliable copy in three known-good shapes (`"{N} friends. {D} days. One survives."` / `"{N} friends. One game. One survives."` / variants from the playbook menu).

**Trade-off accepted:** lower variety per run, in exchange for predictable quality. If post-MVP testing shows the templated lines fatigue, swap to LLM with stricter validation.

### 5.8 Sim-opening cast intros have no spoken VO
**Where:** `video/compose_trailer.py:compose_cast_intro()`. Per-persona 15s.

**Why:** ElevenLabs TTS using *the narrator's* voice for "I'm Aunt Maria, here to play" undercuts the recognition beat — the viewer hears the narrator, not the persona. Cast intros run with anthemic music + sprite cameo + name card + on-screen-text trait moment. Narrator only speaks during cold open and stakes montage.

### 5.9 `VIDEO_SPINE_TIER` env flag isolates cost from quality
**Where:** Sim-Day-Overview spine call routing (§2.2).

**Why:** the spine LLM picks the day's narrative arc. Tier C costs ~$0.50/trailer; Tier B costs ~$0.008. Production needs Tier C reliability; dev iteration needs Tier B speed/cost. A single env flag decouples them: `VIDEO_SPINE_TIER=B` in dev `.env.local`, `=C` in prod. Per-scene calls always run Tier C — only the spine routes via this flag.

### 5.10 Sim-day-overview shipped *protagonist-driven*, not *thread-driven*
**Where:** §2.2 architecture vs the broader vision in playbook §3.8.

**Why:** the more ambitious vision (event-level `TrailerScore`, multi-day thread state machine, mini-arc A/B/C structure, spice moments, personalization) is substantial engineering surface — easily a quarter of greenfield work. Shipping protagonist-driven first gets the trailer type live in days, not weeks; the editorial vision can land incrementally as v2 work without blocking the YouTube channel launch.

**Trade-off accepted:** today's sim-day-overview is less editorial than the vision. The playbook §3.8 captures the gap explicitly so future engineering work has a north star.

---

## 6. Risks, Dependencies, Acceptance

### 6.1 Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Sim-opening at 2:30 fatigues viewers | Low retention past 60s | Ruthless edit pacing in showrunner prompt (≤3s shots, silence beats every 15-20s); A/B against a 90s cut post-MVP |
| Sim-day-overview spine call returns weak arc | Flat trailer | 3-attempt retry with offending-scene feedback; fall back to single-protagonist mode if quiet-day flag trips |
| Cast ranking misses obvious protagonist | Wrong featured picks | Expose ranking as a `--featured` CLI override; log top-10 scores for auditability |
| Council / vote color grade too heavy-handed | Breaks tone | Color grade opacity is fixed today; revisit if test on wholesome-mood days surfaces issues |
| Sim-announce world flyover looks empty | No sprites yet (sim hasn't run) | Render sprites in spawn positions at idle; do flyover through populated zones only |
| Showrunner JSON invalidity | Pipeline halt | Schema validation + 3-attempt retry with offending-scene echo-back (mitigated) |
| TTS quality variance | Inconsistent narrator | Calibration line + stability/clarity params (mitigated) |
| Playwright framerate drift | Stuttery capture | timeScale tuning + post-record validators (mitigated) |
| 9:16 crop clipping | Protagonist out-of-frame | `__followPersona` centering carries day-in-life rule; mobile eyeball pass open as TODO-6 |

### 6.2 Technical dependencies

**All shipped:** Supabase RPCs (`dbl_retrieve_with_rir` 10-param, `dbl_get_sim_memories`, `get_all_step_positions`, `load_persona_scratch`, `save_persona_day_snapshot`, `load_persona_day_snapshot`, `load_survival_season_state`), ElevenLabs + OpenAI TTS, FFmpeg (with `static-ffmpeg` Python wrapper for Windows), Playwright, Phaser frontend with `?recording=true` mode, camera scripting API (5 `window.__*` functions), Tier C LLM access.

**New for §2.4 Sim-Announce:** soul `.md` reader (exists in sim engine — reuse), survival brief config file (§4.1), `music_reveal.mp3` (§4.2).

### 6.3 Acceptance per trailer type

Cross-reference: shared craft acceptance is in playbook §1.8; per-type checklists in playbook §7.

- **Day-in-Life:** 58-62s · 140-170 words · ≥1 silence beat · ≤2 dialogue excerpts · ≤3 cards · 9:16 crop with key elements visible · subtitles readable at mobile size · first 3s thumb-stop
- **Sim-Day-Overview:** 148-180s · 1-3 protagonists · spine sentence in narration · council/vote beat present iff trigger fired · cliffhanger not resolved · "previously on…" skipped iff Day 1
- **Sim-Opening:** 95-180s · 60-220 words narration · 1-6 cast scenes · cold open in first 3s · CTA end card
- **Sim-Announce:** 45-60s · vertical-first 9:16 · all featured personas appear once · Survival rules card present · drop-date end card · no memory-stream data used

---

## 7. Milestone Log

| Date | Milestone |
|---|---|
| 2026-04-10 | First day-in-life trailer produced (Ivan Pistsov / `20260407-2`). |
| 2026-04-13 | FE `?recording=true` mode live — camera API + step animation active. |
| 2026-04-14 | Plan B — consecutive-step scene segments; eliminates character teleportation. |
| 2026-04-14 | Supabase-native context builder — O(constant) context size. |
| 2026-04-14 | RIR focal-point retrieval, sim-scoped (migration `20260414_dbl_retrieve_rir_sim_scope.sql`). |
| 2026-04-15 | PRD reorganized; three sim-wide trailer types added (Sim-Announce, Sim-Opening, Sim-Day-Overview). |
| 2026-04-15 | Day-aware chat extraction from `movement.chat` (verbatim transcripts, importance-threshold selection replacing top-10 cut, optional `--day N` scope). |
| 2026-04-15 | Showrunner retry stabilization — HARD CONSTRAINTS prompt block, per-retry `routing_step_id` pins Tier C, offending-scene echo-back in retry feedback. |
| 2026-04-15 | Mode-aware showrunner — `scratch.survival` auto-detection, Survival beat sheet (HOOK→COALITION→VOTE→STINGER), TikTok-paced voice (140-170 words @ 2.7 w/s). |
| 2026-04-28 | End-of-day persona snapshots shipped (`persona_day_snapshots` + boundary hook + extractor integration). |
| 2026-04-29 | Trailer-quality review of `20260428-3-ivan-day1` — added TODO-0a (day-boundary semantics + timeline truncation), TODO-2c rewrite (Survival prominence + farewell quoting), TODO-2d (personality + top-poignancy in narration), TODO-2e (shareable-moment field). |
| 2026-04-29 | (Nicolas) Smooth scene transitions / blank-screen fix shipped — fused `__headlessReady && __cameraSettled` gate, post-`__movementsComplete` `t_payload_start` capture, accurate FFmpeg head-trim, `_assert_first_frame_not_white` defensive guard. |
| 2026-04-29 | (Nicolas) YouTube description generator + upload helper shipped — per-scene timecode deep-links with `?t=&double=&zoom=&focus=&speed=` params. |
| 2026-04-30 | TODO-0a (#1-#4), TODO-2c, TODO-2d, TODO-2e, TODO-5 all shipped on `ivan/video-trailer-fixes`. End-to-end Gosha-Day-1 trailer for `20260430-7` PASSED — eliminated-protagonist case with verbatim final_statement quoting. |
| 2026-05-01 | Sim-Day-Overview trailer (§2.2) shipped — multi-protagonist 2:30-3:00 ensemble recap with two-stage LLM (spine + per-scene), `VIDEO_SPINE_TIER` env flag for dev/prod tier selection, "Previously on…" WebM bridge card, council/vote color grade, mode-aware validator. End-to-end verified on `20260430-7` Day 2; day-in-life regression check still PASSES. |
| 2026-05-01 | Sim-Opening trailer (§2.3) shipped — Day-0 cast-intro with cold open, 6-persona cast scenes, stakes montage, end card. New `video/capture_static_assets.py` + `video/assets/opening/` (establish frames + per-persona walkout WebMs); reuses §4.8 ranker and §4.9 mode dispatch. Pending manual asset/copy curation per commit `f6f7017b`. |
| 2026-05-04 | PRD restructured — split into "engineering reference" (this doc) and "producer's playbook" (`D:\Coding\double-ivan\video\video_playbook.md`). New §2 Per-Trailer-Type Engineering Reference; new §5 Design Decisions / Divergences. Old `1.MVP_video_playbook.md` and `2.Advanced_video.md` merged into the new playbook and deleted. |
