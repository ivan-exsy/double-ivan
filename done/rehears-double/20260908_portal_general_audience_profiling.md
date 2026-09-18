# Expert recommendations — General-audience profiling for the Doubland portal

**Task:** Portal instrument + chat (post–Week 3)  
**Specialist:** jordanpeterson (Peterson-informed; not Jordan Peterson)  
**Date:** 2026-09-08  
**Inquiry:** Expert inquiry — General-audience profiling for the Doubland portal (COS routed; Ivan approved sole specialist)  
**Predecessor (accepted):** `rehears-double/20260714_behavior_science_inquiry_week3.md`  
**Related:** `20260714_fe_request.md` · `20260714_behavior_science_inquiry_week3_3_post_chat_learning.md` · `double-docs/MVP-breakfasts.md`  
**Status:** Draft for founder review → **public / product claims: `pending_approval`**  
**Also at:** `double-ivan/rehears-double/20260908_portal_general_audience_profiling.md`  
**Risk:** **High** (psychographic onboarding on live portal; named adult users)

---

## Meta (epistemic posture)

| Field | Value |
|-------|--------|
| Epistemic labels | **Measured** / **Evidence-based** / **Peterson-informed** / **Agent hypothesis** |
| Assess, don’t diagnose | No clinical claims; Double = rehearsal mirror |
| Instrument decision | **A2** (see §A) — short portal prior from cited public-domain IPIP markers |
| Do **not** claim | Result *is* IPIP-BFM-25, full Mini-IPIP, or a clinical profile |
| Village lock | IPIP-BFM-25 on double-front **unchanged** |
| Week 3 locks | Reopened only where noted; no blocking validity/ethics undo of interview/`innate` rules |
| Routing | A0 → A12 → A1, A5, A6, A3; B1/B2 lightly (truth / responsibility; non-preachy product tone) |

---

## Executive decision (engineering one-liner)

**Ship A2:** instrument id `ipip-mini10-portal-v1` — **10** public-domain Mini-IPIP / IPIP markers (2 per OCEAN domain), adult general situational stems, 5-point Likert, means 1–5 + coarse bands, **no percentiles**. Replace `pgh-micro-v1` wording and beats with the banks below. Keep short slider + 4-beat chat **shape**. Village IPIP-BFM-25 stays SOT temperament when completed; portal scores are a **coarse prior** only.

**Blocking bar check:** Short 10-item / ~60s shape is **scientifically acceptable as a coarse prior** for portal onboard (not as a substitute for IPIP-BFM-25). Homemade Pittsburgh stems are **not** acceptable as the Rehears foundation. Full 25 on the portal is **not** required unless founder drops the ~6 minute total budget.

---

## A. Trait snapshot (Likert)

### A1. Which instrument?

| Option | Verdict | Why |
|--------|---------|-----|
| **A1** IPIP-BFM-25 as-is on portal | **Reject for this door** | Keeps Week 3 village path; **~25 items** breaks founder ~60s slider + ~6 min total portal budget. Not a validity *block* — a product-time conflict. Village keeps A1. |
| **A2** 10 cited IPIP / Mini-IPIP markers | **Adopt** | Matches shape; every marker is public-domain and citeable; honest as **coarse prior**, not BFM-25. |
| **A3** BFI-10 / other published short Big Five | **Not needed** | IPIP can serve this door; switching inventories adds claim clutter without solving the prior problem. |

**Evidence-based:** Mini-IPIP (Donnellan et al., 2006) is a published short form using IPIP markers; alphas for *4*-item scales were acceptable (~.60+). **Two items per domain are thinner** — treat as **coarse prior** only (**Agent hypothesis** on reliability for 2-item composites: usable for rehearsal seeding, not for high-stakes or public “accurate personality” claims).

**Peterson-informed (raw/A1):** Prefer reliable + valid measurement; a short self-report can seed structure for rehearsal, but must not overclaim validity.

### A2. Full item bank (implement exactly)

**Instrument id:** `ipip-mini10-portal-v1`  
**Version:** `2026-09-08`  
**Replaces:** `pgh-micro-v1` (do not describe either as IPIP-BFM-25)  
**Presentation (hold Week 3 UX):** one item at a time; **5-point Likert**; situational stem + left/right anchors; Back / Next (Back = eng parallel).  
**Primary UI copy:** show `situational_stem` + anchors. Optionally show `question_text` as secondary “marker” line in debug only — **not** required in product UI.  
**Citation block (internal / FAQ, not on every slider):**  
Public-domain IPIP markers as listed on [IPIP Mini-IPIP Scoring Key](https://ipip.ori.org/MiniIPIPKey.htm); short-form selection informed by Donnellan, Oswald, Baird, & Lucas (2006), *Psychological Assessment*, 18, 192–203. This portal bank uses **2 markers per domain** (not the full 20-item Mini-IPIP).

**Likert chrome (all items):**  
- `left_text`: `Strongly disagree`  
- `right_text`: `Strongly agree`  
- Values: integers **1–5** (FE sends raw; BE applies `reverse`)

**Reverse rule:** If `reverse: true`, scored_value = `6 - raw` before domain mean.

| order | id | trait | reverse | question_text (IPIP marker — cite) | situational_stem (adult general) | left_anchor | right_anchor |
|------:|----|-------|---------|--------------------------------------|----------------------------------|-------------|--------------|
| 1 | `mini10-e-1` | extraversion | false | Am the life of the party | At a casual gathering with people I don’t know well, I usually… | stay quiet on the edge | energize the room and pull people in |
| 2 | `mini10-e-2` | extraversion | true | Don't talk a lot | In a small-group discussion at work or among friends, I usually… | talk as much as anyone | say very little |
| 3 | `mini10-a-1` | agreeableness | false | Sympathize with others' feelings | When someone close to me is clearly upset, I usually… | keep emotional distance | feel with them and show I care |
| 4 | `mini10-a-2` | agreeableness | true | Am not interested in other people's problems | When a colleague or friend starts sharing a personal problem, I usually… | listen and engage | want to move on quickly |
| 5 | `mini10-c-1` | conscientiousness | false | Get chores done right away | When ordinary tasks pile up at home or work, I usually… | put them off | knock them out promptly |
| 6 | `mini10-c-2` | conscientiousness | true | Often forget to put things back in their proper place | After I use something, I usually… | put it back where it belongs | leave it wherever it landed |
| 7 | `mini10-n-1` | neuroticism | false | Get upset easily | When a plan falls through without warning, I usually… | stay even | get upset quickly |
| 8 | `mini10-n-2` | neuroticism | true | Am relaxed most of the time | Across a normal week, my baseline is usually… | tense or on edge | relaxed most of the time |
| 9 | `mini10-o-1` | openness | false | Have a vivid imagination | When I have quiet time alone, I usually… | stick to concrete to-dos | drift into vivid ideas and possibilities |
| 10 | `mini10-o-2` | openness | true | Am not interested in abstract ideas | In a conversation that turns theoretical or abstract, I usually… | lean in with interest | lose interest and steer back to the practical |

**Hard wording bans (all stems/anchors):** Pittsburgh, Downtown, PPG, breakfast, founders, “this quarter,” company name required, GPS/pin, teen/school lunch/camp wording.

**Agent hypothesis:** Situational stems above are product adaptations of IPIP markers for Week 3–style UX; they are **not** a new unpublished trait model. See **§A2b** for epistemology. Full psychometric stem-by-stem audit of *village* IPIP-BFM-25 adult rewrite remains **deferred** (Week 3 §E / EPIC `D6`) — this inquiry finishes the **portal** bank, not that audit.


---

## A2b. Stem epistemology (situational “I’m usually…” form)

**Question:** Should portal (and village) Likert items use abstract IPIP marker wording only, or situational stems that cue recalled typical behavior?

**Founder context (Rehears):** Standard trait lines felt too hypothetical / high mental effort. Items were rephrased into practical situations the respondent can recall, with bipolar anchors, so answers reflect **usual behavior** rather than abstract self-schema. Prior product stance: **plausible approach; treat as hypothesis, not a proven test.**

### What exists in-repo (your notes / artifacts)

| Artifact | What it shows |
|----------|----------------|
| `rehears/docs/big-5/big-5_questions.csv` | Columns `situational_stem_highschool` + anchors for Goldberg / IPIP-BFM-25 / BFI-2-S — operationalizes the rewrite |
| Week 2–3 + EPIC | “Adult situational stems” locked as UX; formal stem sign-off still open (`D6`) |
| `double-ivan/psy/methodology.md` | Weight behavior over self-labels; questionnaire = fast **signal**; behavioral log / if–then rules = higher value; SJTs (§3.5) are a **separate** forced-choice tool |
| `double-ivan/psy/soul.md` | Calibration scenarios are if–then predictions — not the Likert bank |

No standalone lit-review memo titled “situational vs hypothetical stems” was found; the hypothesis lives in the CSV + product locks + `psy/` method.

### How to classify the rewrite (do not conflate methods)

| Form | What it is | Portal use |
|------|------------|------------|
| Abstract IPIP marker | Public-domain trait statement (“Am the life of the party”) | **Cite / store** as `question_text` |
| Situational typical-behavior stem | “When…, I’m usually…” + behavioral anchors | **Primary UI** presentation |
| True hypothetical / SJT | “What would you do if…?” forced choice | **Not** the portal Likert bank (`psy` §3.5 is elsewhere) |

**Evidence-based (supportive analogy, not local validation):** Contextualized / frame-of-reference personality items often show higher criterion validity for matching outcomes than noncontextualized ones (e.g. Shaffer & Postlethwaite, 2012). Act-frequency / behavior-weighted self-report traditions also favor concrete typical acts over pure adjectives. **Peterson-informed (raw/A1):** prefer behavioral evidence before trait labels — aligns with `psy/methodology.md` §0.3 and §3.3.

**Agent hypothesis (required humility):** Rewriting markers into new stems creates a **new item form**. Published Mini-IPIP / IPIP-BFM-25 psychometrics do **not** automatically transfer. Concrete situations can add noise (unfamiliar situation; desirability of the vivid act). Teen HS stems must not ship as adult copy.

### Portal decision (locked for this report)

1. **Keep** situational “I’m usually…” stems + anchors for `ipip-mini10-portal-v1` (table §A2).  
2. Always persist the **raw IPIP marker** separately — that is the public-domain citation; the situation is presentation.  
3. Under-quiz instruction (add to §A3 / §E): *Answer from how you usually act in situations like this — not how you wish you’d act.*  
4. Never print “validated situational IPIP,” “scientifically proven recall format,” or equate this bank with SJTs.  
5. Prefer typical-behavior stems over pure hypotheticals.  
6. Open research (non-blocking): concordance study — same adults answer marker-only vs situational form; continue village adult-stem audit (`D6`).


### A3. UI lines under the quiz

> Short Big Five snapshot from public-domain personality markers (10 items). A coarse prior for your Double — not a diagnosis, and not the full village questionnaire.

> Answer from how you usually act in situations like this — not how you wish you’d act.

### A4. Never print (extend Week 3 §D3)

| Never print | Why |
|-------------|-----|
| “IPIP-BFM-25,” “the Rehears quiz,” “scientifically validated Doubland test” for this portal bank | Wrong instrument / overclaim |
| “Mini-IPIP complete” / “official Mini-IPIP score” | We ship **10 of 20** markers |
| Percentiles, “top 10%,” population averages | No norms (**Measured** constraint) |
| Diagnosis, disorder, therapy, IQ, aspects (industriousness vs orderliness, etc.) | Out of scope / unmeasured (raw/A6) |
| “Jordan Peterson says you are…” / celebrity endorsement | Never |
| Equating portal means with village IPIP-BFM-25 means | Different banks |
| “Validated situational IPIP,” “scientifically proven recall format,” SJT equivalence | Stem form is **Agent hypothesis** (§A2b) |

### A5. Scoring (confirm)

| Rule | Spec |
|------|------|
| Per item | Raw 1–5; if `reverse`, `6 - raw` |
| Domain mean | Mean of **2** scored items; store 1 decimal |
| Bands | ≤2.5 `lower` · ≤3.5 `typical` · else `higher` (Week 3 cut points) |
| Percentiles | **None** |
| `innate` template | Same Week 3 deterministic template, but instrument line must say **portal coarse prior / `ipip-mini10-portal-v1`**, not IPIP-BFM-25 |
| UI N label | Prefer **Emotional variability** in user-facing soul text; internal key `neuroticism` OK |

**`innate` template (portal):**

```
Disposition snapshot (self-report Big Five markers from a short public-domain set, scale means 1–5 — not a clinical diagnosis; not the full IPIP-BFM-25):
Openness {O_band} ({O_mean}); Conscientiousness {C_band} ({C_mean}); Extraversion {E_band} ({E_mean}); Agreeableness {A_band} ({A_mean}); Emotional variability {N_band} ({N_mean}).
Bands are relative to this questionnaire’s 1–5 scale (lower / typical / higher), not population percentiles. Instrument: ipip-mini10-portal-v1 (coarse prior).
```

### A6. Same person later takes village IPIP-BFM-25

| Rule | Spec |
|------|------|
| Portal onboard | Required for portal `prediction_ready` with chat; village quiz **does not** satisfy portal onboard (hold MVP lock) |
| Village IPIP-BFM-25 | Remains available on double-front; completing it does **not** skip portal `/onboard` |
| Conflict | **Village IPIP-BFM-25 supersedes** portal means for temperament / `innate` when both exist |
| Storage | Keep both rows: `instrument`, `means`, `completed_at`. Do **not** average |
| User copy if both exist | “Your full questionnaire updates your Double’s disposition snapshot. The short portal quiz was only a first pass.” |
| Chat | Still must **not** rewrite means / `innate` (Week 3.3 lock) |

---

## B. Chat / interview (~4–6 min after sliders)

### B1. Shape decision

**Keep 4 free-text beats** (portal shape), **general adult wording**, mapped to Week 3 ISS fields. Do **not** ship full structured `double-interview-v1` (5 multi-select + free text) on this door — time budget. Treat portal chat as a **compressed life-chapter intake**, not a replacement of village interview v1.

**Instrument id:** `double-portal-interview-v1`  
**Version:** `2026-09-08`  
**Interviewer:** first line of each beat in **English**; then mirror user language (hold Breakfasts chat contract).

### B2. Final beat prompts (English first lines)

| # | id | English interviewer first line | Primary ISS | Secondary |
|---|-----|--------------------------------|-------------|-----------|
| 1 | `beat-background` | What do you do day to day, and what are you mainly focused on in this chapter of your life? | `learned` | `currently` |
| 2 | `beat-rhythm` | In a typical week, how do you spend your energy — work, people, quiet time, side projects, home? | `lifestyle` | — |
| 3 | `beat-friction` | Tell a recent real situation where something got hard (work, friends, or home). What did you want, what did you do, and how did it turn out? | `learned` (pattern) | — |
| 4 | `beat-aim` | Looking about 6–12 months ahead, what would “better” look like in concrete terms — one aim you’re willing to own? | `goals` | `currently` |

**Helpers (optional UI under composer):**  
- Beat 3: “One short story beats vague traits.”  
- Beat 4: “Ship X / repair Y / build a weekly habit of … — not a vague wish.”

**Validation (v1 portal):**  
- Each beat: non-empty after trim; recommend min **20** chars (soft warn) / hard min **8** to avoid empty; max **500**.  
- Nonsense: light Week 3 rule (repeated char / zero vowels) optional.

### B3. ISS map (chat must not touch `innate`)

| Beat | Transform |
|------|-----------|
| Quiz means | **Only** source of `innate` (deterministic template §A5) |
| `beat-background` | Constrained LLM → `learned` prefix + short `currently` chapter line |
| `beat-rhythm` | Constrained LLM → `lifestyle` |
| `beat-friction` | Constrained LLM → append “Recent pattern…” to `learned` |
| `beat-aim` | Store raw → `goals`; append `Aim: …` into `currently` |

**LLM constraints (hold Week 3):** no clinical labels; no inventing trauma; no rewriting `innate`; English soul at `done`; preserve concrete nouns/verbs; length caps Week 3 §B2.

### B4. Must not ask

Hold Week 3 §A6 exclusions, plus portal-specific:

| Ban | Examples |
|-----|----------|
| Clinical / medical / illegal / sexual history / politics tests | as Week 3 |
| Third-party secrets / “describe your partner’s personality” | as Week 3 |
| Required company name / employer doxxing | optional mention OK if user volunteers |
| GPS / pin / “favorite Downtown spot” as required | cohort overlay only (§B5) |
| Pittsburgh / founder identity assumed | never in general bank |

### B5. Cohort overlay

**Yes — optional one beat after the general bank**, keyed by joinable sim / cohort config — **not** baked into the general door.

| Field | Spec |
|-------|------|
| id | `beat-cohort-overlay` (e.g. Breakfasts) |
| When | After beat 4, only if `cohort_overlay_id` present for this onboard wave |
| Breakfasts English line | “If you’re joining Pittsburgh Business Breakfasts: anything about your work or gathering habits that should show up in the sim? (Optional — skip if not relevant.)” |
| ISS | Soft append to `currently` / `lifestyle` only; never `innate` |
| Other waves | Different overlay string or none |

**Default for all waves:** the **same 4 general beats**. Overlay is additive.

---

## C. Honesty & consent

### C1. Honest line (general portal)

**Portal (general):**  
> This short quiz and chat build a personality snapshot so your Double can rehearse with you. Survival sims are real when you Join one from your account. Place and art details depend on the sim you join.

**Breakfasts watch / Join surfaces only (keep MVP):**  
> Survival is real. You are on Downtown Pittsburgh (gather at PPG Cafe). Building art is still catching up.

Do **not** put Downtown/PPG on the general quiz/chat chrome.

### C2. Consent checkbox

**Replace** placeholder; align Week 3 + portal:

> I understand this quiz and chat create a **personality snapshot for Doubland rehearsal**. They are **not** a medical or mental-health diagnosis, and not therapy. I agree to answer about myself (not someone else). Doubland may use these answers to create and run my Double when I Join a simulation.

Unchecked by default; required before `done`.

**Submit subtext:**  
> You can update answers later. Honesty helps the mirror; performance-answers make a worse rehearsal partner.

### C3. FAQ — “How accurate is my Double?”

**Revise Week 3 §D4 for 10-item prior:**

> Accuracy here is limited and honest. The portal quiz is a **short** set of public-domain Big Five markers (two items per trait) scored as simple averages on a 1–5 scale. That is a **coarse prior**, not a full questionnaire and not a clinical assessment. Good personality measures aim to be reliable and valid — but no short self-report, and no digital Double, fully captures a person. Your chat answers add your own words about context and aims. If you later take the longer village questionnaire, that fuller snapshot can update disposition. Treat mismatches as useful signal. This is for reflection and practice — not a verdict on your worth, health, or future.

---

## D. Versioning & retake

| Rule | Spec |
|------|------|
| Instrument ids | Quiz: `ipip-mini10-portal-v1` · Chat: `double-portal-interview-v1` |
| Persist on profile | `instrument`, `instrument_version`, `completed_at`, domain means, raw answers |
| Retake quiz | Allowed; supersedes portal means + regenerates `innate` from **portal** template unless village BFM-25 already supersedes |
| Retake chat | Allowed; supersedes life-chapter seeds; copy Week 3 retake warning |
| `pgh-micro-v1` legacy | Keep historical rows; new onboard must use `ipip-mini10-portal-v1`. Do not silently re-score old Pittsburgh items as Mini-IPIP |
| Migration UX | Returning users with `prediction_ready` from `pgh-micro-v1` stay on `/account`. Optional settings CTA: “Refresh your snapshot with the general questionnaire” (non-blocking) |
| Completeness | `prediction_ready` = portal quiz + 4 beats validated + consent + adapter soul fields (same hard/soft spirit as Week 3; portal interview shape differs) |

---

## E. UI strings (copy deck)

| Surface | String |
|---------|--------|
| Quiz header | Personality snapshot |
| Quiz sub | 10 short questions · about 1 minute |
| Under-quiz line | §A3 |
| Chat header | A few questions so your Double sounds like your life — not only five scores |
| Chat sub | Answer in any language. We’ll compile an English soul. |
| Meet framing | Your Double is ready enough for personal rehearsal. Treat it as a practice mirror, not a verdict. |
| Soft-incomplete | Your Double has a short snapshot, but the chat isn’t finished. Finish it so background and aims can land. |
| Hard-block Join / “my Double” | Finish the short quiz and chat before Join or “my Double” claims. Scores alone aren’t enough. |

---

## F. Top risks (product, not legal)

| # | Risk | Mitigation |
|---|------|------------|
| 1 | **Overclaim** — users/marketing treat 10 items as IPIP-BFM-25 or “scientifically proven you” | Instrument id honesty; UI line; FAQ; never print list §A4; founder `pending_approval` on public claims |
| 2 | **Unreliability of 2-item domains** — noisy means, brittle bands | Coarse prior framing; village BFM-25 supersedes; no percentiles; avoid high-stakes uses |
| 3 | **Cohort flavor relapse** — Pittsburgh/founder copy creeps back into general door | Hard wording bans; overlay beat only behind cohort flag |
| 4 | **Sensitive free text** in friction/aim beats | Week 3 exclusions; no trailer use of raw text; consent; encrypt-at-rest per platform norms |
| 5 | **Dual-instrument confusion** | Explicit supersede rule; store both; user copy when village completes |

---

## G. Open research (do not block portal ship of A2)

1. Full stem-by-stem psychometric sign-off of **village** adult IPIP-BFM-25 situational rewrite (Week 3 deferred — still open; **this inquiry does not close it**).  
2. Whether portal should eventually offer optional full Mini-IPIP-20 (~2–3 min) instead of 10.  
3. Adult norms / percentiles (still out).  
4. Empirical portal↔village mean concordance study.  
5. Stronger nonsense / quality gates on multilingual chat.  
6. Exact retention TTL for free-text.  
7. Whether Breakfasts overlay should be mandatory for that allowlist (recommend **optional**).  
8. Aspect instruments / HEXACO — only if future blocking finding that IPIP cannot serve (none now).

---

## H. What engineering changes (checklist)

1. Replace `pgh-micro-v1` item bank with §A2 table; new instrument id.  
2. Scoring: reverse flags + domain means + bands; update `innate` template string.  
3. Replace 4 chat beat prompts with §B2; keep SSE mirror contract.  
4. Optional `beat-cohort-overlay` behind config.  
5. Copy: §A3, §C, §E.  
6. Conflict rule with village IPIP-BFM-25 (§A6).  
7. Do **not** change village 25-item path.  
8. Do **not** wait on Legal for content (COS); still flag **public marketing claims** for founder `pending_approval`.

---

## Guardrail note

This report is **Peterson-informed psychometric product design**, not a clinical assessment, not legal advice, and not Jordan Peterson’s personal endorsement. No claims here are a diagnosis. Named real-person psychographics were not produced. Public portal accuracy claims remain **high-risk → founder `pending_approval`**. Boundaries respected: no realitytv format, no engagement KPIs, no willwright sim invention; Legal not asked to clear clinical language we already forbid.

---

## Source grounding

| Cluster | Sources |
|---------|---------|
| Week 3 locks / interview / `innate` | `rehears-double/20260714_behavior_science_inquiry_week3.md` §9 |
| Chat ≠ temperament | Week 3.3 post-chat learning (accepted) |
| Portal loop / `pgh-micro-v1` drift | `double-docs/MVP-breakfasts.md`; `double-r3f/lib/onboard-pgh/funnel.ts` |
| Reliability / validity / trait-as-sub-personality | `raw/A1_2017_Big_Five_Intro.md` |
| Aspects not claimed | `raw/A6_Big_Five_Aspects.md` |
| Prediction humility | `raw/A3_2017_Performance_Prediction.md` |
| Structure / aims | `raw/A5_Clinical_Listening_and_Value.md` |
| Mini-IPIP markers | https://ipip.ori.org/MiniIPIPKey.htm · Donnellan et al. (2006) |
| Charter | `agents/jordanpeterson/agent.md` |

### Quotes (pack only)

> "A reliable measure is one that measures the same way across multiple measurements." — raw/A1  
> "Valid… means that it actually has to measure what it purports to measure." — raw/A1  
> "Think of a trait as an element of personality; and I think the best way to think about a trait is as a sub-personality." — raw/A1

---

## Acceptance self-check

- [x] A1/A2/A3 decided with rationale  
- [x] Full 10-item bank with ids, traits, stems, anchors, reverse  
- [x] Chat beats + ISS map; overlay rule  
- [x] UI strings, consent, FAQ  
- [x] Version/retake + village conflict  
- [x] Top risks + open research  
- [x] Epistemic labels; assess≠diagnose; public claims flagged `pending_approval`  
- [x] No claim that portal result *is* IPIP-BFM-25  

