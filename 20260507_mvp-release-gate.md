# MVP Release Gate — 10-Day Sprint

> **Goal:** Demonstrate fundraising-grade traction for Double.
> **Window:** ~10 days.
> **Decision:** Ship **Survival-mode-only** with one undeniable live cohort. Not a public launch. **Adult friend teams only.**
> **Status:** Locked after Will Wright + Andrew Chen + Nir Eyal advisor pass + Burnett / de Mol / Parsons reality-TV pass (2026-04-28).

---

## 0. TODO Index

> Brief scan of what's still open. Full detail lives in §7 (engineering), §6 (recruiting), §11 (risks).
> Doc shorthand: **video PRD** = `D:\Coding\double-docs\20260429_PRD_video_pipeline.md`; **survival upgrade** = `D:\Coding\double-docs\20260428_survival_upd.md`.
> Owner tags: *(Ivan)* = Ivan keeps · *(Nicolas)* = delegated to Nicolas (full implementation brief at `D:\Coding\double-docs\20260507_nicolas-mvp-gate.md`) · *(Ops)* = non-engineering, named cohort-team owner.

**P0 — must ship (cohort proof):**

1. Showrunner authorship-receipt constraint *(Ivan)* — §7 #1
2. Receipt card UI (explicit → tag → tap-to-reveal cadence) *(Nicolas)* — §7 #2, §4
3. Motive-level prediction widget *(Nicolas)* — §7 #3
4. Prediction resolution opener (first 5s of next trailer) *(Ivan)* — §7 #4
5. Lightweight evening drop (push or email+SMS) *(Nicolas)* — §7 #5
6. Reaction capture workflow (single named owner) *(Ops)* — §7 #6, §6
7. Survival-mode end-to-end validation *(Ivan)* — §7 #7 · video PRD §3 TODO-2c

**P1 — recruiting surface + cognitive depth (ships only if P0 stable):**

8. Time-code deep links (`https://doubland.ai/sim/{code}/play?t=&double=`, opens in new window in full-screen Play mode) *(Nicolas)* — §7 #8, §5
9. Founding Host waitlist *(Ivan / Ops, no-code)* — §7 #9
10. Basic share payload — native share to 4 social platforms (Snapchat / Instagram / X / YouTube Shorts), watermarked 9:16 + time-code deep-link description block *(Nicolas)* — §7 #10
11. Survival conversation / reflection priors (Stage 4 of survival cognitive upgrade) *(Ivan)* — §7 #11 · survival upgrade §3 Stage 4
12. Chat memory persistence end-to-end (`movement.chat` → `dbl_memory` gap) *(Ivan)* — §7 #12 · video PRD §3 TODO-2b
13. Trailer quality gates (subtitle timing + auto-validate + 9:16 readability) *(Nicolas)* — §7 #13 · video PRD §3 TODO-4 / TODO-5 / TODO-6

**Recruiting milestone (parallel track):** 1 fully activated Survival cohort (8-15 adults, ≥2 sim-days, ≥2 trailers, ≥5 captured reactions) + 1 partial + 1-2 in pipeline — §6, §10. *(Ivan / Ops, founder-led.)*

**Top risks to clear day 1:** Survival pipeline validation on a true Survival run · trait data path for safe receipts (onboarding → `day_log.json` → `script.json.receipt`) · evening-drop channel decision — §11. *(Ivan owns the calls; Nicolas implements once decisions land.)*

P2 polish items (§7 #14-17) and explicit cuts (§8) are intentionally not duplicated here.

---

## 1. Strategic Frame

**Survival mode is the *only* sim format for MVP.** Standard / free-flow simulation ships post-MVP.

Why Survival:
- The reality-TV format (HOOK → COALITION → VOTE → STINGER) is already shipped in the trailer pipeline.
- Pressure events are intrinsic — challenges and vote-outs guarantee drama every sim-day. No reliance on emergent-only behavior.
- It's a format viewers already understand, which makes the trailer instantly legible.

The atomic network unit is **an 8-15 person adult friend cohort**, not an individual user.
Therefore the milestone is not "open launch" — it is **one fully activated Survival village + visible recruiting motion**.

The investor sentence we need them to feel:

> "Oh — this would not work as a solo app. The social graph is the product."

**Audience for MVP:** adult friend teams. Teen audience and the consent / parental-permission gates that opens up are explicitly post-MVP (see §8 and §11).

---

## 2. The Five-Decision Gate (resolved)

| # | Original item | Decision | Why |
|---|---|---|---|
| 0 | Sim format | **Survival only** | Built-in pressure → strategy → vote-out → trailer. Free reality-TV format. |
| 1 | Two trailers per real day | **Cut** | Will + Nir converge: one trailer is a "trophy of emergence." Two trains a feed mindset. |
| 2 | Trailers people want to share | **Ship — with authorship discipline** | Add Will's "authorship receipt" as a card *outside* the story (Nir's correction). |
| 3 | Seamless sharing (4 social platforms) | **Native share to social only — trailer is the acquisition vehicle** | Snapchat / Instagram / X / YouTube Shorts. The video trailer is the primary engagement and new-user-acquisition surface in MVP scope, so social broadcast is the only share lane we build. **Trailer description must carry the time-code deep-link list** — that's the conversion mechanism (viewer taps timecode → sim viewer → waitlist gate). Group-chat share buttons (iMessage / WhatsApp / Telegram) are cut: cohort members paste the trailer URL into their existing chats and rely on Open Graph rich previews. Platform-specific polish (Stories formatting, Shorts captions, embedded thumbnails) stays in P2. |
| 4 | CTA: register / start own sim | **Waitlist only — reframed** | Capture *cohort intent*, not individual intent. Form names a "Founding Host" status. Skip the fork-your-own-sim infra. |
| 5 | Invite-only + referral rewards | **Policy only, no rewards engine** | Founding Hosts earn invite codes. Defer the kudos / perks economy. |

---

## 3. The Daily Product Loop

**North Star sentence (de Mol):**
*Every night you get one episode: watch what your Double did, see one reason why, predict tomorrow's behavior, and return tomorrow to see if you were right.*

The full habit loop the MVP must deliver — six beats, no more:

1. **Fixed evening drop** — target 6:30-7:30 PM in the cohort's primary time zone.
2. **External push framed as episode drop:**
   > "Your Double's Tuesday just dropped. The vote split your team in half."
3. **One 60-second Survival trailer** — existing pipeline, HOOK → COALITION → VOTE → STINGER beat sheet, mood-aware, 9:16 + 16:9.
4. **Authorship receipt card after the trailer** (not inside narration):
   > **Pulled from your Double DNA:**
   > "loyal under pressure" + "tests new people slowly"
5. **One-tap motive prediction at trailer end** — Will's framing: predict the *rule*, not the plot:
   > "Tomorrow at council, when the vote turns, your Double will…"
   > Hold the line / Flip / Sit out / Lead the swing
6. **Tomorrow's trailer opens with the resolution** (first 5 seconds, before the cold open):
   > "You predicted: Hold the line. Your Double chose: Flip."

That is the entire loop. No personality tweaking. No open-text "leave a thought." No second trailer. No random push timing.

---

## 4. Authorship-Receipt Cadence (Nir's pattern)

| User lifecycle | Receipt style |
|---|---|
| Trailers 1-3 | **Explicit.** "Why this happened: you told your Double 'loyal under pressure,' so when the alliance fractured…" |
| Trailers 4-7 | **Lightweight tags only.** "Double DNA used today: loyal under pressure, tests new people slowly." |
| Trailer 8+ | **Hidden by default.** Tap-to-reveal: "Why did my Double do that?" |

Training wheels for agency, then removed once the player has the mental model. Phrasing rule: "this moment was influenced by…" or "today's scene used…", never "because you chose X." Avoid single-trait determinism.

### 4.1 Safe-Receipt Rule (Parsons)

Even with adult friends, receipts that surface raw insecurities create exposure risk and break the magic. Hard rule:

> **Receipts may reference *behavioral tendencies*, not vulnerable confessions, secrets, or humiliating self-descriptions.**

| Good (behavioral) | Risky (vulnerable) |
|---|---|
| "socially cautious" | "afraid of being judged" |
| "avoids direct confrontation" | "panics when criticized" |
| "loyal under pressure" | "abandonment issues" |
| "tests new people slowly" | "doesn't trust anyone" |

This rule also constrains the **onboarding quiz**. Ask for behaviors and tendencies, not raw insecurities. Anything captured may eventually surface in a trailer receipt visible to the friend group — design accordingly. Keeping this discipline now also makes the eventual teen-audience migration clean.

---

## 5. Time-Code Deep Links (engagement multiplier)

**Mechanic:** every trailer carries time-stamped links into the live sim player.

> 0:18 — Council vote opens → [open sim at Day 2 / 19:14]
> 0:34 — The whisper alliance forms → [open sim at Day 2 / 12:38]
> 0:52 — The vote read-out → [open sim at Day 2 / 19:42]

**Why this earns its slot in the 10 days:**

- **Closes the share → engage → convert loop.**
  Saw clip in a friend's group chat → curious → tap timecode → watch the lead-up in sim player → "I want this for my crew" → waitlist.
- **Cheap to ship.** Time markers already exist in `script.json` (`key_steps`); sim player already supports `seekToStep`. Mostly URL routing + share-payload work.
- **Doubles as Will's "uncut access."** The trailer is the artifact; the sim viewer is the long-form proof that it's real, not scripted.
- **Andrew-friendly:** the timecode link is what gets pasted into a non-cohort friend's chat. That's the recruiting hook for the next cohort.

**MVP scope:**
- Time-code list rendered below the trailer in-product.
- Time-code list embedded in the share description on all four social platforms (Snapchat caption, Instagram caption, X tweet body, YouTube Shorts description). **This is the primary conversion mechanism** — non-cohort viewers tap a timecode, land in the sim viewer, hit the waitlist gate.
- **Deep-link URL:** `https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}`.
- **Click behavior:** clicking a deep link opens a **new browser window/tab** (`target="_blank"`) on `doubland.ai` and lands the visitor in **full-screen Play mode** — no app chrome (navbar / sidebar hidden), immersive sim canvas with a minimal HUD (timestamp, play / pause, exit-to-waitlist CTA). The sim player auto-seeks to the step (`?t=`) and the camera auto-follows the named Double (`?double=` → `__followPersona(name)` per video PRD §2.5).
- **Play mode** is a third FE mode alongside the existing `?headless=true` (backend simulation) and `?recording=true` (trailer capture) modes — see §7 #8.
- Guest viewing path: timecode visitors can watch ±5 minutes around the event, then hit a soft waitlist gate. *(The bounded ±5-min window itself is P2 — see §7 #14.)*

**Out of scope:** highlight reels, scrubbable previews, frame-perfect timing.

---

## 6. Cohort Recruiting Plan (Andrew's funnel)

Run this in parallel with engineering. **Recruiting is half the milestone.**

| Stage | Target | "Done" looks like |
|---|---|---|
| Outreach | 10-15 candidate Founding Hosts | Conversation had, fit assessed |
| Qualified | 5 serious | Named friend group, can name 8+ friends, willing to organize |
| Onboarding | 2-3 in motion | Host onboarded, started inviting |
| **Activated** | **1 full cohort** | 8-15 Doubles created, 2-3 sim-days run *in Survival mode*, 1+ trailer generated, **reactions captured** |
| Partial | 1 cohort | Host + 5-8 friends onboarded |
| Pipeline | 1-2 hosts | Confirmed but not yet started |

**"Reactions captured"** = group-chat screenshots, voice notes, screen recordings, quotable lines. These are the demo's emotional centerpiece — not the trailers themselves. **One named owner** is responsible for collecting them; without that, the demo loses its centerpiece.

---

## 7. Engineering Work — P0 / P1 / P2 Split (de Mol)

In strict priority order. **P0 must ship.** P1 ships only if P0 is stable. P2 only if already built or trivially close.

### P0 — Cohort proof (the nightly episode loop)

1. **Showrunner authorship-receipt constraint** *(Ivan)* — every `script.json` includes a `receipt` field listing 1-3 player traits / seeds that drove the day's key scene. Subject to §4.1 safe-receipt rule. Prompt change, low effort.
2. **Receipt card UI** *(Nicolas)* — render after trailer playback. Explicit format (trailers 1-3) → tag format (4-7) → tap-to-reveal (8+).
3. **Motive-level prediction widget** *(Nicolas)* — 4-option tap at trailer end; persists to Supabase keyed by `(user_id, sim_code, sim_day, trailer_id)`.
4. **Prediction resolution opener** *(Ivan)* — next trailer's first 5 seconds shows "You predicted X / Your Double chose Y" before the cold open. Showrunner reads prior prediction.
5. **Lightweight evening drop** *(Nicolas)* — fixed-time daily delivery via the cheapest channel that works (push if infra exists, else email + SMS). Episode-drop copy. **No new push infrastructure.**
6. **Reaction capture workflow** *(Ops — named cohort-team owner)* — single named owner, defined process for collecting group-chat screenshots / voice notes / screen recordings from the activated cohort during the sim run.
7. **Survival-mode end-to-end validation** *(Ivan)* — confirm shipped Survival prompt + capture behavior on the activated cohort's run. (Listed as P1 TODO in the video PRD; promoted to P0 here because the entire demo depends on it.)

### P1 — Recruiting surface (ships only if P0 is stable)

8. **Time-code deep links** *(Nicolas)* — render under trailer + in share descriptions. **Click opens a new browser window at `https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}` in full-screen Play mode** — a new FE mode (sibling to existing `?headless=true` and `?recording=true`) with no app chrome, sim canvas + minimal HUD, sim player auto-seeking to the step, and the camera auto-following the named Double via `__followPersona(name)`.
9. **Founding Host waitlist** *(Ivan / Ops, no-code)* — Tally / Typeform + landing page. Captures: cohort size, friend-group context, willingness to organize. Issues invite codes on approval.
10. **Basic share payload** *(Nicolas)* — Web Share API (mobile-first) with watermarked vertical 9:16 + **time-code deep-link description block** + invite link. **Four social platforms via the OS share sheet:** Snapchat, Instagram, X, YouTube Shorts. The video trailer is the primary engagement and new-user-acquisition vehicle, so social broadcast is the only share lane in MVP scope. The time-code description must be carried verbatim into each platform's caption / tweet body / description — that's the conversion mechanism. Group-chat share (iMessage / WhatsApp / Telegram) is cut; cohort members paste the trailer URL into their existing chats and rely on Open Graph rich previews on the URL. Platform-specific polish (Stories formatting, Shorts captions, X embedded thumbnails) stays in P2 (#16).
11. **Survival conversation / reflection priors (Stage 4 of survival cognitive upgrade)** *(Ivan)* — survival-aware chat / summarize-conversation / reflect templates so Day-2+ conversations bend toward alliance, voting, threat. Without it the COALITION beat in trailers and the "captured reactions" centerpiece (§6, §10) read as mundane domestic chatter. See `D:\Coding\double-docs\20260428_survival_upd.md` §3 Stage 4.
12. **Chat memory persistence end-to-end** *(Ivan)* — diagnose and close the `movement.chat` → `dbl_memory` chat-row gap so Day-2+ Doubles retrieve yesterday's conversations into planning and vote decisions. Trailer extractor is unaffected (it reads `movement.chat` directly), but multi-day cognitive continuity for the cohort run depends on this. See `D:\Coding\double-docs\20260429_PRD_video_pipeline.md` §3 TODO-2b.
13. **Trailer quality gates (subtitle timing, automated validation, 9:16 crop readability)** *(Nicolas)* — bundle of three: SRT timing derived from real narration audio (not script offsets); a `validate_trailer.py` pre-flight check on duration, narration word count, end-card presence, and crop; manual or automated mobile-readability sign-off on the 9:16 crop. Mobile group-chat share is the cohort signal; a broken trailer in the WhatsApp thread is the demo's biggest avoidable failure. See `D:\Coding\double-docs\20260429_PRD_video_pipeline.md` §3 TODO-4, TODO-5, TODO-6.

### P2 — Polish (cut unless trivially close)

14. Guest sim viewer (±5 min context window, waitlist gate) *(Nicolas, if attempted)*
15. Founding Host badge on Double card / trailer end card *(Nicolas, if attempted)*
16. Public-broadcast platform-specific polish — Instagram Stories card formatting, Snapchat Lens integration, YouTube Shorts caption templates, X embedded-thumbnail tuning. Beyond what the Web Share API gives natively in #10. *(Nicolas, if attempted)*
17. Push-notification infrastructure spike *(Nicolas, if attempted)*

---

## 8. What's Explicitly Cut (post-MVP, not "ran out of time")

- Standard / free-flow sim mode (Survival is the only format for MVP)
- Two trailers per sim-day
- Self-serve sim creation / fork-your-own-village
- Referral rewards / kudos / perks economy
- Personality tweaking as a daily input
- Open-text "leave a thought" investment
- Random / dynamic push timing
- Group-chat share buttons (iMessage / WhatsApp / Telegram) — cut in favor of social-only share. Cohort members paste the trailer URL into their existing chats; Open Graph rich previews on the trailer URL surface a native-quality preview without a per-platform handler.
- Platform-specific polish for social share (Instagram Stories formatting, Snapchat Lens, YouTube Shorts caption templates, X embedded-thumbnail tuning) — basic native share to all 4 social platforms ships in P1 #10; per-platform tuning is post-MVP
- Morning teaser signals (Will's "sunrise mechanic" — post-MVP delight)
- Premium uncut / director tools / poll voting
- **Teen audience expansion + consent / parental-permission gates** — required before opening to under-18 users; deliberately deferred. MVP runs adult-only.
- **Survival post-game archive helper (Stage 5 of survival cognitive upgrade).** The `survival_mode` flag already clears on elimination and on game-over; the formal `_clear_survival_mode` helper and the `survival_archive` / `survival/eliminated/<name>.json` archive mechanism are post-MVP polish. Current partial state is harmless for the demo (no further game logic runs on eliminated Doubles). See `D:\Coding\double-docs\20260428_survival_upd.md` §3 Stage 5.

These are deliberately deferred because they dilute the loop or fall outside the MVP audience, not because the schedule is tight.

---

## 9. Investor Demo Narrative

Five-minute pitch flow:

1. **Thesis.** Real friend groups become AI Survival villages. Drama compounds because the Doubles know each other and the format guarantees pressure every day.
2. **Atomic network.** Not one user — an 8-15 person adult cohort. We optimized for finding this unit, not for waitlist size.
3. **Format.** Survival mode is the demo format: challenges, coalitions, vote-outs. Reality-TV grammar viewers already understand.
4. **Proof.** Live walkthrough of the activated cohort: their Doubles, today's trailer, their reactions in the group chat. *Emotional centerpiece.*
5. **Loop.** Trailer → receipt → motive prediction → tomorrow's resolution. Mention pre-notification opens as a habit signal if available.
6. **Deep link.** Show how a friend outside the cohort follows a time-code into the sim viewer and lands at the dramatic moment.
7. **Cold-start motion.** We recruit Founding Hosts, not individual users. Pipeline: 1 activated, 1 partial, 1-2 forming. Waitlist is supporting evidence.

---

## 10. Success Metrics for the Demo

| Metric | Target |
|---|---|
| Activated cohort | 1 (Survival mode) |
| Cohort size | 8-15 adult friends |
| Sim-days run for cohort | ≥ 2 |
| Trailers generated | ≥ 2 |
| Captured reactions | ≥ 5 quotable moments / clips |
| Pipeline cohorts | ≥ 2 (1 partial + 1 named) |
| Daily-loop completeness | All 6 beats demoable end-to-end |
| Time-code deep link | Round-trips trailer → sim → waitlist gate |
| Pre-notification opens | Track from day 5 onward (leading indicator) |

---

## 11. Open Questions / Risks

- **Survival-mode end-to-end validation.** The pipeline is shipped but not fully validated on a true Survival run (per video PRD). This is the single biggest schedule risk — confirm on day 1 of the sprint.
- **Trait surfacing.** Showrunner must have access to onboarding-quiz traits to produce honest, safe receipts (§4.1). Confirm data path: onboarding → `day_log.json` → `script.json.receipt`.
- **Evening drop channel.** If the app doesn't have working push, default to email + SMS for the cohort. Don't build new push plumbing in this window.
- **Cohort time zones.** Fixed-evening drop needs per-cohort scheduling if any cohort spans time zones.
- **Recruiting bandwidth.** 10-15 outreach conversations in 10 days is real founder time. Founder-led or delegated to one team member full-time?
- **Future risk: teen audience.** When the product opens to teens (post-MVP), consent / parental-permission gates and stricter receipt rules become mandatory. Do not let MVP design decisions assume an adult-forever audience — keep §4.1 safe-receipt rule applied even to adult cohorts so the migration is clean.

---

## 12. Lock & Change Policy

This gate is locked. Changes require explicit decision and re-statement here. New ideas during the sprint go to `!next.md` post-MVP unless they pass this bar:

> *"This change makes the activated Survival cohort more emotionally undeniable for an investor."*

Anything else is noise.