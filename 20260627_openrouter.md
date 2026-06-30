# OpenRouter Migration — DeepSeek V4 + Gemini Embeddings

**Updated:** 2026-06-30 (eve) · **Branch:** `ivan/openrouter-deepseek-v4`

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
| OpenRouter plumbing | Client factory, reasoning control, json_schema + response-healing, provider prefs — branch `ivan/openrouter-deepseek-v4` |
| Sim engine on OpenRouter | 15-player survival runs complete (`20260628-10-openrouter` ~921 steps; `20260629-4-OR` 250 steps) |
| Thinking safety | Tier A = `effort:none`; Tier B routine = `none`; 6 hard prompts = `high` + bumped `max_tokens` |
| Run 1c config adopted | Flash + selective thinking; +$0.18/250 steps; Class A 24→2 |
| Gemini embeddings (dev) | Wired in code; writes/reads work in sim runs |
| Legacy comparison | OpenAI `20260628-4` was already weak at object/fixture level — OpenRouter gap is ~1.7× on divergence, not a clean→broken regression |

### Still pending / not production-ready ⏳

| Area | Status |
|------|--------|
| **Tier 1 code** (location engine) | **Implemented (layer 1)** — label↔anchor reconcile + inherit post-validate; unit tests pass. **In-flight validation `20260630-1-deep`:** Class A **8** at ~157 steps (all `parent_location_inherit_v1`) — **above ≤5 gate**; final read pending at 250. Likely needs **layer 2** post-contract pass (see §Merge planning). Analyzer `work_area` fix still pending on `railway`. |
| **Tier 0 survival** (trailer beats) | **On `railway`** — RCA-1 vote supersession, RCA-2 meal stack (`_ensure_meal_blocks`, cleanup, hourly FOLLOW THE PLAN). Not on OpenRouter branch yet. |
| **Embedding reindex** | Script exists; full `dbl_memory` reindex not run (point of no return) |
| **Gateway cutover** | Chat with Double + card summary still need OpenRouter validation |
| **Merge + production** | Branch not on `main`; `OPENAI_API_KEY` still in prod posture |
| **SOT sign-off** | `sot_llm.md` not updated; Naturalness Gate at full scale not re-certified |

### Sim comparison

| Sim | Tier B | Thinking | Steps | Class A | Divergence | Halluc | Cost note |
|-----|--------|----------|------:|--------:|-----------:|-------:|-----------|
| `20260628-10-openrouter` | Flash | none | ~921 | 24 | 5.7% | 7.5% | Baseline |
| `20260629-4-OR` | Flash | high ×6 | 250 | **2** | **4.8%** | 0%* | +$0.18 Flash |

\*Halluc sample tiny (0/14 LLM location calls). Run 1b (all Tier B on Pro) cancelled — 3× input cost.

### Production env (sim engine)

```bash
LLM_PROVIDER=openrouter
LLM_MODEL_TIER_A=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_C=deepseek/deepseek-v4-pro
TIER_C_ENABLED=false
EMBEDDING_MODEL=google/gemini-embedding-2
```

| `20260629-4-OR` | Flash | high ×6 | 250 | **2** | **4.8%** | 0%* | +$0.18 Flash |
| `20260630-1-deep` | Flash | high ×6 | **250** (in progress) | **8** @ ~157† | TBD | 0% (9/9 LLM loc) | Tier 1 validation fork |

\*Halluc sample tiny (0/14 LLM location calls on Run 1c).  
†Mid-flight snapshot before run completed; re-score at 250.

### In-flight validation — `20260630-1-deep`

Fork: `soul15_seed_20260224` · 15 personas · OpenRouter Flash + Run 1c allowlist.

**Engine health (good):** all 15 sprites at 100% step coverage; no V1–V3 regressions; LLM location hallucination 0/9; movement/pathfinding normal.

**Tier 1 gate (cautious):**

| Signal | ~157 steps | Notes |
|--------|------------|-------|
| Class A | **8** (target ≤5 at 250) | All inherit-path; includes Dean “computer” → supply counter |
| Class B | 20 | Log-only payload desync |
| Gap 2 staff counters | **395** non-worker hits | Inherit bypasses filtered LLM tree; `work_area` / post-validate not enough |
| Gap 1 kitchen objects | 99 | Some legitimate worker placement |

**Interpretation:** Tier 1 reconcile **fires in logs** (`LABEL↔ANCHOR RECONCILE`, `INHERIT POST-VALIDATE`) but **does not close Class A** the way Run 1c alone did on `20260629-4-OR`. Same plateau the Railway team hit on meals: **prompt/decomp-time fix ≠ guaranteed invariant.**

**Decision deferred until 250-step final** `analyze_action-location.py` run.

---

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
3. Decide Tier 1.5 scope from final Class A list (8 cases = acceptance set)
4. Integration branch (suggest: rebase `ivan/openrouter-deepseek-v4` onto `railway`)
   a. Cherry-pick / merge railway survival stack (meals, vote, cleanup)
   b. Keep OpenRouter model + embedding plumbing
   c. Add Tier 1.5 if Class A > 5
5. Single combined validation: 250-step OpenRouter on `soul15_seed` + survival checklist
6. Only then: embedding reindex → gateway → Railway deploy → retire OPENAI_API_KEY
```

**Merge gate questions (answer after 250-step):**

| Question | If yes | If no |
|----------|--------|-------|
| Class A ≤ 5 at 250? | Tier 1.5 optional / smaller | **Must ship** post-contract pass before merge to main |
| Class A ≤ 2 (Run 1c bar)? | Tier 1 sufficient; investigate 8 @ 157 as morning-routine noise | Same as above |
| Survival 2.6k passes on `railway`? | Merge survival into integration branch | Hold prod merge; OpenRouter work can continue on side |
| Gap 2 still >> baseline? | Prioritize `work_area` analyzer + staff filter on inherit | Defer Tier 2 enum |

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
| **Still failing** | Run 1c: 2 bands on `20260629-4-OR`. **Tier 1 shipped** but `20260630-1-deep` mid-flight: **8 Class A @ ~157**, all inherit — Dean computer/counter still present. |
| **Next** | **Await 250-step final.** If >5: **Tier 1.5** post-contract pass (Railway meal-pass pattern). If ≤5: merge Tier 1 as-is. |

### 2. Staff-zone violations (measurement + engine)

| | |
|--|--|
| **Issue** | Non-workers placed in cafe/pub kitchens. Headline counts (~2k baseline, ~332 Run 1c) are mostly **analyzer noise** — `STAFF_BYPASS` hardcoded to Luba only. True work_area-aware violations ≈ 1.3% (Max Shoemaker cross-venue). |
| **Tried** | Run 1c did not target this. Staff gates exist on direct LLM path but **not on inherit path** (~88% of staff-tile placements use inherit). |
| **Still failing** | Real violations persist; `20260630-1-deep` Gap 2 = **395** counter hits — inherit path bypasses staff-filtered tree. |
| **Next** | `work_area` analyzer fix on `railway`; staff cascade on inherit (Tier 1b); Tier 1.5 post-pass for non-workers. |

### 3. LLM location hallucination

| | |
|--|--|
| **Issue** | Unified location resolver picks addresses not in maze (7.5% on baseline, 24/319 calls). |
| **Tried** | Run 1c added thinking + `max_tokens` 30→100 on `action_location_unified`. |
| **Still failing** | 0% in Run 1c but only 14 LLM calls — inconclusive at 250 steps. |
| **Next** | Re-measure at 900+ steps after Tier 1. **Tier 2** (strict location enum) only if still >5%. |

### 4. Survival / trailer beats (Tier 0)

| | |
|--|--|
| **Issue** | Post-vote agents don't go home; premiere sleep invariant (bed tile) — confirmed on legacy `20260628-4`, not OpenRouter-specific. |
| **Tried** | Not on OpenRouter branch. **Railway today:** RCA-1 vote supersession; RCA-2 meal stack (`_ensure_meal_blocks`, cleanup, templates). |
| **Still failing** | Post-vote go-home; premiere sleep — Railway backlog. |
| **Next** | Merge Railway survival stack; validate on 2.6k OpenAI then combined OpenRouter run. |

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
| **`20260630-1-deep`** | In-flight Tier 1 validation fork (`soul15_seed_20260224`, 250 steps) — mid-flight Class A 8 @ ~157 |
| **Legacy sanity** | `20260628-4` (OpenAI, 3k) already had object/fixture gaps — OpenRouter not a new failure mode |

**Run 1c config detail (for reference):** thinking ON + raised `max_tokens` on: `task_decomp_contextual` (3500), `task_decomp_contextual_repair` (3000), `daily_plan` (1200), `external_replan` (800), `generate_conversation_batch` (1500), `action_location_unified` (100).

---

## Path to "migration complete"

**Revised order** (merge-aware):

1. Railway: finish `15sim-polish` remaining tasks + 2.6k OpenAI validation
2. OpenRouter: **`20260630-1-deep` 250-step final** → Class A gate
3. **Merge decision:** `railway` survival stack + `ivan/openrouter-deepseek-v4` model/location → one integration branch
4. **Tier 1.5** (if Class A > 5): post-contract location pass — meal-pass pattern
5. Combined 250-step OpenRouter validation + survival checklist
6. Embedding reindex (dry-run → full)
7. Gateway smoke (Chat with Double + card summary)
8. Full validation + Naturalness Gate; update `sot_llm.md`
9. Railway deploy; retire `OPENAI_API_KEY`; 24h monitor

**Deferred:** Tier 2 strict location enum — only if Class A > 5 **after** Tier 1.5 at 250+ steps.

---

## References

- SOT: `double-docs/sot/sot_llm.md`, `sot_memory.md`, `sot_lifecycle.md`
- Survival MVP: `double-docs/15sim-polish.md` (RCA-2 meal-pass forensic, crutch C-1)
- Router: `reverie/backend_server/persona/prompt_template/model_router.py`
- Reports: `tests/reports/!20260628-10-openrouter_naturalness_report.md`
- Worklog: `double-docs/worklog.md` (2026-06-30 Railway + OpenRouter entries)
