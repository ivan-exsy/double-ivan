# L-Talks Opening Trailer — Anya Handoff Bundle

**Mode:** Manual CapCut edit (not Remotion automation)  
**Sim:** `soul15_seed_20260224` (display: **L-Talks** · season **Press Play**)  
**Target:** ~60s · 9:16 vertical · shareable viral opener [A]

This folder is the single drop zone for Anya. Everything she needs should land here.

---

## Folder map

| Folder | Contents | Status |
|--------|----------|--------|
| `brief/` | Locked decisions + scenario-writer brief | ✅ ready |
| `cast/` | Group photos, `group_anim.mp4`, optional spotlight preview; hero/portraits held for [B] | ✅ ready |
| `brand/` | Village, Survival, Pressure, wordmark, end cards, anthem, SFX | ✅ ready |
| `script/` | **Draft v1** script + on-screen copy | ⚠️ review before VO |
| `audio/` | `narration.mp3` + `narration_timing.json` | ❌ after script lock |
| `world/` | Pointer — survival assets live in `brand/` | ✅ N/A |
| `reference/` | TODO doc, Anya Pistsov scene spec (style reference only) | ✅ ready |

**Cast filenames:** hero and portrait PNGs use readable names (`Max_Shoemaker.png`, etc.). UUID mapping is in `cast/cast_reference.md`.

---

## Trailer shape (locked — lean [A])

1. **Concept intro** — what Doubland is, what a Double is (~0–20s)
2. **Cast overview** — three-hundred-member chat reveal → **`group_photo` → matrix → `group_anim.mp4`**. One VO line; no trait lines.
3. **Close** — mid URL **`doubland.ai`** + named **Survival Mode** (Pistsov visuals) → **What if?** → end card `Episode 1 tomorrow · 18:30 (EST)`.

Per-Double intros and the 15 trait lines are **not** in this trailer — they belong in daily [B] `day_normal`.

**Pacing reference (optional):** `cast/spotlight_preview_v2.mp4` — Anya may use for rhythm; cast block uses `group_anim` per D1.

---

## Locked decisions (2026-07-02)

See `brief/scenario-writer-brief.md` § Locked production decisions (D1–D9).

---

## Your workflow (Ivan)

### Step 1 — Review draft script v1 ✅ drafted

Files: `script/script.md`, `script/script.json`, `script/on-screen-copy.md`

Lock or send to external writer for polish. Brief is retuned for lean ~60s [A].

### Step 2 — Record VO (`--skip-render`)

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

### Step 3 — Deliver to Anya

All visual assets are in `cast/` and `brand/`. After VO lands in `audio/`, the bundle is complete.

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

All production decisions **locked 2026-07-02** — see `brief/scenario-writer-brief.md`.

**Remaining:** script v1 review → VO record → Anya handoff.

---

## Source paths (for Ivan — not Anya)

| Asset | Canonical location |
|-------|-------------------|
| Cohort cast pack | `generative_agents/video/assets/cohort/soul15_seed_20260224/` |
| Spotlight preview v2 | `generative_agents/video/remotion/out/soul15_seed_20260224_spotlight_preview_v2.mp4` |
| Auto script draft | `generative_agents/data/20260628-4/opener&002/script.json` |
| Active TODO | `double-ivan/video/opening/TODOs-opening-trailer.md` |
| Video SOT | `double-ivan/video/sot-video.md` §0, §10 |
