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
   - [11.4 Auto-gen daily trailer (end-to-end)](#114-auto-gen-daily-trailer-end-to-end)  
   - [11.5 Gold Remotion replay (Day-1 north star)](#115-gold-remotion-replay-day-1-north-star)  
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
| **D1** | Tonight’s Scar | **`short` (default):** 45–60s target; soft warn >90s; **hard max 120s**. **`long` (experiment):** deeper featured character/drama; strawman warn >150s / hard **180s** until founder locks — explicit `length_mode=long` only | Daily episode: return tomorrow + one Door | **Primary** · Day-1 gold (Anya CapCut) **~88s** accepted |
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

**Product path (E4):** **Remotion** ships nightly production. CapCut is the **gold-create** tool when a new trailer type needs a higher bar (Anya cut → forensics → Remotion re-assemble). Picture always fits **locked VO**. Do not generate against legacy `narration_v12` encyclopedia prompts.

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
| Spoken stamp **walls** (job+place+want ×N directory) | **One** spoken role+place clause per featured first-intro + day-projection want; habitat picture under it (§3.6) |
| Challenge teach with invented rules art | Teach pack from `sot_challenges.md` §5.1–§5.2 + G3 bodies; kid-plain VO before title celebration |
| Mid-body product UI | Never |
| Dual CTA (watch + create) / create sermon | One Door; soft mirror usually omit |
| Full-day chronological completeness | Moment pick; if score &lt;18 → shorter clip, not encyclopedia |
| “Previously on” recap | Scar chip (§4) |
| Hollow third name (no causal beat) | Picture-only or omit |
| RNG / “dice decided” as thesis | Personality-led choice under pressure |
| All-cinematic daily (no Phaser) | Required 2D↔3D literacy (§3.6) — plant + Peak/Cost dive + Door tease |

### 3.6 Visual rules

- **Featured role intro (VO):** first time a Double is featured (or Survival Day 1), spoken VO includes **one** kid-plain **job + place** clause (e.g. “Irene Dove is a barista at Hobbs Cafe”). Sit that line on **habitat** still/clip (G1/G2 / §2.1 plates). Day-projection **want** may follow in the same stamp window. Returnees → short recall (no full role re-read). Not a multi-sentence bio wall.  
- Job/place **cards / lower-thirds** remain optional picture support — do not replace the spoken role clause on first feature.  
- Prefer real **village place plates** (§2.1) under Stake / habitat beats when the featured workplace exists on disk.  
- **Challenge teach:** resolve `today.challenge.id` → trailer teach pack in `double-docs/sot/sot_challenges.md` §5 (VO brief + visual library). Specimen: `hold_for_shield`.  
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

Picture always fits **locked VO**. Commission stills / micro-clips into bins A–E for CapCut gold cuts **and** Remotion staging — Remotion does not wait on CapCut XML.

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

**Product path (N3 + N6):** picture runs inside `run_tonight_scar` / `build_clip_kit --auto-picture` — stills + G3 i2v + auto READY for G1–G5 + G8; sim cache reuse. No mid-pipeline human READY stop.

```
locked VO + picker/ledger
  → (debug only) python -m video.picture_kit_jobs <package> --write
  → auto_picture_kit: refs → cache hydrate → stills → READY → G3 i2v
  → clip_kit / NightlySurvival props
```

**Do not automate:** CapCut timeline XML as a product path; inventing facts when ledger fields are missing (fail instead); silently overwriting meaning-locked VO.  
**Do automate (landed):** N3 auto picture + N6 one-command wrapper. Manual `mark_picture_jobs` remains for debug / taste overrides only.

**Quality rejects:** marketing job/place on habitat · face drift · wrong interior · G3 winner crown / G5 celebration · identical gestures on multi-body clips · i2v without freezing the approved still.

---

## 11. Eng pipeline & schema

### 11.1 Phases

| Phase | Status / action |
|-------|-----------------|
| **0 Doctrine** | This SOT + V6 gold locked |
| **1 Manual Clip Kit** | **Proved Day 1 V6** — G1–G8 picture kit + CapCut sheet (`trailer_ready_day2/`) |
| **1b Picture gen automation** | **N3 shipped** — `auto_picture_kit` auto G1–G5 + G8 + G3 i2v + sim cache (§14 item 8) |
| **1c Gold Remotion replay** | **Shipped for Day-1 gold** — CapCut CSVs → `build_gold_replay_props` → `DailyGoldReplay` (§11.5). Phone-watch bar |
| **1d One-command nightly** | **N6 shipped** — `run_tonight_scar` (§11.4); human check = final MP4 |
| **2 Remotion (generic night)** | **Prove on new sims** — cold Day-1 on `20260724-2` after place refs (N5) |
| **3 Doors + Edge** | Wire deep links; generate Personal Edge per coverage SLA |

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

Fold into main `sot-video.md` when Remotion nightly (Phase 2) is proven. CapCut stays gold-breakdown reference only (E4) — not a second product template path.

### 11.4 Auto-gen daily trailer (end-to-end)

**Repos:** `generative_agents` (code + assets + Remotion).  
**Doctrine / gold forensics:** this file + `double-ivan/video/daily/gold/`.  
**Product job:** D1 Tonight’s Scar (§3) — picture fits **locked VO**, not the reverse.

**N6 (2026-07-30):** One command runs package → auto picture → nightly. Mid-pipeline human READY is **not** a hard stop — N3 auto-marks G1–G5 + G8. Human check after ship = **final MP4 phone-watch** only. Still required as *inputs* (not mid-pipeline gates): Peak/Cost, meaning-locked VO text, locked narration audio + timing, fact ledger.

```
sim (Supabase + transport)
  → fact ledger in package (or overview sibling)     (facts only)
  → tonight_scar picker (Peak + Cost)                (§8.3)
  → draft VO (optional) → meaning-lock → vo_locked   (§9 · VO_LOCKED.md)
  → locked narration audio + narration_timing.json   (never re-TTS a locked take)
  → python -m video.run_tonight_scar …               (N6 wrapper)
       ├─ build_clip_kit (--auto-picture)            (§10 · N3)
       └─ run_nightly_survival (NightlySurvival)     (§11.4 / E4)
  → human phone-watch final MP4
  → export D2 Spark · write scar.json · coverage board
```

#### Module map (`generative_agents/video/`)

| Module | Role |
|--------|------|
| `run_tonight_scar.py` | **N6 one-command:** ledger + picker + locked VO → clip_kit + nightly |
| `tonight_scar_schema.py` · `tonight_scar_picker.py` | Picker JSON validate / load / save · Peak/Cost resolve |
| `tonight_scar_script.py` | Bin-shaped `script.json` from picker + VO |
| `draft_tonight_scar_vo.py` | LLM or template VO draft (`tonight_scar_v1` cache family) |
| `day_scar.py` | `scar.json` build / prior-scar gate |
| `build_clip_kit.py` | CapCut-ready package: bins A–E, VO hash, draft scar, manifest · `--auto-picture` |
| `validate_clip_kit.py` | Kit completeness before Remotion |
| `auto_picture_kit.py` · `picture_kit_jobs.py` | N3: auto G1–G5 + G8 stills + G3 i2v + sim cache |
| `generate_picture_stills.py` · `mark_picture_jobs.py` · `xai_imagine.py` | Still / i2v backends (manual READY only for debug) |
| `run_nightly_survival.py` · `validate_nightly_survival.py` | Validate → props → snapshot → `NightlySurvival` |
| `NIGHTLY_CRAFT_GAP.md` | Phase A gap freeze: gold vs day props + nightly checklist |
| `assets/challenges/<challenge_id>/` | Challenge teach visual bank (see `sot_challenges.md` §5) |
| `promote_legend_assets.py` | CapCut-used legend → stable names (E5) |
| `cinematic_pack.py` | C1–C8 resolve · opener beds (+ Phaser `signature_flyover`) |
| `compose_trailer.py` · `showrunner.py` | Opener stakes montage uses pack beds |
| `build_gold_replay_props.py` | **Day-1 gold:** CapCut CSVs → Remotion props + staged media |
| `build_day_remotion_props.py` · `render_day_remotion.py` | Generic night Remotion path (legacy / forensics) |
| `lock_day_script.py` | Lock gate: picker + scar + F1 history |
| Remotion `NightlySurvival` / `DailyGoldReplay` | Ship composition / gold phone-watch bar |
| `audio/sfx/` · `audio/music_intrigue_loopable.mp3` | Stock SFX stand-ins + loopable bed |
| `fly-over/` C1–C8 | Cinematic village pack (world-plate swaps + opener) |
| `assets/legend_promoted/<sim>/<day>/` | Stable promoted legend winners (+ `UNUSED.md`) |
| `assets/cohort/<slug>/` | Group photo, matrix, seat_map, portraits |

#### Nightly CLI skeleton (new Survival day)

Engine day index: **Survival Day 1 = engine `--day 2`**. Paths assume repo root = `generative_agents`.

```bash
# 0) Facts — place fact_ledger.json under data/<sim>/trailer_ready_dayN/
#    (or pass --fact-ledger pointing at an overview_dayN* sibling)

# 1) Optional: draft VO only (never overwrites vo_locked.txt)
python -m video.run_tonight_scar <sim_code> --day <engine_day> \
  --peak "<Peak>" --cost "<Cost>" --draft-vo-only [--template-only]

# 2) Meaning-lock — approve text into package vo_locked.txt
#    (+ narration audio + narration_timing.json; never re-TTS a locked take).
#    Mirror into double-ivan/video/daily/VO_LOCKED.md when freezing a gold night.

# 3) One command ship (N6) — auto picture + nightly Remotion
python -m video.run_tonight_scar <sim_code> --day <engine_day> \
  --peak "<Peak>" --cost "<Cost>" \
  --vo data/<sim>/trailer_ready_dayN/vo_locked.txt \
  --length-mode short          # Day-1 parity bar: --length-mode long
#    Props-only dry run: add --skip-render
#    No xAI calls (hydrate/cache only): --no-picture-generate
#    Day-1 CapCut → DailyGoldReplay (§11.5) = forensics / phone-watch bar only.

# --- Lower-level steps (debugging; usually unnecessary) ---
# python -m video.build_clip_kit <sim> --day N --picker … --vo …
# python -m video.run_nightly_survival data/<sim>/trailer_ready_dayN
# python -m video.validate_nightly_survival <package_dir>
```

#### Package layout (CapCut kit)

```
data/<sim_code>/trailer_ready_dayN/clip_kit/   # or package-dir override
  vo_locked.txt · narration*.mp3
  tonight_scar_picker.json · script.json · scar.json (draft→lock)
  CAPCUT_EDIT_SHEET.md · clip_kit.json / manifest
  picture_kit_jobs.json · picture_stills_queue/   # D3 still path
  bins/
    A_hook/  B_stake/  C_pressure/  D_peak/  E_cliff_door/
    F_phaser/          # 2D literacy plant / door tease
    video/             # master/proxy exports when present
    capcut_proj/       # CapCut draft (gold only)
    F_Anya-legend/     # raw legend dump (gold source; retain)
# Stable promoted winners (E5) live outside the kit:
#   generative_agents/video/assets/legend_promoted/<sim>/<day>/
```

**Gold package (Day 1 V6):**  
`generative_agents/data/20260713-1/trailer_ready_day2/clip_kit/`  
**Forensics (no large binaries):**  
`double-ivan/video/daily/gold/20260713-1_day1_anya/` — see `GOLD.md` · `CANONICAL_PATHS.md` · `capcut/`.

#### Immutable auto-gen rules

1. **Fact-lock** — ledger / picker only; fail if Peak, Cost, challenge, or elim identity missing.  
2. **VO-lock** — picture and Remotion timing fit locked text; never invent VO in props builders.  
3. **Prior scar gate** — CapCut / kit for Day N blocked without Day N−1 `scar.json` (§4).  
4. **No encyclopedia spine** — do not call `narration_v12` / stamp walls / concept-reset nightly.  
5. **2D↔3D literacy** — every ship needs Phaser plant + Peak/Cost dive + Door Phaser tease (§3.6 / §12).  
6. **Snapshot before overwrite** — never clobber a founder-approved MP4 without copying first (`out/gold_replay_day1_YYYYMMDD_*.mp4` or `scripts/snapshot_and_render_gold.ps1`).  
7. **Runtime** — default `length_mode=short`: target 45–60s; soft warn >90s; hard max **120s**; Day-1 gold ~88s accepted. Experimental `long`: strawman warn >150 / hard 180 until founder locks; never silently exceed short max on the short lane.  
8. **Challenge teach pack** — VO + visuals from `sot_challenges.md` §5 when pack exists; missing → warn + soft fallback.  
9. **Picture READY** — N3 auto-marks Priority A (G1–G5 + G8); mid-pipeline human READY is **not** a ship gate. Human gate = final MP4 phone-watch (N6).

### 11.5 Gold Remotion replay (forensics bar)

**Product ship path for every Survival night (including Day-1 rebuilds) is §11.4 `run_tonight_scar` → `NightlySurvival`.** This section is the CapCut→Remotion forensic replay used as the craft phone-watch bar until nightly matches it.

Rebuilds the **Anya CapCut Day-1 gold** timeline in Remotion so eng can iterate HUD/craft without reopening CapCut. This is the **proven production re-assembly path for the locked V6 cut** (E4) — not yet the generic “any night” generator (Phase 2 / §14 item 9). CapCut kits remain the gold-create input when a new type needs a human cut first.

#### One-command rebuild

```bash
cd generative_agents   # ivan/dev or feature branch

# Always snapshot prior best before overwrite
# scripts/snapshot_and_render_gold.ps1   # or manual copy of out/gold_replay_day1.mp4

python -m video.build_gold_replay_props
# optional: --gold-dir <double-ivan gold package> --clip-kit <clip_kit path> --dry-run

cd video/remotion
npx remotion render DailyGoldReplay out/gold_replay_day1.mp4 \
  --props=props/gold_replay_day1.json

# Smoke stills (examples)
npx remotion still DailyGoldReplay out/gold_replay_smoke.png \
  --props=props/gold_replay_day1.json --frame=90
```

| Artifact | Path |
|----------|------|
| Props builder | `video/build_gold_replay_props.py` |
| Unit tests | `video/test_build_gold_replay_props.py` |
| Props JSON | `video/remotion/props/gold_replay_day1.json` |
| Staged media | `video/remotion/public/gold_replay/` |
| Composition | `DailyGoldReplay` (`video/remotion/src/DailyGoldReplay.tsx`) |
| Output | `video/remotion/out/gold_replay_day1.mp4` |
| CapCut machine extracts | `double-ivan/…/gold/20260713-1_day1_anya/capcut/*.csv` |
| Snapshot helper | `generative_agents/scripts/snapshot_and_render_gold.ps1` |

#### What the props builder does

1. **Ingest** CapCut media / text / audio CSVs (+ summary duration).  
2. **Stage** resolved files into `public/gold_replay/` (clip_kit + legend + SFX stand-ins).  
3. **World-plate swaps** (`WORLD_PLATE_REPLACEMENTS`) — wrong geography → C1–C8 pack under `video/fly-over/`:  
   - Alpine / open-roof plates → **C1** `c1.2.mp4` (day overhead, animated)  
   - Night overhead beat → **C3** prefers **C2.mp4** (animated dusk) until a true `C3.mp4` exists; static `C3.png` is fallback only  
   - Phaser `signature_flyover` **never** swapped (plant / door literacy)  
4. **Phase-1 HUD grammar** (`apply_phase1_hud_grammar`) — founder craft locked against gold:  
   - Poster hold + matrix · `DOUBLAND.AI` label · LIVE top + N ACTIVE bottom  
   - Survival stamp (pre-cropped red) · progressive STEP bands · want HUDs  
   - Alliances **two-beat**: (A) `panel_under_title` Conversations→Alliances + Talk; (B) consecutive step only — **Alliances→Votes** plate (not full triple cascade)  
   - Fifteen→fourteen: grey-wash **Ivan seat 3.3** (soul15 seat_map; not CapCut seat 1.1)  
   - End VO stretch: full-bleed `cover` heroes under CC (not empty letterbox)  
   - End lockup: square CapCut card padded to **9:16 black** (`end_lockup_9x16.png`) + cover — no matte seams  
5. **SFX / FX** — CapCut stock names → local `video/audio/sfx/` stand-ins; craft FX list (scan / shake / hit).  
6. **Music** — loopable intrigue bed + CapCut volume envelope.  
7. **End punch** — swoosh + lockup; VO finishes brand line then short empty pad; soft music fade under hold.

#### Group-photo seat standard (visual integrity)

Canonical stack for soul15 (and any regen): **top = C back · mid = B · bottom = A front**.  
**Ivan = seat 3.3** (front center) · **Nick = 1.3** (back center).  
SOT file: `video/assets/cohort/soul15_seed_20260224/seat_map.json`.  
Builder: `video/assets/scripts-prompts/build_soul15_cast_plate.py` (`STACK_ORDER = ("c","b","a")`).  
Never flip A to the top on regen — that caused Ivan-row drift across plates.

#### Gold vs generic night

| | Gold replay (§11.5) | Generic night (Phase 2) |
|--|---------------------|-------------------------|
| Input | Frozen CapCut CSVs + V6 VO | Picker + locked VO + clip_kit bins |
| Picture | Replays Anya timeline + eng polish | Bins A–E + G1–G8 + §11.5 craft lift |
| When to use | Day-1 bar, craft regression, founder phone-watch | Nightly Remotion ship (product path) |
| Do not | Rewrite V6 VO; skip snapshot | CapCut XML as product; skip scar gate |

Hub detail: [`gold/20260713-1_day1_anya/GOLD.md`](gold/20260713-1_day1_anya/GOLD.md).

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
8. **Picture kit automation (§10.1):** ✅ N3 — `auto_picture_kit` auto G1–G5 + G8 stills + G3 i2v + sim cache; CLI defaults on `build_clip_kit` / `run_nightly_survival`. Manual READY = debug only.  
9. **Gold replay → generic night (daily auto path):** ✅ Phase A–E0 + N6 `run_tonight_scar`. **Next:** prove cold Day-1 on new sims (`20260724-2`); place refs N5. Gap freeze: `generative_agents/video/NIGHTLY_CRAFT_GAP.md`.  
10. **C3.mp4** — true night overhead motion plate (until then C3 beat uses C2.mp4).  
11. **E4 product path (locked 2026-07-29):** **Remotion** is long-term production. CapCut is gold-breakdown reference only — new trailer types: Anya gold → forensics → Remotion re-assemble. No CapCut XML product path.  
12. **Challenge teach packs:** commission remaining catalog IDs after `hold_for_shield` specimen (`sot_challenges.md` §5.2).  
13. **Length experiment:** produce `short` + optional `long` for feedback; lock long budgets after N nights.  
14. **Do not:** spoken stamp **walls**; `[B]`; encyclopedia Remotion as blocker; invent facts when ledger fields are missing; overwrite founder gold MP4 without snapshot.

Day 1 V6 **G1–G8 READY** — CapCut gold exists; further nights reuse the same commission table.  
**Day-1 Remotion gold replay READY** as production bar (§11.5) — `out/gold_replay_day1.mp4`. CapCut = new-type gold only (E4).

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
| 2026-07-28 | **§11.4–11.5 Auto-gen process documented** — end-to-end nightly CLI (picker → VO lock → clip_kit → CapCut/Remotion); module map; package layout; immutable rules. **Gold Remotion replay** (`build_gold_replay_props` → `DailyGoldReplay`) as Day-1 north star: world-plate C1–C8 swaps, HUD grammar (alliances two-beat, Ivan 3.3 grey-out, end VO full-bleed, 9:16 lockup pad), snapshot-before-overwrite. Seat-map stack C→B→A canonical. |
| 2026-07-29 | **E4 Remotion product lock** · opener beds → C1–C8 (`cinematic_pack.py`) · E5 legend promote (32 used) · D3 still queue + human READY CLI. Next backlog: item 9 daily auto path. |
| 2026-07-29 | **SOT body sync** — CapCut-first pilot language retired; §10.1 / §11.1 / §11.4 module+CLI map match shipped modules; CapCut = gold-breakdown reference only. |
| 2026-07-29 | **#8 Phase A/A2** — featured role intro VO; `length_mode` short/long experiment; challenge teach packs → `sot_challenges.md` §5 + `hold_for_shield` specimen; `NIGHTLY_CRAFT_GAP.md`. |
| 2026-07-29 | **#8 Phase D** — `run_nightly_survival` one-command (validate → props → literacy/length → snapshot → `NightlySurvival`); `validate_nightly_survival` gates. |
| 2026-07-30 | **N3 + N6** — auto picture kit (G1–G5/G8 + G3 i2v); `run_tonight_scar` one-command; mid-pipeline READY dropped as human hard stop; human check = final MP4. |
