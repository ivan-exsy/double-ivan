## Picture-pass asset audit — `20260713-1` / `overview_day2&001` (2026-07-15)

**Package:** Survival Day 1 locked VO (`VO_LOCKED.md` ≡ `script.json` ≡ `script_used.txt`).  
**Featured cast:** Ivan Pitts · Irene Dove · Vince Vale.  
**Purpose:** Tomorrow’s Remotion prep checklist — gather/stage vs generate vs per-day custom clips.  
**Do not** overwrite locked VO / re-TTS while Anya review is open.

### Scene → visual job (edit spine)

| Scene | Beat | VO job | Visual job |
|------:|------|--------|------------|
| 1 | concept_reset | What Doubles are | Brand / group / matrix still |
| 2 | survival_frame | First night / eliminate until one | Survival framing still (group or dorm common OK) |
| 3–5 | cast_intro | Job + place + want stamps | Hero portrait per Double |
| 6 | challenge_teach | Hold for the Shield → Irene wins | Irene + challenge space (optional 1–2s clip) |
| 7 | mid_turn | Ivan hunts; Vince↔Irene talk | Social / night pressure (optional clip) |
| 8 | cost | Six votes; Ivan goes home | Vote / farewell (highest clip priority) |
| 9 | cliff_cta | Trust vacuum + doubland.ai | Irene / cliff + opener end-card pattern |

---

### 1. Ready now (exist on disk — stage into Remotion)

**Cast (baseline cohort `soul15_seed_20260224`)**

| Person | Hero | Portrait | Sketch | Cutout |
|--------|:----:|:--------:|:------:|:------:|
| Ivan Pitts (`42c86639-…fea8`) | ✅ | ✅ | ✅ | ✅ |
| Irene Dove (`eac7be2a-…e9dc`) | ✅ | ✅ | ✅ | ✅ |
| Vince Vale (`69835d95-…845d`) | ✅ | ✅ | ✅ | ✅ |

Paths: `video/assets/cohort/soul15_seed_20260224/{hero,portraits}/<uuid>.png` · sketches `video/assets/users/sketches/` · cutouts `video/assets/users/cutouts/`. Full 15-Double set present in each.

**Group / concept**

- ✅ `group_photo.png` (+ `group_photo_a/b/c.png`, `group_photo_matrix.png`)
- ✅ `relationship_graph.json`, `cast_reference.md`, `manifest.json`

**Places we already have plates for (usable today)**

- ✅ **Hobbs Cafe** — `village/interior/cafe_int_counter.png`, `cafe_int_dining.png` · exterior `village/exterior/hobbs_cafe_exterior_wide.png`
- ✅ **Dorm / night common** (vote / “room” pressure proxy) — `dorm_int_common.png`, `dorm_int_common_vertical.png`, bedrooms/baths
- ✅ **Library** — `library_int_reading.png`, `library_int_stacks.png` · exterior `library_exterior_wide.png`
- ✅ **Oak Hill College classroom** — `college_int_classroom.png` (Vince workplace stamp)
- ✅ **Willows Market & Pharmacy** — `willows_pharmacy_int_counter.png`, `willows_market_int_aisle.png`
- ✅ **Harvey Oak Supply Store** — `supply_int.png`
- ✅ **Rose and Crown Pub** — `pub_int.png`
- ✅ **Apartments 1–5** — `apt{N}_int_main.png` + baths
- ✅ **Houses 1–3 mains** + **Houses 4–6** commons/bedrooms/baths
- ✅ **Artist co-living** — common + studio rooms 1–5 + baths
- ✅ **Johnson Park** (outdoor) — `village/exterior/johnson_park_exterior_wide.png`
- ✅ Phaser property top-downs for the above under `video/assets/phaser/_moodboard/` (manual crops; see that folder’s README)
- Inventory coverage: **57 DONE / 0 TODO / 6 N/A** (`village/interior/_room_inventory.md`)

**Still optional / not blocking Day-1 picture pass**

- [ ] **Oak Hill College exterior** (library exterior ≠ college facade)
- [ ] **Willows exterior** (optional stamp / establish)

**Audio / edit package**

- ✅ Locked narration + timing: `overview_day2&001/audio/narration.mp3`, `narration_timing.json`
- ✅ Mood bed: `audio/music_drama.mp3`
- ✅ Scene list in `script.json` (`locked_human_vo: true`)

**Remotion plumbing (code, not new media)**

- ✅ Daily props path + moment-clip drop-in convention: `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4`
- ✅ End-card / opener component reuse already wired

**Gaps inside an otherwise-ready package (fix at render time, not new art)**

- [ ] Scenes 6–9 in `script.json` have `hero_path: null` — props builder should resolve from `focus_persona`; verify on first Remotion props build.
- [ ] All scenes have empty `location` — on-screen location labels won’t show until filled (B2); plates can still be chosen manually for clips.
- [ ] **No** `video/assets/moment_clips/` tree yet — expected; clips are optional for first render.

---

### 2. Generate next (Ivan — stills / environment plates) — mostly DONE 2026-07-18

Reusable village plates for Day-1 stamps + future social scenes. Inventory is **0 TODO** interiors.

| Priority | Asset | Status | Paths |
|:--------:|-------|:------:|-------|
| **P0** | Willows Market & Pharmacy interiors | ✅ | `willows_pharmacy_int_counter.png`, `willows_market_int_aisle.png` |
| **P0** | Oak Hill College classroom | ✅ | `college_int_classroom.png` |
| **P1** | Oak Hill College exterior | [ ] optional | Not on disk (library exterior ≠ college) |
| **P1** | Willows exterior | [ ] optional | Not on disk |
| **P2** | Pub · supply · apt/house/artist remaining rooms · Johnson Park outdoor | ✅ | `pub_int.png`, `supply_int.png`, apt/house/artist plates, `johnson_park_exterior_wide.png` |

**Acceptance for #2:** Named stills under `video/assets/village/{interior,exterior}/` with clear filenames; Phaser layout refs under `phaser/_moodboard/`. **Met for all interior TODOs + Johnson Park outdoor (2026-07-18).**

---

### 3. Custom per day / cast (after #2) — moment clips + prompt kit

**What these are:** short **1–2s**, 9:16 cinematic beats (Grok Imagine or hand-made) dropped into  
`video/assets/moment_clips/20260713-1/2/beat_<scene_id>.mp4`  
Rule of thumb: **1–3 clips max** (establishing stamps stay portrait cards).

**Recommended clip slots for this locked VO**

| Clip | Scene | Story moment | Who is on camera | Place plate (after #2) | Character refs (ready now) |
|------|------:|--------------|------------------|------------------------|----------------------------|
| A | 6 | Irene wins Hold for the Shield | Irene (+ optional group) | Dorm common *or* challenge gather space | Irene hero + sketch |
| B | 7 | Ivan reading faces / Vince–Irene talk | Ivan; or Vince+Irene | Dorm common / cafe / Willows (pick one truth) | Heroes for people in frame |
| C | 8 | Votes scatter — Ivan goes home | Ivan (+ Irene if ballot beat) | Dorm common (vote night) | Ivan hero; Irene if needed |

**Resources that are already handy for the prompt (when #2 is done)**

| Input | Source |
|-------|--------|
| Scene action / VO line | `script.json` `narrator_lines` + `VO_LOCKED.md` |
| Who / UUID | `cast_reference.md` + hero/portrait/sketch paths above |
| Place still | Village plates (Willows / Oak Hill classroom / cafe / dorm / etc. now on disk) |
| Facts (winner, boot, messy six) | `fact_ledger.json` |
| Blend grammar | `daily/daily-2D-3D-blend.md` (dive in / fracture out; silent clips; 1–3/day) |
| Drop-in path | `build_day_remotion_props.py` → `moment_clips/<sim>/<day>/beat_<id>.mp4` |

**Generalized recipe (every future daily)**

1. From featured + ledger, pick ≤3 arc beats that change power (challenge outcome, betrayal/hunt, vote/farewell).  
2. For each: **place plate** + **Double photo(s)** + **one plain action sentence** from the VO.  
3. Generate 1–2s 9:16 clip → save as `beat_<scene_id>.mp4`.  
4. Re-run Remotion props/render only (do **not** regenerate locked VO).  
5. Verify: clip plays on the right beat, continuity vs portrait, no audio fight with VO.

**#2 plates are on disk** — confirm Willows + Oak Hill classroom paths, then generate clips A–C and do the first Remotion watch pass.

---

### Tomorrow order of work (suggested)

1. [x] Generate **Willows pharmacy interior** (+ optional exterior still open).  
2. [x] Generate **Oak Hill classroom** (+ optional exterior still open).  
3. [x] Village interior baseline fill (pub, supply, houses, artist studios) + **Johnson Park outdoor**.  
4. [ ] (Optional) Fill `location` on scenes 3–8 in script / props path.  
5. [ ] First Remotion render **without** moment clips (portraits + existing plates only) — baseline watch.  
6. [ ] Generate moment clips A–C → drop in → re-render → compare.  
7. [ ] Only after picture + Anya VO OK: `lock_day_script`.

---

# Daily Trailers — primary work doc

**Updated:** 2026-07-18  
**This file is the primary checklist for finishing [C] Survival dailies.** Contracts stay in `sot-video.md`. Older working docs listed below can move to `video/DONE/` after you skim this once.

**Live package:** `generative_agents/data/20260713-1/overview_day2&001/`  
**VO working file:** `VO_LOCKED.md` — **V3.2 clarity draft** (not yet compress-locked / TTS-locked).  
**Do not** overwrite VO / re-TTS while Anya review is open. **Do not** `lock_day_script` until picture + VO are both accepted.

---

## Now — open checklist

### Gate A — VO (Anya)

- [x] Anya + founder review V0 (2026-07-16): **not approved** — clarity / drama / challenge teach / 15-vs-3 ensemble gaps.
- [x] V1 long-form + V2 clarity revise on package (see `VO_LOCKED.md`).
- [x] Screenwriter **V3** + founder **V3.1 mid-beat** + **V3.2 day-projection stamps** on `VO_LOCKED.md`.
- [x] Eng verify Ivan vote-defense: **NONE** — “keep votes off himself” stays cut.
- [x] DEV ACK compress budget @ 1.2× / ~2.2 wps (2026-07-16).
- [x] First **Short version of Ver.3** compress draft on `VO_LOCKED.md` (~263 words / ~118s est.).
- [ ] Founder → Anya **approve short VO meaning** (then measured TTS @ 1.2×).
- [ ] If measured &gt;120s: trim non-sacred only; re-TTS; then update `script.json` + Remotion.
- [ ] Anya approves compressed spoken VO. Keep Remotion off until text+audio final.

### Gate B — Picture (you — see audit at top)

Village interior plates + Johnson Park outdoor are on disk (inventory **0 TODO**). Remaining picture work:

1. [x] P0 plates: Willows pharmacy interior · Oak Hill classroom.
2. [x] P2 village fill: pub · supply · houses/apts/artist studios · Johnson Park outdoor.
3. [ ] Optional exteriors: Willows · Oak Hill College facade.
4. [ ] Baseline Remotion render (no moment clips) → phone watch.
5. [ ] Moment clips A–C (challenge / hunt / boot) → drop-in → re-render.
6. [ ] Verify props gaps: scenes 6–9 `hero_path` resolve; optional `location` labels.

### Gate C — Lock & prove continuity

- [ ] `lock_day_script` on approved Day 1 package (writes F1 featured history + F3 scar).
- [ ] Only then generate Day 2+ overview for this sim (coverage + scars stay honest).

### Gate D — Product quality (after a green MP4)

- [ ] Owner watch: same-show-as-opener feel; cold viewer can name leads, challenge outcome, who went home, tomorrow’s question.
- [ ] Optional D1: 5-viewer comprehension gate (4/5 pass).
- [ ] Merge daily-trailer branch work to `main` when picture path is product-accepted (ff-only protocol).

### Gate E — Automate daily trailer script gen (after this Day 1 VO is script-locked)

**When:** only after Gate A compress + Anya VO OK **and** Gate C `lock_day_script` on this package — treat V3.2 → compress as the **gold specimen**, not as a one-off rewrite forever.

**Goal:** every Survival day can produce a cold-viewer-safe `[C]` VO draft without repeating the V0→V3.2 human recovery loop.

**Encode lessons from V3.2 lock (do not regress):**

| Lesson | Automation requirement |
|--------|------------------------|
| Long → approve → compress | Optional long/clarity draft mode; ship cut respects L10; never optimize TTS before meaning approve (`vo-long-then-compress`) |
| Leave timing | Same-night elim after tally — never “by morning” (`sot_survival` VOTING) |
| Ensemble | State 15 Doubles / all play + vote; simple trio intro — **no** ranking dump in VO |
| Stamps (L11) | **job + place + day-projection want** (personality × today’s dynamics); vary sentence frames; omit want if thin; **no** durable `scratch.want` required; **no** clinical `innate`; **no** `_default_want_for_role` into fact-locked want |
| Challenge teach | Kid-plain number card hold/fold → Shield = safe **tonight only** before celebrating winner |
| Behavior vs invention | Cite ledger / `day_reasoning` / digest only; eng-verify pattern for soft claims (e.g. Ivan vote-defense = NONE → never invent lobby) |
| Mid beats | Keep cafe/social talk **separate** from vote-scatter; no fused “room never settles on one plan” unless evidenced |
| Cliff | Shield spent after tonight; trust vacuum — no multi-day immunity implication |
| Fact-lock | Messy boards stay messy; no invented blocs / second winners |

**Work items (eng + COS craft):**

- [ ] **E1 — Gold package:** freeze accepted compressed VO as regression gold (`VO_LOCKED.md` / `script.json` + short “why V3.2” notes) under `agents/screenwriter` / package archive.
- [ ] **E2 — Emit day-intro fields:** day-overview packages persist `day_intro_want` (or equivalent) + `source_refs` for featured Doubles; role defaults only as non-authoritative `want_fallback` (or delete); on-disk `stamp_facts.json` matches what VO may cite.
- [ ] **E3 — Narration Writer / showrunner policy:** replace caption-card / role-fallback stamp behavior with V3.2 spine + day-projection stamp rules; bake leave-timing + Shield-tonight-only + ensemble one-liners into prompts/validators.
- [ ] **E4 — Soft-claim gate:** pipeline flags unsupported VO claims (vote-defense, alliances, clean blocs) against ledger/digest; omit or `needs-review` instead of inventing.
- [ ] **E5 — Compress assist (optional):** after meaning approve, suggest L10 cut list from “runtime debt” sacred vs cuttable tags (human still owns final cut for first N days).
- [ ] **E6 — CTO brief:** open `@cto` on `generative_agents` when Gate C green — scope E2–E4 first; E5 later.

**Out of scope for Gate E:** Remotion picture automation (Gate B / B4); `[B] day_normal`; durable soul `scratch.want` schema (not required for day-projection stamps).

### Fast-follow (do not block Gate B)

- [ ] **B4** — automate Grok Imagine moment clips (`generate_moment_clips.py`); manual drop-in is enough for first ship.
- [ ] Intra-card motion / more clips if editorial-motion stays ~3/min (gate is soft; north-star is 6–8/min for dailies).
- [ ] **[B] `day_normal`** stub — out of scope until [C] picture loop works once end-to-end.

---

## Product bar (keep in mind)

| Rule | Target |
|------|--------|
| Format | 9:16 Remotion, same show as opener |
| Runtime [C] | ~100–115s typical; hard cap **under 120s** |
| VO craft | Job+place+**day-projection want** stamps once (varied frames) → first names; kid-plain challenge teach; messy boards stay messy; same-night elim; Shield tonight-only cliff + `doubland.ai` + optional itch |
| Picture | Portraits for stamps; **1–3** silent cinematic clips on arc beats only |
| Continuity | Lock Day N before generating Day N+1 |
| Bad substrate | Never polish creatively on `20260705-or-smoke` |

**VO spine (encoded as `narration_v12`):**  
concept → survival_frame → stamp×N → challenge_teach → mid_turn → cost → cliff → cta_sim → itch?

**2D↔3D blend (summary):** establishing = 2D cards; clips only on pressure / turn / vote-class beats; camera dive in / pixel fracture out; silent clips; ≤3/day. Detail: `daily/daily-2D-3D-blend.md`.

---

## Remotion process (one pass)

1. Frozen VO + `script.json` scenes = edit list.  
2. Stage existing cast/group assets (+ new village plates from audit §2).  
3. Optional: 1–3 moment clips → `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4`.  
4. Build Remotion props → render MP4 → validators → watch.  
5. Do **not** regenerate Writer VO during picture-only iterations.

---

## Commands (cheat sheet)

```bash
# VO/script only (reuse day_log; avoid --force on locked package)
python -m video.generate_trailer 20260713-1 --mode day_overview --day 2 \
  --output-dir data/20260713-1/overview_day2&001 --skip-render

# After Anya OK — picture render (no --force if script/audio already locked)
# use generate_trailer without --skip-render (or project Remotion entrypoint)

# After picture + VO accepted
python -m video.lock_day_script data/20260713-1/overview_day2&001
```

---

## Living references (do not archive)

| Doc | Role |
|-----|------|
| `video/sot-video.md` | Trailer taxonomy + laws (L8–L13, [C] duration) |
| `video/TODO_video.md` | **This file** — primary daily work |
| Package `VO_LOCKED.md` / `script.json` / `fact_ledger.json` | Locked episode facts + edit spine |
| `generative_agents/video/assets/...` | Heroes, village plates, moment_clips |

## Older working docs (still under `video/` — 2026-07-16)

Canonical living paths (do **not** use a `done/video/` prefix — that folder was never created):

| Doc | Path |
|-----|------|
| 2D↔3D blend grammar | `daily/daily-2D-3D-blend.md` |
| Asset prompt catalog | `prompts.md` |
| 2026-07-10 inquiries (historical) | `daily/20260710_inquiry_*.md` |
| Day-1 VO rewrite brief | package `VO_LOCKED.md` (V0 + expert V1 notes) — supersedes missing `20260715_script*.md` stubs |

---

## DONE (compact — historical)

### Opener & shared stack
- Remotion 9:16 opener pipeline; shared `OpenerTrailer` composition; end-card `questionToUrlTakeover`.
- Cohort assets + Supabase `trailer_asset` read at render; baseline hero fallback for forks.
- Voice: `eleven_v3` warm (daily locked package @ **1.2×**; Doubland TTS fused spelling).

### Daily story engine
- Cast digest + fact ledger + narration fact gate; slim `day_log`.
- Spicy ranking + coverage slot (L12); F1 intro memory + `lock_day_script` (L11); F3 scar cards (L13).
- Challenge card in ledger + teach-vs-short; soft signals; thin-tally `safe_vo`.
- Narration Writer continuous blocks + want stamps (`day_overview_narration_v12`, `video/vo_craft.py`).
- Word-count advisory; duration backstop; workplace stamps over dorm.

### Daily Remotion plumbing
- Day props builder; beat→opener component map; SFX roles; music duck path.
- B1 moment-clip drop-in; B2 location parse/label; B3 baseline photos; B5 blend grammar doc.
- Validators: format, LUFS, narration-fit, asset-presence, editorial-motion (soft).
- Early Day-2/Day-3 renders gate-green on older packages (creative bar still owner-watch).

### Creative locks (this arc)
- Rejected caption-card auto VO on `20260713-1`; human Fact-Locked Five-Beat VO locked in package.
- Chat-probe gold VO shape (Vincent/Max/Olivia) kept as historical craft reference only — **do not** `lock_day_script` that package to seed live history.
- `20260705-or-smoke` = engineering fixture only.

### Explicitly not done (see open checklist)
- Anya VO sign-off on **V3.2** · compress · optional Willows/Oak Hill **exteriors** · moment clips · Remotion watch · `lock_day_script` · D1 comprehension · **Gate E script automation** · B4 clip automation · [B] day_normal.
- Village **interior** plate fill + Johnson Park outdoor: **DONE 2026-07-18** (inventory 57 DONE / 0 TODO).
