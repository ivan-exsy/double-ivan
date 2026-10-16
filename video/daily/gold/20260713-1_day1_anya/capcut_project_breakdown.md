# CapCut project breakdown — L-talks Day 1 (Anya)

**Role:** Deep north-star for **how the gold cut was built** (tracks, type, FX, media graph).  
**Hub:** [`GOLD.md`](GOLD.md) · machine extracts: [`capcut/`](capcut/)  
**Source draft:** `generative_agents/…/clip_kit/bins/capcut_proj/`  
**Matches master:** `double-video/data/anya/L-talks/Daily_1/final/L-talks Day 1.mp4` (previously `0720(1).mp4`) @ **88.233s**. First frame: `…/final/L-talks Day 1-Cover.jpg`

> Not SOT law. Taste questions (what auto-gen must copy) still live in [`craft_notes.md`](craft_notes.md). This file is **evidence**.

---

## 1. Project facts

| Field | Value |
|-------|--------|
| Draft name | **L-talks Day 1** |
| Draft id | `94B575EE-E577-41F8-8774-CEC7A4FAF2F4` |
| Duration | **88.233s** (`88233333` µs) |
| Canvas | **9:16 · 1080×1920 · 30 fps** |
| Export gold | 2160×3840 HEVC (upscale from project canvas) |
| Author machine | CapCut on macOS (`draft_fold_path` …`/Movies/CapCut/…/0720`) |
| Core files | `draft_info.json` (~1.0 MB timeline) · `draft_meta_info.json` · `Resources/local/` (72 hashed media copies) |
| Package size | ~215 MB · ~308 files (incl. matting masks) |

### Track layout (21 tracks · 133 segments)

| Type | Tracks | Segments |
|------|-------:|---------:|
| video | 10 | 54 |
| text | 1 | **43** |
| audio | 8 | 32 |
| effect | 2 | 4 |

**Read:** heavy **vertical stacking** (multiple video tracks over same time) + one dense kinetic-type track + multi-bus audio (VO / music / SFX).

---

## 2. Machine extracts (eng)

All under [`capcut/`](capcut/):

| File | Use |
|------|-----|
| `capcut_summary.json` | Counts, beat buckets, full text sequence, legend used/unused |
| `capcut_segments.csv` | Every segment (all track types) |
| `capcut_media_timeline.csv` | Video/photo placements with resolved filenames |
| `capcut_text_timeline.csv` | 43 kinetic lines + times |
| `capcut_audio_timeline.csv` | VO / music / stock SFX |
| `capcut_materials.csv` | Material library + hash-resolved origin |
| `capcut_media_map.csv` | Unique media → first use |
| `legend_usage.csv` | Each legend file used? + count |

**Resolution method:** CapCut stores imports as `Resources/local/<md5>.ext`. Extractor MD5-matched against staged bins + `F_Anya-legend` + kit audio (**62/86** AV materials resolved).

---

## 3. Media mix (what actually ships on the timeline)

AV segment source classes (video+audio placements):

| Class | Placements | Meaning |
|-------|----------:|---------|
| **capcut_stock** | 24 | Whooshes, trailer stingers, scan SFX |
| **legend_still** | 22 | Anya stills from `F_Anya-legend` |
| **legend_hf** | 18 | Higgsfield clips from legend |
| **staged_kit** | 10 | Our handoff bins (challenge, ballots, namecards, Talk/Village, faces…) |
| **staged_audio** | 8 | `v6_narration` + `music_drama` instances |
| **staged_phaser** | 4 | `signature_flyover` ×3 · `ivan_leave_phaser` ×1 |

### Legend usage

| | Count |
|--|------:|
| Legend files total | 47 |
| **Used in CapCut** | **32** |
| Unused (candidates to archive) | 15 |

**Unused (do not treat as gold-required):**  
`2571CF95-…`, thin JPGs, `94FF59B2…2/3`, `C126101E-…`, `cinematic_flyover_village_dusk_wind_down.MP4`, `D3AE994C-…`, `ECDC03D9-…`, `F5655AC9-…`, `group_photo 2.PNG`, `hf_20260707_234016_…`, `hf_20260722_025127_…`, `hf_20260722_030045_…`, `IMG_4873.jpg` — full list in `capcut/legend_usage.csv`.

### Staged kit assets confirmed on timeline

Examples resolved by hash/name:  
`ivan_face.png` · `group_photo.png` · `irene_namecard.png` · `ivan_namecard.png` · `challenge_hold_for_shield.mp4` · `ballots.mp4` · `Talk.mp4` · `Village.mp4` · `signature_flyover.mp4` · `ivan_leave_phaser.jpg` · `irene_face.png` · `v6_narration.mp3` · `music_drama.mp3`

**Mostly not the hero path** for Peak/Cost wants: Irene/Ivan **habitats** and several G-stills are overshadowed by **legend cinematic** stills/clips. Staged kit = spine anchors + Phaser + ballots/challenge insert + VO/music.

### Highest-reuse media

| Uses | Asset |
|-----:|-------|
| 9 | CapCut SFX **Digital Device Gadget Scanning Programming Sound2** |
| 6 | `music_drama.mp3` |
| 6 | CapCut SFX **Short Whoosh 4** |
| 4 | Legend still `C30B9252-…PNG` (challenge teach stack) |
| 4 | CapCut **Horror Trailer Opener** |
| 3 | `signature_flyover.mp4` |
| 3 | Legend HUD/UI still `Screenshot 2026-07-20…` (long **background** plate on track 0) |
| 3 | `hf_20260721_210518_…mp4` |

---

## 4. Kinetic type system (critical for auto-gen)

- **43 text segments** on a single text track.  
- **One subtitle template for all:** CapCut name `向上渐显 微发光` (“fade upward + soft glow”).  
- Copy is **fragmented locked VO**, mostly ALL CAPS, not full sentences on screen at once.  
- Type is the primary “HUD” — many full-frame graphic moments in the *export* are **composites** of still/clip + this type + stock FX, not separate designed PNG HUDs for every line.

### Full on-screen text sequence (from draft)

| t (s) | Text |
|------:|------|
| 0.90–1.90 | THESE ARE |
| 2.80–4.30 | AI VERSIONS OF |
| 4.30–5.40 | REAL PEOPLE |
| 5.40–6.90 | MAKING CHOICES |
| 6.90–7.60 | NO ONE WROTE FOR THEM |
| 7.60–9.03 | WROTE FOR THEM |
| 9.13–10.50 | FIFTEEN OF THEM ENTERED |
| 12.30–12.77 | SOMEONE IS VOTED OUT |
| 12.77–13.80 | IS VOTED OUT |
| 13.80–14.83 | EVERY NIGHT |
| 14.83–16.37 | UNTIL ONE REMAINS |
| 16.47–18.03 | TODAY WE'RE FOLLOWING |
| 20.30–22.10 | IRENE GOES HARD FOR COVER |
| 23.57–25.07 | IVAN WATCHES PEOPLE |
| 25.07–26.17 | BEFORE HE BETS |
| 29.43–30.63 | AT 11:00AM |
| 30.63–32.93 | A DAILY CHALLENGE BEGINS |
| 34.77–37.53 | EACH DOUBLE GETS A SECRET CARD |
| 37.67–39.43 | HOLD TO STAY IN THE FIGHT |
| 39.43–41.27 | OR FOLD AND SIT OUT |
| 41.63–43.00 | HIGHEST CARD REMAINING |
| 43.00–44.27 | WINS THE SHIELD |
| 44.47–44.77 | AND IMMUNITY |
| 44.77–46.47 | FROM TONIGHT'S VOTE |
| 46.47–48.53 | IRENE GOT THE HIGHEST CARD |
| 48.93–50.30 | SHE WINS THE SHIELD |
| 50.30–51.70 | AND IS SAFE TONIGHT |
| 51.70–53.30 | AS THE DAY CONTINUES |
| 58.57–59.77 | AT THE END OF THE DAY |
| 59.77–62.07 | EVERY DOUBLE CASTS A BALLOT |
| 62.23–64.40 | TONIGHT SIX VOTES LAND ON |
| 64.40–65.43 | **IVAN PITS** ← draft typo (Pitts) |
| 65.90–68.00 | IRENE'S BALLOT IS ONE OF THEM |
| 68.50–71.00 | IVAN IS GONE |
| 73.03–74.07 | TOMORROW |
| 74.07–75.83 | THE SHIELD IS GONE |
| 75.83–78.03 | NEW ALLIANCES WILL FORM |
| 78.30–79.70 | NEW TARGETS WILL EMERGE |
| 80.23–81.40 | AND ANOTHER DOUBLE |
| 81.40–82.90 | WILL LEAVE THE GAME |
| 82.90–84.47 | WATCH EVERY CONVERSATION |
| 84.47–85.33 | CHALLENGE |
| 85.33–86.17 | AND VOTE |

Door/end brand lockup (**L-TALKS / DOUBLAND.AI**) is **picture**, not in this text track (see ~86.7–88.2 still `22F06DF6-…PNG`).

**Auto-gen implication:** a Remotion “type layer” that chunks VO into 1–5 word cards with one motion preset gets closer to gold than baking every line into Imagine stills.

Type does **not** run for the whole 88s. Measured gaps: **1.9–2.8s**, **26.2–29.4s**, and **53.3–58.6s** (Talk plays with no words; `AS THE DAY CONTINUES` ends at 53.3, the next line is `AT THE END OF THE DAY` at 58.6). Some phrases flash and the tail stays: `SOMEONE IS VOTED OUT` is on screen **12.3–12.8s** (under half a second), then `IS VOTED OUT` holds to 13.8. `NO ONE WROTE FOR THEM` is followed by `WROTE FOR THEM`. The CapCut file does not name a font (`font_name` = `none`). Color is `#ffffffff`.

---

## 5. Audio architecture

| Layer | Asset | Timeline uses | Notes |
|-------|--------|--------------:|-------|
| VO | `v6_narration.mp3` | 2 | Split instances (not one continuous block) |
| Music | `music_drama.mp3` | 6 | Duck/under; multiple regions |
| SFX scan/tech | Digital Device Gadget Scanning… | 9 | Dominant UI/scan sweetener |
| SFX whoosh | Short Whoosh 4 | 6 | Transitions |
| SFX whoosh hit | Cinematic Whoosh Hit Low 2 | 3 | |
| SFX trailer | Horror Trailer Opener | 4 | Stakes / dark hits |
| SFX glitch | Glitching Signal… | 2 | |

**Auto-gen implication:** need a **small licensed/stock SFX kit** + ducking rules; picture-only parity will still feel empty without this bus.

### Measured levels (re-read 2026-10-16, from `capcut_audio_timeline.csv`)

Counts in the table above stay. These are the levels and windows the count table does not show.

| Bus | What the timeline actually does |
|-----|--------------------------------|
| Voice | Two clips, both sped to **1.01**. Full volume **0.9–8.6s**. A hole **8.6–9.133s** with no narration. Then **0.658** from **9.133s** to the end. Not one file with a volume filter. |
| Music | Starts at **1.933s**, after the opening scan. Six regions: **0.214** (1.9–16.4), **0.157** (16.4–29.7), **0.062** (29.7–54.5), then **0.195** in three abutting chunks from 54.5 to the end. The 0.06 ride covers the challenge **and the win**, not the teach line only. |
| Short whoosh | Six uses, level about **0.23**. On the teach steps (34.6, 37.3, 41.2, 44.0), the win (48.7), and once before the end card (84.6). |
| Low hit | Three uses, level about **0.51**. At **10.2s** (into the map), **32.7s** (into the teach), and **86.4s** (end card). |
| Scan | Nine uses. Level is not one number: about **0.34** at the open and the end card, about **0.24** on most joins, about **0.44** at 56.7s (into Talk). Several scans carry a fade. |
| Horror sting | Four uses, quiet, about **0.17**. At **14.3, 21.9, 26.2, and 78.3s**. A low dread hit, not a season-card-only sound. |
| Glitch | Two uses, about **0.18**. At **9.3s** and **14.8s**. |

No glass-break on this timeline. The cost beat is not a cracked photo.

---

## 6. Transitions & video FX palette

**Transitions (unique names):** Tremble Zoom · Blue Scan · Scan Modeling · Scanline Compression  

**Video effects:** Blu-ray Scanning · Shake · Spectrum Scan · Nervous Shaking  

Also: **93 material_animations**, **3 common masks**, multi-face algorithm folder, heavy **matting** on some clips.

**Auto-gen implication:** scan/tremble/shake family is the “Doubland HUD motion” glue between stills — not random crossfades.

The effect tracks are only **4 segments**. Most of the motion is a transition or an animation on the picture segment itself, not a separate FX track.

Confirmed joins from `capcut_media_timeline.csv`:

| Picture | Window | Motion |
|---------|--------|--------|
| Hook still | 0–1.0s | **Blue Scan** |
| Group photo | 1.0–3.1s | **Scan Modeling** on the way out |
| Flyover | 5.6–9.1s | **Scan Modeling**, played at **2.88×** |
| Challenge hf clip | 35.0–46.7s | **Tremble Zoom**. Words of the rules sit on this moving clip. The staged challenge file is a late insert, not the whole teach. |
| Leave plate | 66.0–68.4s | `ivan_leave_phaser.jpg`, **Tremble Zoom**. No crack overlay. |

The project canvas is **1080×1920**. The 2160×3840 master is an upscale of that edit.

---

## 7. Beat → CapCut media (confirmed)

Times are segment starts on the draft (approx.). Full detail: `capcut_summary.json` → `beat_buckets`.

| Beat | ~t | Picture (primary) | Type (sample) | Notes vs staged sheet |
|------|---:|-------------------|---------------|------------------------|
| **0 Hook** | 0–1 | `ivan_face` + legend stills; long UI screenshot plate on tr0 | THESE ARE… | Hook is multi-layer, not single still |
| **1 Concept** | 1–7 | `group_photo` → legend matrix/AI stills → into Phaser | AI VERSIONS / REAL PEOPLE / MAKING CHOICES | **Group first**, Phaser arrives mid-concept |
| **2 Survival / Phaser** | 7–16 | `signature_flyover` + legend overlays + early hf clips | FIFTEEN… / VOTED OUT / UNTIL ONE REMAINS | Phaser **captioned by type**, not bare map |
| **3 Follow** | 16–20 | `irene_namecard` then `ivan_namecard` | TODAY WE'RE FOLLOWING | Staged namecards **used** |
| **4 Irene want** | 20–28 | **legend hf + stills** (not `irene_habitat.png` on timeline) | IRENE GOES HARD… | Habitat plate **not** the CapCut hero |
| **5 Ivan want** | 28–33 | legend objective-style stills | IVAN WATCHES… / BEFORE HE BETS | Confirms **objective/graphic** over Willows habitat |
| **6 Challenge** | 33–48 | Stacked legend `C30B9252…` + long hf `033205…` → **`challenge_hold_for_shield.mp4` insert** | STEP-like VO fragments (secret card / hold / fold / shield) | Teach = **layers + type**; staged challenge clip is late insert |
| **7 Peak** | 48–55 | legend hf reveal clips + stills | IRENE GOT… / SHE WINS… / SAFE TONIGHT | Not only `irene_shield_win.png` |
| **8 Social** | 55–62 | `Talk.mp4` + legend still → `Village.mp4` | AS THE DAY… / END OF DAY… | Stock Talk still used |
| **9 Ballots** | 60–66 | **`ballots.mp4`** + legend still | EVERY DOUBLE CASTS… / SIX VOTES… / IVAN PITS | Staged ballots **used** |
| **10 Cost** | 66–74 | **`ivan_leave_phaser.jpg`** → legend leave hf clips | IRENE'S BALLOT… / IVAN IS GONE | **2D→3D bridge confirmed** |
| **11–12 Cliff** | 74–83 | legend radar/shield hf + `irene_face` + Talk | SHIELD IS GONE / NEW ALLIANCES / NEW TARGETS | Forward threat graphics |
| **14 Door / end** | 83–88 | legend clip → **`signature_flyover`** → end still `22F06DF6…` | WATCH EVERY… / CHALLENGE / AND VOTE | Phaser door tease + brand still |

---

## 8. Architecture pattern (rebuild target)

```
[VO 1.0× timeline ~88s]
    + kinetic type track (chunked VO, one template)
    + multi video tracks (base plate + character + overlay FX stills)
    + Phaser inserts at literacy + cost dive + door
    + staged fact anchors (namecards, challenge clip, ballots, leave phaser)
    + legend cinematic fills (habitats, peak, cliff, end)
    + music_drama ducked
    + scan/whoosh/trailer SFX bus
    + scan/tremble transitions
```

**Not** the handoff model of “one bin file per sheet scene, Ken Burns.”  
**Yes** “bin + legend library + type system + SFX kit.”

---

## 9. Implications for auto-gen phases

| Phase | CapCut evidence says |
|-------|----------------------|
| **Picture jobs G1–G8** | Still necessary as **fact anchors**; insufficient alone for Anya parity |
| **Legend / moment clips** | **32 used** — treat used set as commission targets; drop 15 unused from “required” |
| **Type / HUD** | Prefer **Remotion text layer** mirroring 43-line chunking + one motion preset; optional baked HUD stills |
| **Phaser** | Keep F pack; expect **overlays + type** on plant |
| **Audio** | Ship VO + drama bed + **named SFX palette** above |
| **Runtime** | 88.2s is exact product of VO length + this edit density |
| **CapCut XML import** | Still optional; CSV/JSON extracts are enough to rebuild in Remotion |

---

## 10. Defects / gotchas (do not copy blindly)

1. On-screen **“IVAN PITS”** typo (should be Pitts).  
2. Long track-0 hold of CapCut UI **Screenshot** as background plate — craft artifact, not brand.  
3. Some original Mac absolute paths remain inside JSON; portable media is under `Resources/local/`.  
4. Matting/mask payloads are huge and CapCut-specific — do not port to Remotion 1:1.  
5. Text template is Chinese-named CapCut cloud effect — Remotion should **reimplement motion**, not depend on CapCut resource IDs.

---

## 11. Related docs

| Doc | Relationship |
|-----|----------------|
| [`GOLD.md`](GOLD.md) | Package hub |
| [`gold_beat_map.md`](gold_beat_map.md) | Sheet ↔ film ↔ kit (upgrade with this file) |
| [`craft_notes.md`](craft_notes.md) | Taste gate still open |
| [`anya_bar_rubric.md`](anya_bar_rubric.md) | Pass/fail bar |
| `SOT-new-daily.md` | Product law (promote rules only after taste) |
