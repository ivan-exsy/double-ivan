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
| **Voice** | `eleven_v3` warm @ **1.2×** | **L-Talks manual exception** to SOT default 1.5× — chosen after VO experiment listen (`audio/experiments/README.md`) |
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

