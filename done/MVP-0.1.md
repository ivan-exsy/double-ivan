# MVP-0.1: Downtown Pittsburgh — spatial spec (LeaderTalks)

> **Product MVP is LeaderTalks in Pittsburgh** (Telegram; Downtown / PPG). Breakfasts is a **rehearsal** on village / Hobbs, not this file’s ship.  
> **Breakfasts rehearsal (locked):** sim `pittsburgh-business-breakfasts` is maze **`the_ville` / Hobbs**. Portal onboard APIs are **live**. Job picker shows role + workplace. Watch iframe passes `?double=`.  
> **This file is spatial numbers + Downtown look** for LeaderTalks. Progress: [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md). Breakfasts locks: [`MVP-breakfasts.md`](MVP-breakfasts.md). Watch honesty: `double-ivan/20260917_pre-MVP.md`. LeaderTalks work: `double-ivan/TODO_post_mvp.md`. Founder Breakfasts clicks: [`MVP-breakfasts_ivan.md`](MVP-breakfasts_ivan.md). Nico how-to: [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md).  
> Do **not** treat §1.3 / §4 / §6 “park APIs until look” or “Downtown is Saturday Breakfasts” as live. **§4 workstream 2 (onboard) is superseded by A2 on www.** Workstreams 1 (Downtown look) and 4 (9:16 video / B2B / Find My Double) are **LeaderTalks MVP**. First-pass rooms exist; they are not “hidden under roofs.”

**Target Cohort:** WhatsApp Group "Pittsburgh Business Breakfasts" (Local founders, executives, business owners)  
**Role of this Release (historical):** Breakfasts was the low-risk proof before LeaderTalks. **It is not the product MVP.** The product MVP is LeaderTalks in Pittsburgh.  
**Core Thesis:** Place authentic AI Doubles of real Pittsburgh business leaders into an authentic 2D Downtown Pittsburgh map running **Survival Mode**, where Doubles keep their real-world alter-ego roles.  
**Success Criteria:** Group members recognize their own and their peers' Doubles ("That sounds and acts just like him"), follow the strategic alliances, challenge performance, and nightly voting in Downtown Pittsburgh, and ask: *"Can we run this for our organization / company?"*

---

## 1. Strategic Framing & Product Decisions

### 1.1 De-risking the Vision with a Warm Cohort
Launching a public Survival simulation for the 300-person L-Talks Telegram group is high-stakes. Pivoting to the local "Pittsburgh Business Breakfasts" group provides:
1. **Warm, High-Trust Network:** Real-world peers who already know each other, meeting regularly for business in Pittsburgh.
2. **Instant Local Grounding:** Downtown Pittsburgh (Market Square, PPG Place, Grant Street corridor, Point State Park, the Three Rivers) makes the simulation visually relatable and emotionally compelling.
3. **High-Signal Feedback:** Immediate qualitative feedback on whether Doubles truly represent their real alter-egos in decision-making and voice.

### 1.2 Core Product Decisions (Locked)

1. **Survival Mode is Kept:**
   - We do **not** invent or maintain a separate "friendly business club" engine.
   - We drop the Business Breakfast Doubles directly into the battle-tested **Survival Mode** (11:00 AM Challenge, 20:00 PM Secret Vote, Alliances, Immunity Shield, Nightly Eliminations, Lived Board Facts).
   - The dramatic stakes of Survival create compulsive daily viewing, while the familiar business setting keeps it grounded.
2. **Doubles Keep Real-World Alter-Ego Roles:**
   - Doubles do **not** receive generic fantasy roles (e.g., barista, librarian).
   - Each Double inherits their human alter-ego’s actual business role, company, and industry (e.g., Tech Startup Founder & CEO, Commercial Real Estate Developer, Managing Partner / Angel Investor, Biotech Executive).
   - Their day-to-day work routines, conversational topics, and strategic negotiations reflect their real commercial acumen.
3. **Town Architecture (2D Phaser + Simplified Interiors):**
   - Follows [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md).
   - Continuous 1 m occupancy grid covering the Golden Triangle (4:1 scale, river-framed bbox).
   - Stylized 2D Phaser rendering resembling Downtown Pittsburgh landmarks.
   - Key gathering venues (e.g. PPG Cafe for challenges/votes, offices, meeting spaces) are hollowed into matching downtown footprints with simplified, circulation-friendly 2D interiors.
4. **Hybrid Onboarding (English Micro-Big-5 + Language-Agnostic Simile Chat):**
   - Combines a rapid psychometric baseline with a natural conversational interview to achieve both quantitative behavioral prediction and authentic personal voice.
   - **Language Strategy:** Micro-Big-5 quiz remains **English-only** (simple sliders, 10–12 items). The 5-Minute Simile Chat is **language-agnostic** (candidates can respond in any language; the AI interviewer dynamically detects and mirrors their language, while the Soul Compiler synthesizes everything into English for the simulation engine).

### 1.3 Progress (2026-09-04 snapshot — not live)

**Live:** [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md) + [`MVP-breakfasts.md`](MVP-breakfasts.md) §1b. Cafe walkable is **95**. First-pass furniture is in Tiled. Do not use this table as current look.

Spatial numbers / FE how-to: [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md). Map checklist: [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md). History: `double-ivan/done/r3f/`.

| Item | Current (live) | Desired (this spec) |
|---|---|---|
| 4:1 maze ~409×437 | **Ingested on `ivan/downtown-pgh`.** World `Downtown`, maze_name `downtown`, parallel to `the_ville`. Preview `/simulations/pittsburgh-preview`. Maze CSVs gitignored; **not** in Supabase | 15 Doubles walking this map on an opt-in Downtown sim |
| Gathering | **PPG Cafe** on One PPG Place. Door `[273, 221]`. Arena **42** / walkable **40**. **15** sit/stand anchors | Village Hobbs **~74** walkable is the **pad-size recipe**, not Downtown. **Do not re-hollow** |
| Gather stay (Downtown) | **Done on `ivan/downtown-pgh`.** Stay writes `Downtown:PPG Cafe:cafe` + PPG tiles. Village Hobbs stay unchanged. **Not** on live `railway` | Used by a live Downtown sim |
| Place names | Pittsburgh sim names locked (`Downtown:PPG Cafe:cafe`, …). Village names must not appear on Downtown | Same. Host pads (One PPG Place, …) stay OSM / footprint only |
| Extra interiors / real homes | Five enterable venues only. 15 `Residence N` street tiles are a walk test, not apartments | Real apartments / extra offices — **founder gate** |
| `/onboard/pgh` | **Shell shipped** in `double-r3f` (local draft) | Live `POST /api/onboard/quiz\|chat\|done` — **parked** until after look |
| Spectator chrome | **Find My Double** + B2B banner on `/simulations/[sim_code]` in `double-r3f` | Bind “my Double” on a live Downtown day |
| Phaser look | **2026-09-04 snapshot.** Live: first-pass rooms in Tiled. Tracker: [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md). | Ground-floor furniture this week. Height / façades later (`Pitts_Phaser.md` Vision §1–2) |
| Headless tab reuse | **Proven on `double-front`** (`done/20260903-2_checklist.md`). **Not** ported to `double-r3f` | Port only if Playwright `FRONTEND_URL` is this app |
| Movement smoke | CSV walk **done**. Fork **`20260904-1`** re-booted. **Luba walked sidewalk → PPG Cafe** (cafe tiles by 07:05). Gosha/Katya left spawn. Cap 6, no village address leaks. Ivan still asleep (wake 10). Stopped ~07:24 after proof | Optional longer Downtown day after look |
| Occupancy baseline | **`base_family_pittsburgh`** on maze `downtown` (openrouter). `base_family_sim` stays village. Same four people; place bindings are Pittsburgh-only | Fork this for engine smoke. **Do not** clone it per Breakfasts founder |
| Portable Double + bind | **Not this pass.** Identity already lives on the person; fork still copies village placement unless you start from a maze-specific plant | After look: live onboard quiz/chat/done writes home/job/today from **this** maze (`sot_lifecycle.md` §6.5). That is how real Breakfasts people enter Downtown |
| Survival / 11:00 / 20:00 | Village engine **Pass**. Downtown bodies walk **done**. Pittsburgh scored day **not started** (stopped `20260904-1` ~07:24 after cafe arrival) | Optional engine 11:00 / 20:00 on this fork (founder call). **Breakfasts demo** waits on look TODOs 1–4. Do not swap village create-sim |

---

### 1.4 Doubles vs worlds — occupancy plant now, bind at launch later

**Current (this chapter):** Downtown occupancy uses a **maze-specific plant**, not a hand overlay on every fork.

- `base_family_sim` — village default (dorms, Hobbs). Do not retarget it.
- `base_family_pittsburgh` — same four people, planted on Downtown sidewalk homes **1 / 4 / 7 / 10**. Luba’s work is PPG Cafe. Village place-names stripped from home / work / today / plan. No copied village memories. Fork **this** for a Downtown sprint.
- This is occupancy proof (bodies on the grid). It is **not** the Breakfasts cohort and **not** a screenshot for the WhatsApp group.

**Desired (north star):** a Double is portable. Who they are stays on the person. Where they live, work, and what they do today is **written at sim launch from that maze** — not inherited from a village snapshot. That flow already has a name: simulation binding (`sot_lifecycle.md` §6.5). Breakfasts onboard (`/onboard/pgh` quiz → chat → compiler → bind) **is** that path.

**Next step for the north star (after look TODOs 1–4):** turn on live `POST /api/onboard/quiz|chat|done` and bind real Breakfasts people onto Downtown jobs/homes. Do **not** clone `base_family_pittsburgh` for each founder. Do **not** make “fork village then overlay” the standing process. Sidewalk `Residence N` tiles stay a walk test — real apartments stay a founder gate.

**Put off:** a generic “any Double walks into any world” engine rewrite, extra interiors, and swapping village `create-sim`.

---

## 2. Research & Behavioral Science: What profiling papers support (and what they do not)

Live Breakfasts door is **not** this section. Portal A2 (10 Mini-IPIP sliders + four general chat beats) is locked in [`MVP-breakfasts.md`](MVP-breakfasts.md) §5d. Twin / “that’s me” work is **post-MVP** (`double-ivan/TODO_post_mvp.md` **PM-VIL-2**, charter `double-ivan/TODO_realism_matriAIx.md`). Spatial numbers start at §3.

### 2.1 Academic Evidence on Conversational vs. Standardized Profiling

| Study | Methodology | Key Findings & Relevance to Doubland |
|---|---|---|
| **Park et al.** (*Simulations of 1,000 People*, arXiv 2411.10109v3) | Survey-only (BFI-44, GSS) vs ~2-hr interview vs combined. Score = share of the **same person’s two-week retest**, not 100% human. | **Survey twin, not a village twin.** Abstract GSS: demographics 74% · survey 82% · **interview 83%** · combined **86%**. Combined is strictly highest; the extra from adding survey to interview is small. HAI secondary: economic **games ~66%** (weaker). Do **not** treat these % as “sounds and acts like him” in a maze, and do **not** quote “80% of the interview deleted still wins” (that ablation was **not** ingested as a table). Do **not** ship a 2-hour American Voices interview as the Breakfasts door. |
| **Simile Team** (Free-Flow Conversational Profiling) | Automated multi-turn conversational agents interviewing humans to map values, conflict styles, and worldviews. | Free-flow dialogue can uncover stances and vocabulary that Likert items miss. That is why A2 still has **four chat beats**. It is not proof that a 5-minute chat predicts Survival votes. |
| **MatrAIx** (arXiv 2608.04205) | 1M persona testbed assessing style and behavioral adherence across models. | **Soft trait labels ("high Extraversion") fail in execution.** Models collapse to their default acting voice. What works are **executable if-then directives** (prefer / avoid / tone + one suppress rule). Conversational data provides the raw quotes and boundary conditions needed to compile these directives. |
| **BehaviorChain & Persistent Personas** (arXiv 2502.14642, 2512.12775) | Multi-turn fidelity and persona drift over long interaction chains. | Personas wash out after ~7 goal-oriented rounds if only given broad backstories. To maintain a continuous self, the profile must be compiled into compact, structured identity cards re-injected on cadence. |

### 2.2 Analysis of Current Doubland Implementation
Our existing codebase in `generative_agents` and `double-front` already possesses the core building blocks:
- **`adult-v1` IPIP-BFM-25 Engine:** Calculates domain means (1–5) and qualitative bands for OCEAN (`api_gateway/app/services/profile_adapter_service.py`), stored in `double.user_personality_profiles`. Village 25 **supersedes** portal Mini-IPIP-10 when it exists.
- **Portal A2 (Current Breakfasts):** `ipip-mini10-portal-v1` + `double-portal-interview-v1`. Compiler overwrites `innate` from scored means. Incomplete `pgh-micro-v1` is not mapped.
- **Profile Adapter & Soul Documents:** Converts profile records into `persona_profile_documents`, snippets (`values_and_principles`, `speaking_style`, `decision_heuristics`), and scratch ISS (`innate`, `learned`, `currently`, `lifestyle`).
- **Post-Chat Learning:** Shipped pipeline (`POST /api/me/double/session/end`) assessing conversations for life-chapter updates while protecting `innate` traits from silent corruption.

### 2.3 The Architectural Decision: Hybrid Onboarding (Current = A2, not a 2-hour interview)
**Verdict:** A short quiz plus a short chat is a **compressed** analogue of Park’s survey+interview idea. It is **not** their 2-hour protocol and **not** a scored village twin. Chat is the better place for voice, business context, and idiosyncratic principles. Likert means are a thin temperament spine. Combined GSS in the paper beat interview-only by a few points; that does **not** license using Mini-IPIP-10 to **weight Survival votes, alliance stability, or stress responses**. Games in that study were the weaker band — treat maze minutes as unproven until `PM-VIL-2` measures a held-out in-village choice. Human “that sounds and acts just like him” (this spec’s success line) is **cohort hope**, not a Bernstein KPI.

**The Hybrid Funnel (live lock = A2):**
1. **Part 1: English Mini-IPIP-10 sliders** (`ipip-mini10-portal-v1`):
   - Quick, non-fatiguing slider/tap UI kept in **English only**.
   - Generates calibrated OCEAN domain scores (1–5) for the soul compiler.
   - Do **not** treat these scores as a vote / risk / alliance weight in Survival.
2. **Part 2: Four general conversational beats** (`double-portal-interview-v1`):
   - Automated AI interviewer via mobile web chat. Beats: background, rhythm, friction, aim.
   - **Language follow:** after a non-English user line, keep the next bot line in that language (first line stays English).
   - Extracts alter-ego context, voice, and principles without requiring a 2-hour interview.
3. **Unified compiler:**
   - Reads transcript + Mini-IPIP-10 means; synthesizes the **English soul schema** (`innate`, `learned`, `currently`, `lifestyle`, `speaking_style`, `decision_heuristics`).
   - Retries English if the first soul pass leaks another language; blank model output falls back to an English soul from quiz + chat.
   - Yields a Double that can enter the village. **Twin fidelity** (express *and* suppress in-scene) is `PM-VIL-2`, not Saturday.

---

## 3. Spatial Architecture: Downtown Pittsburgh in 2D Phaser

Per the locked plan [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md):

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     4:1 FULL GOLDEN TRIANGLE BBOX                       │
│  (South 40.4325, West -80.0168, North 40.4482, East -79.9975)           │
│                                                                         │
│      Point State Park ◄── Market Square ◄── Grant Street Corridor       │
│      (The Point / Rivers)    (PPG Cafe / Plaza)  (Office / Corporate) │
│                                                                         │
│  • 1 occupancy cell = 1 game metre = 4 Pittsburgh metres                │
│  • Total maze: ~409 × 437 cells (~179k cells)                           │
│  • 15 active Doubles navigating on continuous 1 m grid                  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.1 Spatial Invariants
1. **One Physical Occupancy Maze:** The 1 m grid is the single source of truth for both outdoor streets and indoor venues. No coordinate scaling splits, no graph-node teleports at doors.
2. **Simplified Ville-Scale Interiors on Matching OSM Pads:**
   - Real OSM storefronts (e.g. 20 m wide) become tiny 5×5 cells after 4:1 scale-down and remain **locked solid exterior pads**.
   - Sim venues sit on large downtown footprints (Ville-sized recipes). Live gathering is **PPG Cafe** on **One PPG Place** (door `[273, 221]`, **40** walkable cafe tiles). Village Hobbs **~74** is the pad-size recipe, not Downtown walkable — do not re-hollow.
   - Four other enterable interiors: Penn College, Fifth Avenue Market, EQT Supply Store, O'Reilly Pub. Everything else is exterior-only.
3. **Visual Look vs. Movement Separation:**
   - **Frontend:** Stylized 2D Phaser rendering of Downtown Pittsburgh architecture, bridges, and riverbanks.
   - **Backend:** 2D collision matrix and sector/arena definitions preserving `MAX_TILES_PER_STEP=6` path honesty.

---

## 4. The 4 Execution Workstreams for MVP-0.1

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                            MVP-0.1 WORKSTREAM PIPELINE                           │
├─────────────────────┬──────────────────────────┬─────────────────────────────────┤
│ 1. SPATIAL + LOOK   │ 2. HYBRID ONBOARDING     │ 3. SURVIVAL & ROLES             │
│ - Maze ingested     │ - Shell shipped; APIs    │ - Keep Survival mode untouched  │
│ - **Nicolas: town look** │   parked until town is  │ - Alter-ego real business roles │
│ - PPG Cafe gather   │   watchable              │ - 11:00 / 20:00 at PPG Cafe     │
├─────────────────────┴──────────────────────────┴─────────────────────────────────┤
│ 4. MOBILE VIEWER & VIDEO DISTRIBUTION                                            │
│ - Responsive mobile Phaser web player (touch navigation & "Find My Double")     │
│ - Daily 60-second vertical 9:16 video recaps (WhatsApp native)                   │
│ - Single B2B inbound capture ("Bring Doubland to your organization")            │
└──────────────────────────────────────────────────────────────────────────────────┘
```

---

### Workstream 1: Spatial Sync + Phaser Look

*Goal: Golden Triangle occupancy is live. Make the preview look like Pittsburgh.*

1. **Maze (done):** 4:1 river-frame bbox (~409 × 437), blocked id `32125`, ingested as world `Downtown`. Village production untouched.
2. **Hero venue (done):** `PPG Cafe` on **One PPG Place**. Door `[273, 221]`. Cafe walkable **40** (42 arena tiles, 2 furniture). 15 gathering anchors. Village Hobbs **~74** is the pad-size recipe, not Downtown — do not re-hollow.
3. **Walk smoke (done):** 15 street start tiles (`Residence N`) reach the cafe door under cap 6. Those tiles are not apartments — do not draw houses on them.
4. **Look:** live checklist [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md). How-to [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md). Height / façades later. If art and walk disagree, fix the **draw** (ask Ivan before changing collision).
5. **Backend (parallel, not a look substitute):** ingest + Downtown gather stay + plant **done** on `ivan/downtown-pgh`. Fork **`20260904-1`** bodies walk (Luba → PPG Cafe, cap 6). Maze CSVs not in git/Supabase. Headless tab reuse stays on `double-front` unless Playwright opens this viewer.

---

### Workstream 2: Hybrid Onboarding (English Micro-Big-5 + Language-Agnostic Simile Chat)

*Goal: Collect high-signal profile data in under 6 minutes on mobile and auto-compile into runtime soul schema.*  
*Status: UI shell is shipped. Live APIs and compiler wait until the town is watchable. That bind path is the portable-Double north star (§1.4) — not a family-plant clone per Breakfasts person.*

1. **Mobile Web Entry:**
   - Candidate receives a custom link via WhatsApp: `doubland.ai/onboard/pgh?code=...`
   - Mobile-first, passwordless authentication (Supabase magic link or verified phone session).
2. **Step 1: The 60-Second Micro-Big-5 (English-Only):**
   - 10 targeted items (2 per OCEAN dimension) adapted from the adult IPIP bank.
   - Kept in **English only** with simple mobile slider/tap controls (low reading friction, fast completion).
   - Generates calibrated baseline OCEAN domain scores (1–5).
3. **Step 2: The 5-Minute Simile Conversational Chat (Language-Agnostic):**
   - Candidate can respond in **any language** (e.g., English, Russian, Spanish, Mandarin).
   - The AI interviewer dynamically detects the candidate's language and seamlessly continues the conversation in that language.
   - Conducts a 4-beat dynamic dialogue:
     - **Beat 1 (Alter-Ego Role & Business):** "What company or project are you running in Pittsburgh, and what is your focus this quarter?"
     - **Beat 2 (Communication & Working Cadence):** "When working with partners or clients, what's your communication style — straight to the point, structured process, or highly informal?"
     - **Beat 3 (Decision & Conflict Stance):** "Think about a tough business negotiation. What is your go-to move when someone pushes you into a corner?"
     - **Beat 4 (Personal Anchor & Daily Routine):** "What's your typical morning before 10 AM? Coffee order, favorite Downtown spot?"
4. **Step 3: Unified Cross-Lingual Soul Compilation:**
   - Single-pass LLM compilation: ingests native-language transcript + English quiz scores.
   - Translates and compiles all facts, authentic voice quirks, and behavioral tendencies **strictly into the English soul schema**:
     - `innate`: Core temperament synthesized from OCEAN scores.
     - `learned`: Real-world business experience, alter-ego domain knowledge (translated to English).
     - `currently`: Active quarterly focus and business goals.
     - `lifestyle`: Daily morning routine, Downtown work habits.
     - `speaking_style`: Executable style rules in English reflecting native conversational cadence (e.g., "Speaks concisely with dry delivery; avoids fluff; pragmatic business focus with occasional subtle humor").
     - `decision_heuristics`: Concrete if-then directives (e.g., "When proposed an unproven partnership, requires clear downside protection before agreeing").
5. **Auto-Binding to Pittsburgh World:**
   - System immediately binds the Double to the active Pittsburgh simulation (`POST /api/me/double/bind/{sim}/join`), auto-assigns an executive avatar look, and allocates daytime workplace and morning starting coordinates.

---

### Workstream 3: Survival Simulation & Alter-Ego Roles

*Goal: Deploy Doubles into battle-tested Survival Mode with authentic professional identities.*  
*Status: Village Survival is Pass. A Pittsburgh day waits until after Phaser look. Do not swap village create-sim.*

1. **Alter-Ego Role Preservation:**
   - Doubles retain their real professional titles and business identities (e.g., "Founder of AI Logistics Startup", "Principal Commercial Developer", "Managing Partner at Early-Stage Fund").
   - Daytime plans generate business-relevant tasks: reviewing term sheets, checking construction progress, meeting clients, or grabbing coffee in Market Square.
2. **Survival Mechanics Unchanged:**
   - **11:00 AM Challenge:** Personas gather at PPG Cafe. Challenge narratives adapt to business/strategic themes (negotiation showdowns, market pitch challenges, trivia/puzzle solving).
   - **20:00 PM Secret Vote:** Personas gather to cast ballots. The lowest-vote earner is eliminated each night.
   - **Strategy & Pacts:** Personas form alliances using the shipped Phase 2B/3b conversation pipe (`meet`, `tell`, `avoid`, `protect`, `expose`). Leftovers mint durable commitments, and Doubles hold internal stances on whether to honor or break them.
   - **Lived Board Facts:** Personas retain honest memories of challenge participation and previous night eliminations (`{name} was voted out tonight`).
3. **Social Tone & Fourth Wall Guardrails:**
   - Fourth-wall ban remains active: no mention of "simulation", "backend", "AI model", or "Doubland".
   - Personas converse authentically about Pittsburgh business, regional developments, strategy, and game alliances.

---

### Workstream 4: Mobile Delivery & Video Distribution

*Goal: Bring the show directly to the WhatsApp group in high-retention formats.*

1. **Mobile-Optimized Web Spectator:**
   - **Current:** `double-r3f` `/simulations/[sim_code]` — pinch/pan, **Find My Double**, B2B banner.
   - Production `double-front` / `vercel` stays frozen until cutover.
2. **Daily 60-Second Vertical Video (9:16):**
   - Render vertical highlight reel of each day's events:
     - Morning gathering and challenge winner.
     - Key hallway or coffee strategy discussions.
     - Dramatic vote-out and evening closing cliffhanger.
   - Automated local-style narration referencing Pittsburgh landmarks and alter-ego businesses.
3. **Shareable 15-Second Spotlight Clips:**
   - Per-member highlight card ("Your Double's Day") formatted for quick forwarding into personal networks and WhatsApp status.
4. **B2B Demand Capture:**
   - Every video description and spectator web header features a clear, non-intrusive CTA:
     > *"Bring Doubland to your company, community, or cohort — Request an interactive simulation."*

---

## 5. Engineering Ownership & Interface Contract (FE vs. BE/LLM)

Map export already happened. Downtown gather stay, occupancy plant `base_family_pittsburgh`, and fork **`20260904-1`** are on `ivan/downtown-pgh`. **Bodies walk:** Luba reached PPG Cafe on a live clock (cap 6). FE look does not wait on a new BE handshake. Onboard APIs stay parked until after look — that is the next step for portable Double + bind, not another maze-specific family baseline. A scored Downtown Survival day is a founder call, not automatic.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       WHAT IS LIVE VS PARKED                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ 1. MAP — DONE ON `ivan/downtown-pgh`:                                       │
│    Ingest + Downtown gather stay. Maze CSVs gitignored / not in Supabase.   │
│    Village create-sim unchanged. Live BE status:                            │
│    History: `double-ivan/done/r3f/handoff_pittsburgh-be.md`                 │
│                                                                             │
│ 2. LOOK — NOW (FE):                                                         │
│    Phaser picture on the ingested maze. Pittsburgh sim names only.          │
│                                                                             │
│ 3. DOWNTOWN SIM — BODIES WALK (BE, parallel with look):                    │
│    `20260904-1`: Luba reached PPG Cafe. Cap 6. Founder decides next.       │
│                                                                             │
│ 4. ONBOARDING APIs — PARKED UNTIL LOOK (portable Double + bind):            │
│    • `POST /api/onboard/quiz`  (FE submits 10 slider scores -> BE stores)   │
│    • `POST /api/onboard/chat`  (FE streams multi-lingual chat -> BE LLM)    │
│    • `POST /api/onboard/done`  (BE compiles soul -> bind home/job on maze)  │
│    Do not clone `base_family_pittsburgh` for the WhatsApp cohort.           │
│                                                                             │
│ 5. LIVE SPECTATOR — UNCHANGED CONTRACT:                                     │
│    • `GET /api/simulations/{sim}/step/{n}` (FE polls movement & chat JSON)  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Track A: Frontend Expert (UI, Mobile UX & Phaser World)
**Primary repo this pass:** `double-r3f` (`pittsburgh` branch). Do not land Breakfasts UI on frozen `double-front` / `vercel`.  
**Focus this pass:** Phaser look on the ingested Downtown maze. Onboard shell already exists; do not treat live APIs as this job.

1. **Mobile Onboarding Flow (`/onboard/pgh`) — parked after the shell:**
   - **60-Second Micro-Big-5 Screen (English):**
     - Fast slider/tap UI for 10 items (2 per OCEAN dimension).
     - Submits payload to `POST /api/onboard/quiz`.
   - **5-Minute Simile Conversational Chat UI (Language-Agnostic):**
     - Mobile WhatsApp-style messaging interface optimized for one-thumb typing.
     - Supports any native language keyboard (UTF-8, voice-to-text friendly).
     - Streaming message bubbles with realistic typing indicators.
   - **"Meet Your Double" Card:**
     - Displays executive avatar, business title, and 3 signature quotes.
     - 1-tap avatar look customizer (business suit options).
     - Final CTA: *"Deploy Double to Downtown Pittsburgh"*.
2. **Downtown Pittsburgh 2D Phaser Map — now:**
   - Stylized 2D Phaser rendering of the Golden Triangle (Point State Park, Market Square, Grant Street, Three Rivers).
   - PPG Cafe interior as the gathering place. Labels use Pittsburgh sim names (`PPG Cafe`, not Hobbs Cafe).
   - Occupancy CSVs stay the truth. Do not re-export a pack for BE unless collision actually changes.
3. **Mobile-First Spectator Player:**
   - Touch navigation: pinch-to-zoom and single-finger pan.
   - Floating **"Find My Double"** quick-focus button to center camera on user's avatar.
   - High-contrast, mobile-scaled speech bubbles.
   - B2B conversion banner: *"Bring Doubland to your organization"* with 1-field email/lead form.
4. **Sprite Position Snap (`HEADLESS_TAB_REUSE`) — later:**
   - **Current:** `double-front` production snap **PASS** (`14dc6ce` / `a373423`; score `20260903-2`).
   - Port `flushResidualMotion()` / `prepareExistingSpritesForStep()` into `double-r3f` **only if** Playwright `FRONTEND_URL` is this app.
   - BE: do not set `HEADLESS_TAB_REUSE=true` for scoring against the June on-box FE (`e5b1868`).

---

### Track B: Backend & LLM Expert (Engine, Prompts & Compiler)
**Primary Repos:** `generative_agents`, `api_gateway`  
**Focus now:** Downtown bodies walk is proven on `20260904-1`. Onboard compiler stays parked until after look — that compiler **is** bind-at-launch for real Breakfasts Doubles.

1. **Spatial Engine & Pittsburgh Integration:**
   - **Done on `ivan/downtown-pgh`:** maze ingest scripts/tests, Pittsburgh names, PPG Cafe door + 15 gathering anchors, Downtown gather stay (PPG addresses, not village Hobbs box), CSV walk smoke under cap 6. **Not** on live `railway`. Maze CSVs gitignored / not in Supabase.
   - **Done on live fork:** `20260904-1` re-booted; Luba sidewalk → PPG Cafe; cap 6; no village address leaks. Do not change `create-sim`.
   - **Later:** extra workplace / real-home interiors (founder gate).
2. **Cross-Lingual Onboarding Pipeline — parked until after look:**
   - **Adaptive AI Interviewer Service:**
     - 4-beat dynamic prompt (business role, communication cadence, tough negotiation, morning routine).
     - Auto-detect candidate input language and dynamically mirror responses in that language.
   - **Cross-Lingual Soul Compiler:**
     - LLM synthesis pass: ingests native transcript + English quiz scores and outputs **strictly English** soul schema (`innate`, `learned`, `currently`, `lifestyle`, `speaking_style`, `decision_heuristics`).
     - Translates real business alter-ego background into daily plan requirements.
   - **Auto-Binding Service:**
     - On chat completion, auto-create persona, bind to Pittsburgh simulation (`POST /api/me/double/bind/{sim}/join`), and assign starting coordinates.
3. **Survival Mode Calibration with Real Alter-Ego Roles — after a Downtown sim exists:**
   - Validate that 11:00 AM Challenge and 20:00 PM Secret Vote trigger reliably on Pittsburgh cafe tiles.
   - Enforce Fourth Wall suppression (strict ban on "simulation", "AI", "backend").
   - Verify conversation leftover memory (KEEP pipe) mints durable business/game commitments between peers.
   - Headless render producing the daily 60-second vertical 9:16 recap clip with local narration.
4. **Headless Generation Optimization (`HEADLESS_TAB_REUSE=true`):**
   - With the FE sprite snap in place, switch generation environment from `HEADLESS_TAB_REUSE=false` to `HEADLESS_TAB_REUSE=true`.
   - Eliminates per-step browser tab reboots, drops per-step `boot_ms` to near 0, and stabilizes long multi-step simulation generation on the server.

---

## 6. Implementation Roadmap & Milestones

Sequence, not a restart clock. Look and remaining BE (opt-in sim) can run together. Do **not** start onboard APIs in parallel with look. Do **not** start a scored Downtown Survival day until an opt-in Downtown sim exists.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CURRENT SEQUENCE                                   │
├───────────┬──────────────────────────────────┬──────────────────────────────┤
│ Now       │ FE: Phaser look (Pitts_Phaser)   │ BE: ingest + gather stay     │
│           │ Pittsburgh names on every label  │    done on ivan/downtown-pgh │
│           │                                  │ Bodies walk on 20260904-1  │
│           │                                  │ Village generation untouched │
├───────────┼──────────────────────────────────┼──────────────────────────────┤
│ After sim │ FE: glance-pass + spectator tune │ BE: bodies smoke, then       │
│           │    (look can still be in flight) │    scored Downtown day       │
│           │                                  │    at PPG Cafe               │
├───────────┼──────────────────────────────────┼──────────────────────────────┤
│ After look│ FE: live onboard wiring          │ BE: quiz/chat/done + compiler│
├───────────┼──────────────────────────────────┼──────────────────────────────┤
│ Launch    │ Pre-flight with 2 Breakfast allies, then the WhatsApp group     │
└───────────┴──────────────────────────────────┴──────────────────────────────┘
```

### Detailed Milestones

#### Milestone 1: Spatial Grid + Look
- [x] Export 4:1 Golden Triangle CSVs from `double-r3f`. **Nicolas’s copy** is committed at `double-r3f/public/assets/pittsburgh/` (branch `pittsburgh`). Gitignored rebuild pack: `tmp/pittsburgh-be-handoff/`. Ingest history: `double-ivan/done/r3f/handoff_pittsburgh-be.md`.
- [x] Ingest as world `Downtown`. **PPG Cafe** on One PPG Place, walkable **40**, door `[273, 221]`, 15 anchors in `cafe_gathering_anchors.json`.
- [x] Pittsburgh sim names on the maze (no Hobbs / Oak Hill / Willows leak).
- [x] 100-step walk smoke, cap 6, 15 street `Residence N` starts → cafe door.
- [x] Downtown gather stay writes PPG Cafe (unit tests). On `ivan/downtown-pgh`, not live `railway`.
- [x] Occupancy plant `base_family_pittsburgh` (4 people, homes 1/4/7/10, maze `downtown`). `base_family_sim` unchanged.
- [x] Fork `base_family_pittsburgh` → `20260904-1` spawn proof (4 sidewalk homes, headless off).
- [x] Engine walk-smoke: collision `"0"` is open; planted homes 1/4/7/10 path to PPG door `[273, 221]` under cap 6.
- [x] Live bodies walk on a re-booted Downtown fork. Luba reached `Downtown:PPG Cafe:cafe` (~07:05). Gosha/Katya left spawn. Ivan still asleep (wake 10). Stopped ~07:24 after proof. Not `create-sim`. Not a Breakfasts demo.
- [ ] **Look (Nicolas):** live [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md). Height / façades later (`Pitts_Phaser.md` Vision §1–2).
- [ ] Extra workplace / real-home pads: **founder gate**.
- [x] Headless snap on **`double-front`** (`20260903-2`). **Skip** r3f port until Playwright uses this viewer.

#### Milestone 2: Hybrid Onboarding Pipeline (after look) — portable Double + bind
- [x] `/onboard/pgh` shell in `double-r3f`: 10 English sliders + 4-beat chat + Meet card (local draft; compiler not live).
- [ ] Deploy the 4-beat Simile interviewer prompt with dynamic language detection and mirroring (BE).
- [ ] Build the Cross-Lingual Soul Compiler service generating English `innate`, `learned`, `lifestyle`, and executable `speaking_style` / `decision_heuristics` (BE).
- [ ] Wire instant auto-bind (`/api/me/double/bind/{sim}/join`) and avatar auto-assignment (BE/FE). This writes **this maze’s** home/job/today — do not plant a new family baseline per Breakfasts person.

#### Milestone 3: Joint Integration & Survival Verification (after a Downtown sim exists)
- [ ] Complete end-to-end joint smoke test: mobile onboard -> compile -> seed Double on map -> live chat playback.
- [ ] Verify headless generation with persistent tabs (`HEADLESS_TAB_REUSE=true`) runs cleanly at high step throughput (`boot_ms → 0`) — **after** box FE is `14dc6ce+` or Playwright uses a viewer that already snaps.
- [ ] Run 1 full simulated day (steps 0 to 2400) in Survival mode on the Pittsburgh map (BE).
- [ ] Verify 11:00 challenge attendance (≥ 80% on tiles), honest conversation leftovers, fourth-wall adherence, and 20:00 vote execution (BE).
- [x] Spectator chrome: pinch/pan, Find My Double, B2B banner in `double-r3f` (tune again on a live Downtown day).

#### Milestone 4: Anchor Pre-flight & Group Launch
- [ ] Onboard 2–3 anchor allies from the Pittsburgh Business Breakfast group as test doubles.
- [ ] Distribute personalized onboarding links to the full WhatsApp group.
- [ ] Seed the Pittsburgh simulation with the cohort's Doubles.
- [ ] Post daily 60-second vertical highlight reels and live web viewer links directly to the WhatsApp chat.
- [ ] Log qualitative reactions, shares, and inbound B2B requests.

---

## 7. Definition of Done for MVP-0.1 Release

MVP-0.1 is ready to launch when:
1. **Map Integrity:** The 4:1 Downtown Pittsburgh 1 m maze runs stably, with honest pathfinding and a gathering venue hosting 15 Doubles.
2. **Onboarding Conversion:** A user completes the hybrid flow (English Micro-Big-5 + language-agnostic Simile chat) in under 6 minutes on a mobile device, producing an auto-compiled Double without manual developer intervention.
3. **Alter-Ego Fidelity:** Doubles operate under their real-world business roles and exhibit recognizable conversational and decision-making styles.
4. **Autonomous Survival Execution:** The engine completes a 2400-step Survival cycle (morning gathering, challenge, evening vote, elimination) with zero coordinate jumps and no fourth-wall violations.
5. **Distribution Delivery:** Daily 60-second vertical videos render reliably and post to the WhatsApp group alongside tracked mobile viewer links.
