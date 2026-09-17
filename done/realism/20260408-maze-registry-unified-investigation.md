# Unified Investigation: `maze_registry.json` as the Central Piece for Behavior Control

**Date:** 2026-04-08  
**Author:** Nicolas de Maria  
**Branch:** nicolas  
**Type:** Deep investigation (read-only, no code changes)  
**Sources:** Two independent research documents (Doc 1: encyclopedic-academic, Doc 2: engineering-critical), unified without loss of information.

---

## Table of Contents

1. [Context and Motivation](#1-context-and-motivation)  
2. [Current State of the Registry](#2-current-state-of-the-registry)  
3. [Consumers in the Cognitive Pipeline](#3-consumers-in-the-cognitive-pipeline)  
4. [State of the Art — Academic Papers](#4-state-of-the-art--academic-papers)  
5. [Precedents in Game Design](#5-precedents-in-game-design)  
6. [Technical Feasibility](#6-technical-feasibility)  
7. [Trade-offs](#7-trade-offs)  
8. [Optimal Schema Design](#8-optimal-schema-design)  
9. [Alternatives to the Monolithic JSON](#9-alternatives-to-the-monolithic-json)  
10. [The Maximalist JSON — Proposed Fields](#10-the-maximalist-json--proposed-fields)  
11. [Complete Example: Hobbs Cafe](#11-complete-example-hobbs-cafe)  
12. [Recommended Roadmap](#12-recommended-roadmap)  
13. [Final Verdict](#13-final-verdict)  

---

## 1. Context and Motivation

### What is this project

Social simulation engine where people (LLM agents) perceive, plan, move, and converse in a tile-based world (the Ville). Each agent's cognitive cycle is: **perceive -> retrieve -> plan -> execute -> (converse) -> reflect**.

### What is maze_registry.json

A JSON file generated from CSVs (`scripts/generate_maze_registry.py`) that describes the complete map: 19 sectors, 63 arenas, 225 objects, 14 activity types. Each arena has metadata like `atmosphere`, `proximity_mod`, `cooldown_mod`. Objects have `type` and `interaction`.

- **File:** `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`  
- **Size:** 1732 lines  
- **Generated:** 2026-04-06T21:57:17.506479+00:00  

The file has already proven transformational: it replaced ~500 lines of regex/pattern matching and is the basis for LocationResolver V2 (the location resolution system).

### The Idea

Take `maze_registry.json` to the extreme: make it the central piece that controls HOW agents interact with the world. Not just "what's here" but "what happens when you're here", "how long you should stay here", and "how being here affects you".

Concrete examples of what the JSON could declare:  
- **Duration per object/arena**: shower max 4 steps, desk default 20 steps, park_bench [5, 15]  
- **Personality modifiers**: desk + trait "lazy" -> duration -5 steps  
- **Affordances**: piano declares ["play", "practice", "perform"] -> the LLM can only choose these  
- **Social rules per arena**: library max_volume="whisper", pub social_bonus=+2  
- **Temporal flows**: cafe morning={quiet, low_crowd}, noon={lively, high_crowd}  

### Thesis

1. The idea is conceptually strong and aligns with two real traditions: affordance theory and the line of multi-agent systems research that treats the environment as a first-level abstraction.  
2. In this repo, the extension is technically feasible, but not naively. The jump from "place metadata" to "declarative behavior control" demands new layers of typing, validation, inheritance, rule evaluation, and observability.  
3. The best path is not a flat monolithic JSON, but a hierarchical registry with defaults, archetypes, temporal overlays, trait modifiers, and a Python runtime evaluator.  
4. The most serious bottleneck is not the map but personality: today agent traits do not exist as a structured taxonomy, so `trait modifiers` are not plug-and-play.  

### Methodology

The investigation combined four fronts:  

1. Direct inspection of the local repo.  
2. Reading the current `maze_registry.json` and its main consumers.  
3. Reading adjacent modules in the cognitive pipeline to locate real insertion points.  
4. Search for academic literature and comparable real systems.  

Local files inspected with the most impact on the analysis:  

- `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`  
- `reverie/backend_server/maze.py`  
- `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`  
- `reverie/backend_server/persona/cognitive_modules/location_resolver.py`  
- `reverie/backend_server/persona/cognitive_modules/location_helpers.py`  
- `reverie/backend_server/persona/cognitive_modules/plan.py`  
- `reverie/backend_server/persona/cognitive_modules/execute.py`  
- `reverie/backend_server/persona/cognitive_modules/perceive.py`  
- `reverie/backend_server/persona/memory_structures/scratch.py`  
- `reverie/backend_server/persona/persona.py`  
- `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt`  
- `reverie/backend_server/persona/prompt_template/v2/generate_conversation_batch_v1.txt`  
- `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`  
- `tests/test_maze_registry.py`  

---

## 2. Current State of the Registry

### 2.1 General Structure (meta)

```json
{
  "meta": {
    "maze_name": "the Ville",
    "world": "the Ville",
    "width": 140,
    "height": 100,
    "tile_size": 32,
    "generated_from": "CSVs",
    "generated_at": "2026-04-06T21:57:17.506479+00:00"
  },
  "sectors": { ... }
}
```

### 2.2 Current Metrics

| Metric | Value |
| --- | --- |
| Sectors | 19 |
| Arenas | 63 |
| Objects | 225 |
| Normalized Activity Types | 14 |

The 14 `activity_type` derived from object interactions:  

`art`, `cook`, `eat`, `exercise`, `hygiene`, `play`, `relax`, `serve`, `shop`, `sleep`, `social`, `storage`, `study`, `work`  

### 2.3 Sectors (19 total)

Types: residential (13), commercial (4), educational (1), recreation (1).  

Fields per sector:  
- `type`: Identifies category (residential, commercial, educational, recreation)  
- `arenas`: Nested object with arena definitions  

### 2.4 Arenas (63 total)

```json
{
  "type": "private_room|shared|public",
  "access": "assigned|sector|sector_gendered|public",
  "gender": null,
  "atmosphere": "casual|private|social|relaxed|busy|lively|focused|transient|quiet",
  "proximity_mod": -1|0|1,
  "cooldown_mod": -2|-1|0|2|3,
  "tile_count": 6-224,
  "objects": { ... }
}
```

**Distribution of arena types:**  
- private_room: 28  
- shared: 27  
- public: 8  

**Distribution of atmosphere:**  
- casual: 18  
- private: 28  
- social: 5  
- relaxed: 5  
- busy: 2  
- lively: 2  
- focused: 1  
- transient: 1  
- quiet: 1  

**Distribution of proximity_mod:**  
- -1 (private spaces, hard to start chat): 30 arenas  
- 0 (neutral): 19 arenas  
- +1 (social spaces, easy to start chat): 14 arenas  

**Distribution of cooldown_mod:**  
- -2 (very short cooldown, many chats): 7 arenas  
- -1 (short cooldown): 25 arenas  
- 0 (neutral): 1 arena  
- +2 (long cooldown): 2 arenas  
- +3 (very long cooldown, few chats): 28 arenas  

**Observed Patterns:**  
- Private rooms: proximity_mod=-1, cooldown_mod=+3 (hard to start, long between chats)  
- Shared spaces (bathrooms): proximity_mod=0, cooldown_mod=-1 (neutral, quick recovery)  
- Social spaces (common rooms): proximity_mod=+1, cooldown_mod=-2 (easy to start, quick recovery)  
- Atmosphere encodes soft place norms: `private`, `casual`, `social`, `relaxed`, `lively`, `focused`, `quiet`, `transient`, `busy`.  
- Social tuning pattern is coherent: private tends to lower proximity and raise cooldown; lively/social does the opposite.  

### 2.5 Objects (225 total)

```json
{
  "type": "fixture|furniture|instrument|appliance|equipment|outdoor|workspace|seating",
  "interaction": "hygiene|sleep|storage|work|play|cook|study|exercise|social|relax|eat|serve|shop|art"
}
```

The `interaction` field can be a string or an array of strings.  

**Distribution of interaction types:**  
- hygiene: 54  
- cook: 43  
- storage: 33  
- sleep: 23  
- work: 20  
- relax: 12  
- social: 11  
- play: 10  
- study: 8  
- eat: 7  
- shop: 6  
- serve: 5  
- art: 3  
- exercise: 1  

Most objects are `furniture` or `fixture`, and nearly all have a single declared interaction; 11 objects accept lists of interactions.  

### 2.6 Current Example: Hobbs Cafe

The `Hobbs Cafe` case confirms that the registry already acts as local behavior policy:  

- In `maze_registry.json:593` the sector block begins.  
- In `maze_registry.json:596` the `cafe` arena appears.  
- That arena declares `atmosphere`, `proximity_mod`, `cooldown_mod`, `tile_count` and a set of objects with interactions.  
- Relevant objects: `behind the cafe counter` -> `serve`, `cafe customer seating` -> `eat` and `social`, `cooking area` -> `cook`, `kitchen sink` -> `cook`, `piano` -> `play` and `social`, `refrigerator` -> `cook`.  

**Conclusion:** Even before the maximalist redesign, Hobbs Cafe is no longer just a spatial box; it is a semantic node that affects where to go, what can be done, and how easily conversation occurs. The file is no longer just topology — it already contains compressed behavioral semantics.  

---

## 3. Consumers in the Cognitive Pipeline

### 3.1 maze.py — Loading, Flattening, and Public API

**File:** `reverie/backend_server/maze.py`  

**Loading Function:** `_load_registry()` (lines 911-991)  

**Loading Process:**  
1. Path resolution (lines 913-915): looks for `maze_registry.json` relative to `env_matrix`  
2. JSON parsing (lines 917-927): file must exist, invalid JSON raises ValueError  
3. Index building (lines 929-964):  
   - `sector_meta` dict: keys are "world:sector" addresses, values: `{label, type}`  
   - `arena_meta` dict: keys are "world:sector:arena" addresses, values: `{label, type, access, gender, atmosphere, proximity_mod, cooldown_mod, tile_count}`  
   - `object_meta` dict: keys are "world:sector:arena:object" addresses, values: `{label, type, interaction}` (interaction normalized to list)  
4. Validation (lines 968-971): cross-check that registry keys exist in `address_tiles`  
5. Derived index (lines 974-978): `valid_activity_types` = set of all interaction types  

Additional flattening facts:  
- `maze.py:903-909` normalizes `interaction` to list, so runtime already tolerates multiple affordances per object.  
- `maze.py:946-955` currently preserves in arenas only `type`, `access`, `gender`, `atmosphere`, `proximity_mod`, `cooldown_mod`, `tile_count`.  
- `maze.py:960-964` currently preserves in objects only `type` and `interaction`.  
- `maze.py:973-978` derives `valid_activity_types` automatically from object interactions.  
- `maze.py:1037-1045` resolves `find_arenas_with_interaction`, which is the piece that currently connects declared affordance with location choice.  

**Public Accessors (all in maze.py):**  

| Line | Function | Returns | Field |
| --- | --- | --- | --- |
| 993-996 | `get_sector_type(addr)` | str\|None | sector_meta["type"] |
| 998-1001 | `get_arena_type(addr)` | str\|None | arena_meta["type"] |
| 1003-1006 | `get_arena_gender(addr)` | str\|None | arena_meta["gender"] |
| 1008-1011 | `get_arena_access(addr)` | str\|None | arena_meta["access"] |
| 1013-1016 | `get_arena_atmosphere(addr)` | str (default "neutral") | arena_meta["atmosphere"] |
| 1018-1021 | `get_arena_proximity_mod(addr)` | int (default 0) | arena_meta["proximity_mod"] |
| 1023-1026 | `get_arena_cooldown_mod(addr)` | int (default 0) | arena_meta["cooldown_mod"] |
| 1028-1031 | `get_object_interaction(addr)` | list\|[] | object_meta["interaction"] |
| 1033-1035 | `find_arenas_by_type(arena_type)` | List[addr] | arena_meta filtered |
| 1037-1043 | `find_arenas_with_interaction(interaction)` | List[addr] | object_meta filtered |

**Key Design:** All consumers access data via public accessors. No module accesses the registry dict directly. This makes extension trivial: add field = add accessor.  

**Critical Reading:** The current structure greatly facilitates extension because there is already a central ingest/normalization step. If tomorrow the JSON adds `duration_policy`, `social_rules`, `emotional_effects` or `trait_modifiers`, the right place to incorporate them is the same flattening.  

### 3.2 conversation_manager.py — The Richest Consumer

**File:** `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`  

The registry already regulates local sociability.  

**Data Structure:**  
```python
@dataclass
class ConversationContext:
    atmosphere: str = "neutral"        # line 1131
    proximity_mod: int = 0             # line 1132
    cooldown_mod: int = 0              # line 1133
```

**Integration Points:**  

1. **Context Building** (lines 1119-1134):  
   - `_build_conversation_context()` extracts the shared arena from both agents  
   - Retrieves three fields from the registry:  
     ```python
     atmosphere = maze.get_arena_atmosphere(shared_arena_addr)
     proximity_mod = maze.get_arena_proximity_mod(shared_arena_addr)
     cooldown_mod = maze.get_arena_cooldown_mod(shared_arena_addr)
     ```

2. **Cooldown Computation** (lines 528-536):  
   - Function: `classify_chat_tier()`  
   - If `cool_mod < 0`: reduce cooldown_steps -> `max(1, cooldown_steps + cool_mod)`  
   - If `cool_mod > 0`: add to cooldown_steps  
   - Example: modifier=-1 reduces cooldown by 1 step; modifier=+3 adds 3 steps  

3. **Elastic Proximity Threshold** (lines 1287-1302):  
   - Function: `_get_elastic_threshold()`  
   - Formula: `max(1, base_tiles + proximity_mod) + 1`  
   - base_tiles = CONVERSATION_CONFIG = 3  
   - proximity_mod=-1 -> effective base 2; +1 -> effective base 4  

4. **Chat Initiation Distance** (lines 1358-1387):  
   - Function: `_compute_initiation_distance()`  
   - Gets current arena from agent's curr_tile  
   - Formula: `max(1, 3 + proximity_mod)`  

5. **Atmosphere in Prompt** (line 213-214): inserts `atmosphere` directly into the conversation prompt.  

6. **Conversation Prompt** translates metadata to conversational style:  
   - `reverie/backend_server/persona/prompt_template/v2/generate_conversation_batch_v1.txt:40-45` defines how the chat should sound if the place is `quiet`, `lively`, `focused`, `relaxed` or `private`.  

**Impact on Behavior:**  
- Social spaces (common room): prox=+1, cool=-2 -> easy to chat, quick recovery  
- Private rooms: prox=-1, cool=+3 -> hard to start, long between chats  
- Casual shared spaces: prox=0, cool=-1 -> neutral, faster recovery  

**Interpretation:** The project has already proven that "the place speaks". It still does so with a minimal surface, but the principle is demonstrated.  

**Could be Extended For:**  
- `max_volume`  
- `max_group_size`  
- `conversation_type_cap`  
- `group_conversation_allowed`  
- `interruption_risk`  
- `privacy_level`  
- `social_bonus`  
- `normative_topics`  

### 3.3 location_resolver.py — Semantic Source of Truth (but with Untapped Surface)

**File:** `reverie/backend_server/persona/cognitive_modules/location_resolver.py`  

It is currently the strongest example of the paradigm shift.  

**Rich Integration Points:**  

- `location_resolver.py:556-617` builds a tree filtered by privacy and gender using registry metadata.  
- `location_resolver.py:588-595` filters arenas by `gender`.  
- `location_resolver.py:836-842` chooses object based on whether its `interaction` contains the `activity_type`.  
- `location_resolver.py:937-1008` chooses arena using a composite score of anchor, distance, crowding, home, and recency.  
- `location_resolver.py:1011-1037` can infer `activity_type` from text, but the valid vocabulary still comes from the registry.  
- `location_resolver.py:1040-1095` implements the deterministic guard v2: if it knows the `activity_type`, it looks for arenas that have some object whose affordance supports it.  
- `location_resolver.py:1320-1438` integrates this into the full resolution, repair, compatibility, validation, and fallback pipeline.  

**Basic Integration Points:**  

- `location_resolver.py:166, 274, 288, 441, 474`: checks `if candidate in maze.address_tiles`  
- `location_resolver.py:328-340`: `_candidate_addresses_for_typed_grounding()` iterates `maze.address_tiles.keys()`  
- `location_resolver.py:271`: calls `_is_private_room(arena, maze, sector_addr)` which uses `maze.get_arena_type()`  

**Important Note:** location_resolver does NOT consume atmosphere, proximity_mod, or cooldown_mod. It only uses `address_tiles` and `get_arena_type()`. This is a huge untapped surface.  

**Critical Reading:** The registry already governs WHERE an action can occur. The next natural step is that it also governs HOW, HOW LONG, WITH WHAT SOCIAL PROBABILITY, WITH WHAT TONE, WITH WHAT COST, and WITH WHAT EMOTIONAL EFFECT.  

### 3.4 location_helpers.py — Space Classification

**File:** `reverie/backend_server/persona/cognitive_modules/location_helpers.py`  

**Functions:**  

1. `_is_private_room` (lines 152-155): `maze.get_arena_type(arena_addr) == "private_room"`  
2. `_is_private_sector` (lines 158-161): `maze.get_sector_type(sector_addr) == "residential"`  
3. `_get_arena_object_names` (lines 218-225): iterates `maze.object_meta` to extract object names in an arena  

**Fields Used:** type (arena and sector), object_meta keys  

### 3.5 plan.py — The LLM Still Decides Too Many Things

**File:** `reverie/backend_server/persona/cognitive_modules/plan.py`  

Uses the registry, but partially.  

**Current Integration Points:**  

- `plan.py:681-767` validates subactivities and requires `duration_min`, `anchor`, `mode` and `activity_type`.  
- `plan.py:745-756` normalizes `social_probability`, but no strong downstream usage like `activity_type` is observed.  
- `plan.py:1800-1822` builds subplans from `duration_min` with synthetic labels; no object-specific semantics.  
- `plan.py:2517-2524` passes `valid_activity_types` to the decomposition prompt.  
- `plan.py:2539-2548` does the same in the repair prompt.  
- `plan.py:3329-3335` invokes `resolve_location(... activity_type=_act_activity_type)`.  
- `plan.py:3404-3406` writes `act_duration`, `act_description` and `act_address` to scratch.  
- `plan.py:4313-4350` uses `act_check_finished()` and, if appropriate, a global extension via `P2_ACTION_EXTENSION_MIN`.  

**Basic Integration Points (only address validation):**  
- Lines 1179, 1184, 1033, 1206, 1580: checks `if candidate in maze.address_tiles`  
- Lines 2128-2139: `maze.address_tiles.get(address, set())`  
- Lines 2214-2228: `maze.get_tile_for_address()`, `maze.pick_up_object()`, `maze.put_down_object()`  

**Important Note:** plan.py does NOT consume atmosphere or modifiers. It only uses the registry as an address validator. This is a huge untapped surface.  

The prompt confirms the current cognitive load still left to the LLM:  

- `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt:19` reminds the model that movement consumes time.  
- `...:31-39` requires it to invent a sequence with exact `duration_min` and exact sum.  
- `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py:989-1070` builds that prompt with the `valid_activity_types` derived from the registry.  

**This is important because it points exactly to what a maximalist registry would gain:** today the LLM not only decides objective and description; it also decides durations, which is one of the most fragile and expensive pieces.  

### 3.6 execute.py — Exact Point to Plug in Declarative Durations and Rich Affordances

**File:** `reverie/backend_server/persona/cognitive_modules/execute.py`  

- `execute.py:1493-1558` distinguishes between `in_place`, `zone_patrol`, `workstation_hop` and `social_touch`.  

An enriched registry could decide not only the duration of a `desk`, but also:  
- target seat selection  
- queueing behavior  
- path preference  
- movement pattern inside target zone  
- occupancy and capacity limits  
- workstation alternation  
- the micro-movement pattern within the area  
- seat choice  
- queue usage  
- hopping between stations or sticking to the anchor  

### 3.7 scratch.py — Action Lifecycle

**File:** `reverie/backend_server/persona/memory_structures/scratch.py`  

`scratch.py:982-1094` contains the single source of truth for an action's lifecycle.  

Facts:  
- `scratch.py:986-988` explicitly defines that the timer runs from arrival at the destination.  
- `scratch.py:1042-1044` if no `act_duration`, uses default 30 minutes.  
- `scratch.py:1075-1094` determines completion by comparing `curr_time` with `act_arrival_time + act_duration`.  

This makes the idea of declarative durations extremely viable: no need to reinvent the lifecycle. Need to decide better the value of `act_duration`.  

### 3.8 perceive.py, retrieve.py, reflect.py — Untapped Cognitive Surface

The main cognitive sequence is in `persona.py:477-493`:  

1. `perceive`  
2. `retrieve`  
3. `plan`  
4. `reflect`  
5. `execute`  

But:  

- `perceive.py:84-147` only uses local geometry, visibility, and events in the same arena. Does not use registry semantics.  
- `retrieve.py` does not consume spatial metadata from the registry.  
- `reflect.py` also does not integrate place rules or spatial aftereffects.  

**This is not a problem; it is an opportunity.** It means `maze_registry.json` still has a lot of cognitive surface to colonize.  

**perceive** could use registry for:  
- visibility by lighting  
- salience by noise/crowding  
- filtering by physical barriers  
- auditory limit between arenas  
- selective perception by relevant affordance  
- `social_rules` (can I talk here? at what volume?)  

**retrieve** could use registry for:  
- weigh memories associated with the same type of space  
- activate memories of previous experiences in socially equivalent spaces  
- use place `emotional_signature` as memory cue  
- atmosphere as context to retrieve relevant memories  

**reflect** could use:  
- spatial aftereffects emotional  
- place residual memory  
- spatial reputation or tension  
- attachment or avoidance of places  
- `inspiration_chance` (insight probability)  

### 3.9 Data Flow Diagram

```
maze_registry.json (file)
    |
    v
maze.py._load_registry()
    |
    +---> sector_meta dict
    +---> arena_meta dict (atmosphere, proximity_mod, cooldown_mod)
    +---> object_meta dict (interaction types)
    |
    v
Accessor Functions (public API):
    |
    +---> get_sector_type() -----------> location_helpers._is_private_sector()
    +---> get_arena_type() ------------> location_helpers._is_private_room()
    +---> get_arena_access() ----------> (not actively consumed)
    +---> get_arena_atmosphere() ------> conversation_manager.ConversationContext
    +---> get_arena_proximity_mod() ---> conversation_manager._get_elastic_threshold()
    |                                    conversation_manager._compute_initiation_distance()
    +---> get_arena_cooldown_mod() ----> conversation_manager.classify_chat_tier()
    +---> get_object_interaction() ----> (available but little consumed)
    +---> find_arenas_by_type() -------> (available)
    +---> find_arenas_with_interaction() -> (available)
```

**Summary of Consumers by Module:**  

```
perceive   --> affordances (what can I do here)
               social_rules (can I talk here? at what volume?)

retrieve   --> no direct change (memory is agent's, not world's)
               possible: atmosphere as context to retrieve relevant memories

plan       --> duration_range (how long each action lasts)
               affordances (constrains LLM options)
               trait_modifiers (personality modifies duration/options)
               MAJOR IMPACT: today LLM generates freely

execute    --> duration_range (how many steps)
               interaction_spot (interaction tile)
               MAJOR IMPACT: today LLM decides duration without restriction

converse   --> social_rules (already partially implemented)
               atmosphere (already implemented)
               proximity_mod, cooldown_mod (already implemented)

reflect    --> emotional_impact (how being here affected me)
               possible: inspiration_chance (insight probability)
```

**Plan and Execute are the highest impact.** Currently the LLM generates durations without restriction. With `duration_range`, the prompt can include "shower: 2-4 steps" as constraint, and the LLM operates within it.  

### 3.10 Existing Tests and Symptoms of Drift

**Tests:**  
- `test_maze_registry.py` (275 lines): full test of all accessors, modifier ranges, defaults  
- `test_conversation_manager.py`: test of ConversationContext with registry modifiers  
- `test_location_resolver.py`: test of address validation against registry  
- `test_cooldown_unification.py`: test of cooldown modifier application  

**Important Drift Finding:**  

- `tests/test_maze_registry.py:465-490` expects `get_object_interaction()` to return a string (`"sleep"`, `"work"`, `"cook"`).  
- `maze.py:1028-1031` already returns lists (`["sleep"]`, `["work"]`, etc.).  
- `tests/test_maze_registry.py:540-568` expects `None` for unknown object.  
- `maze.py:1031` today returns `[]` for unknown object.  

**Interpretation:** Even with the current schema, the project is already brushing the limit where registry evolution starts to misalign with tests and implicit expectations. Expanding the file without a formal contract would increase that problem.  

---

## 4. State of the Art — Academic Papers

The underlying question is not just whether "it can be done" in this repo. It is also whether there is a serious tradition that justifies treating the environment as a regulator of behavior. The answer is yes, from **four distinct traditions**.  

### 4.1 Theoretical Base: Affordances

#### James J. Gibson (1979)

- **Title:** *The Ecological Approach to Visual Perception*  
- **Author:** James J. Gibson  
- **Year:** 1979  
- **Contribution:** Introduces the idea of affordance as the possibility of action offered by the environment to the organism. It is not a purely objective property of the object nor purely subjective of the agent; it is relational.  

Relevance to this project:  
- A `piano` is not "just" a piano; it offers different possibilities to different agents.  
- A `desk` offers `work` to almost anyone, but not with the same value or duration to all.  
- This formally justifies a `maze_registry.json` that describes what the space enables, restricts, or invites to do.  

#### Franziska Klugl (2016)

- **Title:** *Using the affordance concept for model design in agent-based simulation*  
- **Author:** Franziska Klugl  
- **Year:** 2016  
- **Venue:** Annals of Mathematics and Artificial Intelligence, vol. 78, pp. 21-44  
- **Publisher:** Springer  
- **What it says:** Proposes using affordances as a design methodology for agent-based simulations. Affordances represent relationships between environment objects and potential actions that agents can perform. The agent does not decide what to do with an object; the object announces what actions it allows. Includes a post-earthquake behavior model where agents perceive environment affordances to decide whether to flee, shelter, or help.  
- **Direct Relevance:** The extended maze_registry with object affordances is exactly what this paper proposes as best practice for ABM (Agent-Based Modeling).  

#### E. E. Sahin, M. Cakmak, M. R. Dogar, E. Ugur, G. Ucoluk (2007)

- **Title:** *To What Extent Can We Formalize Affordances for Robotics?*  
- **Authors:** E. Erdem Sahin, Mehmet Cakmak, M. R. Dogar, Emre Ugur, Gokhan Ucoluk  
- **Year:** 2007  
- **What it says:** In robotics, formalizing affordances involves modeling relationships between environment properties, agent capabilities, and action effects.  

Relevance:  
- The right question is not "what actions does the object allow" in the abstract.  
- The right question is "what action does it allow for what type of agent, in what state, with what result and under what conditions".  
- This pushes the design toward conditioned rules, not just lists of verbs.  

#### Philipp Zech, Michael Haller, et al. (2017)

- **Title:** *Computational Models of Affordance in Robotics: a Taxonomy and Systematic Classification*  
- **Authors:** Philipp Zech, Michael Haller, Safoura Rezapour Lakani, Lorenz-Jon L. Gienger, Mirjam Ugur, Jan Peters  
- **Year:** 2017  
- **What it says:** Classifies computational models of affordance and emphasizes that the possible action depends on the conjunction between environment, object, state, and agent skill.  

Relevance:  
- Justifies separating `object_affordances`, `state_prerequisites`, `trait_modifiers`, `resource_requirements` and `expected_outcomes`.  
- Reinforces that `interaction: "cook"` is not enough; the good model needs preconditions, effects, and contextual variants.  

#### Tianmin Shu, M. S. Ryoo, Song-Chun Zhu (2016)

- **Title:** *Learning Social Affordance for Human-Robot Interaction*  
- **Authors:** Tianmin Shu, M. S. Ryoo, Song-Chun Zhu  
- **Year:** 2016  
- **Source:** https://arxiv.org/abs/1604.03692  
- **What it says:** Proposes representing social affordances, i.e., spatial and action configurations that make certain interactions between agents appropriate.  

Relevance:  
- Not only objects have affordances; spatial social configurations also do.  
- A `pub` not only allows `drink`; it also makes louder interactions, larger groups, and longer chats appropriate.  
- A `library` makes shorter conversations and low volume appropriate.  

#### Francesco Riccio, Roberto Capobianco, Marc Hanheide, Daniele Nardi (2016)

- **Title:** *STAM: A Framework for Spatio-Temporal Affordance Maps*  
- **Authors:** Francesco Riccio, Roberto Capobianco, Marc Hanheide, Daniele Nardi  
- **Year:** 2016  
- **Source:** https://arxiv.org/abs/1607.00354  
- **What it says:** Introduces `spatio-temporal affordances` and `spatio-temporal affordance maps` to encode action semantics tied to the environment, including temporal dynamics.  

Relevance:  
- Direct validation of the intuition about `temporal flows`.  
- A place should not have fixed affordances; it should have affordances dependent on time, crowding, world state, or recent events.  

#### Lemee, Vachtsevanou, Mayer, Ciortea (2024)

- **Title:** *Signifiers for conveying and exploiting affordances: from human-computer interaction to multi-agent systems*  
- **Year:** 2024  
- **Venue:** Annals of Mathematics and Artificial Intelligence  
- **Publisher:** Springer  
- **What it says:** Defines a **Signifier Exposure Mechanism** where the environment computes which "signifiers" (affordance signals) to expose to each agent based on the current context. Not all agents perceive the same affordances — the environment filters and prioritizes based on the agent's state, role, and situation.  

Direct Relevance:  
- The registry could not only declare affordances, but filter them by agent. A barista sees "serve" on the counter; a customer sees "order". This is exactly what the Signifier Exposure Mechanism describes.  
- Increases interaction efficiency and reduces agent cognitive load.  

#### Penn State / University of Arizona (2011)

- **Title:** *Human Behavioral Simulation Using Affordance-Based Agent Model*  
- **Year:** 2011  
- **Venue:** Springer, Lecture Notes in Computer Science (LNCS)  
- **What it says:** Human behavior simulation model where agents perceive environment affordances to decide actions. Main example: fire evacuation in a warehouse. Doors "offer" exit, stairs "offer" up/down, extinguishers "offer" put out fire.  
- **Direct Relevance:** Demonstrates that the pattern works for realistic human behavior simulation, not just games.  

#### Affordance-based agent model for road traffic simulation

- **Venue:** Autonomous Agents and Multi-Agent Systems (Springer)  
- **What it says:** Driver agents have an ego-centric representation of the environment based on affordances. The environment (road, traffic lights, other vehicles) determines possible actions. The pattern is identical to a registry that declares what each agent can do in each zone.  
- **Direct Relevance:** Additional validation of the "environment declares, agent chooses" pattern.  

### 4.2 Multi-agent systems: the environment as first-level abstraction

#### Danny Weyns, Andrea Omicini, James Odell (2007) [SEMINAL]

- **Title:** *Environment as a first class abstraction in multiagent systems*  
- **Authors:** Danny Weyns, Andrea Omicini, James Odell  
- **Year:** 2007  
- **Venue:** Autonomous Agents and Multi-Agent Systems, vol. 14, pp. 5-30  
- **Publisher:** Springer  
- **What it says:** This is the seminal paper that argues that the environment must be treated as a first-class abstraction in multi-agent systems, not as a mere passive "container". The environment has a dual role: (1) provides the conditions for agents to exist and act, and (2) is an exploitable abstraction for building MAS applications. "The environment is the glue that connects agents into a working system." The paper formally defines the environment's responsibilities: observability, interaction, communication, and regulation.  
- **Direct Relevance:** This is the strongest theoretical foundation to justify the extended registry. The environment is not passive — it is a first-class citizen that controls, regulates, and enables behavior.  

Note: An earlier version of the same argument appears in Weyns, Schumacher, Ricci, Viroli, Holvoet (2005).  

#### Danny Weyns, Fabien Michel, H. Van Dyke Parunak, Jacques Ferber, et al. (2015)

- **Title:** *Agent Environments for Multi-Agent Systems: A Research Roadmap*  
- **Source:** https://www.lirmm.fr/~fmichel/publi/pdfs/weyns15e4mas_roadmap.pdf  
- **What it says:** The environment must be considered a primary abstraction to model shared physical and social world, mediate interactions, and regulate access to resources and constraints.  

Relevance:  
- The idea fits exactly at the `interaction mediation` level.  
- A good maximalist `maze_registry` not only describes places; it mediates behavior between agents.  
- Also suggests that the environment is the natural place for restrictions, regulation, and shared context.  

#### Alessandro Ricci, Mirko Viroli, Andrea Omicini (2008)

- **Title:** *Artifacts in the A&A meta-model for multi-agent systems*  
- **Year:** 2008  
- **Venue:** Autonomous Agents and Multi-Agent Systems (Springer)  
- **What it says:** Defines the **A&A (Agents & Artifacts)** framework. **Artifacts** are reactive entities that provide services and functions, and shape the agent's environment. Agents are proactive (have goals and execute tasks); artifacts are reactive (provide services and functions on demand).  

Direct Relevance:  
- The maze_registry fits perfectly as an "artifact" in the A&A model: it is a reactive entity that provides services (affordances, durations, social rules) that agents exploit to make decisions.  

#### Alessandro Ricci et al. (2011)

- **Title:** *Environment programming in multi-agent systems: an artifact-based perspective*  
- **Year:** 2011  
- **Venue:** Autonomous Agents and Multi-Agent Systems (Springer)  
- **What it says:** Presents **CArtAgO**, a platform for building "work environments" as sets of programmable artifacts. Artifacts are basic blocks for modeling agent environments. The platform allows defining, instantiating, and composing artifacts that agents can perceive and use.  
- **Direct Relevance:** Practical implementation of the A&A model. If we had to formalize the registry, CArtAgO would be the model to follow.  

#### Alexander Helleboogh, Giuseppe Vizzari, Adelinde Uhrmacher, Fabien Michel (2006/2007)

- **Title:** *Modeling Dynamic Environments in Multi-Agent Simulation*  
- **Source:** https://paperzz.com/doc/7898701/modeling-dynamic-environments-in-multi-agent-simulation  
- **What it says:** The dynamics of the environment must be explicitly modeled as part of the simulated environment; the environment encapsulates and regulates its own dynamics.  

Relevance:  
- Justifies that `maze_registry.json` should not be static.  
- Variations by time of day, crowding, events, emotional residues, or place states belong conceptually to the environment.  

#### Eric Platon, Marco Mamei, Nicolas Sabouret, Shinichi Honiden, H. Van Dyke Parunak (2007)

- **Title:** *Mechanisms for Environments in Multi-Agent Systems: Survey and Opportunities*  
- **What it says:** Reviews mechanisms by which the environment regulates, mediates, and structures multi-agent interactions.  

Relevance:  
- Supports the idea that social rules do not live only in each agent.  
- The environment can impose restrictions and channel behavior without making each agent excessively complex.  

#### Signifiers as a First-class Abstraction in Hypermedia Multi-Agent Systems (2023)

- **Venue:** AAMAS 2023 (International Conference on Autonomous Agents and Multiagent Systems)  
- **What it says:** Extends the concept of signifiers as a first-class abstraction in hypermedia-based MAS. The environment exposes signifiers that indicate to agents what affordances they can exploit.  
- **Direct Relevance:** Modern extension of the A&A framework, confirming that the community is still actively pursuing this line.  

### 4.3 LLM agents and social simulation — The Gap in Generative Agents

#### Joon Sung Park et al. (2023)

- **Title:** *Generative Agents: Interactive Simulacra of Human Behavior*  
- **Authors:** Joon Sung Park, Joseph C. O'Brien, Carrie J. Cai, Meredith Ringel Morris, Percy Liang, Michael S. Bernstein  
- **Year:** 2023  
- **Venue:** UIST 2023  
- **Source:** https://arxiv.org/abs/2304.03442  

What it says:  
- Agents perceive the environment, store memories in natural language, reflect, and plan.  
- The paper demonstrates credible social emergence.  
- The sandbox is inspired by *The Sims*.  
- The Smallville environment uses a **hierarchical tree structure**: the root node describes the entire world, children describe areas (Lin family's house, Hobbs Cafe, Johnson Park), and leaves describe objects.  
- Objects **DO have mutable state** (bed "occupied", refrigerator "empty", stove "on").  

What is important for this investigation:  
- The paper **does not formalize the world as a large declarative layer of affordances**.  
- **No declarative registry of affordances or social/duration/behavior rules.** The environment tree is **descriptive** (this is what there is), not **prescriptive** (this is what you can do and how).  
- The LLM decides everything: what to do with each object, how long it lasts, how state changes, when to converse.  
- Emergence comes from memory, reflection, and planning rather than strong place semantics.  

**The Gap:** Park et al. do not implement anything like a world registry with durations, social rules, or trait modifiers. Everything goes through the LLM. This is exactly the opportunity our idea addresses.  

Comparative Conclusion:  
- Our proposal is more world-centric than Park et al.  
- This does not contradict the paper; it complements it.  
- A rich registry can act as guardrail, prior, and compute cost for decisions that today the LLM resolves openly.  

#### Alexander Sasha Vezhnevets et al. — Concordia (2023)

- **Title:** *Generative Agent-Based Modeling with Actions Grounded in Physical, Social, or Digital Space using Concordia*  
- **Source:** https://arxiv.org/abs/2312.03664  

What it says:  
- Presents an engine for GABM where actions are grounded in physical, social, or digital space.  
- Uses a `Game Master` that validates physical plausibility and applies environment effects.  

Relevance:  
- Concordia is much more environment-centric than Park et al.  
- But it does so mostly via runtime components and `Game Master`, not via a monolithic JSON.  
- The lesson is important: the environment can be the plausibility and effect controller, but the representation needs an executor, not just data.  

#### Chen Gao et al. (2023)

- **Title:** *Large Language Models Empowered Agent-based Modeling and Simulation: A Survey and Perspectives*  
- **Source:** https://arxiv.org/abs/2312.11970  

What it says:  
- The survey highlights four strong challenges in simulation with LLMs: environment perception, alignment, action generation, and evaluation.  
- Points out tensions between open intelligence and control/reproducibility.  

Relevance:  
- A maximalist `maze_registry` pushes strongly toward control and reproducibility.  
- This reduces LLM load and variance, but shifts work toward modeling and validation.  

### 4.4 Trend 2024-2025: Structured World Knowledge for LLM Agents

#### Voyager — Wang et al. (2023)

- **Title:** *Voyager: An Open-Ended Embodied Agent with Large Language Models*  
- **Venue:** NeurIPS 2023  
- **Source:** https://arxiv.org/abs/2305.16291  
- **What it says:** LLM agent in Minecraft with **skill library** as executable code. World knowledge is structured as reusable programs, not free text. The agent generates code once; then reuses it. Dramatically reduces LLM cost and improves consistency.  
- **Direct Relevance:** Direct analogy: crystallizing world rules in JSON (like Voyager crystallizes skills in code) is more efficient than re-deriving them via LLM each step.  

#### WorldCoder — Tang, Key, Ellis (2024)

- **Title:** *WorldCoder, a Model-Based LLM Agent: Building World Models by Writing Code and Interacting with the Environment*  
- **Venue:** NeurIPS 2024 (Main Conference)  
- **Source:** https://proceedings.neurips.cc/paper_files/paper/2024/hash/820c61a0cd419163ccbd2c33b268816e-Abstract-Conference.html  
- **What it says:** The agent builds a Python program that represents its world knowledge. Key advantages: LLM prior knowledge informs code generation, allows efficient transfer between tasks, and enables **audit** of system knowledge.  
- **Direct Relevance:** Directly validates the idea of crystallizing world knowledge in an audited structure (our JSON) instead of 100% relying on the LLM.  

#### SPRING — Wu et al. (2023)

- **Title:** *SPRING: Studying the Paper and Reasoning to Play Games*  
- **Venue:** NeurIPS 2023  
- **Source:** https://arxiv.org/abs/2305.15486  
- **What it says:** Uses a **DAG** (directed acyclic graph) as a situational model of the game world. Questions about game state are nodes, dependencies are edges. The LLM queries the graph in topological order.  
- **Direct Relevance:** The JSON as a DAG of world knowledge. Instead of the LLM "discovering" what it can do in a space, we tell it in structure.  

#### AgentSociety (2025)

- **Title:** *AgentSociety: Large-Scale Simulation of LLM-Driven Generative Agents Advances Understanding of Human Behaviors and Society*  
- **Source:** https://arxiv.org/html/2502.08691v1  
- **What it says:** Addresses exactly the need for "grounding" in realistic environments. Argues that behaviors must be anchored in "corresponding objective entities" rather than just in human subjective cognition. Without grounding in the environment, social interactions are only "plausible" without correspondence to physical reality.  
- **Direct Relevance:** Our registry IS the grounding. Without it, agents are "plausible" but not "realistic".  

#### SocioVerse (2025)

- **Title:** *SocioVerse: A World Model for Social Simulation Powered by LLM Agents*  
- **Source:** https://arxiv.org/html/2504.10157  
- **What it says:** Structured pipeline with separate components: Social Environment, User Engine, Scenario Engine, Behavior Engine. The social environment has explicit structure that feeds agent behavior.  
- **Direct Relevance:** Additional confirmation that the trend is to separate structured environment from agent logic.  

#### Context-Aware Multi-Agent Systems Survey (2024)

- **Source:** https://arxiv.org/html/2402.01968v2  
- **What it says:** Comprehensive survey that defines Context-Aware Systems as systems that dynamically adapt their behavior by leveraging context (location, people, objects, events). The environment context modulates agent behavior.  
- **Direct Relevance:** The extended registry is literally a "context provider" for our agents.  

### 4.5 Smart Environments and Context-Aware Computing

#### Daniel Salber, Anind K. Dey, Gregory D. Abowd (1999)

- **Title:** *The Context Toolkit: Aiding the Development of Context-Aware Applications*  
- **Relevance:** Formalizes the idea of encapsulating sensors, context, and triggers in a reusable layer. Transferred to this project: `maze_registry.json` can be a `context toolkit` of the simulated world.  

#### Guanling Chen, David Kotz (2000)

- **Title:** *A Survey of Context-Aware Mobile Computing Research*  
- **Relevance:** Reinforces that contextual behavior benefits from explicitly describing place, time, proximity, activity, and available resources. It is, conceptually, exactly the direction of this redesign.  

### 4.6 Academic Synthesis

The idea has strong backing from **four distinct traditions**:  

1. **Affordance Theory** (Gibson -> Sahin -> Zech -> Shu -> Riccio -> Klugl -> Lemee et al.): the environment must declare what actions are possible, with preconditions, effects, and contextual variants.  
2. **A&A Framework** (Weyns, Omicini, Ricci, Helleboogh, Platon): the environment as a first-class citizen, with artifacts that provide services and mediate interactions.  
3. **Gap in Generative Agents** (Park et al.): the original paper has NO prescriptive metadata in the environment. Everything goes through the LLM. The community (AgentSociety 2025, SocioVerse 2025) explicitly recognizes this gap.  
4. **Trend 2024-2025** (WorldCoder, Voyager, SPRING, AgentSociety): the community is moving toward structured and executable representations of world knowledge, no more LLM-decides-everything.  

---

## 5. Precedents in Game Design

### 5.1 The Sims — The Gold Standard

The Sims invented the pattern of "the object controls the agent". It is the most direct commercial precedent.  

**Main Source Consulted:**  
- *The Sims Design Document Draft 5* (historical design document)  
  https://donhopkins.com/home/TheSimsDesignDocuments/TheSimsDesignDocumentDraft5-DonsReview.pdf  

#### Affordance System

Each object declares a list of **interactions** it offers to the world. The Sim does not "know" internally what to do with a chair; it is the chair that announces "you can sit on me".  

**Data Structure per Object (The Sims 1: IFF format; The Sims 2+: DBPF/package format):**  
- **Catalog metadata**: price, category, description  
- **Interaction list (pie menu)**: ordered list of available actions (e.g., "Sit", "Nap", "Watch TV")  
- **Advertised values**: each interaction declares how much it satisfies each need ("motives"):  
  - `Fun`: +30  
  - `Comfort`: +50  
  - `Hunger`: 0  
  - `Hygiene`: 0  
  - `Social`: 0  
  - `Bladder`: 0  
  - `Energy`: +20  
  - `Room`: 0 (environmental contribution)  
- **Skill gain rates**: `Logic +2/hour`, `Cooking +1/hour`  
- **Attenuation curve**: gain rate decreases based on current skill level  

From the design document:  
- `The Sims` already thought of autonomy as a system where interactions have autonomy thresholds and compete with each other.  
- `Interactions` are entities with their own tuning.  
- The document shows concern for resource costs like water, electricity, fuel, and object state.  

#### The BHAV System (Behavior)

BHAV is Maxis' proprietary visual/scripting bytecode language. Each object interaction is implemented as a BHAV tree — essentially a decision tree with nodes that are engine primitives:  

- **Primitives**: `Route to slot`, `Animate`, `Change motive`, `Test condition`, `Run interaction on target`  
- **Semi-globals**: BHAVs shared between objects of the same category (e.g., all sofas share the "sit" BHAV)  
- **Tuning constants (BCON)**: numeric constant tables separate from BHAV code. This is key — allows designers to tune values (how much comfort it gives, how long the animation takes) without touching the logic.  

#### Sim Decision Flow

1. The Sim evaluates its **current needs** (hunger=30, fun=80, etc.)  
2. The engine collects all **advertised** interactions from all accessible objects  
3. For each interaction, calculates a **score** = `SUM(advertised_value[need] x urgency[need])`  
4. The Sim chooses the interaction with the highest score (with some noise/personality)  
5. Executes the associated BHAV  

**Key Point:** The Sim does not have an internal plan of "I'm going to cook". The refrigerator advertises "+60 hunger", and if the Sim is hungry, that interaction's score wins. **The object controls the behavior.** Autonomy is strongly object-centric and tuning-driven.  

#### The Sims 4: Modern Tuning System

The Sims 4 migrated to a completely data-driven system based on **XML tuning files**. Every object, interaction, buff, trait, and career is an independent XML file:  

```xml
<Object>
  <Interaction name="Sit">
    <AdvertisedCommodity commodity="Comfort" value="50"/>
    <AdvertisedCommodity commodity="Fun" value="10"/>
    <Autonomy weight="1.2"/>
    <TestSet>
      <Test type="ObjectState" state="Empty"/>
    </TestSet>
  </Interaction>
</Object>
```

**Lesson for Our Project:**  
- If you want realism and control, the most similar in mainstream games is not an agent that improvises everything; it is a world full of tuned objects and contexts.  
- The difference is that *The Sims* uses a typed and modular tuning layer, not a single flat map JSON.  

### 5.2 Dwarf Fortress — Room Quality System and Workshops

**Sources Consulted:**  
- Dwarf Fortress Wiki, page `Visitor`  
  https://dwarffortresswiki.org/index.php/Visitor  

#### Zones and Behavior

Dwarf Fortress uses an approach where **designated zones** and **assigned rooms** directly dictate what behaviors emerge.  

**Zone Types and the Behavior They Activate:**  
- **Bedroom** (assigned to a dwarf): the dwarf sleeps there, quality affects thinking  
- **Dining room**: dwarves go there to eat; quality generates positive/negative thoughts  
- **Office/Study**: required for nobles; without it, the noble generates negative mandates  
- **Temple**: satisfies "prayer" need; without temple, negative thoughts  
- **Tavern**: satisfies "socializing" and "drinking"; attracts visitors  
- **Library**: satisfies "scholarship"; dwarves go to read/write  
- **Hospital**: injured go there automatically  
- **Workshop**: defines what crafting jobs can be done  

Visitors use taverns, meeting areas, and other places according to access rules, role, and need. Appropriate places change where they eat, sleep, socialize, or request residence. The game's thought and preference system makes the same space affect everyone differently.  

#### Room Quality System

Room quality is calculated with:  

```
Room Value = SUM(furniture_value) + smoothed_walls_bonus + engraving_bonus + floor_bonus - clutter_penalty - filth_penalty
```

Each piece of furniture has a **quality level** with multipliers:  
- Ordinary: x1  
- Well-crafted: x2  
- Finely-crafted: x3  
- Superior: x4  
- Exceptional: x5  
- Masterwork: x12  
- Artifact: x120  

Material also multiplies (a gold throne is worth more than a wooden one).  

**Quality thresholds generate "thoughts":**  

| Room Value | Thought Generated | Happiness |
| --- | --- | --- |
| < 100 | "Slept in a poor bedroom" | -1 |
| 100-249 | "Slept in a decent bedroom" | neutral |
| 250-499 | "Slept in a fine bedroom" | +1 |
| 500-999 | "Slept in a great bedroom" | +2 |
| 1000-2499 | "Slept in a fantastic bedroom" | +3 |
| 2500+ | "Slept in a legendary bedroom" | +5 |

#### Workshops and Job Sites

Workshops are the clearest example of "location drives behavior":  
- A **Craftsdwarf's Workshop** exists in a specific tile  
- Dwarves with "Stonecrafting" labor enabled seek that type of workshop when there are work orders  
- The dwarf **routes to the workshop**, stands in the **interaction spot** (defined adjacent tile), and executes the task  
- **Without workshop, the work simply cannot occur** — the space defines possibility  

**Furniture Triggers Behavior:**  
- A **statue** in a room increases room value but can also "disturb" if it is of a disturbing theme  
- A **well** generates the "Get water" job and dwarves socialize nearby  
- An **artifact display case** satisfies "admire art" needs  

**Lesson:**  
- Dwarf Fortress does not centralize everything in a single file, but it does show something key: space has norms, roles, and psychological consequences.  
- Behavior is not understood only from the agent; there are workshops, bedrooms, temples, taverns, meeting halls, room quality, ownership, and personal preferences.  

### 5.3 RimWorld — The Most Transparent

RimWorld has the most explicit and transparent system of "the environment controls mood". Everything is defined in XML and is completely moddable.  

**Source Consulted:**  
- RimWorld Wiki, page `Rooms`  
  https://rimworldwiki.com/wiki/Rooms  

#### Room Stats System

Each room is evaluated in real time with these statistics:  

1. **Impressiveness** (0-240+): composite function of all other stats. Final score that generates moodlets.  
2. **Beauty** (-INF to +INF): `SUM(beauty_value)` of all objects and tiles.  
3. **Wealth**: total economic value.  
4. **Space**: available tiles per person.  
5. **Cleanliness** (-INF to +INF): filth objects subtract, sterile tiles add.  
6. **Lighting**: percentage of lighting (0-100%).  

**Impressiveness Formula** (simplified):  
```
Impressiveness = f(beauty, wealth, space, cleanliness) x lighting_factor
```

#### Moodlets Generated by Room Stats

```xml
<ThoughtDef>
  <defName>SleptInBarracks</defName>
  <stages>
    <li>
      <label>slept in barracks</label>
      <baseMoodEffect>-3</baseMoodEffect>
    </li>
  </stages>
</ThoughtDef>

<ThoughtDef>
  <defName>SleptInImpressiveBedroom</defName>
  <stages>
    <li><label>decent bedroom</label><baseMoodEffect>1</baseMoodEffect></li>
    <li><label>slightly impressive bedroom</label><baseMoodEffect>2</baseMoodEffect></li>
    <li><label>somewhat impressive bedroom</label><baseMoodEffect>3</baseMoodEffect></li>
    <li><label>very impressive bedroom</label><baseMoodEffect>5</baseMoodEffect></li>
    <li><label>extremely impressive bedroom</label><baseMoodEffect>7</baseMoodEffect></li>
    <li><label>unbelievably impressive bedroom</label><baseMoodEffect>10</baseMoodEffect></li>
  </stages>
</ThoughtDef>
```

#### Recreation Types

Each recreational object declares a **recreation type** it satisfies. Colonists need **variety** in recreation — repeating the same type gives diminishing returns:  

| Recreation Type | Objects That Provide It |
| --- | --- |
| `Meditative` | Chess table, prayer spot |
| `Social` | Horseshoe pin, poker table |
| `Dexterity` | Billiards table |
| `Intellectual` | Telescope, reading |
| `Gluttonous` | Lavish meals, drugs |
| `Solitary` | Walking in nature |
| `Music` | Instruments (DLC) |

Definition in XML:  

```xml
<ThingDef ParentName="BuildingBase">
  <defName>BilliardsTable</defName>
  <building>
    <joyKind>Dexterity</joyKind>
  </building>
  <statBases>
    <Beauty>2</Beauty>
    <JoyGainRate>1.1</JoyGainRate>
    <WorkToMake>10000</WorkToMake>
  </statBases>
  <interactionCellOffset>(0,0,-1)</interactionCellOffset>
</ThingDef>
```

**Note on `interactionCellOffset`:** The object declares exactly which tile the pawn must stand on to use it. This is directly implementable in our registry.  

#### Work Sites and Interaction Spots

RimWorld defines **interaction spots** as relative offsets to the object:  
- An oven has its spot at `(0,0,-1)` (the tile in front of it)  
- A bed has spots at `(-1,0,0)` and `(1,0,0)` (both sides)  
- A research table has its spot in front  

The work system:  
1. The pawn looks for **bills** (work orders) in workbenches  
2. The workbench announces what type of work it accepts (cooking, smithing, tailoring)  
3. The pawn with the appropriate skill routes to the workbench's **interaction spot**  
4. Work speed is modified by: skill level, room cleanliness (for cooking), lighting, and workbench stats  

**Lesson:**  
- RimWorld already operates with the "place affects behavior and outcomes" pattern.  
- Objects define functions; the combination of objects defines the room's role; the room's role and stats alter needs, mood, and efficiency.  
- It is world-centric, but modular and highly typed.  

### 5.4 Oxygen Not Included — Auto-Classification of Rooms

Automatic "room detection" system: when an enclosed space contains certain objects, it auto-classifies:  

| Room Type | Requires | Bonus |
| --- | --- | --- |
| Barracks | Cots | Stamina recovery |
| Bedroom | Comfy bed + decor item | +Morale bonus |
| Mess Hall | Table + chair | +Morale from eating |
| Great Hall | Table + chair + decor + recreation | +6 Morale |
| Nature Reserve | Minimum plants + critters | +6 Morale |
| Hospital | Medical cot + toilet | Faster disease recovery |

The key: duplicants (NPCs) do not decide "I want a room bonus". The **room auto-classifies** by its contents and applies buffs/debuffs passively. Completely data-driven.  

### 5.5 Kenshi

Uses FCS (Forgotten Construction Set) files where each building/object declares:  
- What jobs it enables  
- What resources it consumes/produces  
- The exact interaction point  
- Bonuses by "town prosperity"  

Modders have full access to the FCS editor.  

### 5.6 Stardew Valley

Less sophisticated but relevant:  
- Objects declare in JSON/xnb their crop type and valid season  
- NPCs have "liked gifts" — the object declares its gift_taste_value  
- Locations declare what fish spawns are possible  

### 5.7 Caves of Qud

Data-driven system in XML where each tile/object declares:  
- **Tags**: `Metal`, `Furniture`, `LightSource`, `Commerce`  
- **Properties**: `Commerce_Value`, `Chair_Comfort`, etc.  
- NPCs use tags to decide behavior: an NPC with role "Merchant" seeks objects with tag "Commerce"  

### 5.8 Factorio

Although it has no NPCs, its "prototypes" system in Lua is the purest example of data-driven design:  

```lua
{
  type = "assembling-machine",
  name = "assembling-machine-2",
  crafting_speed = 0.75,
  energy_usage = "150kW",
  crafting_categories = {"crafting", "advanced-crafting"},
  module_specification = { module_slots = 2 },
  allowed_effects = {"consumption", "speed", "productivity", "pollution"}
}
```

The entire game is defined in Lua tables that modders freely override.  

### 5.9 Comparative Synthesis

| System | Dominant Pattern | Similarity to Our Idea | Important Difference |
| --- | --- | --- | --- |
| Generative Agents | agent-centric with memory and reflection | emergent social behavior | little strong declarative semantics of the environment |
| Concordia | environment-mediated via Game Master | grounding in space and plausibility | logic lives more in runtime than in a large registry |
| The Sims | object-centric tuning and autonomy | affordances per object, thresholds, costs, context | uses modular tuning, not a single unique map JSON |
| RimWorld | data-driven defs and room stats | rooms and objects affect mood, work, risks | more modular and highly typed model |
| Dwarf Fortress | spatial subsystems + preferences | places with social roles and psychological effects | semantics distributed in many subsystems |
| ONI | auto-classification by content | the room is defined by its objects | less granularity per individual object |
| Kenshi | FCS data-driven | declarative work + resources | less social sophistication |
| Stardew Valley | simple JSON | objects declare properties | much smaller scale and complexity |
| Caves of Qud | XML tag-based | tags control NPC behavior | more tag-driven than affordance-driven |
| Factorio | Lua prototypes | gold standard of data-driven design | no social NPCs |

### 5.10 Shared Architectural Pattern (All Games)

```
OBJECT/LOCATION declares --> {affordances, stats, interaction_spots, need_satisfaction}
NPC evaluates             --> {my_needs x what_the_world_offers} --> score
NPC executes              --> route_to(interaction_spot) --> execute(animation/action)
RESULT                    --> modifies(need_state, mood, skills)
```

**Key Principles Extracted:**  

1. **The object announces, the agent does not discover**: the agent does not reason "what can I do with this chair". The chair says "you can sit, comfort +50".  
2. **Scoring based on needs**: almost all use variants of `score = SUM(object_value[need] x agent_urgency[need])`. The Sims formalized it first.  
3. **Interaction spots**: the world declares exactly where the NPC must position to interact. Solves pathfinding and animation in one go.  
4. **Room classification emerges from contents**: instead of "marking" a room as bedroom, the system detects it contains bed + table + lamp and auto-classifies it (ONI, RimWorld partially).  
5. **Tuning/logic separation**: behavior logic is in code, but numeric values are in data files (XML, Lua, BCON). This allows rapid iteration without recompiling.  
6. **Mood as environmental result**: the NPC's mood/happiness is largely a function of the environment (room quality, furniture quality, cleanliness), not internal NPC decisions.  

**Direct Relevance to Our Project:**  

The current generative agents system uses an LLM for the agent to reason about what to do — a fundamentally different approach from these games. However, commercial games demonstrate that the most scalable approach is **hybrid**: the environment declares possibilities and their values, and the agent (in our case, the LLM) decides between already filtered and scored options, instead of generating options from scratch.  

**Conclusion:** We did not find a serious system that does everything with a single monolithic map file and nothing else. We did find many successful systems where the world regulates a large part of the behavior. The conceptual direction is good; the risk is in how to package it.  

---

## 6. Technical Feasibility

### 6.1 JSON Extensibility

**Verdict: very easy to extend.**  

The architecture is already designed for extension:  

1. `maze.py:_load_registry()` (lines 911-991) builds indexed dictionaries. Adding new fields = adding keys to existing dicts.  

2. Accessors are simple 3-4 line methods:  
```python
def get_arena_atmosphere(self, arena_address):
    meta = self.arena_meta.get(arena_address)
    return meta.get("atmosphere", "neutral") if meta else "neutral"
```
Each new field requires 1 new accessor with the same structure.  

3. `scripts/generate_maze_registry.py` produces the JSON from CSVs. Extend there for new fields.  

4. Tests (`test_maze_registry.py`, 275 lines) already validate all accessors. Clear pattern for adding new tests.  

### 6.2 Durations per Object and Arena

This is the most viable part of the entire package.  

Reasons:  
- `act_duration` already exists.  
- A central lifecycle already exists in `scratch.py:982-1094`.  
- Today duration is invented by the LLM in the decomp prompt.  
- `maze.py` already has a single ingest point where new policies can be loaded.  

What would be needed conceptually:  
1. Add something like `duration_policy` to the registry.  
2. Resolve that policy when building `current_action_contract` or writing `act_duration`.  
3. Maintain an override mechanism for special states.  

**Judgment: easy to moderate.**  

### 6.3 Rich Affordances per Object

Also viable, but requires expanding object semantics.  

Today an object basically has:  
- `type`  
- `interaction` as list of activity types  

To truly constrain generation, you would need:  
- allowed verbs  
- subactions  
- prerequisites  
- outputs  
- duration ranges per action  
- time-of-day compatibility  
- capacity  
- resource needs  

Natural consumption points:  
- `plan.py` during decomp to reduce LLM search space  
- `location_resolver.py` to score arena+object better  
- `execute.py` for micro-positioning and persistence  

**Judgment: moderate.**  

### 6.4 Trait Modifiers

This is the conceptually powerful part and technically the least trivial.  

**The problem is not in the JSON; it is in the personality representation.**  

Facts:  
- `scratch.py` stores `innate`, `learned`, `currently`, `lifestyle`, `living_area`.  
- In the repo, no robust taxonomy of normalized traits appears.  
- Inspected examples show free text or semi-structured bios, not canonical tags like `["studious", "lazy", "social"]`.  

Consequence:  
- Cannot build a serious `trait_modifiers` system if each person describes their personality in free text.  
- The alternative would be heuristic string matching. That would be fragile, opaque, and hard to test.  

**Judgment: moderate to difficult, but not because of the registry but because of the persona model.**  

### 6.5 LLM Load Reduction

Expected reduction very real in four dimensions:  

#### Search Space

If the world says:  
- `shower`: 2-4 steps  
- `sink`: 1 step  
- `park_bench`: 5-15  
- `desk`: 20 base  

then the LLM stops improvising a temporal magnitude from natural language.  

#### Less Repair

Today `plan.py` validates and repairs durations, anchors, and activity types. The more structure comes from the registry:  
- fewer sum errors  
- fewer invented anchors  
- fewer decomp repairs  
- fewer heuristic fallbacks  

#### Lower Inter-Run Variance

The same action in the same space should produce a similar family of behaviors, not a completely different improvisation in each run.  

#### Lower Cognitive Cost per Prompt

If the prompt does not have to reason "how long does showering take", "if the piano is reasonable for practicing", "if the library is a good place for long chat", the LLM is reserved for what is really worth reasoning: social nuance, intention, explanation, high-level human improvisation.  

**Conservative Estimation by Category:**  

| Data Delegated to JSON | Tokens Saved/Step/Agent | Quality Improvement |
| --- | --- | --- |
| Action Duration | ~50-100 (eliminates "how long?" reasoning) | More consistent, no absurd durations |
| Object Affordances | ~100-200 (eliminates invalid action generation) | Less hallucination, fewer retries |
| Arena Social Rules | ~50 (already partially implemented) | Already works well |
| Trait Modifiers | ~0 (LLM already has traits in context) | More deterministic, less variance |

**Total Estimated: 200-350 tokens/step/agent reduction, plus elimination of invalid outputs requiring retry.**  

With 14 agents and ~1440 steps per simulated day: 200 x 14 x 1440 = **~4 million tokens/day** saved. At $3/M input tokens, that's ~$12/day direct savings, plus indirect savings from eliminated retries.  

**Qualitative Estimation:**  
- Declarative `duration_policy` could lower a very visible part of planner noise.  
- Declarative `affordances` could lower semantic errors and location/action matching hallucinations.  
- Declarative `social_rules` could make chat much more coherent with the place with almost zero additional token cost.  

### 6.6 JSON Scalability

With 63 arenas x ~20 fields + 225 objects x ~15 fields = **~4,600 total fields**. In flat JSON this would be ~8,000-12,000 lines.  

**Not a runtime problem:** loaded once at start into Python memory as dictionaries. The entire JSON fits in ~100-200KB RAM. The bottleneck will never be JSON parsing.  

**The potential problem is maintenance:** if it grows to 500+ complex rules with temporal overrides, trait modifiers, and inheritance, the JSON becomes hard to **maintain manually** (not process).  

From a machine perspective, 500 rules is nothing.  

From a human perspective, 500 rules is already a serious problem if:  
- no inheritance  
- no templates  
- no schema  
- no linting  
- no readable diffs  
- no coherence tests  

The real limit is not file read/write; it is **authoring and debuggability**.  

At that point, need:  
- JSON Schema for validation  
- A generator/editor ( `generate_maze_registry.py` already exists as base)  
- Eventually, migration to Supabase for edit without redeploy  

---

## 7. Trade-offs

### 7.1 Determinism vs Emergence

**This is the most important trade-off of the entire proposal.**  

**The Problem:** If the JSON says "shower = 3 steps", we lose the emergent behavior where a depressed agent stays 20 minutes in the shower. If "piano = [15, 45]", we lose the agent who discovers they love playing and stays 2 hours.  

**The Solution:** Ranges + mood overrides + LLM escape hatch.  

The problem is not moving rules to the world. The problem is moving them as hard constants.  

The right solution is not `duration = 3`.  
The right solution is something like:  

```json
{
  "duration_policy": {
    "base_steps": 3,
    "range_steps": [2, 4],
    "variance_model": "bounded_random",
    "max_override": 12,
    "state_modifiers": [
      {"when": {"mood": "depressed"}, "delta_range": [3, 12]},
      {"when": {"time_of_day": "late_night"}, "delta_range": [1, 4]}
    ],
    "mood_modifiers": {
      "sad": {"duration_mult": 2.0},
      "anxious": {"duration_mult": 1.5},
      "happy": {"duration_mult": 0.8}
    }
  }
}
```

This preserves emergence within a controlled manifold.  

**Override Mechanism:**  
1. JSON gives `base: [2, 4]` (80% of cases fall here)  
2. Trait modifiers apply automatically: `lazy` -> `x1.5`  
3. If the LLM justifies (e.g., "depressed and doesn't want to leave"), it can request up to `max_override: 12`  
4. All overrides are logged for later realism analysis  

**Design Principle:** "declarative defaults + justified overrides". This is exactly what The Sims does (advertised values are defaults, but traits and mood modify scores) and RimWorld (base stats + modifiers).  

**Emergentism is preserved at the edges, not the center.** The center (normal shower duration) is deterministic. The edges (depressed agent, special event) allow overrides.  

### 7.2 JSON Complexity vs Code Complexity

**Question:** Are we just moving complexity from one side to the other without reducing it?  

**Answer:** Partially yes, but to a better place.  

| Aspect | Complexity in Code | Complexity in JSON | Complexity in LLM |
| --- | --- | --- | --- |
| Visibility | Low (dispersed in multiple files) | High (one file, readable) | None (opaque) |
| Auditability | Medium (have to read Python) | High (flat data) | None (not reproducible) |
| Modifiability | Requires developer | Any text editor | Not directly modifiable |
| Versionability | Git diff readable | Git diff very readable | N/A |
| Error Cost | Runtime bug | Load error (fail fast) | Hallucination (silent) |

Moving rules from **LLM -> JSON** reduces total complexity because it eliminates variance and opacity.  
Moving rules from **code -> JSON** is more of a reorg than a net reduction, but gains visibility and auditability.  

The precedent is clear: The Sims 4, RimWorld, Factorio — all moved complexity from code to data files and the result was better maintainability, moddability, and iteration.  

The right question is not "code or JSON".  
The right question is "reusable declarative rule or duplicated procedural branch".  

If the JSON becomes a pile of ad hoc exceptions, you just hid complexity in data harder to test.  
If the JSON declaratively expresses regular policies, with consistent types and small runtime evaluator, then yes it simplifies.  

### 7.3 Maintainability

**Registry Advantages:**  
- versionable  
- diffable  
- easier for world design  
- fewer dispersed regex/if-else  
- better traceability of why a place behaves as it does  

**Disadvantages:**  
- without tooling, becomes an indigestible configuration wall  
- semantically valid but conceptually absurd errors pass easily  
- people start adding cascading exceptions  

**Who Edits the JSON?** Options:  

1. **Manual (designer):** Works up to ~100 rules. After that tedious but not impossible.  
2. **Generator Script** (already exists `generate_maze_registry.py`): JSON generated from authoritative sources (CSVs, Supabase). Current pattern and works well.  
3. **Admin UI:** If this goes to production and there are non-tech designers editing world rules, eventually needs a visual editor.  

**Risk:** Without validation, a typo in JSON crashes the simulation. Mitigation: JSON Schema + load test at start (already partial in `_load_registry()`).  

**Recommendation:** Keep current pattern (generator -> JSON). Add validation with JSON Schema. Eventually, UI if multiple editors.  

### 7.4 Explainability vs Expressiveness

Strongly in favor of the world-centric approach:  
- Much easier to explain "Klaus spoke in a low voice because the library has `max_volume=whisper`" than "the model felt it was appropriate".  

But:  
- If rules are too many and overlap, explainability collapses.  

Need traces like:  
- `duration resolved from object default`  
- `extended by trait modifier studious`  
- `capped by closing time overlay`  
- `reduced by crowding penalty`  

### 7.5 World-Agent Coupling

**Risk:** If the JSON becomes too prescriptive, agents become puppets of the world. If every action, duration, and emotional effect is predefined, the LLM is just an "option selector", not an autonomous agent.  

**Counterargument:** The Sims has exactly this model and produces convincing emergent behavior. Emergence does not come from each agent being completely free, but from the **combination** of many agents with simple rules interacting in a shared space.  

**Recommended Balance:**  
- JSON defines the **80% common** (normal duration, standard affordances)  
- LLM decides the **20% exceptional** (mood overrides, complex social decisions, narrative emergence)  
- Never: JSON decides **100%** of anything (always escape hatch)  
- Never: LLM decides **100%** of anything critical (always JSON constraints)  

### 7.6 Risk of Dead Metadata

There is already a signal in `plan.py`: `social_probability` is validated and normalized, but does not appear with the same strength of use as `activity_type`.  

**Lesson:**  
- Not everything added to the registry will generate real effect.  
- Without a "field -> runtime consumer" matrix, the JSON fills with decorative semantics.  

**Critical Rule:** Before adding a field to the registry, there must be at least one runtime consumer that reads and acts on it. Fields without consumer = dead metadata.  

### 7.7 Implementation Cost

**Risk:** Implementing all maximalist JSON fields requires changes in practically all cognitive pipeline modules. It is a big project.  

**Mitigation:** Incremental implementation. Each phase adds independent value. No need to implement everything to get benefit.  

---

## 8. Optimal Schema Design

### 8.1 Structure: Inheritance by Levels

Recommendation: `nested but regular`.  

Would not do:  
- a giant flat JSON per address  
- nor arbitrary nesting with inconsistent depth  

Would do:  
- topology nested by `sector -> arena -> object`  
- typed and repeatable substructures  
- defaults/archetypes separate above  
- instance overrides below  

```
meta (global defaults)
  --> sector (inherits from meta, override by sector type)
       --> arena (inherits from sector, override by individual arena)
            --> object (inherits from arena, override by individual object)
```

**Principle:** Each level only declares what differs from its parent. Massively reduces duplication.  

**Inheritance Example:**  

```json
{
  "defaults": {
    "sector": {
      "residential": {
        "atmosphere": "private",
        "proximity_mod": -1,
        "cooldown_mod": 3,
        "social_rules": {"max_group_size": 3, "formality": "casual", "volume": "quiet"}
      },
      "commercial": {
        "atmosphere": "lively",
        "proximity_mod": 1,
        "cooldown_mod": -2,
        "social_rules": {"max_group_size": 6, "formality": "casual", "volume": "normal"}
      },
      "educational": {
        "atmosphere": "focused",
        "proximity_mod": 0,
        "cooldown_mod": 0,
        "social_rules": {"max_group_size": 4, "formality": "moderate", "volume": "quiet"}
      },
      "recreation": {
        "atmosphere": "relaxed",
        "proximity_mod": 1,
        "cooldown_mod": -1,
        "social_rules": {"max_group_size": 8, "formality": "casual", "volume": "normal"}
      }
    },
    "object": {
      "fixture": {"duration": {"base": [1, 3]}},
      "furniture": {"duration": {"base": [5, 30]}},
      "instrument": {"duration": {"base": [10, 40]}, "skill_category": "music"},
      "appliance": {"duration": {"base": [3, 15]}},
      "workspace": {"duration": {"base": [20, 120]}},
      "seating": {"duration": {"base": [10, 60]}},
      "outdoor": {"duration": {"base": [5, 30]}},
      "equipment": {"duration": {"base": [5, 20]}}
    }
  },
  "sectors": {
    "Hobbs Cafe": {
      "arenas": {
        "cafe": {
          "proximity_mod": 1,
          "objects": {
            "piano": {
              "duration": {"base": [15, 45]}
            }
          }
        }
      }
    }
  }
}
```

**Runtime Resolution:** Search in object -> arena -> sector -> defaults. First value found wins.  

### 8.2 Complete Resolution Order (Doc 1 Proposes 16 Levels)

1. `global_defaults`  
2. `sector_type_defaults`  
3. `sector_archetype`  
4. `sector_instance`  
5. `arena_type_defaults`  
6. `arena_archetype`  
7. `arena_instance`  
8. `object_type_defaults`  
9. `object_archetype`  
10. `object_instance`  
11. `temporal_overlay`  
12. `event_overlay`  
13. `persona_trait_modifiers`  
14. `persona_state_modifiers`  
15. `action_specific_override`  
16. `bounded_randomization`  

**Critical Note:** 16 levels of inheritance is ambitious. Without tooling that shows "why this field has this value", debuggability degrades quickly. Recommendation: start with 4-5 levels (defaults -> sector -> arena -> object -> overlay) and add as demonstrated need.  

Without this, a maximalist JSON becomes unmanageable.  

### 8.3 Override by Person-Type or by Individual Trait

Recommendation:  
- individual traits as base mechanism  
- `persona_type` only as authoring shortcut  

Example of persona_types: `student`, `barista`, `retiree`, `artist`  

Each `persona_type` can expand to traits, role, routines, and constraints.  
But the modification engine should operate on atomic tags: `studious`, `lazy`, `social`, `anxious`, `creative`  

Because that allows composition.  

### 8.4 Validation

Need two levels:  

#### JSON Schema

For:  
- types  
- required keys  
- enums  
- ranges  
- formats  

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "duration": {
      "type": "object",
      "properties": {
        "base": {
          "type": "array",
          "items": {"type": "integer", "minimum": 1},
          "minItems": 2,
          "maxItems": 2
        },
        "max_override": {"type": "integer", "minimum": 1},
        "mood_modifier": {"type": "boolean"}
      },
      "required": ["base"]
    },
    "affordances": {
      "type": "array",
      "items": {"type": "string"},
      "minItems": 1
    },
    "atmosphere": {
      "type": "string",
      "enum": ["casual", "private", "social", "relaxed", "busy", "lively", "focused", "transient", "quiet", "neutral"]
    }
  }
}
```

Validated in `_load_registry()` on load. Fail fast with descriptive error.  

#### Semantic Validation

For:  
- trait references exist  
- allowed actions exist  
- `closing_time` does not contradict overlays  
- `capacity.soft` does not exceed `capacity.hard`  
- `resource_outputs` use valid ids  
- addresses exist in `address_tiles`  

Relevant local search: no clear use of `jsonschema`, `pydantic` or `marshmallow` in the repo to validate this file today.  

### 8.5 Trait Modifiers: Separate File vs Integrated

**Perspective 1 (integrated in registry):** Trait modifiers live as subobjects of each arena and object, with a base catalog of traits defined once. Advantage: all behavior in one place. Disadvantage: inflates the main JSON.  

**Perspective 2 (separate file):** Do not put trait modifiers in the main JSON. A separate `trait_modifiers.json` file:  

```json
{
  "lazy": {
    "global": {"energy_cost": -0.2},
    "duration_mod": {"work": -0.3, "sleep": +0.3, "study": -0.2},
    "motivation_mod": {"work": -2, "relax": +1, "exercise": -3}
  },
  "studious": {
    "global": {},
    "duration_mod": {"study": +0.4, "read": +0.3},
    "skill_gain_mod": {"study": +0.2, "research": +0.3},
    "motivation_mod": {"study": +2, "library": +1}
  },
  "social": {
    "global": {"social_magnet": +0.2},
    "duration_mod": {"socialize": +0.3},
    "proximity_mod": +1,
    "motivation_mod": {"party": +2, "alone": -2}
  },
  "introvert": {
    "global": {"social_magnet": -0.2},
    "duration_mod": {"socialize": -0.2, "read": +0.2},
    "proximity_mod": -1,
    "motivation_mod": {"party": -2, "alone": +1}
  },
  "creative": {
    "global": {},
    "duration_mod": {"art": +0.3, "music": +0.2, "write": +0.3},
    "skill_gain_mod": {"art": +0.2, "music": +0.15},
    "inspiration_bonus": +0.1
  },
  "athletic": {
    "global": {"energy_cost": -0.1},
    "duration_mod": {"exercise": +0.3},
    "skill_gain_mod": {"exercise": +0.2},
    "motivation_mod": {"exercise": +2, "sedentary": -1}
  },
  "anxious": {
    "global": {"stress_factor": +0.2},
    "duration_mod": {"sleep": -0.2, "relax": +0.2},
    "safety_threshold": +0.2,
    "motivation_mod": {"crowded_place": -2, "quiet_place": +1}
  }
}
```

Applied at runtime: `effective_duration = base_duration x (1 + trait_mod)`.  

**Reason to Separate:** The main JSON describes the world (static, objective). Trait modifiers describe how different personalities experience the world (subjective). Mixing them violates separation of concerns.  

**Pragmatic Recommendation:** Start with separate file (cleaner). If per-object/arena granularity is needed (e.g., "introvert reacts differently to piano than to desk"), add point overrides in the main registry that complement the trait file defaults.  

### 8.6 Proposed High-Level Structure

```json
{
  "meta": {},
  "taxonomy": {},
  "global_defaults": {},
  "sector_type_defaults": {},
  "arena_type_defaults": {},
  "object_type_defaults": {},
  "trait_profiles": {},
  "event_catalog": {},
  "resource_catalog": {},
  "sectors": {}
}
```

The reason to pull defaults and taxonomies out of the topological tree is simple:  
- reduces repetition  
- facilitates linting  
- avoids each arena rewriting the same rules 80 times  

### 8.7 Base Catalog of Traits

The current repo does not expose a formal trait catalog. For `trait_modifiers` to be viable, need to freeze a taxonomy. Proposed base set:  

| Trait | Tends to Increase | Tends to Reduce | World Fields It Should Most Touch |
| --- | --- | --- | --- |
| `introvert` | preference for privacy, staying in corners | desired group size, volume | `privacy_level`, `solo_comfort`, `seat_selection_policy`, `conversation_type_cap` |
| `extrovert` | social bonus, noise tolerance, staying in third places | need for privacy | `social_bonus`, `max_group_size`, `noise_tolerance`, `proximity_mod` |
| `social` | probability to start chat, social linger | crowd avoidance | `social_bonus`, `cooldown_mod`, `allows_group_conversation` |
| `studious` | staying at desks/tables, focus zones | distraction | `duration_policy`, `study_suitability`, `noise_penalty` |
| `lazy` | preference for short or sedentary actions | duration of demanding work | `duration_policy`, `movement_policy`, `effort_thresholds` |
| `diligent` | staying at work surfaces | early abandonment | `duration_policy`, `work_suitability`, `task_completion_bias` |
| `creative` | attraction to instruments, art, expressive spaces | preference for repetitive routine | `affordance.weight`, `emotional_effects`, `novelty_bonus` |
| `athletic` | use of active spaces, physical tolerance | sedentary inertia | `exercise_suitability`, `movement_mode`, `duration_policy` |
| `anxious` | sensitivity to crowding, vigilance, noise | staying in exposed spaces | `privacy_level`, `eavesdropping_risk`, `crowding_overlays`, `stress_effects` |
| `calm` | tolerance to mild chaos | escalation by noise | `noise_tolerance`, `interruptibility`, `stress_effects` |
| `romantic` | value of intimate or atmospheric places | preference for utilitarian spaces | `date_suitability`, `lighting_tone`, `privacy_level` |
| `frugal` | aversion to cost | impulsive consumption | `economic_cost`, `entry_friction`, `resource_costs` |
| `hedonistic` | preference for comfort, pleasure, bar/cafe/nightlife | austere routines | `comfort_bonus`, `linger_policy`, `consumption_bias` |
| `orderly` | sensitivity to cleanliness and structure | tolerance to disorder | `cleanliness`, `queue_policy`, `formal_rules` |
| `messy` | tolerance to dirt/disorder | aversion to clutter | `cleanliness_penalty`, `odor_sensitivity` |
| `curious` | exploration and novelty seeking | monotonous routine | `novelty_bonus`, `event_hooks`, `unknown_place_bias` |
| `territorial` | preference for home sector | wide wandering | `home_score`, `private_space_attachment` |
| `empathetic` | reading the place's social climate | contextual indifference | `emotional_effects`, `social_rules`, `conversation_type_cap` |
| `status_seeking` | value of visible or prestigious places | anonymity | `prestige_signal`, `visibility_when_used`, `identity_signaling` |
| `rebellious` | breaking soft norms | obedience | `social_rules`, `formal_rules`, `max_volume` |
| `dutiful` | compliance with role rules | improvisation | `role_prerequisites`, `service_policy`, `work_duration` |
| `impatient` | abandonment of queues, short durations | prolonged waiting | `queue_policy`, `duration_policy`, `entry_friction` |
| `hospitable` | use of spaces to receive others | isolation | `group_bonus`, `conversation_openers`, `seat_spread_preference` |
| `solitary` | choice of corners and low conversation | group usage | `solo_comfort`, `group_size`, `social_bonus` |

## 9. Alternatives to the Monolithic JSON

| Alternative | Pros | Cons | Verdict |
|---|---|---|---|
| **Monolithic JSON** | Simple, versionable, diffable, already exists | Scales poorly >20K lines, no queries | Viable up to ~500 rules. Recommended for v1 |
| **JSON split** (by sector) | Better organization, easier merges | More files, more complex inheritance resolution | Good option if it grows a lot |
| **Supabase tables** | Dynamic queries, joins, runtime updates, already in the stack | Query latency, not offline-first, migration overhead | Viable long-term, consistent with `SUPABASE_ONLY_MODE` |
| **Custom DSL** | More expressive, can have conditionals and functions | Requires custom parser, learning curve, tooling | Overkill for this project |
| **Lua tables** (Factorio style) | Turing-complete, modders love it | Requires Lua runtime in Python, security, complexity | Does not apply (stack is Python, no modders) |
| **YAML** | More readable than JSON, supports comments | Indentation-sensitive, not standard in the project | Not worth the change |
| **Python dataclasses** | Type-safe, IDE autocomplete, native validation | Not editable by non-devs, coupled to code | For developer-only teams |
| **Hybrid: JSON defaults + LLM override** | Best of both worlds: base determinism + emergence | Complexity of merge logic | **Recommended as general approach** |
| **Hybrid: JSON file + Supabase overrides** | JSON as seed/fallback, Supabase for live editing | Two sources of truth, need to define precedence | **Recommended for production** |

**Hybrid Recommendation:**

1. JSON or YAML for topology, defaults, archetypes and base rules.
2. Python evaluator for merges, precedence and explanations.
3. Possible DSL or mini-language only for complex conditions.
4. LLM as exceptional override, not as first source of duration or affordance.

**Recommendation by Phase:**

1. **Now:** Monolithic JSON (already works, already integrated). Add fields.
2. **If grows >10K lines:** Split by sector. One JSON per sector + one of defaults.
3. **For production:** Migrate to Supabase (table `maze_registry` with JSONB columns). The JSON file becomes seed/backup. Consistent with the project's `SUPABASE_ONLY_MODE` stance.

---

## 10. El JSON Maximalista — Campos Propuestos

Lo que sigue no es "lo minimo". Es deliberadamente maximalista. La idea es listar la superficie completa de mundo que podria existir si se empuja el enfoque al limite.

### 10.1 Campos de nivel META (global)

| Campo | Tipo | Ejemplo | Que controla |
|---|---|---|---|
| `maze_name` | string | `"the Ville"` | Identificador del mapa (existente) |
| `world` | string | `"the Ville"` | Mundo para construir addresses (existente) |
| `width` | int | `140` | Ancho en tiles (existente) |
| `height` | int | `100` | Alto en tiles (existente) |
| `tile_size` | int | `32` | Pixeles por tile (existente) |
| `generated_from` | string | `"CSVs"` | Origen de generacion (existente) |
| `generated_at` | ISO datetime | `"2026-04-06T..."` | Timestamp (existente) |
| `simulation_step_seconds` | int | `60` | Segundos simulados por step |
| `day_phases` | object | `{morning: [6,12], afternoon: [12,18], ...}` | Definicion de fases del dia para temporal overrides |
| `global_noise_floor` | float | `0.1` | Ruido ambiental minimo del mundo |

### 10.2 Campos de sector (~28+ campos)

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `id` | string | `hobbs_cafe_sector` | Identidad estable para referencias internas |
| `label` | string | `Hobbs Cafe` | Nombre humano |
| `type` | enum | `commercial` | Defaults por categoria (existente) |
| `subtype` | enum | `cafe` | Tuning mas fino |
| `tags` | string[] | `["food", "third_place", "music"]` | Filtros y reglas compartidas |
| `tile_count` | int | `184` | Escala del espacio |
| `district` | string | `downtown` | Agrupacion urbana |
| `ownership` | object | `{"kind":"private_business","owner":"hobbs_family"}` | Acceso, economia y responsabilidad |
| `owner_persona` | string\|null | `"Tom Moreno"` | Quien controla el acceso; prioridad |
| `access_policy` | object | `{"default":"public"}` | Quien entra al sector |
| `security_level` | enum | `low` | Friccion de acceso y vigilancia |
| `surveillance_level` | float | `0.35` | Efecto sobre privacidad y self-consciousness |
| `social_density_profile` | object | `{"base":"medium","variance":"high"}` | Cantidad esperada de gente |
| `noise_profile` / `noise_baseline` | object/float | `{"base_db":54}` / `0.5` | Ruido de fondo del sector |
| `lighting_profile` | object | `{"day":"bright","night":"warm_dim"}` | Percepcion y estado de animo |
| `cleanliness_profile` | object | `{"base":0.72}` | Mood, confort, prestigio |
| `odor_profile` | object | `{"base":"coffee_pastry"}` | Memoria y valencia emocional |
| `temperature_profile` | object | `{"indoor_c":23}` | Confort y permanencia |
| `weather_exposure` | enum | `partial` | Si el clima externo modifica conducta |
| `opening_hours` / `operating_hours` | object | `{"mon":["07:00","20:00"]}` | Disponibilidad por dia |
| `peak_hours` | object[] | `[{"label":"lunch","start":"12:00","end":"14:00"}]` | Crowding y atmosfera |
| `foot_traffic` | object | `{morning: 0.3, noon: 0.9}` | Probabilidad de encontrar gente |
| `safety_rating` | float | `0.95` | Agentes anxious evitan safety baja |
| `economic_tier` | enum | `"middle"` | Filtra acceso implicito |
| `formality` | enum | `"casual"` | Modifica vocabulario y tono |
| `public_reputation` | enum | `"positive"` | Influye decision de visitar |
| `default_emotional_signature` | object | `{"comfort":0.5,"energy":0.6}` | Priors emocionales del sector |
| `social_norms` | object | `{"expected_formality":"casual"}` | Normas globales del sector |
| `resource_market` | object | `{"sells":["coffee","pastry"]}` | Economia y consumo |
| `event_hooks` | object[] | `[{"event_id":"live_music_night","weight":0.08}]` | Eventos |
| `memory_residue` | object | `{"base_decay_hours":18}` | Persistencia de historia |
| `adjacency` | object[] | `[{"to":"main_street","kind":"pedestrian"}]` | Flujo y conectividad |
| `spillover_rules` | object | `{"noise_to_neighbors":0.25}` | Como afecta vecinos |
| `routing_bias` | object | `{"linger_bonus":0.2}` | Preferencia de paso o permanencia |
| `default_trait_modifiers` | object | `{"social":{"social_bonus":1}}` | Modificadores sectoriales por trait |
| `arenas` | object | `{...}` | Contiene arenas |

### 10.3 Campos de arena (~90+ campos)

**Campos de identidad y acceso:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `id` | string | `hobbs_cafe_main_room` | Identidad estable |
| `label` | string | `cafe` | Nombre humano |
| `type` | enum | `public` | Categoria funcional (existente) |
| `subtype` | enum | `cafe_room` | Tuning especifico |
| `tags` | string[] | `["food_service", "music_possible", "social"]` | Reglas transversales |
| `access` | enum | `public` | Acceso base (existente) |
| `access_rules` | object | `{"roles_allowed":["customer","staff"]}` | Restricciones finas |
| `gender` | enum/null | `null` | Filtrado por genero (existente) |
| `age_rules` | object | `{"min_age":null,"max_age":null}` | Restricciones por edad |
| `role_rules` / `role_expectations` | object | `{"staff_zones":["behind_counter"]}` | Roles espaciales |

**Campos fisicos y capacidad:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `capacity` | object/int | `{"soft":18,"hard":26}` / `15` | Saturacion, crowding, rechazo |
| `tile_count` | int | `76` | Area util (existente) |
| `seat_count` | int | `14` | Capacidad de permanencia sedentaria |
| `queue_capacity` | int | `6` | Comportamiento de espera |
| `standing_capacity` | int | `8` | Mezcla de densidad |
| `noise_level` / `noise_level_db` | object/float | `{"base":0.4,"amplification":0.08}` / `58` | Ruido = base + (amp x n_occupants) |
| `lighting` / `lighting_level_lux` | object/float | `{"day":0.85,"night":0.6}` / `320` | Percepcion y mood |
| `lighting_tone` | enum | `warm` | Calidad subjetiva de la luz |
| `temperature_c` / `temperature_comfort` | float/object | `22.5` / `{"summer":0.8}` | Confort termico |
| `humidity` | float | `0.46` | Sensacion ambiental |
| `cleanliness` | float | `0.78` | Comodidad y percepcion |
| `odor_notes` / `scent_profile` | string[] | `["coffee","baked_goods","wood"]` | Memoria y afecto |
| `acoustics` | enum | `chatty_reverberant` | Propagacion de sonido |
| `indoor` | bool | `true` | Interior/exterior; si clima impacta |

**Campos de visibilidad y relacion entre espacios:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `visibility_profile` | object | `{"across_room":"medium","from_entrance":"high"}` | Quien ve a quien |
| `sound_leakage` / `noise_bleed` | object | `{"to_adjacent_arenas":0.2}` | Derrame de ruido |
| `line_of_sight_blocks` | string[] | `["counter","column"]` | Percepcion e interaccion |
| `adjacent_arenas` / `social_adjacency` | object[]/string[] | `[{"arena":"kitchen","doorway":true}]` | Flujos y leakage |
| `routing_connectors` | object[] | `[{"to":"street_entrance","width":2}]` | Navegacion |

**Campos sociales:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `atmosphere` | enum | `lively` | Tono social actual (existente) |
| `baseline_atmosphere` | enum | `casual` | Default estable |
| `proximity_mod` | int | `1` | Distancia de trigger social (existente) |
| `cooldown_mod` | int | `-2` | Frecuencia de chats (existente) |
| `social_bonus` | int | `2` | Probabilidad de interaccion |
| `privacy_level` | float | `0.25` | Cuan expuesto se siente el agente |
| `expected_formality` / `formality` | enum/float | `casual` / `0.2` | Registro conversacional |
| `max_group_size` | int | `6` | Limite de grupos |
| `allows_group_conversation` | bool | `true` | Si soporta grupos |
| `conversation_type_cap` / `conversation_types` | enum/string[] | `"extended"` / `["casual","gossip"]` | Duracion/profundidad de charla |
| `max_volume` / `volume_norm` | enum | `normal` | Techo de volumen social |
| `min_volume` | enum | `low` | Piso de volumen |
| `interruption_risk` | float | `0.45` | Probabilidad de interrupcion |
| `eavesdropping_risk` / `eavesdrop_radius` | float/int | `0.55` / `3` | Riesgo de ser oido |
| `allows_strangers_chat` | bool | `true` | Si desconocidos pueden chatear |
| `social_pressure` | object | `{"alone":0.0,"group":0.1}` | Penalizacion por estar solo |
| `social_rules` | object | `{"normative_topics":["local gossip","plans"]}` | Tono y contenido |
| `formal_rules` | object | `{"no_chat_during_cleaning":false}` | Restricciones duras |
| `security_rules` | object | `{"staff_only_subzones":["behind_counter"]}` | Acceso interno |

**Campos de suitability:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `third_place_score` | float | `0.9` | Tendencia a linger/socializar |
| `solo_comfort` | float | `0.8` | Comodidad estando solo |
| `date_suitability` | float | `0.7` | Apropiado para encuentros |
| `study_suitability` | float | `0.35` | Adecuacion para estudio |
| `work_suitability` | float | `0.4` | Adecuacion para trabajo |
| `rest_suitability` | float | `0.3` | Adecuacion para relajarse |

**Campos temporales:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `opening_hours` / `operating_hours` | object | `{"mon":["07:00","20:00"]}` | Disponibilidad local |
| `service_windows` | object[] | `[{"label":"breakfast","start":"07:00","end":"10:30"}]` | Menu, crowd y staff load |
| `peak_hours` | object[] / int[] | `[{"label":"lunch_rush","start":"12:00","end":"14:00"}]` / `[8,12,18]` | Atm, crowd y timing |
| `time_overlays` / `temporal_atmosphere` | object | `{...}` | Cambios por morning/noon/evening/night |
| `weekday_overlays` / `day_of_week_variation` | object | `{...}` | Cambios por dia |
| `weather_overlays` | object | `{...}` | Cambios por clima |
| `seasonal_variation` | object | `{winter: {...}}` | Override estacional |
| `crowding_overlays` | object | `{...}` | Cambios por densidad |
| `event_overlays` | object | `{...}` | Cambios temporales por evento |

**Campos emocionales:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `emotional_effects` / `mood_effect` | object | `{"instant":{"comfort":0.2},"per_hour":{"energy":0.15}}` | Como modifica mood/estado |
| `mood_accumulation` | enum | `gradual` | Como se aplica el efecto |
| `mood_rate` | float | `0.3` | Cuanto se aplica por step |
| `mood_decay_after_leaving` | float | `0.1` | Disipacion post-salida |
| `stress_effects` / `stress_factor` | object/float | `{"for_anxious":{"stress":0.2}}` / `0.1` | Efectos de estres |
| `comfort_rating` | float | `0.75` | Comodidad general |
| `inspiration_chance` | float | `0.05` | Probabilidad de insight |
| `nostalgia_trigger` | string[] | `["first_date","childhood"]` | Keywords de memoria |
| `memory_bias` | object | `{"salience":1.2,"social_memory_boost":1.4}` | Que se recuerda |
| `identity_signaling` | object | `{"status_signal":0.3,"creative_signal":0.5}` | Como se percibe estar ahi |

**Campos de permanencia y movimiento:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `duration_policy` | object | `{"default_steps":12,"range":[5,25]}` | Permanencia base |
| `linger_policy` | object | `{"after_purchase_bonus":[2,8]}` | Tendencia a quedarse |
| `exit_pressure` | object | `{"near_close_minutes":30,"penalty":0.4}` | Fuerza a irse |
| `entry_friction` | object | `{"queue_if_busy":true,"cost_of_entry":0}` | Barreras de entrada |
| `movement_policy` | object | `{"preferred_mode":"in_place","seat_seek":true}` | Micro-movimiento |
| `seat_selection_policy` | object | `{"prefer_window":0.3}` | Eleccion de asiento |
| `queue_policy` | object | `{"forms_single_line":true}` | Comportamiento de cola |
| `service_policy` | object | `{"requires_order_before_seating":false}` | Flujo de uso |

**Campos economicos:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `resource_costs` | object | `{"coffee":4.5}` | Economia |
| `resource_generation` | object | `{"social_opportunities":0.7}` | Produccion de oportunidades |

**Campos de eventos y memoria:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `event_hooks` / `random_events` | object[] | `[{"event_id":"someone_plays_piano","weight":0.06}]` | Eventos aleatorios |
| `scheduled_events` | object[] | `[{"event":"open_mic","day":"friday","time":19}]` | Eventos programados |
| `memory_residue` / `memory_traces` | object | `{"warmth":0.4,"tension":0.05}` / `{"max_age_hours":48}` | Historial del lugar |

**Campos de modificadores:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `trait_modifiers` | object | `{...}` | Diferencias por personalidad |
| `state_modifiers` | object | `{...}` | Diferencias por hambre, energia, etc. |
| `relationship_modifiers` | object | `{"close_friends":{"conversation_bonus":1}}` | Efecto de con quien estas |

### 10.4 Campos de objeto (~60+ campos)

**Campos de identidad:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `id` | string | `hobbs_piano_01` | Identidad estable |
| `label` | string | `piano` | Nombre humano |
| `type` | enum | `instrument` | Defaults por clase (existente) |
| `subtype` | enum | `upright_piano` | Tuning fino |
| `tags` | string[] | `["music","performance","attention"]` | Reglas compartidas |

**Campos de affordance:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `anchor_weight` | float | `0.95` | Fuerza como anchor semantico |
| `interaction` | string[] | `["play","social"]` | Compatibilidad backward (existente) |
| `affordances` | object[] | `[{"action":"practice"},{"action":"perform"}]` | Acciones permitidas detalladas |
| `default_action` | string | `practice` | Fallback accion |
| `action_aliases` | object | `{"play_music":"perform"}` | Normalizacion de lenguaje |

**Campos de duracion y uso:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `duration_policy` / `duration` | object | `{"default_steps":18,"range":[10,35]}` / `{"base":[15,45],"max_override":90}` | Tiempo tipico de uso |
| `duration_by_action` | object | `{"practice":[10,25],"perform":[5,20]}` | Tiempo por accion |
| `cooldown_policy` | object | `{"self_reuse_steps":4}` | Cuan seguido se reutiliza |

**Campos de capacidad y postura:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `occupancy` / `capacity` | object/int | `{"min_agents":1,"max_agents":1}` / `1` | Capacidad |
| `multi_user` | bool | `false` | Uso simultaneo |
| `stance` | enum | `seated` | Postura requerida |
| `required_mode` | enum | `in_place` | Modo de subactividad |
| `movement_pattern` | enum | `fixed_anchor` | Movimiento mientras se usa |
| `interaction_spot_offset` | [dx,dy]\|null | `[0,-1]` | Tile de interaccion (como RimWorld) |
| `requires_queue` | bool | `false` | Cola |

**Campos de percepcion social:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `visibility_when_used` | float | `0.9` | Cuanto llama la atencion |
| `audibility_when_used` / `noise_output` | float | `0.95` / `0.7` | Cuanto se escucha |
| `social_pull_when_used` / `social_magnet` | float | `0.6` | Atraccion de otros agentes |
| `privacy_when_used` | float | `0.1` | Exposicion |
| `prestige_signal` | float | `0.5` | Senal social |

**Campos de necesidades y efectos (estilo Sims):**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `energy_cost` | float | `0.25` | Energia consumida por step |
| `fun_value` | float | `0.8` | Satisfaccion recreativa |
| `comfort_value` | float | `0.3` | Comfort que provee |
| `beauty_value` | float | `0.5` | Contribucion estetica a la arena |
| `skill_category` | string\|null | `"music"` | Que skill gana/usa |
| `skill_gain_rate` | float | `0.05` | Ganancia de skill por step |
| `skill_requirement` | float | `0.0` | Skill minimo para usar |
| `recreation_type` | string\|null | `"musical"` | Tipo de recreacion (variedad importa) |

**Campos de recursos:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `resource_inputs` / `prerequisites` | object[] | `[{"id":"coffee_beans","qty":1}]` / `{"needs":["ingredients"]}` | Requisitos materiales |
| `resource_outputs` / `outputs` | object[] | `[{"id":"music_experience","qty":1}]` / `{"produces":"food"}` | Produccion |
| `economic_cost` / `use_cost` | object/float | `{"money":0}` / `null` | Costo de uso |
| `resources_consumed` / `consumes` | object\|null | `{"ingredients":1}` | Recursos que gasta |

**Campos emocionales:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `fatigue_effects` | object | `{"energy":-0.1}` | Impacto fisico |
| `emotional_effects` | object | `{"instant":{"joy":0.2}}` | Impacto emocional |
| `relationship_effects` | object | `{"shared_use":{"bond":0.2}}` | Efecto social |
| `memory_bias` | object | `{"salience":1.4}` | Recuerdo del uso |
| `mess_risk` | float | `0.02` | Suciedad potencial |

**Campos temporales:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `time_rules` | object | `{"preferred":["evening"],"discouraged":["early_morning"]}` | Compatibilidad horaria |
| `opening_dependency` | object | `{"arena_must_be_open":true}` | Dependencia de arena |

**Campos de prerequisitos:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `state_prerequisites` | object[] | `[{"state":"energy","gte":0.2}]` | Requisitos de estado |
| `trait_prerequisites` | string[] | `[]` | Rasgos requeridos |
| `role_prerequisites` | string[] | `[]` | Roles requeridos |
| `inventory_prerequisites` | object[] | `[]` | Inventario necesario |

**Campos de fallos y outcomes:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `action_failures` | object[] | `[{"when":{"crowding_gt":0.9},"result":"skip"}]` | Casos de fallo |
| `action_outcomes` | object[] | `[{"action":"perform","spawns_event":"mini_audience"}]` | Efectos |

**Campos de estado mutable:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `states` | object | `{idle: {transitions: ["in_use"]}}` | Estados mutables con transiciones |
| `initial_state` | string | `"idle"` | Estado al inicio |
| `degradation_rate` | float | `0.01` | Degradacion por uso |
| `maintenance_action` | string\|null | `"tune"` | Accion para mantener/reparar |
| `break_probability` | float | `0.005` | Probabilidad de romperse |

**Campos de modificadores:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `trait_modifiers` / `trait_mods` | object | `{...}` | Modificadores por rasgo |
| `state_modifiers` | object | `{...}` | Modificadores por estado |
| `conversation_modifiers` | object | `{"while_using":{"proximity_mod":1}}` | Charla alrededor del objeto |
| `social_rules` | object | `{"allows_side_conversation":false}` | Reglas locales |

**Campos de memoria y apego:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `use_history_affects` | object | `{fun: {direction: "diminishing", max: -0.3}}` | Rendimientos decrecientes |
| `personal_attachment` | bool | `false` | Si el agente puede desarrollar apego |
| `semantic_outputs` | string[] | `["music","attention","self_expression"]` | Conceptos para memoria/planificacion |

**Campos de navegacion:**

| Campo | Tipo | Ejemplo | Que controla |
| --- | --- | --- | --- |
| `ownership` | object | `{"kind":"public_shared"}` | Acceso y conflicto |
| `reservation_policy` | object | `{"reservable":false}` | Reserva |
| `co_use_rules` | object | `{"supports_duet":false}` | Uso conjunto |
| `adjacency_preferences` | object | `{"prefers_open_space":true}` | Ubicacion relativa |
| `routing_bias` | object | `{"approach_from_front":true}` | Como se llega |

### 10.5 Objetos de regla reutilizables

Para que el schema no explote en inconsistencia, conviene definir tipos de regla reutilizables.

#### `duration_policy`

| Campo | Tipo | Ejemplo | Controla |
| --- | --- | --- | --- |
| `default_steps` | int | `12` | Duracion base |
| `range` / `base` | int[2] | `[5,20]` | Variacion permitida |
| `variance_model` | enum | `bounded_random` | Como samplear |
| `hard_min_steps` | int | `2` | Piso absoluto |
| `hard_max_steps` / `max_override` | int | `40` | Techo absoluto |
| `extend_if_engaged` | bool | `true` | Si puede extenderse |
| `truncate_if_interrupted` | bool | `true` | Si se corta |
| `mood_mod` | bool | `true` | Si el mood modifica duracion |
| `modifiers` | rule[] | `[...]` | Ajustes por estado/tiempo/trait |

#### `affordance`

| Campo | Tipo | Ejemplo | Controla |
| --- | --- | --- | --- |
| `action` | string | `practice` | Verbo canonico |
| `prompt_verbs` | string[] | `["play","practice"]` | Lenguaje permitido al LLM |
| `probability_weight` | float | `0.6` | Preferencia relativa |
| `duration` / `duration_override` | int[2]/object | `[10,25]` | Duracion especifica |
| `requires` / `prerequisites` | condition[] | `[...]` | Prerequisitos |
| `produces` | effect[] | `[...]` | Outputs |
| `need_delta` | object | `{"fun":40,"energy":-10}` | Efecto en necesidades |
| `skill_delta` | object | `{"music":2}` | Efecto en skills |
| `social_visibility` | float | `0.8` | Visibilidad social |
| `noise_output` | float | `0.9` | Ruido que genera |
| `mood_effect` | object | `{"joy":0.2}` | Efecto emocional |
| `radius_effect` | object | `{"type":"entertainment","radius":5}` | Efecto en agentes cercanos |

#### `modifier_rule`

| Campo | Tipo | Ejemplo | Controla |
| --- | --- | --- | --- |
| `when` | object | `{"trait":"studious","time_of_day":"morning"}` | Condicion |
| `target` | string | `duration_policy.default_steps` | Campo destino |
| `op` | enum | `add` | Tipo de operacion |
| `value` | number/object | `10` | Magnitud |
| `priority` | int | `50` | Resolucion de conflictos |
| `explain` | string | `studious personas linger longer at study surfaces` | Trazabilidad |

#### `time_overlay`

| Campo | Tipo | Ejemplo | Controla |
| --- | --- | --- | --- |
| `window` / `hours` | string/int[2] | `morning` / `[8,11]` | Franja |
| `patch` | object | `{"atmosphere":"quiet","crowd":"low"}` | Override parcial |
| `blend_mode` | enum | `replace` | Como mergea |
| `priority` | int | `30` | Orden de merge |

#### `emotional_effect`

| Campo | Tipo | Ejemplo | Controla |
| --- | --- | --- | --- |
| `channel` | enum | `calm` | Dimension afectiva |
| `instant_delta` | float | `0.2` | Efecto inmediato |
| `per_step_delta` | float | `0.03` | Efecto acumulativo |
| `cap` | float | `0.6` | Maximo acumulado |
| `decay_steps` | int | `12` | Decaimiento posterior |

### 10.6 Estimacion de tamano del JSON maximalista

**Por arena (63 total):**
- Campos fisicos: ~11 campos, ~20 valores
- Campos temporales: ~5 campos, ~25 valores (con schedules)
- Campos sociales: ~11 campos, ~20 valores
- Campos emocionales: ~7 campos, ~15 valores
- Relaciones: ~3 campos, ~5 valores
- Eventos: ~3 campos, ~15 valores
- **Total por arena: ~40 campos, ~100 valores**

**Por objeto (225 total):**
- Affordances base: ~16 campos, ~20 valores
- Prerequisitos/outputs: ~3 campos, ~5 valores
- Affordances detalladas: ~3 affordances x 5 campos = ~15 valores
- Estado: ~5 campos, ~10 valores
- Trait mods: ~5 traits x 3 campos = ~15 valores
- Economicos: ~3 campos, ~3 valores
- Memoria: ~2 campos, ~3 valores
- **Total por objeto: ~35 campos, ~71 valores**

**Totales globales:**

| Nivel | Items | Valores/item | Total valores |
|---|---|---|---|
| Meta | 1 | ~10 | 10 |
| Defaults (sector types) | 4 | ~25 | 100 |
| Defaults (object types) | 8 | ~10 | 80 |
| Sectors | 19 | ~9-40 | 171-760 |
| Arenas | 63 | ~100 | 6,300 |
| Objects | 225 | ~71 | 15,975 |
| Trait modifiers | ~10-24 traits | ~15 | 150-360 |
| Overlays temporales | - | - | 1,800-8,000+ |
| **TOTAL (razonable)** | | | **~22,000-24,000 valores** |
| **TOTAL (maximalista de verdad)** | | | **~38,000-45,000+ valores** |

**Estimacion en lineas JSON:**
- Con herencia (arena solo declara overrides): **~12,000-18,000 lineas**
- Sin herencia (todo explicito): **~40,000-50,000 lineas**
- Tamano en disco (con herencia): **~400 KB - 2 MB**
- Tamano en memoria (dicts Python parseados): **~200-400 KB**

**Conclusion de escala:** Es grande pero manejable. No es un problema tecnico (se parsea en <100ms). El reto es la mantenibilidad humana, no la performance.

---

## 11. Ejemplo Completo: Hobbs Cafe

Se presentan dos perspectivas del mismo espacio: una mas ingenieria-de-simulacion (con modifier_rules, routing, 16 niveles de herencia) y otra mas game-design (con need_delta, estados mutables, radius_effect). Ambas son complementarias.

### 11.1 Arena maximalista (perspectiva simulacion)

```json
{
  "id": "hobbs_cafe_main_room",
  "label": "cafe",
  "type": "public",
  "subtype": "cafe_room",
  "tags": [
    "commercial", "food_service", "third_place", "music_possible", "social"
  ],
  "access": "public",
  "access_rules": {
    "roles_allowed": ["customer", "staff", "visitor"],
    "roles_preferred": ["customer", "staff"],
    "entry_requires_payment": false,
    "staff_only_subzones": ["behind the cafe counter", "cooking area"],
    "after_hours_locked": true
  },
  "gender": null,
  "age_rules": {"min_age": null, "max_age": null},
  "role_rules": {
    "barista_anchor": "behind the cafe counter",
    "kitchen_anchor": "cooking area",
    "performer_anchor": "piano",
    "customer_default_anchor_set": ["cafe customer seating", "piano"]
  },
  "capacity": {"soft": 18, "hard": 26, "staff_slots": 3, "queue_slots": 6},
  "tile_count": 76,
  "seat_count": 14,
  "queue_capacity": 6,
  "standing_capacity": 8,
  "atmosphere": "lively",
  "baseline_atmosphere": "casual",
  "proximity_mod": 1,
  "cooldown_mod": -2,
  "social_bonus": 2,
  "privacy_level": 0.25,
  "expected_formality": "casual",
  "max_group_size": 6,
  "allows_group_conversation": true,
  "conversation_type_cap": "extended",
  "conversation_types": ["casual", "gossip", "debate", "flirt", "business"],
  "max_volume": "normal",
  "min_volume": "low",
  "interruption_risk": 0.45,
  "eavesdropping_risk": 0.55,
  "allows_strangers_chat": true,
  "eavesdrop_radius": 4,
  "third_place_score": 0.9,
  "solo_comfort": 0.8,
  "date_suitability": 0.7,
  "study_suitability": 0.35,
  "work_suitability": 0.4,
  "rest_suitability": 0.3,
  "noise_level_db": 58,
  "lighting_level_lux": 320,
  "lighting_tone": "warm",
  "temperature_c": 22.5,
  "humidity": 0.46,
  "cleanliness": 0.78,
  "odor_notes": ["coffee", "baked_goods", "wood", "milk_foam"],
  "acoustics": "chatty_reverberant",
  "indoor": true,
  "visibility_profile": {
    "across_room": "medium",
    "from_entrance": "high",
    "to_counter": "high",
    "to_seating_nooks": "medium"
  },
  "sound_leakage": {
    "to_adjacent_arenas": 0.2,
    "from_street": 0.15,
    "from_kitchen": 0.3
  },
  "line_of_sight_blocks": ["counter", "support_column"],
  "opening_hours": {
    "mon": ["07:00", "20:00"],
    "tue": ["07:00", "20:00"],
    "wed": ["07:00", "20:00"],
    "thu": ["07:00", "20:00"],
    "fri": ["07:00", "22:00"],
    "sat": ["08:00", "22:00"],
    "sun": ["08:00", "18:00"]
  },
  "service_windows": [
    {"label": "breakfast", "start": "07:00", "end": "10:30", "menu_bias": ["coffee", "pastry"]},
    {"label": "lunch", "start": "12:00", "end": "14:30", "menu_bias": ["sandwich", "coffee"]},
    {"label": "evening_music", "start": "18:00", "end": "20:00", "menu_bias": ["dessert", "coffee"]}
  ],
  "peak_hours": [
    {"label": "morning_commute", "start": "07:30", "end": "09:30", "crowd": "high"},
    {"label": "lunch_rush", "start": "12:00", "end": "14:00", "crowd": "high"},
    {"label": "after_class", "start": "16:30", "end": "18:30", "crowd": "medium_high"}
  ],
  "time_overlays": {
    "early_morning": {
      "atmosphere": "quiet", "noise_level_db": 42, "social_bonus": 0,
      "study_suitability": 0.45, "work_suitability": 0.5,
      "odor_notes": ["fresh_coffee", "clean_air"]
    },
    "morning": {
      "atmosphere": "busy", "noise_level_db": 60, "social_bonus": 1,
      "queue_capacity_pressure": 0.5, "interruption_risk": 0.55
    },
    "noon": {
      "atmosphere": "lively", "noise_level_db": 64, "social_bonus": 2,
      "max_group_size": 5, "interruptibility": 0.6
    },
    "afternoon": {
      "atmosphere": "casual", "noise_level_db": 56,
      "study_suitability": 0.4, "solo_comfort": 0.82
    },
    "evening": {
      "atmosphere": "relaxed", "lighting_tone": "amber",
      "date_suitability": 0.82, "music_event_bias": 0.2, "linger_bonus": 0.25
    },
    "night": {
      "atmosphere": "private", "social_bonus": 1,
      "privacy_level": 0.35, "eavesdropping_risk": 0.35
    }
  },
  "weekday_overlays": {
    "mon": {"crowd_bias": 0.05},
    "fri": {"social_bonus": 3, "max_group_size": 7},
    "sat": {"date_suitability": 0.85, "linger_bonus": 0.35}
  },
  "weather_overlays": {
    "rain": {"crowd_bias": 0.2, "solo_comfort": 0.88, "odor_notes": ["coffee", "wet_street"]},
    "heat": {"temperature_c": 24.0, "linger_penalty": 0.15}
  },
  "crowding_overlays": {
    "low": {"privacy_level": 0.42, "study_suitability": 0.48},
    "medium": {"social_bonus": 2},
    "high": {"interruption_risk": 0.75, "queue_penalty": 0.4, "study_suitability": 0.2}
  },
  "event_overlays": {
    "live_piano": {"noise_level_db": 67, "social_bonus": 3, "date_suitability": 0.88},
    "staff_conflict_recent": {
      "memory_residue": {"tension": 0.45, "warmth": -0.1},
      "conversation_type_cap": "brief"
    }
  },
  "emotional_effects": {
    "instant": {"comfort": 0.2, "energy": 0.12, "belonging": 0.18},
    "per_step": {"comfort": 0.01, "social_readiness": 0.02},
    "caps": {"comfort": 0.45, "energy": 0.25, "belonging": 0.4},
    "decay_steps": 18
  },
  "stress_effects": {
    "base": {"anxiety": -0.02},
    "high_crowd": {"anxiety": 0.08}
  },
  "memory_bias": {
    "salience": 1.25, "social_memory_boost": 1.4,
    "food_memory_boost": 1.1, "music_memory_boost": 1.35
  },
  "identity_signaling": {
    "status_signal": 0.25, "creative_signal": 0.45, "community_signal": 0.6
  },
  "duration_policy": {
    "default_steps": 12, "range": [5, 25],
    "variance_model": "bounded_random",
    "hard_min_steps": 2, "hard_max_steps": 45,
    "extend_if_engaged": true, "truncate_if_interrupted": true
  },
  "linger_policy": {
    "after_purchase_bonus": [2, 8],
    "after_social_contact_bonus": [3, 12],
    "solo_idle_penalty": -2,
    "close_to_closing_penalty": -6
  },
  "exit_pressure": {"near_close_minutes": 30, "penalty": 0.4, "hard_eject_at_close": true},
  "entry_friction": {
    "queue_if_busy": true, "queue_abandon_threshold_steps": 8,
    "cost_of_entry": 0.0, "social_friction_for_strangers": 0.05
  },
  "movement_policy": {
    "preferred_mode": "in_place", "seat_seek": true,
    "queue_before_service": false, "counter_visit_probability": 0.35
  },
  "seat_selection_policy": {
    "prefer_window": 0.2, "prefer_center": 0.1,
    "prefer_near_music_if_social": true,
    "prefer_perimeter_if_introvert": true,
    "prefer_visible_spot_if_status_seeking": true
  },
  "queue_policy": {"forms_single_line": true, "line_anchor": "behind the cafe counter"},
  "service_policy": {"requires_order_before_seating": false, "staff_serves_counter_only": true},
  "resource_costs": {"coffee": 4.5, "pastry": 3.0, "sandwich": 7.5},
  "resource_generation": {"social_opportunities": 0.7, "comfort_tokens": 0.4},
  "social_rules": {
    "normative_topics": ["plans", "small_talk", "local_gossip", "work", "classes"],
    "discouraged_topics": ["shouting_argument", "public_confession_if_crowded"],
    "expected_greeting_style": "friendly_informal",
    "linger_after_greeting_bias": 0.3
  },
  "formal_rules": {"no_sleeping_on_tables": true, "no_staff_area_for_customers": true},
  "security_rules": {"staff_only_subzones": ["behind the cafe counter", "cooking area"]},
  "random_events": [
    {"event": "live_music", "probability": 0.1, "time_window": [18, 21],
     "effect": {"atmosphere": "lively", "social_magnet": 0.3}},
    {"event": "crowded_rush", "probability": 0.2, "time_window": [12, 13],
     "effect": {"noise_mod": 0.3, "stress_factor": 0.15}},
    {"event": "quiet_moment", "probability": 0.15, "time_window": [15, 17],
     "effect": {"atmosphere": "peaceful", "inspiration_chance": 0.1}},
    {"event": "someone_plays_piano", "probability": 0.08, "time_window": [10, 20],
     "effect": {"atmosphere": "musical", "social_magnet": 0.2}}
  ],
  "scheduled_events": [
    {"event": "open_mic_night", "day": "friday", "time": 19, "duration_hours": 3,
     "effect": {"atmosphere": "lively", "crowd_mult": 1.5}}
  ],
  "memory_residue": {"warmth": 0.4, "tension": 0.05, "novelty": 0.1, "residual_decay_hours": 12},
  "memory_traces": {"max_age_hours": 48, "decay_rate": 0.04},
  "trait_modifiers": {
    "introvert": [
      {"target": "seat_selection_policy.prefer_perimeter_if_introvert", "op": "set", "value": true,
       "explain": "introverts look for edge seating"},
      {"target": "duration_policy.default_steps", "op": "add", "value": 2,
       "explain": "comfortable solo cafe time"},
      {"target": "max_group_size", "op": "add", "value": -2,
       "explain": "prefers smaller clusters"}
    ],
    "extrovert": [
      {"target": "social_bonus", "op": "add", "value": 1},
      {"target": "proximity_mod", "op": "add", "value": 1},
      {"target": "duration_policy.range", "op": "expand", "value": [0, 10]}
    ],
    "social": [
      {"target": "cooldown_mod", "op": "add", "value": -1},
      {"target": "allows_group_conversation", "op": "set", "value": true}
    ],
    "studious": [
      {"target": "study_suitability", "op": "add", "value": 0.15},
      {"target": "interruption_risk", "op": "add", "value": 0.1}
    ],
    "lazy": [
      {"target": "duration_policy.default_steps", "op": "add", "value": 4,
       "explain": "likely to linger over coffee"}
    ],
    "creative": [
      {"target": "objects.piano.affordances[0].probability_weight", "op": "add", "value": 0.2},
      {"target": "identity_signaling.creative_signal", "op": "add", "value": 0.2}
    ],
    "anxious": [
      {"target": "high_crowd_anxiety_penalty", "op": "set", "value": 0.25},
      {"target": "solo_comfort", "op": "add", "value": -0.1}
    ],
    "frugal": [
      {"target": "entry_friction.social_friction_for_strangers", "op": "add", "value": 0.05},
      {"target": "resource_costs.coffee", "op": "perceived_add", "value": 1.0}
    ],
    "romantic": [
      {"target": "date_suitability", "op": "add", "value": 0.12}
    ],
    "status_seeking": [
      {"target": "seat_selection_policy.prefer_visible_spot_if_status_seeking", "op": "set", "value": true},
      {"target": "identity_signaling.status_signal", "op": "add", "value": 0.15}
    ]
  },
  "state_modifiers": {
    "hungry": [{"target": "duration_policy.default_steps", "op": "add", "value": 6}],
    "tired": [{"target": "rest_suitability", "op": "add", "value": 0.1}],
    "under_time_pressure": [{"target": "duration_policy.hard_max_steps", "op": "add", "value": -10}]
  },
  "relationship_modifiers": {
    "close_friends_present": [
      {"target": "social_bonus", "op": "add", "value": 2},
      {"target": "duration_policy.default_steps", "op": "add", "value": 5}
    ],
    "person_of_interest_present": [
      {"target": "date_suitability", "op": "add", "value": 0.2}
    ]
  },
  "adjacent_arenas": [
    {"arena": "cooking area", "doorway": true, "sound_leakage": 0.3, "visibility": 0.2}
  ],
  "routing_connectors": [
    {"to": "street_entrance", "width": 2, "traffic_bias": 0.7}
  ]
}
```

### 11.2 Objeto: piano (perspectiva combinada)

```json
{
  "id": "hobbs_piano_01",
  "label": "piano",
  "type": "instrument",
  "subtype": "upright_piano",
  "tags": ["music", "attention", "performance", "creative"],
  "anchor_weight": 0.98,
  "interaction": ["play", "social"],
  "default_action": "practice",
  "duration_policy": {
    "default_steps": 18,
    "range": [10, 35],
    "max_override": 90,
    "variance_model": "bounded_random",
    "mood_mod": true
  },
  "duration_by_action": {
    "practice": [10, 25],
    "perform": [5, 20],
    "improvise": [8, 18]
  },
  "occupancy": {"min_agents": 1, "max_agents": 1},
  "stance": "seated",
  "required_mode": "in_place",
  "movement_pattern": "fixed_anchor",
  "interaction_spot_offset": [0, -1],
  "visibility_when_used": 0.9,
  "audibility_when_used": 0.95,
  "social_pull_when_used": 0.7,
  "privacy_when_used": 0.1,
  "prestige_signal": 0.45,
  "energy_cost": 0.25,
  "fun_value": 0.8,
  "comfort_value": 0.3,
  "beauty_value": 0.5,
  "skill_category": "music",
  "skill_gain_rate": 0.05,
  "skill_requirement": 0.0,
  "recreation_type": "musical",
  "noise_output": 0.7,
  "resource_inputs": [],
  "resource_outputs": [{"id": "music_experience", "qty": 1}],
  "economic_cost": {"money": 0},
  "fatigue_effects": {"energy": -0.05},
  "emotional_effects": {"instant": {"joy": 0.22, "self_expression": 0.3}},
  "relationship_effects": {"shared_observation": {"bond": 0.08}},
  "memory_bias": {"salience": 1.4},
  "time_rules": {"preferred": ["evening", "afternoon"], "discouraged": ["morning_commute"]},
  "states": {
    "idle": {"transitions": ["in_use"]},
    "in_use": {"transitions": ["idle", "needs_tuning"]},
    "needs_tuning": {"transitions": ["idle"]}
  },
  "initial_state": "idle",
  "degradation_rate": 0.008,
  "maintenance_action": "tune",
  "break_probability": 0.002,
  "use_history_affects": {"fun": {"direction": "diminishing", "rate": 0.02, "floor": 0.4}},
  "personal_attachment": true,
  "affordances": [
    {
      "action": "practice",
      "prompt_verbs": ["play", "practice", "rehearse"],
      "probability_weight": 0.5,
      "duration": [10, 25],
      "need_delta": {"fun": 20, "energy": -20},
      "skill_delta": {"music": 5},
      "social_visibility": 0.8,
      "noise_output": 0.9,
      "mood_effect": {"joy": 0.2},
      "radius_effect": {"type": "ambient_music", "radius": 3, "affected_need": "fun", "delta": 3}
    },
    {
      "action": "perform",
      "prompt_verbs": ["perform", "play for the room"],
      "probability_weight": 0.2,
      "duration": [5, 20],
      "need_delta": {"fun": 30, "social": 20, "energy": -15},
      "skill_delta": {"music": 3},
      "prerequisites": ["music_skill >= 0.3"],
      "radius_effect": {"type": "entertainment", "radius": 6, "affected_need": "fun", "delta": 15}
    },
    {
      "action": "improvise",
      "prompt_verbs": ["improvise", "jam"],
      "probability_weight": 0.15,
      "duration": [8, 18],
      "need_delta": {"fun": 40, "energy": -10},
      "skill_delta": {"music": 2},
      "radius_effect": {"type": "ambient_music", "radius": 4, "affected_need": "fun", "delta": 5}
    }
  ],
  "event_hooks": [{"event_id": "someone_stops_to_listen", "weight": 0.18}],
  "trait_modifiers": {
    "creative": {"fun_bonus": 0.3, "duration_mult": 1.2, "skill_gain_mult": 1.3},
    "musical": {"duration_mult": 1.2, "skill_gain_mult": 1.3, "fun_bonus": 0.2},
    "social": {"social_magnet_bonus": 0.15},
    "anxious": {"duration_mult": 0.7, "fun_mult": 0.8},
    "tone_deaf": {"fun_mult": 0.5, "skill_gain_mult": 0.3}
  }
}
```

---

## 12. Roadmap Recomendado

### Secuencia por fases

| Fase | Campos | Impacto en Realismo | Esfuerzo | Archivos a Tocar |
|---|---|---|---|---|
| **F1: Duraciones** | `duration.base` por objeto, `duration.max_override` | Alto — elimina duraciones absurdas del LLM | Bajo | maze_registry.json, maze.py (accessor), execute.py (consumir), scratch.py |
| **F2: Affordances expandidas** | `interaction` con verbos especificos, `affordances` array | Alto — constrains accion del LLM, reduce alucinaciones | Bajo | maze_registry.json, maze.py, plan.py (filtrar opciones) |
| **F3: Social rules** | `max_group_size`, `volume_norm`, `formality`, `conversation_types` | Medio — conversaciones contextualmente apropiadas | Medio | maze_registry.json, maze.py, conversation_manager.py |
| **F4: Temporal** | `temporal_atmosphere`, `operating_hours`, `peak_hours` | Medio — mundo dinamico que cambia con el dia | Medio | maze_registry.json, maze.py (resolver por hora), plan.py |
| **F5: Emotional** | `mood_effect`, `comfort_rating`, `stress_factor` | Medio-Alto — agentes afectados por el espacio | Alto | maze_registry.json, maze.py, reflect.py, scratch.py (mood state) |
| **F6: Personalidad estructurada / Trait mods** | `trait_mods` por objeto y arena + taxonomia normalizada | Medio — personalidad modifica experiencia | Alto | trait_modifiers.json, maze.py, plan.py, execute.py |
| **F7: Events/Memory** | `random_events`, `scheduled_events`, `memory_traces` | Alto — mundo vivo con historia | Alto | maze_registry.json, maze.py, perceive.py, nuevo subsistema |

### Detalle por fase

#### Fase 1: Control declarativo de duraciones

**Objetivo:**
- Mover `duration_min` base desde el LLM al registro
- Mantener bounded randomness
- No tocar todavia traits complejos

**Por que primero esto:**
- Mayor ROI
- Menor riesgo
- Mejor punto de prueba del paradigma

**Podria implementarse en una sesion.**

#### Fase 2: Affordances enriquecidas por objeto

**Objetivo:**
- Pasar de `interaction` a `affordances`
- Seguir soportando `interaction` como backward compatibility

**Resultado esperado:**
- Planners mas contenidos
- Menos hallucination de acciones impropias

#### Fase 3: Reglas sociales de arena

**Objetivo:**
- Ampliar `atmosphere` hacia reglas mas estructuradas

**Resultado esperado:**
- Conversaciones mas coherentes
- Diferencias claras entre biblioteca, pub, aula, cafe

**Extension natural del sistema de conversacion que ya consume atmosphere y modifiers.**

#### Fase 4: Overlays temporales

**Objetivo:** morning/noon/evening/night, clima, crowding, eventos.

**Resultado esperado:** el mundo deja de ser estatico.

#### Fase 5: Emotional effects

**Nota:** requiere que scratch.py tenga un modelo de mood/estado emocional para que los campos tengan efecto.

#### Fase 6: Personalidad estructurada

**Objetivo:**
- Dejar de depender de texto libre para traits
- Introducir taxonomia normalizada

**Sin esto, los `trait_modifiers` serios no son confiables.**

#### Fase 7: Memoria residual del espacio y economia

**Objetivo:** que el lugar "recuerde", que los objetos/arenas consuman y produzcan recursos.

Esto es lo mas realista y tambien lo mas caro de mantener. Lo haria mas tarde.

---

## 13. Veredicto Final

### La idea es buena?

**Si, es muy buena.** Tiene:

1. **Fundamento academico solido**: affordance theory (Gibson, Sahin, Klugl, Lemee), A&A framework (Weyns, Omicini, Ricci), structured world knowledge (WorldCoder, Voyager, AgentSociety, SocioVerse)
2. **Validacion comercial masiva**: The Sims (30+ anos de exito), RimWorld, Dwarf Fortress, ONI, Factorio — todos usan variantes del mismo patron
3. **Llena una brecha reconocida**: el paper original de Generative Agents (Park et al. 2023) no tiene metadata prescriptiva en el entorno. La comunidad (AgentSociety 2025, SocioVerse 2025) reconoce explicitamente esta brecha
4. **Tendencia actual**: la comunidad 2024-2025 se mueve hacia representaciones estructuradas del mundo, no mas LLM-decide-todo
5. **Ya demostro valor en nuestro proyecto**: el registry actual (con solo 7 campos por arena y 2 por objeto) ya reemplazo ~500 lineas de regex y es la base de LocationResolver V2

### Tiene limites?

**Si, tres limites claros:**

1. **El JSON maximalista completo (~22K valores) es un proyecto en si mismo.** No se implementa de una vez. Debe ser incremental: primero duraciones y affordances (maximo impacto, minimo esfuerzo), luego social rules, luego temporal, luego emotional.
2. **El balance determinismo/emergencia requiere tuning continuo.** No hay un valor "correcto" para `shower_duration`. Se necesitan runs de simulacion, analisis de realismo, y ajuste iterativo. El JSON facilita esto (cambiar un numero vs cambiar prompts), pero el trabajo de tuning no desaparece.
3. **A partir de ~500 reglas complejas con temporal overrides y trait modifiers, el JSON monolitico se vuelve dificil de mantener.** En ese punto, migrar a Supabase tables con el JSON como seed/fallback.

### Conclusion critica: dos condiciones necesarias

La idea no es mala. De hecho, es de las mejores direcciones posibles para este proyecto, con dos condiciones:

1. **No venderla como "un JSON gigante resuelve todo".** Sin un evaluador runtime con tipado, herencia, overlays, traits normalizados y observabilidad, solo se mueve complejidad de un lugar a otro.
2. **No usar texto libre de personalidad como base de modifiers serios.** El cuello de botella mas serio no es el mapa sino la personalidad: hoy los rasgos del agente no existen como taxonomia estructurada.

Lo mejor que puede ser `maze_registry.json` no es "una lista de lugares".
Lo mejor que puede ser es "la capa declarativa de semantica del mundo".

Eso significa:
- el mapa sigue diciendo que existe
- el registro tambien dice que habilita
- que costo tiene
- cuanto dura
- que normas sociales impone
- que emociones induce
- como cambia con el tiempo
- y como distintos tipos de agente lo viven distinto

Pero el runtime sigue siendo necesario para:
- resolver herencia
- evaluar condiciones
- samplear variacion
- aplicar modifiers de persona y estado
- registrar explicaciones

### El approach hibrido

El diseno recomendado no es "JSON reemplaza al LLM". Es "JSON constrains y enriquece al LLM":

- El JSON define el **80% comun** (duracion normal, affordances standard, reglas sociales)
- El LLM decide el **20% excepcional** (overrides por mood, decisiones sociales complejas, narrativa emergente)
- Nunca: el JSON decide 100% de nada (siempre hay escape hatch para el LLM)
- Nunca: el LLM decide 100% de nada critico (siempre hay constraints del JSON)

Esto es exactamente el patron que The Sims usa desde 2000 y que la academia valida como el estado del arte.

### Recomendacion en una linea

`maze_registry.json` si deberia convertirse en la superficie central de semantica del mundo, pero no como archivo monolitico ingenuo; deberia evolucionar a un sistema declarativo con tipado, herencia, overlays, traits normalizados y runtime explicable.

### Observaciones finales

1. El schema maximalista no deberia vivir solo para controlar agentes; tambien podria alimentar tooling de diseno, debuggers de simulacion, explainability UI y telemetria.
2. Si este sistema madura, convendria pensar en un paso de compilacion: `maze_registry_source.json` -> `compiled_runtime_registry.json`, para aplanar herencia y validar referencias una sola vez.
3. Tambien convendria capturar trazas por decision del tipo `world_rule_trace`, porque cuando aparezcan bugs emergentes no va a bastar con leer el JSON a ojo.
4. Si se quiere realismo fuerte, los mejores campos no son solo "acciones permitidas" sino "costos, fricciones y aftereffects". Mucho del comportamiento humano no viene de lo que es posible sino de lo que es incomodo, caro, vergonzoso, ruidoso o socialmente extrano.
5. El mapa ideal no solo describe lugares. **Describe presiones.**

---

## Apendice A: Papers Citados (referencia completa)

### Affordances

1. Gibson, J. J. (1979). *The Ecological Approach to Visual Perception*. Houghton Mifflin.
2. Sahin, E. E., Cakmak, M., Dogar, M. R., Ugur, E., Ucoluk, G. (2007). *To What Extent Can We Formalize Affordances for Robotics?*
3. Zech, P., Haller, M., Lakani, S. R., Gienger, L.-J. L., Ugur, M., Peters, J. (2017). *Computational Models of Affordance in Robotics: a Taxonomy and Systematic Classification*.
4. Shu, T., Ryoo, M. S., Zhu, S.-C. (2016). *Learning Social Affordance for Human-Robot Interaction*. https://arxiv.org/abs/1604.03692
5. Riccio, F., Capobianco, R., Hanheide, M., Nardi, D. (2016). *STAM: A Framework for Spatio-Temporal Affordance Maps*. https://arxiv.org/abs/1607.00354
6. Klugl, F. (2016). *Using the affordance concept for model design in agent-based simulation*. Annals of Mathematics and AI, vol. 78, pp. 21-44. Springer.
7. Lemee, Vachtsevanou, Mayer, Ciortea (2024). *Signifiers for conveying and exploiting affordances: from human-computer interaction to multi-agent systems*. Annals of Mathematics and AI. Springer.
8. Penn State / U. Arizona (2011). *Human Behavioral Simulation Using Affordance-Based Agent Model*. Springer LNCS.
9. *Affordance-based agent model for road traffic simulation*. AAMAS (Springer).

### Multi-Agent Systems y Environment

10. Weyns, D., Schumacher, M., Ricci, A., Viroli, M., Holvoet, T. (2005). *Environment as a First Class Abstraction in Multiagent Systems*.
11. Weyns, D., Omicini, A., Odell, J. (2007). *Environment as a first class abstraction in multiagent systems*. AAMAS, vol. 14, pp. 5-30. Springer.
12. Weyns, D., Michel, F., Parunak, H. V. D., Ferber, J., et al. (2015). *Agent Environments for Multi-Agent Systems: A Research Roadmap*. https://www.lirmm.fr/~fmichel/publi/pdfs/weyns15e4mas_roadmap.pdf
13. Ricci, A., Viroli, M., Omicini, A. (2008). *Artifacts in the A&A meta-model for multi-agent systems*. AAMAS. Springer.
14. Ricci, A. et al. (2011). *Environment programming in multi-agent systems: an artifact-based perspective*. AAMAS. Springer.
15. Helleboogh, A., Vizzari, G., Uhrmacher, A., Michel, F. (2006/2007). *Modeling Dynamic Environments in Multi-Agent Simulation*. https://paperzz.com/doc/7898701/modeling-dynamic-environments-in-multi-agent-simulation
16. Platon, E., Mamei, M., Sabouret, N., Honiden, S., Parunak, H. V. D. (2007). *Mechanisms for Environments in Multi-Agent Systems: Survey and Opportunities*.
17. *Signifiers as a First-class Abstraction in Hypermedia Multi-Agent Systems* (2023). AAMAS 2023.

### LLM Agents y Simulacion Social

18. Park, J. S., O'Brien, J. C., Cai, C. J., Morris, M. R., Liang, P., Bernstein, M. S. (2023). *Generative Agents: Interactive Simulacra of Human Behavior*. UIST 2023. https://arxiv.org/abs/2304.03442
19. Vezhnevets, A. S., Agapiou, J. P., et al. (2023). *Generative Agent-Based Modeling with Actions Grounded in Physical, Social, or Digital Space using Concordia*. https://arxiv.org/abs/2312.03664
20. Gao, C., Lan, X., Li, N., et al. (2023). *Large Language Models Empowered Agent-based Modeling and Simulation: A Survey and Perspectives*. https://arxiv.org/abs/2312.11970

### Tendencia 2024-2025

21. Wang, G., Xie, Y., et al. (2023). *Voyager: An Open-Ended Embodied Agent with Large Language Models*. NeurIPS 2023. https://arxiv.org/abs/2305.16291
22. Tang, H., Key, D., Ellis, K. (2024). *WorldCoder, a Model-Based LLM Agent*. NeurIPS 2024. https://proceedings.neurips.cc/paper_files/paper/2024/hash/820c61a0cd419163ccbd2c33b268816e-Abstract-Conference.html
23. Wu, Y., Min, S. Y., et al. (2023). *SPRING: Studying the Paper and Reasoning to Play Games*. NeurIPS 2023. https://arxiv.org/abs/2305.15486
24. *AgentSociety* (2025). https://arxiv.org/html/2502.08691v1
25. *SocioVerse* (2025). https://arxiv.org/html/2504.10157
26. *A Comprehensive Survey on Context-Aware Multi-Agent Systems* (2024). https://arxiv.org/html/2402.01968v2

### Context-Aware Computing

27. Salber, D., Dey, A. K., Abowd, G. D. (1999). *The Context Toolkit: Aiding the Development of Context-Aware Applications*.
28. Chen, G., Kotz, D. (2000). *A Survey of Context-Aware Mobile Computing Research*.

## Apendice B: Juegos Referenciados

1. **The Sims** (Maxis, 2000-presente) — Sistema BHAV/BCON, advertised values, XML tuning (Sims 4). https://donhopkins.com/home/TheSimsDesignDocuments/TheSimsDesignDocumentDraft5-DonsReview.pdf
2. **Dwarf Fortress** (Bay 12 Games, 2006-presente) — Room quality system, workshop-driven behavior. https://dwarffortresswiki.org/index.php/Visitor
3. **RimWorld** (Ludeon Studios, 2018) — Room stats, XML Defs, recreation types, interaction spots. https://rimworldwiki.com/wiki/Rooms
4. **Oxygen Not Included** (Klei Entertainment, 2019) — Auto-clasificacion de rooms por contenido
5. **Kenshi** (Lo-Fi Games, 2018) — FCS data-driven buildings
6. **Stardew Valley** (ConcernedApe, 2016) — JSON/xnb object declarations
7. **Caves of Qud** (Freehold Games) — XML tag-based object system
8. **Factorio** (Wube Software, 2020) — Lua prototype system, gold standard de data-driven design
