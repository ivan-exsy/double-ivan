# Inquiry — Manual rewrite: Survival Day 1 daily trailer VO

**To:** Expert video production / scenario-writing team  
**From:** Product (Ivan)  
**Date:** 2026-07-10  
**Priority:** Daily trailers (opener automation paused; Anya’s L-Talks opener is locked and stays as-is)  
**Ask:** Draft a **new plain-language voiceover** for this Survival Day 1 package. Do **not** ship the current locked VO as-is.

---

## 1. Why this inquiry exists

We have a working package for **Survival Day 1** of sim `20260707-chat-probe-v3` (engine day 2): fact ledger, cast digest, restitched scene locations, and a human VO that was “good enough” for pipeline plumbing.

**Product review says the VO is not ready for Remotion / public watch.**

- Character **intros are strong** — keep that shape.
- The **challenge block** assumes the viewer already knows Survival / Limited Immunity.
- The **middle and close** tell events in indirect, isolated sentences — a cold viewer has to work too hard.

**Goal of your rewrite:** a 12-year-old who has **never** seen the L-Talks opener should still understand Doubland, Survival, today’s challenge stakes, and why tonight’s vote hurts — then want tomorrow’s trailer **or** to watch live at **doubland.ai**.

---

## 2. Deliverable

| Item | Spec |
|------|------|
| **Format** | One continuous plain-text VO (no `[SCENE]` / pause markers in the draft; audio team splits later) |
| **Length** | Target **~100–115s** spoken @ warm 1.5× (~2.1 words/sec); hard cap **&lt;120s** total trailer |
| **Language** | Marketer-simple. Concrete nouns and verbs. **No** strategy jargon (“board,” “broker,” “cover,” “imbalance”) unless immediately explained in kid-plain words |
| **Leads** | **Vincent Slater, Max Shoemaker, Olivia King** (editorial lock) |
| **Output** | Full narration + short beat map (what each paragraph is doing) + 5-question cold-viewer quiz you expect them to pass |

**Keep (approved):** the three intro stamps (job + place + want) — lines 5–10 of current `script_used.txt`. You may lightly polish wording, but do **not** lose job/place/want.

**Rewrite (required):** challenge explanation + day’s story + vote/farewell + cliffhanger (current lines 11–22).

---

## 3. Product jobs (priority order)

1. **Cold clarity** — What is a Double? What is Survival? What happened today? Who went home?
2. **Care** — Why these three people matter in normal life (job/place), not only as vote pieces.
3. **Stakes** — Why the challenge mattered; why Vincent was in danger; what Irene’s protection means.
4. **Glue** — One continuous story (want → turn → cost), not a list of captions.
5. **Hook for next** — Cliffhanger that pulls to tomorrow’s trailer **and/or** doubland.ai (watch live).

This daily is **[C] `day_survival`** — same show as the opener, different job. Opener sells the world; daily sells **today’s episode**.

---

## 4. Simulation & cast context

| Field | Value |
|-------|--------|
| **Sim** | `20260707-chat-probe-v3` |
| **Baseline / cohort** | Forked from `soul15_seed_20260224` (same Doubles family as L-Talks Press Play cast pack) |
| **Display season** | Treat as **L-Talks · Press Play** world for brand continuity (mask real group names; never put real identities on screen) |
| **Engine day** | **2** = **Survival Day 1** (engine day 1 = grace / premiere — no elimination) |
| **Package** | `generative_agents/data/20260707-chat-probe-v3/trailer_ready_day2/` |
| **Featured Doubles** | Vincent Slater · Max Shoemaker · Olivia King |
| **Eliminated tonight** | **Vincent Slater** — **2 votes** (authoritative) |
| **Challenge** | **Limited Immunity** — two immunity tokens available (claim or negotiate) |
| **Challenge outcome (ledger)** | **Irene Dove** secured protection / won today’s challenge |
| **Yesterday** | None — first competitive Survival night (no “Previously on”) |

### Featured people (normal-life stamps — keep this energy)

| Double | Job / place | Want / trait (current VO) |
|--------|-------------|---------------------------|
| **Vincent Slater** | Builds curricula at **Oak Hill** | Treats every vote like a problem to solve; needs a clean answer tonight |
| **Max Shoemaker** | Pastry line at **Hobbs Cafe** | Watches who leans in; keeps options open |
| **Olivia King** | Waitstaff at **Hobbs Cafe** | Can hold a group together — or decide who no longer belongs |

### Day plot (facts you may use — do not invent a clean voting bloc)

Safe story spine (plain language):

1. Survival starts: each day someone can be voted out until one remains.
2. Today’s challenge: **Limited Immunity** — a few people can earn **protection** so votes against them don’t count (or they’re safe tonight). Only **two** tokens / limited slots — not everyone can be safe.
3. **Irene Dove** gets protected. That means she is **safe from tonight’s vote**.
4. **Vincent does not** get that safety. So he must survive by **talking people into not voting him out** (alliances, targets, plans).
5. Vincent tries to organize people (including pressure around **Diana** as a target) at Hobbs.
6. Max talks with Irene; his loyalty looks soft / options stay open.
7. Olivia helps form a side; Vincent helped build pressure but **is not protected by that side**.
8. Vote: **Vincent goes home** on **two votes**. **Olivia** is one of the people who voted for him.
9. Cliffhanger: Max still looks flexible; Olivia looks powerful; the planner is gone — **who does the room trust tomorrow?**

**Hard fact rules (from `fact_ledger.json`):**

- Do **not** say Vincent “survived Day 1.”
- Do **not** invent a unified alliance that all voted the same way. The recorded ballot board is **split** (many names with 1 vote each among recorded casts). You **may** say Olivia’s vote landed on Vincent.
- Challenge: use **Limited Immunity** + “two tokens / limited protection” + Irene protected. Do **not** invent extra rules beyond the ledger brief.
- Prefer **first names** after the first full-name stamp.

---

## 5. What’s wrong with the current VO (owner notes)

### Keep — intros (approved)

```
Vincent Slater builds curricula at Oak Hill. He treats every vote like a problem on the board — and he needs a clean answer tonight.

Max Shoemaker runs the pastry line at Hobbs Cafe. Half the town passes his counter. He watches who leans in, and he keeps his options open.

Olivia King waits tables at the same cafe. She can hold a group together — or decide who no longer belongs.
```

### Fix — challenge line (current)

> Today: Limited Immunity. Two tokens. Claim one or negotiate. Irene Dove walks away protected. Vincent still has to win the room with talk.

Problems:

1. **“Today: Limited Immunity…”** sounds like a reminder for people who already know the show. Cold viewers don’t. Explain **why there is a challenge**, **what it is**, and **what’s at stake** in one breath.
2. **“Irene walks away protected”** — protected from *what*? What does that mean for her tonight?
3. **“Vincent still has to win the room with talk”** — why is he under pressure? What is the risk if he fails?

### Fix — middle + close (current)

> Vincent maps Hobbs like a classroom… Max sits with Irene… Olivia confirms a four-person side… When the vote lands… Day one ends with a new imbalance…

Problems:

- Language is **indirect** (“maps like a classroom,” “looks locked in,” “broker,” “cover,” “imbalance”).
- Sentences feel like **isolated captions**, not one story.
- Viewer has to **think hard**. We want the opposite: grab attention, stay glued, then wait for tomorrow or open doubland.ai.

**Rule of thumb:** if a sharp 12-year-old wouldn’t get it on one listen, rewrite.

---

## 6. Suggested structure (flexible — serve clarity first)

| Block | Job |
|-------|-----|
| **Concept** | What Doubles are (one plain sentence) — may echo opener, but daily must stand alone |
| **Frame** | First night of Survival + “one person can go home tonight” |
| **Three stamps** | Keep job + place + want (approved) |
| **Challenge** | Why challenge exists → what Limited Immunity is → Irene safe → Vincent not safe / must talk |
| **Want → turn** | Vincent’s plan; Max’s soft play; Olivia’s side — in cause-and-effect order |
| **Cost** | Vincent goes home; Olivia’s vote lands on him; feel the farewell |
| **Cliffhanger** | Tomorrow’s trust question + soft pull to watch live |

Opener already taught Survival Mode (“one out every day until one remains”). Daily should **restate that in kid-plain words** for people who skipped the opener — then go specific.

---

## 7. Reference pack (read these)

### Locked opener (same show, different job)

| Doc | Path | Why |
|-----|------|-----|
| **Locked opener script** | `double-ivan/video/l-talk/script/script_cos.md` | Tone, Doubles definition, Survival Mode one-liner, end-card energy |
| **Opener writer brief** | `double-ivan/video/opening/opening-15person/20260701_scenario-writer-brief_leadertalks-opener.md` | L-Talks / message-derived Doubles / Press Play context (canonical twin: `video/l-talk/brief/scenario-writer-brief.md`) |
| **Opener plain VO used** | `double-ivan/video/l-talk/audio/experiments/script_cos_oneshot_speed12/script_used.txt` | Spoken reference |

Key opener Survival line to rhyme with (don’t copy blindly):

> The show is on — in Survival Mode. Every day, one Double gets eliminated — until only one remains.

### Daily / product SOT

| Doc | Path | Why |
|-----|------|-----|
| **Video SOT** | `double-ivan/video/sot-video.md` | Part I grammar · §12 `[C] day_survival` · L10 duration · L11 first-feature stamps · L12/L13 ranking/scars |
| **Daily TODO / contract** | `double-ivan/video/daily/TODO_daily_trailer.md` | Ideal outcome, plain language, cliffhanger, same-show-as-opener |
| **Prior screenwriter task** | `double-ivan/video/TODO_script_draft.md` | Earlier lock notes (now superseded by this inquiry’s rewrite ask) |
| **Program TODO** | `double-ivan/video/TODO_video.md` | Daily priority over opener automation |

### This package (facts + current draft)

| Artifact | Path |
|----------|------|
| Current plain VO | `generative_agents/data/20260707-chat-probe-v3/trailer_ready_day2/script_used.txt` |
| Structured script | `…/trailer_ready_day2/script.json` |
| Fact ledger (authoritative) | `…/trailer_ready_day2/fact_ledger.json` |
| Cast digest | `…/trailer_ready_day2/cast_digest.md` |
| Locked TTS (old VO) | `…/trailer_ready_day2/audio/narration.mp3` (~106s) — **will re-TTS after rewrite** |

### Engine / challenge background (optional depth)

| Doc | Path |
|-----|------|
| Survival SOT | `double-docs/sot/sot_survival.md` — Limited Immunity is Day-1 catalog challenge; immunity voids votes against holder |

---

## 8. Acceptance checklist (rewrite must pass)

Cold viewer (no opener) after **one** listen can answer:

- [ ] What is a Double / Doubland in one sentence?
- [ ] What is Survival Mode (someone can go home each day)?
- [ ] What was today’s challenge, and why did it matter?
- [ ] What did Irene’s protection mean for her tonight?
- [ ] Why was Vincent in danger, and what did he try to do?
- [ ] Who are Vincent / Max / Olivia in normal life (job + place)?
- [ ] Who went home, and that Olivia’s vote was part of it?
- [ ] What open question makes them want tomorrow (or doubland.ai)?

Craft:

- [ ] Intros keep job + place + want energy  
- [ ] One cohesive story (not caption salad)  
- [ ] 12-year-old language  
- [ ] No invented clean voting bloc  
- [ ] Runtime still fits **&lt;120s** hard cap (aim 100–115s VO)

---

## 9. Out of scope for this inquiry

- Remotion picture polish / moment clips (after VO lock)
- Seeding F1 featured-history / F3 scars from this package (`lock_day_script` starts clean on the **next** live sim)
- Regenerating auto showrunner draft to “fix” language — **manual rewrite is the ask**
- Opener automation pipeline (paused; Anya’s opener stays locked)

---

## 10. Handoff back to engineering

When the new VO is approved:

1. Paste into `script.json` `narrator_script` + `script_used.txt`  
2. Re-TTS warm @ **1.5×**  
3. Remotion render + validate  
4. Owner watch  

Engineering will not treat the current 106s VO as final.

---

**Bottom line for writers:** Keep the three human intros. Teach Survival + Limited Immunity like it’s the first time anyone has heard of them. Tell tonight’s story so a kid gets it in one pass — then leave them hungry for tomorrow.
