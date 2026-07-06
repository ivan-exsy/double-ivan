# Link tracking & lead attribution — build spec

**Date:** 2026-06-15  
**Owner:** Ivan  
**Status (updated 2026-06-16):** **BE confirmed correct** — gateway ratchet (never-downgrade), `source` default `landing-hero`, tag validation, and `interest_type` CHECK all verified against the live schema (2026-06-16). **Viewer team (`double-front`) done + committed** (`ivan/link-tracking-slice6`) — Slice 0 (param rename), Slice 4 (share / play-HUD `?source=`), Slice 6 (embedded Share → landing re-embed, incl. the no-Double map-level fix). **Landing (`double-landing-page`) done** — Slice 2 form + Slice 6 receiver; Slice 6 cross-origin local e2e green (all 4 cases) 2026-06-16. **✅ Funnel verified end-to-end (2026-06-16):** a live submit through the production *browser → landing `/api/waitlist` proxy → gateway* path stored `source`, `interest_type=b2b_group`, and `group_name` exactly as sent; the never-downgrade ratchet and `source` last-write-wins were also confirmed through the live path. The 2026-06-15 smoke failure was a stale proxy deploy — since fixed. **No open gates remain; capture is production-ready.** The only remaining dependency is operator discipline (paste tagged links each drop — §"During the season"). Supersedes the premature “complete” claims in `20260612_VC_prep.md` §8 and `20260611_mvp-release-gate.md` row 9.  
**Strategy anchor:** [`20260612_VC_prep.md`](../double-ivan/20260612_VC_prep.md) (Telegram Survival demo as fundraising wedge)

---

## Implementation reference (final state, 2026-06-16)

Everything below is shipped and verified. This block is the quick reference; the rest of the doc is the build history and rationale.

**Capture contract — `POST /api/waitlist`** (landing proxy → gateway → `double.waitlist`):

| Field | Required | Validation / behaviour |
|---|---|---|
| `email` | yes | `^[A-Za-z0-9._%+-]+@…$`; lowercased; conflict key for the upsert |
| `message` | no | trimmed, max 2000 |
| `source` | no | lowercased; must match `^[a-z0-9.-]{1,64}$` or it is **silently dropped** (signup still succeeds); **last-write-wins**; DB default `landing-hero` on insert |
| `interest_type` | no | `generic` \| `b2b_group` (CHECK); written **only** when `b2b_group`; DB default `generic` |
| `group_name` | no | trimmed, max 200; written only with `b2b_group` |

**Semantics that matter for reading the numbers:**
- **Ratchet (never-downgrade):** a later `generic` re-submit can't overwrite an existing `b2b_group` row — enforced in the gateway, not the landing. *(E2E verified 2026-06-16.)*
- **`source` last-write-wins:** a repeat signup reflects the latest valid tag; an organic re-submit overwrites a prior tag with `landing-hero`.
- **`source IS NULL` = pre-tracking** (signed up before the migration), **not** a season-1 miss — bucket separately.
- **Signup time stays first-seen** (`"timestamp"` column — reserved word, quote it; *not* `created_at`).

**Where it lives:** migration `supabase/migrations/20260615120000_waitlist_source_attribution.sql`; gateway `api_gateway/app/api/routes/waitlist.py`; landing `double-landing-page` (`components/footer.tsx`, `app/api/waitlist/route.ts`, `lib/landing-share.ts`); viewer/video tagging in `double-front` + `video/generate_description.py`.

**Tag vocabulary, link shape, and the readout query** are in §Operator runbook below.

---

## Why

The Telegram Survival season is not a traction play — 15 doubles in a 300-person group will never produce volume metrics a smart VC believes. The raise rests on **magnetism + demand**: a hard-to-impress room watches, forwards, and asks *"can you build one for my group?"*

[`20260612_VC_prep.md`](../double-ivan/20260612_VC_prep.md) frames four **money slides**. Three are already capturable without new product:

| Slide | How we get it today |
|---|---|
| **1. Magnetism / completion** | YouTube Studio (% watched to end) |
| **2. Spread** | Manual tally of Telegram forwards / reach |
| **4. Inbound demand** | Manual log + screenshot of every unsolicited B2B ask, tied to the episode that triggered it |

**Slide 3 — conversion funnel** is the gap: *views → link clicks → waitlist signups, plotted against episode drops.* VC prep §3 calls this out explicitly: *"This is the one we can't measure today."* Root cause: outbound links carry no attribution tag, and the waitlist stores **email (+ optional free text) only** — no structured `source` or B2B interest flag.

The VC prep insight still holds: **we don't need an analytics platform.** We need:

1. A tiny `source` tag on every outbound link we control.
2. The landing to persist that tag through signup.
3. A one-screen readout (query or sheet) to plot signups by source.

Without this, the season generates compelling content but **no provable conversion story** for the deck — only guesswork and whatever people volunteer in "Tell us more!"

**Fundraising wedge = Community/B2B pull** (VC prep §2). The hero metric is inbound *"build one for my group/company"* requests. Structured capture (`interest_type = b2b_group`) makes that signal countable even when inbound is quiet; attribution makes it **attributable** to a specific episode or channel.

---

## Goal

Every controlled outbound link carries a `source` tag. Every waitlist signup records **which link drove it** and **whether the person is generic interest or B2B/group interest.** Operator can pull a daily funnel readout during the season.

**Non-goals:** full analytics stack, click tracking pixels, per-user session replay, or blocking launch on Tier 2/3 VC prep items (serialization, persona fidelity, interactive voting).

---

## Current state (2026-06-15)

| Surface | Built | Gap |
|---|---|---|
| Play-mode deep links (`/sim/{code}/play?t=&double=…`) | ✅ FE route + YouTube description generator | No `source` param |
| Sim viewer share / self-building URL (`/simulations/{code}?t=&double=&zoom=&focus=`) | ✅ `lib/replayUrl.ts`, Share button — `source=sim-share` (Slice 4) + embedded→landing re-embed (Slice 6) | ✅ Done 2026-06-16 (committed `ivan/link-tracking-slice6`; e2e green) |
| YouTube description generator | ✅ `video/generate_description.py` + `generate_trailer.py` — scene links tagged `source=yt-d{N}-s{M}`; watch-live footer CTA → `doubland.ai/?source=yt-d{N}` | ✅ Done 2026-06-15 (TODO-15 closed) |
| Trailer end card | ✅ On-screen `doubland.ai` | Not source-tagged (on-screen text, not a clickable link) |
| Landing waitlist | ✅ Email + `message` + reads `?source=` + B2B micro-actions + Slice 6 receiver | ✅ Verified end-to-end 2026-06-16 — live proxy→gateway submit stored `source`/`interest_type`/`group_name` correctly; ratchet + last-write-wins confirmed |
| API / DB | ✅ `POST /api/waitlist` → `double.waitlist` — accepts + stores `source`/`interest_type`/`group_name` | ✅ Done 2026-06-15 (migration `20260615120000`; signup-time column is `timestamp`, not `created_at`) |
| Funnel readout | ✅ SQL query + per-day variant (§Operator runbook) | Query ready & runs against live schema; no UI by design (MVP) |

**Doc drift:** VC prep §8 (2026-06-04) and the MVP release gate marked the measurement layer “complete.” Landing v8 §6 was **simplified the same week** — `source`, `interest_type`, and B2B micro-buttons were explicitly removed in favor of one form + free text (`landing/20260603_landing-page_v8.md` §6). **This spec is the authoritative build target.**

---

## Link surfaces & tagging

### Parameter

- **Name:** `source` (query param on landing and play URLs; not UTM_* — keep it one field, human-readable, grep-friendly).
- **Format:** lowercase, `[a-z0-9-]` and dots; max **64** chars; no spaces.
- **Convention** (examples — operator may override for one-off posts):

| Pattern | Example | Use |
|---|---|---|
| `tg-survival-d{N}` | `tg-survival-d3` | Telegram post for day N (main tracked link in post copy) |
| `yt-d{N}` | `yt-d3` | YouTube description footer CTA |
| `yt-d{N}-s{scene}` | `yt-d3-s2` | Per-scene play deep link in YouTube description |
| `yt-d{N}-{persona}` | `yt-d3-ivan` | Per-subject vertical clip description (Tier 2) |
| `sim-share` | `sim-share` | Default when user copies URL from sim viewer (Share button or address bar) |
| `landing-hero` | `landing-hero` | Organic landing traffic / untagged CTAs |
| `footer-b2b` | `footer-b2b` | User scrolled to footer and self-identified B2B intent (see §Capture) |

Episode number `N` = Survival sim day (1-based), aligned with daily video drop.

### Where tags are appended

**1. YouTube descriptions** (`video/generate_description.py`)

- Each scene play URL: existing params + `&source=yt-d{day}-s{scene_index}` (scene index 1-based in emitted order). **Shipped.**
- Footer CTA line: `https://doubland.ai/?source=yt-d{day}` — apex, root `/?source=` (the `/#stay-connected?source=…` anchor form was rejected: a query after `#` lands in the fragment, invisible to the landing's reader). **Shipped.**
- CTA copy is the watch-live line — *"Watch live at doubland.ai. Follow any Double. Replay every moment."* (TODO-15 closed); bare `/waitlist` dropped.

**2. Telegram post copy** (operator manual)

- Native vertical clip in-channel for reach.
- **Plus** one tracked link per post, e.g. `https://doubland.ai/?source=tg-survival-d3` or play deep link with same tag.
- Distribution decision (VC prep §6.B.10, §7): native vertical **+** tracked link — get both.

**3. Sim viewer URLs** (`double-front`)

- **Share button / copy-link:** append `source=sim-share` when serializing URL (do not overwrite if URL already has `source` — first wins).
- **Play-mode HUD** “Curious what this is?” pill: `https://doubland.ai/?source=play-hud` (preserve existing `source` from inbound deep link if present — pass through to landing).

**4. Landing CTAs** (no tag change needed)

- Hero / how-it-works buttons that scroll to footer: submissions use `source=landing-hero` when no inbound `?source=` is set.

### Play URLs vs landing URLs

- **Play deep links** (`/sim/{code}/play?…` or `/simulations/{code}?…`): carry `source` for analytics continuity if user later navigates to landing; play route should **preserve** `source` when linking to `doubland.ai`.
- **Conversion endpoint** is always the **landing waitlist** — play mode does not host signup.

---

## Waitlist capture

### UI (landing — `double-landing-page`)

Extend current footer; **do not** reintroduce modals or a second endpoint.

| Element | Behavior |
|---|---|
| Inbound `?source=` | Read on page load; store in React context / sessionStorage for the session; pass on submit. |
| Email + Tell us more | Unchanged UX. |
| B2B intent | **Option A (recommended):** restore two micro-actions under the heading — `Stay updated` → `interest_type=generic`; `Bring this to my group` → `interest_type=b2b_group`, reveal optional **Group / company** field. **Option B (minimal):** keep single form; infer nothing; only `interest_type` from micro-action if added later. **Default for this spec: Option A** — matches VC prep §4 Tier 1 and original landing v8 intent. |
| Submit | `POST /api/waitlist` with extended payload (below). |

### API payload

Extend existing `POST /api/waitlist` (Vercel proxy → gateway → Supabase). **No new route.**

```json
{
  "email": "user@example.com",
  "message": "optional free text",
  "source": "tg-survival-d3",
  "interest_type": "generic",
  "group_name": "optional — when b2b_group"
}
```

| Field | Required | Notes |
|---|---|---|
| `email` | yes | Unchanged validation |
| `message` | no | Unchanged; max 2000 |
| `source` | no | Default `landing-hero` (DB column default, applied on insert only) |
| `interest_type` | no | `generic` \| `b2b_group`; default `generic` |
| `group_name` | no | Only when `b2b_group`; max 200 chars |

### Database

**Shipped:** `supabase/migrations/20260615120000_waitlist_source_attribution.sql` (applied to remote 2026-06-15).

```sql
-- `source` default is set in a SECOND statement so only NEW inserts default to
-- landing-hero; existing rows stay NULL (= pre-tracking). A one-shot
-- ADD COLUMN ... DEFAULT would backfill every existing row.
ALTER TABLE double.waitlist ADD COLUMN IF NOT EXISTS source text;
ALTER TABLE double.waitlist ALTER COLUMN source SET DEFAULT 'landing-hero';

ALTER TABLE double.waitlist
  ADD COLUMN IF NOT EXISTS interest_type text NOT NULL DEFAULT 'generic'
    CHECK (interest_type IN ('generic', 'b2b_group'));

ALTER TABLE double.waitlist ADD COLUMN IF NOT EXISTS group_name text;

CREATE INDEX IF NOT EXISTS idx_waitlist_source ON double.waitlist (source);
-- signup-time column is "timestamp" (reserved word; quote it), not created_at
CREATE INDEX IF NOT EXISTS idx_waitlist_interest_type_timestamp
  ON double.waitlist (interest_type, "timestamp");
```

- **Upsert rule (gateway):** on a repeat email, fields the submit shouldn't overwrite are omitted from the payload (PostgREST leaves omitted columns untouched on conflict). `source` is refreshed whenever a valid tag is sent (**last-write-wins**); `interest_type`/`group_name` are written only on a `b2b_group` submit, so a later generic re-submit **never downgrades** a richer B2B row (ratchet up only).

---

## Funnel readout

**MVP:** one SQL query or Supabase dashboard export — no product UI required for season 1.

**Daily operator sheet** (manual columns + query output):

| Day | YouTube completion % | TG forwards (manual) | Clicks* | Signups by `source` | `b2b_group` count | Inbound quotes (manual) |
|---|---|---|---|---|---|---|
| D1 | from YT Studio | tally | — | `tg-survival-d1`, `yt-d1`, … | count | screenshot + name |

\* *True click counts need a redirect/logging hop — **out of scope** for this spec. Proxy: signups per `source` + YouTube traffic; VC prep accepts this at 15/300 scale.*

**Example readout query:**

```sql
-- NB: the signup-time column on the live table is named "timestamp" (not
-- created_at — see runbook "Reading the numbers").
SELECT source, interest_type, COUNT(*) AS signups
FROM double.waitlist
WHERE "timestamp" >= :season_start
GROUP BY 1, 2
ORDER BY signups DESC;
```

---

## Implementation slices

| # | Slice | Owner | Repo / path | Effort |
|---|---|---|---|---|
| 0 | Rename viewer QA param `?source=`→`?viewer=` (collision fix; prerequisite for Slice 4) | **Viewer team** | `double-front` — `lib/viewerSource.ts`, `__tests__/viewerSource.test.ts`, `scripts/cdn-{smoke,scrub-audit,completed-replay}.mjs` | ~0.5 h |
| 1 | DB migration + gateway accept/store new fields | BE | `generative_agents` — migration, `api_gateway/.../waitlist.py`, tests | ~0.5 d |
| 2 | Landing: read `?source=`, micro-buttons, extended submit | **Landing team** | `double-landing-page` — `footer.tsx`, `app/api/waitlist/route.ts` | ~1 d |
| 3 | YouTube description: `source` on scene links + tracked footer CTA (TODO-15) | Ivan / video | `video/generate_description.py`, tests | ~0.5 d |
| 4 | Sim viewer: append/pass-through `source` on share + play HUD link | **Viewer team** | `double-front` — `useShareReplayLink.ts` / `replayUrl.ts`, play route + `PlayModeHud.tsx` | ~0.5 d |
| 5 | Operator runbook: tag cheat sheet + daily sheet template | Ops | This doc + `20260611_mvp-release-gate.md` §6 | ~1 h |

**Sequence:** 0 + 1 → 2 (signup path live) → 3 + 4 in parallel (outbound links; Slice 4 depends on the Slice 0 rename) → 5 before first Telegram drop.

**Deploy gate:** migration applied on live Supabase **before** landing sends new fields (same pattern as `20260529_landing-page_TODO-BE.md`).

---

## Acceptance criteria

- [x] Posting `https://doubland.ai/?source=tg-survival-d1-test`, submitting waitlist → row has `source = tg-survival-d1-test`. *(✅ Verified end-to-end 2026-06-16: a live submit through the production landing proxy stored `source=tg-survival-d1-test`. The 2026-06-15 smoke failure was a stale proxy deploy, now fixed.)*
- [x] B2B micro-button path → `interest_type = b2b_group` + optional `group_name` persisted. *(✅ Verified end-to-end 2026-06-16: a live `b2b_group` submit stored `interest_type=b2b_group` + `group_name`; a later `generic` re-submit did **not** downgrade the row — the ratchet holds through the live path.)*
- [x] Regenerated YouTube description for day 3 → every scene URL includes `source=yt-d3-s{N}`; footer CTA uses `source=yt-d3`. *(Done 2026-06-15.)*
- [x] Share from sim viewer → copied URL includes `source=sim-share` (unless already tagged). *(Slice 4 — **standalone** viewer copies a canonical `…?source=sim-share` URL; done + tested. **Embedded** case (Slice 6) deliberately copies nothing in-iframe — the parent landing copies a `…?source=sim-share` landing URL; cross-origin local e2e green 2026-06-16. NB: e2e confirmed the tag rides into `location.search`; it did not exercise a DB write — that inherits the AC#1 proxy gate.)*
- [x] Readout query returns signups grouped by `source` and `interest_type`. *(Runs against live schema.)*
- [x] No regression: email-only submits still work (`source` defaults to `landing-hero`). *(Verified via live smoke 2026-06-15.)*

---

## During the season (operator discipline)

From VC prep §6.C — unchanged, but now instrumented:

1. Post daily; record YouTube completion.
2. Include **one tracked link** in every Telegram post (`tg-survival-d{N}`).
3. Manually tally reactions/forwards; **log + screenshot** every *"can I get one for my X"* with episode number.
4. Pull signup readout after each drop; note B2B rows by name.

---

## Operator runbook

Quick reference for running the tracked season. The funnel-sheet template and base readout query are in **§Funnel readout** above; this section is the tag vocabulary, the link shape, and the caveats needed to read the numbers correctly.

### Tag cheat-sheet

| Tag | Where it comes from |
|---|---|
| `tg-survival-d{N}` | Telegram post for day N (operator pastes the tracked link) |
| `yt-d{N}` | YouTube description footer CTA |
| `yt-d{N}-s{M}` | Per-scene play deep link in the YouTube description (M = emitted-scene order, 1-based) |
| `yt-d{N}-{persona}` | Per-subject vertical-clip description (day-in-life trailer; persona = first name, lowercased) |
| `yt-opener` | Pre-season opener trailer description |
| `yt` | Fallback when a trailer has no day (standalone `generate_description` default) |
| `sim-share` | User copied a URL from the sim viewer's Share button |
| `play-hud` | Play-mode "Curious what this is?" pill |
| `landing-hero` | Server default for an email-only signup with no inbound tag |
| `footer-b2b` | (Optional) landing footer B2B self-identification |
| `NULL` source | Pre-tracking row (signed up before this migration) — **not** "untagged this season" |

Format rule: `^[a-z0-9.-]{1,64}$`. A tag that breaks the rule is silently dropped at the API — the signup still succeeds, it just falls back to the `landing-hero` default (or the earlier value on a re-submit) — so keep tags lowercase, no spaces.

### Link shape

Always `https://doubland.ai/?source={tag}` — apex domain, query string **before** any `#` anchor. A `…/#stay-connected?source=…` form does **not** work: anything after `#` is the fragment, so the landing's `?source=` reader never sees it.

### Reading the numbers (data caveats)

These follow from how the API stores re-submits (same email = upsert):

- **`source` is last-write-wins** — a repeat signup from a different link reflects the **latest** touch.
- **`interest_type` / `group_name` ratchet up only** — a later generic re-submit never downgrades an earlier `b2b_group` row. Fix a mis-tagged B2B row by editing the DB directly.
- **Signup time stays first-seen** — a re-submitter keeps their original date but gets the new `source`, so per-day counts attribute by first signup, not latest link. Don't double-count re-submitters.
- **`source IS NULL` = pre-tracking**, not a season-1 miss — exclude or bucket NULLs separately.
- **No true click counts** — signups-per-`source` is the proxy (VC prep accepts this at 15/300 scale).
- **Column name gotcha** — the signup-time column is literally named `timestamp` (a reserved word; quote it as `"timestamp"` in queries), not `created_at`. Live-schema drift from the migration files.

### Per-day readout (extends §Funnel readout)

```sql
SELECT date_trunc('day', "timestamp")::date AS day,
       source,
       interest_type,
       COUNT(*) AS signups
FROM double.waitlist
WHERE "timestamp" >= :season_start
  AND source IS NOT NULL        -- exclude pre-tracking rows
GROUP BY 1, 2, 3
ORDER BY 1, signups DESC;
```

### Deck cuts (VC stats — copy-paste)

Three ready queries that map straight to the VC-prep "money slides" (`20260612_VC_prep.md` §3). Set `:season_start` to the first drop's date.

**A. Per-episode funnel (Slide 3)** — signups + B2B count per day and source:
```sql
SELECT date_trunc('day', "timestamp")::date AS day,
       source,
       COUNT(*)                                           AS signups,
       COUNT(*) FILTER (WHERE interest_type = 'b2b_group') AS b2b_signups
FROM double.waitlist
WHERE "timestamp" >= :season_start
  AND source IS NOT NULL            -- exclude pre-tracking rows
GROUP BY 1, 2
ORDER BY 1, signups DESC;
```

**B. Channel split (Slide 3)** — where demand originates, tags rolled up to channels:
```sql
SELECT CASE
         WHEN source LIKE 'tg-%'                  THEN 'telegram'
         WHEN source LIKE 'yt-%' OR source = 'yt' THEN 'youtube'
         WHEN source IN ('sim-share','play-hud')  THEN 'viewer-share'
         WHEN source = 'landing-hero'             THEN 'organic/untagged'
         WHEN source IS NULL                      THEN 'pre-tracking'
         ELSE 'other'
       END                                        AS channel,
       COUNT(*)                                           AS signups,
       COUNT(*) FILTER (WHERE interest_type = 'b2b_group') AS b2b_signups
FROM double.waitlist
WHERE "timestamp" >= :season_start
GROUP BY 1
ORDER BY signups DESC;
```

**C. B2B lead list (Slide 4 — the closer)** — who asked, and which episode triggered it:
```sql
SELECT "timestamp"::date AS day,
       email,
       group_name,
       source            AS triggered_by
FROM double.waitlist
WHERE interest_type = 'b2b_group'
  AND "timestamp" >= :season_start
ORDER BY "timestamp";
```

### Deploy gate

Apply migration `20260615120000_waitlist_source_attribution.sql` on live Supabase **before** the landing starts sending the new fields, and before the first Telegram drop (same pattern as `20260529_landing-page_TODO-BE.md`).

---

## TODO — split by team

Slices 2 and 4 live in **separate repos with separate owners**; neither is covered by the backend/video build in `generative_agents`:

- **Slice 2 → Landing team** (`double-landing-page`) — signup capture UX + waitlist proxy. **This is NOT a `double-front` task** (it was previously lumped under a generic "FE" owner — corrected here).
- **Slice 0 + Slice 4 → Viewer team** (`double-front`, this repo) — the QA-param rename and viewer/play link tagging. **All references below verified against the code on 2026-06-15.**

### ⚠️ Decide first — `source` query-param collision (cross-cutting → Viewer team)

`double-front` **already uses `?source=cdn|gateway`** as an internal QA override for the viewer data source (`lib/viewerSource.ts`, `VIEWER_SOURCE_QUERY_PARAM = 'source'`; the override is read internally from `window.location.search` and surfaces on **both** `/simulations/[code]` and `/sim/[code]/play`). This spec reuses the same key for attribution.

- **No hard break (verified):** `resolveViewerSource` honors the override only when it is exactly `cdn` or `gateway` (`lib/viewerSource.ts:44`); any other value falls through to the env default. A tracked link (`?source=tg-survival-d3`) therefore **cannot** flip the data source. The landing reads its own `?source=` independently — the core funnel works as written even if the rename below is deferred.
- **But:** the Share button writing `source=sim-share` onto a *viewer* URL is a cosmetic no-op there; an operator can't combine the QA override with a tracking tag; and the overloaded key is a future footgun.
- **Resolution — DECIDED 2026-06-15 (Ivan): rename the internal switch to `?viewer=cdn|gateway`.** `source` becomes attribution-only everywhere. **Corrected impact list (verified against the code 2026-06-15):**
  - `lib/viewerSource.ts` — the `VIEWER_SOURCE_QUERY_PARAM` const (`:25`) + the two doc comments naming `?source=` (`:13`, `:34`).
  - `__tests__/viewerSource.test.ts` — the override cases (`source=gateway` / `source=cdn`, lines 48 / 51 / 57).
  - **CDN audit scripts that hardcode `?source=cdn` (originally omitted from this list — must be included):** `scripts/cdn-smoke.mjs:17`, `scripts/cdn-scrub-audit.mjs:6`, `scripts/cdn-completed-replay.mjs:13`. After the rename these silently stop forcing the CDN path (the value is ignored → falls back to the `gateway` env default), so they must move to `?viewer=cdn` in the same change or the CDN edge audits quietly test the wrong path.
  - **No change needed** to the two page call sites the original spec listed (`app/simulations/[sim_code]/page.tsx:164`, `app/sim/[sim_code]/play/page.tsx:168`): both call `isCdnViewerSource()` with **no arguments**, so the param string lives only inside `viewerSource.ts`.
  - After this, any `?source=` on a viewer/play URL is attribution-only and passed through untouched.

### Slice 2 — LANDING TEAM (`double-landing-page`) — NOT this project

> **Owner: Landing team.** These files are in a different repo and were **not** verified from `double-front`. Treat the file names, CSS-hook names, and constants below as the spec author's notes, to be confirmed by the landing team against that repo before building.

- **Read inbound `?source=` on load** and persist for the session (sessionStorage / context) so it survives scroll-to-footer + submit. No `source` reading exists today.
- **Restore B2B micro-actions** (spec §Capture Option A): two actions under the footer heading — *Stay updated* → `interest_type=generic`; *Bring this to my group* → `interest_type=b2b_group`, revealing an optional **Group / company** field. (v8 removed these; CSS hooks `site-footer-form--b2b` and `site-footer-input--group` reportedly still exist in `footer.tsx`.)
- **Extend submit + proxy passthrough:**
  - `components/footer.tsx` `handleSubmit` posts `{email, message}` only — add `source` (from session, default `landing-hero`), `interest_type`, `group_name`.
  - `app/api/waitlist/route.ts` currently **whitelists `email` + `message`** and silently drops everything else — must forward `source`, `interest_type` (`generic`\|`b2b_group`), `group_name` with the same trim/length guards. **(Without this proxy change the new fields never reach the gateway — easy to miss.)**
- **Tag defaults:** footer/hero CTAs that scroll to the form submit `source=landing-hero` when no inbound `?source=`.
- `WAITLIST_SECTION_ID = "stay-connected"` reportedly already exists, so a `/#stay-connected?source=…` anchor CTA is viable if BE picks the anchor URL shape over root `/?source=…`.

### Slice 4 — VIEWER TEAM (`double-front`) — this project

> **Owner: Viewer team (this repo).** All references verified against the code 2026-06-15. Depends on the Slice 0 param rename above — do them together.

- **Share button** (`hooks/useShareReplayLink.ts` → `lib/replayUrl.ts` `writeReplayShareParams`; wired in `components/simulation/PlayerControls.tsx:154`): append `source=sim-share` when serializing the copied URL, **only if** no `source` already present (first-wins). Verified: today it serializes `new URL(window.location.href)` and writes only `t/zoom/focus/double`, so any existing `source` (e.g. from an inbound tagged link) is already preserved — first-wins needs no extra plumbing.
- **Play-mode HUD pill** (`app/sim/[sim_code]/play/PlayModeHud.tsx`): the "Curious what this is?" CTA currently uses the relative `exitHref` default `'/waitlist'` — **there is no `/waitlist` route in `double-front`** (likely already a dead link). Repoint it to an absolute `https://doubland.ai/?source=play-hud`, and **preserve** an inbound `?source=` from the deep link if present. Requires `PlayModeInner` to (a) read `?source=` in `parsePlayParams` (`app/sim/[sim_code]/play/page.tsx:49` — today it parses only `t/double/zoom/focus`) and (b) thread the resolved href into `<PlayModeHud exitHref=… />` (not currently passed).
- **Pass-through:** play deep links arriving with `?source=yt-d{N}-s{M}` (from YouTube descriptions) should forward that tag to `doubland.ai` on click-through, for funnel continuity. Note the play route hard-requires both `?t=` and `?double=` (`parsePlayParams` → `PlayModeError` otherwise) — the YouTube generator's deep links already include both.

### Deploy gate (Landing depends on BE)

- BE migration (Slice 1) must be applied on live Supabase **before** the landing starts sending the new fields (same pattern as `20260529_landing-page_TODO-BE.md`). **Landing-team** Slice 2 must not ship ahead of the migration. **Viewer-team** Slices 0 + 4 have no BE dependency — they only rename/add query params — so they can ship independently once the rename lands.

---

## Post-build status & reflection (2026-06-15)

**Built & deployed:** Slice 1 (BE — migration + gateway) and Slice 2 (landing — `double-landing-page`) are implemented and pushed to `main` (auto-deploys to Vercel). The landing reads inbound `?source=` (client-side, first-wins, `sessionStorage`), restores the Option-A B2B micro-actions (*Stay updated* / *Bring this to my group* + optional group field), and forwards `source` / `interest_type` / `group_name` through the existing `/api/waitlist` proxy.

**Verified locally:** typecheck clean; `?source=` survives the version-preview middleware (it only strips `?v=`, preserves `?source=`); both v1-cinematic and v2 render the micro-actions.

**Verified in production (smoke test — 2026-06-15):**

- **Domain canonicalization (heads-up — reverses §Link shape):** apex `doubland.ai` **307-redirects to `www.doubland.ai`** (www is the canonical serving host), and the redirect **preserves `?source=`** (307 also preserves POST method). So apex links still work but add one redirect hop. §Link shape currently says "always use apex" — follow-up: either repoint operator copy to `https://www.doubland.ai/?source=…` or knowingly keep apex (harmless; query survives).
- **`POST /api/waitlist` through the live proxy → gateway — all `HTTP 200`:** (1) `generic` + `source=tg-survival-d1-test`; (2) `b2b_group` + `source=tg-survival-d1-test` + `group_name`; (3) email-only. → the deployed gateway **accepts the extended payload** (no schema rejection) and **email-only still succeeds**. Covers the *transport* half of AC #1/#2/#6.
- **Not proven by this test:** (a) the *stored* column values + the ratchet — BE must query `double.waitlist` for the three rows; (b) the browser `?source=` → `sessionStorage` → payload path — curl injects the body directly, so this still needs a ~30-sec manual check (load `https://www.doubland.ai/?source=tg-survival-d1-test`, submit, confirm the row).
- **Cleanup:** exclude/delete the three test rows — `linktrack-smoke-generic@`, `linktrack-smoke-b2b@`, `linktrack-smoke-organic@ondouble.com` (source `tg-survival-d1-test`) — from any readout.

**Resolved — funnel produces correct data (updated 2026-06-16):**

All gateway-side questions **and** the production proxy path are now verified end-to-end. Nothing below blocks the first tagged drop except operator discipline (#4).

1. **Upsert ratchet — ✅ RESOLVED (BE, 2026-06-16).** The gateway enforces "never downgrade": a later `generic` re-submit does **not** overwrite an existing `b2b_group` row — enforced in gateway code, not relying on the column default. No landing change required.
2. **`source` column default — ✅ RESOLVED (BE, 2026-06-16); the earlier "no default" note was wrong.** Live `double.waitlist.source` default **is** `'landing-hero'` (column nullable). An untagged insert lands as `landing-hero`, not NULL; pre-tracking rows (5 live) stay NULL. `source` refresh is last-write-wins, valid-tag-only (the gateway includes `source` only when the regex passes). The landing sending `landing-hero` explicitly is **redundant but safe**. *(Corrects the prior "migration has no column default on source" claim — the migration's second `ALTER COLUMN … SET DEFAULT` did apply.)*
3. **✅ RESOLVED (2026-06-16) — production browser → proxy → gateway forwarding verified end-to-end.** A live submit through `www.doubland.ai/api/waitlist` stored `source=tg-survival-d1-test`, `interest_type=b2b_group`, and `group_name` exactly as sent; a follow-up `generic` re-submit kept the `b2b_group` row (ratchet holds) while `source` refreshed to `landing-hero` (last-write-wins). The 2026-06-15 smoke failure (rows stored defaults) was a **stale Slice-2 proxy deploy** that has since propagated — the landing `/api/waitlist` proxy now forwards all three fields. **No code fix needed; the funnel is production-ready.** *(E2E test rows `linktrack-e2e-generic@` / `linktrack-e2e-b2b@ondouble.com` — exclude/delete from any readout.)*
4. **Outbound tagging — now in place.** Slice 3 (YouTube), Slice 4 (sim viewer / play HUD — viewer team), and Slice 6 (embedded Share → landing re-embed) are all built/committed; Slice 6 local e2e green 2026-06-16. Remaining: the operator pastes tagged Telegram links each drop (Slice 5). Slice 6's `source=sim-share` rides the **same** proxy path as #3, now verified end-to-end (the Slice-6 e2e confirmed the tag reaches `location.search`; the #3 live submit confirmed that path persists to the DB). On-screen end-card URLs (retyped by viewers) inherently can't carry a tag — that traffic stays `landing-hero`.

---

## Slice 6 — Share deep-link → landing re-embed (added 2026-06-15)

> **Refines §3 "Sim viewer URLs" + Slice 4.** The Share button should produce a
> **landing URL**, not a standalone viewer URL. This is the owner's (Ivan's)
> stated intent; it supersedes the "canonical viewer host" reading the landing
> team and viewer team were briefly solving for.

### Goal

Clicking **Share** inside the embedded sim on `doubland.ai` produces a **landing**
URL. When a recipient opens it: (1) the landing loads, (2) it scrolls to the
embedded-sim section, (3) the iframe boots at the **exact step / focus / zoom /
double** that was shared. Keeps the visitor on the marketing page with the
waitlist CTA in view — funnel-aligned (a standalone viewer link would send them
off-funnel).

### Why this replaces the "canonical viewer host" plan

Landing team confirmed (2026-06-15): `www.doubland.ai` is the **landing** app with
**no `/simulations/*` route and no rewrite**; the only viewer host is the
`double-front.vercel.app` alias (iframe `src` = `SIM_BASE` in landing
`lib/palia.ts`, env `NEXT_PUBLIC_SIM_BASE`). A standalone viewer link therefore
can't be served on `doubland.ai` without standing up a viewer subdomain
(`app.doubland.ai`) + DNS. **This design avoids that** — the iframe keeps loading
from the vercel alias (users never see it); the shared link is a landing URL.
`NEXT_PUBLIC_SHARE_BASE_URL` (Slice 4) is **not** the mechanism for the embedded
case — it stays valid only for direct/non-embedded viewer links.

### Shared-link shape (landing owns it)

```
https://www.doubland.ai/?sim={code}&t=…&double=…&zoom=…&focus=…&source=sim-share#<sim-section>
```

Query **before** the `#` (per §Link shape) so `?source=` is funnel-readable and
the hash scrolls. `source=sim-share` rides the same params into the Slice 2 session.

### Existing scaffolding (already built in `double-front`)

- Viewer reads `?t= / double / zoom / focus` on boot (embed bootstrap) — the
  *receiving* side is largely done.
- Parent↔iframe `postMessage` channel exists (`lib/landingCameraMessage.ts`):
  landing→iframe camera commands, iframe→landing playback. **Missing:** the
  iframe→landing *share* message, the landing's build/copy, and the load-time
  re-apply.

### Tasks — VIEWER TEAM (`double-front`)

- [x] `hooks/useShareReplayLink.ts`: when embedded (`window.self !== window.top`,
  same guard as `postLandingSimPlaybackToParent`), **stop copying the iframe URL**
  — `postMessage` the share state to the parent:
  `{ type: 'landing-share', simCode, t, zoom, focus, double, source: 'sim-share' }`.
  Flashes "Copied" **optimistically on post** (owner decision — not on the
  `landing-share-copied` ack; see reflection). Done 2026-06-16.
- [x] `lib/landingCameraMessage.ts`: add the `landing-share` / `landing-share-copied`
  message types + a `postLandingShareRequestToParent(state)` helper. Done 2026-06-16.
- [x] Keep the existing `canonicalizeShareUrl` path for the **non-embedded**
  (direct viewer) case — unchanged. Done 2026-06-16.

### Tasks — LANDING TEAM (`double-landing-page`)

- [x] **On load:** parse `?sim= & t= & double= & zoom= & focus= & source=` from the
  landing URL; scroll the sim section into view; build the iframe `src` =
  `${SIM_BASE}/simulations/{sim}?embed=1&t=…&double=…&zoom=…&focus=…`. Keep
  `?source=` flowing to the waitlist (Slice 2 sessionStorage path). Done 2026-06-16
  (`lib/landing-share.ts` `parseSharedSimParams`/`buildSharedEmbedSrc`,
  `hooks/use-landing-share.ts`).
- [x] **On `landing-share` message:** build the canonical landing URL,
  `navigator.clipboard.writeText()` it **at the top level** (more reliable than
  in-iframe clipboard), `postMessage` back `landing-share-copied`. Done 2026-06-16
  (`buildCanonicalShareUrl` + `use-landing-share.ts`; textarea fallback when the
  async clipboard API is unavailable; ack posted only on a confirmed copy).
- [x] Confirm the embed supports an **arbitrary `sim={code}`** (not only the
  featured sim). **Yes** — `buildLandingSimUrl({ sim })` now substitutes any
  validated code (`^[A-Za-z0-9._-]{1,64}$`) into the iframe path; invalid codes
  fall back to the featured `SIM_CODE`. Caveat below.

### Open decisions (block wiring)

| # | Decision | Owner | Resolution (landing, 2026-06-16) |
|---|---|---|---|
| 1 | Sim-section **anchor id** + exact landing-URL **param names** | Landing team | **Confirmed as proposed.** Anchor `#live-sim` (existing `<section id>` in `hook-section.tsx`). Params `sim` / `t` / `double` / `zoom` / `focus` / `source` — identical to the viewer's `lib/replayUrl.ts` keys, so the message fields map 1:1 (`simCode`→`sim`, `t`→`t`). **No viewer reconciliation needed.** |
| 2 | Embed supports **arbitrary `sim={code}`** vs. only the current featured sim | Landing team | **Arbitrary `sim={code}` — "share any moment."** Validated (`^[A-Za-z0-9._-]{1,64}$`); invalid → featured `SIM_CODE`. Caveat: the live day-badge + status polling (`lib/landing-sim-status.ts`) still track the featured `SIM_CODE`, so a shared *non-featured* sim shows the featured "live" badge over a replay. Acceptable for a replay deep link; revisit if we promote off-featured shares. |
| 3 | Parent owns the clipboard write + the `postMessage` contract (`landing-share` → `landing-share-copied`) | Both — confirm | **Confirmed.** Parent copies at top level and acks `landing-share-copied` to `e.source` **only on a confirmed write**. Viewer's optimistic "Copied" is unchanged; ack is available to gate on later. |
| 4 | `app.doubland.ai` viewer subdomain — **not required** for this design; only if a standalone viewer link is *also* wanted | Owner / DNS | Not needed — landing keeps loading the iframe from `SIM_BASE` (vercel alias); shared link is a landing URL. |

### Deploy dependency

The viewer's `landing-share` postMessage is **inert** until the landing implements
the load-time read + scroll + iframe-`src` threading. Ship them together (or
landing first) so a shared link never opens a landing that ignores the params.

### Viewer-side build & reflection (2026-06-16)

**Built** — branch `ivan/link-tracking-slice6` (viewer team, `double-front`):

- `lib/landingCameraMessage.ts` — `LandingShareMessage` / `LandingShareCopiedMessage`
  types + `postLandingShareRequestToParent(state)`. Same embed guard as
  `postLandingSimPlaybackToParent`; returns `true` when embedded (posted) / `false`
  standalone, so the caller falls back cleanly.
- `hooks/useShareReplayLink.ts` — embedded branch posts
  `{ type:'landing-share', simCode, t, zoom, focus, double, source }` and returns;
  standalone branch unchanged (`canonicalizeShareUrl` + clipboard). `simCode` threaded
  from the existing `PlayerControls` prop (no pathname parsing).
- `__tests__/shareReplayLink.slice6.test.tsx` — embedded posts the message + never
  touches the clipboard; standalone copies a canonical URL tagged `source=sim-share`;
  an inbound `?source=` is forwarded over the `sim-share` default (first-wins); the
  helper no-ops when standalone. 24 related tests green; `tsc` + ESLint clean for the
  changed files.

**Pre-build finding — the spec's own FE status was stale.** Slices 0 (param rename)
and 4 (share / play-HUD `?source=`) were **already shipped and committed**
(`ivan/link-tracking-fe`, 2026-06-15) — confirmed in code, not just claimed. The
status header line and the §Current-state / §Implementation-slices rows for 0 and 4
still read "FE pending" and should flip to ✅. This is the same doc-drift this spec
was written to correct (VC prep §8, MVP gate), now recurring on the FE rows.

**Deviation from the Slice-6 task text — feedback is optimistic, not ack-gated.**
The task said "flash Copied on the `landing-share-copied` ack." Owner decision
(2026-06-16): flash on *post* instead — simpler, but a known soft spot. Until the
landing implements the receiver, the embedded Share button *says* "Copied" while
nothing actually reaches the clipboard. The `landing-share-copied` type is still in
the contract, so swapping to ack-gated feedback later is a small change if the
false-positive bites in testing.

**The Slice-4 acceptance criterion now splits in two.** "Share from sim viewer →
copied URL includes `source=sim-share`" holds for the **direct/standalone** viewer
(it copies a canonical URL). The **embedded** case deliberately copies *nothing* in
the iframe — the parent copies a landing URL. The AC should be split so the embedded
path isn't later read as a regression.

**First-wins source in the embedded path is mostly theoretical.** The iframe `src`
the landing builds (`?embed=1&t=…`) normally carries no `?source=` — the visitor's
funnel tag lives on the *landing* URL (Slice-2 session), not on the iframe. So the
iframe's `readAttributionSource` is almost always null → `sim-share`, and the landing
stays the authority for the session source. The forward is correct and harmless, just
rarely the deciding factor.

**Still blocked end-to-end on the landing half + the §Open-decisions** (anchor id,
exact landing-URL param names, arbitrary `sim={code}` support, clipboard owner). The
viewer emits the proposed contract above; if the landing picks different field names
they must be reconciled. Ship landing-first or together (§Deploy dependency above).

### Landing-side build & reflection (2026-06-16)

**Built** — landing team (`double-landing-page`, branch off `main`):

- `lib/landing-share.ts` — the landing half of the contract: param-name constants,
  `LandingShareMessage` / `LandingShareCopiedMessage` types + an
  `isLandingShareMessage` guard (mirrors `double-front/lib/landingCameraMessage.ts`),
  `parseSharedSimParams` (inbound deep-link reader), `buildSharedEmbedSrc` (iframe
  `src`), and `buildCanonicalShareUrl` (the copied landing URL). Value encoding
  (`zoom` rounding, integer `focus=x,y`) mirrors the viewer's `replayUrl.ts` so a
  link round-trips landing → iframe → viewer untouched.
- `lib/palia.ts` — `buildLandingSimUrl` extended with `sim` (arbitrary code) +
  `focus`; the code is `encodeURIComponent`-escaped into the path.
- `hooks/use-landing-share.ts` — drives both halves: on mount, swaps the iframe
  `src` to the shared moment and scrolls `#live-sim` into view; listens for
  `landing-share`, copies the canonical URL at top level (textarea fallback), and
  acks. Wired into `components/hook-section.tsx` (`src={embedSrc}`).

**All four §Open-decisions answered in the table above; the proposed field names
were accepted verbatim — no viewer reconciliation needed.**

**Hydration note.** The iframe `src` initialises to the default live embed
(`SIM_URL`) so SSR and the first client render agree; deep links swap + scroll just
after mount. Cost: one extra iframe load **only** on shared-link visits, never on
organic traffic — a deliberate trade for zero hydration mismatch on the common path.

**`?source=` was already flowing.** Slice 2's `WaitlistProvider` reads inbound
`?source=` (first-wins, `sessionStorage`) on mount; the shared link puts
`source=sim-share` before the `#`, so it lands in `location.search` and the existing
session path picks it up with no change. The Slice 6 receiver only owns `sim` / `t` /
`double` / `zoom` / `focus`.

**Optimistic-copy soft spot (carried over from the viewer note).** Now that the
receiver exists, the embedded Share genuinely copies — but the viewer still flashes
"Copied" on *post*, not on our `landing-share-copied` ack. If a top-level clipboard
write is ever blocked (permissions, non-secure context), the viewer says "Copied"
while nothing landed. The ack is wired (sent only on a confirmed write) so swapping
the viewer to ack-gated feedback is a one-line change there if it bites.

**Repo lint is pre-existing broken** (no ESLint flat config for v9) — verified via
`tsc --noEmit` (clean) instead. No test framework in the landing repo; the contract
encoding is unit-covered on the viewer side (`shareReplayLink.slice6.test.tsx`).

**Edge case — no-double (map-level) shares in embed mode — RESOLVED via fix (a)
(2026-06-16, owner decision).** Originally flagged by the viewer lead: the embed
camera restore (`app/simulations/[sim_code]/page.tsx` `applyLandingEmbedCamera`)
returned `false` when `!initialCameraParams.doubleName`, restoring the camera only by
framing a persona sprite (which then tracks it live — better than a fixed pan, but
needs a `double`). A `zoom`+`focus` share with **no** `double` (a map-level pan)
relied on the incidental `tryApply` fallback (`applyReplayCameraParamsToScene` via the
`window.__focusCameraViewport` director global). **Fix (a) chosen** (vs. (b) landing
drops `focus`/`zoom` when no `double`): the viewer now **explicitly** honors a
`focus`/`zoom` share without a `double` in embed mode — `applyLandingEmbedCamera` has
a dedicated map-level branch that calls `applyReplayCameraParamsToScene` once the
director global is ready (bails-to-retry until then), making "share any moment"
restore intentional rather than ordering-dependent. The landing always emitted
`focus`/`zoom` correctly; this closes the viewer side. **Confirm visually in e2e case
(b)** that the pan+zoom holds through embed autoplay.

### Local e2e — verified end-to-end (2026-06-16)

Ran with the full local stack: BE gateway (`:8001`) + `double-front` viewer
(`:3000`, `ivan/link-tracking-slice6`) + landing (`:3001`, `ivan/link-tracking-slice6`),
landing iframe pointed at the local viewer via `NEXT_PUBLIC_SIM_BASE=http://localhost:3000`.
Real cross-origin iframe (3000↔3001) and a real browser clipboard — the actual
postMessage + clipboard path, not a mock. All four of the viewer lead's cases pass:

- **(d) sender + clipboard — PASS.** Clicking **Share** inside the embedded iframe
  posted `landing-share`; the landing wrote the canonical URL to the clipboard at the
  top level. Pasted verbatim from the clipboard:
  `http://localhost:3001/?sim=20260615&t=23&double=Luba+Pistsova&zoom=1.282&focus=120%2C50&source=sim-share#live-sim`.
  **The predicted clipboard block did not occur** — the top-level `writeText` succeeded
  even though the originating click was inside the cross-origin iframe. So on this path
  the optimistic flash is not a false positive in practice; ack stays wired but unused.
- **(a) focused-double share — PASS.** Opening the link scrolled to the sim and booted
  **exactly** at the shared step/focus/zoom, following Luba. ("time/place/zoom the link
  was created" confirmed.)
- **(b) map-level, no-`double` share — PASS.** With fix (a), the link restored the
  pan+zoom framing and held it through autoplay, following nobody. The no-`double`
  edge is closed.
- **(c) step-0 share — PASS.** Booted from the start; the step-0 seek-skip is fine.

**Round-trip encoding** was also checked deterministically before the browser run
(build → parse → re-embed over all cases): double-with-space decodes, an inbound tag
(`tg-survival-d3`) beats the `sim-share` default (first-wins), and a path-injection
`sim` code (`../etc/passwd`) safely falls back to the featured sim.

**Not exercised this run (low-risk, still open):** a live waitlist *submit* carrying
`source=sim-share` into a DB row — BE was idle (viewer ran on prod sim data) and the
Slice 2 capture path was verified separately (§Post-build status). The tag is present
in `location.search` and the Slice 2 reader is untouched; worth one ~30-sec confirm.
Independent of Slice 6: the BE **upsert-ratchet + `source`-default** reconciliation
(§Post-build "Still open" #1–2) — Slice 6 routes its tag through the same
`/api/waitlist` path, so it inherits whatever BE confirms; nothing here closes those.

**Status:** Slice 6 is feature-complete and locally e2e-verified across both repos.
Deploy gate unchanged — merge landing **with or after** the viewer (`ivan/link-tracking-slice6`
in both repos), never landing-ahead (§Deploy dependency). Local-only `NEXT_PUBLIC_SIM_BASE`
override in the landing `.env.local` is for testing — revert before deploy.

---

## References

- [`20260612_VC_prep.md`](../double-ivan/20260612_VC_prep.md) — §0 TL;DR, §2 decisions, §3 money slides, §4 Tier 1, §6.A action plan
- [`20260611_mvp-release-gate.md`](../double-ivan/20260611_mvp-release-gate.md) — P0 row 9 (source tagging), §5 landing funnel (original shape)
- [`landing/20260603_landing-page_v8.md`](landing/20260603_landing-page_v8.md) — §6 simplified waitlist (current shipped UX)
- [`landing/20260529_landing-page_TODO-BE.md`](landing/20260529_landing-page_TODO-BE.md) — waitlist deploy gate
- `generative_agents/video/generate_description.py` — YouTube description deep links
- `double-ivan/video/video_PRD.md` — TODO-15 (description CTA alignment)

---

**End of spec.**
