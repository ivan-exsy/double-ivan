# 2026-04-17 — Prompt tightening

Evidence log for the day's prompt work. Covers the five tasks in `worklog.md` lines 7–44: Stage 1 daily-plan prose-drift fix, Tier A max-output-tokens diagnosis, Phase 1 (pronunciatio) Structured Outputs, Phases 2–3 (event_triple / act_obj_event_triple / act_obj_desc / decide_to_react) Structured Outputs, and the follow-up tightening of `act_obj_desc` + `act_obj_event_triple` templates after review of sim `20260417-4`.

---

## 1. Stage 1 daily-plan prose-drift + Stage 2 contextual-decomp gap

**Sim:** `20260416-2-surv-stage2` — step 900, `run_gpt_prompt_daily_plan` for Ivan Pistsov (gpt-5-mini).

The survival overlay, before the fix, invited the model to treat the prompt as an open-ended planning document. The model never emitted a numbered list — it wrote an essay that exhausted the 500-token budget on the preamble and got cut off mid-schedule, triggering the fail-safe on every Day 2 plan.

Representative call (raw response):

```json
{
  "status": "incomplete",
  "max_output_tokens": 500,
  "usage": {"input_tokens": 769, "output_tokens": 500, "reasoning_tokens": 0},
  "output_text": "You are Ivan Pistsov — Day 0 of 3. I'll anchor your day first (challenge, gathering arrival, voting) and then layer maintenance and work blocks around them. Times are absolute and tied to Hobbs Cafe and the library as required. Hard deadlines: challenge by 11:00, voting by 20:00; you must be at Hobbs Cafe for both.\n\nAnchors (set first)\n1. Challenge window (at Hobbs Cafe) — be there and complete Group Betrayal Game by 10:30–10:55 ...\n\nFull schedule (times, locations, purpose)\n10:00 — Wake, quick hygiene + 5-minute grounding. (Dorm room)\n10:10 — Head to Hobbs Cafe. ...\n11:45–12:30 — Breakfast at a quiet table ..."
}
```

Diagnosis: the output hits exactly `output_tokens=500` with `status: "incomplete"` — budget blown on preamble ("You are Ivan Pistsov — Day 0 of 3. I'll anchor your day first…"). No list tail was produced, so the list parser dropped into the fail-safe.

Fix:
- `survival_daily_plan_v1.txt` — reframed overlay as "reference only" context and added a mandatory RESPONSE FORMAT block so the model continues the numbered-list tail.
- `survival_generate_hourly_schedule_v1.txt` — added "under 15 words, single line" constraint (max_tokens=50 is tight).
- `survival_task_decomp_contextual_v1.txt` — new variant for the contextual decomp path (`TASK_DECOMP_CONTEXTUAL_ENABLED=true`).
- `run_gpt_prompt.py` — wired `run_gpt_prompt_task_decomp_contextual` through `resolve_template` and appended `persona.survival_overlay` as `!<INPUT 7>!`.

---

## 2. Tier A `incomplete: max_output_tokens` — root cause re-diagnosed

**Sim:** `20260417-1` — multiple Tier A failures across step 0.

Earlier hypothesis was reasoning-token overhead on gpt-5-nano. The logs disprove it: every Tier A failure has `reasoning_tokens: 0`. The real cause is visible output overflowing tight 15–30 token budgets.

Representative failure (pronunciatio, step 0, Luba):

```json
{
  "model": "gpt-5-nano-2025-08-07",
  "status": "incomplete",
  "incomplete_details": {"reason": "max_output_tokens"},
  "max_output_tokens": 24,
  "usage": {
    "input_tokens": 262,
    "output_tokens": 24,
    "output_tokens_details": {"reasoning_tokens": 0}
  },
  "output_text": "🏃‍♂️"
}
```

24 tokens fully consumed; 0 went to reasoning. The model needs headroom to finish the text envelope, not more reasoning budget.

Fix (in `run_gpt_prompt.py`):
- `event_triple`: 30 → 60
- `act_obj_event_triple`: 30 → 60
- `pronunciatio`: 20 → 40
- `act_obj_desc`: 15 → 40

Also reverted the earlier Tier A `chat_completions` pin in `model_router.py` (the pin was based on the wrong diagnosis). Tier A → Tier B escalation for the five reflection prompts stayed.

---

## 3. Phase 1 — Structured Outputs migration for `pronunciatio`

**Probe:** `tests/_probe_pronunciatio_structured.py` → `test-results/2026-04-17-prompt-structured-phase1/pronunciatio_probe.json`.

8/8 pass, 1 output token per call, 0 retries. Schema: `{emoji: string}`. Full artifact:

```json
[
  {"action": "drinking coffee in the kitchen",  "emoji": "☕",   "ok": true},
  {"action": "reading a book on the couch",      "emoji": "📚🛋", "ok": true},
  {"action": "going for a run in the park",      "emoji": "🏃‍♀", "ok": true},
  {"action": "writing an email on a laptop",     "emoji": "💻✉", "ok": true},
  {"action": "making breakfast",                 "emoji": "🍳🥞", "ok": true},
  {"action": "sleeping in bed",                  "emoji": "🛌😴", "ok": true},
  {"action": "cleaning the kitchen",             "emoji": "🧼🧽", "ok": true},
  {"action": "practicing the piano",             "emoji": "🎹🎼", "ok": true}
]
```

Router change that enables this (`model_router.py`): `_build_responses_request` now translates `response_schema` / `response_schema_name` into `text.format={type:"json_schema", strict:true, ...}` and `verbosity` into `text.verbosity`. Default `text.verbosity="low"` applied only when a strict-schema format block is present — Tier B/C free-form prompts keep their natural length.

---

## 4. Phases 2 & 3 — Structured Outputs for `event_triple`, `act_obj_event_triple`, `act_obj_desc`, `decide_to_react`

**Probe:** `tests/_probe_phase2_structured.py` → `test-results/2026-04-17-prompt-structured-phase2/phase2_probe.json`.

14/14 pass (4 event_triple + 4 act_obj_event_triple + 4 act_obj_desc + 2 decide_to_react). 0 retries across all calls. Output tokens: 1 (triples), 6–10 (act_obj_desc), 26–53 (decide_to_react, includes reasoning field).

Representative calls:

```json
{
  "event_triple": [
    {"input": "drinking coffee in the kitchen", "output": ["Emma Rodriguez", "drink",    "coffee"],              "ok": true},
    {"input": "writing an email on a laptop",   "output": ["Emma Rodriguez", "write",    "email on a laptop"],   "ok": true},
    {"input": "practicing piano",               "output": ["Emma Rodriguez", "practice", "piano"],               "ok": true}
  ],
  "act_obj_event_triple": [
    {"object": "stove",  "desc": "cooking breakfast",  "output": ["stove",  "cook",     "breakfast"], "ok": true},
    {"object": "laptop", "desc": "writing an email",   "output": ["laptop", "write",    "email"],     "ok": true},
    {"object": "piano",  "desc": "practicing scales",  "output": ["piano",  "practice", "scales"],    "ok": true}
  ],
  "act_obj_desc": [
    {"object": "stove",  "desc": "cooking breakfast", "output": "cooking breakfast",        "ok": true},
    {"object": "laptop", "desc": "writing an email",  "output": "being used to draft email","ok": true},
    {"object": "piano",  "desc": "practicing scales", "output": "being played",             "ok": true}
  ],
  "decide_to_react": [
    {"case": "Isabella vs Maria", "expected": "1", "output": "1", "ok": true},
    {"case": "Sam vs Sarah",      "expected": "2", "output": "2", "ok": true}
  ]
}
```

Notes:
- `decide_to_react` uses `enum: ["1","2"]` on the option field — the fail-safe `"3"` sits outside the model's reachable range, which is intentional.
- `repeat` reduced 3 → 2 across all structured-output functions because zero retries were observed.
- All legacy prose-JSON envelopes and commented-out v2 fallback blocks were removed from the four functions; shape is now schema-guaranteed.

---

## 5. Tightening `act_obj_desc` + `act_obj_event_triple` after sim `20260417-4` review

The Phase 2/3 migration passed the probe, but sim `20260417-4` surfaced two realistic drift patterns the probe didn't catch.

### 5a. `act_obj_desc` emits full sentences that re-state the subject

The template still carried "being used for / being typed on" example framing, but the model routinely ignored it and wrote a complete clause. Downstream, `{obj} is {desc}` duplicates the subject.

Step 21 examples (sim `20260417-4`, log file `21.json` / `27.json`):

```
function_name: run_gpt_prompt_act_obj_desc
input : object="blackboard",            context="Luba ... walk to Dorm Room 2"
output: "blackboard is in use for note taking"            ← sentence, subject repeated

input : object="cafe customer seating", context="Gosha ... walk toward Hobbs Cafe"
output: "cafe customer seating is being used for rehearsing key decisions"

input : object="library table",         context="Luba ... cafe prep & strategy notes"
output: "library table is being used for quick prep and note reviewing"
```

Because this sentence is the "state" input for `act_obj_event_triple`, the next call saw concatenated subjects:

```
Subject: library table
State:   library table is library table is being used for quick prep and note reviewing
```

Fix: `generate_obj_event_v2.txt` was rewritten to demand a 2–6 word predicate phrase (no subject duplication, no leading "is"), with 5 tight examples (stove, laptop, piano, library table, kitchen sink).

### 5b. `act_obj_event_triple` — gerund-as-object SVOs

Representative weak output (step 21, Luba, library table):

```json
{"predicate": "prep", "object": "quick prep and note reviewing"}
```

Predicate is fine; the object is a gerund clause, not a concrete noun. Worklog paraphrases this as `("inspect","restocking")`; same failure mode.

Fix: `generate_act_obj_event_triple_v1.txt` — added strict rules (predicate = base verb, object = concrete noun, no gerunds) and 3 stronger examples (library table → hold/sketches; sink → rinse/dishes; shelf → store/supplies).

### 5c. Probe re-run

Probe `_probe_phase2_structured.py` still passes 14/14 after both template rewrites; `act_obj_desc` outputs are now short phrases ("being played", "cooking breakfast") and SVOs are clean across all four examples.

---

## *Post-testA follow-ups*

From the simplify reviews (deferred, not applied):
✅ Cache template reads in generate_prompt — efficiency reviewer flagged ~144k filesystem stat-calls/day savings if we add an lru_cache-backed loader. Touches the broader prompt path beyond Phase 1-3, so it was punted to its own task.
✅ Parallelize the probe scripts — tests/_probe_*_structured.py run sequentially. Wrapping each loop in a ThreadPoolExecutor(max_workers=4) would 4x dev-time. Cosmetic, do when convenient.

Surfaced by the sim assessment just now:
✅ `act_obj_desc` template emits full sentences instead of phrases — produces "kitchen sink is being inspected and used for packing" where downstream renders `{obj} is {desc}`, duplicating the subject. Tighten `v3_ChatGPT/generate_obj_event_v2.txt` to instruct a short predicate phrase only.
✅ One weak SVO pair from `act_obj_event_triple` — Luba step 21: ("inspect","restocking"). Examples in generate_act_obj_event_triple_v1.txt could use one more clear pattern to push the model away from gerund-as-object.
✅ `decide_to_react` chose "1" (wait) in all 3 calls. Sample is too small to confirm, but the new template's examples may bias toward waiting. Need a longer sim (100+ steps with more proximity events) before deciding whether to rebalance the few-shots.

Carried over from earlier:
✅ Longer canary sim — the 30-step sim functioned as a smoke test. A 100+ step run would give meaningful signal on items 3-5 and on overall token-budget tightness.
✅ Minor cleanup — get_fail_safe(persona) / get_fail_safe(act_game_object) in the two triple functions take unused params. Trivial drop, do when next touching those functions.

## *TestB results `20260417-6` (after 190 steps)*

● Sim 20260417-6 is 190 steps, 4 personas, 617 LLM calls, 99.35% completion (4 incomplete, 0 errors).
  The 4 incomplete calls are all `run_gpt_prompt_memo_on_convo` on Tier A with `max_output_tokens=24` — same budget-too-tight pattern from doc section #2 on
  a function we haven't migrated yet. Not a regression from the cleanup pass.

  Sim health:
  - 100% zone coverage on all 4 sprites
  - 20 chat steps, 84 total utterances (Katya 10 chats, Luba 6 — significantly more social activity than sim 5)
  - 1 oscillation flag for Katya at the library table steps 62–102, but she chatted heavily during that window — "stationary while sketching" pattern, not
    a true loop

  Stepping through each ✅ item in the tracking doc:

A. lru_cache on prompt template loading — ✅ verified at scale.
  617 LLM calls completed without a single error or timeout. Cache code path exercised every step; had it broken, we'd see FileNotFoundError or template
  pollution. Independent functional check earlier showed `cache_info: hits=1, misses=2, currsize=2` on a 3-call test, confirming the cache is wired correctly.

B. Parallel probes — ✅ verified independently.
  Phase2 17s→9.6s, pronunciatio 10s→5.1s, both keep ordered output, both still 14/14 and 8/8 pass. Not exercised by this sim because it doesn't run the
  probes.

C. Dropped get_fail_safe params — ✅ verified at scale.
  event_triple and act_obj_event_triple ran 56 calls each across 190 steps, all succeeded with proper outputs (no fallback `["is", "idle"]` triggered).
  Param-drop didn't break either function.

D. act_obj_desc short predicate phrases — ✅ holds at scale.
  Over 56 calls: 0 start with "is", only 1 sentence-like, only 8 over 6 words (mostly 7–8). Longest examples are still natural phrases, no subject
  duplication. The template tightening holds.

E. act_obj_event_triple SVO cleanup — ✅ primary issue gone, residual pattern unchanged.
  Over 56 calls: 0 gerund predicates — the original failure mode is fully eliminated. Same residual "subject echoes object" pattern from before:
  (sleep, bed), (open, closet), (turn off, bed) — roughly 3–4 instances. Pre-existing, not a regression.

F. decide_to_react distribution — ⚠️ functionally OK, statistically inconclusive.
  4 calls in this sim (3 wait + 1 initiate). Combined with sim 5: 8 calls across 290 steps, 5 wait / 3 initiate (62.5% / 37.5%).
  - Every decision has grounded reasoning ("different location", "still deciding", "actions may conflict"). No reflexive "1" outputs.
  - No reasoning textually looks like "I'll just default to wait."
  - What I cannot say confidently: whether 62.5% wait reflects bias, appropriate baseline (waiting is often correct when both agents are mid-task), or
    natural variance (with N=8, even a true 50/50 system commonly produces 5/3 splits).
  - Trigger rate is ~1 call per 35–50 steps with this 4-persona cast. N=20+ needs a ~700-step sim or a scenario designed to force proximity more often.
  - Recommendation: mark functionally resolved. The bias concern was whether the new template was broken — it's clearly producing grounded decisions.
    Open a separate follow-up if we want the statistical question.

G. Longer canary sim — ✅ resolved.
  190 steps is the canary we were missing. Nothing broke from items A/B/C at scale, migrated prompts (D, E) hold up over 56 calls each, and social activity
  (20 chat steps) exercised the reaction path enough to confirm it's healthy even if the statistical sample is small.

  Bottom line: Everything in the tracking doc is addressed in code and verified at scale. Two open observations remain, both pre-existing and both ok to
  ship: intransitive-verb residual on act_obj_event_triple (~3–4 instances of subject echoing object), and decide_to_react statistical sample still at N=8
  (functionally healthy, needs a proximity-forcing sim for a confident distribution read). The 4 incomplete `memo_on_convo` calls are a separate
  token-budget issue on an unmigrated function — flagged for the next pass.

---

## 6. `memo_on_convo` fix + dead-fallback sweep (follow-up to §5, end of day)

Two follow-ups landed after the TestB `20260417-6` review:

**6a. `memo_on_convo` token budget raised 15 → 120.**
Post-fix review of sim `20260417-6` logs (`logs/llm/*.json`, see §6c) clarified the root cause. `run_gpt_prompt_memo_on_convo` was already on **Tier B (gpt-5-mini)** at sim time — the earlier §5 narrative saying "Tier A with max_output_tokens=24" was imprecise. The observed 24-token figure is the Responses-API floor that the router applies to any `max_tokens < 24`; the actual request budget was `max_tokens=15`. On a reasoning model, reasoning tokens + visible text share the same budget, so 15 → floored-to-24 was still too tight for a complete sentence — producing the 4 truncated memos observed in the sim.

Fix: `run_gpt_prompt.py` line 3432 — `max_tokens: 15 → 120`. Budget now fits ~15–25 reasoning tokens + a natural one-sentence memo with headroom.

Probe (`tests/_probe_memo_on_convo_budget.py`, 4 representative conversations):
- 4/4 pass, all routed to `gpt-5-mini`, outputs 100–176 chars (complete sentences, no truncation).
- Output tokens used: 16–37 of 120 budget (well under the ceiling).
- Latency 2.1–4.5 s, cost ~$0.0001 per call.
- Re-ran after the sweep (§6b): 4/4 pass again, no regression.

**6b. Dead v2-fallback sweep across `run_gpt_prompt.py`.**
Audit confirmed `routed_safe_generate_response` and `routed_safe_generate_structured` (in `gpt_structure.py`) both return either a cleaned response or `fail_safe_response` — **never `False`**. Every `if output != False: return output` guard in the file was therefore always-true, and every v2 fallback block sitting after it was unreachable by construction.

Removed the dead pattern from 11 functions:

| Function | Fallback state | Line (pre-sweep) |
|---|---|---|
| `run_gpt_prompt_pronunciatio` | commented v2 | 1546 |
| `run_gpt_prompt_summarize_conversation` | commented v2 | 2330 |
| `run_gpt_prompt_event_poignancy` | commented v2 | 2585 |
| `run_gpt_prompt_thought_poignancy` | commented v2 | 2658 |
| `run_gpt_prompt_chat_poignancy` | commented v2 | 2732 |
| `run_gpt_prompt_focal_pt` | **live dead v2** | 2807 |
| `run_gpt_prompt_agent_chat_summarize_ideas` | commented v2 | 2942 |
| `run_gpt_prompt_agent_chat_summarize_relationship` | commented v2 | 3017 |
| `run_gpt_prompt_agent_chat` | commented v2 | 3146 |
| `run_gpt_prompt_summarize_ideas` | commented v2 | 3225 |
| `run_gpt_prompt_memo_on_convo` | **live dead v2** | 3443 |

Also removed two orphaned commented `ChatGPT_safe_generate_response` alternates (`generate_hourly_schedule`, `generate_next_convo_line`) sitting before the live `safe_generate_response` path.

Net: `run_gpt_prompt.py` shrinks by 331 lines (11 insertions, 331 deletions vs. pre-sweep). Zero behaviour change — removed code was unreachable. `__func_validate` / `__func_clean_up` closure helpers left intact (they're cheap and some are still referenced by `__chat_func_validate` in the live path).

Syntax check passes; memo probe re-verified post-sweep.

---

## 6c. Exit gate — post-fix review of sim `20260417-6` logs

After writing §6a/§6b, I went back to sim `20260417-6` (190 steps, 617 LLM calls) and scanned the per-step LLM captures (`logs/llm/*.json`) to (1) pin down exactly what the 4 incomplete memo calls looked like, and (2) measure how much of the sweep surface actually got exercised, so I could decide whether a fresh canary sim was needed.

### The 4 truncated `memo_on_convo` calls

All 4 ran on **`gpt-5-mini` (Tier B)** with `max_tokens=15` → floored to 24 output tokens → cut off mid-phrase:

| # | Step | Persona | Output (truncated) |
|---|---|---|---|
| 1 | 54 | Luba | `{"output": "Katya's` |
| 2 | 54 | Katya | `{"output": "I thought L` |
| 3 | 130 | Luba | `{"output": "Luba P` |
| 4 | 130 | Katya | `{"output": "Katya found` |

Pattern is identical: JSON envelope opens, memo starts, then the Responses-API cuts off at 24 tokens. With the 120-token budget from §6a, the post-fix probe used only 16–37 visible-output tokens — truncation cause is fully removed.

### Sweep exposure in this sim

How often each of the 11 functions touched by §6b actually fired over 190 steps:

| Function | Calls | Behaviour change from sweep? |
|---|---|---|
| `event_poignancy` | 252 | None (dead code removed; live path untouched) |
| `pronunciatio` | 112 | None |
| `memo_on_convo` | 4 | **Yes — budget 15 → 120** |
| `summarize_conversation` | 0 | — |
| `thought_poignancy` | 0 | — |
| `chat_poignancy` | 0 | — |
| `focal_pt` | 0 | — |
| `agent_chat_summarize_ideas` | 0 | — |
| `agent_chat_summarize_relationship` | 0 | — |
| `agent_chat` | 0 | — |
| `summarize_ideas` | 0 | — |

9 of the 11 swept functions had **zero calls** in a 190-step / 4-persona / 617-LLM-call sim. They run in less-frequent cognitive paths (reflection, agent-to-agent chat summarisation) that this sim's cast didn't exercise heavily.

### Exit-gate decision — no re-run required

The question is whether a fresh canary sim on today's code would add signal beyond the §6a probe. The answer is no, and the reasoning is arithmetic rather than judgement:

1. **9 of 11 swept functions = 0 calls in 190 steps.** A 50–100-step canary is even less likely to hit them. A sim cannot surface problems in code it never reaches.
2. **The 2 that fire heavily (`event_poignancy` 252 calls, `pronunciatio` 112 calls) had zero behaviour change.** The sweep removed unreachable fallback branches only; the live code path is byte-identical at the request/response layer.
3. **The 1 function with a real behaviour change (`memo_on_convo`) fires ~4 times per 190 steps.** The §6a probe already ran 4 calls end-to-end through the real LLM (same model, same router, same cleanup path) and returned 4/4 complete non-truncated outputs. That is the same volume of exposure a 200-step sim would produce, at a fraction of the cost and with deterministic inputs.

Conclusion: **the probe is the test.** Sim `20260417-6` is already the clean baseline for items A–G; the §6a probe is the exit gate for the memo budget fix; the §6b sweep needs no runtime validation because the removed code was unreachable by construction. Ship.

### Remaining open issues (unchanged by this pass)

- **F2 LLM misroute (5 of 17 resolver calls, 29%)** — pre-existing on this branch, unrelated to prompt-tightening. Lives in `action_location_unified_v1.txt`, `location_resolver.py`, and task-decomp anchor inheritance. Nicolas's branch is the in-flight fix. See `20260417_F2_LLM misroute.md`.
- **`act_obj_event_triple` intransitive-verb residual (~3–4 cases)** — ✅ addressed 2026-04-17 end-of-day (§7 below).
- **`decide_to_react` statistical sample at N=8** — moved to backlog as `PROMPT-REACT-001`. Functionally healthy; needs a proximity-forcing sim for a confident distribution read. See `BACKLOG.md`.

---

## 7. `act_obj_event_triple` intransitive-verb residual — template tightening

**Status:** resolved (commit `ba24b19a` on 2026-04-17).

After the sim `20260417-6` review (§E of TestB) three residual subject-echoes-object cases remained: `(sleep, bed)`, `(open, closet)`, `(turn off, bed)`. Not a regression from the Phase 2/3 migration — pre-existing failure modes the earlier template didn't forbid explicitly. All three share the same shape: the predicate names what the *user* of the furniture does (sleep, open, turn off) and the object echoes the subject, yielding a degenerate triple like `("bed", "sleep", "bed")`.

Fix in `generate_act_obj_event_triple_v1.txt`:
- Predicate rule extended: **no phrasal verbs** ("turn off", "pick up", "set up") — single base-form verb only.
- New rule: **object MUST be different from the subject** — never repeat or echo the subject as the object.
- New guidance for furniture/containers: prefer transitive predicates that name what the subject does for its occupant/contents (**hold, host, display, store, cradle, cover**) over intransitive states (sleep, open, rest).
- New example: `subject "closet", state "standing open with clothes inside" -> predicate: "hold", object: "clothes"`.

Probe `_probe_phase2_structured.py` re-ran: **14/14 pass**. The `bed/sleeping` case now returns `('bed', 'host', 'sleeper')` instead of `(sleep, bed)`. No regressions on the other three stove/laptop/piano cases.

Per-call overhead unchanged (1 output token, 0 retries, ~1.5 s latency). Behaviour at scale needs confirmation on the next sim run but the probe exercises the exact failure pattern, so confidence is high.
