## Anonymized Sprite Atlases - Implementation Plan (2026-02-27)

### Goal
Upload anonymized character atlases (e.g., `f1`, `m10`) to Supabase and make them assignable to personas/doubles, with support for:
- many personas sharing the same atlas
- changing a persona's atlas later
- uploading new atlases later (user-managed)

### Current State (from code + docs)
- Supabase already has `double.persona_sprite_assets` with `profile_image_path`, `atlas_image_path`, `atlas_json_path`, `source_bucket`, `is_active` and a one-active-row-per-persona constraint.
- Existing import flow (`scripts/import_soul_profiles.py`) can write sprite rows from a persona->asset manifest, but this is ingest-oriented, not a reusable "appearance management" flow.
- Storage buckets already exist:
  - `shared-assets` (public; good for shared/default atlases)
  - `user-sprites` (private; good for user uploads)
- Frontend is still hardcoded to local static files/persona names in `double-front/scenes/MainScene.ts` and does not read `persona_sprite_assets` yet.
- API SOT (`docs/sot/sot_api.md`) and FE-BE SOT (`docs/sot/sot_be-fe.md`) do not define a sprite-manifest contract yet.

### Recommendation
Implement in 2 phases: **fast unblock now** + **durable architecture**.

---

### Phase 1 - Fast Unblock (1-2 days)
Objective: make anonymized atlases usable immediately with minimal schema change.

1) **Upload generalized assets to Supabase Storage**
- Source: `environment/frontend_server/static_dirs/assets/characters/generalized`
- Target bucket/path: `shared-assets/characters/generalized/`
- Keep one shared `atlas.json`; per atlas PNG stays separate (`f1.png`, `m10.png`, etc.).

2) **Backfill persona sprite rows**
- For each persona, write/update active row in `double.persona_sprite_assets`:
  - `profile_image_path` (optional generic portrait path)
  - `atlas_image_path = characters/generalized/<code>.png`
  - `atlas_json_path = characters/generalized/atlas.json`
  - `source_bucket = shared-assets`
  - `metadata` includes `{ atlas_code: "f1", anonymized: true, placeholder: false }`
- Many personas can share the same atlas simply by pointing to same paths.

3) **Add one verification script**
- `scripts/verify_sprite_assignments.py`:
  - checks every persona in sim has active sprite row
  - checks atlas paths exist in storage
  - checks no persona still has `metadata.placeholder=true` when cutover is expected

Deliverable: current and new sims can be assigned anonymized atlases in Supabase SOT.

---

### Phase 2 - Durable Product Path (3-6 days)
Objective: support self-serve switching/upload and remove hardcoded frontend dependencies.

1) **Add reusable sprite library table**
- New table: `double.sprite_atlas_library` (or similar), keyed by `atlas_code`
- Fields: `atlas_code`, `display_name`, `atlas_image_path`, `atlas_json_path`, `profile_image_path`, `source_bucket`, `visibility` (`shared|user`), `owner_user_id` nullable, `is_active`, `metadata`
- Keep `persona_sprite_assets` as assignment history per persona (active + old rows).

2) **Add API endpoints**
- `GET /api/sprites/library` (shared + user-visible atlases)
- `POST /api/users/{user_id}/sprites/upload-url` (signed upload for `user-sprites`)
- `POST /api/users/{user_id}/sprites/{persona_id}/appearance` (assign atlas to persona; inserts new active row, deactivates old)
- Optional: `GET /api/simulations/{sim_code}/sprite-manifest` (persona -> resolved URLs/keys)

3) **Frontend dynamic sprite loading**
- Replace hardcoded atlas preload in `MainScene.ts` with manifest-driven preload.
- Load unique atlases by key, then map each persona to its assigned atlas key.
- Keep fallback texture as safety only.
- Also switch profile avatars (`PersonaCard.tsx`, `app/page.tsx`) to manifest/profile path from SOT instead of fixed local path convention.

4) **SOT updates (same PR as behavior change)**
- Update `docs/sot/sot_api.md` with new sprite endpoints and response shapes.
- Keep movement contract unchanged in `docs/sot/sot_be-fe.md`; add only optional sprite metadata notes if needed.

---

### Data + Security Notes
- Shared anonymized atlases: use `shared-assets` public bucket.
- User uploads: use `user-sprites` private bucket + signed URLs + ownership checks.
- On assignment changes, preserve old rows as inactive for audit/history (already aligned with current model).

### Acceptance Criteria
- A sim can assign any persona to atlas code (`f1`, `m10`, etc.) from Supabase only.
- Multiple personas can point to same atlas without duplication issues.
- Persona atlas can be changed without recreating persona/sim.
- User can upload new atlas and assign it (after moderation/validation gate, if added).
