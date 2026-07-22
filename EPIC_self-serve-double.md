# Epic: Self-serve owned Double (Rehears → Doubland)

**Status:** Active — Weeks 1–3 + **D1-FE Talk** + **D2-BE/FE bind** shipped and joint-smoked locally (2026-07-22). Open work: Week 4 candidates, BE D3/D4, **D7** promote.
**Branch / worktree:** BE `ivan/dev` → `D:\Coding\generative_agents-ivan-dev` · FE `local` (`double-front`)
**Base:** forked from current `railway` (`0e393ca6`, 2026-07-14). VPS stays on `railway`; implement only in this worktree.
**Architecture:** Port into Doubland (not permanent two-app). One Auth. Doubland-owned profile SOT.
**Success metric:** A non-operator user can sign in → assess → seed an owned Double → chat with it (and optionally bind to a sim) without an engineer hand-authoring the soul.

**Related:** `TODO_rehears-doubland.md` · `sot_lifecycle.md` §6 · `sot_chats.md` §6.9 v4 · `5.2.rehears-double.md` (historical dual-app — superseded)

---

## Recommended NEXT STEPS:

Sequence: `A → small hygiene → then decide on B.`

1. A first (½–1 day): Run a short sim so Join World has a visible punchline. That’s the last hole in the self-serve demo.
2. Hygiene (15 min): Close 20260711-1 self-serve access (closed); commit/push BE ivan/dev if anything is still only local.
3. Then B only if you want real users next — with an explicit promote checklist (auth on, worlds private+allowlist or one open QA world, no surprise open roster).
4. Park C/D until after A (and preferably after B or a deliberate “local-only demo” decision).

## TODOs

Backlog for this epic. **Status** = open or done. **Project** = primary repo/worktree.

| ID | Status | Project | One-liner | Notes |
|----|--------|---------|-----------|--------|
| **D3** | open | `generative_agents` | Village-grade host productization beyond personal `owned-*` chat host | Personal chat host shipped 3.2. |
| **D4** | open | `generative_agents` | Broader chat loader polish (non-owned empty-baseline edges) | Owned step-0 + ISS fixed 3.2. |
| **D6** | open | `double-ivan` | Adult IPIP stem expert sign-off | Optional research; not blocking. |
| **D7** | open | `generative_agents` + `double-front` | Railway / Vercel promote of self-serve path | Local-only until Ivan sign-off. |
| **W4-a** | open | `double-front` | Onboarding/quiz UX design pass (Doubland language) | Week 4 candidate. |
| **W4-b** | open | `generative_agents` + `double-front` | Daily Dilemma adult bank **or** “what would my Double do?” mode | Week 4 candidate (bank BE + mode/UI FE). |
| **W4-c** | open | `double-front` | Re-test / profile versioning product surface | Week 4 candidate (history data already on BE). |
| **Misc** | open | `generative_agents` | Chapter-changed memory injection after identity retake | Nice follow-up to 3.1. |
| **Misc** | *done* | `double-front` | Wire chat UI “end session” → `POST /api/me/double/session/end` | Shipped 2026-07-22 with D1-FE Talk page; joint smoke confirmed. |
| **D1-FE** | *done* | `double-front` | Talk to my Double **UI** (interview/profile → `GET/POST /api/me/double*`) | Shipped 2026-07-22 on FE `local`: `/onboarding/talk`. Joint smoke: chat + End session (`iss_mutated` false path). |
| **D2-FE** | *done* | `double-front` | Self-serve Phase D job/home picker UI | Shipped 2026-07-22: `/onboarding/join-world`. Joint smoke green on `20260711-1`; BE verified roster + job/home in DB. Map sticker deferred until sim runs. |
| D2-B | *done* | `generative_agents` | Auto-join + private/open access + allowlist | Shipped 2026-07-22: `self_serve_access`, allowlist table, `POST …/bind/{sim}/join`, gates (capacity, timing, one village bind). |
| D2-BE v1 | *done* | `generative_agents` | Bind options + finalize for owned Double | Shipped 2026-07-22: joinable flag, options shortlists (fast non-LLM path), single-persona finalize. |
| 3.3-ops | *done* | `generative_agents` | Post-chat learning migration + API smoke | Shipped 2026-07-22: migration applied; consent → session-end → confirm/dismiss. |
| **D5** | *done* | `generative_agents` | Permanent owned-Double chat QA harness (not one-off smoke) | Shipped 2026-07-22: unit `scripts/run_self_serve_spine_unit.py` (`-m self_serve_spine`); live `scripts/smoke_self_serve_spine.py --live` (bind join/finalize opt-in via env). |

**Project key:** `generative_agents` = BE (`ivan/dev` worktree) · `double-front` = FE (`local`) · `double-ivan` = product/docs/research.

---

## Shipped baseline (do not rebuild)

| Area | Status | Reuse / gap |
|------|--------|-------------|
| **Lifecycle Phase D** — job/home binding | **Shipped** CLI+REST + self-serve D2-BE v1/B + **D2-FE** | Joinable access modes + allowlist + auto-join + FE picker (`/onboarding/join-world`); joint smoke 2026-07-22; map presence deferred until sim runs; sim-only goal slot deferred |
| **Lifecycle Phases A–C** | **Deferred** in SOT (post-MVP) | This epic *implements* A–C (account, profile, completeness) |
| **Profile pipeline** | Operator/soul docs + snippets; `get_persona_profile_context` | Adapter must **write** these paths, not invent parallel storage |
| **Chat with Double v1** | **Shipped** — threads, memory retrieve, write-back (P3-1), rate limits | Open endpoint when gate off; service-role |
| **Talk to my Double (D1)** | **Shipped** API (3.2) + FE shell (D1-FE) | `/onboarding/talk` + session-end; post-chat review at `/onboarding/post-chat-updates` |
| **Chat v4 slice A** | **Shipped** (Week 1) | `user_id` on threads + JWT ownership; creator prompt = **slice B / Week 3** |
| **Auth** | **Productized for self-serve path** (Week 1) | Gateway JWKS ES256 + FE magic link; `CHAT_REQUIRE_AUTH` default off on VPS |
| **Post-chat learning (W3.3)** | **Shipped** — assess store + confirm API + Path A `source=post_chat` | Migration applied + API live smoke 2026-07-22; never silent ISS |
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

**FE path:** double-front branch `local` (auth + quiz + Talk + Join) — `http://localhost:3000/auth` magic link → `/onboarding/talk`, `/onboarding/join-world`, `/onboarding/quiz` attach Bearer.

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
- [x] FE live wire (`NEXT_PUBLIC_QUIZ_USE_MOCK=false`) on FE `local` (formerly `ivan/self-serve-double`) — quiz UI + results
- [x] FE magic link sign-in → session → Bearer on quiz + chat
- [x] Week 1 chat stamp re-verified: Vincent thread `b3378a22-…` → `user_id=c2677e73-…`
- [ ] Content owner formal sign-off on adult stems (draft stems shipped; polish optional) → see **TODOs** D6
- [x] Chat trait-colored spot-check with **owned** Double *(Week 3.2 live smoke on owned host)*

**Profile payload v1 (domain means -- not percentiles):** see FE request `20260714_fe_request.md` section 5.5 submit response.

**Week 2 CLOSED** for product smoke (quiz + store + ownership link + cast chat coexistence). No vercel/railway promote yet.

---

### Week 3 — Interview v1 + completeness + creator chat (slice B)

**Status:** **CLOSED** 2026-07-14 (local live smoke). Phase D self-serve bind and product Talk UI were deferred from Week 3 close — **closed 2026-07-22** via **D1-FE** + **D2-FE** (see [TODOs](#todos)).

**Build (done)**
1. Short interview (values / lifestyle / goals / voice) → fills `learned` / `currently` / goals seeds.
2. Soft completeness gate (`prediction_ready`) vs hard block for “my Double” claims.
3. Chat v4 **slice B**: system prompt “talking to your creator” when owner + `prediction_ready`.
4. ~~Self-serve Phase D host entry~~ → deferred from Week 3 close; **shipped D2-BE/FE 2026-07-22**.

**Acceptance**
- [x] Incomplete profile → soft gate message; complete → eligible for bind flags. *(API `prediction_ready` / FE Finish interview CTA)*
- [x] Owner chat prompt differs when owner + prediction_ready (creator mode / slice B).
- [x] End-to-end live smoke: sign in → quiz → interview → seed → chat with **owned** Double. *(live 2026-07-14: interview `prediction_ready`; creator chat thread `4fb0dceb-…` on host sim `20260714-owned-double-smoke`, persona `ipistsov's Double`, `user_id=c2677e73-…`; reply referenced startup aim + quiz traits.)*
- [x] User can bind **their** Double via Phase D self-serve path. *(D2-BE/FE joint smoke 2026-07-22: `20260711-1`, barista @ Hobbs Cafe, House 2; BE verified roster + scratch)*

**Expert input accepted 2026-07-14** — implemented from §9 / COS `2026-07-14-002` only (no invented content).

**BE + FE progress (`ivan/dev` + FE `local`):**
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

**Out of 3.1:** see [TODOs](#todos) (D3–D4, chapter-changed memory; D1-FE / D2 closed 2026-07-22).

---

### Week 3.2 — Talk-to-my-Double API (D1-BE)

**Status:** **IMPLEMENTED** 2026-07-14 (live smoke)

**Build**
1. `GET /api/me/double` — resolve owned Double + personal host sim (`owned-<user8>`)
2. `POST /api/me/double/chat` — creator chat; auto host + scratch ISS; reuses `handle_chat_message`
3. Stale-baseline exception: step-0 scratch with non-empty ISS allowed (owned host path)
4. FE Talk UI → **D1-FE** (shipped 2026-07-22)

**Acceptance**
- [x] `GET /api/me/double` + personal host
- [x] `POST /api/me/double/chat` creator mode
- [x] Step-0 + ISS allowed for owned host
- [x] Live smoke: host `owned-c2677e73`; thread `dd85d1c6-…`; creator_mode true
- [x] FE Talk UI `/onboarding/talk` + session-end (D1-FE + Misc; joint smoke 2026-07-22)

### Week 3.3 — Post-chat profile learning

**Status:** **CLOSED / SHIPPED** 2026-07-22 — expert accepted COS `2026-07-14-003`; migration applied on shared Supabase; API live smoke green

**Inquiry §9:** `double-ivan/rehears-double/20260714_behavior_science_inquiry_week3_3_post_chat_learning.md`  
**Canonical:** `COS/tasks/2026-07-14-003/final.md` · KB `agents/jordanpeterson/kb/raw/task-deliverables/2026-07-14-week33-post-chat-learning.md` · decision `wiki/decision/post-chat-learning-v1.md`

**Intent:** After creator chat, assess for non-clinical **life-chapter** signal → **propose → FE confirm → Path A** (`source=post_chat`). Never mutate `innate` / quiz scores from chat. User verify is the privacy control.

**Build (shipped)**
1. Migration `20260717120000_post_chat_learning.sql` — `post_chat_learning_enabled` on profile; `double.post_chat_assessments` store (service_role; RLS on)
2. Validator `double-post-chat-assessment-v1` — reject `innate`, E0/E1/E5 as ISS evidence, blocklist, char caps
3. Assessor job (async-after-session) — gates (consent, prediction_ready, min turns/chars, frequency caps) → separate non-roleplay LLM → validate → **store only** (`iss_mutated: false`)
4. Confirm API — selected fields + optional edits → Path A `publish_active_identity(..., source="post_chat")`; requires `confirmed_by_user_id`; stale `identity_revision` → block
5. Dismiss + consent APIs
6. FE review UI `/onboarding/post-chat-updates` — consent, before/after per field, edit, save, dismiss, opt-out (Talk shell not required for confirm UI; D1-FE shipped separately)

**API (JWT `/api/me`)**
- `POST /double/session/end` — `{thread_id}` assessor store
- `GET /double/post-chat-learning` · `POST /double/post-chat-learning/consent`
- `GET /double/post-chat-assessments` · `GET .../{id}`
- `POST .../{id}/confirm` · `POST .../{id}/dismiss`

**Acceptance**
- [x] Schema validator + Sam fixture unit tests (6 passed)
- [x] Assessor stores proposals only (no Path A from assessor path)
- [x] Confirm → Path A `source=post_chat`; innate preserved; dismiss leaves ISS unchanged
- [x] Stale revision guard on confirm
- [x] FE review surface (not API-only production apply)
- [x] Migration applied on Supabase project (`kkjhsozszgoorwehhsdg`, 2026-07-22)
- [x] Live smoke (API): consent → session-end store (`iss_mutated: false`) → confirm Path A `source=post_chat` (revision bump, innate preserved) → stale revision 409 → dismiss clean → consent off; soul restored (`scripts/smoke_post_chat_33.py`)

**Bugfix during smoke:** `run_session_end_assessment` must pass `require_auth=True` into `_assert_thread_access`.

**Out of 3.3:** mid-session assess; silent auto-apply; quiz score moves; teen instruments. Full LLM assessor on a long thread is optional follow-up (session-end skip/store path verified; confirm uses validated pending assessment). Talk shell shipped as **D1-FE** (2026-07-22).

### Week D2 — Self-serve Phase D bind API (v1 + D2-B)

**Status:** **SHIPPED (BE + FE)** 2026-07-22 — joint local smoke green (Talk + Join World); bind verified in DB; map visibility deferred until sim runs

**Product decisions (locked)**
1. Access modes: `closed` | `private` (allowlist required) | `open` (any prediction-ready user). Default `closed`.
2. Allowlist: email and/or `user_id` (normalized). Allowlist always wins in `private`.
3. Job/home: API shortlists (FE picker shipped D2-FE).
4. Auto-join: `POST …/join` links owned Double onto roster (prediction_ready only).
5. Join only when sim is `stopped`/`paused`, not generating, not live.
6. Capacity: `self_serve_max_roster` (default 15). One active non-`owned-*` village bind per persona.
7. Name collision: suffix ` (2)`, ` (3)`, … on global persona name when needed.

**Build**
1. Migrations `20260722140000` + `20260722180000` (joinable, access, max_roster, allowlist table).
2. Operator (`ENABLE_ONBOARDING_HOST`):
   - `POST /api/onboarding/{sim}/self-serve-access` `{access, max_roster?}`
   - `GET|PUT /api/onboarding/{sim}/self-serve-allowlist`
   - `POST …/self-serve-joinable` legacy alias (`true`→`open`, `false`→`closed`)
3. JWT self-serve:
   - `GET /api/me/double/bind/sims` (private worlds filtered to allowlisted callers)
   - `GET /api/me/double/bind/{sim}/options`
   - `POST /api/me/double/bind/{sim}/join`
   - `POST /api/me/double/bind/{sim}/finalize`
4. Engine: single-persona board filter + `target_personas` finalize; self-serve options use non-LLM fast path.

**Acceptance**
- [x] `closed` → `not_joinable`; `private` empty allowlist → `allowlist_required`; not on list → `not_allowed`
- [x] Running/live/generating → `sim_not_joinable_now`
- [x] Full roster → `roster_full`; second village → `already_bound`
- [x] Join links roster + seeds scratch ISS (no identity_revision bump); idempotent re-join
- [x] Options/finalize require allowlist in private even if pre-linked
- [x] Finalize writes only owned Double; taken homes blocked
- [x] FE picker (D2-FE) — `/onboarding/join-world`; joint smoke on `20260711-1` for `ipistsov's Double` (barista @ Hobbs Cafe, House 2)

**Operator prep (private demo):** `ENABLE_ONBOARDING_HOST=true` → set access `private` → PUT allowlist emails → user join → options → finalize.

**Local smoke note (2026-07-22):** Map/avatar visibility after bind is deferred until the village sim is run (stopped sim has binding data but no live map presence). Options hang during smoke was multi-LLM board build — BE fixed to fast non-LLM shortlist.

### Week D1-FE — Talk to my Double UI

**Status:** **SHIPPED** 2026-07-22 on FE `local`

**Build**
1. `/onboarding/talk` — `GET /api/me/double`, `POST /api/me/double/chat`
2. Soft gate when not `prediction_ready`
3. **End session** → `POST /api/me/double/session/end` (proposals only; link to `/onboarding/post-chat-updates`)
4. Interview ready CTAs → Talk + Join a world

**Joint smoke (2026-07-22, account `ipistsov@gmail.com`):** Talk multi-turn + End session pass; no silent ISS apply copy confirmed.

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
- Phase D host stays operator-grade for full-roster bind; self-serve bind is D2-BE (access/allowlist/join/options/finalize) + D2-FE picker (`/onboarding/join-world`).
**Flag**
- `CHAT_REQUIRE_AUTH=true` (or equivalent) — default off in prod until FE ships; on in worktree/dev.

**Rollback**
- Flag off → previous open chat behavior for Survival demos.
---

## Decision log (locked 2026-07-14)

1. Port into Doubland · 2. One Auth · 3. Doubland profile SOT · 4. Big-5 + interview for full Double · 5. Soft gate for demos, hard for “my Double” claims · 6. Solo loops inside Doubland later · 7. Modular schemas now, extract onboarding later.

## Decision log (locked 2026-07-22 — D2 bind + D2-B)

1. **Access:** `closed` | `private` (allowlist required) | `open`; default `closed`.  
2. **Allowlist:** email and/or `user_id`; always wins in private (pre-link alone is not enough).  
3. **Job/home:** API shortlists; FE picker **shipped** (D2-FE `/onboarding/join-world`).  
4. **Auto-join:** `POST …/join` links prediction-ready owned Double; join only when stopped/paused and not generating/live.  
5. **Capacity** default 15; **one** active non-`owned-*` village bind; name suffix on collision; no unjoin in this ship.

## Decision log (locked 2026-07-22 — joint FE smoke)

1. **FE branch for self-serve UI:** `local` on `double-front` (not `ivan/self-serve-double`).  
2. **D1-FE + session-end + D2-FE** closed via local joint smoke with BE.  
3. **Map presence** after bind is out of scope for stopped historical sims; DB roster + scratch job/home is the acceptance gate.  
4. **D7** remain blocked on Ivan sign-off (no Railway/Vercel promote yet).

