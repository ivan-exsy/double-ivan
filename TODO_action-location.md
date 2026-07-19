# TODO — Action / location & movement realism (RCA backlog)

**Status:** RCA complete (2026-07-18) — findings below; fixes not yet implemented.  
**Updated:** 2026-07-18  
**Evidence sim:** `20260717-1` (Leg 3b Survival sprint; Supabase through ~step 4795)  
**Tools run:**
- `python tests/analyze_action-location.py 20260717-1 --source supabase`
- `python tests/analyze_sim_realism.py 20260717-1 --source supabase --profile long`
- `python tests/analyze_sim_survival.py 20260717-1 --source supabase --profile long`
- Dedicated RCA re-scan (per-persona paginated Supabase `personas_coords`, sample-rate 1) → `analysis/rca_20260717_final.json`

**Exports:** `generative_agents/environment/frontend_server/storage/20260717-1/analysis/`  
(`summary.json`, `sprite_steps.*`, `survival_day_summaries.json`, `llm_prompt_bundle.md`, `rca_20260717_final.json`)

**Product context (do not mix into this RCA):** Survival §11 / gather lock / Director / Keep reasons on this sim are mid-flight **PASS**. Light soul reasons + blind triad are a **separate** creative gate (Day 4+). This file is only “bodies, places, labels, chat continuity still feel off.”

---

## Snapshot — what still feels off

| # | Theme | Severity | Count on `20260717-1` | Player-visible? |
|---|--------|----------|----------------------:|-----------------|
| **R1** | Staff-zone / counter resolve for non-workers (Issue 2 Gap 1+2) | **P0** | Gap1 **676** + Gap2 **599** | High — customers in kitchen / behind counter |
| **R2** | Address label ≠ description `@` place | **P0** | **3154** divergences | High — UI/forensics disagree on where someone is |
| **R3** | Teleport + path discontinuity | **P0** | TELEPORT **1818** · DISCONTINUITY **1894** (long profile, sample-rate 2) | High — blinks / jerky playback |
| **R4** | Chat cooldown violations | **P1** | **504** | Medium — re-chat spam |
| **R5** | Stale `Apartment N` labels in home text | **P1** | **5538** field hits (concentrated on ~3 residents) | Medium — generic / wrong home names |
| **R6** | Piano leaf while not playing | **P2** | **18** bad · **58** real play OK | Low–medium at Hobbs |
| **R7** | Sub-arena address flapping (Bug C) | **P2** | **3** long bands | Low — leaf thrash in one room |
| **R8** | Chat missing payload | **P2** | **111** | Low — empty chat shells |
| **R9** | Oscillation (tiny back-forth) | **P3** | **1** (realism) / more in survival variant | Low |

**Not in scope for this backlog (already green or N/A on this scan):**
- Nested wait-wrap / `<waiting>` / known truncations → **0**
- Travel-verb misclassified as in-place → **0**
- Survival gather / sleep-stuck / phantom elim → tracked in `20260714_checklist.md`, not here
- Location MVP Class-A desk-exclusion gate (2026-07-09/10) → historical green; do not re-litigate unless R1–R3 reopen it

---

## RCA workstreams (start here)

Prefer one worktree per stream (e.g. `ivan/rca-staff-zone`, `ivan/rca-teleport`). Stop condition = count down on a fresh Survival or long smoke + human playback skim — not “zero forever.”

### R1 — Staff-zone resolver bypass (P0)

**Symptom:** Non-workers resolve onto cafe/pub **cooking area**, **kitchen sink**, **refrigerator**, **behind the cafe/bar counter**.

**Evidence (`analyze_action-location`):**
- **Gap 1** (kitchen + fridge cascade): **676** non-worker hits  
  - Heavy: Vince Vale 281 (242× Hobbs cooking area), Owen Logan 192, Vincent Slater 162 (89× fridge)
- **Gap 2** (behind-counter tags): **599** non-worker hits  
  - Heavy: Owen Logan 324 (290× behind cafe counter), Vince Vale 224

**RCA questions:**
1. Which path writes the leaf — plan inherit, LLM location, spatial default, or FE snap?
2. Is `staff_only` enforced on all resolve paths, or only some?
3. Are “barista / staff” personas incorrectly classified, or is everyone treated as customer?
4. Survival Hobbs gather — does appointment force a bad default leaf inside the cafe arena?

**Acceptance (draft):** Gap1+Gap2 non-worker hits drop sharply on a 500–2600 step re-run; customer actions land on seating/counter-customer leaves, not kitchen/behind-counter.

**Analyzer:** Issue 2 Gap 1 / Gap 2 sections in `analyze_action-location.py`.

---

### R2 — Address-field divergence (P0)

**Symptom:** `address_label` and description `@`-suffix disagree — often different buildings in the same step.

**Evidence:** **3154** total; spread across cast (e.g. Alex Shepard 344, Alexis Reed 307, Olivia King 303, …).

**Examples:**
- label dorm / desc Hobbs seating  
- label Hobbs / desc classroom podium  
- label supply shelf / desc behind supply counter  

**RCA questions:**
1. Are label and description updated on different ticks (stale field)?
2. Is one field intent and one field actual without a single writer of truth?
3. Does FE actual_pos reconcile one field but not the other?
4. How much is sampling artifact vs true dual-write?

**Acceptance (draft):** Same-step label vs `@` mismatch rate near noise; SOT field documented in `sot_action-location.md` / FE-BE contract.

**Analyzer:** “Address-field divergence” section in `analyze_action-location.py`.

---

### R3 — Teleport / discontinuity (P0)

**Symptom:** Large tile jumps within or across steps; realism flags thousands of TELEPORT + DISCONTINUITY.

**Evidence (`analyze_sim_realism`, long profile, sample-rate 2):**
- TELEPORT **1818**
- DISCONTINUITY **1894**
- Examples early run: Alex Butcher 42-tile flips between `[36,22]` and `[57,43]` (steps ~78–92)

**RCA questions:**
1. True pathfinding teleport vs analyzer comparing non-contiguous samples (rate 2)?
2. Intent-only path + FE realization dropping intermediate tiles in Supabase coords?
3. Respawn / elim / home snap without path?
4. Duplicate persona rows or step rewrites?

**Acceptance (draft):** Re-run realism at **sample-rate 1** on a window; true >10-tile jumps rare outside known snaps (sleep wake, elim exit). Playback no longer “blinks” across town every few minutes.

**Analyzer:** `analyze_sim_realism.py` TELEPORT / DISCONTINUITY.  
**Note:** First confirm measurement (sample-rate / SOT coords) before large pathfinding rewrites.

---

### R4 — Chat cooldown violations (P1)

**Symptom:** Pair re-enters chat faster than cooldown policy allows.

**Evidence:** **504** `CHAT_COOLDOWN_VIOLATION` (realism summary). Survival twin run reported fewer cooldown flags depending on issue taxonomy — treat **504** as primary from realism export.

**RCA questions:**
1. Cooldown written but not read on Survival gather density?
2. First-daily-encounter bypass too wide?
3. Missing end_conversation → no cooldown stamp?
4. Analyzer mismatch vs live `conversation_manager` constants?

**Acceptance (draft):** Violations rare outside documented bypasses; no ping-pong pair spam in playback.

---

### R5 — Stale `Apartment N` home labels (P1)

**Symptom:** Display/description still say `Apartment 1/4/5` etc. instead of stable named homes.

**Evidence:** **5538** hits; concentrated:
- Owen Logan ~2288 (desc-heavy, steps 0..4470)
- Vince Vale ~2052
- Vincent Slater ~1160 (until elim)
- Others mostly sparse `address_label` only

**RCA questions:**
1. Bootstrap / maze registry still emitting generic apartment tokens?
2. Relabel pass only on some fields?
3. Persona home anchor never mapped to display name?

**Acceptance (draft):** Living cast home text uses canonical place names; analyzer V4 near-zero on new runs (or only historical elim rows).

**Analyzer:** V4 section in `analyze_action-location.py`.

---

### R6 — Piano affordance false positives (P2)

**Symptom:** Address leaf `:piano` while action is coffee / wait / notes / pact — not playing.

**Evidence:** **18** false · **58** true “play piano” (Nick Miller, Vince Vale) — real play works.

**RCA questions:**
1. Cafe default leaf / occupancy picks piano tile?
2. Affordance gate only on “play” verbs, not on standing resolve?

**Acceptance (draft):** Non-play actions resolve to seating (or other non-piano leaves); play still lands on piano.

**Analyzer:** V2 piano sections.

---

### R7 — Sub-arena flapping (P2)

**Symptom:** Within one arena, address leaf toggles every ~1–3 steps (pool table ↔ common room, blackboard ↔ seating).

**Evidence (Bug C):** 3 bands — Ivan dorm common room; Alex Butcher + Mike Hooks classroom.

**RCA questions:**
1. Re-resolve every step with unstable tie-break?
2. Micro-move + nearest-object thrash?

**Acceptance (draft):** Stable leaf for multi-minute in-place actions unless action changes.

---

### R8 — Chat missing payload (P2)

**Evidence:** **111** `CHAT_MISSING_PAYLOAD`.

**RCA:** Chat step marked without utterance body — transport vs writer vs FE strip. Lower priority than R1–R3 unless playback shows empty bubbles often.

---

### R9 — Oscillation (P3)

**Evidence:** **1** OSCILLATION in realism summary (survival run variant counted more — reconcile if needed). Watch only unless playback shows left-right jitter.

---

## Suggested RCA order

1. **R3 measurement check** (sample-rate 1 window + raw coords) — avoid fixing ghosts  
2. **R1 staff-zone** — highest immersion at Hobbs (Survival stage)  
3. **R2 dual address fields** — single writer of truth  
4. **R5 Apartment N** — cheap label/bootstrap if root is obvious  
5. **R4 chat cooldown** — social spam  
6. **R6–R9** — polish  

---

## RCA findings — 2026-07-18 (`20260717-1`)

**Method:** Re-read SOT (`sot_action-location.md` §3.3 / §7.2), emit path in the movement writer, staff gates in the location resolver, Phase-8 co-location redistribute, gather lock, chat cooldown manager, and analyzers. Re-scanned **every** `personas_coords` row per persona with proper pagination (PostgREST default page = 1000; wide windows under-count unless you page). Artifact: `analysis/rca_20260717_final.json`.

**Cast context (not a bug, but shapes the numbers):**
- Hobbs **workers** (legitimate staff leaves): Irene Dove, Max Shoemaker, Olivia King.
- Heavy non-worker staff hits: Vince Vale (classroom), Owen Logan (Willows), Vincent Slater (classroom, elim ~2310).
- Three cast members **actually live** in `Apartment N`: Owen → Apt 1, Vince → Apt 5, Vincent → Apt 4. That drives most of R5.

### Executive verdict

| # | Real? | Primary root | Fix size |
|---|-------|--------------|----------|
| **R3** | **Yes — true teleports** | Within-step `start→end` jumps with **empty path**; intent-only + FE realization not clamped on the persisted end tile | Medium (movement clamp / path emit) |
| **R1** | **Yes — immersion P0** | Staff leaves land via **tile reverse-geocode** + **Phase-8 redistribute without staff filter**; gather lock destination is correct but body still snaps onto kitchen/counter tiles | Medium (gate emit + Phase 8) |
| **R2** | **Yes — dual writers** | `description @` = planned `act_address`; `address_label` = `get_authoritative_address(actual tile)` — intentionally different fields, never reconciled | Small–medium (single SOT field) |
| **R5** | **Mostly not a bug** | Analyzer flags real `Apartment N` homes; ~61 wrong-home `address_label` snaps are the only real residue | Small (analyzer + rare wrong tile) |
| **R4** | **Mixed** | Runtime uses depth-tier + satiation; analyzer uses depth-tier only; Hobbs `cooldown_mod=-2` still leaves deep chats at 28 — real short gaps exist at cafe | Small (align analyzer + soft gather policy) |
| **R6** | Real, small | Piano is non-staff default leaf; affordance gate only rejects “play” mismatch after resolve, not “standing on piano tile” | Small |
| **R7** | Real, broader than TODO | Leaf thrash inside one arena (classroom/cafe/bathroom); sticky resolve re-picks object | Small–medium |
| **R8** | Mostly analyzer | `chatting_with=(from description)` with 0 utterances — description mentions chat, payload empty | Small |
| **R9** | Noise | 1 oscillation band | Watch only |

**Recommended ship order:** see **Second look** below (naturalness-first). Do **not** implement the first-pass fix bullets blindly — several were retracted or reshaped after a consequence review.

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

Closing **path parity for staff**, **single display-location writer**, and **within-step movement clamp** removes most of the P0 immersion damage without a pure-LLM resolver rewrite.

---

### Proposed fix workstreams (implementation-ready)

| Stream | Branch suggestion | Files (indicative) | Done when |
|--------|-------------------|--------------------|-----------|
| **W1 Movement clamp** | `ivan/rca-teleport-clamp` | step emit / move finalize; FE actual_path ingest | sr1 800-step TELEPORT ≪ 1216; no empty-path >10 jumps |
| **W2 Staff path parity** | `ivan/rca-staff-zone` | Phase 8 pick; emit post-validate; gather assert | Gap1+Gap2 non-worker down sharply |
| **W3 Address SOT** | `ivan/rca-address-sot` | movement JSON writer; SOT doc | R2 near noise; FE shows one place |
| **W4 Leaf sticky + piano** | `ivan/rca-leaf-stable` | sticky resolve; Phase 8 filters; piano default | R6≈0; R7 bands rare |
| **W5 Analyzer truth** | `ivan/rca-analyzer-align` | action-location V4; realism cooldown/chat | Counts match product bugs only |

Do **not** mix these into Survival Director / gather-lock feature work — gather lock destination is already correct; W2 only guards post-lock realization.

---

## Second look — naturalness & unintended consequences (2026-07-18)

**Why this section exists:** The first-pass fixes optimize analyzer counts. Several of them can make the world feel *more* robotic if applied bluntly (instant seat snatching, frozen leaves, silent gather hours, labels that lie about the body). This pass keeps only fixes that improve **lived realism**, and rewrites or kills the rest.

### Ground truth update (changes the R3 fix)

On teleport steps the existing **speed clamp already fires**. Example Alex Butcher step 77:

- Clamp produced intermediate tile `before=[39,25]` (~6 tiles from start `[36,22]`)
- Then **`emit_zone_anchor_fallback`** rewrote emit to `after=[57,43]` (inside far `target_zone`)
- On a 3-persona sample of 291 teleport rows: **291/291** undid a shorter `before` via `emit_zone_anchor_fallback`

So R3 is not “missing a clamp.” It is **clamp → zone-membership emit validation → snap to destination anchor**. A second global clamp without fixing that order will either no-op or fight the same fallback forever.

---

### Per-fix verdict (ship / reshape / do not ship)

| Original suggestion | Verdict | Naturalness risk if done naively |
|---------------------|---------|----------------------------------|
| R3 new hard emit clamp | **Reshape** | Duplicate of existing clamp; may freeze travel if it fights zone fallback |
| R3 always emit full BE path | **Do not ship as default** | Breaks intent-only FE A* contract; can reintroduce wall-walking |
| R3 analyzer sample-rate note | **Ship** | None (docs/metrics only) |
| R1 Phase-8 staff filter | **Ship (narrow)** | Over-filter → everyone piles on 2 seats; workers blocked from counter |
| R1 emit remap staff labels | **Ship (label-only first)** | Remapping *body* off a tile mid-step = visible pop |
| R1 retile maze paint | **Investigate, don’t rush** | Wrong un-paint → staff can’t stand at counter; pathfinding holes |
| R1 gather force-seating assert every step | **Reshape** | Karaoke line / vote crowd becomes musical-chairs teleport |
| R2 option A: label = plan always | **Do not ship** | Label says “at cafe” while sprite still on campus — worse lie |
| R2 option B: force `@` = tile always | **Reshape** | Strips “walking to X” destination from the only player-facing sentence |
| R2 split intent vs presence | **Ship** | None if copy stays human |
| R5 analyzer suppress true homes | **Ship** | None |
| R5 rename apartments | **Optional cosmetic** | Lore churn; low priority |
| R4 align analyzer to runtime | **Ship first** | None |
| R4 gather “already talked” hard mute | **Do not ship** | Kills Survival social texture in the hour that needs it most |
| R4 fix missing end_conversation stamps | **Ship if proven** | None |
| R6 exclude piano from default seat | **Ship** | Don’t block real “play piano” |
| R7 sticky leaf forever | **Reshape** | Stuck on blackboard/sink through whole class/shift |
| R8 analyzer-only | **Ship** | None |
| R9 | **No fix** | — |

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

### Revised ship order (naturalness-first)

1. **R3 emit-order fix** (stop zone-anchor from undoing speed clamp) — biggest “blink” win, preserves walking  
2. **R1 Phase-8 staff filter + intent post-validate** — kitchen invasion, no forced reseat storm  
3. **R2 presence/intent copy split** — honest UI without lying labels  
4. **R1 display prefer non-staff leaf in-arena** (no body warp)  
5. **R6 piano default skip** + **R7 sticky-with-escape**  
6. **R4/R5/R8 analyzer truth** before any social-policy change  

### What we explicitly retract from the first pass

- “Always emit backend paths” as a default fix  
- “address_label = plan always” (option A)  
- “Gather force seating every step”  
- “Gather already-talked hard mute”  
- “Second global teleport clamp” without fixing `emit_zone_anchor_fallback`  
- Treating R5 bulk Apartment hits as a world bug  

### Acceptance (human, not only counters)

| Moment | Should look like |
|--------|------------------|
| Cross-town commute | Multi-minute walk; text says heading to X; no single-frame map hop |
| Hobbs lunch / vote | Crowd in public cafe space; baristas at counter; no customers in kitchen |
| Reading one step | No “at A” vs “at B” fight between label and sentence |
| Cafe chat | Lively, not spam, not silent |
| Piano | Only when playing |
| Class / shift | Same prop for a stretch; moves when the task moves |

---

## Repro / measure commands

```bash
# From generative_agents repo (Supabase creds in .env.local)
python tests/analyze_action-location.py 20260717-1 --source supabase
python tests/analyze_sim_realism.py 20260717-1 --source supabase --profile long
# After a fix, prefer denser sample for teleport truth:
python tests/analyze_sim_realism.py <new_sim> --source supabase --max-steps 800 --sample-rate 1

python tests/analyze_sim_survival.py 20260717-1 --source supabase --profile long
```

Optional VPS (disk env near fire steps — separate from this RCA): Hobbs census at phase-trigger steps 3145 / 3630 / 4585.

---

## Closed / do not re-open (unless regression)

| Item | Notes |
|------|--------|
| Location MVP ship gate (hallucination / Class A desk-excl.) | Green on `20260708-mvp-a` / `20260709-1` (2026-07-09/10) |
| Path A measurement + stopword match | Shipped |
| Hallucination token-budget | Shipped |
| Issue 1 post-validate / orphan redirect | Shipped |
| Issue 3a map registry + prompt grounding | Shipped |
| Wait-wrap compounding / `<waiting>` / truncations | **0** on `20260717-1` |
| Travel-verb as in-place | **0** on `20260717-1` |
| Survival sleep-stuck / all-absent / gather lock | Checklist `20260714_checklist.md` — §11 PASS mid-flight on this sim |
| Light soul reasons / blind triad | Creative gate — not action-location |

**Archived evidence (old MVP only):** `done/20260709_action-location-midflight-report.md` · `done/20260708_hallucinations.md` · `done/20260705_close-for-mvp.md`

---

## Links

| Doc | Role |
|-----|------|
| `double-docs/sot/sot_action-location.md` | Runtime action↔location contract |
| `double-docs/sot/sot_be-fe.md` | Movement / actual_pos contract (teleport RCA) |
| `double-ivan/20260714_checklist.md` | Survival score (separate from this file) |
| `generative_agents/tests/analyze_action-location.py` | Place / staff / piano / apartment scanners |
| `generative_agents/tests/analyze_sim_realism.py` | Teleport, chat cooldown, discontinuity |
| `generative_agents/tests/analyze_sim_survival.py` | Season overlay (gather % — context only) |
| `…/storage/20260717-1/analysis/rca_20260717_final.json` | 2026-07-18 RCA re-scan totals + examples |
