# Screenwriter task — Day 2 daily trailer (`20260705-or-smoke`)

**Package:** `data/20260705-or-smoke/overview_day2&002/`  
**Sources of truth:** `day_log.json` (timeline, votes, survival context), `script.json` (auto-draft — **do not ship as-is**).  
**Audience:** Human screenwriter replacing the broken auto narrator draft before VO lock and Remotion render.

---

## 1. What we are aiming for

### Product goal

Deliver the **Day 2 episode** of L-Talks Survival as a **~85s, 9:16 daily trailer** that feels like the next beat of the same show as the shipped opener: plain language, multi-lead arc, cliffhanger ending, no jargon. The viewer should follow **who** the three featured Doubles are and **what shifted** today (immunity + vote tension) without having watched Day 1.

### Creative vision (L-Talks Survival — Day 2)

- **Self-contained episode** with a short “yesterday” bridge: Alex is already gone; tonight we explain *why the vote picture is messy* (split targets on Day 1), then **today’s** Limited Immunity beat.
- **Three leads, one imbalance at the close:** Max protected, Vincent still exposed and empty-handed, Mike active but unclaimed — **no fake elimination** tonight.
- **Visual story without chat:** All three featured Doubles have **0 recorded conversations** in this export; narration must carry drama from **actions, locations, and vote math**, not quoted dialogue.
- **2D sim on screen, 3D in the mind** (matrix literacy): beats should anchor to real places — market, Hobbs counter, Oak Hill / apartment planning, Rose and Crown mic, evening pub tally.

### Reference docs

| Doc | Why read it |
|-----|-------------|
| `double-ivan/video/daily/TODO_daily_trailer.md` | Daily trailer outcome, beat flexibility, duration, opener parity |
| `double-ivan/video/daily/daily-2D-3D-blend.md` | When/how to cut to moment clips (optional for this pass) |
| `double-ivan/video/sot-video.md` | Shared motion grammar, L8/L9/L10 duration and voice rules |
| `double-ivan/video/l-talk/script/script_cos.md` | Tone reference for “Doubles” concept line (opener) |
| `double-ivan/video/l-talk/HANDOFF.md` | CapCut/opener handoff patterns; VO is source of truth once locked |
| `double-ivan/video/TODO_video.md` §E | Pipeline ownership and daily trailer checklist |
| `double-docs/20260705_close-for-mvp.md` | Sim `20260705-or-smoke` sign-off context (smoke run, survival gates) |

### What went wrong with the auto-draft (`script.json`)

The showrunner auto-draft in `overview_day2&002/script.json` is **factually wrong for Day 2**:

1. **Repeats Alex Butcher’s elimination as if it happens again on Day 2** (Scene 7: “At the vote, Alex Butcher is eliminated — three votes again”). Alex was eliminated **only on Survival Day 1**. There is **no Day 2 elimination** in `day_log.json` / survival export for this overview.
2. **Misframes the coalition:** It implies Mike, Max, and Vincent all “voted with the winning side” against Alex in a clean bloc. Day 1 vote targets were **split** — Alex went home on 3 votes, but **Max and Vincent each received 3 votes** as well; Mike voted **Vincent**, not Alex.
3. **Underplays Limited Immunity:** Day 2’s defining mechanic (two tokens, claim or negotiate at Hobbs) is mentioned thinly compared to the sim timeline (Max secures a token; Mike competes at the pub mic; Vincent plans at Apartment 4 with Alexis/Dean but does not secure a token).

**Your job:** Replace `narrator_script` with the approved plain text below (then producers re-split scenes / timecodes).

---

## 2. Day 2 overview

**Simulation:** `20260705-or-smoke`  
**Overview folder:** `overview_day2&002`  
**Survival day in season:** 2  
**Challenge today:** Limited Immunity — two tokens; claim or negotiate; gathering at Hobbs Cafe; challenge deadline 11:00, vote deadline 20:00 (per survival overlay).  
**Eliminated before today:** Alex Butcher (Day 1 only).  
**Day 2 elimination in data:** **None** — do not narrate anyone going home tonight.

### Day 1 vote (Survival) — for “Previously on”

| Outcome | Detail |
|--------|--------|
| **Eliminated** | **Alex Butcher** — **3 votes** (Vince Vale, Diana Ogden, Vincent Slater) |
| **Also on the board** | **Max Shoemaker** — 3 votes received (Irene Dove, Alexis Reed, Olivia King) |
| | **Vincent Slater** — 3 votes received (Mike Hooks, Andrew Abrams, Max Shoemaker) |

**How our three leads voted on Day 1:**

| Double | Day 1 vote cast |
|--------|-----------------|
| Mike Hooks | Vincent Slater |
| Max Shoemaker | Vincent Slater |
| Vincent Slater | Alex Butcher |

Takeaway for narration: Alex left, but **nobody agreed on the real target** — three names each drew three votes.

### Mike Hooks

- **Role:** Cashier, The Willows Market and Pharmacy — likes to stay invisible; high poignancy from **immunity challenge** actions despite **0 chats**.
- **Day 2 beat:** Strategy notes at Oak Hill College → competes at **Rose and Crown pub microphone** during the immunity window → **no token** → evening **casts vote** at Hobbs → waits at Rose and Crown with Ivan and Vincent near tally review → ends **off the target list** but **without a clear alliance**.

### Max Shoemaker

- **Role:** Pastry chef at **Hobbs Cafe** — half the town passes his counter; Irene and Olivia orbit the kitchen in timeline.
- **Day 2 beat:** Listens to challenge instructions at Hobbs → **claims** then **secures immunity through negotiation** at the cafe (behind counter / seating) → evening vote from Hobbs while **watching cafe doors** for results — **protected** heading into Day 3.

### Vincent Slater

- **Role:** Curriculum developer, Oak Hill College — treats votes like problems on the board.
- **Day 2 beat:** At **Apartment 4** reviews rules and token distribution with **Alexis Reed**; strategy at desk with **Dean Sanford** → **does not secure a token** while Max does → evening **casts vote** at Hobbs → **reviews vote tally sheet** at Rose and Crown with Mike and Ivan nearby — still **exposed from Day 1 vote count**, **empty-handed** on immunity.

### Rest of cast (Day 2 — alive, not featured)

| Double | Notes for B-roll only (do not name all in VO) |
|--------|-----------------------------------------------|
| Alex Shepard | In sim; not featured |
| Alexis Reed | Near Vincent’s apartment planning |
| Andrew Abrams | Day 1 voted Vincent |
| Dean Sanford | Near Vincent’s immunity planning |
| Diana Ogden | Day 1 voted Alex |
| Irene Dove | Hobbs kitchen orbit with Max |
| Ivan Pitts | Near Mike/Vincent at pub evening |
| Nick Miller | College / pub background |
| Olivia King | Hobbs kitchen orbit |
| Owen Logan | Town movement; vote gathering |
| Vince Vale | Day 1 voted Alex |

**14 players remain** after Alex’s Day 1 exit.

---

## 3. Reasoning — why these three and script structure

### Why Mike, Max, and Vincent

Producer ranking in `day_log.json` selected them as protagonists (`protagonists`: Mike Hooks, Max Shoemaker, Vincent Slater) based on **poignancy + location spread** with **zero conversations** — the day’s drama is **behavioral and positional**, not dialogue-driven.

- **Mike** = flexible survivor (competed, voted, never received the Day 1 pile-on).
- **Max** = **only featured Double who secures immunity** — power shift.
- **Vincent** = **only featured Double who cast a vote to eliminate Alex** yet **still took three votes** and **fails the token race** — maximum irony and forward tension.

Together they embody Day 2’s question: *After a split vote and new immunity, who actually has power?*

### Script structure (~85s, no scene markers in draft)

| Block | Purpose |
|-------|---------|
| **Cold open** | Doubles concept + “Day two” + three-name frame |
| **Character stamps** | One line each: job + survival trait (market / Hobbs / Oak Hill) |
| **Yesterday scar** | Alex out on 3; Vincent one of three; **split board** (Max 3, Vincent 3; Mike→Vincent, Max→Vincent, Vincent→Alex) |
| **Today setup** | Limited Immunity, two tokens, Hobbs challenge, vote tonight |
| **Three parallel beats** | Mike (flex / mic / no token) → Max (counter / negotiate / token) → Vincent (apartment plan / no token) |
| **Evening** | Vote gathers; Max watches doors; Vincent tally at pub; Mike votes and waits — **no elimination** |
| **Cliffhanger** | Imbalance: Max protected, Vincent exposed, Mike unaligned |

---

## 4. Script

### A. Actual script generated

[SCENE 1] These are Doubles — AI versions of real people, making choices no one wrote for them.
[SCENE 2] Today: Mike, Max, and Vincent.
[SCENE 3] Day one ended with Alex Butcher voted out by three. 
    Mike Hooks, who keeps his head down, voted with the winning side — alongside Max Shoemaker and Vincent Slater. 
[SCENE 4] Now it's Day 2. Two immunity tokens are on the line — and every vote matters. 
[SCENE 5] Mike's strategy: stay quiet, watch the room, and avoid making enemies. 
    He wants to stay flexible — not locked into any side.
[SCENE 6] But someone else is already making moves. 
  Max Shoemaker, who voted with the coalition, receives a stray vote. So does Vincent Slater. 
[SCENE 7] At the vote, Alex Butcher is eliminated — three votes again. 
  But Max and Vincent each took a vote too. The coalition that won yesterday is cracking.
[SCENE 8] Mike voted with the majority and got no votes back. 
  But now he sees the old alliance is breaking apart — and he has no clear side left.

### B. Proposed plain text script (~85s, no scene markers)

Use this verbatim unless product owner edits facts or tone. **No `[SCENE]` tags, no pause markers** in this draft — audio team splits later.

These are Doubles — AI versions of real people, making choices no one wrote for them.

It is Day two of Survival, and we are following three of them.

Mike Hooks works the register at the market and likes to stay invisible. Max Shoemaker runs the pastry line at Hobbs Cafe — half the town passes his counter. Vincent Slater builds curricula at Oak Hill and treats every vote like a problem on the board.

Yesterday, Alex Butcher went home on three votes. Vincent cast one of those votes. But the night was messier than that. Max took three votes himself. Vincent took three too — including one from Mike and one from Max. Nobody agreed on who the real target was.

Today the game adds Limited Immunity. Two tokens are on the table. You can claim one or negotiate for one. Challenge at Hobbs. Vote tonight.

Mike's plan is to stay flexible. He works through strategy notes at the college, steps up at the Rose and Crown microphone when the challenge opens, and keeps his options open. No enemies. No lock-in.

Max does not hide. He reads the room from behind his own counter while Irene and Olivia orbit the kitchen. When the challenge lands, he does not just compete — he negotiates — and walks away with an immunity token.

Vincent does the homework. At his apartment he picks apart the rules with Alexis. Dean is in the room. Vincent maps a path to a token — but when the moment comes, he does not secure one. While Max cashes in, Vincent is still planning.

By evening the vote gathers. Max watches the cafe doors. Vincent studies the tally sheet at the Rose and Crown with Mike and Ivan nearby. Mike casts his vote and waits. Nobody comes for him tonight — but nobody pulls him in either.

Day two ends with a new imbalance. Max is protected. Vincent is still exposed from yesterday and empty-handed today. And Mike — who voted, competed, and stayed off the target list — still does not know which side he is on tomorrow.

---

## 5. Acceptance checklist

- [ ] **Facts:** Alex eliminated **Day 1 only**; **no** Day 2 elimination narrated.
- [ ] **Day 1 vote math** matches table (Alex 3; Max 3 received; Vincent 3 received; lead votes Mike→Vincent, Max→Vincent, Vincent→Alex).
- [ ] **Day 2 immunity:** two tokens; Max secures one via claim/negotiation at Hobbs; Mike competes at pub mic, **no token**; Vincent plans with Alexis/Dean, **no token**.
- [ ] **Evening:** vote happens; **no one goes home** in copy; cliffhanger is imbalance, not a boot.
- [ ] **No fabricated dialogue** — 0 conversations for all three in export.
- [ ] **Tone:** plain, concrete nouns/verbs; first names in VO; under ~120s hard cap, target **~85s** at 1.5× ElevenLabs warm (`eleven_v3` per daily SOT).
- [ ] **No auto-draft errors** — script does not repeat Alex elimination on Day 2 or imply a clean anti-Alex trio.
- [ ] Owner read-aloud: cold viewer can explain who is safe, who is exposed, and why Mike is stuck in the middle.

---

## 6. After approval steps

1. **Paste approved script** into producer workflow (replace auto `narrator_script` in `script.json` or author `script_used.txt` beside audio experiment folder).
2. **Generate VO** — ElevenLabs one-shot or segmented per `video/l-talk/audio/` experiments; export `narration_timing.json` / word timecodes.
3. **Re-stitch scenes** — showrunner splits plain text into 3–6 beats with `time_range_sec`, locations from `day_log.json` timeline (Oak Hill, Hobbs, Apartment 4, Rose and Crown).
4. **Run gates** — duration, LUFS, narration-fit, asset-presence per `TODO_daily_trailer.md` / `sot-video.md`.
5. **Remotion render** — `overview_day2&002/output/`; optional moment clip drop-in per `daily-2D-3D-blend.md` if owner supplies Grok clips.
6. **Owner watch-through** — confirm Day 2 reads as “next episode” and comprehension gate (D1) before marking daily trailer done for this sim.