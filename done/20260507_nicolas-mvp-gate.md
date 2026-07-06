# MVP Engineering Brief — Nicolas

**Date:** 2026-04-29 (revised from 2026-04-28)
**Sprint window:** ~10 days.

> **Today's call (2026-04-29) set Nicolas's plate to four video-pipeline items:**
> 0. Video posting — upload to YouTube **[Unlisted]** + description with timecodes & links to the simulation.
> 1. Shareable link to exact point in simulation + focus on scene — *already produced by the video gen pipeline; needs to be codified in the URL.*
> 2. Smooth transitions between snippets in video.
> 3. Description for the video with timecodes to scenes.
>
> All four are spec'd as P0 in §4 below. The 2026-04-28 P0 set (receipt card UI, motive prediction, evening drop, native social share) is **cut to post-MVP** — see §3 ownership boundary and §8 cuts.

---

## 1. Product context (the parts you need)

**What we're shipping.** Survival-mode-only MVP, one fully activated 8-15-person adult-friend cohort, fundraising-grade traction. **Not a public launch** — one undeniable live cohort. The investor sentence we want them to feel: *"Oh — this would not work as a solo app. The social graph is the product."*

**Atomic unit.** An 8-15-person adult friend group, *not* an individual user. **Audience: adult friend teams only** (teen audience + consent gates are explicitly post-MVP).

**Sim format.** Survival mode only. Standard / free-flow simulation ships post-MVP.

**Major revision 2026-04-29:** the in-app daily loop is **cut**. No receipt cards, no motive prediction, no evening drop, no native social share. **YouTube is the distribution surface; the trailer is the product surface.** Each trailer goes up unlisted on `youtube.com/@doubland-ai` with a description containing time-coded deep-links into the live sim viewer on `doubland.ai`. Anyone curious taps a timecode → lands in full-screen Play mode at that step → hits the waitlist gate.

**The distribution loop:**

1. Cohort runs Survival sim.
2. Each completed sim-day → Sim-day-overview trailer auto-generated (Ivan's pipeline, video PRD §4.3).
3. Operator uploads trailer to YouTube **Unlisted** with description (your description-generator output) pasted in.
4. Cohort + outsiders watch on YouTube.
5. Anyone curious taps a timecode → opens new tab on `doubland.ai/sim/{code}/play?t=&double=&zoom=&focus=` in full-screen **Play mode** → watches the lead-up → hits waitlist gate.

**Lock policy.** New ideas during the sprint are post-MVP unless they pass:

> *"This change makes the YouTube trailer + waitlist conversion path more emotionally undeniable for an investor."*

P2 polish items (§8) only ship if all P0/P1 items are stable. **Don't pull P2 forward without an explicit Ivan green-light.**

---

## 2. Authoritative sources

- `D:\Coding\double-docs\20260429_PRD_video_pipeline.md` — video pipeline PRD; §3 P1 describes the smooth-transition issue (item 2). §4.2 / §4.3 describe the sim-wide trailer modes Ivan is building upstream.
- `D:\Coding\double-docs\sot\sot_video.md` — video SOT (capture API §2.5: `__followPersona`, `__setCameraZoom`, etc.; Play mode is a sibling to `?recording=true` and `?headless=true`).
- This doc — your single source for delegated MVP items.

---

## 3. Ownership boundary

**Ivan keeps (do not pick up):**

- **Survival mode validation** — currently running Stage 6 fix testing on the in-flight test sim; once stable, Ivan moves to sim-wide trailer generation.
- **Sim-wide trailer pipeline implementation** — both the **Sim-day-overview** trailer (video PRD §4.3) and the **Opening / intro** trailer (video PRD §4.2). Stage 1 extractor extensions, stage 2 showrunner mode dispatch, stage 4 capture extensions, persona ranker, council/vote color treatment, name cards, "Previously on…" bridge cards. **This is the upstream pipeline that produces the trailer files you'll be uploading to YouTube.**
- All scenario / voice / prompt-engineering work — showrunner narration, narration discipline (Parsons safe-receipt rule, gate doc §4), survival template authoring.
- Recruiting / Founding Host outreach / investor narrative.

**Cut from your plate (was on the 2026-04-28 brief):**

- ~~Receipt card UI~~ — cut to post-MVP (no in-app receipts).
- ~~Motive prediction widget~~ — cut to post-MVP (no in-app prediction).
- ~~Lightweight evening drop~~ — cut to post-MVP (YouTube channel + bell IS the drop).
- ~~Basic share payload (Web Share API + four social platforms)~~ — cut to post-MVP (YouTube replaces native social share).
- ~~Trailer quality gates (full §2.4 battery)~~ — minimal three-check version only, see §5 P1.

**Operational (Ops, not engineering):**

- Reaction capture (now optional; cohort signal is now the YouTube channel itself).
- Founding Host waitlist outreach + onboarding.

**Your plate this sprint:** four P0 items from today's call (§4) + two P1 carry-overs (§5).

---

## 4. P0 items — from today's call (2026-04-29)

In strict priority order. **All four must ship.** Recommended sequencing: item 1 first (URL routing unlocks the description generator and the workflow); item 2 in parallel (independent video-pipeline fix); items 3 and 4 once item 1's URL spec is final.

### 1. Shareable URL → exact step + focus on scene *(P0 — FE)*

**Why this matters.** This is the conversion mechanism. The trailer is the artifact; the sim viewer is the long-form proof that it's real, not scripted. Every YouTube description carries timecode deep-links; tapping one drops the viewer into the sim viewer at the exact moment, camera on the right Double. **Without this, the YouTube channel doesn't drive waitlist signups.**

**Status:** the data is already produced by the trailer generator (`script.json.key_steps` carries step + named-Double pairs; the camera scripting API in video PRD §2.5 already exposes `__followPersona`, `__setCameraZoom`, etc.). What's missing is the URL routing + Play mode landing on the FE.

**Scope:**

- **URL spec:** `https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}&zoom={level}&focus={zone_or_xy}`. `?t=` and `?double=` required; `?zoom=` and `?focus=` optional.
- **Play mode** — a third FE mode alongside existing `?headless=true` (backend simulation) and `?recording=true` (trailer capture). Behavior:
  - **No app chrome** — navbar / sidebar / footer hidden.
  - **Immersive sim canvas** with a **minimal HUD**: current sim timestamp, play / pause, exit / "wait, what is this?" CTA → soft waitlist gate.
  - **Auto-seek** to step from `?t=` via existing `seekToStep`.
  - **Auto-focus** on `?double={name}` via existing `__followPersona(name)` (video PRD §2.5).
  - **Optional zoom** — apply `?zoom={level}` via `__setCameraZoom` on load.
  - **Optional focus** — `?focus={zone_name_or_x,y}` pans the camera before the persona-follow kicks in; useful for setting context (e.g. `focus=hobbs_cafe`).
- **Anchor target:** description-block generator (item 3) emits the YouTube description with these URLs; YouTube's renderer handles the new-tab open.

**Acceptance:**
- URL with `?t=&double=` opens in full-screen Play mode, lands at the correct step, camera follows the named Double.
- URL with `?zoom=` applies the zoom level on load; URL with `?focus=` pans before follow.
- Exit / "wait, what is this?" CTA in the HUD routes to `doubland.ai/waitlist`.
- Round-trip flow demoable: YouTube description timecode → sim viewer Play mode → waitlist gate.

**Inputs from Ivan:** confirmation on production domain (`doubland.ai` per current spec); HUD copy ("wait, what is this?" is a placeholder).

**Reference:** video PRD §2.5 (camera scripting API), gate doc §5 (the conversion mechanism).

---

### 2. Smooth transitions between video scenes *(P0 — video pipeline)*

**Why this matters.** Currently a new scene may start with a blank screen while Phaser visualization is loading. On YouTube — where attention spans are ruthless — a blank screen between scenes is the difference between a viewer staying through the cliffhanger and dropping at 0:18. The trailer is the channel's hero artifact; this fix is non-negotiable for clean uploads.

**Status:** video PRD §3 P1: *"Smooth video transition between scenes — Currently new scene may start with a blank screen with phaser vizualization is loading."* Diagnosis is clear; implementation is open.

**Scope:**

- Identify the Phaser-load delay at scene boundaries in `video/record_scenes.py` (and/or `?recording=true` FE mode).
- Likely fixes (your call which lands cleanest):
  - **Pre-warm next scene** before terminating the prior one (overlap render windows).
  - **Bridge frame / freeze-frame** — emit a single static frame (last frame of prior scene) for the duration of the load gap; FFmpeg post-stitches.
  - **Crossfade transition** at the FFmpeg compose step that masks the load gap.
- The fix should not regress the day-in-life pipeline (currently shipped, ~5min generation budget).
- Acceptance applies to **both** the day-in-life pipeline (already shipped) and the new sim-day-overview / Opening trailers Ivan is building (video PRD §4.2 / §4.3) — Ivan's pipeline reuses your fix.

**Acceptance:** no blank-screen frames at scene boundaries on any produced trailer; visual diff against a known-good trailer shows no regression elsewhere.

**Inputs from Ivan:** none. Coordinate with Ivan if your fix changes the `record_scenes.py` interface — he's actively building on top of it for the sim-wide modes.

**Reference:** video PRD §3 P1.

---

### 3. Description-block generator *(P0 — small CLI)*

**Why this matters.** Every trailer needs a YouTube description that (a) hooks the viewer into watching, (b) lists timecode deep-links into the sim viewer (the conversion mechanism), and (c) ends with the Founding Host waitlist CTA. Hand-writing each is tedious + error-prone; a small generator emits the markdown ready to paste into YouTube.

**Scope:**

- Small CLI: `python -m video.generate_description <sim_code> <persona_or_mode> [--output stdout|file]`. Reads `script.json` from the trailer output dir (`trailer_{sim_code}_{persona_or_mode}/script.json`).
- **Output format (markdown, ready to paste into YouTube description):**

  ```
  {one-line summary — 1-2 sentences from script.json.summary or narration opener}

  Key moments:
  0:18 — {key_step_label} → https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}
  0:34 — {key_step_label} → https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}
  0:52 — {key_step_label} → https://doubland.ai/sim/{sim_code}/play?t={step}&double={name}

  Want this for your friend group? Join the Founding Host waitlist:
  https://doubland.ai/waitlist
  ```

- **Source data:** `script.json.key_steps` already carries `(time_range_sec, step, label, double_name)` per scene. Map the start time of each scene to a `MM:SS` timecode + emit the deep-link.
- **Mode-aware:** day-in-life trailers focus on a single persona; sim-day-overview trailers cycle through 1-3 protagonists. Use `script.json.mode` and per-scene `protagonist` field once Ivan adds it for the sim-wide modes.
- **Optional `?zoom=&focus=` params:** if `script.json.key_steps[i]` carries `zoom` or `focus_zone` hints, append them to the URL; otherwise skip them.
- **Discipline guard (advisory, ≤10 lines):** before emitting, scan the summary line and key-step labels for vulnerable-confession terms (`afraid of`, `panics`, `abandonment`, `doesn't trust`). If present, log a WARNING but don't block — Ivan owns the prompt-side enforcement (gate doc §4).
- One line of metadata at the top in an HTML comment for traceability: `<!-- generated from script.json on {timestamp} -->`. YouTube ignores HTML comments in descriptions.

**Acceptance:**
- For any completed trailer (day-in-life, sim-day-overview, or Opening), running the generator produces a markdown block that pastes cleanly into YouTube.
- Each timecode link is a working `doubland.ai/sim/.../play?t=&double=` URL (validated against item 1).
- The waitlist CTA is present on every output.

**Inputs from Ivan:** confirmation on `script.json.summary` field shape if it doesn't already exist; per-mode `key_steps` schema (Ivan exposes as part of items 2 and 3 in the gate doc engineering plate).

**Reference:** gate doc §5, §7 #6.

---

### 4. YouTube posting workflow (operator runbook + helper) *(P0 — workflow)*

**Why this matters.** The trailers don't post themselves. Ivan or a designated operator runs the upload manually for the MVP — "manual + paste description" is the explicit decision in the gate doc. Your job is to make that operator workflow as fast + foolproof as possible.

**Scope:**

- **Runbook (markdown doc at `D:\Coding\double-docs\runbook_youtube_upload.md`):** operator-facing checklist, ~1 page. Covers:
  1. Run the description generator (item 3) → save markdown to disk or copy to clipboard.
  2. Open `youtube.com/@doubland-ai/upload`.
  3. Upload the `trailer_16x9.mp4` (16:9 master is the YouTube primary; `trailer_9x16.mp4` is for Shorts only — flag whether to upload as Short or full video).
  4. **Set visibility to Unlisted** (cohort + investor demo only — never Public, never Private).
  5. Paste description block.
  6. Set thumbnail (optional — pull a frame from `script.json.first_frame_path` if exists, else default to YouTube auto-pick).
  7. Tag conventions: cohort name, sim_code, sim_day, "Survival".
  8. Publish → log the URL.
- **Optional helper script** `python -m video.youtube_upload_helper <trailer_path>` — opens the upload page in default browser, copies the description to clipboard, copies the trailer file to a `ready_to_upload/` directory. **No YouTube Data API integration in MVP** — overkill for unlisted videos at MVP volume (≤10 trailers across the demo).
- **Log file:** simple markdown table or CSV at `D:\Coding\double-docs\youtube_uploads.md`. One row per upload: `sim_code | sim_day | trailer_type | youtube_url | posted_at`. Use this in the investor walkthrough as the "channel inventory" reference.

**Acceptance:**
- Operator runs through the runbook end-to-end in ≤10 minutes per trailer.
- Each trailer's metadata is recorded in the log file.
- All uploads are **Unlisted**, never Public.

**Inputs from Ivan:** confirmation on YouTube channel access (who has the upload credentials); decision on thumbnail strategy (auto vs. manual).

**Reference:** gate doc §7 #6.

---

## 5. P1 — only if all four P0 items are stable

### 5. Founding Host waitlist landing *(P1 — was P0 in earlier brief)*

**Demoted because:** today's call did not include this. If Ivan picks it up himself or hands it to Ops via Tally / Typeform, your plate is unaffected. If the no-code path doesn't deliver in time, this falls back to you.

**Scope (only if you take it on):** thin Next.js page at `doubland.ai/waitlist`. Form fields: email, cohort size, friend-group context, willingness to organize, **explicit "master user" tier** (commits to bringing 5-15 friends → priority queue, invite-code allocation). Writes to Supabase. Out of scope: invite-code minting (Ivan's plate); cohort onboarding flow (post-MVP).

**Acceptance:** form captures → Supabase row exists → confirmation email fires → master-user tier flagged in row.

**Inputs from Ivan:** Supabase table schema (or you propose: `waitlist_signups` with `(email, name, cohort_size, master_user, friend_count_committed, signup_at, status)`); copy for the master-user explanation.

**Reference:** gate doc §7 #5.

### 6. Minimal trailer quality gate *(P1 — minimal version of the prior P0)*

Three checks in `validate_trailer.py`, integrated into `generate_trailer.py` as a pre-compose gate:
- Duration within bounds for the trailer mode (60s for day-in-life, 150-180s for sim-wide).
- End-card present (last 2s carry the `drawtext` end card per `compose_trailer.py`).
- 9:16 crop sanity (key elements visible — manual checklist OK).

Deferred from the prior brief: subtitle timing from real audio (video PRD §3 TODO-4), full §2.4 acceptance battery. **Don't expand scope without an explicit Ivan green-light.**

**Acceptance:** any trailer Ivan or you produce passes the three checks; failures block compose unless `--force`.

**Reference:** video PRD §3 TODO-5.

---

## 6. Open questions — please clarify with Ivan before starting

1. **Production domain (item 1):** is `doubland.ai` final, or is there a staging vs. production split that affects URL routing?
2. **HUD copy (item 1):** "wait, what is this?" is a placeholder. Confirm or replace.
3. **Mode-aware `script.json` schema (item 3):** the day-in-life schema is shipped; the sim-day-overview / Opening modes Ivan is building (video PRD §4.2 / §4.3) introduce per-scene `protagonist` and shared `timeline`. Confirm shape before the generator hard-codes assumptions.
4. **YouTube channel access (item 4):** who holds the upload credentials? Operator handoff plan?
5. **Founding Host waitlist owner (item 5):** Ivan / Ops via Tally? Or you build it?

---

## 7. Working notes

- **Worklog.** Prepend an entry to `D:\Coding\double-docs\worklog.md` after every code change per the standing rule. Skip for doc-only edits.
- **Branch naming.** `nicolas/<description>` — see `D:\Coding\generative_agents\.cursor\rules\git-workflow.mdc` for the merge protocol.
- **Verify after behaviour-affecting edits.** The `verify` skill applies to anything that touches the simulation loop or trailer generation.
- **Don't pick up survival work.** Stage 3-6 fixes are Ivan's; he's currently running Stage 6 fix testing on an in-flight sim. Don't touch survival templates, survival memory, or the cognitive loop without an explicit ad-hoc ask.
- **Coordinate with Ivan on `record_scenes.py`.** Item 2 (smooth transitions) likely touches files Ivan is also editing for sim-wide trailer modes (video PRD §4.2 / §4.3). Either ship item 2 first (so Ivan builds on the fixed pipeline) or coordinate the merge.

---

## 8. Out of scope (P2 — only if all six items above are stable)

- **Guest sim viewer ±5-min context window** (gate doc §7 #10) — bounded watch window before waitlist gate.
- **Founding Host badge** — small badge on Double card / trailer end card (gate doc §7 #11).
- **Subtitle timing from real audio** (video PRD §3 TODO-4) — only if SRT-from-script-offsets visibly slips.
- **Push-notification infrastructure spike** — only if YouTube notifications prove insufficient as the cohort signal (gate doc §7 #13).
- **YouTube Data API automation** — manual upload is fine at MVP volume; automation is post-MVP.

**Cuts from the 2026-04-28 brief (now post-MVP — don't pull these forward):**
- Receipt card UI · motive prediction widget · lightweight evening drop · basic share payload (Web Share API + 4 social platforms) · full §2.4 trailer-quality battery · showrunner authorship-receipt JSON constraint · prediction resolution opener.

The sprint lock policy is *"this change makes the YouTube trailer + waitlist conversion path more emotionally undeniable for an investor"* — P2 items don't pass that bar by default.