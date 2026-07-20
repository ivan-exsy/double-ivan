> **RETIRED 2026-07-20.** Code shipped on `ivan/action-location`. Fresh-sim score: `20260720_launch.md` §20260720-1.  
> Normative contracts: `double-docs/sot/sot_action-location.md`, `sot_realism.md`, `sot_be-fe.md`.  
> This file is historical RCA + ship notes only — do not treat open-looking RCA “Fix suggestions” as backlog.

---
# TODO — Action / location & movement realism (RCA backlog)

**Status:** Code shipped on `ivan/action-location` (2026-07-20). Fresh-sim score lives in `20260720_launch.md` §20260720-1.  
**Updated:** 2026-07-20  
**Evidence sim (pre-fix baseline):** `20260717-1` (Leg 3b; RCA totals below)  
**Score next:** new sim via launch checklist — do not re-score body gates on completed `20260717-1`

**Exports (baseline):** `…/storage/20260717-1/analysis/`  
(`summary.json`, `rca_20260717_final.json`, realism/action-location scans)

**Product context:** Survival Keep / gather / §11 already PASS (`20260714_checklist.md`, retired). This file was bodies/places/labels only.

---

## Snapshot — ship status

| # | Theme | Pre-fix (`20260717-1`) | Status | Implementation (brief) |
|---|--------|------------------------:|--------|------------------------|
| **R1** | Staff-zone / counter for non-workers | Gap1 **676** · Gap2 **599** | **DONE** | Phase-8 staff-evict + post-validate; default pick skips `staff_only` for non-workers; emit prefers non-staff **label** in-arena (no body warp). Workers keep counter leaves. |
| **R2** | Label ≠ description `@` | **3154** divergences | **DONE** | Split presence vs intent at emit: travel = `(heading to X) @ presence`; stationary `@` = presence leaf (aligned with R1 display). Did **not** force label=plan. |
| **R3** | Teleport / discontinuity | TELEPORT **1818** · DISC **1894** (sr2) | **DONE** | `finalize_emit_target`: zone-anchor fallback must not undo speed clamp mid-travel; keep multi-step walk + far `target_zone` intent. Analyzer notes sr>1 DISC inflation. |
| **R4** | Chat cooldown | **504** flags | **PARTIAL** | Analyzer documented to match **end** depth tiers + arena mod + first-daily day skip. **No** gather mute. Runtime social policy unchanged; true spam → separate task after playback. |
| **R5** | Stale `Apartment N` | **5538** hits | **DONE** | Analyzer suppresses true-home Apartment text for residents (Owen/Vince/Vincent). No global rename of real homes. |
| **R6** | Piano while not playing | **18** bad · **58** play OK | **DONE** | Default/Phase-8 pick skips `affordance_required` unless action tokens match (play/practice/…). |
| **R7** | Sub-arena leaf flapping | **3+** thrash bands | **DONE** | Sticky leaf while semantic same action + modes in `{in_place, stationary, in_zone, zone_patrol}`; breaks on travel / new plan. |
| **R8** | Chat missing payload | **111** | **DONE** | Analyzer ignores `(from description)` partner shells; only structured partner + 0 utterances flags. |
| **R9** | Oscillation | **1** band | **WATCH** | No code change. |

**Still open (not code — verify on fresh sim):** human playback + Gap/TELEPORT counters per `20260720_launch.md`. Optional later: R4 end-path `computed_cooldown` if tests/product want start-path satiation stamped at end.

**Not in scope (already green on baseline scan):**
- Nested wait-wrap / `<waiting>` / truncations → **0**
- Travel-verb misclassified as in-place → **0**
- Survival gather / sleep-stuck / phantom elim → retired checklist (PASS)
- Location MVP Class-A desk-exclusion → historical green

---

## Workstreams — what we shipped

Branch: **`ivan/action-location`**. Unit green: emit finalize, Phase-8 staff evict, affordance/piano, R2 helpers, movement realism suite.

### R1 — Staff-zone — **DONE**

**Was:** Non-workers on cooking area / fridge / behind counter (Vince/Owen/Vincent heavy).  
**Shipped:** (1) `_pick_best_object_address` skips `staff_only` for non-workers. (2) Phase-8 evicts non-workers already on staff leaves and post-validates picks. (3) Emit Layer B: if tile geocodes staff but plan is customer seating same arena → prefer seating for `address_label` / `@` without moving the sprite.  
**Not shipped:** maze retile; gather force-reseat every step.  
**Verify:** Gap1/2 ↓ + Hobbs playback (`20260720_launch` §B).

### R2 — Address divergence — **DONE**

**Was:** Dual writers — `@` = plan, `address_label` = tile.  
**Shipped:** `build_presence_intent_description` + `prefer_non_staff_display_address` on movement emit. Travel keeps destination in “heading to”; `@` is presence. Stationary aligns `@` with presence.  
**Not shipped:** label always = plan (retracted — lies while walking).  
**Verify:** one-step copy honesty (`20260720_launch` §C).

### R3 — Teleport — **DONE**

**Was:** Clamp fired, then `emit_zone_anchor_fallback` snapped end into far zone (291/291 sample).  
**Shipped:** `finalize_emit_target` — mid-travel keeps clamped waypoint; zone-anchor cannot invent cross-map end; re-clamp if fallback still too far. Intent-only FE path unchanged.  
**Metrics:** DISCONTINUITY notes sample-rate artifacts; TELEPORT @ sr1 is the blink signal.  
**Verify:** multi-minute walks, no blink (`20260720_launch` §A).

### R4 — Chat cooldown — **PARTIAL**

**Was:** 504 flags; cafe deep-chat gaps real + analyzer/runtime nuance.  
**Shipped:** Analyzer docs/logic stay on **end_conversation** depth tiers (≤2→5, ≤5→15, else 30) + mod + first-daily day rollover — matches what is **stamped** at end today.  
**Not shipped:** gather pair-mute; raising cafe silence; wiring start-path satiation/`computed_cooldown` into end (pre-existing unit tests still expect that older path).  
**Verify:** playback cafe buzz without deep ping-pong; open policy task only if still spammy.

### R5 — Apartment N — **DONE** (analyzer)

**Was:** ~5.5k hits mostly true homes (Apt 1/4/5 residents).  
**Shipped:** V4 suppress when text names the persona’s own living-area apartment.  
**Not shipped:** lore rename of apartments. Residue wrong-home labels expected to fall with R2 honesty.  
**Verify:** analyzer false hits near zero on new run.

### R6 — Piano — **DONE**

**Was:** 18 non-play parked on `:piano`.  
**Shipped:** skip `affordance_required` in default object pick unless action matches affordances.  
**Verify:** coffee/wait ≠ piano; real play still works.

### R7 — Leaf flapping — **DONE**

**Was:** sticky used exact description string; leaves flipped every few steps.  
**Shipped:** sticky uses `descriptions_semantically_match` + in-place mode gate so prop holds until task/mode changes.  
**Verify:** class/cafe prop stable for a stretch; still moves when schedule moves.

### R8 — Missing chat payload — **DONE** (analyzer)

**Was:** 111 shells from description-inferred `(from description)` partners.  
**Shipped:** realism checker skips partner strings starting with `(`.  
**Verify:** no shell flood; real empty bubbles only if structured chat lacks utterances.

### R9 — Oscillation — **WATCH**

**1** band on baseline. No fix. Revisit only if playback jitters.

---

## Ship order executed (Second look)

1. ~~R3 emit-order~~ → **done**  
2. ~~R1 Phase-8 + post-validate~~ → **done**  
3. ~~R2 presence/intent copy~~ → **done**  
4. ~~R1 display prefer non-staff~~ → **done**  
5. ~~R6 piano + R7 sticky~~ → **done**  
6. ~~R4/R5/R8 analyzer truth~~ → **done** (R4 analyzer-only; no social mute)

**Retracted (still do not ship):** full BE paths as default · label=plan always · gather reseat storm · gather talk mute · second global clamp without emit-order fix · treating R5 bulk Apartment as world bug.

---

## RCA findings — 2026-07-18 (`20260717-1`)

**Method:** Re-read SOT (`sot_action-location.md` §3.3 / §7.2), emit path in the movement writer, staff gates in the location resolver, Phase-8 co-location redistribute, gather lock, chat cooldown manager, and analyzers. Re-scanned **every** `personas_coords` row per persona with proper pagination (PostgREST default page = 1000; wide windows under-count unless you page). Artifact: `analysis/rca_20260717_final.json`.

**Cast context (not a bug, but shapes the numbers):**
- Hobbs **workers** (legitimate staff leaves): Irene Dove, Max Shoemaker, Olivia King.
- Heavy non-worker staff hits: Vince Vale (classroom), Owen Logan (Willows), Vincent Slater (classroom, elim ~2310).
- Three cast members **actually live** in `Apartment N`: Owen → Apt 1, Vince → Apt 5, Vincent → Apt 4. That drives most of R5.

### Executive verdict (RCA) → ship outcome

| # | Real? | Primary root (RCA) | Outcome 2026-07-20 |
|---|-------|--------------------|--------------------|
| **R3** | Yes — true teleports | Clamp then zone-anchor undid waypoint | **DONE** — `finalize_emit_target` |
| **R1** | Yes — immersion P0 | Phase-8 + tile geocode staff leaves | **DONE** — staff-evict + pick skip + label prefer |
| **R2** | Yes — dual writers | `@` plan vs label tile | **DONE** — presence/intent copy split |
| **R5** | Mostly analyzer | True homes Apartment N | **DONE** — analyzer true-home suppress |
| **R4** | Mixed | End depth tiers real; satiation nuance | **PARTIAL** — analyzer = end tiers; no gather mute |
| **R6** | Real, small | Piano default leaf | **DONE** — affordance_required skip |
| **R7** | Real, broader | Sticky too brittle | **DONE** — semantic sticky + mode gate |
| **R8** | Mostly analyzer | `(from description)` shells | **DONE** — analyzer skip |
| **R9** | Noise | 1 band | **WATCH** |

Detail of what landed: **Snapshot** + **Workstreams** at top of this file. Score: `20260720_launch.md`. First-pass “Fix suggestions” in the subsections below are **historical RCA** — superseded by Second look + ship.

---

### R3 — Teleport / discontinuity (P0) — CONFIRMED REAL

**Re-measure (sample-rate 1, full per-persona pages):**
- Within-step teleports (>10 tiles start→end): **1216**
- Cross-step teleports (prev end → this end): **1215** (almost 1:1 with within-step — same events)
- True discontinuities (prev end ≠ this start): **0**
- Long-profile export (sample-rate 2) had TELEPORT 1818 / DISCONTINUITY 1894 — **inflated by sampling**, not by missing intermediate rows. Sample-rate is **not** the root of the player-visible blinks.

**Smoking-gun pattern (Alex Butcher 76–92):**

| Step | Mode | start→end | path[] | What it means |
|------|------|-----------|--------|----------------|
| 76 | stationary | [36,22]→[36,22] | empty | At desk |
| 77 | travel_to_zone | [36,22]→[**57,43**] | **empty** | 42-tile blink toward supply store |
| 78 | stationary | [57,43]→[57,43] | empty | Already “there” |
| 88 | travel_to_zone | [57,43]→[**36,22**] | **empty** | 42-tile blink home |
| 91 | travel_to_zone | [36,22]→[57,43] | **empty** | Same blink again |

So the backend is **persisting the destination as the step end** while claiming travel, with **no path waypoints** and jumps far above `MAX_TILES_PER_STEP` (6). Continuity of `start_pos` across steps is fine (hence disc=0); the blink is **inside** the step.

**Root causes (stacked):**
1. **Intent-only path + empty `path[]`:** FE is supposed to A* realize movement, but the coordinate SOT row still stores a far `movement` end tile in the same step — playback/forensics read that as a teleport.
2. **Missing hard clamp on emit:** There is transition-smoothing / `MAX_TILES_PER_STEP` logic in the step loop, but these rows show it is not applied to the final persisted `start_pos`/`movement` pair (or FE actuals overwrite end without intermediate steps).
3. **Not** respawn/elim for the bulk (evenly spread cast; elim only explains Vincent’s shorter row count).
4. **Not** duplicate persona rows (disc=0, clean start chaining).

**Fix suggestions:**
1. **Hard emit invariant (must-ship):** Before writing `personas_coords` / movement JSON, if Manhattan(start, end) > `MAX_TILES_PER_STEP`, either (a) clamp end to the N-th tile along the planned/FE path, or (b) refuse to advance `personas_tile` beyond the clamp and keep residual path for next steps. Never persist a >10-tile within-step jump with empty path.
2. **Always emit path for travel_to_zone** when backend knows a path; if intent-only, require FE to return `actual_path` and store **per-step actual end**, not target leaf tile.
3. **Analyzer:** Keep TELEPORT; drop or reclassify DISCONTINUITY when sample-rate > 1; document that disc≈0 on this sim means “starts chain, ends teleport.”
4. **Acceptance:** sample-rate 1 window of 800 steps → within-step >10-tile events rare outside documented snaps (wake/elim). Playback no longer crosses the map in one tick.

---

### R1 — Staff-zone non-worker resolve (P0) — CONFIRMED; three cooperating bugs

**Re-measure matches TODO:** Gap1 **676**, Gap2 **600**.  
Dominators: Vince Vale (281+224), Owen Logan (192+325), Vincent Slater (162+19).  
Objects: cooking area 514, behind cafe counter 529, fridge 90, pub bar 71.

**Every non-worker staff hit has `zone_resolution=exact_address`.**  
~**144** of the staff-desc samples are gather-lock / “heading to Hobbs” text — but the body leaf is kitchen/counter, not seating.

**Root causes:**

1. **Emit reverse-geocode (main player-visible path)**  
   Movement writer sets:
   - `description` = `{act_description} @ {act_address}` (planned intent — often `cafe customer seating`)
   - `address_label` = `maze.get_authoritative_address(next_tile)` (whatever object the **tile** is painted with)  
   Kitchen / behind-counter tiles sit inside the cafe footprint. Customer bodies that path or snap onto those tiles get a staff `address_label` even when the plan said seating.  
   SOT already warned: *“Staff-only bypass remains possible on at least one upstream assignment path where `zone_resolution=exact_address` can reach emit without post-resolution remap”* (`sot_action-location.md` §7.2). **Still open and dominant on this sim.**

2. **Phase-8 co-location redistribute has no staff filter**  
   After parallel plan, overflow personas are reassigned with `_pick_best_object_address`, which scores accessible objects **without** skipping `staff_only`. Comment in code even cites the failure mode: everyone targeting Hobbs collapses onto “behind the cafe counter.” Phase 8 then **spreads** collisions onto the next-best leaves — cooking area, fridge, sink — for non-workers. Sets `zone_resolution=exact_address` and skips full post-validate.

3. **Gather lock destination is customer-safe; realization is not**  
   Gather lock correctly forces `…:cafe:cafe customer seating`. Survival appointment still produces long **stationary** bands on cooking area / behind counter (Vince 55-step band 4531–4589, etc.). So either Phase 8 or tile reverse-geocode rewrites the leaf after the lock, or FE seats them on staff-painted tiles and BE adopts that address.

4. **Not** mis-tagged workers: Vince/Owen/Vincent `work_area` are classroom / Willows — analyzer worker bypass is correct. Olivia/Max/Irene staff hits are excluded as workers.

**Fix suggestions (path parity — do all three):**
1. **Phase 8:** Pass `unavailable` ∪ all `staff_only` objects when `not is_worker`; prefer `cafe customer seating` / non-staff leaves. After pick, run `_validate_address_post_resolution`.
2. **Emit gate:** Before finalizing `act_address` / `zone_resolution_detail`, if address is staff_only and persona is non-worker → remap (same cascade as resolver). Do **not** trust tile reverse-geocode alone for access control.
3. **Tile paint / seating:** Ensure customer seating tiles are not dual-tagged as cooking/behind-counter in maze data; or prefer planned non-staff address when actual tile is staff-only within same arena (keep body tile, fix label + future target).
4. **Gather lock:** After lock + Phase 8, assert non-worker address is non-staff; if not, force seating object.
5. **Acceptance:** Gap1+Gap2 non-worker ≪ current on 500–2600 step re-run; gather playback shows customers on seating, staff on counter only if `work_area` matches.

---

### R2 — Address-field divergence (P0) — CONFIRMED BY DESIGN (dual writers)

**Re-measure:** **3171** true conflicts (label vs `@` neither is prefix of the other).  
Top sector pair: **Oak Hill College ‖ Hobbs Cafe (1125)** — classic “label still at school, description already at cafe” during travel.  
Same-building leaf fights: Hobbs‖Hobbs 461, dorm‖dorm, library table vs bookshelf, etc.

**label vs zone_resolution_detail:** equal 56.7k · prefix 9.9k · **conflict 1823**.  
So `zone_resolution_detail` usually tracks **plan** (`@` suffix); `address_label` tracks **tile**.

**Root cause (single sentence):**  
Two intentional writers, never reconciled:
1. `execute.py` builds `description = f"{act_description} @ {act_address}"` (intent).
2. Movement emit sets `address_label = get_authoritative_address(next_tile)` (actual tile object).

During travel, tile lags plan → cross-building divergence.  
At destination, tile object ≠ planned object → same-arena leaf divergence (also feeds R1 when tile is staff).

**Not** primarily stale multi-tick fields (same step already disagrees).  
**Not** sampling artifact.

**Fix suggestions:**
1. **Product rule (pick one SOT for UI):**
   - **A (recommended):** `address_label` = planned/resolved `act_address` (post staff-validate); keep tile-derived address only under `realism_trace.tile_address` for forensics.
   - **B:** `address_label` stays tile-actual; rewrite description `@` to match label at emit (intent stays in `intent` / `zone_resolution_detail`).
2. Document the chosen rule in `sot_action-location.md` + FE-BE contract.
3. Analyzer: only flag divergence when **both** fields claim to be “display location,” post-fix.
4. **Acceptance:** same-step label vs `@` mismatch near noise; travel may show “walking to X” in text without claiming body is already at X in the label.

---

### R5 — Stale `Apartment N` (P1) — MOSTLY ANALYZER / TRUE HOMES

**Re-measure:** **5539** field hits — matches TODO order of magnitude.

| Bucket | Who | Meaning |
|--------|-----|---------|
| ~5100 description | Owen, Vince, Vincent | **`living_area` is literally `Apartment 1/5/4`** — correct home names in this baseline |
| ~378 intent/act/progress | same three | Home activities naming their apartment |
| **61 address_label** | scattered cast | **Real bug:** non-residents reverse-geocoded onto `Apartment 2` etc. (Diana/Alexis/Alex at Apt 2 tiles) |

`relabel_stale_place_text` only rewrites when address/living_area is a **Dorm** tree. Apartment residents intentionally keep “Apartment N”. Non-dorm visitors who step on apartment tiles also keep the token in `address_label`.

**Fix suggestions:**
1. **Analyzer V4:** Suppress `Apartment N` when it equals the persona’s `living_area` sector (or is a prefix). Report only cross-home / non-resident hits.
2. **Optional product:** Give Apt 1/4/5 display names (like “Owen’s flat”) in registry + relabel map — cosmetic.
3. **Real residue (61):** same as R2 — don’t adopt foreign home `address_label` from tile without privacy/home checks; or strip apartment labels for non-residents at emit.
4. **Acceptance:** V4 near-zero on **false** hits; living cast may still show their real home name.

---

### R4 — Chat cooldown (P1) — REAL SHORT GAPS + ANALYZER MISMATCH

**Export:** 504 `CHAT_COOLDOWN_VIOLATION`. **~76% at cafe** (385).  
Gap median ~14 vs effective threshold median ~28. Many deep chats (`n_exchanges` 6–8 → base 30) + Hobbs `cooldown_mod=-2` → threshold 28; pairs re-open in 0–15 steps.

**Runtime vs analyzer:**
- `end_conversation` depth tiers: ≤2→5, ≤5→15, else 30 (+ arena mod). Analyzer mirrors this.
- **Start path** also uses **satiation curve** (`_satiation_cooldown` by `times_today`) and **first-daily** bypass. Analyzer does **not** model satiation floors — some flags are false if runtime allowed a lower satiation cooldown.
- Gather density: many pairs in one arena → more legal first-daily + more illegal re-entries after deep chats.

**Fix suggestions:**
1. Align analyzer with full runtime policy (satiation + first-daily + mods) before chasing ghosts.
2. On remaining true violations: ensure every chat end calls `end_conversation` (no path that clears chat without cooldown stamp).
3. Survival gather: optional temporary cooldown floor or “already talked this gather” pair mark so vote hour isn’t re-chat spam.
4. **Acceptance:** true violations rare outside documented bypasses; cafe playback not ping-pong.

---

### R6 — Piano false positives (P2) — CONFIRMED SMALL

**Re-measure:** **18** non-play at `:piano` (Vince 10, Vincent 7, Mike 1); real play still works (~58 in original scan).

**Root:** Piano is a normal cafe object (`affordance_required=true`) but **not** staff_only. Default / Phase-8 / nearest-object pick can seat a non-play action on the piano tile. Affordance hard-gate remaps only when the action fails affordance match **and** cascade finds alternative — sticky/stationary bands can still sit on piano with coffee/wait text.

**Fix:** Exclude `affordance_required` objects from default seating / Phase-8 picks unless action tokens match affordances; prefer `cafe customer seating`.

---

### R7 — Sub-arena flapping (P2) — REAL, WIDER THAN TODO

TODO cited 3 bands; denser scan finds **many** leaf-flip runs (e.g. Alex Butcher classroom 3104–3144 with 38 flips; Max at Hobbs; bathroom thrash).

**Root:** Re-resolve / Phase-8 / tile reverse-geocode retargets object every few steps while arena stays put; sticky short-circuit keys off description equality but object can still churn via redistribute or tile paint.

**Fix:** Sticky leaf for multi-minute in-place actions unless action/anchor changes; Phase-8 only runs on true capacity overflow, not every micro-collision; don’t rewrite `act_address` from tile while stationary in-zone.

---

### R8 — Chat missing payload (P2) — MOSTLY ANALYZER / SHELL ROWS

**111** issues, detail pattern: `chatting_with=(from description) but 0 utterances`.  
Analyzer infers chat from description text when structured chat fields are empty — marks partner as `(from description)`. Often travel/social flavor text, not a real empty bubble.

**Fix:** Analyzer only flag when structured `chatting_with` is set or chat metadata present without utterances. Runtime: don’t set chat flags without payload. Playback audit before code change.

---

### R9 — Oscillation (P3) — WATCH ONLY

**1** realism oscillation band. Not player-critical on this sim.

---

### Cross-cutting architecture (why R1–R3 share DNA)

```
plan/resolve  →  act_address (intent, sometimes post-validated)
       ↓
Phase 8 redistribute  →  may pick staff leaf (no staff filter)
       ↓
move / FE realize     →  next_tile (may jump far; path often empty)
       ↓
emit:
  description @ act_address     ← intent world
  address_label @ tile object   ← actual world  }  never reconciled
  coords end = far tile         ← teleport if unclamped
```

**Post-ship (2026-07-20):** path parity for staff + presence/intent emit copy + emit-order clamp are on `ivan/action-location`. Diagram above is the **pre-fix** failure mode for RCA readers.

---

### Proposed fix workstreams → **shipped on `ivan/action-location`**

| Stream | Status | What landed (brief) | Fresh-sim done when |
|--------|--------|---------------------|---------------------|
| **W1 Movement (R3)** | **DONE** | `finalize_emit_target` — zone-anchor cannot undo speed clamp mid-travel | TELEPORT ≪ 1216 @ sr1; playback walks |
| **W2 Staff (R1)** | **DONE** | Phase-8 staff-evict + pick skip + label prefer non-staff (no body warp) | Gap1+Gap2 non-worker down sharply |
| **W3 Address copy (R2)** | **DONE** | Presence/intent emit split (`heading to` + `@` presence) | One-step text honest |
| **W4 Leaf + piano (R6/R7)** | **DONE** | Affordance_required skip; semantic sticky in-place | R6≈0; R7 thrash rare |
| **W5 Analyzer (R4/R5/R8)** | **DONE** | True-home suppress; chat-shell skip; cooldown = end depth tiers | Counts match real bugs |

Score on a **new** sim: `20260720_launch.md` §20260720-1. Do **not** mix into Survival Director / gather-lock feature work.

---

## Second look — naturalness & unintended consequences (2026-07-18)

**Why this section exists:** Design constraints that shaped the ship. Safe-fix “Do” lists below are **historical intent** — execution status is in the Snapshot + Workstreams tables at the top and the outcome table under ship order. Do not re-implement from the “Do” bullets.

### Ground truth update (changes the R3 fix)

On teleport steps the existing **speed clamp already fires**. Example Alex Butcher step 77:

- Clamp produced intermediate tile `before=[39,25]` (~6 tiles from start `[36,22]`)
- Then **`emit_zone_anchor_fallback`** rewrote emit to `after=[57,43]` (inside far `target_zone`)
- On a 3-persona sample of 291 teleport rows: **291/291** undid a shorter `before` via `emit_zone_anchor_fallback`

So R3 is not “missing a clamp.” It is **clamp → zone-membership emit validation → snap to destination anchor**. A second global clamp without fixing that order will either no-op or fight the same fallback forever.

---

### Per-fix verdict → outcome (2026-07-20)

| Original suggestion | Plan verdict | Outcome |
|---------------------|--------------|---------|
| R3 new hard emit clamp | Reshape | **DONE** as emit-order fix (not a second clamp) |
| R3 always emit full BE path | Do not ship | **Not shipped** (intent-only kept) |
| R3 analyzer sample-rate note | Ship | **DONE** |
| R1 Phase-8 staff filter | Ship narrow | **DONE** |
| R1 emit remap staff labels | Ship label-only | **DONE** (no body warp) |
| R1 retile maze paint | Don’t rush | **Not shipped** |
| R1 gather force-seating every step | Reshape / avoid | **Not shipped** |
| R2 label = plan always | Do not ship | **Not shipped** |
| R2 force `@` = tile only | Reshape | **DONE** as presence/intent split (heading + `@` presence) |
| R2 split intent vs presence | Ship | **DONE** |
| R5 analyzer suppress true homes | Ship | **DONE** |
| R5 rename apartments | Optional | **Not shipped** |
| R4 align analyzer to end depth tiers | Ship first | **DONE** (docs + end-tier mirror; no satiation-at-end rewrite) |
| R4 gather already-talked mute | Do not ship | **Not shipped** |
| R4 missing end_conversation stamps | If proven | **Not chased** this pass |
| R6 exclude piano from default | Ship | **DONE** |
| R7 sticky forever | Reshape | **DONE** as sticky-with-escape (semantic + mode gate) |
| R8 analyzer-only | Ship | **DONE** |
| R9 | No fix | **Watch** |

---

### R3 — Safe fix (natural walking, no blink)

**Goal:** Bodies walk across town over many steps. Destination stays in *intent*; this step’s footprint stays local.

**Do:**
1. **Keep multi-step travel semantics.** `target_zone` / `act_address` = final destination. `movement` / `planned_pos` = **this step’s** waypoint only.
2. **Fix order:** run zone-membership repair only in ways that respect the speed budget:
   - Prefer: if clamped waypoint is outside `target_zone` **because we are still travelling**, **do not** snap to `zone_anchor` inside the far zone. Leave the intermediate tile; keep `target_zone` as the long-range intent (FE already pathfinds with zone + start).
   - Or: after any zone-anchor fallback, **re-apply** `MAX_TILES_PER_STEP` clamp from `start_pos` so fallback cannot invent a cross-map end.
3. **Exempt only true snaps** with an explicit reason code (elim exit, forced respawn, step-0 spawn) — never silent.
4. **Metrics only:** document sample-rate DISCONTINUITY inflation; don’t “fix” disc when disc=0 at sr1.

**Don’t:**
- Don’t require backend to emit full A* paths under `BACKEND_INTENT_ONLY_PATH=true` (FE collision layer is authoritative for walls).
- Don’t clamp so hard that a 40-tile trip becomes stuck oscillating outside the door (clamp must progress along a path / toward zone each step).
- Don’t treat FE `actual_pos` within the strict report threshold as a bug — small FE variance is normal.

**Naturalness check:** Playback should show continuous walks; action text can still say “walking to the supply store” the whole way. Agents should not arrive in one tick, then immediately leave (the 77→88 ping-pong pattern).

**Regression watch:** gather deadlines (must still *arrive* in time — travel duration already reserved); blocked doorways (progress via alternate waypoint, not teleport into zone).

---

### R1 — Safe fix (customers not in kitchen, without musical chairs)

**Goal:** Non-workers don’t *belong* behind the counter. Crowds at Hobbs still look like a cafe, not a single-file seat assignment.

**Do:**
1. **Phase 8 staff filter (yes), with capacity realism:**
   - Non-workers: never redistribute onto `staff_only` leaves.
   - Workers: may use staff leaves in their `work_area`.
   - When customer seating is full: allow **arena-level** / standing room / shared multi-tile seating capacity — **not** kitchen overflow. Soft co-location on seating tiles already exists; use it.
   - After pick: run the same staff post-validate as the resolver (path parity).
2. **Label vs body (two layers):**
   - **Layer A — access control on intent:** `act_address` / Phase-8 result must not be staff for non-workers (fixes long stationary kitchen *plans*).
   - **Layer B — display:** if the body tile reverse-geocodes to staff but intent is customer seating in the same arena, **prefer customer leaf for `address_label` / `@`** without warping the sprite that frame (avoids pop). Next replan should pull target to a walkable non-staff tile when free.
3. **Gather:** keep gather destination = customer seating. Do **not** hard-assert and re-seat every step. At most: one remap when lock applies + when Phase 8 runs; then sticky until action changes.

**Don’t:**
- Don’t mass-rewire maze paint until a tile census shows dual-tagged kitchen/seating (high blast radius).
- Don’t eject workers from “behind the cafe counter” during shifts.
- Don’t teleport 12 gatherers onto 4 chairs in one step when full — prefer stand-near / shared seating tiles.

**Naturalness check:** Customers queue, stand, sit; baristas work the counter. Vote hour is crowded but not a kitchen invasion and not a teleport scramble.

**Regression watch:** Olivia/Max/Irene still own staff leaves; Survival gather % / on-time arrival stays green.

---

### R2 — Safe fix (honest language, not a single lying field)

**Goal:** Player never sees “sleeping @ cafe” / “at library” while the bubble says Hobbs for the wrong reason. Presence and intention are both real — they must not be smashed into one false string.

**Do — split copy, don’t pick A or B from the first pass:**

| Field | Meaning | Example while walking home → cafe |
|-------|---------|-------------------------------------|
| Presence (`address_label` or tile address) | Where the body is | `…Studio Room 3` → street/park tiles → cafe seating |
| Intention (`intent` / act text) | What they’re doing / going to | `walking to Hobbs Cafe` |
| `@` in description | **Presence only** (or omit while travelling) | `@ …common room` early; later `@ …cafe customer seating` |
| `zone_resolution_detail` | Planned resolve target | Hobbs seating the whole travel |

Concrete emit rule:
- If `movement_mode` is `travel_to_zone` (or body not yet in target arena): description = `"{act} (heading to {short destination})"` **without** `@ far_address`, **or** `@` = presence tile address.
- If stationary / in-zone: `@` = resolved non-staff presence leaf; should match `address_label` after R1 layer B.

**Don’t ship first-pass option A** (label always = plan): that makes the UI claim the body is already at the destination — *less* real.  
**Don’t ship blunt option B** (always rewrite `@` to tile and drop destination): players lose “where are they going?”

**Naturalness check:** Reading one step’s text answers both “where are they?” and “what are they up to?” without contradiction.

---

### R5 — Safe fix

**Do:** Analyzer suppress when `Apartment N` ⊆ persona `living_area`. Optional pretty names later.  
**Don’t:** Globally scrub “Apartment” from the world — three residents live there; wiping it makes homes generic and wrong.  
**Residue 61:** falls out of R2 presence honesty + privacy (don’t adopt another person’s home label from a hallway tile).

---

### R4 — Safe fix (social life stays alive)

**Do:**
1. Align analyzer with runtime (depth tier **and** satiation **and** first-daily **and** arena mod) — measure true spam before touching policy.
2. Only if true violations remain: fix missing `end_conversation` / cooldown stamp paths.

**Don’t:**
- **Gather-wide “already talked this hour → mute”** — Survival’s drama is short, repeated, overlapping talk at Hobbs. A hard pair mute makes the vote hour feel dead.
- Don’t raise cafe `cooldown_mod` into library-like silence; cafe is supposed to be chatty (`cooldown_mod=-2` is intentional flavor).

If playback still shows ping-pong **after** analyzer truth: prefer a soft cap (e.g. same pair needs a larger gap only after *deep* chats, or after N chats in M minutes) — not a gather blackout.

**Naturalness check:** Cafe buzzes; the same two people don’t restart a deep talk every minute; strangers can still greet.

---

### R6 — Safe fix

**Do:** Phase-8 / default object pick skips `affordance_required` objects unless action tokens match affordances (piano ← play/practice/perform).  
**Don’t:** Ban piano entirely; don’t remap someone mid “playing piano.”

---

### R7 — Safe fix (stable, not stuck)

**Do:**
- Sticky **object leaf** only while: same action description family, same arena, mode in `{stationary, in_zone}`, and no explicit anchor change.
- Break sticky on: new plan row, travel mode, gather lock, staff remap, blocked target, or intentional sub-activity change.
- Phase 8 only on true capacity overflow (already the intent) — don’t re-pick leaves every step from tile reverse-geocode while stationary.

**Don’t:** Freeze leaf for “multi-minute” by wall clock alone if the action changed. Bathroom thrash may be two real objects (toilet/sink) — prefer sticky per *action*, not per arena.

**Naturalness check:** Teaching stays at the podium/board; coffee stays at a seat; people still move when the schedule moves.

---

### R8 / R9

- R8: analyzer-only until a playback pass shows empty bubbles.  
- R9: no change.

---

### Revised ship order (naturalness-first) — **executed 2026-07-20**

1. ~~**R3 emit-order fix**~~ → **DONE** (`finalize_emit_target`)  
2. ~~**R1 Phase-8 staff filter + intent post-validate**~~ → **DONE**  
3. ~~**R2 presence/intent copy split**~~ → **DONE**  
4. ~~**R1 display prefer non-staff leaf in-arena**~~ → **DONE** (label only)  
5. ~~**R6 piano default skip** + **R7 sticky-with-escape**~~ → **DONE**  
6. ~~**R4/R5/R8 analyzer truth**~~ → **DONE** (no gather mute; R4 runtime policy unchanged)

### What we explicitly retract from the first pass (still retracted)

- “Always emit backend paths” as a default fix  
- “address_label = plan always” (option A)  
- “Gather force seating every step”  
- “Gather already-talked hard mute”  
- “Second global teleport clamp” without fixing `emit_zone_anchor_fallback`  
- Treating R5 bulk Apartment hits as a world bug  

### Acceptance (human, not only counters) — score on fresh sim

| Moment | Should look like | Gate |
|--------|------------------|------|
| Cross-town commute | Multi-minute walk; text says heading to X; no single-frame map hop | `20260720_launch` §A |
| Hobbs lunch / vote | Crowd in public cafe space; baristas at counter; no customers in kitchen | §B |
| Reading one step | No “at A” vs “at B” fight between label and sentence | §C |
| Cafe chat | Lively, not spam, not silent | §F / playback |
| Piano | Only when playing | §D |
| Class / shift | Same prop for a stretch; moves when the task moves | §E |

---

## Repro / measure commands

```bash
# Baseline (pre-fix evidence) — keep for compare only
python tests/analyze_action-location.py 20260717-1 --source supabase
python tests/analyze_sim_realism.py 20260717-1 --source supabase --profile long

# Post-fix score sim (fill code) — prefer sample-rate 1 for teleport truth
SIM=YYYYMMDD-N
python tests/analyze_action-location.py $SIM --source supabase
python tests/analyze_sim_realism.py $SIM --source supabase --profile long --sample-rate 1
```

Full human + analyzer gates: **`20260720_launch.md` §20260720-1**.

---

## Closed / do not re-open (unless regression)

| Item | Notes |
|------|--------|
| **R1–R3, R5–R8 code (this backlog)** | Shipped `ivan/action-location` 2026-07-20 — re-verify on fresh sim, don’t re-implement |
| Location MVP ship gate (hallucination / Class A desk-excl.) | Green on `20260708-mvp-a` / `20260709-1` (2026-07-09/10) |
| Path A measurement + stopword match | Shipped |
| Hallucination token-budget | Shipped |
| Issue 1 post-validate / orphan redirect | Shipped |
| Issue 3a map registry + prompt grounding | Shipped |
| Wait-wrap compounding / `<waiting>` / truncations | **0** on `20260717-1` |
| Travel-verb as in-place | **0** on `20260717-1` |
| Survival sleep-stuck / all-absent / gather lock | `20260714_checklist.md` (retired) — §11 PASS on `20260717-1` |
| Light soul reasons / blind triad | Creative gate — not action-location; optional on launch checklist §H |

**Archived evidence (old MVP only):** `done/20260709_action-location-midflight-report.md` · `done/20260708_hallucinations.md` · `done/20260705_close-for-mvp.md`

---

## Links

| Doc | Role |
|-----|------|
| `double-ivan/20260720_launch.md` §20260720-1 | **Active** score checklist for these fixes |
| `double-ivan/20260714_checklist.md` | **Retired** Survival Keep/gather/§11 + reflection |
| `double-docs/sot/sot_action-location.md` | Runtime action↔location contract |
| `double-docs/sot/sot_be-fe.md` | Movement / actual_pos contract |
| `generative_agents/tests/analyze_action-location.py` | Place / staff / piano / apartment scanners |
| `generative_agents/tests/analyze_sim_realism.py` | Teleport, chat cooldown, discontinuity |
| `…/storage/20260717-1/analysis/rca_20260717_final.json` | 2026-07-18 pre-fix RCA totals |
