# Backend reply — Downtown hybrid maze

**To:** Frontend (double-r3f / downtown)  
**From:** Backend  
**Date:** 2026-09-01  
**Re:** Can we run a hybrid maze (coarse city + fine rooms) for Pittsburgh Downtown?  
**Status:** Current contract (live). Not a production `the_ville` cutover. Not an implement brief.

---

## Verdict

**Hybrid: no** under the live FE–BE contract.

Phase 1 / Cut A should be **one maze, one cell size**. Plan on **uniform 4 m** (~223 × 140). Locked building pads are collision. Recipe interiors are **not** on the live tape until a later, funded Backend world pass.

**Cut B** (a recorded day that uses those insides) is **not in scope this quarter**. Do not wire recipe rooms into live scenario gen.

If we later need Hobbs-like rooms on Downtown, that is a **new contract**, not an FE portal skin. Do not raster two grids assuming Backend will catch up.

---

## Your beliefs — mostly correct

| Belief | Current |
|---|---|
| Payloads are tiles, not meters. Pixels are FE-only (`tile * 32`) | **Yes.** `sq_tile_size` is 32 px. There is no meters field on movement or maze templates. (`sot_be-fe.md` §1) |
| One sim has one `maze_name` and one rectangular tile space. `[x, y]` is unique in that maze | **Yes.** `simulations.maze_id` is a single FK. One `Maze` object. One collision grid. |
| `act_address` / `target_zone` are strings in that maze’s address tree | **Yes.** Shape is `World:Sector:Arena[:Object]` (e.g. `the Ville:Hobbs Cafe:cafe`). |
| Intent-only path: BE sends `target_zone`; FE A* on that collision grid | **Yes.** Production default `BACKEND_INTENT_ONLY_PATH=true`. (`sot_be-fe.md` §2.4, §2.7) |
| This-step end tile must stay within `MAX_TILES_PER_STEP` (default 6) of `start_pos` | **Yes.** Manhattan on **bare** `[x, y]`. Persist rejects larger jumps as `implausible_teleport`. |
| Proximity / chat distance is in tiles | **Yes, with a small correction:** talk start is **3 tiles** base (`CONVERSATION_CONFIG.threshold.base_tiles`), plus atmosphere mod, plus +1 while a talk is already open. Vision radius is 4 tiles. Order-of-~4 is the right mental model; it is not meters. |
| Spatial memory and object pick read maze tables / `address_tiles` for that one maze | **Yes.** RPCs take `p_maze_name` or `simulation_id` → one template. |

If `[x, y]` has no maze id and A* is one grid, hybrid is a Backend change. **Agreed. FE cannot hide the portal.**

`sot_sim.md` mentions multiple worlds / districts. That file is **Draft**. It does not authorize two collision grids in one live sim.

---

## Questions 1–10

### 1. Two mazes in one sim?

**No.** A persona may not live on `downtown_city` in one step and `downtown_bldg_<osm_id>` after a door in the same sim.

**Supported shape:** a single maze with interiors **inlined** (one grid, one cell size, one `maze_name`). That is The Ville today: streets and Hobbs rooms share `the_ville` / 140 × 100.

Create-sim currently allowlists only `the_ville`. A second template can exist in `maze_templates`; a sim still binds **one** of them.

### 2. Tile identity

City `[12, 40]` and interior `[12, 40]` would be **different meters** and **the same identity** in every live payload.

The movement bundle does **not** carry `maze_id` on `movement`, `start_pos`, `actual_pos`, or `actual_path`. Positions are `[tile_x, tile_y]` only. (`sot_be-fe.md` §2.2, §4.2)

**Bare `[x, y]` → hybrid cannot ship.** Adding maze id is a contract change (emit, persist, coords SOT, proximity, chunks, memory). Do not start Phase 1 as if that field exists.

### 3. Address tree

`Downtown:Market Square Bldg:dining` is the **same** `World:Sector:Arena` shape as `the Ville:Hobbs Cafe:cafe`.

`:ground` (street pad) and `:dining` (room) should be **two arenas of one sector, one world, one maze** — the Hobbs pattern (`:cafe` vs sidewalk is still one grid, adjacent tiles).

They must **not** be two worlds. Two worlds would be two sims or a hybrid rewrite.

### 4. Cross-door path

Today FE A* cannot walk to an address whose tiles are not on the **current** collision grid. Correct.

**Who owns a portal hop?** Neither side, because there is no portal. Backend does not emit two `target_zone`s. Frontend must not teleport on a door tile: persist would see a Manhattan jump (city `[50, 80]` → interior `[2, 3]`) and **reject** the report (`implausible_teleport`, cap 6).

Same-step city tile → interior tile is **not** allowed under Current.

A future hybrid would need Backend to own the hop (door as this-step dest, then switch grid next step) **and** persist that knows portals. That is not Phase 1.

### 5. `MAX_TILES_PER_STEP` (6)

We keep **one tile constant**. The engine does not have meters-per-step.

| Grid | 6 tiles | Point → Grant (your numbers) |
|---|---|---|
| 4 m | 24 m / step | ~220 tiles ≈ **37 steps** (~37 min clock; `sec_per_step` = 60) |
| 1 m | 6 m / step | ~890 tiles ≈ **148 steps** (~2.5 h clock) |

**Day length we want for Downtown Cut A:** the **4 m / ~37-step** city crossing — similar to a long Ville walk. Not the 148-step day.

Uniform 1 m with the same cap of 6 makes the city crawl. Raising the cap so streets feel like 24 m/step makes a cafe-sized room one step. That fight is why hybrid looks attractive and why we **refuse it** rather than paper over it in Frontend.

### 6. Proximity

Proximity stays **tiles in the current (only) maze**. No meters.

Two people **cannot** talk across a door if they are on two grids: Manhattan on bare `[x, y]` would either lie (same numbers, distance 0) or miss them. Even on one grid, talk is tile distance, not “same OSM building.”

At 4 m, base talk range is **3 tiles = 12 m** (elastic 4 = 16 m). That is a city sidewalk, not a Hobbs sofa. Accept that for Cut A. Do not ask Backend for meters until a separate contract pass.

### 7. Ingest

**Not** “exactly one 140 × 100 `the_ville`” at the data layer. `maze_templates` already has `width`, `height`, `sq_tile_size`. CSV → Supabase (`maze_meta_info.json`, collision / sector / arena / game_object / spawn, blocked id **32125**) is the existing ingest shape.

**Production create-sim is still `the_ville` only.** Ingesting Downtown does not make it a runnable sim by itself.

There is **no door table**. Do not add one for Phase 1.

Sector ids starting at **50001** are a fine human convention so greps do not collide with Ville Tiled ids. They are **not** required for DB uniqueness (tiles are keyed by `maze_id` + `x` + `y`).

### 8. Chunks / `get_maze_chunk`

City ~223 × 140 ≈ **12** chunks at 64. Fine.

The RPC is `get_maze_chunk(simulation_id, chunk_x, chunk_y)` — **one maze per sim**, overrides applied. It does **not** take `maze_name`. You cannot fetch a second maze’s chunks for the same sim.

### 9. Cut B / scenario gen

**No** — not this quarter, including the 10–15 insides.

Even a street-only Downtown day is a **new world** on Backend, not “load CSVs”:

- Create-sim allowlist
- Maze registry (sector/arena types, affordances, spawn/home)
- Planner / daily plan / survival gather (today those paths know Hobbs, Oak Hill, Ville homes)
- Prompts and address trees

Village MVP (talk leftover) is the live Backend chapter. Downtown scenario gen would steal that.

**FE:** build the **street map** for Cut A. Do **not** wire recipe rooms into live scenario gen.

### 10. Production

**Confirmed.** No swap of `the_ville` on Vercel / double-front / VPS until a separate founder cutover. This inquiry is Downtown only. Kit village stays FE experiment (not ingested).

---

## What FE should implement in Phase 1

1. Raster OSM Golden Triangle at **4 m / tile**, one CSV set, one world string `Downtown`.
2. Streets + water walkable; ~200 buildings **locked** (collision 32125).
3. Addresses like `Downtown:<OSM name or Building {osm_id}>:ground` are fine **as labels on that one grid**. They are not a second maze.
4. Do **not** emit a second 1 m collision maze. Do **not** implement door teleports. Do **not** assume Backend will plan a body that changes maze mid-walk.
5. Phaser / chunking: ~223 × 140 is in range (~2× Ville). Uniform 1 m (~890 × 560) is the size you already flagged as too big for current Phaser/CSV/A*.

## If we later want Hobbs-like rooms

Pick one, explicitly, as a new Backend pass:

| Option | Rooms | City day | Contract |
|---|---|---|---|
| **A. Stay 4 m, weak rooms** | Cafe ~3 × 2 cells; furniture not on own cells | Same as Cut A | Current |
| **B. Rebuild 1 m, interiors inlined** | Hobbs-like | ~148 steps Point→Grant unless we change speed | Current shape, painful size + speed |
| **C. Hybrid two grids** | Hobbs-like + Phaser city | 4 m streets | **New** contract: maze id on every position, Backend-owned hop, persist/proximity/chunks |

**Recommendation:** A unless the founder funds C (or accepts B’s day length and A* cost). Do not mix A+C in Phase 1.

---

## Citations (Current)

- `double-docs/sot/sot_be-fe.md` §1, §2.4, §2.7, §4.2
- `double-docs/sot/sot_action-location.md` (address / `target_zone` vs body)
- `double-docs/sot/sot_sim.md` — Draft only
- `generative_agents/api_gateway/app/core/validation.py` — create-sim `maze_name in ['the_ville']`
- `generative_agents/supabase/db_reference.md` — `get_maze_chunk(simulation_id, chunk_x, chunk_y)`
- `generative_agents/reverie/backend_server/maze.py` — one `Maze(maze_name)`
- Persist: Manhattan(`start_pos`, `actual_pos`) ≤ `MAX_TILES_PER_STEP` (default 6)
- Talk: `CONVERSATION_CONFIG.threshold.base_tiles = 3`

Task: `COS/tasks/2026-09-01-002`
