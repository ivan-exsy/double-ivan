# RCA — §12C place language (Vince)

**Original sim:** `20260724-2` (Vince steps 5827–5895)  
**Re-score:** `20260728-2` @ tip `b230c4be` (Survival Day 1 morning ≈ 1448–1496; day boundary ~1050 @ 00:00)  
**Symptom:** Action text names one place while body / planned address is another (classic: "walking to Hobbs" @ Johnson Park).

## Verdict

Body/`@` presence are mostly honest. The lie is **act text vs sealed `act_address`**, often created by **activity_type whitelist cascade** (exercise → Park), then amplified by emit/API showing raw act.  
**P1 fixed** the classic named-travel Hobbs@Park subclass. Soft residuals remain (below). NM ship: **HOLD** (yellow honesty).

## Player-visible failure modes

1. **Split destinations** — act says Hobbs; sealed plan is Park; emit glues both → `walking to Hobbs (heading to Johnson Park)`.
2. **Premature in-place verbs** — "ordering / eating / reviewing…" while still `travel_to_zone`.
3. **UI/API amplifier** — short `intent` / nested `action_progress.action_description` preferred over emit-cleaned `description`.

## Causal chain (original ship-blocker)

1. Decomp emits travel row (`walking to Hobbs…`) tagged `activity_type=exercise`.
2. Inherit + post-validate: exercise not allowed at cafe-ish address → **Tier-2 whitelist cascade** → Johnson Park.
3. Label stays "walking to Hobbs"; address is already Park.
4. ACTION CONTRACT reuses sealed address; assign never checks label↔dest match.
5. Emit (pre-P0) glues conflicting places; FE often shows short act.

**Same family on `20260724-2`:** Hobbs-label + Park-addr at 30, 1780, 2017, 5827, 5874.  
**Not broken:** fresh Hobbs resolve, path persist, presence geocode, emit framework (fed bad inputs).

**Contributing gaps (pre-fix):** travel typed as exercise; `_label_is_travel` missed `"walking to "`; contract short-circuit; emit conflict scrub missing.

## What shipped (P0 / P1)

| Fix | Change | Effect on `20260728-2` |
|-----|--------|------------------------|
| **P0** emit honesty | Travel rewrite from planned dest; force walking copy for in-place verbs; safe `intent` | Unit-tested; **live score still showed raw "order…"** via API |
| **P1** planner | Named-dest protect (no whitelist cascade when travel names sector); `"walking to "` = travel; travel detach; reject mismatched ACTION CONTRACT | Classic Hobbs/Oak Hill @ Park **gone**; soak `POST-VALIDATE keep named dest` ~48 |

Do **not** warp body to match lying text.

## Soft residuals after P1 (`20260728-2`)

| Case | What player sees | Mechanism |
|------|------------------|-----------|
| **A** ~1448–1474 | "stretching in the main room" while walking to Park | Same cascade family: `activity_type=exercise` → Tier-2 Park; inherit; **not** travel-named so P1 protect does not apply |
| **B** ~1475–1485 | "order breakfast…" while path_len≈7 to Hobbs | Address now **correct** (P1 win); verb vs feet. P0 should rewrite at emit, but gateway prefers raw `action_progress.action_description` over emit `description` |
| **C** ~1530 | "sip coffee…" remapped toward Oak Hill | Study guard / orphan-anchor — same broad family; secondary |

## Roots (for validating next fixes)

| # | Root | Meaning |
|---|------|---------|
| **RC1** | Inconsistent seal | Act claims place/activity A while address / travel state is B |
| **RC2** | Cascade as destination authority | Whitelist/guard remaps address for activity_type even when act claims another place |
| **RC3** | Display ignores emit contract | API/FE serve raw planner act over §5.4 cleaned copy |

| Fix | Hits root? | SOT fit |
|-----|------------|---------|
| P1 | Partial RC1/RC2 (travel-named only) | Spirit of `sot_action-location` §3.3; **not yet documented in SOT** |
| P0 | RC3 layer only | Matches §5.4 **if** all §5.2 surfaces carry it |
| API prefer raw act | **Causes RC3** | Violates §5.2 nested sanitize + `sot_be-fe` presence/intent fields |

## SOT cross-check (reject / accept)

Refs: `sot_action-location` §3.3–3.6, §5.2/§5.4; `sot_be-fe` §2.4; `sot_realism` crutches (empty); `sot_sim` whitelist retirement / hard-gate scarcity.

| Idea | Verdict | Why |
|------|---------|-----|
| Prefer emit copy on API | **Do** | Already required; clears soft B if P0 ran; low regress risk |
| Extend §3.3 place-claim exemption (non-travel) | **Do carefully** | Same family as P1; stops soft A without new keyword lists |
| Broad new "place owns dest" gate | Over-build risk | Can fight orphan-anchor, §3.6 must-emit-address, staff/privacy |
| Hard arrival gate before in-place seal | **Reject as primary** | New crutch; fights dwell/`zone_patrol`; SOT assigns travel honesty to emit |
| Stretch / "main room" keyword protect | **Reject** | Patchwork; noisier with smarter models |
| Expand hard `activity_whitelist` | **Reject** | Anti-`sot_sim` retirement direction |

## Recommended next fixes (order)

**P2-SOT-1 (first) — close RC3.** Gateway must not replace emit-cleaned player fields with raw planner act. Prefer top-level emit `description`/`intent`; keep nested progress §5.4-consistent when `travel_to_zone`.  
*Expected:* soft B clears without planner change. *Does not touch:* pathfinding, staff Layer B, tile budget.

**P2-SOT-2 — extend §3.3 (RC2).** When act claims a sector/arena/home that conflicts with the *candidate remap*, `activity_whitelist` / `bed_non_sleep` must not jump to an unrelated sector (remap within claim, re-resolve under claim, or keep prior legal address). `staff_only` / affordance / privacy stay unconditional; §3.6 still requires some valid address. Tie exemption to **claim vs remap conflict**, not "never cascade."  
*Expected:* soft A class clears. *Watch:* over-broad tokens vs legitimate orphan-anchor (§7.2).  
*SOT debt:* document P1 + this extension under §3.3.

**P2-SOT-3 (optional) — seal hygiene.** Only if P2-SOT-1 insufficient for forensics: when travel feasibility extends because dest unreachable, rewrite sealed `act_description` to travel language. Not a global arrival veto; if ever added, register as crutch with retirement path.

## Re-score gate / ship

- Vince Day1 morning: no assign where act place-claim sector ≠ address sector after drift.
- No player-facing in-place verb on step API while clearly `travel_to_zone` with long path.
- API `description` matches §5.4 travel-safe copy.
- Classic §12C: **PASS**. Full honesty: **yellow** until P2-SOT-1 + P2-SOT-2. NM ship: **HOLD**.
