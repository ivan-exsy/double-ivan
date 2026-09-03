# TODO — 2D→3D morph (post-MVP, outsource)

**Status:** Parked until after Village MVP. **Outsource** to a dedicated video producer. Do not fold into tonight’s closer bake.  
**Locked daily stays:** [`SOT-video.md`](SOT-video.md) §9 closer format lock [A] + current §3.6 literacy (Phaser plant + Cost/Peak Phaser bridge + Door tease). Wipe / fade / Ken Burns only.  
**Starting point:** archived blend grammar [`../done/video/daily/daily-2D-3D-blend.md`](../done/video/daily/daily-2D-3D-blend.md) and compact [`../done/20260828_daily-2D-3D-blend.md`](../done/20260828_daily-2D-3D-blend.md).  
**Tracker:** [`TODO_video.md`](TODO_video.md) points here. Do not brief the next bake from this file.

---

## 1. Why this exists

Trailers must teach: **the live product is pixelated Phaser; cinematic pictures are that same beat as real life.**

The founder vision is not “drop a stock map clip before Peak.” It is:

> An **actual Phaser scene from a simulation moment** morphs into the cinematic visual of that moment.

That morph is the literacy beat. Eng does not have producer-grade instructions for it. The 2026-08-28 `2d-3d` branch tried to force plant timing in the recipe. Watch failed. Code discarded. This doc is the single brief when a producer owns the job.

---

## 2. What ships today (honest)

Do not treat the following as the morph.

| Beat | What the closer actually uses | Gap |
|------|-------------------------------|-----|
| **Plant** | Stock `signature_flyover.mp4` (landscape Phaser **map**, ~1264×720, ~10s, 24fps). Copied into every kit. Same file every night. | Not this sim. Not this night. Not this location. Not a morph. |
| **Cost bridge** | `{cost}_leave_phaser.png` from `video.capture_phaser_elim` (FE `?recording=true` screenshot), then cinematic leave. | Often the **wrong moment** (last step Cost is still in the day’s window, not the vote/leave). HUD **name tags** crowd the frame. Capture **reuses** an existing PNG unless `--force`. |
| **Door** | Same stock `signature_flyover.mp4` as `signature_flyover_door`. | Same generic map as plant. |
| **Transition** | Hard cut, short fade, optional Ken Burns / wipe. | **No morph.** No pose match. No color grade handoff. No name-tag cleanup. |

Live Post-Production can also **duplicate** flyover cuts (recipe layer + leftover polish `edit_script` / imported path). Wall clock = body + `posterHoldSec` (2.5s). Example from the discarded bake: overlapping plant bars ~13.86–15.46 and ~14.37–16.00.

---

## 3. Founder watch — `20260825-1` day 3 (discarded 2d-3d bake)

Package: `double-video/data/20260825-1/trailer_ready_day3`. Peak **Max Shoemaker**. Cost **Alex Shepard**. Engine day 3, Silent Pact. VO lock was **not** replaced.

| Wall | Role | What was on screen | Verdict |
|------|------|--------------------|---------|
| 00:14–00:15 | `signature_flyover` | Generic `clip_kit/imported/signature_flyover.mp4` | Easy to miss. Not a night capture. Two overlapping flyover elements. |
| 56.8–60.2 | `cost_phaser_bridge` | FE Phaser still of **this sim** (`alex_shepard_leave_phaser.png`) | **This cast, wrong beat.** Alex Shepard at the common-room / cafe talking to Ivan Pitts (“Getting some coffee?”). Irene Dove / Owen Logan “Good evening!”. Vincent Slater still on screen (he was **not** booted this night — only Alex Butcher is already out). Overcrowded name tags hide the sprites. **Not** the Silent Pact elim / leave. Bake log: `phaser_elim_capture` = **reuse**. |
| 68.26–74.58 | `signature_flyover_door` | Same generic `signature_flyover.mp4` | Door tease is a map loop, not a morph into lockup. |

Locked master restored from `output/trailer_9x16_closer_20260828_194051_2d3d.mp4` (pre-experiment). Do not treat `*_195124_2d3d.mp4` as the daily.

---

## 4. Desired — producer must specify before eng builds

These are the instructions that were missing. The producer writes them. Eng does not invent them.

### 4.1 Pick the sim moment

- Which **clock**? Engine step, Survival minute, vote lock, last words, leave walk, habitat idle?
- Who is **in frame**? Cost only, Cost + 1–2 others, or the room?
- What **proves** it is tonight (challenge tokens, ballot, empty chair, location from ledger)?
- What happens if Cost is already gone at the probe step (`capture_phaser_elim` uses last step **with** persona in `[lo, hi)` around vote offset 870 min)?
- Fail closed if the still is a random chat (coffee / “good evening”) with no leave meaning.

### 4.2 Process the Phaser frame so Doubles are visible

- **Name tags / chat bubbles / follow-HUD** — hide, dim, or strip. Overcrowded labels were the watch reject.
- Camera: follow vs village wide vs interior crop. Zoom that still reads as Phaser.
- Aspect: native FE is landscape; trailer is **9:16**. Crop, letterbox, or re-frame — pick one and keep it for plant, dive, and door.
- Do **not** Imagine a fake Phaser map as a substitute for this night’s capture.

### 4.3 Morph Phaser → cinematic

Specify, per beat (plant, Cost leave, Door), with picture refs:

- **Location continuity** — Phaser tile (Hobbs cafe, dorm, library, street) must become the matching village plate / habitat, not a generic interior.
- **Pose / facing / scale** — first cinematic frame matches the sprite cluster.
- **Color / light** — pixel palette → cinematic grade (how many frames, LUT, saturation).
- **Duration** — CapCut gold was ~0.5s dive in, ~0.3s pixel fracture out. Target 0.6–1.6s Phaser hold, never sit in 2D more than ~3s without a dive.
- **Audio** — silent under locked VO (recommendation). No new VO for literacy beats.
- **Caps** — 2–3 dives per closer. Establishing cards / census / end lockup stay 2D.

Grammar to start from (archived blend):

- **Camera dive (2D→3D):** push into pixels until they resolve as lived skin / room.
- **Pixel fracture (3D→2D):** optional return to Phaser before the next graphic.
- **Hard cut:** only on vote/leave when drama needs it. Default is dive.

---

## 5. What not to do (learned)

- Do not wallpaper stock flyover on every scene or under the cliff bed.
- Do not bury plant under hook census / group photo / captions.
- Do not call a cinematic Peak namecard a “dive.”
- Do not `--replace-vo-lock` / `--force` `data/20260823-2/trailer_ready_day2` (auto-gen benchmark).
- Do not recut Episode 1 Ivan/Alex as the morph specimen.
- Do not ship all-cinematic (zero Phaser) — that still fails §3.6.
- Do not treat Grok Imagine 2D legend / Spark / timestamps as this job (those stay in [`../done/20260827_viral_video.md`](../done/20260827_viral_video.md)).

---

## 6. Eng hooks (when the producer brief exists)

Today’s code is good enough to **hold a still**. It is not the morph.

| Piece | Today | Later (after producer spec) |
|-------|-------|-----------------------------|
| `resolve_signature_flyover()` | Stock `video/fly-over/signature_flyover.mp4` | Per-night capture or night-locked crop |
| `capture_phaser_elim` | Last-step-with-Cost screenshot; skip if PNG exists | Moment picker + HUD-off recording + 9:16 crop |
| Recipe roles | `signature_flyover`, `cost_phaser_bridge`, `signature_flyover_door` | Morph layer / matched cinematic first frame |
| Validator | Phaser plant + Cost/Peak Phaser + Door Phaser exist | Continuity checks once the producer defines them |

Village MVP gate is gather + town talk (`done/20260910_launch.md`). This TODO is not that gate.

---

## 7. Producer deliverable (acceptance)

A one-pager plus 3–5 annotated frame pairs (Phaser still ↔ first cinematic frame) that answer §4. Until that exists, eng keeps the locked closer and does not reopen a `2d-3d` recipe branch.
