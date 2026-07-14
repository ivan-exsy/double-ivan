# Build inquiry — Doubland Big-5 quiz shell (Week 2)

**To:** double-front / FE owners  
**From:** Ivan / Doubland BE (self-serve Double epic)  
**Date:** 2026-07-14  
**Status:** Ready for capacity + approach reply  
**Epic:** `double-ivan/rehears-double/EPIC_self-serve-double.md` (Week 2)  
**Related:** Rehears content reply (same day) — instrument **IPIP-BFM-25**, adult-retuned stems, **domain means only** (no teen percentiles)

---

## 1. Why this exists

Week 1 identity spine is **closed** on BE (`ivan/dev`): Supabase JWT (JWKS ES256), chat thread ownership, `GET /api/me/doubles`.

Week 2 needs a **signed-in user** to complete a short personality quiz so we can:

1. Store OCEAN + summary under **Doubland-owned** tables  
2. Adapter-seed a Double (profile docs / ISS baseline)  
3. Chat with a trait-colored persona  

**FE lives only in double-front** (not `generative_agents`). BE will ship API + scoring; FE ships the minimal quiz shell.

This is a **build inquiry**, not a commit request: confirm capacity, route ownership, and borrow depth from Rehears before implementation starts.

---

## 2. Product intent (v1)

| Goal | Detail |
|------|--------|
| Audience | **Adult / general** Doubland users (not high school) |
| Instrument | **IPIP-BFM-25** only (25 items, public domain) |
| UX pattern | One question at a time, **5-point Likert slider**, situational stem + left/right anchors |
| Auth | Supabase session already started for Chat v4 (`/auth` magic link on branch `ivan/chat-auth-w1`) |
| After quiz | Show simple OCEAN summary (means 1–5 + short labels); no teen percentile bands |
| Soft demo | Pre-profiled Survival/demo casts **still work without quiz** |

**Copy stance:** “Personality snapshot for your Double” — not clinical diagnosis.

**Out of scope for this shell (later weeks):** full Doubland design polish (Week 4), interview, Phase D job/home bind UI, Daily Dilemma, Rehears dual-app, test-type picker, teen audiences.

---

## 3. Decisions already locked (do not re-open in FE)

| Decision | Value | Source |
|----------|--------|--------|
| Instrument | **IPIP-BFM-25** | PO + Rehears reply |
| Scoring v1 | Domain **means 1–5** (and/or raw 5–25); **no percentiles** | Rehears: no adult norms |
| Stems | Adult rewrite of high-school situational stems; keep `question_text` + reverse keys | Rehears content hierarchy |
| Profile SOT | Doubland Supabase / gateway — **never** Rehears Supabase from FE | Epic architecture |
| Production gate | `CHAT_REQUIRE_AUTH` stays default **off** on VPS; this quiz path is for self-serve | Week 1 handoff |

---

## 4. Scope for double-front (v1 shell)

### In scope

1. **Route** (proposal): `/onboarding/quiz` or `/quiz` (name open)  
2. **Auth gate:** if no session → redirect or CTA to existing `/auth`  
3. **Load items:** from Doubland gateway (not Rehears DB) once BE ships; interim mock JSON OK for parallel FE work  
4. **Quiz UI:**  
   - Progress (e.g. “7 / 25”)  
   - Situational stem  
   - 1–5 slider (or equivalent) with left/right labels + optional icons  
   - Back / next  
   - Submit all answers  
5. **Results screen (minimal):** five trait means + short “higher / typical / lower” labels + optional one-line summary from API  
6. **API client:** Bearer on all quiz calls (same pattern as Chat Bearer attach)

### Explicitly out of scope (do not port from Rehears yet)

| Rehears feature | Path (reference only) | Why skip |
|-----------------|------------------------|----------|
| Test type selector / BFI-only force | `app/quiz/page.tsx`, `components/test-selector.tsx` | Doubland fixed to IPIP-BFM-25 |
| Pre-motivational / post-congrats / confetti milestones | `quiz-pre-motivational.tsx`, `quiz-post-congratulations.tsx`, `quiz-milestone-message.tsx` | Polish later |
| Enhanced personality type synergy names | `lib/utils/enhancedPersonalityAssessment.ts` | Built on **teen** percentiles — do not reuse |
| Direct Supabase `quiz_questions` reads | `lib/services/quizService.ts` | FE → **gateway only** |
| Teen norms / z-score UI | `lib/utils/teenNorms.ts`, `enhancedScoring.ts` | Adult product |
| Analytics Rehears-specific | `AnalyticsService` in `useQuizFlow` | Optional later |

### Soft / optional v1

- Local draft persistence mid-quiz (Rehears has `quizPersistence.ts`) — nice if cheap  
- Mobile-friendly full-height layout (Rehears quiz is slider-first)

---

## 5. Detailed references — borrow from Rehears (logic, not pixels)

**Rehears root:** `D:\Coding\rehears`  
**Doubland FE root:** `D:\Coding\double-front`  
**Epic / this inquiry:** `D:\Coding\double-ivan\rehears-double\`

### 5.1 Primary UI to study (copy patterns, re-skin)

| File | Role | What to reuse |
|------|------|----------------|
| `rehears/app/components/big-five-quiz.tsx` | Core one-question slider loop | Slider binding, back/next, progress callbacks, neutral default = 3 |
| `rehears/app/components/enhanced-big-five-quiz.tsx` | Wrapper flow | **Optional** structure only; drop motivation/congrats for v1 or stub empty |
| `rehears/lib/hooks/useQuizFlow.ts` | Load questions, answers map, complete | **Concept** only — replace `QuizService` + scoring with gateway calls |
| `rehears/lib/types/quiz.ts` | `QuizQuestion`, slider fields, `ICON_MAP` | Shape for FE types (stems, anchors, icons) |
| `rehears/app/components/personality-results.tsx` | Results presentation | Strip to OCEAN bars/means; no teen band language |

### 5.2 Do **not** call / do **not** depend on from double-front

| File | Reason |
|------|--------|
| `rehears/lib/services/quizService.ts` | Reads Rehears Supabase audiences/questions |
| `rehears/lib/services/personalityStorage.ts` | Writes Rehears `user_profiles` |
| `rehears/lib/utils/enhancedScoring.ts` + `teenNorms.ts` | Teen percentiles / wrong SOT |
| `rehears/lib/contexts/AuthContext.tsx` | Port patterns if useful; use double-front `lib/auth.ts` as SOT for Doubland |

### 5.3 Content / scoring truth (BE owns; FE displays)

| Artifact | Path | FE need |
|----------|------|---------|
| Item bank reference | `rehears/docs/big-5/big-5_questions.csv` (filter `IPIP-BFM-25`) | Understand stem + anchors; **runtime from API** |
| Reverse keys (order_weight) | Rehears reply: IPIP **1, 9, 10, 11, 12, 22, 25** | FE sends raw 1–5 only; BE reverses |
| Scoring method | `rehears/docs/big-5/big-5_scoring.md` §§1–3.2 | Display means 1–5; no CDF UI |
| Adult plain items (legacy only) | `rehears/docs/big-5/quizQuestions.md` | **Not** the IPIP stem bank; ignore for v1 slider |

### 5.4 Doubland FE already in place (compose with)

| File | Role |
|------|------|
| `double-front/lib/auth.ts` | Magic link, `getAccessToken()`, session helpers (branch `ivan/chat-auth-w1`) |
| `double-front/app/auth/page.tsx` + `app/auth/callback/page.tsx` | Sign-in surface |
| `double-front/lib/api.ts` | Gateway base URL pattern; Chat already attaches Bearer when present |
| `double-front/lib/supabase.ts` | Browser client (anon); **no** service role |

### 5.5 BE contracts — **CONTRACT FROZEN 2026-07-15**

Base: `NEXT_PUBLIC_API_GATEWAY_URL` (e.g. `http://localhost:8001`)

| Method | Path (**locked**) | Auth | Purpose |
|--------|-----------------|------|---------|
| `GET` | **`/api/me/quiz/items`** (alias: **`/api/quiz/ipip-bfm-25`**) | **Bearer required** | 25 adult-v1 items: `id`, `order`, `trait`, `question_text`, `situational_stem`, anchors, likert texts/icons. No `is_reversed`. |
| `POST` | **`/api/me/quiz/submit`** | **Bearer required** | Body: `{ instrument: "IPIP-BFM-25", answers: [{ item_id, value: 1-5 }] }` → means/labels/summary + profile/persona ids |
| `GET` | `/api/me/profile` | Bearer required | Existing/owned profile for “already completed” branch |
| Existing | `GET /api/me/doubles` | Bearer required | Ownership stub after adapter links persona |

**Item `id` format (locked):** `ipip-bfm-25-1` … `ipip-bfm-25-25` (**no zero-pad**). Always submit the `id` returned by GET items.

**Label cut points (BE-owned):** mean ≤ 2.5 → `lower`; ≤ 3.5 → `typical`; else `higher`. (FE mock bands may differ slightly.)

**Reverse keys (BE-only):** orders `1, 9, 10, 11, 12, 22, 25`. FE sends raw 1–5 only.

**Live wire:** set `NEXT_PUBLIC_QUIZ_USE_MOCK=false`; gateway on `:8001`; migration `user_personality_profiles` applied on dev Supabase. Keep FE branch off `vercel` until epic sign-off.

**Submit response shape (proposed for FE planning):**

```json
{
  "profile_version": "v1",
  "instrument": "IPIP-BFM-25",
  "user_id": "<uuid>",
  "domain_means": {
    "openness": 3.4,
    "conscientiousness": 4.0,
    "extraversion": 2.8,
    "agreeableness": 3.6,
    "neuroticism": 2.2
  },
  "domain_raw": {
    "openness": 17,
    "conscientiousness": 20,
    "extraversion": 14,
    "agreeableness": 18,
    "neuroticism": 11
  },
  "labels": {
    "openness": "typical",
    "conscientiousness": "higher",
    "extraversion": "lower",
    "agreeableness": "typical",
    "neuroticism": "lower"
  },
  "personality_summary": "optional short prose from BE",
  "persona_id": null
}
```

`labels` = coarse bands from **means only** (not population percentiles). Exact cut points BE-owned.

**API landed on BE `ivan/dev`.** FE mock remains default until live wire; use mock for UI-only work.

---

## 6. UX acceptance criteria (FE)

- [ ] Signed-out user cannot complete submit (redirect/sign-in).  
- [ ] Signed-in user can answer all 25 items and submit once.  
- [ ] Raw answers are integers 1–5; no client-side reverse scoring.  
- [ ] Progress visible; user can go back and change an answer.  
- [ ] Results show five traits without teen percentile language.  
- [ ] All quiz API calls send `Authorization: Bearer <access_token>` when session exists.  
- [ ] No calls to Rehears Supabase project.  
- [ ] Visuals: Doubland-adjacent (reuse player/onboarding chrome if easy); **not** purple Rehears skin as final brand.  

---

## 7. Branch / repo hygiene

| Repo | Branch convention | Note |
|------|-------------------|------|
| `double-front` | `ivan/*` or FE-owner prefix per team rules | Feature branch for quiz shell |
| `generative_agents-ivan-dev` | `ivan/dev` | BE API + scoring + adapter |
| Deploy | **Do not** push quiz gate to railway/VPS until Ivan asks | Same as Week 1 |

Suggested FE branch name: `ivan/quiz-shell-w2` (or FE lead equivalent).

---

## 8. Suggested implementation split

| Track | Owner | Deliverable |
|-------|--------|-------------|
| A | BE | Item bank JSON (IPIP-BFM-25 + adult stems), score, profile write, submit API |
| B | FE | Quiz route + slider shell + results + API client (mock-first OK) |
| C | BE+FE | Contract freeze on submit request/response; one integration smoke |

**Parallel start:** FE can build UI against mock items **now** while BE adult-retunes stems and ships API.

---

## 9. Questions for FE (please answer)

1. **Capacity:** Can a thin quiz shell land this sprint / next (dates)?  
2. **Route name:** Prefer `/onboarding/quiz`, `/quiz`, or under existing sim chrome?  
3. **Sequence:** Mock-first FE, or wait for BE OpenAPI?  
4. **Design:** Accept “functional Doubland chrome” for v1, polish in Week 4?  
5. **Auth:** Confirm reuse of `lib/auth.ts` + `/auth` from `ivan/chat-auth-w1` (merge that first if not already on your base branch).  
6. **Owner:** Who implements and reviews on double-front?

---

## 10. Background for FE (one paragraph)

Doubland is porting self-serve “my Double” from Rehears **into** Doubland (one Auth, Doubland profile SOT). Rehears quiz code is a **pattern quarry**: slider UX and question shape are good; Rehears DB, teen norms, BFI-forced UI, and purple branding are not. Content base is IPIP-BFM-25 with **adult** situational stems (rewritten from high-school stems in `big-5_questions.csv`); scoring is domain means only until adult norms exist.

---

## 11. Reply template (FE → Ivan)

```text
Capacity: <dates>
Owner: <name>
Route: </>
Approach: mock-first | wait-for-API
Auth branch: will merge / already has ivan/chat-auth-w1
Blockers: <none | list>
```

---

## 12. Appendix — Rehears item shape (for mock data)

From `rehears/lib/types/quiz.ts` / CSV columns for IPIP-BFM-25:

```ts
type QuizItemV1 = {
  id: string              // Doubland-stable id (BE assigns)
  order: number           // 1..25
  trait: 'openness' | 'conscientiousness' | 'extraversion' | 'agreeableness' | 'neuroticism'
  question_text: string   // public-domain IPIP wording (display optional/secondary)
  situational_stem: string  // adult daily-choice stem (primary UI)
  left_anchor: string
  right_anchor: string
  left_text?: string      // e.g. Strongly disagree
  right_text?: string     // e.g. Strongly agree
  left_icon?: string      // thumbs_down
  right_icon?: string     // thumbs_up
  // is_reversed: BE only — FE must not reverse client-side
}
```

Example **teen** stem (to be replaced by adult rewrite before prod copy):

```text
IPIP-BFM-25 #1
question_text: Am indifferent to the feelings of others
situational_stem (HS): When a friend seems upset during lunch, I'm usually...
left_anchor: asking what's wrong and showing concern
right_anchor: indifferent and don't really react
```

Adult rewrite is BE/content work; FE should treat stem/anchors as **opaque strings** from API/mock.

---

**End of inquiry.** Please reply in the template in §11 so BE can schedule API freeze and adult stem bank delivery.
