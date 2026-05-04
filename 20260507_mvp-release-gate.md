# MVP Release Gate — 10-Day Sprint

> **Goal:** Demonstrate fundraising-grade traction for Double.
> **Window:** ~10 days.
> **Decision:** Ship **Survival-mode-only** with one undeniable live cohort. Not a public launch. **Adult friend teams only.**
> **Status:** Locked 2026-04-28 (Will Wright + Andrew Chen + Nir Eyal + Burnett / de Mol / Parsons advisor pass). **Revised 2026-04-29 — scope reduction:** distribution moves to YouTube; in-app daily loop (receipt cards, motive prediction, evening drop, native social share) cut to post-MVP. The trailer is the product surface; the YouTube channel is the demo.

---

## 0. TODO Index

> Brief scan of what's still open. Full detail lives in §7 (engineering), §6 (recruiting), §11 (risks).
> Doc shorthand:
**video PRD** = `D:\Coding\double-docs\20260429_PRD_video_pipeline.md`
**survival upgrade** = `D:\Coding\double-docs\20260428_survival_upd.md`
> Owner tags: *(Ivan)* = Ivan keeps · *(Nicolas)* = delegated to Nicolas (full implementation brief at `D:\Coding\double-docs\20260507_nicolas-mvp-gate.md` — **needs corresponding revision after this scope cut**) · *(Ops)* = non-engineering, named cohort-team owner.

**P0 — must ship (the demo spine):**
*(Ivan)*
✅ Survival run validates end-to-end (Stage 3 Day-2 retrieval fix + acceptance smoke) — §7 #1 · survival upgrade §3 Stage 3
🟡 **Sim-day-overview trailer pipeline** (video PRD §4.3) — §7 #2
3. **Opening / intro trailer pipeline** (video PRD §4.2) — §7 #3
6. **YouTube workflow** — channel curated; description-block generator emits trailer copy + timecode deep-link list ready to paste — §7 #6

*(Nicolas)*
4. **Time-code deep links + Play mode** (`https://doubland.ai/sim/{code}/play?t=&double=&zoom=&focus=`, opens in new window in full-screen Play mode) — §7 #4, §5
5. **Founding Host waitlist landing** (`doubland.ai/waitlist`, captures cohort intent + master-user tier of 5-15 friend commit) — §7 #5

**P1 — only if P0 is stable:**
*(Ivan / Ops)*
7. Cohort activation (1 fully activated Survival cohort: 8-15 adults, ≥2 sim-days, ≥2 trailers on YouTube) — §6, §10

*(Nicolas / Ivan)*
8. Minimal trailer quality gate — duration + 9:16 readable + end-card present *(Nicolas)* — §7 #7 · video PRD §3 TODO-5/6
9. Chat memory persistence end-to-end (`movement.chat` → `dbl_memory` gap) *(Ivan)* — §7 #8 · video PRD §3 TODO-2b — keep deferred unless the survival smoke surfaces it

**Top risks to clear day 1:** Survival Day-2 retrieval (Fix 2 verification + acceptance smoke) · sim-wide trailer scope is real engineering, not trivial polish · YouTube discoverability vs. shared-link conversion. — §11

P2 polish (§7 #10-13) and explicit cuts (§8) are not duplicated here.

---

## 1. Strategic Frame

**Survival mode is the *only* sim format for MVP.** Standard / free-flow simulation ships post-MVP.

Why Survival: the reality-TV format (HOOK → COALITION → VOTE → STINGER) is shipped in the trailer pipeline. Pressure events are intrinsic — challenges and vote-outs guarantee drama every sim-day. Viewers already understand the format, which makes the trailers instantly legible.

The atomic network unit is **an 8-15 person adult friend cohort**, not an individual user. The milestone is not "open launch" — it is **one fully activated Survival village + visible recruiting motion + a public YouTube channel with the trailers it produces**.

The investor sentence we need them to feel:

> "Oh — this would not work as a solo app. The social graph is the product."

**Audience for MVP:** adult friend teams. Teen audience and the consent / parental-permission gates that opens up are explicitly post-MVP (see §8 and §11).

---

## 2. The Decision Gate (resolved)

| # | Item | Decision | Why |
|---|---|---|---|
| 0 | Sim format | **Survival only** | Built-in pressure → strategy → vote-out → trailer. Free reality-TV format. |
| 1 | Trailers per sim-day | **One** | Will + Nir converge: one trailer is a "trophy of emergence." Two trains a feed mindset. |
| 2 | Distribution surface | **Public YouTube channel** ([@doubland-ai](https://www.youtube.com/@doubland-ai)) | Single hosted surface; captures all trailers; descriptions carry timecode deep-links; no app push infrastructure needed. **The trailer is the product surface in MVP.** |
| 3 | Conversion mechanism | **Time-code deep links in YouTube descriptions** | Viewer taps timecode → lands in sim viewer Play mode → soft waitlist gate. This is the *only* conversion path in MVP scope. |
| 4 | CTA | **Founding Host waitlist** | Capture *cohort intent*, not individual intent. "Master users" who commit to bringing 5-15 friends earn priority. Skip the fork-your-own-sim infra. |
| 5 | In-app daily loop (receipts / motive prediction / evening drop / native social share) | **Cut to post-MVP** | These existed to power a nightly episode loop *inside the app*. With YouTube as the distribution surface, none of them are on the critical path. The trailer + the description + the waitlist ARE the loop. |
| 6 | Invite-only + referral rewards | **Policy only, no rewards engine** | Founding Hosts earn invite codes. Defer the kudos / perks economy. |

---

## 3. The Distribution Loop

**North Star sentence (revised):**
*Each completed sim-day produces one episode trailer on the doubland.ai YouTube channel. Anyone watching can tap a timecode in the description and land at the exact moment inside the live sim viewer. From there, they join the Founding Host waitlist if they want it for their own crew.*

The full loop, six beats:

1. **Cohort runs Survival sim** — onboarded by a Founding Host; sim runs daily.
2. **End-of-sim-day trigger** — completed day produces the source artifacts (movement, scratch, chats, memories).
3. **Trailers auto-generate** —
   - **Opening trailer** once per sim (Day-0 cast intros + stakes; ~2:30, character-led).
   - **Sim-day-overview trailer** for each completed day (~2:30-3:00, ensemble recap with cliffhanger).
4. **Manual upload to YouTube channel** — generator emits a description block (1-2 sentence summary + timecode list with deep-links + waitlist CTA); operator pastes it in.
5. **Cohort + outsiders watch on YouTube** — subscribers get the bell, non-subs find the channel via shared links, group chats, recruiting outreach.
6. **Time-code → sim viewer → waitlist** — anyone curious taps a timecode in the description, lands in full-screen Play mode at that step with the camera on the right Double, watches the lead-up uncut, hits the waitlist gate.

That's the loop. No app push. No in-app receipt cards. No motive prediction. No second trailer per day. No native social share.

---

## 4. Trailer Narration Discipline (Parsons safe-receipt rule, narrowed)

Trailer narration occasionally surfaces trait-level reasoning ("loyal under pressure — that was Katya's call"). Even with adult friends, surfacing raw insecurities creates exposure risk and breaks the magic. Hard rule, applied to **all trailer narration and description copy**:

> Narration may reference *behavioral tendencies*, not vulnerable confessions, secrets, or humiliating self-descriptions.

| Good (behavioral) | Risky (vulnerable) |
|---|---|
| "socially cautious" | "afraid of being judged" |
| "avoids direct confrontation" | "panics when criticized" |
| "loyal under pressure" | "abandonment issues" |
| "tests new people slowly" | "doesn't trust anyone" |

This rule also constrains the **onboarding quiz** — anything captured may eventually surface in trailer narration visible to the friend group. Keeping this discipline now also makes the eventual teen-audience migration clean.

---

## 5. Time-Code Deep Links (the conversion mechanism)

**Mechanic:** every trailer's YouTube description carries time-stamped links into the live sim player.

> 0:18 — Council vote opens → https://doubland.ai/sim/{code}/play?t=1245&double=Katya&zoom=1.4&focus=hobbs_cafe
> 0:34 — The whisper alliance forms → https://doubland.ai/sim/{code}/play?t=859&double=Ivan&zoom=1.6
> 0:52 — The vote read-out → https://doubland.ai/sim/{code}/play?t=1267&double=Katya&zoom=1.2

**Why this is the centerpiece, not a polish item:**

- **Closes the watch → curious → land → convert loop.** Viewer on YouTube sees a clip → taps timecode → lands in sim viewer → "I want this for my crew" → waitlist.
- **Cheap to ship.** Time markers already exist in `script.json` (`key_steps`); sim player already supports `seekToStep`; mostly URL routing + a small description-block generator.
- **Doubles as Will Wright's "uncut access."** The trailer is the artifact; the sim viewer is the long-form proof that it's real, not scripted.

**MVP scope:**
- **Deep-link URL:** `https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}&zoom={level}&focus={zone_or_xy}` — last two params optional.
- **Click behavior:** opens a **new browser tab** (`target="_blank"`) on `doubland.ai` and lands the visitor in **full-screen Play mode** — no app chrome (navbar / sidebar hidden), immersive sim canvas with a minimal HUD (timestamp, play / pause, exit-to-waitlist CTA). Sim player auto-seeks to the step (`?t=`); camera auto-follows the named Double (`?double=` → `__followPersona(name)` per video PRD §2.5); zoom and focus apply if provided.
- **Play mode** is a third FE mode alongside `?headless=true` (backend simulation) and `?recording=true` (trailer capture).
- **Description-block generator:** small CLI helper that reads `script.json` + sim metadata and emits the YouTube description (summary + timecode list + waitlist CTA). Operator pastes it into YouTube.
- Timecode visitors can watch ±5 minutes around the event, then hit a soft waitlist gate. *(The bounded ±5-min window itself is P2 — see §7 #10.)*

**Out of scope:** highlight reels, scrubbable previews, frame-perfect timing.

---

## 6. Cohort Recruiting Plan (Andrew's funnel)

Run this in parallel with engineering. **Recruiting is half the milestone.**

| Stage | Target | "Done" looks like |
|---|---|---|
| Outreach | 10-15 candidate Founding Hosts | Conversation had, fit assessed |
| Qualified | 5 serious | Named friend group, can name 8+ friends, willing to organize |
| Onboarding | 2-3 in motion | Host onboarded, started inviting |
| **Activated** | **1 full cohort** | 8-15 Doubles created, ≥2 sim-days run *in Survival mode*, ≥2 trailers on YouTube |
| Partial | 1 cohort | Host + 5-8 friends onboarded |
| Pipeline | 1-2 hosts | Confirmed but not yet started |

**Reaction capture (was P0; now optional cheap-Ops):** group-chat screenshots, voice notes, screen recordings. Useful for the investor walkthrough, but no longer the demo's emotional centerpiece — that role now belongs to the **YouTube channel itself**: a public surface with a growing library of real trailers from real friend groups. If a named cohort-team owner has bandwidth to collect reactions cheaply, do it; if not, skip without rewriting the demo narrative.

---

## 7. Engineering Work — P0 / P1 / P2 Split

In strict priority order. **P0 must ship.** P1 ships only if P0 is stable. P2 only if already built or trivially close.

### P0 — The demo spine

*(Ivan)*
1. **Survival run validates end-to-end** *(Ivan)* — close out Stage 3 Day-2 retrieval (Fix 2 runtime verification + acceptance smoke; see survival upgrade §3 Stage 3). The activated cohort runs on a survival build that retrieves prior-day memories and surfaces them in vote / chat prompts. Without this, every trailer downstream is built on a broken foundation. **Stages 4 and 5 already shipped 2026-04-28.**
2. **Sim-day-overview trailer pipeline** *(Ivan)* — implement video PRD §4.3 end-to-end: `extract_day_log.py --mode=day_overview` (1-3 protagonist scoring + shared timeline + trigger-event tagging), `showrunner.py --mode=day_overview` (two-stage spine + scenes), per-scene `__followPersona` switching, council/vote color treatment, "Previously on…" bridge card, runtime cap raised to 180s. **This is the recurring artifact** — one per completed sim day. Build first per video PRD recommendation (highest frequency, validates multi-protagonist extension).
3. **Opening / intro trailer pipeline** *(Ivan)* — implement video PRD §4.2: Day-0 cast scoring (top-6), `extract_day_log.py --mode=opener`, `showrunner.py --mode=opener` (two-pass: 6 cast intros + framing wrapper), name-card overlays, optional anthem track. **One per sim**, kicks off the season.
6. **YouTube workflow** *(Ivan)* — channel curated; description-block generator (small CLI, ~1h) emits markdown for each trailer with summary line + timecode deep-link list + Founding Host waitlist CTA. Operator uploads + pastes description manually. No YouTube API automation in MVP.

*(Nicolas)*
4. **Time-code deep links + Play mode** *(Nicolas)* — full-screen Play mode at `https://doubland.ai/sim/{code}/play?t=&double=&zoom=&focus=`. Sibling to existing `?headless=true` and `?recording=true`. No app chrome; minimal HUD (timestamp, play / pause, exit-to-waitlist CTA). Sim player auto-seeks to the step; camera auto-follows the named Double via `__followPersona(name)`; optional zoom + focus apply on load. See §5.
5. **Founding Host waitlist landing** *(Nicolas)* — single page on `doubland.ai/waitlist`. Form fields: cohort size, friend-group context, willingness to organize, **explicit "master user" tier** (commits to bringing 5-15 friends → priority queue, invite-code allocation). No-code (Tally / Typeform embed) acceptable if it's faster than a thin Next.js page; either way, the page exists at `doubland.ai/waitlist` and is referenced from every trailer description.

### P1 — Stability + cognition depth (only if P0 is stable)

*(Nicolas)*
7. **Minimal trailer quality gate** *(Nicolas)* — `validate_trailer.py` checks duration bounds, end-card presence, and 9:16 readable. *Not* the full battery from video PRD §3 TODO-5/6 — just the three checks where a failure makes the YouTube upload obviously broken. Subtitle timing from real audio (TODO-4) deferred to post-MVP unless current SRT-from-script-offsets visibly slips.

*(Ivan)*
8. **Chat memory persistence end-to-end** *(Ivan)* — diagnose and close the `movement.chat` → `dbl_memory` chat-row gap so Day-2+ Doubles retrieve yesterday's conversations. Trailer extractor is unaffected (reads `movement.chat` directly), but multi-day cognitive continuity for the cohort run depends on this. **Keep deferred unless the survival smoke (#1) surfaces it as a blocker.** See video PRD §3 TODO-2b.

### P2 — Polish (cut unless trivially close)

10. Bounded ±5-min guest sim-viewer context window with waitlist gate *(Nicolas, if attempted)*
11. Founding Host badge on Double card / trailer end card *(Nicolas, if attempted)*
12. Subtitle timing from actual narration audio — video PRD §3 TODO-4 *(Nicolas, if attempted)*
13. Push-notification infrastructure spike — only if YouTube notifications prove insufficient as the cohort signal *(Nicolas, if attempted)*

---

## 8. What's Explicitly Cut (post-MVP, not "ran out of time")

**Cut from the original gate (powered the in-app daily loop, no longer needed with YouTube distribution):**
- Authorship-receipt card UI (explicit → tag → tap-to-reveal cadence)
- Showrunner authorship-receipt JSON constraint (only mattered for in-product receipt rendering; trailer narration discipline in §4 still applies)
- Motive-level prediction widget
- Prediction-resolution opener in next trailer (depended on the prediction widget)
- Lightweight evening drop (push / email / SMS) — YouTube channel + bell IS the drop
- Native social share to 4 platforms (Snapchat / Instagram / X / YouTube Shorts) — YouTube channel replaces this; each platform's audience finds the trailer through the channel or shared links
- Group-chat share buttons (iMessage / WhatsApp / Telegram) — cohort members paste the YouTube URL into their existing chats; rich previews surface natively

**Cut from the original five-decision gate (unchanged from prior revision):**
- Standard / free-flow sim mode (Survival is the only format for MVP)
- Two trailers per sim-day
- Self-serve sim creation / fork-your-own-village
- Referral rewards / kudos / perks economy
- Personality tweaking as a daily input
- Open-text "leave a thought" investment
- Random / dynamic push timing

**Cut from sim-wide trailer scope:**
- **Announce trailer** (video PRD §4.1) — pre-sim hype teaser. Builds excitement before Episode 1 drops, but happens *before the cohort even runs*. Skipped for MVP because the YouTube channel can launch with the Opening + first Sim-day-overview as its starting library; we don't need a hype reel to land an investor walkthrough.

**Cut for audience reasons:**
- Morning teaser signals (Will Wright's "sunrise mechanic")
- Premium uncut / director tools / poll voting
- **Teen audience expansion + consent / parental-permission gates** — required before opening to under-18 users; deliberately deferred. MVP runs adult-only.

These are deliberately deferred because they dilute the loop, fall outside the MVP audience, or are not on the critical path. Most can ship in the first month post-MVP if the demo lands.

---

## 9. Investor Demo Narrative

Five-minute pitch flow:

1. **Thesis.** Real friend groups become AI Survival villages. Drama compounds because the Doubles know each other and the format guarantees pressure every day.
2. **Atomic network.** Not one user — an 8-15 person adult cohort. We optimized for finding this unit, not for waitlist size.
3. **Format.** Survival mode is the demo format: challenges, coalitions, vote-outs. Reality-TV grammar viewers already understand.
4. **Proof — the YouTube channel.** Open `youtube.com/@doubland-ai`. Show the activated cohort's Opening trailer + 2 sim-day-overview trailers. *Emotional centerpiece.*
5. **Conversion.** Tap a timecode in the description → land in the sim viewer at the exact moment, camera on the right Double → see the whole council unfold uncut. "This is real. It's not scripted."
6. **Cold-start motion.** We recruit Founding Hosts, not individual users. Pipeline: 1 activated, 1 partial, 1-2 forming. Master-user waitlist (5-15 friend commit) is supporting evidence.

---

## 10. Success Metrics for the Demo

| Metric | Target |
|---|---|
| Activated cohort | 1 (Survival mode) |
| Cohort size | 8-15 adult friends |
| Sim-days run for cohort | ≥ 2 |
| Trailers on YouTube channel | ≥ 2 sim-day-overview + 1 Opening |
| Time-code deep link round-trip | YouTube description → sim viewer Play mode → waitlist gate, demoable end-to-end |
| Waitlist signups | ≥ 1 master-user tier (5-15 friend commit) + ≥ 5 individual entries |
| Pipeline cohorts | ≥ 2 (1 partial + 1 named) |

---

## 11. Open Questions / Risks

- **Survival Day-2 retrieval (Fix 2).** The blocker upstream of everything else. Verify before scheduling the activated cohort run; otherwise the cohort sim produces trailers with no cognitive continuity.
- **Sim-wide trailer scope.** Opening + Sim-day-overview together are real engineering, not polish — multiple new modes across `extract_day_log.py`, `showrunner.py`, and `record_scenes.py`, plus shared infrastructure (mode dispatch, persona ranker, color grade, bridge cards). 10-day window is tight; if it slips, ship Sim-day-overview only and put a static channel banner where Opening would go.
- **YouTube discoverability.** Subscribers will see the bell; non-subs find trailers via shared links and recruiting outreach. There is no organic discovery in MVP; cohort and Founding Host networks are the entire distribution.
- **Trailer narration discipline (§4 safe-receipt rule).** Apply rule to showrunner output and description copy; spot-check every trailer before YouTube upload until the showrunner prompt has been audited.
- **Trait surfacing.** Showrunner needs access to onboarding-quiz traits to produce honest, safe narration. Confirm data path: onboarding → `day_log.json` → `script.json`.
- **Recruiting bandwidth.** 10-15 outreach conversations in 10 days is real founder time. Founder-led or delegated to one team member full-time?
- **Future risk: teen audience.** When the product opens to teens (post-MVP), consent / parental-permission gates and stricter narration rules become mandatory. Keep §4 applied even to adult cohorts so the migration is clean.

---

## 12. Lock & Change Policy

This gate is locked under the 2026-04-29 revision. Changes require explicit decision and re-statement here. New ideas during the sprint go to `!next.md` post-MVP unless they pass this bar:

> *"This change makes the YouTube trailer + waitlist conversion path more emotionally undeniable for an investor."*

Anything else is noise.
