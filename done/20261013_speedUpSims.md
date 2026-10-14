# Plan: cut step time on long, large-cast seasons (headless movement validation unchanged)

## Problem

On 20261009-1 (Downtown, 14 personas, sprint, blocking headless validation), quiet steps take about 134 s. The walk takes under 1 s and the model calls take about 1 s. Almost all the rest is file I/O on `observations/pending.json`.

The engine reads and pretty-prints the whole queue file several times per step:

- **Movement reports:** once per persona. Every report post fails, so each falls back to the local queue write (`_queue_movement_report` in `headless_visualization.py`). That's about 7.5 s × 14 ≈ 107 s.
- **Proximity rows:** once more, through the same fallback (`_write_observations_to_queue`).
- **`process_pending_observations`:** a full read plus a full rewrite, about 12 s.
- **Location monitor:** another full read.
- **Start of the next step:** another full read (`process_pending_observations` again).

The file is 121 MB, 97,542 rows, all processed, covering steps 0–3333. It grows by about 30 rows per step and is never trimmed. Step cost therefore grows with **cast size × steps so far**: a bigger cast is slower on day one and slower again at the end of the season.

## Decision

**Fix the queue format in the engine. Do not change the report URL in this change.**

- **The URL isn't what's slow.** Failed posts take under 1 ms. The 7.5 s is the local rewrite.
- **Fixing the URL now would make things worse.** The gateway's first accepted post would compact the file with archive off (`OBS_QUEUE_COMPACT_ON_WRITE=true`, `OBS_QUEUE_ARCHIVE_PROCESSED=false`, keep 200 rows / 2 steps). That deletes history, including proximity rows that exist nowhere else.
- **Validation is untouched.** Same reports, same file, same blocking strict checks.

## Change 1: engine queue compaction (durable fix)

The change goes in `reverie/backend_server/reverie.py`, in the write-back at the end of `process_pending_observations`. That function already rewrites the file once per step, and it's the only place rows become processed.

- **Keep in `pending.json`:**
  - all unprocessed rows (in practice none);
  - processed **movement reports from the last two steps**.
- **Append everything else that's processed** to `observations/pending.processed.ndjson`. That's one compact JSON row per line, append-only, and the same file name the gateway already uses.
- **Write order:** append to the archive first, then rewrite `pending.json`. If the engine crashes in between, some rows land in the archive twice. That's harmless, because each row has a unique `observation_id`. The other order could lose rows.
- **Forks:** add `observations/pending.processed.ndjson` and the one-off snapshot file (see Change 2) to `FORK_BOOTSTRAP_TRANSIENT_ARTIFACTS`. Forks copy the whole sim folder, and without this they would inherit the parent's archive.

**Why keep two steps:**
- **Resume step inference** (`_infer_next_step_from_pending`) is the only code that reads processed history. If the latest step is missing one persona's report, it can still fall back to the step before.
- **Step re-runs:** keeping recent processed rows means a re-run of a step after resume deduplicates exactly as it does today.
- **Consistency:** it matches the gateway's two-step window.

**Effect:**
- `pending.json` stays at about two steps of rows for the whole season, whatever the cast size.
- Every per-persona fallback write, `process_pending` call and location-monitor read drops from seconds to milliseconds.
- Estimated quiet step: about 134 s down to roughly 10–20 s, to be measured.
- Per-step cost now depends on cast size only, not on how far into the season we are.

**Tests to add:**
- After compaction, resume step inference returns the same answer as before.
- Older processed rows land in the archive and newer ones stay in the queue.
- A partial latest step (one persona missing) still infers from the step before.
- A fork does not inherit the archive.
- Existing `test_continuation_playback_semantics` tests still pass.

**Deferred:** batching the per-persona fallback into one write per step. It only becomes worthwhile at about 50 or more personas, so add it only if measured.

**Takes effect:** for new engine processes only, meaning the next season start, or the next engine restart if the resume script is fixed. The running engine loaded its code and settings at startup.

## Change 2: one-off live trim for 20261009-1 (operations stopgap)

The live run can't pick up code: its engine can't be restarted (the resume script only accepts meta step 2597). So it gets relief by trimming the file between steps. No restart of either process is needed.

**Safe window:** opens when the engine logs `💾 Marked N observations as processed` (end of post-step processing). Closes at the next step's first `[CP-8] SUBMIT`. In between, the engine only reads the queue; it doesn't write it.

**Steps:**
1. **Snapshot:** hard-link `pending.json` to `observations/pending.archive-0-3333.json`. This is instant and keeps the exact bytes. It's safe because every writer writes a temp file and swaps it in; none edit in place. If the filesystem doesn't allow hard links, a plain copy takes about a second.
2. **Build the small file:** write a temp file in the same folder holding only the processed movement reports of the last two steps.
3. **Swap:** replace `pending.json` with it in one atomic step (`os.replace`).
4. **Abort rule:** if a new `[CP-8] SUBMIT` appears before step 3, give up and retry at the next window.
5. **Check:** the next step's `submit_reports_total_ms` should collapse.
6. **Repeat** about every 100 steps, because the file regrows by about 30 rows per step until Change 1 is live.
7. Compress the 121 MB snapshot whenever convenient.

**Risk if mistimed:** a swap that lands while reports are being queued loses one persona's report for that step. The strict check would flag that step, and could stop the run if strict abort is on. That's why the abort rule is mandatory.

**Why snapshot first:** viewer browsers can post observations to the gateway unless the frontend is configured to serve from the CDN. The full 0–3333 history shows none has been accepted for this run so far, but the snapshot guarantees a stray post can't wipe history before it's saved.

## What to keep from the 121 MB file

All of it, unchanged, in `observations/pending.archive-0-3333.json`, compressed later. The proximity rows are the only record of who was near whom at each step, which matters for root-cause analysis and scoring evidence. Chats and positions are already in Supabase.

## Gateway

- **No gateway restart** for any of this. The gateway is not in the current report path.
- **Optional extra safeguard:** set `OBS_QUEUE_ARCHIVE_PROCESSED=true` in the gateway's env file now. It takes effect at the next planned restart. After Change 1 this matters much less: if a gateway post ever lands, its compaction would only drop rows the engine has already archived.
- **Don't fix the URL in this change** (the `http://localhost:8001` vs HTTPS-only gateway mismatch). Handle it separately, after Change 1 is live.

## Known follow-ups and side effects

- The old ad-hoc `_rca_*` scripts read history straight from `pending.json`. They'll need to read the archive too. No skill, scoring or verify step depends on them.
- The archive grows at roughly the same rate the queue file grows today, but more compactly. Compress it at season end.

## Not yet verified (needs a run)

- The actual time saved per step.
- Hard-link support on the server's storage filesystem (a copy works as the fallback).
- Which viewer source the production frontend is set to.