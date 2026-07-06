# Broadcast residual — periodic re-write of survival memories

**Status:** open, blocked behind branch 2 sim completion
**Owner:** Ivan
**Filed:** 2026-05-16
**Target branch:** `ivan/reflect-event-rewrite` (to be created after branch 2 sim completes)
**Related sims:**
- `20260514-1` — original sim where the bloat first surfaced (26× factor before manual dedup)
- `20260515-2` — branch-1 verification at 1 000 steps (8× factor, 2 missing embeddings)
- `20260515-4` — branch-1 + branch-2 sim at 2 000+ steps (22× factor, growing actively)

---

## 1. What's wrong

After a survival broadcast (elimination, vote tally) lands its canonical write through the durable path, **a secondary code path repeatedly re-writes the same event-node** into surviving witnesses' memory. The re-writes:

- Go through an **async path** (so their `dbl_embedding` rows never land).
- Are **invisible to retrieval** — `dbl_retrieve_with_rir` INNER-JOINs `dbl_embedding`, so the embedding-less rows don't surface.
- **Bloat `dbl_memory`** at a rate roughly linear in sim duration (potentially many thousands of rows per logical event in a production-length run).

The canonical writes — `tag_event` and `add_event_durable` — are unaffected. Branch 1's three fixes (durable write, restart guard, 9-param overload drop) all do exactly what they were supposed to. The residual is a separate write path that branch 1 did not touch.

---

## 2. Evidence

### Q1 — per-kind row count and embedding status

Sim `20260515-4` at step ~2 000 (one Day-1 elimination of Gosha):

| kind | total_rows | with_embedding | missing_embedding | distinct_contents |
|---|---:|---:|---:|---:|
| alliance_formed | 18 | 18 | 0 | 7 |
| challenge_outcome | 7 | 7 | 0 | 2 |
| challenge_participated | 7 | 7 | 0 | 3 |
| **elimination_witnessed** | **67** | **6** | **61** | **1** |
| vote_cast | 7 | 7 | 0 | 4 |
| vote_received | 7 | 7 | 0 | 7 |
| **vote_tally** | **12** | **3** | **9** | **1** |

Canonical floor (3 surviving witnesses × 1 elim event):
- `elim_witnessed`: 6 rows expected (3 tag_event + 3 broadcast) — present and embedded.
- `vote_tally`: 3 rows expected (broadcast only) — present and embedded.
- Everything else: 1.00 dup_factor, fully embedded. **`tag_event`-only writes are perfectly clean.**

Residual:
- `elim_witnessed`: **+61 missing-embedding rows** over ~1 100 post-elim steps.
- `vote_tally`: **+9 missing-embedding rows** over the same window.

### Q2 — per-persona spread

| Persona | tally extras | elim extras |
|---|---:|---:|
| Ivan Pistsov | 3 | 7 |
| **Katya Pistsova** | **5** | **39** |
| Luba Pistsova | 1 | 15 |

Asymmetric across personas. Per-persona elim:tally ratio differs (Ivan 2.3, Katya 7.8, Luba 15), so the trigger is **not** purely "this persona was nearby" — the elim event-tile and tally event-tile have different traffic patterns.

### Q3 — duplication ratio

| kind | total_rows | distinct_logical_events | dup_factor |
|---|---:|---:|---:|
| elimination_witnessed | 67 | 3 | **22.33** |
| vote_tally | 12 | 3 | **4.00** |
| vote_cast | 7 | 7 | 1.00 |
| vote_received | 7 | 7 | 1.00 |
| challenge_outcome | 7 | 7 | 1.00 |

### Timestamp / burst analysis (Katya, elim_witnessed)

Histogram of `created_at` deltas between consecutive rows (same `agent_id`, same `content`):

| Delta bucket | n |
|---|---:|
| **< 1 sim-min** (sub-second to ~minute) | **59** |
| 15-30 sim-min | 5 |
| 30-60 sim-min | 5 |
| > 60 sim-min | 3 |

Raw timeline shows ~13 **bursts of 1-8 writes** each, all sub-second within a burst, then **~30-90 minute real-time gaps** between bursts. Burst sizes grow over time: 1 → 2 → 3 → 7 → 8 → 7 → 7 → 7.

The growing burst size is a positive-feedback signature — strongly suggests the function being triggered is iterating over a list that *it itself* contributed to in prior fires.

---

## 3. Hypothesis (highest confidence)

**`reflect()` running on a poignancy threshold** is the most likely trigger:

- Reflection fires periodically based on accumulated poignancy of recent events.
- Elim events carry `poignancy = 8.0` (highest tier) → they dominate reflection's input pool after every burst.
- Reflection iterates source events to build derived thoughts.
- **Bug suspect:** somewhere in the reflection path, `add_event(source_node.description, …)` is being called instead of (or in addition to) `add_thought(…)` — effectively re-persisting each source event as a brand-new event row, which then becomes a new source for the next reflection.

Per-persona variance is then explained by per-persona poignancy accumulation rates — Katya has the highest baseline activity (most steps, most events, most memories) → reflection fires more often for her → most amplification.

### Alternative hypotheses (lower confidence)

| Hypothesis | Why it's less likely |
|---|---|
| Per-step perception loop | Histogram would show ~12-20 second deltas (per-step granularity). Observed deltas are bimodal (sub-second + ~30-min). |
| `_broadcast_elimination` recap-loop | Would fire once per broadcast call. Burst growth wouldn't happen. |
| Tile-re-entry perception | Burst growth wouldn't happen. Would also correlate strictly with persona movement; observed pattern doesn't. |
| Memory consolidation / compression pass | Plausible alternative if it has a similar feedback shape — worth grepping for if `reflect.py` doesn't have the bug. |

---

## 4. Fix approach

Three candidate fixes, ordered by surgicality:

### Option A — guard `add_event` against dedup_key collisions

Before any `add_event` call from inside `reflect.py` / `perceive.py` / similar, check if the persona's `kw_to_event` already has a `dedup_key`-prefixed keyword present in the source node's keywords. If yes, short-circuit. Mirrors what `broadcast_event_to_personas` already does, generalised.

**Pros:** small change, defensive.
**Cons:** doesn't fix the underlying mis-routing — just suppresses the symptom.

### Option B — re-route survival-tagged sources to `add_thought` only

If `reflect.py` is incorrectly calling `add_event` for source events when it should only be calling `add_thought` for the derived insight, fix the routing at the call site.

**Pros:** correct fix, addresses the bug rather than the symptom.
**Cons:** requires identifying the exact call site; might need a code-read of all of `reflect.py`'s outputs.

### Option C — broader audit of all `add_event` call sites

Grep every `add_event` call in the cognitive modules and verify each one's intent. Route the survival-irrelevant ones to `add_event_durable` if they're high-poignancy; route the source-reads-as-new-events ones to noop.

**Pros:** thorough.
**Cons:** scope creep — likely not needed if Option B catches it.

**Recommended starting point:** Option B. Begin with:
```bash
grep -rn "add_event\b" reverie/backend_server/persona/cognitive_modules/reflect.py
grep -rn "add_event\b" reverie/backend_server/persona/cognitive_modules/perceive.py
grep -rn "add_event\b" reverie/backend_server/persona/persona.py
```
Look for any `add_event` call whose `description` argument is derived from an existing event-node's content (vs. freshly-generated text).

---

## 5. Verification protocol for the fix

Once a fix candidate lands:

1. **Unit test** — construct a mock persona, populate `a_mem.seq_event` with a survival-tagged event, fire whatever code path was changed N times, assert that `add_event` was called zero additional times for survival-tagged sources.
2. **Local sim** — fresh fork, run ~1 500 steps (through Day-1 elim + ~600 post-elim steps).
3. **Re-run Q1/Q3** for the new sim's UUID. Pass criteria:
   - `elim_witnessed`: `dup_factor == 1.00` (or ≤ 2.00 if both tag_event + broadcast paths contribute, but no async residuals).
   - `vote_tally`: `dup_factor == 1.00`.
   - `missing_embedding == 0` for every kind.
4. **Re-run timestamp diagnostic** for the new sim. Pass criteria: histogram shows only canonical-write deltas (sub-second between the tag_event + broadcast pair), no further bursts.

---

## 6. Severity & priority

- **User-visible impact:** none directly. Retrieval is uncontaminated.
- **Storage impact:** linear in sim duration. ~14 bloat rows per real-hour per persona post-elim observed in `20260515-4`. A 30-day production sim with 3 eliminations could write 30 000+ unintended rows.
- **Indirect impact:** `seq_event` and `kw_to_event` in-memory state may also be polluted (if the bloat path goes through `json_store.add_event` first), which could affect retrievals that read those structures directly — needs verification once the bug is located.

**Priority:** Land before any production-length sim run. Not blocking for development/validation runs.

---

## 7. History

- **2026-05-15** — first surfaced during 20260515-2 branch-1 verification. Framed as a minor data hygiene issue (8 elim rows, 2 missing embeddings). Initial guesses: perception-path re-write OR `_broadcast_elimination` recap-loop. Recommendation at the time was to merge branch 1 and file as a follow-up.
- **2026-05-16 (mid-day)** — re-checked on 20260515-4 at step 2 000+. Severity revised: bloat is growing fast and clearly linked to a periodic batch process, not a one-off. Timestamp diagnostic confirmed bursts (not per-step), ruled out perception-path-every-step hypothesis. Refined fix surface to `reflect.py` (most likely) or related cognitive batch paths.
- **2026-05-16 (end-of-sim)** — sim ended at step 3 500. Sharper evidence at completion:

  | kind | distinct_contents | distinct_logical_events | Implication |
  |---|---:|---:|---|
  | elim_witnessed | **3** | 7 | only 2 elims actually happened — the third distinct content is **derivative** (paraphrased text for the same logical event) |
  | vote_tally | 2 | 5 | matches 2 tally events with no derivatives — lower poignancy = less reflection triggers |
  | vote_cast, vote_received, challenge_outcome, challenge_participated, alliance_formed | matches | matches | clean |

  **The "third distinct content" detail is the load-bearing observation.** A naive re-write loop would produce duplicates with byte-identical content. We observe duplicates **with slightly different text** — that is the unmistakable signature of `reflect()` generating a paraphrased summary of an existing event and then writing it via `add_event(description=<paraphrased text>, …)` instead of `add_thought(description=<paraphrased text>, …)`. Each reflection produces a new distinct content string for the same logical event, then becomes a new source for the next reflection.

  The asymmetry between elim (3 distinct contents) and tally (2 distinct contents — no derivatives) is explained by poignancy: elim events carry `poignancy=8.0` (highest tier), tally events carry `7.0`. Reflection picks high-poignancy events into its consolidation pool more often. Higher-poignancy events therefore generate more derivative content.

  **Fix surface narrows further.** Look for any `add_event` call in `reflect.py` (or any function reflect.py calls) whose `description` argument comes from an LLM-generated paraphrase of an existing event-node's content. That's the bug. The fix is either:
  - Re-route to `add_thought` (correct), OR
  - Route through `add_event_durable` with a dedup_key derived from the source event (less correct but easier).

  Verification protocol from §5 still applies; pass criterion remains `distinct_contents == 2` per elimination (one tag_event content + one broadcast content, identical) and `dup_factor ≤ 2.00` (no derivative content).
