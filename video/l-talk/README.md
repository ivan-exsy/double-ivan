# L-Talks Opening Trailer — Anya Handoff Bundle

**Mode:** Manual CapCut edit (not Remotion automation)  
**Sim:** `soul15_seed_20260224` (display: **L-Talks** · season **Press Play**)  
**Target:** ~60s · 9:16 vertical · shareable viral opener [A]

This folder is the single drop zone for Anya. Everything she needs should land here.

---

## Folder map

| Folder | Contents | Status |
|--------|----------|--------|
| `brief/` | Scenario-writer brief (send to writer after retune) | ⚠️ needs D1 retune before send-out |
| `cast/` | 15 hero PNGs, 15 portrait crops, group photos, `group_anim.mp4`, pacing preview | ✅ ready |
| `brand/` | Village B-roll, wordmark, end cards, anthem, SFX, Talk/Pressure clips | ✅ ready (reuse Pistsov kit) |
| `script/` | Final script + on-screen copy sheet | ❌ blocked on writer |
| `audio/` | `narration.mp3` + `narration_timing.json` | ❌ blocked on locked script |
| `world/` | One survival-tease still or short loop for the close | ❌ pending (D3) |
| `reference/` | TODO doc, Anya Pistsov scene spec (style reference only) | ✅ ready |

**Cast filenames:** hero and portrait PNGs use readable names (`Max_Shoemaker.png`, etc.). UUID mapping is in `cast/cast_reference.md`.

---

## Trailer shape (locked — lean [A])

1. **Concept intro** — what Doubland is, what a Double is (~0–20s)
2. **Cast overview** — L-Talks alumni chat → "pressed play" reveal → all 15 visible at a glance (group frame / matrix). **No spoken trait lines.**
3. **Close — survival tease** — one hint at survival episodes ahead → "What if?" → `doubland.ai`

Per-Double intros and the 15 trait lines are **not** in this trailer — they belong in daily [B] `day_normal`.

**Pacing reference:** watch `cast/spotlight_preview_v2.mp4` for cast-block rhythm only. Do not copy its per-person VO structure.

---

## Your workflow (Ivan)

### Step 1 — Retune the writer brief (D1) — **do this first**

The brief in `brief/scenario-writer-brief.md` still asks for 15 spoken trait lines and a stakes montage (§6.2–6.3). That matches the **old** ~90s opener, not the lean ~60s [A] shape.

Before sending to the scenario writer, update the brief so deliverables are:

- Cold open + cast-overview block + survival-tease close (~60s total VO)
- **No** 15 `cast_intro` narration lines (visual cast block only)
- **No** survival mechanics in the body — survival hint at close only
- Fix grammar: "L-Talks enter," not "the L-Talks enters"
- Masked names stay locked (L-Talks, Press Play)

`script/script_draft_auto.json` is the current auto-gen draft — useful as JSON shape reference, **not** as final copy.

### Step 2 — Commission final script

Send retuned brief → external writer. Deliverables:

1. Final script (markdown + JSON matching opener shape)
2. Short writer's note on emotional arc (≤300 words)

Drop results in `script/`:

- `script.md` — human-readable
- `script.json` — locked production script
- `on-screen-copy.md` — one-page copy sheet (see template below)

### Step 3 — Record VO (`--skip-render`)

From the engineering repo (`generative_agents`), once `script.json` is locked:

```powershell
cd d:\Coding\generative_agents
.\venv\Scripts\activate
python -m video.generate_trailer 20260628-4 opener `
  --mode opener `
  --top 15 `
  --cohort-name "L-Talks" `
  --season-title "Press Play" `
  --skip-render `
  --force `
  -o "d:\Coding\double-ivan\video\l-talk\audio\_gen"
```

Then copy into `audio/`:

- `narration.mp3`
- `narration_timing.json`

Voice is locked: ElevenLabs `eleven_v3` warm @ **1.5×**. Inline cues like `[curious]`, `[warmly]` are welcome in the script.

> **Note:** The pipeline may expect script at a sim output path. If the command regenerates script instead of using yours, place your locked `script.json` at `data/20260628-4/opener&NNN/script.json` (next index) or pass the output dir explicitly and verify the VO matches your copy before handoff.

### Step 4 — Survival-tease visual (D3)

Pick one (low effort):

| Option | Source | Effort |
|--------|--------|--------|
| **A — Reuse kit clip** | `brand/Pressure.mp4` or a frame from it | Lowest |
| **B — Grok still** | One tense "survival season" image, 9:16 | ~30 min |
| **C — Future sim frame** | Grab from first survival daily when available | Blocks on sim run |

Save as `world/survival_tease.mp4` or `world/survival_tease.png`.

### Step 5 — World beat (D2)

**Recommendation:** reuse `brand/Village.mp4` for the world-establishing beat. No L-Talks sim run required for the lean opener — per-Double habitat visuals are [B], not [A].

### Step 6 — Final handoff check

Before sending to Anya, confirm:

- [ ] `script/script.md` + `script.json` + `on-screen-copy.md`
- [ ] `audio/narration.mp3` + `narration_timing.json`
- [ ] `cast/` complete (already done)
- [ ] `world/survival_tease.*`
- [ ] `brand/` complete (already done)
- [ ] Anya has CapCut project access to this folder

---

## On-screen copy sheet (template for `script/on-screen-copy.md`)

Fill after script is locked:

```
SEASON LINE (hold ≥1s)
  L-TALKS · PRESS PLAY

HOOK TITLES
  WHAT IF…
  YOU HAD A SECOND CHANCE
  … (list each beat)

MID-TRAILER URL (~59s mark in Pistsov reference)
  doubland.ai

END CARD
  What if?
  doubland.ai
  Episode 1 tomorrow · 18:30   ← adjust to launch date

CAPTIONS
  (paste narration lines with approximate timecodes from narration_timing.json)
```

---

## What Anya reuses from the Pistsov reference

See `reference/anya-scene-spec-pistsov-reference.md` for motion/style grammar (palette, typography, dissolve rhythm). **Do not** reuse Pistsov cast assets — L-Talks cast is in `cast/`.

| Pistsov kit (in `brand/`) | L-Talks use |
|---------------------------|-------------|
| `Village.mp4` | World-establishing B-roll |
| `Talk.mp4` | Concept / conversation beat |
| `Pressure.mp4` | Survival-tease close (or reference) |
| `music_anthem.mp3` | Bed under VO |
| `sfx/` | Whooshes, typing, impacts |
| Wordmark + end cards | Brand close |

Replace Pistsov `Family.mp4` with `cast/group_anim.mp4`.

---

## Open decisions

| ID | Question | Recommendation |
|----|----------|----------------|
| D1 | Retune writer brief for lean [A]? | Yes — before send-out |
| D2 | Need a normal-day sim run for visuals? | No — Village + cast pack enough |
| D3 | Survival-tease source? | Start with `Pressure.mp4` frame; upgrade later if needed |

---

## Source paths (for Ivan — not Anya)

| Asset | Canonical location |
|-------|-------------------|
| Cohort cast pack | `generative_agents/video/assets/cohort/soul15_seed_20260224/` |
| Spotlight preview v2 | `generative_agents/video/remotion/out/soul15_seed_20260224_spotlight_preview_v2.mp4` |
| Auto script draft | `generative_agents/data/20260628-4/opener&002/script.json` |
| Active TODO | `double-ivan/video/opening/TODOs-opening-trailer.md` |
| Video SOT | `double-ivan/video/sot-video.md` §0, §10 |
