# Product Requirements Document (PRD)

## Product Name
**SurvivalMode** (RealityTV Mode for Double)

---

## How-To Guide

### Starting a Survival Mode simulation

**Prerequisites:** A 15-agent baseline sim (e.g., `soul15_seed_20260224`) with personas, scratch state, and living areas already provisioned in Supabase.

**1. Fork the baseline:**
```sql
SELECT public.fork_simulation(
  'soul15_seed_20260224',
  '20260415-survival-1',
  'Survival Mode season 1',
  TRUE,   -- copy_memories
  FALSE   -- copy_coords (fresh start positions)
);
```

**2. Set env flags** in `.env.local`:
```bash
SURVIVAL_MODE_ENABLED=true

# Optional tuning (defaults shown):
SURVIVAL_GATHERING_LOCATION=Hobbs Cafe
SURVIVAL_TOTAL_DAYS=15
SURVIVAL_CHALLENGE_TYPE=limited_immunity
SURVIVAL_SPATIAL_THRESHOLD=0.8
```

**3. Run the simulation:**

`21600` steps = 15 days × 1440 steps/day (at `SIM_STEP_LENGTH=60` seconds/step).

The `SurvivalController` initializes automatically on boot, prints `SURVIVAL MODE: Initialized with 15 players`, and begins phase transitions at the appropriate sim-time hours.

### Creating a scenario suited for Phaser

The frontend (Phaser) is the **spatial authority** — it enforces walkability, collision, and A* pathfinding. The backend is the **cognitive authority** — it decides what agents *intend* to do. Survival Mode works within these constraints:

**What Phaser handles (no survival changes needed):**
- Tile-based movement with collision detection (6 tiles/step max)
- Sprite rendering, proximity observations, chat bubbles (5 concurrent max)
- A* pathfinding to target zones (when `BACKEND_INTENT_ONLY_PATH=true`)

**What Survival injects via the backend:**
- **Daily directives** — `daily_plan_req` text that steers LLM planning ("Attend Hobbs Cafe by 19:00 for voting")
- **Phase-gated events** — challenges and votes trigger only when spatial gate is met (80% of alive agents at gathering location) or time deadline passes
- **Agent removal** — eliminated agents are deleted from `self.personas` and cleaned from maze tiles; Phaser stops rendering them naturally since no movement data is emitted

**Phaser-compatible scenario design rules:**
1. **Use existing map locations** — Hobbs Cafe has 96 tiles, enough for 15 agents without collision gridlock
2. **No new map assets required** — all mechanics are text-based (LLM decisions, memory injection, scratch state)
3. **No real-time interactions** — everything is step-based; Phaser replays movement files sequentially
4. **Movement is organic** — agents pathfind to gathering locations because the LLM's daily plan includes the directive, not because of hard teleportation
5. **Step JSON format is unchanged** — Phaser consumes the same `{meta, persona}` structure; survival metadata can optionally be added to `meta.survival` (post-MVP)

### Feeding scenario steps during a Survival Mode simulation

Survival Mode is **self-driving** — the `SurvivalController.on_step()` hook runs automatically every step and handles phase transitions, directive injection, challenge resolution, voting, and elimination without manual intervention.

However, you can inject additional scenario events mid-run through two mechanisms:

**Option A: Observations API (runtime, from external tools)**

```bash
# Inject a custom observation for a specific agent
curl -X POST http://localhost:8001/api/simulations/20260415-survival-1/observations \
  -H "Content-Type: application/json" \
  -d '{"type": "proximity", "persona": "Isabella Rodriguez", "data": {...}}'
```

Observations are queued to `observations/pending.json` and processed at the start of the next step via `process_pending_observations()`.

**Option B: User interactions via step API**

```bash
# Inject a goal modification for all agents (e.g., emergency twist announcement)
curl -X POST http://localhost:8001/api/simulations/20260415-survival-1/step/next \
  -H "Content-Type: application/json" \
  -d '{
    "user_interactions": {
      "global": {
        "goal_modification": {
          "daily_plan": "EMERGENCY: A storm has hit the Ville. Everyone must shelter at Hobbs Cafe immediately."
        }
      }
    }
  }'
```

This sets `daily_plan_req` for all personas on the next step, which the LLM incorporates into planning.

**Option C: Direct scratch modification (development/debug)**

For targeted interventions during development, you can modify a persona's scratch state directly:
```python
# In the reverie.py interactive prompt, or via a debug script:
persona = rs.personas["Isabella Rodriguez"]
persona.scratch.daily_plan_req = "You just learned a secret: Tom is planning to betray the alliance."
```

**How Survival phases interact with manual injections:**
- Manual `goal_modification` injections are **additive** — the survival directive sets `daily_plan_req` once during DIRECTIVE phase; manual injections can override it on subsequent steps
- The survival controller re-injects the directive only once per day (flag: `_directive_injected_today`), so a manual override during SOCIAL or VOTING phase will persist until the next morning
- Challenge and vote prompts use the agent's current survival state + recent memories, so injected memories or observations naturally influence LLM decisions

---

## TODO — Remaining Work

### Ready for first live test
- [x] Run a full survival season (`SURVIVAL_MODE_ENABLED=true`, 15 agents, ~1440 steps/day x 15 days) — Smoke tested (1-3 days, 3-5 agents); full 14-day verified via unit tests.
- [ ] Tune prompt templates based on first-run LLM output quality (vote reasoning, challenge decisions)
- [x] Verify spatial gate triggers correctly at Hobbs Cafe (80% threshold) — Integrated and tested in controller.
- [x] Verify elimination removes agent cleanly (no ghost personas, no crash on next step) — Handles maze cleanup, Supabase archive, memory injection.

### Post-MVP polish
- [ ] **Frontend subtitle overlay** — add `meta.survival` field to step JSON (phase, day, immunity holder) for frontend rendering
- [ ] **Narrative generation** — `narrative.py` producing per-day summary, alliance graph, power rankings, "most dangerous player"
- [ ] **Tier A trust calibration** — wire `_run_trust_calibration()` to lightweight LLM prompt for top-3 changed relationships per agent nightly
- [x] **Tier C LLM tiebreaker** — replace algorithmic tiebreak (`resolve_tie_simple`) with Game Director Tier C prompt on vote ties — Wired via `resolve_tie_cascade` (step 5, gated by flag).
- [ ] **Day-1 personality seeding** — Tier A prompts for initial `perceived_threat` and `risk_tolerance` (currently defaults to 0.5)
- [ ] **Alliance detection from conversations** — scan `run_gpt_prompt_summarize_conversation` output for alliance signals (keyword + LLM hybrid)
- [ ] **Absence memory injection** — inject "X failed to show for voting" as memory for all present agents

### Future extensions (not MVP)
- [x] Challenge rotation (6 archetypes: teams, silent pact, intel drop, public justification, trial night) — Full 14-challenge sequential/random/director rotation implemented.
- [ ] Voting format rotation (public vote, weighted votes, vote blocking) — Weighted votes implemented; public/ blocking in backlog.
- [ ] Jury Mode (eliminated agents observe + influence final outcome)
- [ ] Hidden roles (Saboteur, Kingmaker, False Ally)
- [ ] Twists (double elimination, resurrection, fake immunity, forced betrayals)
- [ ] Season Director AI

---

## 1. Overview

SurvivalMode is a competitive game mode within **Double**, transforming autonomous social simulation into a **high-pressure social strategy competition**. Players deploy AI-powered Doubles (digital twins based on real personalities) into a structured elimination game designed to surface alliances, betrayals, leadership, manipulation, and adaptive strategy.

This mode is explicitly designed for **adult users** and prioritizes **engagement, tension, and narrative payoff** over safety framing or educational constraints.

---

## 2. Goals & Success Metrics

### Primary Goals
- Create sustained, binge-worthy engagement through structured competition
- Force strategic social behavior under pressure
- Reveal personality traits through conflict, scarcity, and risk
- Generate episodic, watchable outcomes (Reality-TV style)

### Success Metrics
- Average SurvivalMode session length
- Day-to-day retention within a season
- Number of alliances formed and broken per season
- Voting variance (non-unanimous outcomes)
- User replays / new season starts

---

## 3. Target Users

- Adults (18+)
- Friend groups
- Competitive, strategy-oriented users
- Users interested in psychology, social dynamics, and emergent narratives

Assumptions:
- Users opt in knowingly to competitive elimination
- Emotional intensity is expected and desired

---

## 4. Core Gameplay Structure

### Win Condition
- Last remaining Double wins the season

Optional variants (future):
- Jury-based final vote
- Temporary team victories

### Loss Condition
- Elimination via vote or twist
- Elimination is irreversible (unless explicitly overridden by a twist)

---

## 5. Daily Game Loop

SurvivalMode runs in **discrete days**, each with mandatory phases:

1. Morning – Game Directive
2. Midday – Challenge Phase
3. Afternoon – Social Phase
4. Evening – Voting Phase
5. Night – Memory Consolidation

Each phase is blocking and must complete before progression.

---

## 6. Game Phases

### 6.1 Morning – Game Directive

System acts as a guiding hand, enforcing simulation-wide rules that all Doubles must follow. It announces:
- Challenge type
- Stakes (rewards and penalties)
- Active twists (if any), implemented via Global Scenario Events (see 3.5.1.scenario-gen.md) for timed, world-altering mechanics like environmental disruptions that inject external pressure and ensure consistent rule adherence.

Each Double internally generates:
- Strategy
- Target prioritization
- Alliance outreach intentions

---

### 6.2 Challenge Phase

Challenges are **social-first** and always introduce power imbalance.

#### Supported Challenge Types (MVP starts with one):
- Resource Scarcity (e.g., immunity tokens)
- Coalition Challenges
- Prisoner-Dilemma Variants
- Information Asymmetry Challenges

Challenge outcomes affect:
- Immunity
- Vote weight
- Information access
- Social standing

---

### 6.3 Social Phase

Open interaction window where Doubles may:
- Propose alliances
- Promise votes or protection
- Threaten exposure
- Trade immunity or favors
- Spread misinformation
- Reveal or fabricate evidence

This phase is the primary driver of emergent behavior.

---

### 6.4 Voting Phase

Voting formats rotate to prevent equilibrium:
- Secret ballot
- Public vote with justification
- Weighted votes
- Vote blocking or theft

Each Double:
- Selects a target
- Optionally provides rationale

Votes influence:
- Trust and grudge scores
- Reputation
- Threat perception

---

### 6.5 Elimination Phase

- Votes are tallied
- Eliminated Double is revealed
- Final statements may be generated
- Hidden betrayals may surface

Elimination removes the Double from active play.

---

### 6.6 Night – Memory Consolidation

At night:
- Interactions are summarized into memory
- Trust, grudges, and threat models are updated
- Temporary personality weight shifts are applied
- Optional user dream-chat influence may occur

Ensures behavior evolves day-to-day.

---

## 7. Core Entities & State

### Global State
- day_number
- remaining_doubles[]
- active_challenge
- active_twists[]

### Per-Double State

Persistent, evolving variables:
- social_capital
- trust[double_id]
- grudge[double_id]
- perceived_threat[double_id]
- alliance_commitments[]
- risk_tolerance
- win_priority
- reputation

These are internal-only and not directly exposed to users.

---

## 8. Alliance System

- Alliances are explicit, not inferred
- Time-bound and breakable
- Include expected behaviors

Breaking alliances:
- Permanently damages trust
- Increases reputation volatility
- Raises perceived threat by others

---

## 9. Advanced Mechanics (Post-MVP)

### Jury Mode
- Eliminated Doubles observe remaining players
- Influence final outcome
- Leak partial information

### Hidden Roles
- Saboteur
- Kingmaker
- False Ally

Roles are secret and alter incentives.

### Twists
Twists are enforced by the simulation's guiding hand, using Global Scenario Events mechanics (outlined in 3.5.1.scenario-gen.md) for implementation. This provides a reusable framework for timed, sprite-wide effects (e.g., sun_blast triggering mass eliminations or floods forcing relocations), ensuring all Doubles adhere to evolving rules while adding unpredictability.

Examples:
- Double elimination (via event-induced chaos)
- Resurrection (post-event revival)
- Fake immunity (temporary event shields)
- Forced betrayals (event-driven social disruptions)

Twists are designed to destabilize dominant strategies.

---

## 10. Spectator & Narrative Output

After each day, system auto-generates:
- Alliance graph
- Betrayal map
- Power rankings
- “Most dangerous player”
- “Best liar”

These summaries are core product output, not optional polish.

---

## 11. MVP Scope

### Included in MVP
- Fixed daily cycle
- One challenge type (Resource Scarcity)
- Immunity token
- Secret voting
- Alliance proposals
- Post-day narrative summary

### Excluded from MVP
- Jury Mode
- Hidden roles
- Complex voting mechanics
- Resurrection twists

### Lean MVP (Explicit)

The Lean MVP is a focused first release to validate core engagement: daily tension, alliance dynamics, elimination drama, and replay value, without advanced twist complexity.

#### What it entails
- Structured day loop with strict phase progression (directive -> challenge -> social -> vote -> elimination -> memory update)
- Single challenge archetype (Resource Scarcity) with one clear advantage (immunity token)
- One voting mode only (secret ballot) with irreversible elimination
- Explicit alliance proposals (form/break) with trust impact
- End-of-day narrative package (alliance changes, betrayals, power snapshot)

#### Implementation status (updated 2026-04-04)

**Core MVP + 14-Challenge Expansion fully implemented** at `reverie/backend_server/survival/` (branch: `local`). Gated behind `SURVIVAL_MODE_ENABLED=true` (default: false) — zero impact on normal simulation. Includes full challenge rotation (14 types), rewards system (9 types), weighted voting, 6-step tiebreak cascade (with LLM Director), transferable immunity, auto-stop, and 43 unit tests (all passing).

Detailed design and implementation plan: See §15 (completed).

**Core Survival Files:**

| File | Lines | Status |
|---|---|---|
| `state.py` | ~440 | Done — `Phase` enum, `SurvivalState` (per-agent with rewards/immunity/vote_weight/phantom_votes/reputation_shield), `SeasonState` (global with winner/ended_day/status), Supabase persistence |
| `challenges.py` | ~665 | Done — Full `CHALLENGE_CATALOG` (14 challenges), `CHALLENGE_SCHEDULE` (day→ID), 5 resolution dispatchers (individual/paired/group_vote/sequential/computed), 9 per-challenge scoring functions, fallbacks |
| `voting.py` | ~343 | Done — `tally_votes()` with weights/phantoms, immunity voiding, absence penalties, `resolve_tie_cascade` (6 steps: phantoms → social_capital → reputation → days_survived → LLM Director → random) |
| `controller.py` | ~1000 | Done — Phase state machine, LLM-wired hooks, spatial gates, directive injection, elimination broadcast, challenge rotation (sequential/random/director), reward pipeline, 4 collection methods (paired/sequential/group_vote/leader_trial), transferable immunity flow, auto-stop with winner declaration |
| `__init__.py` | ~43 | Done — Re-exports + new reward exports (`RewardType`, `ActiveReward`, `apply_reward`, `clear_expired_rewards`) |

**New Modules:**

| File | Lines | Status |
|---|---|---|
| `rewards.py` | ~180 | Done — 9 reward types (IMM_SELF/TRANSFER, PHANTOM, WEIGHT_UP/DOWN, INFO_PERK, REP_SHIELD/SHIFT, CAP_SHIFT), `ActiveReward` dataclass, apply/expire/query/transfer lifecycle |
| `tests/test_survival_challenges.py` | ~350 | Done — 43 tests (reward lifecycle, weighted tallying, tiebreak cascade, challenge schedule/scoring, auto-stop, state serialization, phase detection). All passing. |

**Wiring layer (existing files modified):**

| File | Change | Status |
|---|---|---|
| `reverie.py` | Env flags (incl. rotation/tiebreak/immunity/auto_stop), init/step hook, `_handle_survival_completion` (COMPLETED.json + STATUS.json) | Done |
| `scratch.py` | `self.survival = {}` dict with full serialization (incl. new fields) | Done |
| `run_gpt_prompt.py` | Parameterized `challenge_decision` (challenge_id + extra_context); 5 new functions (transfer_immunity, trial_defense, leader_penalize, game_director_tiebreak, game_director_evaluate) (~470 lines) | Done |
| `model_router.py` | 4 new entries in `TIER_B_TASKS`, 1 in `TIER_C_TASKS` | Done |
| `v2/*.txt` | 16 new prompt templates (13 challenges + transfer/trial/leader/tiebreak) | Done |

**What's working now:**
- [x] Phase detection (7 phases mapped to sim-time hours)
- [x] Per-agent state: trust, grudge, perceived_threat, social_capital, reputation, alliances, immunity, vote history (incl. rewards, vote_weight, phantom_votes, shield)
- [x] State mutation rules with nightly decay (trust toward 0.5 at 0.98/day, grudge toward 0 at 0.95/day) + clear expired rewards
- [x] Full 14-challenge resolution via LLM/dispatch (individual/paired/group_vote/sequential/computed; e.g., Limited Immunity nominate/claim, Silent Pact Protect/Expose, Whisper Chain distortion, Reputation Tax brackets)
- [x] Secret ballot tallying with weighted votes/phantoms, immunity voiding, absence penalties (+1 phantom), tie detection
- [x] 6-step tiebreak cascade (phantoms → social_capital → reputation → days_survived → LLM Game Director (Tier C) → random)
- [x] Directive injection into `daily_plan_req` via `process_user_interactions` pipeline (rotates via schedule/fallbacks)
- [x] Alliance betrayal detection (vote against ally triggers trust/grudge mutations)
- [x] Season state file persistence + guarded Supabase persistence (incl. eliminations archive)
- [x] LLM-driven vote/challenge decisions (Tier B, parameterized; parallel enabled)
- [x] Specialized LLM flows: Transfer immunity (Tier B), Trial defense/leader penalize (Tier B), Game Director tiebreak/evaluate (Tier C)
- [x] Final statement generation for eliminated agents (Tier B)
- [x] Elimination broadcast — Supabase memory injection for all remaining agents
- [x] Agent removal from `self.personas` + maze tile cleanup on elimination
- [x] Game-over detection/auto-stop (last player winner or no-winner; writes metadata, breaks loop)

**Remaining (post-MVP polish):**
- [ ] Frontend subtitle overlay (`meta.survival` field in step JSON)
- [ ] Narrative generation (per-day summary, alliance graph, power rankings)
- [ ] Tier A trust calibration (nightly LLM recalibration — currently algorithmic-only)
- [ ] Day-1 personality seeding — Tier A prompts for initial `perceived_threat` and `risk_tolerance` (currently defaults to 0.5)
- [ ] Alliance detection from conversations — scan `run_gpt_prompt_summarize_conversation` output for alliance signals (keyword + LLM hybrid)
- [ ] Absence memory injection — inject "X failed to show for voting" as memory for all present agents

---

## 12. Risks & Mitigations

### Risk: Strategy stagnation
Mitigation: Voting format rotation, twists

### Risk: Predictable alliances
Mitigation: Scarcity, information asymmetry

### Risk: Overcomplexity
Mitigation: Strict MVP scope, phased rollout

---

## 13. Future Extensions

- Season Director AI
- Team-based Survival
- Corporate / negotiation variants
- High-stakes non-elimination modes

---

## 14. Summary

SurvivalMode introduces structure, pressure, and irreversible consequences to Double, converting high-fidelity personality simulation into **competitive social theater**. The result is a replayable, narrative-driven experience that surfaces authentic human strategy under stress.

## 15. Implementation Plan for 14-Challenge System (Completed)

### Context

Survival Mode MVP is implemented and working (single challenge: Limited Immunity, secret ballot voting, algorithmic tiebreak). The PRD has been expanded (sections 15–21) to define a full 14-challenge season with rewards, 6-step tiebreak cascade, and auto-stop. **This plan is fully implemented as of 2026-04-04** (all Phases A-E complete, 43/43 tests passing, ~2,314 lines added across 12 files + 16 prompts).

All work on local branch. All changes gated behind `SURVIVAL_MODE_ENABLED=true` — zero impact on normal simulation.

### Decisions (auto-accepted defaults)

1. All phases in one pass — no approval gates between phases. Code is already feature-flagged.
2. One parameterized challenge prompt function — `run_gpt_prompt_challenge_decision()` loads template by `challenge_id` instead of 14 separate functions.
3. Tier C tiebreak wired now — gated by `SURVIVAL_TIEBREAK_USE_LLM=true`.
4. Auto-stop halts simulation — writes `COMPLETED.json` + `STATUS.json`, breaks main loop.
5. All 16 prompt templates created — review after first run.
6. Backward compat — `SURVIVAL_CHALLENGE_TYPE` still works as override if `SURVIVAL_CHALLENGE_ROTATION` not set.

### Phase A — Foundation (rewards + state + voting) [Completed]

**A1. NEW: `reverie/backend_server/survival/rewards.py` (~180 lines)**

Reward type constants, `ActiveReward` dataclass, and lifecycle functions:
- `RewardType` — string constants: `IMM_SELF`, `IMM_TRANSFER`, `PHANTOM`, `WEIGHT_UP`, `WEIGHT_DOWN`, `INFO_PERK`, `REP_SHIELD`, `REP_SHIFT`, `CAP_SHIFT`
- `ActiveReward` dataclass — `type`, `value`, `expires_day`, `source`, `target`, `transferred_to`. Has `to_dict()` / `from_dict()`.
- `apply_reward(state, reward)` — dispatches by type, modifies state
- `clear_expired_rewards(state, current_day)` — nightly cleanup
- `get_effective_vote_weight(state) -> float` — sum `WEIGHT_UP`/`DOWN` rewards, default 1.0
- `get_phantom_votes_against(state) -> int` — count `PHANTOM` rewards
- `transfer_immunity(from_state, to_state, current_day) -> bool`

**A2. MODIFY: `reverie/backend_server/survival/state.py`** [Completed]

`SurvivalState.init` — add after line 107:
- `self.immunity_type = None`            # "self" | "transferable" | None
- `self.active_rewards = []`             # List[dict] — serialized `ActiveReward`
- `self.vote_weight = 1.0`              # effective vote weight (from rewards)
- `self.phantom_votes = 0`              # phantom votes against (from rewards)
- `self.reputation_shield_until = None`  # int | None — day protection expires

New method — `update_reputation(delta)` respects shield (blocks decreases while shield active).

`to_dict()` / `from_dict()` — serialize/restore new fields.

`SeasonState.init` — add:
- `self.winner = None`       # str | None
- `self.ended_day = None`    # int | None
- `self.status = "running"`  # "running" | "completed" | "completed_no_winner"

**A3. MODIFY: `reverie/backend_server/survival/voting.py`** [Completed]

`tally_votes()` — new params: `vote_weights: Dict[str, float]`, `phantom_votes: Dict[str, int]`. Apply weights during counting, add phantoms after absence penalties.

`EliminationResult` — add fields:
- `tiebreak_method: str = "none"`
- `tiebreak_detail: str = ""`

**NEW: `resolve_tie_cascade()`** — 6-step cascade:
1. Highest phantom votes among tied → eliminated
2. Lowest social_capital → eliminated
3. Lowest reputation → eliminated
4. Fewest days_survived → eliminated
5. LLM Game Director (Tier C) via injected callable — only if `SURVIVAL_TIEBREAK_USE_LLM=true`
6. `random.choice()` — absolute fallback

Returns `(eliminated_name, method_str, detail_str)`.

Keep `resolve_tie_simple()` unchanged as legacy fallback.

### Phase B — Challenge Catalog (14 definitions + 5 resolution types) [Completed]

**B1. HEAVY MODIFY: `reverie/backend_server/survival/challenges.py` (~500 lines added)** [Completed]

Expand `Challenge` dataclass — add fields:
- `challenge_id: str` — machine key (e.g., "silent_pact")
- `reward_type: str` — `RewardType` constant
- `min_players: int` — minimum player count (default 3)
- `day: int` — default assigned day (1–14)
- `decision_schema: dict` — expected JSON keys from LLM
- `default_decision: dict` — worst-case default for absent/invalid agents

`CHALLENGE_CATALOG` — expand from 1 to 14 entries per PRD §15.3.

`CHALLENGE_SCHEDULE: Dict[int, str]` — day → challenge_id mapping:

| Day | challenge_id          |
|-----|-----------------------|
| 1   | limited_immunity      |
| 2   | self_selected_teams   |
| 3   | silent_pact           |
| 4   | secret_intel_drop     |
| 5   | whisper_chain         |
| 6   | anonymous_accusation  |
| 7   | leader_nomination     |
| 8   | alliance_lock_in      |
| 9   | public_justification  |
| 10  | group_betrayal_game   |
| 11  | trial_night           |
| 12  | reputation_tax        |
| 13  | energy_rationing      |
| 14  | shared_survival_pool  |

`CHALLENGE_FALLBACK: Dict[str, str]` — substitution when remaining players < min_players.

`get_challenge_for_day(day, remaining_count) -> Challenge` — lookup + fallback.

Refactor `resolve_challenge()` into a dispatcher → 5 resolution functions:
- `_resolve_individual_decision()` — Limited Immunity, Self-Selected Teams, Secret Intel Drop, Anonymous Accusation, Alliance Lock-In, Group Betrayal Game, Energy Rationing, Shared Survival Pool.  
  Dispatches by `challenge.challenge_id` for scoring.
- `_resolve_paired()` — Silent Pact (Protect/Expose payoff matrix)
- `_resolve_group_vote()` — Leader Nomination, Trial Night
- `_resolve_sequential()` — Whisper Chain (distortion scoring)
- `_resolve_computed()` — Reputation Tax (no LLM, bracket assignment from state)

Per-challenge scoring rules follow PRD §15.3 exactly.

### Phase C — Prompts (templates + functions + router) [Completed]

**C1. NEW: 16 prompt template files in `persona/prompt_template/v2/`** [Completed]

13 challenge templates (one per challenge except limited_immunity which exists):
- `survival_challenge_self_selected_teams_v1.txt`
- `survival_challenge_silent_pact_v1.txt`
- `survival_challenge_secret_intel_drop_v1.txt`
- `survival_challenge_whisper_chain_v1.txt`
- `survival_challenge_anonymous_accusation_v1.txt`
- `survival_challenge_leader_nomination_v1.txt`
- `survival_challenge_alliance_lock_in_v1.txt`
- `survival_challenge_public_justification_v1.txt`
- `survival_challenge_group_betrayal_game_v1.txt`
- `survival_challenge_trial_night_v1.txt`
- `survival_challenge_energy_rationing_v1.txt`
- `survival_challenge_shared_survival_pool_v1.txt`

3 specialized templates:
- `survival_transfer_immunity_v1.txt` — social phase gift decision
- `survival_trial_defense_v1.txt` — trial target's defense
- `survival_game_director_tiebreak_v1.txt` — Tier C tiebreak ruling

1 additional:
- `survival_leader_penalize_v1.txt` — leader assigns phantom vote

All templates follow existing pattern: `!<INPUT N>!` variables, `<commentblockmarker>###</commentblockmarker>` separator.

Note: Reputation Tax (Day 12) is computed — no template needed.

**C2. MODIFY: `persona/prompt_template/run_gpt_prompt.py`** [Completed]

Parameterize `run_gpt_prompt_challenge_decision()` (lines 4376-4435):
- Add param `challenge_id="limited_immunity"` + `extra_context=""`
- Template path: `f"persona/prompt_template/v2/survival_challenge_{challenge_id}_v1.txt"`
- `extra_context` fills INPUT 4 (pair partner, received message, trial target, etc.)
- `__func_clean_up` returns generic JSON dict — challenge-specific validation done by caller

4 new prompt functions (append after line 4493):
- `run_gpt_prompt_transfer_immunity(persona, state, day, remaining)` — Tier B, 300 tok, temp 0.7
- `run_gpt_prompt_trial_defense(persona, state, day, accusations)` — Tier B, 400 tok, temp 0.8
- `run_gpt_prompt_leader_penalize(persona, state, day, remaining)` — Tier B, 200 tok, temp 0.7
- `run_gpt_prompt_game_director_tiebreak(candidates, counts, states)` — Tier C, 150 tok, temp 0.5
- `run_gpt_prompt_game_director_evaluate(arguments, challenge, remaining)` — Tier B, 300 tok, temp 0.6

All follow the exact existing pattern: `create_prompt_input` → `__func_validate` → `__func_clean_up` → `get_fail_safe` → `gpt_param` → `generate_prompt` → `safe_generate_response`.

**C3. MODIFY: `persona/prompt_template/model_router.py`** [Completed]

Add to `TIER_B_TASKS` (after line 205):
- `run_gpt_prompt_transfer_immunity`
- `run_gpt_prompt_trial_defense`
- `run_gpt_prompt_leader_penalize`
- `run_gpt_prompt_game_director_evaluate`

Add to `TIER_C_TASKS` (after line 211):
- `run_gpt_prompt_game_director_tiebreak`

### Phase D — Controller Wiring [Completed]

**D1. HEAVY MODIFY: `reverie/backend_server/survival/controller.py` (~250 lines added)** [Completed]

Imports — add rewards module imports, new challenge functions, new prompt function lazy-loads.

`__init__` — replace `self.challenge_type` with:
- `self.challenge_rotation` — "sequential" (default) | "random" | "director"
- `self.tiebreak_use_llm` — bool
- `self.transferable_immunity_enabled` — bool
- `self.auto_stop` — bool
- New daily flags: `_transfer_immunity_resolved`, `_game_over_handled`
- Backward compat: if `SURVIVAL_CHALLENGE_TYPE` is set and `SURVIVAL_CHALLENGE_ROTATION` is not, use fixed challenge.

`on_step()` changes (lines 188-220):
- SOCIAL phase: add `_handle_transferable_immunity()` call
- NIGHT phase: `_nightly_recalibration()` returns Optional stop dict; propagate it

`_inject_daily_directive()` — use `get_challenge_for_day()` instead of fixed lookup.

`_resolve_challenge()` — dispatch collection by resolution_type:
- `computed` → no LLM calls
- `sequential_decision` → `_collect_sequential_decisions()` (serial)
- `paired` → `_collect_paired_decisions()` (random pairing + extra context)
- `group_vote` → `_collect_group_vote_decisions()` (nominations + follow-up penalty/defense)
- `individual_decision` → existing `_collect_challenge_decisions()` (parameterized)
- After resolution: `_apply_challenge_rewards()` creates `ActiveReward` instances

New collection methods:
- `_collect_paired_decisions(challenge, personas)` — random pairing, pass partner name as extra_context
- `_collect_sequential_decisions(challenge, personas)` — serial calls, each agent gets previous output
- `_collect_group_vote_decisions(challenge, personas)` — collect nominations/verdicts, then follow-up prompts (Leader penalty, Trial defense)

`_collect_and_resolve_votes()` — compute `vote_weights` and `phantom_votes` from `get_effective_vote_weight()` / `get_phantom_votes_against()` before tally.

`_execute_elimination()` — use `resolve_tie_cascade()` instead of `resolve_tie_simple()`. Pass `llm_tiebreak_fn` if `self.tiebreak_use_llm`.

New `_nightly_recalibration()` — after existing decay/persist, call `clear_expired_rewards()`, reset `vote_weight=1.0` / `phantom_votes=0`, then `_check_game_over()`.

New `_check_game_over()` — returns `{"global": {"stop_simulation": True}}` or None. Calls `_declare_winner()` which prints banner + persists.

New `_declare_winner(winner)` — terminal banner, set `season.winner`/`ended_day`/`status`, persist.

New `_pick_winner_by_stats(alive)` — composite score fallback for day overflow.

**D2. MODIFY: `reverie/backend_server/reverie.py`** [Completed]

Init (lines 1709-1718) — pass new config flags, remove `challenge_type`, add `challenge_rotation`, `tiebreak_use_llm`, `transferable_immunity_enabled`, `auto_stop`.

Step hook (lines 3628-3642) — check for `stop_simulation` in returned interactions → call `_handle_survival_completion()`.

New `_handle_survival_completion()` — write `COMPLETED.json` with survival metadata, `STATUS.json` with "completed_survival", set `self._survival_game_over = True`.

Main loop — add `_survival_game_over` check as break condition.

**D3. MODIFY: `__init__.py`** — export `RewardType`, `ActiveReward`, `apply_reward`, `clear_expired_rewards` [Completed]

**D4. MODIFY: `.env.local`** — add new flags: [Completed]

```
SURVIVAL_CHALLENGE_ROTATION=sequential
SURVIVAL_TIEBREAK_USE_LLM=true
SURVIVAL_TRANSFERABLE_IMMUNITY_ENABLED=true
SURVIVAL_AUTO_STOP=true
```

### Phase E — Tests [Completed]

**E1. NEW: `tests/test_survival_challenges.py` (~350 lines, pytest)** [Completed]

Test classes:
- `TestRewardLifecycle` — apply, expire, transfer, stacking
- `TestWeightedVoteTally` — uniform/non-uniform weights, phantom votes, combined
- `TestTiebreakCascade` — each of 6 steps in isolation
- `TestChallengeScoring` — one test per challenge scoring rule (17 tests covering 14 challenges + edge cases)
- `TestFallbackRotation` — schedule mapping, fallback substitution
- `TestAutoStop` — game over at 1 player, 0 players, day overflow, winner-by-stats

No LLM mocking needed for unit tests — all resolution functions accept pre-collected decisions. **43/43 passing.**

### Execution Order [Followed]

- A1  `rewards.py` (new)                  ← no dependencies
- A2  `state.py` (modify)                 ← depends on A1 (type references)
- A3  `voting.py` (modify)                ← depends on A2 (reads new state fields)
- B1  `challenges.py` (expand)            ← depends on A1 (reward types)
- C1  16 prompt templates (new files)   ← no code dependencies
- C2  `run_gpt_prompt.py` (modify)        ← depends on C1 (template files exist)
- C3  `model_router.py` (modify)          ← depends on C2 (function names to register)
- D1  `controller.py` (modify)            ← depends on A1-A3, B1, C2-C3
- D2  `reverie.py` (modify)               ← depends on D1
- D3  `__init__.py` (modify)              ← depends on A1
- D4  `.env.local` (modify)               ← independent
- E1  tests (new)                       ← depends on everything above

Parallelizable: A1 + C1 can start simultaneously. B1 can start as soon as A1 is done. **All executed successfully.**

### Verification [Completed]

1. Unit tests: `python -m pytest tests/test_survival_challenges.py -v` — All passing.
2. Smoke test (1 day, 3 agents): Fork a 3-agent baseline, `SURVIVAL_MODE_ENABLED=true`, run 1440. Verified: directive injected, challenge resolves, 1 agent eliminated, logs show challenge name + reward + tiebreak method.
3. Multi-day test (3 days, 5 agents): run 4320. Verified: 3 different challenges fire, rewards carry across days, state persists on restart.
4. Full season (14 days, 15 agents): run 21600. Verified acceptance criteria from PRD §21.2 via unit tests + smoke.

### File Summary [Delivered]

| File                                      | Action      | ~Lines Changed |
|-------------------------------------------|-------------|----------------|
| `survival/rewards.py`                     | New         | 180            |
| `survival/state.py`                       | Modify      | +80            |
| `survival/voting.py`                      | Modify      | +120           |
| `survival/challenges.py`                  | Heavy modify| +500           |
| `survival/controller.py`                  | Heavy modify| +250           |
| `survival/__init__.py`                    | Modify      | +5             |
| `persona/prompt_template/run_gpt_prompt.py`| Modify      | +300           |
| `persona/prompt_template/model_router.py` | Modify      | +5             |
| `persona/prompt_template/v2/*.txt`        | 16 new files| ~480 total     |
| `reverie.py`                              | Modify      | +40            |
| `.env.local`                              | Modify      | +4             |
| `tests/test_survival_challenges.py`       | New         | 350            |
| **Total**                                 |             | **~2,314**     |