# Screenwriter task — Survival Day 1 daily trailer (`20260707-chat-probe-v3`)

**Package:** `data/20260707-chat-probe-v3/trailer_ready_day2/`  
**Engine day:** 2 (= Survival Day 1; grace day was engine day 1)  
**Sources of truth:** `fact_ledger.json`, `cast_digest.md`, `day_log.json`, auto `script.json` (do **not** ship as-is).  
**Audience:** Human lock of narration before re-TTS and Remotion render.

**Status (2026-07-10):** VO + TTS locked for this package (pre-F1). Treat as a **creative reference**, not the F1 history seed — F1 starts clean on the next sim (`lock_day_script` only). Picture pipeline (re-stitch → Remotion → watch) still open.

---

## 1. What we are aiming for

### Product goal

Deliver the **first Survival-night episode** as a **~100–115s, 9:16 daily trailer** (hard cap still **<120s** per [C] L10). Cold viewers should **care who these three people are**, follow what each wanted today, and feel the cost when Vincent goes home — without having watched an opener cut of this cast.

### Creative vision (this package)

- **Self-contained Survival Day 1** — no fake “survived Day 1” scar; pressure starts tonight.
- **Three leads with human stamps:** Vincent (Oak Hill curriculum), Max (Hobbs pastry), Olivia (Hobbs waitstaff).
- **Want → turn → cost:** Vincent tries to solve the board → room he pressured excludes him → he goes home; Max keeps options open; Olivia can hold a side — and helps end him.
- **Limited Immunity** only as character pressure (Irene protected; Vincent must win the room with talk) — not a rules dump.
- **Cliffhanger:** who does the room trust tomorrow?

### Reference docs

| Doc | Why |
|-----|-----|
| `double-ivan/video/daily/TODO_daily_trailer.md` | Day arc, duration, follow-up rules (§F) |
| `double-ivan/video/sot-video.md` | [C] <120s, voice, shared grammar, **L11** first-feature intro |
| `trailer_ready_day2/fact_ledger.json` | Authoritative vote / challenge / elimination |
| `trailer_ready_day2/cast_digest.md` | Ranking, moments, chat beats |

### What went wrong with the auto-draft

1. **Dry strategy VO** — labels (“network builder,” “data collector”) instead of job/place/want.
2. **Fact error** — “survived Day 1…” on Survival Day 1.
3. **No reason to care** — plot moves without human stamps (violates day-arc “who they are, not just what they did”).
4. **Old draft doc** pointed at `20260705-or-smoke` (Mike/Max/Vincent, no boot) — superseded by this package.

**Why this package still matters after F1:** it is the gold example of *full* Survival Day 1 stamps (job + place + want). Auto drafts should sound like this; F1’s `intro_mode=full` + stamp facts exist so the pipeline can enforce that shape without a hand rewrite every time.

---

## 2. Day facts (locked)

| Item | Fact |
|------|------|
| **Challenge** | Limited Immunity — two tokens; claim or negotiate |
| **Challenge winner (ledger)** | Irene Dove protected |
| **Eliminated tonight** | **Vincent Slater** — **2 votes** |
| **Featured (editorial lock)** | Vincent, Max, Olivia *(human choice; post-F2 ranker may differ)* |
| **Jobs** | Vincent: curriculum, Oak Hill · Max: pastry, Hobbs · Olivia: waitstaff, Hobbs |
| **Yesterday scar** | None (first Survival day) |

Vote board is **split** (ledger `votes_received` — six names with 1 each among recorded casts). Do **not** invent a clean unified bloc. Safe to say Olivia’s vote is among those that land on Vincent; do not over-claim “the whole alliance.”

---

## 3. Locked plain-text VO (~100–115s)

Use this verbatim unless product owner edits facts or tone. **No `[SCENE]` tags, no pause markers** in this draft — audio team splits later. First names in VO after the stamp lines; full names OK on first stamp.

```
These are Doubles — AI versions of real people, making choices no one wrote for them.

It is the first night of Survival, and we are following three of them.

Vincent Slater builds curricula at Oak Hill. He treats every vote like a problem on the board — and he needs a clean answer tonight.

Max Shoemaker runs the pastry line at Hobbs Cafe. Half the town passes his counter. He watches who leans in, and he keeps his options open.

Olivia King waits tables at the same cafe. She can hold a group together — or decide who no longer belongs.

Today: Limited Immunity. Two tokens. Claim one or negotiate. Irene Dove walks away protected. Vincent still has to win the room with talk.

Vincent maps Hobbs like a classroom. He locks Diana as his target and starts pulling people into a shared plan.

Max sits with Irene and trades notes. He looks locked in — until his attention drifts back toward Diana.

Olivia confirms a four-person side. Vincent helped build that pressure. He is not on the list.

When the vote lands, Vincent goes home on two votes. Olivia is one of them.

Day one ends with a new imbalance. Max still has cover. Olivia looks like the broker. And the man who tried to solve the board is already gone — so who does the room trust tomorrow?
```

**Word count:** ~231 · **Est. delivery @ 1.5× warm (~2.1 wps) + light pauses:** ~110–113s (inside 100–115 target, under 120 hard cap).  
**Measured TTS:** **106.4s** (in package `audio/narration.mp3`).

### Structure map

| Block | Purpose |
|-------|---------|
| Concept | Doubles line |
| Frame | First Survival night + three names |
| **Character stamps** | Job + place + want/trait (why care) — **F1 `full` shape** |
| Challenge clause | Limited Immunity + Irene safe + Vincent must talk |
| Vincent want | Solve the board / Diana / shared plan |
| Max turn | Irene pact + soft loyalty |
| Olivia turn | Side without Vincent |
| Vote / farewell | Vincent out; Olivia among the votes |
| Cliffhanger | Trust vacuum tomorrow |

---

## 4. Acceptance checklist (this lock)

- [x] Cold viewer can name **who** Vincent / Max / Olivia are in normal life (job + place).
- [x] Cold viewer can say **what each wanted** today in one plain sentence.
- [x] **Vincent eliminated tonight** with **two votes**; no “survived Day 1.”
- [x] Limited Immunity named in plain language; Irene protected; no rules dump.
- [x] No invented clean voting bloc; Olivia’s vote on Vincent is allowed.
- [x] Runtime target **100–115s**, hard cap **<120s**. *(measured TTS: **106.4s**)*
- [x] Tone: plain nouns/verbs; first names after stamps; cliffhanger, not a bow.

---

## 5. After approval

1. ~~Paste locked text into `script.json` `narrator_script` (or `script_used.txt` beside audio).~~ **DONE 2026-07-09** — `trailer_ready_day2/script.json` + `script_used.txt`.
2. ~~Re-TTS warm @ 1.5×; refresh `narration_timing.json`.~~ **DONE** — `audio/narration.mp3` (**106.4s**).
3. Re-stitch beats / locations from `day_log.json`.
4. Remotion render + validate (duration band 60–120s).
5. Owner watch-through + optional D1 comprehension gate.

**Do not** run `lock_day_script` on this package to seed F1 history — product decision: F1 starts clean on the next sim.

---

## 6. Follow-up product rules (pipeline status)

Documented in `daily/TODO_daily_trailer.md` §F · SOT `sot-video.md` **L11**:

| Rule | Status |
|------|--------|
| **F1 First-feature intro** — full stamp first time; recall later; Survival Day 1 always full; lock-only history | ✅ **DONE** (2026-07-10) |
| **F2 Elimination ranking** — no +50 auto-#1; soft +2; farewell if boot ∉ top-3 | ✅ **DONE** (2026-07-09) |
| **F3 Prior-day scripts** — from engine Day 3+, feed locked VOs into producer | ⏳ Pending |

**Next sim operator reminder:** after accepting a day-overview draft:

```bash
python -m video.lock_day_script <sim> --day N --script data/<sim>/trailer_ready_dayN/script.json
```
