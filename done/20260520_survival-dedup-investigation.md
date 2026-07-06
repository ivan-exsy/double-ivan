# Survival-memory duplication — investigation (opened 2026-05-20)

**Status:** OPEN — decisive diagnostic run (2026-05-20, §5 below). Root cause:
the elimination memory is **re-created as a fresh memory node** dozens of times
across the run; the node_id-keyed dedup guard cannot catch copies because each
copy has a new node_id. Fix direction identified; code trace of the re-creation
trigger is the remaining work.

**Owner:** Ivan's agent. **Branch:** none yet (do not start a fix until the
diagnostic below is run).

**Sources:** `20260519_be_debt.md` §5 (broadcast memory bloat) + the
`20260519-1` retrospective. Supersedes the "write-time dedup on the
survival-event emit path" guess in that doc — see *Refuted* below.

---

## 1. Plain-language summary

Survival "highlight" memories — who got eliminated, and the vote tally — are
each being saved to the database roughly **8 times** instead of once. We first
suspected the survival game logic was re-running. **It is not.** The game ran
each elimination exactly once. The duplication happens later, in the shared
memory-saving machinery, when a memory is written to durable storage and then
re-saved on every later "flush" cycle. This is a storage-bloat bug, not a
gameplay bug — agents still behave correctly; the database just accumulates
redundant copies.

---

## 2. What is confirmed

### 2.1 The two affected memory kinds and their only writer

`elimination_witnessed` and `vote_tally` rows are written **exclusively** by
`broadcast_event_to_personas` (`persona/cognitive_modules/world_events.py:43`),
called from `_broadcast_elimination` (`survival/controller.py:1999` and `:2032`).

The four `tag_event` call sites in `controller.py` (`:1199` `challenge_participated`,
`:1795` `vote_received`, `:1801` `vote_cast`, `:2106` `alliance_formed`) do **not**
emit either affected kind. `tag_event` is not involved in this bug.

### 2.2 The survival phase machine fired exactly once per day — hard evidence

`storage/20260519-1/logs/survival_phase_trigger.ndjson` (the full file, 5 lines):

```
challenge day 1 step 131   |  voting day 1 step 690
challenge day 2 step 1544  |  voting day 2 step 2130
challenge day 3 step 3013
```

`survival_llm_calls.ndjson` corroborates: `vote_decision` fired once per persona
on day 1 (step 690) and once per persona on day 2 (step 2130). So voting →
elimination → `_broadcast_elimination` → `broadcast_event_to_personas` executed
**exactly twice for the whole run** (Luba day 1, Ivan day 2).

### 2.3 The controller's idempotency guards are working

- `controller.py:610` — `if not self._elimination_done and self._pending_elimination`
  gates elimination to once per day within a run.
- `controller.py:1900` — restart-safe guard: skips re-elimination if the target
  is already in `season.eliminated` (persisted). Added after sim `20260514-1`.

Both held. No phase-window loop, no restart re-run.

### 2.4 Therefore the multiplication is inside the durable write

`broadcast_event_to_personas` loops witnesses and calls `add_event_durable` once
per witness: 3 survivors for Luba's elimination + 2 for Ivan's = **5 calls**.
The diagnostic found **40 `elimination_witnessed` rows / 5 distinct
`(agent_id, content)` groups = 8× per group**. Five calls, forty rows ⇒
`add_event_durable` (or its flush path) is materialising ~8 DB rows per single
logical write. Same shape for `vote_tally` (22 rows / 5 = 4.4×).

The duplicates are spread **10–90 min apart** across ~9 sim-hours (per the
timestamp diagnostic) — i.e. one extra copy per later flush/compaction cycle,
not a burst.

---

## 3. Hypotheses refuted

| Hypothesis | Verdict | Why |
|---|---|---|
| Write-time dedup missing on the survival emit path (`20260519_be_debt.md` §5 guess) | **Refuted** | An idempotency guard already exists — `broadcast_event_to_personas` checks `dedup_key` against `kw_to_event`. The emit path is called only twice; adding emit-side dedup would not help. |
| Phase machine re-runs the ELIMINATION window every step | **Refuted** | `_elimination_done` guard + the phase-trigger log (one trigger per day). |
| Sim restarts re-run voting/elimination | **Refuted** | Phase-trigger log shows a single voting trigger per day; `:1900` restart guard present. |
| Compounding `social_capital` bumps (raised 2026-05-20, pre-evidence) | **Refuted** | `_execute_elimination` runs once per day — the `:1928` bump does not compound. No behavioural bug here. |

---

## 4. Decisive diagnostic — result (2026-05-20)

Q1/Q2 ran against sim `20260519-1` (UUID `ee7fe595-edd2-4071-ba3c-2962a9fe2c9a`),
`double.dbl_memory` filtered to `'elimination_witnessed' = ANY(keywords)`.

| agent | content | total_rows | distinct_node_ids | distinct_memory_ids |
|---|---|--:|--:|--:|
| d4407efa… | Luba eliminated | 12 | **12** | 12 |
| dfc32e65… | Luba eliminated | 12 | **12** | 12 |
| d4407efa… | Ivan eliminated | 6 | **6** | 6 |
| 8af61baf… | Luba eliminated | 5 | **5** | 5 |
| dfc32e65… | Ivan eliminated | 5 | **5** | 5 |

**`distinct_node_ids` == `total_rows` for every group.** It is **not** a
non-idempotent re-INSERT of one node. Each duplicate is a *separately
re-created* event node.

The node_ids are sequential per-persona a_mem event counters —
`20260519114358_event_234`, `_273`, `_329`, … `_901` — and `created_at` spans
the **whole run** (19:55 → 05:21 wall-clock), at irregular intervals (7 min to
1 h 42). `any_tag_event_style_node_id` is `false` everywhere: confirmed written
through `add_event_durable`, not `tag_event`.

---

## 5. Root cause — code trace (2026-05-20)

A **self-feeding loop between the pre-compaction flush and the JSON backup**:

1. The survival broadcast writes the elimination node once into the persona's
   `seq_event` (poignancy 8.0).
2. On each reflection cycle, `_flush_high_value_memories_pre_compaction`
   (`reflect.py:313`) → `_flush_candidates` (`reflect.py:276`) picks the top-N
   nodes with poignancy ≥ `MEMORY_PRE_COMPACTION_FLUSH_POIGNANCY_MIN` — the
   elimination node (8.0) always qualifies — and writes each via
   `write_typed_memory` with `provenance="pre_compaction_flush"`. New
   `dbl_memory` row.
3. `write_typed_memory` → `_async_typed_json_backup` → `_write_typed_to_json`
   (`hybrid_memory_store.py:794`). With `MEMORY_JSON_BACKUP=true` (default),
   line 817 calls `json_store.add_event(...)` — which **re-inserts a fresh copy
   back into the live `seq_event`** with a brand-new sequential node_id.
4. The flush guard `_flushed_pre_compaction_node_ids` (`reflect.py:254`) marks
   only the *original* node's id. The re-inserted copy has a *new* node_id, so
   it is not in the guard set.
5. Next reflection cycle: `_flush_candidates` re-picks the re-inserted copy
   (poignancy still 8.0, node_id not flushed) → flushes it again → another
   `dbl_memory` row + another JSON re-insert. Loop repeats once per reflection
   cycle. The ~12 copies map 1:1 to the ~12 reflection cycles that persona ran.

The irregular cadence is the reflection-trigger cadence (importance-accumulation
based), not a fixed interval.

**Classification: a genuine work loop, not benign.** Each cycle burns a fresh
`get_embedding` call + a Supabase INSERT and grows `seq_event` — self-amplifying
(prior incident: sim `20260515-4`, 135 rows for 2 eliminations).

**Refuted:** the earlier "keyword-keyed dedup at `add_event_durable`" idea
(old §6) is wrong — the re-creation never goes through `add_event_durable`;
it goes through `write_typed_memory`. `broadcast_event_to_personas`'s existing
`dedup_key` check is sound and not implicated.

---

## 6. The fix — scoped, contained, 1 file

**Option A (chosen):** in `_flush_candidates` (`reflect.py`), skip any candidate
node that is itself a pre-compaction-flush re-insert. The JSON re-insert carries
`provenance="pre_compaction_flush"` (and `pre_compaction_flush: True`) in its
`filling` dict — so the re-inserted copies are unambiguously identifiable. One
skip condition next to the existing `already_flushed` check breaks the loop:
the original node is flushed once (correct — persisted to Supabase) and marked
in the node_id guard; every re-inserted copy is skipped by provenance.

**Blast radius:** one function in `reflect.py`, the pre-compaction-flush path
only. No change to the broadcast path, the survival controller, retrieval, the
hybrid store, or the existing `dedup_key` mechanism. The repo already has
`tests/test_pre_compaction_flush_dedup.py` — extend it with a failing test
asserting a flush re-insert is not re-flushed.

Expected outcome: elimination memory drops from ~8–20 rows to ~2 (the original
durable write + one legitimate flush) — `dup_factor` ≤ 2.00, clearing the §5
gate.

---

## 7. Next actions

1. [x] Run the node_id diagnostic — §4.
2. [x] Code-trace the re-creation trigger — §5.
3. [x] Implement Option A on `ivan/dev` — `_is_flush_reinsert` skip in
   `reflect.py:_flush_candidates`; failing test added to
   `tests/test_pre_compaction_flush_dedup.py`. 5 flush-dedup + movement-realism
   tests pass.
4. [ ] Validate on the next 3500-step run by re-running Q1 (§4) — expect
   `dup_factor` ≤ 2.00. This run doubles as the `20260519_be_debt.md` §5
   storage-gate verification.
5. [ ] Update `20260519_be_debt.md` §5 to point here and drop the obsolete guess.
