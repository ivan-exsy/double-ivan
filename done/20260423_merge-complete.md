# Merge Complete — `ivan/merge-supabase-first` → `main`

**Date:** 2026-04-23 (closed 2026-04-24)

## Summary

- Clean Day-1 run validated on `20260423-13-clean`.
- Day-2 fork (`20260423-13-clean-day2`) completed 1500 / 1500 steps with both eliminations, clean background-character carryover, and strict Supabase-first mode holding end-to-end.
- All P0 + P1 items resolved on 2026-04-24: survival resume guard, baseline fork clock alignment, `CURRENT_DATE` → UTC, and `dbl_memory.node_id` overflow fixed via fresh UUIDs (depth-3 fork smoketest passed).
- Inheritance-fence decision resolved on 2026-04-24 as **keep** — fence fires on 56 % of placements and drives <2 % semantic mismatches, narrowly scoped to body-care verbs.

## Pending items

All remaining follow-ups have been migrated into [`BACKLOG.md`](./BACKLOG.md) on 2026-04-24. IDs:

- **P2** — `DECOMP-BODYCARE-001`, `LOG-TYPO-001`
- **P3** — `FORK-CROSS-HOST-AUDIT-001`
- **P4** — `STORAGE-JSON-COLDSTART-001`, `SPATIAL-VISITED-001`
- **P5** — `PERSONA-NAMES-WRITE-001`, `BRANCH-CLEANUP-001`, `CHECKOUT-CLEANUP-001`

This doc is retained as the merge-closure record. Status tracking now lives in BACKLOG.md.
