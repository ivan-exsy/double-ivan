# OpenRouter Migration — DeepSeek V4 + Gemini Embeddings

**Updated:** 2026-07-10 (MVP signed off on `20260709-1`) · **Branch:** merged on `railway`

---

## Goal

Replace all OpenAI dependencies with **one OpenRouter account** for both chat and embeddings.

| Layer | From | To |
|-------|------|-----|
| Tier A (micro JSON, scoring) | `gpt-5-nano` | `deepseek/deepseek-v4-flash` |
| Tier B (planning, decomp, chat) | `gpt-5-mini` | `deepseek/deepseek-v4-flash` + selective thinking on 6 hard prompts |
| Tier C (Chat with Double) | `gpt-5.2` | `deepseek/deepseek-v4-pro` |
| Embeddings | `text-embedding-3-small` (1536→768 compress) | `google/gemini-embedding-2` (768-d native) |

pgvector schema stays `vector(768)`. Out of scope: memory data model, Supabase RPC contracts.

---

## Current status

### What works ✅

| Area | Evidence |
|------|----------|
| OpenRouter plumbing | Client factory, reasoning control, json_schema + response-healing, provider prefs — on `railway` |
| Sim engine on OpenRouter | Full survival MVP proof `20260709-1` (RCA-1 + meals/sleep/P0s/vote/halluc/Class A) |
| Thinking safety | Tier A = `effort:none`; Tier B routine = `none`; 6 hard prompts = `high` + bumped `max_tokens` |
| Gemini embeddings (dev/runtime writes) | Wired in code; writes/reads work in sim runs |
| **SOT production posture** | [`sot/sot_llm.md`](../double-docs/sot/sot_llm.md) v1.7 updated 2026-07-10 → OpenRouter as VPS/`railway` prod |
| **Sim-engine MVP sign-off** | Closed via `20260705_close-for-mvp.md` / `15sim-polish.md` on `20260709-1` |

### Still pending / not production-complete ⏳

| Area | Status |
|------|--------|
| **Embedding reindex** | Script exists; full `dbl_memory` reindex not run (point of no return) — Phase 8 |
| **Gateway cutover** | Chat with Double + card summary still need OpenRouter validation — Phase 8 |
| **`railway`→`main` promotion** | Open (Step 3 ops) |
| **Retire `OPENAI_API_KEY`** | Keep until Phase 8 + promote complete |
| Naturalness Gate at full scale | Not re-certified as a formal gate this cycle |

### Sim comparison

| Sim | Tier B | Thinking | Steps | Class A | Divergence | Halluc | Cost note |
|-----|--------|----------|------:|--------:|-----------:|-------:|-----------|
| `20260629-4-OR` | Flash | high ×6 | 250 | **2** | **4.8%** | 0%* | +$0.18 Flash; pre–Tier 1 |
| `20260630-1-deep` | Flash | high ×6 | 250 | **10** | — | 0% (0/13) | Tier 1 validation — superseded by Tier 1.5 |
| `20260705-or-smoke` | Flash | — | 250 | **2** | — | 0% (0/8) | **Tier 1.5 smoke — PASSED gate** |

\*Halluc sample tiny on Run 1c (0/14 LLM location calls).

### Final validation — `20260630-1-deep` (250 steps) ✅ run complete

Fork: `soul15_seed_20260224` · 15 personas · OpenRouter Flash + Run 1c allowlist.

**Verdict: engine healthy, location gate failed.**

| Signal | 250 steps | Gate | Result |
|--------|-----------|------|--------|
| Sprite coverage | 15/15 @ 250 (100%) | — | ✅ |
| Class A | **10** | ≤5 (≤2 ideal) | ❌ **FAILED** |
| Class B | 20 | log-only | ℹ️ |
| Class C1/C2 | 1 / 0 | low | ✅ |
| V1–V3 (sleep, piano, text) | 0 issues | — | ✅ |
| LLM location hallucination | 0/13 (0%) | <5% | ✅ |
| Gap 2 staff counters | **707** non-worker hits | — | ❌ severe (inherit bypass) |
| Gap 1 kitchen objects | 113 | — | ⚠️ |

**Class A breakdown (10 bands):** 9× `parent_location_inherit_v1`, 1× `llm_location_v1`.

| Persona | Issue (plain language) |
|---------|------------------------|
| Dean Sanford | “on the **computer**” → behind supply counter (headline case) |
| Andrew Abrams | “**closet**” / “**desk**” / “**bookshelf**” → wrong room objects (×3) |
| Max Shoemaker | “**kitchen sink**” / “**refrigerator**” → dorm **desk** (×2) |
| Alexis Reed | “**sofa**” → desk; “help **desk** log” → library table |
| Diana Ogden | “making **bed**” → common room sofa |
| Mike Hooks | “out of **bed**” → common room table (may be analyzer edge — travel phrase) |

**vs Run 1c (`20260629-4-OR`, Class A 2):** Same model config, worse object-placement score on a full 15-player `soul15_seed` fork. Tier 1 layer 1 did not deliver; **10 cases = Tier 1.5 acceptance set.**

**Merge gate answers (final, updated 2026-07-05):**

| Question | Answer | Implication |
|----------|--------|-------------|
| Class A ≤ 5 @ 250 (post Tier 1.5)? | **Yes — 2** (`20260705-or-smoke`) | Smoke gate passed; proceed to 2,600-step sign-off |
| Class A ≤ 2? | **No (2)** | Acceptable for MVP |
| Gap 2 >> baseline? | **Improved** — 2 on smoke vs 707 on `20260630-1-deep` | Staff cascade still deferred |
| Proceed with branch merge? | **✅ Done** | On `railway`, VPS live |
| Promote to `main`? | **Not yet** | After 2,600-step sign-off + `sot_llm.md` |

---

```bash
LLM_PROVIDER=openrouter
LLM_MODEL_TIER_A=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_C=deepseek/deepseek-v4-pro
TIER_C_ENABLED=false
EMBEDDING_MODEL=google/gemini-embedding-2
```

### Production env (sim engine)

## Merge planning (2026-06-30)

Two active lines of work converge after Railway finishes remaining survival tasks and `20260630-1-deep` completes 250 steps.

### Branch ownership (today)

| Branch | Owns | Ahead of other |
|--------|------|----------------|
| **`railway`** | Survival MVP polish (`15sim-polish.md`): RCA-1 vote, RCA-2 meal stack, hourly FOLLOW THE PLAN, daily-plan cleanup, OpenAPI `/start` types, `diagnostic_mode` | ~12 commits vs OpenRouter on survival/planning prompts |
| **`ivan/openrouter-deepseek-v4`** | OpenRouter plumbing, Run 1c, Gemini embeddings, `_auto_assign_work_areas`, Tier 1 label↔anchor reconcile | ~9 commits on model router + location inherit |

**Low conflict overlap:** `model_router.py`, `run_gpt_prompt.py` (max_tokens), `plan.py` (both touched — reconcile vs `_ensure_meal_blocks`), `tests/analyze_action-location.py`.

**Do not duplicate on OpenRouter branch:** survival `controller.py` fixes, premiere sleep, vote supersession — Railway owns until merge.

### Railway pattern to adopt (elegant)

From `15sim-polish.md` RCA-2 forensic (diag2 → diag5):

1. **Prompt salience** — dedicated section (REQUIRED MEAL SLOTS)
2. **Parser repair** — `_clean_up_daily_plan_response` when LLM output format drifts
3. **Deterministic post-pass** — `_ensure_meal_blocks` guarantees lunch/dinner after hourly LLM

Result: 2/15 → 14/15 lunch without fighting the model further.

**Location analogue (proposed Tier 1.5):** same shape, different invariant — after `_contextual_rows_to_contract_pairs`:

- If sub-task **label names object X** and parent arena contains `:X` → force resolved address to `:X`
- If label names X but arena has no X → **detach** + independent `generate_action_location` (don't inherit wrong anchor)
- If **non-worker** on `staff_only` leaf → cascade off counter (inherit currently skips filtered tree)

Tier 1 (decomp-time reconcile) = meal layer 1. **`20260630-1-deep` suggests layer 3 is still needed** for Class A ≤5.

### Cherry-pick matrix (post-gate)

| From `railway` → integration branch | Risk | Need for MVP |
|-------------------------------------|------|--------------|
| `_ensure_meal_blocks` + tests | Low | **Yes** — Batch 3a closed on diag5 |
| `_clean_up_daily_plan_response` + RESPONSE FORMAT | Low | **Yes** — fixes `daily_req` degeneracy (meal crutch C-1 root) |
| Hourly FOLLOW THE PLAN + survival meal guidance | Low | **Yes** |
| RCA-1 vote supersession (`controller.py`) | Medium | **Yes** — trailer vote beat |
| `diagnostic_mode` / log collection | Low | Nice for VPS forensics |
| OpenAPI typed `/start` | None | DX only |

| From `ivan/openrouter-deepseek-v4` | Risk | Need for prod |
|------------------------------------|------|---------------|
| OpenRouter client + tier routing + Run 1c allowlist | Medium | **Yes** |
| Gemini embedding write path + reindex script | High (reindex = point of no return) | After sim sign-off |
| Tier 1 reconcile + inherit post-validate | Medium | **Yes** (insufficient alone) |
| `_auto_assign_work_areas` | Low | **Yes** — fixes missing `work_area` on forked baselines |
| `_tmp_*` cleanup + gitignore | None | **Yes** |

| Build fresh after merge (not on either branch yet) | |
|-----------------------------------------------------|---|
| **Tier 1.5** post-contract location pass (meal-pass pattern) | Class A gate |
| Analyzer `work_area` per persona (Gap 2 measurement) | On `railway` backlog |
| Gateway OpenRouter smoke (Chat with Double, card summary) | Phase 2 |
| Embedding full reindex | Phase 3 — irreversible |

### Merge sequence (proposal — confirm after 250-step)

Assumption: survival MVP gates pass on **`railway` + OpenAI** first; OpenRouter is validated in parallel, then unified.

```
1. Railway team: finish remaining 15sim-polish tasks (2.6k OpenAI validation, etc.)
2. OpenRouter: score `20260630-1-deep` at 250 steps
3. **Tier 1.5** from final Class A list (**10 cases** — acceptance set)
4. Integration branch (suggest: rebase `ivan/openrouter-deepseek-v4` onto `railway`)
   a. Cherry-pick / merge railway survival stack (meals, vote, cleanup)
   b. Keep OpenRouter model + embedding plumbing
   c. Add Tier 1.5 if Class A > 5
5. Single combined validation: 250-step OpenRouter on `soul15_seed` + survival checklist
6. Only then: embedding reindex → gateway → Railway deploy → retire OPENAI_API_KEY
```

**Merge gate questions — answered 2026-06-30 (250-step final); smoke re-confirmed 2026-07-05:**

| Question | Answer | Action |
|----------|--------|--------|
| Class A ≤ 5 @ 250? | **Yes — 2** (`20260705-or-smoke`) | ✅ Smoke passed; 2,600-step sign-off next |
| Class A ≤ 2? | **No (2)** | Acceptable |
| Gap 2 >> baseline? | **No on smoke** — 2 vs 707 | Staff cascade deferred |
| Merge branches? | **✅ Done** | On `railway`, VPS live |

### What we are *not* doing before merge

- Full `dbl_memory` reindex (irreversible)
- Tier 2 strict location enum (unless Class A > 5 **after** Tier 1.5)
- Survival Tier 0 premiere-sleep on OpenRouter branch in parallel (Railway owns)
- Force-push `main` or resolve conflicts autonomously

---

## Open issues — RCA summary

### 1. Action at wrong object/place (Class A)

| | |
|--|--|
| **Issue** | Sprite ends up somewhere the action text doesn't describe (e.g. "computer" in text, sprite at supply counter). ~70% of baseline Class A = decomp **anchor ≠ label text** via `parent_location_inherit_v1`. |
| **Tried** | OpenRouter Flash baseline → modestly worse than legacy. Run 1b (Pro on all Tier B) → cancelled (cost). **Run 1c** (Flash + thinking on decomp/plan/location) → Class A **24→2**, divergence 5.7%→4.8%. |
| **Still failing** | ~~`20260630-1-deep` final: Class A 10~~ → **smoke Class A 2** (`20260705-or-smoke`). Residual: 2 library inherit cases (Alexis Reed). Issue 2 cafe refrigerator deferred. |
| **Next** | **2,600-step sign-off run** on `railway` VPS. Optional: tighten library inherit if Class A regresses on full run. |

### 2. Staff-zone violations (measurement + engine)

| | |
|--|--|
| **Issue** | Non-workers placed in cafe/pub kitchens. Headline counts (~2k baseline, ~332 Run 1c) are mostly **analyzer noise** — `STAFF_BYPASS` hardcoded to Luba only. True work_area-aware violations ≈ 1.3% (Max Shoemaker cross-venue). |
| **Tried** | Run 1c did not target this. Staff gates exist on direct LLM path but **not on inherit path** (~88% of staff-tile placements use inherit). |
| **Still failing** | Gap 2 **2** on `20260705-or-smoke` smoke (Owen @ pub counter) — down from 707 on `20260630-1-deep`. Staff cascade on inherit still deferred. |
| **Next** | Monitor on 2,600-step sign-off; staff cascade (Tier 1b) if Gap 2 spikes on full run. |

### 3. LLM location hallucination — **MVP CLOSED**

| | |
|--|--|
| **Issue** | Unified location resolver picks addresses not in maze (was ~14% at 2,600 on two runs). |
| **Tried** | Run 1c thinking + tokens; map/prompt Tier 1; **`max_tokens` 100→800** (token-budget fix). |
| **MVP result** | **`20260708-mvp-a` @ 2,600: 0.6% (4/675)** — gate &lt; 5% **PASS**. |
| **Next** | Tier 2 flat-enum deferred to Path B / post-MVP (`20260708_hallucinations.md`). Do not block launch. |

### 4. Survival / trailer beats (Tier 0)

| | |
|--|--|
| **Issue** | Post-vote agents don't go home; premiere sleep invariant (bed tile) — confirmed on legacy `20260628-4`, not OpenRouter-specific. |
| **Tried** | Not on OpenRouter branch. **Railway today:** RCA-1 vote supersession; RCA-2 meal stack (`_ensure_meal_blocks`, cleanup, templates). |
| **Still failing** | Post-vote go-home; premiere sleep — **✅ validated `20260703-or-2`** on merged `railway`. |
| **Next** | Included in 2,600-step sign-off re-score (redundant for survival alone; one final combined run). |

### 5. Embeddings cutover

| | |
|--|--|
| **Issue** | Existing `dbl_memory` rows still OpenAI-embedded; Gemini vectors live in a different space. |
| **Tried** | Gemini wired in dev; reindex script written; not executed on full corpus. |
| **Still failing** | Production retrieval still on OpenAI vectors until reindex. Rollback after reindex requires re-reindex. |
| **Next** | After sim-engine sign-off: `reindex_embeddings.py --dry-run` → full run → retrieval spot-checks. |

### 6. Gateway + production cutover

| | |
|--|--|
| **Issue** | Chat with Double (Tier C Pro) and card summary not validated on OpenRouter in gateway; prod still on OpenAI key. |
| **Tried** | Sim engine only. |
| **Still failing** | Gateway paths untested end-to-end with Gemini retrieval + Pro chat. |
| **Next** | Phase 2 gateway smoke → Phase 3 full validation → Railway deploy → retire `OPENAI_API_KEY`. |

---

## Completed — brief log

| Item | Outcome |
|------|---------|
| **Phase −1 spike** | Thinking-off, json_schema, Gemini 768-d confirmed (`tests/openrouter_spike.py`) |
| **Phase 0 code** | OpenRouter client, reasoning per tier, structured outputs, embedding switch, reindex script |
| **Smoke sims** | `20260628-2/3-openrouter` — daily plans non-empty |
| **15-player baseline** | `20260628-10-openrouter` ~921 steps; RCA + naturalness report |
| **Thinking on tiny tokens** | Fixed: Tier A `effort:none` + `exclude:true`; was burning `max_tokens=4` budgets |
| **Run 1b cancelled** | Pro on all Tier B — 3× input cost, not viable |
| **Run 1c** | 6-prompt allowlist + token bumps; `20260629-4-OR` pass; adopted as Tier B posture |
| **Tier 1** | `_reconcile_anchor_with_label` + inherit post-validate; 10 unit tests; lazy-bind for circular import |
| **`20260630-1-deep`** | Tier 1 validation fork — 250 steps, Class A 10 — superseded by Tier 1.5 |
| **Tier 1.5 stages 1–2** | Orphan-anchor redirect + post-validate exemption; SOT v1.7 §7.7 |
| **`20260705-or-smoke`** | Tier 1.5 smoke — **Class A 2** ✅ (gate ≤5) |
| **Merge to `railway`** | `--no-ff` merge `a7cff6bc`; OpenRouter cutover live on VPS |
| **`20260703-or-2`** | Full 2,600 survival validation — meals/sleep/RCA-1 all green |
| **Legacy sanity** | `20260628-4` (OpenAI, 3k) already had object/fixture gaps — OpenRouter not a new failure mode |

**Run 1c config detail (for reference):** thinking ON + raised `max_tokens` on: `task_decomp_contextual` (3500), `task_decomp_contextual_repair` (3000), `daily_plan` (1200), `external_replan` (800), `generate_conversation_batch` (1500), `action_location_unified` (100).

---

## Path to "migration complete"

**Revised order** (merge-aware, updated 2026-07-05):

1. ~~Railway: finish `15sim-polish` + survival validation~~ ✅ `20260703-or-2`
2. ~~OpenRouter: Tier 1.5 smoke~~ ✅ `20260705-or-smoke`, Class A 2
3. ~~**Merge** OpenRouter onto `railway`~~ ✅ deployed VPS
4. ~~**2,600-step sign-off run**~~ — `20260708-mvp-a` location PASS; **`20260709-1` survival MVP PASS** (RCA-1 closed)
5. ~~Update `sot_llm.md` production posture~~ ✅ v1.7 (2026-07-10)
6. Embedding reindex (dry-run → full) — **Phase 8 open**
7. Gateway smoke (Chat with Double + card summary) — **Phase 8 open**
8. `railway`→`main` promotion; retire `OPENAI_API_KEY`; 24h monitor — **Step 3 ops open**

**Deferred:** Tier 2 flat-enum — Path B / post-MVP (hallucination already &lt; 5%).

---

## References

- SOT: `double-docs/sot/sot_llm.md`, `sot_memory.md`, `sot_lifecycle.md`
- Survival MVP: `double-docs/15sim-polish.md` (RCA-2 meal-pass forensic, crutch C-1)
- Router: `reverie/backend_server/persona/prompt_template/model_router.py`
- Reports: `tests/reports/!20260628-10-openrouter_naturalness_report.md`
- Worklog: `double-docs/worklog.md` (2026-06-30 Railway + OpenRouter entries)
