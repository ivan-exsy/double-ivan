# TODO-BE — Waitlist Onboarding (Backend)

Backend work required to make the waitlist onboarding (now mounted on the landing page via
`components/cta-section.tsx`) work end-to-end. The frontend is wired; **do not merge the FE wiring
to `main` until the items below are done** — `main` auto-promotes to production at `www.doubland.ai`,
so an unconfigured form would error for live visitors.

## Current state (what the FE expects)

- The waitlist form `POST`s `{ "email": string }` (JSON) to **`POST /api/waitlist`**.
- The route (`app/api/waitlist/route.ts`) **upserts** into Supabase:
  - schema: **`double`**, table: **`waitlist`**, conflict target: **`email`** (unique).
  - uses the **anon key** (`createClient(SUPABASE_URL, SUPABASE_ANON_KEY)`), so **RLS applies**.
  - treats unique-violation (`23505`) as success (idempotent re-signup).
- Success → `200 { message }`; invalid email → `400`; failure → `500`.

## 1. Environment variables (Vercel)

Set on the Vercel project (Production + Preview), then redeploy:

- `SUPABASE_URL` — project URL.
- `SUPABASE_ANON_KEY` — anon/public key (intentionally anon, not service-role, so RLS is enforced).

## 2. Supabase setup

Create the schema/table and an insert-only RLS policy for the anon role:

```sql
create schema if not exists double;

create table if not exists double.waitlist (
  id          uuid primary key default gen_random_uuid(),
  email       text not null unique
              check (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  created_at  timestamptz not null default now()
);

alter table double.waitlist enable row level security;

-- Anon can insert (upsert) but not read the list.
create policy "anon can join waitlist"
  on double.waitlist for insert
  to anon
  with check (true);
```

Notes:
- Expose the `double` schema to the API in **Supabase → Settings → API → Exposed schemas** (add `double`), or the upsert will fail with a schema-not-found error.
- The CHECK regex mirrors the validation in the route — keep them in sync if either changes.
- No `select` policy is granted to `anon` on purpose (emails stay private). The `.upsert()` call
  doesn't read rows back, so this is fine.

## 3. Verify

- `pnpm dev`, submit an email in the waitlist section → expect `200` and a row in `double.waitlist`.
- Re-submit the same email → still `200` (idempotent), no duplicate row.
- Submit an invalid email → `400`.

## 4. Cleanup / follow-ups (FE-adjacent, confirm before doing)

- **`components/email-modal.tsx`** is a second, **non-functional** waitlist path: it only
  `console.log`s the email (`// TODO: Integrate`) and is not mounted anywhere. Decide whether to
  delete it or wire it to `/api/waitlist`; today it's a trap for future edits.
- Consider adding a server-side success/error toast or duplicate-vs-new distinction if product wants it.
- Add basic rate-limiting / spam protection on `/api/waitlist` if abuse becomes a concern.

---

# BE-TODO: Trailer Gallery (Backend)

> **New ask — not part of the original waitlist scope.** The landing-page redesign
> (`feat/landing-redesign`) adds a **trailer gallery** (Part B of the build spec). It needs a
> Supabase-backed "manifest" that the site reads at request time. **BE owns Supabase**, so the items
> below (migration apply, RLS, schema exposure, service-role key) are for the BE team. The FE code,
> the migration file, and the sync script are already written on the branch — they just need the
> backend provisioned. Until then the gallery renders safe empty/ghost states (no breakage).

## Architecture (how it differs from waitlist)

- **YouTube** is the source of truth + CDN + player. A **manual** local script
  (`scripts/sync-episodes.ts`, `pnpm sync:episodes`) reads a YouTube playlist and **upserts** a
  manifest into Supabase. **No cron, no API route, no scheduler.**
- The Next.js UI (`SeasonSection` + `HookSection`) reads that manifest **with the anon key at
  request time**, so running the sync makes new episodes appear in production **without a redeploy**.
- Unlike `double.waitlist` (insert-only, **no** anon read), the gallery tables need **anon `SELECT`**
  — the public site must read them.

## 1. Apply the migration (BE owns Supabase)

Apply **`supabase/migrations/0001_seasons_episodes.sql`** (on the `feat/landing-redesign` branch) to
the active `double` project. It is idempotent (`create table if not exists`, `on conflict do nothing`)
and does all of the following:

- Creates **`double.seasons`** (one row per showcased season) and **`double.episodes`** (one row per
  trailer), with the Part B §B1 columns + FK `episodes.season_id → seasons.id` and indexes.
- Enables RLS on both and grants **anon `SELECT`** policies (`"anon can read seasons"`,
  `"anon can read episodes"`). No anon write — the sync script writes via the **service-role key**
  (which bypasses RLS).
- Seeds the showcased season row: `the-ville-s1` (cohort `The Ville`, `Season 1`, `sim_id =
  20260520-1`, `total_days = 15`). `youtube_playlist_id` and `state` are intentionally left NULL.

Same `double` schema as `waitlist`, so the already-exposed schema (Settings → API → Exposed schemas)
covers these too — please confirm `double.seasons`/`double.episodes` are reachable via PostgREST with
the anon key.

## 2. Seed the playlist id

Set `double.seasons.youtube_playlist_id` for `the-ville-s1` to the real YouTube **playlist id** for
the season (the operator keeps that playlist ordered: Opening first, then Day 1, Day 2, …). Until
this is set, `pnpm sync:episodes` reports the season as "skipped" rather than failing.

## 3. Secrets (script-only — local, never shipped to the client/Vercel client bundle)

The sync script runs **locally/by hand**, not on Vercel. Please provide / confirm:

- **`SUPABASE_SERVICE_ROLE_KEY`** — for the `double` project (BE-owned). Used only by
  `scripts/sync-episodes.ts` to upsert the manifest. **Never** add to the client bundle or Vercel
  client env.
- **`YOUTUBE_API_KEY`** — YouTube Data API v3 key (from whoever owns the Google Cloud project). A
  handful of quota units per run.
- **UI reads** reuse the **existing** `SUPABASE_URL` + `SUPABASE_ANON_KEY` already set for the
  waitlist — **no new client env** is needed for the gallery.

## 4. Verify

- With the migration applied and `youtube_playlist_id` seeded, run `pnpm sync:episodes` locally →
  expect rows upserted into `double.episodes` and a printed summary (added/updated/removed + featured
  episode).
- Load the site → the §3 gallery and the §1 hero featured slot show real episodes; removing a video
  from the playlist drops it on the next sync.
- Anon read check: a PostgREST `select` on `double.seasons`/`double.episodes` with the **anon** key
  succeeds (read-only); an anon `insert` is rejected by RLS.
