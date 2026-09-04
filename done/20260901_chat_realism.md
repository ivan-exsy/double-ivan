# Chat realism — expert inquiry process

**Date:** 2026-09-01  
**Status:** scratchpad / working process (not an implement brief)  
**Owner:** Ivan  
**Evidence sim:** `20260831-2` (Pass 2b, tip `b8d1fc15`) through day-2 ~11:00 (step **~1745**). Re-harvest after step **2285** (day-2 vote) before locking recommendations.  
**Do not:** resume `20260831-1`. Restore the gather lock. Turn seek on as part of a talk bet. Mix occupancy and drama into one score.

This file is how we **brief experts** and **phrase questions** so answers can become engine changes. It is not the engine plan. Eng stays on an `ivan/*` branch only after you say **go**.

---

## 0. What we actually want

Not “more interesting chat.” Not “better prompts.”

We want Doubles whose **talk changes the rest of their day**, on purpose:

```
a real conversation
  → a thought they keep (debt, suspicion, appointment, hurt, plan)
    → a follow-up (they look for that person, or avoid them, or tell a third)
      → a deeper conversation (not the same six lines remixed)
        → an action you can see (walk, sit, vote, linger, leave, protect, expose)
```

Today, good lines **sometimes appear**. They do not **cause** the next hour. That is why drama feels accidental: the model can improvise a trailer quote, then the village forgets it was a promise.

**Audience test (one sentence):** a cold viewer can say *who wanted what, what made it harder, what changed, what it cost, and why tomorrow matters* — from **what Doubles did**, not from a narrator inventing it. (`double-ivan/video/sot-video.md` closer spine; screenwriter five-beat. Village must *produce* those facts.)

---

## 1. Freeze before you ask anyone

Experts will invent a parallel village if we send vibes. Send **one packet**. Do not add new theory in the same brief.

### 1.1 Already decided (do not re-open in expert chat)

| Item | State | Paper |
|---|---|---|
| Bodies at Hobbs at 11:00 / 20:00 | Hold (this sim: d1 **15/15**, d1 vote **15/15**, d2 11:00 **13/14**) | `20260831-2_checklist.md` |
| Hello mill (same sofa, new “Morning!” every minute) | Named fix in flight: quiet until leave | Pass 2 FAIL `20260831-1`; 2b mill **0** |
| Seek | **Off** this tip. Walking to a named person moves occupancy | `20260901_launch.md` |
| Identity / “that’s me” / MatrAIx | **Post-MVP** charter. Adjacent, not this wave | `TODO_realism_matriAIx.md` |
| Scripted votes / fake blocs | Forbidden. Format may *pressure*; engine must not write the boot | Video SOT fact-lock; realitytv ethics |

### 1.2 Evidence rules (same as sim RCA)

- Quote **verbatim** lines, names, `conversation_id`, step, place. No “they talked strategy.”
- Counts with a window (through step N).
- Separate **hello** (`greeting_{step}_…`, 2 lines) from **full sit** (`Name_Name_{step}`).
- If you claim a causal failure, show the **promise** and the **non-event** (e.g. “see you at 8” → nobody walked to that corner at 8).

Re-run the stitch after **2285** so day-2 vote talk is in the packet.

---

## 2. Current situation (paste this as the brief’s “world”)

### 2.1 Mix of the room (through ~1745)

| Kind | Count | What a viewer hears |
|---|---|---|
| Two-line hellos | **358** | Morning / coffee / “you too.” First hello is allowed. This is wallpaper. |
| Full talks | **59** | Almost all **game-talk** (shield, vote, trust, Silent Pact). |
| Of those, “drama-keyword” | **55 / 59** | Strategy, not “how was your shift.” |
| Pairs that actually sit long | Few. Irene–Ivan, Alex–Andrew, Andrew–Nick, Butcher–Shepard, Dean–Diana, Shepard–Owen, Mike–Nick dominate. | Most of the 14/15 are in the **hello** pile. |

Hello mill (same pair, same room, second hello inside 30 min): **0**. Quiet is working. Coverage of *real* talks is not.

### 2.2 Three storylines that *existed in words*

1. **Max wins the Shield.** Room starts hunting a first boot.  
   Irene → Ivan: pastry debt, “cataloging who's buttering up Max.”
2. **Irene as Cost.** Flagged *before* the vote (folded fast; protein-shake “ritual”). Gone from the map at **21:00**. **No farewell scene.** Day 2 treats it as data (“Irene's elimination means one less wildcard”).
3. **Day-2 Silent Pact.** Protect vs expose. Mike–Nick, Shepard–Owen: trust as scarce resource.

These are closer-worthy **quotes**. They are not yet a **machine** that will produce the next night’s quotes on purpose.

### 2.3 Three failures of the causal loop (the actual bug class)

| Loop step | What happened | Failure |
|---|---|---|
| Talk → thought | Long sits write many unique lines. Memory retrieve exists for the *next chat prompt*. | No durable **object**: appointment, debt, named suspicion, “I will vote X unless.” Thoughts are prose in a pile. |
| Thought → follow-up | “I'll check in before eight.” “Same corner table.” “See you at the back booth at 10:30.” | Bodies do not keep those dates. Linger helper **never fired**. Seek **off**. Planner does not own “meet Irene at 19:15.” |
| Follow-up → deeper talk | Same pair, same sofa, **80 minutes**, 300–500 “unique” lines. | **Remix, not turn.** Opening 6 lines are gold; the rest restate Max/shield/8pm. New `conversation_id` after `desync_scratch_cleared` (25 of 58 full endings) looks like a new sit to the viewer. |
| Talk → action | Votes and challenge still happen on the **clock**. Occupancy held. | Action is **schedule**, not **consequence of that sofa**. Ivan still walking to Hobbs at d2 11:00 is leftover travel, not “because of a pact.” |

**Spy-flavored invention:** Ivan–Owen “antacid three times,” floor audits, circling produce. Flavor. **Not on the public board.** Do not put in fact-locked VO. Experts should say whether that class of talk should be **suppressed**, **grounded**, or **allowed as private color**.

### 2.4 How the engine actually talks (levers — keep this map in every brief)

Do not ask experts to redesign Phaser bubbles. Ask them which **box** is empty.

```
[1 WHO]   Proximity scan → ConversationManager.should_converse
          (sleep, distance, already chatting, will/affinity, cooldown,
           first-daily hello, quiet-until-leave for greetings)
              ↓
[2 WORDS] One LLM batch (both identity cards + retrieved memories)
          sliced across minutes. Hellos are hardcoded templates, not CM.
              ↓
[3 KEEP]  Chat rows + memory write. Retrieve can feed the *next* prompt.
          No first-class “open loop / debt / appointment.”
          **Pipe (founder 2026-09-01):** leftover from a full talk is
          **mode-agnostic** — ConversationManager + memory, every sim
          mode. Survival may *read* the leftover (protect/expose/we’re in)
          into alliance/vote context. SurvivalController does **not** own
          the pipe. Do not hang KEEP/DO only on `record_alliance_from_chat`.
              ↓
[4 DO]    Daily plan, linger (+10 once, unused on this sim),
          Survival seek (off), vote/challenge clocks.
```

**Adjacent (not this inquiry’s job):** identity compile / “that’s me” (`TODO_realism_matriAIx.md`). If an expert says “give them better personalities,” park it. This wave is **loop**, not soul soup.

**Token rule (still true):** replace weak structure; do not stack more biography into every chat call.

---

## 3. How to talk to experts (the process)

### 3.1 One job per specialist

If two experts own the same sentence, we get poetry twice and no lever.

| Specialist | Ask them | Do not ask them |
|---|---|---|
| **willwright** | What **state** must persist so talk is a feedback loop (garden, not script). What possibility space we closed by slicing one LLM dump across 80 minutes. | Vote rules. Trailer VO. KPI copy. |
| **realitytv** (Burnett / de Mol / Parsons) | What **social facts** the daily loop must make *visible and scarce* (status, exclusion, loyalty) so drama is format-native, not random wit. One mechanic that maps `village → pressure → strategy → vote → trailer`. | Writing village lines. Occupancy patches. Seek-on. |
| **jordanpeterson** | Why **two sofas** sound like the same strategist. Temperament × *this* situation (first boot, shield, protect/expose): who should initiate, who should stay quiet, who should refuse game-talk. Fictional Doubles only. | Format. Engine APIs. Profiling real staff. |
| **screenwriter** | Diagnose a sit as a **scene** (want → pressure → turn → cost → open question). Why the remix has no turn. Criteria for “this conversation completed.” **Not** draft village dialogue. | Changing challenge/vote rules (`realitytv`). CapCut. |
| **engagement** | **Later.** Only after a loop exists: what a *viewer* must see to return. Not how Doubles talk. | First-wave talk machinery. |
| **videoproducer** | **After** facts exist. Clip-ability is a test of the loop, not a design input. | Inventing Peak/Cost. |
| **@cto / eng** | **Last.** Translate a ranked bet into `ivan/*` with an independent observable. | Asking them “make it dramatic.” |

### 3.2 Order (do not parallel-dump the same essay)

1. **willwright** — name the missing feedback (KEEP + DO).  
2. **realitytv** — which social facts that feedback should carry for Survival.  
3. **jordanpeterson** — who enters [1 WHO] and who should *not* sound like a producer.  
4. **screenwriter** — pass/fail on 3–5 **existing** sits (appendix), as scene criteria.  
5. **You + COS** — synthesize to **one ranked list of engine bets**.  
6. **@cto** only after you pick a bet that has its own observable and does not share occupancy with gather.

Skip 2–4 until 1 names a *kind of state* (appointment, debt, public board fact, private suspicion). Otherwise later experts will ask for “more conflict in the prompt.”

### 3.3 Packet every expert gets (one page + appendix)

```
A. Goal (section 0) — four lines
B. Engine map (section 2.4) — the four boxes
C. Mix table (section 2.1) — through step N
D. Constraints (section 1.1)
E. Five verbatim scenes (appendix) — promise vs what the body did next
F. Your job (one paragraph from the table above)
G. Required answer shape (section 4)
H. Forbidden answers (section 3.4)
```

Do not attach the 400-hello dump. Do not attach the 576-line remix in full — **first 8 lines + last 4 + duration**.

### 3.4 Forbidden answers (print in the brief)

Reject and send back if the recommendation is:

- “Make the prompt more dramatic / add conflict.”
- “Have the LLM decide who to vote for in chat, then force the ballot.”
- “Restore the cafe lock / pin people so they talk.”
- “Turn seek on” **without** saying how occupancy stays a separate score.
- “Dump more personality / Big Five / memories into every call.”
- “Lengthen linger so talks continue” as a hide for remix (linger is for *bodies staying*, not for minting more paraphrases).
- “Write a season arc for Irene.” We need **machinery that would have produced Irene**, not a script about her.

---

## 4. Required answer shape (so we can compare)

Every expert recommendation must fill this. If a field is empty, the round fails.

```
1. Loop step it repairs: WHO | WORDS | KEEP | DO  (one primary)
2. Social fact that must persist (one sentence, example from the appendix)
3. Engine-shaped change (rule, object, or gate — not “better writing”)
4. Independent observable (log line, count, or body test we can read at a named step)
5. Occupancy coupling: none | watch | do not ship on this tip
6. Token / identity: replace what?  ≤+5% or “not a chat-prompt change”
7. Anti-pattern: the naive version that recreates mill, lock, or fake blocs
8. Prototype this week: smallest village test (not a 2400-step season)
```

**Your synthesis rule (from launch):** one bet per **shared number**. Talk-drama that moves **Hobbs occupancy** does not ride the same sim as gather. Seek is the classic shared-number trap.

---

## 5. Question bank (copy-paste)

Replace `SIM` / `STEP` if you re-harvest. Keep the rest stable so answers stay comparable.

### 5.1 willwright

1. In Wright terms: talk that does not change the **possibility space** of the next hour is decoration. Looking at box KEEP and DO, what is the **smallest persistent object** a Double should leave a sofa with (name it: appointment, obligation, updated relationship weight, public-board delta, …)? What feedback does the *village* show when that object is honored vs ignored?  
2. We generate **one** conversation then slice it for ~80 minutes. Unique words go up; the **turn** does not. Is that a possibility-space problem (too little new input) or a feedback problem (the world didn’t move)? What would you cut vs add?  
3. “I’ll see you at 8” is authored in WORDS and never becomes DO. Map that to a **player-visible** failure (the garden didn’t grow). What rule would make ignoring a promise *itself* content — without scripting the vote?

### 5.2 realitytv

Question type for them: **daily loop** + **information reveal**. Core loop they must map to: `village → challenge pressure → social strategy → vote-out → trailer`.

1. On `20260831-2`, Max’s Shield and Irene’s boot **happened**. Chat *commentated* them; it did not **create** a loyalty test that a new viewer could point to. Which **one** social fact should a sofa be required to mint or update for the format to feel intentional (status, exclusion, debt, public vs private knowledge)? de Mol: can that be a **repeatable daily** without a producer?  
2. Parsons: first-boot talk treated Irene as a spreadsheet (shakes, “folded fast”) and skipped a farewell. Is the missing piece **dignity of cost** (a human beat the format owes) or **coalition visibility** (who sat with whom)? Burnett: which of those is actually trailer-native?  
3. We must not script ballots. What is the **maximum** chat is allowed to do to the vote (information, commitment, lie) so strategy is real and the boot is still *theirs*?

### 5.3 jordanpeterson

Fictional Doubles. No named real people. Label forecasts as temperament × situation, not diagnosis.

1. Most full sits sound like the **same** high-Openness strategist. Given a first-boot + shield morning, who (by trait *pattern*, not name) should **refuse** game-talk, who should **gossip**, who should **make a concrete ask**? What would falsify “they’re all producers”?  
2. Coverage: 358 hellos, ~8 pairs with real sits. Is the gap **initiation** (E / assertiveness), **avoidance** (anxiety under status threat), or **satiation** (they already talked, will is a number we already have)? Recommend a **who-talks** prior that is a gate, not a prompt label.  
3. After a boot, what *situation* should change the quiet people (not the two sofas that already talk)? One forecast, one disconfirmer we can read in logs.

### 5.4 screenwriter

Do **not** draft VO or village lines. Score the appendix sits.

1. For each of the five appendix scenes: write the five-beat spine **only from quoted lines + whether the body did the promised act**. If a beat is missing, name it. Do not invent.  
2. An 80-minute sit with 300 unique lines and no turn — is that “too much dialogue” or “no new pressure entering the scene”? What **completion test** should end a village sit so the next sit can be a *sequel* (new want) not a remix?  
3. Cost (Irene) is in the ledger and almost absent as a **spoken cost**. What is the smallest *behavioral* beat (not VO) that would make Cost legible without humiliation?

### 5.5 engagement (defer)

Only after KEEP/DO exists: “If the village minted one debt per evening, what does the **viewer** need on the home screen / closer Door so they return — without us writing the drama in the trailer?”

---

## 6. After answers — synthesis (you, not the experts)

1. Put every recommendation on a **4-box** sticky (WHO / WORDS / KEEP / DO).  
2. Drop anything that fails occupancy coupling or forbidden list.  
3. Keep at most **one** change per box for the next implement wave. Prefer KEEP or DO first — WORDS without KEEP is how we got accidental quotes.  
4. Write the score card *before* code: step to read, verbatim signal, abort. Same discipline as Pass 2b.  
5. Then `@cto` brief: one bet, one observable, seek still off unless that *is* the bet and occupancy is scored as hold-or-split.

**First bet class (direction locked 2026-09-01, not yet an eng brief):** a leftover from a **full talk** on ConversationManager + memory (every sim mode), plus sit completion so a sequel can start. Honor/break by co-presence; seek off. Survival may read the leftover; it does not own the pipe. Re-harvest after **2285** before `@cto`. Do not implement on the live `20260831-2` score sim.

---

## 7. Appendix — five scenes for the packet

Use these. Re-quote from movement after 2285 if the sit grew.

**A. Promise without body (KEEP/DO miss)**  
`Irene Dove_Ivan Pitts_308` ~11:08 Hobbs.  
Irene: pastry for Max; “I'll flag you if I spot anything obvious.”  
Ivan: “I'll check in before eight.”  
Then ~80 minutes of remix. Linger **0**. No evidence they *met at eight because of this*.

**B. Intentional-feeling strategy (WORDS hit, no new pressure)**  
`Andrew Abrams_Nick Miller_622` afternoon.  
Andrew: “Groups have a half-life.”  
Nick: nine-person hold board as a coalition.  
Long sit restates the same coalition math.

**C. Vote-wait character (trailer-native, still decoration)**  
`Alex Butcher_Alex Shepard_853` ~20:00.  
Butcher: napkin arrows between people who only said hey.  
Shepard: wait for tally so tomorrow “means something.”  
Jazz-loop remix for ~60 min.

**D. Cost without a human beat**  
Irene gone at step **905**.  
Day-2 `Alex Shepard_Owen Logan_1706`: “yesterday's vote went for Irene” / “one less wildcard.”  
No farewell sit in the harvest.

**E. Short complete-ish scene (control)**  
`Mike Hooks_Nick Miller_1616` — 6 unique lines, protect vs expose, then they **stop**.  
Use as “this already looks like a scene.” Ask: why didn’t *this* become an 11:00 pairing action?

---

## 8. How to run it in COS

1. Freeze packet (this file §2 + §7, dated step).  
2. `tasks/<id>/` — risk **low** (internal craft). Sequential specialists as §3.2.  
3. Attach: this file, `20260831-2_checklist.md` Decision, `sot_chats.md` as **Current (lags code)** — tell them 2.4 wins.  
4. One specialist per round. Do not merge Wright and Burnett in one prompt.  
5. COS scores their `agent.md` acceptance + **section 4 schema**. Fail if schema empty.  
6. You pick the bet. Then implement loop on `generative_agents`.

When the packet is stale (sim past 2285, or a new tip), update §2 counts and §7 quotes. Keep questions stable.

---

## 9. Open (founder)

- [x] COS inquiry drafted — task `COS/tasks/2026-09-01-001/` (`brief.md` + per-expert inquiries in `plan.md`). Wave 1 = willwright only; pause after.  
- [x] Founder go — sequential wave complete; leftover pipe **mode-agnostic** (CM + memory).  
- [ ] Re-harvest chats at **2285** (day-2 vote sofas), then `@cto` — do not implement on live `20260831-2`.  
- [ ] Seek remains **off** until a dedicated occupancy-hold sim.  
- [ ] Identity/MatrAIx stays **post-MVP** unless a WHO-gate truly needs a compiled if–then line (then it is a tiny compile, not soup).
