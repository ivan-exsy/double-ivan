# Findings — MatrAIx → “that’s me” Double fidelity

**Date:** 2026-08-10  
**Owner:** DEV (investigation only)  
**Status:** complete — evidence-backed eng plan; **no code shipped**  
**Brief:** `20260810_realism_matriAIx.md`  
**Doctrine:** `COS/tasks/2026-08-10-001/final.md`, Will Wright validation-split decision, Jordan Peterson minimal trait pack  
**Repos tip inspected:** `generative_agents` branch `railway` (read-only)

---

## Executive verdict

Doubles already **store** Measured IPIP-BFM-25 (`domain_means` / labels) and **publish** a disposition string into ISS `innate` plus three profile snippets. At runtime the engine almost never treats Big Five as **numbers**. Plan/chat get soft prose; react gets weak action snippets without a full soul card; reflect insights often get **no identity at all**. Naturalness Gate scores body/chat integrity only — not “is this me?”

Highest-ROI path (doctrine-aligned): keep Naturalness Gate; add a thin **Persona Adherence Gate**; wire **channel-specific** trait directives from existing IPIP spine; measure express **and** suppress. Do **not** import MatrAIx’s 1,290-dim schema, 1M coreset, MBTI driver, or playground runtime.

---

## Trace: quiz → DB → snippets → cognition

```
IPIP-BFM-25 answers
  → quiz_scoring.score_ipip_bfm_25  (domain_means, domain_raw, labels)
  → quiz_profile_service.submit_quiz
       ├─ double.user_personality_profiles  (means, labels, summary, soul_seeds…)
       ├─ double.dbl_agent.config           (domain_means, labels, summary)
       ├─ double.persona_profile_documents  (soul markdown doc_type=self_serve_personality_v1)
       ├─ double.persona_profile_snippets   (values / speaking_style / decision_heuristics)
       └─ identity_publish_service → persona_scratch.innate (+ learned/currently/lifestyle if chapter)
  → runtime
       ├─ scratch.get_str_iss()             free-text identity card
       └─ profile_context_builder           RPC snippets by task_type → [profile_context]
            → selected plan/chat/react prompts (uneven)
```

---

## A. Current identity plumbing

### A1. Where IPIP `domain_means` / labels live after quiz submit

| Store | Schema / table | Fields | Role |
|-------|----------------|--------|------|
| Active profile | `double.user_personality_profiles` | `domain_means`, `domain_raw`, `labels`, `personality_summary`, `answers`, `instrument`, `instrument_version`, `persona_id`, `soul_seeds`, `identity_revision`, `is_active` | Canonical Measured record per user |
| Ownership / config | `double.dbl_agent` | `config.domain_means`, `config.labels`, `config.personality_summary`, later ISS keys | Links `user_id` ↔ `agent_id` (= persona) |
| Long doc | `double.persona_profile_documents` | `doc_type=self_serve_personality_v1`, markdown with means + labels | Soul dossier (not steady-state prompt) |
| Prompt snippets | `double.persona_profile_snippets` | `values_and_principles`, `speaking_style`, `decision_heuristics` | What RPC serves to prompts |
| Archive | `double.user_identity_versions` | prior `soul_seeds`, `domain_means`, `labels` | Chapter history on retake |
| Runtime ISS | `double.persona_scratch` | `innate`, `learned`, `currently`, `lifestyle`, … | Free-text card used by most prompts |

**Citations:**  
- `api_gateway/app/services/quiz_profile_service.py` — `submit_quiz`, `_ensure_persona`, `_snippet_rows`, `_upsert_profile_document_and_snippets`, innate publish (~L452–638)  
- `api_gateway/app/services/quiz_scoring.py` — `score_ipip_bfm_25`, `build_personality_summary`  
- `api_gateway/app/services/identity_publish_service.py` — Path A ISS write-through  
- `supabase/db_reference.md` — `user_personality_profiles`, snippets, `get_persona_profile_context`

Quiz-built snippets today (deterministic, not LLM):

```text
values_and_principles  = "Agreeableness {label}; conscientiousness …"
speaking_style         = "Adult conversational voice…" + summary
decision_heuristics    = "Lean toward choices that fit O=…, C=…, E=…, A=…, N=…"
```

(`quiz_profile_service._snippet_rows`, ~L179–224)

Self-serve quiz does **not** write `social_rules`, `do_not_do`, or `topic_attractors`. Those exist for soul15 import (`scripts/import_soul_profiles.py` `SNIPPET_SPECS`) and career apply, not the IPIP path.

### A2. Which prompt paths receive profile snippets

**Builder maps** (`profile_context_builder.py`):

```python
_TASK_SNIPPET_ORDER = {
    "chat": ["speaking_style", "social_rules", "values_and_principles"],
    "planning": ["decision_heuristics", "values_and_principles", "do_not_do"],
    "action": ["decision_heuristics", "values_and_principles", "do_not_do"],
    "reflection": ["values_and_principles", "topic_attractors"],
    "auto": ["decision_heuristics", "values_and_principles", "social_rules", "do_not_do"],
}
```

Budget ratios (env-overridable): chat/planning/reflection 0.35, action/auto 0.30.

**SOT mirror:** `double-docs/sot/sot_prompts.md` § Profile Context Injection.

| Path | Identity injection today |
|------|--------------------------|
| Daily plan / hourly schedule | ISS + `build_default_context_block("planning")` → profile planning snippets |
| Task decomp contextual | `context_pack["profile_context"]` via `build_profile_context_block("planning", …)` in `plan.py` |
| Batch conversation | `_persona_identity_block(…, "chat")` = ISS + chat snippets |
| `decide_to_talk` / `decide_to_react` | `build_default_context_block("action")` only — **no full ISS** in primary slots |
| `external_replan` | **ISS only** — no profile block |
| Poignancy (event/thought/chat) | ISS only |
| Focal points | statements-oriented; limited identity |
| **Insight / guidance (core reflect)** | **statements + n only — no ISS, no profile_context** |
| Memo / planning thought on convo | limited / ISS-adjacent (not full reflection pack) |
| Survival vote / challenge | `_persona_identity_block` with action/chat task |
| **Chat-with-Double (gateway)** | ISS fields in system prompt only — **no** `profile_context` RPC |
| Greeting templates | hardcoded — no identity modulation |

Injection helper: `run_gpt_prompt._persona_identity_block` (~L3859–3873).  
Shared path: `context_builder.build_default_context_block` embeds profile (~L221–227).

### A3. Structured numbers at runtime?

**No.** Backend cognition does not read `domain_means` as floats.

- Numbers live in Supabase profile / `dbl_agent.config` and inside **prose** snippets (`O=3.2` text).
- Scratch holds free-text `innate` (disposition snapshot with labels + means as strings).
- Grep of `reverie/backend_server` shows no consumer of structured IPIP fields for plan/chat/react/reflect.

This is exactly `sot_sim.md` **Q6**: trait taxonomy free-text; subjective divergence drifts across LLM calls.

### A4. Call-to-call drift of free-text identity

| Layer | Stable? | Notes |
|-------|---------|--------|
| Quiz → `innate` / snippets | **Deterministic** | Template from means/labels; no LLM on write |
| Soul15 import snippets | **Mostly stable** | Compiled from markdown headings; defaults if missing |
| Same ISS in prompts across steps | **Byte-stable** if scratch unchanged | Cache key `(persona_id, fingerprint, task_type)` for snippets |
| LLM **behavior** from same ISS | **Drifts** | Q6 ceiling; temperature/routing; no adherence gate |

No live multi-step prompt dump was run in this pass (read-only). Code shape alone shows: identity **text** is stable; **adherence of outputs** is unmeasured and expected to wander.

---

## B. Behavioral channels (gap analysis)

| Channel | Identity inputs today | Observable behavior hook | Gap vs “that’s me” bar |
|---------|----------------------|--------------------------|------------------------|
| **plan** | ISS (`innate`…); planning/action snippets (`decision_heuristics` as “lean toward O=…”, values, optional `do_not_do` for soul15); `currently` / `daily_plan_req` | Daily plan list; hourly org; task decomp modes/anchors; schedule stickiness vs stall replan | Heuristics are numeric soup, not C→stickiness / E→social goals. No suppress rule (“high-C may still rest”). Role text often dominates disposition. |
| **chat (in-sim)** | ISS + chat snippets (`speaking_style`, `social_rules` if present, values) via `_persona_identity_block` | Utterance tone, length, initiation after `decide_to_talk=chat` | Self-serve `speaking_style` is generic adult + summary — not A-blunt / E-volume / N-worry directives. `social_rules` often **empty** on quiz path. |
| **chat (Talk / gateway)** | ISS only in system prompt (`chat_with_double_service._build_system_prompt`); optional soul_seeds overlay | User-facing Double voice | No snippet pack; no structured poles; creator_mode honesty copy only. Weakest surface for “that’s me” claims. |
| **react** | `decide_to_*`: action profile snippets inside shared_context **without** full ISS; `external_replan`: ISS only | Join vs walk away (`decide_to_react` 1/2); talk tier none/greeting/chat; same-day plan splice | No trait→repair/escalate/freeze mapping. Extraversion should dominate initiation; Agreeableness repair — neither is named. Fail-safe greeting biases social even when low-E. |
| **reflect** | Poignancy: ISS. **Insights: no identity.** Builder has `reflection` task types but core `run_gpt_prompt_insight_and_guidance` ignores them | Thought nodes themes; memo on convo | Fails bar #4 (duty vs mess, threat rumination, other-focus). Reflections can invent themes unrelated to Measured poles. |
| **place / social choice** | Soft: career/home rank by personality **prose** at onboarding; survival attraction scrapes `innate` text; decomp `social_probability` not trait-gated | Job/home pick at bind; who walks toward whom in Survival; venue mix | No structured E→public venues / N→safety bias / O→explore. Place honesty / staff_only must stay Naturalness-owned — trait must not override walkability. |

---

## C. Cast / multi-persona coherence

### C5. How castmates are bootstrapped

| Path | Mechanism | Compatibility? |
|------|-----------|----------------|
| **soul15 / operator cast** | Markdown souls → `import_soul_profiles.py` → docs + full snippet suite; careers via `assign_soul15_careers` / `apply_career_assignment`; homes via living_area + optional onboarding host | LLM “personality fit” for job/home — **not** joint trait DAG or hard masks across cast |
| **base_family / fork** | `fork_simulation` (+ assets); scratch/profiles copied or backfilled | Independent bios; no cross-persona trait coherence check |
| **Self-serve Double** | Quiz (+ optional interview) → one persona owned via `dbl_agent`; bind into sim via onboarding when `prediction_ready` | Single-identity; multi-user cast = independent Measured profiles with **no** pairwise mask |
| **Relationships** | `sot_lifecycle` §6: teammate relationships **not** seeded; emerge in-sim | Correct product choice; still allows incoherent trait mashups in synthetic casts |

### C6. Smallest latent + mask design (no MatrAIx-scale schema)

**Latent roots (5 + optional 2):**  
`O, C, E, A, N` from IPIP means (1–5). Optional later: risk/NFC scalar; soft attachment prior (secure/anxious/avoidant) — only if channel-wired (Peterson pack).

**Derived surfaces (NL only, budgeted):** one snippet line per channel directive (not full dossier).

**Hard masks (cast generation / validation only):**

1. Age band vs role feasibility (teen vs adult job labels).  
2. Contradictory lifestyle flags if interview present (e.g. “never leaves home” + full-time cafe open alone — warn/block).  
3. Language/locale consistency if multi-lingual fields appear later.  
4. No MBTI as generative parent.

**Soft masks:** Spearman-style checks on cast sample (e.g. mean E vs mean social job density); reject or re-sample outliers — not pairwise 1,290-dim edges.

**Runtime:** free-text remains **derived color**; structured means are SOT for adherence probes and directive selection.

---

## D. Measurement

### D7. Persona Adherence Gate v0 (separate from Naturalness Gate)

**Purpose:** Score whether Measured identity shows in the right channel **or is correctly quiet**.  
**Non-purpose:** Walking, dwell, multi-venue, chat payload integrity — remain Naturalness Gate (`sot_lifecycle.md` §4).

**Protocol (v0):**

- Two personas (or two quiz-forked Doubles) with **opposite poles** on one dim, same maze, same day window, same persona-agent model.  
- Optional third arm: mid/typical control.  
- Score **express** scenes (trait is task-relevant) and **suppress** scenes (trait should not dominate).  
- Pass dim if express difference is detectable **and** suppress false-positive rate is below threshold.  
- Never fold into Naturalness GO/NO-GO.

| # | Pole | Express arm (should differ) | Suppress arm (should stay quiet) | Primary signal |
|---|------|-----------------------------|----------------------------------|----------------|
| 1 | High vs low **E** | Proximity window: initiation rate (`decide_to_talk` → chat vs none); utterance count | Solo work block: no forced social detours | Chat initiation / talk volume |
| 2 | High vs low **C** | Morning plan: stay on `daily_plan_req` / fewer abandon-splices | Explicit leisure slot: allow slack without “duty monologue” | Schedule stickiness / abandon rate |
| 3 | High vs low **A** | Mild conflict prompt: repair language vs blunt refusal | Neutral logistics chat: no excessive people-pleasing or aggression | Bluntness / repair markers (LLM judge + keyword) |
| 4 | High vs low **N** | Ambiguous threat / social risk: safety bias, freeze vs snap | Calm routine hour: no chronic worry monologue | Safety language / freeze-snap react |
| 5 | High vs low **O** | Novel option offered: explore/reframe | Familiar commute task: no forced “curiosity” | Explore choice rate |
| 6 | High **C** vs high **E** tradeoff | Schedule conflict: duty vs social pull | — | Preference under conflict |
| 7 | **Suppress cartoon** (meta) | — | High-N not always crying; high-C not always working | Stereotype rate (LLM judge) |
| 8 | **Talk next-turn** (optional v0.1) | Creator chat: predicted reply vs shuffled-persona baseline | Refusal/abandon when asked to break character | Accuracy vs shuffle (App. M style) |

**Judge mix:**  
- **Code-first** for rates (initiation, schedule deviation, replan yes/no).  
- **Thin LLM judge** only for tone poles (A bluntness, N worry) with fixed rubric and second-model spot-check before any public claim.  
- Log **persona-agent model** + judge model on every report.

### D8. Cheapest trustworthy artifacts

| Artifact | Cost | Trust |
|----------|------|-------|
| Unit: opposite poles → directive text present in assembled prompt | Tiny | Plumbing only |
| 60–100 step fork pair, same seed window | Low–med | Good for E initiation + C stickiness |
| Prompt dumps / cassette replay (`PROFILE_CONTEXT_REPLAY_PATH`, LLM replay) | Low | Regression of wiring |
| Full-day multi-dim battery | High | Pre-release only |
| Human teen recognition study | Highest | Required before marketing “scientifically you” |

Prefer: **code metrics on 60–100 steps** + 2 LLM-judged poles; defer population claims.

### D9. Logging persona-agent model

Already partial: `LLM_METRIC` lines and `sim_cost_daily.model_breakdown` / verification export routing stats (`gpt_structure`, `export verification stats`).

**Gap for fidelity honesty:** adherence report must pin:

- `sim_code`, step window  
- persona ids + **domain_means snapshot** (or profile fingerprint)  
- **persona-agent model id(s)** per tier (A/B/C) actually used for scored functions  
- judge model if any  
- flag if Talk and sim share the same backbone (self-preference risk — MatrAIx § model-as-config)

---

## E. Alter-ego / Talk path (P2 sketch only)

### E10. What already exists (sim-to-real substrate)

| Piece | Status | Citation |
|-------|--------|----------|
| Chat-with-Double gateway | Shipped | `chat_with_double_service.py`; `sot_chats.md` |
| Memory write-back `gwchat_*` | Shipped P3-1 | `dbl_memory`, `meta.source` |
| `external_inbox` → perceive drain | Shipped | `perceive._drain_external_inbox` |
| Same-day `external_replan` | Shipped | `run_gpt_prompt_external_replan`; `plan._external_react` |
| Post-chat learning (life chapter) | Shipped W3.3 | `post_chat_learning_service` — **never mutates innate/Big Five** |
| Identity chapters / retake archive | Shipped | `user_identity_versions` |
| Creator mode prompt | Shipped | system prompt relation string |

**MatrAIx App. M behaviors we can pilot later:** refusal, correction, abandonment, next-turn prediction vs **shuffled-persona** baseline — using Talk logs + optional same-day replan outcomes. Not built as a gate yet.

### E11. Must not ship for teens without privacy review

- Public “scientifically accurate Double” / clinical-adjacent claims  
- Dense psychographic export or third-party sharing of IPIP answers  
- Covert profiling of named minors; persuasion/exclusion targeting  
- Trait→humiliation or stereotype templates  
- Impersonation of real named individuals  
- Auto-apply of post-chat patches without consent (`post_chat_learning_enabled`)  
- Treating Persona 1M / external bios as teen truth  
- MBTI (or other weak typology) as generative driver  

Keep investigation and internal probes internal until privacy/product review (onboarding Phases A–C still deferred in `sot_lifecycle` §6).

---

## Ranked eng plan (implementation later — not this pass)

### P0 — Smallest hook that moves “that’s me”  
**Effort:** ~0.5–1.5 eng days · **Risk:** low (prompt text only if scoped) · **Files:** few

1. **Channel directive compiler** from existing `domain_means`/`labels` (gateway or shared pure function): replace weak `Lean toward O=…` with 1–2 lines per pole **and** a one-line suppress cue (e.g. “Do not perform this trait every turn”).  
2. Write into `decision_heuristics` + `speaking_style` (+ `social_rules` if missing) on quiz submit / one backfill script for self-serve personas.  
3. **Wire reflect:** pass ISS + `build_profile_context_block("reflection")` into `run_gpt_prompt_insight_and_guidance` (and memo path if cheap).  
4. **Wire react:** include compact identity (ISS or action profile) explicitly in `decide_to_talk` / `decide_to_react` primary inputs — not only buried shared_context.  
5. Acceptance: opposite-pole unit test on compiled directives; one 60-step qualitative pair on E initiation; Naturalness Gate unchanged on a baseline roster smoke.

### P1 — Structured traits + channel wiring + adherence probes  
**Effort:** ~1–2 weeks · **Risk:** medium (teen identity; stereotype) · **Files:** profile schema consumers, prompts, tests, analyzer

1. Structured trait fields readable at runtime (scratch or profile RPC): means + labels + fingerprint; validators; **no** MBTI driver.  
2. Prompt builders select **budgeted channel lines** by task_type (Peterson map: E chat/plan social; A repair; C schedule; N safety; O explore).  
3. Cast soft/hard masks for operator-generated rosters.  
4. **Persona Adherence Gate v0** script + CI-optional job; log models; separate artifact from Naturalness report.  
5. Talk system prompt: optional same snippet pack as in-sim chat (still snippet-scale).  
6. Acceptance: ≥4/6 poles pass express+suppress on 60–100 steps; Naturalness Gate non-regression on soul15/family baseline; advisor pass on prompt diffs.

### P2 — Talk sim-to-real  
**Effort:** multi-week · **Risk:** high (privacy, claims) · **Depends:** privacy review

1. Extraction discipline already partially present (null > invent on post-chat; innate frozen) — extend rubrics.  
2. Protocol: withheld context, correction, abandonment, next-turn vs shuffled persona.  
3. Multi-model spot-check before any external accuracy claim.  
4. Acceptance: internal dashboard only until human study.

### Naturalness regression (every eng slice)

Re-run lifecycle Naturalness metrics on comparable 60–100 step window: subactivity switches, overdue ratio, stall replan, stationary-but-progressing, chat payload integrity, multi-venue. **No ship** if personality wiring worsens body honesty or place rules.

---

## Out of scope / do not import

| Item | Why |
|------|-----|
| MatrAIx 1,290-dim schema | Catalog bloat; token poison; product-eval oriented |
| Persona 1M coreset as Double truth | Wrong population; privacy |
| MBTI as plan/chat/react/reflect driver | Weak prediction; doctrine reject |
| Independent-trial playground as runtime | Wrong architecture vs persistent cast + FE spatial authority |
| 91.5% style score as ship bar | Different product; App weaker; our bar is recognition + naturalness |
| Normative SOT rewrite in this pass | Lifecycle = implement + score first; Current vs Desired notes only |
| Capability/Lifestyle mega-taxonomies | No channel proof |
| Replacing Naturalness Gate | Keep separate |
| FE quiz redesign | Not a runtime blocker for means |

---

## Teen / stereotype risks (P1+)

- IPIP bands are **self-report markers**, not diagnosis — keep disclaimer language in `innate` / Talk.  
- Directive text must preserve within-group variation; avoid “all high-E teens are loud party starters.”  
- Suppress arms are load-bearing to prevent cartoons.  
- Minors’ answers are sensitive psychographics — retention, access, and marketing claims need explicit review.  
- Do not weaken staff_only / place honesty to chase personality theater.

---

## Desired vs Current (SOT note only — not normative edit)

| Topic | Current (live) | Desired (charter) |
|-------|----------------|-------------------|
| Trait SOT | Free-text ISS + soft snippets (`sot_sim` Q6) | Thin structured IPIP spine + channel directives |
| Gates | Naturalness only (`sot_lifecycle` §4) | Naturalness **and** Persona Adherence |
| Fidelity def | Implicit “hope the LLM reads innate” | Express **or** correctly suppress |
| Reflect identity | Often none | Reflection pack + values/topic attractors |

Promote Desired → normative SOT only after green implement + score.

---

## Acceptance checklist (this investigation)

- [x] Questions A–E answered with citations  
- [x] Channel gap table complete  
- [x] P0 / P1 / P2 ranked with effort, risk, acceptance  
- [x] Persona Adherence Gate v0 designed  
- [x] Out-of-scope / do-not-import list  
- [x] No eng SOT normative rewrite  
- [x] Teen / stereotype risks called out  
- [x] No feature implementation / PR merge  

---

## Recommended next founder move

Approve **P0 only** on an `ivan/*` branch: compile stronger IPIP channel lines + wire reflect/react identity — **under the cost addendum below** (replace soup, hard caps, ≤+5% tokens/step smoke). Then run Adherence v0 poles 1–2 (E, C) beside an existing Naturalness smoke. Hold P1 structured runtime fields until P0 shows a visible “that’s me” delta.

---

## Addendum — P0 cost / context budget (2026-08-10)

**Constraint:** more “that’s me” **without** blowing per-step token spend.  
**Method:** static size math from live templates + existing budget caps (`prompt_budget.py`, `profile_context_builder.py`). Token ≈ `chars/4` (OpenAI-ish rough). No live sim meter in this pass.

### 1. Per-step identity budget today

#### Building blocks (self-serve / quiz-shaped Double)

| Block | Typical size | Notes |
|-------|--------------|--------|
| ISS `get_str_iss()` (name/age/innate/learned/currently/lifestyle/daily_plan/date) | **~350–700 ch · ~90–175 tok** | Quiz `innate` alone ~240 ch; full soul15 ISS can exceed 1k ch |
| Planning/action `[profile_context]` (heuristics + values; `do_not_do` often empty on quiz) | **~200–350 ch · ~50–90 tok** | Weak `O=/C=/E=` soup + label list |
| Chat `[profile_context]` (speaking_style + values; `social_rules` often empty on quiz) | **~350–500 ch · ~90–125 tok** | speaking_style = boilerplate + full summary |
| Action shared_context shell (relationship/memory/location + embedded profile) | profile as above + **~80–200 ch** shell | Whole shared_context then re-capped with memories |

Existing **ratio caps** on profile block (`max_injected_chars × ratio`):

| task_type | max_injected_chars | ratio | Effective profile cap |
|-----------|-------------------|-------|------------------------|
| chat | 2600 | 0.35 | **~910 ch · ~230 tok** |
| planning | 2000 | 0.35 | **~700 ch · ~175 tok** |
| action | 1500 | 0.30 | **~450 ch · ~110 tok** |
| reflection | 1800 | 0.35 | **~630 ch · ~160 tok** |

Quiz content today sits **well under** these caps; the risk is stacking ISS + profile on many calls per step, not a single oversized block.

#### Main call types — identity on/off and rough identity tokens

| Call | Fires (typical step) | ISS | `[profile_context]` | Identity tokens / call (quiz-shaped) |
|------|----------------------|-----|---------------------|--------------------------------------|
| **Daily plan** | Rare (day boundary) | yes | planning (via shared_context) | **~150–250** (ISS+profile, joint-capped ~0.70 planning) |
| **Hourly schedule** | Rare (hour / wake) | yes | planning | **~150–250** |
| **Task decomp (legacy)** | When decomp path uses ISS template | yes | planning in shared | **~150–250** |
| **Task decomp contextual** | Common when action decomposes | **no** direct ISS | **yes** inside `context_pack` JSON (planning) | **~50–90** profile only; pack also has role/plan hints |
| **decide_to_talk** | When proximity / social eval | **no** full ISS | action (inside shared_context) | **~50–110** |
| **decide_to_react** | When path conflict | **no** full ISS | action (inside shared_context) | **~50–110** |
| **Chat batch** (full convo) | When tier=chat | yes (×2 personas) | chat via `_persona_identity_block` | **~200–280 each** · **~400–560** pair |
| **Greeting** | tier=greeting | no | no | **0** |
| **external_replan** | Only if gateway chat drained | yes | **no** | **~90–175** ISS only |
| **Reflect: insight_and_guidance** | When reflection triggers | **no** | **no** | **0** ← main fidelity hole |
| **Reflect: focal_pt** | With reflection | no | no | **0** |
| **Reflect: memo / planning_thought on convo** | After chats | no | no | **0** |
| **Poignancy** (event / thought / chat) | Per new memory nodes | yes | no | **~90–175** each (high frequency, low “that’s me” leverage) |
| **Chat-with-Double** (gateway) | Offline Talk | ISS fields in system | **no** RPC profile | **~90–200** system traits (not sim step) |

#### Persona-step rollup (identity only, not full prompt)

Assume a “busy” normal step: 1 contextual decomp + 1 decide_to_talk + 0–1 react + 0–2 poignancy + rare chat/reflect.

| Step shape | Identity tokens (today, rough) |
|------------|--------------------------------|
| Quiet routine (decomp only, no social) | **~50–90** |
| Social eval, no full chat | **~100–220** (decomp + decide_to_talk [+ react]) |
| Full chat fires (pair) | **+400–560** once per conversation start (not every step) |
| Reflection wave | **+0** identity today on insights; poignancy may add **~100–350** if several nodes |
| **Likely average busy step** | **~120–250** identity tok/persona |

Plan/hourly are amortized over many steps (day/hour), not every tick.

### 2. P0 delta (compiled directives + wire reflect + wire react)

**Design rule:** replace weak soup / boilerplate with **equal-or-smaller** channel lines. Do **not** stack a third identity layer on calls that already carry ISS + profile.

| Change | Token effect |
|--------|----------------|
| Replace `decision_heuristics` O=/C= soup + verbose speaking_style/summary with short channel lines (plan/chat/react-relevant + one suppress line) | **0 to −40 tok** per profile block if compiled tight; worst **+20** if lines slightly longer than soup |
| Wire **reflect** insights: add **compact** reflection profile only (values/topic line ≤~200 ch), **not** full ISS | **+40–60** per reflection call (rare) |
| Wire **react / decide_to_talk**: prefer **one** compact action directive line in primary input **or** keep existing action profile but shrink it — avoid ISS+profile double | **0 to +30** if we only reshape existing shared profile; **+90–175 worst** if we naively prepend full ISS |
| external_replan / poignancy | **no P0 identity expansion** |

**Added tokens per persona-step (P0):**

| Case | Δ tok / persona-step | How |
|------|----------------------|-----|
| **Best** | **−20 to 0** | Smaller snippets; no new call bodies; reflect not firing |
| **Likely** | **0 to +15** | Replace-in-place snippets; react uses same action budget; reflect rare (~1/N steps → amortized ~+2–5) |
| **Worst** | **+80 to +150** | Full ISS bolted onto decide_to_* **and** full ISS on every insight **and** longer directives — **reject this design in review** |

**P0 implementation mandate:** worst case above is a **bug**. Target the **likely** band; PR fails cost acceptance if smoke shows material token uptick (below).

### 3. Triage — must-have identity vs leave bare (P0)

| Priority | Calls | P0 identity policy |
|----------|-------|--------------------|
| **Must (fidelity)** | Chat batch (in-sim); decide_to_talk; decide_to_react; daily/hourly plan; contextual decomp `profile_context` | Channel-correct directives; **one** identity surface per call (ISS **or** compact profile, not both inflated) |
| **Must (cheap)** | Reflect **insight_and_guidance** only | Compact reflection profile (**≤160 ch / ~40 tok**); skip full ISS |
| **Optional later** | external_replan | Keep ISS-only; do not add profile in P0 |
| **Leave bare / do not grow** | Poignancy (all three); focal_pt; memo_on_convo; planning_thought_on_convo; greetings; pronunciatio / event triples / act_obj formatters; movement_mode | Keep as today; **do not** add profile_context. Poignancy may stay ISS-only (already); do not lengthen ISS for these |
| **Out of sim step** | Chat-with-Double | P0 optional: same compact speaking line in system prompt only if Talk A/B is in scope; else defer to P1 |

**Rationale:** “That’s me” is won on **plan stickiness, talk initiation/tone, react join/withdraw, reflect themes** — not on whether poignancy scores 4 vs 5.

### 4. Hard caps (absolute, on top of ratios)

Propose **absolute char caps** applied inside `build_profile_context_block` **after** render, **before** ratio cap (take `min(ratio_cap, abs_cap)`):

| task_type | Absolute `[profile_context]` cap | ~tok | Intent |
|-----------|----------------------------------|------|--------|
| **planning** | **320 ch** | ~80 | 2 lines: C/E plan directive + suppress |
| **action** | **280 ch** | ~70 | React/talk: E initiate + A repair + suppress |
| **chat** | **360 ch** | ~90 | speaking + optional social_rules one-liner |
| **reflection** | **200 ch** | ~50 | Theme bias only (duty/threat/other/meaning) |
| **auto** | **300 ch** | ~75 | Fallback |

**ISS** (separate): no P0 growth. Optional later clamp for bloated soul15 ISS on high-frequency paths only — **not** required for P0 if we refuse to attach ISS to decide_to_*/poignancy expansions.

**Directive compile:**

- Pure function from `domain_means` + `labels` (and optional existing summary **clipped**).
- Runs at **quiz write + backfill only** → **zero LLM cost**, deterministic, unit-testable.
- Runtime only **reads** snippets (existing RPC + cache); no per-step compile LLM.

### 5. P0 acceptance — cost (add to eng P0)

On a **fixed 60–100 step** smoke (same roster, maze, model tier config, comparable wall clock window):

| Metric | Baseline | P0 bar |
|--------|----------|--------|
| `sim_cost_daily.tokens_in` (or sum `LLM_METRIC` prompt tokens) / steps completed | B | **≤ B × 1.05** (**material = +5%**; soft watch at +3%) |
| tokens_in **per persona-step** (total prompt tokens / (steps × alive personas)) | b | **≤ b × 1.05** |
| Identity-related: optional counter of profile_context chars injected (if logged) | — | mean profile block ≤ abs caps above |
| Naturalness Gate | pass | still pass (unchanged bar) |
| Adherence smoke | — | qualitative E or C pole movement without cartoon |

**If +5–10%:** stop; strip double-injection (ISS+profile) and shorten directives before any fidelity tune.  
**If >+10%:** P0 fail — do not merge.

**How to measure:** one baseline run + one P0 run; compare `sim_cost_daily` / verification export routing totals; same `sim_code` fork recipe.

### P0 cost summary (one screen)

1. Today identity is **moderate** on plan/chat, **thin** on decide_to_*, **absent** on reflect insights, **repeated** on poignancy.  
2. P0 should be **replace-not-stack** → likely **~0–15 tok/persona-step**.  
3. Must-have: plan/decomp, decide_to_talk/react, chat, compact reflect. Bare: poignancy growth, formatters, greetings.  
4. Abs caps: planning 320 / action 280 / chat 360 / reflection 200 ch; compile = deterministic, $0 LLM.  
5. Ship bar: **≤+5% tokens/step** on 60–100 step smoke + Naturalness hold.

---

## Key citations (quick index)

| Area | Path |
|------|------|
| Brief | `double-ivan/20260810_realism_matriAIx.md` |
| Doctrine | `COS/tasks/2026-08-10-001/final.md` |
| Validation split | `COS/agents/willwright/kb/wiki/decision/matraix-validation-split.md` |
| Trait pack | `COS/agents/jordanpeterson/kb/wiki/decision/minimal-double-trait-pack.md` |
| Q6 ceiling | `double-docs/sot/sot_sim.md` §Q6 |
| Naturalness Gate | `double-docs/sot/sot_lifecycle.md` §4 |
| Profile injection SOT | `double-docs/sot/sot_prompts.md` |
| Talk + external_replan | `double-docs/sot/sot_chats.md`, `sot_realism.md` |
| Quiz pipeline | `api_gateway/app/services/quiz_profile_service.py` |
| Snippet builder | `reverie/.../profile_context_builder.py` |
| ISS card | `reverie/.../scratch.py` `get_str_iss` |
| Identity block | `run_gpt_prompt.py` `_persona_identity_block` |
| Reflect gap | `run_gpt_prompt_insight_and_guidance` inputs = statements only |
| Talk gateway | `api_gateway/app/services/chat_with_double_service.py` |
