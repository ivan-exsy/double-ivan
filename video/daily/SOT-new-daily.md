# SOT — Daily Trailers (Tonight’s Scar)

> **Audience:** DEV / Remotion / narration pipeline / CapCut ops  
> **Authority:** For **daily** trailers, this file **supersedes** `../sot-video.md` §11–§12 and L11 spoken-stamp law until folded into the main Video SOT.  
> **Does not replace:** Part I shared grammar in `../sot-video.md` (9:16, voice, mix, assets, baseline validators) · opener `[A]` · `daily-2D-3D-blend.md` · fact-lock to the sim ledger.  
> **Locked VO gold:** [`VO_LOCKED.md`](VO_LOCKED.md) §V6 (Survival Day 1).  
> **History / debate:** [`archive/SOT-new-daily-history.md`](archive/SOT-new-daily-history.md)

**Nav:** [Video SOT](../sot-video.md) · [Legacy encyclopedia WIP](../TODO_video.md) · [2D↔3D](daily-2D-3D-blend.md) · [Prompts](../prompts.md) · [VO locked](VO_LOCKED.md)

---

## Contents

1. [Intent](#1-intent)  
2. [Asset stack](#2-asset-stack)  
   - [2.1 Village place plates](#21-village-place-plates-interiors)  
3. [D1 — Tonight’s Scar](#3-d1--tonights-scar)  
4. [Continuity (Scar Chain)](#4-continuity-scar-chain)  
5. [Cast & season coverage](#5-cast--season-coverage)  
6. [D2 — Share Spark](#6-d2--share-spark)  
7. [D3 — Personal Edge](#7-d3--personal-edge)  
8. [Moment picker](#8-moment-picker)  
9. [VO contract & templates](#9-vo-contract--templates)  
10. [CapCut / Remotion bins](#10-capcut--remotion-bins)  
   - [10.1 Picture kit commission (G1–G8)](#101-picture-kit-commission-g1g8)  
11. [Eng pipeline & schema](#11-eng-pipeline--schema)  
12. [Validators](#12-validators)  
13. [Guardrails](#13-guardrails)  
14. [DEV backlog](#14-dev-backlog)  
15. [Changelog](#15-changelog)

---

## 1. Intent

Default daily is **not** a full-day encyclopedia.

| Paused (do not build as default) | Ship instead |
|----------------------------------|--------------|
| `concept_reset → stamps×N → challenge_teach → full-day recap` | **D1 Tonight’s Scar** — unfinished social pressure → return itch → one Door |
| `[B] day_normal` cast directory | `[A]` opener + landing for product literacy / create |

**Code names:** `tonight_scar` · `share_spark` · `personal_edge`  
Legacy alias: `day_survival` / `[C]` → `tonight_scar` during migration.

---

## 2. Asset stack

| ID | Name | Runtime | Job | L-Talks pilot |
|----|------|--------:|-----|---------------|
| **D1** | Tonight’s Scar | **45–60s** target; **soft warn >90s**; **hard max 120s** | Daily episode: return tomorrow + one Door | **Primary** · Day-1 gold (Anya CapCut) **~88s** accepted |
| **D2** | Share Spark | **12–20s** | Mute-safe Peak crop | Sibling of D1 |
| **D3** | Personal Edge | **8–15s** | Hard-side “MY Double…” | After D1 CapCut proven (§7) |
| **[A]** | Opener | ~60s | Product literacy + create | Unchanged |
| **[B]** | `day_normal` | — | Cast habitat directory | **Paused** |

### 2.1 Village place plates (interiors)

Reusable **empty** eye-level stills of Doubland locations (cafe, dorm, Willows, classroom, …). CapCut / Remotion use them for **job+place cards**, habitat under Stake, and social / hunt backgrounds — not as one-off per trailer art.

**Paths**

| Kind | Path |
|------|------|
| Finished plates | `generative_agents/video/assets/village/interior/` (+ `exterior/` when needed) |
| Manual Phaser layout crops | `generative_agents/video/assets/phaser/_moodboard/` (see README there) |
| Maze furniture inventory | `…/village/interior/_room_inventory.md` |
| Paste-ready prompts | `…/village/interior/_interior_prompts_TODO.md` |

**Commission order (required)**

```
0. Manual Phaser top-down of THAT property → save under phaser/_moodboard/
1. generate_room_inventory.py          (maze furniture → LAYOUT)
2. generate_interior_prompts.py        (Grok prompts + Phaser gate notes)
3. Grok Imagine: Phaser layout + style frame + continuity interior
4. Save plate → register EXISTING_INTERIORS → re-run 1–2
```

| Rule | Detail |
|------|--------|
| **Manual Phaser only** | Hand-capture or hand-crop the property top-down. **Do not** auto-crop from `1-village-birdeye.png` (too low-res; clips neighbors). |
| **Unlabeled crop** | Never feed `raw/*_labeled.png` into Imagine (text confuses generation). |
| **Register the crop** | Add filename to `SECTOR_PHASER_LAYOUT` or `ARENA_PHASER_LAYOUT` in `generate_interior_prompts.py`. Missing crop → prompt emits **BLOCKED**. |
| **Imagine ref stack** | (1) manual Phaser layout · (2) `_style_frame_master.png` · (3) continuity plate (e.g. `cafe_int_counter.png`) |
| **Two cameras OK** | Same building may ship 2 plates (e.g. Willows pharmacy counter + grocery aisle) like cafe counter + dining. |
| **Empty room** | No people / Doubles in place plates — cast goes on later hero/moment layers. |

**the_ville Phaser crops on disk (examples):** `2-hobbs-cafe.png` · `3-dorm.png` · `4-oak-hill-library.png` · `willows-market.png` · `oak-hill-college-classroom.png` · `Harvey-Oak-Supply-Store.png` · `johnson-park.png` · houses/apts/pub/artists co-living under `phaser/_moodboard/`.

Historical / opener detail: `../archive/sot-video-history.md` §TODO-O.

---

## 3. D1 — Tonight’s Scar

### 3.1 Job

Make **tonight’s unfinished social scar** feel personal, then hand the viewer **one Door** into live proof. Not a full-day recap. Not a product demo.

### 3.2 Roles

| Role | Definition |
|------|------------|
| **Peak** | Share-turn person (what changed / who won) |
| **Cost / protagonist** | Person the open question and Door are about (usually who paid / left) |
| **Satellite** | Named only if causal (§5.1) |

Peak and Cost **may be different people**. Cold quiz must still yield **one clear lead**.

### 3.3 Production order

```
1. Moment pick from locked ledger (§8)
2. Lock Peak + Cost + open question + Door
3. Draft VO from beat map (§9) — not encyclopedia spine
4. Meaning-lock in VO_LOCKED.md
5. CapCut / Remotion bins fit to locked VO (§10)
6. TTS / mix / end card
7. Export Spark; write scar.json for Day N+1 (§4)
```

**Default this pilot:** CapCut fits **picture to VO**. Do not generate against legacy `narration_v12` encyclopedia prompts.

### 3.4 Sacred VO beats (every night)

1. Want (concrete, tonight)  
2. Pressure (kid-plain fork)  
3. Turn (ledger result)  
4. Cost (human, dignified)  
5. Honest open question  
6. One Door  

**Day 1 only — Stake literacy (after mute Hook):**

1. ≤1 concept clause — e.g. *These are Doubles — AI versions of real people, making choices no one wrote for them.*  
2. ≤1 season-stakes clause — e.g. *Fifteen of them entered Survival mode: someone is voted out every night until one remains.*  
3. Then follow + wants  

**Later nights:** no concept / Survival primer. Scar chip → follow (optional) → wants (§4).

### 3.5 Kill list

| Kill | Do instead |
|------|------------|
| Nightly `concept_reset` / Survival primer | Day 1 Stake only |
| Spoken stamp walls (job+place+want ×N) | Visual job/place cards + spoken want/behavior |
| Separate challenge-teach scene | Bodies + ≤1 caption; consequence-first VO |
| Mid-body product UI | Never |
| Dual CTA (watch + create) / create sermon | One Door; soft mirror usually omit |
| Full-day chronological completeness | Moment pick; if score &lt;18 → shorter clip, not encyclopedia |
| “Previously on” recap | Scar chip (§4) |
| Hollow third name (no causal beat) | Picture-only or omit |
| RNG / “dice decided” as thesis | Personality-led choice under pressure |
| All-cinematic daily (no Phaser) | Required 2D↔3D literacy (§3.6) — plant + Peak/Cost dive + Door tease |

### 3.6 Visual rules

- Job + place on **cards / lower-thirds**, not spoken directory. Prefer real **village place plates** (§2.1) under Stake / habitat beats when the featured workplace exists on disk.  
- Cast: **1 protagonist + ≤2 satellites**.  
- **2D↔3D literacy (L8) — required every D1 ship** (detail: `daily-2D-3D-blend.md`):  
  1. **Phaser plant** — ≥1 early beat (Stake / Survival literacy on Day 1; scar chip or follow on later nights) that shows the **live sim look** (top-down Phaser / schematic sprites). Silent — no new VO.  
  2. **Peak/Cost bridge** — ≥1 **camera dive** (2D → cinematic) on Pressure, Peak, **or Cost**; prefer **Cost** when the scar is a leave/boot. Optional **pixel fracture** back to Phaser before the next graphic.  
  3. **Door tease** — ≥1 short Phaser beat at/under the Door so `doubland.ai` matches the watch surface.  
  4. **Caps** — ≤3 silent cinematic punctuations on arc beats; establishing (namecards, census, end-card lockup) stay cards/2D, not a full movie world.  
  5. **Fail** — all-cinematic picture with zero Phaser = bait-and-switch vs live product; do not ship.  
- Dignity: warm narrator; boot = cost not punchline; no pile-on.

### 3.7 Door / CTA

End card always includes `doubland.ai` (reuse opener end-card motion where possible).

| Priority | Copy |
|----------|------|
| 1 | Cliff / open question (required) |
| 2 | Door (required) — pilot OK: *Watch every conversation, challenge, and vote live at doubland.ai.* Prefer *Watch tonight at doubland.ai* when click hits a real surface |
| 3 | Soft mirror — usually **omit** |
| 4 | Create sermon — **forbidden** |

Picker may store intended `door.type` for eng while `artifact_id` is null. **No fake deep links.** Speak a specific Door only when the URL hits that surface.

### 3.8 Pass bar (cold drop-in)

After one watch: lead · want · pressure fork · turn · cost · open question · Door.  
Soft secondary: “would you text a friend.” Hard acquisition stays on Spark / `[A]`.  
**Simulation literacy:** viewer must recognize that live Doubland looks like Phaser (pixel map / sprites), and that cinematic beats are *inside* that world — not a different product.

---

## 4. Continuity (Scar Chain)

### 4.1 Lock gate

1. Operator **locks Day N** before drafting Day N+1.  
2. Engine day index: Survival Day 1 = engine `--day 2`.  
3. CapCut **blocked** without Day N−1 `scar.json` — regenerate from ledger + locked meaning; do not paste yesterday’s full VO.

### 4.2 `scar.json` (write on lock)

Required fields:

| Field | Purpose |
|-------|---------|
| `thesis` | ≤12 words |
| `featured` | Peak + Cost ids/names |
| `elim` / status deltas | Who left / power spent |
| `open_question` | Unfinished thread |
| `door` | type / label / url used |
| `challenge_type_taught` | Shorten teach on later nights |
| `chip_one_liner` | ≤12 words for next Stake |
| `unfinished_thread` | 1 line |
| `coverage_queue` | Alive never-featured ids |

### 4.3 Viewer scar chip (later nights)

| Layer | Rule |
|-------|------|
| **Picture** | **Default on** — one card, one idea (left / power spent / census), ≤2.5s in bin B |
| **Spoken** | **Optional (A/B)** — ≤1 clause if tonight’s want needs last night’s status; **skip** if Hook already carries debt |
| **Forbidden** | “Previously on” montage; Day-1 literacy replay |

Chip must be cold-readable without having watched Day N−1.

### 4.4 Author vs CapCut packs

| Role | Gets |
|------|------|
| **Writer** | Day N−1 **full** locked VO + `scar.json`; optional N−2/N−3 **chip + spine only**; Day N ledger (sole facts); coverage board. Full last-3 VOs = optional skim later — never paste into Stake |
| **CapCut** | `scar.json` + tonight locked VO + F1 recall cards for tonight’s featured (+ tagged picture satellites) |

---

## 5. Cast & season coverage

### 5.1 Spoken cast

**Default: Peak + Cost.** Follow line: *Today we’re following [Peak] and [Cost].*  
Drop Follow if scar chip already named both.

| Rule | Detail |
|------|--------|
| Third named | Only if causal to same pressure→turn→cost **and** ≥1 verb beat before Cost |
| Else | Picture-only — no spoken name |
| Cap | 1 protagonist + ≤2 satellites |

### 5.2 Bonding (themness)

**Want × costly choice × face** — not job stamps, not clinical vibe labels.

| Spoken | Picture |
|--------|---------|
| Tonight-want / behavior for featured | Name card + optional job/place chip + choice body + reaction |

Hard-side “MY Double…” → **D3**, not D1 VO.

### 5.3 Peak ≠ Cost VO

Name Peak + what happened + **≤1 want clause if it explains the turn**. No spoken job/place.

### 5.4 Challenge VO

Consequence-first (e.g. Shield = immunity from **tonight’s** vote). Day 1 may include clock + name + fork in one breath. Later nights: shorter if type already taught. Teach while bodies act; ≤1 caption.

### 5.5 “Featured ≥1×”

**Counts:** D1 spoken Peak **or** Cost, **or** shipped **D3**.  
**Does not count:** unnamed group texture; name-and-drop without a verb beat.

### 5.6 Coverage SLA

| Layer | Rule |
|-------|------|
| **Soft** | Never-featured preference on **ties** / last seat / picture-only — **never** demote a clearer ≥18 Peak/Cost pair |
| **Hard** | Every Double gets ≥1 **D3** before they leave **or** by mid-season (whichever first). Leave-face Edge OK if never edged before |

Maintain a **Cast Coverage Board** (Double × D1 Peak/Cost/picture · D2 · D3 · elim). If many alive stay at 0 features → Edge sprint, not D1 cast expansion.

### 5.7 First-feature memory

On `lock_day_script`: write F1 history for **picture/recall** (job/place chips). Spoken full stamps stay **off**.

---

## 6. D2 — Share Spark

| Field | Rule |
|-------|------|
| Source | Crop from D1 Peak (+ minimal Stake if needed) |
| Runtime | 12–20s |
| VO | Optional; prefer caption / mute-safe |
| Content | One sendable beat — no stamps, rules, or CTA ladder |
| End | ≤1s `doubland.ai` |
| Export | Auto-sibling when D1 locks |

---

## 7. D3 — Personal Edge

| Field | Rule |
|-------|------|
| Audience | Hard-side / cast-adjacent |
| Runtime | 8–15s |
| Content | One attributable moment for **one** Double |
| Caption | Name + moment + “our season” — not product education |
| Counts as featured | Yes (§5.5) |
| **L-Talks sequence** | Prove **Day-2 D1 CapCut** (1–2 nights), **then** parallel **2–3 Edges** for never-featured **same week** |

Do not expand D1 spoken cast to meet coverage.

---

## 8. Moment picker

### 8.1 Score (1–5 each)

| Scored | Tie-break only |
|--------|----------------|
| Face · Themness · Break · Stakes · Mute | Failure clarity · Authorship |

**Max 25. Ship if ≥18.** Prefer Themness ≥4.  
If best &lt;18: shorter D1 or flag gap — **not** encyclopedia fallback.  
Veto: **founder**; Anya may flag.

### 8.2 Pick order

1. Score candidates.  
2. Lock Peak + Cost.  
3. Never-featured soft preference on ties only.  
4. Do not demote clear Peak/Cost for fairness.

### 8.3 Picker JSON (normative contract)

**Roles are first-class.** `peak_id` = Share-turn person; `cost_id` = Door / open-question person (SOT §3.2). Peak and Cost may differ. Both are required to ship.

**Retired:** treating a lone `protagonist_id` as Peak. Legacy `protagonist_id` is a **Cost alias only** (maps to `cost_id`). Do not invent Peak from `satellite_ids`.

```json
{
  "asset": "tonight_scar",
  "sim_code": "…",
  "engine_day": 2,
  "peak_id": "uuid-or-name",
  "cost_id": "uuid-or-name",
  "satellite_ids": ["uuid-or-name"],
  "share_peak": {
    "beat_id": "…",
    "ledger_refs": ["…"],
    "one_line": "…"
  },
  "open_question": "…",
  "door": {
    "type": "vote_chat | farewell | chat_double | challenge_scrub | homepage",
    "label": "Watch tonight at doubland.ai",
    "intended_label": "Open tonight’s vote chat",
    "artifact_id": null,
    "url": "https://doubland.ai"
  },
  "scar_chip": { "from_day": null, "one_line": null, "spoken": false },
  "unfinished_thread": null,
  "coverage_queue": [],
  "scores": { "face": 0, "themness": 0, "break": 0, "stakes": 0, "mute": 0 }
}
```

**Day 1 V6 example:** `peak_id` = Irene Dove · `cost_id` = Ivan Pitts.

Human override until picker quality is proven.

---

## 9. VO contract & templates

### 9.1 Gold specimen

**Day 1 locked text:** `VO_LOCKED.md` §V6 — do not silently rewrite. CapCut/TTS for Day 1 cut to that text.

### 9.2 Beat map

| # | Beat | Day 1 | Later nights |
|---|------|-------|--------------|
| 0 | Hook | Mute face/move — no VO | Same |
| 1 | Stake | Concept + Survival | Picture scar chip; spoken clause optional (A/B) or skip |
| 2 | Follow | Peak + Cost names | Optional if chip named them |
| 3 | Wants | One line each | Protagonist required; Peak if causal |
| 4 | Pressure | Challenge name + fork + tonight consequence | Shorter if known |
| 5 | Peak | Winner / power — tonight-only | Same |
| 6 | Mid | Optional generic social→votes (no invented blocs) | Only if ledger supports |
| 7 | Cost | Votes / leave + Peak ballot if true | Same |
| 8 | Census | Optional N→N−1 | Elim nights |
| 9 | Cliff | Power spent + open tomorrow | Specific debt, not season essay |
| 10 | Door | Catalog or “Watch tonight…” | Same until deep links |

**Spine aid:** `[Cost] needed [want] — but [pressure]. When [Peak turn], it cost [Cost], and now [open question].`

### 9.3 Slot template (Day N)

```
[Day 1 only] These are Doubles — AI versions of real people, making choices no one wrote for them.
[Day 1 only] [N] of them entered Survival mode: someone is voted out every night until one remains.
[Later] [Picture scar chip — CapCut default]
[Later] [Optional spoken scar ≤1 clause — A/B]

Today we’re following [Peak] and [Cost].   ← drop if chip already named both
[Peak] [tonight-want / behavior].
[Cost] [tonight-want / behavior].

[Challenge: name + fork + tonight consequence]
[Peak turn]
[Optional mid: generic social → votes]
[Cost: votes / leave — Peak ballot if true]
[Optional census]
[Cliff: specific unfinished debt]
[Door]
```

### 9.4 Day N ops checklist

```
1. Day N−1 locked (scar.json + VO_LOCKED section). CapCut blocked without packet.
2. Author pack: N−1 VO + scar.json; optional older chips; Day N ledger; coverage_queue.
3. Moment pick ≥18; Peak/Cost lock; soft coverage on ties only.
4. Draft VO from §9.2–9.3 (Day-1 literacy OFF after Day 1).
5. Scar chip: picture on; spoken on/off for this night (A/B).
6. Fact audit + cold quiz.
7. Meaning-lock → VO_LOCKED.md.
8. CapCut bins → TTS @ 1.2× (warn >90s, fail >120s). Day-1 literacy may land longer than later nights.
9. Export Spark; write scar.json; update coverage board.
10. After Day-2 CapCut proven: queue D3 Edges (§7).
```

Creative chain: screenwriter → engagement (Door) → videoproducer. Pull realitytv only if mechanics are open.

---

## 10. CapCut / Remotion bins

Bin times are **guides**. Peak may steal runtime from Pressure.

| Bin | Guide | Picture | VO — Day 1 | VO — later |
|-----|------:|---------|------------|------------|
| **A Hook** | 0–3s | Mute Cost or Peak face/move | None | Same |
| **B Stake** | 3–12s | Day 1: **name cards (G8)** + optional job/place chip ≤2s + **habitat plates (G1/G2)** from §2.1. Later: scar chip ≤2.5s → name cards | Concept → Survival → follow → wants | Chip → optional spoken → follow → wants |
| **C Pressure** | 10–35s | Challenge bodies (**G3**); ≤1 caption; never-featured faces OK without VO names | Challenge teach | Shorter if known |
| **D Peak** | 35–50s | Peak reaction **hold** (**G4**) | Turn / power | Same |
| **E Cliff+Door** | 50–60s | **Ballots (G6)** / leave dignity (**G5**) / **census (G7)**; end card | Cost + census + cliff + Door | Same |

Reminder tax ≤ ~3.5s; protect ≥8s Pressure for bodies.

### 10.1 Picture kit commission (G1–G8)

**Worked example (ship):** Survival Day 1 · sim `20260713-1` · package `generative_agents/data/20260713-1/trailer_ready_day2/` · Anya sheet `CAPCUT_EDIT_SHEET.md` · bins `clip_kit/bins/`.  
**Ops detail / automation notes also mirrored:** `../opening/TODOs-opening-trailer.md` § Automate CapCut picture gen.

CapCut **fits picture to locked VO**. Commission stills / micro-clips into bins A–E — do not wait on Remotion.

#### Commission table (normative beat → asset)

| ID | Priority | Beat (VO) | Bin / drop | Medium (default) | Fact / picture lock |
|----|----------|-----------|------------|------------------|---------------------|
| **G1** | A | Peak want | `B_stake/{peak}_habitat.png` | Still (or 1–2s loop) | Sim **workplace** + face + §2.1 place plate (not marketing cards) |
| **G2** | A | Cost want | `B_stake/{cost}_habitat.png` | Still (or 1–2s loop) | Same |
| **G3** | A | Challenge teach | `C_pressure/challenge_*.mp4` | **Still → 1–2s clip** | Gather arena; hold/fold from ledger; unique per-Double micro-moves; **no winner crown** |
| **G4** | A | Peak / turn | `D_peak/{peak}_*.png` | Still (or 1–2s hold) | Peak hero + winning fact; soft BG OK; same set continuity as G3 when same arena |
| **G5** | A | Cost / leave | `E_cliff_door/{cost}_leave.png` | Still (or 1–2s) | Dignity exit; cooler/evening light if vote is evening; **no celebration pile-on** |
| **G6** | B | “every Double casts a ballot” | `E_cliff_door/ballots.mp4` | **Still → 1–2s clip** | Hands + blank ballots @ evening gather; faces soft/partial; **no alliance labels / named tallies** |
| **G7** | B | Census N→N−1 | `E_cliff_door/census_* .png` | Still | Prefer **group matrix with elim face dimmed** (+ optional quiet `N → N−1`); else card-flip graphic |
| **G8** | B | “Today we’re following…” | `B_stake/{peak\|cost}_namecard.png` | Still | Face-led name plate; **names only** — no job/place stamps baked into art (chips stay CapCut-optional) |

**Day 1 V6 defaults that shipped:** G6 hands→bowl @ Hobbs evening · G7 dim one face on `group_photo` + quiet `15 → 14` · G8 Irene / Ivan name plates.  
**Ship bar:** Priority **A (G1–G5)** required for a good first cut. **B (G6–G8)** upgrades the mid/census/follow beats — ship when ready; stock Village/Talk/Family remain interim bridges only.

#### Hard locks (fail the job if missing)

1. **Fact lock** — Peak/Cost, workplaces, gather arena, challenge cards / hold·fold, elim identity → ledger / `stamp_facts` / picker. Never invent.  
2. **Identity lock** — attach exact baseline portrait(s) as Imagine refs (`_refs/*_face.png`). Prompt-only “X-like” is reject.  
3. **Location lock** — attach empty §2.1 interior plate for habitat / gather.  
4. **VO / story lock** — picture serves the locked line; bonding = habitat under wants; G3 teaches rule before G4 win; Cost stays dignified.

#### Two-step Grok Imagine (required for motion)

Per [xAI video generation](https://docs.x.ai/developers/model-capabilities/video/generation) / [image-to-video](https://docs.x.ai/developers/model-capabilities/video/image-to-video):

| Step | Output | Rule |
|------|--------|------|
| **1. Still** | Hero frame 9:16 → `*_ref.png` / bin still | All face + place refs attached; photoreal; no text overlay unless the beat is a **name card (G8)** or quiet census numeral (G7) |
| **2. Clip** | 1–2s MP4 from that still | `POST /v1/videos/generations` · model `grok-imagine-video-1.5` · `image.url` = data URI · `duration` 1–2 · `aspect_ratio` `9:16` · motion prompt = tension + **unique** per-person micro-moves · preserve faces/set |

Auth: `XAI_API_KEY`. Stills-only beats (typical G1/G2/G4/G5/G7/G8) stop after step 1 unless Anya asks for a micro-loop.

#### Automation stages (eng)

```
locked VO + picker/ledger
  → emit CAPCUT_EDIT_SHEET + JSON job list (G1…G8)
  → stage clip_kit/_refs/ (faces + interiors)
  → for each job: prompt template → still (+ optional i2v)
  → human eyeball / gate → mark READY on sheet + clip_kit.json
  → zip: sheet + vo_locked + narration mp3 + bins/
```

**Do not automate yet:** CapCut timeline XML; inventing facts when ledger fields are missing (fail instead); Remotion replacement for Anya’s cut.

**Quality rejects:** marketing job/place on habitat · face drift · wrong interior · G3 winner crown / G5 celebration · identical gestures on multi-body clips · i2v without freezing the approved still.

---

## 11. Eng pipeline & schema

### 11.1 Phases

| Phase | Status / action |
|-------|-----------------|
| **0 Doctrine** | This SOT + V6 gold locked |
| **1 Manual Clip Kit** | **Proved Day 1 V6** — G1–G8 picture kit + CapCut sheet (`trailer_ready_day2/`). Next nights: repeat §10.1 from picker + locked VO |
| **1b Picture gen automation** | Codify §10.1 (`build_capcut_picture_kit` / Imagine still + optional i2v) — see §14 |
| **2 Remotion** | After 3–5 approved kits: picker props → bins A–E → auto Spark |
| **3 Doors + Edge** | Wire deep links; generate D3 per coverage SLA |

**Do not** port `narration_v12` / concept→stamps→teach into Remotion.  
**Do not** implement `[B]`.  
**Do not** rebuild spoken stamp pipeline.

### 11.2 Data / CLI

| Concern | Rule |
|---------|------|
| Fact ledger | Absolute — no invented drama |
| `lock_day_script` | Writes picker JSON + scar + F1 history; D1 bin schema |
| Spicy / coverage | Picker input only — not VO chapters |
| `intro_mode` | Picture recall OK; spoken full stamp **off** |
| Narration cache | New family e.g. `tonight_scar_v1` — do not reuse encyclopedia keys |
| Legacy encyclopedia path | Flag `legacy_day_survival_encyclopedia=false` by default |

**`script.json` scene ids:** `hook | stake | pressure | peak | cliff_door`

### 11.3 Legacy map

| Old (`sot-video.md` / TODO) | This SOT |
|-----------------------------|----------|
| `[C]` full-day recap | D1 scar episode |
| L10 &lt;120s | D1 45–60s target; hard max **120s** (was 75; relaxed 2026-07-23 for Anya gold / auto-gen) |
| L11 spoken stamps | Visual cards + want/behavior |
| L13 scars | Scar chip + `scar.json` |
| Encyclopedia Remotion polish | Do not block on stamp plates |

Fold into main `sot-video.md` when Remotion + CapCut templates are proven.

---

## 12. Validators

| Check | Pass |
|-------|------|
| Hook ≠ concept | First 3s = face/move, not “Doubles are…” |
| Share peak | `share_peak` non-null; Peak bin non-empty |
| Runtime | D1 ≤**120s** hard; warn &gt;**90s**; target 45–60s (later nights prefer tighter) |
| VO budget | Soft ~90–160 @ 1.2×; Day-1 literacy may run longer |
| No RNG thesis | Banlist |
| Door | `door.label` + url/artifact |
| Stamp VO | Fail ≥2 consecutive spoken job+place directory lines |
| Cast VO | Fail third name without causal verb beat |
| Scar chip | No “Previously on” stack; spoken ≤1 clause; picture ≤ one idea |
| Coverage | Soft preference must not override ≥18 Peak/Cost |
| Peak ballot | Prefer naming Peak’s ballot on Cost when ledger-true |
| Spark | Queued on D1 lock |
| Dignity | Existing ethics gates |
| **2D↔3D literacy** | Fail if zero Phaser plant **or** zero Peak/Cost dive **or** Door has no Phaser tease; fail if &gt;3 cinematic arc punctuations; fail all-cinematic cut |

Shared Part I checks (9:16, LUFS, visual-change rate, end card): `../sot-video.md` §9.

---

## 13. Guardrails

- Fact-lock absolute  
- Teen dignity — no humiliation-as-hook, no FOMO create pressure  
- Doors only to **shipped** artifacts  
- Personal Edge non-spam; no “tag 5 friends” dark patterns  
- Masked cohort rules unchanged (L7)  
- **No all-cinematic daily** — Phaser plant + Peak/Cost dive + Door tease are ship gates (§3.6 / §12)

---

## 14. DEV backlog

1. Schema: `tonight_scar` picker JSON + `script.json` bin ids; bump narration cache key.  
2. Flag: legacy encyclopedia spine **off** by default.  
3. Remotion stub: bins A–E (reuse opener end-card / music patterns).  
4. Auto-export Share Spark from Peak.  
5. Door props + deep-link table (wire when FE ready).  
6. `scar.json` writer on lock + CapCut gate.  
7. Coverage board + D3 queue after Day-2 CapCut proven.  
8. **Picture kit automation (§10.1):** emit GENERATE jobs from picker + locked VO → stage `_refs/` → Imagine still (+ i2v for G3/G6) → gate → `clip_kit.json` + Anya zip. Prompt templates per G1–G8 family.  
   - **Started 2026-07-23:** `video/picture_kit_jobs.py` + `prompt_families_picture_kit.md`; Day-1 gold forensics under `double-ivan/video/daily/gold/20260713-1_day1_anya/`. Next: still generator + human READY; HUD families optional until taste lock.  
9. **Do not:** spoken stamp pipeline; `[B]`; encyclopedia Remotion as blocker; invent facts when ledger fields are missing.

Creative CapCut for Day 1 V6 **G1–G8 READY** — Anya can cut; further nights reuse the same commission table.

---

## 15. Changelog

| Date | Change |
|------|--------|
| 2026-07-16 | Tonight’s Scar asset split — temp daily SOT created (COS `2026-07-16-003`). |
| 2026-07-17 | V6 Day-1 gold + two-featured cast (COS `2026-07-17-001`). |
| 2026-07-17 | Day 2+ Scar Chain + coverage SLA A–E (COS `2026-07-17-002`). |
| 2026-07-17 | **Normative cleanup** — single DEV contract; history moved to `archive/SOT-new-daily-history.md`. |
| 2026-07-17 | **§8.3 Peak/Cost first-class** — `peak_id` + `cost_id` required; retire `protagonist_id`-as-Peak; legacy `protagonist_id` = Cost alias only. |
| 2026-07-18 | **§2.1 Village place plates** — commission interiors only after a **manual** Phaser property top-down (`phaser/_moodboard/`); no auto-crop from village birdseye; maze LAYOUT + Imagine ref stack; CapCut B Stake prefers habitat plates when on disk. |
| 2026-07-18 | **§10.1 Picture kit G1–G8** — CapCut commission table + fact/identity/location locks; two-step Grok Imagine (still → 1–2s i2v for G3/G6); Priority A required / B upgrades; Day 1 V6 kit proved (`trailer_ready_day2/`); automation stages + DEV backlog item 8. |
| 2026-07-20 | **§3.6 / §12 2D↔3D literacy mandatory** — every D1 ship: Phaser plant + Peak/Cost dive (≥1) + Door Phaser tease; ≤3 cinematic arc punctuations; all-cinematic cut fails validators; matches CapCut practice (`trailer_ready_day2` F_phaser pack). |
| 2026-07-23 | **Runtime relaxed** — D1 hard max **120s** (was 75); soft warn **>90s**; target still 45–60s. Anya CapCut Day-1 gold **~88s** accepted as creative north star (`daily/gold/20260713-1_day1_anya/`). Auto-gen may flex up to 120s. |
