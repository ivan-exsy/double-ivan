# True Doubles — research KB

**Date:** 2026-08-23  
**Owner:** Ivan  
**Status:** research note (no code) · §0 is live-impl context for the chat RCA  
**Goal:** every Double should be perceived as a true representative of its human alter-ego.

This note collects what we can steal for that goal. It is not an eng plan. The locked charter remains `TODO_realism_matriAIx.md` and the plumbing evidence remains `done/20260810_realism_matriAIx_findings.md`.

---

## Verdict in one screen

A Double is “true” only when **four tests** pass together. No paper we reviewed passes all four.

| Test | Meaning | Best evidence today |
|---|---|---|
| **Source grounding** | The identity card is supported by the human’s own words and acts, not invented | Park 1,000 people; MatrAIx extraction rubric |
| **Express or suppress** | The trait shows when the scene calls for it, and stays quiet when it does not | MatrAIx 91.5% Opus / 79.2% GPT-5.6 |
| **Continuous self** | The same person persists across many steps, not one clever answer | BehaviorChain (SOTA <60%); Persistent Personas (fade after ~7 goal rounds) |
| **Recognition** | The human (or a close other) says “that’s me / that’s them” | IMPersona 44% pass even with fine-tune + memory; Park interview agents beat quiz-only |

**Hard product facts**

- A quiz label is not a person. Interviews beat demographics and short bios. Combined interview + survey is best, then gains flatten.
- Soft labels (“you are high Extraversion”) fail. Executable if–then lines work better.
- **Token thrift and interpretation honesty pull opposite ways — both stay required.** A thin prompt that only says “C=high” is cheap and the model will *guess* behavior. A full soul dump is honest-looking and too expensive, and still washes to the model’s default voice. The RCA must not pick one goal and drop the other.
- The model that *plays* the Double is part of the identity. Same persona, different model → wildly different choices.
- Self-report is easy. Observer report is harder. Friends detect fakes when they text often.
- Early errors compound. Long village days will wash a Double back toward the model’s default voice.
- Per-user “accuracy” can look good while the *set* of Doubles collapses toward a bland average.
- A self-report quiz is a real signal, but a modest one. Friends, language, and what the person *does* add validity the quiz misses. Rare acts are not predictable from traits.
- Do not claim scientific representation until a human recognition study says so.

---

## 0. Current implementation (2026-08-23)

Context for the chat-naturalness / personality RCA. **Not a new charter.** Eng stay on `TODO_realism_matriAIx.md`. Plumbing detail: `done/20260810_realism_matriAIx_findings.md`. Chat contract on paper: `double-docs/sot/sot_chats.md` (lags the code — see §0.3).

Live village evidence below is from Survival score **`20260823-2`** at ~step **1496** (Premiere + next morning). Walk / place honesty was green. Chat was not.

### 0.0 Two goals that look like they fight (they both stay)

This is the load-bearing design problem for the RCA. It is already named in the charter as **cost** vs **interpretation honesty**. Do not resolve it by dropping either side.

| Goal | What it forbids | Naive “fix” that fails the other goal |
|---|---|---|
| **Token thrift** | Dumping the whole person into every plan / chat / react / reflect call | Send only the dry assessment that seems on-topic (“this talk is social → Extraversion=high”) |
| **Interpretation honesty** | Treating the acting model as a behavior scientist who can turn a Big Five score, a label, or a one-line trait into the *right* act | Paste more of the card, the quiz means, and a psych lecture so the model can “figure it out” |

**Why they are not a real either/or.** Tokens want *less text per call*. Honesty wants *less translation work left to the model*. Those agree if the runtime sees a **short, already-translated, situation-bound line** (prefer / avoid / tone + one suppress) and does **not** see a score it must interpret. They fight if “relevant traits only” means “relevant *labels* only,” or if “don’t trust the model with dry scores” means “send the whole biography every step.”

**What “relevant” is allowed to mean**

- Allowed: a compiler (quiz / interview / backfill, *not* the hot-path LLM) picks 1–3 **executable** lines that match *this* scene type (café small talk vs inventory vs conflict vs sleep). Unused lines stay out of the prompt.
- Not allowed: the hot-path model receives `O=4.1 C=2.8 E=3.9` (or “high Extraversion”) and is asked to predict what that person would say or do.
- Not allowed: growing the per-step card to buy fidelity. Charter P0: **replace soup, do not stack.** ≤ **+5%** tokens/step on a fixed smoke.

**What today’s impl does (so the RCA can see the squeeze)**

- We already spend tokens on a **wide** card every village chat (full ISS + style/values + memories) — the opposite of thrift.
- That card is still **soft** (“lean toward choices that fit O=/C=/E=…”) — the opposite of honesty. The model must invent trait → line.
- Result on `20260823-2`: spend is high, adherence is low, everyone sounds like the acting model. More soup will not fix this. Drier scores will not either.

**RCA must propose a third shape**, not a winner between the two columns: *when* to compile, *how short* a scene line can be and still be executable, *who* chooses relevance (code / retrieve / offline compiler — not “the chat model reads the Big Five”), and how we **measure** that a shorter prompt did not become a cartoon or a default voice.

### 0.1 Two talk surfaces (do not mix scores)

| Surface | Who talks | How it starts | Who writes the words | Where it shows |
|---|---|---|---|---|
| **Village chat** | Double ↔ Double | Proximity + `ConversationManager` (no LLM in the *decision*) | One **batch** LLM call per chat (Tier B; this score used DeepSeek v4 flash) | Phaser bubbles via movement `chat` / `chatting_with` / `chat_metadata` |
| **Talk-with-Double** | Human ↔ one Double | User POST | **Tier C** (deeper model), memories via pgvector | Talk tab, not the village |

Village chat is the RCA target for “does the town sound like people.” Talk-with-Double is the cheaper surface for Park / IMPersona **individual** tests. A good Talk score does **not** prove village chat.

The **acting model is part of the identity** (§1.3). Village and Talk already use different backbones. Do not treat a DeepSeek village line and a Tier-C Talk line as the same Double.

### 0.2 Identity card today

```
Quiz (IPIP-BFM-25) and/or soul import / interview
  → user_personality_profiles + snippets + ISS on scratch
      innate / learned / currently / lifestyle   (free-text card)
      snippets: speaking_style, social_rules, values_and_principles
                (+ decision_heuristics, do_not_do on some paths)
  → every village chat call: ISS + chat-task snippets + retrieved memories
  → Talk-with-Double: ISS + “respond as yourself” + retrieved memories
```

- **Innate is frozen.** A chat must not rewrite the card without consent.
- Quiz snippets are **soft labels** (“Adult conversational voice…”, “Lean toward choices that fit O=… C=…”). They are not executable if–then lines (§4.2).
- Self-serve quiz does **not** write `social_rules` / `do_not_do`. Soul15 import can. Owned Doubles are thinner than the soul15 cast.
- Chat **does** re-inject the card every generation (good vs Persistent Personas fade). Plan / react / reflect get a **weaker or empty** card. The 2026-08-10 finding still holds: we store Big Five **numbers** and almost never *use* them as numbers.
- Memory is Supabase-primary (`dbl_memory`). Village chat retrieves partner-focused thoughts + recent talks + reflections, then a standard retrieve. Write-back exists. Empty / no-op steps can still pollute (MiroFish §2.1.5 is not fully true here).

### 0.3 How village chat actually runs

Paper SOT still describes `classify_chat_tier`, `PAIR_CHAT_COOLDOWN_STEPS=15`, greeting templates, and turn-by-turn `agent_chat_v2`. **That is not what runs.**

**Decision (deterministic)** — `ConversationManager.should_converse`

- Sleeping, already chatting, too far: no.
- First meet of the in-sim day can bypass cooldown once.
- Else: overlap + same room → greeting vs full, exchange cap, satiation cooldown (~**1–8** sim-minutes). Cafe liveliness can cut more; a **5-minute** floor tries to stop pair-spam.
- **End** of a chat stamps a *different* bar: **5 / 15 / 30** minutes by depth, then cafe −2. Start-path satiation is **not** what gets stamped. Analyzer `CHAT_COOLDOWN_VIOLATION` scores this end bar.

**Words (one LLM call)** — `generate_conversation_batch`

- Prompt: both ISS cards + speaking_style/social_rules/values + location, time, activities, atmosphere, “times talked today”, memories.
- Asks for natural 1–3 sentence lines. **Does not** say “never mention the simulation.” Talk-with-Double SOT *does*.
- Greeting templates and iterative `agent_chat_v2` are leftover / fallback, not the happy path.
- Each `start_conversation` mints a **new `conversation_id`**. Same pair, same sofa, six minutes later looks like a new talk. They often **greet again**.

**Volume on `20260823-2`:** 794 distinct chats, 104 pairs, someone talking on ~475 of 1496 steps. Top pairs re-open on a **~15 min** median. That is a busy café, not a quiet town.

### 0.4 What the last score actually sounded like

Jobs show. Voices do not.

- Role objects appear (~48% of chats): dough, espresso, shelves, pharmacy, library.
- **~29%** name the sim, Doubland, the experiment, or the backend. **~41%** sound like a debug stand-up (system, SKU, sensor offset, “lazy backend”).
- One house style: long, witty, analytic. Ivan is a bit longer; Olivia a bit shorter. Lexicons still collapse to *I’ll / that’s / system / same*.
- Same greeting reused across pairs (“Good morning! Yeah, slept okay.”). After a long bathroom theory talk, the next open is “Morning!”
- Analyzer: **213** cooldown flags (end-bar 15/30). Many gaps are 6–15 minutes. Some are true re-opens; some are one sit split by a new id.

**Mapping onto the four tests**

| Test | Today |
|---|---|
| Source grounding | Quiz + optional interview + soul import. Null-on-unknown is intended; quiz still *fills* soft style lines. No MatrAIx claim-validity rubric on extracts. |
| Express or suppress | Not scored. Chat prompt has no suppress arm. Extraversion-as-clever-analyst fires in bathrooms, cafés, and libraries. |
| Continuous self | Card is re-injected, but the *model default* wins by mid-morning. New conversation ids break “we already talked.” BehaviorChain streaks are not measured. |
| Recognition | Never run. We have not asked a human “is that me / can you tell Anya from Jordan.” |

Naturalness Gate (`sot_lifecycle` §4) scores **body and chat integrity** (payload, stall, venues). It does **not** score “that’s me.” A green walk + a green payload can still be a town of one writer.

### 0.5 Limitations the RCA should treat as facts

1. **World naturalness ≠ persona adherence.** Keep two scores. This tip’s walk bar is not the chat bar.
2. **SOT lag.** Do not design from `sot_chats.md` env flags (15 / 45 min, 90% brief pass). Design from `ConversationManager` + the batch prompt.
3. **Soft card, strong model prior.** We inject prose. The acting model (flash-class) rewrites everyone into one systems-analyst. Interpretation honesty is not optional: the LLM is not a psych expert. Token thrift is not optional either. See §0.0 — do not “fix” one by violating the other.
4. **Continuation is broken.** New id + re-greet + “Hey again” after they never left.
5. **Fourth wall is legal in village chat.** The batch prompt never forbids “we are in a simulation.” The cast uses it as a shared hobby.
6. **Talk Path A is on hold.** Cadence / seek / anti-loop work is not on this Survival tip.
7. **Judge contamination.** A same-family model must not be the only scorer of Talk or village voice (§1.4).
8. **Cast collapse.** Fifteen Doubles can all be “plausible” and still be one average person (§3.5). Distinctness is unmeasured.
9. **Owned Doubles are thinner than soul15.** RCA on this score is a **soul-imported** 15. Self-serve quiz Doubles get fewer snippets.
10. **No human recognition study.** Do not turn any RCA metric into a public “scientifically you” claim.

### 0.6 Goals this RCA is allowed to aim at

Research goals only. **No eng until founder go.** Do not replace P0/P1/P2.

- Separate **town naturalness** (how often, how long, when to stop, when to continue) from **persona adherence** (would *this* person say that, and stay quiet when they would not).
- Propose measurements that match the papers: express **and** suppress; shuffled-persona / no-persona on Talk; between-Double distinctness; multi-step **streaks**, not one clever reply.
- Say whether the fix is **card shape** (if–then vs soft labels), **re-inject cadence**, **prompt law** (no fourth wall, no re-greet), **cooldown / continuation**, **acting model**, or **evaluation only**.
- Any proposal must hold **both** §0.0 constraints: fewer tokens per call **and** no hot-path “act from this Big Five / dry trait.” Prefer a short compiled scene line over a smaller dump of scores *or* a larger dump of biography.
- Keep cost doctrine: replace soup, do not stack. Hard P0 bar remains ≤ +5% tokens/step on a fixed smoke.
- Keep humble claims. Simulated result → hypothesis. Human study → claim.

**Out of scope unless the founder lifts it:** MatrAIx catalog, MBTI, fine-tune on private messages, clinical language, stopping `20260823-2` for chat voice.

### 0.7 Suggested improvements (research → RCA, 2026-08-23)

Synthesis of §§1–8 + live §0. **Not a new charter.** P0/P1/P2 in `TODO_realism_matriAIx.md` still win. Deep-research-2 status: **Partial** — it mostly confirmed the locked P0; it did not invent a new architecture.

**MVP-blocking idea in one line:** do not add more personality text on the hot path. Replace today’s soft soup with short compiled scene lines, persist the same sofa talk, and score “would this person say that” apart from town naturalness.

#### What the pass confirmed in code (and one correction)

- Village chat still dumps **both** speakers’ full ISS + style/values + both memory blocks every generation. That is the opposite of token thrift.
- Planning still sends **Lean toward O=/C=/E=** via `decision_heuristics`. That is the opposite of interpretation honesty.
- **Correction vs §0.0 wording:** that exact O=/C=/E= string sits on **plan / action**, not on the village chat batch. Chat `task_type` omits `decision_heuristics`. Chat’s failure is a **wide soft ISS + house voice**, not the numeric soup line.
- Quiz Doubles still persist only three soft snippets. They do not write `social_rules` / `do_not_do`. The hot path has nothing executable to read unless a compiler writes it at quiz/backfill.
- `decide_to_react` does not call `get_str_iss()`. Reflect (focal / insight / memo) takes statements only.
- Talk-with-Double injects ISS fields + “respond as yourself,” and attaches **neither** profile snippets nor `daily_plan_req`.
- Each `start_conversation` mints a new id from the two names + the current step. Same sofa → new talk → re-greet.
- Soul `do_not_do` can exist in the DB; Python chat snippet order **drops** it, so it never reaches village chat.

Rates in §0.4 (~29% fourth wall, ~41% debug stand-up, 794 chats) live in this note. The pass did **not** re-count movement dumps. Treat them as working RCA facts, not independently re-verified.

#### Ordered moves (research goals only — founder go still required)

| # | Move | Why (from this KB) | Holds §0.0? |
|---|---|---|---|
| **A** | **Compile once, replace soup.** Deterministic function over `domain_means` / labels at quiz write + backfill. Emit 1–2 if–then prefer/avoid/tone lines **per channel** + **one suppress line**. Write into `speaking_style` / `decision_heuristics` / `social_rules` (and `do_not_do` if missing). Zero LLM at compile. Runtime only reads. | MatrAIx: executable > soft. Park: interview knowledge still needs a compiled surface. Charter P0. | Yes — shorter than today’s soup, no dry scores on the hot path |
| **B** | **One identity surface per call.** Drop the full ISS dump from village chat and from plan. Pick 1–3 **scene-type** lines (café vs inventory vs conflict vs sleep). Unused lines stay out. Caps stay: plan 320 / action 280 / chat 360 / reflect 200 ch. Smoke: tokens/step ≤ baseline × 1.05. Bolting ISS onto the new lines is a **reject**. | Persistent Personas: re-inject compact card, not a novel. Token addendum. | Yes |
| **C** | **Close the holes, do not grow poignancy.** Same budgeted lines on react + compact reflect (≤200 ch) + Talk system prompt. Leave poignancy / greetings / formatters bare. | §0.2 + findings A2. Identity is empty where “that’s me” is decided (join/withdraw, insight themes, Talk voice). | Yes if replace-not-stack |
| **D** | **Persist the open pair.** One `conversation_id` until an explicit end. No re-greet when they never left. Prompt law: never name the simulation / Doubland / backend. | §0.3–0.5. This is **ConversationManager + prompt law**, not card shape. Card compile will not stop “Morning!” on the same sofa. | Neutral on tokens; required for continuous self |
| **E** | **Keep two scores.** Naturalness Gate = body + chat integrity (how often, how long, when to stop). Persona Adherence = express **and** suppress; between-Double distinctness; Talk shuffled-persona / no-persona; multi-step streaks. Never fold into Naturalness GO/NO-GO. Second-model or human judge — not the same-family writer. | §§1.2, 1.4, 3.2, 3.5, 8.3 | Measurement only |
| **F** | **Acting model is a lever, not the first patch.** Flash-class village voice is collapsing the cast. Measure distinctness after A–D. Only then consider a different village backbone. Size ≠ persona skill (PersonaGym). | §1.3, §3.8, §0.4 | Do not spend tokens hoping a bigger model interprets O=/C=/E= |

**Do not do**

- More ISS / quiz means / psych lecture on the hot path.
- “Relevant traits only” as dry labels or `E=3.9`.
- Same-inventory re-quiz of the Double as proof (InCharacter).
- Fine-tune on private messages, MBTI, MatrAIx catalog, covert Likes/sensors.
- Public “scientifically you.”
- Stopping `20260823-2` only to retune chat voice.

#### How we would know A–D worked (hypothesis, not a ship bar)

No inspected source gives a numeric “shorter prompt is safe” threshold. Propose this measurement set, then score it:

1. Token smoke: ≤ +5% vs a fixed 60–100 step baseline; mean profile block under the abs caps.
2. Town: fourth-wall and debug-stand-up **rates fall**; same-sofa re-greet **falls**; cooldown flags are real re-opens, not split ids.
3. Twin: opposite-pole E/C pair shows a named delta (talk start rate / schedule stick) **and** a suppress arm that stays quiet. Distinctness: a second-model or human can tell two Doubles apart above chance.
4. Talk (separate score): next-turn vs shuffled-persona / no-persona. Does not certify village chat.

If A–C pass cost and D fixes continuation, and voice is still one writer, **then** open F (acting model). Do not open F first.

---

## 1. MatrAIx — [arXiv 2608.04205](https://arxiv.org/abs/2608.04205)

**What it is:** a population-scale *simulated-user test bench* (Persona 8B + Survey / Chat / Web / App playground).  
**What it is not:** a persistent multi-agent village. Their own comparison table marks multi-agent social simulation as a **non-goal**. That is our lane.

Project: [matraix.ai](https://matraix.ai) · coreset: ~1M personas (599,847 human-grounded + 400,000 synthetic).

### 1.1 Identity construction

- **Typed schema, not a blob.** 1,290 categorical dimensions under five groups: Background (238), Psychology (210), Capability (331), Behavior (124), Lifestyle (387). Useful idea: typed fields can be queried, contradicted, and left **null**.
- **Do not import the catalog.** 1,290 dims are a product-eval instrument. They would poison our prompts and our teen-privacy posture. Steal the *discipline*, not the width.
- **Two complementary paths.** Synthetic records are sampled from a dependency graph (priors × correlations × hard compatibility masks). Human-grounded records map Wikipedia, Amazon reviews, Stack Overflow, GSS, PRISM, and 355 consented self-reports into the same schema.
- **Null beats invention.** Unsupported fields stay empty. “Human-grounded” names the *origin*, not a guarantee that every field is a verified fact.
- **Hard masks vs soft adjustments.** English-as-primary + English-proficiency=None is *forbidden*. Rare-but-possible combinations stay allowed. That split is how you keep a population coherent without killing odd-but-real people.
- **Calibration is only four marginals.** Age, region, gender identity, urbanicity. They do **not** claim joint truth over 1,290 dims. Corpus size ≠ execution scale: a record becomes an agent only when paired with a model, interface, and task.
- **Extraction quality rubric (steal this).** Five scores, 1–5:
  1. Claim validity — value + cited evidence + free-text description must stand together.
  2. No over-claiming — do not populate a field with no basis.
  3. Coverage — do not omit a fact the source clearly gave.
  4. Internal consistency — no contradictions on core identity.
  5. Overall fidelity — usable for role-play; inferred traits stay plausible.
- Human mean on 100 personas × 6 raters: **4.135 / 5**. 97.2% of rater pairs within 1 point. Opus as judge is within 1 point of the human mean in **93.8%** of cases; GPT 5.5 in **79.2%**.

**Doubland take:** our IPIP + interview + post-chat path already matches their “grounded + null > invent” posture. Use their five-metric rubric on soul cards and interview extracts. Keep innate frozen. Do not fill missing teen fields from Wikipedia-style inference.

### 1.2 Adherence is express *or* correctly suppress

400-trial probe: 10 style attributes × 4 environments × 5+5 opposite-pole personas.

- Opus 4.8: **366 / 400 = 91.5%** (33/40 cells strong).
- GPT-5.6-sol (not 5.5): **317 / 400 = 79.2%**.
- Haiku is **not** in this probe.
- Survey / Chat / Web: 9 of 10 attributes strong. App / OS: 6 of 10.
- Failures cluster. Half of Opus misses are in OS-App. Suppression is harder than expression.
- Alignment fights persona: agents asked to be impolite often refuse. GPT-5.6 **never** produced the rambling/verbose persona (0/5 in all four environments). Soft style transfers worse than executable style (code comments, naming).
- The judge must cite **verbatim behavior**, not the persona restating its own trait.

**Doubland take:** this is the load-bearing definition. A Double that performs Extraversion every turn is a cartoon, not a twin. Directives and tests must both have a suppress arm. Do not use 91.5% as our ship bar — different product, different judge, App already weaker.

### 1.3 The acting model *is* the Double

Same personas, same 8 tasks, three brains. Product answers diverge:

| Task | GPT 5.5 | Opus 4.8 | Haiku 4.5 |
|---|---|---|---|
| Hesitate at a price rise | 98.3% | 27.0% | 83.3% |
| Pick a paid Notion plan | 75.8% | 23.2% | 93.9% |
| Keep using OpenBB after a fail (unsure) | 81.3% | 85.5% | 28.1% |
| Very likely to book a checkup | 50.5% | 41.4% | 29.7% |

- 7 of 8 tasks: significant three-model gap.
- Median Spearman ρ of *subgroup orderings* across 22 pair-by-task comparisons: **+0.29**. Only OpenBB trust-level ranked the same under all three (ρ = +1.00).
- Paired agreement on 88 joinable fields: median Cohen’s κ ≈ **0**.
- Age-band self-report: Haiku **100%**; GPT 5.5 **16.3%** and Opus **16.9%** — both at chance.

**Doubland take:** log the persona-agent model on every fidelity claim. Never treat Opus / GPT / Haiku Doubles as interchangeable. Pick one acting model for a village, or report split. A “that’s me” result on one backbone does not transfer.

### 1.4 Self-preference trap

If the model that *plays* the Double and the model *behind the product* share a backbone, a good score is ambiguous. The Double may like its own voice. MatrAIx did not isolate this. They warn: run at least one persona model that does **not** share the product backbone before you trust the result.

**Doubland take:** Talk-with-Double and in-sim chat must not be scored only by the same model that generated the utterance. Use a second-model spot-check or a human before any public claim.

### 1.5 What they did *not* prove (and we must)

They say this plainly in Appendix M:

- A simulated cohort is **not** a probability sample of real people.
- Adherence ≠ resemblance. They did not measure disclosure, correction, refusal, or abandonment the way humans do.
- They propose two missing tests we should own:
  1. **Population:** compare simulated vs real logs on turn length, question type, withheld context, correction / abandon rates. A real-vs-sim classifier should sit near AUC 0.5.
  2. **Individual:** extract a persona from the first half of a held-out real conversation; simulate the next turns; score against what the person actually wrote; include **shuffled-persona** and **no-persona** baselines so we can tell identity from conversational momentum.
- Human-referenced studies remain the standard for consequential claims.
- Forbidden uses they name: impersonating a named person, attributing opinions to a real community, targeting / persuasion / exclusion of a protected group. Volunteer items had a decline option on all 1,290 fields.

**Doubland take:** our Talk logs + post-chat review are the cheapest place to run the individual next-turn test. Shuffled-persona is the honest baseline. Do not market “scientifically you” off adherence alone.

### 1.6 Steal / skip (MatrAIx)

| Steal | Skip |
|---|---|
| Express-or-suppress as the fidelity definition | 1,290-dim schema / Persona 1M as Double truth |
| Typed identity + hard compatibility masks | MBTI as a generative parent (they use typology in the catalog; we already rejected it) |
| Null > invent; claim-validity rubric | Independent-trial playground as village runtime |
| Opposite-pole matched cohorts | 91.5% as ship bar |
| Model-as-config honesty | Treating product-task success as human validity |
| Separate world naturalness from persona adherence | Using their synthetic population as teen truth |

---

## 2. MiroFish — [github.com/666ghj/MiroFish](https://github.com/666ghj/MiroFish)

**What it is:** a swarm-prediction engine. Upload seed text (news, policy, novel). Build a temporal knowledge graph. Spawn thousands of OASIS agents. Let them post / like / follow on a Twitter-like and Reddit-like world. Write a prediction report. Chat with any agent after.

Backed by Shanda. Simulation core is [OASIS](https://github.com/camel-ai/oasis) (CAMEL-AI). Memory is **Zep Cloud** (GraphRAG / temporal graph). Typical LLM: Qwen-plus.

**What it is not:** a twin of a *consenting living person*. Agents are extracted from documents and then socially evolved. Fidelity here means “grounded in the seed world,” not “this is you.”

### 2.1 Learnings that help true Doubles

1. **Ground personas in a retrieved graph, not a free-text vibe.** `OasisProfileGenerator` does a second Zep search (edges = facts, nodes = summaries) before it writes a bio. Weak seed → generic persona. That is the same failure mode as our soft `innate` dump.
2. **Separate individual vs institution.** People get a personal card. Orgs get a spokesperson card. Do not let a group entity pretend to be a human Double.
3. **Close the memory loop.** Every meaningful action becomes a dated natural-language episode and is written back to the graph in batches. Next round, agents retrieve the updated world. Fidelity at scale is a *write-back* problem, not a bigger prompt.
4. **Episodes are temporal.** Facts carry time. Multi-action batches keep event time in the source text so later extraction does not collapse the day.
5. **Skip empty acts.** `DO_NOTHING` is not written to memory. We should not pollute Double memory with no-op steps.
6. **Fail closed on memory ingest.** If a Zep batch fails, they do not silently replay (not idempotent). Incomplete memory is treated as a broken run. For a twin, a silent memory miss is worse than a visible miss.
7. **You can talk to any agent after the run.** Post-sim interview is a cheap recognition surface. We already have Talk. Use it as a fidelity instrument, not only as a feature.
8. **Ontology first, then people.** They generate entity types from the seed before they generate personas. For Doubland villages, the world (places, roles, relationships) should constrain who a Double can be.

### 2.2 What to skip

- **MBTI on the agent card.** Their profile schema includes MBTI. We already rejected this as a generative parent. Do not copy it.
- **Invented demographics to fill the card.** Age / gender / country / profession are LLM-filled when the graph is thin. That is over-claiming. MatrAIx’s null rule wins here.
- **2,000-word persona essays.** Their prompt asks for a 2,000-character-class persona dump. That fights our token budget and our “executable lines, not soft labels” rule.
- **Swarm prediction as the product.** Their north star is “rehearse the future of an event.” Ours is “this specific teen’s Double.” Different success metric.
- **Zep Cloud as a must.** The *pattern* (temporal graph + episode write-back) is the learning. The vendor is optional. We already have Supabase memory + scratch.

### 2.3 Mapping onto Doubland

| MiroFish piece | Closest Doubland piece | Useful move |
|---|---|---|
| Seed → GraphRAG | Interview / quiz / Talk → profile snippets + `dbl_memory` | Retrieve *cited* facts before plan/chat, not the whole soul |
| Episode write-back | perceive → memory → reflect | Write only meaningful acts; keep time; fail closed |
| Individual vs group card | owned Double vs village NPC / org | Never let a cast NPC wear a user’s identity |
| Post-sim agent chat | Talk-with-Double | Score next-turn vs human, with shuffled-persona baseline |
| Dual-platform social | in-sim chat + Survival social | Persistence across surfaces is the hard part |

---

## 3. Additional studies

### 3.1 Park et al. — *LLM Agents Grounded in Self-Reports* (was “Simulations of 1,000 People”)

[arXiv 2411.10109](https://arxiv.org/abs/2411.10109) · already in `done/1.paper-simulations-of-people.md`

- 1,052 US adults. Two-hour **American Voices Project** interview (AI interviewer, ~6,500 words). Then GSS, BFI-44, economic games, five experiments. Repeat two weeks later to get **self-consistency**.
- Normalized accuracy = agent accuracy ÷ the human’s own two-week consistency. 1.0 = as consistent as the person is with themselves.
- GSS (updated): interview **83%**, survey **82%**, combined **86%**, demographics-only **74%**. Original writeup: interview 85% (raw 68.9% vs human self-consistency 81.3%).
- Big Five: interview normalized *r* ≈ **0.80** (raw *r* = 0.78 vs human 0.95). Demographics 0.55. Short self-persona paragraph 0.75.
- Economic games: weaker (~0.66 normalized). Money-and-stakes behavior is harder than attitudes.
- Combined interview + survey is best, but the extra gain is **modest**. Once the model has enough evidence *in a domain*, more of the same flattens.
- Even with **80% of the interview deleted**, interview agents still beat survey-composite agents. A bullet summary of the interview (facts, not voice) still beat composites. The *knowledge* matters more than the original wording — but we still need the interview to *get* that knowledge.
- Interviews cut demographic/ideological accuracy gaps vs “act as a 17-year-old…”.
- Agents replicated the same 4 of 5 experiments as the humans; effect-size *r* ≈ 0.98.

**Doubland take:** this is the strongest “true representative” paper we have. Our quiz is the survey arm. Our Talk / interview is the Park arm. **Interview is the unlock.** A short “describe yourself” paragraph is closer to their weak persona baseline than to a two-hour life story. We will not get 83% GSS-style fidelity from IPIP labels alone.

### 3.2 BehaviorChain — *How Far are LLMs from Being Our Digital Twins?*

[arXiv 2502.14642](https://arxiv.org/abs/2502.14642) · ACL 2025 Findings

- 1,001 personas × 15,846 behaviors, extracted from fiction and biography. Each chain is 10–20 context → next-act nodes.
- Two tasks: pick the next act (4-way) and generate the next act.
- GPT-4o multiple-choice AvgScore **0.56** overall (sub-60%). Generation is worse. Consecutive-correct (CumScore) is much lower — **early misses snowball**.
- Models do better on “key” dramatic acts than on ordinary next-acts. Twins fail on the boring middle of a day.
- Bigger models help inside a family (Llama 8B → 70B), but even 70B is not a twin.

**Doubland take:** village life is a behavior chain. Plan → walk → chat → react → reflect is exactly their setting. Measure **streaks**, not single clever replies. A Double that nails one talk and then defaults is not a twin.

### 3.3 IMPersona — individual impersonation

[arXiv 2504.04332](https://arxiv.org/abs/2504.04332) · Princeton

- Can an LM fool people who *know* the person? 114 participants, 12 real people, 3-minute chats.
- Prompting + sample texts: best pass rate **25%** (Claude). Fine-tune Llama-3.1-8B on as little as **500** messages + hierarchical memory: **44%**.
- Hierarchical memory (episode → theme → abstraction, then zoom) beats flat RAG. Memory helps *facts*; it can *hurt* style if the model force-fits old stories.
- Fine-tunes get style but break **flow** (topic jumps). Prompted models stay too polished and too eager.
- Close family can still be fooled if they do not text that person often. Detection predictors: texting frequency and AI experience — not “I am their sibling.”
- Reliable catch: ask about **right-now** facts (where are you, last night’s game). Models cannot live in the present.
- Safety: all tested models agreed to deceptive impersonation prompts (including fake emergencies for money).

**Doubland take:** Talk-with-Double will feel “close” long before it *is* the person. 44% is not success for us; it is a warning. Do not fine-tune on a teen’s private messages without a hard privacy/ethics gate. Do give the Double a live “today in the village” feed so present-tense questions have an honest answer. Keep a visible “this is a Double” mark — we are a rehearsal mirror, not a clone-for-deception product.

### 3.4 Persistent Personas

[arXiv 2512.12775](https://arxiv.org/abs/2512.12775) · EACL 2026

- Seven models, 100+ dialogue rounds. Two conversation types:
  - Persona-directed (interview about identity) — persona fades late.
  - Goal-oriented (do a task) — fade starts around **round 7** and does not recover.
- Over 100 rounds, persona-specific patterns drop **>40%**; default model voice rises.
- Instruction-following and persona fight each other. Safety refusals drift toward the no-persona baseline.

**Doubland take:** a village day is goal-oriented. Identity will wash out unless we **re-inject** a compact card (or retrieve it) on a cadence — not only at step 0. This supports the existing “budgeted channel lines every relevant call” design, and argues against a one-shot soul dump.

### 3.5 The Persona Fidelity Gap

ICML Workshop on Pluralistic Alignment, 2025 · [OpenReview](https://openreview.net/forum?id=DJN39gBPm3)

- ~268k Amazon users. LLM personas seeded from real purchase history.
- Item-level rank accuracy looks fine (**0.72–0.85**). Population coverage of real preference neighborhoods: **4.6–9.4%**.
- Personas form tight clusters (cosine 0.94–0.99) vs real users (0.56–0.68). Free-form demographic/backstory personas cover ~0%.
- Per-user metrics hide a collapsed, average person.

**Doubland take:** a village of Doubles can all feel “plausible” and still not be *those* friends. Measure **between-Double distinctness** (can a rater tell Anya’s Double from Jordan’s?) not only “does this one sound human.” Opposite-pole casts are the cheap version of this test.

### 3.6 InCharacter

[arXiv 2310.17976](https://arxiv.org/abs/2310.17976) · ACL 2024

- Do not trust a role-play agent’s *self-report* on a Big Five form. Interview it. Convert scale items to open questions. Score the answers.
- SOTA role-play agents hit up to **80.7%** alignment with how humans perceive the *character* — not a living twin.

**Doubland take:** if we ever re-quiz a Double, use behavioral interview, not “rate yourself 1–5 on Extraversion.” The Double will recite the card.

### 3.7 Human Simulacra + MACM

[arXiv 2402.18180](https://arxiv.org/abs/2402.18180) · ICLR 2025

- 11 constructed characters, Jungian trait pack, multi-agent cognition (Think / Emotion / Memory / Coordinator).
- Self-report **88%**. Observer report **~78%** even with MACM. Conformity experiment: human-like direction, more rigid than people.

**Doubland take:** the gap between “I know who I am” and “you look like you” is the product gap. Observer / friend / creator recognition is the score that matters.

### 3.8 PersonaGym

[arXiv 2407.18416](https://arxiv.org/abs/2407.18416) · EMNLP Findings 2025

- 10 models × 200 personas × 10k questions. **Model size does not reliably predict persona skill.** Llama-3-8B tied GPT-4.1 (4.49). Llama-3.3-70B was worse (4.36). Claude Haiku often *refused to be a person*.
- Hardest task: linguistic habits (jargon, tone, speech).

**Doubland take:** do not assume “upgrade the village model → truer Doubles.” Measure. Voice/habit is the weak surface — which is exactly what a friend notices first.

### 3.9 Silicon sampling (Argyle et al.)

[arXiv 2209.06899](https://arxiv.org/abs/2209.06899) · *Political Analysis* 2023

- Condition GPT-3 on real sociodemographic backstories; it can reproduce *group* survey patterns (“algorithmic fidelity”).
- Later work is mixed. Good for cheap hypothesis generation. Not a replacement for a named person.

**Doubland take:** group-level “teens like this” is a different product from “this is Maya.” Silicon sampling can help *cast NPCs*. It cannot certify an owned Double.

### 3.10 Generative Agents / OASIS / SOTOPIA (context only)

Park et al. 2023 (Smallville), OASIS, SOTOPIA, Concordia, AgentSociety: persistent identity + memory + relationships in a social world. MatrAIx correctly marks this as **our** architecture class. They give us the *stage*. They do not give us the *twin test*. Use them for village naturalness, not for “that’s me.”

---

## 4. What “true representative” actually requires

Combine the sources. A Doubland Double is true when:

1. **The card is sourced.** Quiz + interview + consented Talk. Null where unknown. No inferred clinical labels. Evidence attached to claims (MatrAIx M1–M2).
2. **The card is compiled into if–then lines.** Not “high C.” Yes: “when a plan and a party collide, keep the plan unless a friend is in real trouble.” Suppress line on every channel (`psy/methodology.md` already said if–then beats labels).
3. **The acting model is fixed and logged.** Identity claims are model-specific.
4. **Behavior is measured on chains.** Opposite poles, express *and* suppress, multi-step streaks. Shuffled-persona baseline on Talk.
5. **Identity is re-presented.** Goal-oriented days wash persona out. Re-inject compact channel lines; retrieve cited memories; do not rely on step-0 context.
6. **Memory write-back is honest.** Meaningful acts only. Time-stamped. Fail closed. Do not mutate innate from a chat without consent (already shipped).
7. **Recognition is the product score.** Creator says “that’s me.” Close friends can tell two Doubles apart. Self-report quizzes of the agent do not count.
8. **Present-tense life is available.** A twin that cannot answer “what did you do an hour ago in the village?” fails IMPersona’s cheapest probe.
9. **Diversity of the cast is protected.** Avoid the fidelity-gap collapse: every Double sounding like a polite, medium teen.
10. **Claims stay humble.** Simulated result → hypothesis. Human study → claim. Especially for teens.

---

## 5. Implications for Doubland (no new eng until founder go)

These are research implications. They do **not** replace the P0/P1/P2 in `TODO_realism_matriAIx.md`. They refine what “done” should mean.

**Already aligned (keep)**

- Thin IPIP spine, not a 1,290 catalog.
- Express-or-suppress.
- Replace soup, do not stack tokens.
- Innate frozen; post-chat is consented.
- Naturalness Gate stays separate from Persona Adherence.

**Strengthen when we pick this up**

- Treat **interview / Talk** as first-class identity evidence, not a chat feature. Park is the reason.
- Add **shuffled-persona** and **no-persona** baselines to any Talk accuracy number.
- Add a **distinctness** check: can a rater tell two friends’ Doubles apart?
- Re-inject identity on a cadence during long days (Persistent Personas).
- Score **streaks** (BehaviorChain CumScore), not single replies.
- Use MatrAIx M1–M5 on interview extracts before they become soul.
- Never let the same model judge its own Talk voice as the only score.
- Keep a live village recap so present-tense questions have a true answer.
- Do not add MBTI, 2,000-word persona essays, or imputed demographics.

**Still banned without a separate ethics pass**

- Fine-tune on a user’s private messages (IMPersona-style).
- Public “scientifically you” / clinical language.
- Impersonation that can leave the product and fool a third party.
- Covert profiling of minors.

---

## 6. Related internal docs

| Doc | Role |
|---|---|
| This file §0 | Live village + Talk implementation as of 2026-08-23 (RCA context) |
| `TODO_realism_matriAIx.md` | Locked eng charter (post-MVP) |
| `done/20260810_realism_matriAIx_findings.md` | Current plumbing + P0 cost caps |
| `psy/methodology.md` | If–then, triangulate, weight behavior |
| `psy/soul.md` | Human-authored snapshot template |
| `EPIC_self-serve-double.md` | Quiz → owned Double spine |
| `concept/mission.md` | Why the mirror exists |
| `done/1.paper-simulations-of-people.md` | Full Park 1,000-people extract |

---

## 7. Sources

- Li, Hao, et al. *MatrAIx: Simulating the World with 8.3 Billion Persona Agents.* arXiv:2608.04205, 4 Aug 2026. https://arxiv.org/abs/2608.04205
- MiroFish. *A Simple and Universal Swarm Intelligence Engine.* https://github.com/666ghj/MiroFish (OASIS + Zep; inspected `oasis_profile_generator.py`, `zep_graph_memory_updater.py`)
- Park, Zou, Kamphorst, et al. *LLM Agents Grounded in Self-Reports Enable General-Purpose Simulation of Individuals.* arXiv:2411.10109, v3 28 Jun 2026.
- Li, Xia, Yuan, et al. *How Far are LLMs from Being Our Digital Twins?* arXiv:2502.14642, ACL 2025 Findings.
- Shi, Jimenez, Dong, et al. *IMPersona: Evaluating Individual Level LM Impersonation.* arXiv:2504.04332, 2025.
- Luz de Araujo, Hedderich, et al. *Persistent Personas?* arXiv:2512.12775, EACL 2026.
- *The Persona Fidelity Gap.* ICML Workshop on Pluralistic Alignment, 2025. https://openreview.net/forum?id=DJN39gBPm3
- Wang et al. *InCharacter.* arXiv:2310.17976, ACL 2024.
- *Human Simulacra.* arXiv:2402.18180, ICLR 2025.
- *PersonaGym.* arXiv:2407.18416, EMNLP Findings 2025.
- Argyle et al. *Out of One, Many.* arXiv:2209.06899, *Political Analysis* 2023.
- Park et al. *Generative Agents.* 2023. OASIS (CAMEL-AI). SOTOPIA.

---

## 8. Human personality science and at-a-distance profiling (2026-08-23 widen)

Source: deep-research pass after the LLM-twin papers. **Status: Partial** — several primary PDFs did not open (IPIP reliability tables, HEXACO/SJT meta-analyses, CIA PAS/Gittinger, full Slammer reports). Claims below are only what the pass could inspect. Full writeup: session workflow `deep-research` report.

This pass answers a different question than §§1–3. Those ask “can an LLM *play* a person?” This asks “what does human science actually know about *measuring* a person, and what should a Double inherit?”

### 8.1 The usable construct

Keep scoring **public Big Five / IPIP tendencies**, not diagnosis and not IQ.

- IPIP/BFI-style items → reverse-keyed 1–5 domain means. That is a behavioral tendency score, not a clinical instrument.
- This product already does that: IPIP-BFM-25 → OCEAN means + lower / typical / higher bands (cuts 2.5 / 3.5), no population percentiles.
- Assigned high/low Big Five profiles can be checked in LLM personas with the same inventory plus generated language (PersonaLLM / Jiang). Humans can sometimes see the trait in stories (~80%), and that drops when raters are told the author is AI.
- Do **not** leverage MMPI-style clinical batteries, diagnostic opinions, or Raven/IQ *g* as Double-fidelity scores. APA 9.01–9.02: a diagnostic claim needs a method validated for that purpose and an adequate exam. We do not have either, and we should not pretend to.

### 8.2 What Big Five actually predicts (modest, real)

These are human–human numbers. They set the ceiling for how much a quiz can ever “be” someone.

- Life events, not vibes. Neuroticism, low Agreeableness, and low Conscientiousness predict later marital dissolution more strongly than SES in the same review (*r* ≈ .17 / −.18 / −.13 vs SES −.05). Roberts et al., “The Power of Personality.”
- Mega-analysis, 171,395 people, 10 panels: after matching, Big Five still tracks later partnering, marriage, volunteering, and lower criminality. Effects are **small** (odds ratios ~1.04–1.06). Beck & Jackson.
- HEXACO Honesty-Humility + Openness are the strongest trait correlates of pro-environmental attitudes/acts; combined traits predict holdout behavior at *r* ≈ .28–.43. Soutter, Bates, Mõttus.

**Doubland take:** a high-C Double that keeps a plan, or a high-N Double that freezes under threat, is in the right scientific neighborhood. Expect **small, reliable leans**, not destiny. A Double that “always” does the trait is over-acting relative to real people.

### 8.3 Self-report is not enough — triangulate

This is the same rule already in `psy/methodology.md`. The human literature now names the extra instruments:

| Method | What it adds | Size / note |
|---|---|---|
| **Informant / friend ratings** | Often beat self-report on achievement and job performance; combining both is best | 263 samples, 44k targets. Conscientiousness → school: other .41 vs self .25/.18; job: .29 vs .20 (Connelly & Ones; Oh, Wang & Mount) |
| **Language (open-vocab)** | Facebook status words agree with self-report and add unique validity beyond friends | Train 66k / test 4.8k; language–self *r* ≈ .39 vs informant–self .32; both → .45 (Park et al. 2015) |
| **Digital traces (Likes)** | Computer Big Five from Likes *r* = .56 vs friends’ questionnaire *r* = .49; ~10 / 70 / 300 Likes ≈ colleague / friend / spouse | 86k people (Youyou, Kosinski, Stillwell). **Do not copy covert scraping for teens.** |
| **Ambient behavior (EAR)** | Two days of daily-life sound recovers Extraversion especially well | N = 96 (Mehl et al.). Village telemetry is our legal analog: who they approach, how long they talk |
| **Structured trait interview** | Adds validity over a self-report inventory | SIFFM, ~200 people |
| **Situational judgment (if–then scenes)** | Interpersonal SJT predicted later real job behavior; cognitive exam predicted grades | 4,538 medical candidates |
| **Implicit tests** | A shyness IAT predicted *spontaneous* shy acts that explicit ratings missed | N = 139. Interesting, not a product path |

**Doubland take:** the quiz is arm 1. Talk / interview is arm 2 (Park + SIFFM). Friend recognition is arm 3 (informant). Village acts are arm 4 (EAR analog). Language of in-sim chat is arm 5 — score it, do not only prompt it. Do **not** ingest social-graph Likes or covert phone audio.

### 8.4 CIA / OSS — what transfers, what does not

These programs profiled *other people* under state power. We take method lessons, not the mission.

- **At-a-distance dossier (Langer / OSS, 1943).** 249 pages on Hitler from >11,000 pages of sources. Predicted suicide before surrender. Lesson: many sourced documents + a life reconstruction can forecast a *style* of ending. CIA later writing still questions how often such profiles were right.
- **Leader profiles for negotiation (Jerrold Post / CAPPB).** Camp David principals. Carter later said he would not change a word after 13 days with them. Lesson: a good profile is useful when the *use* is “how will this person sit in a room,” not “will they commit a rare crime.”
- **Stress assessment, not a quiz (OSS stations, 1944–45).** ~5,300 people, multi-day situational tasks under stress. Screened out 15–20% as unfit; of the first 300 who passed and deployed, 6% proved unsatisfactory. Lesson: watch the person *under load*. Survival days and hard Talk prompts are closer to this than IPIP items.
- **Rare acts are not statistically predictable (CIA 2017, Project Slammer).** Espionage framed as personality dysfunction × personal crisis × easy opportunity. After Ames, 1,790 staff surveyed; warning signs produce many false positives; the arrested-spy sample is too small. Lesson: do not claim a Double can forecast a one-off betrayal, crime, or “who flips.”
- **IARPA MOSAIC (2016) stated the same limit we have:** one-shot tests, self-report, interviews, assessment centers, and SJTs all suffer unnatural settings, thin context, impression management, and rater bias. They wanted unobtrusive sensing. We must not build that for teens.

**PAS / Gittinger** CIA documents were listed but not opened. Do not claim them.

**Doubland take:** steal *sourced dossier + stress scene + modest forecast*. Do not steal covert sensing, clinical labels, or rare-event prediction. A village Double can be “likely to withdraw when the group turns on them.” It cannot be “will this person become a traitor.”

### 8.5 What this pass could not settle

- No inspected source ranks Big Five vs HEXACO vs NEO-PI-R vs MMPI vs SJTs as *the* best predictor of social behavior.
- IPIP-BFM-25 official reliability tables were not fetched. Our 25-item form is a thin public proxy, not a gold standard.
- No inspected primary source validates IPIP / HEXACO / SJT / MMPI as a scoring method *for LLM personas*. Same-inventory induce-and-test (give the model “high E,” then re-quiz it) is a weak fidelity test — the model can recite the card (see also InCharacter, §3.6).
- HEXACO Honesty-Humility is a real extra trait for ethics/cooperation. Optional later, only if we wire a channel. Do not rename it a “social-ethics construct.”
- Forensic offender-profiling papers were not opened. Leave them out.

### 8.6 Steal / skip (human + IC pass)

| Steal | Skip |
|---|---|
| Big Five as scored tendency, modest effect sizes | Clinical diagnosis, MMPI, IQ-as-fidelity |
| Informant + interview + behavior triangulation | Covert Likes / phone / sensor profiling |
| If–then / SJT scenes as identity tests | Same-inventory re-quiz of the Double as proof |
| Watch the person under load (OSS-style scenes) | Rare-event / betrayal prediction |
| Honesty-Humility as a possible later sixth | PAS/Gittinger or any unopened CIA method |

---

## 9. Sources (human + IC widen)

- Roberts et al. *The Power of Personality.* https://pmc.ncbi.nlm.nih.gov/articles/PMC4499872/
- Beck & Jackson. *A Mega-Analysis of Personality Prediction.* https://pmc.ncbi.nlm.nih.gov/articles/PMC8867745/
- Soutter, Bates, Mõttus. *Big Five and HEXACO … Proenvironmental …* https://pmc.ncbi.nlm.nih.gov/articles/PMC7333518/
- Connelly & Ones. *An Other Perspective on Personality.* http://www-2.rotman.utoronto.ca/facbios/file/Connelly%20%26%20Ones%20%282010%29.%20Psych%20Bull.pdf
- Park et al. 2015. *Automatic Personality Assessment Through Social Media Language.*
- Youyou, Kosinski, Stillwell. *Computer-based personality judgments…* https://pmc.ncbi.nlm.nih.gov/articles/PMC4313801/
- Mehl et al. *Personality in its natural habitat.* https://doi.org/10.1037/0022-3514.90.5.862
- Asendorpf et al. 2002. Shyness IAT double dissociation. https://pubmed.ncbi.nlm.nih.gov/12150235/
- SIFFM incremental validity. https://scholars.duke.edu/publication/1091117
- Interpersonal SJT / 21st-century skills workshop. https://www.ncbi.nlm.nih.gov/books/NBK84226/
- Jiang et al. *Evaluating and Inducing Personality in Pre-trained Language Models.* arXiv:2206.07550
- Jiang et al. *PersonaLLM.* arXiv:2305.02547
- Langer / OSS Hitler analysis (CIA Museum). https://www.cia.gov/legacy/museum/artifact/a-psychological-analysis-of-adolph-hitler-by-walter-langer/
- CIA. *Intelligence and the Camp David Accords* (2014).
- Wilder. *The Psychology of Espionage.* *Studies in Intelligence* 61(2), 2017. https://www.cia.gov/resources/csi/static/psychology-of-espionage.pdf
- OSS assessment stations. https://www.nps.gov/articles/a-wartime-organization-for-unconventional-warfare.htm
- IARPA MOSAIC Proposers’ Day, 2016.
- APA Ethics Code 2017, Standards 9.01–9.02.


# Plan: Will, linger, seek (everyday + Survival), sofa persist, fourth wall

**Branch (when implementing):** `ivan/social-will-seek`  
**Author:** Ivan  
**Mode:** implement only after founder go. This file is the plan.  
**Not this ticket:** personality card compile (true-doubles A–C), Talk Path A (human ↔ Double), acting-model swap, new env flags.

## Goal

Doubles can **choose** a long talk and **walk toward a named person** in everyday town and in Survival. They may do that more than once a day when it still looks like life. Same room alone is only a hello. A sit is one talk until someone leaves. They never name our world. Walk, work, sleep, and Survival gather stay green.

## Locked product rules

1. **Card thickness** stays out. This ticket is will + body + talk law, not ISS compile.
2. **Sofa:** leave the room ends it. Next act that cannot include talking closes it.
3. **Fourth wall A:** ban Doubland / simulation / backend / “as an AI” everywhere. Survival may still talk vote, alliance, challenge, who left last night.
4. **Seek never starts a chat.** Proximity + ConversationManager still decide. Existing `<persona>{Name}` walk stays the only walk.
5. **No new env flags.** Write the behaviour. Reuse `social_seek_target` / `social_seek_until_step` / `SOCIAL_SEEK_MAX_STEPS`.
6. **Zero LLM in will / linger / seek pick.** Deterministic, like `should_converse`.
7. **Normative SOT after a green score**, not before (`sot_chats.md` / `sot_survival.md` still describe Current).

## How it works today (facts)

- Chat start: pairwise proximity → `ConversationManager.should_converse` (overlap → greeting 1–2 or full 3–10). No will.
- Each `start_conversation` mints `{nameA}_{nameB}_{step}`. Utterances play, then `reverie._clear_chat_continuation` ends the session (`slicing_complete`) and stamps 5/15/30 min cooldown. Same sofa looks like a new meeting.
- `CHAT_PRESERVES_ACTION=true`: talk does not change destination. When the sit timer ends, they leave.
- Seek: Survival morning rewrite sets `social_seek_target` **once per day**. `plan._maybe_apply_social_seek` walks toward them for ~30 steps, pauses in gather prewindow, skips sleep / active chat. Chat still needs proximity.
- Survival picker: ally → trust ≥ 0.55 → **first other name**. That last fallback must not survive multi-seek (everyone would hunt the same person).
- Planner already strips “chatting with X” from the day plan. Linger must **not** insert a chat job.
- P2 action extension **refuses** during chat. Do not reuse it for linger.

## Target behaviour

```
Will? ──no──► same room → greeting only (real cooldown)
  │
  yes, already together ──► full talk (one conversation_id until leave)
  │                         if sit about to end and both still want it
  │                         and next act can include talking → linger +10 min, once
  │
  yes, not together ──► walk toward that person (soft hours only)
                        arrive → normal chat gates
                        fail / expire → wait (satiation), maybe try later or someone else
```

Hard stops always win: sleep, staff/private space, Survival gather hour, high pressure / appointment.

---

## 1. Shared will (deterministic)

One helper, used by full-talk gate, linger, and seek pick. No scores on the chat prompt.

**Willing to have a full talk with B** if any one is true, and no hard stop:

- Decay-aware `relationship_affinity[B] ≥ 0.2` (existing 0–0.35 scale; “familiar”), or
- Survival: active alliance with B, or trust[B] ≥ 0.55, or
- They already had a **full** talk today and this is continuation / cut-off resume, or
- `times_talked_today ≥ 1` **and** last talk was full (not greeting-only).

**Not willing:** sleep, gather prewindow, pressure ≥ 0.5, already chatting with someone else, next act cannot include talking (for linger / stay only).

Greeting does **not** need will. Strangers can still say hello.

---

## 2. Full talk needs will (S1 gate)

In `should_converse`:

- Fleeting / first-daily pass → **greeting** (unchanged).
- Short / medium / long overlap → **full only if both willing**. Else **greeting**.
- Cooldown, sleep, already-in-session, distance: unchanged.
- Cafe liveliness and pair CD floor: keep (S0 hygiene already on end path).

**Why this must ship with linger:** linger without this gate = two coworkers never leave (old café loop, longer).

**Check:** extend `tests/test_conversation_manager.py` — long overlap + zero affinity → greeting; long overlap + affinity 0.25 → full.

---

## 3. Sofa persist (one sit = one talk)

**End the session only when:**

- Someone leaves the arena / goes far (`left_arena`), or
- Hard interrupt: next scheduled act cannot include talking (sleep, travel to a different workplace, gather appointment, “heading to…”), or
- Pause timeout (already 10 steps apart), or
- Desync repair.

**Do not end** on `slicing_complete` if both still same arena and (remaining overlap > 0 or linger just applied).

Then:

- Keep the same `conversation_id` (stop minting `{names}_{step}` on every burst). Use `{sorted names}_{started_at_step}`.
- Next burst is continuation: existing prompt rules (`times_talked_today` + `both_staying_nearby` / `resuming`). No re-greet.
- Cooldown stamps **only** on a real end (leave / interrupt), not on a pause between bursts.
- Greeting-expiry sweep must not wipe an active persisted full session.

**Check:** unit test — same pair, same arena, burst finishes, `should_converse` / process_step does not mint a new id and does not stamp CD.

**Files:** `conversation_manager.py`, `reverie.py` (`_clear_chat_continuation`), `tests/test_conversation_manager.py`.

---

## 4. Linger (“I want to stay and talk”)

When a full session is about to lose overlap (current `act_duration` running out):

- Both willing (helper).
- Next act **can** include talking (in-place café / park / sit / wait / same-room work). Sleep, other workplace, gather hour → **no**.
- This sit has not lingered yet.
- Not high pressure.

Then add **+10 minutes** to **both** current `act_duration` only. Do not change `act_address`. Do not write “chatting with X” into the schedule. Once per sit.

If only one is willing, the other leaves → sofa end. No solo linger in v1.

**Files:** small helper + call from ConversationManager / plan after chat housekeeping. Prefer one call site. `scratch` fields: `linger_used_for_conversation_id`.

**Check:** next act sleep → no extend. Both willing + café next → duration +10, same address. Second linger same id → no.

---

## 5. Seek in everyday town, more than once a day

### Keep

- `_maybe_apply_social_seek`: `<persona>{Name}`, 30-step box, pause gather prewindow, no sleep, no chase sleeper, clear when already chatting with target, **does not start chat**.
- Gather lock still runs **after** seek in `plan()`.
- Execute already pathfinds `<persona>` to their `curr_tile` (no teleport).

### Remove

- Survival **once-per-day** exclusive write in `_rewrite_survival_lifestyle` (`social_seek_target = pick...` only when daily req is written). Survival may still **prefer** an ally in the shared picker. It must not lock the only seek of the day or overwrite a live everyday seek.

### New: when to arm a seek (any mode)

Call a shared picker from `plan()` only when **all** of these hold:

- No current `social_seek_target`.
- Soft hours: current act is leftover / travel / errand / already looking — **not** mid-shift work, not sleep, not gather prewindow.
- Seek satiation wait has elapsed (see below).
- A legal target exists.

**Who to pick** (first match, never a stranger with no reason):

1. Cut-off partner: last full talk ended by hard interrupt / left_arena, and still willing.
2. Survival (if `survival_mode`): active ally, else trust ≥ 0.55.
3. Highest affinity ≥ 0.2 (and satiation allows that pair).

**Never:** alphabetical `others[0]`, sleeping target, target in a **private home that is not the seeker’s**, staff-only tile the seeker cannot enter, eliminated / missing person.

**Satiation (“as they see fit” without chaos)** — no hard daily quota:

- One seek at a time (already).
- After each attempt (arrive + talk, or expire, or target slept): pair wait rises (same quadratic idea as chat CD). Same person is harder to hunt again than someone else.
- After a **successful** full talk with B, do not seek B again until that pair wait expires (they just talked).
- Failed expire: shorter wait; they may try another legal person.
- Soft hours only, so work and gather still look like a town.

**Privacy / staff:** before redirect, if target `curr_tile` / address is private-other-home or staff-only for this seeker, **do not arm** (or clear). Do not follow them through the door.

**Check:** extend `tests/test_social_seek.py` + new `tests/test_social_will.py`:

- Non-survival + affinity 0.25 + soft hour → arms seek.
- Non-survival + no affinity / no cut-off → no seek.
- Survival gather prewindow → no redirect, target kept.
- After expire, satiation blocks immediate re-arm; later re-arm allowed.
- Survival morning rewrite does not clobber an in-flight seek.
- Private/staff target refused.
- Chat still does not start from seek alone (`should_converse` still required).

**Files:** `plan.py` (picker + extra guards), `survival/controller.py` (stop daily overwrite; reuse preference list only), `scratch.py` (seek attempt counts / last pair / last end reason). Keep dual-import pattern.

---

## 6. Fourth wall A

- `generate_conversation_batch_v1.txt`: add Talk-style law — never name the simulation, Doubland, the experiment, the backend, SKUs/sensors, “as an AI.” Keep jobs / day / gossip.
- `survival_generate_conversation_batch_v1.txt`: keep vote / alliance / challenge / last boot **legal**. Tighten the existing meta ban so it also covers Doubland / backend / debug stand-up. Do **not** ban the word “game.”
- Do **not** change planner prompts that say “simulation agent” (backstage, not spoken).
- Residual: old memories that already say Doubland can leak back. Out of scope unless a later score still shows it; then filter retrieve, do not grow this ticket.

**Check:** `prompt-verify` skill on the two chat templates. Existing Survival alliance tests still expect verbal “let’s stick together” (unchanged).

---

## What must not break

| System | Guard in this ticket |
|---|---|
| Survival gather / 80% occupancy | Seek already paused in prewindow; linger refuses; gather lock last |
| Sleep | Hard interrupt; seek skips sleeper and sleeping seeker |
| Jobs / staff / private homes | Soft-hours seek only; refuse staff/private-other; interrupt if next act is another workplace |
| Walk / `MAX_TILES_PER_STEP` | No new path type; existing `<persona>` + FE A* |
| Café talk loop | Will gate + sofa persist + linger once + seek satiation |
| Phantom “chatting with X” plan | Linger only stretches duration |
| Alliances | Verbal commitment unchanged; fourth wall keeps game talk legal |
| Talk-with-Double | Untouched |
| Headless / movement payload | Same `chat` / `chatting_with` / `chat_metadata`; stable `conversation_id` helps FE buffer |
| Intent persist | Duration-only linger is a normal plan field write |
| Parallel LLM | Will/seek/linger stay off the LLM path |

## Out of scope

- ISS / quiz compile, O=/C=/E= soup, acting model (true-doubles F).
- Talk Path A.
- Re-enabling plan-path `decide_to_react` / `lets_react` under `OBSERVATION_PRIMARY`.
- Daily plan text “find A” as the primary arm (picker is code). Keep `_strip_social_refs` allowing “looking for” so seek intent text stays legal.
- New flags.
- Normative SOT rewrite before score.

---

## Implementation chunks (≤3 files each; check before next)

1. **Will helper + tests** — new `social_will.py` (or tight functions in `conversation_manager.py` if that stays under 3 files with tests). Affinity / alliance / cut-off / hard stops. Check: `tests/test_social_will.py`.
2. **Full-talk gate** — `conversation_manager.py` + `test_conversation_manager.py`. Check: greeting vs full cases above.
3. **Sofa persist** — `conversation_manager.py`, `reverie.py` `_clear_chat_continuation`, tests. Check: no new id / no CD on same-arena burst end.
4. **Linger** — helper + CM/plan call + scratch field + tests. Check: +10 once; sleep next → no.
5. **Seek multi + everyday** — `plan.py` picker/guards, `survival/controller.py` stop daily clobber, `scratch.py` satiation fields. Check: `test_social_seek.py` + will tests.
6. **Privacy/staff refuse** — `plan.py` (+ location helper if needed) + tests.
7. **Fourth wall** — two batch templates + `prompt-verify`.
8. **Verify** — project `verify` skill (narrow first: conversation + seek tests; then listed behaviour suite). Maker ≠ verifier.

Stop on first red check. Do not stack chunks.

## Score / prove (after unit green; not this coding session unless asked)

Separate Survival **and** a short everyday fork.

- Café still lively (greetings happen).
- Same-pair full-chat spam falls vs `20260823-2` CD ugly.
- ≥1 everyday **will → walk → talk** path.
- ≥1 second seek the same day after satiation (not instant re-hunt).
- Nobody misses sleep or gather hour because of linger/seek.
- Walk / persist ≤6 / teleports stay green.
- Fourth-wall rate on a Survival window falls; vote/alliance lines still appear.

Then update `sot_chats.md` / `sot_survival.md` on `double-docs` `main` (Current ← this). Worklog on code ship.

## Risks

- Will threshold too high → dead town. Too low → café lock. Tune on affinity 0.2 + greeting fallback.
- Multi-seek without satiation → ping-pong walks. Satiation is load-bearing.
- Sofa persist + greeting sweep desync → zombies. Keep desync repair.
- Following `<persona>` into a house → privacy bug. Chunk 6 is required before score.

## Founder confirmations already taken

- Linger: stretch sit + hard interrupt.
- Fourth wall: A.
- Seek: everyday + no once-a-day cap, still natural.
- Package: will gate + sofa persist so linger/seek stay safe.
