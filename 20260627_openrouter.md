# OpenRouter Migration Plan — DeepSeek V4 + Gemini Embeddings

**Date:** 2026-06-27  
**Status:** Draft — revised to fold in embeddings migration (no OpenAI dependency remaining)  
**Scope:** Move both chat-tier LLM calls **and** memory embeddings from direct OpenAI to OpenRouter

---

## Goal

Replace **all** OpenAI dependencies with OpenRouter-routed models. One provider, one API key, one base URL for both chat and embeddings.

### Chat tiers

| Tier | Current | Target (OpenRouter slug) | Primary use |
|------|---------|--------------------------|-------------|
| A | `gpt-5-nano` | `deepseek/deepseek-v4-flash` | Micro decisions, scoring, short JSON |
| B | `gpt-5-mini` | `deepseek/deepseek-v4-flash` | Planning, decomposition, conversation |
| C | `gpt-5.2` | `deepseek/deepseek-v4-pro` | Chat with Double; optional sim daily-plan |

### Embeddings

| Current | Target | Why |
|---------|--------|-----|
| `text-embedding-3-small` (1536-d → stride-2 compress → 768-d) | `google/gemini-embedding-2` (768-d via Matryoshka `dimensions` param) | +6 MTEB points (68.3 vs 62.3), 2.5× cheaper ($0.008 vs $0.02 /1M), no OpenAI dependency, no stride-2 hack |

**Out of scope for this migration:** pgvector schema (stays `vector(768)` — Gemini outputs 768 directly via Matryoshka), Supabase RPC contracts, memory data model.

**Runner-up embedding model:** `qwen/qwen3-embedding-0.6b` (MTEB 64.3, Apache 2.0, explicitly on OpenRouter) if open-source/self-host path becomes a priority later.

---

## Context compatibility verification (2026-06-27)

### Verdict: context pipeline is provider-agnostic ✅

All context fed into chat prompts is **plain text assembled before the HTTP call**. None of it depends on OpenAI-specific chat features. DeepSeek V4 via OpenRouter (1M-token context window) is vastly larger than anything we send today.

| Context source | How it works | OpenRouter impact |
|----------------|--------------|-------------------|
| **Supabase pgvector** | Query text → embedding → compress/store 768-d → RPC `dbl_retrieve_memories` | **Embeddings now via OpenRouter** (Gemini). Retrieval RPC unchanged. Schema `vector(768)` unchanged — Gemini outputs 768 directly via Matryoshka |
| **Embedding LRU cache** | In-process cache in `retrieve_double.py` (500 entries default) | Unaffected (cache works for any provider) |
| **Memory prompt injection** | `prompt_budget.py` caps injected text (e.g. chat max 2,600 chars, planning max 2,000 chars) | Well within any model limit |
| **Profile context** | Supabase RPC + local LRU cache; bounded by `PROFILE_CONTEXT_MAX_RATIO_*` | Unaffected |
| **Scratch / planner state** | Persona name, schedule, act_address, survival overlay — string fields from Supabase scratch | Unaffected |
| **Spatial location tree** | Filtered tree string in task-decomp prompts | Unaffected (text only) |
| **Conversation history** | Prior utterances concatenated into prompt templates | Unaffected |
| **System prompt "cache"** | Static strings in `prompt_fragments.py` prepended as `role: system` | **Not** OpenAI API prompt caching — just local strings; works on any provider |
| **Task-decomp day cache** | Local cache keyed by persona + day in `plan.py` | Unaffected |
| **Chat with Double** | Embed user message (now Gemini via OpenRouter) → pgvector retrieve → format ≤2,000 char memory block + 10-turn thread history | Both chat and embeddings via OpenRouter |

### Largest single-prompt estimate

Typical injected context per call: **< 5,000 characters** (~1,200 tokens) including template, profile block, memory block, and location tree. Step-level token budget across all parallel calls: ~24,000 tokens (`REGRESSION_MAX_TOKENS_PER_STEP=24000`) — many small calls, not one giant prompt. DeepSeek V4 Flash/Pro: **1M context** — no sizing concern.

**Caveat:** the 24k step budget is *input* across calls. Per-call `max_tokens` (output) is much smaller and is the real risk surface — see Critical Gap #3.

---

## Critical gaps identified in review

These must be solved before any production cutover. They are addressed in Phase 0/1 below.

### #1 — ~~`OPENAI_BASE_URL` env var also rewrites the embedding client~~ **OBSOLETE**

**Resolved by folding embeddings into the OpenRouter migration.** Both chat and embeddings now route through OpenRouter with one base URL and one key. The original concern (global `OPENAI_BASE_URL` would 404 embedding calls because OpenRouter had no embeddings endpoint) is no longer accurate — **OpenRouter has a dedicated embeddings API** (`POST https://openrouter.ai/api/v1/embeddings`) supporting Gemini, Qwen3, Cohere, OpenAI, and other embedding models.

The new risk (replacing #1): **embedding model switch requires reindexing** existing memories. Vectors from different embedding models live in different mathematical spaces and cannot be cross-queried. See Critical Gap #6 below.

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

### #6 — Embedding model switch requires reindexing (NEW)

Gemini Embedding 2 and OpenAI `text-embedding-3-small` produce vectors in different mathematical spaces. After switching, every existing memory in `dbl_memory` must be re-embedded with Gemini or retrieval quality degrades silently (cross-model similarity scores are meaningless).

**Mitigations:**
- User confirms current memory volume is low — reindex is a one-shot script, not a multi-hour operation.
- Reindex after Phase 1 chat validation passes, not before. Keeps rollback clean if chat migration hits a blocker.
- The pgvector schema stays `vector(768)` — Gemini outputs 768 directly via Matryoshka `dimensions` parameter, so no schema migration.
- Drop the stride-2 compression code in `retrieve_double.py:919-929` and `chat_with_double_service.py:80-85` — Gemini produces 768 natively, no compression needed.

---

## Architecture (unchanged data flow)

```
┌──────────────────────────────────────────────────────────────┐
│  Cognition loop (per step)                                    │
│                                                               │
│  Perceive → retrieve memories                                 │
│      │                                                        │
│      ├─ embed query ──► OpenRouter /google/gemini-embedding-2 │
│      │                  (dimensions=768 via Matryoshka)        │
│      └─ Supabase pgvector RPC ──► ranked memory text          │
│                                                               │
│  Plan / converse → assemble prompt (budgeted plain text)      │
│      │                                                        │
│      └─ model_router ──► OpenRouter chat-completions          │
│              deepseek/deepseek-v4-flash  (Tier A + B)         │
│              deepseek/deepseek-v4-pro      (Tier C)           │
└──────────────────────────────────────────────────────────────┘

Chat with Double (gateway):
  embed (OpenRouter / Gemini) → pgvector → format memories
    → OpenRouter Tier C (V4 Pro, reasoning_effort=high)
```

**Key invariant:** one OpenRouter client, one base URL, one API key for both chat and embeddings. No more split base URLs or dual-key management.

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

### 6. Embeddings API + Matryoshka dimensions — **for the embedding migration**

OpenRouter exposes `POST https://openrouter.ai/api/v1/embeddings` with the same auth and routing model as chat. Supports `dimensions` parameter for Matryoshka truncation — the model outputs exactly the dimension count you request, with minimal quality loss.

```python
# Single OpenRouter client, same key as chat
client = openai.OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=openrouter_key,
)
response = client.embeddings.create(
    model="google/gemini-embedding-2",   # verify exact slug in Phase −1
    input=text,
    dimensions=768,                       # Matryoshka; matches existing vector(768) schema
    # OpenRouter also accepts:
    # input_type="search_query" or "search_document",
    # provider={"data_collection": "deny", "sort": "price"},
)
```

**Why this is a clean fit for our migration:**
- Existing schema is `vector(768)` — Gemini outputs 768 directly, no schema migration
- Current code uses stride-2 compression (1536 → 768) — Gemini makes this hack unnecessary, simplifies `retrieve_double.py:919-929` and `chat_with_double_service.py:80-85`
- MTEB 68.3 vs OpenAI small's 62.3 — better retrieval quality
- $0.008/1M tokens vs OpenAI's $0.02 — 2.5× cheaper
- Same `provider` routing preferences as chat (sort, data_collection, allow_fallbacks) apply to embeddings too

**Available embedding models on OpenRouter** (verify exact slugs in Phase −1): `google/gemini-embedding-2`, `qwen/qwen3-embedding-0.6b`, `openai/text-embedding-3-small`, `openai/text-embedding-3-large`, Cohere embed v4, and others. Browse current list at `https://openrouter.ai/models?output_modalities=embeddings`.

---

## Target configuration

### Simulation engine (`.env.local`)

```bash
# --- Everything via OpenRouter (one provider, one key) ---
LLM_PROVIDER=openrouter
OPENAI_BASE_URL=https://openrouter.ai/api/v1
OPENROUTER_API_KEY=<openrouter-key>          # one key for chat + embeddings
OPENAI_API_KEY=${OPENROUTER_API_KEY}         # alias used by client factory
OPENAI_API_STYLE=chat_completions

# Chat tiers
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

# --- Embeddings via OpenRouter (Gemini) ---
EMBEDDING_PROVIDER=openrouter
EMBEDDING_MODEL=google/gemini-embedding-2     # verify exact slug in Phase −1
EMBEDDING_DIMENSIONS=768                       # Matryoshka truncation; matches existing vector(768) schema
```

### API gateway

Same tier model + embedding env vars. Gateway services (`chat_with_double_service`, `card_summary_service`) use the shared OpenRouter client factory for **both** chat and embeddings — no more split base URLs.

### Rollback (config-only)

```bash
LLM_PROVIDER=openai
# Unset OPENAI_BASE_URL (or set to https://api.openai.com/v1)
OPENAI_API_STYLE=responses          # or chat_completions
LLM_MODEL_TIER_A=gpt-5-nano
LLM_MODEL_TIER_B=gpt-5-mini
LLM_MODEL_TIER_C=gpt-5.2
HOURLY_SCHEDULE_FORCE_TIER_B=true

# Revert embeddings to OpenAI
EMBEDDING_PROVIDER=openai
EMBEDDING_MODEL=text-embedding-3-small
# Unset EMBEDDING_DIMENSIONS (OpenAI is 1536 native; current code compresses to 768)
```

Restart backend + gateway. **Post-rollback smoke:** verify a single embedding call resolves to OpenAI and a single chat call resolves to OpenAI Responses API.

**Important rollback caveat:** memories indexed with Gemini embeddings are not compatible with OpenAI embeddings — they live in different vector spaces. If you rollback embeddings after reindexing, you must either (a) keep the Gemini-indexed memories and accept that rollback re-embeds new writes only (mixed index — retrieval quality degrades), or (b) re-reindex back to OpenAI (one-shot script). **Recommendation:** validate Phase 1 thoroughly before reindexing in Phase 0.11 so rollback stays clean.

---

## Implementation phases

### Phase −1 — Config-only spike (0.5 day)

**Owner:** Backend  
**Goal:** De-risk Critical Gaps #2, #3, #4, #6 before touching production code. Several unknowns are now confirmed by OpenRouter docs — this phase verifies them empirically.

Standalone script (no repo changes) using `openai.OpenAI(base_url="https://openrouter.ai/api/v1", api_key=<openrouter-key>)`:

**Chat probes:**
- [ ] **Confirm thinking-disabled path** on V4 Flash: `extra_body={"reasoning": {"effort": "none"}}` with `max_tokens=4` returns non-empty output. Also try `extra_body={"thinking": {"type": "disabled"}}` (DeepSeek-native) and pick whichever is more reliable.
- [ ] Probe `temperature=0` on V4 Flash with a planning-style prompt — accept or clamp to 0.01?
- [ ] Confirm `response_format: {type: "json_schema", strict: true, ...}` is accepted by V4 Flash and returns schema-conformant JSON for one of the 6 structured prompts (e.g. pronunciatio).
- [ ] Confirm `plugins: [{"id": "response-healing"}]` activates and repairs a deliberately malformed JSON response.
- [ ] Confirm `provider: {require_parameters: true, sort: "latency"}` is accepted and routes correctly.
- [ ] Run all 6 structured prompts against V4 Flash with thinking disabled + healing enabled; validate parser compatibility.
- [ ] Capture p95 latency for 10 small calls (with thinking disabled) vs same prompts on OpenAI (baseline for Phase 1 gate).
- [ ] Burst 50 parallel small calls — note any 429s and observe OpenRouter's auto-failover behavior.

**Embedding probes (NEW):**
- [ ] List available embedding models: `GET https://openrouter.ai/api/v1/embeddings/models` — confirm `google/gemini-embedding-2` slug (or closest equivalent).
- [ ] Embed 3 sample texts with `google/gemini-embedding-2`, `dimensions=768` — confirm 768-d vectors returned.
- [ ] Embed same 3 texts with `qwen/qwen3-embedding-0.6b` as backup — confirm dimensions parameter works.
- [ ] Compute cosine similarity between Gemini vectors for semantically-related vs unrelated text — confirm sensible ranking (sanity check that vectors aren't degenerate).
- [ ] Compare Gemini vs current OpenAI `text-embedding-3-small` (compressed 768) on a small set of memories — qualitative check that Gemini produces at least as good cluster separation.
- [ ] Confirm `provider: {data_collection: "deny"}` is accepted for embedding requests.

**Exit criteria:** Written answers to all probes. The thinking-disabled param and the Gemini embedding probe must work or the migration is blocked. Other probes inform Phase 0 implementation choices.

---

### Phase 0 — Prerequisites (2–3.5 days)

**Owner:** Backend  
**Goal:** Production code changes, ordered by criticality.

#### 0.1 — Single OpenRouter client factory (REVISED — no more split base URLs)

- [ ] Add `_create_openrouter_client()` in `gpt_structure.py` that reads `OPENROUTER_API_KEY` + `OPENAI_BASE_URL` (OpenRouter) and injects attribution headers (`HTTP-Referer`, `X-Title`).
- [ ] Replace `_create_embedding_request` in `gpt_structure.py:949` to use the same factory with `model=EMBEDDING_MODEL` (Gemini) and `dimensions=768` parameter.
- [ ] Same factory used by `model_router._create_openai_client` for chat.
- [ ] Same factory used by `api_gateway/app/services/chat_with_double_service._get_openai_client` (chat) and `_embed_message` (embeddings).
- [ ] Same factory used by `video/showrunner._call_llm_direct`.
- [ ] Unit test: factory produces a client with the correct base URL and headers; both chat and embedding calls succeed against the OpenRouter endpoint.

#### 0.2 — Chat client factory (centralize) — **folded into 0.1**

Single factory handles both chat and embeddings. No separate chat client factory needed. Skip this sub-task (kept for traceability).

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
- [ ] Embeddings: `extra_body={"provider": {"sort": "price", "data_collection": "deny"}}`
- [ ] Keep `allow_fallbacks: true` (default) for free 5xx/429 failover.
- [ ] Optional: `preferred_max_latency` for Tier A set to OpenAI baseline × 1.5 (soft preference).

#### 0.7 — Embedding model switch (NEW)

- [ ] Wire `_create_embedding_request` to call `google/gemini-embedding-2` (or Phase −1-confirmed slug) with `dimensions=768`.
- [ ] Wire `chat_with_double_service._embed_message` to use the same model + dimensions.
- [ ] Pass `input_type` parameter where supported (`"search_query"` for retrieval queries, `"search_document"` for memory writes) — improves retrieval quality when the model distinguishes query vs document.
- [ ] Update `MODEL_CONFIG["EMBEDDING"]` in `model_router.py` from `text-embedding-3-small` to the new model.
- [ ] Update `EMBEDDING_MODEL` and `EMBEDDING_PROVIDER` defaults in `retrieve_double.py:79-82` to read from env with new defaults.
- [ ] Unit test: embedding call returns 768-d vector via OpenRouter; dimension assertion.

#### 0.8 — Drop stride-2 compression (NEW)

Gemini outputs 768 directly via Matryoshka — the stride-2 hack (1536 → 768) is obsolete.

- [ ] Remove compression code in `retrieve_double.py:919-929` (`_get_compressed_embedding`) — return the embedding as-is from the API call.
- [ ] Remove compression code in `chat_with_double_service.py:80-85` (`_embed_message` stride-2 loop).
- [ ] Remove the `1536 → 768` padding/truncation fallback in `retrieve_double.py:927-929` (no longer needed — Gemini always returns 768 with `dimensions=768`).
- [ ] Update `_EMBEDDING_INDEX_VERSION` to `"v3-gemini"` so the LRU cache invalidates cleanly across the switch (prevents stale OpenAI vectors from being served from cache).
- [ ] Unit test: embedding returned from `_get_compressed_embedding` is exactly 768-d with no compression step applied.

#### 0.9 — Reindex script (NEW — run after Phase 1 chat validation passes)

Re-embed every existing memory with Gemini so retrieval works against the new vector space. Run as a one-shot script after Phase 1 chat migration is validated, **not before** — keeps rollback clean if chat hits a blocker.

- [ ] Write `scripts/reindex_embeddings.py` that:
  - Connects to Supabase
  - Walks `dbl_memory` in batches (e.g. 100 rows)
  - For each row: reads the memory text, calls Gemini via OpenRouter with `dimensions=768`, updates the `embedding` column
  - Tracks success/failure counts, supports resuming from a row offset
  - Has a `--dry-run` mode that prints the count and sample texts without writing
- [ ] Add a guard: refuse to run if `EMBEDDING_MODEL` env var is still OpenAI (prevents accidental reindex with the wrong model).
- [ ] Document the run procedure in the migration plan's Phase 1.5 step.
- [ ] Do NOT run the reindex in Phase 0 — only after Phase 1 chat validation passes.

#### 0.10 — Replay strategy decision (pick one)

- [ ] **Option A — Re-record:** re-run baseline sims on DeepSeek, check in new fixtures. Locks in new baseline; one-time cost.
- [ ] **Option B — Tolerant replay:** match on `function_name` + `persona` + `step` only, ignore `api_style`/`model`. Old fixtures work but lose transport fidelity.
- [ ] Document the choice in `sot_llm.md` and update affected tests (`tests/replay/*`).

#### 0.11 — Provider-mode unit tests

- [ ] Add `openrouter` case to `test_model_router_provider_modes.py` (capability flags + reasoning_effort per tier).
- [ ] Add tests for `extra_body` injection: `reasoning: {effort: "none"}` on Tier A, `plugins: [response-healing]` on structured prompts, `provider` prefs.
- [ ] Add tests for embedding call: returns 768-d via Gemini, `input_type` parameter propagated, `dimensions=768` honored.
- [ ] Update `test_cost_telemetry.py` hardcoded `gpt-5-nano` / `gpt-5-mini` — make model-agnostic or add DeepSeek + Gemini buckets.

**Exit criteria:** 3–5 representative prompts pass via `tests/llm_output_function.py` against OpenRouter. Embedding unit test confirms 768-d output via Gemini. All Phase −1 blockers have a code-level mitigation.

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
- No increase in `embedding_fallback_count` or retrieval misses — confirms Gemini embeddings are working end-to-end (no stale OpenAI vectors in cache after `_EMBEDDING_INDEX_VERSION` bump)
- **p95 latency for Tier A calls vs Phase −1 baseline** — rollback if > 2× OpenAI baseline
- **429 / rate-limit count** per step — rollback if sustained
- **Embedding call latency** vs OpenAI baseline (Gemini via OpenRouter may be slightly slower due to routing hop)

**Exit criteria (concrete, not "spot review"):**
- No transport hard failures
- Parse-retry rate ≤ baseline + 5 percentage points
- Embedding fallback count = 0 (or baseline parity)
- Tier A p95 latency ≤ 2× OpenAI baseline
- Embedding call latency ≤ 2× OpenAI baseline
- Naturalness Gate thresholds from `sot_lifecycle.md` met for the 40-step window (movement, chat, planning — even at smoke scale)
- New memories written during the run retrieve correctly via pgvector (Gemini embeddings working in both write and read paths)

---

### Phase 1.5 — Shadow run + reindex (1.5 days, recommended)

**Owner:** Backend

Two related activities: shadow run for chat quality, then reindex for embeddings.

**Chat shadow run** — uses the existing replay capture system. Run the same baseline sim twice — once on OpenAI (current), once on DeepSeek (OpenRouter) — with capture enabled, then diff outputs function-by-function.

- [ ] Capture both runs to `environment/frontend_server/<sim>/analysis/`
- [ ] Diff task-decomp outputs, conversation lines, daily plans
- [ ] Quantify divergence: % of calls where DeepSeek output fails OpenAI's parser, % where semantic content differs
- [ ] Decision: proceed, tune prompts, or rollback

**Embedding reindex** — only run if Phase 1 chat validation passed cleanly. This is the point of no return for embeddings rollback.

- [ ] Run `scripts/reindex_embeddings.py --dry-run` first — confirm row count and sample texts look right
- [ ] Run `scripts/reindex_embeddings.py` for real — re-embed all `dbl_memory` rows with Gemini
- [ ] Verify a sample of retrieval queries return sensible memories after reindex (sanity check the new vector space)
- [ ] Spot-check: pick 3-5 known memories, retrieve with their original focal-point queries, confirm they still surface

**Exit criteria:** Quantified chat divergence report + reindex complete with sanity checks passing. Stronger signal than spot review alone. After this point, OpenAI key can be retired.

---

### Phase 2 — Gateway + product surfaces (1–2 days)

**Owner:** Backend

- [ ] Wire `chat_with_double_service` chat call to OpenRouter (Tier C → V4 Pro)
- [ ] Enable `reasoning_effort: high` for Chat with Double (quality-over-latency surface)
- [ ] Wire `card_summary_service` to OpenRouter (Tier A → V4 Flash)
- [ ] Generalize `max_completion_tokens` logic (currently GPT-5.2-specific) to use `max_tokens` for non-GPT-5 slugs
- [ ] Confirm gateway embedding calls (`_embed_message`) use Gemini via the shared OpenRouter client (post-0.7 verification)
- [ ] Manual smoke: Chat with Double — memory retrieval + in-character reply (verifies chat + embeddings working together in gateway)
- [ ] Manual smoke: Card summary JSON generation

**Exit criteria:** Chat with Double returns coherent in-character replies using pgvector-retrieved memories. Gateway logs show both chat and embedding calls hitting OpenRouter.

---

### Phase 3 — Full validation (2–3 days)

**Owner:** Backend + Product review

- [ ] 100+ step medium run (3–5 personas)
- [ ] `analyze_sim_realism.py` with optional `--llm-assess`
- [ ] Compare token pressure vs baseline (`REGRESSION_MAX_TOKENS_PER_STEP` guardrails)
- [ ] Apply replay strategy chosen in Phase 0.10
- [ ] Add DeepSeek + Gemini model entries to cost telemetry
- [ ] Latency p95 report for full run (chat + embeddings)
- [ ] Confirm no OpenAI API key is being used anywhere (grep logs, grep code paths)

**Exit criteria:** Naturalness Gate pass per `sot_lifecycle.md` at medium-run scale; rollback path tested end-to-end; no OpenAI dependency remaining.

---

### Sign-off step (separate from Phase 3)

- [ ] Update `double-docs/sot/sot_llm.md` §2 production posture with new tier models, transport, embedding model
- [ ] Update env-flags reference in `double-docs` and `CLAUDE.md` if new flags added
- [ ] Product owner sign-off on realism quality

---

### Phase 4 — Production rollout

- [ ] Deploy gateway + simulation with new env vars on Railway
- [ ] Retire `OPENAI_API_KEY` from production env (no longer used)
- [ ] Monitor 24h: latency p95 (chat + embeddings), parse-retry rate, LLM error rate, embedding cache hit rate, 429 rate
- [ ] Document rollback in ops runbook (note: embedding rollback requires re-reindex back to OpenAI)

---

## Effort summary

| Phase | Days | Risk |
|-------|------|------|
| −1 — Config-only spike (chat + embedding probes) | 0.5 | Low (de-risks everything below) |
| 0 — Prerequisites (chat + embedding code) | 2–3.5 | Medium (reindex script is the new critical path) |
| 1 — Sim spike | 2–3 | High (behavior quality + latency + rate limits) |
| 1.5 — Shadow run + reindex | 1.5 (recommended) | Medium (reindex is point of no return for embeddings) |
| 2 — Gateway | 1–2 | Medium |
| 3 — Full validation | 2–3 | Medium |
| Sign-off + SOT update | 0.5 | Low |
| 4 — Production rollout | 0.5 + 1 day monitoring | Medium |
| **Total** | **~2–2.5 weeks** | |

---

## Risk register (revised)

| Risk | Severity | Mitigation phase |
|------|----------|------------------|
| ~~`OPENAI_BASE_URL` rewrites embedding client → 404s~~ | **Obsolete** | Resolved by folding embeddings into the OpenRouter migration |
| DeepSeek V4 thinking defaults to enabled → tiny-token burn | **Critical (confirmed)** | Phase 0.5 (mandatory `reasoning.effort=none` on Tier A) |
| Strict JSON schema unsupported on V4 Flash | **Medium** (downgraded) | Phase 0.4 (OpenRouter normalizes `json_schema`; response-healing plugin as backup) |
| `temperature=0` rejected or behaves oddly | **Medium** | Phase −1 |
| Behavior quality regression on Tier B | **High** | Phase 1 + 1.5 + 3 |
| Tier A latency p95 vs OpenAI baseline | **Medium** | Phase −1 + 0.6 (`sort: "latency"`) + 1 (gate at 2×) |
| OpenRouter rate limits on parallel Tier A burst | **Low** (downgraded) | Auto-failover via `allow_fallbacks: true` (default); Phase −1 burst probe confirms |
| Embedding reindex fails partway | **Medium** (new) | Phase 0.9 (resumable script with offset); dry-run first; point-of-no-return deferred to Phase 1.5 |
| Gemini embedding quality worse than OpenAI for our corpus | **Low** (MTEB 68.3 vs 62.3) | Phase −1 sanity probe + Phase 1.5 spot-check retrieval after reindex |
| Gemini slug not on OpenRouter or differs from expected | **Low** | Phase −1 lists available models; fallback to `qwen/qwen3-embedding-0.6b` |
| Stale OpenAI vectors served from LRU cache after switch | **Low** | Phase 0.8 (`_EMBEDDING_INDEX_VERSION` bump to `v3-gemini`) |
| Mixed vector space after partial rollback | **Medium** | Rollback caveat in plan — recommend reindex only after Phase 1 chat passes |
| Replay test fixtures mismatch | **Medium** | Phase 0.10 (decision) |
| Cost telemetry has no DeepSeek + Gemini buckets | **Low** | Phase 3 (after cost projection) |
| A and B share same model — promotion is a no-op | **Low** | Phase 0.3 (disable + document) |
| Malformed JSON on structured prompts | **Medium** | Phase 0.4 (response-healing plugin + parser retry) |

---

## Decision log

| Decision | Rationale |
|----------|-----------|
| **Move embeddings to Gemini via OpenRouter** | Eliminates OpenAI dependency entirely; MTEB 68.3 vs 62.3 (+6 points); 2.5× cheaper ($0.008 vs $0.02 /1M); single API key for chat + embeddings; OpenRouter has dedicated `/embeddings` endpoint |
| **Gemini Embedding 2 over Qwen3-Embedding-0.6B** | Better MTEB (68.3 vs 64.3); Google-backed stability; same OpenRouter access. Qwen3 kept as fallback if Gemini slug unavailable or self-hosting becomes a priority |
| **Use `dimensions=768` Matryoshka truncation** | Matches existing `vector(768)` schema — no schema migration needed; lets us drop the stride-2 compression hack |
| **Drop stride-2 compression code** | Gemini outputs 768 directly via Matryoshka — compression step is obsolete |
| **Bump `_EMBEDDING_INDEX_VERSION` to `v3-gemini`** | Prevents stale OpenAI vectors being served from the LRU cache after the switch |
| **Reindex only after Phase 1 chat validation passes** | Keeps rollback clean — if chat hits a blocker, embeddings stay on OpenAI without needing a reverse reindex |
| **Single OpenRouter client factory for chat + embeddings** | One base URL, one key, one set of attribution headers; no more split base URLs or dual-key management |
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
| `provider: {sort: "latency"}` for Tier A, `"price"` for B/C + embeddings | Latency-sensitive Tier A vs cost-sensitive B/C/embeddings |
| `allow_fallbacks: true` (default) | Free 5xx/429 failover across providers; mitigates rate-limit risk |
| `HOURLY_SCHEDULE_FORCE_TIER_B=false` during rollout | Inert when A=B; setting false avoids confusion |
| No dynamic cross-provider failover in our code | OpenRouter handles failover at the routing layer; per `sot_llm.md` §8 our config-rollback posture stays |
| Phase −1 spike before Phase 0 code | De-risks temperature, thinking-default, schema, burst behavior, and Gemini embeddings before writing production code |
| Shadow run + reindex in Phase 1.5 | Existing replay capture makes chat shadow nearly free; reindex is the point of no return for embeddings rollback |
| Add OpenRouter attribution headers | Free, recommended by OpenRouter docs; makes app discoverable |
| Context verification passed | All injected context is budgeted plain text; retrieval pipeline is provider-agnostic |

---

## Open questions

1. **Replay strategy** — Phase 0.10 decision: re-record fixtures (Option A) or tolerant mode (Option B)? Recommendation: **Option A** if Phase 1 passes cleanly; **Option B** as a fallback if re-recording is blocked.
2. **Tier C in sim** — Enable `TIER_C_ENABLED` for `daily_plan` on V4 Pro, or leave gated and only use Pro for Chat with Double? Recommendation: **leave gated** for initial rollout; revisit after Chat with Double validates Pro quality.
3. **Reasoning param form** — Use OpenRouter-unified `reasoning: {effort: "none"}` or DeepSeek-native `thinking: {type: "disabled"}` for Tier A? Phase −1 picks whichever is more reliable. Preference: unified form (provider-agnostic).
4. **Tier B per-function reasoning overrides** — Allow specific Tier B calls (daily plan, task decomp, external replan, task decomp repair) to escalate to `effort: "high"`. Do NOT use `minimal`/`low`/`medium` — they silently map to `high` anyway with no savings.
5. **Cost projection** — Run a side-by-side cost estimate using actual step token volume (`REGRESSION_MAX_TOKENS_PER_STEP=24000` × expected steps/day) against DeepSeek V4 Flash pricing ($0.14/M input, $0.28/M output) + Gemini Embedding 2 ($0.008/1M) vs current GPT-5 nano/mini + OpenAI small spend. **TBD until measured** — do not assume savings. Note: reasoning-disabled Tier A spends ~0 reasoning tokens; V4 Pro Tier C with `effort=high` will spend more.
6. **`LLM_STEP_PARALLEL_WORKERS`** — Keep at `0` (unbounded) or bound for OpenRouter? OpenRouter's `allow_fallbacks: true` handles 429 failover; likely keep unbounded unless Phase −1 burst probe shows problems.
7. **`preferred_max_latency` value** — Set for Tier A as soft preference? Use Phase −1 p95 × 1.5 as starting value.
8. **Embedding `input_type` parameter** — Use `"search_query"` for retrieval queries and `"search_document"` for memory writes? Improves quality on models that distinguish; verify Gemini supports it in Phase −1.
9. **Reindex batch size** — Default 100 rows per batch for `reindex_embeddings.py`. Adjust based on OpenRouter rate limits and observed latency in Phase −1.
10. **Gemini exact slug on OpenRouter** — Confirm via `GET https://openrouter.ai/api/v1/embeddings/models` in Phase −1. Expected: `google/gemini-embedding-2` (or similar). Fallback: `qwen/qwen3-embedding-0.6b`.

---

## References

- LLM SOT: `double-docs/sot/sot_llm.md`
- Memory SOT: `double-docs/sot/sot_memory.md`
- Lifecycle / Naturalness Gate: `double-docs/sot/sot_lifecycle.md`
- Router: `generative_agents/reverie/backend_server/persona/prompt_template/model_router.py`
- Embedding client: `generative_agents/reverie/backend_server/persona/prompt_template/gpt_structure.py` (`_create_embedding_request`, line 949)
- Embedding compression (to be removed): `generative_agents/reverie/backend_server/persona/cognitive_modules/retrieve_double.py` (line 919)
- Gateway embedding (to be updated): `generative_agents/api_gateway/app/services/chat_with_double_service.py` (line 80)
- Memory retrieval: `generative_agents/reverie/backend_server/persona/cognitive_modules/retrieve_double.py`
- Prompt budgets: `generative_agents/reverie/backend_server/persona/prompt_template/prompt_budget.py`
- Replay: `generative_agents/reverie/backend_server/persona/prompt_template/llm_replay.py`
- Gateway chat: `generative_agents/api_gateway/app/services/chat_with_double_service.py`
- OpenRouter chat models: [deepseek/deepseek-v4-flash](https://openrouter.ai/deepseek/deepseek-v4-flash), [deepseek/deepseek-v4-pro](https://openrouter.ai/deepseek/deepseek-v4-pro)
- OpenRouter embeddings API: [Embeddings reference](https://openrouter.ai/docs/api/reference/embeddings), [List embedding models](https://openrouter.ai/docs/api/api-reference/embeddings/list-embeddings-models)
- OpenRouter docs: [Structured Outputs](https://openrouter.ai/docs/features/structured-outputs), [Response Healing](https://openrouter.ai/docs/features/response-healing), [Provider Routing](https://openrouter.ai/docs/features/provider-routing), [Reasoning Tokens](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens)
- DeepSeek thinking mode: [DeepSeek API Docs](https://api-docs.deepseek.com/guides/thinking_mode)
- MTEB benchmark: [MTEB 2026 state of the embeddings](https://app.ailog.fr/en/blog/news/rag-benchmark-mteb-2026)
