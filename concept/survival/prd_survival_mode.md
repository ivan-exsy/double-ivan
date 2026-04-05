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
```bash
cd reverie/backend_server
python reverie.py
# Enter baseline: soul15_seed_20260224
# Enter new sim:  20260415-survival-1
# Enter: run 21600
```

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
- [ ] Run a full survival season (`SURVIVAL_MODE_ENABLED=true`, 15 agents, ~1440 steps/day x 15 days)
- [ ] Tune prompt templates based on first-run LLM output quality (vote reasoning, challenge decisions)
- [ ] Verify spatial gate triggers correctly at Hobbs Cafe (80% threshold)
- [ ] Verify elimination removes agent cleanly (no ghost personas, no crash on next step)

### Post-MVP polish
- [ ] **Frontend subtitle overlay** — add `meta.survival` field to step JSON (phase, day, immunity holder) for frontend rendering
- [ ] **Narrative generation** — `narrative.py` producing per-day summary, alliance graph, power rankings, "most dangerous player"
- [ ] **Tier A trust calibration** — wire `_run_trust_calibration()` to lightweight LLM prompt for top-3 changed relationships per agent nightly
- [ ] **Tier C LLM tiebreaker** — replace algorithmic tiebreak (`resolve_tie_simple`) with Game Director Tier C prompt on vote ties
- [ ] **Day-1 personality seeding** — Tier A prompts for initial `perceived_threat` and `risk_tolerance` (currently defaults to 0.5)
- [ ] **Alliance detection from conversations** — scan `run_gpt_prompt_summarize_conversation` output for alliance signals (keyword + LLM hybrid)
- [ ] **Absence memory injection** — inject "X failed to show for voting" as memory for all present agents

### Future extensions (not MVP)
- [ ] Challenge rotation (6 archetypes: teams, silent pact, intel drop, public justification, trial night)
- [ ] Voting format rotation (public vote, weighted votes, vote blocking)
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

#### Implementation status (updated 2026-04-03)

Detailed design and implementation plan: [`survival_playbook.md`](survival_playbook.md)

**Fully wired into simulation loop** at `reverie/backend_server/survival/` (branch: `local`). Gated behind `SURVIVAL_MODE_ENABLED=true` (default: false) — zero impact on normal simulation.

| File | Lines | Status |
|---|---|---|
| `state.py` | 361 | Done — `Phase` enum, `SurvivalState` (per-agent), `SeasonState` (global), Supabase persistence |
| `challenges.py` | 165 | Done — `Challenge` catalog (MVP: Limited Immunity), resolution logic with nominations + tiebreaks |
| `voting.py` | 223 | Done — `tally_votes()`, immunity voiding, absence penalties, algorithmic tiebreaker |
| `controller.py` | ~750 | Done — Phase state machine, LLM-wired hooks, spatial gates, directive injection, elimination broadcast |
| `__init__.py` | 38 | Done — re-exports |

**Wiring layer (existing files modified):**

| File | Change | Status |
|---|---|---|
| `reverie.py` | Env flag + init + step hook in `start_server()` + elimination handler | Done |
| `scratch.py` | `self.survival = {}` dict with full serialization | Done |
| `run_gpt_prompt.py` | 3 prompt functions + format helper (~170 lines appended) | Done |
| `model_router.py` | 3 entries in `TIER_B_TASKS` | Done |
| `v2/*.txt` | 3 new prompt templates (vote, challenge, final statement) | Done |

**What's working now:**
- [x] Phase detection (7 phases mapped to sim-time hours)
- [x] Per-agent state: trust, grudge, perceived_threat, social_capital, reputation, alliances, immunity, vote history
- [x] State mutation rules with nightly decay (trust toward 0.5 at 0.98/day, grudge toward 0 at 0.95/day)
- [x] Limited Immunity challenge resolution via LLM (claim/nominate, social_capital ranking, tiebreak by threat)
- [x] Secret ballot tallying with immunity voiding, absence penalties (+1 phantom vote), tie detection
- [x] Algorithmic tiebreaker fallback (lowest social_capital eliminated)
- [x] Directive injection into `daily_plan_req` via `process_user_interactions` pipeline
- [x] Alliance betrayal detection (vote against ally triggers trust/grudge mutations)
- [x] Season state file persistence + guarded Supabase persistence
- [x] LLM-driven vote decisions (Tier B prompt per agent)
- [x] LLM-driven challenge decisions (Tier B prompt per agent)
- [x] Final statement generation for eliminated agents (Tier B)
- [x] Elimination broadcast — Supabase memory injection for all remaining agents
- [x] Agent removal from `self.personas` + maze tile cleanup on elimination
- [x] Game-over detection (last player standing)

**Remaining (post-MVP polish):**
- [ ] Frontend subtitle overlay (`meta.survival` field in step JSON)
- [ ] Narrative generation (per-day summary, alliance graph, power rankings)
- [ ] Tier A trust calibration (nightly LLM recalibration — currently algorithmic-only)
- [ ] Tier C LLM tiebreaker (currently uses algorithmic fallback)

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