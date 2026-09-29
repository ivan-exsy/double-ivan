# VC Pitch Doctrine: Doubland, Chen-first

**Last updated:** 2026-09-28
**Owner:** Ivan
**Status:** Doctrine. Not a todo list.

---

## 0. What this doc is

This is the pitch doctrine for the Doubland raise. It says what we claim, which metrics lead, what order the deck goes in, and which decisions are locked. It is written through Andrew Chen's lens (a16z, *The Cold Start Problem*) because that is the first target.

Live todos do not go here. They live in `IVAN_pre-MVP.md` (the file previously named `20260917_pre-MVP.md`), under "LeaderTalks play" (PM-LTALK-2 through PM-LTALK-8 and the operator runbook). The measurement contract is Current in `double-docs/sot/sot_api.md` §10. The June release gate is archived at `done/TODO_mvp-release-gate.md`. The June 2026 planning material that used to fill this file is kept in the Appendix, marked superseded where it conflicts with the sections above it.

Rules for this doc: never invent traction, investor interest, or comps. Honest zeros are fine. Adults first; teens and campus come later and are never the lead framing.

---

## 1. Thesis in Andrew Chen's terms

Doubland is a new kind of personalized entertainment and a new social format. Real people take a personality test and get a Double, an AI version of themselves that lives in a village simulation with the Doubles of the people they already know. Every day the product auto-generates a short video episode of what the group's Doubles did. You do not play it and you do not have to feed it. You watch a show about you and your people.

Product clarity for the pitch: Doubland is not another social network. It needs no continuous babysitting input from users. It is a show about you with a heavy social layer. To Chen, "a new social network format" is the thesis fit; in the room we still say plainly that we are not asking people to post.

Network shape, in Cold Start terms:

- **Hard side: Showrunners.** The organizer who brings a named, real group into Doubland, gets members through the test and profile, and sustains the season. Without a Showrunner a village is an empty map, no matter how good the video looks.
- **Soft side: the cast and viewers.** Members whose Doubles appear in the show, plus the people who watch, claim their Double, share, and come back.
- **Atomic network:** one Showrunner-led group with enough of its roster active that the daily episode is about people who know each other. Density before scale.

The first public sim is LeaderTalks (L-Talks), an adults-first Telegram group, with Ivan as Showrunner #1. The cast is the 15 Doubles already built on soul_15.

---

## 2. Why Chen

Everything in this section comes from founder notes on Andrew Chen interviews (`cos/agents/vc/kb/raw/user-provided/2026-09-17-andrew-chen-cold-start-notes.md`). These are not verified quotes and not a signal that he will meet or invest.

- **He invests very early** when the early signals are real, the idea is genuinely new, and it rides the right trends.
- **His interests line up with Doubland:** new formats (such as auto-generated short video), new gaming built on the latest tech, new personalized entertainment formats, and new social network formats.
- **He judges on retention and pull.** Retention means people come and stay. Pull means people need more of it.
- **He cares about the hard side.** In his framework seed networks die without it. For Doubland that is Showrunners, not viewers.
- **Warm intro path:** CMU, then LeaderTalks, then a DM on X. The intro graph is part of the raise process, not a product ticket.
- **HPVP rhymes.** HPVP's bar (viewers, join requests, time on platform) measures the same thing as Chen's retention and pull, so one operator log serves both.

Post-MVP only: Chen's Tinder-style campus party distribution idea (profile plus test as the pass-in, sim on a big screen). It goes to Engagement after LeaderTalks, with Legal before any campus or teen public claim. It is not part of this pitch.

---

## 3. What the first public sim (LeaderTalks) must prove

1. **Retention.** The people who watched night 1 are still watching on night N. The curve flattens instead of decaying to zero.
2. **Pull.** People want more without being asked: they ask what happens tomorrow, ask to join or add someone, and claim their Double.
3. **The hard side works.** Ivan runs one group end to end as Showrunner #1, and at least a few named people ask to run it for their own group (the target is 1 to 3 named yeses, not a blast).
4. **Recognizability.** Members react with "that's so them." This is also the answer to "why isn't this just GPT": the fidelity of the Doubles is the tech story.

We are not proving traction-scale volume. At this size a smart VC discounts raw counts instantly. We are proving intensity of pull on the right side of the network.

---

## 4. Metric stack

Capture facts reused from the June 16 production verification (Appendix A9): the waitlist records signups per source, not clicks, because no redirect hop was built. Retention from YouTube Studio is aggregate, not per-user cohorts, so the per-person retention curve comes from the manual operator log. The Telegram tag `tg-survival-d{N}` (and `tg-survival-premiere` for the opener) is manual and must be pasted into every post, or those signups collapse into `landing-hero`. On-screen end-card URLs cannot be tagged and also read as `landing-hero`.

### Hero metrics

| Metric | Definition | How captured | Honest limit |
|---|---|---|---|
| Retention curve | The same night-1 cohort (named people who watched or reacted on night 1) tracked through night N. Does it flatten or decay to zero? | Manual operator log per drop (PM-LTALK-4): who from the night-1 set is back. YouTube Studio returning viewers as a cross-check. | Per-person tracking is manual and only sees people who react or tell us. YouTube retention is aggregate, not a cohort. Small N. |
| Pull per episode | Unprompted "what happens tomorrow" questions, add or join requests, and claims per drop, shown as a trend across drops. | Manual log plus screenshots per drop, tied to the episode that triggered it. Claims come through the Claim/Remove runbook. | Manual and qualitative. Only counts what is visible in chat, DMs, or email. |

### Hard-side metrics

| Metric | Definition | How captured | Honest limit |
|---|---|---|---|
| Showrunner count | Named people who accepted the host role (Ivan plus recruits). | Operator log (PM-LTALK-5, PM-LTALK-6). | Starts at 1. Recruiting is after pull is visible, not night 1. |
| Showrunner-sourced asks | Named "run it for my group" requests, separate from soft-side claims. | Screenshot plus who plus episode. Waitlist `interest_type = b2b_group` with `group_name` from the live "Run Doubland for Your Group" footer door (PM-LTALK-7). | A form submit is interest, not an activated group. |
| Time to activate a new group | Time from a Showrunner saying yes to their roster being tested, profiled, and in a sim. | Operator log dates. | Only measurable once a second group exists. |
| Roster activation % | Share of the invited roster that finished test plus profile. | Operator log (Flintstone roster is fine). | Manual. Depends on how the roster is defined. |

### Atomic network health

| Metric | Definition | How captured | Honest limit |
|---|---|---|---|
| Density | Share of the roster that watched or engaged with the show. | Operator log against the named roster. | Silent watchers are invisible unless the platform reports them. |
| Unprompted activity | Whether activity continues on days the founder does not push. | Operator log marks which days Ivan nudged and which he did not. | Needs discipline to record the nudge days honestly. |

### Second-group signal (only if it is real)

| Metric | Definition | How captured | Honest limit |
|---|---|---|---|
| Group #2 speed | Whether group #2 activates faster or with less founder time than LeaderTalks. | Founder time and activation dates in the operator log. | Only report if a second group actually runs. Never stand up empty parallel groups to fill this row. |

### Supporting metrics

| Metric | Definition | How captured | Honest limit |
|---|---|---|---|
| Completion % | Share of viewers who watch each episode to the end. | YouTube Studio. | Aggregate. Only for traffic that lands on YouTube. |
| Attributable funnel (view to signup) | Signups by episode and channel, set against views per episode. | Waitlist `source` tag per signup (verified in production 2026-06-16). | Signups per source, not clicks. Untagged Telegram posts and end-card URLs read as `landing-hero`. |
| Organic spread | Reach and forwards with zero paid spend. | Manual Telegram tally; `sim-share` and `play-hud` tags for signups from viewer re-shares. | Forwards are hand-counted. |
| Recognizability log | "That's so them" quotes and screenshots. | Qualitative log per drop. | Qualitative by design. Needs consent to show in a deck. |

### Ignore or de-emphasize

Raw view counts, total reactions, follower counts, and any other vanity totals. They are small at this scale and VCs know it.

---

## 5. First public sim results (LeaderTalks)

No numbers go here until they come from the sim and the operator log. Honest zeros are fine. Never invent a value.

| Metric | Value |
|---|---|
| Retention curve (night-1 cohort through night N) | TBD, fill from sim data |
| Pull per episode (tomorrow questions, add or join requests, claims) | TBD, fill from sim data |
| Showrunner count | TBD, fill from sim data |
| Showrunner-sourced "run it for my group" asks | TBD, fill from sim data |
| Time to activate a new group | TBD, fill from sim data |
| Roster activation % | TBD, fill from sim data |
| Density (share of roster that watched or engaged) | TBD, fill from sim data |
| Activity on non-push days | TBD, fill from sim data |
| Second-group signal | TBD, fill from sim data |
| Completion % | TBD, fill from sim data |
| Attributable funnel (view to signup) | TBD, fill from sim data |
| Organic spread (zero paid) | TBD, fill from sim data |
| Recognizability quotes and screenshots | TBD, fill from sim data |

---

## 6. Deck order

1. **Retention curve.** The night-1 cohort through night N.
2. **Pull.** Per-episode trend of tomorrow questions, add or join requests, and claims.
3. **Showrunner proof.** Named Showrunners, roster activation, Showrunner-sourced "run it for my group" asks.
4. **Inbound quotes.** Named "build one for my group" and "that's so them" screenshots, with consent.
5. **Attributable funnel.** Every signup traces to an episode. This proves the pull is real and attributable; it is not a volume slide.

**Fallback if retention decays:** lead with the Showrunner story and the pull quotes, and say plainly what is being fixed (for example serialization and cliffhangers, or Double fidelity) and how we will know it worked. Do not pad the deck with spread or view counts to cover the gap.

---

## 7. Locks and decisions

| Item | Lock |
|---|---|
| Consent | Surprise group review, then Claim double / Remove double in chat. Locked 2026-08-31. Handled by hand, no product build. Remove is no questions asked and honored within about 24 hours. Portrayals stay affectionate and flattering. The June brief-first triage (Appendix A5) is retired. Runbook: `IVAN_pre-MVP.md`. |
| Showrunner title | Locked 2026-09-18. "Doubland Admin" is retired as a live term. Avoid Admin, Moderator, Community Manager, Ambassador. |
| Measurement layer | Live. Waitlist `source`, `interest_type`, and `group_name`, verified end to end in production 2026-06-16 (`sot_api.md` §10). Do not rebuild attribution. |
| Showrunner waitlist door | Live on www.doubland.ai since 2026-09-24 ("Run Doubland for Your Group"; every submit is `b2b_group`). No second form. |
| Showrunner compensation | Free for organizers. Status, tools, recognition, and soft credits come first. No cash pitch this pass. Any cash, stipend, or rev-share goes to Legal before any promise. QSBS and entity questions go to Tax. |
| Season Spec | Locked 2026-09-18: premiere opener (`tg-survival-premiere`), then 15 evening drops (`tg-survival-d1` to `tg-survival-d15`), one Telegram post per evening, night 15 is winner plus season overview. Detail in `IVAN_pre-MVP.md` (PM-LTALK-2). |
| Audience | Adults first (LeaderTalks). School, campus, and teen go-to-market come later and never lead the pitch. |

**Showrunner twist on the older money slides (carried from the old §11):** split inbound demand into (a) soft-side "want more" or claim and (b) Showrunner-sourced "run a season for my group". (b) is the Cold Start closer. Log whether night-N returners sit in a named Showrunner roster. Treat `b2b_group` with `group_name` as Showrunner interest when the ask is to host or organize. Do not swap magnetism or spread for hard-side vanity.

**Promote and defer (carried from the old §11):**
1. Keep: measurement tags, daily tape quality, retention and pull logging.
2. Add now (Flintstone is fine): Showrunner identity plus one job (invite, roster done, watch together); recruit 1 to 3 next Showrunners from L-Talks after pull is visible.
3. Defer: cash for Showrunners; campus party distribution; teen or public-graph Showrunner go-to-market; parallel empty groups.

**Open items:**
- **Season cadence beyond LeaderTalks.** The LeaderTalks season is locked; the cadence for later seasons and for group #2 is not.
- **Distribution mix check.** Native Telegram post plus tracked YouTube link is the locked drop shape. Whether and when to add the per-Double 9:16 15-second clips (PM-BFST-4) is still open.
- **Scope guard.** Serialized cliffhangers, Survival "that's so them" fidelity (PM-VIL-2), and letting the group influence the sim stay held until the numbers justify them. Revisit after the first results are in, using the fallback logic in §6.

---

## 8. Showrunner operator checklist (LeaderTalks to VC deck)

Carried over intact from the old §11 lock (2026-09-18). The live copy sits on PM-LTALK-4 in `IVAN_pre-MVP.md`.

Each drop / week, capture honest zeros if empty:
1. **Showrunner count**: named hosts who accepted (Ivan + recruits)
2. **Activation**: % of invite roster who finished test + profile
3. **Create+share**: Showrunner (or co-creator) originated a personal share
4. **Showrunner-sourced pull**: named "run this for my group" (screenshot + who)
5. **Retention**: night-N returners (same people)
6. **Pull**: join/claim, forwards, time, want-more (HPVP bar)
7. Tags: paste `tg-survival-d{N}` every post (§9 discipline, now Appendix A9)

---

## Appendix: Archive (June 2026), superseded where it conflicts with the sections above

Kept for history and for the facts it records. Section numbers are the old ones, prefixed with A. Lines marked **[Superseded]** are no longer doctrine.

**Original header.** Title: "Release Gate: Telegram 'Doubles' Demo as a Fundraising Asset." Date 2026-06-02, owner Ivan.

**Original context.** MVP was close (sims ran, trailer generation mostly fixed, Nicolas integrating the video section on the landing page). The plan was to build AI Doubles of the 15 most active members of a 300+ person alumni Telegram group (founders, VCs, corporate leaders), run them through Survival, and post daily video updates back to the group to generate engagement and demand signals for the raise. **[Superseded in framing]** The live play is LeaderTalks with Ivan as Showrunner #1 and the soul_15 cast (§1, §3).

### A0. TL;DR (June)

- We are not proving traction. At 15 subjects in a group of about 300 the numbers are small. We are proving magnetism and demand: that Doubles of real people are compelling enough that a hard-to-impress audience watches, shares, and asks for one for their own group.
- Fundraising wedge: Community/B2B pull. The money signal was inbound "build one for us" requests from a room of founders and VCs. (This became Showrunner-sourced pull in §4.)
- First thing to build: the measurement and funnel layer. **[Superseded]** "Today we can't see view to click to signup, and the waitlist captures email only" is stale; the layer was built and verified in production on 2026-06-16 (A9).
- The content engine was about 80% there. The gaps were measuring and packaging, not a big new build.
- Privacy: pseudonyms and generic photos protect the public layer but not identities inside the group. **[Superseded]** The recommended triage rollout and brief-first approach were replaced by surprise group review plus Claim/Remove, locked 2026-08-31 (§7). Dropping the "all matches are incidental" disclaimer for honest, playful framing still stands as advice.

### A1. The play and why it works (June)

What: 15 Doubles of the group's most active members, a Survival season, daily video updates posted in the group.

Why it is strong: a warm, dense, high-value network where people know each other (some could be investors); personalization is an irresistible hook, and the 15 become the distribution engine; the group is the channel, so zero paid acquisition; the content is the demo.

Structural truth: a demo this size cannot produce traction-scale metrics, so we compete on intensity, not volume, and frame the raise as "here is the intensity of pull, extrapolate it." **[Superseded in part]** June instrumented for completion, spread, conversion intent, and inbound demand. Retention and pull now lead (§4).

### A2. Decisions locked (June)

| Decision | Choice | Implication |
|---|---|---|
| Fundraising wedge | Community/B2B pull | Hero metric was inbound "build one for my group or company." CTA "Bring this to your community," not a generic signup. **[Superseded]** Hero metrics are now retention and pull; the hard-side ask is Showrunner-sourced. |
| Build first | Attribution plus CTA | Done and verified (A9). |
| Consent / rollout | Pending, leaning triage | **[Superseded]** Surprise group review plus Claim/Remove, locked 2026-08-31. |
| Hard-side role title | Showrunner (locked 2026-09-18) | Now in §7. |

### A3. Metrics that matter (June "four money slides")

1. Magnetism / completion: share who watch each 60 to 90 second episode to the end (YouTube gives this free). High completion against the roughly 50 to 60% norm means genuinely gripping. Pair with in-group reaction rate. **[Superseded as lead]** Now a supporting metric (§4).
2. Spread: people reached plus forwards with zero ad spend ("one group of 300 reached N via M forwards").
3. Conversion funnel: views to link clicks to waitlist signups, plotted against drops. **[Superseded]** "This is the one we can't measure today" is stale; closed 2026-06-16, with signups per source rather than clicks (A9).
4. Inbound demand (the closer): unsolicited "can you build one for my community, company, or portfolio?" requests, ideally from named founders or VCs. Quotes beat numbers; log and screenshot every one with the triggering episode.
5. (Optional, for a full multi-day season) Daily-return retention: do day-5 viewers come back from day 1? **[Superseded]** Retention is now a required hero metric (§4).

Defensibility note: VCs will ask why this isn't just GPT. The proof is recognizability ("that's SO them"), which evidences cognitive depth (memory, emergent behaviour). Still valid (§3).

Ignore as vanity: raw view count, total reactions, follower count. Still valid.

Capturable today vs gap (June): YouTube views and completion free if posted to YouTube; Telegram reactions, forwards, and inbound by manual tally. **[Superseded]** "Click to signup attribution is the one real gap" is stale (A9).

Insight: no analytics platform needed; a tiny attribution tag plus the discipline to log qualitative inbound.

### A4. Missing functionality, prioritized by traction leverage (June)

What already existed: Survival Mode (elimination game with daily challenges, voting, alliances, betrayals, eliminations, day summaries, relationship states, a "Previously on" recap card); video pipeline (per-day per-character 60 second trailers, per-day ensemble recap, pre-sim cast opener, personalized with personality, daily plan, real dialogue quotes, and a hand-drawn sketch portrait); funnel skeleton (waitlist endpoint plus YouTube-only distribution with deep links to the play page).

Tier 1 (cheap, required to prove anything): attribution and funnel (source/UTM tags on deep links, `source` field on the waitlist, per-episode and per-subject capture, a simple readout); a CTA in the content (end-card CTA, tracked link in post copy, re-enable the built but disabled 9:16 vertical format); a separate "build one for my group" capture, where even a fake door counts as data. **[Done]** Attribution and capture shipped (A8, A9); the Showrunner door is live (§7). Vertical 9:16 clips remain on PM-BFST-4.

Tier 2 (multiplies engagement): per-subject shareable clips ("your Double's day"); serialized show quality (day-overview narration read as disconnected captions; no season arc or cliffhangers); persona fidelity in Survival (every agent started neutral at 0.5 and drama was purely emergent, so Survival was not personality-aware). Still held (§7 open items).

Tier 3 (most fundable, biggest build): let the group influence the sim (vote on immunity, suggest a scenario, ask a character a question). Held until the base play is measured.

### A5. Privacy and consent (June)

June plan: psychological Doubles of real members; fictionalized names recognizable to the subject but not obvious to outsiders ("Misha Kryukov" to "Mike Hooks"); generic AI photos; an "all matches are incidental" disclaimer; claim your Double by creating an account and linking it.

June assessment, still useful as background:
- The veil protects against outsiders, not the in-group. Everyone who knows the subject can decode the name. The real risk is an influential peer feeling caricatured in front of people you both care about.
- "All matches are incidental" is the weak link and reads as a wink. Suggested replacement: "AI doubles inspired by the legends of this group, fictionalized with love, names changed to protect the guilty."
- The psychological profile is more sensitive than the name. Keep every portrayal affectionate and flattering, not exposé. (Still a live rule, §7.)
- Light flag, not legal advice: profiling identifiable people and publishing it is the sensitive combination (reputational, plus data-protection norms if any subjects are in the EU or UK).

**[Superseded]** June recommended triage: brief senior or sensitive subjects first (as the first B2B sales call), surprise the playful ones, soft-launch with 2 or 3, and add a quiet "this isn't me / remove me" path. Replaced by surprise group review plus Claim/Remove, locked 2026-08-31 (§7). The remove path survives as the Remove half of that lock.

### A6. Action plan (June)

A. Build now, the measurement layer: UTM tags on deep links; `source` on the waitlist; a distinct "Bring this to your community" B2B capture; end-card CTA plus tracked link and 9:16 vertical; a one-screen funnel readout. **[Done]** except vertical clips (PM-BFST-4).

B. Prepare the run: pick the 15 **[Done: soul_15]**; triage into brief-first vs surprise **[Superseded: consent lock, §7]**; tone check each portrayal; swap the "incidental" disclaimer for the honest-playful frame; package per-subject vertical clips; distribution as a native Telegram post plus a tracked link to the full episode. (Live version: PM-LTALK-2 and PM-LTALK-3.)

C. During the season: post daily; capture YouTube completion and the funnel readout; tally reactions and forwards by hand; log and screenshot every "can I get one for my X" with its episode; run brief-first conversations as soft sales calls **[Superseded: consent lock]**. (Live version: PM-LTALK-4.)

D. Decide later: if retention is the gap, invest in serialization; if "that's so them" lands weakly, invest in persona fidelity; if we want a daily participation loop, build the interactive mechanic.

Operational note, still valid: do not run trailer generation while a sim is generating. Shared headless-browser contention on localhost:3000 can crash the sim. Sequence them.

### A7. Open decisions (June)

- Consent and rollout: confirm triage. **[Superseded]** Locked 2026-08-31 (§7).
- Season length and cadence. **[Resolved for LeaderTalks]** Season Spec locked 2026-09-18. Later-season cadence is open (§7).
- Distribution: native Telegram vertical plus tracked link vs YouTube link only. **[Resolved]** One Telegram post per evening with the YouTube link and short copy (§7). Vertical clips optional (PM-BFST-4).
- Scope guard: do not build Tier 2 or 3 until the base play's numbers justify it. Still in force (§7).

### A8. Implementation updates (2026-06-04)

Launch package: the core play plus a B2B CTA that surfaces a paid or premium interest tier from day one, for willingness-to-pay signals without first solving onboarding friction or multi-sim backend limits.

Landing spec v8 measurement layer: a B2B capture reusing the footer newsletter block, with two micro-buttons ("Stay updated" and "Bring this to my group") feeding one waitlist form. Payload extended with `source`, `interest_type` (`generic` or `b2b_group`), and optional `group_name`, on the existing `POST /api/waitlist`. All primary "Create your Double" CTAs open that form; the external `app.ondouble.com` link was removed. Email line: "Request Doubland for your team or group, or just stay in the loop." **[Superseded in part]** The footer door is now the Showrunner door, "Run Doubland for Your Group" (live 2026-09-24, §7). The B2B line on Watch (PM-BFST-5) was dropped 2026-09-24.

June "next steps" (triage consent, season length, distribution) are superseded by §7.

### A9. What we actually built (2026-06-16)

The Tier 1 measurement layer was built, deployed, and verified end to end through the live production path on 2026-06-16: a live submit (browser to landing proxy to gateway to Supabase) confirmed that a tagged B2B signup persists correctly and that the never-downgrade ratchet holds. Build detail and verification: `double-docs/done/20260615_link-tracking.md`. Durable contract: `sot/sot_api.md` §10. Ready-to-run deck queries (per-episode funnel, channel split, B2B lead list) are in the link-tracking doc under "Operator runbook", "Deck cuts".

What it unlocked: every signup records `source` and a timestamp, so views to signups by episode is a real, attributable curve, with the channel split (Telegram, YouTube, viewer share, organic) from the same data. `interest_type = b2b_group` plus `group_name` make "build one for my group" countable, with names and the triggering episode. `sim-share` and `play-hud` tags count signups from viewers re-sharing a sim.

Honest limits (still true, reused in §4): signups per source, not clicks, since no redirect hop was built; retention is aggregate (YouTube Studio plus manual view curve), not per-user cohorts; on-screen end-card URLs cannot be tagged and read as `landing-hero`.

Operational dependency (still true): YouTube and viewer-share tags are automatic, but the Telegram `tg-survival-d{N}` tag is manual and must be pasted into every post.

**[Superseded]** June deck reframe: "lead with completion % and B2B asks plus named quotes, use the funnel as proof." Retention and pull now lead (§6).

### Folded sections

The old §10 (Chen / a16z metric lens, 2026-09-17) is folded into §2, §4, and §6. The old §11 (Cold Start hard side = Showrunners, locked 2026-09-18) is folded into §1, §4, and §7, and its operator checklist is §8.
