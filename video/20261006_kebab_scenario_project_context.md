# Project context for the Scenario Writer PRD

**Follow-up to** `20261006_kebab_scenario_PRD.md`  
**Date:** 6 October 2026  
**From:** Doubland product / engineering  
**For:** the authors of that PRD

The PRD is a clear product ask: an internal workspace that shows why a Survival daily script came out the way it did, compares two ways of telling the same day, and hands a chosen script to the existing voiceover lock. Pictures, speech synthesis, and publishing stay downstream.

That ask was written without inspecting this repository. Several names in the PRD are real, and they belong to a different writer than the one that already matches the PRD’s 60–120 second, multi-workflow shape. This note is the missing context. Section 10 is the question list. Answer those before an implementation plan.

Authoritative video contract: `double-ivan/video/SOT-video.md` §9 (closer) and §11 (pipeline). Live video code: `double-video/video/`. Open story problems on the current sim: `double-ivan/video/20261002_daily-story.md`.

---

## 1. Two writers already exist

Daily Survival video is not one pipeline. Treating “the writer” as a single module will put the inspector on the wrong execution path.

### A. Nightly closer — this is what ships

| | |
|---|---|
| Command | `python -m video.run_tonight_scar <sim> --day <engine_day> --peak "…" --cost "…"` from `double-video` |
| Default cut | `--sku closer` |
| Script | `video/draft_closer_tonight_vo.py` |
| Fact gate | `check_closer_vo_facts` in `video/validate_nightly_survival.py` |
| Lock file | `vo_locked_long.txt` inside `data/<sim>/trailer_ready_dayN/` |
| Picture + master | Same command continues into the clip kit and Remotion `NightlySurvival` |

A person starts this. There is no day-complete consumer in the video repo that enqueues it.

Peak and Cost are **inputs**. The operator passes `--peak` and `--cost`, or points at an existing `tonight_scar_picker.json`. The closer does not search the day for candidate stories and then choose a cast. It fills a fixed spoken shape from a fact ledger. Empty slots stay silent. It does not invent a farewell, a motive, or a challenge.

If `vo_locked_long.txt` is missing, the bake **auto-locks** the closer draft and continues. That is the opposite of a mandatory human approval step. An existing lock is kept unless the operator passes `--replace-vo-lock`. One package must never be force-replaced: `double-video/data/20260823-2/trailer_ready_day2` (the accepted auto-gen specimen).

Short Scar (`--sku scar`, `vo_locked.txt`, `draft_tonight_scar_vo.py`) is a separate, shorter cut. It is not the default daily.

### B. Staged Short pipeline — this is the nearer match to the PRD

| | |
|---|---|
| Command | `python -m video.trailer_pipeline --sim <sim> --day <engine_day>` |
| Code | `double-video/video/trailer_pipeline/` |
| Formats | `video/trailer/variants/` — registered ids `group-recap` (default) and `protagonist-choice` |
| UI | Post-Production **Story tab** (`apps/trim-board/src/StoryTab.tsx`), local API on `127.0.0.1:8787` |
| Artifacts | `double-video/data/<sim>/day<engine_day>/stage1.json` … `stage9.json`, plus `decisions/stopN.json` |
| Script-only stop | `--script-only` ends at stage 5 (voiceover). Stages 6–9 are shots, stills, speech audio, and render |

Stages:

| Stage | Name | What it emits |
|---|---|---|
| 1 | collect | Normalized public events from the fact ledger |
| 2 | score | Ranked events and score reasons |
| 3 | cast | Leads and reasons (the pipeline allows 2–4) |
| 4 | story | Ordered beats bound to event ids |
| 5 | vo | Narration lines, `fact_refs`, fact-check flags |
| 6–9 | scenes, assets, vo audio, render | Picture and master. Outside the PRD’s script boundary |

`group-recap` is a 60–120 second group short. Planning target inside that variant is 90 seconds. Beat labels are hook, setup, escalation, turn, outcome, tease. It will expand narration to fill the range.

`protagonist-choice` is already labeled in code as the ReelShort-style cut: one protagonist, one real decision, a mute cold open, a real open thread when the ledger has one. Length is sized to the day, about 20–75 seconds, with no padding pass. Quiet days are allowed to be short. Its prompts forbid narrated feelings and forbid inventing a cliffhanger.

The variant registry is a Python dict. The variant README states there is **no workflow engine**. Adding a format means a new Python module plus a registry line. Stage files record the variant id and an input hash. Re-runs skip a stage when that hash matches, unless `--force`.

Decisions today are approval stops (`approved`, `rejected`, `edited`, `auto_approved`) with an optional edits blob. The default run auto-approves. These are not the PRD’s Decision records (evaluated options, eligibility, rule results, origin).

The Story tab lets a person pick sim and engine day, run with auto-approve or manual stops, and read score, cast, beats, script lines, fact-check flags, shots, and asset thumbnails. It does not pass a variant, so it always runs the default `group-recap`. It has no beat kebab, no sentence-to-source click, no side-by-side comparison, and no “this run must not replace the nightly lock” handoff.

The word **kebab** in this repo means the spelling of variant ids (`group-recap`). It does not mean the vertical beat view in the PRD.

---

## 2. What the PRD named, and what those names actually do

The PRD lists `tonight_scar_picker`, `draft_closer_tonight_vo`, `check_closer_vo_facts`, and `lock_day_script` as integration points, taken from `SOT-video.md` and not checked against the tree. They are real. They are the **closer** path.

| Name | What it does today | What it does not do |
|---|---|---|
| `tonight_scar_picker.json` | Stores the operator’s Peak, Cost, door, and related picker fields for one nightly package | Discover candidate stories or rank alternatives |
| `draft_closer_tonight_vo` | Fills the §9 spoken slots from the ledger. Writes `vo_draft_long.txt`. Can write `vo_locked_long.txt` only when the bake asks it to lock | LLM discovery, beat planning, or claim-level provenance |
| `check_closer_vo_facts` | Fails the bake when the closer shape is missing: Doubles line, living last line, at least two emotional hooks, Day-1 versus later alliances line, Peak choice or win when the ledger has them. Also fails the phrases “are locked” and “trust score” | Check that each factual sentence is supported by a source span |
| `lock_day_script` | Locks a `script.json` and writes featured-history rows for picture recall | The closer voiceover lock. That file is `vo_locked_long.txt` |

Wrapping only those four modules produces an inspector for a slot template. It does not produce the PRD’s discovery, selection, planning, and writing stages. Those stage names already exist on path B, with thinner records than the PRD’s contract.

Path B does not write `vo_locked_long.txt`. Path A does not read path B’s stage files. They do not share a run id, a snapshot id, or a policy version.

---

## 3. Input the writers actually see

Both writers read a **fact ledger**, not the raw simulation log.

`build_fact_ledger` (`video/build_fact_ledger.py`) builds one JSON packet for an engine day from a cast digest plus season state. Top-level fields:

- `day`, `starting_cast`, `eliminated_history`
- `today.eliminated`, `today.challenge`, `today.votes` (includes a safe-wording mode such as `tie_then_tiebreak`)
- `yesterday` when the day is after the first
- `alliances`, `roles`
- `day_collection.public_conversations` and `day_collection.top_moments`
- `today_facts`, `yesterday_facts`, `writer_rules`

`day_collection` is the conversation and moment slice. It is not a guarantee that every action in the day was listed. The PRD’s rule — every supplied event is processed, excluded with a reason, or marked unprocessed — is not implemented. A truncated digest can still produce a ledger and a script.

Private user-to-Double chats are banned from this packet. Records tagged `gateway_chat` or ids starting `gwchat_` must not reach the digest, the day log, or the ledger (`video/collection_boundary.py`). Log text is data. That part of the PRD matches an existing rule.

Season state is a living row. A ledger built late can already contain later alliances and later exits. The script needs a **cutoff**: the row as of this night. That cutoff is an open bug, not a stored snapshot type. See §5.

Engine day and Survival episode are different indexes. **Survival day 1 is engine `--day 2`.** The PRD’s `DaySnapshot.engine_day` and `episode_number` must stay separate. The mapping is sim metadata, not `episode_number = engine_day`.

---

## 4. The closer’s spoken contract (path A)

`SOT-video.md` §9 is the live contract for anything that bakes through `run_tonight_scar --sku closer`.

Every night the script teaches the show and two people:

- One Doubles line: “These are Doubles — AI versions of real people, making choices no one wrote for them.”
- Someone is voted out; tonight’s game in one breath; a vote; someone left; a one-breath census; one Door.
- Peak then Cost: job and place, then at most one personality line each. The personality line is who they were tonight, or the innate trait. It is never Hold rank, Shield, Expose, or Protect.
- One real choice, kid-plain, when the ledger has a reason of the shape the writer can read.
- A last line that names someone **still in** tomorrow. Default is Peak walking in without tonight-only power.
- At least two emotional hooks among: one choice, last words, inner vote, living last line.

Day 1 (engine day 2) also says how many entered, the short challenge how-to, and the alliances-then-votes teaching lines. Later nights drop that alliances sermon. The vote still names the Cost: “Tonight {N} people name {Cost}.”

Length on this contract **follows the night**. Under 90 seconds is not a failure. Padding, a village recap, or a night with no real choice is a failure. An older ops note warns over 90 seconds and fails over 120. That is a warning band, not the planning target the PRD states.

Bonding lines (alliance, what they were doing, the choice, the inner vote, last words, the living last line) are kid-plain. Status first, then why, who, and when if those fields exist. Skip when empty. Never “are locked.” Never a trust score.

---

## 5. Known failures on the current sim

`20261002_daily-story.md` is the open story note for LeaderTalks. The daily closer is blocked on it. Do not treat the saved draft as a good trace of a correct writer.

Package: `double-video/data/20261001-2/trailer_ready_day2`. Trailer night is engine day 2, which is Survival day 1. Peak Nicolás, Cost Ivan Pitts.

The draft is the slot form. The note records these misses:

| Spoken result | What the record holds |
|---|---|
| “Fifteen entered” / “fifteen become fourteen” | This sim’s start roster is six (fork of `base_pit`). After Ivan leaves, five are still in. The Day-1 branch prints a constant. |
| “Nicolás and Gosha have each other's backs.” | On Survival day 1 the pair is Gosha and Ivan. The writer takes Peak’s first partner and does not reject pairs whose `formed_day` is later. The saved season row had already moved on. |
| No goodbye | Ivan’s farewell is on the season elimination row. The digest vote pack drops `final_statement`, so the writer never sees it. |
| Bare names, no job and place | Role cards are built from a “Working as … at …” sentence. This digest stores “Currently” and a daily plan. Ivan is also missing from that day’s digest cast. |
| “Tonight Two people name Ivan.” | The tally is a tie at 2 (Ivan and Katya). A tiebreak sent Ivan home. The ledger has fold reasons. The choice line only speaks a sentence shaped “I'd rather … than …”. Ivan’s reason has “I'd rather” and no “than”, so that slot stays empty. |

The note’s rule until a script is accepted: no full bake of that package. The specimen `20260823-2` stays untouched. `SOT-video.md` §9 stays the contract until an accepted script replaces it. Headcount for this season is the six-person baseline, not fifteen, and not `remaining_players` on a later day.

A trace UI built on today’s ledger would faithfully explain a wrong script. Fixing the packet (cutoff, goodbye, jobs, tie, headcount) is a different task from building the inspector. Section 10 asks which one this project owns.

---

## 6. Rule conflicts the shared policy cannot leave open

The PRD says every workflow inherits one versioned shared policy, and that storytelling may change emphasis and order but may not override factual requirements. It also says to extract that policy from the current video contract and to resolve conflicts **before** implementation. Those conflicts are:

| Topic | Closer, SOT §9 | Staged `group-recap` | Staged `protagonist-choice` | PRD proposal |
|---|---|---|---|---|
| Runtime | Follows the night. Under 90s is not a fail | Fixed 60–120s. Heuristic target 90s. A short script is expanded | Sized to the day, about 20–75s. No padding. Quiet day may be ~15–25s | 60–120s, proposed target 90s. `insufficient_story` may skip the day |
| Featured cast | Exactly Peak and Cost, named by the operator. At most one extra causal name, not featured | 2–4 leads chosen in stage 3 | One protagonist | Two or three featured doubles |
| Beat vocabulary | Fixed §9 slots. Empty slots skip. Hard show lines stay (Doubles, census, living last line, Door) | hook / setup / escalation / turn / outcome / tease, 4–7 beats | cold open / context / build / choice | Each workflow defines its own vocabulary. Hard obligations still covered |
| Alliances teaching line | Day 1 only. Later nights skip it | Not a closer slot | Not a closer slot | Not specified. A workspace note still asks for that line every night. The video contract wins for the closer bake: later nights skip it |
| Story discovery | None. Slots from ledger fields | Rank events, then one story | One decision or a quiet day | Three strongest candidates when available, with evaluated alternatives |
| Motive | Do not invent. Choice line needs a parseable “rather … than …” reason | Observable facts. Variant lint forbids narrated feelings on the protagonist cut; group-recap’s voice prompt is warmer and does not use that lint hook | Same lint: no motives, no “you” | Do not infer a motive from a vote alone |
| Future | Last line is someone still in. Do not promise a future confrontation | Tease beat exists | Open thread only when the ledger supports it | One evidence-supported unresolved thread. Do not assert an unsimulated confrontation |
| Door | One Door. Deep link or “Watch tonight…” | A CTA line from the variant | Same pipeline | One primary invitation. A scene link only through a real destination contract |
| Human gate | Missing lock auto-locks and bakes | Default auto-approve. Optional manual stops | Same | No new mandatory nightly approval. Experimental runs do not replace the production script unless explicitly handed off |

Path A and path B cannot share one policy object until this table has a chosen row per topic. Copying the PRD’s 60–120 / 90-second default onto the closer would change a locked ship rule. Copying the closer’s “length follows the night” onto `group-recap` would turn off that variant’s expand-to-60 pass.

---

## 7. Storage, users, and triggers

| PRD assumption | This project today |
|---|---|
| Day-complete signal enqueues one idempotent run | No such consumer in the video repo. Both writers start from a CLI or the Story tab |
| Idempotency key = sim + day + snapshot hash + workflow version + policy version | Closer: “file `vo_locked_long.txt` exists.” Pipeline: per-stage input hash under `data/<sim>/dayN/` |
| Runs, comparisons, and audit in the existing backend, with workspace roles | Stage JSON and package files on the local disk (`double-video/data/`, gitignored). Story tab is a local app. Sim allowlists exist for the public product. They are not roles on this writer |
| Immutable input snapshot at day completion | Ledger is rebuilt from current season state when extracted. Later days can already be inside that row |
| Prompt injection from the log cannot change policy | Private chats are stripped. Public dialogue is passed to the model as data on path B. There is no separate recorded proof that a log line was refused as an instruction |
| Retention for traces, revisions, and deleted sims | Not specified for these local files. Do not invent a retention rule |

Post-Production’s other job is picture polish on `{package}/edit_script.json` after a closer bake. The Story tab is a second screen in that same local app. It is the only UI that already runs a script pipeline.

---

## 8. Suggested reading of the PRD against this tree

Use this when revising the PRD. It is a reading of the current code, not a decision.

**Milestone A (trace contract around the primary writer).** The primary automatic daily is path A, and it cannot emit candidate stories, eligibility, or rejected alternatives without a new writer in front of the slots. Path B already has collect, score, cast, story, and voiceover, and already has two registered methods. A trace contract fits path B’s stage files first. Path A stays the production bake until a person hands a script across.

**Milestone B (workspace, inspector, comparison, second workflow).** The second workflow is already registered: `protagonist-choice`. The workspace seed is the Story tab. The missing product is the PRD’s beat view, evidence lookup, comparison modes, and the label `incomplete_trace` for a closer script that has no decision records. Comparison of path A against path B is a descriptive comparison until they share a snapshot and a policy. The PRD already has that label. Use it.

**Script handoff.** The production boundary to protect is `vo_locked_long.txt` on the nightly package, then the existing bake. `lock_day_script` is a different, older lock for `script.json` plus featured history. Experimental stage files must not be copied onto that lock unless an operator selects them. Path B’s stages 6–9 (pictures, audio, render) stay outside this product. `--script-only` is the existing way to stop at the script.

**P0 registration.** A developer-managed registry matches `video/trailer/variants/registry.py`. The inspector can stay stable while a new variant is added only if every variant maps into the same stage files the UI reads. That mapping does not exist yet at the PRD’s Decision / BeatPlan / claim grain.

**Do not design these as greenfield:**

- A second app with its own login, for the first release.
- A new orchestrator beside `trailer_pipeline/runner.py`.
- A day-complete queue before the snapshot cutoff is real.
- An automatic replacement of the closer lock.
- A rewrite of `20260823-2`.
- Picture, speech, or YouTube work inside this scope. The staged pipeline already has those stages. This product stops at the script package.

---

## 9. Fixture material that exists

| Material | Use | Limit |
|---|---|---|
| `data/20261001-2/trailer_ready_day2` | First real night with known wrong lines, documented in `20261002_daily-story.md` | Draft is not an accepted script. No full bake until the story note is accepted |
| `data/20260823-2/trailer_ready_day2` | Accepted closer specimen. Peak Ivan Pitts, Cost Alex Butcher, Hold for the Shield | Do not overwrite the lock or the master |
| `video/fixtures/` and `synthetic-demo` / `synthetic-protagonist` | Offline pipeline tests, including a protagonist ledger | Synthetic. Must be labeled if used as acceptance fixtures |
| A 12-day evaluation set across two sims | PRD proposal | Not assembled |

ReelShort: the team’s captured principles are not in the repo. `protagonist-choice` is this team’s current interpretation, with its own prompts and an offline fixture. The PRD is right that those principles are not verified as ReelShort’s method.

---

## 10. Questions to answer before an implementation plan

Proposed defaults are what we will plan against if you accept them. Override the ones you reject. A plan that mixes path A’s lock with path B’s discovery, under two unspoken policies, will not be estimable.

### Product boundary

1. **Which writer is in scope for the first release?**  
   **Proposed default:** Path B (`trailer_pipeline` through stage 5). Path A remains the nightly bake and is not rewritten in this release. A closer script may be opened in the inspector only as `incomplete_trace`.

2. **Does the first release include pictures, speech audio, or the Remotion master?**  
   **Proposed default:** No. Stop at `--script-only`. Stages 6–9 stay as they are and are not part of the kebab workspace.

3. **May a finished experimental run write `vo_locked_long.txt` by itself?**  
   **Proposed default:** No. Handoff is an explicit operator action onto a chosen script revision. The current closer behavior stays: if that lock file is missing, the closer writer still auto-locks, and experimental runs do not create that file. No new human approval step on the nightly command.

### Shared policy

4. **What is the runtime rule for the workflows this tool compares?**  
   **Proposed default for path B comparison:** keep each variant’s own length rule (`group-recap` 60–120 with a 90-second planning target; `protagonist-choice` sized to the day, 20–75, no padding). Do not impose 60–120 on the protagonist cut. Do not change the closer’s “length follows the night” rule in this release.  
   Confirm or replace that split.

5. **How many featured people, and who chooses them?**  
   **Proposed default:** `group-recap` may feature two or three. A fourth lead is out. `protagonist-choice` features one and must declare that it cannot enter a fixed-cast comparison without a cast override. The closer’s Peak and Cost remain operator inputs and are not silently replaced by stage 3.

6. **Which show lines are hard obligations for every workflow, and which are closer-only?**  
   Need an explicit list. Candidates that are hard on the closer and absent from path B today: the Doubles sentence, the census count, the living last line, one Door, “Tonight {N} people name {Name},” and the Day-1-only alliances teaching lines.  
   **Proposed default:** those lines stay obligations of the closer bake only. Path B workflows must still refuse invented facts, invented motives, invented farewells, private chats, and promises about an unsimulated future. Say if any closer line must also be true of `group-recap` before comparison is meaningful.

7. **Headcount, goodbye, alliance day, jobs, and the tie on `20261001-2`.**  
   These are open in `20261002_daily-story.md`.  
   **Proposed default:** this PRD does not change those writer rules. The first trace is allowed to show the current wrong script and the missing fields. A separate change fixes the ledger cutoff, the dropped farewell, job and place, the tie wording, and the six-person start count. Confirm the start list is those six names before that separate change.  
   If you instead want this project to fix the packet before any UI, say so. That becomes Milestone A0 and blocks the inspector.

8. **Alliances teaching line.**  
   **Proposed default:** follow `SOT-video.md` §9. Day 1 only. Later nights do not say it. Ignore any note that asks for it every night.

### Workspace

9. **Where does the beat view live, and who uses it in the first release?**  
   **Proposed default:** extend the local Post-Production Story tab. One operator on this machine. Reviewer / editor / maintainer roles wait. Anya does not need a login for this release.

10. **Is React Flow required?**  
    **Proposed default:** no. A readable list of beats with local alternatives is the first UI. A graph layout is optional and not a dependency.

### Execution

11. **What starts a run in the first release?**  
    **Proposed default:** the operator, from the Story tab or the existing CLI. Day-complete enqueue waits until a snapshot has a real cutoff and a content hash. Repeated clicks with the same sim, day, variant, and input hash reuse stored stage files. `--force` is the explicit rerun and must produce a distinct run id once run ids exist. Today `--force` overwrites stage files in place. That overwrite contradicts the PRD’s immutable runs. Confirm that new runs must stop overwriting stage files.

12. **Where do traces live?**  
    **Proposed default:** keep local files under `double-video/data/`. Add the PRD’s ids and records beside the current stage JSON. Do not move this into the simulation database in the first release.

13. **What is the snapshot?**  
    **Proposed default:** the fact ledger JSON used for that run, stored with a content hash and the engine day, plus a completeness flag. Completeness is “the ledger was built and private chats were absent.” It is not yet “every simulation event was accounted for.” Full event accounting waits on the cutoff work in question 7. Prior-day facts must stay labeled `yesterday_facts` or prior context.

### Comparison and the experimental workflow

14. **Is `protagonist-choice` the experimental workflow for Milestone B?**  
    **Proposed default:** yes. Registering it in the inspector is the “second workflow” acceptance test. Supply a principles note only if this variant should change. Do not block the inspector on a new ReelShort transcription.

15. **First real comparison pair.**  
    **Proposed default:** same ledger, `group-recap` versus `protagonist-choice`, on a fixture day. Fixed-story mode is the second mode and requires the protagonist variant to accept an imposed story and cast. Until it declares that, those two runs are a complete-workflow comparison, and a quiet story change is a hard failure of fixed-story mode.  
    First real sim for a trace demo: `20261001-2` engine day 2, after question 7 says whether the packet is fixed first. Do not use `20260823-2` as a rewrite target.

16. **Blind review, 1–5 scores, and a 12-day set.**  
    **Proposed default:** out of the first UI release. Store a single note and a preference (A, B, tie, both unacceptable) when a person compares two runs. The five anchored ratings and the 12-day set come after one real day is traceable.

### Acceptance

17. **Which PRD acceptance rows are in the first release?**  
    **Proposed default:** AC02 (sentence opens its beat and source refs, at the grain the ledger actually has), AC03 (missing farewell stays missing), AC06 (second registered variant renders in the same UI), AC08 (closer lock shown as `incomplete_trace`), AC11 (experimental run leaves `vo_locked_long.txt` unchanged), AC12 (private chat and cross-sim reads stay denied).  
    AC01 (day-complete delivered twice) waits on question 11. AC04 and AC05 wait on the shared policy and on real ledger fields for “allied at vote time” and for a merge reason. AC07 waits on question 15. AC09 waits on question 4. AC10 is in scope as soon as two runs can carry different snapshot hashes. P1 rows AC13–AC15 are not in the first release.

18. **Anything in P1 (overrides, manual sentence edits, rule forms, promotion) that must be designed into the P0 records so it is not a rewrite?**  
    **Proposed default:** store parent run id, input hash, variant id, and policy id on every run, and do not mutate a finished stage file. Do not build the editor, the fork UI, or promotion in the first release.

---

## 11. What we need back

Reply by question number. Accept the proposed default or replace it. The implementation plan starts when 1, 4, 5, 6, 7, and 11 have an answer. The others can keep the proposed default if you do not object.
