# TODO — Action / location & movement realism — **RETIRED**

**Retired:** 2026-07-20  
**Code:** `ivan/action-location` (generative_agents)  
**Score checklist:** [`20260720_launch.md`](./20260720_launch.md) § **20260720-1**  
**Full RCA + ship notes (archive):** [`done/20260720_TODO_action-location.md`](./done/20260720_TODO_action-location.md)

## What this was
Bodies, places, labels, and movement naturalness after Survival Keep/gather/§11 already passed on `20260717-1`. Not a Survival Light checklist.

## What shipped (one screen)

| # | Outcome |
|---|---------|
| R1 staff zones | Phase-8 staff-evict + pick skip `staff_only`; display prefer non-staff label (no body warp) |
| R2 place language | Presence vs intent at emit (`heading to` + `@` presence) |
| R3 teleports | `finalize_emit_target` — zone-anchor must not undo speed clamp mid-travel |
| R4 cooldown | Analyzer matches end depth tiers; **no** gather mute / no runtime policy change |
| R5 Apartment N | Analyzer true-home suppress |
| R6 piano | Skip `affordance_required` unless action matches |
| R7 leaf thrash | Semantic sticky + in-place modes |
| R8 chat shells | Analyzer ignores `(from description)` partners |
| R9 oscillation | Watch only |

## Where truth lives now
- **Normative:** `double-docs/sot/sot_action-location.md` · `sot_realism.md` · `sot_be-fe.md`
- **Verify next sim:** `20260720_launch.md` §20260720-1
- **Do not re-open** from archived RCA “Fix suggestions” that were retracted (full BE paths, label=plan, gather mute/reseat, second global clamp).

