# PRD: Day-Overview Trailer v2 — Dramatic Daily Recaps

> **Leveraging the shipped opener pipeline (20260501_opening-trailer.md) for simulation-day story trailers.**  
> **Audience:** Engineering + Creative leads.  
> **SOT:** `D:\Coding\double-docs\sot\sot_video.md` (video pipeline contract) + `video_PRD.md` §2.2.  
> **Status:** v1 (MVP) shipped; v2 spec approved 2026-05-14; implementation queued.  
> **Author:** Ivan (architectural draft from analysis session).  
> **Date:** 2026-05-14

---

## 0. Executive Summary

The opening-trailer pipeline (5-beat structure, Burnett 6-beat narration with cache, commissioned asset buckets, composition layers, and Playwright capture) already solves the hardest parts of turning raw simulation data into cinematic, brand-consistent story content.  

Day-overview trailers (the "simulation-day recap" format) are the natural next application. A targeted v2 uplift reuses 70-80% of the opener work to deliver dramatic, watchable daily recaps that feel like "mini-openers" — same voice, same card treatment, same stakes language — while using the day's actual footage instead of static flyovers.

**Outcome:** Every simulation day automatically gets a polished 2:30–3:00 trailer with prior-day bridge, rising action, key conflicts, vote fallout, and tomorrow tease. One unified `--mode day_overview` command. Minimal new code; maximum reuse.

---

## 1. Current State (v1)

| Aspect | Opener (shipped, polished) | Day-Overview (MVP) | Gap |
|--------|----------------------------|--------------------|-----|
| Narrative engine | 6-beat Burnett (cold_open → format_lock → 4×cast_intro → pressure → vote_dread → habit_hook) with `narration_cache` + brand discipline | 5-6 scene roles (previously_on / setup / development×N / council_vote / cliffhanger); flat spine + per-scene LLM | No cache, weaker dramatic arc, no brand-voice lock |
| Visual language | Trading-card frames, sketch→sprite expand/minimize timed to VO, exact-once walkouts, music tail fade | Basic scene cards; no card-grid roster or timed sprite sync | Inconsistent brand experience |
| Asset reuse | Per-village (exteriors/interiors), per-cohort (sketches/sheets/walkouts), per-archetype (frames/stings) all commissioned | Same buckets available but under-used | Day-specific highlight clips exist but not sequenced into stakes montage |
| Extraction | `extract_opener_context` (Day-0) | `extract_day_overview` (rich: protagonists[], shared_timeline, trigger_events, prior_day_summary) | Already stronger context for day recaps |
| Composition | Cold-open card, cast-intro grid, stakes flyovers, single end card | "Previously on…" bridge + flat scenes | Missing dynamic stakes montage and card timing polish |
| Runtime | 95–180 s (N=4→6 cohort) | 150–180 s target | Overlap is good |

**Key files (already mode-aware):**
- `video/generate_trailer.py` — orchestrator + CLI
- `video/extract_day_log.py` — `extract_day_overview` + `extract_opener_context`
- `video/showrunner.py` — `_generate_day_overview_script` (two-stage) + opener 6-beat helpers + `narration_cache`
- `video/compose_trailer.py` — mode dispatch, music ducking, 16:9+9:16 crops, end-card
- `video/record_scenes.py` + `capture_static_assets.py` — Playwright capture
- `video/assets/` — five-bucket layout (phaser/, users/, village/, cohort/, archetypes/)

---

## 2. Opportunity & Recommendation

**Do a targeted v2 uplift on the day-overview path** rather than forking a new trailer type. This keeps one command surface, reuses every commissioned asset and capture path, and lets the dramatic quality of the opener "lift" daily recaps immediately.

**Trade-offs:**
- Speed to value: 3–5 days (mostly prompt + ~150 LOC composition) vs. months for ground-up day trailer.
- Risk: Low — mode dispatch and extraction are stable; only swapping narrative layer and extending composition.
- Quality outcome: Day trailers feel like mini-openers → unified brand voice across pre-sim + daily slate.
- Future-proofing: Sim-announce (last planned type) becomes trivial variant once this is done.

**Scope for v2:** Narrative 6-beat upgrade + cache layer + composition visual alignment. No new asset commissions required.

---

## 3. v2 Narrative Design: 6-Beat Day-Arc

Replace the current generic spine + per-scene prompts with opener-grade 6-beat structure that honors `prior_day_summary` and `trigger_events`.

### 3.1 New 6-Beat Roles (spine output)
1. `previously_on` — REQUIRED on Day > 1 (10 s). Recaps yesterday's elimination. Driver: highest-rank alive protagonist.
2. `setup` — REQUIRED (12–18 s). Morning stakes from top protagonist's POV.
3. `development` — 2–3× (20–30 s each). Key moments; each protagonist drives at least one.
4. `turning_point` — REQUIRED (20–30 s). Conflict peak / betrayal.
5. `vote_fallout` — REQUIRED on elimination day (20–30 s). Names eliminated + margin.
6. `cliffhanger` — REQUIRED (8–15 s). Tomorrow tease. Driver: highest-rank alive.

Total 5–6 scenes, 150–180 s runtime.

### 3.2 Brand-Voice Discipline (shared with opener)
```
BRAND VOICE DISCIPLINE (applies to every line):
- FORBIDDEN: "simulate", "agent", "AI twin", "AI version", "digital copy"
- Concrete, plain, observant. Trust nouns and verbs. Name who did what, to whom, where.
- End on a question, fact, or rising tension — never flourish or moral.
- "Doubland" pronounced as two clear syllables ("double" + "land").
```

### 3.3 Draft System Prompts (ready to paste into `showrunner.py`)

```python
DAY_OVERVIEW_BRAND_DISCIPLINE = """
BRAND VOICE DISCIPLINE (applies to every line):
- FORBIDDEN: "simulate", "agent", "AI twin", "AI version", "digital copy"
- Use only the cohort's actual names and the season title from context.
- Concrete, plain, observant. Trust nouns and verbs. Name what happened — who did what, to whom, where.
- End on a question, a fact, or rising tension — never a flourish or moral.
- Pronunciation: "Doubland" must sound like "double" + "land" (two clear syllables).
"""

DAY_OVERVIEW_PREVIOUSLY_ON_SYSTEM = (
    "You write the 'Previously on…' bridge narration for a daily reality-TV recap trailer. "
    "Voice: calm, intimate, slightly conspiratorial. Quote the prior_day_summary closely. "
    "One sentence max. Output ONLY the line."
) + DAY_OVERVIEW_BRAND_DISCIPLINE

DAY_OVERVIEW_SETUP_SYSTEM = (
    "You write the morning-setup / today's-stakes narration beat for a daily recap trailer. "
    "Voice: surveillance-documentary, TikTok pace. Introduce the day's pressure from the "
    "highest-ranked protagonist's POV. One tight paragraph (2 lines). Output ONLY the lines."
) + DAY_OVERVIEW_BRAND_DISCIPLINE

DAY_OVERVIEW_DEVELOPMENT_SYSTEM = (
    "You write one development-beat narration block for a daily recap trailer. "
    "Focus on the assigned protagonist's key moment (use their timeline/conversations/reflections). "
    "Voice: concrete, active, present tense. 2-3 lines, 50-70 words total. "
    "End on rising tension. Output ONLY the narrator_lines array."
) + DAY_OVERVIEW_BRAND_DISCIPLINE

DAY_OVERVIEW_TURNING_POINT_SYSTEM = (
    "You write the turning-point / conflict-peak narration for a daily recap trailer. "
    "Voice: ominous-intimate. Name the decisive action or betrayal. One paragraph. "
    "Output ONLY the line(s)."
) + DAY_OVERVIEW_BRAND_DISCIPLINE

DAY_OVERVIEW_VOTE_FALLOUT_SYSTEM = (
    "You write the vote/elimination fallout narration for a daily recap trailer. "
    "Voice: cool, knowing. Name the eliminated persona and the vote margin if known. "
    "One sentence. Output ONLY the line."
) + DAY_OVERVIEW_BRAND_DISCIPLINE

DAY_OVERVIEW_CLIFFHANGER_SYSTEM = (
    "You write the single closing cliffhanger line for a daily recap trailer. "
    "Voice: confident, intimate, opt-in. Tease tomorrow's tension without spoiling. "
    "This is the LAST thing viewers hear. Output ONLY the line."
) + DAY_OVERVIEW_BRAND_DISCIPLINE
```

**Cache pattern (identical to opener):**  
Each artifact uses `get_or_generate(sim_code, day=day, artifact_key=f"day{day}_previously_on", ...)` so hand-edits persist across re-renders. Per-protagonist development beats remain dynamic.

---

## 4. Composition & Visual Alignment Spec (One-Page)

**Goal:** Day-overview trailers become visually indistinguishable from openers in brand language while using live day footage.

### 4.1 Card Treatment (reuse opener logic)
- `previously_on` scene → full-screen protagonist card expand on first VO word, minimize on last word (exact timing from 20260513-1 feedback).
- Each `development` / `turning_point` scene → trading-card frame + sketch portrait crossfade (same as cast_intro), then day's actual clip instead of sprite walkout.
- `vote_fallout` → same card treatment, tinted red for elimination.

### 4.2 Dynamic Stakes Montage
- Replace static `establish_*.png` + fly-over MP4s with 4–5 short clips pulled from the day's `shared_timeline` high-impact steps (already captured by `record_scenes.py`).
- Sequence: morning tension → midday conflict → evening vote → night fallout → cliffhanger tease.

### 4.3 Music & Audio
- Same anthem + archetype stings as opener (already commissioned in `video/assets/archetypes/`).
- 5-second music tail fade after final VO line (expose the helper already wired for openers).

### 4.4 End Card
- Single card: "Day N ends — New trailer daily at 6:30 PM" (Round 3 closer treatment, already shipped for openers).

### 4.5 Files Touched (minimal)
- `video/showrunner.py` — add 6 system prompts + cache wrappers (~60 LOC).
- `video/narration_cache.py` — one-line key-naming extension for `day_overview_day{N}_*`.
- `video/compose_trailer.py` — extend `_compose_day_overview` path for card timing, dynamic montage, music tail (~80–100 LOC).
- `video/record_scenes.py` — no change (existing capture path sufficient).

---

## 5. Implementation Plan

**Phase 1 — Narrative v2 (1 day)**
- Paste 6 new system prompts + `DAY_OVERVIEW_BRAND_DISCIPLINE`.
- Wire cache calls in `_generate_day_overview_script` (mirror opener helpers).
- Update spine validator to enforce new 6-beat roles and focal_step rules.

**Phase 2 — Composition Polish (2 days)**
- Card expand/minimize timing helpers (pull from opener `compose_cast_intro`).
- Dynamic stakes-montage clip selection from shared_timeline.
- Music tail + end-card unification.
- 9:16 crop + subtitle timing parity check.

**Phase 3 — Test & QA (1–2 days)**
- Render on `base_family_sim` Day 2+ (multi-day survival with votes).
- Visual QA against 20260513-1 feedback notes (card timing, exact-once playback, music fade).
- Validate narration word count (250–480), duration (150–180 s), focal_step ranges.
- Run existing `validate_trailer.py` + realism gates.

**Total effort:** 3–5 days. One engineer + creative review pass.

---

## 6. Risks & Mitigations

- **Risk:** Cache key collision between opener and day_overview.  
  **Mitigation:** Prefix all day keys with `day{day}_` + mode.
- **Risk:** Dynamic montage clips shorter than static flyovers → pacing drift.  
  **Mitigation:** Cap each montage beat at 6 s; let music carry.
- **Risk:** Prior-day summary missing on Day 1.  
  **Mitigation:** `previously_on` role is already conditional in spine prompt.

---

## 7. Open TODOs Post-v2

- TODO-14 (this doc) — close after ship.
- TODO-4 (subtitle timing from actual audio) — still open, benefits both opener and day v2.
- TODO-10 (in-browser MediaRecorder path) — orthogonal.
- Future: Sim-announce trailer (pre-sim hype) becomes trivial once this lands.

---

## 8. Acceptance Criteria

- One CLI: `python -m video.generate_trailer <sim> --mode day_overview --day N --top 3`
- Output: `data/<sim>/overview_dayN/output/trailer_16x9.mp4` + `script.json` + YouTube description with deep links.
- Visual & narrative quality parity with `20260513-1/opener&001/trailer_16x9.mp4`.
- All existing validators pass; new 6-beat structure validated.
- Hand-edited narration lines survive re-render via cache.

---

**Ready for implementation.** Branch: `ivan/day-overview-v2`. Target ship: 2026-05-19.

---

*References:*  
- Opener playbook & asset commissions: `20260501_opening-trailer.md`  
- Video engineering contract: `video_PRD.md`  
- Latest opener artifact: `data/20260513-1/opener&001/`  
- Feedback notes that informed card timing: `data/20260513-1/opener&001/script.json` (top section)