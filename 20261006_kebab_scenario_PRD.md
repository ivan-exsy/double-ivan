# Doubland Scenario Writer

**Product requirements for Survival trailer scripts**

*Draft v1.0 • 6 October 2026 • Audience: product, design, engineering and editorial*

<plan C:\Users\ipist\.cursor\plans\kebab_scenario_writer_5c562a28.plan.md>

### Product decision

Build an internal workspace that makes daily trailer generation inspectable and comparable. The team must be able to trace a generated script back to the day’s events, inspect the choices that shaped it, and compare different storytelling workflows on the same evidence. The target output is a script for a 60–120 second Survival daily trailer featuring two or three doubles.

### Problem and desired outcome

Current scripts can feel generic, miss the most interesting events, and fail to create curiosity about the simulation or the next episode. Limited visibility makes it difficult to tell whether the failure began in event selection, story planning, writing, or later shortening. We need a record of those decisions and a practical way to test alternatives.

Success means a nontechnical teammate can explain why a script took its final form, identify a weak decision, and compare a better alternative without tracing application code. The product should ultimately support reusable rule changes that improve future automatic generation.

### Confirmed scope

- Survival daily episodes only. Generation begins after a simulation day is complete.
- The writer has access to the complete day log, including timestamped conversations and actions, and is responsible for finding high-impact material.
- The minimum capability is inspection of the decisions behind an automatically generated script. Multiple workflows and script comparison are core requirements.
- Episode overrides and reusable rule editing are desired capabilities, delivered after inspection and comparison are reliable.

### Specification status

This PRD translates the product discussion into proposed implementation requirements. P0 is the first release; P1 adds editing. Defaults, targets, and architecture choices identified as proposed require team review. No repository or real day-log schema has been inspected. SOT-video.md is background for integration, with the current 60–120 second requirement taking precedence over older timing bands.

## 1 Scope and product concepts

| Priority | Included |
| --- | --- |
| P0 Inspect and compare | Automatic day-complete runs; immutable input snapshots; explicit decision records; interactive beat view; evidence inspection; versioned workflow registration; two comparison modes; feedback; validated script handoff. |
| P1 Change and reuse | Episode-specific overrides; selective regeneration; manual text revisions; structured rule editing; workflow forks; historical impact previews; default-version promotion and rollback. |
| Later | Broad no-code workflow construction, large-scale parameter search, audience analytics integrations, collaborative live editing and automated optimization. |

Outside this product’s first release: ordinary town-life trailers, changing the simulation’s actions, TTS production, Grok video generation, video editing, and YouTube publishing. The product exports a script package for the existing downstream pipeline. It must not claim to enumerate every possible story or every possible wording.

### Shared vocabulary

| Term | Definition |
| --- | --- |
| Workflow | A reusable method for discovering, selecting, planning and writing a story. |
| Workflow version | An immutable definition of that method, including rules, prompts and stage configuration. |
| Run | One execution of a workflow version against an identified input snapshot. |
| Candidate story | A connected set of evidence, participants, a meaningful change and any unresolved thread. |
| Beat | A unit of the episode plan with a storytelling purpose, evidence and planned duration. |
| Alternative | Another eligible choice at a recorded decision point. |
| Override | An explicit change to a run that creates a derived run and preserves the original. |
| Policy version | Shared requirements applied across workflows, including factual and production constraints. |

### User roles

Proposed roles: reviewers inspect and annotate; editors create episode alternatives and draft workflow versions; maintainers register executable workflows and promote default versions. Map these capabilities onto existing workspace access controls. Automatic generation must use the same validated execution path as an operator-started run.

## 2 Episode workspace and navigation

### P0 01 Episode selection

Users select simulation, completed day and run. The run header shows workflow and policy versions, input snapshot, completion state, validation state and timing status. Survival episode number and engine day index must be labeled separately; the mapping must come from simulation metadata.

### P0 02 Interactive beat view

The main view is a vertical sequence of selected beats, informally called the kebab. Alternatives expand locally at each decision. Branches can rejoin, and selected beats can contain optional sub-beats. The default view shows the executed path. Dependencies appear when relevant to the selected beat rather than as an always-visible web of edges.

Each beat shows its purpose, selected option, narration excerpt, planned seconds and status. A merged or omitted beat remains discoverable with a reason. Required information is tracked separately from visible layers so removing a layer does not silently remove an obligation.

### P0 03 Evidence and script inspection

Selecting a beat opens its source excerpts, timestamps, speakers, rule references, input values, alternatives and concise selection reasons. The corresponding script passage is highlighted. Selecting a script sentence performs the reverse lookup. Users can open surrounding source context without losing their place.

| Decision status | Meaning |
| --- | --- |
| Selected | This option was used in the recorded run. |
| Eligible but not selected | The option was evaluated and allowed, but another was chosen. |
| Ineligible | A named prerequisite or constraint failed. |
| Merged or omitted | The beat was evaluated but has no separate slot; show where its purpose is covered or why it is unnecessary. |
| Not evaluated | The run provides no evaluation of this option; no rejection reason may be invented. |

### P0 04 Comparison entry

A Compare action lets users choose two compatible runs or start a new comparison. Show script differences, story and cast differences, and the first recorded divergence. When beat structures differ, align by purpose and evidence and leave unmatched beats visible; do not force one-to-one alignment.

### Interaction requirements

Support keyboard selection and expansion, text labels for every status, a readable list alternative to the graph, and persistent selection while inspecting sources. Large logs must load by page or window. Developer details such as prompts and raw payloads belong in an optional technical inspector.

## 3 Story discovery and episode planning

### P0 05 Complete day input

Create an immutable snapshot at day completion. Include the day log, roster baseline, relevant status changes, relationship history needed for that day, challenge rules, and prior episode continuity. Prior material may explain context but must be labeled as prior-day evidence. Facts about today must resolve to the appropriate event time.

Complete access does not require placing the entire log in one model call. Retrieval or chunking may be used, but every supplied event must be accounted for as processed, excluded with a recorded reason, or unprocessed. Record retrieval queries, selected event IDs and any limits. A truncated or incomplete source cannot silently pass as a complete day.

### P0 06 Candidate stories

Discover connected event chains and propose the story and featured cast together. Each candidate must include a factual summary, event references, central change, stakes supported by the record, essential participants, unresolved thread if present, and any missing evidence. Examples include a promise contradicted, costly support, a failed attempt or a relationship affected by a vote.

Proposed default: return the three strongest eligible candidates when available; allow fewer with an explicit reason. Scores are optional estimates with a named rubric and version. They must remain separate from factual validity. Record why the chosen candidate was preferred and preserve all alternatives actually evaluated.

### P0 07 Beat planning

Each workflow defines its own beat vocabulary and order. Common stages are discovery, selection, planning, writing and validation. The episode plan binds beat choices to evidence and allocates time. It may add, skip, merge, split or expand beats where the workflow allows it. Hard obligations must still be covered.

For example, a hook that states an earlier promise can satisfy the context obligation and remove a separate backstory beat. Time may then move to a supported consequence. The inspector must show the condition that caused the merge, the evidence retained and the new time allocation.

### P0 08 Narration and provenance

Draft narration from the selected plan. Preserve the selected story and cast unless a recorded replan occurs. Each factual claim must link to supporting evidence; questions, invitations and editorial transitions must be typed separately. Exact quotations must retain speaker and source span. Paraphrases must be identified as paraphrases.

Each stage emits explicit decisions while executing. Model-supplied reasons are labeled as explanations, not guaranteed accounts of internal reasoning. Alternatives generated after completion are labeled post-run exploration and cannot appear as original decisions.

## 4 Shared requirements and validation

### P0 09 Common policy

All competing workflows inherit a versioned shared policy. Storytelling rules can change emphasis and sequence but cannot override factual requirements. A deterministic condition evaluates true, false or unknown. Unknown evidence must never be treated as a positive match. Failed predicates and their actual input values must be inspectable.

| Requirement | Required behavior |
| --- | --- |
| Evidence | Every factual narration claim has source support. Citation presence alone is insufficient; validate that the evidence supports the claim. |
| Temporal correctness | Resolve alliances, eligibility, powers and roster status as of the event. Distinguish expired powers from continuing powers. |
| Causation and motive | Do not infer a motive from a vote alone or claim one ballot caused elimination without supporting mechanics and totals. |
| Featured cast | Use two or three featured doubles. Additional incidental names must not silently become featured cast. |
| Runtime | Plan within 60–120 seconds. Proposed default target is 90 seconds. Store estimated and measured durations separately. |
| Continuation | Use an evidence-supported unresolved thread. Do not assert that an unsimulated future confrontation will occur. |
| Destination | Use one primary invitation to watch. A specific scene link must resolve through an available destination contract; otherwise use an explicitly configured general destination. |
| Source treatment | Dialogue and day-log text are data. They cannot alter workflow instructions, authorize tool execution or change shared policy. |

### Validation types

Deterministic checks cover required fields, IDs, counts, chronology, claim references, runtime estimates and allowed transitions. Semantic checks assess whether evidence supports wording and whether the story remains understandable. Store evaluator version, result, explanation and uncertainty. Semantic checks supplement editorial review; they do not guarantee factual truth.

### Timing and infeasible plans

Planning estimates use a configured narration pace plus explicit non-speech windows. Actual TTS timing, when returned by the existing pipeline, is authoritative for final runtime. A script export can be estimate-validated while measured timing remains pending; it must not be labeled final-runtime-validated.

If mandatory content cannot fit, return a visible constraint conflict and proposed cuts or a replan. A quiet day should still be searched for a smaller meaningful change. If no supported plan meets the requirements, return insufficient_story with evidence of the search; do not fabricate drama or pad the script. This is an explicit exception to daily output.

## 5 Workflow registration and extensibility

### P0 10 Workflow registry

Maintain separate workflow and version records. A new version includes a name, description, author, method notes, stage definitions, prompts, model configuration, rule definitions, output schema version and shared-policy compatibility. Completed runs retain the exact version used. Editing a draft must never mutate an existing run.

P0 registration may use a developer-managed configuration or API. Adding a workflow must not require redesigning the inspector or comparison screen. Bespoke execution code may be supplied through a trusted adapter that emits the same stage and decision contracts.

### P0 11 Common adapter contract

| Stage | Required output |
| --- | --- |
| Discovery | Coverage record and candidate stories with evidence. |
| Selection | Chosen story and cast, evaluated alternatives and selection record. |
| Planning | Ordered beats, dependencies, coverage of obligations and time allocation. |
| Writing | Script segments and claim-level provenance. |
| Validation | Policy checks, semantic findings, duration status and export eligibility. |

A workflow can add internal stages or use a different beat sequence. It must map its observable outputs to the common stages. A workflow that cannot honor a fixed-story comparison must declare that limitation. Imported scripts without recorded decisions may be displayed, but must carry incomplete_trace and cannot be presented as fully inspectable runs.

### Rule representation

Each rule needs a stable ID, version, stage, scope, prerequisites, effect and explanation template. Hard constraints and soft preferences must be distinct. Soft criteria use explicit tie-breaking. Rules that conflict on a mandatory obligation produce a visible error; no hidden precedence may decide which requirement disappears.

Proposed default: use typed conditions and allowlisted actions for ordinary editing. Free-text principles may guide model stages, but the interface must identify them as instructions rather than mechanically enforced conditions. Never execute arbitrary code supplied by an editor or imported document.

### ReelShort inspired workflow

Provide a place to attach the team’s captured storytelling principles and their source notes. Translate those principles into explicit discovery, planning and writing instructions, then compare results with the primary workflow. This PRD does not define or verify ReelShort’s method. The experimental workflow is the team’s interpretation and requires its own version and test examples.

## 6 Overrides and rule editing

### P1 01 Episode alternatives

An editor can select a different candidate story, change featured people, choose a different eligible beat, or modify permitted beat inclusion and length. Every edit creates a derived run with a parent run ID, structured patch, actor, time and reason. The original stays available for side-by-side comparison.

Before execution, show the affected stages, stale decisions and expected generation scope. An invalid choice remains inspectable but cannot produce an exportable script until its conflict is resolved. Editors can pin unaffected decisions; if a pin conflicts with the new plan, explain the conflict and request a revised selection.

### P1 02 Selective regeneration

Use declared dependencies and input hashes to determine what can be reused. A new cast invalidates dependent story and script decisions. A rewritten hook can invalidate context coverage, transitions and timing. Changes to the final script always rerun global validation, even when only one stage was regenerated.

If dependencies are incomplete, rerun conservatively from the earliest affected stage. Retain each attempt and its outputs. Reusing identical stored artifacts must not be described as a new model result. Re-executing the same model settings may produce different text; exact replay means reopening stored outputs.

### P1 03 Text editing

Allow a manual draft revision with a visible difference from the generated script. Changed factual claims become unverified until their provenance and semantic checks are refreshed. A locked script is immutable; editing it creates a new revision and leaves the downstream production package attached to the old revision until a deliberate handoff.

### P1 04 Reusable rule changes

An editor may save a variant as a draft workflow version and express supported rules through forms. The product must make the scope explicit: this episode, a draft workflow version, or the default for future runs. Before promotion, show affected historical episodes and comparison results on the evaluation set.

Maintainers can promote a tested version or roll back to a previous version. Record the effective point and actor. Already queued jobs retain their pinned version; future jobs use the new default. Concurrent edits must use version checks and return a conflict rather than overwriting another editor’s work.

### Audit requirement

Record changes to selection, text, workflow versions, policies and default routing. Audit records explain who changed what and which runs were derived from that change. Episode overrides never silently become global rules.

## 7 Comparisons and evaluation

### P0 12 Two comparison modes

| Mode | Fixed inputs | Variable decisions |
| --- | --- | --- |
| Complete workflows | Identical day snapshot, shared policy and comparison settings. | Story selection, cast, beat structure and writing. |
| Storytelling approaches | Identical evidence package, selected story, cast and shared policy. | Beat structure, emphasis, sequence and wording. |

Require compatible snapshots and policies before presenting a controlled comparison. If users intentionally compare incompatible runs, label it descriptive and show the differences in input conditions. In fixed-story mode, a workflow must not quietly select another story or introduce new unsupported evidence.

### Comparison behavior

Start with two scripts side by side. Show selected story, cast, timing status and hard failures before editorial scores. Let users inspect differences in beats, evidence and narration, with aligned scrolling optional. Preserve unmatched beats and distinguish changed wording from changed factual content.

A concise divergence explanation should identify the earliest recorded difference, such as a different candidate selection or a context beat merged into a hook. The explanation must cite decision IDs. It may summarize the trace but cannot invent missing deliberation.

### P0 13 Human feedback

Reviewers can prefer A, prefer B, mark a tie or mark both unacceptable. Collect a reason and separate ratings for factual support, story clarity, specificity, emotional interest and curiosity to watch more. Proposed scale: 1–5 with anchored examples. Store reviewer identity and whether workflow names were hidden during review.

Blind script review is the proposed default for preference collection. Reveal workflow identity when the reviewer opens the diagnostic comparison. Model judgments are optional secondary feedback and must show evaluator version; they must not be presented as audience engagement measurements.

### Evaluation set and success measures

Proposed initial set: at least 12 completed days across at least two simulations, covering ordinary and unusual Survival outcomes. Include missing reasons, split votes, recurring cast, expired powers, weak story days and rich emotional evidence. Human annotations identify acceptable evidence and known failure cases rather than require one exact script.

Track trace completeness, unsupported-claim findings, reviewer agreement, inspection task completion, edit turnaround, and preference against the baseline. Proposed usability target: four of five nontechnical reviewers can identify a selected story, its source evidence and a rejected alternative within five minutes without developer help. Establish quality-improvement thresholds after a baseline review; no uplift is assumed.

## 8 Data contracts

The following entities are a logical contract, not a prescribed database schema. Use stable IDs and a schema_version on serialized artifacts. Times must distinguish simulation time from execution time. Preserve source offsets or equivalent stable spans for quotations.

| Entity | Minimum fields |
| --- | --- |
| DaySnapshot | snapshot_id, sim_id, engine_day, episode_number, cutoff, source_revision, content_hash, event_manifest, roster_ref, rules_ref, prior_context_refs, completeness_status. |
| SourceEvent | event_id, snapshot_id, sim_time, type, actor_ids, location_id when available, payload_ref, source_span, provenance. Retain original content. |
| WorkflowVersion | workflow_id, version_id, definition_hash, stages, rules, prompts, model_settings, adapter_ref, capabilities, author, created_at. |
| Run | run_id, snapshot_id, workflow_version_id, policy_version_id, parent_run_id, override_patch, status, attempts, stage_artifact_refs, execution_metadata. |
| CandidateStory | candidate_id, factual_summary, participant_ids, evidence_refs, central_change, stakes, unresolved_thread, evidence_gaps, evaluation_refs. |
| Decision | decision_id, stage_id, input_refs, rule_refs, evaluated_options, selected_option_ids, condition_results, explanation, origin, dependencies, timestamp. |
| BeatPlan | beat_id, purpose, option_id, cast_ids, evidence_refs, obligations_satisfied, requires, excludes, merge_target, duration_estimate, sequence_index. |
| ScriptRevision | script_revision_id, run_id, ordered_segments, text, claims, beat_refs, evidence_refs, revision_hash, validation_refs, lock_status, timing_status. |
| Comparison | comparison_id, mode, run_ids, frozen_story_ref when applicable, compatibility_result, alignment_refs, evaluations and human_feedback. |
| ExportPackage | package_id, script_revision_id, revision_hash, snapshot_id, workflow_version_id, policy_version_id, beat_and_evidence_manifest, timing_status. |

### Data integrity rules

Evidence references include event ID and source span plus whether evidence is current-day or prior context. Options store eligibility separately from selection. Rule outcomes use true, false or unknown. Decision origin distinguishes recorded execution, human override and post-run exploration. A workflow version, completed snapshot or locked script cannot be modified in place.

Store prompts, provider and model identifiers, settings, input hashes, tool results, timing, token usage and available cost data in execution metadata. Do not require private model reasoning. Missing provider metrics remain unknown. Deleting or losing a source must produce an unavailable-evidence state rather than a broken claim presented as verified.

## 9 Execution and production integration

### P0 14 Day completion and job execution

Consume a confirmed day-complete signal, finalize the input snapshot and enqueue a run using the configured default workflow and policy versions. Proposed idempotency key: simulation ID, completed day, snapshot hash, workflow version and policy version. Repeated delivery reuses the same scheduled job; an explicit rerun creates a distinct run with a new attempt or request identifier.

Jobs run asynchronously. Persist stage outputs before starting dependent stages, expose progress, and retain partial traces after failure or cancellation. Retries are bounded and stage-specific. A resumed job must verify all upstream hashes before reuse. Cancellation prevents new stages and blocks downstream handoff even if an in-flight provider call later returns.

### State separation

| State family | Values and behavior |
| --- | --- |
| Execution | queued, running, completed, failed, canceled. Completion means the execution finished, not that the script passed validation. |
| Validation | pending, passed, failed, needs_review. Show individual failures and unresolved semantic checks. |
| Script lifecycle | draft, locked, superseded. A lock identifies exact words and their revision hash. |
| Timing | estimated, measured, conflict. Show whether the current script has matching measured audio. |

### P0 15 Integration boundary

Wrap the existing writer where practical and add structured outputs around discovery, selection, planning and writing. The application service owns validation and persistence; the visual interface reads those records. Existing orchestration may remain in place if it can emit the required artifacts. A new orchestration framework is not a prerequisite.

SOT-video.md identifies candidate integration points including tonight_scar_picker, draft_closer_tonight_vo, check_closer_vo_facts and lock_day_script. These names are document references only and must be verified against the repository. Map Peak and Cost explicitly where the selected workflow uses them; do not force every experimental workflow to expose identical beat names.

### Script handoff

P0 exports a validated script revision and its beat/evidence manifest to the existing VO lock boundary. Preserve existing automatic generation behavior; do not add a mandatory nightly human approval step. Experimental runs never replace the production script unless explicitly selected for handoff by the configured workflow or an authorized operator.

Downstream assets must bind to the exact script revision hash. A changed script makes matching audio timing stale. Supply simulation time and location references for later replay links and descriptions; do not invent final video timecodes before measured timing exists. Phaser capture, cinematic production and rendering remain downstream responsibilities.

## 10 Reliability and operating requirements

### Failure handling

| Condition | User-visible result and recovery |
| --- | --- |
| Missing or incomplete logs | Mark snapshot incomplete, list missing coverage and block automatic export. Resume after a new complete snapshot is created. |
| No valid story | Show inspected candidates and evidence gaps. Return insufficient_story and allow a reviewed alternative or corrected inputs. |
| Missing motive or farewell | Disable unsupported content, retain unknown state and choose an allowed alternative without fabricating speech. |
| Contradictory rules | Identify both rule IDs, the conflicting obligation and affected beats. Require an explicit draft policy change or valid alternative. |
| Model or provider failure | Keep completed stages and failure details. Allow bounded retry or cancellation without duplicating production handoff. |
| Invalid output schema | Record the invalid response; allow a bounded repair attempt. Never mark a repaired output as the original response. |
| Changed inputs or versions | Create a new snapshot or version and new run. Existing comparisons retain their original inputs. |
| Missing replay destination | Show evidence in the inspector and use configured general CTA behavior. Do not create a fake scene URL. |

### Access and isolation

Use existing simulation and workspace permissions for logs, scripts and traces. Enforce access on the service side, including exports and direct artifact URLs. Keep credentials out of trace payloads. Test cross-simulation access explicitly. Retention and deletion must follow the existing product policy; unresolved retention details are listed in Section 12.

### Proposed performance targets

At the agreed benchmark size, target p95 of two seconds for an existing episode view, 500 milliseconds for expansion of loaded beat details, and three seconds for an existing two-run comparison. Generation latency and provider cost must be visible but are not assigned unsupported launch limits. Establish log-size and concurrency benchmarks from real data before committing to capacity targets.

### Monitoring and reproducibility

Record stage latency, failures, retries, model usage, candidate counts, missing evidence, rule conflicts and export outcomes. Exact inspection replay loads stored artifacts. A fresh generation is a new run and may differ even with identical settings. Retain the association between each generated script, its validation and any downstream timing result.

## 11 Acceptance criteria

The following cases define observable P0 and P1 behavior. Build fixtures from real logs where available; synthetic edge cases must be labeled. A completed generation is insufficient if its decision trace or evidence mapping is missing.

| ID | Given and when | Required result |
| --- | --- | --- |
| AC01 P0 | A day-complete event is delivered twice. | One scheduled run and one production handoff for the same idempotency key. |
| AC02 P0 | A reviewer clicks a factual sentence. | The exact script segment, beat, decision and supporting source spans are reachable. |
| AC03 P0 | An option fails because no farewell is recorded. | The failed predicate and missing field are shown; no fabricated farewell appears. |
| AC04 P0 | A relationship formed after the relevant vote. | It cannot support a claim that the pair were allied at vote time. |
| AC05 P0 | A hook already explains a prior promise. | The context beat may merge; the obligation remains covered and time is recalculated. |
| AC06 P0 | A second workflow is registered. | It executes on an existing snapshot and renders through the same inspector and comparison UI. |
| AC07 P0 | Two workflows use fixed-story mode. | Selected story, cast and evidence package remain fixed; structural and wording differences remain visible. |
| AC08 P0 | A legacy script has no decision records. | It is labeled incomplete_trace; alternatives are not invented as historical decisions. |
| AC09 P0 | Required material exceeds 120 seconds or no supported story fits. | The result shows a constraint conflict or insufficient_story and cannot be automatically exported. |
| AC10 P0 | Two scripts use different day snapshots. | Controlled comparison is blocked or explicitly converted to descriptive comparison. |
| AC11 P0 | An experimental run finishes while a production script is locked. | The locked script and its downstream package are unchanged. |
| AC12 P0 | Logs contain instructions to ignore the rules, or another simulation is requested. | Log instructions have no authority; unauthorized source access is denied. |
| AC13 P1 | An editor changes the featured pair. | A derived run is created; dependent outputs are invalidated and original artifacts remain available. |
| AC14 P1 | An editor changes a factual sentence manually. | Provenance and global validation become stale until checked for the new revision. |
| AC15 P1 | A tested version is promoted or rolled back. | Future jobs use the selected default; queued jobs and completed runs retain pinned versions. |

P0 exit also requires the nontechnical inspection exercise in Section 7, a usable list alternative to the graph, partial-failure recovery, and preservation of the existing VO lock contract. P1 exit requires conflict-aware regeneration and successful historical comparison before default promotion.

## 12 Delivery plan and decisions to confirm

### Delivery sequence

Milestone A establishes the input adapter, snapshot model, shared-policy registry and trace contract around the primary writer. Exit with one real day fully traceable through script validation, including a failed alternative.

Milestone B delivers the episode workspace, evidence inspector and comparison view. Register the primary workflow and one experimental workflow, support both comparison modes, and complete the P0 evaluation fixtures. This is the minimum useful internal release.

Milestone C adds episode overrides, manual revisions and dependency-aware regeneration. Milestone D adds structured rule editing, historical impact previews, promotion and rollback. Estimate delivery only after a repository and sample-data review; this PRD makes no staffing or schedule commitment.

### Open decisions and proposed defaults

| Decision | Proposed default or required input |
| --- | --- |
| Active Survival contract | Extract one shared policy from the current SOT. Resolve conflicting concept-introduction, role-introduction and timing rules before implementation. |
| Runtime target | Use 90 seconds as the initial planning target within the confirmed 60–120 second range. |
| Workflow authoring | Developer-managed registration in P0; constrained forms in P1. Broad visual programming remains later. |
| Evaluation material | Supply one full day log, its generated script, a strong reference script, and then assemble the broader test set. |
| Trace storage and UI | Use existing backend and authentication where feasible. React Flow with optional ELK is a candidate UI implementation, not a required dependency. |
| Retention and access | Confirm existing policy for private conversations, model traces, revisions and deleted simulations. |
| ReelShort principles | Supply the captured principles and examples before defining that experimental workflow. |

### Source basis and design references

Primary inputs: the product requirements and clarifications in the 6 October 2026 discussion; SOT-video.md supplied by the product owner. The attachment describes the existing pipeline but has not been verified against implementation. The PRD is authoritative only for the proposed scenario-writer scope; source policy conflicts require resolution.

Design references previously reviewed: Felt story sifting (github.com/mkremins/felt); Emily Short on storylets (emshort.blog/2019/11/29/storylets-you-want-them/); Ink branching and gathers (github.com/inkle/ink); articy simulation mode (articy.com/help/adx/Presentation_Simulation.html); DMN decision tables (docs.camunda.io); React Flow layouts (reactflow.dev/learn/layouting/layouting); LangSmith comparison (docs.langchain.com/langsmith/compare-experiment-results). These inform design patterns and do not imply vendor adoption.

## Additional clarifications

The repository context corrects two assumptions in the PRD: the shipping closer and staged writer are separate execution paths, and both currently consume a fact ledger rather than a complete day log.

Use the following decisions to revise the PRD and prepare the implementation plan. The first release should establish a useful inspection and comparison workspace while preserving the longer-term daily trailer requirements.

1. **Which writer is in scope? — Accept.**

   Build on **path B, `trailer_pipeline`, through stage 5**. Extend its existing stages and records rather than introducing another writer or orchestrator.

   Path A remains the production closer. Its scripts may be inspected, but missing decision history must be labeled `incomplete_trace`. Do not fabricate candidate selection or rejected alternatives for that path.

2. **Pictures, speech audio and rendering? — Accept.**

   Stop at `--script-only`. Stages 6–9 remain outside this project’s first release.

   The output is a selected script revision, its evidence and decision records, and its validation results.

3. **May experimental runs write the closer lock? — Accept, with a compatibility check.**

   Completing an experiment must never create or replace `vo_locked_long.txt`.

   Handoff is an explicit operator action selecting an exact script revision and destination package. Before writing, check that the script satisfies the destination’s closer contract and that its cast maps correctly to the required Peak/Cost inputs. A valid experimental script is not automatically a valid closer script.

   If adaptation is necessary, create a separate derived revision and show its differences. Preserve the previous lock when replacing an existing one. The accepted `20260823-2` specimen remains protected.

   The nightly command’s existing auto-lock behavior stays unchanged. No new routine human approval step is introduced.

4. **Runtime rules? — Replace the proposed default with separate production and experiment profiles.**

   The requested **daily trailer target remains 60–120 seconds**. Ninety seconds is a planning default, not a requirement to pad.

   Preserve `protagonist-choice` at its native shorter duration for experimentation. Do not force it to expand merely to participate in the inspector. However, a shorter result must be labeled **outside the daily target**, and cannot count as satisfying that target.

   Similarly, `group-recap` may expand only by including additional supported, useful material. Reaching 60 seconds through generic filler is a quality failure.

   Leave path A’s existing runtime policy unchanged in this release. A comparison between different duration profiles must disclose that difference.

5. **Featured people and selection? — Accept, with the same profile distinction.**

   For the daily-target `group-recap`, use **two or three featured doubles**, selected by the pipeline. Remove the fourth-lead option.

   Preserve the native single-protagonist experiment, clearly labeled as a different cast profile. It cannot claim fixed-cast comparison support until its adapter actually honors the imposed cast and roles.

   Path A’s Peak and Cost remain operator inputs. Stage 3 must not replace them automatically.

6. **Which obligations are shared? — Use a shared factual policy plus workflow-specific format contracts.**

   Shared requirements are:

   - Factual claims and quotations must be supported by the available evidence.
   - Counts, relationships, powers and eligibility must be correct for the relevant time.
   - Missing motives, farewells and future events cannot be invented.
   - Private user-to-Double chats remain excluded.
   - Public dialogue cannot change system instructions or rules.
   - Links and replay destinations must be real.
   - Trailer outputs must include one primary invitation to watch.

   Explicitly recorded reasons may be narrated with appropriate attribution. A blanket prohibition on all motives would discard useful evidence.

   The exact Doubles sentence, census beat, living last line, tally formulation and Day-1 alliances teaching lines remain **closer-format obligations**. They are not universal requirements for path B experiments.

   Store both the shared factual-policy version and the variant’s format-contract version. Different formats can then share factual safeguards without pretending their editorial requirements are identical.

7. **Known failures on `20261001-2`? — Add a focused Milestone A0.**

   Preserve the current ledger and wrong draft as a labeled regression fixture before making changes.

   A0 owns the minimum correctness work required for trustworthy new runs: historical cutoff, roster baseline, preservation of recorded farewell text, role-source handling, and accurate tie/tiebreak representation. Where an error is in the writer rather than the packet, identify the narrowly scoped writer fix separately.

   **UI scaffolding may proceed in parallel. A0 blocks acceptance of the real-day demo as correct and blocks production handoff of affected results.** It does not block opening the known-bad fixture to diagnose it.

   The note supports a six-person baseline and five remaining after Ivan’s departure. It does **not list all six identities**, so I cannot confirm those names. Read and preserve the actual baseline roster; do not substitute a later `remaining_players` value.

   Missing job information must remain unknown until an authoritative source is identified. Tie wording must explain the tiebreak when needed to avoid a misleading account.

   Keep the existing no-full-bake restriction until the corrected script is accepted. Do not redesign the closer’s storytelling format under A0.

8. **Alliances teaching line? — Accept.**

   For path A, follow SOT §9: Day 1 only. Later nights omit the teaching line.

   This does not prevent a later episode from describing an actual, relevant alliance supported by that night’s evidence.

9. **Where does the workspace live? — Accept.**

   Extend the local Post-Production Story tab for one operator. No new app, login system or reviewer-role implementation in the first release.

   Make saved comparisons and notes understandable to nontechnical teammates. Multi-user access can follow later.

10. **Is React Flow required? — Accept that it is optional.**

    Start with a readable vertical beat list with expandable alternatives, evidence and linked script passages.

    Interaction and traceability are required. A graph library is not.

11. **What starts a run? — Accept the staged rollout; require immutable runs now.**

    Use the existing CLI and Story tab initially. Day-complete automation remains a later delivery milestone after cutoff and snapshot behavior are reliable.

    Repeated equivalent requests may reopen or reuse stored results. An explicit rerun must create a **new run ID and output directory**.

    `--force` must stop overwriting completed run artifacts. Record workflow, prompt, model, policy and input versions when deciding whether cached output is reusable; the day and ledger hash alone are insufficient.

12. **Where do traces live? — Accept.**

    Keep them under `double-video/data/`, with a distinct directory per run and its stage attempts.

    Existing sim/day paths may point to a selected or latest run, but must not become the sole copy of historical results. No simulation-database migration is required.

13. **What is the snapshot? — Accept a ledger snapshot initially; reject the proposed meaning of completeness.**

    Freeze the exact ledger consumed by the run, including its hash, simulation, engine day, episode mapping and extraction metadata.

    Track these separately:

    - Whether the packet was built successfully.
    - Whether the privacy boundary passed.
    - Whether the historical cutoff is verified.
    - Whether source-event coverage is complete, partial or unknown.

    “Ledger built and private chats absent” is not evidence that the day’s relevant events were fully represented.

    Until coverage is established, label the input **ledger slice with partial or unknown coverage**. Prior-day evidence remains explicitly identified.

    Complete-day analysis remains the product direction. A ledger-only inspector does not by itself fulfill that requirement.

14. **Use `protagonist-choice` as the second workflow? — Accept.**

    Expose the existing registered variant in the Story tab and comparison system. Do not block this on a new ReelShort transcription.

    Label it as the team’s current interpretation. Additional captured principles can become a later version.

15. **First comparison pair? — Accept, with accurate comparison labels.**

    Run `group-recap` and `protagonist-choice` against the **same frozen ledger**, initially on a labeled fixture.

    Their native duration and cast requirements differ, so present this as a **cross-format complete-workflow comparison**. Its results cannot isolate whether a preference comes from writing, runtime, cast size or event selection.

    Defer fixed-story mode until both participating adapters honor the same imposed story, evidence and cast requirements. Do not simulate support by quietly allowing reselection.

    Use `20261001-2`, engine day 2, for the real trace demo after A0. The original wrong packet remains a separate regression fixture. The accepted specimen remains read-only.

16. **Blind review, five ratings and the 12-day set? — Accept deferral.**

    First release: preference **A / B / tie / both unacceptable**, plus a note linked to the exact run pair.

    Defer the full scoring interface and 12-day evaluation set. Still require a small release test set covering the known failures, not only one successful example.

17. **Which acceptance criteria apply? — Revise as follows.**

    | Criteria | First-release decision |
    |---|---|
    | **AC01** | Defer day-complete delivery. Add equivalent duplicate-click and explicit-rerun tests now. |
    | **AC02** | Include sentence-to-beat-to-source navigation. Label ledger-field evidence honestly; do not present it as an original transcript span. |
    | **AC03** | Include missing-farewell handling and a separate test proving an existing farewell survives extraction. |
    | **AC04** | Include through A0: future relationships cannot support earlier-night claims. |
    | **AC05** | Include if a workflow actually merges beats. Otherwise show that capability as unsupported; no generic merge engine is required yet. |
    | **AC06, AC08, AC11** | Include as proposed. |
    | **AC07** | Defer fixed-story behavior; require explicit capability detection now. |
    | **AC09** | Include validation against the selected format profile and separate daily-target eligibility. |
    | **AC10** | Include snapshot and profile compatibility disclosure. |
    | **AC12** | Include private-chat exclusion, simulation/file access boundaries, and an adversarial public-dialogue fixture. Privacy filtering alone does not test instruction handling. |
    | **AC13–AC15** | Defer the editing and promotion interfaces. |

    Add one essential trace test: **the UI distinguishes selected, evaluated-but-rejected, ineligible and not-evaluated options using actual records**. Showing stage outputs alone does not satisfy the decision-inspection requirement.

    Add a handoff test proving that an incompatible experimental script cannot overwrite the closer lock.

18. **What must P0 preserve for P1? — Accept, with a fuller record contract.**

    Store stable run, stage, decision, option, beat and script-segment IDs; parent run and revision relationships; snapshot hash; workflow and format versions; shared-policy version; prompt/model configuration; evidence references; validation results; and declared dependencies.

    Reserve structured fields for override origin and patch details. Record evidence granularity and missing trace information explicitly.

    Completed artifacts remain immutable. Failed or canceled runs retain their partial records. Future edits create derived runs or revisions.

    The editor, fork interface, rule forms and promotion UI can wait. Stable identities, provenance and preserved history cannot.

These decisions support an implementation plan centered on **A0 input correctness, the existing staged pipeline, and the existing Story tab**. The first release is an inspection and comparison tool. Automatic daily triggering and editing remain explicit subsequent milestones.