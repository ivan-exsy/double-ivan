# UX + COS brief: Landing page — what’s live today

**Audience:** External UX / COS partners building the durable UX knowledge base  
**Product:** Doubland marketing landing (`double-landing-page`)  
**Owner:** Product / Eng (Ivan)  
**Date:** 2026-07-21  
**Status:** Snapshot of **production as shipped**, not aspirational docs  
**Verified:** Live HTML fetch of `https://www.doubland.ai/` → `data-landing-version="2"`

---

## Quick facts

| Item | Answer |
|------|--------|
| **Production URL** | https://www.doubland.ai/ |
| **Legacy redirects** | `www.ondouble.com` / `ondouble.com` → `www.doubland.ai` (308) |
| **Default version** | **v2** (confirmed live) |
| **v3 status** | Labeled FINAL in code; **dev-only preview** (not reachable in prod) |
| **Copy SOT (live)** | `lib/landing-copy-v2.ts` (+ shared strings from `landing-copy-v1.ts`) |
| **Doc SOT (aspirational)** | `double-docs/landing/20260603_landing-page_v8.md` + `20260604_brand.md` |
| **Deploy branch** | `main` → Vercel auto-promote |
| **Last ship on main** | 2026-07-21 (`6fe149e` — v2 episodes mobile polish) |
| **Figma** | **N/A** (no linked production Figma in repo/docs) |
| **Screenshots / Loom** | Not attached in this pass — ask if needed |

---

## A. What’s live right now

### 1. URLs

- **Production:** https://www.doubland.ai/
- **Also:** https://www.ondouble.com → 308 → doubland.ai  
- **Staging / preview:** Vercel preview URLs per PR/branch (project: `https://vercel.com/exsy/v0-landing-page-for-double`). No separate always-on staging hostname documented.
- **Local preview:** `http://localhost:3001` (`pnpm dev`)

### 2. Default version

**Confirmed: users see v2.**

- Code: `resolveLandingVersion` returns `"2"` when preview is off (`lib/landing-versions.ts`).
- Prod HTML: `class="landing-variant landing-variant--v2" data-landing-version="2"`.
- v3 is described as “Merged hero (FINAL)” in code comments, but is **not** production default.

### 3. How to force other versions

| Mechanism | Who can use it |
|-----------|----------------|
| `?v=1` / `?v=2` / `?v=3` | **Localhost + `next dev` only** |
| `/v/1`, `/v/2`, `/v/3` | Same — redirects to `/?v=N` in dev; **redirects to `/` in production** |
| Env flag | None for version switching. Gate is `NODE_ENV === "development"` + localhost host (`lib/landing-dev.ts`) |

In production, middleware **strips** `?v=` and **blocks** `/v/*` → always v2.

### 4. Deploy branch / last ship

- **Branch:** `main` (auto-tracked by Vercel).
- **Last commit on `main`:** 2026-07-21 — v2 episodes carousel mobile styles; prior 2026-07-20 Screening Room / footer / how / world polish wave.
- README still says “Redeployed by Ivan: 20260616” for an older sim-share redeploy note — **treat git `main` date as ship truth**, not that README line.

---

## B. Page map (as shipped — **v2 live**)

Ordered from top of viewport:

| # | Section | DOM / component | Purpose | Primary CTA | Destination |
|---|---------|-----------------|--------|-------------|-------------|
| 0 | Fixed header | `SiteHeader` | Brand + nav + invite | **Request early invite** | Scroll + focus `#stay-connected` |
| 1 | Hero (pinned full-bleed) | `HeroSection` in `.hero-pin` | Promise + atmosphere | **Request early invite** | `#stay-connected` |
| 2 | Live Sim | `HookSection` `#live-sim` | Proof: live world embed | In-player controls (“Press play”, fullscreen) | iframe → `double-front` sim |
| 3 | Episodes / trailers | `EpisodesSection` `#episodes` | Daily trailer rail | Play selected YouTube clip | YouTube embed (same page) |
| 4 | How it works | `HowItWorksSection` `#how-it-works` | 3-step storyboard | **Request early invite** | `#stay-connected` |
| 5 | In Doubland / world | `VillageWorldSection` `#world` | Feature tiles (gallery + modal) | **Request early invite** | `#stay-connected` |
| 6 | Footer / waitlist | `Footer` `#stay-connected` | Email capture + trust + social | Submit email | `POST /api/waitlist` (no quiz / app handoff) |

Nav order (v2): Live Sim → Episodes → How It Works (+ invite CTA).

### 7. Mobile vs desktop (v2)

- **Hero:** full-viewport pinned image; content bottom-left; “SCROLL” cue. No sticky bottom CTA bar.
- **Header:** desktop inline nav + invite; mobile hamburger + invite in menu.
- **Live Sim / Episodes / How / World:** responsive layout; several sections use **mobile vs desktop line breaks** for titles (copy modules with `*LinesMobile` / `*LinesDesktop`).
- **Episodes:** Embla carousel; recent work specifically on v2 mobile carousel styles.
- **Hero pin:** desktop/mobile both use fixed hero with content scrolling over cream `#page-scroll` (parallax-style pin, not a separate sticky CTA).
- **Player:** live sim is iframe; YouTube in episodes is click-to-select embed (not autoplay hero video).

### 8. Known incomplete / placeholders

- Hero **video** not shipped — still image `/hero-village-overhead.png`; code comments reserve a sound-toggle slot for future video.
- `APP_URL = https://app.ondouble.com/` exists in `lib/palia.ts` but is **not wired** as CTA destination.
- Episode **ghost / locked** cards for unreleased days (“tonight, 6:30 PM” / “Coming soon”).
- v1 / v3 layouts exist in codebase but are **preview-only**.
- Footer Support link still points to `https://x.com/ondouble` (legacy handle).

---

## C. Copy & brand SOT

### 9. Live strings SOT

**Live = code, not docs.**

| Layer | File |
|-------|------|
| **Production strings** | `double-landing-page/lib/landing-copy-v2.ts` |
| Shared body / steps / footer base | `lib/landing-copy-v1.ts` (imported by v2) |
| Draft FINAL hero (not live) | `lib/landing-copy-v3.ts` |
| Spec / brand docs | `double-docs/landing/20260603_landing-page_v8.md`, `20260604_brand.md` |

### 10. Hotfix list (live ≠ locked doc)

| Surface | Docs (v8) say | Live v2 says |
|---------|---------------|--------------|
| Hero / nav / How / World CTAs | `Create your Double` | **`Request early invite`** |
| Episodes H2 | “Your story plays out live” (v1) / rail label for v3 | **`Daily Trailers`** |
| Episodes sub | longer “Trailers are the highlights…” | Shorter: “Videos are the highlights of the day. Zoom into details in Doubland.” |
| World H2 | features triad | **`Explore Doubland your way`** |
| Footer heading | “Request Doubland for your team or group — or just stay in the loop.” | **`Request Doubland for your group. Receive early invites and updates.`** |
| Step titles | still “Create your Double” etc. | **Same as docs** (step labels unchanged; only button CTAs differ) |

### 11. Locked vocabulary on-page today

- **Doubland** — product/place brand (wordmark, live header, copyright `doubland.ai`).
- **Double** — personality twin (hero sub, steps, tagline “What would your Double do?”).
- **Create your Double** — still used as **step 1 title** and in how-it-works storyboard; **not** the primary button label on live v2.
- **Village** — soft / in-world flavor only where copy allows; live framing prefers **Doubland** (`brand.md`).
- **Exceptions on live:** CTA = **Request early invite** (invite framing, not create-flow framing).

### 12. Figma

**N/A / unknown.** No production Figma URL in landing repo or `double-docs/landing/*`. Design refs are ChatGPT / Dribbble moodboards in `design-language.md`, plus “Screening Room” CSS system in code (Fraunces + IBM Plex Mono).

---

## D. Interaction & media

### 13. Hero media

- **Image** (full-bleed overhead village still), not video.
- No autoplay. Future plan documented in `hero-section.tsx`: swap to muted looping `<video>` with same still as poster; sound toggle slot reserved (`hidden`).

### 14. Season / episode rail

- **Data:** `GET /api/youtube-playlist` when `YOUTUBE_API_KEY` set; else committed `data/landing-episodes.manifest.json`.
- Hook: `hooks/use-youtube-playlist.ts` — falls back to static manifest on error.
- Locked / unreleased days show ghost cards with “Coming soon” / tonight labels.
- Featured / playlist order per v8 decisions (playlist `PLeAjE_puY2jG1CTg3WZn6xTet6W1H69-R`).

### 15. Waitlist / “Create your Double” handoff

- All primary CTAs → **scroll to footer** `#stay-connected` + focus email (`WaitlistProvider.openWaitlist`).
- Submit → `POST /api/waitlist` → API gateway → Supabase `double.waitlist`.
- Optional group + “Tell us more” after email typed.
- **No auth, quiz, or app redirect** on success. Success is in-page form state only.
- Self-serve Double / onboarding lives elsewhere (product backlog; not this page’s next screen).

### 16. Share / UTM / referral

- Inbound `?source=` captured once (sessionStorage), sent with waitlist (`double-docs` link-tracking Slice 2; default source `landing-hero`).
- Sim deep links: `?sim=&t=&double=&zoom=&focus=&source=sim-share#live-sim` (Slice 6) — copies canonical landing URL when embed posts `landing-share`.
- No classic UTM parser called out in landing code (source tag is the attribution mechanism).

---

## E. Analytics & experiments

### 17. Events

- **Vercel Analytics** + **Speed Insights** in root layout (`app/layout.tsx`).
- **No custom** CTA / play / scroll-depth / waitlist event layer found in components (no PostHog/gtag custom events in repo).
- Waitlist success is server-side DB write; product analytics beyond Vercel defaults = **unknown / not instrumented in FE**.

### 18. Funnel numbers

**Unknown** from this codebase. Check Vercel Analytics dashboard + Supabase `double.waitlist` counts separately.

### 19. A/B / version tests

- **None running in production.** Version switching is gated off outside localhost.
- Historical layout experiments (v1 / v2 / v3) remain as code variants for local review only.

---

## F. Accessibility, performance, constraints

### 20. A11y

- **No formal audit recorded** in repo. No WCAG target documented for the landing.
- Some good patterns: `sr-only` labels on footer fields, aria on world tiles / menus, reduced-motion CSS blocks.
- Known soft spots: decorative images with empty `alt`; iframe embed a11y depends on sim FE.

### 21. Motion / reduced-motion

- `SmoothScroll` **disables** custom anchor easing when `prefers-reduced-motion: reduce`.
- Multiple `@media (prefers-reduced-motion: reduce)` blocks in `globals.css` / cinematic CSS.
- Reveal-on-scroll animations used heavily on v2 polish (should respect reduced-motion via CSS).

### 22. Performance

- No documented Lighthouse budget in repo.
- Mitigations: preconnect to sim + YouTube nocookie; dynamic import for world section; hero `priority` image.
- Heavy costs: live sim iframe + YouTube embeds (expected).

### 23. Hard technical constraints

- Live proof = **iframe** embed of `double-front` (`NEXT_PUBLIC_SIM_BASE`, default `https://double-front.vercel.app`).
- Waitlist = **gateway proxy**, not direct Supabase from browser.
- Episode rail = YouTube playlist / manifest.
- Version preview cannot be demoed to external stakeholders via production URL (must use Loom/local/Vercel preview with care — preview deploys also run `NODE_ENV=production`, so `?v=` may still be blocked unless a special override is added).

> **Important for UX demos of v3:** production and typical Vercel preview builds will force v2. To show v3, use local `pnpm dev` or change the preview gate (eng change).

---

## G. Decisions & backlog

### 24. Rejected / superseded (short)

- Static v2 image hero was **temporary**; v8 marks it superseded by **v3 merged trailer hero** — but v3 not promoted.
- Direct app/quiz CTA as primary path — rejected for now; waitlist-only.
- Em-dash heavy chrome — prefer middle dot `·` in live/status copy.
- Cohort-specific names (e.g. Survival cast) — trailer-only, not landing chrome.
- Path B designs that made transcript/sidebar primary for chat are out of scope for *landing* (separate Doubland viewer UX work).

### 25. Near-term (next 2–4 weeks) — from product notes

From `double-ivan/20260720_launch.md` + landing reality:

- Website redesign / cinematic “movie about me” direction (aligns with Screening Room + eventual v3).
- Daily trailer automation pipeline.
- Self-serve Double / auth onboarding (product), not yet landing CTA destination.
- Possible promote of **v3** once ready — currently FINAL in docs, not live.

### 26. Open questions for UX input

1. Should primary CTA stay **Request early invite** or return to locked **Create your Double** before v3 ship?
2. Is **Daily Trailers** the right episodes framing vs “Your story plays out live” / v3 rail “This season in Doubland”?
3. When to promote **v3** (trailer-as-hero) vs polish current Screening Room v2?
4. Hero: ship muted looping concept video now, or wait for opening-trailer pipeline?
5. Waitlist → what is the **first post-submit** experience UX wants (confirmation only vs soft onboarding tease)?
6. How should external partners **preview v1/v3** without localhost (preview env gate)?

---

## Ideal attachments (not included here)

- [ ] Desktop scroll Loom (~2 min) of https://www.doubland.ai/
- [ ] Mobile scroll Loom
- [ ] Optional: localhost `?v=3` Loom labeled **draft / not live**

---

*Engineering refs: `components/landings/landing-page.tsx`, `lib/landing-versions.ts`, `lib/landing-dev.ts`, `middleware.ts`, `lib/landing-copy-v2.ts`.*
