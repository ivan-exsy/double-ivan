# Expert brief — Gold Day-1 craft vs Nightly auto Remotion

**Date:** 2026-07-29  
**Owner:** Ivan (founder) · **Audience:** video / craft expert team (videoproducer · reality format · engagement as needed)  
**Goal:** Explain both production systems in enough detail that experts can deliver a **second-by-second comparison** and **clear leveling instructions** so auto-gen matches gold’s visual rhythm, dynamism, and VO lockstep — not just “more SFX.”

**Founder symptom (phone-watch):** New nightly is still dramatically flatter than gold — fewer visual changes, less dynamism, visual rhythm does not match the VO. SFX count was raised to ~gold; the gap remains. Treat this as an **edit grammar / picture cadence / VO sync** problem, not a missing whoosh count.

---

## 1. Ask (what we need back)

Please return a single deliverable (markdown OK) with:

1. **Second-by-second (or ~1s / beat) comparison table** for wall-clock `0 → ~90s` covering both films side by side:
   - What is on screen (hero plate / HUD / Phaser / type)
   - Cut or visual change rate
   - VO line (or silence) in that window
   - Whether picture **locks to VO stress** (word land, challenge name, elim, brand)
2. **Root-cause clusters** (not a laundry list): e.g. “single plate holds too long,” “HUD not re-timed to VO syllables,” “missing mid-beat inserts,” “wrong world mix,” etc.
3. **Level-up instructions for auto-gen** — ordered, implementable by eng, in this shape:
   - **Must** (blocks “same show” claim)
   - **Should** (next pass)
   - **CapCut-only / do not automate yet**
4. **Per-beat picture recipe** for the Scar bins (`hook → stake → pressure → peak → cliff_door → lockup`) that nightly should emit **without** CapCut CSVs.
5. Explicit call on **VO**: keep locked V6 and fix picture timing only, **or** recommend a VO timing/edit pass (still prefer no re-TTS unless necessary).

**Success bar:** After eng implements your Must list, a phone-watch of nightly vs gold should feel like the *same show* (craft + rhythm), not pixel-identical.

---

## 2. Two systems (do not conflate)

| | **Gold (bar)** | **Nightly auto (product path)** |
|--|----------------|----------------------------------|
| Role | Human CapCut gold → Remotion **forensics replay** | Every Survival night ship path (incl. Day-1 rebuild) |
| Composition | `DailyGoldReplay` | `NightlySurvival` (same Remotion renderer component) |
| Timeline source | CapCut CSV timelines (media / text / audio) | Locked VO **segments** → scar beat windows + HUD grammar |
| CapCut CSVs | **Yes** (ingest) | **No** (forbidden as product input) |
| Normative SOT | `SOT-new-daily.md` §11.5 | `SOT-new-daily.md` §11.4 |
| Phone-watch MP4 | `generative_agents/video/remotion/out/gold_replay_day1.mp4` | Latest energy-pass ref (see §6) |

Authority docs:

- Daily trailer SOT: [`SOT-new-daily.md`](SOT-new-daily.md) §11.4–§11.5  
- Gold hub: [`gold/20260713-1_day1_anya/GOLD.md`](gold/20260713-1_day1_anya/GOLD.md)  
- Beat map: [`gold/20260713-1_day1_anya/gold_beat_map.md`](gold/20260713-1_day1_anya/gold_beat_map.md)  
- Craft notes (observable gold behaviors): [`gold/20260713-1_day1_anya/craft_notes.md`](gold/20260713-1_day1_anya/craft_notes.md)  
- Eng gap freeze: `generative_agents/video/NIGHTLY_CRAFT_GAP.md`  
- Challenge teach packs: `double-docs/sot/sot_challenges.md` §5  

---

## 3. Gold production process (detailed)

### 3.1 Human gold creation (Anya CapCut)

1. Locked **V6** Survival Day-1 VO (fact-locked Peak/Cost/challenge/elim).  
2. CapCut editorial cut on 9:16 with dense layered timeline (picture + legend HUDs + stock SFX + music + kinetic text).  
3. Machine extracts under:

```
double-ivan/video/daily/gold/20260713-1_day1_anya/capcut/
  capcut_media_timeline.csv
  capcut_text_timeline.csv
  capcut_audio_timeline.csv
  capcut_summary.json
  capcut_segments.csv
  legend_usage.csv
  …
```

4. Clip kit + promoted legend art + VO audio sit beside the package / eng `trailer_ready_day2/clip_kit`.

### 3.2 Remotion gold replay (forensics — eng)

```bash
cd generative_agents   # ivan/dev
python -m video.build_gold_replay_props
cd video/remotion
npx remotion render DailyGoldReplay out/gold_replay_day1.mp4 \
  --props=props/gold_replay_day1.json
```

Builder (`video/build_gold_replay_props.py`) approximately:

1. Ingest CapCut CSVs → timed layers / texts / audio / FX.  
2. Stage media into `video/remotion/public/gold_replay/`.  
3. World-plate swaps → C1–C8 cinematic pack (`WORLD_PLATE_REPLACEMENTS`); **never** swap Phaser `signature_flyover`.  
4. `apply_phase1_hud_grammar` — founder-locked HUD stack (poster, LIVE/ACTIVE, Survival stamp, STEP bands, want HUDs, alliances two-beat, Cost grey seat 3.3, end lockup punch).  
5. CapCut stock SFX → local stand-ins; craft FX (scan / shake / black_hit / radial_zoom).  
6. Music bed + CapCut volume envelope; end swoosh + 9:16 lockup.

**Important:** Gold Remotion is a **replay of a human edit**. Timing is CapCut wall-clock. That is why it feels “busy” and VO-locked — every cut was authored against the VO take.

### 3.3 Craft notes (what gold does well — experts should verify)

From `craft_notes.md` (observable, not taste ranking):

- Mute hook = walk-in + status, not logo-only.  
- Concept literacy via cast matrix + kinetic fragments, then Phaser as product UI (`LIVE SIMULATION` / `N ACTIVE`).  
- Irene want = habitat; Ivan want = intention HUD (“READ THE ROOM”).  
- Challenge teach is **stepped** over bodies.  
- Peak = evidence (card visible).  
- Alliances = abstract teach, then votes.  
- Cost = dignified leave; cliff = forward threat; door = Phaser → brand lockup.  
- Picture change rate: **rarely >2–3s without type or cut**.

Open founder taste questions in that file still matter for what auto-gen **must** copy vs CapCut-only flourishes.

---

## 4. Nightly auto process (current)

### 4.1 Intent

One command after facts + locked VO + clip_kit exist — **no CapCut CSVs**:

```bash
cd generative_agents
python -m video.run_nightly_survival data/20260713-1/trailer_ready_day2 \
  --length-mode long --force
```

Chain: validate → `build_nightly_remotion_props` → literacy/length/anti-leak gates → snapshot → Remotion `NightlySurvival` → `output/nightly_run_report.json`.

### 4.2 Inputs (Day-1 package)

```
data/20260713-1/trailer_ready_day2/
  tonight_scar_picker.json      # Peak / Cost / door
  fact_ledger.json              # challenge id, elim, …
  vo_locked.txt                 # V6 text (immutable for this prove)
  audio/narration*.mp3          # locked take
  audio/narration_timing.json   # sibling timing (14 segments, ~87.6s) — VO-lock = audio+timing
  clip_kit/bins/{A_hook…E_cliff_door,F_phaser}/
```

Challenge teach (Hold for the Shield) from:

`video/assets/challenges/hold_for_shield/` (status **specimen**).

### 4.3 How timing is invented (root of rhythm risk)

Unlike CapCut wall-clock:

1. Load `narration_timing.json` segments.  
2. Keyword-classify each line → Scar beat (`hook|stake|pressure|peak|cliff_door`) → **merge windows**.  
3. Derive HUD windows from those beats (`video/nightly_hud.py`: LIVE/ACTIVE, stamp, want, alliances…).  
4. Place bin media + teach pack + grey-out + lockup into those windows.  
5. Schedule stock SFX/FX on beat/cut markers (~23 SFX after energy pass).  
6. Emit **key-phrase** captions only (~10–22), not full VO transcript.  
7. Anti-leak: no Day-1 `legend_promoted` persona/count art in emitted `src`; want plates staged as `want_peak_hud.png` / `want_cost_hud.png` when Anya art exists.

**Renderer:** same `DailyGoldReplay.tsx` — so quality gap is almost entirely **props / edit plan**, not Remotion chrome.

### 4.4 Explicit policies for this analysis

| Policy | Status |
|--------|--------|
| Re-TTS locked V6 for timing | **Forbidden** unless your Must list proves picture-only cannot recover rhythm |
| CapCut CSV as nightly product input | **Out of scope** |
| Day-1 Anya want plates for prove | Allowed if staged under neutral filenames |
| Mass CapCut `H_*` legend wall every night | Still taste-gated off |
| Featured job+place VO intros | **Parked** for this brief (existing VO only) |

---

## 5. Quantitative snapshot (props, not taste)

| Metric | Gold props | Nightly long (energy pass) |
|--------|------------|----------------------------|
| `totalSec` | ~89.3 | ~90.2 |
| Layers | **50** | **29** |
| Texts (CC) | **43** (CapCut kinetic fragments) | **22** (key-phrase highlights) |
| SFX events | **23** | **23** |
| FX events | **9** | **14** |
| CapCut CSV source | yes | no |

**Founder read:** Matching SFX count did **not** close the gap. Experts should prioritize **layer change cadence**, **mid-beat inserts**, **VO syllable lock**, and **stacked world mix** over adding more whooshes.

Props on disk:

- Gold: `generative_agents/video/remotion/props/gold_replay_day1.json`  
- Nightly: `generative_agents/video/remotion/props/nightly_20260713-1_day2_long.json`  

---

## 6. Watch assets (side-by-side)

| Label | Path |
|-------|------|
| **Gold bar** | `D:\Coding\generative_agents-ivan-dev\video\remotion\out\gold_replay_day1.mp4` |
| **Nightly energy-pass reference** (renamed; do not overwrite) | `D:\Coding\generative_agents-ivan-dev\data\20260713-1\trailer_ready_day2\output\trailer_9x16_20260729_184421_energy_pass_ref.mp4` |
| Same bytes (named) | `…\output\nightly_20260713-1_day2_long.mp4` |
| Locked VO text | `…\trailer_ready_day2\vo_locked.txt` |
| VO timing | `…\trailer_ready_day2\audio\narration_timing.json` |
| Gold beat map | `double-ivan/video/daily/gold/20260713-1_day1_anya/gold_beat_map.md` |

Optional: 1fps / keyframe stills already used for gold craft notes under the Anya gold package (see GOLD.md / grabs if present).

---

## 7. Suggested analysis method

1. Scrub both MP4s with VO timing JSON open (segment `start_sec` / `end_sec` / `content`).  
2. Build a shared timeline at **1s resolution** (or VO segment boundaries, whichever reveals the rhythm miss faster).  
3. For each row mark: gold picture event · nightly picture event · **delta type** (`missing cut`, `held too long`, `wrong plate`, `HUD late/early`, `type missing`, `stack missing`).  
4. Cluster deltas into eng-facing recipes (e.g. “Stake must alternate habitat↔want HUD every ≤2.0s while Irene/Ivan lines play”).  
5. Cross-check against `craft_notes.md` “what the cut does well” — flag anything nightly systematically skips.  
6. Output Must/Should/Defer with acceptance checks eng can automate (role presence + max hold time + VO-aligned windows).

---

## 8. Constraints / non-goals

- Do **not** recommend returning CapCut XML as the nightly product path.  
- Do **not** require pixel-identical frames to gold.  
- Do **not** invent new facts (Peak/Cost/challenge/elim stay ledger-true).  
- Prefer solutions that generalize past Day-1 (synthetic Night-2 / anti-leak still apply). Day-1-only plate reuse is OK as a temporary Must if labeled.

---

## 9. Eng contact points (for your instructions)

| Concern | Code / doc |
|---------|------------|
| Scar beat + captions | `video/nightly_vo_timing.py` |
| HUD windows / anti-leak / want plates | `video/nightly_hud.py` |
| Edit plan emit | `video/build_nightly_remotion_props.py` |
| Shared craft constants | `video/nightly_craft.py` |
| Gold grammar (reference only) | `video/build_gold_replay_props.py` → `apply_phase1_hud_grammar` |
| CLI | `video/run_nightly_survival.py` |
| Gap log | `video/NIGHTLY_CRAFT_GAP.md` |

---

## 10. Handoff checklist for experts

- [ ] Watched gold + energy-pass ref back-to-back on phone  
- [ ] Second-by-second (or 1s) comparison table completed  
- [ ] Root-cause clusters named  
- [ ] Must / Should / CapCut-only instructions written for eng  
- [ ] Per-Scar-bin picture recipe written  
- [ ] VO keep-vs-revise recommendation stated  

Deliverable filename suggestion:  
`double-ivan/video/daily/20260729_expert_response_gold_vs_nightly_levelup.md`
