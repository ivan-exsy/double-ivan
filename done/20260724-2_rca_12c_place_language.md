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

§12C remains **FAIL** on `20260724-2` until P0+P1 deploy and a morning-commute re-score. Natural-movement ship still blocked by 12C until then.
