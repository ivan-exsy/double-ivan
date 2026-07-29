# RCA — §12C place language (Vince Vale / `20260724-2`)

**Date:** 2026-07-28  
**Sim:** `20260724-2`  
**Symptom:** Human FAIL — status says walking to / ordering at Hobbs while body is at Johnson Park (or leaving cafe).  
**Evidence window:** Vince Vale steps **5827–5895** (matches Jul 28 morning human pass).

## Verdict (one sentence)

The body and `@` presence are mostly honest; the **action text** names Hobbs while the **sealed planned address** is Johnson Park — emit then glues both; deeper dig shows the park address was sealed at decomp by an **exercise whitelist cascade**, not by a broken Hobbs resolver.

## Timeline (DB)

| Step | Body (addr) | `intent` (what UI often shows) | Full `description` |
|------|-------------|-------------------------------|--------------------|
| 5827 | Apt 5 | walking to Hobbs Cafe | walking to Hobbs Cafe **(heading to Johnson Park)** @ Apt 5 |
| 5845 | Johnson Park | walking to Hobbs Cafe | walking to Hobbs Cafe (heading to Johnson Park) @ Johnson Park |
| 5858 | street (`the Ville`) | **ordering breakfast at the counter** | ordering… **(heading to Hobbs)** @ the Ville |
| 5869 | Hobbs seating | ordering breakfast… | ordering… @ cafe customer seating |
| 5874 | leaving cafe | walking to Hobbs Cafe | walking to Hobbs Cafe **(heading to Johnson Park)** @ the Ville |
| 5895 | street | reviewing lecture notes over coffee | reviewing… **(heading to Oak Hill)** @ the Ville |

Same split-brain pattern also appears early in the sim (e.g. step ~30).

In this morning window alone: **52** steps with intent=Hobbs but description heading=Johnson Park; **10** steps with “ordering…” while `address_label` is not Hobbs.

## Failure modes (player-visible)

1. **Split-brain destinations (core)**  
   - `act_description` / `intent` → “walking to **Hobbs**”  
   - `act_address` (planned) → **Johnson Park**  
   - Emit helper `build_presence_intent_description` adds `(heading to {planned})` without scrubbing the conflicting place already inside the act text →  
     `walking to Hobbs Cafe (heading to Johnson Park) @ …`

2. **Premature in-place verbs while travelling**  
   - Schedule advances to “ordering breakfast at the counter” / “reviewing … over coffee” before arrival.  
   - Emit correctly marks travel toward Hobbs/Oak Hill, but the verb still claims the activity.

3. **UI amplifier**  
   - Persona card / status prefers short action/`intent` (raw act text), not the fuller composed `description`.  
   - Player sees “Walking to Hobbs” even when presence `@` is already Johnson Park.

## Deeper RCA — why Park while words say Hobbs

**Not broken:** fresh `resolve_location("walking to Hobbs Cafe", anchor=cafe)` returns Hobbs. Path persist / gradual walk are fine. Presence `@` tracks the body.

**Broken path (soak `20260724-2`, assign step 5827):**

1. Contextual decomp emits two sub-rows, including  
   `walking to Hobbs Cafe [mode=zone_patrol anchor=cafe customer seating]` (8min).
2. That travel row is typed **`activity_type=exercise`** (LLM decomp — “walking…” read as exercise).
3. The row takes the **inherit** path (`INHERIT POST-VALIDATE`), then whitelist post-validate sees `exercise` is not allowed at the inherited / cafe-ish address.
4. **Forbidden-cascade Tier-2** remaps exercise → nearest exercise-whitelisted arena →  
   `the Ville:Johnson Park:park:park garden`.
5. Sibling row `reviewing lecture notes over coffee` with `activity_type=study` cascades to Oak Hill classroom (same mechanism).
6. Duration check still prints `COMPATIBLE: … walking to Hobbs Cafe` — label unchanged; **address already Park**.
7. Stall breaker advances to that schedule index; assign prints  
   `ACTION CONTRACT: … using '…Johnson Park…'` then  
   `[LIFECYCLE:ASSIGN] … action='walking to Hobbs Cafe' … addr=…Johnson Park…`.

**Same family elsewhere on this sim:** Hobbs-label + Park-addr assigns at steps **30, 1780, 2017, 5827, 5874**.

**Step-30 micro-proof (clearest single remaps):**  
`walking to Oak Hill College` resolves to library table →  
`POST-VALIDATE [whitelist] … -> Johnson Park` with `activity_type='exercise'`.

**Contributing code gaps:**

| Gap | Effect |
|-----|--------|
| Travel row tagged `exercise` | Whitelist cascade prefers Johnson Park over named cafe/college dest |
| `_label_is_travel` lists `"walk to "` but **not** `"walking to "` | Travel sub-rows inherit parent location too often, then get remapped |
| ACTION CONTRACT short-circuit trusts sealed `resolved_address` | Assign never re-asks “does this address match the label’s named place?” |
| Emit glues act + planned without conflict scrub | Player-visible “Hobbs (heading to Johnson Park)” |

## What is *not* broken

- Tile → `address_label` presence geocode (mostly tracks body).  
- Path persist / gradual walk (§11 / §11b).  
- Core Hobbs name→address resolve when called fresh.  
- The presence/intent emit *framework* (shipped 2026-07-20) — it is being fed inconsistent planner inputs.

## Code locus

| Layer | Where | Role |
|-------|--------|------|
| Emit composition | `action_contract_v1.build_presence_intent_description` | Glues act + planned dest; no conflict scrub (pre-P0) |
| Emit wiring | `reverie.py` (~5632–5658) | Sets `description` via helper; sets `intent` from raw `act_description` (pre-P0) |
| Decomp contract seal | `plan._contextual_rows_to_contract_pairs` | Inherit + post-validate; seals Park into row contract |
| Whitelist cascade | `location_resolver._remap_for_forbidden_address` Tier-2 | `exercise` → Johnson Park |
| Assign short-circuit | `plan.py` ACTION CONTRACT path | Reuses sealed address without label/dest check |
| FE surface | `PersonaCard` / `personaMapping` actionDescription | Often shows short act, not composed description |

## Fix plan

**P0 — Emit honesty (committed on `ivan/place-language-emit-honesty`)**  
1. If travelling and act text names a place ≠ planned short dest → rewrite travel copy from **planned** dest.  
2. If travelling and act looks in-place (ordering / eating / reviewing at …) → force `walking to {planned}`.  
3. Emit `intent` through `build_travel_safe_intent` (not raw lying act).  
4. Tests in `tests/test_action_text_sanitization.py` for Vince fixtures.  
Stops player-facing “Hobbs while feet go to Park” lies.

**P1 — Planner consistency (implemented 2026-07-28, same branch)**  
1. Post-validate: do **not** whitelist-cascade when travel text names the address sector (`_named_destination_protects_address`).  
2. Treat `"walking to "` as travel (`_label_starts_with_travel`).  
3. Detach inherit when travel names a place outside the parent (`TRAVEL DEST DETACH`).  
4. Reject ACTION CONTRACT when sealed address != named travel destination (forces fresh resolve).  
5. Tests: `tests/test_named_destination_travel.py`.

**Do not** “fix” by warping the body to match lying text.

## Ship impact

On `20260724-2`, §12C remained **FAIL** until P0+P1 deploy and a morning-commute re-score.

**Update (2026-07-29):** re-score `20260728-2` cleared the classic Hobbs@Park named-travel pattern. Soft honesty residuals (stretch→Park, ordering-while-travel) remain — see **Addendum** below. Natural-movement ship still **HOLD** until soft bar clears or product accepts yellow.

---

## Addendum — `20260728-2` re-score soft honesty (2026-07-29)

**Sim:** `20260728-2` @ tip `b230c4be` (includes P0 emit honesty + P1 named-dest travel)  
**Window:** Survival Day 1 morning ≈ steps **1448–1496** (07:00 clock ≈ 1470; day boundary ~1050 @ 00:00)  
**Question:** Do the original RCA findings still hold? Where do the soft misses come from?

### Verdict (one sentence)

**Original core finding still holds** (exercise whitelist cascade → Johnson Park; premature in-place verbs while travelling). **P1 fixed the classic named-travel Hobbs@Park ship-blocker**; the soft misses are **siblings the P0/P1 scope did not cover** (plus an API read-path that prefers raw planner act text over emit-cleaned copy).

### Do original findings still hold?

| Original claim | On `20260728-2`? | Evidence |
|----------------|------------------|----------|
| Named "walking to Hobbs" sealed to Johnson Park via exercise cascade | **No longer observed** (P1 working) | Vince Day1 morning: walk/order/eat assign to Hobbs addr; soak `POST-VALIDATE keep named dest` firing (~48) |
| Fresh Hobbs resolve is fine; body/path mostly honest | **Holds** | Travel feasibility extends duration; paths length 7 across town |
| Exercise → Park Tier-2 cascade is the deep remapper | **Still true** for non-travel / non-named-dest rows | Midnight decomp seal (below) |
| Premature in-place verbs while travelling (ordering…) | **Still true** | Steps 1475–1485 |
| Emit glues conflicting places without scrub | **Partially fixed by P0**, but player/API still often see raw act | See soft case B |
| UI prefers short act / intent | **Holds / amplified** | Gateway `normalize_action_contract` prefers `action_progress.action_description` over emit `description` |

### Soft case A — "stretching in the main room" → Johnson Park (steps 1448–1474)

**Player-visible:** status = apartment stretching; body walks across town to Park.

**Seal (same family as original RCA):** during Day1 schedule decomp (~soak line 1953134), a morning stretch row is typed `activity_type=exercise`, then:

```
forbidden-cascade Tier-2 (activity_type='exercise'): Vince Vale -> Johnson Park:park:park garden
INHERIT POST-VALIDATE: Vince Vale [whitelist]
COMPATIBLE: … do light stretching in the main room [mode=zone_patrol anchor=cooking area]
```

Later assign (step 1448):

```
ACTION CONTRACT: … using '…Johnson Park…'
[LIFECYCLE:ASSIGN] action='do light stretching in the main room' addr=…Johnson Park…
movement_mode=travel_to_zone  source=llm:outside_zone_safety_net
```

**partial_state at 1448:** `action_family=exercise`, `resolution_source=parent_location_inherit_v1`, `resolved_address=Johnson Park`, `actual_tile_address=Apartment 5:main room`, `subactivity_mode=zone_patrol`, `anchor_text=cooking area`.

**Why P1 did not stop this:** `_named_destination_protects_address` only protects **travel-like** labels that **name the address sector**. "do light stretching in the main room" is not travel-like, and "main room" is not a protected named destination — so the exercise→Park cascade still wins. P1 correctly spared *named Hobbs/Oak Hill walks*; it never claimed to spare unlabeled exercise rows.

**Contributing LLM decomp oddity:** stretch was sealed as `[mode=zone_patrol]` with a cooking-area anchor, so the engine treats it as out-of-zone travel to the sealed Park address rather than in-apartment stretch.

**P0 emit gap:** `_PREMATURE_INPLACE_RE` includes order/eat/sip/… but **not stretch**; `_KNOWN_PLACE_RE` does not treat "main room" as a conflicting place token. Even a perfect emit path would leave the lying apartment wording unless extended.

### Soft case B — "order breakfast…" while travelling to Hobbs (steps 1475–1485)

**Player-visible:** status = ordering at the counter; feet still en route (path_len=7); body still leaving Park tiles.

**Planner side (honest address, premature verb):**

```
[LIFECYCLE:ASSIGN] action='order breakfast at the counter' addr=…Hobbs Cafe…cafe customer seating
TRAVEL FEASIBILITY: unreachable in 5min (dist=64) → extend to 16min
movement_mode=travel_to_zone
```

**partial_state at 1475:** `resolved_address=Hobbs`, `actual_tile_address=Johnson Park` (still at Park from case A), `action_description=order breakfast at the counter`, `subactivity_mode=social_touch`.

This is **exactly original failure mode #2** (premature in-place verb while travelling). Address is now correct (Hobbs) — that is the P1 win vs the old Hobbs-label@Park-addr split. The remaining lie is **verb vs feet**.

**Why P0 did not fully erase it on this score:**

1. **P0 unit coverage exists** (`test_travel_rewrites_premature_inplace_verb`) — if emit runs with `movement_mode=travel_to_zone` + planned Hobbs, copy should become `walking to Hobbs Cafe @ {presence}`.
2. **Stored/served step payload still shows raw "order breakfast…"** with `intent=null`, matching `partial_state.action_progress.action_description`.
3. **API amplifier (new finding):** `api_gateway/app/core/action_contract.py` `normalize_action_contract` prefers `action_progress.action_description` (raw planner act) **over** top-level emit `description`. `BusinessRuleValidator.validate_movement_data` then sets response `description` from that preferred raw text. So even a cleaned emit can be **replaced by the lying planner verb on read**.

Inverted schedule note: after arriving for "order", assign later flips to `walk to Hobbs Cafe` (step 1491) while already at cafe — travel language after the fact (soft / secondary).

### Soft case C — "sip coffee…" @ Oak Hill (step ~1530) — brief

Soak shows **study deterministic guard** remapping coffee/review language toward Oak Hill classroom, with orphan-anchor redirects fighting cafe seating. Same broad family (activity_type / guard cascade overwrites place implied by activity), not the classic Hobbs@Park travel seal. Treat as related residual, not the primary soft A/B pair.

### What P0+P1 actually bought on this re-score

- **Ship-blocker pattern fixed:** named walking-to-Hobbs/Oak-Hill no longer remaps to Johnson Park.
- **Still open:** (1) exercise/unlabeled place rows → Park inherit; (2) premature order/eat/sip verbs while `travel_to_zone`; (3) API/FE prefer raw act over emit-cleaned copy.

### Did P0 / P1 address the root cause? (verification)

There are **two planner roots**, plus one **display-contract breach**:

| # | Root | Meaning |
|---|------|---------|
| **RC1** | Inconsistent seal | Planner may store act text that claims place/activity A while `act_address` / travel state is B (or in-place verb while still travelling). |
| **RC2** | `activity_type` cascade as destination authority | Hard whitelist / guard remap can rewrite address to satisfy activity type (exercise→Park, study→classroom) even when act text already claims another place. |
| **RC3** | Display path ignores emit contract | Gateway prefers raw `action_progress.action_description` over emit-cleaned `description`/`intent`, so §5.4 honesty never reaches the player. |

| Fix | Hits root? | Verified effect on `20260728-2` | SOT fit |
|-----|------------|----------------------------------|---------|
| **P1** named-dest protect + travel detach + contract reject | **Partial RC1/RC2** | Classic named "walking to Hobbs/Oak Hill" @ Park **gone**; `POST-VALIDATE keep named dest` fires | Aligned with spirit of `sot_action-location.md` §3.3 (text that names place should not be cascade-stolen), but **not yet written into SOT** — still a narrow special case (travel-like + names sector only). Soft A (non-travel stretch) correctly out of scope. |
| **P0** emit rewrite while travelling | **RC3 layer only** | Unit tests prove rewrite; live score still showed raw "order…" | Matches `sot_action-location.md` §5.4 composition rule — but only if all §5.2 surfaces carry it. |
| **API normalize preferring raw act** | **Causes RC3** | Soft B visible on step API | **Violates** `sot_action-location.md` §5.2 (nested `action_progress.action_description` is a required *sanitized* emit surface) and §5.4 / `sot_be-fe.md` §2.4 (`description`/`intent` = presence/intent copy). |

**Conclusion:** P0+P1 fixed the original ship-blocker *subclass*. They did **not** close RC2 for non-travel place claims, and RC3 currently undoes P0 for gateway consumers.

### SOT cross-check — accuracy & unintended consequences

Normative refs: `sot_action-location.md`, `sot_be-fe.md` §2.4/§2.7, `sot_realism.md` (honest place language + crutches), `sot_sim.md` (whitelist retirement / hard-gate scarcity).

| Earlier P2 idea | Accurate vs SOT? | Expected effect | Unintended consequence risk |
|-----------------|------------------|-----------------|------------------------------|
| Broad new "place-claim owns destination" hard policy | **Directionally right**, but easy to over-build | Would stop stretch→Park / coffee→classroom cousins | Can fight **orphan-anchor redirect**, **§3.6 must-emit-an-address**, and **staff_only/privacy** if not explicitly subordinated to permanent world-law guards (`sot_action-location.md` §3.3). Also fights `sot_sim.md` P4 ("hard gates rare") if implemented as another growing gate list. |
| Hard **arrival gate** (never seal in-place until feet arrive) | **Over-strong vs current SOT** | Would clear soft B at planner | New deterministic **crutch** (`sot_realism.md` crutches registry — currently empty). Can fight intentional `zone_patrol` / dwell stages and add patterned schedule rewrites. SOT already assigns honesty for travel to **emit §5.4**, not a new seal veto. |
| Prefer emit `description`/`intent` on API | **Required by existing SOT** | Soft B disappears for FE/score if P0 emit ran | Low risk if scoped to player-facing fields only; keep raw act in scratch/forensics. |
| Add stretch / "main room" keyword protects | **Band-aid** | Fixes one sim line | Exactly the patchwork that gets noisier with smarter models (`sot_action-location.md` §3.4 retire crutches; `sot_sim.md` retire hard whitelist intelligence). |
| Expand / harden `activity_whitelist` cascades | **Anti-SOT** | More remap "fixes" | Contradicts `sot_sim.md` §5 retirement candidate and §3.5 "soft scoring must not be the long-term semantic SOT". |

### Recommended fix — SOT-aligned, root-cause, low new noise

Do **not** add one-off verb/place lists. Prefer **narrowing existing drift heuristics** and **honoring contracts already shipped**.

#### P2-SOT-1 — Close RC3 first (contract compliance, not a new idea)

`sot_action-location.md` §5.2 already requires sanitization on:
- movement `description` / `intent`
- nested `partial_state.action_progress.action_description`

**Change:** gateway `normalize_action_contract` / step validation must not replace emit-cleaned player fields with raw planner act. Prefer top-level emit `description`/`intent` when present; keep nested progress consistent with §5.4 travel rewrite when `travel_to_zone`.

**Expected effect:** Soft B (order-while-travel) clears for players/score *if* P0 emit ran — without new planner gates.  
**Does not regress:** pathfinding (`sot_be-fe.md`: description is display-only), staff Layer B, finalize_emit_target tile budget.

#### P2-SOT-2 — Extend existing §3.3 exemption (RC2), do not invent a parallel protect system

Today §3.3: if act **names the resolved object**, whitelist/`bed_non_sleep` must **not cascade away**.  
P1 added: if act is **travel naming the sector**, do not cascade away.  
**Gap (soft A):** act claims home/"main room" (or other place) but is **not** travel-like → exercise whitelist still remaps to Park.

**Change:** generalize the *same exemption family*: when act text claims a **sector/arena/home place** that conflicts with the *candidate remap target*, drift heuristics (`activity_whitelist`, `bed_non_sleep`) must not jump to an unrelated sector. Remap only within the claimed place, or re-resolve under that claim, or keep prior legal address — **never** invent Park/classroom that contradicts the claim.

**Hard subordinates (unchanged):** `staff_only`, `affordance_required`, privacy — still unconditional (`sot_action-location.md` §3.3).  
**Fallback (`§3.6`):** still must emit some valid address; prefer claim-consistent resolve over cross-town cascade.

**Expected effect:** Soft A class (stretch→Park, similar exercise/home lies) clears without per-verb patches.  
**Risk to watch:** over-broad token matching could block legitimate orphan-anchor redirects when description and anchor disagree (`sot_action-location.md` §7.2 — remediates in decomp, not by inventing cross-building cascades). Keep exemption tied to **conflict between claim and remap target**, not "never cascade."

**SOT debt:** document P1 named-dest protect + this generalization into `sot_action-location.md` §3.3 (currently missing from SOT).

#### P2-SOT-3 — Planner hygiene only if P2-SOT-1 is insufficient (optional, narrow)

If after P2-SOT-1, sealed scratch still shows in-place verbs during `travel_to_zone` and forensics care:

When **travel feasibility extends** duration because target is unreachable this block, rewrite sealed `act_description` to travel language toward `act_address` (align seal with §5.4), instead of keeping "ordering…".

**Do not** start with a global arrival-veto gate. That is a new crutch; if ever needed, register it in `sot_realism.md` crutches registry with a retirement path.

#### Explicitly reject

- Warping the body to match lying text (`sot_action-location.md` §5.4 must-not-ship).
- Expanding hard `activity_whitelist` intelligence (`sot_sim.md` retirement direction).
- Emit-only keyword lists ("add stretch") as the primary strategy.
- Broad arrival gates that fight dwell / `zone_patrol` without evidence that §5.2–§5.4 compliance failed.

#### Re-score gate

Vince Survival Day 1 morning: no assign where act place-claim sector ≠ address sector after drift; no player-facing in-place verb on step API while clearly `travel_to_zone` with long path; API `description` matches §5.4 travel-safe copy.

### Ship call (updated)

- Classic §12C Hobbs@Park: **PASS** on `20260728-2` (P1 subclass).
- Full honesty bar: **yellow** until **P2-SOT-1** (RC3) + **P2-SOT-2** (RC2 generalization of §3.3).
- Natural-movement ship: **HOLD**; prefer contract compliance + narrowing cascade noise over new patch layers.

