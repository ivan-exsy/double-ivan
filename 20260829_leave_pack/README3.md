# Leave pack 3 — does a chat ending empty the cafe? (`20260828-1`)

Read-only. Sim `49f3ddd9-6cad-473a-9c96-97c82a7643ea`. Max step on disk **1850** (day-2 ~12:45). Runner not touched. Raw: `data3.json`. Narrative + later tables (transcripts, resolution, verbatim bench): RCA **§12 / §12.9**.

`chat_ended` = `chatting_with` nonempty at step S, empty or a different partner on the next stored step. `on_cafe` = tile x 72–83, y 19–30. `on_at_fire` = on cafe at the **exact** fire step. Destination = `act_address` (never name-test `dest`).

---

## Query 1 — 2×2

`chatting_with` is almost always a 1–2 step burst. Every cafe visitor in all three windows has at least one such burst-end. The `chat_ended = no` cells are **empty**.

| Window | Visitors | yes+on | yes+off | no+on | no+off | leave rate ended=yes | leave rate ended=no |
|---|---|---|---|---|---|---|---|
| 245–305 (d1 chal, fire 305) | 15 | 10 | 5 | 0 | 0 | **5/15** | empty |
| 785–845 (d1 vote, fire 845) | 13 | 9 | 4 | 0 | 0 | **4/13** | empty |
| 1685–1745 (d2 chal, fire 1745) | 12 | 6 | 6 | 0 | 0 | **6/12** | empty |

**yes+on / yes+off names**

- **245–305 on:** Shepard, Andrew, Dean, Irene, Max, Mike, Olivia, Owen, Vince, Vincent. **off:** Butcher, Reed, Diana, Ivan, Nick.
- **785–845 on:** Butcher, Shepard, Andrew, Diana, Ivan, Max, Olivia, Owen, Vincent. **off:** Dean, Mike, Nick, Vince. Never on cafe in this window: Reed, Irene.
- **1685–1745 on:** Irene, Ivan, Max, Mike, Nick, Olivia. **off:** Reed, Andrew, Dean, Owen, Vince, Vincent. Never on cafe in this window: Shepard, Diana.

---

## Query 2 — chains that ended

Directed `chatting_with` ends (one row per person): **228 / 185 / 94**. Unique pair+step: **141 / 122 / 57**.

Flag = two or more participants have a non-Hobbs `act_address` in the next 3 steps (any location, not cafe-only). Unique pairs: **23 / 4 / 13**. Most day-1 245–305 flags are people already at college greeting each other. Full last-line + next-3: `data3.json` → `query_2.flagged_two_plus_off_dest_any_location`.

**Cafe-tile + 2 people off-Hobbs dest, day-2 10:00–10:25 only**

| end_step | clock | pair | lines | last line | next dests |
|---|---|---|---|---|---|
| 1702 | 10:17 | Vince + Vincent | 2 | Vincent: Good morning! Yeah, slept okay. | Vince: Hobbs, Hobbs, **college**. Vincent: **Apartment 4** ×3 |
| 1704 | 10:19 | Reed + Vincent | 4 | Vincent: Unless you're paired with someone who was already on the outs… | Reed: **college** ×3. Vincent: **Apartment 4** ×3. Both already off-cafe tiles. |

Other group-B leaves in this slice are **one** person off-dest, partner stays Hobbs: Vincent+Olivia @1700; Reed+Andrew @1701 (Reed already college dest); Andrew+Dean @1705 (Andrew college, Dean Hobbs).

---

## Query 3 — group B, one row per step

Leave-write = first step `act_address` leaves Hobbs.

| Person | write | clock | last `chatting_with` before write | gap | dest at write |
|---|---|---|---|---|---|
| Reed | 1700 | 10:15 | Owen @1696 (then 3 empty) | +4 | college blackboard |
| Vincent | 1701 | 10:16 | Olivia @1700 | +1 | Apartment 4 blackboard |
| Vince | 1705 | 10:20 | Vincent @1702 (then 2 empty) | +3 | college seating |
| Andrew | 1706 | 10:21 | Dean @1703–1705 (6-line chat) | +1 | college seating |

Full per-step rows (tile, address, description, chatting_with, act_start, duration): `data3.json` → `query_3`. `chatting_with` is **empty** on all four write steps.

---

## Query 4 — crowding every 5 steps

| Window | cafe headcount | cafe convo pairs |
|---|---|---|
| 1685 | 3 | 0 |
| 1690 | 7 | 0 |
| 1695 | 9 | 4 |
| 1700 | 10 | 1 |
| 1705 | 8 | 1 |
| 1710 | 4 | 1 |
| 1715–1720 | 4 / 3 | 1 |
| 1725–1740 | 4–5 | 0 |
| 1745 | 6 | 1 |

785–845: headcount stays **9–10**. Convo pairs jump 0 → 7 → 0 (0, 3, 1, 3, 3, 2, 0, **7**, 0, 2, 0, 0, 0). Headcount does not move with conversation count.

---

## Query 5 — hedge at the four writes

| Person | step | act_event | should_react | perceived | survival broadcast ±5 | p2.reaction_llm | emit.cause | resolution_source | new dest |
|---|---|---|---|---|---|---|---|---|---|
| Reed | 1700 | empty | empty | empty | empty | 0 | none | parent_location_inherit_v1 | college blackboard |
| Vincent | 1701 | empty | empty | empty | empty | 0 | premature_inplace | parent_location_inherit_v1 | Apartment 4 blackboard |
| Vince | 1705 | empty | empty | empty | empty | 0 | premature_inplace | parent_location_inherit_v1 | college seating |
| Andrew | 1706 | empty | empty | empty | empty | 0 | none | llm_location_v1 | college seating |

All four: `decision_tags` = `routine_light`, `persist_override`, `action_switch`. `anchor_text` still **cafe customer seating**. Vince/Vincent emit rewrote raw “Reviewing challenge notes” to a walk line.

---

## Query 6

**deferred: PID.** Max step 1850. Vote window 2225–2285 not on disk.

---

## Gaps

- `chat_ended = no` cells: **empty** (every cafe visitor has ≥1 `chatting_with` burst-end).
- `act_event`, `_should_react`, recently perceived, survival broadcast ±5: **empty** on the coord rows. Scratch is live (later clock) so it cannot back-fill those four writes.
- `chatting_with` is not a continuous conversation — 1–2 step greetings dominate the end count.
- Day-2 vote 2×2 and the log batch: **deferred: PID**.

---

## Follow-up — did the conversation name the destination?

Last chat before each flip. College / Apartment 4 in the lines?

| Person | last chat | tier | dest in the talk? | What the lines actually name |
|---|---|---|---|---|
| Reed → college @1700 | Owen @1696, 2 lines | greeting | **no** | “Oh hey! Good to see you.” / “Morning! Feeling good today.” |
| Vincent → Apt 4 @1701 | Olivia @1700, 2 lines | greeting | **no** | “Hey, good morning.” / “Morning!” |
| Vince → college @1705 | Vincent @1702, 2 lines | greeting | **no** | “Getting some coffee?” (cafe, not college) |
| Andrew → college @1706 | Dean @1703–1705, 6 lines | full | **no** | “I'll grab my coffee and come back to the table” / “Go get your caffeine. I'll hold the fort” |

**Olivia** after Vincent’s chat (1701–1703): Hobbs seating · sitting down to have breakfast at a table.

**Dean** after Andrew’s chat (1706–1708): Hobbs seating · settling in at cafe customer seating.

Flip-row production: takeaway/summary **empty**, `chatting_end_time` **empty**, `reaction_llm_call_count` **0**. All four `movement_mode_source` = `keyword_in_place:outside_zone_safety_net`. Andrew `resolution_source` = `llm_location_v1`; the other three `parent_location_inherit_v1`. Vince/Vincent emit rewrite from “Reviewing challenge notes”. Andrew–Dean stored transcript **changes** between 1703 and 1704 (same conversation_id). Full lines in the data-request file.

---

## Follow-up — location resolution rows

Stored row has no inherit flag and no parent address. Hourly text at 10:00 is still Hobbs for all six.

| Flip | resolver | stored anchor | output |
|---|---|---|---|
| Reed 1700 | inherit_v1 | cafe seating | **college blackboard** |
| Vincent 1701 | inherit_v1 | cafe seating | **Apt 4 blackboard** |
| Vince 1705 | inherit_v1 | cafe seating | **college seating** |
| Andrew 1706 | llm_location_v1 | cafe seating | **college seating** |

Olivia / Dean at those same steps: Hobbs seating (Olivia llm then inherit; Dean inherit).

One step before each flip: dest still Hobbs. Flip dest first appears at the flip.

**10:00–11:00 unique action starts:** inherit **47** (19 non-Hobbs). LLM **11** (5 non-Hobbs).

Andrew LLM prompt on disk: **empty**. Row intent = “spreading out challenge notes on the table”. Path-pick list is six **college** tiles, not a sector tree.

---

## Follow-up — two log lines

Runner still live (step **1922**). `GUARD SECTOR-SHORTCIRCUIT` and `LITERAL SECTOR PIN` are stdout only. **deferred: PID** for the four flips, the pairing test, and Olivia/Dean.

Day-2 hourly, all 15: **128** blocks say **Hobbs Cafe**. **0** say **Hobbs** without Cafe.

---

## Follow-up — verbatim bench strings

Parent-setting `task` **matches** the hourly on all six (field: `f_daily_schedule[curr_index][0]` / `act_desp`). Item 5 still **deferred: PID** (step **1932**).

Hourly (10:00–11:00):

- Reed: `at Hobbs Cafe reviewing challenge notes`
- Vincent: `at Hobbs Cafe reviewing notes before the challenge`
- Vince / Olivia / Dean: `arriving at Hobbs Cafe early for the challenge`
- Andrew: `arriving at Hobbs Cafe and reviewing challenge notes`

Flip sub-task + anchor + tile:

- Reed 1700: `reading through the challenge rules [mode=in_place anchor=cafe customer seating]` · `cafe customer seating` · **(75, 26)**
- Vincent 1701: `Reviewing challenge notes [mode=in_place anchor=cafe customer seating]` · `cafe customer seating` · **(77, 29)** · emit raw same; stored dest text `walking to Apartment 4`
- Vince 1705: `Reviewing challenge notes [mode=in_place anchor=cafe customer seating]` · `cafe customer seating` · **(77, 28)** · emit raw same; stored dest text `walking to Oak Hill College`
- Andrew 1706: `spreading out challenge notes on the table [mode=in_place anchor=cafe customer seating]` · `cafe customer seating` · **(77, 26)**

Controls stay on cafe tiles. Olivia `work_area` is `the Ville:Hobbs Cafe:cafe`. Dean 1700 live row is still `walking to Hobbs Cafe` / `blackboard` while the clock-mapped slot is already `settling in…`. Full quotes in the data-request file.

---

## Follow-up — activity_type + whitelist

`activity_type` key: **empty** on all six rows. Stored decomp type is `action_family`: Reed / Vincent / Vince / Andrew / Olivia = `study`. Dean 1701 = `relax`.

Hobbs cafe whitelist: `["eat", "social", "serve", "relax"]`. College classroom: `["study", "social"]`.
