*I use Supergrok subscription to run Grok Bot. Noticed that my Supergrok usage quota gone super fast - in 3 days Sep.12-13-14.*

*Need to investigate this and find ways to optmize:*


**Totals (Sep 12–14 ET + Wave 2 into midnight):** 20 sessions · **140M** input tokens · 322K output · **92% cache reads** · 1040 model calls · almost all `grok-4.6`

| Where | Input | Share |
|---|---|---|
| `generative_agents` | 88M | 63% |
| `double-landing-page` | 32M | 23% |
| `double-front` | 14M | 10% |
| `double-r3f` | 6M | 4% |

**By agent type:** `grok-build-plan` ate **134M (96%)**. `general-purpose` 4M · `explore` 1.4M.

**Top burns**
1. **W0–W1 verify / iPhone** — 54M · 42 turns · Sat 4pm→Sun 1pm · context kept growing (turns hit 3.7M, 5.1M, **5.9M** input)
2. **Wave 2 talks / lore ban** — 33M · 13 turns · Sun 6:30pm→midnight · one turn alone **11.2M** input; another **7.7M** (sim watchers waking the same fat chat)
3. **Look photo 1MB / quiz** — 24M · 24 turns · Sat afternoon–evening · same grow pattern (turns to **2.7M / 3.8M**)
4. Then T-W4 front 8M, portal tickets 8M, r3f Nico spike 6M

**Inefficient patterns (ranked)**

1. **Long `grok-build-plan` chats that never reset** — 96% of spend. Continuations after “ran out of context” still re-feed huge summaries. Cache is 92%, but SuperGrok still meters that compute.
2. **Monster turns inside those chats** — Wave 2 t4 = 11M in one call; verify-walk had several 2–6M turns. That’s the smoking gun.
3. **Parallel plan sessions across repos** — verify-walk overlapped landing-page **6+ hours** and r3f **20+ hours**. Wave 2 overlapped front + landing + r3f the same Sunday evening. Four plan chats burning at once.
4. **Sim watchers glued to the fat session** — Wave 2 got monitor-ended reminders that re-woke a 30M+ context chat (hours-long watches).
5. **One-turn “learn / map / verify” swarm** — 13 sessions ≥200K in one turn (mostly double-front noon Sun), **~6M** total. Each cold-starts tools/MCP. Fine individually; together they’re noisy.
6. **Stale r3f session** — opened Sep 10, still alive Sep 14, overlapped everything for days while doing little.

**What looked fine**
- Using `explore` + `grok-4.20-non-reasoning` for short map jobs (~0.4–0.5M each)
- Dropping input on some turns (compaction / focused asks) — happens, just not often enough
- Small output vs input (not “wrote novels”) — waste is **input re-feed**, not chatty replies

**Do this next week**
1. **New session per workstream** (Breakfasts verify ≠ Wave 2 ≠ landing photo). Don’t “continue” a 20+ turn plan chat.
2. **Hard reset when a turn’s input > ~1M** — or after ~8–10 fat turns. Cheaper than another 5M turn.
3. **One active plan session at a time** across repos. Park r3f/front when generative_agents is hot.
4. **Detach long sim watches** from the coding chat (or a tiny dedicated session) so monitor callbacks don’t re-inflate a 30M context.
5. **Keep map/locate on `explore` + non-reasoning**; don’t promote them into `grok-build-plan`.
6. **Batch learn/signal mapping** into one session (or a script), not 8–12 parallel one-shots.
7. **Close idle sessions** at end of day (that Sep 10 r3f chat).
8. For verify-walks: checklist + short sessions per symptom — not a 42-turn live autopsy in one thread.
