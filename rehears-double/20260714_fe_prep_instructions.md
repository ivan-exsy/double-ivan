# FE prep — self-serve Double quiz shell (stay off `vercel`)

**For:** double-front / FE team  
**Scope doc:** `double-ivan/rehears-double/20260714_fe_request.md`  
**Epic:** `double-ivan/rehears-double/EPIC_self-serve-double.md`  
**Date:** 2026-07-14

---

## Deployment rule (non-negotiable)

| Branch | Role |
|--------|------|
| **`vercel`** | **Production deployment track.** Do **not** merge, push, or open PRs *into* `vercel` for this epic until Ivan signs off that integration is complete. |
| **Integration branch** | Where all epic FE work lands until then. |

Treat `vercel` as frozen for self-serve Double / quiz / auth-for-chat work until the full BE+FE path is ready.

---

## Prepare (do this first)

1. **Create an integration baseline** (not `vercel`):
   ```bash
   git fetch origin
   git checkout vercel
   git pull origin vercel
   git checkout -b ivan/self-serve-double
   git merge ivan/chat-auth-w1
   ```
   - Resolve conflicts if any.
   - **Optional but recommended:** `git push -u origin ivan/self-serve-double` so previews/PRs can target this branch (still **not** `vercel`).

2. **Confirm Week 1 auth is on the baseline** (from `ivan/chat-auth-w1`):
   - `lib/auth.ts`, `app/auth/*`, Chat Bearer attach in `lib/api.ts`
   - Local: magic link → session → Talk tab can send `Authorization: Bearer` when signed in

3. **Read the full build inquiry** before coding:
   - `20260714_fe_request.md` (instrument, API shape, Rehears borrow list, out-of-scope)

4. **Env (local / preview only):**
   - `NEXT_PUBLIC_API_GATEWAY_URL` → local gateway or non-prod API (not a surprise VPS cutover)
   - `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` → Doubland project (same as BE dev), **not** Rehears Supabase

5. **Do not:**
   - Call Rehears Supabase for quiz questions
   - Port teen norms / BFI test picker / Rehears purple branding as final UI
   - Merge anything from this epic into **`vercel`** until epic sign-off

---

## Then implement

- Implement **`20260714_fe_request.md`** on **`ivan/self-serve-double`** (or short-lived branches that **merge into** `ivan/self-serve-double` only).
- Mock API first is OK; wire gateway when BE ships quiz endpoints.
- PR target for review: **`ivan/self-serve-double`**, never **`vercel`**.

---

## When to touch `vercel`

Only after Ivan confirms Week 2+ integration ACs (sign-in → quiz → profile → chat path) and explicitly asks to promote. One promotion PR: integration branch → `vercel`.

---

## Reply (FE → Ivan)

```text
Integration branch: ivan/self-serve-double (or name)
chat-auth-w1 merged: yes/no
Owner: <name>
Starting: mock-first / wait-for-API
Will not merge to vercel until sign-off: confirmed
```
