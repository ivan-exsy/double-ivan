# Release Gate — Telegram "Doubles" Demo as a Fundraising Asset

**Date:** 2026-06-02
**Owner:** Ivan
**Status:** Strategy notes + action plan. Wedge and first build **decided**; consent/rollout **being refined**.

**Context:** MVP is close (sims run, trailer gen mostly fixed, Nicolas integrating the video section on the landing page). This doc plans the launch play: build AI **"doubles"** of the 15 most-active members of a 300+ person elite alumni Telegram group (founders / VCs / corporate leaders), run them through **Survival**, and post daily video updates back to the group — to generate the engagement and demand signals that fuel the raise.

---

## 0. TL;DR

- We are **not proving "traction"** — at 15 subjects / 300 people the numbers are small, and a smart VC discounts "we got 40 reactions" instantly. We're proving **magnetism + demand**: that AI doubles of real people are so compelling that a hard-to-impress audience watches, shares, and asks *"can I get one for my own group?"*
- **Fundraising wedge = Community/B2B pull.** The money signal is **inbound "build one for us" requests** from a room full of founders and VCs.
- **First thing to build = the measurement / funnel layer** (attribution + a B2B call-to-action). Today we can't see view → click → signup, and the waitlist captures email only. Without this, the play generates no provable numbers.
- The content engine is **~80% there** already. The gaps are about **measuring** and **packaging**, not a big new build.
- **Privacy:** the pseudonyms + generic photos are smart for the *public* layer but don't hide identities from the *in-group*. Recommend a **triage rollout** (brief the senior/sensitive subjects first — which doubles as the first B2B sales call — surprise the playful ones) and drop the "all matches incidental" disclaimer for honest-playful framing.

---

## 1. The play & why it works

**What:** 15 doubles of the group's most-active members → a Survival season → daily video updates posted in the group.

**Why it's strong:**
- Warm, dense, high-value network (300 people who know each other; founders + VCs — some could be investors).
- Personalization is an irresistible hook — people can't *not* watch a version of themselves; the 15 become the distribution engine.
- The group **is** the channel — zero paid acquisition.
- The content **is** the demo — VCs see the product working, not a deck.

**The structural truth (read this twice):** a 15/300 demo can't produce traction-scale metrics. So we don't compete on volume. We instrument for **completion, spread, conversion intent, and inbound demand**, and we frame the raise as *"here's the intensity of pull — extrapolate it,"* not *"here are our big numbers."*

---

## 2. Decisions locked

| Decision | Choice | Implication |
|---|---|---|
| Fundraising wedge | **Community/B2B pull** | Hero metric = inbound "build one for my group/company." The CTA is **"Bring this to your community,"** not a generic signup. |
| Build first | **Attribution + CTA** | Make the funnel measurable *before* adding content features. |
| Consent / rollout | *Pending* — leaning **triage** (see §5) | — |

---

## 3. Metrics that matter (what proves it to a VC)

### The four "money slides"
1. **Magnetism / completion** — % who watch each 60–90s episode to the end (YouTube gives this free). High completion vs. the ~50–60% norm = genuinely gripping. Pair with in-group reaction rate.
2. **Spread** — people reached + forwards/shares with zero ad spend. *"One group of 300 → reached N via M forwards."* The network expanding itself.
3. **Conversion funnel** — views → link clicks → waitlist signups, plotted against episode drops. **This is the one we can't measure today.**
4. **Inbound demand (the closer)** — unsolicited *"can you build one for my community / company / portfolio?"* requests, ideally from named founders/VCs. **Quotes beat numbers here** — log and screenshot every one, attributed to the episode that triggered it.

### If we run a full multi-day season
5. **Daily-return retention** — do day-5 viewers come back from day-1? The most fundable engagement metric there is.

### Defensibility note
VCs will ask *"why isn't this just GPT?"* The proof is **recognizability** — *"that's SO them."* That reaction is evidence of the cognitive depth (memory, emergent behaviour), so let the doubles' fidelity carry the tech story.

### Ignore (vanity)
Raw view count, total reactions, follower count — small at this scale, and VCs know it.

### Capturable today vs. gap
- ✅ YouTube views / completion (free) — *if* posted to YouTube.
- ✅ Telegram reactions / forwards / inbound — **manual** tally is perfectly fine at this scale.
- ❌ Click → signup attribution — **the one real gap.** No source/UTM on links; the waitlist stores email only.

**Insight:** we don't need an analytics platform. We need a tiny attribution tag + the discipline to log qualitative inbound. That's it.

---

## 4. Missing functionality, prioritized by traction leverage

### What already exists (we're ~80% there)
- **Survival Mode:** elimination game, daily challenges / voting / alliances / betrayals / eliminations, day summaries, relationship states, a "Previously on…" recap card.
- **Video pipeline:** per-day per-character 60s trailers + per-day ensemble recap + a pre-sim cast opener; personalized with each character's personality, daily plan, **real dialogue quotes**, and a hand-drawn sketch portrait.
- **Funnel skeleton:** a waitlist endpoint + YouTube-only distribution with deep-links to the play page.

### Tier 1 — cheap, and the play can't prove anything without them (days)
- **Attribution + funnel.** Add source/UTM tags to the play-page deep-links and a `source` field to the waitlist; capture which episode/subject drove each signup; a simple way to read views → clicks → signups.
- **A CTA in the content.** Today the video has *no* link/CTA (end card only). Add an end-card CTA + a tracked link in the post copy. **Re-enable the 9:16 vertical format** (built but currently disabled) — vertical wins for in-feed / Telegram sharing.
- **A separate "build one for my group" capture** — distinct from the generic email waitlist. This is the wedge-demand signal that raises money; even a fake-door counts as data.

### Tier 2 — multiplies the engagement the play generates
- **Per-subject shareable clips.** Package each character's existing video as a personal, forwardable *"your double's day."* 15 subjects forwarding to *their* networks = the reach multiplier.
- **Serialized show quality.** Known issue: day-overview narration reads as disconnected captions; Survival has day boundaries but no season-arc/cliffhanger framing. Continuous narration + cliffhangers + recaps = the daily-return retention curve.
- **Persona fidelity in Survival.** Today every agent starts neutral (0.5) and drama is purely emergent — Survival isn't personality-aware. For a *real-people* play, recognizability is the whole magic; making outcomes reflect each person's known traits is the heart of the differentiation (and the tech proof).

### Tier 3 — most "fundable" feature, biggest build
- **Let the group influence the sim** — vote on immunity, suggest a scenario, ask a character a question. Converts passive viewers into daily participants and is a differentiated product story. **Hold** until the base play is measured — unless we deliberately want it as the demo centerpiece.

---

## 5. Privacy & consent

**Current plan:** psychological doubles of real members; fictionalized names recognizable to the subject but not obvious to outsiders (*'Misha Kryukov' → 'Mike Hooks'*); generic AI photos detached from real faces; post with *"all matches are incidental"*; let people claim their double (create account → link it).

**Assessment:**
- **The veil protects against outsiders, not the in-group.** The names are *designed* to be recognizable; in a 300-person group where everyone knows each other, if the subject can decode it, so can everyone else. Good protection against random viewers / journalists / leaked screenshots — **no** protection against the one risk that hurts the raise: an influential peer feeling caricatured in front of people you both care about.
- **"All matches are incidental" is the weak link.** To founders/VCs it's transparently untrue (the puns are deliberate) — little real cover, and reads as a wink. Replace with honest-playful: *"AI doubles inspired by the legends of this group — fictionalized with love, names changed to protect the guilty."*
- **The psychological profile is more sensitive than the name.** Publishing how a peer-identifiable person thinks/behaves under pressure — inside a game of betrayal and elimination — is the part that can sting. Keep every portrayal affectionate/flattering, not exposé.
- **The rollout is optimized for the wrong goal.** "Post first, claim later" maximizes surprise/virality (the *consumer* play). We chose **B2B** — where telling the subject *first* IS the first sales call and the best demand slide.

**Recommended approach — triage, not all-or-nothing:**
- **Public layer:** keep pseudonyms + generic photos as planned.
- **Senior / sensitive / less-flatteringly-portrayed subjects → brief first** (or leave out). Highest value, highest risk; the heads-up turns them into amplifiers and doubles as the B2B ask.
- **Playful, well-known-to-you, flattering portrayals → surprise in-channel is fine** and makes great authentic content. **Soft-launch with 2–3** to read the room first.
- **Keep "claim your double"** (great account hook) + add a quiet *"this isn't me / remove me"* path.
- Light flag (not legal advice): the sensitive combination anywhere is *profiling identifiable people + publishing it.* Recognizability is what trips it (reputational, plus data-protection norms if any subjects are EU/UK based). Having asked is the single best protection on every axis.

---

## 6. Action plan (sequenced)

### A. Build now — the measurement layer (Tier 1)
1. Add source/UTM tagging to the play-page deep-links (per episode, per channel).
2. Add a `source` field to the waitlist; record which episode/subject drove each signup.
3. Add a distinct **"Bring this to your community"** B2B CTA + capture (separate from the email waitlist).
4. Add an end-card CTA + tracked link to the video/post; **re-enable 9:16 vertical** output.
5. Stand up a one-screen funnel readout (views → clicks → signups; even a simple query/sheet to start).

### B. Prepare the run
6. Pick the 15; triage into "brief-first" vs "surprise" buckets (§5).
7. Sanity-check each portrayal for tone — affectionate/flattering, not exposé.
8. Swap the "incidental" disclaimer for the honest-playful frame.
9. Package per-subject shareable clips (vertical) so each subject can forward their own.
10. Decide distribution: native vertical clip in Telegram (reach) **+** tracked link to the full episode / play page (analytics + conversion) — get both.

### C. During the season
11. Post daily; capture YouTube completion + the funnel readout each day.
12. Manually tally in-group reactions/forwards; **log + screenshot every "can I get one for my X"** with the episode it came from.
13. Run the brief-first conversations as **soft sales calls** (*"…want one for your own company / portfolio / club?"*).

### D. Decide later, based on early numbers (Tier 2/3)
14. If retention is the gap → invest in serialization (continuous narration, cliffhangers, season arc).
15. If "that's so them" is landing weakly → invest in Survival persona fidelity.
16. If we want a daily participation loop / standout demo feature → build the interactive mechanic.

### Operational notes
- **Don't run trailer generation while a sim is generating** — shared headless-browser contention on localhost:3000 can crash the sim. Sequence them, don't overlap.

---

## 7. Open decisions needed from Ivan
- **Consent / rollout:** confirm the triage approach (who to brief vs. surprise; which 2–3 allies to soft-launch with).
- **Season length / cadence:** how many days, posting frequency.
- **Distribution:** confirm native-Telegram-vertical **+** tracked-link (vs. YouTube-link-only, which loses in-group reach but keeps free analytics).
- **Scope guard:** agree to *not* build Tier 2/3 until the base play's numbers justify it.

---

## 8. Implementation updates (2026-06-04)

**Launch package locked:** Execute the core play (15 doubles → Survival season → daily videos in the Telegram group) with one addition — the B2B CTA now surfaces a paid/premium interest tier from day one. This gives revenue scaling path + strong "willingness to pay" signals without solving onboarding friction or multi-sim backend limits first.

**Landing spec (v8) updated with Tier 1 measurement layer:**
- New §6: concise B2B capture reusing the existing footer newsletter block. Two micro-buttons (`Stay updated` for generic, `Bring this to my group` for B2B) feed a single enhanced waitlist form.
- Form payload extended with `source` (UTM/episode tag), `interest_type` (`generic` | `b2b_group`), and optional `group_name`. No new endpoints or UI states — extends `POST /api/waitlist`.
- All primary CTAs ("Create your Double") now open the §6 form (Option 1 chosen); button text kept verbatim everywhere for brand continuity. External `app.ondouble.com` link removed.
- Email form line rephrased to Option A (implemented): **"Request Doubland for your team or group — or just stay in the loop."** This makes the new request capability unmistakable while keeping the low-friction generic path.

**Result:** Every CTA and deep link is now source-tagged and interest-segmented. Funnel readout (views → clicks → signups by episode/source + B2B/paid-interest count) is ready with zero extra design surface. Spec shared with landing/BE team; build is days, not weeks.

**Next immediate steps:** triage consent for the 15 subjects (brief-first for senior/sensitive), finalize season length, confirm distribution mix. Tier 2/3 (serialization, persona fidelity, interactive voting) deferred until early numbers justify.

---

## 9. What we actually built — reflection (2026-06-16)

The Tier-1 measurement layer (§6.A) is **built, deployed, and — as of 2026-06-16 — verified end-to-end through the live production path.** §8 (2026-06-04) called it "complete" before it was proven; a live submit on 2026-06-16 (browser → landing proxy → gateway → Supabase) confirmed a tagged B2B signup persists correctly and that the never-downgrade ratchet holds. **The funnel can now be trusted for the deck.** Build detail + verification live in `double-docs/done/20260615_link-tracking.md`; the durable API contract is now in `sot/sot_api.md` §10.

**What this unlocks against the four money slides (§3):**

- **Slide 3 (conversion funnel) — the one gap we couldn't measure is closed.** Every signup records `source` (which episode/channel drove it) + `timestamp`, so *YouTube views → signups-by-episode* is now a real, attributable curve, not guesswork. Channel split (Telegram vs YouTube vs viewer-share vs organic) falls out of the same data.
- **Slide 4 (inbound demand) — the hero signal is now countable, not just anecdotal.** `interest_type = b2b_group` + `group_name` turn "build one for my group" into a number with names attached, tied to the episode that triggered it. The manual quote/screenshot log still carries the qualitative weight — the two reinforce each other.
- **Slide 2 (spread) gains a measurable sliver** — `sim-share` / `play-hud` tags count signups that came from viewers re-sharing a sim, so "the network expands itself" has data behind it, not just forward tallies.
- **Slides 1 & 5 unchanged** — YouTube Studio (completion %, returning viewers) + manual Telegram tallies, exactly as planned.

**Honest limits (state these to VCs so the numbers hold):**
- We record **signups per source, not clicks** — no redirect hop was built (out of scope, accepted at 15/300). The funnel is *views → signups* with clicks proxied.
- **Retention is aggregate** (YouTube Studio + manual view-curve), not per-user cohorts.
- On-screen end-card URLs can't be tagged (viewers retype them) → that traffic reads as `landing-hero`; don't misread it as organic failure.

**Reframe for the deck (consistent with §0/§1):** at 15/300 the absolute counts stay small, so **lead with completion % (Slide 1) and B2B asks + named quotes (Slide 4)**, and use the funnel (Slide 3) as proof the pull is *real and attributable* — "every signup traces to an episode" — not as a volume slide. We're selling intensity + demand, not traction-scale numbers.

**The one operational dependency:** the YouTube and viewer-share tags are automatic, but the **Telegram `tg-survival-d{N}` tag is manual — the operator must paste it into each post.** Without it those signups collapse into `landing-hero` and Slide 3 goes blank. This is now the single discipline gate before the first drop (§6.C.11–12). Ready-to-run deck queries (per-episode funnel, channel split, B2B lead list) are in the link-tracking doc's §Operator runbook → "Deck cuts."

**Still deferred (correctly):** Tier 2/3 (serialization/cliffhangers, Survival persona fidelity, interactive voting) stay held until early numbers justify them (§4, §6.D). The measurement layer was the prerequisite — and it's done.

---

**Status (updated 2026-06-16):** Measurement layer + CTA routing complete **and verified end-to-end in production** (§9). Core demo execution ready to proceed once consent and cadence are confirmed; the remaining gate to trustworthy funnel data is operator discipline — paste the `tg-survival-d{N}` tag into each drop.
