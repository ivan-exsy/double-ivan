# Day-Overview Trailer — Spec & Status

> Daily simulation-day recap trailers (Episode 1, 2, 3… at 18:30 owner-local, per `D:\Coding\double-docs\20260519_LIVE_mode.md`). Reuses the shipped opener pipeline.
> **Engineering ref:** `D:\Coding\double-ivan\video\video_PRD.md` §2.2 · **Creative ref:** `D:\Coding\double-ivan\video\video_playbook.md` §3.
> **Status:** v3 on `ivan/dev`. Day-1 path renders end-to-end and passes all validators. **Last updated: 2026-05-29.**

---

## Status

The Day-1 path is complete and validated (latest render: `20260528-1` day 1 — `trailer_16x9.mp4` 140.7s, all 5 validator checks pass). Day-2+ and the viewer-comprehension QA gate are the remaining gates before merge to `main`.

---

## Architecture

One command:

```
python -m video.generate_trailer <sim> --mode day_overview --day N --top 3
```

Pipeline: **extract → two-stage narration → TTS → record (Phaser) → compose → validate.**

### Narration — two-stage (one lead per day, one continuous voiceover)

- **Stage 1 — Day Story Producer:** decides thesis, lead, dramatic question, status deltas, and the per-beat plan from the full day's context.
- **Stage 2 — Narration Writer:** writes the whole VO in one pass (threaded with connective tissue) plus a one-line on-screen caption per beat.

Both cached per day so hand-edits survive re-render (`scope=day`; keys `day_overview_story_v2`, `day_overview_narration_v3`).

### Beat template (the day arc)

`today_pressure → apparent_plan → countermove → vote_reveal → new_imbalance`.
Day 1 drops `yesterday_scar`; non-elimination days swap `vote_reveal/new_imbalance → pressure_peak/unresolved`.

### Establishing layer (Day 1 only)

Prepended before the arc: a **concept-reset** card + **one cast-intro per Double**. Composed (not Phaser-recorded) over the realistic cohort hero images; intro lines derive from the producer's status-delta. Day ≥ 2 uses `yesterday_scar` + the "Previously on…" bridge instead.

### Composition

- **Opening title:** clean DOUBLAND wordmark still (`opening_wordmark-no-h2.png`) with season + episode in the band below the underline. No mask box. (Opener trailers keep the motion push-in.)
- **Cast intros:** cohort hero image backdrop + name + intro line.
- **Arc scenes:** Phaser footage + gold card border + AI caption (lower-center) + the Double's sketch portrait in an alternating top corner with a name tag.
- **End card:** brand end card (cohort + "DAY N ENDS" + watch CTA + cadence), stretched by a tail guard so the full VO never truncates.
- **Runtime:** ~125–145s on Day 1 (incl. establishing layer); ~110s on Day ≥ 2.

### Brand discipline (every line)

- Forbidden: "simulate", "agent", "AI twin", "AI version", "digital copy" — except the allowed trailer-only line: *"They are not game characters. They are Doubles — AI versions of real people, making choices no one wrote for them."* (used as the Day-1 concept reset).
- Concrete and observable: name who did what, to whom, where. No invented motive or emotion. No raw step numbers / scene IDs.
- End on a question, fact, or rising tension. "Doubland" = two syllables ("double" + "land").

---

## Implemented

- Two-stage narration + fixed beat template, day-scoped narration cache.
- Guardrails: brand discipline, no step-number leak, no over-claiming, vote-outcome named, every beat opens on a full first name.
- **Opening title card:** clean wordmark, season + episode, no mask/overlap.
- **Scene captions:** AI-written "First name + action" caption per arc scene + alternating-corner sketch portrait with name tag (replaced the old "LABEL / Name" production text).
- **Establishing layer (Day 1):** concept reset + cast intros, composed over realistic cohort hero images.
- **No truncation:** unbudgeted micro-reset removed (folded into the budgeted concept-reset scene); compose tail guard fits the full VO; runtime/word/scene-count bounds in lockstep (showrunner ↔ validator).
- End-card cohort/episode field alignment.

---

## Pending

- **Day-2+ elimination render** — confirm the Day ≥ 2 path (`yesterday_scar` + "Previously on" bridge, no establishing layer).
- **5-viewer comprehension test** (QA gate): after one watch, can viewers name the lead, the dramatic question, who went home & why, and what changes tomorrow? Needs 4/5 to pass before merge.
- **Day-2+ rotating product cue** — Ivan locks the text; small follow-up.
- **Sub-second caption/subtitle timing** from `narration_timing.json` (optional polish; captions are currently per-scene).
- **Arc VO/video sync** (optional): a long arc voiceover can run a few seconds into the end card — tail-guarded (no truncation), but conforming arc clip durations to `narration_timing.json` would tighten it.
- **Merge `ivan/dev` → `main`** after the Day-2 render + viewer QA.

---

## Key files

- `video/generate_trailer.py` — orchestrator + CLI (skips recording/compose-guard for `composed` scenes).
- `video/extract_day_log.py` — `extract_day_overview` (protagonists, shared timeline, trigger events, prior-day recap, sketch_path resolution).
- `video/showrunner.py` — two-stage prompts, beat template, establishing layer (`_stitch_overview_script`, `_resolve_hero_path`), bounds.
- `video/compose_trailer.py` — brand open, scene cards (caption + portrait), establishing clips, scene-type dispatch, tail guard.
- `video/record_scenes.py` — Playwright capture (skips `composed` scenes).
- `video/validate_trailer.py` — quality gates (duration, word count, scene count, narration-fits-video).
- Assets — `video/assets/cohort/hero/<cohort>/` (realistic per-persona images), `video/assets/users/sketches/<uuid>.png` (sketch portraits), `video/assets/production/brand/opening_wordmark-no-h2.png` (clean wordmark).

---

## Appendix — why two-stage (history)

v1 wrote each scene's narration in a separate pass that saw only its own character's event log → seven disconnected "character does X at location Y" captions, no arc, no payoff. The fix (confirmed by a reality-TV consult, Burnett/de Mol/Parsons lenses): author the whole day's narration in one pass with full context, one lead per day, explicit connective tissue ("but", "by nightfall", "what none of them knew"), and a specific named cliffhanger. That consult also set the daily-cadence runtime target and the 5-viewer comprehension gate above.
