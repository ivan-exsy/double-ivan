# Rehears × Doubland — Assessment & Integration Plan

**Audience:** Doubland team (product, FE, BE, future onboarding owner)  
**Status:** Decisions locked 2026-07-14 → **implementation epic active**.  
**Epic (one-pager + weekly ACs):** `double-ivan/EPIC_self-serve-double.md`  
**Branch / worktree:** `ivan/dev` → `D:\Coding\generative_agents-ivan-dev`  
**Related SOT:** `double-docs/sot/sot_lifecycle.md` §6 · `sot_chats.md` §6 (Chat with Double v4) · `double-docs/x_next/5.2.rehears-double.md`  
**Code:** Rehears → `D:\Coding\rehears` · Doubland FE → `double-front` · BE → `generative_agents`

---

## 1. Why this doc exists

Doubland needs **user accounts**, **ownership rules** (only the owner edits their Double’s settings; only registered users chat with Doubles, etc.), and **rich personality inputs** so Doubles behave like real people—not only hand-authored soul cards.

Rehears is an earlier product that already built much of that **entry-gate** surface: auth, Big-5 assessment, profile storage, and “what would my double do?” loops. The question for the team is not “is Rehears cool?” but:

> **Should we keep Rehears as a permanent connected product, or port its high-value pieces into Doubland (and retire Rehears as a front door)?**

This document introduces Rehears, records product-owner constraints, and ranks work by **impact vs effort** for a small team. It also notes how the work should be **modular** so a future onboarding/Rehears-owned slice can split cleanly when the team grows.

---

## 2. What is Rehears? (orientation for Doubland)

### 2.1 Product in one sentence

**Rehears** is a web app (Next.js + Supabase + OpenAI edge functions) that turns a **Big-5 personality quiz** into a **personal “Double”** used for decision rehearsal: daily dilemmas, free-form “Ask My Double,” and “Double It” multi-option outcome exploration. Originally aimed at **U.S. high-school teens** (13–18); last meaningful product commits ~**2025-10** (including links toward ondouble.com). It is **not** a multi-agent village simulator.

### 2.2 Stack & repos

| Layer | Implementation |
|-------|----------------|
| Frontend | Next.js 15 App Router, React 19, Tailwind/shadcn, Framer Motion |
| Auth | Supabase Auth — Google OAuth + magic link; school-email domain gate (configurable) |
| Data | Supabase Postgres + RLS (`user_profiles`, quiz sessions, dilemmas, quotas, shares, analytics) |
| AI | Supabase Edge Functions + OpenAI (assistants / chat completions) |
| Hosting | Historically Vercel; dual-dev workflow with v0 UI iteration |
| Path | `D:\Coding\rehears` |

**Note:** Root README still mentions Expo/RN in places; the **live product surface is the Next.js app** under `app/`.

### 2.3 User journey (screens that matter for Doubland)

Rough flow from Rehears docs (`docs/workflows.md`):

1. **Invite / welcome** → exclusivity gate  
2. **Auth** → Google or email magic link  
3. **Value props** → why take the test  
4. **Test selector** → Big-5 instrument / audience variant  
5. **Personality quiz** (~25–30 Likert items) → scoring engine  
6. **Results** → OCEAN percentiles, strengths/growth, type name  
7. **Double reveal** → “this is your Double” moment  
8. **Core loops (post-profile):**  
   - **Daily Dilemma** — scenario card, choice, prediction vs actual, streak  
   - **Ask My Double** — chat-style advice grounded in traits  
   - **Double It** — free-text dilemma → multi-motivational options + timelines  

### 2.4 Personality data model (what Doubland can consume)

Stored primarily in **`user_profiles`** (see migrations + `lib/services/personalityStorage.ts`):

| Field | Meaning | Doubland relevance |
|-------|---------|-------------------|
| `user_id` | Supabase `auth.users` | Identity / ownership join key |
| OCEAN percentiles (0–100) | Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism | Trait vector for ranking jobs/homes, seeding behavior |
| Raw scores / z-scores | Instrument-native + normed | Finer sim weights; optional |
| `personality_summary` | Prose summary | Seed text for ISS-like `innate` / snippets |
| strengths / growth_areas | Arrays | Goals, friction, growth arcs |
| Assessment metadata | date, audience, question count | Versioning, re-test policy |

**Export sketch already exists:** `rehears/double/fetchPersonalities.md` + `fetch_personality_summaries.js` (service-role fetch → summary sentences for sim).

**Important impedance:** Rehears gives a **compact psychometric + prose**. Doubland agents need **ISS-style soul** (`innate`, `learned`, `currently`, `lifestyle`) + profile documents/snippets + routine/goals. **Big-5 alone is not a full Double.** Product intent (below) is quiz **plus** onboarding interview → full profile.

### 2.5 Auth & security patterns worth reusing

- Supabase session + `AuthContext` / `auth` service  
- OAuth callback route, session cleanup, provider mismatch logging  
- RLS: users read/write **only their** profiles  
- Optional school-domain email validation (`lib/utils/emailValidation.ts`) — **teen-era; not default for adult Doubland**  
- Quotas / rate limits on AI features (patterns transferable to Chat with Double)

### 2.6 What Rehears is *not*

- Not a sim engine, maze, LIVE feed, or Survival mode  
- Not Chat-with-Double (Doubland already has memory-backed persona chat)  
- Not production-active as Doubland’s primary surface (Doubland is the active product)  
- Not adult-framed copy or Doubland brand design system  

### 2.7 Mapping to Doubland SOT onboarding phases

| Lifecycle phase (`sot_lifecycle.md` §6.2) | Rehears today | Doubland today |
|-------------------------------------------|---------------|----------------|
| **A — Account** | Implemented (Supabase Auth) | Deferred post-MVP (manual claim for demo) |
| **B — Personality & core profile** | Big-5 + summary (+ optional AI insights) | Operator/soul pipeline; pre-profiled roster |
| **C — Completeness gate** | Implicit “has `user_profiles` row” | TBD privacy/consent |
| **D — Simulation binding** | N/A | **Shipped** (onboarding host CLI/REST) |
| **E — Assets** | Weak / none | Manual / video pipeline |

Rehears is essentially a **partial implementation of Phases A–B**, with entertainment loops that sit **beside** the village, not inside Phase D.

---

## 3. Product owner notes (elaborated)

These constraints should drive prioritization and architecture choices.

### 3.1 Personality assessment is high leverage for Doubland

**Why it matters:** Doubland’s brand promise is a **personality twin**, not a generic NPC. Operator-authored souls work for Survival demos; **self-serve “my Double”** needs structured capture.

**Recommended capture stack (combined, not either/or):**

1. **Big-5 (or equivalent short battery)** — fast, comparable, scorable, good for ranking and default weights.  
2. **Onboarding interview** (chat or multi-step form) — values, relationships, lifestyle, goals, voice, non-negotiables → feeds `learned` / `currently` / goals / social seeds.  
3. **Adapter layer** — maps (1)+(2) → `persona_profile_*` + ISS fields + optional routine/goal/tie templates (`5.2.rehears-double.md`).

Without (2), Doubles will feel like **trait-colored templates**. Without (1), interview-only profiles are hard to normalize and hard to reuse for job/home fit ranking.

### 3.2 Daily Dilemma / “What would my Double do?” enhances UX (but is not the foundation)

Rehears loops that **validate** the Double *before* (or alongside) village play:

| Rehears feature | Doubland-facing value | Notes |
|-----------------|----------------------|--------|
| **Daily Dilemma** | Habit, return visits, “spot-on / off” feedback | Needs **adult** dilemma bank |
| **Ask My Double / Double It** | Solo “rehearsal” without spinning a full sim | Overlaps Chat with Double; design as **modes**, not two apps |
| Share cards | Growth / social proof | Align with Doubland tracking / trailers later |

These are **engagement multipliers after** auth + profile + ownership exist. They should not block village MVP self-serve if resources are tight—but they are strong candidates for a **Solo Rehearsal** surface inside Doubland brand.

### 3.3 Teen product → adult Doubland (mandatory rework)

Rehears was built for **teens**. Doubland audiences (founders, professionals, social/reality-TV framing) need:

| Area | Teen Rehears (examples) | Adult Doubland direction |
|------|-------------------------|---------------------------|
| Big-5 item wording | School, parents, peers | Work, partnership, identity, ethics, ambition |
| Norms / scoring | Teen norm populations | Adult norms (or population-agnostic z-scores + re-validation) |
| Dilemmas | Social/academic teen pressure | Career, relationships, reputation, money, loyalty, public image |
| Auth gates | `.edu` / school email options | General email + OAuth; age/consent for 18+ (or market-specific) |
| Tone / COPPA posture | Minor-sensitive | Adult privacy, data retention, psychometric consent |
| AI advice framing | “Wise friend for high school” | “Your Double / personality twin” brand language |

**Do not ship teen item banks or teen dilemma CSVs into production Doubland without content pass.** Port **scoring engines and flow architecture**; rewrite **content**.

### 3.4 UX / design must match Doubland

Rehears UI is purple-gradient, quiz-app, early-v0 aesthetic. Doubland design language is **cinematic control room / streaming / village player** (`double-docs/landing/design-language.md`, brand docs).

**Implication:** Port **flows and logic**, not pixel layouts. Onboarding, quiz, and dilemma screens should feel like Doubland (player chrome, chips, restraint, “show don’t tell”), not a second product skin.

### 3.5 Small team → ruthless prioritization

Resources are limited. Prefer:

1. One product surface (Doubland)  
2. Features that unlock **ownership + believable Doubles**  
3. Reuse of existing Doubland systems (Chat with Double, Phase D binding, Supabase `double` schema)  
4. Explicit **postpone** list so scope does not creep  

See **§5 Prioritized backlog**.

### 3.6 Future team growth → modular ownership (design for split)

When headcount grows, expected ownership slices (illustrative):

| Future module | Likely owner | Contents |
|---------------|--------------|----------|
| **Frontend / player** | FE lead | Playback, LIVE, Survival UI, Talk tab |
| **Backend / sim** | BE lead | `reverie`, gateway, memory, realism |
| **Video** | Video lead | Trailers, daily cuts, Remotion/pipeline |
| **Onboarding / “Rehears”** | Onboarding lead | Auth UX, quiz, interview, profile adapter, solo dilemma loops |

**Architecture implication (now):**

- Keep **profile + auth domain** behind clear APIs/schemas (`user` ↔ `double_profile` ↔ `persona_id`), not woven into Phaser or step JSON.  
- Prefer **one Supabase Auth** (or one IdP) with **Doubland as consumer of profile contracts**, not deep coupling to Rehears UI repo forever.  
- Document a **profile payload version** (`v1`: OCEAN + summary; `v2`: + interview; `v3`: + social graph) so a future onboarding service can own write path while FE/BE only read.  
- Avoid permanent **two-app IdP** unless multi-product is a deliberate multi-year strategy.

---

## 4. Architecture assessment: connect vs port

### 4.1 Option summary

| Option | Description | Recommendation |
|--------|-------------|----------------|
| **A. Permanent connect** | Rehears stays entry gate + IdP; Doubland validates Rehears JWTs / shared project; users bounce for quiz | **Not recommended long-term** |
| **B. Port into Doubland** | Auth + assessment + (later) dilemma loops live under Doubland brand; Rehears is code/content quarry | **Recommended** |
| **C. Short bridge** | Temporary export / shared Auth only until onboard ships; then sunset Rehears front door | **OK as tactical bridge** |

### 4.2 Why permanent “two products” is a poor fit for a small team

- **Ops tax:** two deploys, two env surfaces, cross-domain session bugs, dual failure modes.  
- **Ownership still lives in Doubland DB:** Chat with Double v4 (`user_id` on threads), settings RLS, sim binding—Rehears cannot enforce “only owner edits this Double” inside the sim schema.  
- **Rehears is stale** relative to Doubland; every auth/profile change becomes a cross-repo coordination tax.  
- **Brand:** landing/player already center Doubland; a second front door confuses funnel.  
- **SOT already places Phases A–C inside Doubland’s onboarding story**, not as an eternal external dependency.

### 4.3 What *is* worth taking from Rehears

**Take (IP / modules):**

- Auth UX patterns and RLS habits  
- Quiz engine, multi-format scoring, profile persistence shape  
- Summary generation → sim seed sentences  
- Dilemma/Ask-My-Double **interaction patterns** (after adult content + Doubland design)  
- Quota / streak / share mechanics as optional growth tools  

**Leave / rewrite:**

- Teen framing, school email defaults, teen dilemma content  
- Full second product ops as permanent architecture  
- Parallel “advice chat” that ignores Doubland memory/Chat-with-Double  

### 4.4 Profile adapter (required either way)

```
Auth subject
    → Big-5 (+ interview)
    → profile payload vN
    → persona_profile_documents / snippets + ISS seed
    → Phase D binding (job, home, goals)
    → sim + Chat with Double + settings ownership
```

This adapter is the real integration surface—not JWT plumbing alone.

### 4.5 Relation to earlier plan in this file (historical)

An earlier draft of this document recommended **Option A — shared Supabase** with ondouble.com as profile authority and a 4-week dual-app timeline (see **Appendix A**). That remains a valid **tactical** pattern if both domains must share users immediately.

**Updated product stance (2026-07-14):** optimize for **one product + portable onboarding module**, not two long-lived apps. Shared Supabase Auth is still attractive **if** the write path for profiles moves into Doubland-owned services/tables (or a future onboarding service), with Rehears UI retired or demoted to temporary funnel.

---

## 5. Prioritized backlog (effort × impact)

Effort: **S** days · **M** ~1–2 weeks · **L** multi-week · **XL** multi-month  
Impact: **H** unlocks product promise · **M** retention/quality · **L** polish/growth  

### 5.1 Must-focus (small team, next self-serve gate)

| Priority | Feature | Impact | Effort | Why | Depends on |
|----------|---------|--------|--------|-----|------------|
| **P0** | Doubland Auth (Supabase) + session in FE/gateway | H | M | Everything else is unowned without identity | Decision: single Auth project |
| **P0** | Ownership model: `user_id` on Double/settings + RLS | H | M | “Only owner edits settings” | Auth |
| **P0** | Chat with Double access gate (registered users; optional owner-only threads) | H | S–M | SOT chats §6.9 v4; cost/abuse control | Auth + `user_id` on threads |
| **P0** | Adult-framed Big-5 (or short battery) + store profile | H | M–L | Core twin fidelity; content rewrite required | Auth |
| **P0** | **Profile adapter** → soul/snippets/ISS seed | H | M | Without this, quiz data does not move agents | Profile + existing profile pipeline |
| **P1** | Short **onboarding interview** (values/lifestyle/goals) | H | M–L | Completes “fully functional detailed profile” | Adapter design |
| **P1** | Self-serve link into **Phase D** binding (or auto-bind solo) | H | M | Closes loop: profile → in village | Profile + Phase D host |
| **P1** | Completeness gate (“prediction-ready Double”) | M–H | S–M | Quality bar before sim placement | Interview + Big-5 |

### 5.2 High value, schedule after P0/P1 foundation

| Priority | Feature | Impact | Effort | Why postpone slightly |
|----------|---------|--------|--------|------------------------|
| **P2** | Daily Dilemma (adult bank) in Doubland UX | M–H | M | Great retention; not required for first owned Double in sim |
| **P2** | “What would my Double do?” solo mode (reuse Chat-with-Double + profile context) | M–H | M | Prefer one chat stack over porting Ask My Double wholesale |
| **P2** | UX refresh of onboarding/quiz to Doubland design system | M | M | Can ship functional first; brand polish before broad marketing |
| **P2** | Re-test / profile versioning & history | M | S–M | Needed once users evolve; not day-one |
| **P3** | Double It multi-timeline explorer | M | L | Heavy AI UX; overlaps sim “watch outcomes” |
| **P3** | Share vault / viral cards from Rehears | L–M | M | Growth; align with video/deep links later |
| **P3** | Streaks, push, quota polish | L–M | M | Engagement; after core loop proven |
| **P3** | Permanent multi-domain Rehears app as IdP | L | L | High ops; wrong default for small team |
| **P4** | Full teen→adult research re-norming study | M | XL | Ideal scientifically; start with expert content pass |
| **P4** | Separate deployable onboarding microservice | M | L | Design modules now; extract when second owner exists |

### 5.3 Explicit non-goals (near term)

- Rebuilding Expo/RN Rehears  
- Keeping school-email-only auth  
- Dual Chat products (Rehears Ask My Double **and** Doubland Chat with Double) without unified design  
- Self-serve paid multi-tenant villages before ownership + profile quality  
- Porting all Rehears analytics/monitoring as-is  

### 5.4 Suggested sequencing (resource-aware)

```
Week-ish blocks (illustrative, not a commit):

  [1] Auth + ownership RLS + chat gating
  [2] Adult Big-5 v1 + profile storage + adapter → seed one Double
  [3] Interview v1 (minimal) + completeness gate + Phase D self-serve path
  [4] Design pass on onboard/quiz
  [5] Daily Dilemma / solo “what would my Double do” if retention needs it
```

Ship **vertical slices**: one real user can sign in → assess → seed Double → own settings → chat—before polishing secondary loops.

---

## 6. Decision checklist (team assessment)

Use this in a short alignment meeting; record outcomes at the top of this file when locked.

| # | Decision | Options | PO lean (2026-07-14) |
|---|----------|---------|----------------------|
| 1 | Long-term architecture | Connect two apps forever vs **port into Doubland** | **Port**; optional short bridge |
| 2 | Auth home | Shared Supabase vs Doubland-only vs external IdP | **One Auth**; prefer Doubland project or shared project with Doubland-owned profile writes |
| 3 | Profile authority | Rehears tables forever vs Doubland/`double` profile SOT | **Doubland-owned profile SOT**; Rehears schema as migration source |
| 4 | Minimum profile for sim | Big-5 only vs Big-5 + interview | **Big-5 + interview** for “fully functional”; Big-5-only only as soft/demo mode |
| 5 | Soft vs hard gate | Allow synthetic Double vs block until complete | Soft for demos; hard for “my Double” claims |
| 6 | Solo rehearsal features | In-player tabs vs separate app | **In Doubland**; Rehears not permanent home |
| 7 | Content ownership | Who rewrites adult items/dilemmas | Needs named owner + copy pass before FE polish |
| 8 | Future split | Monolith modules vs early microservice | **Modular monorepo/schemas now**; extract onboarding later |

---

## 7. Risks & open questions

| Risk | Mitigation |
|------|------------|
| Big-5 → soul mapping feels thin | Interview + templates (routine/goals/ties); human review on first cohorts |
| Teen content leaks into adult product | Content freeze: no import of raw teen CSVs without rewrite checklist |
| Scope creep into full Rehears rebuild | Stick to P0/P1 table; dilemmas are P2 |
| Dual-app half-migration | Time-box any bridge; delete dual login path when onboard ships |
| Privacy / psychometrics | Consent, retention, “who can see my traits” before public self-serve |
| Adapter drift from sim pipeline | Adapter writes only through existing profile/snippet paths used by Phase D |
| Small-team bus factor | Document profile payload v1 in SOT when implementing |

**Open questions:**

- Exact instrument (IPIP-BFM length vs shorter BFI-2-S) for adult v1?  
- Is “owner-only chat with *my* Double” vs “any registered user chats any Double” the v1 rule?  
- Solo mode before or after first self-serve village placement?  
- Domain: ondouble.com vs doubland.ai vs single hostname for onboard?  

---

## 8. References

### Rehears (code & docs)

- Repo: `D:\Coding\rehears`  
- Auth: `lib/services/auth.ts`, `lib/contexts/AuthContext.tsx`, `docs/AUTH_SETUP.md`  
- Profile storage: `lib/services/personalityStorage.ts`, migrations `user_profiles`  
- Flows: `docs/workflows.md`, `docs/double-it/0.rehears_concept.md`  
- Export to sim: `double/fetchPersonalities.md`  
- Features: `docs/dailyDilemma/`, `docs/ask-my-double/`, `docs/big-5/`  

### Doubland (SOT & plans)

- Onboarding phases: `double-docs/sot/sot_lifecycle.md` §6  
- Chat ownership roadmap: `double-docs/sot/sot_chats.md` §6.9 v4  
- Historical integration sketch: `double-docs/x_next/5.2.rehears-double.md`  
- Brand / design: `double-docs/landing/`  
- MVP scope guard (auth deferred): `double-ivan/TODO_mvp-release-gate.md`  

---

## Appendix A — Historical plan: shared Supabase dual-app (pre–2026-07-14)

> Preserved for context. Assumes ondouble.com as identity + profile authority and doubland.ai as simulation layer. **Superseded as long-term default by §4 (port / modular onboarding).** May still inform a **temporary** shared-Auth bridge.

**Original goal:** Users who create rich profiles on ondouble.com use the same credentials in doubland.ai simulations.  
**Original approach:** Option A — Shared Supabase project.  
**Original timing:** After MVP Telegram Survival demo; self-serve deferred until integration.

### A.0 Alignment

1. Confirm shared Supabase vs API layer.  
2. Boundaries: ondouble = build double; doubland = live in sims.  
3. Open questions: lightweight doubland signup → redirect to quiz; long-term IdP.  
4. Metrics: % with existing profile; time to first real-personality sim; consistency feedback.

### A.1 Shared Auth setup

- Multi-domain redirect URLs + CORS  
- Header/PKCE session strategy across domains  
- RLS: `user_profiles` SOT; doubland reads, does not corrupt core profile tables  
- Smoke: register → quiz → login doubland → profile readable  

### A.2 Profile import & gate

- Gate: completed `user_profiles` or CTA to create Double  
- Return URL after quiz  
- Versioned personality payload for sims  
- Dev import harness  

### A.3 E2E & polish

- Happy path + edge cases (incomplete quiz, token expiry)  
- Brand treatment; monitoring  

### A.4 Hardening

- Security/compliance; runbook; escape hatch to Double API; dual-team sign-off  

**Next step if using this path only:** time-box bridge and name sunset criteria for Rehears UI.

---

## Appendix B — One-page summary for busy readers

| Topic | Takeaway |
|-------|----------|
| What Rehears is | Auth + Big-5 + dilemma/advice loops; teen-era Next/Supabase app |
| What’s gold | Assessment + patterns for profile; optional solo loops |
| What’s not | Permanent second product; teen content; dual chat stacks |
| PO intent | Quiz **+ interview** → rich Double; adult content; Doubland UX; prioritize hard |
| Architecture | **Port into Doubland**; modular for future onboarding owner |
| Do first | Auth, ownership, chat gate, adult Big-5, adapter, interview, bind to sim |
| Do later | Daily Dilemma, solo rehearsal polish, viral shares, microservice split |

**Recommended team action:** Review §5–§6 in a 30–45 min meeting; lock decisions 1–4; open a single implementation epic under Doubland (not a perpetual “integrate two repos” workstream).
