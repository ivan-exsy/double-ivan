# Double v1 — World Primitives Spec (covers cities, products, trade, war, police, stock exchange)

## 0) Design goals
- Enable “anything” by composing a small set of primitives.
- Keep simulation **deterministic**, **budgeted**, and **safe**.
- Support both local hosting and paid always-on hosting.
- Keep the world **isolated** from the real world by default.

---

## 1) Core model: Entity-Component + Event Log

### 1.1 Entities (nouns)
Each thing in the world is an **Entity** with an ID and a set of components.

**Core entity types**
- `Actor` (Double, NPC)
- `Parcel` (land tile / lot)
- `Building` (structure on a parcel)
- `Item` (resource or product)
- `Container` (inventory, warehouse)
- `Vehicle` (optional; logistics)
- `Organization` (company, faction, government)
- `Market` (shop, exchange, auction)
- `Contract` (employment, lease, loan, insurance, treaty)
- `Law` (rules with enforcement)
- `District` (shard / region)
- `Realm` (world instance)

### 1.2 Components (attributes)
Examples (not exhaustive):
- `Location { district_id, x, y, z? }`
- `Inventory { slots, item_stacks[] }`
- `Ownership { owner_entity_id, rights[] }`
- `Skills { skill_name -> level }`
- `Roles { role_name -> scope }` (police, judge, soldier, mayor)
- `Stats { health, stamina, morale, reputation }`
- `Production { recipes[] }`
- `OrderBook { bids[], asks[] }` (advanced)
- `Wallet { currency -> amount }`
- `Identity { display_name, handle }`

### 1.3 Events (verbs)
The canonical record is an append-only event log.

**Example event types**
- Space/build: `ClaimParcel`, `BuildBuilding`, `UpgradeBuilding`, `Demolish`
- Movement/action: `Move`, `Interact`, `Attend`, `WorkShift`
- Economy: `Harvest`, `Craft`, `TransferItem`, `ListForSale`, `Buy`, `PayWage`
- Org/governance: `CreateOrg`, `AssignRole`, `ProposeLaw`, `EnactLaw`
- Enforcement: `IssueCitation`, `Arrest`, `Fine`, `SeizeAsset`
- Conflict: `DeclareWar`, `Attack`, `CaptureParcel`, `SignTreaty`
- Finance: `CreateSecurity`, `IssueShares`, `PlaceOrder`, `Trade`, `Settle`

**Rule:** State is derived by replaying events + applying deterministic reducers.

---

## 2) Time & simulation

### 2.1 Discrete ticks
- Simulation advances in ticks (e.g., 1 minute per tick).
- Per tick:
  1) collect intents,
  2) validate against rules + budgets,
  3) apply reducers,
  4) emit events.

### 2.2 Determinism requirements
- No nondeterministic randomness without a seeded RNG stored in state.
- Same inputs + same seed = same world outcomes.

---

## 3) Hosting & scale primitives

### 3.1 Realms and districts
- A `Realm` is a world instance (friend group universe).
- A realm is split into `District`s (spatial shards).

### 3.2 Authoritative host
Each district has one authoritative host:
- free tier: a selected peer device host,
- paid tier: an always-on cloud node.

Cross-district interaction happens via message/events, never shared memory.

### 3.3 “Actor objects” for consistency
Any object that needs strong consistency is handled by a single serialized “owner”:
- parcel ownership
- inventories
- market/exchange order books
- security/share registry

---

## 4) Capability boundaries (world-only by default)
**World API** is the only exposed toolset to Doubles unless user explicitly enables more.

Examples:
- `world.move(actor, to)`
- `world.build(parcel, blueprint)`
- `world.craft(actor, recipe)`
- `world.trade(market, order)`
- `world.enforce(law_action)`
- `world.conflict(action)`

No OS access, no email, no SMS by default.

---

## 5) The module system (how “anything” is enabled)

A **Module** is a package that adds:
1) new entities/components,
2) new event types,
3) validation rules,
4) reducers (state updates),
5) optional UI/editor affordances.

### 5.1 Required official modules (v1+)
- `EconomyCore`: items, wallets, recipes, marketplaces
- `CityKit`: parcels, buildings, zoning, utilities
- `Organizations`: companies, factions, governments
- `LawAndOrder`: laws, roles, enforcement actions
- `Conflict`: war, territory, combat, treaties
- `Finance`: securities, exchange, settlement (later)

### 5.2 Community modules (safe extension)
Community can safely extend:
- content: items, buildings, jobs, recipes
- scenarios: events, quests, templates

Community cannot safely extend (without review):
- new privileged enforcement powers
- cross-realm networking
- anything that alters hosting/security boundaries

---

## 6) World Rules DSL (safe programmability)

### 6.1 What DSL must express
- Recipes: input -> output with time/energy/waste
- Prices/taxes: fees, tariffs, VAT, subsidies
- Employment: wage, schedule, performance
- Zoning: what can be built where
- Law: forbidden actions + penalties
- War: triggers, victory conditions, rules of engagement

### 6.2 Example DSL snippets (illustrative)

**Recipe**
- `recipe bread: inputs { flour:2, water:1 } time 30m outputs { bread:1 }`

**Tax**
- `tax sales_tax: applies_to market_sales rate 0.06 pay_to org:CityGov`

**Law**
- `law theft: when TransferItem without consent penalty Fine(50) + Reputation(-10)`

**War rule**
- `war_rule capture: parcel_control changes when faction_presence > 60% for 6h`

**Budget cap**
- `limit max_events_per_tick 200`
- `limit max_entities_touched_per_action 50`

---

## 7) Primitives that cover your examples

### 7.1 “Build new cities”
Use:
- `Parcel`, `Building`, `Ownership`, `ZoningRule`, `Utility` (power/water)
Events:
- `ClaimParcel`, `BuildBuilding`, `ConnectUtility`

### 7.2 “Produce products / sell produce”
Use:
- `Item`, `Recipe`, `Container`, `Market`, `Wallet`
Events:
- `Harvest`, `Craft`, `ListForSale`, `Buy`, `TransferItem`

### 7.3 “Go to war”
Use:
- `Organization` (factions), `Territory` (parcel control), `Unit` (optional)
Events:
- `DeclareWar`, `Attack`, `CaptureParcel`, `SignTreaty`
Constraints:
- supply lines via items/containers
- morale via stats

### 7.4 “Work in police”
Use:
- `Role` + `Law` + `Evidence` (optional) + `EnforcementAction`
Events:
- `IssueCitation`, `Arrest`, `Fine`, `SeizeAsset`
Constraints:
- scope-limited powers (district, org)
- audit trail from event log

### 7.5 “Open stock exchange”
Start simple, then extend:

**v1 (simple market)**
- fixed-price marketplace + “company shares” as items

**v2 (real exchange)**
Use:
- `Security` (share registry), `Exchange` (order book), `Settlement`
Events:
- `CreateSecurity`, `IssueShares`, `PlaceOrder`, `Trade`, `Settle`
Constraints:
- serialized ownership for settlement prevents double-spend

---

## 8) Safety & performance budgets (non-negotiable for scale)

### 8.1 Simulation budgets
- max CPU time per tick
- max events per tick
- max entities touched per action
- max memory per district
- max mod execution time (if any)

### 8.2 Validation pipeline
Before a rule pack / template is runnable:
- static validation (schema, limits)
- sandbox simulation smoke test
- publish with a “trust level” label

---

## 9) Highlight generation hooks (story layer)
The engine emits **Story Markers** as events:
- `StoryBeat` (betrayal, romance, promotion, bankruptcy, arrest, victory)
- `ConflictSpike`
- `MarketCrash`
- `ElectionResult`

Highlight generator selects and renders:
- top beats + context + “why” explanations

---

## 10) Minimal v1 primitive list (recommended)
If you want the smallest set that still covers most cases:

**Entities**
1. Actor
2. Parcel
3. Building
4. Item
5. Container
6. Organization
7. Market
8. Contract
9. Law
10. District/Realm

**Components**
1. Location
2. Ownership
3. Inventory
4. Wallet
5. Roles
6. Skills/Stats
7. Production (recipes)
8. Control (parcel/faction)
9. Reputation
10. Limits (budgets)

**Events**
1. Claim/Build/Upgrade
2. Move/Interact/Work
3. Craft/Harvest/Transfer
4. List/Buy/Pay
5. CreateOrg/AssignRole/EnactLaw
6. Enforce (fine/arrest/seize)
7. DeclareWar/Attack/Capture/Treaty
8. (Later) IssueShares/PlaceOrder/Trade/Settle

This set enables cities, products, selling, police, war, and a path to finance.

