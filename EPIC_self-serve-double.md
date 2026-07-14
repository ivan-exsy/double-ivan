# Epic: Self-serve owned Double (Rehears → Doubland)

**Status:** Active — decisions locked 2026-07-14  
**Branch / worktree:** `ivan/dev` → `D:\Coding\generative_agents-ivan-dev`  
**Architecture:** Port into Doubland (not permanent two-app). One Auth. Doubland-owned profile SOT.  
**Success metric:** A non-operator user can sign in → assess → seed an owned Double → chat with it (and optionally bind to a sim) without an engineer hand-authoring the soul.

**Related:** `TODO_rehears-doubland.md` · `sot_lifecycle.md` §6 · `sot_chats.md` §6.9 v4 · `5.2.rehears-double.md` (historical dual-app — superseded)

---

## Shipped baseline (do not rebuild)

| Area | Status | Reuse / gap |
|------|--------|-------------|
| **Lifecycle Phase D** — job/home binding | **Shipped** CLI+REST (`ENABLE_ONBOARDING_HOST`); finalize writes scratch + report | Self-serve FE still missing; sim-only goal slot deferred |
| **Lifecycle Phases A–C** | **Deferred** in SOT (post-MVP) | This epic *implements* A–C (account, profile, completeness) |
| **Profile pipeline** | Operator/soul docs + snippets; `get_persona_profile_context` | Adapter must **write** these paths, not invent parallel storage |
| **Chat with Double v1** | **Shipped** — threads, memory retrieve, write-back (P3-1), rate limits | Open endpoint; service-role; **no `user_id` / RLS** |
| **Chat v4 (roadmap)** | **Not shipped** | `user_id` on threads + ownership + creator prompt |
| **Auth** | **Not productized** | Client-supplied `user_id` on legacy user routes; `dbl_agent.user_id` exists; no JWT gate on gateway |
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
- [ ] Unauthenticated `POST …/chat` → **401** when gate enabled.
- [ ] Authenticated user can open a thread; `user_chat_threads.user_id` = their `auth.uid()`.
- [ ] User A cannot continue User B’s thread (403/400 ownership).
- [ ] Existing open chat still works when gate **disabled** (rollback flag) for operator demos.
- [ ] One smoke path documented (curl or FE): login → chat one turn → row in DB with correct `user_id`.

**Repos:** `api_gateway` auth dependency · migration on chat tables · `chat_with_double_service` ownership check · FE session header (double-front or temporary harness).

**Week 1 progress (2026-07-14, branch `ivan/dev`):**
- [x] `api_gateway/app/core/auth.py` — Supabase JWT decode + `get_chat_user`
- [x] `CHAT_REQUIRE_AUTH` + `SUPABASE_JWT_SECRET` in config
- [x] Migration `20260714120000_chat_thread_user_id.sql` — `user_id` + RPC `p_user_id`
- [x] Chat service ownership + route 401/403 wiring
- [x] Unit tests `api_gateway/tests/test_chat_auth.py`
- [x] Unit tests green (`25` auth+memory)
- [ ] Apply migration on Supabase project
- [ ] FE: pass `Authorization: Bearer` on chat (double-front)
- [ ] Live smoke with real JWT (needs `SUPABASE_JWT_SECRET` in env)

**Smoke (after migration + JWT secret in `.env.local`):**

```bash
# Flag off (demo rollback) — open chat still works
curl -s -X POST "http://localhost:8001/api/simulations/{sim}/personas/{persona}/chat" \
  -H "Content-Type: application/json" -d '{"message":"Hello"}'

# Flag on — require token; user_id stamped on thread
# CHAT_REQUIRE_AUTH=true
curl -s -X POST "http://localhost:8001/api/simulations/{sim}/personas/{persona}/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{"message":"Hello"}'
# SQL: SELECT id, user_id FROM double.user_chat_threads ORDER BY created_at DESC LIMIT 5;
# Other user's token on same thread_id → 403; no token with flag on → 401
```

---

### Week 2 — Adult Big-5 v1 + profile store + adapter seed

**Build**
1. Adult item bank v1 (content rewrite; no teen CSVs) + scoring engine ported from Rehears patterns.
2. Persist OCEAN + summary under Doubland-owned tables (not Rehears as SOT).
3. Profile adapter v1: OCEAN + summary → `persona_profile_documents` / snippets + ISS seed fields (`innate`/`learned` baseline).
4. Link created persona to owning `user_id`.

**Acceptance**
- [ ] Signed-in user completes quiz → profile row owned by them.
- [ ] Adapter produces active document + snippets readable by `get_persona_profile_context`.
- [ ] Chat with that persona uses seeded traits (spot-check: trait-colored reply, not blank template).
- [ ] Soft demo mode: operator can still run pre-profiled rosters without quiz.

**Content owner:** named person for adult items (blocks ship if missing).

---

### Week 3 — Interview v1 + completeness + Phase D self-serve path

**Build**
1. Short interview (values / lifestyle / goals / voice) → fills `learned` / `currently` / goals seeds.
2. Soft completeness gate (“prediction-ready”) vs hard block for “my Double” claims.
3. Self-serve entry into **existing** Phase D host (REST already shipped): user-owned Double on a roster → job/home finalize **or** auto-bind solo path.
4. Chat v4 **slice B**: system prompt “talking to your creator” when `user_id` owns the persona.

**Acceptance**
- [ ] Incomplete profile → soft gate message; complete → eligible for bind.
- [ ] User can bind **their** Double via Phase D API (or auto-bind); operator CLI still works.
- [ ] Owner chat prompt differs from anonymous/registered non-owner (if non-owner allowed).
- [ ] End-to-end: sign in → quiz → interview → seed → chat → (optional) bind.

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
- Phase D host stays operator-grade until Week 3; only document the REST contract for later FE.

**Flag**
- `CHAT_REQUIRE_AUTH=true` (or equivalent) — default off in prod until FE ships; on in worktree/dev.

**Rollback**
- Flag off → previous open chat behavior for Survival demos.
---

## Decision log (locked 2026-07-14)

1. Port into Doubland · 2. One Auth · 3. Doubland profile SOT · 4. Big-5 + interview for full Double · 5. Soft gate for demos, hard for “my Double” claims · 6. Solo loops inside Doubland later · 7. Modular schemas now, extract onboarding later.
