# Chat with Double — Implementation Concept

**Status:** Draft
**Last updated:** 2026-03-31
**Depends on:** Sprite Detail Card `/card-summary` endpoint (shipped), Talk tab UI shell (placeholder)

---

## 1. Goal

Allow users to chat directly with a simulated persona ("double") during playback. The double draws on all its simulation memories, acts in-character, and responds using the Tier C model (`gpt-5.2`) for maximum quality.

### Future extensions (out of scope for v1)
- Access gating: user can only chat with selected doubles (e.g., their own)
- Personality modification: user can adjust their double's traits through conversation
- Goal/task embedding: user can assign simulation goals and tasks through chat

---

## 2. Decisions

| Question | Decision | Rationale |
|---|---|---|
| Availability | Playback-only | Chat requires a simulation context (step, persona state, memories) |
| Memory retrieval | Full pgvector | Rich, in-character responses justify embedding cost |
| Transport | REST for v1, stream later | Ship faster; accept 3-8s Tier C latency with "thinking" animation. Upgrade to SSE/WS in v2 |
| Persistence | Supabase table | Survives restarts, supports future analytics and personality modification |
| LLM model | Tier C (`gpt-5.2`) | User-facing chat is the highest-stakes interaction surface |

---

## 3. Architecture Overview

```
Frontend (Talk tab)
    │
    ▼  POST /api/simulations/{sim_code}/personas/{persona_name}/chat
    │  Body: { message, thread_id?, step? }
    │
API Gateway (chat_with_double_service.py)
    │
    ├── 1. Load persona state (Supabase: persona_scratch, personas_coords)
    │
    ├── 2. Load/create chat thread (Supabase: user_chat_threads)
    │
    ├── 3. Embed user message (OpenAI text-embedding-3-small → 1536-d → compress to 768-d)
    │
    ├── 4. Retrieve relevant memories (Supabase RPC: dbl_retrieve_memories)
    │      pgvector similarity search against persona's memory embeddings
    │
    ├── 5. Assemble prompt context:
    │      ┌─ Persona ISS (identity, traits, currently, lifestyle)
    │      ├─ Retrieved memories (budget-capped, deduplicated)
    │      ├─ Current action + location
    │      ├─ Conversation thread history (last N turns)
    │      └─ System prompt (persona voice, chat rules)
    │
    ├── 6. Call Tier C LLM (gpt-5.2, max_completion_tokens ~8000)
    │
    ├── 7. Persist assistant message to thread (Supabase)
    │
    └── 8. Return response
```

---

## 4. Endpoint Contract

### `POST /api/simulations/{sim_code}/personas/{persona_name}/chat`

**Path parameters:**
- `sim_code` (string) — simulation identifier
- `persona_name` (string) — URL-encoded persona name

**Request body:**
```json
{
  "message": "What are you working on right now?",
  "thread_id": "uuid | null",
  "step": 100
}
```
- `message` (string, required) — user's chat message
- `thread_id` (string, optional) — existing thread ID to continue. If null, creates a new thread.
- `step` (integer, optional) — simulation step for persona context. Defaults to latest.

**Response — `200 OK`:**
```json
{
  "thread_id": "uuid",
  "persona_name": "Gosha Pistsov",
  "step": 100,
  "response": {
    "message": "I'm just finishing up my SAT math practice — been going through a timed section and marking the tricky ones. I want to nail these before lunch. Katya and I have a craft project later too, so I'm trying to stay on schedule.",
    "timestamp": "2026-03-31T22:00:00Z"
  },
  "thread_message_count": 4,
  "context_metadata": {
    "memories_retrieved": 12,
    "model": "gpt-5.2",
    "retrieval_ms": 350,
    "generation_ms": 4200
  }
}
```

**Error responses:**
- `404` — persona not found in simulation
- `503` — LLM service unavailable
- `400` — empty message or invalid thread_id

---

## 5. Supabase Schema

### `double.user_chat_threads`

```sql
CREATE TABLE double.user_chat_threads (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  sim_code text NOT NULL,
  persona_name text NOT NULL,
  step integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX idx_chat_threads_sim_persona
  ON double.user_chat_threads (sim_code, persona_name);
```

### `double.user_chat_messages`

```sql
CREATE TABLE double.user_chat_messages (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  thread_id uuid NOT NULL REFERENCES double.user_chat_threads(id),
  role text NOT NULL CHECK (role IN ('user', 'assistant')),
  content text NOT NULL,
  created_at timestamptz DEFAULT now(),
  context_metadata jsonb DEFAULT '{}'
);

CREATE INDEX idx_chat_messages_thread
  ON double.user_chat_messages (thread_id, created_at);
```

**Notes:**
- No `user_id` column in v1 (no access gating yet). Add when auth lands.
- `context_metadata` on assistant messages stores retrieval stats, model used, token counts — useful for future analytics and cost tracking.
- Thread is scoped to `(sim_code, persona_name, step)` — changing step starts a new context window.

---

## 6. Prompt Design

### System prompt

The system prompt establishes the persona's voice and chat rules. It's constructed per-thread from persona state and is NOT sent to the LLM as a static string — it's assembled from live data.

```
You are {persona_name}, a {age}-year-old person.

Your core traits: {innate}
Your background: {learned}
Your current focus: {currently}
Your lifestyle: {lifestyle}

Right now you are: {current_action_description}
You are at: {current_location_readable}

You are having a private conversation with someone who wants to get to know you.
Respond naturally as yourself — use your real thoughts, memories, and personality.
Keep responses conversational: 2-4 sentences unless the question needs more.
Never mention that you are a simulation, AI, or program.
Never reference internal systems, planner states, or technical mechanics.
If asked about something you don't remember, say so honestly.
```

### User prompt (per turn)

```
Here are your relevant memories and thoughts:
{retrieved_memories_block}

Your recent experiences:
{recent_events_block}

Conversation so far:
{thread_history}

{user_name}: {user_message}
{persona_name}:
```

### Context budget

| Component | Max tokens (approx) | Source |
|---|---|---|
| System prompt (persona identity) | ~300 | persona_scratch |
| Retrieved memories | ~2000 | pgvector RPC, budget-capped |
| Recent events/thoughts | ~500 | last 10 from dbl_memory |
| Thread history | ~2000 | last 10 turns from user_chat_messages |
| User message | ~200 | request body |
| **Total input** | **~5000** | |
| **Max output** | **~1000** | max_completion_tokens |

With Tier C (`gpt-5.2`), `max_completion_tokens` should be set to ~8000 to give the reasoning model headroom (same lesson as gpt-5-nano: reasoning tokens count against the budget). Expect ~1000 reasoning + ~200 output tokens for a typical chat response.

---

## 7. Memory Retrieval Strategy

### Flow

1. **Embed user message** via `text-embedding-3-small` (1536-d)
2. **Compress to 768-d** to match the Double memory embedding format
3. **Call Supabase RPC** `dbl_retrieve_memories` with:
   - `p_agent_id`: persona's UUID
   - `p_query_embedding`: compressed 768-d vector
   - `p_max_results`: 20
   - `p_memory_types`: `['event', 'thought', 'chat']`
4. **Format results** using budget-capped text block (~2000 chars)

### Embedding compression

The simulation engine compresses 1536-d → 768-d via **stride-2 downsampling**: `[embedding[i] for i in range(0, 1536, 2)]` — simply takes every other dimension. Verified at `hybrid_memory_store.py:768-771`. The gateway must replicate this one-liner.

### Fallback

If embedding/retrieval fails, fall back to last 20 memories by recency (same as card-summary approach). Chat should never fail because retrieval failed — it just becomes less contextual.

---

## 8. Files to Create/Modify

| File | Action | Purpose |
|---|---|---|
| `api_gateway/app/services/chat_with_double_service.py` | **Create** | Main service: thread management, embedding, retrieval, prompt assembly, LLM call |
| `api_gateway/app/api/routes/simulations.py` | **Modify** | Add POST `/chat` route |
| `api_gateway/app/core/config.py` | **Modify** | Add `llm_model_tier_c` config field |
| Supabase migration | **Create** | `user_chat_threads` + `user_chat_messages` tables |

### Reuse from card-summary

- `card_summary_transforms.format_location_readable()` — for location in system prompt
- `_get_openai_client()` pattern — singleton AsyncOpenAI client
- Exception classes: `PersonaNotFoundError`, `LLMServiceUnavailableError`
- Persona data fetching via `SupabaseService.get_persona_detailed_info()`

### New capabilities needed in gateway

- **Embedding generation**: `AsyncOpenAI.embeddings.create()` with `text-embedding-3-small`
- **768-d compression**: replicate engine's compression method
- **Supabase RPC calls**: `dbl_retrieve_memories` for pgvector search
- **Thread CRUD**: insert/select on `user_chat_threads` and `user_chat_messages`

---

## 9. Resolved Questions

| # | Question | Resolution |
|---|---|---|
| 1 | Embedding compression method | **Stride-2 downsampling** — `[e[i] for i in range(0, 1536, 2)]`. Verified at `hybrid_memory_store.py:768-771`. |
| 2 | Simulation validation | **Trust the frontend** — users can only open chat from an existing simulation's Sprite Card. |
| 3 | Thread length limits | **25-message cap** per thread. New thread starts automatically when user re-opens Sprite Card. |
| 4 | Rate limiting | **25 messages/thread (from #3) + 2 threads per hour max.** Simple guard sufficient for v1. |
| 5 | Persona awareness of user | **v1: stranger/curious observer.** Future: "you are talking to your creator." |
| 6 | Memory injection from chat | **Out of scope for v1.** Needs proper investigation to avoid breaking simulation coherence. |

---

## 10. Implementation Phases

### Phase 1 — v1 (full chat loop with pgvector)
- POST endpoint with Tier C LLM call
- Persona ISS + current state as system prompt
- Embedding generation in gateway (`text-embedding-3-small`)
- 768-d stride-2 compression + `dbl_retrieve_memories` RPC for relevant memories
- Recency fallback if retrieval fails
- Thread persistence in Supabase (`user_chat_threads` + `user_chat_messages`)
- 25-message thread cap, 2 threads/hour rate limit

### Phase 2 — Streaming upgrade
- Add SSE support to the POST endpoint (or new WS endpoint)
- Frontend shows progressive token delivery
- Typing indicator integration

### Phase 4 — Access gating + identity
- Add `user_id` to thread tables
- Verify user owns the double they're chatting with
- Persona system prompt adjusts: "you are talking to [your creator / someone you know]"

### Phase 5 — Personality modification
- Parse user instructions from chat ("focus on studying", "be more social")
- Store as persona directives in Supabase
- Simulation engine reads directives and incorporates into planning prompts
