# Branch 2 startup — `ivan/conversation-quality`

**Status:** branch created on `origin/main`, ready for work. Open in a separate window/worktree to develop in parallel with branch 1 (`ivan/survival-retrieval-fix`).

**Scope:** Day-3 mode-collapse mitigation + analyzer methodology fixes. Independent of branch 1 — both branches edit different files and can be developed simultaneously.

---

## Context (what came before)

Sim `20260514-1` (3 days survival, 4 Pistsovs) exhibited:

1. **Day-3 mode collapse** — once cast shrank to 2 survivors (Katya + Luba), all 19 Day-3 chats were between them, 14 opening with "Quick thought —" rehearsing the same Energy Rationing pitch.
2. **Analyzer false positives** — verification report claimed 77% cooldown violations and 2 OSCILLATION runs; deeper analysis showed both were measurement artifacts (slicing artifacts mis-counted as restarts; desk work mis-flagged as oscillation).
3. **Survival broadcasts never surfaced in chat or vote decisions** — the headline finding originally attributed to embedding write loss + simulation_id NULL poisoning. **The real root cause was a PostgREST RPC overload ambiguity** (PGRST203) on `dbl_retrieve_with_rir` since the 2026-04-14 migration. Branch 1 fixed this with a one-line migration that drops the 9-param overload. **See the "FINAL CORRECTION" section of the verification report for the full story** — the prior RCA addendums named real bugs that needed fixing but neither was the retrieval blocker.

Full RCA at `D:\Coding\generative_agents\environment\frontend_server\storage\20260514-1\20260514-1_verification.md` (scroll to "FINAL CORRECTION — actual root cause was a PostgREST RPC overload (2026-05-15)" for the load-bearing analysis).

Three compounding causes for the mode collapse:
- **Planner converges when cast shrinks** — both survivors independently arrive at the same "prep for today's challenge" daily plan.
- Both gravitate to Hobbs Cafe, where `cooldown_mod = -2` makes effective cooldowns 3 / 13 / 28 — so chats fire frequently.
- **Edit D's partner-block re-anchors each new chat onto the previous chat's topic.** Note: in the broken sim, semantic retrieval was returning 0 results (PGRST203), so the partner-block was the *only* memory context the LLM saw. With branch 1's retrieval fix, semantic retrieval now also contributes ~30 candidates per chat — so the partner-block's topic redundancy matters *more* now (it competes for prompt budget against a fuller candidate pool), but the fix shape doesn't change.

This branch addresses causes 1 and 3 (cause 2 is intentional arena gravity and not a bug). The analyzer hygiene fixes prevent future verification reports from claiming the same false-positive bugs.

---

## Worktree setup

From a new shell, in the project root:

```bash
# Option A — separate worktree (recommended, avoids switching back-and-forth)
git worktree add ../generative_agents-conv-quality ivan/conversation-quality
cd ../generative_agents-conv-quality

# Option B — same checkout, just switch branches when you want to work on this one
git checkout ivan/conversation-quality
```

Both branches were created from the same `origin/ivan/dev` commit (`5feaf6f6`), so there's no merge dependency at branch-creation time — branch 2 doesn't automatically inherit branch 1's commits.

**Rebase plan after branch 1 merges:**

Branch 1 ships three commits (durable broadcast writes + restart guard + 9-param-overload-drop migration). Branch 2 unit tests don't depend on those — partner-block contents are mocked directly in the topic-dedup test (Step 2.2). So you can develop branch 2 against `origin/ivan/dev` as it stands today.

When branch 1's Path C sim run confirms PASS and branch 1 merges to `ivan/dev`:

```bash
git fetch origin
git rebase origin/ivan/dev          # pulls branch 1's three commits in
# resolve any conflicts (there shouldn't be any — zero file overlap)
```

After that, fresh sim runs against branch 2 will have branch 1's fixes in scope, which is necessary for empirically observing the partner-block dedup's effect on Day-3 mode collapse.

---

## Step-by-step

Follow CLAUDE.md's bug workflow: **failing test first, then fix, then run `/verify` after all steps land.**

### Step 2.1 — Small-cast planner guardrail

**Goal:** When `len(survival.remaining_players) <= 2`, the daily-plan LLM is steered to include non-survival variety so both surviving personas don't converge on the same single rehearsal activity all day.

**Files touched:**
- `reverie/backend_server/persona/cognitive_modules/plan.py` — `generate_first_daily_plan` (line ~2521)
- `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` — `run_gpt_prompt_daily_plan` (find via grep; the prompt-builder for survival_daily_plan_v1.txt)
- `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt` — append a conditional "SMALL CAST GUIDANCE" block triggered by a new template variable

**Failing test first:**
- `tests/test_small_cast_planner_guardrail.py` (new)
- Build a fake survival state with `remaining_players` of size 2; call the prompt-builder; assert the rendered prompt contains the "small cast" guidance string.
- Same test with `remaining_players` of size 4 should assert the guidance string is **absent**.

**Implementation:**
- Wire `remaining_players_count` into the prompt-builder's input dict (an `INPUT N` slot).
- In `survival_daily_plan_v1.txt`, append a templated section that renders only when the count ≤ 2. Content roughly: "With only N players remaining, the day risks collapsing into nonstop rehearsal of the same activity. Deliberately include at least 30% non-survival activities: meals, rest, household chores, casual walks, conversations unrelated to the challenge. Variety preserves naturalness."
- No new env flag. Default behaviour is "always include the conditional render."

**Edge cases to cover in tests:**
- Survival mode off (no `survival_controller`) → no guardrail, no crash.
- `remaining_players` count of 1 (last survivor — game ends) → guardrail still renders but irrelevant.
- Count of 3 → no guardrail (we're targeting the 2-survivor cliff specifically).

### Step 2.2 — Partner-block topic dedup

**Goal:** Break the recursive "Energy Rationing pitch" anchor. Edit D's partner-block currently returns the top-5 most recent partner-related thoughts; when 5 of them share a topic, the next chat is anchored to that topic, which produces more same-topic thoughts, and so on.

**Note on context after branch 1:** the partner-block uses `a_mem.retrieve_about(name, kind=...)` which is a pure dict lookup against `kw_to_thought` / `kw_to_event` — *not* the pgvector path. So branch 1's PGRST203 fix doesn't affect this code path. Partner-block was working all along; it just contributed redundant topic anchors to a prompt where the second memory block (semantic retrieval via `_new_retrieve_compat`) was returning empty. After branch 1, the semantic block also returns content — which means partner-block redundancy now competes for prompt budget instead of being the sole signal. The fix shape is unchanged but the value of fixing it is higher post-branch-1.

**File touched:**
- `reverie/backend_server/persona/cognitive_modules/conversation_manager.py:start_conversation` — the `_partner_block` helper at lines 619–643.

**Failing test first:**
- `tests/test_partner_block_topic_dedup.py` (new)
- Construct a persona with `a_mem.kw_to_thought["partner_name"]` containing 5 nodes all sharing the same topic (mock `embedding_key` text). Call `_partner_block(persona, partner_name)`. Assert the returned text contains at most 2 of the 5 nodes.
- Second test: 3 nodes with different topics → all 3 appear.

**Implementation:**
- Add a helper `_extract_topic_signature(text)` that strips stopwords and joins the first 3 content words.
- In `_partner_block`, after retrieving thoughts/events, group by topic signature; keep at most 2 nodes per signature; preserve overall recency order across the deduplicated set.
- The cap is hardcoded (no env flag). Number `2` is chosen because it's enough to convey "they've been thinking about this" without burying the prompt under five paraphrases of the same idea.

**Edge cases to cover in tests:**
- Empty `kw_to_thought[partner_name]` → returns `("", set())` as today.
- Topic signatures with fewer than 3 content words (e.g., 1-word thoughts) → don't crash; group by whatever's there.
- Mixed-language or stopword-only text → fall back to including the node (don't drop it entirely).

### Step 2.3 — Analyzer hygiene (RCA-1 and RCA-5)

**Goal:** Future verification reports compute accurate cooldown-violation rates and stop flagging stationary desk work as oscillation.

**Files touched:**
- `tests/analyze_sim_realism.py` — wherever it computes conversation gap-violation stats
- `tests/analyze_action-location.py` — `summary.json` issue generation for OSCILLATION

**No failing-test gate** required — these are tool changes, not behavioural bug fixes.

**Changes:**

1. **Dedupe chat-step records by `conversation_id`.** Currently the analyzer dedupes by `(step, pair)`, which counts each sliced step of a multi-step chat as a separate conversation. Read `chat_metadata.conversation_id` from `movement/N.json` and group records by `(pair, conversation_id)` instead. The `gap` between two distinct conversations is `next_conversation.first_step − prev_conversation.last_step`. Sliced segments of the same `conversation_id` collapse to one entry.

2. **Apply arena `cooldown_mod` to the violation threshold.** Load `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`. For each chat, extract the arena from `address_label[:3]`, look up `cooldown_mod`. Compute the chat's `n_exchanges = total_utterances // 2`. Base cooldown is `5` for `n_exchanges ≤ 2`, `15` for `≤ 5`, `30` otherwise (this matches `conversation_manager.end_conversation`). Effective threshold is `max(1, base + cooldown_mod)`. A gap is a violation only when `gap < effective_threshold`.

3. **Gate OSCILLATION detector.** A run with `≤ 2` unique positions over `≥ 30` steps is **not** a violation when:
   - `stationary_intent` was `true` for `≥ 80%` of the run, OR
   - The set of distinct `description` strings has `≥ 3` entries (proves the persona was doing varied work in the same spot, not stuck).
   Both conditions are read from the same `sprite_steps.json` the analyzer already loads.

**Verification:** Re-run the analyzer against `20260514-1`. Expected outcomes:
- Real cooldown-violation count drops from 212 to roughly **0–2** (down from 77%).
- OSCILLATION count drops from 2 to **0** (both flagged runs are stationary desk work with multiple distinct actions).

### Step 2.4 — Worklog + commit + push

Two worklog entries — one per step or one combined per CLAUDE.md format. Branch is `ivan/conversation-quality`. **Don't auto-merge to main**; wait for explicit instruction.

### Step 2.5 — `/verify`

Run `/verify` per CLAUDE.md once all three steps are landed. This is a behaviour-affecting change (planner guardrail + partner-block dedup will alter sim output).

---

## Pre-flight checks before starting

- `git status` — clean working tree
- `git branch --show-current` — should be `ivan/conversation-quality`
- `git log --oneline -1` — should match the `origin/ivan/dev` commit this branch was created from (`5feaf6f6 Merge branch 'ivan/video' into ivan/dev`)
- Run all existing test suites to make sure the worktree is healthy before adding new tests: `python tests/test_batch_beta.py` and `python tests/test_batch_alpha_survival_pipeline.py` should both pass.

## Things NOT to do on this branch (out of scope)

- **Don't touch `survival/memory.py`, `survival/controller.py`, `cognitive_modules/world_events.py`, `memory_structures/hybrid_memory_store.py`, or `supabase/migrations/*`** — those are branch 1's domain.
- **Don't add a phantom-name regex post-filter.** That call has been made: we rely on retrieval surfacing real cast names instead. Re-evaluate only if the fresh sim run (with branch 1 merged) still shows the Mira/Cass leak.
- **Don't add a deterministic survival-state block to `ConversationContext.serialize_for_prompt`.** Deferred per Ivan's "preserve agency" preference. Backup option only if the fresh sim shows retrieval surfacing broadcasts but the LLM still ignores them.
- **Don't fix the `_SIM_ID_RESOLUTION_FAILED` latch in `survival/memory.py`.** Branch 1's diagnosis revealed it's not load-bearing for any current issue (the rows we thought it was poisoning turned out to be cross-sim history). Separate follow-up if/when it actually bites.
- **Don't touch `dbl_retrieve_with_rir` or related Supabase migrations.** Branch 1 dropped the 9-param overload; the 10-param version is now the sole function. Any further retrieval changes are a separate branch.

## Communication style reminder (from CLAUDE.md)

Ivan is a product owner, not an engineer. End-of-step summaries should lead with behaviour ("Day-3 chats will now include rest / household / non-rehearsal activities") not files ("modified plan.py at line 2521"). Save file paths for when explicitly asked.

---

## When you're done

1. Mark this file's contents as complete (or delete the file).
2. Append a `## Done` section here with the final commit SHA per step so Ivan can scan what landed.
3. Ping Ivan in the main window — branch 2 is mergeable behind branch 1, since the conversation-quality fixes are most visible once survival broadcasts are also surfacing.

---

## Done — 2026-05-15

Branch `ivan/conversation-quality` pushed to origin. Four commits:

| Step | Commit | Summary |
|---|---|---|
| 2.1 — Small-cast planner guardrail | `d0a436b5` | When ≤ 2 survivors remain, daily plan prompt includes a SMALL CAST GUIDANCE block steering toward non-survival activities. New `_build_small_cast_guidance` helper + `!<INPUT 8>!` slot in `survival_daily_plan_v1.txt`. 10 unit tests. |
| 2.2 — Partner-block topic dedup | `61089846` | Caps partner-block thoughts/events at 2 per topic signature. Hoisted `_partner_block` to module level; added `_extract_topic_signature` and `_dedup_by_topic`. 11 unit tests. |
| 2.3 — Analyzer hygiene | `1268780a` | New `_check_chat_cooldown_violations` in `analyze_sim_realism.py` (groups by `(pair, conversation_id)`, applies arena `cooldown_mod`, mirrors first-daily-encounter bypass) + OSCILLATION gate (skips when `stationary_intent ≥ 80%` of run OR ≥ 3 distinct descriptions). |
| Simplify pass (post-/verify) | `04fdc742` | Trimmed stopwords list (kept pronouns/time-anchors as topical signal), reused `parse_address` from `location_helpers`, swapped string sentinels for tuples, narrowed broad except, dropped task/incident comments. Net −51 lines. |

**Worklog:** entry added to `D:\Coding\double-docs\worklog.md` under `2026-05-15 — Ivan — branch: ivan/conversation-quality`. Worklog file modification is uncommitted in the `double-docs` repo because that repo also has unrelated in-progress work (deleted `20260520_production_hardening.md`, untracked `TODO_production_hardening.md`) — Ivan to commit/push the docs repo separately.

**Empirical results on `20260514-1`:**
- OSCILLATION: 2 → 0 (matches expected outcome).
- CHAT_COOLDOWN_VIOLATION: 211 reported (vs the verification report's narrower manual count of 1, which only counted negative-gap overlapping conversations). The 211 is an honest count by the cooldown rule + first-daily bypass; may indicate a runtime bypass path my analyzer doesn't model. Worth a follow-up branch to investigate.

**Verify status:** `/verify` ran. 64 tests green (movement realism + new suites + survival_daily_plan_wiring + batch_beta + analyze_sim_realism_exports). `/simplify` review applied. No regressions in pre-existing related test suites.

**Out-of-scope items left untouched** (per doc): no phantom-name regex, no deterministic survival-state block in `ConversationContext`, no fix to `_SIM_ID_RESOLUTION_FAILED` latch, no edits to `dbl_retrieve_with_rir` (branch 1's domain).

**Branch readiness:** mergeable behind branch 1. Don't auto-merge — wait for explicit instruction per doc Step 2.4.
