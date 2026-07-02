*20260702: DESPITE EVERYTHING IS IMPLEMENTED, THE RESULT IS SHIT*


# Day-Overview Trailer — Implementation TODO

> Daily simulation-day recap trailers (Episode 1, 2, 3… at 18:30 owner-local). **Must look and feel like the next episode of the same show as the shipped opener.**
> **Refs:** Video SOT `video/sot-video.md` (Part I shared grammar · §12 [C] · L8 simulation literacy · **L9/L10 duration**) · Blend grammar `video/daily/daily-2D-3D-blend.md` · Opener impl `video/opening-15person/20260617_vertical-trailer-automation.md` · Engineering `video/video_PRD.md` §2.2 · Creative `video/video_playbook.md` §3.
> **Branch:** `ivan/daily-trailer` (forked from railway). **Last updated: 2026-07-01.**



---

## Ideal outcome

### 1. Same show, next episode (style & format)

The daily trailer is indistinguishable in craft from the opener — a viewer can't tell it was built by a different code path. It inherits from the opener:

- **Format:** 9:16 vertical, 1080×1920, mobile-first. **Remotion render** (not the legacy FFmpeg/Phaser path).
- **Motion system:** continuous journey, motivated handoffs, 3+ depth layers, `type-then-hold` text — shared grammar in `video/sot-video.md` Part I (§3–§7).
- **Assets:** reuse the opener's Supabase `trailer_asset` registry by `persona_id` — cutouts, hero spotlights, group photo, matrix, relationship graph. **No sketch-portrait re-generation.** Same Doubles appear in both trailers.
- **Audio:** opener SFX library + planner; mix ~-14 LUFS, true peak ≤ -1 dBTP, music ducked 3–5 dB under speech.
- **Voice:** ElevenLabs `eleven_v3` warm @ **1.5×** (matches opener).
- **End card:** opener's `questionToUrlTakeover` pattern with day-episode copy ("Day N ends" / "What happens tomorrow?").
- **Validators:** the opener gate set — 9:16, 1080×1920, 30fps, LUFS, editorial-motion (visual-change rate ~23.5/min, near-static intervals), asset-presence, narration-fit.

### 2. The day arc (story)

- **Multi-lead, moment-driven.** The producer ranks the day's events, selects **1–3 impactful moments** and **2–4 featured Doubles**, then drafts a flexible **3–6 beat plan** sized to those moments. The fixed 5-beat template is a fallback shape, not the default.
- **Cold-viewer intro.** Day-1: daily-specific concept-reset card + per-Double cast intros. Day ≥2: brief concept+cast touch + `yesterday_scar` "Previously on" bridge. The opener is **not** the Day-1 trailer — each daily is a self-contained episode.
- **Drama >> resolution.** The day closes on a cliffhanger hook for tomorrow, never a bow.
- **Plain marketer-simple language.** Concrete nouns and verbs, no strategy jargon or abstractions. A viewer who's never seen the show follows every sentence.
- **Who they are, not just what they did.** Each featured Double's first mention carries a few role/trait words explaining *why* they act, drawn from the producer's status-deltas and persona personality data.
- **Pacing.** Total trailer **under 120 seconds** ([C] `day_survival` per SOT L10). Pauses minimal and matched to the opener (~0.15s per scene, ~3s total silence). First-name-only in voiceover; full names on cards.

### 3. The 2D→3D "matrix" north-star

The deepest product goal: the viewer **watches** the Phaser 2D visualization but **sees** (mentally) a 3D rendering — as if Doubland is their portal into a matrix where the simulation is indistinguishable from reality. Locked as **L8** in `video/sot-video.md` §0.2. The daily trailer is where that mental translation gets trained; execution rules → `video/daily/daily-2D-3D-blend.md`.

For the day's 1–3 selected high-stakes moments, the trailer cuts from 2D into a short **1–2s cinematic 3D clip** generated from *that moment's actual location and the actual Doubles involved*, then back to 2D. Workflow per selected moment:

1. **[a] Identify the location** where the event occurred (tile/sector → named location).
2. **[b] Fetch the location plate** — interiors: `video/assets/village/interior/` (39 plates); exteriors: `video/assets/village/exterior/` (6 plates).
3. **[c] Fetch the participating Doubles' photos** — from the baseline cohort the sim was forked from (`video/assets/cohort/soul15_seed_20260224/` — `portraits/`, `hero/`, `group_photo*.png`, `relationship_graph.json`). The fork reuses the same Doubles.
4. **[d] Generate a 1–2s clip** via Grok Imagine (image-to-video): location plate [b] as setting + Doubles' photos [c] as character reference + a plain action description (from the producer's `moment_ref` / beat note) specifying what each Double was doing.
5. **[e] Wire the clip** as the beat's background layer in Remotion, with the 2D visualization/portrait retained as foreground — so the cut reads "2D you watch → 3D you see → back to 2D."

---

## Gap (current state vs. ideal)

| Area | Current state | Gap |
|---|---|---|
| **Format / render engine** | 9:16 Remotion (migrated) | ✅ Done |
| **Story engine** | Multi-lead, moment-driven, flexible 3–6 beats, 2–4 featured Doubles | ✅ Done |
| **Voice** | `eleven_v3` warm @ 1.5× | ✅ Done |
| **Language / character** | Plain marketer-simple + who-they-are/why woven in | ✅ Done |
| **Duration / pauses** | Day-2 86.7s PASS, Day-3 PASS — all gates green (2026-07-01) | ✅ Done |
| **Per-cast assets** | Supabase `trailer_asset` registry read at render (C3) + baseline-cohort fallback (B3) | ✅ Done |
| **End card** | `questionToUrlTakeover` wired with producer's `dramatic_question` + day-episode phases | ✅ Done |
| **Validators** | 9:16, LUFS, duration, word, scene, narration-fit, asset-presence, editorial-motion done | ✅ Done (C2); editorial-motion soft per SOT — Day-2 scores 2.8/min vs 16/min floor |
| **2D→3D blend** | B1 manual clip slot + B2 location + B5 grammar done; B4 automation fast-follow | ⏳ B1/B2/B5 done; B4 pending |
| **Day-2+ validation** | Day-2 & Day-3 both pass all gates; cast rotates across days; "Previously on" bridge works (producer-chosen, optional) | ✅ Done |
| **Comprehension gate** | Never run | ❌ Pending (D1) |

---

## Status & implementation notes

### A. Story & polish

- **A1. Day-2 + Day-3 renders validated — ✅ Done (2026-07-01).** Day-2 = `overview_day2&013` (86.7s, all 7 gates PASS); Day-3 = `overview_day3&002` (all gates PASS, cast rotated Owen/Vincent/Alex → Max/Ivan/Alex). Fix landed: the Narration Writer's word budget now reserves the composed intro-card words, each beat carries an explicit MAX-word cap in the prompt, and over-length retries feed back the exact word count with a hard rewrite target (`video/showrunner.py`). The "Previously on" bridge is producer-chosen and optional — Day-2 used it, Day-3 didn't; both valid. Pending owner watch-through to confirm the renders read well (the human half of A1).

### B. The 2D→3D blend (the "matrix" north-star)

- **B1. Manual clip drop-in — ✅ Done (2026-07-01).** Convention: `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4`. `build_day_remotion_props.py` resolves it per arc beat (pressure/world/turn), stages the clip into the Remotion render dir, and uses it as the beat's `video` prop — overriding the generic opener loop when present, falling back when absent. Sim_code and day are derived from the trailer dir path. Covered by `video/test_moment_clip_dropin.py` (5 tests, 24/24 green). **First-merge scope accepts manual drop-in; B4 automation is a fast-follow.**
- **B2. Surface event location — ✅ Done (2026-07-01).** Location is parsed from timeline action strings (`@ world:sector:arena:tile` → sector as friendly name) via `_location_from_action` + `_resolve_beat_location` in `showrunner.py`. Arc scenes in `_stitch_overview_script` now carry a resolved `location` field; `build_day_remotion_props.py` passes it as `locationLabel` on pressure/world/turn beats. No maze loading needed — the address is already in the action text. Covered by `video/test_location_resolver.py` (7 tests). Unlocks on-screen location captions and feeds the B4 clip prompt's environmental description. Existing Day-2 script.json has empty locations (pre-B2); next render populates them.
- **B3. Resolve forked-cohort persona photos — ✅ Done (2026-07-01).** `_resolve_hero_path` now falls back to the baseline cohort by `agent_id` when the fork-named `hero/<fork-slug>/` folder is absent. Baseline is resolved by walking `double.simulations.parent_simulation_id` in Supabase to the root baseline (cached per sim). For `20260628-4` → `soul15_seed_20260224`. Covered by `video/test_hero_baseline_fallback.py` (4 cases, 13/13 tests green). Restores realistic Doubles to the cast panel and gives the clip generator its character references.
- **B4. Automate Grok Imagine clip generation — fast-follow (post-merge).** New `generate_moment_clips.py`: for each arc beat with a known location (B2) + featured Doubles (B3) + action description, resolve the location plate + persona photos, call Grok Imagine, output a 1–2s `.mp4` into the B1 path. Cache per `(sim, day, beat)`. API facts locked from docs: `POST https://api.x.ai/v1/videos/generations`, model `grok-imagine-video`, `Bearer $XAI_API_KEY`, duration 1–15s, `aspect_ratio: "9:16"`, `resolution: "720p"`, async polling via `request_id`. **Design wrinkle:** image-to-video takes ONE source image; our plate + multiple Double photos need either (a) pre-compositing into one 9:16 still then animating, or (b) the reference-to-video endpoint. Start with (a); escalate to (b) if composited clips don't read cinematic enough.
- **B5. Creative blend grammar — ✅ Done (2026-07-01).** `video/daily/daily-2D-3D-blend.md` documents: which beats are clip-eligible (1–3 per day, arc beats only; establishing layer stays 2D), the two transition types (camera dive 2D→3D, pixel fracture 3D→2D), continuity rules (location/pose/lighting match), clip sourcing (B1 manual → B4 automated), and the visual-rhythm target (clips lift the daily from 2.8/min toward 6–8/min, not the opener's 23.5/min — the daily is a slower format by design). Three open creative questions flagged: clip aspect ratio (16:9→9:16), clip audio (recommend silent), clip repetition (recommend no).

### C. Opener-stack alignment (remaining)

- **C1. End card — ✅ Done (was already wired before this round).** `build_day_remotion_props.py:262-288` already uses the opener's `questionToUrlTakeover` with the producer's `dramatic_question` as the hook and day-episode phases. Tests assert the phases exist. The original TODO's "static DAY N ENDS card" gap was outdated.
- **C2. Validator — editorial-motion + asset-presence gates — ✅ Done (2026-07-01).** Two new gates in `validate_trailer.py`: `_check_asset_presence` (cross-references scene hero_path/sketch_path against disk; hard-fails on missing files, reports arc scenes with no asset) and `_check_editorial_motion` (samples frames at 2fps, measures visual-change rate ≥16/min + near-static intervals ≤2.5s per SOT §9.2). Both soft/non-blocking initially per SOT guidance. Covered by `video/test_validate_c2_gates.py` (5 tests). **Finding:** Day-2 scores 2.8 visual changes/min (opener ref ~23.5/min) with a 61.5s near-static stretch — the daily trailer is dramatically more static than the opener. The gate reports it; the threshold is not lowered to hide it. The 2D→3D blend (B) is one lever to lift this; intra-card motion improvements are the other.
- **C3. Supabase `trailer_asset` read at render time — ✅ Done (2026-07-01).** New `video/trailer_asset_store.py` module (was referenced by registration/validation scripts but didn't exist on disk) provides `get_asset(sim_code, persona_id, asset_type)` querying `double.trailer_asset`. The `_hero()` helper in `showrunner.py` now tries Supabase first (via `_resolve_hero_from_trailer_asset`, which queries the baseline cohort's `hero_spotlight` row by persona_id and resolves via `metadata.local_path`), then falls back to the fork-named cohort folder, then the baseline-cohort agent_id folder. Covered by `video/test_trailer_asset_read.py` (6 tests). Resolution order: Supabase registry → fork cohort folder → baseline cohort folder → None.

### D. Gates & merge

- **D1. 5-viewer comprehension gate — pending (manual; run after A1 watch-through).** On a passing Day-2 render, 4/5 viewers must name after one watch: the lead(s), the dramatic question, who went home & why (elimination days), and what changes tomorrow. Panel selection deferred until owner confirms A1 renders read well. Runbook, not code: pick 5 viewers (mix: 1 cold, 3 who've seen the opener, 1 close to product), show the final MP4 once with no pauses, capture answers via a 5-question form, score against the rubric.
- **D2. Merge `ivan/daily-trailer` → `main` — pending.** Standard ff-only protocol (see `git-workflow` rule). First-merge scope: A1 + B2 + B3 + B1 + B5 + C2 + C3 + D1 + D2. B4 (automation) is the only fast-follow. **All code work complete — only D1 (manual watch-through) and D2 (merge) remain.**

---

## Locked decisions (don't re-litigate)

- **Multi-lead counts:** soft target 1–3 moments / 2–4 featured Doubles; producer flexes within guardrails, no hard rejection (2026-07-01).
- **Day-1 intro:** daily-specific concept-reset card styled like the opener (option b). Daily is a self-contained episode every day; the opener is **not** the Day-1 trailer (2026-07-01).
- **Voice:** `eleven_v3` warm @ 1.5×, matching the opener (2026-07-01).
- **Duration:** [C] survival daily **<120s**; validator band **60–120s** (SOT L10, 2026-07-02). *[B] `day_normal` target 60–90s when that contract ships (SOT L9).*
- **Pauses:** opener-matched ~0.15s per scene, ~3s total (2026-07-01).
- **Language:** plain marketer-simple, no abstractions; weave who-they-are/why into each Double's first mention (2026-07-01).
- **Persona ranker:** honors `--top N` as a minimum; the producer decides the actual featured-Double count (quiet-day fallback removed, 2026-07-01).

---

## How to run

```
python -m video.generate_trailer <sim> --mode day_overview --day N --top 3 --voice-profile warm
```

Pipeline: extract (Supabase or cached `day_log.json`) → two-stage narration (LLM, cached) → TTS (ElevenLabs warm @ 1.5×) → Remotion 9:16 render → validate. **No API Gateway or frontend needed at render time** — the `day_overview` path skips Phaser recording; after the first Supabase extract (or with a cached `day_log.json`), everything runs over local files.

---

## Current architecture (reference for the team)

**Two-stage narration** (both cached per day so hand-edits survive re-render; keys `day_overview_story_v3`, `day_overview_narration_v6`):
- **Stage 1 — Day Story Producer:** thesis, featured Doubles, dramatic question, status deltas, flexible beat plan (3–6 beats from a vocabulary) from the full day's context.
- **Stage 2 — Narration Writer:** the whole voiceover in one pass, threaded across the featured Doubles with connective tissue, plus a one-line on-screen caption per beat.

**Beat vocabulary** (producer picks 3–6): `yesterday_scar` (Day>1, beat #1), `today_pressure`, `apparent_plan`, `countermove`, `vote_reveal` (elimination days) / `pressure_peak` (non-elimination days — mutually exclusive), `new_imbalance` / `unresolved` (cliffhanger close). `concept_reset` + `cast_intro` are auto-prepended (not producer-chosen).

**Establishing layer:** Day-1 = concept-reset + one cast-intro per Double (~24s). Day ≥2 = brief concept+cast touch (~12s) + `yesterday_scar`. Composed (not recorded) over realistic cohort images.

**Render path:** `generate_trailer --mode day_overview` → `render_day_remotion.render_day_trailer()` → `build_day_remotion_props.build_day_props()` → shared `OpenerTrailer` Remotion composition (same as opener). Beats map to opener components via `_BEAT_TYPE` (e.g. `vote_reveal`/`countermove`→`turn`, `today_pressure`/`pressure_peak`→`pressure`).

**Brand discipline (every narration line):**
- Forbidden: "simulate", "agent", "AI twin", "AI version", "digital copy" — except the locked Day-1 concept line: *"They are not game characters. They are Doubles — AI versions of real people, making choices no one wrote for them."*
- Concrete and observable: name who did what, to whom, where. No invented motive. No raw step numbers / scene IDs.
- End on a question, fact, or rising tension. "Doubland" = two syllables.

---

## Key files

- `video/generate_trailer.py` — orchestrator + CLI.
- `video/extract_day_log.py` — `extract_day_overview` (protagonists, shared timeline, trigger events, prior-day recap, sketch_path resolution). **No `location` field yet (TODO B2).**
- `video/showrunner.py` — two-stage prompts, beat vocabulary, establishing layer (`_stitch_overview_script`, `_resolve_hero_path`), duration/word bounds, pauses.
- `video/persona_ranker.py` — ranks personas by storyline potential; honors `--top N`.
- `video/build_day_remotion_props.py` — maps daily scenes → opener Remotion beat types; stages portraits/assets. **`video` prop currently points to generic opener loops (TODO B1).**
- `video/render_day_remotion.py` — builds props + calls shared Remotion render.
- `video/validate_trailer.py` — quality gates (9:16, LUFS, duration per type: [A] ~50–75s · [B] 60–90s · [C] 60–120s, word 130–175, scene count, narration-fit).
- `video/remotion/src/` — shared Remotion components (`OpenerTrailer.tsx`, `beats/AnyaBeats.tsx` with `BgVideo`/`OffthreadVideo`, `QuestionToUrlTakeover.tsx`, etc.).
- **Assets:** `video/assets/village/interior/` (39) + `exterior/` (6) — location plates (unused, TODO B2); `video/assets/cohort/soul15_seed_20260224/` — baseline cohort photos (TODO B3); `video/assets/users/sketches/<uuid>.png` — sketch portraits (current fallback).
- **Opener asset staging:** `video/asset_manifest.py`, `video/build_opener_remotion_props.py`.

---

## History

**Why two-stage narration:** v1 wrote each scene's narration in a separate pass that saw only its own character's event log → seven disconnected "character does X at location Y" captions, no arc, no payoff. A reality-TV consult (Burnett/de Mol/Parsons lenses) set the fix: author the whole day's narration in one pass with full context, explicit connective tissue, and a named cliffhanger. That consult also set the daily-cadence runtime target and the 5-viewer comprehension gate.

**Obsoleted:** the `20260528-1` Day-1 review defects (full-name VO, grey overlay highlight, end-card timing) were FFmpeg-render-specific and are obsoleted by the Remotion migration + the first-name VO rule (now in the narration writer). The legacy 16:9 FFmpeg/Phaser path (`compose_trailer.py`, `record_scenes.py` for daily) is retired for `day_overview`.
