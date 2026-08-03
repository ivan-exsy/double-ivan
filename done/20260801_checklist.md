# 20260801 — Pass A score paper (compressed reference)

**Status:** CLOSED as score paper · **Pass A ship = NO** · full narrative archived in git history / prior edits  
**Use this file only as baseline + RCA pointer for `20260802_checklist.md`.**

---

## Identity

| Field | Value |
|-------|--------|
| Tip | `be158e24` (Pass A) |
| Sim | `20260801-1` · UUID `e09ffe02-64c3-42ff-9d92-fa742424ae96` · PID `2378819` |
| Stop | step **2147** · graceful · `2026-08-03T00:54Z` |
| Artifacts | `generative_agents/.../storage/20260801-1/analysis/` · soak `/var/log/soak/20260801-1.log` |

**Shipped on tip:** L0 place-claim defer · piano resolver parity (starved) · S0 end-CD floor · greeting `conversation_id` · analyzer dedupe  

**Held from prior tips (do not re-litigate unless reopen):** Class P named-travel ≈0 on `20260730-1`/`20260731-1` · Class D prefer-emit · travel-defer walk→Park · dorm-@ on residual · teleports  

---

## Score @ ~1928 (stop 2147 — gate call unchanged)

| Gate | Result | Notes |
|------|--------|-------|
| Place-claim bath→Park | **0** PASS | L0 worked |
| Piano V2 / emit | **60 / 96** FAIL | vs 64 / 212; emit drop **unowned** (gates never live) |
| Chat CD honest | **461** · gap0 **0** | vs inflated 946; cafe ~62%; instrument fixed |
| effective_cd=3 | **17** partial | vs 229 |
| Dorm-@ / TELEPORT | **0 / clean** | held |
| Class P soft | **9** park-while-named-travel rows | transit-paint shape; watch |
| Vote gather | **not proven** | challenge 15/15; vote null; Hobbs skim ≤12 |
| Soft | Gap-2 **10** · APT-N **68** · OSC low | record only |
| Display / Talk Path A | OPEN / HOLD | not scored |

**Pass A ship? NO.** Public MVP? NO.

---

## RCA consensus (opinions #2–#4) — locked

**Enabling defect:** registry marks piano + mic `affordance_required: true`, but `_load_registry` omitted the field → getter always `False` → R6 / GUARD parity / post-validate / sticky skip / contract reject all starved.

**Phase 8 → piano (17):** confirmed **introducer** in early sample; **not proven primary**. Pre-flag census cannot decide L1.

**Next tip (executed):** plumb flag + real-loader contract tests → tip **`1c830aec`** · VPS PASS (piano/mic True). Score on `20260802-1`.

**Do not:** Phase-8-only special-case · mix S1/L1 on piano tip · credit Pass A for 212→96 · size S1 off pre-S0 946 (use **461**).

**Separate later:** S1 chat · L1 only after post-flag census · generator↔enriched-fields ticket · Talk Path A.

---

## Carry into `20260802` (still open / unverified)

- Early soak: `HEADLESS_STRICT_ABORT` / traceback; `PLACE-CLAIM-DEFER` / `TRAVEL-DEFER` presence  
- Class P soft (9 rows) + prefer-emit morning probe  
- Display honesty morning probe  
- Vote gather 15/15 @ hour 20  
- §9.3 CD mechanism (eff_cd=3 samples; willingness vs stamp)  
- Soft Gap-2 / APT-N / OSC  
- Post-flag: piano V2/emit vs **60/96**; gate-fired evidence **or** residual ≈0; persona-step census; mic over-rejection spot-check  
- Streak↔P8 correlate **only if** residual persists with gates live  

**Archives:** `done/20260801_deep_RCA.md` · `done/20260731_RCA.md` · `done/20260730-1_MVP_RCA.md` · `done/20260729-1_RCA.md` §13
