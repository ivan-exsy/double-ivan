# Day-Overview Trailer — PRD + Execution Playbook

> **Leveraging the shipped opener pipeline (`20260501_opening-trailer.md`) for daily simulation-day story trailers (Episode 1, 2, 3, … at 18:30 owner-local per `D:\Coding\double-docs\20260519_LIVE_mode.md`).**
> **Audience:** Engineering + Creative leads.
> **Engineering reference:** `D:\Coding\double-ivan\video\video_PRD.md` §2.2. Creative reference: `D:\Coding\double-ivan\video\video_playbook.md` §3.
> **Status:** v1 (MVP) shipped 2026-05-01. v2 rebuilt on branch `ivan/day-overview-v2` post Reality-TV expert consult; **code complete, in verification — NOT yet merged.**
> **Original draft:** 2026-05-14. **Last updated:** 2026-05-26.

---

## Status at a glance — 2026-05-26

**v2 on branch `ivan/day-overview-v2` — code complete, awaiting verification + viewer QA, then merge.**

### ✅ DONE (on branch)

- Reality-TV expert consult (Burnett / de Mol / Parsons lenses) — see Appendix A.
- **Two-stage narration architecture:** **Day Story Producer** (decides thesis / lead / dramatic question / status deltas / beat plan) → **Narration Writer** (one continuous-story pass).
- **Fixed 6-beat template:** `yesterday_scar → today_pressure → apparent_plan → countermove → vote_reveal → new_imbalance`. Non-elimination days fall back to `pressure_peak / unresolved`. `yesterday_scar` dropped on Day 1.
- **Runtime retargeted to ~60–75 s** (Double's video SOT anchor), down from ~2:30–3:00.
- **Hard content rule** (no mundane action unless it reveals stakes) + over-claiming guardrail, baked into both prompts.
- **Day-1 "cast's debut" nuance** — the cold-open beat lightly grounds the lead.
- Per-beat word count made a soft advisory (was crashing the pipeline on over-tight bands).
- Narration word bounds recalibrated to the measured ~2.0 words/sec TTS pace, plus a `_check_narration_fits_video` validator backstop.

### 🟡 REMAINING (blocks merge)

- **Clean Day-1 re-render** (the 2026-05-14 render truncated the cliffhanger — root cause fixed since).
- **Day-2+ elimination-day render** to confirm the full path at the new runtime.
- **`/verify` + `/simplify` on the branch** (decide whether to run on `ivan/day-overview-v2` or post-merge on `ivan/dev`).
- **5-viewer comprehension test** (the expert's QA gate — can cold viewers name the lead, the dramatic question, who went home & why, and what changes tomorrow?).
- **Prompt-tuning pass** — narration prose still reads somewhat expository in places; informed by the 5-viewer test.
- **Merge `ivan/day-overview-v2` → main.**

---

> **⚠️ Doc structure note (2026-05-26).** Sections §0–§2 below describe the **original implementation plan** drafted 2026-05-14. The v2 architecture that was actually built on `ivan/day-overview-v2` is captured in **§3 v2 Actual Implementation (post-pivot)**. The pre-pivot v2 narrative spec (old §3 below, with the `previously_on → setup → development → turning_point → vote_fallout → cliffhanger` template) is **superseded** by §3 — kept for historical context, do not implement as written. Same applies to the old §4 composition spec where it references the pre-pivot beats. Appendix A captures the narration-quality problem and the expert consult that drove the pivot.

---

## 0. Executive Summary (original 2026-05-14 plan)

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

## v2 Actual Implementation (post Reality-TV expert consult, 2026-05-14) — **LIVE SPEC**

> This is what was actually built on branch `ivan/day-overview-v2`. Supersedes the pre-pivot §3–§5 below. See Appendix A for the narration-quality problem and the expert consult outcome that drove this pivot.

### A. Two-stage narration architecture

Single per-scene LLM calls (the v1 approach) structurally cannot build an arc — each scene sees only its own character's event log, with no awareness of what was said before or after. The fix is a two-stage pipeline where one LLM decides the day's story, then a second LLM writes the whole trailer's narration in one pass.

**Stage 1 — Day Story Producer.** Takes the full day's extracted context (all protagonists, shared timeline, trigger events, prior-day summary) and decides:
- **Thesis** — one sentence capturing today's social pivot.
- **Lead** — the day's protagonist (one persona, not three).
- **Dramatic question** — what the trailer hooks the viewer on.
- **Status deltas** — who rose, who fell, who changed alliance, who got exposed.
- **Beat plan** — the per-beat content brief that Stage 2 writes against.

**Stage 2 — Narration Writer.** Takes Stage 1's brief and writes one continuous narration script in a single pass. Sees the whole day. Threads transitions ("but," "meanwhile," "by nightfall," "what none of them knew"). Each beat does a *different* rhetorical job rather than seven captions in a row.

### B. Fixed 6-beat template

Elimination days (the default):

1. `yesterday_scar` — the unresolved wound from yesterday that today is still living with. Dropped on Day 1.
2. `today_pressure` — what's at stake today; who is exposed.
3. `apparent_plan` — what the lead (or the group) thinks is happening.
4. `countermove` — what's actually happening underneath; the betrayal or counter-alliance the lead can't see.
5. `vote_reveal` — the elimination, named, with vote count if known. Verbatim farewell quote when available.
6. `new_imbalance` — the cliffhanger: who is now exposed because of tonight's vote.

Non-elimination days fall back to `pressure_peak / unresolved` in slots 5–6.

### C. Runtime target: ~60–75 s (down from 2:30–3:00)

Anchored to Double's video SOT pacing for daily-cadence content (viewers meant to watch every single day). Industry research: 5-min recap engagement drops past 3 min; 60–75 s is the daily-habit sweet spot.

### D. Hard content rules baked into both prompts

- **No mundane action unless it reveals stakes.** "Checked the laptop," "still in bed," "rehearsed at the counter" are forbidden as standalone beats. A line about a Double doing something only ships if it tells the viewer what's *at risk* for that Double.
- **Over-claiming guardrail.** Narrator may state facts and pose questions but never asserts unsupported emotion or motive ("she felt terrified," "he had always known…" are out).
- **Day-1 "cast's debut" nuance.** The cold-open beat lightly grounds the lead since there's no `yesterday_scar` to anchor.
- **Word counts are soft advisories** (the hard bands crashed the pipeline). The `_check_narration_fits_video` validator backstop catches drift.

### E. What was deliberately dropped vs the original §3–§5 plan

The pre-pivot plan (old §3–§5 below) defined an 8-beat structure with cafe ceremony, POV/omniscient variable inserts, Today's Pressure module, thread-driven bridge cards, and persona-ranker scoring updates. None of that shipped — the two-stage 6-beat / 60–75 s architecture replaced it entirely. The cafe ceremony, variable inserts, and ranker v2 are not on the v2 roadmap; revisit only if viewer testing surfaces a specific gap they'd fill.

### F. Files touched on `ivan/day-overview-v2`

- `video/showrunner.py` — two new system prompts (Day Story Producer, Narration Writer), `_generate_day_overview_script` rewritten as the two-stage pipeline.
- `video/narration_cache.py` — `day` scope used (already infrastructure-ready from the opener work).
- `video/validate_trailer.py` — new `_check_narration_fits_video` backstop + recalibrated word bounds (~2.0 words/sec measured).
- `video/compose_trailer.py` — duration cap retargeted; minor cleanup.

---

## 3. ~~v2 Narrative Design: 6-Beat Day-Arc~~ — **DEPRECATED 2026-05-14**

> **Superseded by the "v2 Actual Implementation" section above.** The 6-beat template described in this section (`previously_on → setup → development → turning_point → vote_fallout → cliffhanger`) was the pre-pivot plan; the actual v2 build uses a different two-stage 6-beat template (`yesterday_scar → today_pressure → apparent_plan → countermove → vote_reveal → new_imbalance`) at ~60–75 s runtime. Kept for historical context.

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

## 4. ~~Composition & Visual Alignment Spec~~ — **DEPRECATED 2026-05-14**

> **Card-treatment + dynamic-stakes-montage spec below references the pre-pivot beat names (`previously_on`, `development`, `turning_point`, `vote_fallout`).** The actual v2 build uses the two-stage 6-beat template described in "v2 Actual Implementation" above. The §4.3 music-tail and §4.4 end-card guidance still apply in principle; §4.1–§4.2 do not. Kept for historical context.

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

## 5. ~~Implementation Plan~~ — **DEPRECATED 2026-05-14**

> **The 3-phase plan below was the pre-pivot estimate.** Actual implementation followed a different shape: the two-stage Producer → Writer architecture replaced the "Phase 1 — 6 system prompts" step entirely; Phase 2 composition polish wasn't needed at the new ~60–75 s runtime; Phase 3 QA is captured in "Status at a glance" above (clean Day-1 re-render + Day-2+ elimination render + 5-viewer test). Kept for historical context.

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

**Ready for implementation.** Branch: `ivan/day-overview-v2`. Target ship: 2026-05-19. **Actual:** code complete; merge gated on the §"Status at a glance" remaining items.

---

*References:*
- Opener playbook & asset commissions: `D:\Coding\double-ivan\done\20260501_opening-trailer.md`
- Video engineering contract: `D:\Coding\double-ivan\video\video_PRD.md`
- Video creative spec: `D:\Coding\double-ivan\video\video_playbook.md`
- LIVE-mode framing (Episode 1, 2, 3… at 18:30 owner-local): `D:\Coding\double-docs\20260519_LIVE_mode.md`
- Latest opener artifact: `data/20260513-1/opener&001/`

---

## Appendix A — Narration-Quality Problem + Reality-TV Expert Consult (history)

*Captured here as the historical record that drove the v2 pivot. Originally filed as `20260514_day-overview-narration-brief.md`; merged into this doc 2026-05-26.*

### A.1 The problem (with real examples) — ✅ ADDRESSED

The v1 day-overview narration felt **punctuated and uneven** — seven self-contained captions rather than one story. Here is a real generated output (Day 2, an elimination day, 3 characters: Gosha, Luba, Katya):

> 1. *Yesterday, Ivan Pistsov goes home — three votes. Gosha wakes alone in the dorm, planning the next move.*
> 2. *Gosha wakes at eight p.m., still in bed — plan notes unfinished. He should meet Luba by the cafe to swap final ballots. Can he hold the centre tonight?*
> 3. *Luba checks the laptop for challenge notes and the calendar. She types a reminder: meet Gosha in ten. She folds her plan into a compact promise — back him at the vote tonight. Can she keep that quiet?*
> 4. *Katya reviews the token plan at the table. She rehearses the pitch under her breath. She tells Luba they'll stick together if voting starts — steady, low, certain.*
> 5. *Luba rehearses a quiet negotiation pitch at the counter. She practices wording that keeps Gosha safe — and keeps her options open. At 11:00 she locks eyes with Gosha; the plan shifts in three words. Will their pact hold at the vote?*
> 6. *Gosha rehearses his negotiation points at the window, finalizing who he'll back. Twenty minutes later the vote lands — Gosha Pistsov is eliminated by two votes.*
> 7. *Katya studies her notes at the piano, mapping contingency moves. Her breath tightens. Luba waits nearby. The vote closes in.*

**What's wrong with it:**

- **Every beat is the same kind of statement** — "Character does a small action at a location." Seven of them in a row. No variety of rhetorical function.
- **No thesis, no payoff.** The day has a real arc (alliance, betrayal, elimination) but the narration never *states* the stakes or *builds* to them — it just lists.
- **No connective tissue.** No "but," "meanwhile," "by nightfall," "what none of them knew." Each line is an island.
- **It narrates logistics, not drama.** "Checks the laptop for challenge notes," "types a reminder," "still in bed" — these are the literal event-log entries. A trailer narrator should be telling us what it *means*, not what was clicked.
- **The climax lands flat.** The elimination — the single biggest moment of the day — is delivered in the same even tone as "Luba checks the laptop."
- **Accidental repetition.** "Gosha wakes / Gosha wakes / Luba rehearses / Gosha rehearses / Katya studies" — same verbs, by accident.

**Root cause (technical).** Each scene's narration was written by a *separate* generation pass that saw only its own character's raw event log — not the other scenes, not what was said before or after. Structurally no way to build an arc, thread transitions, or vary rhetoric. By construction: seven captions.

### A.2 What the opening trailer got right (the contrast)

The **opening-trailer** narration for the same cast — which works:

> *They're family. In Doubland, their Doubles have to survive each other.*
> *Four Doubles enter a village. Every day brings pressure and escalating stakes. Every night, they vote one of their own out.*
> *Gosha is reliably kind. That makes him the teammate everyone trusts; it also makes him the person others can quietly trade favors through — and betray when it counts.*
> *(…)*
> *This is the moment family rules meet the format. The vote. Where loyalty becomes math and you must choose to outlast the brother or outlive the daughter you love.*

**Why this works — and what transferred:**

1. **Each beat does a *different* job.** Premise → format explainer → character turns → stakes statement → question hook → call to action. No two beats are the same kind of sentence.
2. **There's a thesis, and it pays off.** "They're family / have to survive each other" is planted in line 1 and cashed in later.
3. **Explicit dramatic connectors** thread the beats.
4. **It's about essence and stakes, not logistics.**
5. **Repetition is a chosen device, not an accident.**

The fix hypothesis (confirmed by the expert consult): **author the day-overview narration as one continuous piece with full story context** — one pass that sees the whole day and writes a single throughline with setup → escalation → turn → payoff — instead of seven blind captions. And push content from "what they did" toward "what it meant."

### A.3 Expert consult outcome (Burnett / de Mol / Parsons lenses, 2026-05-14) — ✅ DONE

Twelve questions were sent to external reality-TV / trailer-editorial consultants covering structure & arc, voice & content, cast & cadence, craft guardrails, and reactions to the example narrations. The consult answers fed directly into the two-stage Producer → Writer architecture and 6-beat template captured in "v2 Actual Implementation" above.

Headline takeaways that drove design:
- **~60–75 s** is the right runtime for a daily-cadence recap (5-min is too long for a habit-loop format).
- **Omniscient narration** stays, but lines must be earned by stakes (not logistics).
- **One lead per day**, others orbit — avoids fragmenting into three mini-stories.
- **A continuous-story pass** is the only structural fix for the seven-captions problem.
- **Connective devices** ("but," "meanwhile," "by nightfall," "what none of them knew") are non-negotiable.
- **The cliffhanger** must name a *specific* unresolved tension, not generic "tomorrow…"
- **Repetition becomes rhythm only when chosen**, never accidental.

### A.4 QA gate inherited from the consult

The expert specified a **5-viewer comprehension test** as the QA gate (still pending — see "Status at a glance"). Cold viewers should, after one watch, be able to name:
1. The lead.
2. The dramatic question.
3. Who went home and why.
4. What changes tomorrow.

If any of those four answers don't land for 4+ of 5 viewers, the prompt-tuning pass is required before merge.