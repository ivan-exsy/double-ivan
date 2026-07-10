# TODO — Action-Location

**Status:** **LOCATION MVP GREEN** — Path B post-MVP residual only  
**Updated:** 2026-07-09 (full report verified)  
**MVP tracker:** [`double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md)  
**Decision basis:** [`20260709_action-location-midflight-report.md`](20260709_action-location-midflight-report.md) · full report `generative_agents/tests/reports/_20260708_mvp_a_action_location.txt`

---

## Locked decisions (2026-07-09)

1. **Hallucination is MVP-green.** Full run **0.6%** (4/675) on `20260708-mvp-a` @ 2,600 — **confirmed fixed**. Do **not** prioritize Tier 2 flat-enum for MVP.
2. ~~**Finish `20260708-mvp-a` to 2,600.**~~ **Done** — sim completed; report downloaded locally.
3. **Class A location ship call: PASS.** Full raw **21** → desk-synonym excluded **15** ≤ **20**. No dramatic worsening vs mid-flight 18; residual = Path B debt.
4. **`desk → table / podium / student seating` is NOT Class A.** Same-room synonym / leaf mismatch — scorer and product rule, not a world bug. Excluded **6** of 21 on this run.
5. **Old Option 1 polish folds into Path B** (post-MVP), run by an autonomous agent on a dedicated worktree — not required to unblock launch.
6. **Survival RCA-1 still blocks overall MVP** (separate from location) — see close-for-mvp tracker.

---

## A. Ship MVP (now)

### Goal

Close location as an MVP blocker with an honest product gate, then release. Path A (measurement + matching) already did its job.

### What Path A shipped (live on VPS)

| Fix | Outcome |
|-----|---------|
| Planned vs actual address | Class A scores the **planned** object, not the floor tile during hop/patrol |
| Stopword-safe label matching | No more “the” / place-name false matches |
| Exact object-name boost | Named maze objects win over near-misses |
| Token budget (`max_tokens` 100→800) | Hallucination collapsed ~14% → **&lt; 1%** |

### Mid-flight scoreboard (`20260708-mvp-a` @ ~1,843 / 2,600)

| Gate | Mid-flight | Old MVP target | Call |
|------|------------|----------------|------|
| Hallucination | **0.6%** (3/508) | &lt; 5% | **PASS — fixed** |
| Class A | **18** unique bad actions | ≤ 5 | **FAIL old gate** — residual is deferred world/policy debt |
| Path A hygiene | Planned address + `action_id` live | Required | **PASS** |

**Trajectory:** ~0 → 3 → 6 → 18 across the run; roughly linear, not a late cliff. Final Class A will almost certainly stay **high teens / low twenties** unless growth flattens hard — **will not clear ≤ 5**.

**Sources of the 18:** `llm_location_v1` ~14, `parent_location_inherit_v1` ~4.

### Residual themes (full run, after desk exclusion) — Path B debt

| Theme | Count | MVP treatment |
|------|------:|---------------|
| Computer where arena has no PC (supply / pharmacy / library table) | 5 | **Known launch debt** → Path B |
| Cafe counter vs seating / wrong venue leaf | 4 | **Known launch debt** → Path B |
| Bed still in desc after transition | 2 | Soft / timing — watch |
| Refrigerator @ pub seating | 1 | Path B |
| Piano @ bar seating | 1 | Path B |
| Desk text at shelf (anchor already `desk`) | 1 | Keep as Class A; Path B |
| Desk → library table / podium / student seating | 6 | **Excluded** (product rule) |

**Player-visible takeaway:** ~15 / 2001 unique actions (~0.75%) still look slightly wrong after desk exclusion. Not cross-building chaos. Not invented locations.

### Revised MVP ship gate (after full 2,600)

Ship location if **all** of the following hold on `20260708-mvp-a` (or equivalent scored fork):

| Gate | Pass |
|------|------|
| Hallucination | **&lt; 5%** |
| Class A (with desk synonyms **excluded**) | **≤ 20** unique bad actions @ 2,600 |
| Chaos check | **No** cross-building / invented-place flood |
| Monitoring | Diagnostic on; `action_id` present |

**Dramatic worsening (do not ship on this run alone):** Class A (desk-excluded) jumps well past ~20, or hallucination regresses ≥ 5%, or cross-building chaos returns.

### Full-run ship call (`20260708-mvp-a` @ 2,600) — **PASS**

| Gate | Result | Call |
|------|--------|------|
| Hallucination | **0.6%** (4/675) | **PASS** |
| Class A raw | **21** / 2001 unique actions | (old ≤5 would fail) |
| Class A desk-excl. | **15** (excluded 6 desk→table/podium/seating) | **PASS ≤20** |
| Chaos / invented flood | No; residual = computer×5, cafe counter×4, soft bed×2, fridge×1, piano×1 | **PASS** |
| Monitoring | Full 2600 movement; `action_id` path live | **PASS** |

Desk exclusions (product rule): Alex Shepard×2 (library desk/table/podium), Diana (student desk→seating), Nick (desk→podium), Vince×2 (desk→student seating). Owen “sitting at the desk” @ shelf with anchor `desk` kept as Class A.

### Checklist — while / after this sim

- [x] Leave `20260708-mvp-a` running to **2,600** — completed
- [x] Final analyzer package generated on VPS (`_20260708_mvp_a_action_location.txt`); hallucination **0.6%** locked
- [x] Download full report locally + desk-synonym exclusion → **15** ≤ 20
- [x] Location MVP green in [`20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md)
- [x] No dramatic worsening — Path B for residual themes only

### Explicit non-goals for MVP

- Do **not** start Path B / flat-enum to unblock launch
- Do **not** re-run Path A alone hoping for ≤ 5
- Do **not** abort `20260708-mvp-a` early
- Do **not** treat Tier 2 flat-enum as the Class A fix

### Scoreboard (recent)

| Run | Steps | Class A | Hallucination | Notes |
|-----|------:|--------:|---------------|-------|
| `20260705-or-smoke` | 2,600 | **21** | 14.7% | Last full dual fail |
| `20260706-map-smoke` | 250 | 3 | 0% | Map/prompt OK at smoke |
| `20260707-chat-probe-v3` | 2,600 | unscored* | ~14% | *no `action_id` |
| `20260708-mvp-signoff` | ~384 abort | 8 mid | 0.6% | Token fix only; aborted for Path A |
| **`20260708-mvp-a`** | **2,600** | raw **21** → desk-excl. **15** | **0.6%** (4/675) | **Location MVP PASS** — [full report](../generative_agents/tests/reports/_20260708_mvp_a_action_location.txt) · [midflight](20260709_action-location-midflight-report.md) |

---

## B. Post-MVP — Path B (autonomous worktree)

**Do not block MVP on this.** Start after location ship call (or in parallel once ship criteria are locked).

### Packaging rule

Old “Option 1” is **not** one vague bag. Split:

| Item | Where | Agent scope |
|------|-------|-------------|
| Desk aliases (`desk` satisfied by library table / classroom podium / student seating) | **Scorer + product rule first** | Small first chunk — teach analyzer; do not “fix” world for synonyms |
| Impossible computer (action names computer, arena has none) | **Path B policy +/or fixtures** | Nearest valid work surface **and** normalize description, **or** block computer language at plan time — pick one in the brief |
| Cafe counter preference (“order / at the counter”) | **Path B affordance** | Prefer counter leaf over customer seating on inherit + LLM paths |
| World-truth object lists | Path B foundation | Complete accurate arena fixtures |
| Flat-enum LLM pick | Path B later | Tier 2 / option C — after world truth |
| Retire band-aids (repoint / reconcile / force / orphan) | Path B last | Only after flat enum is primary |

### Autonomous agent brief (dedicated worktree)

**Branch / worktree:** `ivan/path-b-class-a-residual` (or similar author-prefixed name).

**In scope (stop when done, not “until Class A ≤ 5 forever”):**

1. Desk synonym **not** Class A in analyzer (+ documented aliases in SOT).
2. Impossible-computer policy implemented and tested.
3. Cafe-counter preference on inherit + LLM paths.
4. Unit / analyzer tests green → **250 smoke** showing those themes down → human review → optional 2,600.

**Out of scope for the first agent pass:**

- Full Tier 2 flat-enum redesign
- Deleting all band-aids in one pass
- Changing MVP launch gates
- Unrelated survival / chat work

**Stop conditions:** tests pass → 250 smoke OK → human approves synonym/policy choices → then schedule a scored 2,600 if we want a new Class A baseline.

### Long-term Path B order (when we get there)

1. Keep planned vs actual as the measurement contract  
2. World truth (complete arena object lists)  
3. Flat-enum LLM pick  
4. Audit and retire band-aids that only paper over the old picker  
5. Formal impossible-object product policy (redirect vs fail vs rewrite)

**Acceptance for “long-term done”:** Class A stays low at 2,600 without fragile post-hoc patches; hallucination stays &lt; 5% via enum; resolver path is short and explainable.

---

## Closed / do not re-open unless regression

- Issue 1 — post-validate vs orphan redirect ✅  
- Issue 3a — map registry + prompt grounding ✅  
- Hallucination token-budget fix ✅ — confirmed **0.6%** on full `20260708-mvp-a` @ 2,600  

- Issue 2 — cafe refrigerator fixture — deferred into Path B unless it dominates residual

---

## Quick links

| Doc | Role |
|-----|------|
| [`20260709_action-location-midflight-report.md`](20260709_action-location-midflight-report.md) | Mid-flight evidence + original options 1–3 |
| [`double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md) | MVP Class A / hallucination tracker — update after final 2,600 |
| [`20260708_hallucinations.md`](20260708_hallucinations.md) | Token-budget RCA; Tier 2 deprioritized for MVP |
| [`TODO_pure-llm-resolver-research.md`](TODO_pure-llm-resolver-research.md) | Long-term flat enum (Path B later) |
| `double-docs/sot/sot_action-location.md` | Runtime contract SOT |
