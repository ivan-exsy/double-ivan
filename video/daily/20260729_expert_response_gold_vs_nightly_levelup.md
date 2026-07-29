# Expert response — Gold Day-1 vs Nightly auto Remotion (level-up)

**Date:** 2026-07-29  
**Audience:** eng (`build_nightly_remotion_props` / `nightly_hud` / `nightly_vo_timing` / `nightly_craft`)  
**Bar watched:**
- Gold: `generative_agents/video/remotion/out/gold_replay_day1.mp4` (~91.9s render · props `totalSec` 89.3)
- Nightly energy-pass ref (do not overwrite): `data/20260713-1/trailer_ready_day2/output/trailer_9x16_20260729_184421_energy_pass_ref.mp4` (~92.8s · props `totalSec` 90.2)
- Locked VO: `vo_locked.txt` + `audio/narration_timing.json` (14 segments, 87.62s) — **same take family as gold**

**Method:** phone-style back-to-back watch + scene frames + full props forensics (layers/texts/sfx/fx).  
**Success bar:** after Must list ships, phone-watch should feel like the *same show* as gold — not pixel-identical.

---

## 0. Executive call

| Question | Answer |
|----------|--------|
| Why does nightly feel flatter? | **Edit grammar**, not SFX count. Gold changes the *picture stack* ~every 1.5–3s and lands type on VO stress. Nightly holds one hero plate for 8–17s and only sprinkles captions/SFX on top. |
| Is SFX the fix? | **No.** Both props emit **23** SFX. Matching whooshes did not close the gap. |
| Keep locked V6? | **Yes — keep locked V6. Picture-only fix.** No re-TTS. Optional: start VO ~0.9s after poster (gold does this) by *offsetting* the existing mp3, not re-rendering. |
| CapCut CSVs as product input? | **No.** Recipes below are role/bin recipes eng can emit from picker + ledger + clip_kit + teach pack + VO timing. |

### Quant snapshot (props — not taste)

| Metric | Gold | Nightly energy-pass | Read |
|--------|-----:|--------------------:|------|
| Layers | **50** | **29** | ~40% fewer picture events |
| Texts (CC) | **43** (~29/min) | **22** (~15/min) | half the kinetic type density |
| SFX | 23 | 23 | parity — **not the gap** |
| FX | 9 | 14 | nightly already has enough FX |
| Median layer duration | **2.5s** | **7.9s** | primary flatness driver |
| Secs with 0 layer/text starts | 27/89 | **51/90** | nightly is “quiet” more than half the film |
| Frame near-dup drop (watch skill) | 4 | **26** | objective static signal |
| Base picture starts (non-badge) | ~41 | ~21 | half the cut grammar |
| Long hero holds ≥8s | rare (bg underlays only) | **many** (15s Phaser, 17s challenge bodies, 13s ballots, 13s census…) | monoplates |

---

## 1. Second-by-second comparison (wall-clock ≈ VO)

**Clock notes**
- Gold Remotion: poster ~0–2.5s; VO audio starts ~**0.9s** (CapCut-style offset); second VO slice after small breath.
- Nightly: poster ~0–2.5s; VO starts **0.0** under poster; timeline below uses **narration_timing.json** seconds as the shared VO spine. Picture times are *approximate* wall-clock on each MP4 (±0.5–1s OK for craft).

**Delta tags:** `missing cut` · `held too long` · `wrong plate` · `HUD late/early` · `type missing` · `stack missing` · `VO lock miss` · `overlap mud` · `OK / close`

| t (s) | VO (locked V6) | Gold picture | Nightly picture | Delta |
|------:|----------------|--------------|-----------------|-------|
| 0–1 | *(poster / pre-VO)* | Matrix poster + Ivan face flash + DOUBLAND badge + scan SFX | Same poster grammar (L-TALKS / SURVIVAL) but **EPISODE 2** label on a Day-1 prove | `wrong plate` (episode) |
| 1–3 | “These are Doubles…” | Group photo → kinetic **THESE ARE / AI VERSIONS** | Still matrix/world; caption **THESE ARE DOUBLES** only | `missing cut` · `type missing` |
| 3–6 | “…AI versions of real people…” | **AI split matrix** (neon seam) + **REAL PEOPLE** word | Jumps toward Phaser/world early; thin type | `wrong plate` · `missing cut` |
| 5.5–9 | “…making choices no one wrote…” | **Phaser flyover** + LIVE SIMULATION top + **15 ACTIVE** + kinetic fragments | Phaser + LIVE + 15 ACTIVE — **closest parity moment** | `OK / close` (then diverges) |
| 7.8–12 | “Fifteen of them entered Survival…” | Phaser continues; Survival stamp; **FIFTEEN…** type; HUD energy | Phaser hold continues; **FIFTEEN ENTERED** once | `held too long` · `type missing` |
| 12–15 | “…voted out every night until one remains.” | **14 ACTIVE census graphic** + ring + dots + **UNTIL / ONE REMAINS** | Still mostly Phaser/world; sparse “VOTED OUT…” | `missing cut` · `VO lock miss` |
| 15–19 | “Today we’re following Irene Dove and Ivan Pitts.” | Clean **Irene namecard** then **Ivan namecard** (scan FX) + FOLLOWING type | Peak habitat + want overlay + stamp — **stake dump starts early**; namecards not cleanly sequenced | `overlap mud` · `HUD early` |
| 19–22 | “Irene goes hard for cover…” | **Irene habitat** (Hobbs barista) + line type | Habitat/namecard stack; type weaker | `held too long` · `type missing` |
| 22–28 | “Ivan watches… before he bets… weak card.” | Ivan habitat/objective beat → **READ THE ROOM want HUD** (intention, not only workplace) | **Namecard double-exposure** (Irene ghost over Ivan / overlapping cards) + long habitat holds | `overlap mud` · `wrong plate` · `stack missing` (want HUD underpowered) |
| 28–33 | “At 11am, a daily challenge begins…” | C1 village overhead + **A DAILY CHALLENGE BEGINS** + title card hit (zoom/shake) | Hard cut to table bodies + title; less world-bed punctuation | `missing cut` (world bed) |
| 33–46 | Hold/fold/shield teach (long line) | **Bodies under progressive STEP 1→2→3→4 stack** + dense VO fragments every ~1–2s + late **challenge clip insert** | **Same table plate ~17s** with STEP bands; fewer phrase locks; teach feels like one slide deck | `held too long` · `type missing` · `missing cut` (late insert timing) |
| 45–51 | “Irene got the highest card… safe tonight.” | Multi-cut peak: clip → reveal hf → **Irene portrait + IMMUNITY ACTIVE** | Immunity banner **on same table**; then long **peak_hold** still on challenge world | `held too long` · `missing cut` (portrait peak) |
| 50–58 | “Conversations turn into alliances… into votes.” | **Talk.mp4 under title** → **ALLIANCES → VOTES** abstract card (two-beat) | Alliances chat/votes exist but sit **late/compressed** against peak_hold; less clean two-beat | `HUD late/early` · `held too long` (peak under alliances) |
| 57–63 | “Every Double casts a ballot.” / “Tonight six votes…” | Ballots bowl **with kinetic SIX / IVAN…** | Ballots plate OK visually but **held ~13s** with thin type; VO stress under-punctuated | `held too long` · `type missing` |
| 63–69 | “…six votes land on Ivan… Irene’s ballot… Ivan is gone.” | Ballots → vote graphic → **Phaser Irene inside / Ivan outside** + line lock | Still ballots/leave path; **missing Phaser betrayal bridge** at VO stress | `missing cut` · `VO lock miss` |
| 68–74 | “Ivan is gone.” / “Fifteen become fourteen.” | Leave hf → **group matrix with seat grey (Ivan out)** + type | Leave still OK → grey matrix appears but **too early relative to cliff** and then **overstays** | `held too long` |
| 72–80 | “Tomorrow, the Shield is gone. New alliances… New targets…” | **Shield-gone / NEW TARGETS radar** + Talk/cinematic inserts + kinetic lines | **Grey group photo continues** through cliff VO — forward threat never lands | `wrong plate` · `missing cut` · `VO lock miss` |
| 80–86 | “And another Double will leave…” / door VO | Census grid (named tiles, Ivan disconnected) → night village → **Phaser door** | Census/grey still holding; door flyover late | `held too long` · `missing cut` |
| 86–90 | “Watch every conversation… doubland.ai.” | Phaser → **L-TALKS / DOUBLAND.AI / WATCH LIVE** lockup + swoosh | Lockup **OK** (brand punch works) | `OK / close` (end only) |

### VO segment spine (for eng locks)

| Seg | start–end | Scar bin (target) | Gold lock behavior | Nightly failure mode |
|----:|-----------|-------------------|--------------------|----------------------|
| 0 | 0.0–7.68 | hook | matrix → AI split → Phaser+LIVE | Phaser mono + thin type |
| 1 | 7.78–15.06 | hook→stake | Phaser + census “until one” | Phaser hold |
| 2 | 15.16–18.92 | stake | namecards A then B | habitat dump / mud |
| 3 | 19.02–22.22 | stake (Peak want) | habitat Irene | habitat OK-ish, type thin |
| 4 | 22.32–28.16 | stake (Cost want) | intention HUD | namecard overlap mud |
| 5 | 28.26–45.38 | pressure | stepped teach + insert | one body plate |
| 6 | 45.48–50.68 | peak | portrait + immunity | table + long hold |
| 7 | 50.78–57.58 | peak→social | Talk → votes card | compressed / under peak |
| 8–9 | 57.68–68.98 | cliff_door (elim) | ballots → Phaser bridge → gone | ballots long → leave |
| 10 | 69.08–72.2 | cliff | fifteen→fourteen grey | grey OK then overstay |
| 11–12 | 72.3–82.16 | cliff | NEW TARGETS + census energy | **still grey matrix** |
| 13 | 82.26–87.62 | lockup | Phaser door → brand | brand OK |

---

## 2. Root-cause clusters

Not a laundry list — five clusters that explain the phone-watch gap.

### C1 — Monoplate holds (primary)

Nightly assigns **one hero `cover` layer per long VO window** (challenge bodies 17s, ballots 13s, census 13s, early Phaser 15s).  
Gold keeps a quiet underlay but **swaps the hero stack every ~2–3s** (legend_hf / kit / Phaser / HUD).

**Feel:** “slideshow with VO” vs “edited show.”

### C2 — Kinetic type is half-density and not syllable-locked

Gold: **43** CapCut fragments, often 1–2 words, firing on VO stress (“REAL PEOPLE”, “UNTIL”, “IVAN IS GONE”).  
Nightly: **22** key-phrases, longer holds, gaps of 3–5s with no type.  
Also: nightly props show **caption reuse bugs** (e.g. “VOTES LAND” / “IS GONE” reappearing in the cliff window ~72–77s) — undermines trust even when picture is fine.

**Feel:** ears lead; eyes idle.

### C3 — Missing mid-beat inserts & world mix

Gold’s rhythm is a **three-world mix**:
1. cinematic / legend stills  
2. Phaser (product UI)  
3. full-frame HUD cards  

Nightly often stays in **one world** for a whole scar bin. Especially missing:
- AI-split / concept literacy inserts in hook  
- “until one remains” census graphic  
- challenge **late motion insert** as a *cut*, not only STEP chrome  
- Peak **portrait** cut  
- Cost **Phaser inside/outside** bridge on “Irene’s ballot / Ivan is gone”  
- Cliff **NEW TARGETS** forward-threat card  

### C4 — Stack collisions instead of sequenced beats (stake)

Nightly stake dumps **habitat + want + both namecards** with overlapping windows → double-exposure / mud (visible ~t23).  
Gold **sequences**: namecard Irene → namecard Ivan → Irene habitat → Ivan intention HUD.

**Feel:** busy but not rhythmic; faces fight the VO.

### C5 — Cliff energy spent too early; end overstays census

Grey “Ivan out” matrix is correct **once** at “fifteen become fourteen.”  
Nightly then **parks on that plate through “new targets / leave the game”**, so the forward-threat act never happens. Gold spends cliff on radar + named census + door Phaser, then lockup.

SFX/FX cluster is **not causal** (counts already match or exceed gold).

---

## 3. Level-up instructions for auto-gen

### MUST (blocks “same show” claim)

Implement these before claiming gold parity. Each has an acceptance check eng can automate.

| # | Instruction | Acceptance check |
|---|-------------|------------------|
| M1 | **Max hero-plate hold ≤ 3.0s** without a picture event (new full-bleed layer **or** full-frame HUD **or** kinetic type burst). Soft warn 2.5s; hard fail 3.5s on long mode. | Validator: scan emitted layers+texts; no gap >3.0s without start event in t∈[postBoot, lockup). |
| M2 | **Raise kinetic type to ≥ 0.40 events/s** (~36+ over 90s) using VO fragment grammar (1–5 words), not only 22 key-phrases. Prefer word-groups from `narration_timing` + simple stress lexicon (names, numbers, challenge title, elim, brand). | `len(texts)/totalSec ≥ 0.40`; no caption text reused outside its VO segment ±0.5s. |
| M3 | **Hook recipe (seg 0–1):** after poster — group/matrix (≤2s) → concept insert (AI split **or** cast matrix punch) → Phaser+LIVE+N ACTIVE (≤3.5s) → **census/until-one graphic** on “voted out / until one remains.” Do **not** hold Phaser for the full 0–15s. | Roles present: `cast_matrix|group`, `concept_literacy`, `signature_flyover`+badges, `hook_census`; each ≤ max hold. |
| M4 | **Stake sequencing (seg 2–4):** strict order, no overlap mud: (1) Peak namecard (2) Cost namecard (3) Peak habitat (4) Peak want HUD (5) Cost intention HUD (“READ THE ROOM” class — objective, not second workplace if Cost is strategist). Each 1.5–2.8s. | No two namecards full-bleed overlapping >0.25s; want HUDs on `hud_stack`. |
| M5 | **Pressure teach (seg 5):** bodies bed OK, but **STEP bands progressive** (1→2→3→4) *and* **≥1 mid/late motion insert** (teach clip or card-reveal still) *and* type locks on hold/fold/shield/immunity words. Title card gets hit FX (black_hit/radial_zoom/shake) at challenge name land. | `challenge_title`, ≥3 step bands with staggered starts, `challenge_insert` or equivalent cut, type hits on lexicon. |
| M6 | **Peak (seg 6):** do **not** leave immunity on the teach table. Cut to **Peak portrait + IMMUNITY ACTIVE** (or card-evidence closeup) within 1.0s of “wins the Shield / safe tonight.” | `peak_portrait` or `immunity_hud` full-frame in [seg6.start, seg6.end]; table bodies not sole hero after shield land. |
| M7 | **Alliances two-beat (seg 7):** Beat A `Talk`/`alliances_chat` under title **CONVERSATIONS → ALLIANCES**; Beat B `alliances_votes_card` **ALLIANCES → VOTES**. Total ~4–6s. Must start at seg7 VO, not under peak_hold. | Two roles, sequential, non-overlapping >0.3s; window ⊂ seg7±0.5s. |
| M8 | **Elim bridge (seg 8–9):** ballots (≤3.5s) → vote tally/type on “six votes” → **Phaser Cost-out / Peak-in bridge** on “Irene’s ballot / Ivan is gone” → leave plate (≤3s). | Role `cost_phaser_bridge` (or `ivan_leave_phaser`) present; ballots duration ≤3.5s. |
| M9 | **Cliff forward threat (seg 11–12):** after one census grey hit for “fifteen→fourteen,” **must leave grey matrix**. Emit `cliff_new_targets` (radar/threat HUD) and/or named census energy — **not** the same grey group photo through door VO. | Grey matrix end ≤ seg10.end+1.5s; ≥1 cliff role before door. |
| M10 | **Door → lockup (seg 13):** Phaser door tease (≤2s) → brand lockup on final URL line + swoosh. Lockup already OK — keep. | `signature_flyover_door` then `end_lockup`; lockup starts near VO “doubland.ai” / end of seg13. |
| M11 | **Fix episode label** for Day-1 prove (`EPISODE 1` / ledger day), not hard-coded Episode 2. | Poster episode matches package day index. |
| M12 | **Kill caption reuse / mis-time** (duplicate “VOTES LAND” / “IS GONE” in cliff). Captions must map 1:1 to a VO substring inside their segment. | Unit test on emitted texts vs segment windows. |

### SHOULD (next pass after Must)

| # | Instruction |
|---|-------------|
| S1 | Adopt gold’s **~0.9s VO start after poster** (offset existing mp3 `sourceStartSec=0` at `startSec=0.9`) so mute hook can breathe — still no re-TTS. |
| S2 | Music duck envelope: duck on **picture cuts + type lands**, not only VO segment edges (nightly envelope is segment-gated and feels mechanical). |
| S3 | Want Peak = habitat-true; Want Cost = **intention HUD** by default when Cost role is social/strategic (gold pattern). |
| S4 | Mid-social: keep abstract alliances (good) — add optional soft Talk loop under title only if kit has it (already partially there). |
| S5 | Challenge insert prefers bank teach clip **late** (last 1.5–2s of pressure), matching gold’s “layers first, staged clip last.” |
| S6 | End VO visuals: 2–3 short full-bleed inserts under cliff lines (Talk / night village / radar) before door — gold’s 74–83 pattern. |
| S7 | Raise non-badge layer count toward **≥40** on long Day-1 as a health metric (not a hard art requirement). |

### CapCut-only / do **not** automate yet

| Item | Why defer |
|------|-----------|
| Mass CapCut `H_*` legend wall (32 files) every night | Taste-gated; anti-leak; commission cost |
| Pixel-identical AI-split / neon seam composites | One-off gold art; replace with **reusable concept_literacy role** (matrix punch or simple split shader) |
| CapCut CSV timelines as product input | Forbidden by SOT §11.4 |
| Exact CapCut volume automation / multi-VO slice at 1.01× | Editorial micro-mix; optional later |
| Custom every-night orange radar illustration variants | One reusable `cliff_new_targets` template is enough |
| Full word-by-word CapCut 43-line clone of this VO | Aim for density + stress locks, not this transcript’s exact breaks |
| Featured job+place spoken intros | Parked by brief |

---

## 4. Per-Scar-bin picture recipe (no CapCut CSVs)

Emit from: `tonight_scar_picker` + `fact_ledger` + `clip_kit/bins` + challenge teach pack + `narration_timing` + neutral want plates.

### Global rules (all bins)

1. **Hero cut ≤ 2.5s median; hard max 3.0s** without type or overlay event.  
2. **Always one of:** new plate · HUD stack change · kinetic type — every ~2s.  
3. **Type:** short fragments on names, numbers, challenge title, elim, brand.  
4. **SFX:** keep ~gold count; fire on *cuts*, not as a substitute for cuts.  
5. **Anti-leak:** no Day-N+1 persona art; stage wants as neutral filenames.

---

### A — `hook` (VO seg 0–1 · ~0–15s)

| Beat | Dur | Picture | Type / HUD | Notes |
|------|----:|---------|------------|-------|
| A0 Poster | 2.0–2.5 | Cast matrix + L-TALKS / SURVIVAL / EPISODE N | — | Mute OK |
| A1 Cast | 1.5–2.0 | Group photo or matrix punch | THESE ARE / DOUBLES | |
| A2 Concept | 1.5–2.5 | Concept literacy (AI split **or** matrix neon) | AI VERSIONS / REAL PEOPLE | Replaces gold legend_hf |
| A3 Phaser plant | 3.0–3.5 | `signature_flyover` | LIVE SIMULATION + N ACTIVE; MAKING CHOICES… | Product UI framing |
| A4 Threat literacy | 2.0–3.0 | Hook census / “until one” graphic | VOTED OUT / EVERY NIGHT / UNTIL ONE REMAINS | **Must** — nightly skips this |

**Bin sources:** `A_hook/*`, group matrix, Phaser pack, drawn census template.

---

### B — `stake` (VO seg 2–4 · ~15–28s)

| Beat | Dur | Picture | Type / HUD |
|------|----:|---------|------------|
| B1 | 1.8–2.2 | Peak namecard | TODAY WE’RE FOLLOWING / name |
| B2 | 1.8–2.2 | Cost namecard | name |
| B3 | 2.0–2.5 | Peak habitat | GOES HARD FOR COVER |
| B4 | 1.5–2.0 | Peak want HUD (`hud_stack`) | optional WANT label |
| B5 | 2.0–2.8 | Cost intention HUD (not second workplace if strategic) | BEFORE HE BETS / READ THE ROOM class |

**Forbidden:** overlapping full-bleed namecards; habitat-only for both when Cost is intention.

**Bin sources:** `B_stake` namecards/habitats; want plates `want_peak_hud` / `want_cost_hud`.

---

### C — `pressure` (VO seg 5 · ~28–45s)

| Beat | Dur | Picture | Type / HUD |
|------|----:|---------|------------|
| C0 | 1.5–2.5 | World bed (C1 village / overhead) | AT 11AM / DAILY CHALLENGE BEGINS |
| C1 | 1.8–2.2 | Challenge title card + hit FX | HOLD FOR THE SHIELD |
| C2 | 8–12 | Bodies bed + **progressive** STEP 1–4 bands | SECRET CARD / HOLD / FOLD / HIGHEST / SHIELD / IMMUNITY |
| C3 | 1.5–2.0 | **Late insert** teach clip or card reveal | final immunity phrase |

**Rule:** STEP bands stagger starts (gold: 37 / 39 / 40 / 43 pattern — ratios OK). Do not show all four from t0 of pressure.

**Bin sources:** teach pack `hold_for_shield` + `C_pressure` bodies + C1 plate.

---

### D — `peak` (VO seg 6 · ~45–51s)

| Beat | Dur | Picture | Type / HUD |
|------|----:|---------|------------|
| D1 | 1.5–2.0 | Evidence (card / table crop) | HIGHEST CARD / WINS |
| D2 | 2.0–3.0 | **Peak portrait** + IMMUNITY ACTIVE | SAFE TONIGHT |

**Forbidden:** leaving teach-table as sole hero for entire peak.

**Bin sources:** `D_peak` / immunity HUD template / Peak still from kit.

---

### E — social bridge inside peak→cliff (VO seg 7 · ~51–58s)

Treat as sub-bin **even if scar merge folds it into peak/cliff**:

| Beat | Dur | Picture | Type |
|------|----:|---------|------|
| E1 | 2.0–2.5 | Talk / chat panel under title | CONVERSATIONS TURN INTO ALLIANCES |
| E2 | 2.0–2.5 | Alliances → votes abstract card | ALLIANCES TURN INTO VOTES |

**Bin sources:** Talk stock + `alliances_votes_step` art (already in nightly craft).

---

### F — `cliff_door` (VO seg 8–12 · ~58–82s)

| Beat | Dur | Picture | Type / HUD |
|------|----:|---------|------------|
| F1 | ≤3.5 | Ballots bowl | EVERY DOUBLE CASTS / SIX VOTES |
| F2 | 2.0–2.5 | Tally / name lock | IVAN… / SIX |
| F3 | 2.0–2.8 | **Phaser bridge** Peak inside / Cost outside | IRENE’S BALLOT / IVAN IS GONE |
| F4 | ≤3.0 | Cost leave (dignified) | IVAN IS GONE |
| F5 | 2.0–2.5 | Grey matrix **once** | FIFTEEN BECOME FOURTEEN |
| F6 | 2.5–3.5 | **NEW TARGETS** radar / threat HUD | SHIELD IS GONE / NEW TARGETS |
| F7 | 2.0–3.0 | Named census / forward energy | ANOTHER DOUBLE WILL LEAVE |

**Forbidden:** grey matrix as the bed for F6–F7.

**Bin sources:** ballots, leave, Phaser leave still, census grey seat map, reusable cliff HUD.

---

### G — `lockup` (VO seg 13 · ~82–90s)

| Beat | Dur | Picture | Type |
|------|----:|---------|------|
| G1 | ≤2.0 | Phaser door flyover | WATCH / CHALLENGE / VOTE fragments |
| G2 | 2.5–3.0 | Brand lockup 9:16 | — (logo carries) + swoosh SFX |

**Already near-parity** on nightly — preserve.

---

## 5. VO recommendation

### **Keep locked V6. Fix picture timing only.**

Reasons:
1. Gold and nightly already share the same locked take family; gold’s “energy” is **edit density**, not a different performance.  
2. Founder symptom matches props math (holds, type rate, missing inserts) — not VO wording or length.  
3. Re-TTS would burn the VO-lock contract and still fail if monoplates remain.  
4. Optional non-TTS alignment only: **poster hold then start VO at ~0.9s** (gold), using the existing mp3 offset — still the same file.

**Do not** rewrite lines, change Peak/Cost/challenge/elim facts, or unlock timing JSON for “pacing” until Must M1–M12 are green on a phone-watch.

---

## 6. Eng implementation map (where to work)

| Cluster | Primary touchpoints |
|---------|---------------------|
| Scar windows + caption fragments | `video/nightly_vo_timing.py` |
| HUD / want / anti-leak / LIVE | `video/nightly_hud.py` |
| Layer emit, holds, inserts, episode label | `video/build_nightly_remotion_props.py` |
| Shared max-hold, teach pack, SFX floors | `video/nightly_craft.py` |
| Gates for M1–M2 density | `video/validate_nightly_survival.py` |
| Gold reference only | `video/build_gold_replay_props.py` → `apply_phase1_hud_grammar` |
| Gap log update after ship | `video/NIGHTLY_CRAFT_GAP.md` |

**Suggested ship order:** M11+M12 (cheap correctness) → M1+M2 (cadence engine) → M3–M4 (hook/stake) → M5–M7 (pressure/peak/alliances) → M8–M10 (elim/cliff/door) → phone-watch vs gold + energy-pass ref.

---

## 7. What “same show” means (acceptance for founder)

After Must:

- Rarely more than **~2.5–3s** without a visible change on a phone.  
- Hook teaches **people → AI → live sim → elimination stakes** before names.  
- Stake is **two clean faces**, then wants — no double-exposure mud.  
- Challenge is a **stepped lesson**, not one table still.  
- Peak is a **portrait/immunity punch**.  
- Elim has a **Phaser betrayal bridge**.  
- Cliff is **forward threat**, not a parked grey photo.  
- End lockup still hits.  
- SFX count may stay ~23 — **do not** “fix” by adding whooshes.

Pixel match to CapCut/gold: **not required.**

---

## 8. Evidence appendix (forensic)

| Signal | Gold | Nightly energy-pass |
|--------|------|---------------------|
| Props path | `video/remotion/props/gold_replay_day1.json` | `…/nightly_20260713-1_day2_long.json` |
| Watch near-dups dropped | 4 | 26 |
| Median layer dur | 2.5s | 7.9s |
| Texts/min | ~29 | ~15 |
| Notable nightly holds | — | Phaser ~15s; challenge bodies ~17s; peak_hold ~12s; ballots ~13s; census/grey ~13s |
| End lockup | brand OK | brand OK |
| Poster episode | EPISODE 1 | EPISODE 2 (bug on Day-1 package) |

Frame grabs used under:
- `generative_agents/tmp_watch_gold/frames/`
- `generative_agents/tmp_watch_nightly/frames/`

---

## 9. Checklist (brief §10)

- [x] Watched gold + energy-pass ref (frames + props forensics; phone-equivalent cadence read)
- [x] Second-by-second comparison table
- [x] Root-cause clusters named (C1–C5)
- [x] Must / Should / CapCut-only instructions
- [x] Per-Scar-bin picture recipe
- [x] VO keep-vs-revise: **keep locked V6**

---

*End of expert response. Eng: implement Must M1–M12, re-render long nightly, phone-watch against gold — leave energy-pass ref untouched as regression bar.*
