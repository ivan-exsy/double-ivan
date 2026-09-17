# Design: natural conversation initiation (T-E1 / T-E2 deep dive)

**Status:** LOCKED 2026-09-13 — this is the single implementer doc for T-E1 / T-E2. Inquiries, findings, and the deep-dive handoff were retired into this file (git history keeps them).
**Date:** 2026-09-12 (design) / 2026-09-13 (intent addendum + founder locks).
**Source:** read-only worktree `D:\Coding\generative_agents-e1e2-hello` at `railway` tip `9a409cec` (detached). No production code, no sim runs, no VPS, no Supabase writes. One numeric spike (pure Python, `/tmp`) for the hazard numbers in §3.4.
**Settled, not reopened:** cap 6 · Survival priors (`sot_survival.md` Conversation Priors) · linger stays dead · S4 tiers (hello ≤2 lines, no carry; conversation ≥3 exchanges + co-located) · KEEP / leftover mint / stance thought (`sot_chats.md` §3b). Walking-seek is PM-VIL-1 (post-MVP).

## Locks and next-pass recommendation

**Do not start T0–T7 until W1 verify is green and the founder says go.** Then implement this design, tickets in order, scored after T4/T5.

| # | Lock |
|---|---|
| 1 | One talk per encounter. Second talk only on a **new reason** (due leftover, Survival event) — never a second dice. |
| 2 | **Delete linger** (T6). |
| 3 | **`pair_encounters` is a table** — no jsonb-on-sim fallback. |
| 4 | **Hold Extraversion** until the realism charter. |
| 5 | **A can intend** once they share a room: A initiates, B need not want it, the reason is the opener. **No new walking** in this pass. Survival's existing once-a-day walk stays; everyday hunt is post-MVP. |

**Why (one line each):** Friday = “already hi” lived on the *plan* and died every restart / 60-step chunk. Saturday = hellos never become talks, and fresh Doubles cannot earn a talk while standing still. Fix = one *encounter* keyed on bodies, stored in the database; a small per-person chance to open a talk; a one-sided reason beats the dice.

---

## 0. The decision, in one paragraph (founder version)

Two Doubles who end up in the same room say hello **once** — that hello opens an *encounter* that lasts until they actually walk apart. While the encounter is open and both have free time, every minute carries a **small chance** that one of them opens a real conversation; the chance is higher if they already know each other, if the place invites talk (cafe, park, common room), or if one of them has a reason (a leftover promise, a Survival tie, an explicit "chat with X"); it is zero if either is asleep, busy, about to leave, or stressed. Strangers who sit together for a quarter of an hour end up talking about half the time; in a lively place, two times out of three; two people who already talked once today, nearly always. Once they have talked, they stay quiet until they part and meet again — and a re-meet within ten minutes is the same encounter, not a new hello. Chance is not the only door: when one Double carries a **reason** — a promise left over from an earlier talk, a Survival tie, "chat with X" on the plan — that Double speaks first the moment the two share a room, opens on that reason, and the other does not have to want it (only sleep, an appointment, another talk, or real stress make them wait). In this wave a reason does not walk anyone across the village; the body follows the day as today, and the reason waits for life to cross their paths (Survival's existing once-a-day seek still steers the walk). Encounters are written to the database, so a restart, a new hour-chunk, or a new day never turns friends back into strangers.

---

## 1. Phase 1 — current implementation, confirmed

### 1.1 The router (one production entry)

All five trigger sources (backend proximity scan, proximity observation, `observation_apply`, path intersection, `movement_report_interrupt`) converge on `reverie.py:8690` `_attempt_chat_via_manager` → `ConversationManager.should_converse` (`conversation_manager.py:620`) → route on `conversation_type`:

| Branch | What happens | Session? | Persist / continuation possible? |
|---|---|---|---|
| `greeting` (`reverie.py:8746-8817`) | `generate_greeting` template pair, `chat_end_step = step + 1`, id `greeting_{step}_{names}`, then `set_cooldown` + `increment_daily_encounters` + `record_greeting_sit` + `record_interaction(+0.06)` | **No** | **No** — `start_conversation` / `try_persist_or_linger` never called |
| `full` (`reverie.py:8820`) | `start_conversation` → LLM dump, slicing, `sofa_persist`, `full_talk_partners_today`, `record_interaction(+0.12)` | Yes | Yes (KEEP, beat budget 6/12, leftover mint) |

### 1.2 Findings confirmed / corrected

| E1E2 finding | Status | Note from this pass |
|---|---|---|
| Q1 hello-only: greeting branch is a one-shot; `_no_will` demotion is structural for fresh Doubles (affinity 0.0 < `AFFINITY_FULL_TALK` 0.2; +0.06 per hello; quiet allows 1 hello per visit) | **Confirmed** | `social_will.py:34,128-136`; `persona.py:41-44,97-102`. Only exits: survival trust ≥ 0.55, `_had_full_talk_today` (chicken-and-egg), or leave-and-return ×4 |
| Q2 re-greet: `_greeting_sits` keyed on `act_address` arena, popped when either plan arena differs | **Confirmed** | `conversation_manager.py:1328-1350`. `_persona_arena` (body-first, `:1466`) exists but is used only by desync repair |
| Q3 restart wipes quiet / cooldown / daily / sessions / leftovers | **Confirmed** | `ConversationManager()` has no load/save. Fresh subprocess per Start / resume / **every 60-step live chunk** (`background_tasks.py:207,287-305`) |
| Q4 same code Friday vs Saturday; variables = plan-address stability + restart timing | **Confirmed** | Last chat-logic commit `970d263a` (Sep 2) |
| Suspect #1 (production hellos never sit as one talk) | **Confirmed still true on tip** | `start_conversation(..., conversation_type="greeting")` only in tests. `try_persist_or_linger`'s `"greeting"` half (`:1363`) is dead in production |
| Fix #4 alternative "route hello through `start_conversation` as greeting-tier session" | **Do not do as written** | It keeps two products (hello tier vs talk tier) and only moves the trap: the greeting session would still need `willing_full_talk` to escalate. §3 replaces the gate, not the plumbing around it |

**Two things the findings under-weighted:**

1. **"Overlap" is not co-presence.** `_compute_overlap` (`:1935-1951`) returns the *remaining minutes of the current planner slice*, min over both. Decomposed tasks are short, so a pair that will sit together for an hour usually reads as `fleeting` (< 3) or `short` (≤ 8). Pass 2 evidence: *every* `SOFA PERSIST` on `20260831-1` logged `overlap=2`; **34/180** hellos there were `fleeting_same_arena` for people already seated at Hobbs. The whole fleeting/short/medium/long matrix (`:723-795`) is tiering on the wrong quantity. This is why "planted" pairs never look planted to the engine.
2. **Live mode is hourly amnesia by design.** Each live chunk is a fresh `reverie.py` (60 steps). Every chunk boundary re-arms `is_first_daily` → cooldown bypass (`:682`) + `first_daily_fleeting` greeting at ≤ 3 tiles (`:734`). Saturday ran sprint (999/1000 uninterrupted) so it did not show; the Breakfasts product target is live mode, where today's code re-hellos every seated pair once an hour, guaranteed.

### 1.3 The unconfirmed discriminator (Saturday 09:37, Luba ↔ Yevgenia)

Not confirmable from the repo: the `reason=` on that pair's `👋 GREETING TRIGGERED` line lives only in the VPS run log. Both candidate values lead to the same greeting branch, so the design does not depend on it — but it tells us *which* wrong quantity fired first. Read-only command for whoever has the box (no restart, no pull):

```bash
grep -F "GREETING TRIGGERED" <sim log for pittsburgh-business-breakfasts 2026-09-12> | grep -F "Luba" | grep -F "Yevgenia"
```

- `reason=first_daily_fleeting` → planner slice remaining < 3 min at 09:37 (overlap misread, §1.2 item 1).
- `reason=short_overlap_no_will` / `medium_overlap_no_will` → slice was long enough; the will gate (affinity 0.0) demoted a full talk to a hello (hello-trap).

### 1.4 Stores today (what would survive a restart)

Survive (scratch → Supabase `save_persona_scratch`, `scratch.py:634-640`): `relationship_affinity`, `last_interaction_time`, `full_talk_partners_today`, `sofa_persist`.
Do **not** survive (in-process dicts, `conversation_manager.py:593-611`): `_cooldowns`, `_daily_encounters`, `_pair_topics_today`, `_active_sessions` / `_participant_session`, `_greeting_sits`, `_open_leftovers`.

Everything that decides "have we already said hello / talked / promised" is in the second list.

---

## 2. Phase 2 — the band-aid history and the pattern

Chronological, from `git log` on the chat files plus the score cards (`double-ivan/done/2026083*`, `202609*`).

| # | Fix (commit, date) | Symptom it fixed | What it cost | What it assumed |
|---|---|---|---|---|
| 1 | Hardcoded greeting tier (`8c3db809`, Jan 22) | LLM cost of every hello | Hello became a stateless one-shot **outside** any conversation lifecycle — the root of every later "hello" bug | A hello never needs to become a talk |
| 2 | First-daily bypass of cooldown + promote to greeting (`71a49a8e`, Feb 11; SOT §2) | Silent mornings | After *any* wipe of `_daily_encounters` every pair is "first daily" again → restart / chunk hello bursts (Friday 11:01) | The process lives all day |
| 3 | ConversationManager + overlap matrix + satiation (`c16ec455`…`ea775a31`, Apr 5) | Scattered gates, LLM "should we talk" cost | Tiering keyed on remaining planner slice, not co-presence (§1.2) | Planner slice ≈ how long they will be together |
| 4 | Raise exchange bases (`7c0dd59e`, Apr 7) | 87 % of full talks capped at 1 exchange | — | Silence is a length problem |
| 5 | Tighter proximity / higher cooldowns (`fa87218b`, Apr 8) | Spam | Cooldown as the primitive for "already talked" | Time apart ≈ social memory |
| 6 | Pair cooldown floor 5 after first meet (`be158e24`, Aug 1) | Irene ↔ Max re-trigger spam | A 5-minute mill is still a mill (`20260831-1`: 150 floor lines, 77 re-opens in 260 steps) | Same as 5 |
| 7 | Will gate + `_no_will` demotion + linger (`266aa54f`, Aug 27 — bundled in the skip-premiere commit) | Too many / too deep full talks | **Created the hello-trap**: fresh Doubles (affinity 0) can never pass; will-fail falls into the hello path *on a loop* (104/180 hellos on `20260831-1` were `*_no_will`) | Relationship precedes talk (chicken-and-egg with fix 1) |
| 8 | Greeting-tier persist (`2f5f7269`, Aug 31) | The mill (Pass 2 packing) | Fixed the unit test, not production — `tier=greeting` on `CM.START` = **0** in the scored run | Tests exercised the production path |
| 9 | Quiet until leave + `keep_sit_partner` (`b8d1fc15`, Aug 31) | Pass 2 FAIL 77 re-opens → **0** on `20260831-2` | Keyed on plan address and in-process: cafe re-greets when plans churn (Friday), restart bursts, and — with fix 7 — **permanent almost-friendship** for planted pairs (Saturday) | `act_address` = body; process lives |
| 10 | KEEP desync repair + beat budget 6/12 + leftover mint (`bb22747d`, Sep 1) | 53/97 fake `desync_scratch_cleared` ends | Structural, kept. `_open_leftovers` still in-process | — |
| 11 | Linger +10 (`ec8e2076`, Sep 2) | Sitters leaving after a talk | **0** fires in 55 sit-stops; founder skipped | Will would pass for sitters — same trap as 7 |
| 12 | Stance thought (`612be4d2`, Sep 2) | Leftover had no consequence | Orthogonal, kept | — |

**The pattern.** Every fix is a **veto bolted onto the output side**, keyed on whichever field was handy (planner address, remaining slice, a process dict), and none of them models *what the pair wants*. Vetoes compose toward silence; the one positive path that no veto guards is the stateless template hello from fix 1 — so that is what leaks, and every "spam" outbreak is that hello squeezing through a new gap (cooldown floor, plan churn, restart). Two recurring category errors underneath: **plan mistaken for body** (fixes 3, 9) and **process memory mistaken for relationship memory** (fixes 2, 5, 6, 9, 10).

Same shape as the gather bug family (`AGENTS.md` 2026-08-29: a preference gate relocating a resolved body). The fix there was to delete the veto and let the model decide; the fix here is the same move.

---

## 3. Phase 3 — the design

### 3.1 Principles

1. **The unit is the encounter, not the hello.** One pair, one co-presence episode, one record — from first shared room to walking apart. Hello and talk are *phases* of it, not separate products with separate memories.
2. **Body decides presence; plan decides availability.** "Same room" is `curr_tile` → `maze.get_authoritative_address` (the `_persona_arena` helper that already exists). "Free to talk" is the plan (`act_description`, next scheduled act, remaining slice ≥ 2 min).
3. **Positive model, few hard stops.** Replace the veto stack with one *desire* quantity that rises with time together, relationship, place and intent — and a short list of hard stops that already exist (`_hard_stop`: sleep, gather pre-window, chatting with someone else, pressure ≥ 0.5, leaving next).
4. **Sometimes, by design.** A bounded per-minute chance (a hazard), not a threshold. Strangers *can* talk on the first meet; friends usually do; nobody always does.
5. **Relationship memory lives in the database.** Anything that decides "already said hello / talked / promised" is persisted on transition and rehydrated at boot. Process memory is a cache.

### 3.2 State model — `Encounter`

One record per `(sim_code, pair_key)` that is open, plus history rows for scoring.

| Field | Meaning | Written on |
|---|---|---|
| `pair_key`, `sim_code` | sorted names | open |
| `arena` | 3-part arena from **body** at open | open |
| `opened_step`, `opened_day` | when they first shared the room | open |
| `phase` | `greeted` → `talking` → `talked` → `parted` | every transition |
| `hello_step` | exactly one per encounter | hello |
| `talk_session_id`, `talk_opened_step` | the CM session for this encounter's talk | talk open |
| `copresent_steps` | minutes both bodies in `arena` | each step (in memory; flushed on transition + every N steps) |
| `last_copresent_step` | for the part-grace timer | each step |
| `parted_step` | when bodies were apart ≥ `PART_GRACE` | part |
| `rng_seed` | `hash(sim_code, pair_key, opened_step)` | open |

Derived, so no separate dicts:

- **first daily** = no encounter row for this pair with `opened_day == today`.
- **cooldown** = an encounter with `phase == parted` and `parted_step + REMEET_MIN > step` → re-entry *resumes* that encounter (no new hello). Older → new encounter.
- **quiet** = `phase in (greeted, talked)` and both bodies still in `arena` → no hello, no second talk.

Replaces: `_greeting_sits` (fix 9), `_cooldowns` + pair CD floor (fixes 5, 6), `_daily_encounters` + first-daily bypass (fix 2), `_participant_session` lookup (kept as cache), `greeting_{step}_…` ids (fix 1) — the encounter id is the conversation id for both the hello rows and the talk.

### 3.3 Gates — decision order per pair per step

Runs inside `should_converse`; the router keeps its shape.

1. **Presence (body).** Both `_persona_arena(curr_tile)` equal, or Manhattan ≤ `base_tiles` (3) when either has no arena (street). Not present → if an encounter is open and `step − last_copresent_step ≥ PART_GRACE` (2) → `parted`. Stop.
2. **Encounter lookup.** Open encounter for this pair? If `parted` less than `REMEET_MIN` (10) ago → reopen it (same id, phase unchanged). Else none → **open new** with phase `greeted` and emit the hello (S4: ≤ 2 template lines, `chat_end_step = step + 1`, `record_interaction("greeting")`). First hello per genuine encounter is unconditional except hard stops — this keeps "no silent mornings" without a daily counter.
3. **Hard stops (both sides).** Existing `_hard_stop` (`social_will.py:101-119`) + remaining slice < 2 min. Any → no talk this step; encounter stays open.
4. **Phase.**
   - `greeted` → **warm-up hazard** (§3.4). Draw once per step from the encounter's seeded RNG. Hit → `start_conversation(full)`; phase `talking`.
   - `talking` → today's machinery untouched: slicing, `try_persist_or_linger` (full only), KEEP desync repair, beat budget 6 / cap 12, leftover mint on complete, stance thought. On complete → phase `talked`.
   - `talked` → quiet until `parted`. One talk per encounter for MVP. (Later: a second talk only on a new *intent* — a due leftover with this partner or a Survival event — not on time.)
5. **Forced tier** (`movement_report_interrupt`, `forced_tier="full"`) → hazard = 1 for this step, hard stops still apply. Same for explicit intent (`chat with {name}` in action text, `social_seek_target == other`, open leftover due with this partner).

### 3.4 The warm-up hazard

Per open encounter in phase `greeted`, per step (after the hello minute), **one draw per side** (§3.9 — the side whose draw hits is the initiator; both hit → seeded tie-break):

```
p_side = clamp( H_BASE × place × relationship × intent_side ÷ crowd , 0 , P_MAX )
```

| Factor | Values | Source (exists today) |
|---|---|---|
| `H_BASE` | **0.05** per minute | new constant |
| `place` | social arena (cafe, common room, park) **1.5**; neutral **1.0**; quiet (library, classroom, bedroom) **0.3** | `maze_registry` atmosphere already feeds `get_effective_threshold` / `get_arena_cooldown_mod` — reuse the class, drop the cooldown mod |
| `relationship` | `1 + 2 × decayed_affinity` (0 → 1.0; 0.2 → 1.4; 0.35 cap → 1.7); Survival ally or trust ≥ 0.55 → **2.5** | `_get_decayed_affinity`, `_survival_ally_or_trust` |
| `intent` | **per side** (§3.9): the holder's p = 1 and the holder initiates; the other side's p unchanged | `social_seek_target`, `_open_leftovers`, `forced_tier`, `chat with {name}` in `act_description` |
| `crowd` | `sqrt(others co-present and free)`; alone together → 1 | proximity scan already has the room |
| satiation (per persona) | for 30 min after a completed talk, that persona's encounters use `H_BASE × 0.4` | new scratch field `last_talk_end_step` |
| `P_MAX` | 0.35 | |

Optional P1 (realism charter, code priors from E — `TODO_realism_matriAIx.md` §3 P1, not MVP): multiply by 0.7–1.3 from the initiator's Extraversion mean.

Numbers (20 000-trial spike, `H_BASE = 0.05`):

| Pair | 3 min together | 8 min | 15 min | 30 min |
|---|---|---|---|---|
| strangers, neutral place | 14 % | 34 % | 54 % | 78 % |
| strangers, social place (Saturday park pair) | 21 % | 46 % | **69 %** | 90 % |
| acquaintances (aff 0.2), social place | 28 % | 59 % | 81 % | 97 % |
| Survival ally / trust, social place | 48 % | 82 % | 96 % | ≈100 % |

Cost envelope (same spike, one talk per persona at a time, 5-min talk, 30-min satiation, crowd divisor): a full Hobbs hour with **15** people ≈ **10** talks; with **4** people ≈ **3.6**. Pass 2 (`20260831-1`) logged 19 session ids in 260 steps ≈ 4.4/hour for 15 including re-opens; the hazard roughly doubles real talks at the busiest hour and removes the hello noise (180 hellos in those same 260 steps). `H_BASE` is the single cost lever.

Determinism: the RNG is seeded per encounter (`rng_seed`), so a replay of the same sim from the same step gives the same draws, and a restart mid-encounter continues the same stream from `copresent_steps`.

### 3.5 What persists where

| State | Where | Cadence |
|---|---|---|
| `Encounter` rows | Supabase — **table `double.pair_encounters`** (`sim_code, pair_key, opened_step` PK; service-role read/write only — the engine is the sole client, no anon policy, so the `personas_simulations` RLS recursion that bites `personas_coords` cannot recur here). **No jsonb fallback** (founder lock 13 Sep). | write on every phase transition + `copresent_steps` flush every 10 steps; read once at `Reverie.__init__` |
| Open leftovers (`_open_leftovers`) | same table, `leftover` jsonb on the encounter row | on mint / honor / break |
| Talk session (`_active_sessions`) | stays in-process **but** is reconstructed at boot from an encounter in phase `talking` + the scratch `chat_queue` / `chat_cursor` that already persist. If the queue is gone, the encounter completes as `restart_cut` (no mint, no re-hello) | boot |
| affinity, `last_interaction_time`, `last_talk_end_step` | scratch → Supabase as today | as today |
| Removed | `_cooldowns`, `_daily_encounters`, `_greeting_sits`, `full_talk_partners_today`, `sofa_persist` as a gate (kept only as the emit `keep_sit_partner` signal), `GreetingTracker` stays (cosmetic) | — |

Live-mode chunks: the chunk boundary becomes invisible — the new subprocess loads open encounters and continues the hazard stream. This is the fix for §1.2 item 2 and for the Friday 11:01 burst.

### 3.6 Tiers — S4 stands

- **Hello** = the encounter's opening: ≤ 2 template lines, `chat_end_step + 1`, no topic carry, no leftover, +0.06 affinity. Exactly one per encounter.
- **Conversation** = the encounter's talk: `start_conversation(full)`, ≥ 3 exchanges, beat budget 6 / cap 12, both co-located by **body** at open and at each slice (KEEP repairs same-arena desync; a real leave still ends with `left_arena`). +0.12 affinity, may mint a leftover.
- No third "almost talk" state. Watch shows both as today (T-W7).

### 3.7 Why this recreates neither spam nor silence

**No spam.** A hello needs a *new* encounter, and a new encounter needs the bodies to have been in different rooms for ≥ 10 minutes. There is no cooldown to leak through, no daily counter to wipe, no plan address to churn. A talk needs phase `greeted`, so at most one per encounter; satiation and the crowd divisor bound talks per persona per hour (§3.4 envelope). Restart / chunk boundaries rehydrate the same rows.

**No silence.** Every genuine encounter opens with a hello (hard stops aside), so mornings are not silent. The hazard is strictly positive for any free pair — strangers included — and grows with time together, so a planted pair sitting 15 minutes in a park talks ~7 times in 10; the same pair passing in a corridor for 2 minutes talks ~1 in 7. That is the "sometimes" the handoff asks for, and it is the same rule for friends and strangers with different odds — no chicken-and-egg.

**Why it reads as human.** Opportunity (same room, free), intent (seek / promise / Survival), relationship (affinity, trust), situation (place, crowd, stress, leaving) are the four inputs of §0, each a named factor. No emergent behaviour depends on a planner slice length.

### 3.8 What is deleted (dead after §3.3)

- Overlap matrix and ranges (`CONVERSATION_CONFIG["overlap_ranges"]`, cases 1–4 at `:723-795`), `_satiation_exchanges`, `_satiation_cooldown`, the whole `cooldown` config block, pair CD floor (`:846-858`), affinity/pressure cooldown modifiers (`:826-845`), `get_arena_cooldown_mod`.
- `willing_full_talk`'s affinity / trust / had-talk-today **thresholds** (`social_will.py:128-136`) — the same inputs move into the hazard multipliers. `_hard_stop` and `next_act_allows_talk` stay.
- `first_daily` bypass and `first_daily_fleeting` reason.
- `greeting_{step}_…` ids; `record_greeting_sit` / `_greeting_sit_blocks` / `sofa_greeting_quiet`.
- `try_persist_or_linger`'s `"greeting"` tier half; `maybe_apply_linger` and `LINGER_MINUTES` (founder lock 13 Sep: delete in T6).
- Legacy `meeting`-observation hello (`reverie.py:9480-9552`). In-tree check: `"meeting"` appears only as an accepted type in the API schema (`simulation_control.py:519`) and tests — no producer in headless / gateway code. T6 confirms against one headless log before deleting.
- `full_talk_partners_today` (its only reader was the will gate).

### 3.9 Addendum (2026-09-13) — intent, initiator, body

Founder question: *are all deep chats a roll of the dice, or can A intend to talk with B while B does not know yet?* — **A can intend.** Intent is one-sided, it makes A the initiator, it carries the topic, and in this wave it does not move the body.

**Correction to §3.3–3.4 as first written.** The hazard was one number for the pair and intent was a pair multiplier. That is wrong for the founder picture and is replaced by the three rules below.

**Rule 1 — every talk has an initiator; intent belongs to one side.**
The hazard is drawn **per side**: `p_A` is A's chance to open with B, `p_B` is B's. Whichever side's draw hits speaks first; if both hit in the same minute, the encounter's seeded RNG breaks the tie. So even a chance talk on Watch has a visible opener, not a coin flip after the fact. An **intent** is a per-persona record `{partner, kind, clause, source, armed_step, expires_step}` held by exactly one side:

| `kind` | Holder | `clause` (what A wants to say) | Armed by | Expires |
|---|---|---|---|---|
| `leftover` | the speaker of the classified line (`classify_leftover` returns the speaker too — small extension; if unknown, both hold it) | the leftover `clause` verbatim | `mint_leftover` | leftover `due_step` (60) or when honored/broken |
| `survival` | the persona whose scratch has `social_seek_target == partner` | the Survival prior for that pair (`alliance_commitments` class or "trust") | `_apply_survival_lifestyle` (today's once-a-day pick) | `social_seek_until_step` / end of day |
| `plan` | the persona whose `act_description` names the partner (`chat with {name}`, `talk to {name}`) | that `act_description` | planner slice | slice end |
| `forced` | the persona reported by `movement_report_interrupt` | none | the report | that step |

When A holds an intent for B and the two share a room (§3.3 gate 1), **A's p = 1** on the first minute both pass hard stops; B's `p_B` is untouched. **B's will is not required** — there is no affinity, trust, or had-talk-today check on B (the design already deleted those). B's **hard stops** still apply (asleep, gather pre-window, chatting with someone else, pressure ≥ 0.5, leaving next, slice < 2 min): they **delay**, they do not cancel — the intent stays armed and fires the next minute B is free while still in the room. An intent may open a **second** talk in an encounter already in phase `talked` (this is the "new intent" exception in §6 Q1); a chance draw may not.

**Rule 2 — body boundary (hard).**
**Option (a) for T0–T7: intent never writes `act_address`.** The encounter code reads `social_seek_target` / leftovers / plan text as *reasons*; it does not steer walking. The founder's "A looks for B" is delivered two ways in this wave, neither new movement:
- **Survival:** the Current once-a-day seek (`_maybe_apply_social_seek`, `plan.py:673-744`) keeps steering A toward the ally / trust target exactly as today (`sot_survival.md` Conversation Priors: movement copy only). What changes is the arrival: today A reaches B's room and still needs the will gate (affinity ≥ 0.2) or gets a hello; under Rule 1 A's armed `survival` intent fires p = 1 and A opens on the prior. So Survival intent **does** walk-then-talk — with the walk that already exists.
- **Village (leftover / plan):** A carries the reason and speaks first when the day crosses their paths; A does not detour. This is a product cut, not a limitation to hide: everyday seek-to-person is **PM-VIL-1 Hold** (`TODO_post_mvp.md`) because walking to a person empties Hobbs (`sot_chats.md` §3b "Seek-to-person (empties Hobbs). Stay off village MVP."). Founder lock 2026-09-13: **(a) now, (c) later** — no Seek ticket in T0–T7.

**Rule 3 — a reason carries its topic.**
When an intent fires, `start_conversation` receives `opener = {initiator, kind, clause}`; `ConversationContext` gets one new field `opener_intent` (today it has `relationship_summary`, `topics_already_discussed`, `public_game` — nothing that says what A came to say). The batch prompt must open with the initiator's line **on that clause** (prompt edit → `prompt-verify` skill at implementation, not this phase). For `leftover`: the promise clause verbatim ("A wanted to talk *about X*"). For `survival`: the prior class in plain speech (protect / expose / mutual_in / trust), never engine words — same rule as the stance thought. For `plan`: the act text. For `forced`: none (usual dump). Chance talks get no opener; the usual dump picks the subject. The encounter row records `initiator`, `intent_kind`, `intent_clause` for scoring; the intent is consumed one-shot on fire. Leftover **honor / break stays co-presence only** (Current, not reopened) — the fired intent does not change that scoring, it only makes the promise audible.

**What this replaces.** Fix 7's symmetric will gate ("both must want it") — the reason Survival seek arrivals ended as hellos on `20260831-1` (63 `SOCIAL_SEEK` lines, `*_no_will` hellos) — and the pair-level intent multiplier of the first draft of this doc.

---

## 4. Migration — ordered, ticket-sized (`ivan/*` branches, one PR each)

Each ticket is independently shippable and scored; T1–T3 alone already fix Friday (T-E2a/b); T4 fixes Saturday (T-E1).

| # | Ticket | Replaces band-aid | Size | Narrowest check |
|---|---|---|---|---|
| **T0** | **One decision line per pair-step.** Extend `🔍 CM.SHOULD` / `👋 GREETING TRIGGERED` / `📊 CONV MANAGER skip` with `phase, copresent, arena_body_a/b, arena_plan_a/b, aff_a/b, p` (p = 0 until T4). Add `analyze_hellos.py` (counts per pair per encounter, re-greets within N, talks per persona-hour) | — (unblocks every score below) | XS | scratch sim 120 steps; script reproduces `20260831-1` §8 counts from a log |
| **T1** | **Presence by body.** `record_greeting_sit` / `_greeting_sit_blocks` / `try_persist_or_linger` / `start_conversation` arena checks use `_persona_arena(curr_tile)`; `act_address` only when no maze/tile | fix 9's plan keying (Friday cafe re-greets) | S | unit: plan churn while bodies stay → still quiet; body leaves while plan says cafe → not quiet |
| **T2** | **`PairEncounters` store + persistence.** New class with `open / touch / part / transition`, **table `double.pair_encounters` only** (founder lock — no jsonb-on-sim), load in `Reverie.__init__`, save on transition. Behind it, `_greeting_sits` / `_cooldowns` / `_daily_encounters` become derived reads. Behaviour otherwise unchanged (hello once per encounter = today's quiet; cooldown = `REMEET_MIN` after part) | fixes 2, 5, 6, 9's process memory (restart + chunk amnesia) | M | unit: kill and rebuild `ConversationManager` mid-encounter → no second hello; live 3-chunk local run → 0 re-hellos at chunk boundaries |
| **T3** | **Hello opens the encounter.** Greeting branch of `_attempt_chat_via_manager` uses the encounter id, drops `set_cooldown` / `increment_daily_encounters` / `record_greeting_sit` calls; `first_daily` bypass removed | fix 1's stateless hello, fix 2 | S | scratch sim: every hello row has an encounter; `greeting_{step}_` ids = 0 |
| **T4** | **Warm-up hazard replaces the will gate + overlap matrix.** `should_converse` = presence → encounter → hard stops → phase → hazard. Delete §3.8 items except `meeting` path and linger. Constants in one `ENCOUNTER_CONFIG` | fix 7 (hello-trap), fix 3 (overlap tiering), fix 4/5 tuning | M | unit: strangers aff 0, 15 steps co-present in social arena, seeded RNG → talk opens; `talked` phase → no second talk; hard stop → p = 0. Scored run §5 |
| **T5** | **Per-side hazard, intent, initiator, opener (§3.9) + satiation + crowd.** `Intent` record on scratch (armed by `mint_leftover`, `_apply_survival_lifestyle`, plan text, `movement_report_interrupt`); holder's p = 1, other side untouched, B hard stops delay not cancel; `opener_intent` on `ConversationContext`; `last_talk_end_step` satiation; crowd divisor. **No `act_address` write** in this ticket. Prompt line for the opener goes through `prompt-verify` | fix 7's symmetric will gate; fix 6's floor (cost control at the source) | M | unit: A holds leftover for B, B affinity 0 and no talk today, same room → A initiates next free minute; B asleep → intent still armed, fires on wake in-room; `chat_history[0][0] == initiator`; `opener_intent.clause` == leftover clause; grep: encounter code writes no `act_address` |
| **T6** | **Delete dead paths.** `meeting`-observation hello (after `grep type="meeting"` on a headless log = 0), greeting half of `try_persist_or_linger`, `maybe_apply_linger`, `full_talk_partners_today`. Leftovers move onto the encounter row | fixes 8, 11 | S | test suite green; `SOFA LINGER` grep = 0 in code |
| **T7** | **SOT.** `sot_chats.md` §2 trigger + §3 tiers + §3b rewritten around encounters + intent/initiator; `sot_survival.md` Conversation Priors: seek stays movement-only, arrival now fires the `survival` intent. Only after T4/T5 score green (`sot-update-lifecycle`) | — | XS | — |

Everyday walk-to-person (a leftover or plan intent steering `act_address`) is **not a ticket in this pass** — it is **PM-VIL-1 Hold** (`TODO_post_mvp.md`), post-MVP, its own occupancy bet. Founder lock 2026-09-13.

Guard rails during migration: `CHAT_PRESERVES_ACTION` stays default true; KEEP / leftover / stance code untouched in T1–T5; no seek; cap 6.

---

## 5. Verify spec (scored, not vibes)

**Runs (local scratch only — never production, never the Breakfasts sim):**

- **R1 sprint:** 4-Double fork (SOT §3b: a 4-person pass is a village pass), `skip_premiere`, `diagnostic_mode=false`, `max_steps ≥ 900` (through day-1 11:00 = step 305 and 20:00 = step 845). **Plant** one stranger pair in the same arena at 06:00 with ≥ 30 min of free slice (the Saturday shape). **Force one stop + resume at ~step 300.**
- **R2 live-mode chunks:** same fork, ≥ 180 steps in 60-step chunks (three subprocesses).
- **R3 cost hour (T4+ only):** 15-Double fork, steps 240–305 (the Hobbs walk-in), for the talks-per-hour and token envelope.

**Assertions (from logs + `movement.chat` rows + `pair_encounters`):**

| # | Check | Bar | Kills which regression |
|---|---|---|---|
| V1 | Hellos per pair per encounter | **= 1**; re-greet same encounter **0**; re-greet across the restart boundary **0**; across each chunk boundary **0** | spam (Friday), fixes 2/5/6/9 |
| V2 | Planted stranger pair | ≥ 1 talk (`tier=full`, ≥ 3 exchanges) during day 1, opened while both bodies in the planted arena | silence (Saturday), fix 7 |
| V3 | Talk share, encounters ≥ 10 min co-present with both free, strangers | between **30 %** and **85 %** (design 46–69 %) | "always" and "never" |
| V4 | Talks per persona per hour (R3) | ≤ **2**; chat tokens/step ≤ baseline × 1.25 | cost |
| V5 | S4 tier integrity | hello rows ≤ 2 lines, no carry; talk sessions ≥ 3 exchanges with both bodies same arena at open and ≥ 50 % of slices | contract |
| V6 | Occupancy hold | day-1 11:00 and 20:00 **4/4** (R1); R3 walk-in ≥ 12/15 at 11:00 | gather non-regression |
| V7 | KEEP / leftover / stance unchanged | `desync_scratch_cleared` **0**; `LEFTOVER MINTED` ≥ 1 on full sits, **0** on hellos; `vote.target` writes **0**; stance keep thoughts present | §3b Current |
| V8 | Persistence proof | after resume: `ENCOUNTER RESTORED n=…` log, n = open rows before stop; open leftovers restored | restart amnesia |
| V9 | Affinity trajectory | planted pair reaches ≥ 0.2 by one talk (+0.12) plus hello, not by 4 hellos; logged per pair | hello-trap |
| V10 | Persist over-6 | **0** | cap 6 |
| V11 | Determinism | re-run R1 from the same fork with the same seeds → identical hello / talk steps for the planted pair | replayability |
| V12 | Initiator (T5+) | every talk row has `initiator`; for intent talks `initiator == intent holder` **100 %**; `chat_history[0][0] == initiator` | coin-flip opener |
| V13 | One-sided intent (T5+) | ≥ 1 intent talk where the partner had affinity < 0.2, no talk today, and no intent of their own; partner hard stop → talk opens on the first free in-room minute after, not cancelled | "B must want it" |
| V14 | Topic carry (T5+) | initiator's first line shares ≥ 1 content keyword with `intent_clause` in ≥ 80 % of `leftover` / `plan` intent talks; `survival` openers contain no engine words (`leftover`, `alliance_commitments`, `vote.target`) | "flag set, dice came up" |
| V15 | Body boundary (T0–T7) | `act_address` writes from encounter / intent code **0** (log + grep); Survival `[SOCIAL_SEEK:REDIRECT]` count unchanged vs baseline | seek leaking into this wave |

Stop rules: V1 > 0 or V6 below bar → stop and split, do not tune `H_BASE` to hide it. V3 outside band → tune `H_BASE` / `place` once, re-score; do not add a gate.

---

## 6. Founder locks (13 Sep — do not re-ask)

1. **One talk per encounter for MVP.** A second talk in the same sit only on a **new reason** (due leftover with this partner, Survival event — §3.9 Rule 1), never a second dice roll after a gap.
2. **Delete linger code** (T6). Dead by decision and by data.
3. **`pair_encounters` is a table**, not jsonb on the sim row.
4. **Hold Extraversion** until the realism charter. No multiplier in T0–T7.
5. **Body boundary (a) now, (c) later.** T0–T7 never move a body for a reason. Survival's existing once-a-day walk stays as is. Everyday walk-to-person is PM-VIL-1, post-MVP — no Seek ticket in this pass.

## 7. Intent follow-up (13 Sep) — answered in §3.9

Chance talks still exist (per-side dice). Intent talks exist too: holder initiates, B need not want it, opener carries the clause. No new walking. T5 + V12–V15. Ready to implement when the founder says go.
