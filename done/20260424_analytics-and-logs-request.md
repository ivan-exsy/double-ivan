# Implementation Request — Analytics Scripts + Log Preservation on Fork

**Date:** 2026-04-24
**Requestor:** Ivan (product)
**Target team:** Analytics / Backend
**Priority:** Medium–High. Blocks post-run forensic debugging on any sim that gets forked into a child.

---

## Context

The project is now fully Supabase-first: `SUPABASE_ONLY_MODE=true` is the production posture; every persistent state (memories, scratch, coordinates, survival season, reverie meta) lives in Supabase. Local JSON files are either transport (FE↔BE step exchange), diagnostics (human-readable logs), or a dev-mode cache — never the canonical copy. See `D:\Coding\double-docs\20260422_supabase-first.md`.

Two practical issues have surfaced during multi-day survival testing (2026-04-23 → 2026-04-24) that block the debug workflow:

1. **Analyzers still assume local disk layout in places**, even though they already have `--source supabase`. Minor gaps, but enough to produce confusing output when a sim's local folder is incomplete.
2. **Forking a sim deletes the parent's local runtime logs** (movement/, monitoring/, logs/, observations/, rendered/, replay/, analysis/). The parent's `personas/`, `reverie/`, `survival/`, `environment/`, `feedback/` folders remain — but every artifact needed for post-run forensic debugging is wiped.

Both are debug-ergonomics issues, not correctness issues. The simulation still runs correctly and Supabase has the canonical data. But analyzing a completed sim after a child has been forked off of it is currently painful.

---

## Issue A — Analyzers should work purely from Supabase

### Current state

Both `tests/analyze_sim_realism.py` and `tests/analyze_sim_survival.py` support `--source supabase` and already default to it when the DB credentials are present. Example from today's run:

```
> python tests/analyze_sim_survival.py 20260423-13-clean
Source: supabase | Profile: standard | Sample rate: 1
Supabase: sim_id=19bcec8c..., personas=4, max_step=904
  Fetched 3586 records
```

So the read-side is mostly fine. The gaps:

### A1. Output export still writes to a local path that may not exist
The analyzer exports to `environment/frontend_server/storage/<sim_name>/analysis/`. When the local sim folder has been pruned by the fork bootstrap cleanup (see Issue B below), the analyzer either silently fails the export or writes files that subsequently get deleted by the next fork. Either way, the export is unreliable.

**Requested behaviour:**
- Default export destination should be **outside** the sim folder — e.g., `tests/exports/<sim_name>/` or `D:\Coding\double-docs\past-sims-reports\<sim_name>/`.
- Keep `--output-dir` override as-is.
- If the default export destination doesn't exist, create it.

### A2. A few read-side functions still presume local files exist
Specifically, any helper that reads `meta.json`, `survival/season_state.json`, or `bootstrap_memory/scratch.json` from disk should be audited. Under `--source supabase`, these should come from `get_simulation_metadata` RPC / `load_survival_season_state` RPC / `persona_scratch` table — never from the local folder.

**Audit:** grep the two analyzer files for `open(`, `json.load(`, paths containing `storage/`, `reverie/meta.json`, `survival/`, `bootstrap_memory/`. Replace any that are in the main read path with Supabase equivalents. Keep disk reads only in the explicitly-local code path (when `--source api` or `--source compare`).

### A3. Compare mode (`--source compare`)
Compare mode contrasts API-returned data with Supabase-returned data. It's a legitimate tool for verifying the dual-write path. No change needed; just make sure it doesn't break when the local sim folder is pruned.

### Acceptance criteria for A
- `python tests/analyze_sim_realism.py <sim_name>` runs to completion and exports to `<default_export_dir>/<sim_name>/` even if `environment/frontend_server/storage/<sim_name>/` is completely absent from disk.
- `python tests/analyze_sim_survival.py <sim_name>` same.
- Both work for any sim present in Supabase, with no local files required.
- `--source api` and `--source compare` continue to work for sims that DO have local files.

---

## Issue B — `log N` mode should create + preserve the full sim folder

### Current state

`reverie.py` has two run modes at the `Enter option:` prompt:

- `run N` — advance N steps, minimal diagnostics on disk.
- `log N` — advance N steps WITH **full movement + FE forensics + LLM capture** written to `environment/frontend_server/storage/<sim_code>/logs/`. Used when Ivan needs to debug a simulation.

Code entry point: `reverie.py:6530-6534`.

Expected layout after `log N` for sim `<X>`:
```
environment/frontend_server/storage/<X>/
├── movement/                  # per-step FE↔BE payloads
├── monitoring/                # per-step sim state snapshots
├── observations/              # per-step observation exchange
├── logs/
│   ├── fe-forensics/          # FE pathfinding / replay traces
│   ├── llm/                   # per-step LLM prompt+response dumps
│   ├── movement-pipeline.ndjson
│   └── movement-pipeline-summary.md
├── replay/, rendered/, feedback/
├── personas/, environment/, reverie/, survival/
└── analysis/                  # on-demand, written by the analyzer
```

### B1. Full layout is created by `log N` — this already works
During a live `log N` run, reverie.py writes everything listed above correctly. Confirmed today on `20260423-13-clean` Day 1: `log 900` produced a full folder tree. No change needed here.

### B2. The folder is destroyed when a child sim is forked off of this sim

**Observed 2026-04-24:** After `fork_simulation('20260423-13-clean', '20260423-13-clean-day2')`, the parent's local folder collapsed to:
```
environment/feedback/personas/reverie/survival/   ← minimal bootstrap only
```
Everything in `movement/`, `monitoring/`, `logs/`, `observations/`, `rendered/`, `replay/`, `analysis/` was deleted.

**Root cause:** `reverie.py` `_bootstrap_missing_fork_from_supabase()` at approximately **reverie.py:2056-2060**:

```python
target_folder = os.path.abspath(f"{fs_storage}/{fork_sim_code}")
os.makedirs(os.path.dirname(target_folder), exist_ok=True)
if os.path.exists(target_folder):
    shutil.rmtree(target_folder)           # ← deletes parent's runtime data
copyanything(template_folder, target_folder)
```

This function runs every time reverie starts up and the fork source's local folder needs to be re-hydrated from Supabase. It blindly `rmtree`s the existing folder before copying the minimal Supabase-derived template on top. The "template" only contains the canonical bootstrap data (`personas/`, `reverie/meta.json`, `survival/season_state.json`, `environment/`) — **not** the runtime logs that the previous run produced.

This is too aggressive. The intent of the bootstrap was "ensure the fork source has a valid starting state for the child fork to copy from." Runtime logs from a prior completed run of that sim are not part of the bootstrap state; they're post-run forensics and should be preserved.

### Required fix

Change the cleanup behaviour in `_bootstrap_missing_fork_from_supabase()` (reverie.py:2058-2059) from **delete-everything-then-copy** to **merge-update**:

- **Do not** rmtree the parent folder if it already exists.
- Overwrite only the canonical-bootstrap files that the function re-writes from Supabase (`reverie/meta.json`, `personas/<name>/bootstrap_memory/scratch.json`, `survival/season_state.json`, `survival/agents/<name>.json`, `environment/0.json`).
- Leave everything else (`movement/`, `monitoring/`, `logs/`, `observations/`, `rendered/`, `replay/`, `analysis/`, `feedback/`) untouched.

Practical implementation: replace the `shutil.rmtree` + `copyanything` with a loop that writes each canonical file individually, or with a `copyanything` variant that overwrites files without pre-deleting the destination tree.

### Acceptance criteria for B
- Run `log 30` on a new sim `<X>`. Confirm `storage/<X>/logs/` is populated.
- Start a new reverie session, fork `<X>` into `<Y>`. Confirm:
  - `<Y>` is created normally (no regression in the fork flow).
  - `<X>`'s local folder is still intact — specifically `<X>/logs/`, `<X>/movement/`, `<X>/analysis/` all still contain the data from before the fork.
- Repeat the fork (`fork <X> → <Z>`). `<X>` still intact.

### Edge cases / non-goals

- **Fresh fork of a sim whose local folder is incomplete** — the current behaviour (rebuild from Supabase) is actually correct in this case. Handle the two cases distinctly: if the folder is present and contains a valid `reverie/meta.json`, merge-update; if it's missing or meta.json is absent, do the full rebuild as today.
- **Concurrent runs on the same sim** — not a supported scenario. The fix does not need to be multi-process safe.
- **Disk usage growth** — preserving logs means sims accumulate disk footprint across forks. Acceptable for the debug workflow; a separate `clean-old-sims.py` housekeeping script could be added later if needed.

---

## Testing & verification

Both changes are behaviour-affecting, so require `/verify` per `CLAUDE.md §Rules & Conventions` before merging.

Suggested regression test additions:

1. `tests/test_fork_preserves_parent_logs.py` — forks a sim that has a populated `logs/` directory, asserts logs still exist after the fork RPC call.
2. `tests/test_analyze_sim_without_local_folder.py` — deletes the local folder for a sim that exists in Supabase, runs both analyzers, asserts they export successfully.

---

## Pointers

| Item | Location |
|---|---|
| `log N` CLI handler | `reverie/backend_server/reverie.py:6530` |
| Fork-time folder rebuild | `reverie/backend_server/reverie.py:2058-2060` |
| `_remove_fork_bootstrap_transient_artifacts` (narrow, keep as-is) | `reverie/backend_server/reverie.py:88` |
| Analyzer — realism | `tests/analyze_sim_realism.py` |
| Analyzer — survival | `tests/analyze_sim_survival.py` |
| Supabase RPC: simulation meta | `get_simulation_metadata(sim_name)` |
| Supabase RPC: survival state | `load_survival_season_state(sim_name)`, `load_all_survival_agent_states(sim_name)` |
| Supabase table: coords/movement | `double.personas_coords` |
| Supabase table: memories | `double.dbl_memory` |
| DB reference index | `D:\Coding\generative_agents\supabase\db_reference.md` |
| Three-bucket file taxonomy (context) | `D:\Coding\double-docs\20260422_supabase-first.md` |

---

## Out of scope for this request

- Changes to `fork_simulation` RPC semantics (already patched today — see migrations 20260423130000, 20260423140000, 20260423150000, 20260423160000).
- Survival controller `sim_code` preservation (already patched today in `reverie/backend_server/survival/controller.py`).
- The `varchar(50)` node_id depth limit (tracked separately in `20260423_merge-complete.md §C.2`).
- Performance optimisation of long-running sims (separate follow-up).
