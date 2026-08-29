# Expert brief — Verify Day-1 gold edit script (sync bar)

**Date:** 2026-07-29  
**Owner:** Ivan (founder) · **Audience:** video / craft experts (videoproducer · reality format)  
**Goal:** Confirm whether the extracted **edit script** faithfully encodes gold’s wall-clock picture timing and VO lockstep — and name what’s still missing or mis-labeled. This is a **verification** brief, not another open “why is nightly flat?” critique.

**Context:** Eng stopped guessing scar recipes for Day-1. We extracted a cut list from gold Remotion props (CapCut forensics) and nightly now **executes that script** when present. Phone-watch should feel closer to gold; your job is to say if the script itself is right.

---

## 1. Ask (what we need back)

**Respond in this same file** — append your findings under **§8 Expert findings** below (do not create a separate response doc).

Please cover:

1. **Verdict:** Does `edit_script.json` encode gold sync well enough to be the Day-1 bar? (`pass` / `pass with fixes` / `fail`)
2. **Clock check:** For VO stress moments (cast count, Peak/Cost names, challenge name, Shield, elim, “fifteen→fourteen”, brand), is picture **on time** vs gold MP4? Flag early/late by ~seconds if off.
3. **Missing / wrong cuts:** Any gold visual that is absent, held wrong, or mapped to the wrong `role` / media in the script.
4. **Role taxonomy:** Which `legend_insert` (and other generic) cuts should be renamed to stable product roles (habitat, census, cliff insert, etc.) so Night-2+ can reuse the schema without CapCut.
5. **Captions:** Keep gold text-track timings, or prefer syllable-locked VO captions for auto nights?
6. **Ship call:** Is this script good enough for Day-1 nightly ship pending your Must fixes, or must eng re-extract after CapCut CSV merge?

**Success bar:** Experts can say “execute this script = gold rhythm” (media may differ slightly; timing must not).

---

## 2. What eng built (do not redesign the pipe)

| Piece | Path |
|-------|------|
| Schema + apply | `generative_agents/video/nightly_edit_script.py` |
| Extractor | `generative_agents/video/extract_gold_edit_script.py` |
| Canonical Day-1 script | `generative_agents/video/assets/edit_scripts/20260713-1_day1_gold_sync.json` |
| Package copy (nightly prefers this) | `data/20260713-1/trailer_ready_day2/edit_script.json` |
| Nightly builder | Prefer script when present; else scar recipes |
| Gold source props | `video/remotion/props/gold_replay_day1.json` (50 layers → 50 cuts) |

**Clock fields in script:**

- `totalSec` ≈ 89.33 (gold props)
- `voSec` = 87.62 (locked V6)
- `posterHoldSec` = 2.5
- `voStartOffsetSec` = 0.9 (gold boot; verify against phone-watch)

**Stats (v1 full extract):** 50 cuts · 43 captions · median non-bed hold ≈ 2.4s · roles include badges, teach STEPs, want HUDs, alliances two-beat, Phaser plant/door, census, `legend_insert` inserts, end lockup.

---

## 3. Films to watch (phone)

| Label | File |
|-------|------|
| **Gold bar** | `generative_agents/video/remotion/out/gold_replay_day1.mp4` |
| **Nightly = edit script (latest master)** | `data/20260713-1/trailer_ready_day2/output/trailer_9x16.mp4` |
| Snapshot of this pass | `…/output/trailer_9x16_20260729_200304_edit_script_v1_full.mp4` |
| Do **not** treat as current | `…/trailer_9x16_20260729_184421_energy_pass_ref.mp4` (older energy pass; keep as archive only) |

Also open:

- Script JSON (cuts + captions) — §2  
- VO timing: `data/20260713-1/trailer_ready_day2/audio/narration_timing.json`  
- Gold craft notes: [`gold/20260713-1_day1_anya/craft_notes.md`](gold/20260713-1_day1_anya/craft_notes.md)  
- Prior level-up response (context only): [`20260729_expert_response_gold_vs_nightly_levelup.md`](20260729_expert_response_gold_vs_nightly_levelup.md)

---

## 4. Known gaps eng already sees (confirm / correct)

These are **not** hidden — please validate or reclassify:

1. **Generic `legend_insert`:** Several CapCut HF clips kept timing but lack product role names (stake habitat dives, cliff social, etc.). Experts should rename for schema reuse.
2. **Habitats / namecards:** Peak namecard + Cost namecard present; workplace habitat plates may still be under `legend_insert` or missing as named roles — confirm.
3. **Want HUDs:** Staged under neutral filenames (`want_peak_hud` / `want_cost_hud`) for anti-leak; art is still gold CapCut plates. Confirm timing, not filename.
4. **SFX / FX:** Script pass focuses on **picture cuts + captions**. Stock SFX bus may still differ from CapCut — call out only if it breaks VO sync feel.
5. **Clock vs VO:** Nightly total ~90.2s (VO + end lockup hold). Gold props `totalSec` 89.33. Flag if boot/poster offset makes picture land early/late vs spoken words.
6. **Generalization:** Day-1 script is gold-specific media. Night-2+ needs word-align or scar recipes — out of scope for this verify unless you see a schema hole that blocks that later.

---

## 5. Suggested verify method (short)

1. Scrub gold + script-nightly back-to-back on phone (mute optional once; then with VO).  
2. Spot-check against script JSON at these wall-clock anchors (adjust if gold differs):

| ~t (s) | Expect (gold grammar) |
|--------|------------------------|
| 0–3 | Hook face / cast / mute walk-in |
| ~5.6 | LIVE + N ACTIVE + Phaser plant |
| ~20–27 | Stake / want / Peak–Cost pressure |
| ~35–48 | Challenge teach + STEP bands + Shield |
| ~52–66 | Alliances → ballots → Cost |
| ~63–66 | Census / fifteen→fourteen energy |
| ~68–83 | Cliff / door Phaser / new pressure |
| end | Full-bleed VO → 9:16 lockup |

3. For each miss: cite `cut.id` / `role` / `startSec` from the JSON (or “missing from script”).  
4. Deliver Must fixes as **script edits** (timing / role / mediaHint) when possible — not a new open Must list for unrelated craft.

---

## 6. Constraints

- Do **not** recommend CapCut XML as the product path.  
- Do **not** ask to re-TTS locked V6 VO.  
- Do **not** require pixel-identical frames.  
- Prefer corrections that keep **wall-clock sync** as the Day-1 bar.

---

## 7. Handoff checklist

- [~] Watched gold vs edit-script nightly on phone — **substituted instrumented A/B** (frame-fingerprint
  picture match + VO cross-correlation) on the **master**, not the named snapshot. A founder phone watch is
  still worth doing *after* Must #1 lands; it will not surface anything more about timing.
- [x] Verdict recorded — `pass with fixes`
- [x] Clock / VO stress table completed — all 7 moments measured, 1.31s → 0.54s late
- [x] Missing/wrong cuts listed with script IDs where possible — 8 items; no picture holes
- [x] `legend_insert` → product roles proposed — 15 renames, `legend_insert` emptied
- [x] Captions recommendation stated — repaired gold track for Day-1, syllable-locked for auto nights
- [x] Ship call stated — **yes**, after Must #1 + #2

**Eng will implement your Must script fixes next; no more vibe scar passes for Day-1.**

---

## 8. Expert findings

> **Instructions for experts:** Fill this section in place. Keep the headings. Cite `cut.id` / `role` / `startSec` where useful. Date + author at top.

**Date:** 2026-07-29  
**Author(s):** Craft verification pass — **instrumented A/B**, not a subjective phone watch.

**Method (so you can weigh the evidence):** rather than eyeball the two films, we measured them.
(a) *Picture:* per-frame fingerprints of both MP4s, matched event-by-event to find the onset wall-clock of
each cut in each film. (b) *Audio:* cross-correlated the locked V6 `narration.mp3` against both films'
audio at 14 points to recover exactly where the VO sits in each. (c) Confirmed the result against the
raw `audio[]` block in `gold_replay_day1.json`. Every number below is measured, not estimated.

Films compared: `gold_replay_day1.mp4` (2755 frames / 91.883s) vs master
`trailer_9x16.mp4` (2782 frames / 92.779s).

---

### Verdict

**`pass with fixes`** — the cut list is a *frame-exact* encoding of gold's picture clock (20 independent
picture events, **median deviation 0.000s**; 13 of 20 matched to the frame), but the script omits gold's
**VO plan** entirely, so nightly lays the locked V6 flat from t=0 and every cut and caption lands
**0.5–1.3s late against the spoken word**. The picture script is right; the thing that makes it *sync* is missing.

*(Two events read as larger shifts — the second `signature_flyover` and the night plate. Both are
media reused at more than one timecode or joined by a slow dissolve, so the matcher is ambiguous there;
neither is a real shift.)*

**The headline:** this is not a timing-extraction failure. Picture is already at the bar. It is a
**single missing field**, and the correct values are sitting in gold's own props.

### Clock / VO stress check

Read "nightly body" as *what frame of the cut list is on screen when that word is spoken*. Gold and nightly
run the **same** picture clock, so all delta comes from VO placement.

| Moment | Gold OK? | Script nightly | Delta (early/late ~s) | Notes |
|--------|----------|----------------|------------------------|-------|
| Cast count / FIFTEEN | ✅ cast census insert `g031` + caption land together at body 9.25 | still inside LIVE / 15 ACTIVE flyover (`g030`), caption reads **"WROTE FOR THEM"** | **1.31s LATE** | Worst point in the film, and it is the hook |
| Peak / Cost names | ✅ Irene card up 0.7s before "Irene Dove"; Ivan card pre-laps "and Ivan Pitts" | on "Irene Dove" no card yet (`g044` starts 17.43); on "Ivan Pitts" only Irene's card | **1.22 / 1.21s LATE** | Both names spoken over the wrong card |
| Challenge name | ✅ `challenge_title` `g034` lands at VO 31.82 = exactly on "Hold for the Shield" | title card arrives after the name has already been said | **1.08s LATE** | Format name loses its title-card hit |
| Shield | ✅ caption "WINS THE SHIELD" lands at VO 41.98, on the word | caption still reads **"HIGHEST CARD REMAINING"** | **0.97s LATE** | Payoff word uncovered |
| Elim / Cost out | ✅ "IVAN IS GONE" caption at VO 67.74, on the words; walk-out `g016` cuts at 68.37 | still on phaser bridge, caption **"IRENE'S BALLOT IS ONE OF THEM"** | **0.72s LATE** | |
| Fifteen → fourteen | ⚠️ grey-out `g017` lands mid-phrase (VO 70.90) — but **no caption in gold either** | grey-out lands near the *end* of the phrase | **0.70s LATE** | 2.03s caption hole; the count is never on screen |
| Brand / end | ✅ `end_lockup` `g023` lands at VO 86.15 = on "doubland.ai" | lockup lands at VO 86.69, after "doubland" has started | **0.54s LATE** | Least broken, still soft on the CTA |

**Root cause, exactly.** Gold's props place the VO as **two clips at `speed: 1.01`** with a deliberate
breath between them; nightly's props place it as **one clip at 1.00× starting at 0.0**:

| | gold `gold_replay_day1.json` | nightly `nightly_..._day2_long.json` |
|---|---|---|
| clip A | `startSec 0.9 → 8.6`, `sourceStartSec 0.0`, **`speed 1.01`** | `startSec 0.0 → 87.62`, `sourceStartSec None`, `speed None` |
| breath | **0.533s of silence** (body 8.6 → 9.133) before "Fifteen of them entered" | — |
| clip B | `startSec 9.133 → 88.033`, `sourceStartSec 7.777`, **`speed 1.01`** | — |

Measured VO start: gold **3.97s** wall (body 1.47 effective) vs nightly **2.545s** (body 0.045). The 1.01
speed is confirmed independently — re-testing the correlation with the reference sped up by 1.0097 collapses
the offset spread from **2.95s to 0.03s**. So the drift is real and its magnitude is known to ±0.03s.

`clock.voStartOffsetSec` is *not wrong* (0.9 is gold's clip-A start) — it is **never read by any code**
(`extract_gold_edit_script.py:91` writes it; nothing consumes it), and on its own it cannot reproduce gold
sync because it carries neither the 1.01 speed, the 0.533s breath, nor `sourceStartSec 7.777`.

### Missing or wrong cuts

Picture coverage is continuous 0 → 89.33 with **no holes** — nothing is absent. The defects are labelling,
redundancy and captions:

1. **The whole VO plan is missing from the schema.** There is no `vo[]` in the script. This is the only
   change that affects whether the film reads as synced. See Must #1.
2. **`g012` is mapped to the wrong role.** Tagged `peak_portrait` (body 51.93–54.13) but the media is a
   **dusk world establishing plate** (mountain village, L-TALKS badge) under "AS THE DAY CONTINUES". On
   Night-2+ a role-driven build will substitute a persona portrait here and break the beat. Should be `world_plate`.
3. **`g026` is mapped to the wrong role.** Tagged `census` (body 63–66) but the media is the
   **VOTING TARGET / IVAN PITTS · 6 VOTES RECEIVED** card. It is a vote tally, not a census. The film's
   *actual* census visual is `g020` (15-seat cast grid with one silhouetted unknown, body 80.6–82.9),
   which is currently tagged `legend_insert`. The two names are effectively swapped.
4. **Triple-stacked identical media.** `g042` (14.667–15.30, tr9), `g043` (15.30–16.60, tr9) and `g047`
   (14.667–16.60, tr10) are the **same** file at ~0.5 opacity — one clip split in two and then duplicated
   underneath itself. That is a CapCut crossfade/speed-ramp flattened by the extractor; it renders as a muddy
   double-exposure. Collapse to a single cut 14.667 → 16.60.
5. **Caption defects (5).** Two duplicate tails that read as stutters — #4 "NO ONE WROTE FOR THEM" →
   #5 "WROTE FOR THEM", and #7 "SOMEONE IS VOTED OUT" → #8 "IS VOTED OUT". Two unreadable holds —
   #7 at **0.47s / 42.8 ch-s** and #22 "AND IMMUNITY" at **0.30s / 40 ch-s**. And a name typo:
   #31 reads **"IVAN PITS"** while the card behind it correctly reads *IVAN PITTS*.
6. **The count is never on screen.** 2.03s caption hole (71.0 → 73.03) across "Just like that, fifteen
   become fourteen" — 37.9% caption coverage on the single most important product number in the film.
   Gold has this hole too, so it is a **gold defect we are faithfully reproducing**, not a nightly bug.
7. **Do not copy gold's VO mix.** Gold drops clip B to `volume 0.6582` (−3.6 dB) for 90% of the film.
   Nightly's flat 1.0 is better. Copy gold's *timing*, not this.
8. **Music open.** Gold holds music out until body 1.933 so the typing SFX opens cold; nightly starts the
   bed at 0.0. Minor, but it is why nightly's first two seconds feel less deliberate.

### Role taxonomy (`legend_insert` → product roles)

Named from the actual frames, so Night-2+ can fill these slots without CapCut:

| cut.id | startSec | Proposed role | Why |
|--------|----------|---------------|-----|
| `g031` | 9.133 | `cast_census_entry` | Cast grid with highlighted portraits — the "N entered" roster beat |
| `g042`/`g043`/`g047` | 14.667 | `wincon_one_remains` | Glowing **1 ACTIVE** ring over 15 seat dots = win condition, not a census. Collapse the three into one |
| `g005` | 20.333 | `peak_habitat` | Irene behind her bakery counter — **this is the workplace habitat plate §4.2 asked about** |
| `g006` | 23.733 | `cost_habitat` | Ivan behind his shop counter — the matching Cost habitat plate |
| `g009` | 46.733 | `challenge_result_reveal` | Table of held number cards at the reveal (currently `challenge_insert`) |
| `g010` | 48.533 | `peak_shield_win` | Winner holding the high card + IMMUNITY ACTIVE (currently `peak_portrait`) |
| `g011` | 49.933 | `shield_grant_fx` | Energy-swirl shield grant on the winner |
| `g012` | 51.933 | `world_plate` | **Wrong role today** — dusk establishing plate, not a portrait |
| `g015` | 66.000 | `phaser_vote_bridge` | Keep, but name the engine bridge explicitly |
| `g016` | 68.367 | `cost_exit_walk` | Eliminated player leaving with a bag — the elimination walk-out |
| `g018` | 74.233 | `cliff_shield_gone` | Shield dissolving (currently `end_vo_visual`) |
| `g024` | 75.833 | `cliff_alliances` | Chat-bubble wireframe under "NEW ALLIANCES WILL FORM" |
| `g019` | 78.367 | `cliff_new_targets` | Target-ring network under "NEW TARGETS WILL EMERGE" |
| `g020` | 80.600 | `cast_census_remaining` | **The real census** — 15-seat grid with one silhouetted unknown |
| `g026` | 63.000 | `vote_tally` | VOTING TARGET card with votes-received count — **not** a census |

After this, `legend_insert` is empty and every cut carries a role a Night-2 builder can resolve. That closes
the schema hole in §4.6 — no CapCut needed.

### Captions recommendation

**Split the answer: keep gold's track for Day-1 (repaired), move to syllable-locked VO captions for auto nights.**

Gold's 43-cue track is genuinely well-placed against gold's VO — it is not the problem here. But it carries
CapCut progressive-reveal artifacts (the duplicate tails, the 0.30s and 0.47s cues) that only make sense as
an animation the extractor flattened, and they will not regenerate for a new night.

More importantly, the desync we just measured is *the* argument for syllable-locking: a caption track stored
as absolute body times can silently drift a full second from the audio, which is exactly what happened.
Syllable-locked captions derive from VO word timings and therefore **cannot** drift. Keep gold's track as the
style reference (ALL CAPS, 2–4 word chunks, ~1.0–1.5s per cue, 10–16 ch-s) and generate the timing.

### Must script fixes (for eng)

Ordered. **#1 alone fixes the sync.** #2 is text-only. #3–#5 are schema hygiene and do not block Day-1.

1. **Add a `vo[]` block to the script and have the nightly builder honour it.** Values are lifted directly
   from gold props — no guessing, no re-TTS, no CapCut:

```json
"vo": [
  { "startSec": 0.9,   "endSec": 8.6,    "sourceStartSec": 0.0,   "speed": 1.01, "gain": 1.0 },
  { "startSec": 9.133, "endSec": 88.033, "sourceStartSec": 7.777, "speed": 1.01, "gain": 1.0 }
]
```

   Note `gain 1.0` on both — deliberately **not** gold's 0.658 duck. Also note these spans consume source
   `0 → 87.466` of an 87.62s file, i.e. gold clips the last **0.154s**; that is trailing silence after
   "doubland.ai", so copy it as-is rather than stretching clip B to fit. Extend `extract_gold_edit_script.py`
   to carry `audio[role=="vo"]` instead of hardcoding `voStartOffsetSec = 0.9`, and make the builder emit
   two VO layers rather than one. Expected result: the 1.31 → 0.54s lateness goes to **0.00s** across the film.
   *To be explicit: `speed 1.01` is a 1% pitch-preserving tempo nudge that gold itself already uses — it is
   not a re-TTS and is inaudible.* If it is rejected anyway, placing the VO at 0.9 / 9.133 at 1.00× still
   removes most of the error (residual grows 0 → 0.79s instead of today's 1.31 → 0.54s) — but do #1 properly.

2. **Five caption repairs** (text/timing only):
   - Extend #4 to `6.9 → 9.033` ("NO ONE WROTE FOR THEM"); **delete** #5.
   - Merge #7+#8 into one cue `12.3 → 13.8` ("SOMEONE IS VOTED OUT"); **delete** #8.
   - Merge #22+#23 into `44.467 → 46.467` ("AND IMMUNITY FROM TONIGHT'S VOTE").
   - #31 text `"IVAN PITS"` → `"IVAN PITTS"`.
   - **Add** `{"startSec": 71.0, "endSec": 73.033, "text": "FIFTEEN BECOME FOURTEEN"}` — fills the hole and
     puts the count on screen for the first time.
3. **Collapse `g042`/`g043`/`g047`** into a single cut `14.667 → 16.60`, one track, full opacity.
4. **Apply the 15 role renames** in the table above.
5. **Should-fix, non-blocking:** move the music bed start from 0.0 → 1.933 to restore gold's cold typing
   open; trim `g016` from 3.27s → 3.0s to clear the standing `hero hold 3.1s > 3.0s` warning at t=68.5.

### Ship call

**Yes — ship Day-1 on this script, after Must #1 and #2 land and one re-render is watched.**
The picture cut list is already at the gold bar and needs no re-extraction; shipping *today's* master would
regress the one axis this pass exists to protect, and #1 is a single block of numbers copied out of gold's
own props.

**Answering §1.6 directly: no CapCut CSV re-extract is needed.** The props-derived extract is frame-exact on
picture — the extractor simply skipped the audio rows that were sitting in the same file.

**Two housekeeping notes for the next pass.** The brief points at snapshot
`…_200304_edit_script_v1_full.mp4`, but master `trailer_9x16.mp4` was re-rendered ~7 min later and the two
differ on 456 of 2782 frames — this review used the **master**, and the snapshot should be re-cut so the
named reference matches what ships. And once #1 lands, `totalSec` should come back toward gold's 89.333
(nightly is 90.22), which leaves the ~1.3s silent lockup tail gold uses rather than 2.2s.
