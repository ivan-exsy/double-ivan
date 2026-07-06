# FE Implementation Inquiry — Survival day-label surfaces

**Date:** 2026-06-28
**From:** Ivan (BE)
**To:** FE team
**Reference:** [`15sim-polish.md`](./15sim-polish.md) §9.9 #8, [`sot/sot_survival.md`](./sot/sot_survival.md) §Day indexing → "Operator surfaces"
**Sim that surfaced it:** `20260627-2` (15-player Survival season)

## UPDATE 2026-06-28 — your two contract asks are shipped

You asked for two things before building; both are now on the BE and live on the `double` Supabase. Build against the contracts below.

1. **`day_label: string | null` on both highlights paths** — ✅ shipped. Added a `day_label` text column to `day_highlights` (migration `20260628150000`, applied to `double`). `video/build_highlights.py` populates it; `video/highlights_store.py` and the CDN artifact (`publish_highlights_artifact`) both carry it; the gateway endpoint `GET /api/simulations/{sim}/day/{day}/highlights` now returns `day_label` (plus `season_day_number` / `is_grace_day` for completeness). Render `day_label ?? \`Day ${day}\`` verbatim — no FE branching rule, BE owns the string.
2. **`is_survival` on `/status/current` + CDN manifest, plus `current_day_label` + `engine_day` on `/status`** — ✅ shipped. `/status/current` now returns `is_survival` (bool), `current_day_label` (string, nullable), `engine_day` (int, nullable). The CDN live manifest (`live.json`) now carries `is_survival` (bool) so `/play` can skip the `/survival` probe without any backend round trip. `/api/simulations/{sim}/survival` is confirmed **CORS-public** (global middleware), **unauthenticated** (no auth dependency), and **CDN-cacheable** (`Cache-Control: s-maxage=60, stale-while-revalidate=300`) — safe to call from the CDN-only `/play` route.

So your chunk 1 (types + API client + `useSurvivalStatus`) and chunk 2 (`useDayHighlights` + `HighlightsSideList`) can proceed with the payloads below verbatim. The two open questions that remain yours: grace-day wording (we send `is_grace_day: true` + `day_label: "Premiere"` — say the word if you want a different string and I'll swap it BE-side), and any other bare-"Day N" FE surfaces to align.

---

## Original inquiry (kept for context)

## Why this is coming to you

The `20260627-2` RCA found that the same simulated day carries **three different "Day N" labels**, and operator/viewer surfaces were showing the bare engine day number — which reads as "Day 1 = first survival day" when in fact engine day 1 is the **DP8 grace/premiere** (survival dormant) and **survival season day 1 = engine day 2**. That conflation caused false "someone was eliminated on the premiere day" alarms and made the highlights chapter list disagree with the HUD.

The BE has now labeled both schemes everywhere it writes state (highlights row, video CLI, elimination/vote memory prose, and a new survival status endpoint). The remaining surfaces are **FE-rendered**, so this is an inquiry, not a directive — please confirm the contract below works for your HUD/chapter-list components and tell me what else you need.

## What the BE now furnishes

### 1. Survival status endpoint (new) — for the HUD

`GET /api/simulations/{sim_code}/survival`

- **404** when the sim is not a Survival season (your existing non-survival HUD path stays as-is).
- **200** body:

```json
{
  "sim_code": "20260627-2",
  "current_day": 1,
  "current_day_label": "Survival Season Day 1",
  "engine_day": 2,
  "total_days": 14,
  "phase": "VOTING",
  "status": "running",
  "winner": null,
  "active_challenge_id": "resource_race",
  "remaining_players": ["Ivan", "Irene", "Max Shoemaker"],
  "remaining_count": 3,
  "eliminated": [{ "name": "Klaus Lopez", "day": 1, "vote_count": 5, "final_statement": "..." }],
  "eliminated_count": 1,
  "eliminated_names": ["Klaus Lopez"]
}
```

- `current_day` = survival season day (1-indexed from the first competitive day).
- `engine_day` = `current_day + 1` (engine day 1 = grace = season day 0).
- `current_day_label` = ready-to-render string — please use it verbatim in the HUD so we never re-derive the label client-side and risk a third interpretation.
- `eliminated[*].day` is the **season day** (same as `current_day`'s scheme), not the engine day.

### 2. Day-highlights row — for the chapter list

`day_highlights` (served via your existing highlights pull endpoint) now carries two extra columns:

| Column | Type | Meaning |
|---|---|---|
| `season_day_number` | int, nullable | Survival season day. `null` for non-survival sims, full-range runs, and the grace/premiere day (engine day 1 = season day 0, uncounted). For engine day N>1: `N-1`. |
| `is_grace_day` | bool, nullable | `true` on the DP8 grace/premiere day (engine day 1) of a survival sim; `false` for competitive survival days; `null` for non-survival sims and full-range runs. |

`day_number` (the existing column) is unchanged — it stays the **engine calendar day**.

**Proposed render rule for the chapter label** (please sanity-check against your component):

```
if is_grace_day === true        → "Premiere"
else if season_day_number != null → `Survival Day ${season_day_number}`
else                              → `Day ${day_number}`   // non-survival sim or full-range
```

So a survival sim's chapter list reads: `Premiere · Survival Day 1 · Survival Day 2 …`, while a family sim still reads `Day 1 · Day 2 …`.

### 3. Memory prose (no FE action, for awareness)

Elimination and "vote concluded" memory descriptions now read `"<name> was eliminated … on Survival Day N (engine Day N+1)"`. If your memory/chat-bubble surface shows the raw description, it'll already carry both labels — no FE change needed. If you parse or reformat it, preserve both qualifiers.

## Questions for the FE team

1. **HUD source**: Is `GET /api/simulations/{sim_code}/survival` the right shape for your HUD, or do you already pull `survival_season_state` directly via Supabase Realtime/PostgREST and prefer to keep that path? If you keep the Supabase path, I can mirror the `current_day_label` / `engine_day` derivation into a view or a doc snippet you can copy — say which you'd prefer.
2. **Chapter label**: Does the proposed render rule above fit your highlights component, or do you need a single pre-formatted string column from the BE (e.g. `day_label: "Survival Day 1"`) so the FE does zero derivation? I can add it if you'd rather not branch client-side.
3. **Grace-day wording**: "Premiere" vs "Grace Day" vs "Prologue" — what reads right in the UI? The BE only sends `is_grace_day: true`; the wording is yours to pick.
4. **Other "Day N" surfaces**: Are there any other FE surfaces that print a bare day number (timeline scrubber, step counter, recap cards, etc.) that should adopt the same label? If you list them, I'll check whether they need a BE-side label field too.

## What's already shipped on the BE (so you don't wait)

- Migration `20260628140000_day_highlights_season_labeling.sql` — **applied** to the `double` project; the two columns are live and `build_highlights` populates them on the next highlights rebuild for any survival sim.
- `GET /api/simulations/{sim_code}/survival` — **registered** and serving the payload above.
- `--season-day N` CLI alias on `video/extract_day_log.py` and `video/build_highlights.py` (operator tooling, not FE-facing — for your awareness only).

No FE work is blocked by the BE; the contracts above are stable.

## Suggested next step

Pick a survival sim (e.g. `20260627-2`) and wire the HUD + chapter list to the labeled fields above. If anything in the contract is awkward for your components, reply here and I'll adjust the BE before you build against it.
