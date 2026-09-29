# Front-page demo sim: consolidated plan

- **Date:** 2026-09-29
- **Owner:** Ivan Pistsov (founder, Doubland). Compiled by COS from 7 expert memos, their follow-ups, and Legal's drafts.
- **Status:** needs-review. This is a proposal. Every threshold below is a proposal to test. None of them is a benchmark or a traction number.
- **Sources:** `/workspace/demo-sim-research/01-reality-tv.md` to `07-cto.md`, `05-plg-full.md`, `08-followups.md`, and the Legal drafts in `/workspace/doubland-demo-sim-legal-20260929/`.

**Key terms (used throughout)**

- **Double:** the AI character modeled on a real adult. Doubles live *in* Doubland (pronounced Dohb-land).
- **Home:** one slot in a sim. One home holds one Double. Every sim has **20 homes at most**.
- **Resident:** a real person whose Double holds a home in the demo.
- **Showrunner:** a resident who gathers a group of 5+ people and runs a private sim of their own, with their own rules.
- **House Double (anchor):** a permanent, labeled AI Double owned by Doubland that lives in the demo house. It provides continuity and pressure but is never the lead.
- **AI stand-in (placeholder):** a clearly labeled AI Double that fills an empty home until a real person arrives. It never counts toward growth or density numbers.
- **Closer:** the short nightly episode that sums up the sim's day. It's the unit we post publicly.
- **Closer beats:** the named parts of a closer: **Stake**, **Pressure**, **Peak** (the day's strongest moment), and **Cost** (the character who pays the price for it).
- **Door:** the single call to action a closer is allowed to carry.
- **Flintstoning:** staff doing by hand what the product will automate later, so early users get the full experience.
- **Graduation:** a resident leaving the demo with their Double, its history ("tape"), and a nudge to run their own sim.
- **Pending sim:** a showrunner's sim that is still filling up and isn't live yet.
- **D1 / D7:** the share of new residents who come back 1 day / 7 days after moving in.
- **K:** how many new qualified showrunner sims each active sim produces per 7-day cycle. It's defined precisely in section 7.2.
- **share_id:** a tracking id on every shared clip or invite link, used to trace who brought whom.

---

## 1. Summary

The demo is a **showroom, not the product**. It's one permanent village house with a revolving door: 4 labeled house Doubles plus 16 resident homes (recommended default), never more than 20 Doubles in total. It runs 24/7 in weekly seasons that end in a finale. At launch, anyone can *watch* the live sim on the landing page, and joining works by invite link only. New residents arrive whenever a home is free. Their Double gets a guaranteed 2-4s cameo in the next closer, and they get a private 8-12s "Day 1" clip to share. Inactive residents get a notice at 48h and move out at 72h. Moving out is a quiet, dignified morning card that is never framed as a loss. The Double stays on the resident's account as an alumnus. Being voted out is a separate, on-stage game event that happens every night. A residency lasts one weekly season: everyone graduates at the finale, and anyone voted out earlier graduates too, with an alumni card. The demo's job is to turn residents into **showrunners**. The pitch comes at a few strong moments (first feature, graduation, finale), each resident gets 1 plus-one home and 3 pending-sim invite links, and a pending sim goes live at 3 real people (target 5), with labeled AI stand-ins in the empty homes. Ivan approves every public trailer, and only residents who opted in can appear in one. The first showrunners are hand-picked and hand-run (1, then 2-3, then about 10). The demo opens to the public only when a merged checklist of conversion and self-sustaining signals holds, and only when Ivan decides. Nothing opens automatically. **Engineering (CTO):** the invite-only build is about 4.5-6 backend weeks plus 2-2.5 front-end weeks. Measured running cost is small, about $1/day for a full 20-home sim. The real risks are speed (20 Doubles haven't been load-tested) and security: **the production sim API currently answers with no login and exposes real people's Double names, locations and activities. Locking it down is a launch blocker before public watching.**

---

## 2. Decisions

### 2.1 Locked by Ivan (2026-09-29), plus CTO-confirmed facts

1. **Front door is invite-link-only at launch**, with hand-picked first showrunners. It opens to the public once the demo proves it converts residents into showrunners. **Ivan makes that call. It never happens automatically.**
2. **18+ only.** Teens are out of scope.
3. **Ivan approves every public trailer.**
4. **Per-person opt-in to appear in public trailers, off by default.**
5. **No monetization this chapter.**
6. **Sims may go live below 5 real people**, with labeled AI stand-ins.
7. **Hard cap: at most 20 Doubles per sim (20 homes), the demo included.** House Doubles, residents, plus-ones and AI stand-ins all count.
8. **Anyone can watch the demo sim on the landing page. Joining is invite-only.** The trailer end card's primary line is "Watch the village live at doubland.ai."
9. **A vote-out happens every night.** This overrides Reality TV's 2-3 a week. Rotation math: nightly votes mean about 7 exits a week (plus any inactivity move-outs). Arrivals are capped at about 2 cameos a day, with the overflow card for extras. Nightly votes free homes about as fast as arrivals fill them, and labeled AI stand-ins cover any gap.
10. **Residency is tied to the weekly season, with graduation at the finale.** Anyone voted out earlier also graduates with their alumni card. "Voted out" and "moved out" (inactivity) are still presented differently.
11. **Live model: CONFIRMED `deepseek/deepseek-v4-flash-0731`** (CTO). It has been recorded on every sim since the Sep 17 run `20260917-3`, and the source of truth (`sot_llm.md` v1.9) now says 0731. Because 0731 has no price entry, costs since Sep 17 are recorded about 1.8x too high. The fix is a small code PR, pending Ivan's OK (section 5.8).
12. **Trailer treatment of people who haven't opted in (Legal draft 01, now aligned):** they appear only as unidentifiable background extras (no name, namecard, lines or face match), or the beat is cut. No recasting and no visible blur. Labeled AI stand-ins still fill empty *homes*, but a stand-in is never swapped in for a real person in a trailer scene.
13. **Recommended cast default: 4 labeled house Doubles plus 16 resident homes = 20** (CTO). Reality TV's original range was 3-5 house Doubles plus 10-15 residents. 4 + 16 sits inside that and fills the cap exactly. *Recommended, pending Ivan's confirmation.*

### 2.2 Open decision for Ivan

| Decision | Options | COS recommendation |
|---|---|---|
| **Pooled-residents number** for the "ready to go public" checklist (section 7.4) | 40 (PLG, pooled across consecutive weekly cohorts) / 50 (Engagement, restated as pooled across seasons, counting everyone who rotated through) | **40.** COS arithmetic (section 7.1): with 16 resident homes and a fresh cast each weekly season, two seasons pool about 42 real residents when each vote-out is replaced, and about 52 only at maximum churn. 40 is reachable in two seasons. 50 needs everything to go right, so it would likely delay the call without adding signal. Every other gate is unchanged. |

---

## 3. Strategy

### 3.1 The demo is a showroom
- Its purpose is to show what a sim feels like and to convert visitors into **showrunner applicants** (Andrew Chen). Demo daily-active users and retention are health checks, not the goal.
- Demo = public strangers plus house Doubles under fixed house rules. Showrunner sim = private, your 5+, your rules, no house Doubles (Reality TV).
- Show, don't say. The demo should create moments where a viewer thinks "that's my friend," not state "imagine this with friends."

### 3.2 A permanent house with a revolving door
- One house, a fixed daily clock, and a weekly rhythm. **No hard reset.** A monthly season marker with a recap (Reality TV).
- **Weekly seasons with a finale.** A fresh cast arrives from Monday. The finale is the best place for the showrunner Door.
- **Residency = one weekly season** (locked). Residents graduate at the finale. Anyone voted out earlier also graduates with an alumni card.
- **A vote-out every night** (locked), plus the finale vote.
- **Rolling arrivals** plus the day-1 cameo replace the batched weekly move-in windows. The weekly arc and finale stay (Reality TV follow-up).
- Rotation is always shown as a scene, and inactivity is never shown as "inactive" (Reality TV).

### 3.3 House Doubles (anchors)
- **4** permanent, **labeled** house Doubles (recommended default; Reality TV's range was 3-5) provide continuity and pressure. They are never the leads and never the Cost.
- If house Doubles can't be voted out, say that rule out loud on screen.
- Risk: real residents feel like extras. Mitigation: the picker favors residents, and house Doubles are never recast into a real resident's scene (Video Producer).

### 3.4 AI stand-ins
- Used as disclosed flintstoning: the demo is never empty, and a showrunner with 2-4 friends can start (Andrew Chen).
- **Always labeled. Never counted** in density, K or growth claims. They should be a minority in showrunner sims.
- Each real arrival replaces a stand-in. Stand-ins must not resemble real people (Legal).
- Stand-ins fill empty **homes** only. A stand-in is never swapped in for a real person in a trailer scene.

### 3.5 Graduation
- Every departure is a graduation: finale, vote-out, or inactivity (Engagement). The main graduation is at the weekly finale, when the residency ends. Anyone voted out earlier graduates with their alumni card.
- **A Double is never deleted on move-out.** It keeps its tape and gets an alumni card (a shareable object).
- Afterward the resident can re-queue with priority or bring their Double, with its history, into their own sim.
- The move-out produces a "recruiting kit": a move-out clip, an editable pre-written Telegram message, the pending-sim link, a fill meter and rule presets (PLG).

### 3.6 The showrunner funnel
- **Pitch moments** (Engagement): after a resident's first feature; at graduation (the strongest moment); when a resident shares or invites someone (prefill the group); at the season finale. **Never** "invite 5 to continue." There's also a landing-page CTA and an end card, with one Door per closer.
- **Conversion object = start a pending sim** (PLG), not "become a showrunner."
- **Fill meter** (for example 2/5). The invite shows the recruiter's own clip first: "Did you see what my Double did? Come be in ours."
- **Quorum go-live at 3 real people, target 5.** AI stand-ins fill the rest. The season is built for 5+, aiming for 5 humans by mid-season. Groups of 3, 5 and 8 get tested (consensus of PLG, Chen and Engagement).
- No rewards for inviting, no "tag friends to unlock," no nudges to people who don't share (PLG).

### 3.7 Invites
- Each demo resident gets **1 plus-one demo home** and **3 pending-sim invite links**. Each link has its own share_id and is refilled when accepted (PLG).
- Plus-ones stay at 1 because of the 20-home cap. Measure whether plus-ones convert to showrunners better than solo residents.
- Engagement's open ask: prefill showrunner groups with each resident's invitees.

### 3.8 Showrunner rollout sequence (Andrew Chen)
1. **1 showrunner**, fully hand-run by staff (flintstoned).
2. **2-3 showrunners** from overlapping communities.
3. **About 10.** Roughly 1 new showrunner every 1-2 weeks. **Pause while any sim decays.**

- Pick people who already run a dense, active group (for example the L-Talks Telegram circle), will co-run season 1, can bring 3 people in week 1, and will share. Density matters more than audience size.
- Deepen sim #1 before adding #2 and #3. Growth to 100 comes through referrals and trailer-driven applications via waitlist and screening, not open signup.

---

## 4. Product implementation

### 4.1 First session
- The front door autoplays at least one closer (last night's). The CTA is "Move your Double in," which leads to the personality test/profile (the gate), then a home tonight, or a queue with a real ETA plus spectating (Engagement).
- **Honest scarcity** (PLG): when the house is full, the visitor spectates, sees their real queue position, and gets notified when a home opens. No fake countdowns.
- **Activation** (PLG) = "my Double appeared in a clip I shared," within 24h of move-in.

### 4.2 Arrival
- **Hard rule: the day-1 cameo** (Engagement and Reality TV):
  - Every Double whose `moved_in_at` falls in the last 24h gets **2-4s in the next closer**, grouped if there are several.
  - Placement: picture only (walk-in, namecard, habitat shot), after Stake and before Pressure (Reality TV). Engagement places it "after the vote and before the final line." **This needs reconciling in the template** (see section 11).
  - Spoken name only if it matters to the Peak or Cost. It never takes the Peak slot and never replaces the Cost walk. No invented reactions. A reaction from a house Double or resident can be the Peak if the ledger (the sim's factual event log) backs it.
  - **Up to 2 cameos a day** (about 7-14 arrivals a week at most). Overflow goes to a "new in the house" card with 2-3 faces.
  - A new arrival is **immune from the vote the first night**. This matters because a vote-out now happens every night.
  - **Arrivals stop 2 nights before the finale.** Later joiners debut at the next season's premiere.
- **Private day-1 clip, 8-12s** (Video Producer): village shot with their sprite, namecard, a habitat clip at their job, then an end card: "Day 1 — you're in the village." Ledger facts only, with fallbacks, cached. Sent privately with a share button and **never auto-posted**.
- Every resident is featured at least once before leaving (Video Producer).

### 4.3 Rotation
- **Activity signal:** a resident is active if they opened a closer or checked in within 72h (Engagement). A light daily check-in gives agency without control.
- **48h:** a neutral notice, "home held until…" From then on the Double **can't be voted out**. Coming back clears this silently.
- **72h:** the Double moves out of the demo home. If that falls on a vote night, it airs the next morning.
- **Rotation math (nightly votes, locked):** about 7 vote exits a week, plus any 72h inactivity move-outs. Arrivals are capped at about 2 cameos a day (overflow goes to the "new in the house" card). Nightly votes free homes about as fast as arrivals fill them. Labeled AI stand-ins cover any gap, so the house is never short.
- **Two exits, never confused** (Reality TV and Engagement):
  - **Voted out** = a game event that plays on stage in the vote segment every night. The resident graduates with an alumni card.
  - **Moved out** = a quiet morning card, "[Name] moved out. Home open.", with no tally and no reactions. It's framed as life, never a loss.
- The freed home goes to the next person in the queue. Otherwise a labeled AI stand-in takes it at the next cutoff.
- No peer reports. Showrunners set idle rules in private sims.
- Staff can move anyone out for rules violations at any time, without notice when safety requires it (Legal 03, A2).

### 4.4 Trailers
- **One public closer per demo night**, built automatically. It ships only if the picker score is at least 18 and the closer has both a Peak and a Cost. Skipping a night beats posting a boring one (Video Producer).
- **Format:** a vertical master. The ~12s muted cut is the unit for Shorts, Reels and TikTok. Telegram gets the full closer, pinned daily. X gets the short cut plus a cliffhanger question.
- **Opt-in filter first:** the Peak, the Cost and any named supporting characters must all have opted in. Otherwise the scene is private-only and the next 18+ scene with opted-in leads runs. If nothing qualifies, **nothing posts**.
- People who haven't opted in appear only as **unidentifiable background extras** (no name, namecard, lines or face match), or the beat is cut. Vote tallies show counts only. This matches Legal draft 01 (now aligned).
- A new **`public_safe`** flag. Cut, never visibly blur. A validator fails any render that face-matches a non-opted-in person.
- **Never recast** a real resident's scene with a house Double or an AI stand-in.
- **Automated gates** (Video Producer): fact diff against the ledger, identity, dignity, and so on. **Then Ivan approves every public trailer** (locked). This settles the earlier tension between the Video Producer's "spot-check after ~10 clean nights" and Legal's "human sign-off on every post."
- **Content bans** (Legal): no storylines about crimes, sex, health or sexual orientation involving real people. Every trailer carries the label "AI characters. Fictional events." plus platform AI labels.
- **End-card copy while invite-only** (Video Producer):
  - Drop "A home is open."
  - Primary (locked): "Watch the village live at doubland.ai."
  - Secondary: "Invite only for now. Run one for your friends → Host a season."
  - Private clips: "Bring a friend in → [invite link]."
  - The CTA goes only on the end card or caption, never in the voiceover. One CTA per surface.
- **Showrunner sims:** private recaps by default. Public posting needs the organizer's opt-in plus each featured person's opt-in (Video Producer). Never promise public posting without Legal's sign-off.
- Continuity comes from the format (house frame, scar chip, named cliffhanger), not from the cast.

### 4.5 Cast within 20 homes
- **Recommended default: 4 house Doubles plus 16 resident homes = 20** (CTO). Reality TV's original range was 3-5 house Doubles plus 10-15 residents.
- Plus-ones take resident homes. AI stand-ins fill empty resident homes. The total stays at 20 or fewer.
- Engagement's target: at least 80% of homes held by real, active people. *Note:* 4 house Doubles are 20% of 20 homes, so if the 80% counts all homes, it requires zero AI stand-ins. COS suggests measuring it over the 16 resident homes (see section 11).
- Speed, not cost, is the constraint: each simulated minute must finish in under 60s, and 20 Doubles haven't been load-tested (section 5.6).

### 4.6 Data retention (Legal draft 03, rev 2)
- **Moving out ≠ deletion.** The Double stays on the account as an alumnus with its tape. It drops out of new demo trailers, and consented trailers already posted stay up (Part A).
- **Moving out ≠ withdrawing trailer consent** (consistency edit to draft 01).
- **Deletion happens only** on request (within 30 days), on account closure (after a 30-day grace period), or after 24 months with no sign-in (with a 30-day warning email). Backups are purged within a further [60] days (Part B).
- On deletion, other Doubles' memories of the person are de-identified (name, handle and details removed or made generic). Trailers are removed from Doubland's own channels within 30 days. Reposts by others can't be recalled.
- A limited record (consent history, moderation actions, account id) is kept for about 3 years (suggested).
- **CTO must confirm** that the data stores and the LLM provider's retention (via OpenRouter) fit these windows.

---

## 5. Engineering plan (CTO)

*From the CTO's memo (advice only) and follow-up answers (2026-09-29).*

### 5.0 LAUNCH BLOCKER: security
- [ ] **The production sim API answers with no login.** `/api/simulations/`, `/{sim}/costs` and `/{sim}/personas` expose the sim list, costs, and real people's Double names, locations and activities. **It must be locked down before public watching.** This is Next actions item #1.

### 5.1 Principles
- Build on **live mode** (1:1 real time, hourly chunks) and the existing join/home flow. Allow joins between chunks, on the demo only, with a lock.
- Shared database, worker and gateway. **No container per sim.**
- The landing-page live embed and the waitlist already exist.

### 5.2 Invite-only MVP (~4.5-6 backend weeks via Cloud Agents plus ~2-2.5 front-end weeks from Nicolas; was 5-7 plus 2-3)

**Kept**
- [ ] **Join lock:** joins on live sims are refused today. Allow them between chunks on the demo.
- [ ] **Race-free home claim:** `home_claim` has a race. Fix it with a unique constraint or an RPC so two people can't claim one home.
- [ ] **Memory seeding** for a Double that joins mid-run, so it knows the house and residents.
- [ ] **Move-out** (unbind a Double from a home) plus a "moved away" memory for the Doubles who stay.
- [ ] **48h/72h inactivity:** the 72h activity signal, the 48h notice, and vote-ineligibility during the notice.
- [ ] **`double.sim_events` table** plus webhooks that feed trailers, monitoring and the waitlist. The CTO proposed its fields and event types.
- [ ] **Per-sim daily budget cap**, before launch.
- [ ] **Price fix** (section 5.8).

**Added**
- [ ] **Invite links** carrying a share_id.
- [ ] **Nightly vote-out** that moves one resident out and the next one in.
- [ ] **Weekly season rollover.**
- [ ] **Hardened public watch view:** read-only API, CDN, rate limits.

**Dropped (not needed while invite-only)**
- The anonymous queue with wait times, open signup, abuse/moderation at public scale, SEO/landing work.

### 5.3 Rules requested by other experts (not yet scoped by CTO)
- `arrival_beat` and `farewell_card` picker rules, the `public_safe` flag and the face-match validator, moving a Double between sims (Engagement and Video Producer asks).
- share_id end to end, from clip to visit to join to sim (PLG). Without it, K can't be computed.

### 5.4 Phase 2 (~4-6 weeks)
- (a) Automatic nightly closer plus private resident clips, checked automatically, with Ivan approving every public post.
- (b) Public posting only after Legal's stage-2 gates and per-person opt-in.
- (c) Viewer presence.
- (d) Showrunner-hosted pending sims: share_id, fill meter, go-live at 3 real people with labeled stand-ins, per-sim budget and model.
- (e) Cheaper background residents via caching, gated by the Naturalness test (the check that residents still read as natural).

### 5.5 Multi-tenancy (later)
- `MAX_CONCURRENT_SIMS=3` today. Maybe 9-18 live sims per box, pending a load test.
- Missing: custom rules, per-sim budget, model tier, templates, billing (no billing this chapter).
- `SCRATCH`/`SIM_META` default to local JSON. Fix this before a worker pool.

### 5.6 Cast cost (measured) and the real risk: speed
- **Cast:** 4 labeled house Doubles plus 16 residents = 20 homes.
- **Measured from `sim_cost_daily`:** about 339k input and 13k output tokens per Double per day.

| Unit | Typical | Range |
|---|---|---|
| Per Double per day | ~$0.05 | $0.01-0.13 |
| Full sim (20 homes) per day | ~$1 | $0.21-2.66 |
| Full sim per weekly season | ~$7 | n/a |
| Each new Double after a vote-out | ~$0.01 extra | n/a |

- These measured figures **replace** the earlier formula-based estimates ($104-626/month for 15 residents) and COS's derived 20-Double column.
- **The real risk is speed, not money.** Each simulated minute must finish in under 60s, and 20 Doubles haven't been load-tested. **Load test at 20 Doubles before launch.**

### 5.7 Clip cost (estimate)
- Pipeline: Playwright recording, Remotion render on our own servers, optional ElevenLabs voice.
- About **$0-0.03 per 8-15s clip**, or about **$2-15/month** for 16-20 residents nightly.
- **Remotion licensing** may add $0.01 per render ($100/month minimum) unless we qualify for the free license. **Ivan to check.**

### 5.8 Model and price fix (small code PR, pending Ivan's OK)
- **Confirmed live:** `deepseek/deepseek-v4-flash-0731` (on every sim since run `20260917-3`; `sot_llm.md` v1.9). Costs since Sep 17 are recorded about 1.8x too high because 0731 has no price entry.
- [ ] Log OpenRouter's billed `usage.cost` on every call, with the price table only as a backup.
- [ ] Price table: add 0731 at $0.14/$0.28 per million input/output tokens, keep 0423 at $0.0763/$0.1526, add v4.1-flash at $0.30/$1.20.
- [ ] Warn on unknown models. Refuse to start if a configured model tier has no price.
- [ ] Re-price past costs from their recorded token counts.

---

## 6. Legal

*Legal's memo is not from counsel, and all drafts are unreviewed by counsel. Nothing gets published or sent without Ivan's approval.*

### 6.1 Gated checklist

**Stage 1: before the first invited resident**
- [ ] Clickwrap ToS: 18+ attestation, rotation / no permanent home, AI disclaimer, liability, right to remove.
- [ ] Privacy Policy: what builds a Double, that sim text is sent to LLM providers via OpenRouter, retention, contact at ip@ondouble.com.
- [ ] Community Rules.
- [ ] Showrunner Terms (draft 02).
- [ ] Date-of-birth check that blocks under-18s when an invite is accepted.
- [ ] No face or voice biometrics (BIPA risk; BIPA is Illinois' biometric privacy law).
- [ ] A working report/delete email.
- [ ] Rotation/farewell clause in the ToS (draft 03 rev 2).

**Stage 2: before the first public trailer**
- [ ] Logged per-person likeness opt-in: who, when, version, withdrawal (draft 01).
- [ ] "AI characters. Fictional events." label plus platform AI labels.
- [ ] Ivan's approval checklist for every trailer.
- [ ] AI stand-ins don't resemble real people.
- [ ] Takedown within 48h. Removal from own channels within 30 days of withdrawal.
- [ ] Automated screen before human review (the fact, identity and dignity gates).

**Stage 3: before going public**
- [ ] Stronger age gate plus a way to report a suspected minor.
- [ ] Automated moderation.
- [ ] Registered DMCA agent (~$6).
- [ ] A Take It Down Act process with a 48h response (a US law on removing non-consensual intimate images). Report form target: 24h.
- [ ] Check whether Doubland crosses any state privacy-law threshold.
- [ ] Counsel review of the ToS, arbitration and privacy.

### 6.2 Drafts (in `/workspace/doubland-demo-sim-legal-20260929/`, .md and .docx)
- **`00_README`:** index. Bracketed items are placeholders for Ivan or product. Scope: 18+, invite-link only, no monetization, Ivan approves every trailer.
- **`01_likeness-opt-in-consent`:** optional, off by default. Covers the Double's appearance, name or handle, and AI voice in public trailers on Doubland's site and socials. Promises: AI label, human approval, no sexual/crime/sensitive-trait content, no payment, no biometrics [to confirm], covers only the signer. Moving out isn't a withdrawal. Withdrawal stops new trailers right away and removes existing ones from own channels within 30 days. Urgent takedown within 48h. Consent log. Version v0.1.
  - *Aligned (updated 2026-09-29):* people who haven't opted in appear only as unidentifiable background extras (no name, namecard, lines or face match), or the scene is cut. No recasting with a stand-in and no visible blur.
- **`02_showrunner-terms`:** an add-on to the ToS. Invite only people you believe are 18+. You can't consent for others. No Doubles of non-residents. Doubland has the final say and can moderate, pause or end any sim. Unpaid, with an FTC-style disclosure if that ever changes. Status is revocable. Indemnity [counsel to review].
- **`03_rotation-farewell-clause` (rev 2):** Part A: a demo home is a revocable permission. 48h notice, 72h move-out, the Double stays as an alumnus, no compensation. Part B: deletion only on request, account closure or 24 months of inactivity. The 30/60-day windows, de-identified memories, a ~3-year limited record.

---

## 7. Metrics and gates

### 7.1 Engagement KPI gates (invite-only phase)
| Gate | Threshold |
|---|---|
| D1 (back the day after moving in) | ≥ 40% |
| D7 (back a week later) | ≥ 15% |
| Homes held by real, active people (AI stand-ins fill the rest) | ≥ 80% |
| Median time from invite to move-in | ≤ 24h |
| Residents who submit a host application with a group name | ≥ 5% |

- Open to the public when all 5 hold for **2 consecutive weekly seasons**, with no open safety incidents, plus at least 1 showrunner launched from the demo with ≥ 5 completed profiles. If only D1/D7 pass, stay invite-only.
- **Adjusted:** Engagement's "≥ 50 real residents per season" can't fit in a 20-home sim (16 resident homes). It is restated as **≥ 50 distinct real residents counted across everyone who rotated through, pooled across consecutive seasons**.
- **COS arithmetic (redone for 16 resident homes and weekly residency):**
  - Each season starts with up to 16 real residents.
  - Mid-season arrivals stop 2 nights before the finale, leaving about 5 arrival nights.
  - Replacing each nightly vote-out adds about 5 arrivals a season. The 2-cameos-a-day cap allows about 10 if inactivity frees extra homes.
  - That's about 21-26 per season, or **about 42-52 over two seasons**. Both numbers assume every resident home holds a real person.
  - The earlier figure (~43) didn't account for fresh casts each season.
  - 40 is reachable in two seasons. 50 needs maximum churn. This is why COS recommends 40 (section 2.2).

### 7.2 PLG: K and the public trigger
- **Qualified sim:** the showrunner's last share_id touch traces to an active sim or the demo, the sim reaches **3 real members within 7 days**, and **3+ real members act in days 8-14**. AI never counts.
- **K** = qualified sims attributed to a 7-day cycle ÷ qualified sims active in that cycle. K above 1 compounds only if cycles are short and sims survive.
- Breakdown: K = [M × s × n × v × j × r + M × m] × f
  - M = active members per sim
  - s = share rate
  - n = shares per sharer
  - v = new visitors per share
  - j = visitor→resident
  - r = resident→showrunner
  - m = members who start their own sim directly
  - f = pending-sim fill rate
- **Trigger (revised for the 20-home cap):** pool **≥ 40 residents** across consecutive weekly cohorts, with:
  - ≥ 10% creating a pending sim
  - ≥ 50% of those reaching 3 real members in 7 days
  - ≥ 60% surviving week 2
  - median time to first clip ≤ 24h
  - **K ≥ 0.3**
- Then it goes to Ivan. It never opens automatically.
- Report alongside: time to first clip, time to fill, week-2 survival, trailers per sim, viewers per trailer, cycle time.

### 7.3 Andrew Chen: self-sustaining signals
- (a) 3+ sims self-sustaining for 2+ weeks after staff stop hand-running them.
- (b) AI homes shrinking.
- (c) Unprompted host applications, some coming from friends' trailers.
- (d) The demo converting visitors into host applicants.
- **Hold** if (a) holds without (c), or (c) without (a).

### 7.4 Merged "ready to go public" checklist (Ivan decides)
All of these must be true:
- [ ] **Engagement:** D1 ≥ 40%, D7 ≥ 15%, ≥ 80% real-held homes, median invite→move-in ≤ 24h, ≥ 5% host applications, holding for 2 consecutive weekly seasons.
- [ ] **Volume:** ≥ 40 real residents pooled across consecutive weekly cohorts (PLG), and ≥ 50 distinct real residents counted across everyone who rotated through, pooled across seasons (adjusted Engagement). *Open: COS recommends 40 (section 2.2).*
- [ ] **PLG rates:** ≥ 10% create a pending sim, ≥ 50% of those reach 3 real members in 7 days, ≥ 60% survive week 2, median first clip ≤ 24h, K ≥ 0.3.
- [ ] **Chen:** 3+ sims self-sustaining for 2+ weeks without staff, AI homes shrinking, unprompted host applications (some from friends' trailers), the demo converting visitors to applicants.
- [ ] **Showrunner from the demo:** at least 1 launched with ≥ 5 completed profiles.
- [ ] **Safety:** no open safety incidents. Legal stage 3 complete.
- [ ] **Ivan's explicit go.**

Recalibrate thresholds after a 2-week baseline (Engagement).

---

## 8. Expert briefs (appendix)

### 8.1 Reality TV
- The demo is a house, not a cast (Big Brother model): a permanent house with a revolving door.
- Show bible: one house, a fixed daily clock, a weekly rhythm, 3-5 labeled house Doubles. Residents' Doubles are rotating guests.
- Every rotation is a scene. Move-out beat: pack, one goodbye from the ledger, the room reacts. Move-in beat: the newcomer arrives with a job, room and want.
- Two exits never confused: voted out (the game) vs moved out (life, dignified).
- House Doubles are continuity and pressure, never leads, never the Cost. If they can't be voted out, say so on screen.
- Structure: daily closer, weekly arc plus finale, monthly season marker with a recap, no hard reset.
- **Follow-up:** rolling arrivals plus the day-1 cameo replace weekly windows. Arrival beat is picture only, 2-4s, after Stake and before Pressure. Up to 2 cameos a day, with an overflow card.
- **Follow-up:** 2-3 vote-outs a week plus the finale vote, not nightly. *Overridden by Ivan: a vote-out every night.*
- **Follow-up:** cast of 3-5 house Doubles plus 10-15 residents (now 4 + 16 as the recommended default). One Door per closer. The showrunner pitch goes in the finale, landing page and end card. Showrunner sims need no house Doubles. 18+ only.

### 8.2 Engagement
- The demo is a series of short seasons with finales. Every departure is a graduation leading to "run your own season."
- Front door = last night's closer on autoplay, not the map. Watching is free, and hosting is the step up.
- Precedents: gate hosting, not watching (the FFXIV trial lets you join but not form a party). Same world public and private (Roblox, VRChat). The hub shrinks as owned spaces grow (Habbo). Failures to learn from: Nothing Forever (decay plus safety ban), Smallville (agents too cooperative).
- A light daily check-in (no control). Queue visible and dated, spectate while waiting. Scarcity is a hook, not retention (Clubhouse).
- Showrunner prompts: after first feature, at graduation, on group pull, at the finale. Never "invite 5 to continue."
- Risks: weak drama among strangers, novelty decay, rotation felt as eviction, safety and consent.
- **Follow-up:** invite-only gates (section 7.1), the day-1 arrival hard rule, the voted-out vs moved-out presentation, vote-ineligibility during the notice.
- *Superseded by Ivan's decisions:* paid queue priority (no monetization). First-round gates (D1 ≥ 27%, D7 ≥ 7-8%, ≥ 90% utilization, 1-5% applicants) were replaced by the follow-up gates.

### 8.3 PLG
- The demo is a fixed residency (7 days proposed). Move-out = your own Double's clip plus a "bring your people" handoff.
- Activation = my Double in a clip I shared within 24h of move-in.
- Honest scarcity: full house → spectate with your real queue position.
- The conversion object is the pending sim: a fill meter, invites that show the recruiter's clip first, labeled placeholders.
- Showrunning free at small scale. Charge later for scale and depth, never for the first sim or for sharing (parked: no monetization this chapter).
- Hand-recruit the first 3-5 showrunners from L-Talks. share_id everywhere.
- Precedents: Among Us, Jackbox and Roblox (host plus room code, a good fit). Wordle (the shareable artifact matters). Gas and BeReal (spikes without a group loop decay).
- Risks: tourist trap, a strangers' village weakening "MY Double," the 5+ wall.
- **Follow-up:** quorum 3 real, target 5. 1 plus-one plus 3 invite links. Qualified-sim and K definitions. The public trigger, revised to pooled ≥ 40.

### 8.4 Andrew Chen
- Showroom, not network. The metric is % of demo visitors starting a showrunner application or group.
- The atomic unit is a showrunner plus a real group. Measure human-to-human conversations and re-shares after flintstoning stops.
- The first 10 showrunners are hand-recruited and invite-only, with staff co-running season 1 and hand-edited trailers.
- AI Doubles as disclosed flintstoning, labeled and excluded from growth claims.
- Escape velocity comes from personal connections: residents share their own sim's trailer with people who know them. The public feed is secondary.
- Ceiling controls: curate public trailers, cap and rotate demo homes, screen showrunners.
- **Follow-up:** go live at 3 real people, aim for 5 by mid-season, test 3/5/8. Selection criteria. The 1 → 2-3 → ~10 sequence. The public signals (a)-(d).

### 8.5 Video Producer
- One public closer per demo night, built automatically. Ship only if the picker score is ≥ 18 with a Peak and a Cost. Skipping beats boring.
- A vertical master, with a ~12s muted cut for Shorts, Reels and TikTok. Telegram gets the full closer. X gets the short cut plus a cliffhanger question.
- CTA only on the end card or caption, one per surface, never in the voiceover.
- A private "Your Double today" clip with a share button, never auto-posted. Every resident featured at least once before leaving.
- Showrunner sims private by default. Public needs the organizer's plus each featured person's opt-in.
- **Follow-up:** never recast real residents. The picker filters on opt-in first, and if nothing qualifies nothing posts. `public_safe`, cut not blur, face-match validator. The 8-12s private day-1 clip spec. Invite-only end-card copy. Their open question on public watching is now settled: yes.

### 8.6 Legal (not counsel)
- 18+ only, with a neutral date-of-birth gate. Teens are out of scope.
- Per-person written likeness opt-in, off by default. Trailers are Doubland's own speech, so Section 230 (the US law that shields platforms from liability for users' posts) protects them only weakly. That means an automated screen plus human approval before every post, and content bans on sensitive topics about real people.
- Withdrawal: new trailers stop immediately, removal from own channels (30 days in the drafts), reposts can't be recalled, consent is logged.
- No face or voice scans. Take It Down process within 48h. DMCA agent.
- A slot is a revocable license. Showrunners can't consent for others, must attest invitees are 18+, and need an FTC disclosure if rewarded.
- **Follow-up:** the three-stage gated checklist (section 6.1). Drafts 01-03. The retention windows. Rev 2 splits leaving a home from deleting a Double.

### 8.7 CTO (advice only)
- Build on live mode plus the existing join/home flow. Join between chunks with a lock, on the demo only.
- A per-sim daily budget cap before launch. One `sim_events` table plus webhooks. Shared infrastructure, no container per sim.
- Blockers: joins refused on live sims, a race in home claim. Missing pieces: memory seeding, a leave endpoint, an inactivity rule, a "no home free" state.
- First memo: model-id mismatch (0423 vs 0731) might overstate cost 1.8-2.9x. Costs came from a formula with unmeasured tokens per step. MVP ~5-7 backend plus 2-3 front-end weeks.
- **Follow-up: LAUNCH BLOCKER.** The production sim API answers with no login and exposes real people's Double names, locations and activities. Lock it down before public watching.
- **Follow-up:** invite-only scope cut, with a revised MVP of ~4.5-6 backend plus ~2-2.5 front-end weeks (section 5.2).
- **Follow-up:** cast 4 + 16. Measured cost ~$0.05 per Double per day, ~$1/day and ~$7 per season for 20 homes. The risk is speed: load test at 20 Doubles.
- **Follow-up:** clips ~$0-0.03 each (~$2-15/month). Remotion license check.
- **Follow-up:** model confirmed as 0731. Costs are recorded ~1.8x high. Price-fix PR pending Ivan's OK.
- **Follow-up:** phase 2 (a)-(e), ~4-6 weeks (section 5.4).

---

## 9. Next actions

1. [ ] **CTO — LAUNCH BLOCKER:** lock down the production sim API (`/api/simulations/`, `/{sim}/costs`, `/{sim}/personas`), which currently answers with no login, before public watching (section 5.0).
2. [ ] **Ivan:** OK the price-fix PR. **CTO:** ship it: log billed `usage.cost`, add the 0731/0423/v4.1-flash prices, warn or refuse on unknown models, re-price past costs (section 5.8).
3. [ ] **CTO:** load test at 20 Doubles. Each simulated minute must finish in under 60s (section 5.6).
4. [ ] **Ivan:** check whether Doubland qualifies for Remotion's free license; otherwise ~$0.01 per render with a $100/month minimum (section 5.7).
5. [ ] **Ivan:** decide the pooled-residents gate, 40 vs 50 (COS recommends 40; section 2.2).
- [ ] **Ivan:** confirm the 4 + 16 cast default and whether Engagement's 80% real-held gate counts only the 16 resident homes (section 11).
- [ ] **Ivan:** name the first hand-picked showrunner (dense active group, e.g. L-Talks).
- [ ] **CTO:** confirm data stores and OpenRouter/provider retention fit Legal rev 2's windows.
- [ ] **CTO (Cloud Agents):** build the invite-only MVP backend (section 5.2): join lock, race-free claim, memory seeding, move-out, 48h/72h inactivity, `sim_events`, budget cap, invite links with share_id, nightly vote-out plus move-in, weekly season rollover, hardened read-only watch view (CDN, rate limits).
- [ ] **Nicolas:** invite-only front end: open / full states, the public watch view, invite-link flow. (The anonymous queue with wait times is dropped for now. Fill meter is phase 2.)
- [ ] **CTO + Video Producer:** `arrival_beat`, `farewell_card`, the `public_safe` flag, face-match validator (fails any render matching a non-opted-in person), private day-1 clip.
- [ ] **CTO:** confirm nightly-vote rotation holds in practice (exits vs arrivals) and that stand-ins backfill empty homes at each cutoff.
- [ ] **CTO + PLG:** share_id end to end, plus the PLG event list.
- [ ] **Reality TV + Screenwriter:** nightly vote segment, arrival and move-out templates, graduation/alumni-card beat at the finale; reconcile where the arrival beat goes.
- [ ] **Legal:** fill the bracketed placeholders in drafts 01-03; prepare stage-1 docs (ToS, Privacy, Community Rules).
- [ ] **Legal + CTO:** under-18 date-of-birth block at invite acceptance; working report/delete email.
- [ ] **Ivan:** approve the stage-1 legal docs before the first invite is sent.
- [ ] **PLG + Engagement:** set up dashboards for section 7 gates. Recalibrate after a 2-week baseline.
- [ ] **PLG + Chen:** prefill showrunner groups with each resident's invitees.

---

## 10. Source conflicts and how they were handled

| Conflict | Resolution |
|---|---|
| Nightly votes (Engagement) vs 2-3 a week (Reality TV) | Resolved by Ivan: a vote-out every night. |
| Weekly move-in windows (Reality TV memo 1) vs 24h activation (PLG) | Resolved: rolling arrivals plus the day-1 cameo and private clip. |
| Human approval of every post (Legal) vs spot-check after ~10 clean nights (Video Producer) | Resolved by Ivan: he approves every public trailer. |
| Automated daily trailers (Ivan's ask) vs human sign-off (Legal) | Resolved: automated build and gates, then Ivan's approval. |
| Quorum 5 vs lower | Resolved: live at 3 real, target 5. |
| Notice ~7 days (Legal first draft) vs 48h/72h (Engagement) | Resolved in Legal rev 2: 48h notice, 72h move-out, deletion on a separate timeline. |
| Alumni promise vs 30-day deletion | Resolved in rev 2: the Double stays on the account. Deletion only on request, closure, or 24 months of inactivity. |
| Showroom (Chen) vs growth engine (Ivan's framing) | Resolved: showroom. Conversion to showrunners is the metric. |
| Engagement's first-round KPI gates vs follow-up gates | Follow-up gates used. |
| Paid priority (Engagement) and later monetization (PLG) vs no monetization | Resolved by Ivan: none this chapter. |
| Open public join (Ivan's original ask) vs invite-only (PLG, Chen, CTO) | Resolved by Ivan: invite-only first. Anyone can watch. |
| Consent draft 01 (blur or stand-in) vs Video Producer (cut, never recast) | Resolved: draft 01 now aligned. Unidentifiable background extras or cut, no recast, no visible blur. |
| Residency length: fixed 7 days (PLG) vs open-ended (Engagement) | Resolved by Ivan: one weekly season, graduation at the finale. |
| Model 0423 (source of truth) vs 0731 (memory, Ivan) | Resolved: CTO confirmed `deepseek/deepseek-v4-flash-0731`, and the source of truth now says 0731. |
| Cast 3-5 house + 10-15 residents (Reality TV) vs 20-home cap | Resolved: 4 + 16 recommended (CTO), inside Reality TV's range. |
| Formula cost estimates ($104-626/month) vs measured cost | Resolved: measured ~$1/day for 20 homes replaces the estimates. |

---

## 11. Unresolved conflicts

1. **Arrival beat placement:** Reality TV puts it after Stake and before Pressure. Engagement says after the vote and before the final line. → Template owners reconcile.
2. **Resident volume gate:** Engagement's 50 (now pooled) vs PLG's pooled 40. Two seasons pool about 42-52 with 16 resident homes, so 50 needs maximum churn. → Ivan decides; COS recommends 40.
4. **80% real-held homes (Engagement) vs 4 house Doubles:** house Doubles take 20% of 20 homes, so 80% over all homes allows zero AI stand-ins. → COS suggests measuring over the 16 resident homes; Ivan to confirm.
3. **Engagement's "1 showrunner launched with ≥ 5 completed profiles"** vs the go-live quorum of 3 real people. Both are kept: 3 is go-live, and the public gate asks for one sim at the 5 target. Flagged for Ivan's awareness.
