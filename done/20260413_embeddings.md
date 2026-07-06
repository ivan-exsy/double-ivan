# Local Embeddings Dict: Redundant RAM Growth After Supabase Migration

**Filed:** 2026-04-07
**Severity:** Medium (RAM waste, not correctness)
**Branch:** post-merge (applies to `nicolas` branch after it merges `local` — see `20260408-mergeBE.md`)
**Related sim:** 20260406-3 (3GB RAM, 960 steps, 4 agents)

> **Implementation context updated 2026-04-08.** This plan was originally written against `local`. Nicolas's branch has reshaped `perceive.py` significantly, and Ivan is implementing this fix on the merged branch after Nicolas completes his merge. The high-level design is unchanged; Step 1 has been revised to handle the **three** `a_mem.embeddings` read sites that exist on the merged branch (not the two sites on the old `local`). `associative_memory.py` (Step 2) is unchanged — Nicolas never touched it.

## Problem

`AssociativeMemory.embeddings` (`associative_memory.py:76`) is an in-memory dict that holds every embedding ever created during a simulation. Each entry is a 768-float array (~6KB). Over a long sim, this dict grows unboundedly:

- 960 steps x 4 agents x ~3 embeddings/step = ~11,500 entries = **~69 MB per agent / ~276 MB total**
- For a full 3-day survival sim (4,320 steps): projected **~500 MB+**
- Never evicted, never trimmed. Also serialized to `embeddings.json` on every persist cycle (`associative_memory.py:161`), growing disk writes too.

## Why It Exists (Legacy)

Before Phase 4 (Supabase pgvector migration), the JSON retriever (`retrieve.py:224`) computed cosine similarity locally and needed all embeddings in RAM:

```python
# retrieve.py:224 — legacy JSON path
node_embedding = persona.a_mem.embeddings[node.embedding_key]
relevance_out[node.node_id] = cos_sim(node_embedding, focal_embedding)
```

The dict was the only place embeddings lived. Every node's embedding had to be in RAM for retrieval to work.

## Why It's Redundant Now

With `USE_DB_MEMORY_READS=true` (production default since Phase 4), retrieval goes through `retrieve_double.py`, which:
- Queries Supabase pgvector for similarity (server-side cosine)
- Has its own LRU embedding cache (`_embedding_cache` + `_embedding_cache_prev`) with eviction
- **Never touches `persona.a_mem.embeddings`** (confirmed: zero references to `a_mem.embeddings` in `retrieve_double.py`)

The local dict now serves exactly one purpose: `perceive.py:150-151` checks it before calling `get_embedding()` to avoid duplicate API calls within the same step:

```python
# perceive.py:150-153
if desc_embedding_in in persona.a_mem.embeddings:
    event_embedding = persona.a_mem.embeddings[desc_embedding_in]
else:
    event_embedding = get_embedding(desc_embedding_in)
```

Same pattern at `perceive.py:166-171` for chat embeddings.

## Current Flow (Wasteful)

1. `perceive.py` creates embedding -> checks local dict first (cache hit avoids API call) -> stores in `a_mem.embeddings` (RAM, forever)
2. `associative_memory.py:205,249,280` — `add_event()`, `add_thought()`, `add_chat()` all append to dict
3. `associative_memory.py:161` — `save()` serializes entire dict to `embeddings.json` every persist cycle
4. `retrieve_double.py` — ignores the dict entirely, queries pgvector
5. `retrieve.py:224` — legacy path reads from dict (only active if `USE_DB_MEMORY_READS=false`)

## Suggested Fix: Use retrieve_double's existing cache (cleanest)

Route perceive's embedding lookups through the same `_get_cached_embedding()` / `_cache_embedding()` in `retrieve_double.py` which already has LRU eviction. Remove `self.embeddings` entirely when `USE_DB_MEMORY_READS=true`.

**Changes:**
- `perceive.py` — import and use `retrieve_double._get_cached_embedding()` instead of `a_mem.embeddings`
- `associative_memory.py` — guard `self.embeddings` behind `USE_DB_MEMORY_READS` flag
- `associative_memory.py:161` — skip `embeddings.json` write when DB reads enabled

**RAM saved:** Same as Option A, plus eliminates a redundant cache layer.

### Legacy safety

The legacy JSON retriever (`retrieve.py:224`) still needs the full dict when `USE_DB_MEMORY_READS=false`. Both options must preserve the current behavior behind that flag. The dual-import fallback pattern applies here.

## Files Involved

| File | Role |
|---|---|
| `persona/memory_structures/associative_memory.py` | Owns `self.embeddings` dict, loads/saves `embeddings.json` |
| `persona/cognitive_modules/perceive.py:150-171` | Only active consumer of local dict (embedding cache for dedup) |
| `persona/cognitive_modules/retrieve.py:224` | Legacy consumer (only when `USE_DB_MEMORY_READS=false`) |
| `persona/cognitive_modules/retrieve_double.py:439-470` | Has its own LRU cache, never touches local dict |

---

## Implementation Plan

**What this does in plain language:** When the system is set to use the database (which is always in production), stop hoarding every embedding in memory forever. Instead, let the existing smart cache in the retrieval layer handle dedup. The old local-only path stays intact behind its flag, untouched.

**Decision rationale:** There's no benefit to maintaining a separate local cache when the database retrieval layer already has a better one — thread-safe, bounded, with eviction and monitoring. Option A (keeping a smaller local cache) was rejected as unnecessary duplication.

### Step 1 — `perceive.py`: Use retrieval cache instead of local dict

> **POST-MERGE UPDATE.** On the merged branch, `perceive.py` has **three** sites that read `persona.a_mem.embeddings`, not two. Nicolas added a new helper `_persist_chat_node_early()` (called from `conversation_manager` and the reverie greeting path) that pre-persists chat nodes at conversation start. All three sites need the same treatment. Line numbers below reflect the merged file shape; re-confirm them before editing in case the merge shifts them.

**Three sites to patch (merged branch):**

| Site | Function / context | Purpose of the lookup |
|---|---|---|
| ~lines 33–36 | `_persist_chat_node_early()` (Nicolas's new helper) | Chat embedding at conversation start (early persist for reflect evidence linking) |
| ~lines 185–188 | `perceive()` event loop | Event embedding during perception |
| ~lines 207–211 | `perceive()` event loop (nested inside `if not _chat_node_persisted`) | Chat embedding when the early-persist path didn't fire |

All three follow the same old pattern:
```python
if <desc> in persona.a_mem.embeddings:
    embedding = persona.a_mem.embeddings[<desc>]
else:
    embedding = get_embedding(<desc>)
```

**New behavior:** When DB reads are on, check `retrieve_double`'s cache instead. Fall back to the old dict path when DB reads are off. Identical pattern at all three sites.

#### Import block (add once at top of file)

Place near the existing import block, after `from persona.prompt_template.run_gpt_prompt import *` and after Nicolas's `location_helpers` import:

```python
try:
    from persona.memory_structures.runtime_flags import db_memory_reads_enabled
except Exception:
    from memory_structures.runtime_flags import db_memory_reads_enabled  # type: ignore[no-redef]

_USE_DB = db_memory_reads_enabled()
if _USE_DB:
    try:
        from persona.cognitive_modules.retrieve_double import (
            _get_cached_embedding, _store_cached_embedding
        )
    except Exception:
        from cognitive_modules.retrieve_double import (  # type: ignore[no-redef]
            _get_cached_embedding, _store_cached_embedding
        )
```

#### Helper (define once, use at all three sites)

To avoid copy-pasting the same 8-line if/else three times, define a module-level helper right after the imports:

```python
def _cached_or_fetch_embedding(persona, desc):
    """DB mode: route through retrieve_double's LRU cache.
    Legacy mode: check the per-persona dict (old behavior)."""
    if _USE_DB:
        emb = _get_cached_embedding(desc)
        if emb is None:
            emb = get_embedding(desc)
            _store_cached_embedding(desc, emb)
        return emb
    if desc in persona.a_mem.embeddings:
        return persona.a_mem.embeddings[desc]
    return get_embedding(desc)
```

#### Apply at all three sites

**Site A — `_persist_chat_node_early()` (~lines 33–36):**
```python
# Before:
if desc in persona.a_mem.embeddings:
    chat_embedding = persona.a_mem.embeddings[desc]
else:
    chat_embedding = get_embedding(desc)

# After:
chat_embedding = _cached_or_fetch_embedding(persona, desc)
```

**Site B — event embedding in `perceive()` (~lines 185–188):**
```python
# Before:
if desc_embedding_in in persona.a_mem.embeddings:
    event_embedding = persona.a_mem.embeddings[desc_embedding_in]
else:
    event_embedding = get_embedding(desc_embedding_in)

# After:
event_embedding = _cached_or_fetch_embedding(persona, desc_embedding_in)
```

**Site C — chat embedding in `perceive()` (~lines 207–211, nested inside `else` branch of the `_chat_node_persisted` check):**
```python
# Before:
if persona.scratch.act_description in persona.a_mem.embeddings:
    chat_embedding = persona.a_mem.embeddings[
                       persona.scratch.act_description]
else:
    chat_embedding = get_embedding(persona.scratch.act_description)

# After:
chat_embedding = _cached_or_fetch_embedding(persona, persona.scratch.act_description)
```

Preserve the surrounding code (keyword building, `chat_embedding_pair` tuple, `generate_poig_score()` call, `add_chat()` call) unchanged.

#### Why this matters for Nicolas's helper

Nicolas's `_persist_chat_node_early()` was added to support chat-node persistence at conversation start so that `reflect()` can link evidence to the chat node in the same step. It wasn't written with the Supabase cache migration in mind — it just copied the old dict-lookup pattern from the main `perceive()` loop. Routing it through the same helper keeps behavior consistent across all three chat-node creation paths and avoids an untouched legacy reader once the dict gets gated in Step 2.

### Step 2 — `associative_memory.py`: Stop loading/growing/saving the dict when DB is on

> **Unchanged from the original plan.** Nicolas never touched this file, so the four edits below apply cleanly to the merged branch. Line numbers should be identical.

**2a — Init (line 76):** Skip loading `embeddings.json`.

```python
# Add import at top:
_USE_DB = os.getenv("USE_DB_MEMORY_READS", "true").lower() == "true"

# Line 76:
if _USE_DB:
    self.embeddings = {}
else:
    self.embeddings = json.load(open(f_saved + "/embeddings.json"))
```

**2b — Node loading (lines 100–101):** Skip embedding vector lookup; only need the key string.

```python
if _USE_DB:
    embedding_pair = (node_details["embedding_key"], None)
else:
    embedding_pair = (node_details["embedding_key"],
                      self.embeddings[node_details["embedding_key"]])
```

**2c — `add_event` (line 205), `add_thought` (line 249), `add_chat` (line 280):** Guard the dict write.

```python
if not _USE_DB:
    self.embeddings[embedding_pair[0]] = embedding_pair[1]
```

**2d — `save()` (lines 160–161):** Skip writing `embeddings.json`.

```python
if not _USE_DB:
    with open(out_json+"/embeddings.json", "w") as outfile:
        json.dump(self.embeddings, outfile)
```

### Step 3 — Validation

> **POST-MERGE UPDATE.** Added two validation points specific to the merged-branch interactions: a check that Nicolas's early-persist chat flow still fires correctly, and a check that `ConversationManager`-driven chats use the cached path.

1. Run a short sim (20–40 steps, 4 agents) with `USE_DB_MEMORY_READS=true`.
2. Confirm RAM stays flat (no growth from embeddings) — inspect `tracemalloc` snapshot or OS RSS before/after.
3. Confirm no errors in perceive/retrieve logs.
4. Run `export verification stats 24` — check `retrieve_double` embedding cache hit/miss counters are healthy. After the first 10 steps, cache hit rate should climb above zero (dedup is working).
5. Verify `embeddings.json` is NOT written during the run (`ls environment/frontend_server/storage/<sim_code>/personas/<name>/bootstrap_memory/` — the file should be absent or frozen at its pre-run size).
6. **Merged-branch check A:** Trigger at least one conversation via `ConversationManager`. Confirm `_persist_chat_node_early()` fires (look for chat node persistence logs at conversation start, not just at end-of-step in `perceive()`).
7. **Merged-branch check B:** Confirm both chat-node creation paths (early persist via Nicolas's helper AND the fallback inside `perceive()`) produce the same cache-hit behavior. An early-persisted chat followed by a perceive-pass observation should hit the cache on the second lookup, not re-call `get_embedding()`.
8. **Legacy smoke test:** Run the same sim with `USE_DB_MEMORY_READS=false` (20 steps is enough). Confirm the old dict path still works, `embeddings.json` is written, and no `NameError` from the conditional imports.
9. **Survival mode sanity:** Enable `SURVIVAL_MODE_ENABLED=true` for a 100-step run. Survival injects lots of chats during vote phases, which exercises both chat-embedding sites. Watch for RAM growth — this is the regression surface that motivated the fix.

### Files touched

| File | What changes |
|---|---|
| `persona/cognitive_modules/perceive.py` | Add `_cached_or_fetch_embedding()` helper + conditional imports, then replace 3 dict-lookup blocks with helper calls (one in `_persist_chat_node_early`, two in `perceive`) |
| `persona/memory_structures/associative_memory.py` | Skip load/grow/save of `self.embeddings` when DB reads on (4 edits: init, node load, add_event/thought/chat writes, save) |

### Risk assessment

- **Low risk.** All changes are gated behind `USE_DB_MEMORY_READS` — if anything breaks, setting it to `false` restores full legacy behavior instantly.
- **No behavioral change.** Agents will perceive, remember, and retrieve exactly the same way. Only the plumbing for where embedding dedup happens changes.
- **No database changes.** Nothing in Supabase is affected.
- **No conflict with Nicolas's work.** All three perceive.py sites get treated consistently. The helper approach means Nicolas's `_persist_chat_node_early()` doesn't become a silent legacy reader after Step 2 gates the dict.

---

## Pre-implementation checklist (for when I pick this up post-merge)

Before writing any code, verify the merged branch state:

1. [ ] `git checkout` the merged branch Nicolas hands back (likely `integration/20260408-local-into-nicolas` or fast-forwarded `nicolas` / `local`)
2. [ ] Confirm survival mode validation is green (per `20260408-mergeBE.md` Step 6–7)
3. [ ] Re-verify line numbers in `perceive.py` — run `grep -n "a_mem.embeddings" reverie/backend_server/persona/cognitive_modules/perceive.py`. Should return exactly **3** matches (4 if counting `_persist_chat_node_early()` both the `if` check and dict access as separate lines).
4. [ ] Re-verify line numbers in `associative_memory.py` — should be unchanged from the plan (init ~76, node load ~100–101, save ~161, add_event ~205, add_thought ~249, add_chat ~280).
5. [ ] Confirm `retrieve_double._get_cached_embedding` / `_store_cached_embedding` still exist and have the same signatures. Nicolas shouldn't have touched `retrieve_double.py`, but verify.
6. [ ] Confirm `runtime_flags.db_memory_reads_enabled()` still exists and behaves the same.

If any of these checks fail, pause and reassess — the merge may have introduced surprises that change the patch shape.
