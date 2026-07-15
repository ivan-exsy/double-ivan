# Epic: Self-serve owned Double (Rehears → Doubland)

**Status:** Active — Weeks 1–3 core **CLOSED**; **3.1** identity publish + **3.2** Talk-to-my-Double API + **3.3** post-chat learning **shipped (code)**. Residual: apply 3.3 migration + live smoke; open product work in **[TODOs](#todos)**.
**Branch / worktree:** `ivan/dev` → `D:\Coding\generative_agents-ivan-dev` · FE `ivan/self-serve-double`  
**Base:** forked from current `railway` (`0e393ca6`, 2026-07-14). VPS stays on `railway`; implement only in this worktree.  
**Architecture:** Port into Doubland (not permanent two-app). One Auth. Doubland-owned profile SOT.  
**Success metric:** A non-operator user can sign in → assess → seed an owned Double → chat with it (and optionally bind to a sim) without an engineer hand-authoring the soul.

**Related:** `TODO_rehears-doubland.md` · `sot_lifecycle.md` §6 · `sot_chats.md` §6.9 v4 · `5.2.rehears-double.md` (historical dual-app — superseded)

---

## TODOs

Open work only. Completed weeks stay under **Week plan** below for history.

| ID | One-liner | Notes |
|----|-----------|--------|
| **D1-FE** | Talk to my Double **UI** (interview/profile → `GET/POST /api/me/double*`) | D1-BE done (3.2). **Explicitly skipped for now** (Ivan 2026-07-14) |
| **D2** | Self-serve Phase D bind — owned Double on a real sim roster | Operator Phase D CLI/REST exists |
| **D3** | Village-grade host productization beyond personal `owned-*` chat host | Personal chat host shipped 3.2 |
| **D4** | Broader chat loader polish (non-owned empty-baseline edges) | Owned step-0 + ISS fixed 3.2 |
| **D5** | Permanent owned-Double chat QA harness (not one-off smoke) | Product path already green via 3.2 |
| **D6** | Adult IPIP stem expert sign-off | Optional research; not blocking |
| **D7** | Railway / Vercel promote of self-serve path | Local-only until Ivan sign-off |
| **3.3** | Post-chat profile learning (assess → FE confirm → Path A) | **Shipped code** — store+confirm+FE; apply migration `20260717120000`; live smoke pending |
| **W4-a** | Onboarding/quiz UX design pass (Doubland language) | Week 4 candidate |
| **W4-b** | Daily Dilemma adult bank **or** “what would my Double do?” mode | Week 4 candidate |
| **W4-c** | Re-test / profile versioning product surface | Week 4 candidate |
| **Misc** | Chapter-changed memory injection after identity retake | Nice follow-up to 3.1 |
| **Misc** | Self-serve Phase D job/home FE | Tied to D2 |

---

## Shipped baseline (do not rebuild)

| Area | Status | Reuse / gap |
|------|--------|-------------|
| **Lifecycle Phase D** — job/home binding | **Shipped** CLI+REST (`ENABLE_ONBOARDING_HOST`); finalize writes scratch + report | Self-serve FE still missing; sim-only goal slot deferred |
| **Lifecycle Phases A–C** | **Deferred** in SOT (post-MVP) | This epic *implements* A–C (account, profile, completeness) |
| **Profile pipeline** | Operator/soul docs + snippets; `get_persona_profile_context` | Adapter must **write** these paths, not invent parallel storage |
| **Chat with Double v1** | **Shipped** — threads, memory retrieve, write-back (P3-1), rate limits | Open endpoint when gate off; service-role |
| **Chat v4 slice A** | **Shipped** (Week 1) | `user_id` on threads + JWT ownership; creator prompt = **slice B / Week 3** |
| **Auth** | **Productized for self-serve path** (Week 1) | Gateway JWKS ES256 + FE magic link; `CHAT_REQUIRE_AUTH` default off on VPS |
| **Post-chat learning (W3.3)** | **Shipped (code)** — assess store + FE confirm + Path A `source=post_chat` | Migration apply + live smoke residual (`3.3-ops`); never silent ISS |
| **MVP consent** | Manual claim in Telegram | Self-serve claim/auth was explicitly out of MVP scope — this epic is the post-MVP unlock |

**Implication for Week 1:** Build only the missing **identity + ownership spine**. Everything else (quiz, interview, Phase D self-serve UI) hangs off that spine.

---

## Week plan + acceptance criteria

### Week 1 — Identity spine (thinnest vertical slice)

**Build**
1. Supabase Auth session validation on API gateway (Bearer JWT → `auth.uid()`).
2. FE (or minimal test client): sign-in / session attach to gateway calls.
3. Chat v4 **slice A**: `user_id` on `user_chat_threads` (+ migration); create/continue threads only when authenticated; optional “registered users only” gate (flag-friendly).
4. Ownership stub: map `auth.uid()` → owned persona(s) via existing `dbl_agent.user_id` and/or a thin `double.user_doubles` link table if agent link is incomplete.
5. Document profile payload **v0** contract (user_id only; no Big-5 yet) in epic/SOT note.

**Out of scope this week:** Big-5, interview, adapter→soul, Phase D FE, dilemmas, design polish.

**Acceptance**
- [x] Unauthenticated `POST …/chat` → **401** when gate enabled. *(live auto 2026-07-14: gate on, no token + garbage Bearer → 401)*
- [x] Authenticated user can open a thread; `user_chat_threads.user_id` = their `auth.uid()`. *(live ES256 JWT via JWKS: thread `a66ed58a-…` / `5a23b996-…` stamped `646e1c7e-…`)*
- [x] User A cannot continue User B’s thread (403/400 ownership). *(live: B on A’s thread → 403; A continues → 200; anon on owned → 403)*
- [x] Existing open chat still works when gate **disabled** (rollback flag) for operator demos. *(live: flag off, no token → 200, `user_id` NULL on `ac5ff1b7-…`)*
- [x] One smoke path documented (curl or FE): login → chat one turn → row in DB with correct `user_id`. *(auto Admin API + password grant + JWKS; FE `/auth` on `ivan/chat-auth-w1`)*

**Repos:** `api_gateway` auth dependency · migration on chat tables · `chat_with_double_service` ownership check · FE session header (double-front or temporary harness).

**Week 1 progress (2026-07-14, branch `ivan/dev`):**
- [x] `api_gateway/app/core/auth.py` — Supabase JWT decode + `get_chat_user`
- [x] `CHAT_REQUIRE_AUTH` + `SUPABASE_JWT_SECRET` in config
- [x] Migration `20260714120000_chat_thread_user_id.sql` — `user_id` + RPC `p_user_id`
- [x] Chat service ownership + route 401/403 wiring
- [x] Unit tests `api_gateway/tests/test_chat_auth.py` + `test_me_doubles.py` + memory injection — **31 passed**
- [x] Apply migration on Supabase project (`double-openrouter` / `kkjhsozszgoorwehhsdg`) — column + 4-arg RPC verified
- [x] FE: pass `Authorization: Bearer` on chat (double-front `ivan/chat-auth-w1`)
- [x] Ownership stub: `GET /api/me/doubles` + tests
- [x] Profile payload **v0** documented (below)
- [x] Live open-path + gate-on 401 smoke (results below)
- [x] Gateway JWT verify upgraded to **JWKS / ES256** (primary); legacy HS256 secret optional fallback only
- [x] **Live auto smoke complete** (Admin-minted users, ES256 access tokens, JWKS verify, stamp + 403 + gate rollback)

### Profile payload v0 (Week 1 contract)

```json
{
  "version": "v0",
  "user_id": "<uuid auth.users id>"
}
```

- **Only field:** `user_id` (Supabase Auth subject).
- **Storage this week:** stamped on `double.user_chat_threads.user_id`; listed via `dbl_agent.user_id` on `GET /api/me/doubles` (`profile_version: "v0"`).
- **Not yet:** OCEAN, interview, soul fields (Week 2–3).
- **v1 (Week 2):** + domain means (1-5) + labels + personality_summary (not population percentiles).
- **v2 (Week 3):** + interview seeds (learned / currently / goals).

### BE contract (Chat v4 slice A)

| Item | Contract |
|------|----------|
| Header | `Authorization: Bearer <supabase_access_token>` (optional when `CHAT_REQUIRE_AUTH=false`) |
| JWT verify | **Primary:** JWKS ES256 from `{SUPABASE_URL}/auth/v1/.well-known/jwks.json`. **Optional fallback:** `SUPABASE_JWT_SECRET` HS256 (legacy only). |
| Gate off (default) | No token → open chat; new threads may have `user_id` NULL |
| Gate on | No/invalid token → **401**; valid token → stamp `user_id` = JWT `sub` on **new** threads |
| Owned thread | Caller `user_id` must match thread `user_id` else **403** |
| Legacy thread | `user_id` NULL → allowed without ownership match |
| Gateway DB path | Service-role RPC only; JWT verified on gateway, then `p_user_id` into `chat_create_thread` |
| Ownership list | `GET /api/me/doubles` requires Bearer; does **not** gate chat |
| VPS safety | Default `CHAT_REQUIRE_AUTH=false`; do **not** enable gate or deploy `ivan/dev` to railway until Ivan asks |

### Smoke results (2026-07-14, local gateway + double-openrouter)

| Check | Result |
|-------|--------|
| Migration `user_id` column | **PASS** (nullable uuid on `double.user_chat_threads`) |
| RPC `chat_create_thread(..., p_user_id uuid)` | **PASS** |
| Unit tests auth + me + memory | **PASS** (31) |
| Flag off, no token → chat | **PASS** 200; thread `a155e73f-1298-4e65-9514-4fa33d1e731d`; `user_id` **NULL** |
| Flag on, no token → 401 | **PASS** |
| Flag on, garbage Bearer → 401 | **PASS** |
| `GET /api/me/doubles` no token → 401 | **PASS** |
| Flag on, real JWT → stamp `user_id` | **PASS** ES256 token; thread `5a23b996-…` / `a66ed58a-…` → `user_id=646e1c7e-…` |
| User A vs B thread 403 (live) | **PASS** B→403; A continue→200; anon on owned→403 |
| Unit tests JWKS ES256 + HS256 fallback | **PASS** (34 with memory injection) |
| `GET /api/me/doubles` with valid token | **PASS** 200 + matching `user_id` |
| Week 1 **CLOSED** — ready for Week 2 | **YES** (no VPS deploy; gate remains default off) |

**Smoke (JWKS primary — needs only `SUPABASE_URL` already in `.env.local`):**

```bash
# 0) Env (local only — never railway / VPS)
# SUPABASE_URL=https://kkjhsozszgoorwehhsdg.supabase.co   # enables JWKS
# SUPABASE_JWT_SECRET=...   # OPTIONAL legacy fallback only — not required for Week 1
# CHAT_REQUIRE_AUTH=false   # default

# 1) Flag off (demo rollback) — open chat still works
curl -s -X POST "http://localhost:8001/api/simulations/20260713-1/personas/Diana%20Ogden/chat" \
  -H "Content-Type: application/json" -d '{"message":"Hello"}'

# 2) Flag on — require token; user_id stamped on thread
# CHAT_REQUIRE_AUTH=true  (restart gateway after setting)
curl -s -o /dev/null -w "%{http_code}" -X POST \
  "http://localhost:8001/api/simulations/20260713-1/personas/Diana%20Ogden/chat" \
  -H "Content-Type: application/json" -d '{"message":"nope"}'
# expect 401

curl -s -X POST "http://localhost:8001/api/simulations/20260713-1/personas/Diana%20Ogden/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{"message":"Hello"}'
# SQL: SELECT id, user_id FROM double.user_chat_threads ORDER BY created_at DESC LIMIT 5;
# Other user's token on same thread_id → 403; no token with flag on → 401

# Ownership stub
curl -s "http://localhost:8001/api/me/doubles" -H "Authorization: Bearer $ACCESS_TOKEN"
```

**FE path:** double-front branch `ivan/self-serve-double` (auth + quiz) — `http://localhost:3000/auth` magic link → Talk + `/onboarding/quiz` attach Bearer.

**Coexistence with VPS:** Gate defaults **off**; migration is backward-compatible (`p_user_id` default null). Do **not** set `CHAT_REQUIRE_AUTH=true` on production or deploy this branch to the VPS in this handoff.

---

### Week 2 — Adult Big-5 v1 + profile store + adapter seed

**Build**
1. Adult item bank v1 (content rewrite; no teen CSVs) + scoring engine ported from Rehears patterns.
2. Persist OCEAN + summary under Doubland-owned tables (not Rehears as SOT).
3. Profile adapter v1: OCEAN + summary → `persona_profile_documents` / snippets + ISS seed fields (`innate`/`learned` baseline).
4. Link created persona to owning `user_id`.

**Acceptance**
- [x] Signed-in user completes quiz → profile row owned by them. *(live 2026-07-14: profile `b0e495dc-…`, user `c2677e73-…`, means O4.6/C4.4/E4.0/A3.6/N1.6)*
- [x] Adapter produces active document + snippets + linked persona. *(persona `97b365d0-…` / `ipistsov's Double` via `dbl_agent`)*
- [x] Soft demo mode: operator can still run pre-profiled rosters without quiz. *(Vincent Slater cast chat still works; Diana threads with `user_id` null remain)*
- [x] Chat with **owned** self-serve persona uses seeded traits (spot-check). *(closed by Week 3 creator smoke + Week 3.2 `POST /api/me/double/chat`)*

**BE + FE progress (closed 2026-07-14 local smoke):**
- [x] Adult IPIP-BFM-25 bank `adult-v1` + scoring (domain means, reverse keys 1/9/10/11/12/22/25)
- [x] `GET /api/me/quiz/items` (+ alias `/api/quiz/ipip-bfm-25`), `POST /api/me/quiz/submit`, `GET /api/me/profile`
- [x] Table `double.user_personality_profiles` applied on shared Supabase (`kkjhsozszgoorwehhsdg`)
- [x] Adapter → personas + profile documents/snippets + `dbl_agent.user_id`
- [x] Contract frozen — `20260714_fe_request.md` §5.5
- [x] FE live wire (`NEXT_PUBLIC_QUIZ_USE_MOCK=false`) on `ivan/self-serve-double` — quiz UI + results
- [x] FE magic link sign-in → session → Bearer on quiz + chat
- [x] Week 1 chat stamp re-verified: Vincent thread `b3378a22-…` → `user_id=c2677e73-…`
- [ ] Content owner formal sign-off on adult stems (draft stems shipped; polish optional) → see **TODOs** D6
- [x] Chat trait-colored spot-check with **owned** Double *(Week 3.2 live smoke on owned host)*

**Profile payload v1 (domain means -- not percentiles):** see FE request `20260714_fe_request.md` section 5.5 submit response.

**Week 2 CLOSED** for product smoke (quiz + store + ownership link + cast chat coexistence). No vercel/railway promote yet.

---

### Week 3 — Interview v1 + completeness + creator chat (slice B)

**Status:** **CLOSED** 2026-07-14 (local live smoke). Phase D self-serve bind and product “Talk to my Double” UI are **explicitly deferred** — see [TODOs](#todos).

**Build (done)**
1. Short interview (values / lifestyle / goals / voice) → fills `learned` / `currently` / goals seeds.
2. Soft completeness gate (`prediction_ready`) vs hard block for “my Double” claims.
3. Chat v4 **slice B**: system prompt “talking to your creator” when owner + `prediction_ready`.
4. ~~Self-serve Phase D host entry~~ → **deferred** (operator Phase D REST still shipped; self-serve FE/bind not in Week 3 close).

**Acceptance**
- [x] Incomplete profile → soft gate message; complete → eligible for bind flags. *(API `prediction_ready` / FE Finish interview CTA)*
- [x] Owner chat prompt differs when owner + prediction_ready (creator mode / slice B).
- [x] End-to-end live smoke: sign in → quiz → interview → seed → chat with **owned** Double. *(live 2026-07-14: interview `prediction_ready`; creator chat thread `4fb0dceb-…` on host sim `20260714-owned-double-smoke`, persona `ipistsov's Double`, `user_id=c2677e73-…`; reply referenced startup aim + quiz traits.)*
- [ ] ~~User can bind **their** Double via Phase D API (or auto-bind)~~ → moved to **TODOs** (D2)

**Expert input accepted 2026-07-14** — implemented from §9 / COS `2026-07-14-002` only (no invented content).

**BE + FE progress (`ivan/dev` + `ivan/self-serve-double`):**
- [x] `double-interview-v1` bank + validation + Sam Calder soul fixture tests
- [x] `GET /api/me/interview/items`, `POST /api/me/interview/submit`
- [x] Profile columns interview_* / soul_seeds / prediction_ready (migration applied remote)
- [x] Completeness flags on `GET /api/me/profile`
- [x] Creator chat system-prompt + soul overlay when ready
- [x] FE `/onboarding/interview` + quiz soft-incomplete CTA
- [x] Live interview submit smoke + owned-Double chat *(API path; temporary host sim + step-1 coords seed)*

---

### Week 3.1 — Identity publish (Path A) + living chapters

**Status:** **CLOSED / IMPLEMENTED** 2026-07-14 (code + migration + live retake smoke)

**Goal:** Quiz/interview author the Double; active identity is published into scratch ISS + profile (same path cast souls use). Retakes supersede the active chapter, archive the prior one, and re-publish.

**Build**
1. Migration: `identity_revision` / `identity_effective_from` / `identity_pending` on profile; `user_identity_versions` history table.
2. `identity_publish_service`: archive prior chapter, bump revision, write ISS to `persona_scratch` (non-generating sims), sync `dbl_agent.config`.
3. Wire `submit_interview` + `submit_quiz` (quiz keeps interview chapter on retake).
4. Chat: prefer scratch ISS; fill blanks from `soul_seeds` only (no full overwrite).

**Acceptance**
- [x] Publish service + unit tests (merge, overlay prefer-scratch)
- [x] Interview/quiz submit call publish
- [x] Chat overlay prefer-scratch
- [x] Profile payload exposes `identity_revision` / `identity_effective_from`
- [x] Live retake smoke: revision bumps, history row, scratch ISS updated *(2026-07-14: rev 1→2, history row, host sim scratch lifestyle publish; marker cleaned)*

**Out of 3.1:** see [TODOs](#todos) (D1-FE, D2–D4, chapter-changed memory).

---

### Week 3.2 — Talk-to-my-Double API (D1-BE)

**Status:** **IMPLEMENTED** 2026-07-14 (live smoke)

**Build**
1. `GET /api/me/double` — resolve owned Double + personal host sim (`owned-<user8>`)
2. `POST /api/me/double/chat` — creator chat; auto host + scratch ISS; reuses `handle_chat_message`
3. Stale-baseline exception: step-0 scratch with non-empty ISS allowed (owned host path)
4. FE Talk button **not** shipped → **D1-FE** deferred

**Acceptance**
- [x] `GET /api/me/double` + personal host
- [x] `POST /api/me/double/chat` creator mode
- [x] Step-0 + ISS allowed for owned host
- [x] Live smoke: host `owned-c2677e73`; thread `dd85d1c6-…`; creator_mode true

FE Talk UI → **TODOs** D1-FE (explicitly skipped for now).

### Week 3.3 — Post-chat profile learning

**Status:** **IMPLEMENTED (code)** — expert accepted COS `2026-07-14-003`; BE store+confirm+FE review; apply migration `20260717120000`
**Inquiry §9:** `double-ivan/rehears-double/20260714_behavior_science_inquiry_week3_3_post_chat_learning.md`  
**Canonical:** `COS/tasks/2026-07-14-003/final.md` · KB `agents/jordanpeterson/kb/raw/task-deliverables/2026-07-14-week33-post-chat-learning.md` · decision `wiki/decision/post-chat-learning-v1.md`  
**Intent:** After creator chat, assess for non-clinical life-chapter signal → **propose → FE confirm → Path A** (`source=post_chat`). Never mutate `innate`/quiz from chat.  
**Engineering:** implement from §9; **no Path A apply without FE review UI**; API may store proposals for smoke first.

---

### Week 4 — Design pass + retention candidates (only if Weeks 1–3 green)

**Build (pick by need)**
- Onboarding/quiz UX in Doubland design language.
- Daily Dilemma adult bank **or** solo “what would my Double do?” as Chat-with-Double mode.
- Re-test / profile versioning.

**Acceptance**
- [ ] Functional path still green after UX pass.
- [ ] No second chat product; no permanent Rehears IdP.

---

## Explicit non-goals (entire epic)

- Permanent dual-app Rehears as IdP  
- Teen item banks / school-email auth  
- Dual “Ask My Double” + Chat with Double  
- Full scientific re-norming study  
- Onboarding microservice extraction  
- Paid multi-tenant villages before ownership + profile quality  

---

## Week 1 implementation notes (start here)

**Prefer existing hooks**
- `dbl_agent.user_id` already ties agents to users in memory RPCs.
- Chat tables + RPCs exist; extend with `user_id`, do not redesign chat.
- Phase D host stays operator-grade for self-serve; self-serve bind/FE still **TODOs** (D2).

**Flag**
- `CHAT_REQUIRE_AUTH=true` (or equivalent) — default off in prod until FE ships; on in worktree/dev.

**Rollback**
- Flag off → previous open chat behavior for Survival demos.
---

## Decision log (locked 2026-07-14)

1. Port into Doubland · 2. One Auth · 3. Doubland profile SOT · 4. Big-5 + interview for full Double · 5. Soft gate for demos, hard for “my Double” claims · 6. Solo loops inside Doubland later · 7. Modular schemas now, extract onboarding later.

