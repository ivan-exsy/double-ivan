# Realism charter — “That’s me” Double fidelity (MatrAIx → eng)

**Date:** 2026-08-10 (amended same day: interpretation honesty + post-MVP review foreword)  
**Status:** charter locked as starting point; **eng deferred to post-MVP** (stronger Grok expected)  
**Evidence (deep dive):** `done/20260810_realism_matriAIx_findings.md`  
**Doctrine:** `COS/tasks/2026-08-10-001/final.md` · Will Wright `matraix-validation-split` · Jordan Peterson `minimal-double-trait-pack`  
**Paper:** [MatrAIx arXiv 2608.04205](https://arxiv.org/html/2608.04205v1)

---

## Foreword — post-MVP re-investigation (stronger model)

**Intent:** Ship this work **after MVP**. By then, run implementation (and any re-plan) with a **much stronger Grok** as the working model. Treat **this document as the starting point**, not the final design.

### What a follow-up agent must do
1. **Re-read this charter end-to-end**, then `done/20260810_realism_matriAIx_findings.md`, then live code under `generative_agents` (quiz → profile snippets → plan/chat/react/reflect prompts). Do not trust §2 alone — plumbing may have moved since 2026-08-10.
2. **Re-run a focused investigation** with this doc as the hypothesis set. Confirm or revise P0/P1/P2 against current SOT (`sot_sim` Q6, `sot_memory`, `sot_lifecycle` Naturalness Gate, `sot_realism`).
3. **Dig specifically into Interpretation honesty** (below). That is the load-bearing open problem: we cannot assume the runtime LLM is a human-behavior expert that will correctly turn a psych profile into situation-appropriate decisions. The follow-up must propose (and stress-test) the balance of:
   - **sufficient context** (what to inject, per channel, under cost caps),
   - **model intelligence** (what we can safely leave to the stronger Grok),
   - **behavior accuracy / realism** (what must be pre-translated, code-prior’d, or measured — not hoped).
4. **Preserve constraints unless founder lifts them:** ≤ +5% tokens/step on smoke; replace soup don’t stack; Naturalness Gate non-regression; no MatrAIx catalog/coreset/MBTI/playground transplant; teen/privacy posture on public fidelity claims.
5. **Deliverable of the re-investigation:** an updated recommendations section (or a dated sibling note) that either green-lights P0 as written, or replaces it with a sharper P0 that still fits cost + interpretation honesty. Then eng on `ivan/*` only after founder **go**.

### What not to redo from scratch
Doctrine (validation split, thin IPIP spine, express-or-suppress) and cost triage are **accepted starting beliefs**. Challenge them with evidence if the stronger model finds them wrong — do not silently discard them.

---

## 1. Why improve realism (MatrAIx vs our goals)

### What MatrAIx is
Population-scale **simulated-user evaluation** (typed personas + independent Survey/Chat/Web/App trials). It is **not** a persistent multi-agent world. Their matrix marks multi-agent social simulation as a non-goal — that is our lane.

### What we steal (doctrine)
| Steal | Skip |
|-------|------|
| Separate **world naturalness** vs **persona adherence** | 1,290-dim schema / Persona 1M coreset |
| Thin structured identity (IPIP spine) + dependency/coherence | MBTI as behavior driver |
| Fidelity = **express OR correctly suppress** | Independent-trial playground as runtime |
| Model-as-config honesty on fidelity claims | Their 91.5% style score as our ship bar |

### What Doubland means by realism & naturalness
Two product bars — **never one score**:

1. **World naturalness (already gated)** — walking, dwell, place honesty, chat integrity → Naturalness Gate (`sot_lifecycle` §4).  
2. **“That’s me” fidelity (gap)** — for the same Measured IPIP identity, the Double’s **plan / chat / react / reflect** should feel like that person: show the trait when the scene calls for it, stay quiet when it doesn’t.

Our SOT already names the ceiling: free-text traits drift across LLM calls (`sot_sim.md` Q6). Naturalness Gate does not score identity.

### Cost constraint (founder)
Many LLM calls per step. Maximize “that’s me” **without** growing context until costs blow up. Prefer **replace weak identity text** over stacking more. Hard P0 bar: **≤ +5% tokens/step** on a fixed smoke vs baseline.

### Interpretation honesty (founder — load-bearing)
We **cannot** treat the runtime LLM as a psychology expert and prompt “act based on this psychological profile,” hoping it will figure out how that person would decide in a given situation.

**Design goal:** the right balance of **sufficient context**, **model intelligence**, and **behavior accuracy / realism** of the output.

| Lever | Role |
|-------|------|
| **Pre-translated context** | At quiz/backfill, compile short **situation-actionable** channel lines (prefer / avoid / tone + one suppress). Runtime reads them; it does not invent trait→behavior from O=/C= soup or soft labels. |
| **Model intelligence** | Follows concrete instructions in scene context. Stronger post-MVP Grok may widen what we can leave soft — only after re-investigation proves it. |
| **Verification** | Opposite poles + express/suppress; named behavioral deltas — not vibes, not “directives present.” |

**Banned as the primary identity surface:** soft labels (“you are high Extraversion”), full-profile dumps, or “act according to this Big Five profile.” MatrAIx itself found soft style transfers worse than **executable** directives; failures concentrate on **suppression**.

**Open for post-MVP review:** how much of decide_to_talk / react / plan can stay LLM-only with better lines vs light **code priors** (e.g. initiation bias from E). Current P0 assumes better lines first; code priors are P1-or-revisit.

---

## 2. Findings in current implementation (brief)

Full trace + tables: `done/20260810_realism_matriAIx_findings.md` (re-verify live code in any post-MVP pass).

### Plumbing
- Quiz stores **Measured** `domain_means` / labels in `user_personality_profiles` (+ `dbl_agent.config`).
- Publishes prose `innate` + three snippets (`values`, `speaking_style`, `decision_heuristics`).
- Runtime almost never uses Big Five as **numbers** — only free-text ISS + `[profile_context]`.
- Self-serve quiz does **not** write `social_rules` / `do_not_do` / `topic_attractors` (soul15 import does).

### Channel gaps
| Channel | Today | Gap |
|---------|-------|-----|
| **plan** | ISS + weak `O=/C=/E=` soup | No C-stickiness / E-social goals / suppress |
| **chat** | Generic speaking_style; Talk = ISS only | No A-blunt / E-volume / N-worry directives |
| **react** | Action profile, no full soul; fail-safe greets | Low-E still pushed social; no repair/withdraw map |
| **reflect** | Insights = statements only | **No identity** — biggest cheap hole |
| **place/social** | Onboarding prose fit | No structured poles (defer; don’t fight place laws) |

### Cost snapshot (today → P0)
- Identity today ~**120–250 tok/persona** on a busy step (chat pair is a spike).
- P0 must **replace soup, not stack**; likely Δ **0 to +15** tok/step; worst **+80–150** if full ISS bolted onto react/reflect = **reject as bug**.
- Absolute `[profile_context]` caps (on top of ratios): planning **320** · action **280** · chat **360** · reflection **200** ch.
- Compile directives at quiz/backfill = **$0 LLM**, deterministic.

---

## 3. Detailed improvement recommendations

### Principles
1. Keep Naturalness Gate; add **Persona Adherence Gate** (separate artifact).  
2. Thin **IPIP-BFM-25** spine only (+ optional risk/NFC/attachment later if channel-wired).  
3. One identity surface per call when possible; **equal-or-smaller** than today’s soup.  
4. Express **and** suppress in directives and in tests.  
5. **Interpretation honesty:** executable channel directives (prefer/avoid/tone), not soft psych labels or “act per profile.”  
6. No MatrAIx catalog / coreset / MBTI / playground transplant.  
7. No normative SOT rewrite until implement + green score.

### P0 — Ship first (post-MVP; after re-investigation or founder go)
**Effort:** ~0.5–1.5 days (estimate at lock time) · **Risk:** low · **Repo:** `generative_agents` on `ivan/*`

| # | Change | Notes |
|---|--------|--------|
| 1 | **Channel directive compiler** from `domain_means`/`labels` | Replace `Lean toward O=…` + verbose speaking_style with **1–2 executable lines** (prefer/avoid/tone for that channel) + **one suppress line**. Ban soft “you are high-E” as the main surface. |
| 2 | Quiz submit + **backfill** self-serve personas | Write `decision_heuristics`, `speaking_style`, and `social_rules` if missing |
| 3 | **Wire reflect** | Compact reflection profile only (≤~160–200 ch) into `insight_and_guidance` — **not** full ISS |
| 4 | **Wire react / decide_to_talk** | Compact action identity in primary inputs; reshape existing action profile — **do not** prepend full ISS |
| 5 | Leave bare | Poignancy, greetings, formatters, focal/memo/planning_thought; **external_replan stays ISS-only** |

**P0 acceptance**
- [ ] Opposite-pole unit test: compiled directives are **executable** (prefer/avoid/tone + suppress), present, under abs caps — not soft trait labels  
- [ ] 60–100 step smoke: Naturalness Gate non-regression  
- [ ] Cost: `tokens_in` / step **≤ baseline × 1.05** (watch at +3%)  
- [ ] **Named behavior delta:** high vs low **E** shows a measurable difference (e.g. talk-initiation rate or withdraw-on-conflict), not only “prompts look different”  
- [ ] PR review rejects any design in the “worst” token band (+80–150) and any “act according to this profile” dump

### P1 — After P0 shows a visible delta
- Structured means readable at runtime (validators; fingerprint).  
- Budgeted channel lines by `task_type` (Peterson map); optional **situation→behavior** tables if re-investigation requires them.  
- Light **code priors** on decide_to_* if lines alone underperform (revisit under Interpretation honesty).  
- Cast soft/hard masks for operator rosters.  
- **Persona Adherence Gate v0** (8 poles in findings §D — express + suppress; code-first rates + thin LLM judge for tone).  
- Optional: Talk system prompt gets same compact speaking line.  
- Log persona-agent model (+ judge) on every adherence report.

### P2 — Later / privacy-gated
- Talk sim-to-real: refusal, correction, abandonment, next-turn vs **shuffled-persona** baseline.  
- Human recognition study before any public “scientifically you” claim.  
- Teen psychographic / marketing review required.

### Persona Adherence Gate v0 (summary)
Opposite poles, same maze/day window, same model. Score express **and** suppress. Never fold into Naturalness GO/NO-GO. Cheapest trustworthy: 60–100 step code metrics on E/C + 2 LLM-judged tone poles. Detail: findings §D7–D9.

### Explicit non-goals
1290-dim schema · Persona 1M as Double truth · MBTI driver · playground runtime · growing poignancy identity · replacing Naturalness Gate · FE quiz redesign as P0 blocker · hoping a stronger model alone fixes fidelity without interpretation honesty.

---

## How to use this doc

| Role | Action |
|------|--------|
| **Founder** | Hold eng until post-MVP; then kick **re-investigation** (Foreword) before or with P0 |
| **Follow-up agent (stronger Grok)** | Start here → findings → live code; deep-dive Interpretation honesty; revise §3 if needed |
| **COS / CTO** | After green re-investigation + founder **go**, turn §3 P0 into an `ivan/*` implement brief |
| **BE** | Implement against locked §3 + findings cost addendum; keep findings as evidence appendix |

**Suggested next step (now):** park until post-MVP. **Then:** re-investigation under Foreword → founder **go P0** → `@cto` on `generative_agents`.
