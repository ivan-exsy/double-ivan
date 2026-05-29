# Landing Page — Implementation Request

> **Target repo:** `D:\Coding\double-landing-page` (separate from this docs repo).
> **Stack (verified 2026-05-29):** Next.js 16 App Router · React 19 · TypeScript · Tailwind v4 · shadcn/Radix UI · Supabase (already wired) · Vercel hosting · pnpm.
> **What this doc is:** the build spec for the landing-page refresh. **Part A is LOCKED copy + page outline** — implement verbatim. **Part B is the tech plan** for the trailer gallery (YouTube + manual sync script) and the sim-player migration. **Part C is the visual redesign** (remove the AI-generated look). **Appendix** holds the copy-decision history (reference only).

## Execution rules (read first — for the AI coding engine)

1. **Work in a dedicated git worktree, not on `main`.** Create one before touching files, e.g.:
   ```bash
   git -C D:/Coding/double-landing-page worktree add ../double-landing-page-redesign -b feat/landing-redesign
   ```
   Do all work in that worktree branch (`feat/landing-redesign`); open a PR at the end. Never commit straight to the deployed branch.
2. **Copy is LOCKED — zero variation.** Every string in Part A must be implemented **exactly** as written: same words, punctuation (em dashes, apostrophes), and casing. Do not rephrase, "improve", shorten, or A/B-vary any headline, subhead, CTA, or body line. If a string seems wrong, flag it in the PR — do not change it.
3. **Three workstreams, all in scope:** (A) copy swap, (B) trailer gallery + sim-player migration, (C) visual redesign. Land them in that order so the page is never broken between steps.
4. **Visual redesign is required, not optional** (Part C). The current site has an "AI-built" look (rainbow gradient text, pulsing blurred color blobs); it must end up looking like a polished product art-directed by film/TV professionals.

---

# PART A — LOCKED: Final Copy & Page Outline

> Copy is final. Implement strings verbatim. CTA discipline: **primary button is always `Create your Double`**; "Enter Doubland" is a destination *label* (Step 3), never a button (the Village is invite-only in beta). Vocabulary: "AI Double" on first mention (metadata + hero) for cold-traffic clarity, "Double" thereafter; never "Double + Doubland" in the same short sentence/H1.

## Page order & component mapping

`app/page.tsx` renders, top → bottom:

| # | Section | Component file | Status |
|---|---|---|---|
| 1 | **Hero** | `components/hook-section.tsx` | EDIT — new copy + featured-trailer player; **remove** sim iframe (migrates to §4) |
| 2 | **Explainer** — Get in Doubland in 3 steps | `components/explain-section.tsx` | EDIT — copy |
| 3 | **The Season** — trailer gallery | `components/season-section.tsx` | **NEW** |
| 4 | **The Live Village** — interactive sim player | `components/live-village-section.tsx` | **NEW** (receives the iframe + fullscreen logic moved out of `hook-section.tsx`) |
| 5 | **Amplifier / Social** | `components/amplify-section.tsx` | EDIT — copy |
| 6 | **Safety / Control** | `components/reassure-section.tsx` | EDIT — copy |
| 7 | **Closing CTA + Footer** | `components/cta-section.tsx` (add to page) + `components/footer.tsx` | EDIT |

`app/page.tsx` updated import/order:
```tsx
<HookSection />        // hero + featured trailer
<ExplainSection />
<SeasonSection />      // NEW — trailer gallery
<LiveVillageSection /> // NEW — sim player (migrated iframe)
<AmplifySection />
<ReassureSection />
<CtaSection />         // closing CTA
<Footer />
```

---

## 1. Metadata (`app/layout.tsx`)

**Title:** `Doubland — Watch the version of you that said yes`

**Description:** `Make your AI Double, test it in private, then let it loose with your friends in Doubland. Invite-only beta.`

## 2. Hero — `hook-section.tsx`

**H1:** `Give your Double a life of its own.`

**Subhead:** `It thinks like you, acts like you, makes choices you'd never admit — then runs loose in a village with your friends. Press play.`

**Primary CTA:** `Create your Double` → `app.ondouble.com`
**Secondary CTA:** `Watch the season ▸` → anchor-scroll to §3 (`#the-season`)

> 🎬 **Hero visual = featured trailer player** (16:9, MVP format). Muted + captioned + poster-framed on load, large play button; click plays with audio. "Press play" is literal. Featured episode follows the **Featuring Rule** (§B2). Shares manifest/state with the §3 gallery — the hero is just the featured slot surfaced up top.
> ⚠️ The sim iframe + fullscreen `postMessage` logic currently in this file **moves to §4** (`live-village-section.tsx`). Do not leave it in the hero.

## 3. The Season — `season-section.tsx` (NEW, id `the-season`)

**Header:** `A nature documentary about your friends.`

**Sub:** `Every trailer is one real day in a real village — narrated by someone who knows everything.`

**Per-episode card caption:** the trailer's own cliffhanger end-card question (e.g. *"Who knew before the vote?"*).

> 🎬 Layout: large featured player on top + horizontal scrollable filmstrip of episode cards. Card = poster · `Day N` label · cliffhanger caption · duration. Unreleased days render as locked ghost cards. Data + behavior spec in **§B2**.

## 4. The Live Village — `live-village-section.tsx` (NEW)

**Header:** `It's not a video. It's the village — live.`

**Sub:** `Trailers are the highlights. Open the village and watch the whole thing from Day 1 — zoom into any moment, follow any Double, replay anything.`

**Block CTA:** `Open the village ▸` (expands/fullscreens player) · then `Create your Double`.

> 🎬 This is the **existing** interactive sim iframe migrated out of the hero — same simulation as the §3 trailers (`https://double-front.vercel.app/simulations/20260520-1`). Keep the fullscreen `postMessage` handshake intact. Tone: *"follow the village,"* never *"spy on your friends."* Detail in **§B3**.

## 5. Amplifier / Social — `amplify-section.tsx`

**Header:** `The version of you that said yes`

**Body:** `Bring your friends — the plot twists get better fast.`

- **Card 1:** `Relationships, rivalries, alliances — way more fun when it's people you actually know.`
- **Card 2:** `Your Double makes the moves. You watch like it's your favorite show.`
- **Card 3:** `Moments so unhinged you'll have to send them to the group chat.`

## 6. Safety / Control — `reassure-section.tsx`

**Header:** `You're in control the whole time`

**Subhead:** `It's a story, not real life.`

- `Keep your profile private unless you share.`
- `You decide who gets access to your Village.`
- `Delete anytime — gone.`

## 7. Closing CTA + Footer — `cta-section.tsx` + `footer.tsx`

**Primary CTA:** `Create your Double`
**CTA line:** `Batch-based rollout. Earlier profiles get invited earlier.`

**Footer brand:** `Doubland.ai`
**Footer tagline:** `Double your squad, watch the chaos`

## Explainer copy (§2 section) — `explain-section.tsx`

**Header:** `Get in Doubland in 3 steps`
**Intro:** `Watch what it does when you're not steering.`

- **Step 1 — `Create your Double.`** — `Teach your Double what it's like to be you.`
- **Step 2 — `Test it in private.`** — `Put your Double through messy choices and see when it acts exactly like you — or nothing like you.`
- **Step 3 — `Enter Doubland.`** — `Bring friends in and see what your Doubles do together. Invite-only in beta.`

---

# PART B — Tech Decisions & Build Plan

## B0. Decisions locked

- **Video gallery implementation:** YouTube (source of truth + CDN + player) → **synced manifest** in Supabase → Next.js gallery UI.
- **Sync trigger:** **manual script**, run by hand after each YouTube upload. **No cron, no API route, no scheduler.**
- **Episode metadata:** the operator names YouTube videos freely on upload — **no enforced title convention, no title parsing.** Structure (order, Opening vs daily) is derived from **YouTube playlist order**; the YouTube title is shown on the card as-is.
- **Video format:** 16:9 (MVP). One showcased Survival season (sim `20260520-1`).
- **Sim player:** existing iframe migrates from hero to a dedicated section; unchanged behavior.
- **CTA verb sitewide:** `Create your Double`.
- **Visual:** full redesign to a cinematic / prestige-documentary look (Part C). Remove the AI-generated flare.

## B1. Video Gallery — YouTube + synced manifest + cron

### Data flow
```
Operator uploads episode to YouTube, adds it to the season playlist (in order)
        │
        ▼  operator runs the script by hand
pnpm sync:episodes   ── YouTube Data API v3 ──▶ read playlist → upsert
        │
        ▼
Supabase tables `episodes` + `seasons`   ◀── the synced manifest
        │
        ▼  (read at request)
SeasonSection (gallery) + HookSection (featured slot)
        │
        ▼
YouTube IFrame embed plays the video
```

YouTube owns hosting/bandwidth/player. **Our UI owns the chrome** (cards, Day labels, ghost cards, featuring). Because the gallery reads Supabase at request time, running the script makes new episodes appear in production **without a redeploy**.

### Episode structure — derived from playlist order (NO title convention)
The operator names videos freely; the script never parses titles for meaning. Structure comes from the **YouTube playlist**:

- **Order** = playlist position. Operator keeps the playlist ordered: **Opening first, then Day 1, Day 2, …** (reorder in YouTube Studio if needed).
- **`kind` / `day_number`** = derived from position: first item → `opening` (`day_number = 0`); item *n* (1-indexed after Opening) → `day`, `day_number = n`. (Override available via the optional config below if the operator doesn't want position-based numbering.)
- **Card label** = the YouTube **title**, shown verbatim, exactly as typed on upload.
- **Caption (optional cliffhanger line)** = first line of the YouTube **description**, if present; otherwise omitted. Never required.
- A video pulled from / not in the playlist simply drops out of the gallery on the next run — nothing breaks.

> Optional manual override: a committed `data/season-overrides.json` keyed by `youtube_id` may set `{ day_number, kind, caption }` for any episode the operator wants to control explicitly. The script merges overrides on top of the playlist-order defaults. Leave the file empty (`{}`) to rely purely on playlist order.

### Manifest schema (Supabase)

`seasons` (one row per showcased season):
```
id              text  PK   -- e.g. "the-ville-s1"
cohort          text       -- "The Ville"
season_title    text       -- "Season 1"
sim_id          text       -- "20260520-1"  (links to the §4 sim player)
youtube_playlist_id text
state           text       -- "live" | "completed"   (manual override; nullable)
total_days      int        -- expected episode count (~15) for ghost cards
updated_at      timestamptz
```

`episodes` (one row per trailer):
```
id            text PK      -- youtube videoId
season_id     text FK
kind          text         -- "opening" | "day"
day_number    int          -- 0 for opening
title         text
caption       text         -- cliffhanger question
youtube_id    text
duration_sec  int          -- from videos.list contentDetails
published_at  timestamptz
thumbnail_url text
```

### Manual sync script — `scripts/sync-episodes.ts` (run by hand)
Run after each YouTube upload: `pnpm sync:episodes` (add `"sync:episodes": "tsx scripts/sync-episodes.ts"` to `package.json`; `tsx` as a devDependency). The script:
1. Reads each `seasons` row; calls `playlistItems.list` (`part=snippet,contentDetails`, `maxResults=50`) on `youtube_playlist_id`.
2. Batches `videos.list` (`part=contentDetails`, up to 50 ids) for durations (ISO-8601 → seconds).
3. Builds episode rows from **playlist order** (kind/day_number from position; title verbatim; caption = description line 1 if present), merges `data/season-overrides.json`, then **upserts** into `episodes` (idempotent on `youtube_id`); removes rows no longer in the playlist.
4. Sets `seasons.state` from the `--state live|completed` flag if passed; otherwise leaves the row's stored value untouched (operator-controlled, see below).
5. Connects to Supabase with the **service-role key** (local-only, never shipped to the client). Prints a summary: episodes added/updated/removed, current featured episode.
- **CLI flags:** `--season the-ville-s1` (default: all seasons) · `--state live|completed` (optional) · `--dry-run` (print, don't write).
- **Quota:** a handful of units per run vs 10,000/day — irrelevant for manual use.

### Featuring Rule (what plays in the featured slot)
`seasons.state` is set by the operator (the `--state` flag on the script, or edited directly in Supabase) — there is no cron to auto-recompute it.

| Season state | Featured episode | Rail scroll | Badge / cue |
|---|---|---|---|
| **live** | **latest** released episode (max `day_number`) | snapped to newest end | `● LIVE — Day N` + `New episode daily · 6:30 PM` |
| **completed** | **Opening** (`kind=opening`) | snapped to start | `Full season · N episodes` |

- Ghost cards: render `total_days − releasedDays` trailing locked cards (`Day {n} — tonight, 6:30 PM`).
- Episode order in rail: by `day_number` ascending (Opening first).
- Deep links: `/season/{season_id}#day-{n}` loads that episode into the featured player (group-chat shareable).

### YouTube embed params (both hero + gallery players)
`mute=1` (hero autoplay loop) · `cc_load_policy=1` (captions on — narration carries the story) · `modestbranding=1` · `rel=0` · `playsinline=1`; hero loop adds `loop=1&playlist={videoId}`. Raw `<iframe>` is fine (matches existing pattern in `hook-section.tsx`); no new dependency needed.
> Producer tip: set a **custom YouTube thumbnail** = the trailer's end-card frame so gallery posters match the brand aesthetic.

### Reading the manifest in the UI
`SeasonSection` and `HookSection` read from Supabase (server component) using the existing anon key. Read dynamically (Supabase reads are cheap) or cache with `export const revalidate = 300`. Freshness is operator-paced: the gallery reflects whatever the last `pnpm sync:episodes` wrote.

### Secrets / env
```
# Script-only (local .env.local; NEVER expose to the client / ship to Vercel client bundle):
YOUTUBE_API_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
# Already present, used by the UI for reads:
# SUPABASE_URL / SUPABASE_ANON_KEY
# Season config (playlist id, sim_id, total_days, cohort, season_title) seeded once into the `seasons` table
```
No `CRON_SECRET` / Vercel Cron / API route — sync is local + manual.

## B2. (covered above) ·  ## B3. Live Village sim-player migration

- Move the `<iframe src="…/simulations/20260520-1">` block **and** all fullscreen `postMessage`/`fullscreenchange`/Escape logic from `hook-section.tsx` into `live-village-section.tsx` unchanged.
- Drive the `src` sim id from `seasons.sim_id` so the player and the §3 trailers always reference the same season.
- Add labels: live → `Running now — Day N`; completed → `Replay the full season`. Keep "Open the village ▸" as the expand trigger.
- Hero (`hook-section.tsx`) keeps only its layout + new copy + the featured **trailer** player.

## B4. Implementation checklist
- [ ] Create the worktree/branch first (see Execution rules).
- [ ] `app/layout.tsx` — metadata title/description.
- [ ] `hook-section.tsx` — new H1/subhead/CTAs; swap sim iframe → featured trailer player; secondary CTA anchors to `#the-season`.
- [ ] `explain-section.tsx` — 3-step copy.
- [ ] **NEW** `season-section.tsx` — gallery (featured player + rail + ghost cards), reads manifest.
- [ ] **NEW** `live-village-section.tsx` — migrated sim iframe + fullscreen logic.
- [ ] `amplify-section.tsx`, `reassure-section.tsx`, `cta-section.tsx`, `footer.tsx` — copy.
- [ ] `app/page.tsx` — insert `SeasonSection` + `LiveVillageSection` in order; add `CtaSection`.
- [ ] Supabase — create `seasons` + `episodes` tables; seed the `the-ville-s1` season row.
- [ ] **NEW** `scripts/sync-episodes.ts` + `data/season-overrides.json` (`{}`) + `package.json` `sync:episodes` script; add `tsx` dev dep.
- [ ] Env — `YOUTUBE_API_KEY`, `SUPABASE_SERVICE_ROLE_KEY` in local `.env.local` only.
- [ ] **Part C visual redesign** applied across all sections + design tokens.
- [ ] Open PR from `feat/landing-redesign`.

## B5. Acceptance criteria
- After an upload + `pnpm sync:episodes`, the new episode **appears in the gallery with no redeploy**.
- Episode order/Opening-vs-daily reflects **playlist order**; card label is the YouTube title verbatim.
- `--state live` → featured slot shows latest day + `● LIVE` badge; `--state completed` → featured slot shows Opening.
- Captions on by default; YouTube related-video leak minimized (`rel=0`, `modestbranding`).
- Sim player works (incl. fullscreen) in its new section; references same `sim_id` as the trailers.
- A video removed from the playlist disappears on the next sync; no run ever crashes on free-form titles.
- All copy matches Part A **verbatim** (strings, punctuation, casing); single CTA verb `Create your Double` sitewide.
- Visual: no rainbow gradient text, no pulsing blurred color blobs; passes the Part C "prestige product" bar.

---

# PART C — Visual / Art Direction Redesign

> **Goal:** the page must read as a polished product art-directed by film/TV professionals — **prestige documentary meets streaming key art** (think A24, a Netflix docuseries landing page, Survivor/HBO title design). It currently reads as an AI-generated template. This is a required workstream.
> **North Star (from the video playbook):** *"Truman Show meets prestige documentary — surveillance footage narrated by a warm, omniscient voice."* The page should feel cinematic, observed, and human — not techy.
> Hex values below are **starting points** — refine to taste; the constraints (remove the AI flare, ≤2 accents, cinematic dark base, editorial type) are the spec.

## C1. Remove the "AI-built" flare (specific elements)
In `hook-section.tsx` and wherever else they recur:
- ❌ Rainbow gradient headline text: `bg-gradient-to-r from-primary via-secondary to-accent bg-clip-text text-transparent animate-gradient` → solid warm off-white headline, optionally **one** word in the gold accent.
- ❌ The three pulsing blurred color blobs (`bg-primary/30 … rounded-full blur-3xl animate-pulse`, ×3) → delete entirely.
- ❌ Multi-hue section gradient backgrounds (`from-primary/20 via-secondary/10 to-accent/20`) → replace with a deep, near-flat cinematic base + optional subtle texture/vignette.
- ❌ Neon glow shadows (`shadow-2xl shadow-primary/20`) → flat or soft neutral elevation only.
- ❌ The purple/teal/pink default palette → retire.

## C2. Palette — cinematic, ≤2 accents
Define once as design tokens in `app/globals.css` (Tailwind v4 `@theme` / CSS vars) and have every section consume them — no per-section ad-hoc colors.

| Token | Role | Start value |
|---|---|---|
| `--background` | deep ink base (dusk/night) | `#0B0B0F` |
| `--surface` | lifted card/panel | `#15151B` |
| `--foreground` | warm off-white (paper, not pure white) | `#F4F1EA` |
| `--muted` | secondary text | `#9A9AA6` |
| `--accent-gold` | headlines accent + primary CTA (the trailer "gold lettering") | `#C8A24B` |
| `--accent-cyan` | **signal only** — live dot, links, hover, the wireframe echo | `#3FB6C4` |
| `--hairline` | 1px borders | `rgba(244,241,234,0.10)` |

Rules: gold = the one warm "premiere" accent; **cyan is reserved** for interactive/live signals (echoes the brand's cyan wireframe — never a fill, never on big text). No third hue. Mostly ink + paper + a little gold.

## C3. Typography — editorial, "produced"
- **Display / H1 / section headers:** a cinematic **high-contrast serif** (e.g. Canela, GT Sectra, or free: Playfair Display / Fraunces) — this single change kills the "template" feel fastest. Tight tracking, balanced wrapping (`text-balance`).
- **Body / UI / cards:** clean grotesk — keep **Inter** (matches the trailer card font in the playbook). Generous line-height.
- One serif + one sans, nothing else. Load via `next/font`.

## C4. Motion — restrained & cinematic
- Replace pulsing/`animate-gradient` with slow fades, gentle parallax, and a subtle Ken-Burns drift on poster stills. Single easing, 250–600ms.
- No perpetual pulsing, no neon glow loops. Honor `prefers-reduced-motion`.

## C5. Texture & imagery
- Subtle **film grain** + soft **vignette** over the dark base; optional thin **letterbox** framing on hero media — sells "footage."
- Trailer thumbnails are poster-grade (custom end-card frames). Cards: matte `--surface`, 1px `--hairline` border, restrained radius, flat elevation.
- Lean into the documentary frame: the gallery's "narrated by someone who knows everything" line can sit as an editorial caption, not a marketing blurb.

## C6. Components
- **Buttons:** primary = solid gold on ink (`Create your Double`); secondary = ghost/hairline (`Watch the season ▸`). No glow.
- **Live badge:** small cyan dot + `LIVE — Day N`, understated.
- **Sections:** consistent vertical rhythm, wide margins, one idea per viewport — give it room; prestige design is confident with negative space.

## C7. Brand guardrails to honor (from `brand.md`)
- Question mark is a brand element; don't italicize "What if?".
- Cyan wireframe motif lives on its own plane — accent only, never touching headline/wordmark.
- Tone test for every visual choice: would this look at home on the key art of a show people actually watch? If it looks like a SaaS template, redo it.

---

# APPENDIX — Copy Decision History (reference only)

> Superseded by Part A. Retained for traceability of the copy choices.

## A0. Final Copy Decision Table (Current vs Suggested vs Expert vs Selected)

| Landing Page Section | Current (live) | Suggested | Expert | Selected (→ now in Part A) |
|---|---|---|---|---|
| **Metadata Title** | `Build a Double of You — Watch It Play Out` | `Watch the version of you that said yes - in Doubland` | `Doubland — Watch the version of you that said yes` | `Doubland — Watch the version of you that said yes` |
| **Metadata Description** | "Build a Double of you, drop it into a village… Solo Rehearsals are live. Villages invite-only in beta, rolling out in batches." | "Your Double is a personality twin that explores the choices you didn't make…" | "Make your Double, test it in private, then let it loose with your friends in Doubland. Invite-only beta is rolling out by school." | "Make your AI Double, test it in private, then let it loose with your friends in Doubland. Invite-only beta." |
| **Hero H1** | "Build a Double of You" + "Drop Into a Village With Friends" + "(No real-life consequences. Mostly.)" | `Enter Doubland with friends.` | `Make a Double of yourself. Then let it loose with your friends.` | _(fixed in Part A)_ `Give your Double a life of its own.` |
| **Hero Subhead** | `It thinks like you, acts like you, and makes choices you'd never admit. Press play.` | `Your Double has your personality. Watch the version of you that said yes.` | `Watch another version of you flirt, fight, choose sides, start drama…` | `It thinks like you, acts like you, makes choices you'd never admit — then runs loose in a village with your friends. Press play.` |
| **Hero Primary CTA** | None in hero | `Enter your Doubland` | `Create My Double` | `Create your Double` |
| **Hero Secondary CTA** | None | learn-more | `See how it works` | `Watch the season ▸` |
| **Explain Header** | `Get on Double in 3 steps` | `Get in Doubland in 3 steps` | emotionally vivid framing | `Get in Doubland in 3 steps` |
| **Explain Intro** | `Watch what it does when you're not steering.` | Keep (locked) | Keep (strongest line) | `Watch what it does when you're not steering.` |
| **Step 1** | `Create your Double.` | Keep | Keep | `Create your Double.` + "Teach your Double what it's like to be you." |
| **Step 2** | `Solo Rehearsals.` + "Real-life dilemmas…" | Keep title | `Test it in private.` + "Put your Double through messy choices…" | `Test it in private.` + "Put your Double through messy choices and see when it acts exactly like you — or nothing like you." |
| **Step 3** | `Enter the Village.` + `Invite-only in beta.` | `Enter your Doubland.` | `Enter Doubland.` + "Bring friends in…" | `Enter Doubland.` + "Bring friends in and see what your Doubles do together. Invite-only in beta." |
| **Amplifier Header** | `Feels real—because it's built from you` | `The version of you that...` | `Alone, your Double is interesting. With friends, it gets dangerous.` | `The version of you that said yes` |
| **Amplifier Body** | `Bring your friends — the plot twists get better fast.` | `Relationships, rivalries…` | `Alliances form. Secrets leak…` | `Bring your friends — the plot twists get better fast.` |
| **Amplifier Card 1** | `Relationships, rivalries, alliances—way more fun…` | — | — | `Relationships, rivalries, alliances — way more fun when it's people you actually know.` |
| **Amplifier Card 2** | `Your Double makes the moves. You watch like it's your favorite show` | — | — | `Your Double makes the moves. You watch like it's your favorite show.` |
| **Amplifier Card 3** | `Highlights you'll want to send to the group chat.` | sharper tone | `Moments so unhinged you'll have to send them to the group chat.` | `Moments so unhinged you'll have to send them to the group chat.` |
| **Safety Header** | `You're in control the whole time` | Keep | `Your Double only goes where you let it.` | `You're in control the whole time` |
| **Safety Subhead** | `It's a simulation, not a contract.` | Keep | `It's a story, not real life.` | `It's a story, not real life.` |
| **Safety Body** | private / who-gets-access / delete | Keep | `Keep it private, choose who joins, delete anytime.` | `Keep your profile private unless you share` + `You decide who gets access to your Village` + `Delete anytime — gone` |
| **CTA Consistency** | Mixed | Standardize `Enter your Doubland` | beta-aware action | **`Create your Double`** (resolved) |
| **Footer Brand** | `Double` | `Doubland` | brand=Doubland / entity=Double | `Doubland.ai` |
| **Footer Tagline** | `Double your squad, watch the chaos` | `Where your "What if?" gets answered.` | keep current | `Double your squad, watch the chaos` |

## A1. Expert consensus (consolidated)
- Support line locked. · Avoid "Double + Doubland" in one short sentence/H1. · "Enter" is the preferred verb (used as Step-3 destination label). · "With friends" must stay (restored in the hero subhead). · Retired vocab: "build", "simulation", "digital twin", "platform" — promoted: "personality twin", "the version of you that…", "in Doubland".

## A2. Resolved open questions
1. Metadata description — locked (Part A §1). 2. Hero CTA — `Create your Double`, with `Watch the season ▸` secondary. 3. Footer tagline — kept `Double your squad, watch the chaos`. 4. Sim player + trailers reference the same season (`sim_id`).
