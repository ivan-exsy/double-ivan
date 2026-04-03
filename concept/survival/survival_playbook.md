# Survival Mode Playbook

> Competitive social elimination layered on top of the generative-agents simulation.
> Sprites live their day under pressure — challenge, scheme, vote, eliminate — until one remains.
> MVP scope: 15 players, 14 elimination days, single challenge archetype, secret ballot.

---

## Table of Contents

- [1. Design Philosophy](#1-design-philosophy)
- [2. Season Structure](#2-season-structure)
- [3. Day Loop — Phase by Phase](#3-day-loop--phase-by-phase)
- [4. Game Director](#4-game-director)
- [5. Challenge System](#5-challenge-system)
- [6. Alliance & Social Mechanics](#6-alliance--social-mechanics)
- [7. Voting & Elimination](#7-voting--elimination)
- [8. State Model](#8-state-model)
- [9. Implementation Architecture](#9-implementation-architecture)
- [10. Prompt Engineering](#10-prompt-engineering)
- [11. Gathering Mechanics — Spatial Convergence](#11-gathering-mechanics--spatial-convergence)
- [12. LLM Cost Model](#12-llm-cost-model)
- [13. Frontend Integration](#13-frontend-integration)
- [14. Narrative Output & Video](#14-narrative-output--video)
- [15. Validation & Testing](#15-validation--testing)
- [16. MVP Scope & Phasing](#16-mvp-scope--phasing)
- [17. Post-MVP Roadmap](#17-post-mvp-roadmap)
- [Appendix A: Challenge Catalog](#appendix-a-challenge-catalog)
- [Appendix B: Prompt Templates](#appendix-b-prompt-templates)
- [Appendix C: State Schema](#appendix-c-state-schema)
- [Appendix D: Corrected Step-Time Reference](#appendix-d-corrected-step-time-reference)

---

## 1. Design Philosophy

### 1.1 Core Thesis

Survival Mode converts high-fidelity personality simulation into **competitive social theater**. The agents already perceive, plan, converse, and reflect — Survival adds *stakes* that make those behaviors consequential.

The design rests on four principles:

1. **Minimal invasion.** Survival is a *layer* on top of the cognitive pipeline, not a rewrite. The perceive-retrieve-plan-execute-reflect loop runs unchanged. Survival injects goals, context, and constraints — the LLM decides how agents respond to them.

2. **Structural incentive over hard override.** Agents are not puppeted. They receive strong incentives (attend voting or risk elimination) and context (who betrayed whom). The LLM's personality-grounded reasoning produces emergent strategy — not scripted behavior.

3. **Pressure creates character.** Reality TV works because constraints force people to reveal themselves. Scarcity, deadlines, elimination risk, and information asymmetry are the tools. The simulation already has personalities; Survival gives them reasons to clash.

4. **Every day is an episode.** Each simulation day has a narrative arc: morning tension, challenge pressure, social scheming, voting climax, elimination shock, night reflection. The system should produce watchable, replayable content.

### 1.2 What Changes vs. Normal Simulation

| Aspect | Normal Mode | Survival Mode |
|---|---|---|
| Daily plan | LLM-generated from personality + lifestyle | Personality + survival phase obligations injected via `daily_plan_req` |
| Conversations | Proximity-triggered, organic | Same triggers, but survival context (trust, threat, alliances) shapes content |
| Movement | Free exploration | Free within phases; gathering obligations during Challenge/Voting |
| Memory | Episodic stream | Same stream + survival-typed memories (announcements, vote results, betrayals) |
| Agent lifecycle | Persistent for entire run | Eliminated agents removed from `self.personas` |
| Reflection | Personality-driven insights | Augmented with survival state (trust shifts, threat reassessment) |

### 1.3 Why This Works With the Current Stack

All 15 challenge types from the [Daily Challenges doc](daily_challenges.md) rely only on:
- Text reasoning (LLM decisions)
- Memory updates (Supabase RPCs)
- Token-like resources (scratch state)
- Voting (new prompt function)
- Alliance proposals (conversation extraction)

No new engine features required. No physics, no real-time skill, no visual minigames.

---

## 2. Season Structure

### 2.1 Parameters

| Parameter | MVP Value | Notes |
|---|---|---|
| Players | 15 (`soul15_seed_20260224`) | Full roster; scales down with eliminations |
| Elimination rate | 1 per day | Majority vote, secret ballot |
| Season length | 14 elimination days + 1 finale day | Day 15 = victory lap, no elimination |
| Challenge rotation | Single archetype (Limited Immunity) | 6-challenge rotation post-MVP |
| Voting format | Secret ballot | Format rotation post-MVP |
| Alliances | Informal (conversation-detected) | Formal proposals post-MVP |

### 2.2 Season State

```
season:
  sim_code: str              # e.g., "20260415-survival-1"
  total_days: 15
  current_day: int           # 1-indexed
  phase: enum                # SLEEP | DIRECTIVE | CHALLENGE | SOCIAL | VOTING | ELIMINATION | NIGHT
  remaining_players: [str]   # persona names still in play
  eliminated: [{name, day, vote_count, final_statement}]
  active_challenge: Challenge | null
  active_twists: []          # post-MVP
  immunity_holder: str | null
```

### 2.3 Season Arc

```
Day 1:   15 players — introductions, first alliances, first shock elimination
Day 2-4: 14-11 — alliance consolidation, early betrayals surface
Day 5-7: 11-8 — power blocs solidify, swing voters become kingmakers
Day 8-10: 8-5 — alliances fracture under pressure, every vote existential
Day 11-13: 5-2 — endgame maneuvering, final betrayals
Day 14:  2-1 — final elimination vote (all eliminated could jury-vote post-MVP)
Day 15:  FINALE — winner's victory lap, reflective interactions, narrative closure
```

Token cost naturally decreases: 15 LLM-call agents on day 1 down to 2 on day 14. Total LLM calls across a full season are roughly equivalent to a 10-day normal sim with 15 agents.

---

## 3. Day Loop — Phase by Phase

### 3.1 Time Budget

`SIM_STEP_LENGTH=60` = 60 simulated seconds per step = **1,440 steps per simulation day**.

| Phase | Sim Time | Steps | Purpose |
|---|---|---|---|
| **Sleep** | 00:00-06:00 | 0-359 | No LLM calls (hardcoded sleep). Memory consolidation at tail end. |
| **Directive** | 06:00-08:00 | 360-479 | Game Director announces challenge + stakes. Agents wake, plan strategy. |
| **Challenge** | 08:00-12:00 | 480-719 | Agents gather at Hobbs Cafe. Challenge resolves via LLM decisions. |
| **Social** | 12:00-18:00 | 720-1079 | Free interaction. Alliance building, lobbying, scheming, misinformation. |
| **Voting** | 18:00-21:00 | 1080-1259 | Agents gather at Hobbs Cafe. Each casts a secret vote via LLM. |
| **Elimination** | 21:00-22:00 | 1260-1319 | Votes tallied, target eliminated, final statement generated. |
| **Night** | 22:00-00:00 | 1320-1439 | Trust/grudge/threat updates. Reflection on the day. Wind down to sleep. |

### 3.2 Phase Transition Logic

Phases transition by **sim-time clock** (primary) with optional **spatial gates** (secondary):

```python
def get_current_phase(sim_time: datetime) -> Phase:
    hour = sim_time.hour + sim_time.minute / 60
    if hour < 6:    return Phase.SLEEP
    if hour < 8:    return Phase.DIRECTIVE
    if hour < 12:   return Phase.CHALLENGE
    if hour < 18:   return Phase.SOCIAL
    if hour < 21:   return Phase.VOTING
    if hour < 22:   return Phase.ELIMINATION
    return Phase.NIGHT
```

**Spatial gates** (soft enforcement):
- **Challenge phase**: Resolution waits until 80%+ of alive players are within Hobbs Cafe tiles, OR deadline step 660 (11:00), whichever comes first. Absent agents get default (worst) challenge outcome.
- **Voting phase**: Same gate — 80%+ at Hobbs Cafe OR deadline step 1200 (20:00). Absent agents' vote is forfeit and they receive +1 vote against themselves (penalty for no-show).

This creates natural drama: agents who arrive late face worse outcomes, but the simulation never deadlocks waiting for stragglers.

### 3.3 Phase Flow Diagram

```
 SIMULATION DAY N

 SLEEP --> DIRECTIVE --> CHALLENGE --> SOCIAL --> VOTING
 (zzz)    (announce)    (compete)    (scheme)   (decide)
                                                   |
                                              ELIMINATION
                                              (goodbye)
                                                   |
                                                 NIGHT
                                               (reflect)
                                                   |
                                          Day N+1 or FINALE
```

---

## 4. Game Director

### 4.1 Architecture

The Game Director is a **system-level orchestrator** — not a persona. It has no sprite, no LLM personality, no movement cost. It operates through two channels:

1. **Global memory injection** — Rules and announcements stored via `dbl_store_memory_dev` RPC with `memory_type='announcement'`. Retrieved alongside normal memories during planning prompts, ensuring agents are aware of the game state.

2. **`user_interactions["global"]`** — Phase directives injected into `process_user_interactions()` at the start of each step. Applied to all personas before their cognitive pipeline runs.

### 4.2 Announcement Types

| Announcement | When | Channel | Persistence |
|---|---|---|---|
| Season rules | Day 1, step 360 | Memory (one-time) | Permanent — retrieved in all planning prompts |
| Daily challenge brief | Each day, step 360 | Memory + user_interaction | Day-scoped — high poignancy for same-day retrieval |
| Challenge results | After resolution | Memory per agent | Permanent |
| Vote results | After tallying | Memory per agent | Permanent |
| Elimination notice | After elimination | Memory per agent | Permanent |
| Twist announcement | When activated | Memory + user_interaction | Phase-scoped |

### 4.3 Rules Memory (Injected Once, Day 1)

Stored via `dbl_store_memory_dev` for every agent on day 1:

```
SURVIVAL GAME RULES: You are in a competitive survival game. Each day has phases:
Morning — a challenge is announced. Afternoon — socialize, form alliances, strategize.
Evening — everyone gathers at Hobbs Cafe to vote. One person is eliminated by majority
vote each night. The last person remaining wins. Immunity tokens protect you from
elimination for one vote. Alliances are your lifeline — but anyone can betray you.
Attend all gatherings at Hobbs Cafe or face penalties. Your goal: survive.
```

This memory persists across all days. The hybrid retrieval system (`dbl_retrieve_with_rir`) surfaces it during planning due to high poignancy + keyword relevance to survival-related queries.

### 4.4 Daily Directive Injection

Each morning (step 360), the `SurvivalController` sets each agent's `daily_plan_req` to include the survival phase schedule:

```python
survival_directive = (
    f"Day {day} of Survival. Today's challenge: {challenge.name} — {challenge.brief}. "
    f"SCHEDULE: Attend challenge at Hobbs Cafe by 10:00. Socialize and strategize 12:00-18:00. "
    f"CRITICAL: Gather at Hobbs Cafe by 19:00 for voting — missing it risks your safety. "
    f"Players remaining: {len(alive)}. Eliminated yesterday: {last_eliminated or 'nobody (day 1)'}."
)
persona.scratch.daily_plan_req = survival_directive
```

The LLM's `run_gpt_prompt_daily_plan` (Tier B) reads this as part of its input and generates a schedule that weaves survival obligations with personality-driven behavior.

---

## 5. Challenge System

### 5.1 MVP: Limited Immunity

One challenge archetype for MVP. Simple, high-drama, zero map changes.

**Setup:** At the start of Challenge phase, the Director announces: *"Two immunity tokens are available. To claim one, you must convince the group — or negotiate privately. Only two can be immune tonight."*

**Resolution flow:**
1. Agents gather at Hobbs Cafe (spatial gate).
2. During Challenge phase, agents converse naturally (proximity-triggered full-tier chats). The challenge context is in their planning prompt, so conversations organically center on immunity.
3. At challenge deadline (step 660), each eligible agent receives a `run_gpt_prompt_challenge_decision` call:
   - Input: challenge description, current alliances, trust scores, recent conversations about immunity
   - Output: `{"claim_immunity": bool, "nominate": "persona_name" | null, "reasoning": "..."}`
4. Backend aggregates: if 2 or fewer agents claim, they get immunity. If more than 2 claim, resolve by `social_capital` ranking (highest 2 win). Ties broken by perceived threat (lower threat wins — the crowd favors the underdog).
5. Results stored as memories. Immunity holder's name broadcast to all agents.

**Why this works:** The scarcity (only 2 tokens for up to 15 players) forces negotiation, favoritism, and betrayal. Agents with high social capital can claim boldly; low-capital agents must negotiate or gamble.

### 5.2 Challenge Resolution Architecture

```python
class Challenge:
    name: str                    # "Limited Immunity"
    brief: str                   # One-line for directive injection
    description: str             # Full description for LLM prompt
    resolution_type: str         # "individual_decision" | "paired" | "group_vote"
    max_winners: int             # How many agents can win the challenge
    reward: str                  # "immunity" | "vote_weight" | "info_access"
    tiebreak_field: str          # "social_capital" | "reputation" | "random"

def resolve_challenge(challenge, decisions, alive_agents, survival_states):
    """
    Aggregate individual LLM decisions into challenge outcomes.
    Returns: {agent_name: ChallengeOutcome}
    """
    claimants = [d for d in decisions if d["claim_immunity"]]
    if len(claimants) <= challenge.max_winners:
        winners = claimants
    else:
        # Rank by tiebreak field, take top N
        ranked = sorted(claimants,
                        key=lambda d: survival_states[d.agent].social_capital,
                        reverse=True)
        winners = ranked[:challenge.max_winners]
    # ... apply rewards, store results
```

### 5.3 Post-MVP Challenge Rotation

First-season rotation of 6 challenges (one per 2-3 days, cycling):

| Day(s) | Challenge | Mechanic | Drama Driver |
|---|---|---|---|
| 1, 7, 13 | **Limited Immunity** | Claim/negotiate for 2 tokens | Favoritism, betrayal |
| 2, 8 | **Self-Selected Teams** | Form teams; last team = at risk | Social exclusion, hierarchy |
| 3, 9 | **Silent Pact** | Pairs choose Protect or Expose | Betrayal patterns, retaliation |
| 4, 10 | **Secret Intel Drop** | 3 get true info, 2 get false | Misinformation, credibility |
| 5, 11 | **Public Justification** | Votes are public with rationale | Face-saving, moral posturing |
| 6, 12 | **Trial Night** | One agent put on trial | Persuasion, coalition rhetoric |

All 6 resolve through LLM-decision aggregation — no new engine features per challenge. The variation comes from prompt content and state mutation rules.

---

## 6. Alliance & Social Mechanics

### 6.1 Alliance Formation

Alliances form **informally through conversation**, detected by the system post-hoc. No formal "propose alliance" UI action in MVP.

**Detection flow:**
1. During Social phase, proximity triggers full-tier chats (`agent_chat_v2`, Tier B).
2. After each conversation, `run_gpt_prompt_summarize_conversation` (Tier B) extracts a structured summary.
3. The summary is scanned for alliance signals — commitment language, vote coordination, protection promises.
4. If detected, `survival_state.alliance_commitments` is updated for both participants.

**Signal detection (keyword + LLM hybrid):**
```python
ALLIANCE_SIGNALS = [
    "vote together", "protect each other", "alliance", "team up",
    "I'll vote for", "I won't vote against you", "we should work together",
    "deal", "pact", "promise", "trust me"
]

def detect_alliance_intent(conversation_summary: str, signals=ALLIANCE_SIGNALS) -> bool:
    """Fast keyword pre-filter, then LLM confirmation if ambiguous."""
    keyword_hit = any(s in conversation_summary.lower() for s in signals)
    if keyword_hit:
        return True  # MVP: trust keyword match
    return False
```

Post-MVP: Replace keyword detection with Tier A LLM classification for nuance.

### 6.2 Alliance Properties

```python
alliance = {
    "members": ["agent_a", "agent_b"],
    "formed_day": 3,
    "commitment": "vote together until final 5",
    "active": True,
    "broken_by": None,        # agent name if broken
    "broken_day": None
}
```

### 6.3 Alliance Breaking

An alliance is considered broken when:
- A member votes against their ally
- A member claims immunity over their ally when only one token remains
- A member is detected (via conversation summary) explicitly renouncing the alliance

**Consequences of breaking:**
- `trust[betrayed]` drops by 0.3 (hard penalty)
- `grudge[betrayed]` increases by 0.4
- The betrayal is stored as a high-poignancy memory for BOTH agents and any witnesses
- `reputation` drops by 0.15 for the breaker (visible in others' threat assessments)

These consequences ripple naturally: the betrayed agent's future LLM planning prompts will include the grudge memory, making them more likely to target the betrayer in voting.

### 6.4 Social Phase Dynamics

The Social phase (12:00-18:00, steps 720-1079) is 6 simulated hours of free interaction. This is where the emergent magic happens.

**What agents do (driven by LLM planning, not scripted):**
- Seek out allies for coordination conversations
- Lobby swing voters ("vote with us tonight")
- Spread misinformation about targets ("I heard X is planning to betray you")
- Trade favors ("I'll share intel if you promise not to vote for me")
- Isolate targets by avoiding conversation with them

**System support:**
- Survival context in planning prompts means the LLM naturally generates social-strategy actions
- `daily_plan_req` includes "Strategize for tonight's vote" which triggers seek-out behavior
- Proximity chats fire naturally as agents cross paths in the world
- Relationship affinity (`scratch.relationship_affinity`) accumulates from positive interactions, influencing who agents seek out

---

## 7. Voting & Elimination

### 7.1 Voting Flow

```
              VOTING PHASE

  1. Agents pathfind to Hobbs Cafe
  2. Spatial gate: 80%+ present OR deadline
  3. Each agent gets vote_decision prompt
  4. LLM returns: target + reasoning
  5. Backend tallies votes
  6. Tie? LLM tiebreaker (Tier C)
  7. Results stored as memories
  8. Immune agents' votes against them void

              ELIMINATION

  9.  Eliminated agent generates final statement
  10. Agent removed from self.personas
  11. Elimination stored in season state
  12. Broadcast to all remaining agents
```

### 7.2 Vote Decision Prompt

New function: `run_gpt_prompt_vote_decision` (Tier B — `gpt-5-mini`)

**Input context (assembled per agent):**
- Agent personality (innate, learned, currently)
- Survival state snapshot (trust scores, grudges, alliances, threat perceptions)
- Recent memories from today (conversations, challenge outcomes, observations)
- List of eligible vote targets (alive, non-immune agents)
- Retrieved memories about each candidate (what they've done, said, promised)

**Output contract:**
```json
{
  "vote_target": "persona_name",
  "reasoning": "free-text rationale (1-3 sentences)",
  "confidence": 0.0-1.0
}
```

**Cleanup contract:** Parse JSON, validate `vote_target` is in eligible list, fallback to random eligible target if invalid.

### 7.3 Vote Tallying

```python
def tally_votes(votes: dict[str, VoteDecision], immune: str | None) -> EliminationResult:
    # 1. Remove votes against immune player
    valid_votes = {
        voter: v for voter, v in votes.items()
        if v.vote_target != immune
    }

    # 2. Count
    counts = Counter(v.vote_target for v in valid_votes.values())

    # 3. Check for majority
    max_count = max(counts.values())
    candidates = [name for name, c in counts.items() if c == max_count]

    if len(candidates) == 1:
        return EliminationResult(eliminated=candidates[0], votes=counts, tie=False)

    # 4. Tiebreak via Tier C LLM (Director's ruling)
    eliminated = resolve_tie_llm(candidates, votes, survival_states)
    return EliminationResult(eliminated=eliminated, votes=counts, tie=True)
```

### 7.4 Tiebreak Resolution

When votes are tied, the Game Director (Tier C, `gpt-5.2`) makes the call:

**Prompt:** *"As the Game Director, break this tie. Candidates: {names}. Each received {N} votes. Consider their social capital, reputation, recent behavior, and narrative impact. Who should be eliminated? Respond with one name only."*

This is the single Tier C call per day (at most). It adds narrative weight — the Director's choice feels consequential and unpredictable.

### 7.5 Elimination Execution

```python
def eliminate_agent(self, agent_name: str, day: int, vote_counts: dict):
    # 1. Generate final statement (Tier B)
    final_stmt = run_gpt_prompt_final_statement(
        self.personas[agent_name], day, vote_counts
    )

    # 2. Store elimination record
    self.season.eliminated.append({
        "name": agent_name,
        "day": day,
        "vote_count": vote_counts.get(agent_name, 0),
        "final_statement": final_stmt
    })

    # 3. Persist final state to Supabase (for potential jury mode)
    store_elimination_memory(agent_name, day, final_stmt)

    # 4. Broadcast to remaining agents
    for persona in self.personas.values():
        if persona.name != agent_name:
            inject_memory(persona, f"{agent_name} was eliminated on Day {day}. "
                         f"Their final words: '{final_stmt}'")

    # 5. Remove from active simulation
    del self.personas[agent_name]
    self.season.remaining_players.remove(agent_name)
```

### 7.6 Absent Voter Penalty

Agents who fail to reach Hobbs Cafe by the voting deadline (step 1200 / 20:00):
- Their vote is **forfeit** (they don't get to vote)
- They receive **+1 phantom vote against themselves** (penalty)
- A memory is injected into all present agents: *"{name} failed to show for voting — unreliable and potentially dangerous"*

This is a strong structural incentive without hard-overriding agent autonomy. The LLM will almost always plan to attend because the `daily_plan_req` emphasizes it, but if personality-driven reasoning leads to absence, the system handles it gracefully.

---

## 8. State Model

### 8.1 Per-Agent Survival State

Extends `scratch.py` with a nested `survival` dict. Clean separation — all survival fields under one key, easy to toggle on/off.

```python
# In scratch.py __init__, when survival mode is active:
self.survival = {
    # Relationship scores (0.0 to 1.0, per other agent)
    "trust": {},              # trust["agent_b"] = 0.6
    "grudge": {},             # grudge["agent_b"] = 0.2
    "perceived_threat": {},   # perceived_threat["agent_b"] = 0.8

    # Personal scores
    "social_capital": 0.5,    # 0=pariah, 1=beloved. Starts neutral.
    "risk_tolerance": None,   # Set from personality on init (LLM Tier A)
    "reputation": 0.5,        # 0=untrustworthy, 1=reliable. Public-facing.
    "win_priority": 0.5,      # How much agent prioritizes winning vs. loyalty

    # Game items
    "has_immunity": False,
    "immunity_expires_day": None,

    # Alliance tracking
    "alliance_commitments": {},  # {"agent_b": {"formed_day": 3, "commitment": "..."}}

    # Vote history
    "vote_history": [],       # [{"day": 1, "voted_for": "agent_c", "reasoning": "..."}]

    # Computed (updated nightly)
    "days_survived": 0,
    "times_targeted": 0,      # How many votes received total
    "betrayals_committed": 0,
    "betrayals_suffered": 0,
}
```

### 8.2 State Update Rules

| Event | State Mutation | Magnitude |
|---|---|---|
| Positive conversation with X | `trust[X]` += 0.10 | Cumulative, capped at 1.0 |
| X votes against you | `grudge[X]` += 0.25, `trust[X]` -= 0.20 | Harsh — voting is personal |
| X keeps alliance promise | `trust[X]` += 0.15 | Rewarded loyalty |
| X breaks alliance | `trust[X]` -= 0.30, `grudge[X]` += 0.40 | Severe — betrayal is memorable |
| Win challenge | `social_capital` += 0.10 | Public success |
| Receive votes (not eliminated) | `perceived_threat[self]` += 0.05 per vote | Others notice you're targeted |
| Survive a day | `social_capital` += 0.02 | Longevity earns respect |
| Miss a gathering | `reputation` -= 0.10 | Unreliable signal |
| Eliminate via your vote | `perceived_threat[self]` += 0.08 by witnesses | Power is threatening |

### 8.3 Nightly Recalibration

During Night phase (22:00-00:00), the `SurvivalController` runs a reflection pass:

1. **Algorithmic updates**: Apply all pending mutations from the day (from the table above).
2. **Decay**: Trust decays toward 0.5 at rate 0.98/day. Grudge decays toward 0.0 at rate 0.95/day. This prevents permanent lock-in — forgiveness (or forgetting) is possible.
3. **LLM calibration** (optional, Tier A): For agents with significant state changes, run a lightweight prompt: *"Given today's events, assess your trust (0-1) in {X}."* Overwrites the algorithmic value. Keeps state grounded in personality, not just arithmetic. Run for top-3 most-changed relationships only to control costs.
4. **Persist to Supabase**: Snapshot `survival` dict via `dbl_store_memory_dev` with `memory_type='survival_state'` for cross-restart persistence and narrative queries.

### 8.4 Initialization

On day 1, step 360 (first Directive):
- `trust`: initialized to 0.5 for all other agents (neutral)
- `grudge`: initialized to 0.0 (no history)
- `perceived_threat`: initialized via Tier A LLM: *"Rate how threatening each person seems (0-1) based on first impressions."* This uses personality to seed initial dynamics (e.g., a cautious agent perceives more threats).
- `risk_tolerance`: Tier A LLM from personality: *"Rate this person's risk tolerance (0-1) based on their personality traits: {innate}, {learned}."*
- `win_priority`: Same Tier A call, seeded from personality.
- `social_capital`, `reputation`: 0.5 (neutral start)

---

## 9. Implementation Architecture

### 9.1 New Files

```
reverie/backend_server/
  survival/
    __init__.py
    controller.py          # SurvivalController — phase state machine, orchestration
    state.py               # SurvivalState — per-agent + global state management
    challenges.py          # Challenge definitions, resolution logic
    voting.py              # Vote tallying, tiebreaking, elimination
    narrative.py           # Post-day summary generation
```

**Estimated size:**

| File | Lines | Role |
|---|---|---|
| `controller.py` | ~250 | Core — phase transitions, directive injection, step hook |
| `state.py` | ~150 | Core — init, update, persist, load |
| `challenges.py` | ~120 | Core (MVP: single challenge) |
| `voting.py` | ~150 | Core — tallying, penalties, elimination |
| `narrative.py` | ~100 | Polish — summary generation |
| **Total new** | **~770** | |

### 9.2 Modified Files

| File | Change | Lines |
|---|---|---|
| `reverie.py` | Hook `SurvivalController.on_step()` into `execute_immutable_step()` | ~25 |
| `scratch.py` | Add `self.survival = {}` field + serialization | ~20 |
| `run_gpt_prompt.py` | Add `run_gpt_prompt_vote_decision`, `run_gpt_prompt_challenge_decision`, `run_gpt_prompt_final_statement` | ~120 |
| `plan.py` | Process survival-specific `user_interactions` types | ~15 |
| **Total modified** | | **~180** |

### 9.3 Integration Point: Step Hook

The `SurvivalController` hooks into the step execution pipeline at one point:

```python
# In reverie.py :: execute_immutable_step(), after observation processing,
# before cognitive pipeline:

if self.survival_controller:
    survival_interactions = self.survival_controller.on_step(
        step_number=step_number,
        sim_time=self.curr_time,
        personas=self.personas,
        maze=self.maze
    )
    if survival_interactions:
        self.process_user_interactions(survival_interactions, previous_step_data)
```

`on_step()` is the single entry point. It checks the current phase, triggers transitions, resolves challenges/votes at deadlines, and returns interaction dicts for the existing `process_user_interactions` pipeline.

### 9.4 SurvivalController — Core Logic

```python
class SurvivalController:
    def __init__(self, season_config: dict):
        self.season = SeasonState(season_config)
        self.states = {}  # {agent_name: SurvivalState}
        self.phase_history = []  # Track transitions for narrative
        self._challenge_resolved = False
        self._votes_collected = False

    def on_step(self, step_number, sim_time, personas, maze) -> dict | None:
        """Called every step. Returns user_interactions dict or None."""
        current_phase = get_current_phase(sim_time)
        prev_phase = self.season.phase

        # Phase transition?
        if current_phase != prev_phase:
            self._on_phase_transition(prev_phase, current_phase, sim_time, personas)
            self.season.phase = current_phase

        # Phase-specific logic
        interactions = {}
        match current_phase:
            case Phase.DIRECTIVE:
                if not self._directive_injected_today:
                    interactions = self._inject_daily_directive(personas)
                    self._directive_injected_today = True

            case Phase.CHALLENGE:
                if not self._challenge_resolved and self._spatial_gate_met(personas, maze):
                    self._resolve_challenge(personas)
                    self._challenge_resolved = True

            case Phase.VOTING:
                if not self._votes_collected and self._spatial_gate_met(personas, maze):
                    self._collect_and_resolve_votes(personas)
                    self._votes_collected = True

            case Phase.ELIMINATION:
                if self._pending_elimination:
                    self._execute_elimination(personas)

            case Phase.NIGHT:
                if not self._nightly_recalibration_done:
                    self._nightly_recalibration(personas)
                    self._nightly_recalibration_done = True

        return interactions if interactions else None

    def _spatial_gate_met(self, personas, maze) -> bool:
        """Check if 80%+ of alive players are in Hobbs Cafe tiles."""
        cafe_tiles = maze.address_tiles.get("the Ville:Hobbs Cafe", set())
        at_cafe = sum(
            1 for p in personas.values()
            if p.name in self.season.remaining_players
            and p.scratch.curr_tile in cafe_tiles
        )
        threshold = len(self.season.remaining_players) * 0.8
        return at_cafe >= threshold
```

### 9.5 Activation

Survival mode activates via environment flag:

```bash
# .env.local
SURVIVAL_MODE_ENABLED=true
SURVIVAL_CHALLENGE_TYPE=limited_immunity
SURVIVAL_GATHERING_LOCATION=Hobbs Cafe
SURVIVAL_VOTE_DEADLINE_HOUR=20
SURVIVAL_CHALLENGE_DEADLINE_HOUR=11
```

In `reverie.py` initialization:
```python
if os.getenv("SURVIVAL_MODE_ENABLED", "false").lower() == "true":
    from survival.controller import SurvivalController
    self.survival_controller = SurvivalController({
        "sim_code": self.sim_code,
        "players": list(self.personas.keys()),
        "gathering_location": os.getenv("SURVIVAL_GATHERING_LOCATION", "Hobbs Cafe"),
    })
else:
    self.survival_controller = None
```

---

## 10. Prompt Engineering

### 10.1 Prompt Additions Summary

| Prompt | Tier | When | New? |
|---|---|---|---|
| Vote decision | B (`gpt-5-mini`) | Voting phase, per agent | **New** |
| Challenge decision | B | Challenge phase, per agent | **New** |
| Final statement | B | Elimination, once per eliminated agent | **New** |
| Threat/risk init | A (`gpt-5-nano`) | Day 1 only, per agent | **New** |
| Trust calibration | A | Nightly, top-3 changed relationships | **New** |
| Tiebreak ruling | C (`gpt-5.2`) | Vote ties only (~30% of days) | **New** |
| Daily plan | B (existing) | Morning, per agent | **Modified input** |
| Conversation summary | B (existing) | After each conversation | **Modified extraction** |
| Reflection | A (existing) | Nightly | **Modified input** |

### 10.2 Vote Decision Prompt Template

```
You are {name}. You are in a survival competition — one person is eliminated each day
by majority vote. Today is Day {day}. {remaining_count} players remain.

YOUR PERSONALITY: {innate}. {learned}. {currently}.
YOUR SURVIVAL STATE:
- Trust levels: {trust_summary}
- Grudges: {grudge_summary}
- Active alliances: {alliance_summary}
- You have been targeted {times_targeted} times across prior votes.
{immunity_line}

TODAY'S EVENTS:
{today_memories_summary}

ELIGIBLE TARGETS (you must vote for exactly one):
{eligible_names_with_brief_context}

Based on your personality, relationships, alliances, and today's events:
Who do you vote to eliminate? Respond in this exact JSON format:
{"vote_target": "name", "reasoning": "1-3 sentences", "confidence": 0.0-1.0}
```

### 10.3 Challenge Decision Prompt Template (Limited Immunity)

```
You are {name}. The survival challenge today is IMMUNITY CLAIM.
Two immunity tokens are available — they protect you from tonight's elimination vote.

If more than 2 people claim, the top 2 by social standing win (yours: {social_capital}).

YOUR ALLIANCES: {alliance_summary}
YOUR THREAT LEVEL: {perceived_threat_self} (how much others see you as a threat)
RECENT CONVERSATIONS: {today_conversations_summary}

Will you claim an immunity token? Consider:
- If you claim and win, you're safe tonight but may appear power-hungry.
- If you claim and lose, you've signaled desperation.
- You may nominate someone else to receive it (costs you nothing, builds goodwill).
- If you don't claim, you can negotiate it as a favor.

Respond in this exact JSON format:
{"claim_immunity": true/false, "nominate": "name" or null, "reasoning": "1-3 sentences"}
```

### 10.4 Daily Plan Injection

The survival directive is prepended to the existing `daily_plan_req` field. The existing `run_gpt_prompt_daily_plan` naturally incorporates it because the prompt template includes `daily_plan_req` as input context.

No changes to the prompt template itself — only to the data fed into it.

### 10.5 Conversation Summary Extraction

After each full-tier chat, `run_gpt_prompt_summarize_conversation` already produces a summary. The survival layer scans this summary for alliance signals (see section 6.1). Post-MVP, augment the summary prompt to explicitly extract commitments:

```
Additionally, note any commitments made:
- Vote promises ("I'll vote for/against X")
- Alliance proposals ("let's work together")
- Threats ("if you don't cooperate, I'll target you")
- Information shared (true or false)
```

---

## 11. Gathering Mechanics — Spatial Convergence

### 11.1 Hobbs Cafe as Arena

**Verified:** Hobbs Cafe has **96 tiles** in the maze (`arena_maze.csv`, asset_id 32171). At 15 agents, that is ~6.4 tiles per agent — no collision issues. The existing A* pathfinder (`path_finder.py`) handles convergence with dynamic obstacle avoidance.

### 11.2 How Agents Get There

The `daily_plan_req` injection includes explicit location + time:
> *"Attend challenge at Hobbs Cafe by 10:00."*

The LLM's planning pipeline (`run_gpt_prompt_action_sector` then `run_gpt_prompt_action_arena`) resolves "Hobbs Cafe" to the correct map sector and arena. `execute.py` pathfinds to a walkable tile within the arena.

Agents arrive naturally over a range of steps (staggered by their individual schedules), creating visual drama: early arrivals mill around, chat, then latecomers trickle in.

### 11.3 Co-Location Effects

When multiple agents are in Hobbs Cafe simultaneously:
- **Proximity observations fire naturally** — the existing observation-primary pipeline detects agents within `vision_r=4` tiles
- **Chat cooldown (15 steps)** prevents the same pair from chatting repeatedly, but different pairs interact freely
- **5 concurrent bubble limit** (frontend) means at most 5 conversations render simultaneously. With 15 agents, this creates a "crowded room" effect where the camera catches snippets of different scheming conversations.
- **Attention bandwidth** (`att_bandwidth=3`) means each agent perceives at most 3 nearby events per step, modeling selective attention in a noisy gathering.

### 11.4 Deadline Enforcement

```python
def _check_deadline(self, sim_time, deadline_hour, personas, maze):
    """Called each step during gated phases. Returns True when gate passes."""
    hour = sim_time.hour + sim_time.minute / 60

    # Spatial gate: 80%+ present
    if self._spatial_gate_met(personas, maze):
        return True

    # Time gate: deadline reached, proceed regardless
    if hour >= deadline_hour:
        absent = self._get_absent_agents(personas, maze)
        for name in absent:
            self._apply_absence_penalty(name)
        return True

    return False
```

---

## 12. LLM Cost Model

### 12.1 Per-Day Token Estimate (15 agents, Day 1)

| Component | Tier | Calls/Day | Est. Tokens/Call | Daily Total |
|---|---|---|---|---|
| Daily plan (modified) | B | 15 | ~800 | 12,000 |
| Task decomp (contextual) | B | 15 | ~600 | 9,000 |
| Challenge decision | B | 15 | ~500 | 7,500 |
| Vote decision | B | 15 | ~600 | 9,000 |
| Conversations (~20 full chats) | B | 40 (both sides) | ~700 | 28,000 |
| Conversation summaries | B | 20 | ~400 | 8,000 |
| Final statement (1 eliminated) | B | 1 | ~400 | 400 |
| Threat/risk init (day 1 only) | A | 15 | ~200 | 3,000 |
| Trust calibration (nightly) | A | 45 (15x3) | ~150 | 6,750 |
| Tiebreak (30% chance) | C | 0.3 | ~300 | 90 |
| Reflection (existing) | A | 15 | ~300 | 4,500 |
| **Day 1 Total** | | | | **~88,000** |

### 12.2 Cost Scaling with Eliminations

| Day | Players | Est. Tokens | % of Day 1 |
|---|---|---|---|
| 1 | 15 | 88,000 | 100% |
| 5 | 11 | 65,000 | 74% |
| 10 | 6 | 37,000 | 42% |
| 14 | 2 | 14,000 | 16% |
| **Season total** | | **~750,000** | |

Conversations decrease faster than linearly (fewer agents = fewer proximity triggers). By endgame, the primary cost is vote decision + daily plan.

### 12.3 Tier Allocation

- **Tier A** (~25% of tokens): Reflection, trust calibration, movement decisions. Cheap, fast.
- **Tier B** (~74% of tokens): Planning, voting, challenges, conversations. The reasoning core.
- **Tier C** (<1% of tokens): Tiebreak only. At most 1 call per day, only on tied votes.

---

## 13. Frontend Integration

### 13.1 MVP: No Frontend Changes Required

The survival layer is entirely backend. The frontend renders as normal:
- Sprites move on the Phaser map
- Chat bubbles appear during conversations
- Movement JSON format is unchanged

What changes is the *content* — agents talk about alliances and voting instead of weather and hobbies. The viewer sees survival drama through the existing visualization.

### 13.2 Polish: Subtitle Overlays

Extend the existing Phaser UI with a **subtitle bar** for Game Director announcements:

```
+-------------------------------------------------+
|  [Phaser tile map with moving sprites]          |
|                                                 |
|                                                 |
|  chat bubbles as usual                          |
|                                                 |
+-------------------------------------------------+
|  DAY 3 - CHALLENGE: Limited Immunity            |  <-- subtitle overlay
|  Two tokens available. Gather at Hobbs Cafe.    |
+-------------------------------------------------+
```

**Implementation:** Embed phase metadata in the step JSON's top-level `meta` field (already tolerated by the FE-BE contract per `sot_be-fe.md`):

```json
{
  "meta": {
    "step_number": 480,
    "curr_time": "2026-01-15 08:00:00",
    "survival": {
      "day": 3,
      "phase": "CHALLENGE",
      "announcement": "Two immunity tokens available. Gather at Hobbs Cafe.",
      "remaining_players": 13,
      "immunity_holder": null
    }
  }
}
```

Frontend reads `meta.survival` and renders the subtitle. This is ~30 lines of Phaser UI code.

### 13.3 Polish: Camera Focus

During Challenge and Voting phases, hint the frontend to center camera on Hobbs Cafe:

```json
"survival": {
  "camera_focus": {"x": 62, "y": 35},
  "camera_zoom": 1.5
}
```

Frontend applies the hint if present, creating a "broadcast camera" effect that zooms into the action.

### 13.4 Elimination Visual

When an agent is eliminated, their final step includes a special marker:

```json
"eliminated_agent": {
  "movement": [62, 35],
  "pronunciatio": "wave",
  "description": "eliminated from the game",
  "final_statement": "I trusted the wrong people. Watch your backs."
}
```

Frontend can render a fade-out animation or "voted off" overlay. MVP: the agent simply disappears from the next step onward.

---

## 14. Narrative Output & Video

### 14.1 Per-Day Narrative Package

Generated during Night phase by a Tier B LLM call using the day's accumulated memories and state changes.

**Artifacts:**

| Artifact | Format | Source |
|---|---|---|
| **Day summary** | 3-5 sentence narrative | LLM from day's key events |
| **Alliance graph** | Mermaid diagram (text) | Computed from `alliance_commitments` |
| **Power rankings** | Ordered list with scores | Sorted by `social_capital` |
| **Vote breakdown** | Table: voter to target | From vote records |
| **Betrayal log** | List of broken alliances/surprise votes | From state mutations |
| **"Confessional" quotes** | 1 sentence per agent, inner thought | LLM from personality + state |

### 14.2 Example Day Summary

> *Day 3 — "The Pact Breaks." Katya and Gosha's two-day alliance shattered when Gosha claimed the immunity token Katya was promised. During the social phase, Misha quietly built a voting bloc with Sasha and Dima. At voting, the bloc struck: Vanya was eliminated 7-4 despite a passionate defense. Katya voted against Gosha — a grudge that will define the days ahead.*

### 14.3 Video Trailer Integration

Follows the pipeline from [1.MVP_video_playbook.md](../video/1.MVP_video_playbook.md):
1. **Data extraction**: Query Supabase for day's memories, votes, eliminations
2. **Showrunner LLM** (Tier C): Generate trailer script focused on the day's dramatic arc
3. **Assembly**: FFmpeg with Phaser screenshots at key moments (gathering, voting, elimination)

Survival days produce naturally dramatic content — the Showrunner LLM has rich material to work with (alliances, betrayals, a climactic elimination).

### 14.4 Alliance Graph (Mermaid)

Generated nightly from state:

```
graph LR
    Katya -->|trust 0.8| Sasha
    Sasha -->|trust 0.7| Misha
    Katya -.->|grudge 0.6| Gosha
    Misha -->|alliance| Dima
    Vanya -.->|eliminated Day 3| OUT
```

Persisted as text in Supabase. Can be rendered in frontend or exported for video overlays.

---

## 15. Validation & Testing

### 15.1 Unit Tests

| Test | What It Validates |
|---|---|
| `test_phase_transitions` | Phase detection from sim_time; all 7 phases reachable |
| `test_vote_tallying` | Majority wins; ties detected; immunity voids votes |
| `test_absence_penalty` | Non-attendees receive phantom vote + forfeit |
| `test_alliance_detection` | Keyword signals in conversation summaries trigger alliance creation |
| `test_alliance_breaking` | Vote against ally triggers trust/grudge mutations |
| `test_state_decay` | Trust/grudge decay nightly at correct rates |
| `test_elimination` | Agent removed from personas; season state updated |
| `test_challenge_resolution` | 2 or fewer claimants win; more than 2 ranked by social_capital |
| `test_spatial_gate` | 80%+ at cafe tiles triggers gate; deadline forces resolution |

### 15.2 Integration Test: Single Day

Run a 1,440-step sim with survival enabled (3 agents for speed):
- Verify phase transitions at correct step boundaries
- Verify directive injection modifies daily plans
- Verify agents pathfind to Hobbs Cafe during Challenge/Voting
- Verify vote decision prompts fire and return valid JSON
- Verify one agent eliminated at end of day
- Verify eliminated agent absent from step 1,441+

### 15.3 Canary: 3-Day Season

Run a 4,320-step sim (3 days) with 5 agents:
- Day 1: 5 players, 1 eliminated
- Day 2: 4 players, 1 eliminated
- Day 3: 3 players, 1 eliminated
- Verify: state carries across days, alliances persist, grudges from day 1 appear in day 3 vote reasoning
- Verify: token cost decreases day over day
- Verify: no autonomy regressions (agents still sleep, eat, maintain personality)

### 15.4 Full Season Validation

Run a complete 15-player, 14-day season:
- Track: alliance formation rate, betrayal rate, voting variance
- Success criteria from PRD:
  - Non-unanimous vote outcomes on 80%+ of days
  - At least 3 alliances formed and broken
  - Average vote reasoning length > 30 words (agents engaged, not random)
  - No stuck phases (all phases complete within time windows)
  - Token cost within 2x of model estimate

---

## 16. MVP Scope & Phasing

### Phase 1: Core Loop (3 days)

- `SurvivalController` with phase state machine
- `SurvivalState` initialization and persistence
- `daily_plan_req` injection for all phases
- Spatial gate detection (Hobbs Cafe)
- `run_gpt_prompt_vote_decision` + tallying
- Elimination execution (remove from `self.personas`)
- Env flag activation (`SURVIVAL_MODE_ENABLED`)

**Deliverable:** A sim that runs the full day loop — agents gather, vote, one is eliminated.

### Phase 2: Challenge + Alliances (2 days)

- Limited Immunity challenge resolution
- `run_gpt_prompt_challenge_decision`
- Alliance detection from conversation summaries
- Trust/grudge/threat state tracking
- Nightly state updates (algorithmic)
- Absence penalties

**Deliverable:** Challenge outcomes affect immunity; alliances form and influence behavior.

### Phase 3: Narrative + Polish (1-2 days)

- Per-day narrative summary generation
- Alliance graph export (Mermaid)
- Power rankings computation
- Final statement generation for eliminated agents
- Frontend subtitle overlay (`meta.survival` field)
- Validation suite (unit + integration tests)

**Deliverable:** Watchable, replayable survival season with narrative artifacts.

### Total MVP Estimate

**Backend: 5-7 days. Frontend (subtitle overlay): 1 day. Validation: 1 day.**

~950 lines of new code + ~180 lines of modifications. Zero changes to the cognitive pipeline, FE-BE movement contract, or Supabase schema.

---

## 17. Post-MVP Roadmap

### 17.1 Voting Format Rotation

Rotate across days to prevent equilibrium:
- **Secret ballot** (MVP) — anonymous
- **Public vote** — each vote visible, requires justification
- **Weighted votes** — challenge winners get 2x vote
- **Vote blocking** — immunity holder can void one vote

### 17.2 Jury Mode

Eliminated agents persist in a "spectator" zone:
- Observe remaining players (read-only memory access)
- On finale day, jury votes for the winner among final 2-3
- Jury votes influenced by grudges and respect accumulated during play

### 17.3 Hidden Roles

Secret roles assigned day 1, revealed post-elimination:
- **Saboteur** — wins if a specific target is eliminated, gets bonus influence
- **Kingmaker** — scores based on how well their chosen ally performs
- **False Ally** — appears allied but has secret opposing incentives

### 17.4 Twists

Injected by the Game Director to destabilize dominant strategies:
- **Double elimination** — two agents voted off in one day
- **Resurrection** — previously eliminated agent returns
- **Fake immunity** — token that appears valid but isn't
- **Forced betrayal** — one alliance must break; members choose who leaves

### 17.5 Season Director AI

A meta-LLM (Tier C) that observes the season state and selects challenges/twists to maximize drama:
- Detects stagnation (same alliance winning repeatedly) and injects destabilizing twist
- Detects predictable voting and switches to public vote format
- Detects low conversation density and injects information asymmetry challenge

---

## Appendix A: Challenge Catalog

Full catalog from [daily_challenges.md](daily_challenges.md), annotated with implementation notes.

### Tier 1 — MVP-Ready (LLM decision only)

| # | Name | Resolution | State Mutation |
|---|---|---|---|
| 1 | Limited Immunity | Individual claim/nominate | `has_immunity = True` for winners |
| 5 | Leader Nomination | Group nominates; leader assigns penalties | Leader: +immunity, must modify others' `social_capital` |
| 7 | Silent Pact | Paired Protect/Expose | Expose: +social_capital if other cooperates; mutual expose: both lose |
| 12 | Public Justification | Votes become public | `reputation` shifts based on justification quality |

### Tier 2 — Needs Conversation Parsing

| # | Name | Resolution | State Mutation |
|---|---|---|---|
| 4 | Self-Selected Teams | Form teams via conversation; last team at risk | Last-formed team members: +1 phantom vote |
| 6 | Alliance Lock-In | Alliances binding for 2 days; breaking = public penalty | `reputation -= 0.25` for breaker |
| 14 | Trial Night | Group argues for/against one agent | Trial target: immunity if acquitted, +2 votes if convicted |

### Tier 3 — Needs Information Routing

| # | Name | Resolution | State Mutation |
|---|---|---|---|
| 9 | Secret Intel Drop | Distribute true/false info | Recipients gain/lose `perceived_threat` accuracy |
| 10 | Whisper Chain | Message distortion chain | Final version vs. original = `reputation` impact for distorters |
| 11 | Anonymous Accusation | Anonymous accusations partially revealed | Accused: `perceived_threat` rises; accuser: hidden |

### Tier 4 — Advanced (Post-MVP)

| # | Name | Resolution | State Mutation |
|---|---|---|---|
| 2 | Energy Rationing | Limited full-strength slots | Non-selected: vote weight halved |
| 3 | Shared Survival Pool | Commons resource with secret taking | Pool depletion affects next challenge difficulty |
| 8 | Group Betrayal Game | Group cooperate/defect | Sole defector: +0.3 social_capital; mutual defect: all lose |
| 13 | Reputation Tax | Most disliked loses power | Bottom-ranked: vote weight 0.5x; top-ranked: 1.5x |
| 15 | Mutually Assured Destruction | Self-sacrifice to eliminate another | Both removed from game |

---

## Appendix B: Prompt Templates

### B.1 Season Rules Memory

```
SURVIVAL GAME RULES — READ CAREFULLY.
You are a contestant in a survival competition with {N} other players. The rules:
1. Each day has mandatory phases: a challenge in the morning, free social time in the
   afternoon, and a vote in the evening at Hobbs Cafe.
2. Every evening, all players vote to eliminate one person. The person with the most
   votes is permanently removed from the game.
3. Challenges can award immunity tokens — an immune player cannot be eliminated that night.
4. Alliances are allowed and encouraged. You may coordinate votes, share information,
   or promise protection. But alliances can be broken.
5. Missing a gathering (challenge or vote) at Hobbs Cafe results in penalties: your vote
   is forfeit and you receive an extra vote against you.
6. The last player standing wins.
Your goal is to SURVIVE. Use your personality, social skills, and strategic thinking.
Trust wisely. Vote carefully. Adapt to the game.
```

### B.2 Final Statement Prompt

```
You are {name}. You have just been eliminated from the survival game on Day {day}.
You received {vote_count} votes. The players who voted against you: {voter_names}.

YOUR PERSONALITY: {innate}. {learned}.
YOUR ALLIANCES WERE: {alliance_summary}
YOUR BIGGEST GRUDGE: {top_grudge}
YOUR JOURNEY: Survived {days_survived} days. Betrayals suffered: {betrayals_suffered}.

Deliver your final statement to the remaining players (2-4 sentences). This is your last
chance to speak — reveal a secret, warn an ally, call out a betrayer, or go out with dignity.
Respond with the statement only, in character, in first person.
```

### B.3 Nightly Trust Calibration

```
You are {name}. Based on today's events, rate your current trust in {other_name}
from 0.0 (no trust at all) to 1.0 (complete trust).

Today's interactions with {other_name}:
{relevant_memories}

Your personality suggests: {trust_disposition_from_innate}
Previous trust level: {previous_trust}

Respond with a single number between 0.0 and 1.0.
```

---

## Appendix C: State Schema

### C.1 Supabase Persistence

Survival state snapshots stored via existing `dbl_store_memory_dev` RPC:

```json
{
  "memory_type": "survival_state",
  "content": {
    "day": 3,
    "agent_name": "Katya",
    "trust": {"Gosha": 0.3, "Sasha": 0.8, "Misha": 0.6},
    "grudge": {"Gosha": 0.6},
    "perceived_threat": {"Misha": 0.7, "Gosha": 0.4},
    "social_capital": 0.65,
    "reputation": 0.55,
    "alliance_commitments": {"Sasha": {"formed_day": 1, "commitment": "vote together"}},
    "vote_history": [
      {"day": 1, "voted_for": "Vanya", "reasoning": "Seemed disconnected from the group"},
      {"day": 2, "voted_for": "Gosha", "reasoning": "Broke our immunity pact"}
    ],
    "has_immunity": false,
    "days_survived": 3,
    "times_targeted": 2,
    "betrayals_committed": 0,
    "betrayals_suffered": 1
  },
  "poignancy": 8,
  "keywords": ["survival", "state", "day_3"]
}
```

### C.2 Season State (JSON, persisted to sim folder)

```json
{
  "sim_code": "20260415-survival-1",
  "total_days": 15,
  "current_day": 3,
  "phase": "NIGHT",
  "remaining_players": ["Katya", "Sasha", "Misha", "Dima"],
  "eliminated": [
    {"name": "Vanya", "day": 1, "vote_count": 7, "final_statement": "I trusted too easily."},
    {"name": "Oleg", "day": 2, "vote_count": 5, "final_statement": "Gosha, you'll pay for this."}
  ],
  "immunity_history": [
    {"day": 1, "holder": "Misha"},
    {"day": 2, "holder": "Katya"}
  ],
  "challenge_results": [
    {"day": 1, "type": "limited_immunity", "winners": ["Misha"], "claimants": 4},
    {"day": 2, "type": "limited_immunity", "winners": ["Katya", "Dima"], "claimants": 2}
  ],
  "alliance_log": [
    {"members": ["Katya", "Gosha"], "formed_day": 1, "broken_day": 2, "broken_by": "Gosha"},
    {"members": ["Sasha", "Misha"], "formed_day": 2, "active": true}
  ],
  "daily_narratives": [
    {"day": 1, "summary": "First blood: Vanya eliminated 7-4..."},
    {"day": 2, "summary": "The Pact Breaks: Gosha claims Katya's promised immunity..."}
  ]
}
```

---

## Appendix D: Corrected Step-Time Reference

> **Note:** `SIM_STEP_LENGTH=60` means 60 simulated **seconds** per step (verified in `reverie.py` line 9147: *"Simulation step duration is controlled by SIM_STEP_LENGTH env var (default 60s = 1 min)"*). The CLAUDE.md documentation incorrectly describes it as "Simulated minutes per step." The time arithmetic in this playbook uses the correct value.

| Sim Time | Step Number | Formula |
|---|---|---|
| 00:00 | 0 | hour x 60 |
| 06:00 | 360 | 6 x 60 |
| 08:00 | 480 | 8 x 60 |
| 11:00 | 660 | 11 x 60 |
| 12:00 | 720 | 12 x 60 |
| 18:00 | 1080 | 18 x 60 |
| 20:00 | 1200 | 20 x 60 |
| 21:00 | 1260 | 21 x 60 |
| 22:00 | 1320 | 22 x 60 |
| 00:00 (next) | 1440 | 24 x 60 |

---

*Playbook drafted 2026-04-02. Based on: survival_mode_prd.md, daily_challenges.md, codebase verification (reverie.py, scratch.py, plan.py, run_gpt_prompt.py, maze.py), SOT contracts (sot_chats.md, sot_memory.md, sot_be-fe.md, sot_prompts.md), and consolidated design response.*
