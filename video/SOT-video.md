# Video SOT — Doubland trailers

> **Primary video SOT** (2026-08-28). Daily ship = **Closer tonight**. This file replaces `sot-video.md` (archive: [`../../done/sot-video.md`](../../done/sot-video.md)).  
> **Audience:** DEV / Remotion / narration / CapCut ops.  
> **Live closer format:** §9.0–§9.5. New sim bakes use `draft_closer_tonight_vo` + `check_closer_vo_facts`.  
> **Opener [A]** is a separate product — WIP [`../opening/TODOs-opening-trailer.md`](../opening/TODOs-opening-trailer.md). Do not mix opener scene maps into the daily.  
> **Paused / killed:** `[B] day_normal` (cast directory) · encyclopedia `[C]` / `[B] day_normal` recut. Short Scar is `--sku scar`, not the default.  
> **Locked VO gold:** [`VO_LOCKED.md`](VO_LOCKED.md) §V6 (Episode 1 specimen only — do not silently rewrite).  
> **History:** [`archive/SOT-new-daily-history.md`](archive/SOT-new-daily-history.md) · format-lock brief [`../../done/20260828_format_lock_closer.md`](../../done/20260828_format_lock_closer.md)

**Nav:** [Pending work](../TODO_video.md) · [Prompts](../prompts.md) · [VO locked](VO_LOCKED.md) · [Opener WIP](../opening/TODOs-opening-trailer.md)

---

## Contents

1. [Intent](#1-intent)  
   - [1.1 Trailer types (now)](#11-trailer-types-now)  
   - [1.2 Shared craft (still current)](#12-shared-craft-still-current)  
2. [Asset stack](#2-asset-stack)  
   - [2.1 Village place plates](#21-village-place-plates-interiors)  
3. [D1 — Tonight’s Scar](#3-d1--tonights-scar)  
4. [Continuity (Scar Chain)](#4-continuity-scar-chain)  
5. [Cast & season coverage](#5-cast--season-coverage)  
6. [D2 — Share Spark](#6-d2--share-spark)  
7. [D3 — Personal Edge](#7-d3--personal-edge)  
8. [Moment picker](#8-moment-picker)  
9. [VO contract & templates](#9-vo-contract--templates)  
   - [9.0 Live closer format lock](#90-live-closer-format-lock)  
   - [9.5 Bonding overlay](#95-bonding-overlay-skip-if-empty)  
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

Default daily is **Closer tonight** (long social resolution of the same night). It is **not** a full-day encyclopedia. Short Scar is `--sku scar`.

### 1.1 Trailer types (now)

| Type | Job | Status |
|------|-----|--------|
| **Closer tonight** (D1, default) | Tonight’s Peak + Cost; teach the show and a person | **Live** — this file §9 |
| **Tonight’s Scar** (`--sku scar`) | Same night, short sibling | Live sibling, not the pin |
| **[A] Opener** | Lean ~60s: what Doubland is, group cast, Survival tease at close. No per-Double spoken intros. No Survival rules in the body. | Separate product. WIP `opening/TODOs-opening-trailer.md`. Old scene map: `done/sot-video.md` §10 |
| **D2 Share Spark** | 12–20s mute-safe crop | **Not built.** Not a closer ship gate |
| **D3 Personal Edge** | Paid one-Double report | **Not built.** Not the group daily |
| **`day_normal` [B]** | Every-cast habitat directory | **Paused** |
| Encyclopedia `[C]` | Full-day recap | **Killed** |

### 1.2 Shared craft (still current)

Borrowed from the old video SOT; still true for opener and daily.

- **Frame:** 9:16 · 1080×1920 · ≥30 fps.
- **Voice:** warm narrator; never mocks the Doubles. ElevenLabs `eleven_v3` warm @ **1.2×** (API max). Pronounce Doubland as fused `Dubland` (no hyphen).
- **Mix:** ~**-14 LUFS** · true peak ≤ **-1 dBTP** · music under speech duck ~3–5 dB.
- **End card:** `doubland.ai`. Do not fake a deep link.
- **Fact-lock:** ledger and public board. Do not invent challenge, votes, or chat.
- **2D literacy (L8):** trailers train “watch Phaser, see real life.” Daily execution is §3.6 (plant + Peak/Cost dive + Door tease). Fail all-cinematic. Opener uses matrix / flyover / cutouts, not daily dives.
- **Length:** opener target ~60s. Closer follows the night (under 90s is not a fail). Short Scar 45–60 / warn 90 / hard 120. Encyclopedia still fails at any length.

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
| **D1** | Tonight’s Scar / Closer tonight | **`closer` (default):** 90–140s target; warn >165s; hard **180s**. **`scar` (`--sku scar`):** 45–60s target; warn >90s; hard **120s**. `--length-mode` is only the Remotion clock | Daily episode: return tomorrow + one Door | **Primary** · Day-1 gold (Anya CapCut) **~88s** accepted · Day-2 closer lock `trailer_9x16_closer.mp4` |
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
| “Previously on” recap / mid-body last-night vote lecture | Cost why-tonight (≤1 leftover) + cliff appointment (§9.2) |
| Hollow third name (no causal beat) | Picture-only or omit |
| RNG / “dice decided” as thesis | Personality-led choice under pressure |
| All-cinematic daily (no Phaser) | Required 2D↔3D literacy (§3.6) — plant + Peak/Cost dive + Door tease |

### 3.6 Visual rules

- **Featured role intro (VO):** default auto-gen for **every sim / cast / episode** (not a one-package polish). Every night, spoken VO includes **one** kid-plain **job + place** clause per featured Peak and Cost, then **≤1 why-tonight** clause that is the **personality that showed up in today's events** — not a challenge result (never “holds an 8”, never Shield/HOLD/Expose/Protect as the news). Cold viewers do not know the mechanic yet. **Both** Peak and Cost get that personality clause. Motive comes from tonight's `choice_reason_plain` when it has a human “I'm a … who …” line; **`roles.trait`** (innate who-clause) is the fallback when the reason is only the board move. Cost leftover heat (“the room is looking at them”) is a **fallback** only when there is still no trait. Why-tonight must sound like **spoken English people actually use**. Never “a read she can trust” / “wants a lock X can trust” / “She names him because…”. Never a challenge-slug slogan that would repeat every Silent Pact / Lock-In night. Sit both clauses on the **habitat clip** (G1/G2 `.mp4`) after the namecard — do not cut still → clip (that freeze is a reject). If no clip exists, the still may fill the same window. Sit why-tonight on a short **want HUD** that **stamps that same personality line** (e.g. TESTS BELIEFS / PROTOTYPES / SHIPS / BUILDS) — never generic TONIGHT when a trait line exists, never the board move. Never `{Name} is back.` Not a multi-sentence bio wall. Skip why-tonight only if there is no reason and no innate trait.  
- Job/place **cards / lower-thirds** remain optional picture support — do not replace the spoken role clause on first feature.  
- Prefer real **village place plates** (§2.1) under Stake / habitat beats when the featured workplace exists on disk.  
- **Challenge teach:** resolve `today.challenge.id` → trailer teach pack in `double-docs/sot/sot_challenges.md` §5 (VO brief + visual library). Specimen: `hold_for_shield`.  
- Cast: **1 protagonist + ≤2 satellites**.  
- **2D↔3D literacy (L8) — required every D1 ship.** Morph / true camera-dive craft is **post-MVP** ([`TODO_2D-3D.md`](TODO_2D-3D.md)); do not redesign it on tonight’s closer.  
  1. **Phaser plant** — ≥1 early beat (Stake / Survival literacy on Day 1; scar chip or follow on later nights) that shows the **live sim look** (top-down Phaser / schematic sprites). Silent — no new VO.  
  2. **Peak/Cost bridge** — ≥1 Phaser beat on Pressure, Peak, **or Cost**; prefer **Cost** on leave/boot (`{cost}_leave_phaser` → cinematic leave). A cinematic namecard/habitat alone is not the bridge.  
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

### 9.0 Live closer format lock

**Status:** Live. New sim bakes (`--sku closer`, default) must fill this shape. Episode 1 Ivan/Alex (`double-video/data/20260823-2/trailer_ready_day2`) is a **specimen** of version 1, not the cut to rewrite. Do not `--force` / `--replace-vo-lock` that package.

Hybrid job every night: **teach the show and a person.** Not a tutorial-only recap. Not a quiet movie with almost no voice.

- **Show framework:** Doubles line every night (first-time viewers land on a random episode); someone is voted out every night; tonight’s game in one breath; a vote happened; someone left; one-breath census; a Door to the live village.
- **Personal touch:** two people at work, hands if we have them, one real choice, a dignified leave, a last line about someone still in tomorrow.
- **Bonding beats (§9.5):** kid-plain (a 12-year-old). Status first, then why / who asked / when if the ledger has it. Never invent. Never “are locked.” Length is not the cap.
- **Voice on pictures:** every picture in the body has spoken words under it. The only planned silence is the first few seconds (a face moving, no talking). After that, voice stays on.

**Every night, keep (once):** `These are Doubles — AI versions of real people, making choices no one wrote for them.` Do not say “unscripted” / “no one knows how it ends” again later. The choice in the night has to prove it.

**Episode 1 / first Survival night (engine `--day 2`):** Survival primer (`{N} entered. Someone is voted out every night until one remains.`). Short challenge how-to. Alliances→votes teach + ballot line. Then people.

**Later nights:** `{N} still in. Someone is voted out every night.` Then jobs. Do **not** replay the alliances sermon. Shorter game line if this challenge type was already taught.

Beat order for speech (empty beats skip; do not invent; do not pad; do not drop G7): Doubles → Survival stake → body in a place → hands at the job if we have it → personality that showed up today if we have it → tonight’s game → one choice → leave → one-breath census (`{N} become {N−1}`) under G7 → last line → Door. Census is show-framework, not the feeling.

**Last line (required):** name someone **still in** tomorrow. Default: tonight’s Peak, walking in without tonight-only power (the Shield does not go with them). If Cost leftover names a living person, past tense leftover + come back for the living name. Never: “someone else leaves,” “new alliances will form,” “we’ll miss them,” come-back-for-the-boot.

**Required emotional hooks:** at least **2** of: one real choice (tonight’s reason, kid-plain, no rank), last words, inner vote why, living last line. The last line is always one of them. Hold-for-Shield Peak: `{Name} would rather …` then `She/He wins the Shield.` Quiet nights still need two hooks — do not ship choice-only or last-line-only.

**Length:** follows the night. Under 90s is not a fail. Fail = pad, village recap, or no real choice. The §2 90–140 / hard 180 band is a historical closer clock, not a fail-under-90.

**Ship gate:** missing `vo_locked_long.txt` auto-locks from `draft_closer_tonight_vo`. Bake fails if `check_closer_vo_facts` does not see Doubles, the living last line, ≥2 hooks, Day-1 vs later alliances, and Peak choice/win when the ledger has them. Bake also fails “are locked” and “trust score” / “trust level.” Pictures: same G1–G8 jobs. Do not redesign 2D↔cinematic on this contract. Share clip (Spark) and timestamp cards are **not** this SKU.

**Pass after one watch:** a stranger can name the two people; they got the show (vote-out, tonight’s game, someone left); they felt one choice; they would send it; they want tomorrow for a named living person.

### 9.1 Gold specimen

**Day 1 locked text:** `VO_LOCKED.md` §V6 — do not silently rewrite. CapCut/TTS for Day 1 cut to that text.

### 9.2 Beat map

| # | Beat | Day 1 | Later nights |
|---|------|-------|--------------|
| 0 | Hook | Mute face/move — no VO | Same |
| 1 | Stake | Concept + Survival | Doubles concept + `{N} still in Survival mode. Someone is voted out every night.` (N = `15 −` prior boots; same math as G7) |
| 2 | Follow | Peak + Cost names | Skip “following two of them”; Peak then Cost |
| 3 | Wants | One line each | Job+place every night (returnee included), then ≤1 why-tonight each. Why-tonight = personality revealed today (not the card rank / Hold / Expose / Protect). Innate `roles.trait` if the reason is only the board. Cost leftover is last fallback. Want HUD stamps that line. Never `{Name} is back.` Skip why-tonight only if no reason and no innate. |
| 4 | Pressure | Challenge name + fork + tonight consequence | `Tonight's game is {name}.` + steps_board order |
| 5 | Peak | One real choice from tonight’s reason (kid-plain, no rank), then winner / power — tonight-only. Hold for the Shield win line is `{She/He} wins the Shield.` | Same |
| 6 | Mid | Alliances→votes teach + ballot line | **Skip** the alliances sermon. Vote still lands on Cost tally. Last-night heat is Cost why-tonight, not a recap |
| 7 | Cost | Votes / leave + Peak ballot if true | Same. Last words sit on the leave walk (loop 1×), not a freeze |
| 8 | Census | Fifteen become fourteen | `{N} become {N−1}` under G7. Keep G7. One breath. |
| 9 | Last line | Someone **still in** tomorrow (default: Peak without tonight-only power, e.g. walks in without the Shield). If Cost leftover names a living person, past tense leftover + come back for the living name. Never “someone else leaves,” “new alliances will form,” “we’ll miss them,” or come-back-for-the-boot. | Same |
| 10 | Door | Catalog or “Watch tonight…” | Same until deep links |

**Spine aid:** `[Cost] needed [want] — but [pressure]. When [Peak turn], it cost [Cost], and now [open question].`

### 9.3 Slot template (Day N)

```
[Every night] These are Doubles — AI versions of real people, making choices no one wrote for them.
[Day 1] Fifteen of them entered Survival mode: someone is voted out every night until one remains.
[Later] {N} still in Survival mode. Someone is voted out every night.

[Day 1] Today we are following two of them.
[Every night] [Peak] job+place. [Peak] personality that showed up today (not the board result).
[Every night] [Cost] job+place. [Cost] personality that showed up today (leftover only if no tonight trait). Never `{Name} is back.`

Tonight's game is [challenge]. [Day 1: short how-to. Later: one breath; skip steps_board sermon]
[One choice from tonight's reason — Peak first. Kid-plain; no rank. Example: Olivia would rather show who is playing than hide and let chance decide.]
[Peak turn. Hold for the Shield: She/He wins the Shield.]
[Day 1 only] As the day continues, conversations turn into alliances. Alliances turn into votes.
[Day 1 only] At the end of the day, every Double casts a ballot.
[Cost: Tonight {N} people name {Cost}. Never "the vote splits." Then leave — Peak ballot if true]
[Day 1] Just like that, fifteen become fourteen.
[Later] {N} become {N−1}.
[Last line: named living person still in tomorrow — default Peak without tonight-only power]
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

### 9.5 Bonding overlay (skip-if-empty)

These beats exist so a stranger **cares about a person**, not a board. They sit on the locked spine. They are **not** a second framework.

**How every bonding beat speaks**

1. **Kid-plain.** A 12-year-old gets it. No Lock-In / rank / trust-score / “are locked.”
2. **Status, then context.** First breath is what is true. Second breath is **why**, **who asked**, or **when** — only if `alliances.confirmed`, `alliance_log`, `vote_reasons`, `choice_reason_plain`, or `final_statement` has it.
3. **Skip if empty.** Omit the beat or the extra breath when the field is missing. Do not invent. Do not pad. The night still ships.
4. **Bonding over the clock.** Do not cut these lines to hit 90s.

| Beat | Status line (kid-plain) | Extra breath when the ledger has it | Skip when | Picture |
|------|-------------------------|--------------------------------------|-----------|---------|
| **One doing** | Hands at this person’s job (`doing_plain` only). | Where / when of that ritual, if a safe field exists. | No `doing_plain`. Never invent from `job_action`. Never “I held a card.” | G1 / G2 habitat |
| **Relationship weather** | `{A} and {B} have each other's backs.` from `alliances.confirmed` (Peak pair first, else Cost; skip Peak+Cost boot pair). | Why they teamed up, who asked, or when (`They teamed up on day one.`). Prefer why, then who, then when. | No confirmed pair. Episode 1 often empty. Not `public_board`. | Hold on habitat |
| **One choice** | `{Name} would rather … than …` from tonight’s reason. No rank. | The reason *is* the why. Do not add a slogan after it. | No `choice_reason_plain` / `absent`. | G3 / G4 |
| **Inner vote why** | Peak names Cost in spoken English. No mind-read. | Peak’s stated `vote_reasons` (unreadability, leftover heat, or a short kid-plain first sentence). | No Peak→Cost `vote_reasons`. | G5 / G6 |
| **Last words** | Cost’s own `final_statement`, cut for speech. Dignity. | The speech *is* the why. Do not compress to a recap slogan. | Missing, empty, or engine-clone essay. | G5 loop 1× |
| **Living last line** | Named person still in tomorrow. | Cost leftover that names a living person, if present. | Never skip the last line. Never the boot. | Peak habitat / cliff |

**Also skip (do not invent):** Cost “played and lost” when `choice_reason_plain` is `absent`; personality clause when no why-tonight after fallbacks; a clean pile-on when `safe_vo` is split/messy; chat as a deal log; narrator mind-read (`felt / realized / in my heart`).

**Ship:** `check_closer_vo_facts` fails “are locked” and “trust score” / “trust level” in the long lock. Habitat job+place and the required last line still run.

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
| **G3** | A | Challenge teach | `C_pressure/challenge_*.mp4` | **Still → clip** | Gather arena; unique faces; tokens **visible as objects**; **ranks not phone-readable** (backs / inward). Winning numeral lives on **G4 Peak**, not G3. **No winner crown**. |
| **G4** | A | Peak / turn | `D_peak/{peak}_*.png` | Still (or 1–2s hold) | Peak hero + winning fact; soft BG OK; same set continuity as G3 when same arena |
| **G5** | A | Cost / leave | `E_cliff_door/{cost}_leave.png` | Still (or 1–2s) | Dignity exit; cooler/evening light if vote is evening; **no celebration pile-on** |
| **G6** | B | “every Double casts a ballot” / “then the vote” | `E_cliff_door/ballots.mp4` | **Clip (loop)** | Hands + blank ballots @ evening gather; faces soft/partial; **no alliance labels / named tallies on the plate**. Later nights **copy** Day-1 G6 (seed from prior kit / `video/assets/nightly/ballots.mp4`). Never Cost habitat as the vote bed. Split nights overlay `vote_split_board.png` / drawn `vote_tally` (count + `NAME {First}`) — tally lives on the overlay, not the G6 plate. Do not insert C1 `world_plate` under this beat. |
| **G7** | B | Census N→N−1 | `E_cliff_door/census_matrix_pre.png` + `census_matrix_post.png` | Remotion still | **ACTIVE DOUBLES** identity-card grid (`CensusMatrix`). Seat order = group photo C→B→A (do not flip A to the top). Prior boots show `DISCONNECTED` from the first frame; tonight’s Cost is the only tile that changes. Quiet `N → N−1` on the post frame. Auto-gen renders stills on bake from sibling-night ledgers (`15 − n_priors`). Gone portrait = stock silhouette. **Never grey-wash. Never `imported/`.** |
| **G8** | B | “Today we’re following…” | `B_stake/{peak\|cost}_namecard.png` | Still | Face-led name plate; **names only** — no job/place stamps baked into art (chips stay CapCut-optional) |

**Day 1 V6 defaults that shipped:** G6 hands→bowl @ Hobbs evening · G7 dim one face on `group_photo` + quiet `15 → 14` · G8 Irene / Ivan name plates.  
**Later nights (locked 2026-08-21):** G6 = seeded ballots clip + split tally overlay. G7 = identity-card grid (see row above). Habitat intro = namecard + mp4. Day-1 gold-replay grey-wash of Ivan 3.3 (§11.5) stays forensics-only.  
**Ship bar:** Priority **A (G1–G5)** required for a good first cut. **G6 and G7 auto-seed on bake** (prior kit or `video/assets/nightly/`). G8 from N3. Stock Village/Talk remain interim only when a named beat has no kit file.

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

This file **is** the main video SOT (2026-08-28). CapCut stays gold-breakdown reference only (E4) — not a second product template path. Old taxonomy / opener scene map: `done/sot-video.md`.

### 11.4 Auto-gen daily trailer (end-to-end)

**Repos:** `generative_agents` (code + assets + Remotion).  
**Doctrine / gold forensics:** this file + `double-ivan/video/daily/gold/`.  
**Product job:** D1 Tonight’s Scar (§3) — picture fits **locked VO**, not the reverse.

**N6 (2026-07-30):** One command runs package → auto picture → nightly. Mid-pipeline human READY is **not** a hard stop — N3 auto-marks G1–G5 + G8. Human check after ship = **final MP4 phone-watch** only. Still required as *inputs*: Peak/Cost + fact ledger. **VO (2026-08-21):** default SKU is Closer tonight. If `vo_locked_long.txt` is missing, auto-gen from the closer writer (leftover = Cost why-tonight + cliff; never a mid-body last-night vote recap). Never write `vo_locked.txt` from that path. Short Scar (`--sku scar`): if `vo_locked.txt` is missing, auto-gen from the short writer. Never overwrite an existing lock unless `--replace-vo-lock` (re-TTS that package). TTS when audio is missing, or when the lock was just replaced.

```
sim (Supabase + transport)
  → fact ledger in package (or overview sibling)     (facts only)
  → tonight_scar picker (Peak + Cost)                (§8.3)
  → vo lock: closer keeps/auto-locks vo_locked_long.txt; short uses vo_locked.txt (§9)
  → narration audio + timing: keep if present; else TTS the lock
  → python -m video.run_tonight_scar …               (N6 wrapper)
       ├─ build_clip_kit (--auto-picture)            (§10 · N3)
       └─ run_nightly_survival (NightlySurvival)     (§11.4 / E4)
  → human phone-watch final MP4
  → export D2 Spark · write scar.json · coverage board
```

**G7 auto-gen (locked 2026-08-20):** `seed_nightly_kit_from_priors` renders Remotion `CensusMatrix` stills into `clip_kit/bins/E_cliff_door/census_matrix_{pre,post}.png`. Prior boots = every earlier `trailer_ready_day*` ledger (not yesterday only). Count = `15 − n_priors`. Do not copy a previous night’s mock stills. Recipe prefers those files over `group_photo_{cost}_out.png`. Hook 15→14→1 HUD (`census_15_to_1.mp4`) is a different beat.

**G6 auto-gen (locked 2026-08-21):** the same seed copies `ballots.mp4` into `E_cliff_door` from a prior kit, else stock `video/assets/nightly/ballots.mp4` (new sim Episode 1). Recipe plays that clip from “That’s the challenge. Then the vote.” through the split. Never Cost habitat. Split/messy nights also write `vote_split_board.png` (`vote_tally`). Do not insert C1 `world_plate` under the vote.

**Habitat intro (locked 2026-08-21):** `habitat_lock.py` maps ledger job+place → Ville interior for G1/G2. Recipe is namecard then habitat **`.mp4`** for the whole featured window (no still→clip freeze). Kit stems are full-name slugs.

#### Module map (`generative_agents/video/`)

| Module | Role |
|--------|------|
| `run_tonight_scar.py` | **N6 one-command:** ledger + picker + locked VO → clip_kit + nightly |
| `tonight_scar_schema.py` · `tonight_scar_picker.py` | Picker JSON validate / load / save · Peak/Cost resolve |
| `tonight_scar_script.py` | Bin-shaped `script.json` from picker + VO |
| `draft_tonight_scar_vo.py` | Consecutive-night VO skeleton from ledger (`tonight_scar_v6`); census gate |
| `habitat_lock.py` | Job+place → Ville interior + kit slug (G1/G2) |
| `day_scar.py` | `scar.json` build / prior-scar gate |
| `build_clip_kit.py` | CapCut-ready package: bins A–E, VO hash, draft scar, manifest · `--auto-picture` |
| `validate_clip_kit.py` | Kit completeness before Remotion |
| `auto_picture_kit.py` · `picture_kit_jobs.py` | N3: auto G1–G5 + G8 stills + G3 i2v + sim cache |
| `census_vacant_matrix.py` · Remotion `CensusMatrix` | G7 identity-card stills (pre/post) — bake, not mock |
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

# 1) Optional: preview VO draft only (never overwrites vo_locked.txt)
python -m video.run_tonight_scar <sim_code> --day <engine_day> \
  --peak "<Peak>" --cost "<Cost>" --draft-vo-only [--template-only]

# 2) One command ship (N6) — auto-locks the active SKU VO if missing,
#    TTS if audio missing, auto picture + nightly Remotion.
#    Existing vo_locked_long.txt / vo_locked.txt is kept unless --replace-vo-lock.
python -m video.run_tonight_scar <sim_code> --day <engine_day> \
  --peak "<Peak>" --cost "<Cost>"
#    Default: Closer tonight (vo_locked_long.txt → trailer_9x16_closer.mp4).
#    Short Scar: add --sku scar (vo_locked.txt → trailer_9x16.mp4).
#    --length-mode is the Remotion clock only (default long).
#    Pass --vo only to copy an external lock in.
#    --no-auto-vo restores the old hard-stop if vo_locked is missing.
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
data/<sim_code>/
  picture_kit_cache/          # sim shelf (N3 habitats/namecards + polish promoted/)
  trailer_ready_dayN/
    edit_script.json          # optional founder polish SOT (Post-Production)
    clip_kit/
      vo_locked.txt · narration*.mp3
      tonight_scar_picker.json · script.json · scar.json (draft→lock)
      CAPCUT_EDIT_SHEET.md · clip_kit.json / manifest
      picture_kit_jobs.json · picture_stills_queue/   # D3 still path
      imported/               # day shelf — founder polish one-offs
      bins/
        A_hook/  B_stake/  C_pressure/  D_peak/  E_cliff_door/
        F_phaser/          # 2D literacy plant / door tease
        video/             # master/proxy exports when present
        capcut_proj/       # CapCut draft (gold only)
        F_Anya-legend/     # raw legend dump (gold source; retain)
# Stable promoted winners (E5) live outside the kit:
#   generative_agents/video/assets/legend_promoted/<sim>/<day>/
# Cohort cast plates (group photo / matrix / portraits):
#   generative_agents/video/assets/cohort/<slug>/
```

**Gold package (Day 1 V6):**  
`generative_agents/data/20260713-1/trailer_ready_day2/clip_kit/`  
**Forensics (no large binaries):**  
`double-ivan/video/daily/gold/20260713-1_day1_anya/` — see `GOLD.md` · `CANONICAL_PATHS.md` · `capcut/`.

#### Media resolve (Live = Rebuild)

Post-Production Live preview and eng Rebuild share one ladder so phone MP4 matches Live:

1. Package `src` (`clip_kit/imported/…`, bins)  
2. Logical aliases in `edit_script` cuts:
   - `sim_cache/picture/<rel>` → `data/<sim>/picture_kit_cache/<rel>` (sim-reusable polish + N3 cache)
   - `sim_cache/cohort/<rel>` → `video/assets/cohort/<slug>/<rel>` (cast plates; optional leading slug)
3. Challenge teach pack / role→bin maps  
4. Safety net: `remotion/public/nightly_survival` + `gold_replay` basenames (encode scratch — not SOT)

**Save (Post-Production):** promotes Live-only soft-miss files into **sim** (`sim_cache/picture/promoted/`) or **day** (`clip_kit/imported/`) shelves, rewrites `cut.src`, and **drops unreferenced** polish-owned files from those shelves (sim `promoted/` only when unused by sibling night packages too). Rebuild preflight **warns** (does not block) when picture cuts remain unresolved. VO/SFX paths unchanged (day package + eng stock).

**Do not** treat `nightly_survival/` leftovers as the long-term asset home — Save sync or resolve via shelves above.
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
| **Closer VO facts** (`check_closer_vo_facts`) | Fail without Doubles clause, living last line, ≥2 hooks, Day-1 vs later alliances, Peak “would rather” when the ledger has a tonight choice, Hold-for-Shield win line when Peak won |

Shared craft checks (§1.2): 9:16 · ~-14 LUFS · true peak ≤ -1 dBTP · end card `doubland.ai`. Visual-change rate is opener guidance, not a closer fail.

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
| 2026-08-29 | **§9.5 bonding overlay** — weather / doing / one choice / inner vote / last words / living last line speak kid-plain. Status then why/who/when when the ledger has it. Never “are locked.” Bonding over the 90s clock. |
| 2026-08-29 | **§3.6 2D→3D morph postponed** — keep the locked closer picture (stock flyover plant/door + Cost leave_phaser still). True Phaser-scene → cinematic morph is post-MVP, outsourced to a video producer. Brief: [`TODO_2D-3D.md`](TODO_2D-3D.md). |
| 2026-08-28 | **Primary video SOT** — this file replaces `sot-video.md` (archive `done/sot-video.md`). Borrowed still-current bits: trailer types now, 9:16 / TTS / LUFS, opener [A] as a separate product, 2D literacy in §3.6. |
| 2026-08-28 | **§9.0–§9.5 live closer contract** — format lock [A] promoted here from `20260828_format_lock_closer.md` (that brief → `done/`). Skip-if-empty overlay: doing, weather, vote-why, last words. |
| 2026-08-28 | **§9 closer ship gate** — new sim bakes auto-lock `vo_locked_long.txt` from the closer writer. `check_closer_vo_facts` fails closed without Doubles, living last line, ≥2 hooks, Day-1 vs later alliances, and Peak choice/win when the ledger has them. |
| 2026-08-28 | **§9 two emotional hooks** — every closer needs ≥2 of: one real choice (tonight’s reason, kid-plain, no rank), last words, inner vote why, living last line. Last line still required. Hold-for-Shield Peak turn is `{She/He} wins the Shield.` after the choice. |
| 2026-08-28 | **§9 closer format lock [A]** — Doubles line every night (full sentence, once). Later nights **drop** the alliances sermon (supersedes the same-day “alliances every night” row). Census stays (G7 + one breath). Last line names someone still in (default Peak without tonight-only power). Never “another Double will leave” / “new alliances will form.” Voice on after mute hook. Length follows the night; under 90s is not a fail. |
| 2026-08-28 | **§9.2–9.3 Episode 1 spine every night** — alliances→votes teach + ballot line after the Peak win, any episode. Survival stamp sits on the group photo; census HUD starts after the stamp (not a fixed 3.5s tail on a short later-night line). **Superseded for later-night mid-body by the format-lock [A] row above.** |
| 2026-08-27 | **§3.6 / §9 intro + tally** — featured why-tonight is personality revealed today for Peak **and** Cost (never “holds an 8”). Split/messy tally is `Tonight {N} people name {Cost}.` — drop the empty “the vote splits” throat-clear. |
| 2026-08-21 | **§2 / §9 / §11.4 Closer default** — daily ship is Closer tonight (`--sku closer`); short is `--sku scar`. Leftover heat is Cost why-tonight + cliff, not a mid-body last-night vote recap. Last words on the leave walk. |
| 2026-08-20 | **§9 picture+VO lock** — later nights speak Peak then Cost job+place (never `{Name} is back.`). Scar windows = first contiguous beat (teach = pressure). `--replace-vo-lock` rewrites a lock + re-TTS for that package only. |
| 2026-08-20 | **§9 / §11.4 consecutive-night VO** — Doubles + `{N} still in` are machine-spoken every later night (N = `15 −` prior boots, same as G7). Auto-lock `vo_locked.txt` when missing; never overwrite an existing lock unless `--replace-vo-lock`; fail closed on a wrong remaining-count. |
| 2026-08-20 | **§10.1 / §11.4 G7** — identity-card grid (`CensusMatrix`); auto-gen stills on bake from sibling-night priors; quiet `N → N−1`; never grey-wash / never `imported/`. Day-1 gold-replay Ivan 3.3 grey (§11.5) unchanged. |
| 2026-08-19 | **§10.1 G3** — teach tokens visible as objects; ranks not phone-readable; winning numeral on G4 Peak (COS `2026-08-19-001` Option B). |
| 2026-08-07 | **§11.4 media resolve** — Live = Rebuild ladder; `edit_script` + `sim_cache/picture|cohort` aliases; Save promotes + GCs polish shelves; `nightly_survival` safety net only. |
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
