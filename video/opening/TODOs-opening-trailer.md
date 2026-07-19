# TODO — L-Talks / Press Play Opening Trailer (manual production)

> **Mode:** Manual — Anya edits by hand in CapCut. Not the automated Remotion pipeline.
> **Sim:** `soul15_seed_20260224` (15 Doubles, forked from the soul15 baseline).
> **Cohort display name:** L-Talks (masked) · **Season:** Press Play.
> **Type:** Opener [A] — lean viral asset. Per `video/sot-video.md` §0 and §10.
> **Handoff bundle:** `video/l-talk/` · **Locked script:** `l-talk/script/script_cos.md` (v2) · **Locked VO:** `l-talk/audio/experiments/script_cos_oneshot_speed12/`

---

## Locked script & VO (2026-07-06 — selected with Anya)

| Item | Canonical path | Notes |
|------|----------------|-------|
| **Script** | `l-talk/script/script_cos.md` | **v2** team draft; supersedes `script.md` (v1). Block map + on-screen cues in the same file. |
| **VO audio** | `l-talk/audio/experiments/script_cos_oneshot_speed12/narration_cos.mp3` | **~83.4s** one-shot take |
| **Timing** | `…/script_cos_oneshot_speed12/narration_timing.json` | Single segment — Anya marks title cards from the waveform, not pre-segmented beats |
| **TTS input** | `…/script_cos_oneshot_speed12/script_used.txt` | Exact string sent to ElevenLabs (inline `[curious]` / `[warmly]` / `[excited]` / `[accentuate]`) |
| **Voice** | `eleven_v3` warm @ **1.2×** | Matches SOT global lock (§0.3 / §7.1). Chosen after VO experiment listen (`audio/experiments/README.md`); earlier v1 tried 1.5× and was rejected for flow/runtime. |
| **Re-render** | `python -m video.render_ltalk_cos_oneshot` | From `generative_agents` repo root |

**Why this beat v1:** Tighter `script_cos` copy + 1.2× one-shot landed better flow and runtime than `script.md` @ 1.5× (`v1_oneshot_speed15`). Close hook locked to *"what would MY Double do?"* (not generic "What if?").

`script.md` / `script.json` remain as v1 archive; do not hand Anya v1 for the edit.

---

## Trailer shape (locked)

Lean viral asset, mobile 9:16, shareable. **VO ~83s** (longer than SOT ~60s target — accepted for this manual cut). No per-Double intros, no survival mechanics in the body.

1. **Concept intro** — what Doubland is, what a Double is (message-derived profiles).
2. **Cast overview** — L-Talks reveal (three-hundred-member chat → year analyzed → top 15 → pressed play) + visual roster: `group_photo` → matrix → **`group_anim.mp4`**. No spoken trait lines.
3. **Close — survival tease** — mid URL `doubland.ai` + named **Survival Mode** (Pistsov visuals) → "What if?" → end card.

Per-Double intros and the 15 spoken trait lines move to **[B] `day_normal`** daily (SOT L2).

## Locked decisions (2026-07-02)

| ID | Decision |
|----|----------|
| D1 | Cast stack: group photo → matrix → `group_anim.mp4` |
| D2 | No sim run — `Village.mp4` + cast pack |
| D3 | Survival close: reuse Pistsov `Survival.png` + `Pressure.mp4` |
| D4 | Scale in VO: ~300-member chat (locked copy: *"Three hundred voices in one alumni chat"*) |
| D10 | **Locked script:** `script_cos.md` (v2) — Ivan + Anya, 2026-07-06 |
| D11 | **Locked VO:** `script_cos_oneshot_speed12/` · `eleven_v3` warm @ **1.2×** one-shot |
| D12 | **Close hook:** *"what would MY Double do?"* + end card **WHAT WOULD MY DOUBLE DO?** |
| D5 | Named Survival Mode badge at close |
| D6 | End card: `Episode 1 tomorrow · 18:30 (EST)` |
| D7 | Mid-trailer + end card `doubland.ai` |
| D8 | Group assets only — no hero/portrait PNGs in opener |
| D9 | `spotlight_preview_v2.mp4` optional for Anya |

Full detail: `l-talk/brief/scenario-writer-brief.md` § Locked production decisions.

## Raw materials to prep for Anya

### Narrative
- [x] **Script locked** — `l-talk/script/script_cos.md` (v2; supersedes `script.md` v1)
- [x] **VO locked** — `l-talk/audio/experiments/script_cos_oneshot_speed12/narration_cos.mp3` + `narration_timing.json`
- [x] **On-screen copy sheet** — `on-screen-copy.md` timecodes aligned to `narration_cos.mp3` (~83.36s; fine-tune on waveform)

### Cast pack (ready — do not regenerate)
- [x] Group photo (clean + matrix) + `group_anim.mp4`
- [x] Hero/portrait PNGs — **held for [B]; not used in opener (D8)**
- [x] `spotlight_preview_v2.mp4` — optional reference (D9)

### World / survival close (ready)
- [x] `Village.mp4` — world beat (D2)
- [x] `Survival.png` + `Pressure.mp4` — Pistsov survival tease (D3, D5)

### Brand kit (ready)
- [x] End card, wordmark, anthem, SFX, Talk.mp4 — `l-talk/brand/`

## Order of work

1. ~~Retune brief (D1)~~ · ~~Draft script v1~~ · ~~Lock script_cos + VO (D10–D11)~~ · ~~On-screen timecodes + HANDOFF~~
2. **Deliver `l-talk/` folder to Anya** (or confirm she has locked assets)

## Handoff checklist for Anya

- [x] `HANDOFF.md` — shot-by-shot map (`l-talk/HANDOFF.md`)
- [x] `script/script_cos.md` (+ `script_used.txt` in VO experiment folder)
- [x] `audio/experiments/script_cos_oneshot_speed12/narration_cos.mp3` + `narration_timing.json`
- [x] `script/on-screen-copy.md` — timecodes from locked VO (~83.36s)
- [x] `cast/group_photo*.png` + `group_anim.mp4`
- [x] `brand/` (Village, Survival, Pressure, end cards, SFX)
- [x] `cast/spotlight_preview_v2.mp4` (optional)

---

## Automate CapCut picture gen (lesson from Tonight’s Scar D1 — 2026-07-18)

> **Worked example:** Survival Day 1 kit for sim `20260713-1` — `generative_agents/data/20260713-1/trailer_ready_day2/`  
> **Edit sheet:** `CAPCUT_EDIT_SHEET.md` · **Bins:** `clip_kit/bins/{A_hook,B_stake,C_pressure,D_peak,E_cliff_door}/`  
> **Goal:** turn “GENERATE G1–G5” into a repeatable pipeline (not one-off chat gen). Opening trailers can reuse the same two-step Imagine pattern for any still → micro-clip need.

### What we shipped (manual run that proved the method)

| ID | Beat | Output | Medium |
|----|------|--------|--------|
| **G1** | Irene want / habitat | `B_stake/irene_habitat.png` | Still |
| **G2** | Ivan want / habitat | `B_stake/ivan_habitat.png` | Still |
| **G3** | Hold-for-Shield teach | `C_pressure/challenge_hold_for_shield.mp4` (+ `_ref.png`) | **Still → 2s clip** |
| **G4** | Peak / Irene Shield | `D_peak/irene_shield_win.png` | Still |
| **G5** | Cost / Ivan leave | `E_cliff_door/ivan_leave.png` | Still |

**Priority B also shipped (2026-07-18):** **G6** `ballots.mp4` · **G7** `census_15_to_14.png` · **G8** Irene/Ivan name cards — defaults in daily SOT §10.1.

### Hard locks (do not skip — early gens looked like “random people in themed rooms”)

1. **Fact lock** — jobs, places, Peak/Cost, challenge cards, gather arena come from the **sim day ledger**, not cohort marketing cards.  
   - Example D1: Irene = barista @ **Hobbs Cafe**; Ivan = pharmacy tech @ **Willows**; challenge gather + evening vote @ Hobbs; cards Irene **7** hold / Vince **6** / Max **5** / Ivan **4** fold.  
   - Sources: `stamp_facts.json`, cast digest, `day_reasoning` / picker — never invent workplaces for habitat plates.
2. **Identity lock** — every hero face must match the **exact baseline portrait** (UUID face still / `_refs/*_face.png`). Prompt alone is not enough; attach the face as a reference image.
3. **Location lock** — habitat / gather plates must match the **empty Ville interior** reference (e.g. `_refs/hobbs_counter.png`, `hobbs_dining.png`, `willows_counter.png`). Same architecture, furniture, light mood.
4. **VO / story lock** — picture serves the locked VO beat. Bonding = **habitat under want lines** (no spoken job+place stamps). G3 teaches the rule; G4 is the win; G5 is dignified Cost (no celebration pile-on).

### Two-step Grok Imagine (required for any motion clip)

Per [xAI Imagine / video docs](https://docs.x.ai/developers/model-capabilities/video/generation) and [image-to-video](https://docs.x.ai/developers/model-capabilities/video/image-to-video):

| Step | What | API / tool | Notes |
|------|------|------------|--------|
| **1. Still** | Generate the **hero frame** with all identity + set + fact detail | Cursor `GenerateImage` *or* Imagine image API | Attach **all** face + place refs. 9:16. Photoreal. No text overlay / logo / winner crown unless the beat needs it. |
| **2. Clip** | Animate that still 1–2s | `POST https://api.x.ai/v1/videos/generations` with `image: { url: data:image/png;base64,… }` + motion prompt | Model: `grok-imagine-video-1.5`. `duration: 2`, `aspect_ratio: "9:16"`. Prompt = **tension / mood / unique per-person micro-moves** — preserve faces and set; no celebration unless Peak beat asks for it. |

**G3 motion pattern that worked:** locked camera + tiny push-in; Irene grip-tighten on 7; Vince lean-in on 6; Max eye-flick on 5; Ivan finishes setting 4 down. Each Double must have a **distinct** movement (or explicitly “hold still”).

**Auth:** `XAI_API_KEY` from `generative_agents/.env.local`. Poll `GET /v1/videos/{request_id}` until `status=done`, then download `video.url` into the bin.

Stills-only beats (G1/G2/G4/G5) stop after step 1 unless Anya asks for a micro-loop.

### Manual workflow we used (encode this as stages)

```
locked VO + picker/ledger
  → CAPCUT_EDIT_SHEET (commission list G1…Gn)
  → stage _refs/ (faces + empty interiors)
  → for each G#:
       build prompt from sheet row (VO line, place, who, posture, mood, fact lock)
       step 1: still w/ refs → bins/<bin>/<name>.png
       [if motion] step 2: i2v → bins/<bin>/<name>.mp4
       human eyeball (faces, place, story)
  → mark READY on sheet + clip_kit.json
  → zip package for Anya
```

### What to automate next (engineering backlog)

Treat this as a small pipeline module (working name: `build_capcut_picture_kit` / `imagine_g_assets`), not Remotion.

| Stage | Automate | Inputs | Outputs |
|-------|----------|--------|---------|
| **A. Commission** | Emit GENERATE rows from locked VO + picker (Peak, Cost, challenge type, gather place, workplaces) | `vo_locked.txt`, picker, `stamp_facts` | `CAPCUT_EDIT_SHEET.md` draft + JSON job list |
| **B. Refs** | Resolve face UUIDs + Ville interior plates into `clip_kit/_refs/` | baseline cohort portraits, `video/assets/village/interior/*` | Named `_refs/{person}_face.png`, `{place}_*.png` |
| **C. Still gen** | Call Imagine image (or equivalent) with prompt template + `reference_image_paths` | Job row + refs | `bins/.../*.png` |
| **D. Optional i2v** | Call xAI video generations (base64 still + motion template) | Still path + unique-move list | `bins/.../*.mp4` |
| **E. Gate** | Checklist: file exists, 9:16, optional face-similarity / human review flag | Outputs | Update sheet status READY / FAIL |
| **F. Package** | Refresh `clip_kit.json` staged list; zip bins + VO + sheet | Kit folder | Anya handoff zip |

**Prompt templates to codify (one per beat family):**

- **Habitat (G1/G2):** single Double + workplace interior + quiet activity matching want line; face + place refs; optional on-screen chip is CapCut-only (do not bake into still).
- **Challenge bodies (G3):** multi-face + dining gather plate; per-person hold/fold from ledger; no “X wins” subtitle.
- **Peak (G4):** Peak hero + winning card/fact; soft BG holders if ledger names them; same gather set as G3; daylight continuity.
- **Cost leave (G5):** Cost center; evening/cooler light if vote is evening; no mocking BG; dignity exit.

**Do not automate yet:** full CapCut timeline XML; Remotion replacement for Anya’s cut; inventing facts when ledger fields are missing (fail the job instead).

### Quality failures to catch in CI / review

- Habitat uses **marketing** job/place instead of **sim** workplace.
- Face drift (“Irene-like” without the portrait attached).
- Wrong interior (generic cafe vs Hobbs plate).
- G3 shows a winner crown / G5 shows celebration.
- Motion clip where every Double does the **same** gesture.
- Step 2 run **without** freezing step-1 still (breaks continuity with G4/G5).

### Paths to keep linked

| Artifact | Path |
|----------|------|
| Worked CapCut sheet | `generative_agents/data/20260713-1/trailer_ready_day2/CAPCUT_EDIT_SHEET.md` |
| Kit + refs | `…/trailer_ready_day2/clip_kit/` |
| Daily SOT | `double-ivan/video/daily/SOT-new-daily.md` |
| xAI video API | https://docs.x.ai/developers/model-capabilities/video/generation |
| xAI image-to-video | https://docs.x.ai/developers/model-capabilities/video/image-to-video |

