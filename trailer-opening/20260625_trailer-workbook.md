# Opening Trailer Workbook — `soul15_seed_20260224`

**Meta goal:** `soul15_seed_20260224` is the **pilot cohort** — not a one-off manual asset dump. We walk the trailer pipeline step by step, produce Anya-quality assets for this sim, and **capture each step so the next cohort can run with one command** (`generate_trailer` + cohort asset generation).

| Field | Value |
|---|---|
| **Simulation (pilot)** | `soul15_seed_20260224` (15 Doubles, Survival Mode, the Ville) |
| **Cohort folder** | `D:\Coding\generative_agents\video\assets\cohort\soul15_seed_20260224` |
| **Reference standard** | Anya cut `video/opening-anya/DOUBLAND1.mov`; timing SOT `trailer-opening/teadown/` |
| **Automation baseline** | `data/base_family_sim/opener&009/output/trailer_9x16.mp4` |
| **Implementation plan** | `trailer-opening/20260617_vertical-trailer-automation.md` |

---

## Status & open TODOs (2026-06-25)

**Readout:** Cast montage is approved (preview v2). Fifteen-person **pipeline code** is in the repo. **No full opener MP4 yet** — world motion assets (Phase 4) must land first.

### Completed

| Area | Status | Notes |
|---|---|---|
| **0a–0b** | Done | Supabase manifest, 15 locked trait lines, asset registry |
| **1 / 1b** | Done · **Ivan approved** | All 15 hero spotlights + portrait crops in Storage |
| **2** | Done | Group photo (3 rows) + matrix tier registered |
| **3** | Done · **preview v2 approved** | `fifteen_spotlight_montage` motion grammar locked |
| **5 — code** | Done (not yet run end-to-end) | See automation table below |
| **Prompt registry** | Done | `cohort/soul15_seed_20260224/prompt_log.md` backfilled |

**Automation shipped 2026-06-25 (Phase 5 prep + 15-cast glue):**

| Capability | Where |
|---|---|
| Manifest export from Supabase | `video/export_cohort_manifest.py` |
| Opener context up to 15 personas, manifest-first | `video/extract_day_log.py` |
| Trait-only VO script (no per-person LLM when manifest row exists) | `video/showrunner.py` |
| Dynamic narration segments (8 + N cast + 6 tail → **29** for soul15) | `video/opener_beat_map.py` |
| Integrated spotlight props stage narration + music | `video/build_fifteen_spotlight_props.py --integrate-opener` |
| Package A props accept 29 segments | `video/build_opener_remotion_props.py` |
| Validator **90–105 s** band for spotlight cohorts | `video/validate_trailer.py` |
| `generate_trailer opener --top 15`; default voice **`trailer`** | `video/generate_trailer.py`, `video/tts.py` |

### Open TODOs (priority order)

| P | Task | Owner | Depends on | Done when |
|---|---|---|---|---|
| **P0** | **Phase 4** — world / survival / relationship Grok assets (strict workbook path) | Ivan | — | soul15 plates registered in Supabase; no Pistsov/Anya reuse |
| **P0** | Regenerate **per-cohort** `Family.mp4` equivalent for soul15 | Ivan | Phase 4 | Cast-specific motion plate in Storage |
| **P1** | **Phase 5 run** — first `generate_trailer soul15_seed_20260224 opener --top 15` (trait VO + trailer voice) | Auto | Phase 4 assets for full mix; VO-only path testable earlier | `narration_timing.json` has **29** segments; trait lines match manifest |
| **P1** | **Phase 6** — first full Remotion render + validation | Auto | Phase 4 + 5 | `trailer_9x16.mp4` passes validator (90–105 s); poster frame exported |
| **P1** | `export_relationship_graph` — 15-node layout from Supabase | Auto | Phase 4 | Graph JSON feeds concept/turn beats |
| **P2** | `trailer_run` table + post-render Storage upload | Auto | Phase 6 | Run metadata + MP4 path in DB |
| **P2** | `generate_cohort_assets` thin orchestrator | Auto | Phase 4 | One command: heroes → group → world rows |
| **P3** | **Phase 7** — second-cohort smoke test | Auto | Phases 5–6 complete | New sim runs DB + Storage only |
| **P3** | **CapCut ingest** — recover Anya editorial craft | Ivan + Anya | Anya project package | Motion grammar doc + timing overrides |

### Explicitly deferred / do not do yet

- **Full opener render** until Phase 4 world assets are locked.
- **Phase 7 smoke test** until Phases 5 and 6 are fully implemented.
- Re-generate approved heroes (Phase 1b) before full render.

### Two deliverables (every phase)

| Track | Question | Done when |
|---|---|---|
| **A — Pilot trailer** | Does soul15 get a good opening trailer? | Approved asset pack + render passes QA |
| **B — Automation** | Can the *next* sim repeat this without rediscovering steps? | Script/config/docs exist; second cohort smoke test passes |

Manual Grok work on soul15 is **R&D** — prompts, QA gates, and file layout get **codified** as we go, not documented only at the end.

---

## Product decisions (locked)

1. **Every participating Double is introduced** — all 15 get a **full-screen hero moment** and a **spoken trait line** in VO.
2. **Cast strategy: Option A — rapid spotlight montage** — not the Pistsov/Anya panel→zoom→panel rhythm repeated 15 times. One opening panel, fast full-screen hero cuts with trait lines, bookend on full-cast frame.
3. **Longer trailer is OK** — target **~90–105 s** total (vs Anya ~77 s). Validator uses manifest `target_runtime_sec` for soul15 spotlight cohorts.
4. **No Pistsov/Anya cast fallbacks** — wrong-cohort assets must fail or warn, not silently substitute.

### Anya animated kit (`video/opening-anya/Anya_animated`)

Four motion plates — **three sim-agnostic**, one cast-specific:

| File | Reuse |
|---|---|
| `Village.mp4` | Sim-agnostic |
| `Pressure.mp4` | Sim-agnostic |
| `Talk.mp4` | Sim-agnostic (chat / social beat) |
| `Family.mp4` | **Per-cohort** — regenerate for each new cast |

Phase 4 will produce soul15 equivalents; do not reuse Pistsov `Family.mp4` for soul15.

**Still open:** CapCut ingest (pending Anya project package). See **Status & open TODOs** at top of doc.

### Cast block shape (Option A)

| Phase | Content | Target duration |
|---|---|---|
| Open | Static 5×3 matrix identity grid — all 15 visible | **3.5 s** |
| Body | 15 hero spotlights (tile morph in/out + fullscreen hold) + trait VO | **~40 s** visual (~2.6 s × 15; anchors 3.0 s) |
| Close | Full-cast matrix photo — all 15 online | **2.5 s** |

**Cast block total (visual only, no VO):** ~**46 s**. Full opener target **~90–105 s** unchanged.

Pacing per person: **2.6 s** default spotlight beat (**3.0 s** for `anchor_spotlight` rows in manifest). Trait text appears at **scale-up** (not only fullscreen hold) — see motion grammar above.

Remotion strategy name: `fifteen_spotlight_montage`.

### Cast montage motion grammar (locked 2026-06-25)

**Approved preview:** `video/remotion/out/soul15_seed_20260224_spotlight_preview_v2.mp4`

| Beat | Component | Duration | Behaviour |
|---|---|---:|---|
| **3a — Intro** | `MatrixIdentityGrid` (5×3) | **3.5 s** | Static roster; HUD `ACTIVE DOUBLES` / `PERSONALITIES UPLOADED ...`. Last **0.25 s** dims non-selected tiles and highlights spotlight #1 for handoff. |
| **3b — Per person** | `HeroSpotlightBeat` | **2.6 s** default / **3.0 s** anchors | Six micro-phases per double (below). |
| **3c — Close** | `FullCastMatrixBeat` | **2.5 s** | Registered `group_photo_matrix.png`; `N DOUBLES ONLINE`. |

**Per-double micro-phases** (content and geometry decoupled — roster stays still):

| Step | Duration | Size | Content |
|---|---:|---|---|
| Hold | 0.25 s | Tile | Matrix identity card highlighted; **no pulse / glow** |
| Content in | 0.35 s | Tile | Card → hero photo crossfade **before** scale |
| Scale up | 0.45 s | Tile → fullscreen | Photo only; grid fades behind; **name + trait visible** |
| Hero hold | remainder | Fullscreen | Photo + bottom caption |
| Scale down | 0.45 s | Fullscreen → tile | Photo only; caption stays |
| Content out | 0.28 s | Tile | Photo → card for next handoff |

**Rejected (do not reintroduce):** moving carousel / filmstrip intro; combined zoom+crossfade (light→dark flash at large size); fullscreen card layout on collapse; animated box-shadow / grid-scale “glow beat” on phase changes.

**Code map:** `video/fifteen_spotlight_beat_map.py` (timing) · `video/remotion/src/components/matrixGridLayout.ts` (phases) · `video/remotion/src/beats/FifteenSpotlight.tsx` · `video/build_fifteen_spotlight_props.py` (preview props + versioned render name).

**Preview workflow:**

```bash
python -m video.build_fifteen_spotlight_props --cohort soul15_seed_20260224
cd video/remotion
npx remotion render OpenerTrailer out/soul15_seed_20260224_spotlight_preview_vN.mp4 \
  --props=props/soul15_seed_20260224__spotlight_preview.json
```

Builder prints the next `_vN` filename automatically (`--version N` to override). Keep prior renders for A/B comparison.

---

## Data posture: Supabase-first (not local disk)

**Principle:** Trailer pipeline **reads canonical state from Supabase** and **writes results back to Supabase**. Paths under `video/assets/` and `data/*/opener&*` are **dev/bootstrap crutches** — useful for the soul15 pilot, but not the production contract.

| Layer | Today (crutch) | Target (Supabase SOT) |
|---|---|---|
| **Cast + trailer manifest** | `cohort/.../manifest.json` on disk | `double.cohort_trailer_config` + `double.cohort_trailer_cast` |
| **Trait / narration copy** | Locked lines in manifest export | `cohort_trailer_cast.trait_line` (SOT) + mirror in `video_narration_cache` |
| **Persona inputs** | `souls/*.md` on disk; scratch from sim at render time | Persona UUID + sim-scoped scratch/profile from Supabase; soul summaries ingested or linked by persona id |
| **Generated visuals** | `video/assets/users/{character-sheets,cutouts,sprite-walkouts}` + `cohort/{hero,portraits,group_photo}` | Supabase Storage bucket(s) + `double.trailer_asset` rows: persona id, asset type, storage path, prompt hash, `qa_status` |
| **Brand / village B-roll** | `opening-anya/`, `video/fly-over/` (OK as shared kit) | Shared kit can stay repo-local or move to a `brand-assets` bucket; sim-specific assets must not |
| **Render outputs** | `data/<sim>/opener&NNN/output/*.mp4` | Storage upload + run metadata row (sim, run id, poster frame, validation report) |
| **Remotion staging** | `video/remotion/public/render/` copy per build | **Transport only** — download from Storage URLs for render; do not treat as SOT |

**Rules for new work:**

1. No new generators that **only** write under `video/assets/` without a Supabase register step.
2. `manifest.json` becomes an **export / dev snapshot** (`export_cohort_manifest --cohort …`) — not the authority editors update by hand long term.
3. Trait lines: `build_cohort_manifest` seeds or LLM-generates → write Supabase → showrunner reads DB. **No human approval step** in the auto-pipeline (`pinned` only for optional hand-edited overrides).
4. Asset QA gates query Supabase (row exists + `qa_status=approved` + Storage object present), not `os.path.exists` on laptop paths.
5. Wrong-cohort resolution: persona UUID + simulation id from Supabase; never filename heuristics.

**soul15 pilot exception:** Existing character sheets and walkouts on disk are **legacy inputs** until migrated to Storage; manifest paths document where files live today while we build the register + upload path.

---

## Supabase implementation plan (Phase 0a–0b)

Implementation plan aligned with **existing Supabase patterns** — not a greenfield design. Follow the same conventions as `video_narration_cache`, `day_highlights`, and `persona_day_snapshots`.

### Design principles (match existing workflows)

| Principle | Existing precedent | Trailer plan |
|---|---|---|
| **Schema** | Pipeline tables live in `double.*`, not exposed via PostgREST | Same — no new public RPCs in v1 |
| **Access** | RLS enabled, **no policies** → `service_role` only | Same for new tables |
| **Sim key** | Video pipeline uses **`sim_code` text** (`simulations.name`) | `video_narration_cache`, `day_highlights` — **not** `simulation_id` uuid on cast rows |
| **Persona key** | `persona_id uuid` → `double.personas(id)` | FK on cast + asset rows; resolve names via existing `get_agent_id_by_name` / roster RPCs |
| **Python stores** | Thin modules: `narration_cache.py`, `highlights_store.py` | Add `cohort_manifest_store.py`, `trailer_asset_store.py`, `trailer_storage.py` |
| **Client** | Lazy `create_client` + `SUPABASE_SERVICE_ROLE_KEY` | Reuse same pattern — do not use anon key for pipeline writes |
| **Upsert** | Functional unique index with `COALESCE` NULL sentinels | Same for `(sim_code, persona_id)` and `(sim_code, persona_id, asset_type)` |
| **Storage** | Buckets in `storage_manager.py` / `storage_config.py`; `step-bundles` uses `{sim_code}/…` keys | Extend bucket list; persona-stable vs sim-scoped paths (below) |
| **Context extraction** | `extract_opener_context` → Supabase RPC + scratch | Join **`cohort_trailer_cast`** for trait lines + spotlight order |
| **No manual trait gate** | N/A | Lines written as `approved` on seed/generate; `pinned` in narration cache = optional hand-edit only |

### What we reuse (do not duplicate)

| Need | Reuse |
|---|---|
| Trait / VO text cache | `double.video_narration_cache` — mirror trait lines as `scope=persona`, `artifact_key=persona_narration` (showrunner already reads this) |
| Sim roster + scratch | `get_simulation_metadata`, `get_step_positions`, `persona_scratch` via existing extractors |
| Soul personality text | `souls/*.md` at seed time (ingest to DB is post-MVP; `build_cohort_manifest` reads files like today) |
| Storage client | `StorageManager` + service-role upload helper (extend `scripts/migrate_assets_to_supabase.py` patterns) |
| Fork workflow | After `fork_simulation`, run `build_cohort_manifest --sim <new_code>` — do **not** auto-copy trailer rows in v1 |

### New schema (one migration: `20260625_cohort_trailer.sql`)

**1. `double.cohort_trailer_config`** — one row per opener cohort / sim run

| Column | Type | Notes |
|---|---|---|
| `sim_code` | text PK | Matches `video_narration_cache.sim_code` |
| `cohort_slug` | text | e.g. `soul15_seed_20260224` — stable asset namespace |
| `cast_strategy` | text | e.g. `fifteen_spotlight_montage` |
| `cast_size` | int | Denormalized count |
| `mode` | text | e.g. `survival` |
| `world` | text | e.g. `the_ville` |
| `target_runtime_sec` | jsonb | `{min, max}` |
| `manifest_version` | text | e.g. `1.0` |
| `created_at` / `updated_at` | timestamptz | |

**2. `double.cohort_trailer_cast`** — one row per `(sim_code, persona_id)` — **manifest SOT**

| Column | Type | Notes |
|---|---|---|
| `sim_code` | text FK → config | |
| `persona_id` | uuid FK → personas | |
| `display_name` | text | |
| `spotlight_order` | int | 1–15 montage sequence |
| `featured` | bool | soul15: all true |
| `anchor_spotlight` | bool | Optional rhythm anchors |
| **`trait_line`** | text | **Authoritative spoken line** — soul15 locked copy |
| `trait_line_status` | text | Default `approved` on write (not a pipeline gate) |
| `career`, `location` | text | From career assignment |
| `relationship_tags` | jsonb | string[] |
| `profile_doc` | text | Repo path to soul file until ingest exists |
| `created_at` / `updated_at` | timestamptz | |

Unique: `(sim_code, persona_id)` and `(sim_code, spotlight_order)`.

**3. `double.trailer_asset`** — registry for every generated or migrated binary

| Column | Type | Notes |
|---|---|---|
| `sim_code` | text | Sim-scoped assets; for persona-global sheets use `sim_code` = cohort slug **or** a sentinel `__persona__` — **prefer persona-global rows with `sim_code` NULL + persona_id set** |
| `persona_id` | uuid nullable | NULL = cohort-level (group photo, matrix) |
| `asset_type` | text | Enum-like: `character_sheet_front_neutral`, `full_body_standing`, `sprite_walkout`, `cutout`, `portrait_crop`, `hero_spotlight`, `group_photo`, `group_photo_matrix`, … |
| `storage_bucket` | text | e.g. `user-sprites`, `trailer-assets` |
| `storage_path` | text | Object key (see layout below) |
| `content_hash` | text nullable | sha256 of file bytes |
| `prompt_hash` | text nullable | For Grok outputs — same idea as narration cache |
| `qa_status` | text | `pending` \| `approved` \| `rejected` — **blocks render** when required asset missing/rejected |
| `source_generator` | text nullable | e.g. `generate_cutouts.py` |
| `metadata` | jsonb | Pose name, dimensions, derived-from asset id, etc. |
| `created_at` / `updated_at` | timestamptz | |

Unique index: `(COALESCE(sim_code,''), COALESCE(persona_id::text,''), asset_type)`.

**Persona-global vs sim-scoped assets**

| Scope | `sim_code` | `persona_id` | Example |
|---|---|---|---|
| Persona-global | NULL | uuid | character sheets, walkouts, cutouts (same Double across sims) |
| Sim/cohort | set | uuid or NULL | hero spotlight variant, group photo for this opener |

**4. `double.trailer_run`** (optional in 0a — can defer to Phase 9)

| Column | Notes |
|---|---|
| `sim_code`, `run_label` (`opener&009`), `storage_path` mp4, `poster_path`, `validator_json`, `duration_sec` | Audit trail for renders |

### Storage layout (align with existing buckets)

Extend `storage_config.create_supabase_buckets_if_needed()`:

| Bucket | Public | Purpose | Key pattern |
|---|---|---|---|
| **`user-sprites`** (existing) | false | Persona-stable art — already used for Double uploads | `{persona_id}/character-sheets/{pose}.png`, `{persona_id}/sprite-walkout.mp4`, `{persona_id}/cutout.png` |
| **`trailer-assets`** (new) | false | Sim/cohort-generated opener assets | `{sim_code}/group_photo.png`, `{sim_code}/group_photo_matrix.png`, `{sim_code}/hero/{persona_id}.png`, `{sim_code}/renders/{run_label}/trailer_9x16.mp4` |

Service role downloads to `remotion/public/render/` at props-build time — same as today’s local copy, but source URL comes from `trailer_asset` row.

**Do not** store canonical PNGs only under `video/assets/cohort/` after migration.

### Python modules (mirror `highlights_store.py`)

| Module | Responsibility |
|---|---|
| `video/cohort_manifest_store.py` | `upsert_config`, `upsert_cast_row`, `fetch_cast(sim_code)`, `fetch_cast_ordered(sim_code)` |
| `video/trailer_asset_store.py` | `register_asset(...)`, `get_asset(sim_code, persona_id, asset_type)`, `list_assets(sim_code)`, `set_qa_status` |
| `video/trailer_storage.py` | `upload_file(local_path, bucket, key) → storage_path`, `download_to_staging(storage_path) → local Path`, `object_exists` |
| `video/build_cohort_manifest.py` | CLI: resolve sim via RPC → read souls/careers → upsert config + cast rows → optional `--export-json` |
| `video/import_cohort_manifest.py` | One-time: load `manifest.json` → DB (soul15 seed) |
| `video/register_legacy_trailer_assets.py` | Scan `video/assets/users/…` → upload + `trailer_asset` rows for soul15 UUIDs |
| `video/validate_cohort_assets.py` | Required asset types for cast_strategy → DB + Storage head checks |

Shared helper: extract `_get_supabase_client()` into `video/supabase_client.py` later if duplication hurts — **not required for 0a**.

### Trait-line workflow (no manual approval)

```
build_cohort_manifest / import_cohort_manifest
  → cohort_trailer_cast.trait_line  (SOT)
  → video_narration_cache mirror: scope=persona, artifact_key=persona_narration,
     content=trait_line, prompt_hash=sha256("seeded:{trait_line}"), pinned=false

showrunner _generate_opener_script
  → if cohort_trailer_cast.trait_line exists: use as narration_line
  → else: existing get_or_generate LLM path + write cast row on first run

generate_trailer / TTS
  → unchanged — consumes narration_line from script.json
```

Soul15: `import_cohort_manifest` loads locked lines; no LLM call for traits.

### Integration touchpoints (existing code)

| File | Change (later chunks) |
|---|---|
| `video/extract_opener_context.py` | Raise `top_n` cap to 15; merge cast rows; pass `trait_line` + `spotlight_order` into context |
| `video/showrunner.py` | Prefer DB trait line over `_generate_persona_narration` when cast row present |
| `video/build_opener_remotion_props.py` | Resolve portraits/heroes via `trailer_asset_store` + staging download |
| `video/generate_trailer.py` | `--cohort` slug; preflight `validate_cohort_assets` |
| `video/assets/scripts-prompts/generate_*.py` | After write: `trailer_storage.upload` + `trailer_asset_store.register` |
| `supabase/db_reference.md` | Document new tables in same migration PR |

### Implementation chunks (approve before coding each)

| Chunk | Deliverable | Verify |
|---|---|---|
| **0a-1** | Migration SQL + `db_reference.md` update | **Done** — remote `20260625170330_cohort_trailer`; local file aligned; `db push` clean |
| **0a-2** | Add `trailer-assets` bucket to `storage_config.py` | **Done** — create via dashboard or `create_supabase_buckets_if_needed()` |
| **0b-1** | `cohort_manifest_store.py` + unit smoke | **Done** — `tests/test_cohort_trailer_store.py` |
| **0b-2** | `import_cohort_manifest.py` ← soul15 `manifest.json` | **Done** — 15 cast rows + config in DB |
| **0b-3** | Mirror trait lines → `video_narration_cache` | **Done** — 15 `persona_narration` rows (seeded hash) |
| **1a** | `trailer_storage.py` + `trailer_asset_store.py` | **Done** |
| **1b** | `register_legacy_trailer_assets.py` for soul15 | **Done** — 90 asset rows (6 per persona) |
| **1c** | `validate_cohort_assets.py` | **Done** — PASS for soul15 |
| **5** | Showrunner reads DB trait lines + 15-cast segment map | **Done** | `cohort_trailer_cast` preferred; 29 segments for soul15 |
| **5b** | `generate_trailer --top 15`, trailer voice, validator 90–105 s | **Done** | First end-to-end run still pending |
| **6** | Props builder Storage resolution + full render | **Partial** | Integrate-opener stages VO; render blocked on Phase 4 |
| **9** | `trailer_run` + upload render outputs | MP4 path in DB |

**Gate before Grok hero work:** 0b-2 complete (cast + traits in DB) **and** 1b complete (sheets/walkouts registered) — not necessarily full showrunner wiring.

### soul15 backfill sequence (concrete)

1. Apply migration `20260625_cohort_trailer.sql`.
2. `python -m video.import_cohort_manifest --sim soul15_seed_20260224 --from video/assets/cohort/soul15_seed_20260224/manifest.json`
3. `python -m video.register_legacy_trailer_assets --personas soul15 --types character_sheet,sprite_walkout`
4. `python -m video.validate_cohort_assets --sim soul15_seed_20260224 --strategy fifteen_spotlight_montage`
5. Optional: `python -m video.export_cohort_manifest --sim soul15_seed_20260224 -o manifest.json` — confirm JSON ≈ source.

### Out of scope for 0a–0b (explicit deferrals)

- PostgREST / FE API for manifest editing
- Soul file ingest table (keep `profile_doc` path + file read at seed)
- Auto-copy trailer rows on `fork_simulation`
- Replacing `opening-anya/` brand kit with Storage
- `trailer_run` table (unless Phase 9 starts early)

---

## Pilot checklist (historical)

> **Current priorities:** see **Status & open TODOs** at the top of this doc.

Each item produces **soul15 assets** and an **automation artifact** for the next cohort. **Supabase register + Storage upload** is part of “done” for any generated asset — not optional follow-up.

| # | Pilot work (soul15) | Status | Automation artifact (next cohort) |
|---|---|---|---|
| **0a** | Supabase schema — manifest, asset registry, Storage bucket | **Done** | Migration + `db_reference.md` |
| **0b** | Seed soul15 — 15 personas, locked trait lines, spotlight order | **Done** | `import_cohort_manifest.py` + `export_cohort_manifest.py` |
| **1** | Register character sheets + walkouts (15/15) | **Done** | `register_legacy_trailer_assets.py` |
| **2** | Per-person cutout, portrait, hero spotlight ×15 | **Done** | `generate_opener_hero_assets.py` + `--upload` |
| **3** | Group photo + matrix poster tier | **Done** | `cast_group_layout.py`, matrix HUD |
| **4** | Cast montage Remotion (`fifteen_spotlight_montage`) | **Done** — preview v2 approved | Beat map + props builder + versioned preview |
| **5** | Trait VO + opener script assembly | **Code done** — first pipeline run pending | Showrunner + 29-segment map + `trailer` voice |
| **6** | World / Survival / relationship assets | **Open** — Ivan, Phase 4 | Sim asset rows + `export_relationship_graph` |
| **7** | `prompt_log.md` — accepted Grok steps | **Done** | `cohort/.../prompt_log.md`; DB registry later |
| **8** | QA every asset | **Done** (cast pack) | `validate_cohort_assets.py` |
| **9** | Full Remotion render; upload MP4 + poster | **Blocked** on Phase 4 | `generate_trailer --top 15`; `trailer_run` TBD |
| **10** | CapCut ingest (when available) | **Open** | Motion grammar doc + Remotion timing overrides |

**Do first:** **0a → 0b** — schema and Supabase manifest (with locked soul15 trait lines) are the contract before heavy Grok spend.

**Pilot rule:** when a manual step succeeds twice with the same recipe, **script it + register in Supabase immediately** — do not batch automation or disk-only outputs to the end.

---

## Working approach (three layers)

| Layer | Timing | Role |
|---|---|---|
| **B — Asset automation (now)** | Pilot on soul15 | Walk each asset step manually once; codify prompts, scripts, manifest, QA gates so cohort **N+1** is `generate_cohort_assets → generate_trailer` |
| **A — CapCut blueprint** | When Anya sends files | Recover hidden editorial craft (masks, easing, SFX timing) → Remotion motion grammar |
| **C — Full opener pipeline** | After B + partial A | Anya motion grammar + automated asset pack + `fifteen_spotlight_montage` in one command |

**Anti-pattern:** finish soul15 in Grok, then start thinking about automation.  
**Target pattern:** each approved soul15 asset → updated prompt template + generator flag + manifest field + QA check.

### Automation definition of done (next cohort)

A new simulation with a new cast (up to 15) can run without manual Remotion edits or wrong-cohort fallbacks:

1. `build_cohort_manifest` from sim code → **Supabase cohort manifest rows** (+ optional JSON export)
2. `generate_cohort_assets --cohort <slug>` → Storage uploads + asset registry rows + QA report in DB
3. `generate_trailer <sim> opener --cohort <slug> --top 15` → MP4 + poster **uploaded**; run metadata in DB
4. Validator passes (Supabase asset gates + ~90–105 s band for 15-person cast)

Soul15 pilot **proves** the path; a second cohort **validates** automation without relying on Ivan's laptop folder layout.

---

## Phased pilot walkthrough

Each phase: **manual proof on soul15** → **automation artifact** → **gate before next phase**.

| Phase | Manual proof (soul15) | Automate (codify now) | Gate |
|---|---|---|---|
| **0a** | Supabase migration: manifest + asset registry + bucket policy | Schema in `supabase/migrations/` + `db_reference.md` | Service role can read/write trailer tables |
| **0b** | Seed soul15 rows — **locked trait lines** (approved 2026-06-25), spotlight order | `build_cohort_manifest.py` writes **Supabase**; exports JSON for dev | 15 rows; all `trait_line_status: approved` |
| **1** | **Done 2026-06-25** — Max Shoemaker hero + portrait; visual QA pass; 720×1280 accepted | `generate_opener_hero_assets.py` + `register_cohort_trailer_assets.py` | 1 persona asset rows `qa_status: approved` |
| **1b** | **Done 2026-06-25** — 14 generated + Max; **Ivan approved** all heroes | `generate_opener_hero_assets.py --skip-existing --upload` | All 15 approved in DB |
| **2** | **Done 2026-06-25** — group photo (3 rows) + matrix tier; Supabase registered | `cast_group_layout.py`, matrix HUD, Storage rows | Poster tiers match cast in Storage |
| **3** | **Done 2026-06-25** — `fifteen_spotlight_montage` visual QA (**preview v2 approved**) | Beat map + Remotion beats + `build_fifteen_spotlight_props` | Motion grammar locked; versioned previews |
| **4** | World / Survival / graph assets — **next (Ivan)** | Sim asset rows + relationship graph from Supabase | No Pistsov/Anya reuse |
| **5** | VO pipeline — **code done 2026-06-25**; first run pending | Trait lines from manifest; 29 segments; `trailer` voice | `narration_timing.json` with 29 segments after `generate_trailer` run |
| **6** | Full Remotion render + upload — **blocked on Phase 4** | `integrate-opener` props + validator 90–105 s | PASS report + `trailer_run` row (upload TBD) |
| **7** | **Second-cohort smoke test** — after 5 + 6 | Full path without local `cohort/` dependency | One command; DB + Storage only |

**Next up:** Phase 4 (world assets) → Phase 5 run → Phase 6 full render.

---

## Simulation-specific asset list (pilot checklist)

Manual Grok checklist for soul15 — **each row should become a generator step or prompt template** for the next cohort.

### 1. Cast Data Manifest

**Authority:** Supabase cohort manifest table (sim-scoped). The file `cohort/soul15_seed_20260224/manifest.json` is a **bootstrap export** for the pilot — same fields, but editors and automation should target the DB.

| Column | Required |
|---|---|
| `persona_id` (UUID) | Yes |
| `display_name` | Yes |
| `character_sheet` / Storage refs | Existing poses — register in `trailer_asset` (not copy to `cohort/source_photos/`) |
| `sprite_walkout` | Existing walkout — Storage ref `sprite-walkouts/{uuid}.mp4` |
| `profile_doc` / soul source | Soul summary linked by persona id (repo `souls/*.md` until ingested) |
| `trait_line` | Short spoken line; stored in manifest row + `video_narration_cache` on seed/generate |
| `trait_line_status` | Set to `approved` automatically when written — **not a manual gate** (`pinned` in cache = optional hand-edit override only) |
| `spotlight_order` | 1–15 introduction sequence |
| `relationship_tags` | For graph + social beats |
| `hero_spotlight`, `portrait_crop`, `cutout`, etc. | **Storage path + asset row id** (not laptop-relative path as SOT) |
| `qa_status` | pending / approved / rejected |
| `automation_step` | Links row to prompt registry |

Export for dev: `python -m video.export_cohort_manifest --sim soul15_seed_20260224`. Prompt templates: `cohort/soul15_seed_20260224/prompt_log.md` (pilot backfill).

Personality summaries: `souls/*.md` (ingest target). Roster: `souls/soul15_roster_20260224.json`. Careers: `souls/soul15_seed_20260224_career_assignment.json`.

**All 15 are featured.** No "background only" cast members for this trailer.

### Trait lines — how they are produced (no manual approval in auto-pipeline)

| Stage | What happens |
|---|---|
| **soul15 (locked 2026-06-25)** | 15 lines hand-drafted from soul profiles + Anya calibration; **Ivan approved** — all `trait_line_status: approved` in manifest export. |
| **Auto-pipeline (all cohorts)** | `build_cohort_manifest`: read persona UUID + soul + scratch from Supabase → seed locked lines **or** Tier B LLM (`OPENER_PERSONA_NARRATION_SYSTEM`) → write `trait_line` + `trait_line_status: approved` to DB/cache **in one step**. No human review gate. |
| **Optional override** | Hand-edit a line in DB and set `pinned=true` on `video_narration_cache` to freeze copy across re-renders — editorial escape hatch, not part of default flow. |
| **Render** | Showrunner uses **DB/manifest trait line** as `narration_line` per `cast_intro` (replace today's per-render LLM for cohort trailers). |

**Personality audit (soul15 locked lines vs `souls/*.md`)** — completed 2026-06-25; all align with evidence-based identity unless noted:

| Name | Trait line | Soul fit |
|---|---|---|
| Max Shoemaker | Max turns ideas into momentum. | Builder + connector; turns ideas into products — **strong** |
| Alex Butcher | Alex prototypes before he explains. | Prototypes fast, test-and-improve builder — **strong** |
| Ivan Pitts | Ivan debates for clarity, not performance. | Sensemaking, context over slogans — **strong** |
| Olivia King | Olivia ships — then asks what's broken. | Builder-operator who ships and wants sharp feedback — **strong** |
| Diana Ogden | Diana reads the room behind the story. | Institutions, incentives, narratives — **strong** |
| Andrew Abrams | Andrew follows incentives, not headlines. | Contrarian; incentives and media dynamics — **strong** |
| Irene Dove | Irene warms up the room — then stress-tests the logic. | Warm but direct; pros/cons and media skepticism — **good** (macro side compressed) |
| Dean Sanford | Dean calls power when he sees it. | Power dynamics and institutions — **strong** |
| Alexis Reed | Alexis wants evidence before opinion. | Evidence-anchored realist — **strong** |
| Owen Logan | Owen treats the headline like a script. | Discourse as theatre; incentives underneath — **strong** |
| Vince Vale | Vince measures claims against reality. | Criteria, mechanisms, incentives — **strong** |
| Mike Hooks | Mike argues in definitions, not slogans. | Nearly verbatim soul identity line — **strong** |
| Nick Miller | Nick wants solutions that actually work. | Pragmatic operator; solutions not slogans — **strong** |
| Alex Shepard | Alex sees the gray zones others skip. | Systems thinker; nuance vs binary framing — **good** |
| Vincent Slater | Vincent asks who benefits — every time. | Default lens in soul (“Who benefits?”) — **strong** |

No line reads as wrong-cast or generic filler. soul15 lines are **locked** for the pilot; future cohorts rely on LLM + soul/scratch inputs with the same prompt rules.

#### Cast reference (manifest seed)

| spotlight_order (draft) | Display name | persona_id |
|---:|---|---|
| 1 | Alex Butcher | `0e8d6398-bfe5-40c7-9b6d-1eae2b0abc49` |
| 2 | Alex Shepard | `f428ae04-975d-4163-b7e6-fbaea8befd24` |
| 3 | Alexis Reed | `0c7ff9b1-44bc-4afe-a189-52d88d2abd09` |
| 4 | Andrew Abrams | `be6de09c-91e4-42c7-a936-2193977dd17c` |
| 5 | Dean Sanford | `e8c1b20c-dff4-4ab3-836b-cf1d86a8b958` |
| 6 | Diana Ogden | `021d4622-9b7e-4b73-9f94-322c4e5121da` |
| 7 | Irene Dove | `eac7be2a-b689-40be-a3a1-b4c4426ae9dc` |
| 8 | Ivan Pitts | `42c86639-8f93-4f97-a541-8cd5baf2fea8` |
| 9 | Max Shoemaker | `bcf5fb65-6e7e-464a-83bb-51668f967f77` |
| 10 | Mike Hooks | `77c2f157-64bb-4fa0-b451-3a644661d1a4` |
| 11 | Nick Miller | `e473df98-8abb-44e9-a73f-f89771ec91d2` |
| 12 | Olivia King | `87daf41e-0237-4a55-a1ad-14007cefbefe` |
| 13 | Owen Logan | `cc277da1-521b-4ba8-8f78-a7a1f09c3a32` |
| 14 | Vince Vale | `69835d95-c543-48b1-85c0-f7d5351d845d` |
| 15 | Vincent Slater | `29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca` |

Reorder `spotlight_order` for trailer rhythm after trait lines are drafted.

### 2. Poster And Group Assets — **Phase 2 done 2026-06-25**

Required for the opening flash and poster/export frame:

- **Clean group photo:** all cast members together, casual clothes, black background, premium editorial look, faces clear, vertical 9:16 safe crop.
- **Matrix group photo:** derived from the exact clean group photo, darker/dimmer, tight vertical crop, blue matrix/scan rectangles around head and shoulders, upper-left HUD `PERSONALITIES UPLOADED ...`.
- **Poster composite source:** layout depends on cast size (see below). Anya-style dual stack for ≤10; sequential full-frame cut for 11–15.
- **Optional wide crop:** same cast group in a wider composition for internal cards or web previews.

**Group photo row tiers** (`video/cast_group_layout.py` — cast size 3–15):

| Cast size | Rows | Split |
|----------:|------|-------|
| 3–5 | 1 | all together (center when &lt;5) |
| 6 | 2 | **3 + 3** (balanced) |
| 7 | 2 | **4 + 3** (balanced) |
| 8 | 2 | **4 + 4** (balanced) |
| 9–10 | 2 | 5 + x |
| 11 | 3 | 4 + 4 + 3 |
| 12 | 3 | 4 + 4 + 4 |
| 13 | 3 | 5 + 4 + 4 |
| 14 | 3 | 5 + 5 + 4 |
| 15 | 3 | 5 + 5 + 5 |

**Poster on-screen layout** (Remotion `ConceptPoster`):

| Cast size | Mode | Behaviour |
|----------:|------|-----------|
| 3–5 | `dual` | Matrix top + clean bottom (Anya) |
| 6–10 | `dual_weighted` | Same, larger clean tier (~54% height) |
| 11–15 | `sequential` | Full-frame clean, then cut to full-frame matrix |

### 3. Individual Cast Assets (all 15)

Every person needs assets for **full-screen spotlight + spoken trait line**:

- **Character sheet (existing)** — `character-sheets/{uuid}/` already has `front_neutral`, `front_smile`, `three_quarter_neutral`, `profile_neutral`, `full_body_standing`. Use these as inputs; do not copy photos into `cohort/source_photos/`.
- **Sprite walkout (existing)** — `sprite-walkouts/{uuid}.mp4` (15/15 for soul15).
- **Full-body standing** — from character sheet; cutout pipeline input.
- **Transparent full-body cutout** — no background, full body head-to-toe, hero-safe (no bad hands/feet).
- **Square/portrait crop** — identity cards and Active Doubles panel.
- **Hero spotlight asset** — expressive full-body pose, strong silhouette, **full-screen safe** (~1.5–2.2 s per beat). **Required for all 15**, not a subset.
- **Trait line** — one short spoken line per person (manifest + VO script).
- **Mobile-safe crop notes** — face above caption band; trait text crosses torso/waist like Anya cast beats.

Optional: 2–3 **anchor** spotlights (slightly longer hold or stronger pose) for montage rhythm — still part of the all-15 sequence.

### 4. Cast Montage Layout Assets (Option A) — **Done 2026-06-25 (visual QA: preview v2)**

Supports rapid spotlight montage; **not** 15 separate panel→zoom interstitials.

| Asset | Priority | Role | Status |
|---|---|---|---|
| **Active Doubles grid (15)** | Critical | Opening beat — static 5×3 `MatrixIdentityCard` tiles | **Done** — `MatrixIdentityGrid` |
| **Hero spotlight morph** | Critical | Tile content-swap → scale up → hold → scale down → content-out | **Done** — `HeroSpotlightBeat` |
| **Full-cast matrix frame** | Critical | Closing beat — "all 15 online" | **Done** — `FullCastMatrixBeat` |
| **Cluster group visuals** | Optional | Relationship / pressure sections only | Not started |
| **Per-person selection panel** | Skip | Pistsov pattern; not used in Option A | N/A |
| **Moving carousel / filmstrip** | Skip | Rejected — unreadable at 15 cards | N/A |

### 5. Relationship And Social Assets

Required for the hook, UI morph, pressure, and proof sections:

- **Relationship graph data source.** Names, edges, labels, and relationship types for 2-15 nodes.
- **Relationship graph visual style reference.** Cyan nodes/lines, readable labels, no baked-in wrong names.
- **Conversation/rehearsal visual.** A social-interaction image or short loop showing two or more people in a hard conversation; can later replace/generate beyond Anya `Talk.mp4`.
- **Live activity feed panel.** Simulation-specific example actions using this cast, not Pistsov names.
- **Decision/choice panel.** One or two high-stakes choices using the new simulation premise.

### 6. Simulation / World Assets

Soul15 context: **the Ville**, **Survival Mode**, 15-player competitive social season.

- **Establishing environment shot or loop** — the Ville, vertical-safe, cinematic.
- **Live map/world representation** — top-down or dashboard view.
- **Night/pressure version** — darker world for pressure section.
- **Survival Mode visual** — 15-player stakes (not Pistsov family framing).
- **Replay/follow visual** — aerial or map for live/replay montage.

May partially reuse generic the Ville B-roll; cast-facing assets must be 100% soul15.

### 7. Audio / SFX Inputs

- Tagged SFX library staged locally (`video/audio/sfx/`).
- Mid-trailer URL sting + final URL/logo resolve.
- **VO: 15 trait segments** + standard opener hook/concept/pressure/end blocks — expect longer narration than Pistsov opener; lock after trait lines are written.

---

## Prompt log → automation registry

Every Grok attempt that succeeds (or teaches something) feeds the **automation registry**, not just soul15 files.

Use this for every Grok Imagine production attempt that is good enough to keep or informative enough to learn from.

```text
Asset ID:
Trailer role:
Cast members included:
Source inputs:
Prompt:
Negative prompt / avoid:
Model/settings:
Accepted output path:
Rejected output paths:
Why accepted:
Why rejected:
Needed edits:
Automation notes:
```

The goal is a **repeatable recipe**: soul15 manual run → `prompts/<step>.md` or generator default → next cohort runs without rediscovery.

### soul15 — Max Shoemaker (Phase 1 locked 2026-06-25)

```text
Asset ID: soul15_seed_20260224 / Max Shoemaker / hero_spotlight
Trailer role: Full-screen montage beat (~1.5–2.2s) + trait VO overlay
Cast members included: Max Shoemaker (bcf5fb65-6e7e-464a-83bb-51668f967f77)
Source inputs: character-sheets/{uuid}/full_body_standing.png
Prompt: See prompts_opener_hero_assets.md (hero_spotlight block)
Negative prompt / avoid: text, logos, other people, props clutter, mangled hands/feet
Model/settings: grok-imagine-image-quality (XAI_IMAGE_MODEL)
Accepted output path: video/assets/cohort/soul15_seed_20260224/hero/bcf5fb65-6e7e-464a-83bb-51668f967f77.png (720×1280)
Rejected output paths: —
Why accepted: Visual QA pass; trait-line overlay readable at mobile width; 720p accepted for pilot
Why rejected: —
Needed edits: —
Automation notes: Codified in generate_opener_hero_assets.py; Phase 1b uses same prompt ×14
```

```text
Asset ID: soul15_seed_20260224 / Max Shoemaker / portrait_crop
Trailer role: Active Doubles panel / identity card (~72×96)
Cast members included: Max Shoemaker
Source inputs: hero_spotlight output (same persona)
Prompt: square identity card portrait, same illustrated colored-pencil style, neutral expression, plain grey background, face large and readable at small size, no text.
Negative prompt / avoid: text, logos
Model/settings: grok-imagine-image-quality
Accepted output path: video/assets/cohort/soul15_seed_20260224/portraits/bcf5fb65-6e7e-464a-83bb-51668f967f77.png (1024×1024)
Rejected output paths: —
Why accepted: Readable at small size; matches character-sheet illustrated style
Why rejected: —
Needed edits: —
Automation notes: Portrait-from-hero pipeline in generate_opener_hero_assets.py; fallback = front_neutral if identity drifts
```

---

## Manual Asset QA Checklist

Before an asset enters Remotion:

- Correct soul15 cast, not Pistsov/Anya.
- **Hero spotlight assets** pass full-screen QA — face, hands, limbs, proportions.
- Trait line readable on-screen at mobile size when overlaid on hero asset.
- All 15 hero assets share consistent visual style/lighting.
- Transparent cutouts: clean edges, no accidental background.
- Group + matrix poster tiers: same cast/composition.
- Active Doubles panel + matrix: all 15 names/faces recognizable.
- No wrong-cast silent fallback.

---

## CapCut Request For Anya

Ask for the full project package, not only the exported video:

- CapCut project/draft folder.
- All linked media and generated source assets.
- Fonts.
- SFX and music files.
- Export settings.
- Any prompts or production notes used to generate assets.
- Optional screen-recorded walkthrough of the timeline.

What we need to extract later:

- layer stack per section;
- crops and masks;
- blend modes and opacity ramps;
- keyframe timing and easing;
- text animation settings;
- SFX placement;
- which effects are direct CapCut effects vs reusable assets;
- export resolution, frame rate, and audio settings.

---

# `opener&009` Review Notes

**Video:** `generative_agents/data/base_family_sim/opener&009/output/trailer_9x16.mp4`  
**Anya ref:** `video/opening-anya/DOUBLAND1.mov`; grabs in `teadown/reference_grabs/`
**Props / assets:** `video/remotion/props/base_family_sim__opener_009.json`; staged files in `video/remotion/public/render/`

**How:** Pause at **Scrub**, compare to **Grab**, jot notes. Severity: OK / Tweak / Wrong / Blocker.

**Heads-up:** No matrix poster tier; group photo = Anya `Family.png`; most SFX missing; graph labels may be wrong.

---

## Beat Review Worksheet

### 0 - Poster Flash

**Time:** 0:00-0:05
**Scrub:** 0:00
**Grab:** `00-00_000`
**Assets:** `family.png` = Anya Family; `double_wordmark.png`

Comparison image: `D:\Coding\generative_agents\data\base_family_sim\opener&009\009-teardown\0_poster.png`

Changes needed in auto version:

- Lower image: generate group photo of the cast in casual clothes on a black background.
- Upper image: use the same lower image with matrix filter applied; about 80% size; dimmer color; blue matrix rectangles around heads; upper-left text `AI SCAN MODE | Personality Identified`.
- `DOUBLE` text should sit without background over the lower portion of the upper image.
- Remove `AI VERSION OF YOU` from the upper image.
- `AI VERSION OF YOU` should sit in the middle band in bold font.

### 1 - Hook

**Time:** 0:05-10:8
**Scrub:** 0:13, 4:2, 8:6
**Grabs:** `00-03_200`, `01-03_700`
**Assets:** `talk.mp4`, `asset_orb.png`, text overlay

### 2 - Concept / Poster

**Time:** 10:8-19:5
**Scrub:** 11:3, 12:6, 16:8
**Grabs:** `00-11_500`, `00-16_800`
**Assets:** `family.png`, `family_anim.mp4`, cutouts x4

### 3 - World - Create

**Time:** 19:5-24:0
**Scrub:** 20:8, 23:5
**Grab:** `00-20_800`
**Assets:** `village.mp4`

### 4 - World - Live Map

**Time:** 24:0-27:2
**Scrub:** 25:4, 27:2
**Grab:** `00-25_900`
**Assets:** `village.mp4`, `gold_ornament.png`, cutouts x4

### 5 - UI Morph

**Time:** 27:2-31:8
**Scrub:** 28:6, 30:0
**Grab:** `00-29_300`
**Assets:** relationship graph dynamic, cutouts

### 6 - Survival / Season

**Time:** 31:8-41:4
**Scrub:** 33:0, 35:0, 41:4
**Grabs:** `00-33_700`, `00-40_800`
**Assets:** `village.mp4`, Survival UI scaffold

### 7 - Cast Gosha

**Time:** 41:4-43:2
**Scrub:** 41:4, 42:1
**Grab:** `00-42_300`
**Assets:** `portrait_0_gosha.png`, selection panel

### 8 - Cast Ivan

**Time:** 43:2-45:7
**Scrub:** 43:9, 45:0
**Grab:** `00-44_800`
**Assets:** `portrait_1_ivan.png`

### 9 - Cast Katya

**Time:** 45:7-48:3
**Scrub:** 46:3, 47:5
**Grab:** `00-47_500`
**Assets:** `portrait_2_katya.png`

### 10 - Cast Luba

**Time:** 48:3-52:5
**Scrub:** 49:1, 50:2
**Grab:** `00-51_300`
**Assets:** `portrait_3_luba.png`

### 11 - Pressure Gauges

**Time:** 52:5-57:0
**Scrub:** 53:3, 55:9
**Grab:** `00-55_300`
**Assets:** `pressure.mp4`, Luba cutout for radial match

### 12 - Pressure + Mid URL

**Time:** 57:0-1:00:9
**Scrub:** 59:4
**Grab:** `01-00_200`
**Assets:** `pressure.mp4`, `MidUrlPlate`

### 13 - Live / Replay

**Time:** 1:00:9-1:06:4
**Scrub:** 1:02, 1:04, 1:06
**Grab:** `01-02_200`
**Assets:** `aerial.mp4`

### 14 - Turn - Avatars

**Time:** 1:06:4-1:08:2
**Scrub:** 1:07
**Grab:** `01-07_300`
**Assets:** `village.mp4`

### 15 - Turn - Learn / Change

**Time:** 1:08:2-1:11:7
**Scrub:** 1:09, 1:11
**Grab:** `01-10_900`
**Assets:** cutouts x4, `TurnDashboard`

### 16 - End Card

**Time:** 1:11:7-1:16:6
**Scrub:** 1:13:8, 1:15:3, 1:16:0
**Grabs:** `01-14_500`, `01-16_200`
**Assets:** `end_card.png`, URL takeover

---

## Overall Review Rows

| Area | vs Anya | vs 006 |
|---|---|---|
| Pacing / length (~80 s) | | |
| Hook feel | | |
| Hero videos: Talk, Village, Pressure | | |
| Text / SFX / mix | | |
| Poster @ 11.3 s | | |

---

## Asset Roots

**Supabase (target SOT):** cohort manifest rows, `trailer_asset` registry, `video_narration_cache`, Storage bucket(s) for per-persona and cohort renders.

**Repo / disk (bootstrap & shared kit only):**

- **Soul15 export (dev):** `D:\Coding\generative_agents\video\assets\cohort\soul15_seed_20260224\manifest.json`
- **Prompt registry (pilot backfill):** `.../cohort/soul15_seed_20260224/prompt_log.md`
- Anya kit (reference only): `video/opening-anya/`
- **Character sheets (legacy input, migrate to Storage):** `video/assets/users/character-sheets/{uuid}/`
- **Sprite walkouts (legacy input):** `video/assets/users/sprite-walkouts/{uuid}.mp4`
- Cutouts (generate → register): `video/assets/users/cutouts/` until migrated
- Soul profiles (ingest source): `souls/{uuid}.md`
- Pistsov cohort (do not use for soul15): `video/assets/cohort/pistsov_family/`

## Engineering backlog (tie to pilot phases)

Map to phased walkthrough — implement as each pilot phase completes, not after all manual work.

| Item | Pilot phase | Status | Notes |
|---|---|---|---|
| Migration: `20260625_cohort_trailer.sql` | 0a | **Done** | `cohort_trailer_config`, `cohort_trailer_cast`, `trailer_asset` |
| `trailer-assets` bucket in `storage_config.py` | 0a | **Done** | Sim-scoped Grok outputs + renders |
| `cohort_manifest_store.py` + `import_cohort_manifest.py` | 0b | **Done** | Seed soul15 from locked JSON |
| `export_cohort_manifest.py` | 0b | **Done** | Supabase → dev JSON export |
| `trailer_storage.py` + `trailer_asset_store.py` | 1a | **Done** | Register on every upload |
| `register_legacy_trailer_assets.py` | 1b | **Done** | soul15 sheets + walkouts → Storage + DB |
| `generate_opener_hero_assets.py` | 1–1b | **Done** | Hero + portrait Grok pipeline; `--upload` registers |
| `register_cohort_trailer_assets.py` | 1b | **Done** | Upload/register cohort hero + portrait paths |
| `validate_cohort_assets.py` | 1 | **Done** | Queries DB + Storage, not local paths |
| `generate_group_photo.py` + matrix for 15 | 2 | **Done** | soul15 group + matrix registered |
| `fifteen_spotlight_beat_map.py` + Remotion cast beats | 3 | **Done** | Motion grammar locked; preview v2 |
| `build_fifteen_spotlight_props.py` | 3 | **Done** | Versioned `_vN` preview; `--integrate-opener` stages VO |
| Opener pipeline glue (15 cast, trait-only, trailer voice) | 5 | **Done** | `showrunner`, `opener_beat_map`, `extract_day_log`, `validate_trailer` |
| `build_opener_remotion_props.py` dynamic segments | 5–6 | **Done** | 29-segment gate; spotlight branch when strategy set |
| `export_relationship_graph` from Supabase | 4 | **Open** | 15-node layout |
| `fifteen_spotlight_montage` full opener render | 6 | **Blocked** | Waiting on Phase 4 world assets |
| `trailer_run` + render upload to Storage | 6 | **Open** | Run metadata in DB |
| `generate_cohort_assets` orchestrator | 4–6 | **Open** | One-command asset gen for cohort N+1 |
| Second-cohort smoke test (DB-only path) | 7 | **Open** | Automation definition of done |