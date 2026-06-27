# OpenRouter Migration Plan — DeepSeek V4

**Date:** 2026-06-27  
**Status:** Draft — revised after critical-path review  
**Scope:** Move chat-tier LLM calls from direct OpenAI to OpenRouter; keep embeddings on OpenAI

---

## Goal

Replace current tier models with DeepSeek V4 via OpenRouter:

| Tier | Current | Target (OpenRouter slug) | Primary use |
|------|---------|--------------------------|-------------|
| A | `gpt-5-nano` | `deepseek/deepseek-v4-flash` | Micro decisions, scoring, short JSON |
| B | `gpt-5-mini` | `deepseek/deepseek-v4-flash` | Planning, decomposition, conversation |
| C | `gpt-5.2` | `deepseek/deepseek-v4-pro` | Chat with Double; optional sim daily-plan |

**Out of scope for this migration:** memory embeddings (`text-embedding-3-small`), pgvector index, Supabase schema.

---

## Context compatibility verification (2026-06-27)

### Verdict: context pipeline is provider-agnostic ✅

All context fed into chat prompts is **plain text assembled before the HTTP call**. None of it depends on OpenAI-specific chat features. DeepSeek V4 via OpenRouter (1M-token context window) is vastly larger than anything we send today.

| Context source | How it works | OpenRouter impact |
|----------------|--------------|-------------------|
| **Supabase pgvector** | Query text → OpenAI embedding (1536-d) → stride-2 compress to 768-d → RPC `dbl_retrieve_memories` | **No change to retrieval.** Embeddings must stay on OpenAI (see Critical Gap #1) |
| **Embedding LRU cache** | In-process cache in `retrieve_double.py` (500 entries default) | Unaffected |
| **Memory prompt injection** | `prompt_budget.py` caps injected text (e.g. chat max 2,600 chars, planning max 2,000 chars) | Well within any model limit |
| **Profile context** | Supabase RPC + local LRU cache; bounded by `PROFILE_CONTEXT_MAX_RATIO_*` | Unaffected |
| **Scratch / planner state** | Persona name, schedule, act_address, survival overlay — string fields from Supabase scratch | Unaffected |
| **Spatial location tree** | Filtered tree string in task-decomp prompts | Unaffected (text only) |
| **Conversation history** | Prior utterances concatenated into prompt templates | Unaffected |
| **System prompt "cache"** | Static strings in `prompt_fragments.py` prepended as `role: system` | **Not** OpenAI API prompt caching — just local strings; works on any provider |
| **Task-decomp day cache** | Local cache keyed by persona + day in `plan.py` | Unaffected |
| **Chat with Double** | Embed user message (OpenAI) → pgvector retrieve → format ≤2,000 char memory block + 10-turn thread history | Embedding stays OpenAI; chat model only sees formatted text |

### Largest single-prompt estimate

Typical injected context per call: **< 5,000 characters** (~1,200 tokens) including template, profile block, memory block, and location tree. Step-level token budget across all parallel calls: ~24,000 tokens (`REGRESSION_MAX_TOKENS_PER_STEP=24000`) — many small calls, not one giant prompt. DeepSeek V4 Flash/Pro: **1M context** — no sizing concern.

**Caveat:** the 24k step budget is *input* across calls. Per-call `max_tokens` (output) is much smaller and is the real risk surface — see Critical Gap #3.

---

## Critical gaps identified in review

These must be solved before any production cutover. They are addressed in Phase 0/1 below.

### #1 — `OPENAI_BASE_URL` env var also rewrites the embedding client

OpenRouter has **no embeddings endpoint**. The OpenAI Python SDK reads `OPENAI_BASE_URL` from env. Setting it globally routes **every** `client.embeddings.create(...)` to OpenRouter and 404s — silently breaking memory retrieval and Chat with Double context.

Confirmed in code:

```949:994:reverie/backend_server/persona/prompt_template/gpt_structure.py
def _create_embedding_request(request_params):
  # ... replay path omitted ...
  embeddings_ns = getattr(openai, "embeddings", None)
  if embeddings_ns and hasattr(embeddings_ns, "create"):
    return embeddings_ns.create(**request_params)

  client_cls = getattr(openai, "OpenAI", None)
  if client_cls:
    api_key = _require_openai_key()
    client = client_cls(api_key=api_key)
    if getattr(client, "embeddings", None):
      return client.embeddings.create(**request_params)
```

Same pattern in `api_gateway/app/services/chat_with_double_service.py` (`AsyncOpenAI(api_key=...)` for both chat and embeddings).

**Splitting API keys alone does not solve this — `base_url` is the problem, not the key.**

### #2 — `temperature=0` is the dominant setting; needs explicit DeepSeek validation

Roughly half of `run_gpt_prompt.py` calls use `temperature: 0` (planning, decomposition, all structured outputs, poignancy scoring). Some providers reject `temperature=0` or clamp to a minimum. DeepSeek's native API accepts it, but OpenRouter's routing layer and the V4 thinking-mode toggle can interact with sampling in non-obvious ways.

### #3 — Tiny `max_tokens` budgets (4–15 tokens) on a reasoning-capable model — **CONFIRMED**

Wake-up hour uses `max_tokens=4`; poignancy/focal_pt/summarize use 15; pronunciatio uses 60. **DeepSeek V4 thinking mode defaults to ENABLED** (per DeepSeek API docs: "The thinking toggle defaults to enabled"; per OpenRouter reasoning docs: `enabled: true` defaults to "medium" effort). With thinking on, a `max_tokens=4` request is **entirely consumed by reasoning tokens** and produces empty output — triggering `chat_empty_retry_with_responses`, which then tries Responses API (which OpenRouter doesn't have) and fails hard.

This is a certainty on day one, not a risk. Mandatory mitigation: inject `extra_body={"thinking": {"type": "disabled"}}` (DeepSeek-native) or `reasoning: {effort: "none"}` (OpenRouter-unified) on all Tier A calls. See Phase 0.5.

### #4 — Structured JSON via `response_format` on OpenRouter — **largely mitigated**

OpenRouter's structured-outputs page confirms **both** `json_object` and `json_schema` strict mode are normalized across providers. DeepSeek V4 is in the supported list. The original concern (V4 might only support `json_object`) is downgraded — `json_schema` strict should work directly.

**Additional mitigation: Response Healing plugin.** OpenRouter offers a `response-healing` plugin that auto-repairs malformed JSON (missing brackets, markdown wrappers, trailing commas, unquoted keys, mixed text+JSON). For non-streaming requests with `response_format: json_schema`, including `plugins: [{"id": "response-healing"}]` reduces parser-retry churn on the 6 structured prompts.

**Limitation:** the plugin cannot repair responses truncated by `max_tokens` — so disable thinking on small-token calls first (per #3), then enable healing for safety.

### #5 — Replay strategy is a decision, not a checkbox

`llm_replay.py` records `api_style` + `model` per call. Recorded fixtures are `gpt-5-nano` + `responses`. "Update fixtures or enable tolerant mode" are very different choices and affect every replay-coupled test. Must be picked in Phase 0.

---

## Architecture (unchanged data flow)

```
┌──────────────────────────────────────────────────────────────┐
│  Cognition loop (per step)                                    │
│                                                               │
│  Perceive → retrieve memories                                 │
│      │                                                        │
│      ├─ embed query ──► OpenAI text-embedding-3-small        │
│      │                  (FORCED base_url=api.openai.com)      │
│      ├─ compress 768-d                                         │
│      └─ Supabase pgvector RPC ──► ranked memory text          │
│                                                               │
│  Plan / converse → assemble prompt (budgeted plain text)      │
│      │                                                        │
│      └─ model_router ──► OpenRouter chat-completions          │
│              deepseek/deepseek-v4-flash  (Tier A + B)         │
│              deepseek/deepseek-v4-pro      (Tier C)           │
└──────────────────────────────────────────────────────────────┘

Chat with Double (gateway):
  embed (OpenAI, forced base_url) → pgvector → format memories
    → OpenRouter Tier C (V4 Pro, reasoning_effort=high)
```

**Key invariant:** embedding clients explicitly pin `base_url=https://api.openai.com/v1` and use a dedicated OpenAI key. Chat clients inherit `OPENAI_BASE_URL` (OpenRouter) or pass it explicitly.

---

## OpenRouter capabilities to leverage

These directly mitigate risks in the plan and should be wired in Phase 0. Confirmed against OpenRouter docs (2026-06-27).

### 1. Reasoning control — **mandatory for Tier A, selective for Tier B**

DeepSeek V4 thinking defaults to **enabled**. OpenRouter's unified `reasoning` parameter lets us control it per request.

**Critical gotcha — V4 only has three real modes.** Per DeepSeek's docs, V4 supports `Non-think`, `Think High`, and `Think Max` only. OpenRouter's `low`/`medium`/`minimal`/`xhigh` are *silently mapped*: `low`/`medium`/`minimal` → `high` (full reasoning tokens), `xhigh` → `max`. **There is no "minimal thinking"** — it's all or nothing. Picking `effort=minimal` thinking you're saving tokens will actually burn the full reasoning budget.

The only way to truly disable thinking is `effort=none` (or DeepSeek-native `thinking.type=disabled`).

```python
# Tier A (V4 Flash) — DISABLE thinking, tiny token budgets
extra_body={"reasoning": {"effort": "none"}}
# or DeepSeek-native: extra_body={"thinking": {"type": "disabled"}}

# Tier B complex (V4 Flash) — HIGH thinking for genuinely hard prompts
extra_body={"reasoning": {"effort": "high"}}

# Tier C Chat with Double (V4 Pro) — HIGH reasoning for quality
extra_body={"reasoning": {"effort": "high"}}
# xhigh maps to Max reasoning — not worth the cost for chat
```

### V4 Flash intelligence by effort vs current models

Current setup runs GPT-5 family at `reasoning.effort=minimal` (auto-injected in `model_router.py:840`) and `gpt-5.2` at `none` (`model_router.py:710`). So we're not comparing against full-power GPT-5.

| Effort param | Actual V4 mode | MMLU-Pro | GPQA Diamond | LiveCodeBench |
|--------------|---------------|----------|--------------|---------------|
| `none` | Non-think | 83.0 | 71.2 | 55.2 |
| `minimal`/`low`/`medium` | → silently maps to High | 86.4 | 87.4 | 88.4 |
| `high` | Think High | 86.4 | 87.4 | 88.4 |
| `xhigh` | → Think Max | 86.2 | 88.1 | 91.6 |

Reference: gpt-5-nano @ high = 71.2 GPQA, gpt-5-mini @ high = 82.3 GPQA, gpt-5.2 @ xhigh = 93.0 GPQA. Current setup runs these at *minimal* effort, which is lower.

**Interpretation for our prompts** (which are NOT GPQA-level — they're tiny structured outputs, schedule generation, conversation lines):

- **Tier A (emoji labels, JSON triples, single integers):** V4 Flash @ `none` (71.2 GPQA) matches gpt-5-nano @ *high* and beats our current nano @ *minimal*. More than enough.
- **Tier B routine (schedule, reflection, conversation):** V4 Flash @ `none` is comparable to or slightly below gpt-5-mini @ *high*, but our current mini runs at *minimal* so the practical gap is small. `none` is fine.
- **Tier B complex (daily plan, task decomposition, external replan):** V4 Flash @ `high` (87.4 GPQA) clearly beats gpt-5-mini @ *high* (82.3). Worth the reasoning tokens for these few prompts.
- **Tier C (Chat with Double):** V4 Pro @ `high` (89.1 GPQA) is below gpt-5.2 @ xhigh (93.0) but plenty for in-character chat. `xhigh` not worth the cost.

Optional: `reasoning: {exclude: true}` strips reasoning tokens from the response so parsers don't trip on chain-of-thought. Useful for any call where we only want the final answer.

### 2. Strict JSON Schema + Response Healing plugin — **for the 6 structured prompts**

OpenRouter normalizes `response_format: {type: "json_schema", json_schema: {name, strict: true, schema}}` across providers. DeepSeek V4 supports it. Wire exactly like the existing Responses-API `text.format` block.

For the 6 structured prompts, also enable the response-healing plugin via `extra_body`:

```python
extra_body={
    "response_format": {
        "type": "json_schema",
        "json_schema": {"name": schema_name, "strict": True, "schema": schema},
    },
    "plugins": [{"id": "response-healing"}],
}
```

Auto-repairs: missing brackets, trailing commas, markdown wrappers, mixed text+JSON, unquoted keys. **Does not repair `max_tokens`-truncated output** — so disable thinking first.

### 3. Provider routing preferences — **free reliability + latency control**

OpenRouter auto-fails over across providers on 5xx or rate-limit (`allow_fallbacks: true` is default). This **directly mitigates the rate-limit risk** in the original plan — bounded `LLM_STEP_PARALLEL_WORKERS` may be unnecessary.

Per-request preferences via `extra_body={"provider": {...}}`:

| Preference | Use for | Value |
|------------|---------|-------|
| `require_parameters: true` | Structured prompts | Only route to providers that support `response_format` |
| `sort: "latency"` | Tier A (latency-sensitive) | Prefer low-latency endpoints |
| `sort: "price"` | Tier B/C | Prefer cheapest endpoint |
| `preferred_max_latency` | Tier A | Set to OpenAI baseline × 1.5 as a soft preference |
| `data_collection: "deny"` | All tiers | Privacy — avoid providers that store data |
| `allow_fallbacks: true` | All tiers (default) | Free reliability on 5xx/429 |

### 4. Attribution headers — **free, recommended by OpenRouter**

```python
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=openrouter_key,
    default_headers={
        "HTTP-Referer": "https://doubland.ai",   # or app URL
        "X-Title": "Doubland Simulation Engine",
    },
)
```

Makes the app discoverable on openrouter.ai rankings; no functional impact.

### 5. SSE streaming for all models — **not needed now**

All prompts use `stream: False`. Not changing in this migration. Noted for future latency optimization on Tier A.

---

## Target configuration

### Simulation engine (`.env.local`)

```bash
# --- Chat tiers via OpenRouter ---
LLM_PROVIDER=openrouter
OPENAI_BASE_URL=https://openrouter.ai/api/v1
OPENROUTER_API_KEY=<openrouter-key>          # chat tiers
OPENAI_API_KEY=${OPENROUTER_API_KEY}         # alias used by chat client factory
OPENAI_API_STYLE=chat_completions

LLM_MODEL_TIER_A=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_C=deepseek/deepseek-v4-pro

# Reasoning control (per tier) — implemented in model_router via extra_body
# Tier A: reasoning.effort = none  (mandatory; thinking defaults to enabled)
# Tier B: reasoning.effort = none  (default; per-function override allowed)
# Tier C: reasoning.effort = high  (Chat with Double quality surface)

# Tier C in sim engine stays off unless explicitly testing
TIER_C_ENABLED=false

# Now inert (A and B resolve to same slug) — set false to avoid confusion
HOURLY_SCHEDULE_FORCE_TIER_B=false

# --- Embeddings stay on OpenAI (explicit, do NOT inherit OPENAI_BASE_URL) ---
EMBEDDING_PROVIDER=openai
EMBEDDING_MODEL=text-embedding-3-small
OPENAI_EMBEDDING_API_KEY=<openai-key>
OPENAI_EMBEDDING_BASE_URL=https://api.openai.com/v1
```

### API gateway

Same tier model env vars. Gateway services (`chat_with_double_service`, `card_summary_service`) need the shared OpenRouter client factory for chat and an OpenAI-pinned client for embeddings — they currently bypass the simulation router and create both clients the same way.

### Rollback (config-only)

```bash
LLM_PROVIDER=openai
# Unset OPENAI_BASE_URL (or set to https://api.openai.com/v1)
OPENAI_API_STYLE=responses          # or chat_completions
LLM_MODEL_TIER_A=gpt-5-nano
LLM_MODEL_TIER_B=gpt-5-mini
LLM_MODEL_TIER_C=gpt-5.2
HOURLY_SCHEDULE_FORCE_TIER_B=true
```

Restart backend + gateway. **Post-rollback smoke:** verify a single embedding call resolves to OpenAI (check logs for `embeddings.create` 200, not 404) and a single chat call resolves to OpenAI Responses API. No Supabase changes required.

---

## Implementation phases

### Phase −1 — Config-only spike (0.5 day)

**Owner:** Backend  
**Goal:** De-risk Critical Gaps #2, #3, #4 before touching production code. Several unknowns are now confirmed by OpenRouter docs — this phase verifies them empirically.

Standalone script (no repo changes) using `openai.OpenAI(base_url="https://openrouter.ai/api/v1", api_key=<openrouter-key>)`:

- [ ] **Confirm thinking-disabled path** on V4 Flash: `extra_body={"reasoning": {"effort": "none"}}` with `max_tokens=4` returns non-empty output. Also try `extra_body={"thinking": {"type": "disabled"}}` (DeepSeek-native) and pick whichever is more reliable.
- [ ] Probe `temperature=0` on V4 Flash with a planning-style prompt — accept or clamp to 0.01?
- [ ] Confirm `response_format: {type: "json_schema", strict: true, ...}` is accepted by V4 Flash and returns schema-conformant JSON for one of the 6 structured prompts (e.g. pronunciatio).
- [ ] Confirm `plugins: [{"id": "response-healing"}]` activates and repairs a deliberately malformed JSON response.
- [ ] Confirm `provider: {require_parameters: true, sort: "latency"}` is accepted and routes correctly.
- [ ] Run all 6 structured prompts against V4 Flash with thinking disabled + healing enabled; validate parser compatibility.
- [ ] Capture p95 latency for 10 small calls (with thinking disabled) vs same prompts on OpenAI (baseline for Phase 1 gate).
- [ ] Burst 50 parallel small calls — note any 429s and observe OpenRouter's auto-failover behavior.

**Exit criteria:** Written answers to all probes. The thinking-disabled param must work or the migration is blocked. Other probes inform Phase 0 implementation choices.

---

### Phase 0 — Prerequisites (1.5–2.5 days)

**Owner:** Backend  
**Goal:** Production code changes, ordered by criticality.

#### 0.1 — Embedding-aware client factory (CRITICAL — do first)

- [ ] Add `_create_embedding_client()` in `gpt_structure.py` that explicitly uses `OPENAI_EMBEDDING_API_KEY` + `OPENAI_EMBEDDING_BASE_URL` (default `https://api.openai.com/v1`), **never inheriting** `OPENAI_BASE_URL`.
- [ ] Replace `client_cls(api_key=api_key)` in `_create_embedding_request` with the new factory.
- [ ] Same change in `api_gateway/app/services/chat_with_double_service._embed_message` and any other embedding call site.
- [ ] Unit test: with `OPENAI_BASE_URL=openrouter` set, embedding client still resolves to `api.openai.com`.

#### 0.2 — Chat client factory (centralize)

- [ ] `_create_openai_client()` in `model_router.py` honors `OPENAI_BASE_URL` + `OPENAI_API_KEY` (chat key).
- [ ] Gateway `_get_openai_client` for chat uses same factory.
- [ ] `video/showrunner._call_llm_direct` uses same factory.

#### 0.3 — Provider capability + reasoning_effort per tier

- [ ] Add `openrouter` to `LLM_PROVIDER_CAPABILITIES` (`responses_api: false`, `json_schema_mode: <per Phase −1>`, `reasoning_effort: false`).
- [ ] **Per-tier reasoning capability:** V4 Flash = `reasoning_effort: false`; V4 Pro = `reasoning_effort: true` (supports `high`/`xhigh` per OpenRouter docs). Wire so Chat with Double can opt into `reasoning_effort: high`.
- [ ] Disable `_needs_tier_promotion` when Tier A and Tier B resolve to identical slug (document as inert, don't delete).

#### 0.4 — Structured JSON adapter (json_schema + response-healing)

Per OpenRouter docs: strict `json_schema` is normalized across providers and DeepSeek V4 supports it. The Response Healing plugin auto-repairs malformed JSON for non-streaming `json_schema` requests.

- [ ] Map `response_schema` → `response_format: {type: "json_schema", json_schema: {name, strict: true, schema}}` on chat path.
- [ ] Inject `plugins: [{"id": "response-healing"}]` via `extra_body` for the 6 structured prompts (pronunciatio, event triples, act_obj_desc, act_obj_event_triple, decide_to_react, external_replan).
- [ ] Inject `provider: {require_parameters: true}` via `extra_body` for the same 6 prompts — ensures OpenRouter only routes to providers that honor `response_format`.
- [ ] Keep existing `safe_generate_response` parser-retry loop as a second line of defense.
- [ ] If Phase −1 finds `json_schema` is rejected: fall back to `json_object` + healing + parser retry.

#### 0.5 — Reasoning control per tier (mandatory)

**Critical:** DeepSeek V4 only has three real modes (Non-think, Think High, Think Max). OpenRouter's `minimal`/`low`/`medium` silently map to `high` — there is no "minimal thinking." Never use those values.

- [ ] **Tier A (V4 Flash):** inject `extra_body={"reasoning": {"effort": "none"}}` (or `{"thinking": {"type": "disabled"}}` per Phase −1) on every call. V4 Flash @ none (71.2 GPQA) already matches gpt-5-nano @ high — more than enough for tiny structured outputs, and tiny `max_tokens` budgets can't afford reasoning.
- [ ] **Tier B routine (V4 Flash):** default `effort: "none"`. Schedule generation, conversation lines, reflection — no chain-of-thought needed.
- [ ] **Tier B complex (V4 Flash):** per-function allowlist for `effort: "high"` on: `run_gpt_prompt_daily_plan`, `run_gpt_prompt_task_decomp_contextual`, `run_gpt_prompt_external_replan`, `run_gpt_prompt_task_decomp_contextual_repair`. V4 Flash @ high (87.4 GPQA) beats gpt-5-mini @ high (82.3).
- [ ] **Tier C (V4 Pro):** default `effort: "high"` for Chat with Double. Skip `xhigh` (maps to Max, not worth the cost for chat).
- [ ] Add `reasoning: {exclude: true}` for Tier A so any residual reasoning tokens don't appear in the response payload (parser safety).
- [ ] Regression test: `max_tokens=4` on chat path returns non-empty output with `effort=none`.
- [ ] Regression test: complex Tier B function with `effort=high` returns valid JSON within `max_tokens=1400` budget.

#### 0.6 — Provider routing preferences

- [ ] Tier A: `extra_body={"provider": {"sort": "latency", "require_parameters": true, "data_collection": "deny"}}`
- [ ] Tier B/C: `extra_body={"provider": {"sort": "price", "require_parameters": true, "data_collection": "deny"}}`
- [ ] Keep `allow_fallbacks: true` (default) for free 5xx/429 failover.
- [ ] Optional: `preferred_max_latency` for Tier A set to OpenAI baseline × 1.5 (soft preference).

#### 0.7 — Replay strategy decision (pick one)

- [ ] **Option A — Re-record:** re-run baseline sims on DeepSeek, check in new fixtures. Locks in new baseline; one-time cost.
- [ ] **Option B — Tolerant replay:** match on `function_name` + `persona` + `step` only, ignore `api_style`/`model`. Old fixtures work but lose transport fidelity.
- [ ] Document the choice in `sot_llm.md` and update affected tests (`tests/replay/*`).

#### 0.8 — Provider-mode unit tests

- [ ] Add `openrouter` case to `test_model_router_provider_modes.py` (capability flags + reasoning_effort per tier).
- [ ] Add tests for `extra_body` injection: `reasoning: {effort: "none"}` on Tier A, `plugins: [response-healing]` on structured prompts, `provider` prefs.
- [ ] Update `test_cost_telemetry.py` hardcoded `gpt-5-nano` / `gpt-5-mini` — make model-agnostic or add DeepSeek buckets.

**Exit criteria:** 3–5 representative prompts pass via `tests/llm_output_function.py` against OpenRouter. Embedding unit test confirms isolation from `OPENAI_BASE_URL`. All Phase −1 blockers have a code-level mitigation.

---

### Phase 1 — Simulation engine spike (2–3 days)

**Owner:** Backend

- [ ] Apply target env profile on feature branch `ivan/openrouter-deepseek-v4`
- [ ] Run 20-step smoke sim (1 persona, baseline fork)
- [ ] Run 40-step sim (3 personas)
- [ ] Export: `export verification stats 24`
- [ ] Analyze: `python tests/analyze_sim_realism.py <sim_code> --max-steps 40`

**Watch specifically:**
- Task decomposition JSON validity
- Conversation line generation quality
- Pronunciatio / event triple structured outputs
- No increase in `embedding_fallback_count` or retrieval misses (confirms #1 fix)
- **p95 latency for Tier A calls vs Phase −1 baseline** — rollback if > 2× OpenAI baseline
- **429 / rate-limit count** per step — rollback if sustained

**Exit criteria (concrete, not "spot review"):**
- No transport hard failures
- Parse-retry rate ≤ baseline + 5 percentage points
- Embedding fallback count = 0 (or baseline parity)
- Tier A p95 latency ≤ 2× OpenAI baseline
- Naturalness Gate thresholds from `sot_lifecycle.md` met for the 40-step window (movement, chat, planning — even at smoke scale)

---

### Phase 1.5 — Shadow run (1 day, optional but recommended)

**Owner:** Backend

The existing replay capture system supports recording both transports. Run the same baseline sim twice — once on OpenAI (current), once on DeepSeek (OpenRouter) — with capture enabled, then diff outputs function-by-function.

- [ ] Capture both runs to `environment/frontend_server/<sim>/analysis/`
- [ ] Diff task-decomp outputs, conversation lines, daily plans
- [ ] Quantify divergence: % of calls where DeepSeek output fails OpenAI's parser, % where semantic content differs
- [ ] Decision: proceed, tune prompts, or rollback

**Exit criteria:** Quantified divergence report. Stronger signal than spot review alone.

---

### Phase 2 — Gateway + product surfaces (1–2 days)

**Owner:** Backend

- [ ] Wire `chat_with_double_service` chat call to OpenRouter (Tier C → V4 Pro)
- [ ] Enable `reasoning_effort: high` for Chat with Double (quality-over-latency surface)
- [ ] Wire `card_summary_service` to OpenRouter (Tier A → V4 Flash)
- [ ] Generalize `max_completion_tokens` logic (currently GPT-5.2-specific) to use `max_tokens` for non-GPT-5 slugs
- [ ] Manual smoke: Chat with Double — memory retrieval + in-character reply
- [ ] Manual smoke: Card summary JSON generation
- [ ] Confirm gateway embedding calls still resolve to OpenAI (post-#1 verification)

**Exit criteria:** Chat with Double returns coherent in-character replies using pgvector-retrieved memories. Embedding calls in gateway logs show OpenAI host.

---

### Phase 3 — Full validation (2–3 days)

**Owner:** Backend + Product review

- [ ] 100+ step medium run (3–5 personas)
- [ ] `analyze_sim_realism.py` with optional `--llm-assess`
- [ ] Compare token pressure vs baseline (`REGRESSION_MAX_TOKENS_PER_STEP` guardrails)
- [ ] Apply replay strategy chosen in Phase 0.6
- [ ] Add DeepSeek model entries to cost telemetry (per #10 below — only after cost projection)
- [ ] Latency p95 report for full run

**Exit criteria:** Naturalness Gate pass per `sot_lifecycle.md` at medium-run scale; rollback path tested end-to-end (including embedding isolation).

---

### Sign-off step (separate from Phase 3)

- [ ] Update `double-docs/sot/sot_llm.md` §2 production posture with new tier models, transport, embedding isolation rule
- [ ] Update env-flags reference in `double-docs` and `CLAUDE.md` if new flags added
- [ ] Product owner sign-off on realism quality

---

### Phase 4 — Production rollout

- [ ] Deploy gateway + simulation with new env vars on Railway
- [ ] Keep OpenAI key live for embeddings (explicit `OPENAI_EMBEDDING_API_KEY`)
- [ ] Monitor 24h: latency p95, parse-retry rate, LLM error rate, embedding cache hit rate, 429 rate
- [ ] Document rollback in ops runbook (include embedding-isolation smoke step)

---

## Effort summary

| Phase | Days | Risk |
|-------|------|------|
| −1 — Config-only spike | 0.5 | Low (de-risks everything below) |
| 0 — Prerequisites | 1.5–2.5 | Medium (embedding factory is critical) |
| 1 — Sim spike | 2–3 | High (behavior quality + latency + rate limits) |
| 1.5 — Shadow run | 1 (optional) | Low |
| 2 — Gateway | 1–2 | Medium |
| 3 — Full validation | 2–3 | Medium |
| Sign-off + SOT update | 0.5 | Low |
| 4 — Production rollout | 0.5 + 1 day monitoring | Medium |
| **Total** | **~1.5–2 weeks** | |

---

## Risk register (revised)

| Risk | Severity | Mitigation phase |
|------|----------|------------------|
| `OPENAI_BASE_URL` rewrites embedding client → 404s | **Critical** | Phase 0.1 |
| DeepSeek V4 thinking defaults to enabled → tiny-token burn | **Critical (confirmed)** | Phase 0.5 (mandatory `reasoning.effort=none` on Tier A) |
| Strict JSON schema unsupported on V4 Flash | **Medium** (downgraded) | Phase 0.4 (OpenRouter normalizes `json_schema`; response-healing plugin as backup) |
| `temperature=0` rejected or behaves oddly | **Medium** | Phase −1 |
| Behavior quality regression on Tier B | **High** | Phase 1 + 1.5 + 3 |
| Tier A latency p95 vs OpenAI baseline | **Medium** | Phase −1 + 0.6 (`sort: "latency"`) + 1 (gate at 2×) |
| OpenRouter rate limits on parallel Tier A burst | **Low** (downgraded) | Auto-failover via `allow_fallbacks: true` (default); Phase −1 burst probe confirms |
| Embeddings accidentally moved | **High** (if #1 unaddressed) | Phase 0.1 + post-rollback smoke |
| Replay test fixtures mismatch | **Medium** | Phase 0.7 (decision) |
| Cost telemetry has no DeepSeek buckets | **Low** | Phase 3 (after cost projection) |
| A and B share same model — promotion is a no-op | **Low** | Phase 0.3 (disable + document) |
| Malformed JSON on structured prompts | **Medium** | Phase 0.4 (response-healing plugin + parser retry) |

---

## Decision log

| Decision | Rationale |
|----------|-----------|
| Keep embeddings on OpenAI | 768-d pgvector index built from `text-embedding-3-small`; reindex is a separate project |
| Embedding client pins `base_url` explicitly | Critical Gap #1 — global `OPENAI_BASE_URL` would route embeddings to OpenRouter (no endpoint) |
| A + B both on V4 Flash | User-specified mapping; simplifies cost; tier promotion becomes parse-quality guard only |
| Disable `_needs_tier_promotion` when A=B | Inert code confuses operators; disable with comment, don't delete |
| Force `chat_completions` | OpenRouter does not support OpenAI Responses API |
| Per-tier `reasoning_effort` capability | V4 Pro supports `high`/`xhigh`; Chat with Double benefits. V4 Flash must use `none` (thinking defaults enabled) |
| Tier A: `reasoning.effort=none` mandatory | Confirmed — DeepSeek V4 thinking defaults to enabled; burns tiny `max_tokens` budgets. V4 Flash @ none (71.2 GPQA) matches gpt-5-nano @ high — more than enough for tiny structured outputs |
| Tier B: `none` default, `high` for complex prompts | Routine prompts don't need chain-of-thought; complex planning benefits from `high` (87.4 GPQA, beats gpt-5-mini @ high 82.3). No middle ground — `minimal`/`low`/`medium` silently map to `high` |
| Tier C: `reasoning.effort=high` for Chat with Double | Quality-over-latency surface; V4 Pro @ high = 89.1 GPQA. `xhigh` (Max) not worth the cost for chat |
| Use strict `json_schema` directly (not `json_object` fallback) | OpenRouter normalizes across providers; DeepSeek V4 supported |
| Enable Response Healing plugin on 6 structured prompts | Auto-repairs malformed JSON; doesn't help with truncation, so disable thinking first |
| `provider: {require_parameters: true}` on structured prompts | Only route to providers honoring `response_format` |
| `provider: {sort: "latency"}` for Tier A, `"price"` for B/C | Latency-sensitive Tier A vs cost-sensitive B/C |
| `allow_fallbacks: true` (default) | Free 5xx/429 failover across providers; mitigates rate-limit risk |
| `HOURLY_SCHEDULE_FORCE_TIER_B=false` during rollout | Inert when A=B; setting false avoids confusion |
| No dynamic cross-provider failover in our code | OpenRouter handles failover at the routing layer; per `sot_llm.md` §8 our config-rollback posture stays |
| Phase −1 spike before Phase 0 code | De-risks temperature, thinking-default, schema, and burst behavior before writing production code |
| Shadow run in Phase 1.5 | Existing replay capture makes this nearly free; strongest pre-cutover quality signal |
| Add OpenRouter attribution headers | Free, recommended by OpenRouter docs; makes app discoverable |
| Context verification passed | All injected context is budgeted plain text; retrieval pipeline is embedding-independent (with #1 fix) |

---

## Open questions

1. **Replay strategy** — Phase 0.7 decision: re-record fixtures (Option A) or tolerant mode (Option B)? Recommendation: **Option A** if Phase 1 passes cleanly; **Option B** as a fallback if re-recording is blocked.
2. **Tier C in sim** — Enable `TIER_C_ENABLED` for `daily_plan` on V4 Pro, or leave gated and only use Pro for Chat with Double? Recommendation: **leave gated** for initial rollout; revisit after Chat with Double validates Pro quality.
3. **Reasoning param form** — Use OpenRouter-unified `reasoning: {effort: "none"}` or DeepSeek-native `thinking: {type: "disabled"}` for Tier A? Phase −1 picks whichever is more reliable. Preference: unified form (provider-agnostic).
4. **Tier B per-function reasoning overrides** — Allow specific Tier B calls (daily plan, task decomp, external replan, task decomp repair) to escalate to `effort: "high"`. Do NOT use `minimal`/`low`/`medium` — they silently map to `high` anyway with no savings.
5. **Cost projection** — Run a side-by-side cost estimate using actual step token volume (`REGRESSION_MAX_TOKENS_PER_STEP=24000` × expected steps/day) against DeepSeek V4 Flash pricing ($0.14/M input, $0.28/M output) vs current GPT-5 nano/mini spend. **TBD until measured** — do not assume savings. Note: reasoning-disabled Tier A spends ~0 reasoning tokens; V4 Pro Tier C with `effort=high` will spend more.
6. **`LLM_STEP_PARALLEL_WORKERS`** — Keep at `0` (unbounded) or bound for OpenRouter? OpenRouter's `allow_fallbacks: true` handles 429 failover; likely keep unbounded unless Phase −1 burst probe shows problems.
7. **`preferred_max_latency` value** — Set for Tier A as soft preference? Use Phase −1 p95 × 1.5 as starting value.

---

## References

- LLM SOT: `double-docs/sot/sot_llm.md`
- Memory SOT: `double-docs/sot/sot_memory.md`
- Lifecycle / Naturalness Gate: `double-docs/sot/sot_lifecycle.md`
- Router: `generative_agents/reverie/backend_server/persona/prompt_template/model_router.py`
- Embedding client: `generative_agents/reverie/backend_server/persona/prompt_template/gpt_structure.py` (`_create_embedding_request`, line 949)
- Memory retrieval: `generative_agents/reverie/backend_server/persona/cognitive_modules/retrieve_double.py`
- Prompt budgets: `generative_agents/reverie/backend_server/persona/prompt_template/prompt_budget.py`
- Replay: `generative_agents/reverie/backend_server/persona/prompt_template/llm_replay.py`
- Gateway chat: `generative_agents/api_gateway/app/services/chat_with_double_service.py`
- OpenRouter models: [deepseek/deepseek-v4-flash](https://openrouter.ai/deepseek/deepseek-v4-flash), [deepseek/deepseek-v4-pro](https://openrouter.ai/deepseek/deepseek-v4-pro)
- OpenRouter docs: [Structured Outputs](https://openrouter.ai/docs/features/structured-outputs), [Response Healing](https://openrouter.ai/docs/features/response-healing), [Provider Routing](https://openrouter.ai/docs/features/provider-routing), [Reasoning Tokens](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens)
- DeepSeek thinking mode: [DeepSeek API Docs](https://api-docs.deepseek.com/guides/thinking_mode)
