# Checkpoint 1 Update

**Date:** 2026-04-03  
**Branch:** `integration/20260330-local-hardening-rebuild`  
**Baseline:** sim `20260330-1` (190 steps, 4 personas)  
**Validation:** `20260403-3` (200 steps, full Supabase + OpenAI, detailed report attached)

---

## Status: 6/6 Items Done

| Item | Status | What was done |
|------|--------|--------------|
| A — Greeting → full chat | ✅ Done | Greeting escalation: after 1 greeting, the next proximity trigger promotes to full conversation. 3 pairs converse naturally, 24 chat steps across 200 steps. |
| B — Wrong bed / private rooms | ✅ Done | Privacy filter propagated to all 3 location resolution paths. 0 Studio Room violations in 200 steps. Ivan goes to his own Dorm Room 1. |
| C — Duration overflow | ✅ Done | Travel feasibility capped to maze physical limits (60 min max travel). Max duration: 180 min (was 1487 min). 0 actions >300 min (was 310). |
| D — Social descriptions | ✅ Done | Two-layer defense: prompt rules + runtime guards with location-aware replacements. 0 violations in 200 steps. |
| E — Object relocation | ✅ Done | Settlement override + anchor_radius alignment + zero padding for object-level zones + stationary recovery. Personas reach correct object tiles. |
| F — Greeting bubble | ✅ Done | BE populates per_message_duration for greetings (6s floor). FE timestamp=0 falsy bug fixed. |

---

## Validation: 20260403-3 vs 20260330-1

| Metric | Baseline | 20260403-3 | Status |
|--------|----------|------------|--------|
| Wrong room visits | Present (steps 127+) | **0** | ✅ Fixed |
| Duration overflow | Max 1487 min, 310 >300min | **Max 180 min, 0 >300min** | ✅ Fixed |
| Greeting escalation | Stuck at greeting | **Greeting → full chat in 3 steps** | ✅ Fixed |
| Social descriptions | Present | **0 violations** | ✅ Fixed |
| Conversation pairs | 2 | **3** | ✅ Improved |
| Chat steps | 14 | **24** | ✅ Improved |
| First conversation | Step 69 | **Step 8** | ✅ 8x faster |
| Luba movement | 3 positions (94% stationary) | **63 positions (68% stationary)** | ✅ Major improvement |

Full per-persona analysis, conversation breakdown, and remaining issues in the attached report: `past-sims-reports/20260403-3/20260403-3_report.md`

---

## Known issues (not regressions)

1. **Ivan's bootstrap data:** His `lifestyle` and `daily_plan_req` in scratch.json reference activities that don't exist in the simulated world ("drives for Uber", "family dinner"). The LLM generates a plan with these, but the runtime can't resolve them to map locations → falls back to the desk. The other 3 personas reference real locations (library, Hobbs Cafe, campus) and work correctly. Fix: update Ivan's bootstrap data to reference map-valid activities.

2. **Luba wrong-sector bathroom:** Went to Studio Bathroom (~130 tiles away) instead of Dorm bathroom (~5 tiles). Not a privacy issue — the system doesn't rank candidates by distance. Fix requires distance-aware location ranking (Phase 2).

3. **Conversation context:** Conversations don't know how long personas will be together. Can produce mismatched dialogue. Designed context-aware params for Phase 2.

---

## Commits

### BE (on `integration/20260330-local-hardening-rebuild`)

```
70373ef1 — Greeting escalation: promote to full chat after greetings
f4148857 — Lower escalation threshold to 1: greet once then full chat
8e2d46ec — Cap travel feasibility extension to maze physical limits
d651465b — Settlement override for non-object tiles
2aa23d47 — anchor_radius=0 alignment + greeting bubble 6s floor
1a1ee694 — Propagate privacy filter to all location resolution paths
f4f7116b — Cafe settlement: remove padding + stationary recovery
b2f9b9b6 — Social action filter: prompt rules + runtime guards
```

### FE (on `local` branch of double-front)

```
c8e526d — Fix greeting bubble: timestamp !== undefined
```

---

## Structural findings for Phase 2

During this work I traced several root causes that go deeper than the 4 original items. Documented with code-level detail:

**Conversation system:**
- Greeting tier uses hardcoded templates — redundant, the LLM naturally greets in full conversations
- Conversations have zero temporal context (overlap time, next actions)
- 20-step cooldown is arbitrary — should be proportional to co-location time

**Location system:**
- Three systems (plan.py, execute.py, reverie.py) use different criteria for "arrived at destination" — no single authority
- Location candidates are distance-blind — personas can be sent across the map when a closer option exists
- FE headless can overwrite backend positions without validation

**Bootstrap data quality:**
- Ivan's persona references impossible activities (Uber, family dinner) — causes location fallback loops
- The runtime should handle unresolvable activities gracefully instead of silent fallback to desk
- Persona bootstrap data should be validated against available map locations

All documented with designs and estimates, ready for Phase 2 discussion when you want.
