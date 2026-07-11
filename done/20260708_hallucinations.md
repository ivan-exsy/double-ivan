# Handoff: Tier 2 flat-enum for LLM location hallucination

**Date:** 2026-07-08 · **Updated:** 2026-07-09 · **Owner:** TBD  
**MVP status:** **CLOSED for MVP** (2026-07-09 on `20260708-mvp-a`; re-confirmed **0.0%** on `20260709-1`). Tier 2 is **Path B / post-MVP** hardening only.  
**Archive:** Moved to `double-ivan/done/` on 2026-07-10 with MVP doc closure.

---

## MVP verdict (2026-07-09)

| Run | Steps | Hallucination rate | Target | Call |
|-----|------:|-------------------:|--------|------|
| `20260705-or-smoke` | 2,600 | **14.7%** | &lt; 5% | Failed — triggered Tier 2 plan |
| `20260707-chat-probe-v3` | 2,600 | **14.0%** | &lt; 5% | Failed |
| **`20260708-mvp-a`** | **2,600** | **0.6%** (4/675) | &lt; 5% | **PASS — MVP green** |

**What fixed it for MVP:** `max_tokens` 100→800 on unified location (token-budget / truncation), plus Path A measurement hygiene — not flat-enum. Flat-enum remains useful long-term (zero invented addresses by construction) but is **not** required to ship.

---

## Problem statement (historical — why Tier 2 was drafted)

The unified LLM location call (`run_gpt_prompt_action_location_unified`) picks locations that are **not in the valid location tree** it was offered — a "hallucination". Pre-fix measured rate:

| Run | Steps | Hallucination rate | Target |
|-----|------:|-------------------:|--------|
| `20260705-or-smoke` (sign-off) | 2,600 | **14.7%** | < 5% |
| `20260706-map-smoke` | 250 | 0% (6 calls — tiny sample) | < 5% |
| `20260707-chat-probe-v3` | 2,600 | **14.0%** | < 5% |

Two full runs at ~14% **after** the Tier 1 map/prompt fixes. That met the old trigger for Tier 2 — **superseded** by the token-budget confirmation on `20260708-mvp-a`.

**Impact note:** hallucinated picks are caught by validation and never ship a broken address — the cost is retries/fail-safes (latency, LLM spend) and fallback to less appropriate locations. It inflates Class A indirectly.

## Likely contributing cause: model switch

We migrated from OpenAI (`gpt-5-mini`/`nano`) to **DeepSeek via OpenRouter** (`deepseek/deepseek-v4-flash` for location calls). DeepSeek follows the "copy verbatim from this tree" instruction less reliably than the OpenAI models did — the failure is mostly **formatting/grounding drift** (paraphrased object names, invented-but-plausible objects like "library computer"), not random invention. Do not assume prompt wording alone can close the gap; the Tier 2 design below removes the opportunity to drift.

## What is already shipped (Tier 1 — do not redo)

All on `railway`, validated on `20260706-map-smoke`:

1. **Map data patch** — removed 3 phantom "common room bench" entries from `maze_registry.json` (registry now matches tiles/Supabase). A chunk of the original "hallucinations" were the *map's* fault.
2. **Prompt tightening** — `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt` now has verbatim-copy rules and named-object grounding rules.
3. **Parse-time normalization** — `_normalize_location_pick` in `run_gpt_prompt.py` canonicalizes case/whitespace/"the Ville |" prefix slips before validation (with regression tests in `tests/test_location_pick_normalization.py`).

Result: 0% on the 250-step smoke, but 14% persists at 2,600-step scale.

## Tier 2 design: flat-enum answer contract

**Core idea:** stop asking the model to compose a `sector | arena | object` triple from a nested tree. Instead, enumerate every valid full address as one line and require the answer to be **one line copied verbatim from the list**. Validation becomes exact string membership; there is no format to drift in.

A working prototype already exists and was A/B tested:

- **Prototype:** `generative_agents/tests/_tmp_classa/llm_prompt_experiment.py` — variant `C_flat_enum` (see `flat_enum_prompt()` for the exact prompt shape, incl. rules for named objects, home fallback, and private-room exclusion).
- The experiment harness replays the 21 historical Class A failure cases against OpenRouter with tile-backed persona location trees — reuse it for iteration before any sim run.

### Implementation sketch

1. In `location_resolver.generate_action_location` (or the prompt-template layer), build the flat list from the same privacy-filtered tree used today (`_build_filtered_location_tree`) — ordering: persona's current sector first, then home, then rest.
2. New prompt template `v1/action_location_flat_enum_v1.txt` modeled on the prototype.
3. Response handling: exact-match against the offered list (after `_normalize_location_pick`-style normalization); on miss, one retry, then existing fail-safe chain unchanged.
4. Feature-flag it (e.g. `LOCATION_FLAT_ENUM_ENABLED`, default false) so VPS rollback is an env change, per `env-flags-and-storage` conventions.

### Watch-outs

- **Prompt size:** the full Ville has hundreds of addresses; the filtered tree per persona is much smaller. Measure token cost before/after — if too large, enumerate only arenas+objects within the already-chosen sector (the unified call resolves sector first; check current call structure before deciding).
- **Don't touch the deterministic guards** (anchor repoint, orphan redirect, post-validate) — they are a separate open track (`TODO_action-location.md`, inherit-anchor work).
- Keep the dual-import `try/except` pattern in any backend module you touch.

## Acceptance gates

1. **Unit:** replay harness on the 21 historical cases — 0 hallucinated picks, no regression in correct-object rate vs the tightened baseline (prototype already showed 0 hallucinations for variant C locally).
2. **Smoke:** 250-step VPS fork — hallucination 0–1 call, Class A ≤ 5. (Remember: smoke is a regression detector only.)
3. **Sign-off:** 2,600-step fork with `traceability.contract.action_id` monitoring enabled — **hallucination < 5%** and contributes to Class A ≤ 5.
4. Scorers: `tests/analyze_action-location.py` (hallucination + Class A) — verify monitoring flags on fork *before* launching (the chat-probe-v3 run silently produced no contracts and couldn't be scored).

## Verification & process

- Behaviour-affecting change → run `.cursor/skills/verify/SKILL.md` before handoff; prompt edits → `prompt-verify` skill.
- Worklog entry per `worklog-own-update` rule after code changes.
- Cost guard: check OpenRouter balance before long runs (ran dry on 2026-07-07 mid-testing).

## Reference material

- MVP tracker: `double-docs/20260705_close-for-mvp.md` (item 4 of "Open work — location")
- SOT: `double-docs/sot/sot_action-location.md` (v1.8 documents the Tier 1 fixes)
- Historical failure taxonomy: computer/piano/sofa/kitchen-sink themes, 21 cases — see tracker §"Class A arc"
- Prior experiment results: tightened prompt + normalization → hallucinations 0 on local replay; flat-enum variant was equal-or-better on grounding
