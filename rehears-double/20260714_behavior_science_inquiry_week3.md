# Expert inquiry — Week 3 interview & Double completeness (behavior science)

**To:** Behavior science / assessment specialist (Doubland team)  
**From:** Ivan / product + engineering (self-serve Double epic)  
**Date:** 2026-07-14  
**Status:** **Accepted 2026-07-14** — engineering may implement Week 3 from §9 (COS `2026-07-14-002`)  
**Epic:** `double-ivan/rehears-double/EPIC_self-serve-double.md`  
**Audience for this doc:** Subject-matter expert (not engineering). Engineering will implement your recommendations as specified.

---

## 1. Why we are asking you

We are building **self-serve “owned Doubles”**: a signed-in adult user completes a short personality path, we seed a digital persona, and they can eventually chat with **their** Double and optionally place it in a simulation.

**Engineering owns:** APIs, storage, auth, chat plumbing, sim binding mechanics, UI shells.  
**We need you to own:** assessment design, interview content, completeness criteria, ethical framing, and what “good enough to claim this is you” means scientifically/product-wise.

We will **not** invent interview questions, completeness rules, or trait-interpretation copy without your report.

---

## 2. What is already shipped (do not redesign unless you flag a problem)

| Piece | Status | Notes |
|-------|--------|--------|
| Auth + chat thread ownership | Live (local smoke) | Supabase Auth; threads stamped with `user_id` |
| Big-5 instrument | **IPIP-BFM-25** (public domain) | Locked for v1 |
| Item presentation | 25 adult situational stems + 5-point Likert | Adult retune of stems (draft); formal content sign-off still welcome |
| Scoring | Domain **means 1–5** only | Reverse keys BE-owned; **no population percentiles** (no adult norms table) |
| Labels | Coarse bands: lower / typical / higher | Cut points currently ≤2.5 / ≤3.5 / higher — **open to your revision** |
| After quiz | Profile row + short deterministic summary + linked “user’s Double” | Not clinical language in product |
| Soft demo | Pre-profiled cast agents still work **without** quiz | Locked product decision |

**User path today:** sign in → 25-item quiz → OCEAN snapshot → own a Double record.  
**Gap:** no interview yet; chat with **owned** Double as “creator” not productized; no “prediction-ready” completeness; no self-serve sim bind.

---

## 3. Product intent for Week 3 (engineering plan — content is yours)

Goal: a non-operator adult can finish a **short interview** after Big-5 so the Double is richer than five scores, then:

1. Be marked **complete enough** for “this is my Double” claims (soft vs hard gates).  
2. Chat with **their** Double in a creator-aware mode.  
3. Optionally **bind** that Double into a sim world (job/home) via existing operator pipelines wrapped for self-serve.

**Explicit non-goals for this inquiry**

- Clinical diagnosis, therapy, or medical claims  
- Teen / school instruments  
- Full scientific re-norming study for IPIP (unless you recommend a minimal responsible path)  
- Permanent second product (Rehears dual-app)  
- Replacing IPIP-BFM-25 in v1 (unless you raise a **blocking** ethical/validity concern)

---

## 4. Decisions we need from you (please answer in a short written report)

Please structure your reply so engineering can implement without reinterpretation. Prefer **concrete artifacts** (question text, scales, decision trees, copy strings) over abstract theory alone.

### A. Interview design (primary)

1. **Purpose of the interview** in one paragraph (what constructs / life domains it should capture that Big-5 does not).  
2. **Length:** recommended number of items and target completion time (we were thinking ~4–6 prompts / under ~5–8 minutes — confirm or revise).  
3. **Format per item:** free text, multiple choice, Likert, multi-select, or mix — and why.  
4. **Full item bank for v1:** final wording for each question (adult, general audience, English).  
5. **Optional branching:** if any question depends on a prior answer, specify the tree.  
6. **What must *not* be asked** (sensitive topics, clinical screening, illegal activity, etc.).  
7. **Retake policy:** can users redo interview? How does that interact with an existing Double?

### B. Mapping interview → Double “soul” fields

Our engine consumes short natural-language seeds (roughly):

| Field | Role in sim/chat (plain language) |
|-------|-------------------------------------|
| `innate` | Stable disposition / character tone |
| `learned` | Background, skills, how they see the world |
| `currently` | Present life focus / situation |
| lifestyle / goals (as used in profiles) | Day-to-day pattern and aims |

Please specify:

1. **Which interview answers map to which fields** (table: item → field → transform).  
2. Whether mapping is **deterministic templates**, **light rules**, or **you recommend LLM summarization** (if LLM: constraints, max length, forbidden claims).  
3. Example of a **complete filled profile** (fake persona) after quiz + interview so we can regression-test the adapter.  
4. How Big-5 means/labels should appear in the soul text (if at all) alongside interview content.

### C. Completeness / “prediction-ready” gate

Locked product principle: **soft** for demos; **hard** for “my Double” ownership claims.

Please define:

1. **Minimum viable complete profile** for v1 (checklist).  
2. **Soft-incomplete** user messaging (exact or near-final copy).  
3. **Hard-blocked** actions when incomplete (e.g. bind to sim, claim “my Double” in chat).  
4. Whether **quiz-only** users may still chat with cast agents (we assume yes) and with a half-seeded owned Double (your call).  
5. Any **quality** bar beyond “all fields filled” (e.g. minimum free-text length, nonsense detection — only if you recommend it for v1).

### D. Interpretation & product language

1. Safe **user-facing** framing for quiz + interview results (we currently say personality snapshot / not a clinical diagnosis — refine).  
2. Label bands for domain means: keep, change cut points, or replace with different language.  
3. Anything we should **stop saying** in UI or summaries given IPIP-BFM-25 + means-only scoring.  
4. Guidance if users ask “how accurate is my Double?”

### E. Adult IPIP stems (optional but valued)

Draft adult situational stems are live. If you have capacity:

1. Sign-off, edits, or a red-line list for any of the 25 items.  
2. Whether reverse-key set `1, 9, 10, 11, 12, 22, 25` should stay as-is for this instrument.

If you defer stems, say so explicitly; engineering will keep draft stems for integration.

### F. Risks & ethics (short)

1. Top **3 risks** of this onboarding path and mitigations (product, not legal opinion).  
2. Any **must-have** disclaimers or consent lines before interview submit.  
3. Data sensitivity: any interview answers that should be stored with higher care or not stored long-term.

---

## 5. Constraints engineering will respect

| Constraint | Detail |
|------------|--------|
| Audience | Adult / general Doubland users |
| Auth | Supabase session required for quiz/interview submit |
| Instrument v1 | IPIP-BFM-25; means 1–5; no teen percentiles |
| Storage | Doubland Supabase is SOT (not Rehears DB) |
| Soft demo | Cast sims work without onboarding |
| Deploy | No production FE/BE promote until epic sign-off |
| Timeline | We implement **after** your report; no parallel guesswork on content |

---

## 6. Deliverable we need from you

A single **recommendations report** (markdown or doc) that includes:

1. Final v1 interview item bank + formats  
2. Mapping table → soul/profile fields + 1 worked example  
3. Completeness checklist + soft/hard gate copy  
4. User-facing interpretation/disclaimer language  
5. Optional: stem sign-off or “defer” note  
6. Explicit list of **open research** items that must *not* block v1 engineering  

**Target length:** enough to implement without meetings (roughly 3–8 pages).  
**Success criterion for engineering:** we can open tickets and ship Week 3 without inventing assessment content.

---

## 7. What we will do after your report

1. Ivan reviews product fit.  
2. Engineering implements interview API + FE shell + adapter + completeness flags + creator chat prompt + thin bind path per epic Week 3.  
3. We only re-ping you if implementation hits an ambiguity in the report.

---

## 8. Contact / reply path

Reply to Ivan with the report attached or linked.  
Reference this file: `double-ivan/rehears-double/20260714_behavior_science_inquiry_week3.md`.

**Thank you** — we want the psychometric and behavioral design to be expert-led; development will follow your specification.

---

## 9. Expert recommendations — jordanpeterson (COS)

**Source:** COS task `2026-07-14-002` · specialist `jordanpeterson` (Peterson-informed; not Jordan Peterson)  
**Date:** 2026-07-14  
**Risk:** high (psychographic onboarding) — **founder approved 2026-07-14**; engineering may implement.  
**Canonical copy also at:** `d:\Coding\COS\tasks\2026-07-14-002\final.md` · KB: `agents/jordanpeterson/kb/raw/task-deliverables/2026-07-14-week3-interview-recommendations.md`

**Task:** `2026-07-14-002`  
**Specialist:** jordanpeterson (Peterson-informed; not Jordan Peterson)  
**Date:** 2026-07-14  
**Inquiry:** `double-ivan/rehears-double/20260714_behavior_science_inquiry_week3.md`  
**Status:** Draft for COS review → founder `pending_approval`

---

## Meta (epistemic posture, risk, citations basis)

| Field | Value |
|-------|--------|
| Epistemic posture | Formal claims labeled **Measured** / **Evidence-based** / **Peterson-informed** / **Agent hypothesis**. Product copy stays plain-language; this report keeps labels for engineering + founder review. |
| Risk | **High** — psychographic onboarding + “this is my Double” ownership claims for real adult users. |
| Audience | Adult Doubland users; English; general public. |
| Instrument lock | IPIP-BFM-25 stays for v1; domain means 1–5; coarse bands only; **no population percentiles**. |
| Routing used | A0 → A12 → A1, A5, A6, A7, A3; B1/B2 lightly for truth/listening/responsibility framing (not culture-war). |
| Product framing | Double as safe mirror / rehearsal — not clinical therapy (`mission.md`; A5 clinical-as-engineering is *method analogy*, not a product claim). |

**Evidence categories used below:** SELF-REPORT (quiz + interview), MEASURED (domain means from IPIP scoring), INFERRED (adapter templates / LLM compressions).

---

## A. Interview design

### A1. Purpose (one paragraph)

**Peterson-informed + Evidence-based.** The IPIP-BFM-25 quiz estimates relatively stable Big Five disposition (baseline traits ≈ sub-personalities within a diverse unity — raw/A1; raw/A12 §Trait). It does **not** capture (a) biographical background and how the person sees the world, (b) present life chapter / pressures, (c) day-to-day rhythm, or (d) near-term aims the person defines as “better.” Week 3 interview fills those gaps so ISS soul fields `learned`, `currently`, and `lifestyle` (plus a stored **goals** seed) become usable for creator chat and sim binding — matching the four-layer model: baseline traits (quiz) vs current state / aims / concrete self-description (interview) (raw/00; raw/A5). Without the interview, a Double is score-shaped, not situation-shaped.

### A2. Length (confirmed)

| Spec | v1 recommendation |
|------|-------------------|
| Items | **5 required prompts** (no optional 6th in v1) |
| Time | **~5–8 minutes** target; hard UX soft-cap ~10 minutes |
| Rationale | Short structured intake beats shallow long forms when the aim is workable structure over exhaustive coverage (raw/A5: structure beats floundering). Five items cover learned / lifestyle / currently / goals / one behavioral vignette without exceeding attention. |

### A3. Format mix (and why)

| Format | Use | Why |
|--------|-----|-----|
| Multi-select (capped) | Background lens, lifestyle rhythm | Fast, deterministic mapping, reduces blank free-text failure |
| Single-select + optional short text | Current chapter | Forces a primary “game” / chapter (raw/A5 dedication) while allowing nuance |
| Constrained free text | Near-term aim + one recent pattern | Behavioral evidence > trait adjectives alone (raw/00 interview posture; raw/A1 demand for evidence) |

**Do not use** open clinical Likert batteries in the interview (quiz already owns Likert).

### A4. Full item bank for v1 (final wording)

**Screen chrome (once, before Q1):**

> **About this short interview**  
> These five questions help your Double sound more like *your* day-to-day self—not just five personality scores. Answer as you are now. There are no right answers. This is a personality snapshot for Doubland rehearsal—not a clinical diagnosis or therapy.

**Instrument id:** `double-interview-v1`  
**Version:** `2026-07-14`

---

#### W3-I1 — Background lens → `learned`

- **id:** `w3_i1_background`  
- **format:** multi-select, **min 1 / max 3**  
- **prompt:**  
  > Which of these best describe your background and how you tend to see the world? Pick up to three.
- **options (store option ids):**

| id | label |
|----|-------|
| `bg_practical` | Practical and hands-on — I learn by doing |
| `bg_analytical` | Analytical — I like figuring systems out |
| `bg_people` | People-oriented — relationships shape how I see things |
| `bg_creative` | Creative / idea-driven |
| `bg_structured` | Structure-minded — plans, routines, and standards matter |
| `bg_explorer` | Explorer — I seek variety and new experiences |
| `bg_steady` | Steady and cautious — I prefer what has worked before |
| `bg_builder` | Builder — I care about making something that lasts |

- **optional follow-up (same screen, free text, max 280 chars, optional):**  
  > Optional: In one sentence, anything else about your background that matters?  
- **validation:** ≥1 option required; follow-up optional.

---

#### W3-I2 — Day-to-day rhythm → `lifestyle`

- **id:** `w3_i2_lifestyle`  
- **format:** multi-select, **min 1 / max 3**  
- **prompt:**  
  > In a typical week, what does your day-to-day look like? Pick up to three.
- **options:**

| id | label |
|----|-------|
| `ls_work_heavy` | Work or study takes most of my energy |
| `ls_social` | I spend a lot of time with people |
| `ls_solo` | I protect a lot of solo / quiet time |
| `ls_active` | I stay physically active when I can |
| `ls_home` | Home / household life is a big part of my week |
| `ls_side` | Side projects or hobbies eat real hours |
| `ls_irregular` | My schedule is irregular — days don’t look the same |
| `ls_care` | Caregiving or supporting others is a big part of my week |

- **validation:** ≥1 option required.

---

#### W3-I3 — Current chapter → `currently`

- **id:** `w3_i3_currently`  
- **format:** single-select **required** + optional free text (max 200 chars)  
- **prompt:**  
  > Which best names your *current* life chapter? (What you’re mainly dealing with right now.)
- **options:**

| id | label |
|----|-------|
| `cur_building` | Building something (career, skill, project, business) |
| `cur_stabilizing` | Stabilizing — getting routines, health, or finances steadier |
| `cur_transition` | In transition (job, city, relationship, identity chapter) |
| `cur_relationships` | Focused on relationships / community |
| `cur_recovery` | Recovering energy after a hard stretch (non-clinical: rest / catch-up) |
| `cur_exploring` | Exploring options — not locked into one path yet |
| `cur_maintaining` | Maintaining — keeping a good thing going |

- **optional follow-up:**  
  > Optional: One concrete detail about what “right now” looks like.  
- **validation:** exactly 1 option; follow-up optional.  
- **Note (copy constraint):** Do **not** label `cur_recovery` as depression, burnout diagnosis, or medical recovery.

---

#### W3-I4 — Near-term aim → `goals` (+ feeds `currently` enrichment)

- **id:** `w3_i4_aim`  
- **format:** free text, **required**, min 20 / max 400 chars  
- **prompt:**  
  > Looking ~6–12 months ahead: what would “better” look like for you, in concrete terms? Name one aim you are willing to take responsibility for.  
- **helper text:**  
  > Example shape: “Ship X,” “Repair Y with Z,” “Build a weekly habit of …” — not a vague wish.  
- **validation:** length gates as above; reject whitespace-only.  
- **Grounding:** Dialogic aims / subject-defined better (raw/A5); voluntary responsibility framing (raw/A12 §Meaning via responsibility; B2 Rule 7 lightly) — product copy stays non-preachy.

---

#### W3-I5 — Recent concrete pattern → enriches `learned`

- **id:** `w3_i5_pattern`  
- **format:** free text, **required**, min 40 / max 500 chars  
- **prompt:**  
  > Think of a recent real situation (work, friends, or home). Briefly: what happened, what you wanted, what you did, and how it turned out.  
- **helper text:**  
  > One short story is enough. Specific beats vague (“I’m a hard worker”).  
- **validation:** length gates; no forced structure fields in v1 UI (single box).  
- **Grounding:** Guided assessment pattern what happened → wanted → did → afterward (raw/00).

---

### A5. Branching

**None in v1.** All five prompts are linear.  
**Agent hypothesis (non-blocking):** Later, if `cur_transition` selected, a follow-up “from → to” field could help; defer.

### A6. What must *not* be asked (hard exclusions)

Do **not** include interview or follow-up prompts about:

| Category | Examples (non-exhaustive) |
|----------|---------------------------|
| Clinical screening | Depression/anxiety diagnosis, suicide/self-harm, trauma inventory, PTSD, therapy history as diagnosis |
| Medical | Diagnoses, medications, disability details beyond optional lifestyle “care” (already soft) |
| Illegal activity | Crime, substance dependence screening |
| Deep intimacy / sexual history | Sexual behavior, orientation forced disclosure |
| Politics / culture-war identity tests | Party, ideology questionnaires |
| Third parties by name | “Describe your partner/boss’s personality” |
| Covert profiling of others | Ranking friends without consent |
| Minors | Any path for under-18 assessment (out of epic scope) |
| Forced trauma disclosure | Childhood abuse inventories |

If free text *voluntarily* includes sensitive content: store per §F; do not surface in public trailers; do not diagnose in chat.

### A7. Retake policy

| Rule | Spec |
|------|------|
| Allowed? | **Yes** — authenticated owner may retake interview anytime |
| Effect | New submit **supersedes** previous interview seeds for `learned` / `currently` / `lifestyle` / `goals`; prior version retained in audit/history table if eng already has versioning, else overwrite + timestamp |
| Quiz interaction | Interview retake does **not** auto-rerun Big-5; quiz retake is separate product flow |
| Completeness | After retake, re-run completeness checklist; if free-text fails length, mark incomplete again |
| User copy on retake start | “Updating these answers will change how your Double talks and behaves in rehearsal. Your previous interview answers will be replaced.” |
| Bound sims | If Double already Phase-D bound: **do not** auto-rewrite job/home; only refresh soul text fields; show note: “Your sim role stays the same until you re-bind or an operator updates it.” |

---

## B. Mapping interview → Double soul fields

ISS fields used by chat/sim (raw product SOT): `innate`, `learned`, `currently`, `lifestyle` (`sot_chats.md`). Epic Week 3 also stores **goals** as a profile seed (may live beside ISS or concatenated into `currently` / `lifestyle` — see transform).

### B1. Item → field → transform

| Item | Primary field | Secondary | Transform method |
|------|---------------|-----------|------------------|
| Quiz OCEAN means + bands | `innate` | — | **Deterministic template** (below) |
| W3-I1 options (+ optional sentence) | `learned` | — | Deterministic phrase join + optional append |
| W3-I5 vignette | `learned` | — | **Constrained LLM** compression → append to `learned` |
| W3-I2 options | `lifestyle` | — | Deterministic phrase join |
| W3-I3 option (+ optional detail) | `currently` | — | Deterministic chapter line + optional detail |
| W3-I4 aim | `goals` (stored) | `currently` | Store raw aim; append one short “Aim: …” clause into `currently` via template |

### B2. Transform method recommendation (clear)

**Hybrid — prefer deterministic where possible; LLM only for free-text compression.**

1. **Deterministic templates** for all multi/single-select mappings and Big-5 → `innate`.  
2. **Constrained LLM summarization** only for W3-I5 (and optional I1 free-text if present), with hard constraints:

| Constraint | Value |
|------------|-------|
| Max output | `learned` total ≤ **600 chars**; `currently` ≤ **400**; `lifestyle` ≤ **400**; `goals` raw ≤ **400** |
| Must | Preserve user’s concrete nouns/verbs; first-person or close paraphrase OK |
| Forbidden | Clinical diagnoses; disorder labels; “you have X personality disorder”; invented childhood trauma; percentiles; IQ claims; moral condemnation; culture-war framing |
| On LLM failure | Fall back: truncate raw user text to max length with ellipsis; still mark complete if length gates passed |
| Temperature | Low; no creative “enrichment” beyond compression |

**Do not** let the LLM rewrite `innate` from interview (traits stay MEASURED from quiz).

### B3. Deterministic phrase banks (implement exactly)

**`innate` template** (after quiz):

```
Disposition snapshot (self-report Big Five markers, scale means 1–5 — not a clinical diagnosis):
Openness {O_band} ({O_mean}); Conscientiousness {C_band} ({C_mean}); Extraversion {E_band} ({E_mean}); Agreeableness {A_band} ({A_mean}); Emotional variability {N_band} ({N_mean}).
Bands are relative to this questionnaire’s 1–5 scale (lower / typical / higher), not population percentiles.
```

Use product label **“Emotional variability”** in user-facing soul text instead of “Neuroticism” where the string is shown in chat prompts (internal scoring key may still be `neuroticism`).

**Band words:** `lower` | `typical` | `higher` (cut points §D).

**W3-I1 → `learned` prefix:**

```
Background lens: {joined option labels with "; "}.
{optional_sentence}
```

**W3-I5 → append after LLM or fallback:**

```
Recent pattern (self-described): {compressed_or_truncated}
```

**W3-I2 → `lifestyle`:**

```
Day-to-day: {joined option labels with "; "}.
```

**W3-I3 → `currently`:**

```
Current chapter: {option label}. {optional_detail}
Aim: {w3_i4_aim_text}
```

**`goals` stored field (profile payload):** raw W3-I4 text unchanged (trim).

### B4. How Big-5 appears in soul text

| Field | Big-5? |
|-------|--------|
| `innate` | **Yes** — only place for OCEAN means + bands (deterministic) |
| `learned` / `currently` / `lifestyle` | **No trait scores** — interview language only |
| Chat system prompt | Keep existing ISS order: innate → learned → currently → lifestyle (`sot_chats.md`) |

### B5. Worked example — fake persona only

**Synthetic regression persona:** `Sam Calder` (fictional; not a real person).

**Measured quiz means (example):**

| Domain | Mean | Band |
|--------|------|------|
| O | 4.2 | higher |
| C | 3.8 | higher |
| E | 2.4 | lower |
| A | 3.2 | typical |
| N | 2.8 | typical |

**Interview answers:**

- I1: `bg_analytical`, `bg_structured` + optional “CS background; prefer clear specs.”  
- I2: `ls_work_heavy`, `ls_solo`, `ls_side`  
- I3: `cur_building` + “Shipping a self-serve product path at work.”  
- I4: “In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.”  
- I5: “Last week a launch slipped. I wanted clarity. I wrote a one-page risk list, asked for one decision owner, and we cut two features. Tension dropped; we shipped a thinner cut.”

**Filled soul (illustrative after transform):**

**innate**

```
Disposition snapshot (self-report Big Five markers, scale means 1–5 — not a clinical diagnosis):
Openness higher (4.2); Conscientiousness higher (3.8); Extraversion lower (2.4); Agreeableness typical (3.2); Emotional variability typical (2.8).
Bands are relative to this questionnaire’s 1–5 scale (lower / typical / higher), not population percentiles.
```

**learned**

```
Background lens: Analytical — I like figuring systems out; Structure-minded — plans, routines, and standards matter.
CS background; prefer clear specs.
Recent pattern (self-described): After a slipped launch, wanted clarity; wrote a one-page risk list, named one decision owner, cut two features; shipped a thinner cut and tension dropped.
```

**currently**

```
Current chapter: Building something (career, skill, project, business). Shipping a self-serve product path at work.
Aim: In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.
```

**lifestyle**

```
Day-to-day: Work or study takes most of my energy; I protect a lot of solo / quiet time; Side projects or hobbies eat real hours.
```

**goals (stored)**

```
In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.
```

Use this block as adapter regression fixture `sam_calder_week3_fixture`.

---

## C. Completeness / prediction-ready gate

Locked principle: **soft** for demos; **hard** for “my Double” ownership claims.

### C1. Minimum viable complete profile (v1 checklist)

A profile is **`prediction_ready = true`** iff **all** of:

| # | Gate | Type |
|---|------|------|
| 1 | Authenticated adult user owns the Double | hard |
| 2 | IPIP-BFM-25 submitted; five domain means present | hard |
| 3 | Deterministic `innate` seed written | hard |
| 4 | W3-I1…W3-I5 all validated answers stored | hard |
| 5 | Adapter wrote non-empty `learned`, `currently`, `lifestyle` | hard |
| 6 | `goals` seed non-empty | hard |
| 7 | User acknowledged snapshot disclaimer at interview submit | hard |

**Soft-incomplete** = quiz done but interview incomplete (or interview failed validation).

### C2. Soft-incomplete messaging (near-final copy)

**Banner / empty state:**

> Your Double has a personality snapshot from the quiz, but it’s not fully set up yet. Finish the short interview so it can use your real background, current chapter, and aims. Demo cast Doubles still work without this.

**CTA:** `Finish interview`  
**Secondary:** `Keep browsing demos`

### C3. Hard-blocked actions when incomplete

| Action | Soft-incomplete (quiz only) | Incomplete (no quiz) | Complete |
|--------|----------------------------|----------------------|----------|
| Browse / chat with **cast** demo agents | Allowed | Allowed | Allowed |
| View own OCEAN snapshot | Allowed | Blocked (no data) | Allowed |
| Chat with **owned** Double as “my Double” / creator mode | **Blocked** | Blocked | Allowed |
| Claim “this is my Double” in UI | **Blocked** | Blocked | Allowed |
| Self-serve Phase D bind / place in sim | **Blocked** | Blocked | Allowed |
| Operator soft-demo roster (pre-profiled cast) | N/A — unchanged | N/A | N/A |

**Hard-block modal copy:**

> To chat with your Double as yours—or place it in a simulation—finish the quiz and the short interview. This keeps “my Double” claims honest: scores alone aren’t enough.

### C4. Quiz-only chat policy (decision)

| Mode | Decision |
|------|----------|
| Cast / demo agents | **Yes** — always allowed without quiz (locked product) |
| Owned Double, creator chat | **No** until `prediction_ready` — half-seeded owned chat invites false “this is me” claims |
| Owned Double, read-only preview of scores | **Yes** |

### C5. Quality bar beyond “fields filled” (v1)

| Check | v1? | Spec |
|-------|-----|------|
| Min free-text length | **Yes** | I4 ≥20, I5 ≥40 chars |
| Max length | **Yes** | As in item bank |
| Nonsense / keyboard mash | **Light only** | Reject if >40% repeated single character or zero vowels in Latin text; else accept |
| LLM toxicity/clinical | **No** as completeness blocker in v1 | Log for later |
| Semantic “quality” scoring | **No** | Do not block on eloquence |

---

## D. Interpretation & product language

### D1. Safe user-facing framing (refine)

**Post-quiz:**

> Here’s your personality snapshot from a short Big Five questionnaire. It describes tendencies—not destiny—and it is **not** a clinical diagnosis or therapy.

**Post-interview (complete):**

> Your Double is ready enough for personal rehearsal. It combines your questionnaire snapshot with what you shared about background, day-to-day life, and aims. Treat it as a **practice mirror**, not a verdict on who you are.

**Mission-aligned one-liner (settings):**

> Double is for safe rehearsal and reflection—not medical or mental-health treatment.

### D2. Band labels & cut points

**Keep** three bands: `lower` / `typical` / `higher`.

| Mean (1–5 domain) | Band |
|-------------------|------|
| ≤ 2.5 | lower |
| ≤ 3.5 | typical |
| > 3.5 | higher |

**Evidence-based note:** These are **scale-relative product bands**, not population norms. Without an adult norms table, do not imply “average person.”  
**UI microcopy under bands:** `Relative to this quiz’s 1–5 scale — not a population percentile.`

**Optional display synonym:** show “Emotional variability” for N in UI; keep internal key `neuroticism`.

### D3. Stop saying (given means-only IPIP-BFM-25)

| Stop / avoid | Why |
|--------------|-----|
| “Percentile,” “top 10%,” “more neurotic than 80% of people” | No norms (**Measured** constraint) |
| “Diagnosed,” “disorder,” “clinical profile,” “therapy plan” | Out of scope; not clinicians |
| “Scientifically proven accurate Double” | Overclaims validity without local validation study (raw/A1 reliability/validity humility) |
| “IQ,” “intelligence score” | Not measured (raw/A3) |
| Aspect claims (industriousness vs orderliness, etc.) | IPIP-BFM-25 does not score aspects (raw/A6) — don’t invent |
| “Jordan Peterson says you are…” | Never |

### D4. If users ask “How accurate is my Double?”

**Recommended reply (support / FAQ / chat refusal script):**

> Accuracy here means something limited and honest. The quiz is a short public-domain Big Five marker set scored as simple averages on a 1–5 scale. Good personality measures aim for **reliable** (stable enough) and **valid** (related to real patterns)—but no short self-report, and no digital Double, can fully capture a person. Your interview adds your own words about context and aims, which helps rehearsal feel more like you. Treat mismatches as useful signal: update the interview, or notice where the mirror is wrong. This is for reflection and practice—not prediction of your worth, health, or future with certainty.

**Epistemic backbone (internal):** Reliability/validity language from raw/A1; forecasts must stay conditional (raw/00; raw/A3 match temperament to situation, not total remake).

---

## E. Adult IPIP stems

### E1. Formal sign-off status

**Explicit defer of full psychometric stem-by-stem sign-off for v1.**  
Engineering may **keep the current draft adult situational stems** in `ipip_bfm_25_adult_v1.json` for integration. A dedicated stem audit (anchor polarity, reverse-key alignment, cultural neutrality) is listed under **Open research** and must not block Week 3.

### E2. Reverse-key set

**Provisional keep:** reverse keys `1, 9, 10, 11, 12, 22, 25` as stated in the inquiry, **pending** the deferred stem audit.  
**Agent hypothesis:** These match negatively keyed IPIP marker wording in the draft bank (items whose `question_text` is negatively framed). Do **not** invent a new key set without a content audit.

### E3. Light red-line notes (non-blocking; optional polish)

| Item | Note | Action for v1 |
|------|------|----------------|
| #4 “Love children” situational | Can feel off-target for adult workplace product; not unethical | Keep for v1; revise in open research |
| #19 “feel kind of blue” | Mood language; not a depression screen if framed as questionnaire tendency | Keep; never branch to clinical help flow from this item alone |
| Reverse-keyed situational polarity | Confirm left/right anchors still flip correctly in FE | Eng QA checklist, not content rewrite |

---

## F. Risks & ethics

### F1. Top 3 risks + mitigations (product, not legal opinion)

| # | Risk | Mitigation |
|---|------|------------|
| 1 | **False identity / overclaim** — users treat a short quiz+interview as “the real me” or a clinical truth | Hard gate for “my Double”; disclaimer copy; bands ≠ percentiles; FAQ accuracy language; no diagnosis in prompts |
| 2 | **Sensitive free-text leakage** — vignettes include trauma, third parties, or secrets that later appear in trailers/public surfaces | Exclude sensitive prompts; creator-chat only for owned complete profiles; do not put raw interview into public trailer pipelines; retention controls §F3 |
| 3 | **Mirror misuse** — humiliation, coercion, or “gotcha” profiling of others | Refuse third-party profiling in product; ownership auth; no cast agent claims to be the user’s clinical evaluator; Peterson-informed listening framing is for *user self-description*, not weaponized assessment (raw/00 consent) |

### F2. Must-have disclaimer / consent lines (before interview submit)

**Checkbox required (unchecked by default):**

> I understand this interview and quiz create a **personality snapshot for Doubland rehearsal**. They are **not** a medical or mental-health diagnosis, and not therapy. I agree to answer about myself (not someone else).

**Submit button subtext:**

> You can update these answers later. Honesty helps the mirror; performance-answers make a worse rehearsal partner.

*(Truthful speech as practical ethics — B2 Rule 8 — kept non-preachy in product tone.)*

### F3. Data sensitivity

| Data | Sensitivity | v1 handling |
|------|-------------|-------------|
| OCEAN means / bands | Moderate psychographic | Authz by owner; not public by default |
| Multi-select interview | Moderate | Same |
| Free-text I4/I5 | **Higher** — may contain health, conflict, names | Encrypt at rest if platform standard; **never** use in public marketing trailers; exclude from anonymous analytics aggregates in v1; consider 90-day raw-text retention with compressed soul kept longer (**open research** — don’t block on exact TTL) |
| Clinical-sounding voluntary disclosures | High | No auto-diagnosis; optional future “edit/delete interview” control |

---

## Open research (do not block v1)

1. Adult norms / percentile tables for IPIP-BFM-25 (explicitly out of v1).  
2. Full stem-by-stem psychometric sign-off + reverse-key verification study.  
3. Aspect-level instrument (BFAS) — not v1.  
4. Interview branching by current chapter.  
5. Strong nonsense / LLM-judge quality gates.  
6. Exact retention TTL / deletion UX for free-text.  
7. Local predictive validity study (Double behavior vs user self-ratings).  
8. Teen / school instruments (out of epic).  
9. Whether `goals` should remain a separate ISS field vs only embedded in `currently`.  
10. Replacing IPIP-BFM-25 (only if future blocking validity/ethics finding).

---

## Guardrail note

This report is **Peterson-informed psychometric product design**, not a clinical assessment, not legal advice, and not Jordan Peterson’s personal endorsement. No claims here are a diagnosis. Forecasts about Double “accuracy” are conditional and limited by short self-report reliability/validity constraints (raw/A1). Named real-person psychographics were not produced—only a synthetic fixture. Boundaries respected: no realitytv format design, no engagement KPIs, no willwright simulation-system invention; mapping targets existing soul/ISS fields only.

---

## Source grounding

| Claim cluster | Sources |
|---------------|---------|
| Method, epistemic labels, interview posture | `raw/00_custom_gpt_instructions.md` |
| Routing | `raw/A0_Peterson_Index.md` |
| Reliability, validity, trait as sub-personality | `raw/A1_2017_Big_Five_Intro.md`; `raw/A12_Peterson_Glossary.md` |
| Aims, listening, structure | `raw/A5_Clinical_Listening_and_Value.md` |
| Aspects not claimed without measure | `raw/A6_Big_Five_Aspects.md` |
| OCEAN vocabulary (secondary) | `raw/A7_Big_Five_Science_Support.md` |
| Prediction humility / temperament × role | `raw/A3_2017_Performance_Prediction.md` |
| Truth / listening framing (light) | `raw/user-provided/B2_12_Rules_7_to_12.md` (Rules 8–9) |
| Responsibility / meaning (light) | `raw/A12` §Meaning via responsibility; B2 Rule 7 |
| Product soul / mission | `double-ivan/concept/mission.md` |
| ISS fields | `double-docs/sot/sot_chats.md` |
| Completeness / bind phases | `double-docs/sot/sot_lifecycle.md` §6; epic Week 3 |

### Quotes used (from pack `## Quotes` only)

> "Think of a trait as an element of personality; and I think the best way to think about a trait is as a sub-personality." — raw/A1

> "A reliable measure is one that measures the same way across multiple measurements." — raw/A1

> "Valid… means that it actually has to measure what it purports to measure." — raw/A1

> "Helping them impose ANY STRUCTURE onto their life is likely to be an improvement over no structure at all." — raw/A5

> "My basic practise with people is to say… obviously you are here because you would like things to be better… We can use your definition of what constitutes better." — raw/A5

---

## Acceptance self-check (specialist)

- [x] A–F answered with concrete artifacts (item bank, maps, copy, checklists)  
- [x] Citations + epistemic labels present  
- [x] Guardrail note present  
- [x] No invented norms/percentiles/aspect scores  
- [x] Fake persona only for worked example  
- [x] IPIP stems: **explicit defer** + provisional reverse keys  
- [x] Engineering can implement Week 3 without inventing assessment content  

