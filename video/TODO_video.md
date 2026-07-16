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
- ✅ **Library** (weak college proxy only) — `library_int_reading.png`, `library_int_stacks.png` · exterior `library_exterior_wide.png`
- ✅ Other interiors on disk (apts / houses / artist commons) — 39 interior files total; 6 exteriors

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

### 2. Generate next (Ivan — stills / environment plates)

These are **reusable village assets** (not one-off per trailer). Inventory already flags them as missing; this VO needs the first two badly.

| Priority | Asset to generate | Why this package needs it | Notes |
|:--------:|-------------------|---------------------------|--------|
| **P0** | **The Willows Market and Pharmacy — interior (store)** | Ivan’s stamp workplace; hunt/cost beats can live here | No `willows*` / pharmacy plate on disk today |
| **P0** | **Oak Hill College — classroom interior** | Vince’s stamp workplace | No classroom plate; library is only a weak stand-in |
| **P1** | **Oak Hill College exterior** (optional) | Stamp / establish Vince’s place from outside | Not on disk (library exterior ≠ college) |
| **P1** | **Willows exterior** (optional) | Stamp / establish Ivan’s place | Not on disk |
| **P2** | Other inventory TODOs (pub, supply store, remaining house mains, etc.) | Future days / other featured Doubles | See `village/interior/_room_inventory.md` — do **not** block this Day-1 picture pass |

**Acceptance for #2:** Named stills land under `video/assets/village/{interior,exterior}/` with clear filenames (e.g. `willows_pharmacy_int_store.png`, `oak_hill_college_int_classroom.png`) so clip prompts and location labels can point at them without guessing.

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
| Place still | Village plates (#1 ready + #2 new Willows / Oak Hill) |
| Facts (winner, boot, messy six) | `fact_ledger.json` |
| Blend grammar | `done/video/daily/daily-2D-3D-blend.md` (dive in / fracture out; silent clips; 1–3/day) |
| Drop-in path | `build_day_remotion_props.py` → `moment_clips/<sim>/<day>/beat_<id>.mp4` |

**Generalized recipe (every future daily)**

1. From featured + ledger, pick ≤3 arc beats that change power (challenge outcome, betrayal/hunt, vote/farewell).  
2. For each: **place plate** + **Double photo(s)** + **one plain action sentence** from the VO.  
3. Generate 1–2s 9:16 clip → save as `beat_<scene_id>.mp4`.  
4. Re-run Remotion props/render only (do **not** regenerate locked VO).  
5. Verify: clip plays on the right beat, continuity vs portrait, no audio fight with VO.

**When #2 is done:** re-check this section — confirm Willows + Oak Hill paths, then generate clips A–C and do the first Remotion watch pass.

---

### Tomorrow order of work (suggested)

1. [ ] Generate **Willows pharmacy interior** (+ optional exterior).  
2. [ ] Generate **Oak Hill classroom** (+ optional exterior).  
3. [ ] (Optional) Fill `location` on scenes 3–8 in script / props path.  
4. [ ] First Remotion render **without** moment clips (portraits + existing plates only) — baseline watch.  
5. [ ] Generate moment clips A–C → drop in → re-render → compare.  
6. [ ] Only after picture + Anya VO OK: `lock_day_script`.

---

# Daily Trailers — primary work doc

**Updated:** 2026-07-15  
**This file is the primary checklist for finishing [C] Survival dailies.** Contracts stay in `sot-video.md`. Older working docs listed below can move to `video/DONE/` after you skim this once.

**Live package:** `generative_agents/data/20260713-1/overview_day2&001/`  
**Locked VO:** `VO_LOCKED.md` (= `script.json` spoken text = `script_used.txt`) · TTS ~109.5s @ warm **1.2×**  
**Do not** overwrite VO / re-TTS while Anya review is open. **Do not** `lock_day_script` until picture + VO are both accepted.

---

## Now — open checklist

### Gate A — VO (Anya)

- [ ] Anya approves locked Survival Day 1 VO (package above).
- [ ] If she requests edits: update `VO_LOCKED.md` + `script.json` + re-TTS together; keep Remotion off until text is final again.

### Gate B — Picture (you — see audit at top)

Follow **Tomorrow order of work** in the audit section. Short form:

1. [ ] P0 plates: Willows pharmacy interior · Oak Hill classroom (+ optional exteriors).
2. [ ] Baseline Remotion render (no moment clips) → phone watch.
3. [ ] Moment clips A–C (challenge / hunt / boot) → drop-in → re-render.
4. [ ] Verify props gaps: scenes 6–9 `hero_path` resolve; optional `location` labels.

### Gate C — Lock & prove continuity

- [ ] `lock_day_script` on approved Day 1 package (writes F1 featured history + F3 scar).
- [ ] Only then generate Day 2+ overview for this sim (coverage + scars stay honest).

### Gate D — Product quality (after a green MP4)

- [ ] Owner watch: same-show-as-opener feel; cold viewer can name leads, challenge outcome, who went home, tomorrow’s question.
- [ ] Optional D1: 5-viewer comprehension gate (4/5 pass).
- [ ] Merge daily-trailer branch work to `main` when picture path is product-accepted (ff-only protocol).

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
| VO craft | Job+place+**want** stamps once → first names; challenge teach from ledger; messy boards stay messy; cliff + `doubland.ai` + optional itch |
| Picture | Portraits for stamps; **1–3** silent cinematic clips on arc beats only |
| Continuity | Lock Day N before generating Day N+1 |
| Bad substrate | Never polish creatively on `20260705-or-smoke` |

**VO spine (encoded as `narration_v12`):**  
concept → survival_frame → stamp×N → challenge_teach → mid_turn → cost → cliff → cta_sim → itch?

**2D↔3D blend (summary):** establishing = 2D cards; clips only on pressure / turn / vote-class beats; camera dive in / pixel fracture out; silent clips; ≤3/day. Detail: `done/video/daily/daily-2D-3D-blend.md`.

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

## Archived working docs → `done/video/` (2026-07-15)

Stubs remain at the old paths. Canonical copies:

| Archived | Path |
|----------|------|
| Daily implementation tracker | `done/video/daily/TODO_daily_trailer.md` |
| Chat-probe VO lock | `done/video/TODO_script_draft.md` |
| 2026-07-15 VO inquiry | `done/video/daily/20260715_script.md` |
| 2026-07-15 VO follow-up / framework | `done/video/daily/20260715_script_followup.md` |
| 2D↔3D blend grammar | `done/video/daily/daily-2D-3D-blend.md` |
| Asset prompt catalog | `done/video/prompts.md` |

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
- Anya VO sign-off · Willows/Oak Hill plates · moment clips · Remotion watch on locked package · `lock_day_script` · D1 comprehension · B4 clip automation · [B] day_normal.
