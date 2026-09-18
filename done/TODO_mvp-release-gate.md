# MVP Release Gate — Telegram Survival Demo (2026-06-04)

> **Goal:** Turn the 300-person Telegram alumni group (founders / VCs / corporate leaders) into the primary fundraising wedge by running 15 AI doubles through a Survival season and posting daily video updates — proving magnetism + inbound "build one for my group" demand.
> **Window:** ~3–4 weeks (3-sim hardening + season execution). Consent: **manual claim/remove** in group chat — no product build.
> **Decision:** Ship the demo scoped to the current 3.8 GB hardware (~3 concurrent sims). Enhanced landing B2B capture + Option 1 CTA routing. **Not** full self-serve paid onboarding or 10+ sim scale. This is the release that makes 13 months of foundational work count.
> **Status:** Strategy locked in `20260603_VC_prep.md` §8 (implementation updates). Landing spec v8 §6 + CTA behavior + Option A copy implemented. **Simulation-binding wizard shipped (2026-06-08)** — operator can assign job + home per Double (CLI + REST; `sot_lifecycle.md` §6.10). **3-sim hardening complete (2026-06-10):** Item 1 H0 + Item 1.5 VPS soaks passed · Item 2 BE cap + queue deployed (`railway` `e47e08ae`) with `queued_at_capacity: true` proof on VPS. **P0 reliability spine closed** — season execution is next. Technical scope from `TODO_production_hardening.md` MVP section (top of file).

---

## 0. TODO Index (P0 / P1 split)

**Doc shorthand:**
- **hardening** = `D:\Coding\double-docs\TODO_production_hardening.md` (MVP section at top for 3-sim scope)
- **landing v8** = `D:\Coding\double-docs\landing\20260603_landing-page_v8.md` (§6 B2B capture, CTA behavior, Option A copy)
- **VC prep** = `D:\Coding\double-ivan\20260604_VC_prep.md` (the play, consent triage, metrics, §8 implementation log)
- **lifecycle §6** = `D:\Coding\double-docs\sot\sot_lifecycle.md` §6 (simulation-binding wizard — job + home assignment)

**Owner tags:** *(Ivan)* = Ivan keeps · *(Nicolas / FE)* = frontend/landing · *(BE team)* = backend/orchestrator · *(Ops)* = consent, cohort, posting.

### P0 — Must ship for demo launch (the measurement + reliability spine)
| # | Item | Owner | Ref |
|---|------|-------|-----|
| *Nicolas* | **Run 15-person Survival season** — daily videos, per-subject shareable clips (vertical), tracked deep-links, manual inbound logging | Ivan / Ops | VC prep §1 "The play", §4 "Tier 1", §8 "Content engine" *INCLUDE DEEP LINKS TO DESC* |
| *Nicolas* | **Source tagging on every CTA / deep link** (`?source=tg-survival-dayN`, `footer-b2b`, etc.) + funnel readout (views → clicks → signups by source + interest_type) | Nicolas + BE | landing v8 §6 "Tracking & attribution" + VC prep §3 "Metrics that matter" |
| ✅ | **DONE (2026-06-09)** — **Prod frontend build for headless (H0)** — `double-front` `main` on VPS (`21371fa`); prod `next start` + systemd `double-front.service`; **3×5 + 3×100 VPS soaks passed** (4/4 headless reports/step, no OOM). | Nicolas / FE + Ivan / BE | `20260608_FE_MVP_hardening.md` item 1 · `20260609_vps_generation_deploy_topology.md` |
| ✅ | **DONE (2026-06-09)** — **Reuse Playwright tab per sim (Item 1.5)** — `HEADLESS_TAB_REUSE=true` on VPS; A/B/C soaks passed (`boot_ms→0` steps 2+; 3×100 final). | Nicolas / BE | `20260608_FE_MVP_hardening.md` item 1.5 |
| ✅ | **DONE (2026-06-10)** — **Enforced 3-sim cap + overflow queue (Item 2)** — `MAX_CONCURRENT_SIMS=3` on VPS; 4th API start `queued_at_capacity: true`; `COMPLETED.json` mkdir fix shipped. BE `e47e08ae` / FE `21371fa`. | Ivan / BE | `20260608_FE_MVP_hardening.md` item 2 · `scripts/signoff/item2-queue-20260610-meta.json` |
|✅| **DONE (2026-06-05)** — **Landing §6 B2B capture** — two micro-buttons in footer (`Stay updated` / `Bring this to my group`), enhanced waitlist form with `source` + `interest_type` + optional `group_name` | Nicolas | landing v8 §6 "Footer treatment" + "Form payload" |
|✅| **DONE (2026-06-05)** — **CTA destination change (Option 1)** — all CTA buttons open §6 form (`interest_type = generic`); B2B button pre-selects `b2b_group`. **Note: CTA copy changed to "Request your invite for limited roll-out" — diverges from the locked "Create your Double" verbatim decision (items 3 & 5/§2 row 3); confirm intentional.** | Nicolas | landing v8 "Primary CTA behavior" decision + §6 |
|✅| **DONE (2026-06-05)** — **Email form line to Option A** — "Request Doubland for your team or group — or just stay in the loop." | Nicolas | landing v8 (implemented per user confirmation) |
|✅| **DONE (2026-06-08)** — **Simulation-binding wizard** — operator assigns each Double a personality-matched **job** + **home** via guided host (CLI + REST; `onboarding_host.py` + gateway routes). Validated on 4-double fork; idempotent finalize. **Unblocks** placing the 15-person cohort. Deferred: sim-only goal slot, operator UI screen. | Ivan / BE | `sot_lifecycle.md` §6.5–§6.10 · VC prep §6.B "Prepare the run" (provisioning spine) |
| ✅ | **LOCKED (2026-06-08)** — **Consent / claim / remove — manual, 0 build** — launch sim for group review; post states coincidences are accidental + **"Claim double / Remove double"** in chat. **Claim:** member contacts Ivan → manual account link + optional profile tune via scripts. **Remove:** Ivan removes from sim + flags withdrawn (skip future videos). No self-serve claim UI for MVP. | Ivan / Ops | VC prep §5 (supersedes triage-first recommendation) · §4 below |
| DROPPED | ~~**Trailer mutual-exclusion guard**~~ — Trailers now render on Ivan's local machine off Supabase records, so they can't contend with server sims. No guard needed. | — | `20260608_FE_MVP_hardening.md` "Trailers (out of server scope)" |

### P1 — Only if P0 is stable (multiplies engagement)
| # | Item | Owner | Ref |
|---|------|-------|-----|
| 10 | **Per-subject shareable clips packaged** (vertical 9:16, end-card CTA, forwardable "your double's day") | Nicolas / Ops | VC prep §4 "Tier 2" |
| 11 | **Serialized show quality spike** (continuous narration, cliffhangers, season arc) — only if daily-return retention is the gap | Ivan | VC prep §4 "Tier 2" |
| 12 | **Persona fidelity in Survival** (outcomes reflect known traits) — only if "that's so them" is landing weakly | Ivan | VC prep §4 "Tier 2" |

**Deferred (post-MVP, explicit scope guard):** Full self-serve paid "own doubland" flow, 10+ concurrent sims, browser-free realization (§3.2 in hardening), interactive voting, **self-serve claim/remove UI + auth** (magic-link claim, in-app tune/delete), **self-serve** onboarding quiz rework (Phases A–C in `sot_lifecycle.md` §6.2). Operator simulation-binding (Phase D) is **in scope and shipped** — not deferred. See VC prep §8 "Scope guard".

---

## 1. Strategic Frame — Why this package makes 13 months count

**The unique asset:** 300-person Telegram alumni group (founders, VCs, corporate leaders). Warm, dense, high-value network. Zero paid acquisition. The 15 doubles become the distribution engine.

**The wedge:** Community/B2B pull. Hero metric = inbound "build one for my group/company" requests from named founders/VCs. The demo proves magnetism (completion rates, forwards) and demand intensity (quotes beat numbers at this scale).

**Why 3-sim scope (not 10+ or full paid self-serve):**
- Hardware reality: current 3.8 GB box holds ~3 concurrent sims (measured ~0.8 GB peak per sim). 10 requires ~16 GB or browser-free path (4–6 weeks FE, parity risk).
- Onboarding friction: app.ondouble.com quiz is cumbersome; no clean port to doubland.ai. The demo uses pre-known profiles — bypasses this.
- Backend limits: multi-tenant concurrent sims is substantial (see hardening full doc). 3-sim MVP is the sized-down slice that ships reliably.
- Landing + B2B capture already done (v8 §6 + Option 1 + Option A). Measurement layer is days, not weeks.

**The release that counts:** One clean, instrumented demo that turns the Telegram group into both VC proof ("they asked us") and early paid-customer language. Strong inbound gives optionality — raise on demand signal, build paid tier (daily trailers + own village), or both. No dilution of focus.

---

## 2. The Decision Gate (locked)

| # | Item | Decision | Why / Ref |
|---|------|----------|-----------|
| 0 | Release vehicle | **Telegram Survival demo (15 doubles)** | Unique warm network; zero acquisition cost; inbound B2B is the money slide. VC prep §1 |
| 1 | Technical scope | **3 concurrent sims on current 3.8 GB box** | Matches measured hardware; prod FE build + enforced 3-sim cap. Trailers render off-server (local, off Supabase) — no on-box trailer contention. hardening MVP section |
| 2 | Landing / funnel | **Enhanced waitlist with B2B capture (§6)** + Option 1 CTA routing + Option A copy | Two micro-buttons, `interest_type` segmentation, source tagging. landing v8 §6 + Decisions |
| 3 | CTA text | **"Create your Double" kept verbatim everywhere** | Brand continuity; only destination changes to §6 form. landing v8 "CTA text remains unchanged" |
| 4 | Email form line | **Option A implemented** ("Request Doubland for your team or group — or just stay in the loop.") | Makes request capability unmistakable. landing v8 (user confirmation) |
| 5 | Distribution | **Native Telegram vertical clips + tracked links to play page** | Reach (in-feed) + analytics (deep links). VC prep §6 "Distribution" |
| 6 | Consent | **Group-review launch + manual claim/remove** — post "Claim double / Remove double"; Ivan handles in background (0 build). Incidental-disclaimer framing in post. | Fast opt-out without product scope; claim via email/DM. VC prep §5 (triage deferred) |
| 7 | Paid tier | **B2B interest flag in form from day one** | Revenue scaling path + "willingness to pay" signal without building full paid product yet. VC prep §8 |
| 8 | Scope guard | **No Tier 2/3 until base play numbers justify** | Serialization, persona fidelity, interactive voting deferred. VC prep §4, §8 |

---

## 3. Technical Scope — 3-Sim MVP (reference hardening.md)

**Hardware binding constraint (measured 2026-06-04):** 4 vCPU / 3.8 GB no-swap VPS. One real sim peaks ~800 MB RSS. Realistic cap = **3 concurrent sims** (tight but workable; 4 = OOM risk).

**MVP items (already verified in place or small):**
- Unattended launch + orchestration (`reverie.py <origin> <target>` + `POST /api/simulations/{sim_code}/start`).
- Supabase-first canonical state (`SUPABASE_ONLY_MODE=true`).
- Simulation-binding host — operator assigns job + home per roster Double (`ENABLE_ONBOARDING_HOST`; CLI + `GET/POST /api/onboarding/{sim}/…`). Drives lifecycle §1 steps 4–6.

**P0 engineering (the blocker list — reduced 2026-06-08, trailers moved off-server):**
- H0: Prod frontend build (`next build && next start`) + drop `Cache-Control: no-cache` on Playwright navigations. **DONE** — VPS soaks 2026-06-09 (`21371fa` FE, systemd `:3000`).
- Item 1.5: reuse Playwright tab per sim. **DONE** — `HEADLESS_TAB_REUSE=true`; 3×100 VPS soak passed 2026-06-09.
- Enforced 3-sim cap + overflow queue (sims-only). **DONE** — VPS queue proof 2026-06-10 (`e47e08ae` BE; `queued_at_capacity: true`).
- Per-subprocess `FRONTEND_URL` not needed for 3 sims (one frontend backs 3 contexts safely per FE §7 Q2).
- ~~Trailer mutual-exclusion guard~~ — **dropped:** trailers render on Ivan's local machine off Supabase records (`video/extract_day_log.py` reads from Supabase, not server disk), so they never contend with server sims.

**Deferred:** Per-subprocess `FRONTEND_URL` override, browser-free realization (parity risk, 4–6 weeks), 10-sim upsizing, on-server trailer rendering / shared render tier.

**Reference:** `20260608_FE_MVP_hardening.md` (Items 1 / 1.5 / 2 **closed** 2026-06-10) · `TODO_production_hardening.md` MVP section.

---

## 4. Content & Cohort Plan

**15 doubles** of the group's most-active members → Survival season → daily video updates posted in the group.

**Per-subject shareable clips** (vertical, "your double's day") so each subject can forward to their networks = reach multiplier.

**Daily logging:** YouTube completion (free), in-group reactions/forwards (manual tally), every "can I get one for my X" quote screenshot-attributed to episode.

**Consent (locked 2026-06-08):** Surprise launch for group review — **not** triage-first. Launch post includes incidental-disclaimer framing (*coincidences are accidental*) plus **"Claim double / Remove double"** in the Telegram chat. All handling is **manual operator** (no claim/remove product for MVP).

**Operator runbook (Ivan):**
1. **Claim** — member DMs/emails → identify their double → manually link account (`dbl_agent`) → tune profile via existing scripts if they send corrections.
2. **Remove** — member DMs/emails → remove persona from Survival sim → flag **withdrawn** so future daily videos skip them (honor within ~24h).
3. Keep portrayals affectionate/flattering; removals are no-questions-asked.

**Season length / cadence:** TBD in open decisions (how many days, posting frequency).

**Reference:** VC prep §1 "The play & why it works", §4 "Tier 1", §5 "Privacy & consent", §6 "Action plan B. Prepare the run".

---

## 5. Landing & Funnel (reference landing v8 §6)

**Footer treatment:** Keep existing "Stay Connected" block. Add two side-by-side micro-buttons (or segmented pill) directly under it:
- `Stay updated` → `interest_type = generic`
- `Bring this to my group` → `interest_type = b2b_group` + optional "Group / company" field

**Form payload (extend existing `POST /api/waitlist`):** `email`, `source`, `interest_type`, `group_name` (optional). No new endpoint or UI states.

**Tracking:** Every CTA and deep link carries `source` tag. Form submission passes current `source` + chosen `interest_type`. Result: every waitlist row tells exactly which episode/CTA/channel drove it and whether B2B/paid-interest.

**CTA behavior (Option 1):** All "Create your Double" buttons now open the enhanced form (pre-select `generic`). B2B button pre-selects `b2b_group`. Text verbatim everywhere.

**Email form line (Option A implemented):** "Request Doubland for your team or group — or just stay in the loop."

**What this unlocks:** Funnel readout (views → clicks → signups by source + interest_type). Direct "money slide" data: count of `b2b_group` submissions + group names. Zero extra design surface.

**Reference:** landing v8 §6 (full spec), "Primary CTA behavior" decision, "CTA text remains unchanged" bullet.

---

## 6. Success Metrics (the four "money slides" from VC prep §3)

1. **Magnetism / completion** — % who watch each 60–90s episode to the end (YouTube free). High vs. ~50–60% norm.
2. **Spread** — people reached + forwards/shares with zero ad spend. "One group of 300 → reached N via M forwards."
3. **Conversion funnel** — views → clicks → signups, plotted against episode drops (now measurable via source tags).
4. **Inbound demand (the closer)** — unsolicited "can you build one for my community / company / portfolio?" requests, logged + screenshot-attributed. Quotes beat numbers.

**If full multi-day season:** Daily-return retention (day-5 viewers come back from day-1).

**Ignore (vanity):** Raw view count, total reactions, follower count (small at this scale).

---

## 7. Open Decisions Needed from Ivan (VC prep §7)

- ~~**Consent / rollout:**~~ **LOCKED** — group-review surprise launch; manual claim/remove via chat (§4 operator runbook).
- **Season length / cadence:** how many days, posting frequency.
- **Distribution:** confirm native-Telegram-vertical **+** tracked-link (vs. YouTube-link-only).
- **Scope guard:** agree to *not* build Tier 2/3 until base play's numbers justify it.

---

## 8. Lock & Change Policy

This gate is locked under the 2026-06-04 revision. Changes require explicit decision and re-statement here. New ideas during execution go to `!next.md` post-MVP unless they pass this bar:

> *"This change makes the Telegram demo + B2B inbound signal more undeniable for the raise or materially improves 3-sim reliability."*

Anything else is noise.

---

**End of MVP Release Gate.** All prior strategy (VC prep §1–7) and landing spec (v8 §1–5) remain authoritative. This document is the execution spine with clear TODOs and cross-references.

**Current status (2026-06-10):** **P0 reliability spine closed.** Items 1 (H0), 1.5 (tab reuse), and 2 (sim cap + queue) validated on VPS `199.80.55.26`. Measurement layer + CTA routing complete in landing v8. **Simulation-binding wizard shipped** — cohort can be placed (job + home). **Consent locked** — manual claim/remove, 0 build. **Next:** 15-person Survival season (P0 row 8) + attribution (row 9) + open cadence decisions (§7).

### Progress log

| Date | Who | What |
|------|-----|------|
| 2026-06-05 | Nicolas | Landing §6 B2B capture, Option 1 CTA routing, Option A copy — shipped |
| 2026-06-05 | Nicolas | Item 1 FE on `double-front` `main` (`544f288`); paired BE changes local; local smoke ~1.1 s/step |
| 2026-06-08 | Nicolas | Reviewed `20260608_FE_MVP_hardening.md` — scope clear and feasible; documented Item 1.5 |
| 2026-06-08 | Ivan + Nicolas | Agreed: VPS soak first → Item 1.5 → Item 2. BE deploys from `BE/vercel`; Ivan to share VPS credentials |
| 2026-06-08 | Ivan | Simulation-binding wizard shipped (`sot_lifecycle.md` §6.10) — job + home assignment via guided host; validated on 4-double fork |
| 2026-06-08 | Ivan | Consent approach locked — group-review launch; "Claim double / Remove double" in chat; manual operator runbook (0 build); triage-first deferred |
| 2026-06-09 | Nicolas | Item 1 H0 + Item 1.5 VPS soaks passed (3×5 + 3×100); Ivan production-generation sign-off `signoff-20260609-2350` |
| 2026-06-10 | Ivan | Item 2 deployed on VPS (`549d2d41`→`e47e08ae`); queue proof `queued_at_capacity: true`; `COMPLETED.json` mkdir fix; soak script + sign-off meta committed |