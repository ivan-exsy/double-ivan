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
4. Reject ACTION CONTRACT when sealed address ≠ named travel destination (forces fresh resolve).  
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

There are **two root causes**, not one symptom:

| # | Root cause | What it means |
|---|------------|----------------|
| **RC1** | **Inconsistent action contract is allowed to seal** | Planner may store `(act_description, act_address, mode)` where the words claim place A (or an in-place verb at A) while the sealed address / travel target is B. Downstream layers then argue about which lie to show. |
| **RC2** | **`activity_type` is treated as destination authority** | Whitelist / deterministic-guard cascade may **rewrite the address** to satisfy activity type (exercise→Park, study→classroom) **without requiring the act text to agree**. Named-travel was only the loudest subclass. |

**Secondary amplifiers (not root):** emit copy scrubbing; API/FE preferring raw planner act over emit-cleaned copy; LLM tagging "walking" as exercise / stretch as `zone_patrol`.

| Fix | Hits root? | What it actually did | Verdict |
|-----|------------|----------------------|---------|
| **P1** named-dest protect + travel detach + contract reject | **Partial RC1/RC2** | For the subclass *travel text that names a sector*, cascade may no longer steal the address. Proven on `20260728-2`: classic Hobbs@Park gone. | **Root-cause for that subclass only** — still a special-case exception to cascade, not a general "place claims in text own the address" rule. Soft A (stretch / main room → Park) is the same RC2 with a non-travel label, so it slipped through. |
| **P0** emit rewrite while travelling | **No (symptom)** | Rewrites player-facing copy when travelling so status does not say order/Hobbs while planned dest differs. Does **not** stop the planner from sealing a premature in-place verb or a wrong address. | **Band-aid / presentation layer.** Necessary as defense-in-depth, insufficient alone. On `20260728-2` soft B still visible because API prefers raw `action_progress.action_description` over emit `description`. |
| **API normalize preferring raw act** | **Amplifier** | Undoes P0 for anything that reads step/movement via gateway validation. | Must align with emit, but fixing only this without RC1 still leaves planner lies in scratch/logs. |

**Conclusion:** P0+P1 **did** fix the original ship-blocker *instance* (named walking-to-Hobbs remapped by exercise). They **did not** fully fix RC1/RC2. Soft A/B on the re-score are expected leftovers of the same roots, not unrelated new bugs.

### Recommended fix — root-cause, general (P2)

Do **not** add one-off lists ("stretch", "main room", "Hobbs") as the strategy. Encode one invariant and enforce it at seal time; keep emit/API as mirrors.

#### Invariant (the product rule)

> **At assign / contract seal, words and destination must agree.**  
> If the act text claims a place (named sector, living area, or "at/in \<place\>"), `act_address` must be that place (or a travel target toward it with travel language).  
> If the body is not yet there, the sealed act must be **travel language** to that place — never an in-place verb at a place the feet have not reached.  
> `activity_type` may choose *among addresses that already satisfy the place claim*; it must not invent a conflicting destination.

That single rule covers: Hobbs@Park, stretch@Park, order-while-travelling, coffee@OakHill-from-study-guard, and most future "status ≠ feet" cousins.

#### P2a — Planner: place-claim owns destination (fixes RC2 generally)

When post-validate / deterministic guard would remap address:

1. Extract **place claims** from act text (named sectors *and* structural claims: living area / "main room" / "at the counter" with cafe context / "in bed", etc. — from spatial vocab, not a one-off keyword dump).
2. If a place claim exists, **cascade/guard may only pick addresses under that claim**. If none are whitelist-legal, **fail closed to a travel resolve of the named place** or keep prior legal address — never jump to an unrelated arena (Park, classroom) that contradicts the claim.
3. Keep today's named-travel protect as the special case of (2), not the whole policy.

This replaces "add another protect for home stretch" with "activity_type cannot veto place claims."

#### P2b — Planner: arrival gate for in-place verbs (fixes RC1 generally)

Before sealing an in-place activity (order/eat/sip/stretch/review-at-desk/…):

1. If current tile is not in the resolved target zone → seal a **travel** sub-action to that address (or rewrite act to travel language + keep address), **not** the in-place verb.
2. Only after arrival (or same-zone) may the in-place verb become the sealed `act_description`.

Travel-feasibility duration extension without rewriting the verb is how soft B keeps happening; the gate removes that class.

#### P2c — One player-facing description channel (fixes amplifier; supports P0)

- Scratch/planner may keep raw act for internals.
- Movement SOT + API player fields (`description`, `intent`) must use the **emit-cleaned** travel-safe copy.
- `normalize_action_contract` must **not** prefer `action_progress.action_description` over top-level emit `description`/`intent` for those fields.

Without P2c, P0 remains a unit-test theater for gateway consumers.

#### Explicitly reject as strategy

- Warping the body to match lying text.
- Ever-growing verb/place allowlists as the primary fix (stretch here, coffee next).
- Emit-only patches without seal-time invariant (P0 alone).

#### Re-score gate

Same Vince Survival Day 1 morning window: zero assigns where place claim in act ≠ address sector; zero in-place verbs while `movement_mode=travel_to_zone` / path clearly in transit; API `description` matches emit travel-safe copy.

### Ship call (updated)

- Classic §12C Hobbs@Park: **PASS** on `20260728-2` (P1 subclass win).
- Full honesty bar (status = feet): **still yellow** — RC1/RC2 not fully closed.
- Natural-movement ship: **HOLD** until P2a+P2b (and P2c so players see it).

