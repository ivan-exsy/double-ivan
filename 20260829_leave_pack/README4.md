# Leave pack 4 — arena whitelist: keep, widen, or retire (`20260828-1`)

Read-only. Sim `49f3ddd9-6cad-473a-9c96-97c82a7643ea`. Max step ~**2030** (day 2 15:45). Runner not touched. Raw: `data4.json`. Full tables in `20260829_datareq_4_whitelist-strategy.md`.

No recommendation. Veto and search kept separate.

---

## Q1 — Registry

**63** arenas. Whitelist key present **53**, absent **10**, null **0**.

Activities: `art` `cook` `eat` `exercise` `hygiene` `play` `relax` `serve` `shop` `sleep` `social` `storage` `study` `work`.

Scarce (≤3 arenas): `art` 1 · `shop` 2. `study` 4 · `serve` 4. `relax` 31 (widest).

Hobbs cafe: `["eat", "social", "serve", "relax"]`. College classroom: `["study", "social"]`. Full 63-row table in the data-request file.

---

## Q2 — Stored `action_family` (every step, n=29325)

empty **8969** (8273 of those are `planner_contract_v1`) · `relax` 6834 · `work` 4806 · `study` 2770 · `eat` 2731 · `hygiene` 1052 · `play` 879 · `cook` 696 · `social` 579 · `exercise` 9.

In the run but not in any whitelist: **empty** only.
In a whitelist but never in this run: `art` `serve` `shop` `sleep` `storage`.

---

## Q3 — Top five × arenas

| family | n arenas | ≤3? |
|---|---|---|
| empty | 0 | **flag** |
| `relax` | 31 | no |
| `work` | 18 | no |
| `study` | 4 | no |
| `eat` | 12 | no |

`study` only: Apartment 4 main room · Dorm Room 2 · college classroom · college library.

---

## Q4 — Inherit/planner dest sector ≠ hourly-named sector

Day 1 original hourly: **empty** (rollover snapshot is a 1260-min “earlier today” lump, no sector name).

Day 2 (live hourlies, through ~15:36): **1414 / 5540** sector-naming rows. 90 distinct actions. `from` arena empty (hourly names a sector only).

Biggest triple: `Hobbs Cafe:` → `Oak Hill College:classroom` · `study` · **343**. Next are Hobbs → pub (`play`/`relax`/`eat`) and Hobbs → Apartment 4 `study`.

By hour: **10:00 is the peak** (310/780). 11–13 stay high (242–258). 19:00 vote not on disk. Hour 7’s 60/60 is Olivia’s hourly `Apartment 1` vs dest `House 1`.

This proxy is not veto-only.

---

## Q5 — Resolvers / logs

`parent_location_inherit_v1` **15882** · `planner_contract_v1` **8273** · `llm_location_v1` **4488** · empty **696**.

Cascade / guard log counts: **deferred: PID**.
