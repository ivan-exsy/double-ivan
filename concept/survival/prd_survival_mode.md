# Product Requirements Document (PRD)

## Product Name
**SurvivalMode** (RealityTV Mode for Double)

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

**Standalone module implemented** at `reverie/backend_server/survival/` (branch: `local`). Fully self-contained — zero modifications to existing files, portable to any branch.

| File | Lines | Status |
|---|---|---|
| `state.py` | 265 | Done — `Phase` enum, `SurvivalState` (per-agent), `SeasonState` (global), Supabase persistence |
| `challenges.py` | 140 | Done — `Challenge` catalog (MVP: Limited Immunity), resolution logic with nominations + tiebreaks |
| `voting.py` | 170 | Done — `tally_votes()`, immunity voiding, absence penalties, algorithmic tiebreaker |
| `controller.py` | 340 | Done — `SurvivalController` phase state machine, `on_step()` hook, spatial gates, directive injection |
| `__init__.py` | 15 | Done — re-exports |

**What's working now (930 lines, all smoke-tested):**
- [x] Phase detection (7 phases mapped to sim-time hours)
- [x] Per-agent state: trust, grudge, perceived_threat, social_capital, reputation, alliances, immunity, vote history
- [x] State mutation rules with nightly decay (trust toward 0.5 at 0.98/day, grudge toward 0 at 0.95/day)
- [x] Limited Immunity challenge resolution (claim/nominate, social_capital ranking, tiebreak by threat)
- [x] Secret ballot tallying with immunity voiding, absence penalties (+1 phantom vote), tie detection
- [x] Algorithmic tiebreaker fallback (lowest social_capital eliminated)
- [x] Directive injection in the exact `user_interactions` format `plan.py` already accepts
- [x] Alliance betrayal detection (vote against ally triggers trust/grudge mutations)
- [x] Season state file persistence + guarded Supabase persistence

**Pending — requires wiring after Nicolas's branch merges:**
- [ ] Hook `SurvivalController.on_step()` into `reverie.py::execute_immutable_step()` (~25 lines)
- [ ] Add `self.survival = {}` dict to `scratch.py` for in-memory state (~20 lines)
- [ ] New prompt functions in `run_gpt_prompt.py`: `run_gpt_prompt_vote_decision` (Tier B), `run_gpt_prompt_challenge_decision` (Tier B), `run_gpt_prompt_final_statement` (Tier B) (~120 lines)
- [ ] Register new functions in `model_router.py` tier lists
- [ ] Wire 4 placeholder hooks in controller.py to actual LLM calls
- [ ] `SURVIVAL_MODE_ENABLED` env flag activation in `reverie.py` init
- [ ] Frontend subtitle overlay (`meta.survival` field in step JSON)
- [ ] Narrative generation (per-day summary, alliance graph, power rankings)

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