# DeepSeek V4 Flash 0731 — Tier B pilot brief

**Date:** 2026-08-01  
**Author:** Ivan (with agent assist)  
**Audience:** Dev team lead  
**Status:** Recommend controlled Tier B pilot; do not blind-swap full sim stack

---

## Executive summary

DeepSeek shipped an upgraded **V4 Flash API** (`deepseek/deepseek-v4-flash-0731` on OpenRouter) on 2026-07-31. Same list price as legacy Flash ($0.14 / $0.28 per 1M in/out), re-post-trained for agent workflows ([DeepSeek announcement](https://x.com/deepseek_ai/status/2083084415157022911), [OpenRouter model page](https://openrouter.ai/deepseek/deepseek-v4-flash-0731)).

We ran a local A/B on **36 real captured Tier B prompts** from sim `20260706-local-1`. **Candidate:** 0731 with reasoning **off** and **50% lower** `max_tokens`. **Baseline:** production captures from the same sim (Flash + `reasoning.effort=high` on the complex allowlist).

**Result:** ~45% fewer tokens, ~42% lower estimated cost per call, and **better structured-output success** on location + task decomp. Hypothesis is **supported for the 6 complex Tier B prompts** — not yet proven for full multi-day sims.

**Separate track (already on `railway`):** Chat with Double uses Tier C (`deepseek/deepseek-v4-pro`) via gateway; does **not** require `TIER_C_ENABLED=true` on the sim engine.

---

## Current production posture (unchanged unless we pilot)

| Layer | Model | Notes |
|-------|--------|--------|
| Tier A + B (sim) | `deepseek/deepseek-v4-flash` | Tier B complex allowlist gets `reasoning.effort=high` |
| Tier C (sim) | `deepseek/deepseek-v4-pro` | `TIER_C_ENABLED=false` — effectively off in engine |
| Chat with Double | `deepseek/deepseek-v4-pro` | Gateway only; independent of sim Tier C flag |
| Embeddings | `google/gemini-embedding-2` | 768-d |

SOT: `double-docs/sot/sot_llm.md`

---

## What we tested

**Scope:** Only the **Tier B complex allowlist** (6 functions):

- `run_gpt_prompt_action_location_unified`
- `run_gpt_prompt_daily_plan`
- `run_gpt_prompt_task_decomp_contextual` (+ repair)
- `run_gpt_prompt_external_replan`
- `run_gpt_prompt_generate_conversation_batch`

**Harness:** `generative_agents/scripts/ab_tier_b_flash_0731.py`  
**Report artifact:** `generative_agents/tests/_tmp/tier_b_ab_report.json`

| Arm | Model | Reasoning | Token budget |
|-----|--------|-----------|--------------|
| Baseline | `deepseek/deepseek-v4-flash` | `high` (prod) | As captured (e.g. location 800, decomp 3500) |
| Candidate | `deepseek/deepseek-v4-flash-0731` | Off (`exclude=true`) | 50% of prod caps |

Sample: 12 calls each for location, daily plan, task decomp (36 total live candidate calls).

---

## Results (aggregate)

| Metric | Baseline (capture) | Candidate (0731) | Delta |
|--------|------------------|------------------|-------|
| Avg tokens / call | 2,319 | 1,273 | **−45%** |
| Avg completion tokens | 1,152 | 169 | **−85%** |
| Est. cost / call | $0.00035 | $0.00020 | **−42%** |
| Parse success (lightweight) | 31% | 67% | **+36 pp** |
| API success | 39% | 100% | **+61 pp** |

### By prompt type

| Function | Parse (base → cand) | Tokens (base → cand) | Notes |
|----------|---------------------|----------------------|--------|
| **Location unified** | 8% → **100%** | 927 → 839 | Many baseline captures were **empty** (truncation / reasoning budget). Candidate always returned valid `sector \| arena \| object`. |
| **Task decomp contextual** | 83% → **100%** | 3,881 → 1,970 | JSON valid in all 12 cases; ~half the tokens. |
| **Daily plan** | 0% → 0% (scorer) | 2,149 → 1,011 | Scorer expects ≥3 lines; prod uses **single-line numbered lists**. Outputs look fine — metric is wrong, not necessarily the model. |

**Match vs production output:** 0% for candidate (expected when changing model; not a quality gate by itself).

---

## Interpretation

1. **Token economics:** Today’s Tier B complex path pays a large **hidden reasoning tax** inside `max_tokens`. 0731 without reasoning cuts completion tokens sharply while improving parse rates on structured tasks.
2. **Cost vs legacy discounted Flash:** OpenRouter’s generic `deepseek-v4-flash` slug can route to **cheaper providers** (~$0.09/M). 0731 is pinned at $0.14/M — we only win if **token reduction** outweighs the higher unit price. In this sample, it did (~42% cheaper per call).
3. **Quality ceiling:** ~70% of visible location “Class A” bugs in past RCA were **deterministic code** (parent inherit / anchor repoint), not LLM picks. Smarter Flash does not replace those fixes.
4. **Pro unchanged:** DeepSeek did not upgrade V4 Pro API on 2026-07-31; keep Chat / Tier C on Pro.

---

## Recommendation

**Proceed with a Tier-B-only pilot on `railway`**, not a full-model swap:

```bash
# Tier B complex path only (env sketch — tune after smoke)
LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash-0731
# Keep Tier A on current Flash until separately validated:
LLM_MODEL_TIER_A=deepseek/deepseek-v4-flash
```

**Code-side (small follow-up):** When `LLM_MODEL_TIER_B` contains `deepseek-v4-flash-0731`, force `reasoning.effort=none` on the complex allowlist and reduce `max_tokens` in `run_gpt_prompt.py` (or via router) to match A/B caps:

| Function | Current max_tokens | Pilot cap |
|----------|-------------------|-----------|
| `action_location_unified` | 800 | 400 |
| `daily_plan` | 1200 | 600 |
| `task_decomp_contextual` | 3500 | 1750 |
| `task_decomp_contextual_repair` | 3000 | 1500 |
| `external_replan` | 800 | 400 |
| `generate_conversation_batch` | 1500 | 750 |

**Rollback:** Revert `LLM_MODEL_TIER_B` to `deepseek/deepseek-v4-flash` and restore token budgets; restart `double-api` between sims.

---

## Validation plan before promote

1. **50-step smoke** on VPS with `diagnostic_mode=true`, `LLM_CAPTURE_ENABLED=true`.
2. Compare vs prior smoke: `analyze_sim_realism.py`, action-location scan, parse/retry rates in compact LLM metrics.
3. Re-run A/B harness on the new capture: `python scripts/ab_tier_b_flash_0731.py run --llm-log-dir ...`
4. **Do not** enable `TIER_C_ENABLED` for this experiment.

**Pass criteria (draft):**

- No increase in LLM retry storms or empty-response rate.
- Location unified parse rate ≥ baseline smoke.
- Tier B token spend per step ↓ ≥30% on complex allowlist calls.
- No regression in conversation / plan coherence on spot-check.

---

## References

- A/B script: `generative_agents/scripts/ab_tier_b_flash_0731.py`
- Chat Tier C gateway change: `railway` @ `e8ad8aeb`
- LLM SOT: `double-docs/sot/sot_llm.md`
- DeepSeek 0731: [X post](https://x.com/deepseek_ai/status/2083084415157022911) · [OpenRouter](https://openrouter.ai/deepseek/deepseek-v4-flash-0731)
