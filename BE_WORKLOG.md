## 2026-10-13 — Ivan — branch: ivan/card-warm-and-hearts

### Backend

- [x] **Every Social row has hearts, and Story shows the last three days**
   - `api_gateway/app/services/person_card.py`: Score hearts from allies, strangers, broken pledges, and votes, and return alliances, breaks, votes, and challenges for the last three days
   - `api_gateway/app/services/person_card_service.py`: Sign the portrait on each Story person, and stop reading conversation memories for the card
   - `api_gateway/tests/test_person_card.py`: Cover the heart scale and a full day that still keeps the vote and the challenge

## 2026-10-12 — Ivan — branch: ivan/card-warm-and-hearts

### Backend

- [x] **A second card open is reused, and two votes still show a heart**
   - `api_gateway/app/services/person_card_service.py`: Reuse the first screen for 20 seconds, including the signed portrait
   - `api_gateway/app/services/person_card.py`: Count two votes as 1 heart so the row is not five empty outlines
   - `api_gateway/tests/test_person_card.py`: Cover one, two, and three votes, and a repeated card open

## 2026-10-12 — Ivan — branch: ivan/show-day-and-sprites

### Backend

- [x] **The person card reads real nights, pledges, and a quiz sheet**
   - `api_gateway/app/services/person_card.py`: Keep dated public beats, name allies stored as ids, and read a quiz sheet written into innate
   - `api_gateway/app/services/person_card_service.py`: Use that day's beat when no nightly line is stored, and reuse the town read for 20 seconds
   - `api_gateway/app/services/persona_sprite_service.py`: Return no portrait URL when the photo cannot be signed
   - `api_gateway/app/services/supabase_service.py`: Sign the manifest portrait the same way as the card
   - `api_gateway/tests/test_person_card.py`: Cover a spared person, an id alliance, Talked once, and a quiz sheet

## 2026-10-12 — Ivan — branch: ivan/show-day-and-sprites

### Backend

- [x] **Season status keeps the survival label and an open length**
   - `api_gateway/app/services/season_status.py`: Return the survival day label and the stored length, including 0, and a null playlist
   - `api_gateway/app/api/routes/seasons.py`: Document that this route does not invent a 15-day cap
   - `api_gateway/tests/test_season_status.py`: Expect Survival Season Day 2 and total_days 0 on engine day 3
   - `api_gateway/tests/test_person_card.py`: No finished night is null; a night with no votes for that person is 0

## 2026-10-12 — Ivan — branch: ivan/show-day-and-sprites

### Backend

- [x] **The landing can read the show day, last night's votes, and the night someone left**
   - `api_gateway/app/services/season_status.py`: Publish Survival Season Day N for the showcase season
   - `api_gateway/app/api/routes/seasons.py`: Public `GET /api/seasons/{id}/status` (the page hides Day N until this answers)
   - `api_gateway/app/services/person_card.py`: Count ballots stored as persona ids, and return `eliminated_day`
   - `api_gateway/app/services/day_highlights_service.py`: Add the missing "is voted out" line on that engine day
   - `api_gateway/tests/test_season_status.py`: Show day 2 when the clock is engine day 3, and Alex's 4-vote line

## 2026-10-09 — Ivan — branch: ivan/card-look-photos

### Backend

- [x] **A missing portrait is omitted, and the manifest uses the same signed photo as the card**
   - `api_gateway/app/services/persona_sprite_service.py`: Return no photo URL when the portrait cannot be signed
   - `api_gateway/app/services/supabase_service.py`: Sprite manifest signs that portrait for six hours and still publishes the public atlas
   - `api_gateway/tests/test_persona_sprite_service.py`: Cover a failed signature
   - `api_gateway/tests/test_supabase_read_only_mode.py`: Manifest signs a look photo and leaves the atlas public

## 2026-10-09 — Ivan — branch: ivan/market-name-match

### Backend

- [x] **A usable place keeps its name when a shorter street sits inside it**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Fifth Avenue no longer counts as the place inside Fifth Avenue Market
 - `tests/test_life_not_destination.py`: The Market row stays, and a bare Fifth Avenue meeting still flags

## 2026-10-08 — Ivan — branch: ivan/park-midpoint-walk

### Backend

- [x] **Out-of-zone travel walks to a tile inside the target address**
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Skip the rectangle midpoint when its address is outside the target
 - `tests/replay/test_out_of_zone_walk_target.py`: The garden anchor wins over the street midpoint
- [x] **Embedding and database waits can no longer sit for minutes**
 - `reverie/backend_server/step_caps.py`: Embedding reads wait 15 seconds with one retry, and PostgREST waits 15 seconds
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Those limits bind the embedding client, and chat keeps its own deadline
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Memory, position, and raw clients use that PostgREST timeout
 - `reverie/backend_server/reverie.py`: Boot log prints the caps next to the three persist attempts
 - `tests/test_step_caps.py`: The embedding call is capped and the chat call is not

## 2026-10-08 — Ivan — branch: ivan/person-card

### Backend

- [x] **The person card opens from three small reads instead of the biography and a live model call**
 - `api_gateway/app/services/person_card.py`: Trait words, markers, votes, alliances, and story lines are built from stored rows
 - `api_gateway/app/services/person_card_service.py`: The card, Story, and Social reads stay off the model and off the old biography
 - `api_gateway/app/api/routes/simulations.py`: Those three reads are public, and a replay day before day 1 is rejected
 - `supabase/migrations/20261008170000_persona_card_lines.sql`: A place to store the nightly sentence, which the card shows only for that exact day

## 2026-10-05 — Ivan — branch: ivan/account-watch-and-leave

### Backend

- [x] **Account shows every town the Double is already in, including a finished tape**
 - `api_gateway/app/services/self_serve_bind_service.py`: Closed towns on the roster appear as joined, and a finished run can be watched
 - `api_gateway/tests/test_onboard_sims.py`: A closed completed town is listed once and counts as watchable
- [x] **Any signed-in visitor gets the neighbor conversation**
 - `api_gateway/app/services/chat_with_double_service.py`: A login that does not own this Double gets the neighbor pack
 - `api_gateway/tests/test_chat_double_lore_ban.py`: Signed-in non-owner is a neighbor; no login stays a stranger

## 2026-10-05 — Ivan — branch: ivan/account-watch-and-leave

### Backend

- [x] **Account list says whether they can watch, and carries a premiere date only when one is set**
 - `api_gateway/app/services/self_serve_bind_service.py`: The portal sim list adds can_watch and premiere_date
 - `supabase/migrations/20261005150000_sim_premiere_date.sql`: Empty premiere date on each sim, separate from the town clock
 - `api_gateway/tests/test_onboard_sims.py`: A resting live town still counts as watchable
- [x] **A person can leave one town from their account**
 - `api_gateway/app/api/routes/me.py`: Leave is a signed-in call on that person's own Double
 - `api_gateway/app/services/self_serve_bind_service.py`: The apartment opens, the job on that town clears, and the others get a quiet moved-away memory
- [x] **The public person card no longer returns the quiz score sheet**
 - `api_gateway/app/services/card_summary_transforms.py`: A quiz sheet in innate is blank on the public card
 - `api_gateway/app/api/routes/simulations.py`: Person details use that public copy

## 2026-10-03 — Ivan — branch: ivan/chat-and-team-door

### Backend

- [x] **Talk to your Double with no town running, and a correction stays in that conversation**
 - `api_gateway/app/services/chat_with_double_service.py`: Owner chat uses a correction in later replies and does not treat it as a lasting change
 - `api_gateway/app/services/owned_double_host_service.py`: A new personal host uses the downtown maze when the old template sim is missing
 - `api_gateway/tests/test_chat_double_lore_ban.py`: The next prompt contains the correction; other talkers do not get that rule
 - `api_gateway/tests/test_owned_double_chat.py`: Host creation works without the old sim, and the chat does not write the profile
- [x] **Docs and operator controls require a team email on the same 6-digit login**
 - `supabase/migrations/20261003120000_team_members.sql`: Team list, applied on the live database
 - `api_gateway/app/services/team_access.py`: Docs go to the code page; start, stop, and the other operator controls return 401 or 403
 - `api_gateway/app/api/routes/team_login.py`: The code page checks the team list and returns to the docs
 - `api_gateway/tests/test_team_door.py`: Playback, the person card, signup, health, chat, and movement reports stay open

## 2026-10-03 — Ivan — branch: ivan/vote-count-is-people

### Backend

- [x] **A stronger vote lasts one night, and the number people remember is how many named them**
 - `reverie/backend_server/survival/rewards.py`: A boost from an earlier day no longer multiplies tonight's vote
 - `reverie/backend_server/survival/controller.py`: The day roll drops that spent boost; elimination still uses the weighted total; memory stores the headcount
 - `reverie/backend_server/survival/voting.py`: Count one person per ballot, separate from the weighted total
 - `tests/test_survival_challenges.py`: Yesterday's 1.5 does not stack on today's double, and three names stay 3 when the weights add to 6
 - `tests/test_survival_rca_20260627.py`: The day roll drops last night's boost
 - `tests/test_survival_restart_idempotency.py`: The elimination record stores 3 when the weighted total is 8

## 2026-10-03 — Ivan — branch: ivan/street-line-matches-body

### Backend

- [x] **The line under a person names the street while they are on it, and the room once they have stopped**
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: A street presence or a street landing says “on the street”; landing in another room names that room
 - `tests/test_action_text_sanitization.py`: A park plan while the body is on the street no longer prints the park
 - `tests/test_movement_report_landed_label.py`: A walk report that lands on the street or in the park rewrites the sentence to that place

## 2026-10-03 — Ivan — branch: ivan/public-card-quiz-sheet

### Backend

- [x] **Public person card no longer returns the quiz score sheet**
  - `api_gateway/app/services/card_summary_transforms.py`: Blank that sheet on the public personality line and on the trait chips; a normal sentence stays
  - `api_gateway/app/services/card_summary_service.py`: The card's short sentences are written without the sheet
  - `api_gateway/app/api/routes/simulations.py`: The public details read uses that same blanked line
  - `api_gateway/tests/test_public_card_quiz_sheet.py`: The two public reads omit the quiz name; chat still receives the sheet

## 2026-10-01 — Ivan — branch: ivan/ballot-sentence-first

### Backend

- [x] **A Survival ballot leads with the person's own sentence**
  - `reverie/backend_server/survival/pledges.py`: Put the sentence first, drop the extra promise why, and keep up to 800 characters of the sentence and 2,000 of the whole line
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Keep the first 800 characters of the model's vote sentence
  - `reverie/backend_server/survival/controller.py`: The elimination record keeps that same full line
  - `tests/test_survival_pledges.py`: A long promise does not push the sentence off the line

## 2026-10-01 — Ivan — branch: ivan/vote-ballot-json

### Backend

- [x] **A Survival vote keeps the person's own choice when the reply includes pledges**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Read the whole JSON object. The old cut stopped at the first closing brace inside the pledge list, so every ballot fell back to the backup name
 - `tests/test_vote_json_parse.py`: A nested vote reply stays the model's target, including a brace inside the reason

## 2026-10-01 — Ivan — branch: ivan/pm-auth-2-lock-public-reads

### Backend

- [x] **The simulation list, costs, and full roster require a signed-in account**
  - `api_gateway/app/api/routes/simulations.py`: Anonymous calls to those three reads are rejected. Playback and a person's card stay open
  - `api_gateway/app/routes/simulation_control.py`: Remove the unused second roster read so it cannot answer later
  - `api_gateway/tests/test_public_sim_reads_auth.py`: An anonymous caller is rejected; a signed-in caller can list; a person card still opens

## 2026-09-30 — Ivan — branch: ivan/persona-relation-ids

### Backend

- [x] **A pledge, a vote, an affinity, and an open chat stay attached when a Double is renamed**
  - `reverie/backend_server/persona/relation_keys.py`: Store the relationship on `personas.id`. A sentence still uses the current name
  - `reverie/backend_server/survival/controller.py`: On the next start, name-keyed pledges and stored vote targets are rewritten once
  - `reverie/backend_server/persona/memory_structures/scratch.py`: The chat partner and affinity map use the id. The step feed still shows the name
  - `reverie/backend_server/reverie.py`: Bootstrap writes that id onto each persona and onto the Survival records

## 2026-09-30 — Ivan — branch: ivan/survival-live-pledges

### Backend

- [x] **A Survival ballot keeps only live vote and protection pledges**
  - `reverie/backend_server/survival/pledges.py`: A pledge is spare or vote_with. The ballot line is the stored words plus keep or break
  - `reverie/backend_server/survival/controller.py`: Close a pledge when that person is voted out. A listener's new words do not reopen a broken pledge. The goodbye adds one clause for people who had a pledge
  - `reverie/backend_server/persona/prompt_template/v2/survival_talk_takeaway_v1.txt`: A favor, an errand, or a hint is not a pledge
  - `reverie/backend_server/persona/prompt_template/v2/survival_vote_decision_v1.txt`: The vote returns one keep or break, and one sentence, per person still in
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Drop any other kind. Retry when a live pledge has no stance

## 2026-09-30 — Ivan — branch: ivan/persona-name-heal

### Backend

- [x] **Roster name wins when scratch still has the login**
  - `reverie/backend_server/persona/persona_names.py`: One split. Nicolás stays Nicolás; a matching scratch row is left alone
  - `reverie/backend_server/reverie.py`: A missing-fork bootstrap writes the roster name into scratch.json and corrects the scratch row
  - `reverie/backend_server/persona/persona.py`: The next start rewrites a disagreeing scratch file. A sim already running keeps the name it booted with
  - `api_gateway/app/services/pgh_compile.py`: Onboarding rename writes `personas.name` and every `persona_scratch` row for that Double

## 2026-09-29 — Ivan — branch: ivan/talk-promises-to-vote

### Backend

- [x] **Spoken Survival promises now reach the ballot**
   - `reverie/backend_server/persona/prompt_template/v2/survival_talk_takeaway_v1.txt`: One takeaway call per full sit; promises are verbatim vote/later lines
   - `reverie/backend_server/survival/controller.py`: Store takeaways and `i_promised`/`they_promised`; betrayal only when the voter promised
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: Hook talk-end into the Survival controller
   - `reverie/backend_server/persona/cognitive_modules/leftover.py`: Drop Survival leftover classes; meet/tell/avoid stay

## 2026-09-29 — Ivan — branch: ivan/persona-name-unicode

### Backend

- [x] **Watch map no longer goes blank when a Double's name has an accent**
 - `api_gateway/app/core/validation.py`: Persona name check accepts accented letters (Nicolás); symbols and emoji are still rejected
 - `api_gateway/tests/test_persona_name_validation.py`: Lock accented, decomposed-accent, and emoji cases, plus a step frame that keeps Nicolás

## 2026-09-29 — Ivan — branch: ivan/downtown-join-20-apartments

### Backend

- [x] **Downtown Join offers the 20 apartments, one person each, and every job stays open**
 - `api_gateway/app/data/maze_catalogues/downtown.json`: List the 20 apartments and add PPG Cafe as a job that can be shared
 - `api_gateway/app/services/maze_bind_catalog.py`: One occupant fills a home; a shared job stays on the list
 - `api_gateway/tests/test_maze_bind_catalog.py`: Lock the 20 homes, one person per home, and a taken shop still offered
 - `api_gateway/tests/test_onboard_deploy.py`: A full town is all 20 apartments taken

## 2026-09-28 — Ivan — branch: ivan/downtown-shelf-load

### Backend

- [x] **Use Luba's own account on the five-Double baseline**
 - `scripts/plant_base_pit.py`: Replace the scripted Luba with the Breakfasts account, keeping Six PPG Place and PPG Cafe
 - `tests/test_plant_base_pit.py`: Lock that account, her home, and her cafe shift

## 2026-09-28 — Ivan — branch: ivan/downtown-shelf-load

### Backend

- [x] **Save a paused five-Double Downtown baseline**
 - `scripts/plant_base_pit.py`: Fork the family baseline and place Yevgenia at Roosevelt Building with a Fifth Avenue Market shift, without starting the sim
 - `tests/test_plant_base_pit.py`: Lock that home, that job, and the village-name leak check

## 2026-09-28 — Ivan — branch: ivan/downtown-shelf-load

### Backend

- [x] **A new run reads the shared Downtown floor**
 - `reverie/backend_server/maze.py`: the shelf control defaults on; Downtown still loads in 64-tile blocks and refuses a missing block
 - `tests/test_downtown_home_walls.py`: the file-load checks keep the control off for that check
 - `tests/test_downtown_smoke_homes.py`: the file-load checks keep the control off for that check

## 2026-09-28 — Ivan — branch: ivan/downtown-shelf-load

### Backend

- [x] **Downtown can read the shared floor when the shelf control is on**
 - `reverie/backend_server/maze.py`: Downtown uses the same on/off control as the village and reads the floor in 64-tile blocks; a missing block refuses to start, then river walls apply
 - `tests/test_downtown_maze_ingest.py`: the cafe door stays on its own tile, a river tile is a wall while the picture stays open, and a missing or misplaced block refuses to start
 - `tests/test_downtown_river_walls.py`: the file-load check keeps the shelf control off
 - `supabase/db_reference.md`: Downtown tiles are on the shelf; the engine reads them only when the control is on

## 2026-09-28 — Ivan — branch: ivan/downtown-join-20-homes

### Backend

- [x] **Downtown Join offers the 20 apartments, one person each**
 - `api_gateway/app/data/maze_catalogues/downtown.json`: the 20 homes, plus PPG Cafe with the four earlier jobs
 - `api_gateway/app/services/maze_bind_catalog.py`: a listed workplace can be chosen, including PPG Cafe
 - `api_gateway/tests/test_maze_bind_catalog.py`: membership, one person per home, First & Market is a home

## 2026-09-28 — Ivan — branch: ivan/create-sim-default-downtown

### Backend

- [x] **A new sim with no maze starts on Downtown**
 - `api_gateway/app/models/simulation.py`: blank create uses `downtown`
 - `api_gateway/app/core/validation.py`: accept `downtown` and `the_ville`; a named maze is kept
 - `api_gateway/app/api/routes/simulations_mvp.py`: the empty-list bootstrap uses Downtown
 - `api_gateway/tests/test_create_sim_maze_default.py`: omitted maze is Downtown; `the_ville` is kept

## 2026-09-26 — Ivan — branch: ivan/headless-zone-center

### Backend

- [x] **A shift keeps the workplace the hour already named**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: a rejected place line and a rebuilt breakdown stay in that hour's room, and a full desk line stays at the desk

## 2026-09-26 — Ivan — branch: ivan/headless-zone-center

### Backend

- [x] **A file-loaded destination box stays on the tile the engine named**
 - `reverie/backend_server/headless_visualization.py`: the box uses the same tile-center pixel as the body, so the player reads the original tile
 - `video/record_scenes.py`: the recording copy of that conversion uses the same center

## 2026-09-26 — Ivan — branch: railway

### Backend

- [x] **The Pittsburgh headless box is on the current floor**
 - Engine floor on the VPS replaced with this machine’s downtown files; the previous floor is saved on the box
 - Headless player is the stamp build, and its eight floor files match the engine

## 2026-09-26 — Ivan — branch: ivan/pgh-vps-fixes

### Backend

- [x] **Downtown headless compares the player's stamp to the eight floor files**
 - `headless_visualization.py`: The expected stamp is the full hash of those files' raw bytes, in the player's order. A missing file does not start the run.

## 2026-09-26 — Ivan — branch: ivan/pgh-vps-fixes

### Backend

- [x] **Family day stays in real rooms and remembers only this simulation**
 - `path_finder.py`, `maze.py`: the small Water patches are walls, the same way the rivers are
 - `spatial_occupancy.py`, `location_helpers.py`, `plan.py`: a person counts as arrived only inside the destination room
 - `location_resolver.py`: the place picker will not send someone into another apartment
 - `action_contract_v1.py`: while walking, the status line names the destination
 - `retrieve_double.py`: day planning, reflection, chat, and votes read only this simulation
 - `plan.py`, hourly prompt: a task place must be one full allowed line; a second miss stays in that task’s own room; the hour list is written to the sim log
 - `headless_visualization.py`: a downtown run does not start when the player floor stamp differs

## 2026-09-24 — Ivan — branch: ivan/pgh-leaks

### Backend

- [x] **Close 21,279 outside tree and street-art cells on the local Downtown floor**
 - `environment/.../downtown/matrix/maze/collision_maze.csv`: Stamp Nicolas’s city list. Rivers, doors, and the 22 Sep rooms stay as they were. Production was not touched.

## 2026-09-24 — Ivan — branch: ivan/pgh-leaks

### Backend

- [x] **Downtown walls reach the headless player; map build is reproducible (units green, not scored)**
  - `path_finder.py` + `reverie.py`: Each downtown minute carries `no_walk` (the three rivers plus every apartment but their own home and the one they stand in). A reported walk that touches one logs `NO_WALK CROSS` and is not rejected.
  - `api_gateway` (`validation.py`, `supabase_service.py`): `GET /step` keeps `no_walk`. Before this, the validator dropped unknown fields.
  - `headless_visualization.py`: A downtown walk waits for the player's `layers: true` and is refused without it.
  - `scripts/generate_maze_registry.py`: A rebuild keeps downtown apartments private and their towers residential. It now reproduces the scored downtown file exactly, with talk mood unchanged and village output unchanged.

## 2026-09-24 — Ivan — branch: ivan/pgh-leaks

### Backend

- [x] **Pittsburgh leak fixes, Phase 1 (units green, not scored)**
  - `reverie.py` + `action_contract_v1.py`: After the movement report, the place label and `@` line are rewritten from the room the body actually landed in (movement file and Supabase row).
  - `scripts/generate_maze_registry.py`: Shop kitchen, fridge, and counter objects are built `staff_only`. The local downtown registry was patched in place, not rebuilt, because a rebuild would make apartments public.
  - `location_resolver.py` + `plan.py`: A sleep row goes to the person's own bed whichever planner path chose the place, unless the line says they sleep somewhere else.
  - `pair_encounters.py` + `conversation_manager.py`: Every minute, meeting rows for pairs who are no longer together close after the grace period. A row keeps the room it opened in, and open downtown ground counts only when the two are close.
  - `scripts/plant_base_family_pittsburgh.py` + fixture: Katya is homeschooled with an afternoon EQT shift, and Gosha takes dual-enrollment classes at Penn College. The leak check rejects Dorseyville and Fox Chapel. `base_family_pittsburgh` was re-planted and is still paused.

## 2026-09-24 — Ivan — branch: ivan/life-not-destination

### Backend

- [x] **Real life is talk, not a destination (not scored yet)**
  - `persona/cognitive_modules/location_helpers.py` + `plan.py`: The day writer's place list is only places with something to use, plus their own home and job. A daily check rewrites off-map blocks, and a school-age Double takes classes at the map's college.
  - `persona/cognitive_modules/location_resolver.py`: A final address outside that list falls back to home (`OFFMAP_DEST`).
  - `persona/prompt_template/` (day, hourly, decomp, talk, new `offmap_block_check_v1`): Life off the map stays true in talk, never a block or an off-map report. Blank day-plan items are dropped.
  - `api_gateway/app/services/chat_with_double_service.py`: Watch chat says today is only what happened here. The owner can answer plainly ("no pool here").

## 2026-09-23 — Ivan — branch: ivan/downtown-home-walls

### Backend

- [x] **A downtown home that is not theirs is a wall on the walk**
  - `reverie/backend_server/path_finder.py`: Other apartment rooms are walls. Their own home stays open. If they are already inside, they can leave.
  - `reverie/backend_server/persona/cognitive_modules/execute.py`: The walk uses that rule.
  - `reverie/backend_server/reverie.py`: A rebuilt short step uses the same rule, and a talk stays off the card once the two people are in different rooms.
  - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: Outside the block’s room, the line is the walk, including a minute the plan calls a stay.
  - `reverie/backend_server/persona/cognitive_modules/pair_encounters.py`: A hello after they part is a new meeting. The old row stays closed.
  - `tests/test_downtown_home_walls.py`: A route goes around someone else’s apartment. The picture of the map stays open.

## 2026-09-23 — Ivan — branch: ivan/straight-walk-full-step

### Backend

- [x] **A straight walk to a place keeps the full 6-tile step**
  - `reverie/backend_server/path_finder.py`: A step already inside the cap stays. A longer jump is still cut.
  - `reverie/backend_server/persona/persona.py`: The walk uses that rule, so a straight street is not split in half.
  - `reverie/backend_server/reverie.py`: The same rule on the step that gets written out.
  - `tests/test_straight_walk_step.py`: A straight 6 is kept. A 10-tile jump is still shortened.

## 2026-09-23 — Ivan — branch: ivan/trip-line-matches-walk

### Backend

- [x] **A trip line matches the direction of the walk**
  - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: While someone is still on the way, an errand becomes walking to that place. A sentence that starts as the trip stays.
  - `tests/test_action_text_sanitization.py`: Washing hands before leaving the cafe, while walking there, is the walk. The wash shows once she is in the room.

## 2026-09-23 — Ivan — branch: ivan/downtown-river-walls

### Backend

- [x] **A downtown walk stays off the three rivers**
  - `reverie/backend_server/maze.py`: When the downtown floor loads, the three river places are remembered as walls. The picture file stays open.
  - `reverie/backend_server/path_finder.py`: Every route treats those cells as walls. Someone already on the water may step onto land.
  - `tests/test_downtown_river_walls.py`: A small water strip is walked around, and Encore to Penn College touches none of the three rivers.

## 2026-09-23 — Ivan — branch: ivan/day-honors-job

### Backend

- [x] **The written day includes one shift at the job on file**
  - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: The day writer must name one shift at the workplace, with a run or a hobby around it.
  - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: The same shift sits beside the challenge and the vote.
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: The workplace passed into that day is the job on file.
  - `tests/fixtures/downtown_family_plant.json`: Ivan’s story includes O’Reilly Pub, and Katya’s includes the EQT Supply Store. The paused family baseline was updated. The finished morning was not.

## 2026-09-23 — Ivan — branch: ivan/first-market-not-home

### Backend

- [x] **First & Market is no longer a home; Katya wakes at Midtown**
  - `api_gateway/app/data/maze_catalogues/downtown.json`: The building stays on the map and is not offered as a home or a job.
  - `tests/fixtures/downtown_family_plant.json`: Katya’s baseline home is Midtown Tower, still working at the supply store. The paused family baseline was re-stamped. The finished morning was not.
  - `api_gateway/tests/test_maze_bind_catalog.py`: Claiming First & Market is rejected. A full Midtown still blocks a new resident.

## 2026-09-23 — Ivan — branch: ivan/downtown-headless-own-floor

### Backend

- [x] **Downtown headless saves a walk only on this sim's floor**
  - `reverie/backend_server/headless_visualization.py`: Refuse the minute unless the player reports downtown, 409 by 437, and open only the configured player.
  - `reverie/backend_server/reverie.py`: Wait for that report before the next minute, and do not attach a village map id.
  - `reverie/backend_server/tests/test_headless_lifecycle.py`: A village report is refused, including when no picture is taken.

## 2026-09-23 — Ivan — branch: ivan/downtown-nicolas-ingest

### Backend

- [x] **Tell the watch page which maze a finished run used**
  - `api_gateway/app/services/file_service.py`: Status includes `maze_name` from the run record. `20260923-1` is downtown.
  - `api_gateway/tests/test_simulation_meta_maze.py`: Downtown is borrowed; an explicit village name is kept.

## 2026-09-23 — Ivan — branch: ivan/downtown-nicolas-ingest

### Backend

- [x] **Lock Roosevelt, Encore, and Gateway as one apartment each**
  - `tests/test_downtown_home_splits.py`: The extra street doors stay sealed, and one walk from the remaining door covers each home.

## 2026-09-23 — Ivan — branch: ivan/downtown-nicolas-ingest

### Backend

- [x] **Move the downtown family baseline into four real apartments**
  - `scripts/plant_base_family_pittsburgh.py`: Stamp Gateway Tower, Encore on 7th, First & Market, and Six PPG Place. Keep Luba at PPG Cafe. Do not copy village memories or edit `base_family_sim`.
  - `tests/fixtures/downtown_family_plant.json`: Home, work, and start tile for each of the four.
  - `tests/test_plant_base_family_pittsburgh.py`: Expect those apartments and an open floor tile inside each door.

## 2026-09-22 — Ivan — branch: ivan/downtown-nicolas-ingest

### Backend

- [x] **Load Nicolas's Downtown rooms and furniture as the live maze**
  - `scripts/ingest_downtown_maze.py`: Copy the furniture files, keep the 20 apartments, and move four cafe meeting spots off chairs. Do not stamp Residence 1–15.
  - `tests/test_downtown_maze_ingest.py`: Expect 73 walkable cafe tiles, 868 furniture cells, and the locked doors.
  - `tests/test_downtown_smoke_homes.py`: Old sidewalk tiles stay open. They are no longer named homes.

## 2026-09-18 — Ivan — branch: ivan/waitlist-grok-pager

### Backend

- [x] **Waitlist signups can page the dedicated Grok Bot after the row saves**
 - `api_gateway/app/api/routes/waitlist.py`: after a successful save, fail-open POST of the stored fields to `WAITLIST_GROK_WEBHOOK_*` (skip if unset)
 - `api_gateway/tests/test_waitlist_endpoint.py`: page on persist; skip without secrets; pager down still 200; no page on bad email or save failure

## 2026-09-17 — Ivan — branch: ivan/sim-jobs-tier-a

### Backend

- [x] **Village LLM jobs write answers instead of thinking until the cap; Watch Chat still thinks**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: move all sim jobs to Tier A; empty Tier B list; blocked C and unknown jobs fall back to A
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Day plan and village full-talk no longer ask for Tier C



### Backend

- [x] **Already-at-place leftover `walking from … to` stickers become a stay line**
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: treat `walking from` as travel so arrived leftover emits `at {place}`
- [x] **Watch Chat splits owner / same-sim peer / stranger (prompt + memory filter)**
 - `api_gateway/app/services/chat_with_double_service.py`: owner keeps life notes and Watch Chat memory; peer gets sim-public facts only; stranger gets manner plus current act



### Backend

- [x] **Sim and Watch Chat take model and thinking only from env (one knob per tier)**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: required A/B/C model + thinking keys; drop Flash/Pro inference and the six-job allowlist
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: leftover talk jobs stay off thinking; hourly stays A; Survival B token budgets ≥500
 - `api_gateway/app/core/config.py` + `api_gateway/app/services/chat_with_double_service.py`: Watch Chat uses env B model + B thinking (no silent other model)



- [x] **Guest Chat opens to Email me a link; chips and composer stay off until www posts a session**
  - `double-front/components/persona-card/ChatTab.tsx`: gate on `getAccessToken()` at open, not after a failed send; `landing-chat-login` still asks www; empty `landing-auth` clears this Chat's resume
  - `__tests__/ChatTab.auth.test.tsx`: signed-out gate, no leftover resume, token reveals send, 401 retry still green

## 2026-09-17 — Ivan — branch: ivan/arrived-walk-sticker

### Backend

- [x] **Already-at-place leftover walk stickers become a stay line**
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: leftover `walking to {place}` while already there emits `at {place}` (person dests unchanged)
 - `tests/test_action_text_sanitization.py`: Luba-at-Hobbs leftover walk → stay; real dorm→Hobbs walk still walking

## 2026-09-17 — Ivan — branch: ivan/watch-boot-sticker

### Backend

- [x] **Watch shows bodies at Start before the day plan; leftover same-place dests keep sleep/sit stickers**
 - `reverie/backend_server/spawn_step0.py` + `reverie/backend_server/reverie.py`: write step-0 movement from planted tiles at boot (no headless, no day plan wait)
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: same-room leftover dest is not a walk; sleep/wake never become “walking to {place}”
 - `tests/test_spawn_step0.py` + `tests/test_action_text_sanitization.py`: spawn payload at planted tiles; Ivan sleep-in-dorm and already-at-Hobbs keep the planner act

## 2026-09-16 — Ivan — branch: ivan/pm-auth-b1

### Backend

- [x] **Watch Chat requires login; owners hear they are talking to their Double**
 - `api_gateway/app/core/config.py` + `api_gateway/app/core/auth.py`: Chat login is on by default; missing token returns `chat_auth_required`
 - `api_gateway/app/services/interview_profile_service.py` + `chat_with_double_service.py`: owner is the linked Double, not a finished quiz; owner prompt says yes and keeps it
 - `api_gateway/tests/test_chat_auth.py` + `test_chat_double_lore_ban.py`: 401 code and owner vs stranger prompts

## 2026-09-16 — Ivan — branch: ivan/t-e8-caption-retry


### Backend

- [x] **Watch stickers keep this minute’s act when leftover dest is a person; seek no longer writes “looking for X to talk”**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: seek still points the walk at the person, but does not overwrite the sticker text
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: a person dest never becomes a place label or a fake walk
 - `tests/test_action_text_sanitization.py` + `tests/test_social_seek.py`: 20260916-1 tape rows through the Watch sticker helper; seek leaves planner intent untouched

## 2026-09-16 — Ivan — branch: ivan/t-e8-caption

### Backend

- [x] **Watch captions: standing still is not “walking to someone”; a person name only if they actually move toward that person**
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: stand-still this step is not travel; a person dest is not a room, so it does not fake a walk; walking to a real place still says heading
 - `reverie/backend_server/reverie.py`: compare this step’s start tile to the dest tile before the caption is written
 - `tests/test_action_text_sanitization.py`: stand-still keeps making the bed; person dest does not become walking; dorm→Hobbs still headings

## 2026-09-15 — Ivan — branch: railway

### Backend

- [x] **Talk unmute live on VPS (`9354aed6`)**
 - gateway restarted idle; Breakfasts and `20260915-2` were already completed

## 2026-09-15 — Ivan — branch: ivan/w2-talk-unmute

### Backend

- [x] **Talk unmute: leftover thoughts, expired walks, dest captions, and same-room distance no longer block a cafe sit**
 - `reverie/backend_server/persona/cognitive_modules/social_will.py`: hard-stop is only sleep, gather prewindow, already chatting, or a true next-act busy
 - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: leftover/slice do not mute; same cafe is not too_far; scan uses body tiles not dest strings
 - `reverie/backend_server/persona/cognitive_modules/plan.py` + `reverie.py`: no walk-to-person redirect when already in the same room; proximity uses the tiles they stand on
 - `scripts/plant_r1_stranger_pair.py`: plant also writes the current morning plan as a cafe sit with ≥45 minutes left
 - `tests/test_conversation_manager.py` + `test_social_will.py` + `test_social_seek.py` + `test_plant_r1_stranger_pair.py` + `test_scan_pair_same_arena.py` + `test_proximity_scan_unconditional.py`: leftover, slice, same-room, seek no-op, dest-not-skip, plant schedule

## 2026-09-15 — Ivan — branch: ivan/w2-free-check

### Backend

- [x] **Wave 2.1: planted cafe pair stays at Hobbs on boot (do not snap them home)**
 - `reverie/backend_server/spawn_step0.py` + `reverie.py`: keep off-home step-0 tiles; overlay partial Supabase coords; write the step-0 map file from those tiles (do not leave a park fallback for the handshake)
 - `scripts/plant_r1_stranger_pair.py`: also write step-0 tiles for the rest of the roster so boot has a full set
 - `tests/test_spawn_step0.py`: cafe plant stays; leftover JSON homes remain for the other two

- [x] **Wave 2.1: cafe sits can talk after the nod (do not treat last night’s sleep as “busy”)**
 - `reverie/backend_server/persona/cognitive_modules/social_will.py`: “free to talk?” uses this minute’s action only
 - `scripts/plant_r1_stranger_pair.py`: require sim name; write and assert Hobbs tiles on step 0
 - `tests/test_social_will.py` + `tests/test_conversation_manager.py` + `tests/test_plant_r1_stranger_pair.py`: leftover `sleeping` day-plan row must not hard-stop a cafe sit

## 2026-09-14 — Ivan — branch: ivan/w2-talks

### Backend

- [x] **Wave 2 BE: village encounters, 90s first planning try, Watch lore ban**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: first planning try is a 90s wall-clock miss
   - `api_gateway/app/services/chat_with_double_service.py`: Watch chat bans secret-pair lore in owner and stranger modes
   - `reverie/backend_server/persona/cognitive_modules/pair_encounters.py` + `supabase/migrations/20260915120000_pair_encounters.sql`: one encounter per sit, table is SOT
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py` + `reverie.py`: hello opens the encounter; bodies decide presence; hazard + one-sided intent replace the will gate
   - `reverie/backend_server/persona/cognitive_modules/social_will.py`: linger deleted
   - `reverie/backend_server/persona/cognitive_modules/leftover.py`: leftover remembers the speaker
   - `scripts/analyze_hellos.py`: counts hellos, talks, and re-greets from a log

## 2026-09-14 — Ivan — branch: railway

### Backend

- [x] **Pager sim_code live on VPS**
   - `railway` @ `7e5525b4`: sprint Start stamps `CURRENT_SIM_CODE`; pager JSON includes `function_name`; gateway restarted healthy
   - Breakfasts stayed **completed** 999/1000 (`is_generating` false); next Start fills sim name on stall pages

## 2026-09-14 — Ivan — branch: ivan/w1.5-planning-stall

### Backend

- [x] **Pager names the sim that stalled**
   - `api_gateway/app/services/simulation_control.py`: sprint Start always sets `CURRENT_SIM_CODE` (was diagnostic-only)
   - `reverie/backend_server/reverie.py`: engine also stamps `CURRENT_SIM_CODE` at construct
   - `reverie/backend_server/persona/prompt_template/model_router.py`: webhook JSON now includes `function_name`

## 2026-09-14 — Ivan — branch: railway

### Backend

- [x] **Wave 1.5 live on VPS**
   - `railway` @ `188e9b18`: stall retry + Grok Bot pager pulled; gateway restarted healthy; Breakfasts stayed stopped @80
   - VPS `.env.local`: pager URL/key set (not in git); `LLM_MODEL_TIER_C=deepseek/deepseek-v4.1-flash`; `TIER_C_ENABLED=false`

## 2026-09-13 — Ivan — branch: ivan/w1.5-planning-stall

### Backend

- [x] **Wave 1.5 pager: Grok Bot routines webhook on 10 first-miss or 5 min pause**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: POST JSON `sim_code`/`model`/`event` with Bearer key; skip if URL unset; fail-open
   - `reverie/backend_server/tests/test_planning_stall_policy.py`: pause posts once, 10-streak posts once, stretch does not post, missing URL silent

- [x] **Wave 1.5: keep real planning answers when decomp times out or returns empty**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: empty/timeout is a miss; same model 135s, then force Tier C; 10 first-miss `ADMIN_ALERT`; 5 min pause then retry
   - `api_gateway/app/core/config.py`: OpenRouter Tier C default is now `deepseek/deepseek-v4.1-flash` (assessor follows this slug)
   - `reverie/backend_server/tests/test_planning_stall_policy.py`: stretch, timeout, C failover, pause, 10-streak alert, exhaust skip

## 2026-09-12 — Ivan — branch: railway

### Backend

- [x] **W1 backend live on VPS: skip-premiere date stamp + rename on repeat done**
 - `api_gateway/app/services/simulation_control.py` + `supabase_service.py`: fresh-sim Start auto-stamps Pittsburgh-today−1, fail-open (T-W9)
 - `api_gateway/app/services/pgh_compile.py`: idempotent done path now renames the persona (T-W3 backend half, unblocks portal fix)
 - Deploy: `railway` FF to `c2919c4c`, VPS pulled clean, gateway restarted healthy; portal greenlit to stack Meet-Continue fix on `ivan/w1-portal-funnel`

## 2026-09-12 — Ivan — branch: ivan/w1-date-and-names

### Backend

- [x] **Skip-premiere Start auto-stamps the HUD date; repeat done renames the Double (W1)**
 - `api_gateway/app/services/simulation_control.py`: Stamp start_date to Pittsburgh-today-minus-one on fresh sims, fail-open
 - `api_gateway/app/services/supabase_service.py`: Invalidate cached start info after the stamp
 - `api_gateway/app/services/pgh_compile.py`: Repeat done renames personas.name via shared helper
 - `api_gateway/tests/test_skip_premiere_stamp.py` + `test_onboard_done.py`: Date math incl. ET-midnight edge; fresh/stale/fail-open; rename on repeat done

## 2026-09-12 — Ivan — branch: ivan/wave0-chat-tier-b-caps-50

### Backend

- [x] **Watch chat runs on faster Tier B model with 50/50 caps (Wave 0)**
 - `api_gateway/app/core/config.py`: Read existing `LLM_MODEL_TIER_B` into gateway settings
 - `api_gateway/app/services/chat_with_double_service.py`: Chat LLM uses Tier B; caps 100→50 per thread and per hour
 - `api_gateway/app/services/post_chat_learning_service.py`: Drop stale no-tier-B note; assessor stays Tier C
 - `api_gateway/tests/test_chat_limits.py` + `test_chat_tier_c_kwargs.py`: Caps assert 50; new test pins chat to Tier B

## 2026-09-11 — Ivan — branch: ivan/chat-limits-100

### Backend

- [x] **Watch chat allows 100 messages per thread and 100 new chats per hour**
 - `api_gateway/app/services/chat_with_double_service.py`: Raise both caps from 25/2 to 100
 - `api_gateway/tests/test_chat_limits.py`: Caps and hourly block at 100

## 2026-09-11 — Ivan — branch: ivan/pbb-survival-empty-roster

### Backend

- [x] **Breakfasts first Start no longer ends the season because nobody was on the Survival list**
 - `reverie/backend_server/survival/controller.py`: Empty running season seeds remaining players from the current Doubles
 - `tests/test_survival_empty_roster_seed.py`: Empty roster seeds; live remaining and post-elim empty stay untouched

## 2026-09-10 — Ivan — branch: ivan/persona-name-plus

### Backend

- [x] **Step API accepts plus-address Join names**
   - `api_gateway/app/core/validation.py`: Persona names may include `+` so `GET /step/0` no longer 400s `Ip+20260809 3`
   - `api_gateway/tests/test_persona_name_validation.py`: Covers that live Breakfasts name; `@` still rejected

## 2026-09-10 — Ivan — branch: ivan/join-home-stamp

### Backend

- [x] **Join stamps the chosen home, not a cloned room**
   - `api_gateway/app/services/owned_double_host_service.py`: New scratch no longer copies another Double’s home or tile
   - `api_gateway/app/services/pgh_deploy.py`: First Join applies the picker; map sticker is written after placement
   - `api_gateway/tests/test_onboard_deploy.py`: Cloned Dorm Room 1 does not keep the pick from applying

## 2026-09-10 — Ivan — branch: railway

### Backend

- [x] **Look APIs live on production**
   - `api_gateway` on VPS: photo, look status, Join-wait, language follow (`c4b4ee8e`)
   - `requirements.txt`: pin `python-multipart==0.0.32` so photo upload can start (`6fd96b30`)

## 2026-09-09 — Ivan — branch: ivan/look-photo-sprite

### Backend

- [x] **Meet done can save the sprite pick in the same request**
   - `api_gateway/app/services/pgh_compile.py`: Optional `atlas_code` after the Double exists

- [x] **Keep the interviewer in the user's language after the first English line**
   - `api_gateway/app/services/pgh_chat.py`: After a non-English answer, do not swap in the English beat
   - `api_gateway/tests/test_onboard_chat.py`: Russian without `?` stays Russian; empty model does not become English

- [x] **Save Look photo + sprite and wait on Join until both exist**
   - `api_gateway/app/services/persona_sprite_service.py`: Store one trailer still; keep it when they change sprite
   - `api_gateway/app/api/routes/me.py`: `GET /api/me/double/look` and `POST /api/me/double/photo`
   - `api_gateway/app/services/self_serve_bind_service.py`: New Join waits with 409 until photo and sprite exist

## 2026-09-09 — Ivan — branch: pittsburgh-rooms

### Backend

- [x] **Unsplit Roosevelt / Encore / Gateway so each home is one room**
 - `double-r3f` occupancy: extra walls and extra street doors taken back; Midtown bath wall kept; shop doors unchanged
 - `tests/test_downtown_home_splits.py`: Each pad walks from its one street door; extra split doors sealed

## 2026-09-09 — Ivan — branch: ivan/portal-profiling-a2

### Backend

- [x] **Replace Pittsburgh quiz with Mini-IPIP portal prior**
   - `api_gateway/app/data/ipip_mini10_portal_v1.json`: Ten cited markers, reverse keys, situational stems
   - `api_gateway/app/services/pgh_quiz.py`: Score `6-raw` on reverse items; do not map old `pgh-*` answers
   - `api_gateway/app/services/pgh_chat.py`: Four general adult beats; first line English, then mirror
   - `api_gateway/app/services/pgh_compile.py`: Overwrite `innate` from scored means; chat fills life chapter

## 2026-09-09 — Ivan — branch: pittsburgh-rooms

### Backend

- [x] **Stamp home walls and extra street doors on Downtown**
 - `double-r3f` occupancy: Roosevelt / Encore / Gateway split into two walkable apartments; Midtown bath wall; First & Market left open
 - `tests/test_downtown_home_splits.py`: Each new door opens its own room; shop doors unchanged

## 2026-09-08 — Ivan — branch: ivan/maze-bind-catalog

### Backend

- [x] **Join uses a frozen maze home/job catalogue**
   - `api_gateway/app/data/maze_catalogues/downtown.json`: Five apartments and four workplaces; PPG is gather only
   - `api_gateway/app/data/maze_catalogues/the_ville.json`: Private rooms and walkable village jobs; no remote
   - `api_gateway/app/services/maze_bind_catalog.py`: Rank by personality; claims per sim
   - `api_gateway/app/services/pgh_deploy.py`: Deploy accepts home/job ids or auto-picks remaining apartments
   - `api_gateway/app/api/routes/onboard_pgh.py`: GET bind-options; deploy no longer writes Residence N

## 2026-09-08 — Ivan — branch: ivan/onboard-chat-resume

### Backend

- [x] **Finish compile when the model returns a blank soul**
 - `api_gateway/app/services/pgh_compile.py`: English fallback from quiz + chat if the compiler is empty
 - `api_gateway/tests/test_onboard_compile.py`: Empty model output still produces an English soul

## 2026-09-08 — Ivan — branch: ivan/onboard-chat-resume

### Backend

- [x] **Compile retries English if the first pass leaks another language**
 - `api_gateway/app/services/pgh_compile.py`: Second compile pass in English; four saved answers count as a finished chat
 - `api_gateway/app/services/pgh_quiz.py`: Load saved slider answers
 - `api_gateway/app/api/routes/onboard_pgh.py`: GET quiz; log compile rejects
 - `api_gateway/tests/test_onboard_compile.py`: Russian first pass, English retry

## 2026-09-08 — Ivan — branch: ivan/onboard-chat-resume

### Backend

- [x] **Reload returns saved chat answers; resubmit replaces them**
 - `api_gateway/app/services/pgh_chat.py`: Empty chat after answers returns the four lines; replace writes a clean transcript
 - `api_gateway/app/api/routes/onboard_pgh.py`: Chat JSON includes `answers`; body `{ answers }` updates them
 - `api_gateway/tests/test_onboard_chat.py`: Reload after complete is not a trap; replace rejects blanks

## 2026-09-08 — Ivan — branch: railway

### Backend

- [x] **Onboard chat questions arrive as one full line**
 - `api_gateway/app/api/routes/onboard_pgh.py`: Chat returns JSON, not a drip of 16-character pieces
 - `api_gateway/app/services/pgh_chat.py`: If the model’s question has no `?`, show the written beat
 - `api_gateway/tests/test_onboard_chat.py`: Cut-off “corners you in a” falls back to the full conflict question

## 2026-09-08 — Ivan — branch: railway

### Backend

- [x] **Onboard chat no longer dies on a blank interviewer reply**
 - `api_gateway/app/services/pgh_chat.py`: Fast model for the 4 questions; if the model is blank, show the next written question
 - `api_gateway/app/services/pgh_compile.py`: Meet compile uses the same fast model
 - `api_gateway/tests/test_onboard_chat.py`: Blank or failed model still advances the chat

## 2026-09-08 — Ivan — branch: railway

### Backend

- [x] **Breakfasts Join follows the sim’s maze**
 - `api_gateway/app/services/pgh_deploy.py`: Downtown still gets Downtown pads; village uses the existing join (Saturday fallback)
 - `api_gateway/tests/test_onboard_deploy.py`: Village join no longer errors as “must be Downtown”

## 2026-09-08 — Ivan — branch: breakfasts

### Backend

- [x] **Ingest item 7 — occupancy furniture is not walls**
 - `scripts/ingest_downtown_maze.py`: Pack from `double-r3f/tmp/pittsburgh-be-handoff`; cafe walkable is **95** (placeholder furniture no longer collision)
 - `tests/test_downtown_maze_ingest.py`: Cafe 95/95; former furniture cells walkable; PPG and First & Market open from the door

## 2026-09-08 — Ivan — branch: breakfasts

### Backend

- [x] **Ingest the five hollowed homes on Downtown**
  - `scripts/ingest_downtown_maze.py` pack from `double-r3f/tmp/pittsburgh-be-handoff`
  - Shop doors and cafe counts unchanged (PPG `[273, 221]`, cafe 95/91). Smoke homes stay `Residence N` until living_area bind.

## 2026-09-07 — Ivan — branch: breakfasts

### Backend

- [x] **Ingest the hollowed Downtown pack so cafe and market match the new floor**
 - `scripts/ingest_downtown_maze.py`: Expect cafe arena 95 / walkable 91, and Fifth Avenue Market door `[286, 162]`
 - `tests/fixtures/downtown_smoke_homes.json`: Residences 10–12 now walk to the new market door, not the gone `[289, 161]`
 - `tests/test_downtown_maze_ingest.py`: New gathering anchors, furniture cells, and market-door check
 - `tests/test_downtown_smoke_homes.py`: Work doors must be walkable venue doors

## 2026-09-07 — Ivan — branch: breakfasts / ivan/breakfasts-portal

### Backend

- [x] **Portal join list and add-one-email allowlist (no wipe)**
   - `api_gateway/app/services/self_serve_bind_service.py`: Append one allowlist row; list sims with public path and joined/joinable
   - `api_gateway/app/api/routes/onboard_pgh.py`: `GET /api/onboard/sims` and `POST /api/onboard/{sim}/allowlist` (caller must already be on the list)

## 2026-09-07 — Ivan — branch: breakfasts

### Backend

- [x] **Breakfasts onboard APIs: quiz, chat, compile, Deploy onto Downtown**
   - `api_gateway/app/api/routes/onboard_pgh.py`: Bearer routes for `/api/onboard/quiz`, `/chat` (SSE), `/done` (ready only), `/deploy` (join + pad)
   - `api_gateway/app/services/pgh_quiz.py`: 10-item `pgh-micro-v1` score and profile persist; does not mark ready
   - `api_gateway/app/services/pgh_chat.py`: 4-beat interviewer; first line English; then same language as the user
   - `api_gateway/app/services/pgh_compile.py`: English soul from scores + transcript; strips unearned barista/librarian jobs
   - `api_gateway/app/services/pgh_deploy.py`: Join only if maze is `downtown`; auto-pick `Downtown:Residence N`; work is not PPG Cafe

## 2026-09-04 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Re-boot Downtown so people actually walk, and keep the map on local files**
 - `reverie/backend_server/maze.py`: Downtown never loads empty cloud tiles even if maze-from-cloud is on
 - `tests/test_downtown_maze_ingest.py`: Prove Downtown still reads the 409×437 Pittsburgh files in that case
 - `scripts/_boot_downtown_walk_20260904_1.py`: Resume `20260904-1` with headless off so bodies can leave the sidewalk

## 2026-09-04 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Treat Downtown sidewalk `"0"` as open and path to PPG Cafe**
 - `reverie/backend_server/reverie.py`: Spawn and walk helpers use `is_collision_cell` so CSV `"0"` is not a wall
 - `reverie/backend_server/path_finder.py`: A* blocks `"32125"` instead of only integer `1`
 - `tests/test_downtown_smoke_homes.py`: Planted homes 1/4/7/10 reach PPG door under cap 6 on the engine grid
 - `plan.py` / `execute.py`: Same open-cell rule when picking a room tile or a nearby fallback

## 2026-09-04 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Plant `base_family_pittsburgh` as the Downtown occupancy baseline**
 - `scripts/plant_base_family_pittsburgh.py`: Fork the four family people onto maze `downtown` (homes 1/4/7/10, Luba → PPG Cafe) without copying village memories
 - `tests/test_plant_base_family_pittsburgh.py`: Leak-gate village place names out of home/work/today/plan
 - `tests/fixtures/downtown_family_plant.json`: Roster mapping for the plant

## 2026-09-04 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Downtown maze loads Pittsburgh files, not the village map**
 - `reverie/backend_server/maze.py`: Non-village mazes read local CSVs even when cloud storage is on
 - `tests/test_downtown_maze_ingest.py`: Loader stays 409×437 if village maps are offered
 - `supabase/migrations/20260904160000_downtown_maze_catalog.sql`: Catalog name `downtown` only; no tile upload

## 2026-09-03 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Downtown gather stay writes PPG Cafe, not the village Hobbs box**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Stay keep on downtown writes `Downtown:PPG Cafe:cafe` and the PPG tile box; leftover Hobbs arena remaps; village stay unchanged
 - `tests/test_gather_stay_keep.py`: Downtown stay + occupancy tests; village Hobbs stay still passes
 - `reverie/backend_server/maze.py`: Supabase downtown cafe zone is PPG tiles, not village 72–83 / 19–26
 - `reverie/backend_server/survival/controller.py`: Gathering helper annotation works on Python 3.9

## 2026-09-03 — Ivan — branch: ivan/downtown-pgh

### Backend

- [x] **Stamp 15 smoke homes on Downtown so bodies can start and walk**
  - `scripts/stamp_downtown_smoke_homes.py`: 15 walkable `Downtown:Residence N:room` street tiles near the five interiors
  - `tests/test_downtown_smoke_homes.py`: unique homes + 100-step walk to Hobbs under the 6-tile cap
- [x] **Ingest Downtown Pittsburgh as a parallel maze; village production stays on the_ville**
   - `environment/frontend_server/static_dirs/assets/downtown/`: 409×437 occupancy pack, Hobbs door `[273, 221]`, 15 cafe gathering tiles
   - `reverie/backend_server/maze.py`: load maze by name; accept 2D CSVs; do not point create-sim at Downtown
   - `tests/test_downtown_maze_ingest.py`: door, 15 anchors, cafe 40 walkable / 42 arena tiles including furniture

## 2026-09-03 — Ivan — branch: ivan/ops-rls-drain

### Backend

- [x] **Lock down backend-only tables so a leaked browser key cannot read memories or game state**
  - `supabase/migrations/20260903174000_rls_backend_tables_lockdown.sql`: enable RLS and revoke anon/authenticated grants on 12 open tables (applied on live `double-openrouter`)
  - `supabase/db_reference.md`: record the 7c lockdown in RLS posture and the migrations table
- [x] **Let a server restart finish the current sim minute instead of killing mid-step**
  - `reverie/backend_server/sim_drain.py` + `reverie.py`: SIGTERM sets a drain flag; after the current step, save and mark `stopped`
  - `api_gateway/app/services/simulation_control.py` + `api_gateway/app/main.py` + `scripts/deploy/api-gateway.service`: wait 15 minutes for drain; systemd stop timeout 960s (Hetzner unit stays HTTP `127.0.0.1:8001`)
- [x] **Box frontend restart must actually kill the old Next process**
  - `scripts/deploy/double-front.service`: `KillMode=mixed` so a leftover `next-server` cannot keep port 3000 after restart

## 2026-09-03 — Ivan — branch: ivan/gather-stay-keep

### Backend

- [x] **If they already sat the appointment, they do not walk to college before it fires**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: after replan, keep cafe address and `target_zone` when the body is already on Hobbs in the invitation hour
   - `tests/test_gather_stay_keep.py`: on-cafe keep, off-cafe no rewrite, after-resolve leave, in-cafe dest unchanged

## 2026-09-02 — Ivan — branch: ivan/overlay-lived

### Backend

- [x] **They remember sitting or missing the board, and talk from public facts**
   - `reverie/backend_server/survival/controller.py`: first-person sit/miss thoughts at challenge and vote resolve; compact public facts on scratch
   - `reverie/backend_server/survival/memory.py`: allow `vote_participated` as an event kind
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: talk context includes a public board card
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_conversation_batch_v1.txt`: speak from memory; do not force challenge/vote talk or recite overlay

## 2026-09-02 — Ivan — branch: ivan/leftover-choice

### Backend

- [x] **After a leftover, they think whether they still mean the promise**
   - `reverie/backend_server/persona/cognitive_modules/leftover.py`: keep thought the next step; drop only if the same pair later says the opposite
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: take that stance each step after leftover score
   - `tests/test_leftover.py`: keep, contradiction drop, no drop on a third person, no Survival engine words, dest and vote target unchanged

## 2026-09-02 — Ivan — branch: ivan/linger-plus-10

### Backend

- [x] **After a full sit, both people stay +10 minutes once, same place**
   - `reverie/backend_server/persona/cognitive_modules/social_will.py`: linger is once per pair and room; prints `SOFA LINGER`
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: linger at sit complete (`beat_budget` / `commitment_mint` / `no_new_pressure`); persist no longer +10 when overlap is 0
   - `tests/test_social_will.py` / `tests/test_conversation_manager.py`: once-per-sit, no linger on leave, persist overlap 0 does not extend duration

## 2026-09-01 — Ivan — branch: ivan/talk-leftover-keep

### Backend

- [x] **Phase 2B: a full sit can keep one leftover, and Survival only reads it**
  - Same pair still in the room after a fake desync keeps the open talk (`DESYNC REPAIR keep`). A sit stops at 6 unique lines (no second dump) and hard-caps at 12.
  - On a real complete (`beat_budget` / `left_arena` / `commitment_mint` / `no_new_pressure`) both agents get a leftover thought. Hello and desync reasons mint nothing.
  - Honor/break is co-presence only (due 60 steps). Survival may copy `protect|expose|mutual_in` into `alliance_commitments`. Chat never writes `vote.target`. Start-of-talk alliance LLM hook is gone.

## 2026-08-31 — Ivan — branch: ivan/pass-2-hello-quiet

### Backend

- [x] **Same sofa: one hello, then quiet until they leave; sitting long talks no longer restart as a new chat**
 - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: After a village hello, the same pair in the same room cannot greet again until someone leaves; a later long talk is still allowed if they both want it
 - `reverie/backend_server/reverie.py`: Village hellos stamp that sit; emitting a finished burst no longer wipes the partner while the sit is still open
 - `tests/test_conversation_manager.py`: Second hello on the same Hobbs sofa is quiet; leave-and-return can hello again; will can upgrade to a full talk; persist keeps the partner

## 2026-08-31 — Ivan — branch: ivan/pass-2-talk

### Backend

- [x] **Pass 2: a sofa hello stays one talk, and the standing 76-test tax is gone**
 - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: Keep greeting sits on the same sofa until someone leaves; the +10 linger still only applies to a full talk both people want
 - `tests/test_conversation_manager.py`: Same-pair hello on the same sofa does not start a second greeting
 - `pytest.ini` + `tests/`: The old 76 reds are now honest skips or updated stubs — no village walk/talk behaviour changed to silence a test

## 2026-08-29 — Ivan — branch: ivan/gather-1a

### Backend

- [x] **1-B chunk 1: an arena's activity whitelist no longer relocates a resolved address**
 - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Delete the whitelist branch of `_validate_address_post_resolution`, which walked four personas from Hobbs to campus during the challenge hour because the cafe list omits `study`; the whitelist still ranks candidates and drives the Tier-2 search, and every hard gate is untouched
 - `tests/test_named_destination_travel.py`: Retire the three cases that required the cascade to fire and add the 20260828-1 shape directly — `study` at cafe seating stays put

## 2026-08-28 — Ivan — branch: ivan/gather-1a

### Backend

- [x] **1-A chunks 3–5: fresh identity seed, travel-anchor detach fix, position-gated ritual verbs**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Restamp a survival persona's `currently` with the real day and headcount ahead of the three early returns that used to leave it on the premiere-day seed, skip `revise_identity` for survival (four LLM calls per persona that survival already overwrites), and drop the parent-scoped anchor when a travel step detaches, which is what resolved "walking to Hobbs" to the library
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: Split ritual verbs from travel verbs so taking part in a challenge or vote is gated on where the body is while travel wording stays gated on the destination
 - `reverie/backend_server/survival/controller.py`: Snapshot the season day number into persona scratch, the one fact the planner needed and could not reach

## 2026-08-28 — Ivan — branch: ivan/gather-1a

### Backend

- [x] **1-A chunk 2: restore the one-hour arrival invitation across both prompt sites**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Add one shared `_SURVIVAL_ARRIVE_LEAD_HOURS`/`_LABEL` pair at 1.0 and quote it from both the hourly calendar rule and the daily-plan fixed-events cue, which Pass 1 had independently cut to 30 minutes
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Retarget the `_in_survival_gather_prewindow` docstring at the seek pause now that the lock it described is gone, and note the lead is deliberately independent of the prompt invitation
 - `tests/test_hourly_schedule_calendar.py`: Re-point the mirrored helper and the range assertions at the one-hour window, and add a wiring test that re-reads the real source so the two prompt sites and the mirror cannot drift apart again

## 2026-08-28 — Ivan — branch: ivan/gather-1a

### Backend

- [x] **1-A chunk 1: delete the survival gather lock (caption writer + arrival freeze)**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Drop the gather-lock call site and its six helpers; keep `_in_survival_gather_prewindow` (seek pause) and the `tile_is_at_gathering` occupancy primitives the 80% gate and scoring scripts depend on
 - `tests/test_survival_gather_lock.py`: Remove the 18 lock tests; seek-pause (`test_social_seek`) and the planner wake override (`test_survival_wake_override`) keep independent coverage

## 2026-08-28 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Episode 1 closer spine is every night: alliances teach + stamp-on-photo census**
 - `video/draft_closer_tonight_vo.py` + `video/draft_tonight_scar_vo.py`: after Peak win, always speak alliances→votes and the ballot line
 - `video/nightly_scar_recipe.py`: if the Survival stamp would land on the census HUD, extend the group-photo bed to the stamp end

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Innate chat-behavior dumps become a verb; want HUD stamps any trait**
 - `video/featured_history.py`: strip “appears to be (from chat behavior)” before the who-clause
 - `video/draft_tonight_scar_vo.py`: intro is personality every night; ignore stamp `want` / Expose-Protect on the role card
 - `video/nightly_scar_recipe.py`: want HUD uses the spoken verb (ARGUES) when no named stamp matches

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Auto-gen featured intro is personality for every sim, not Ivan/Alex keywords**
 - `video/draft_tonight_scar_vo.py`: who-clause from tonight's reason, else innate `roles.trait`; never Expose/Protect/rank as intro
 - `video/summarize_cast_day.py` + `video/build_fact_ledger.py`: digest innate → `roles.trait`
 - `video/nightly_scar_recipe.py`: want HUD stamps that line (SHIPS / BUILDS), not TONIGHT

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Silent Pact intro must not say Protect when the Peak exposed**
 - `video/draft_tonight_scar_vo.py`: Protect/Expose featured lines follow the board action, not the word “Protect” in the reason
 - `video/nightly_vo_timing.py` + `video/picture_kit_jobs.py`: `exposes ` lands on the same stake window as `protects `

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Featured intro speaks personality, not Hold rank; vote tally drops “the vote splits”**
 - `video/draft_tonight_scar_vo.py`: intro is the trait that showed up today for Peak and Cost; leftover stays fallback
 - `video/draft_closer_tonight_vo.py`: `Tonight Six people name Alex.` — no empty splits line
 - `video/nightly_vo_timing.py`: new tally line still lands on the cliff/vote beat

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **ENG_ROOT auto-detect uses the live sim, not the video-extract fork**
 - `video/_env.py` + `scripts/eng_path.py` + `services/local-api/src/config.ts`: sibling lookup is `generative_agents` then `generative_agents-video`; drop `generative_agents-ivan-dev`
 - `video/test_env_load.py`: prefer live sim even when the ivan-dev folder exists

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **OpenAI TTS fallback honors OPENAI_BASE_URL from this repo `.env`**
 - `video/tts.py`: pass `OPENAI_BASE_URL` into the OpenAI client so OpenRouter keys hit the gateway, not api.openai.com
 - `video/test_tts_pronunciation.py`: assert the client is constructed with that base URL

## 2026-08-27 — Ivan — branch: ivan/mvp-pass1

### Backend

- [x] **Pass 1: same 30-min walk-in for challenge and vote, then fire at 11:00 and 20:00; honest dest text; thin town talk; skip-Premiere test start**
 - `survival/controller.py` + `plan.py`: vote gate opens at 20:00; both lock leads are 30 minutes; dinner 18:00–19:30 stays free
 - `action_contract_v1.py` + hourly calendar: no Hobbs/ritual verbs when the body is off-cafe
 - `social_will.py` + `conversation_manager.py`: full talk only when both willing; sofa persist; linger once
 - conversation batch templates: speakers never name the simulation, Doubland, or the backend
 - `skip_premiere.py` + start parameters: `skip_premiere: true` jumps to engine day 2 05:55; live starts refuse

## 2026-08-27 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Video secrets live in this repo `.env`; stop inheriting the sim `.env.local`**
 - `video/_env.py`: load this repo `.env` then `.env.local` only — never `ENG_ROOT/.env.local`
 - `video/tts.py` + `video/capture_phaser_elim.py` + `video/generate_missing_interiors.py`: call `load_video_env()` so Imagine/TTS/Phaser see this repo’s keys
 - `.env.example` + `README.md` + `eng/README.md` + `AGENTS.md`: document Imagine / ElevenLabs / OpenAI / Supabase here; `ENG_ROOT` is optional remotion fallback only
 - `video/supabase_client.py` + `video/extract_day_log.py` + `video/narration_cache.py` + `video/highlights_store.py`: error text points at `.env`

## 2026-08-26 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Closer watch-3: two-beat alliances VO, Ken Burns materialize, C4/C8 cliffs, distinct G3 extras**
 - `video/draft_tonight_scar_vo.py` + `video/draft_closer_tonight_vo.py`: restore “conversations turn into alliances / Alliances turn into votes”
 - `scripts/materialize_edit_script.py`: copy `scaleFrom` / `scaleTo` / `scaleAnimSec` onto Live cuts
 - `video/nightly_scar_recipe.py` + `video/nightly_craft.py`: weather ends before the door; seed C4/C8 for cliff beds
 - `video/auto_picture_kit.py` + `video/generate_picture_stills.py`: pick extras by look; name IMAGE_0/1/2 so Grok cannot clone seats
 - `video/tts.py`: OpenAI fallback tries `tts-1` then `gpt-4o-mini-tts` (this key still has no speech models)

## 2026-08-26 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Episode 1 closer: Peak motive, no leftover Cost heat, C1 weather, stock HUD**
 - `video/draft_tonight_scar_vo.py`: Hold why speaks rank/test; Day-1 Cost skips leftover pin-down
 - `video/nightly_scar_recipe.py`: tally on “people name”; looped C1 weather; stamp/Talk/end lockup
 - `video/run_tonight_scar.py` + `video/nightly_craft.py`: refuse dummy Live VO; seed Talk/stamp/lockup from `video/assets/nightly/`
 - `scripts/materialize_edit_script.py`: copy `loop` onto picture cuts so Live matches the bake

## 2026-08-26 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Video extracts live in double-video/data; pull from Supabase, not ENG disk**
 - `video/extract_package_facts.py`: write digest + ledger + season snapshot into the trailer package
 - `video/run_tonight_scar.py`: missing ledger extracts from Supabase; closer also writes `vo_locked.txt` sidecar for clip-kit; no ENG extra_roots fallback
 - `eng/E_CONTRACT.md`: ENG_ROOT is sim checkout only; packages + extracts are VIDEO_DATA_ROOT

## 2026-08-26 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **New video packages live in double-video/data; sim facts stay in ENG**
 - `.gitignore` + `video/_env.py`: gitignored `data/`; `VIDEO_DATA_ROOT` default; ledger search still reads ENG overview
 - `video/run_tonight_scar.py` + `video/generate_trailer.py`: new packages write here; existing ENG paths still Open
 - `video/xai_imagine.py`: `generate_still` chains when refs exceed the 3-image API cap

## 2026-08-26 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **G3/gather clones, Peak cheer-not-rank, census REMOTE home**
 - `video/xai_imagine.py`: edits API cap is 3; chain merge-3 then still+2; no silent drop
 - `video/generate_picture_stills.py` + `video/auto_picture_kit.py`: extra portraits as pass-1 refs; Peak/Cost on pass 2; HFS peak-card from ledger rank
 - `video/matrix_hud.py` + `video/census_vacant_matrix.py` + `video/nightly_craft.py`: census chips from job+place (WILLOWS), not maze REMOTE
 - `video/nightly_scar_recipe.py`: Peak win prefers `*_peak_card{rank}` over cheer/shield_win

## 2026-08-25 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Day-1 closer was later-night VO (~64s); gather stills drew metal shields**
 - `video/draft_closer_tonight_vo.py`: Survival Day 1 closer uses entered-Survival literacy, challenge teach, and Shield-gone cliff
 - `video/draft_tonight_scar_vo.py`: Peak HOLD action speaks a why-tonight even when the ledger reason is jargon
 - `video/generate_picture_stills.py`: gather/table prompts ban literal shields; leave walk is village dusk, not black-tie
 - `video/run_tonight_scar.py`: after closer TTS, keep long audio on ship/Live paths; park short as `narration_scar`
 - `video/validate_nightly_survival.py`: closer under 90s is a warning

## 2026-08-25 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Fix doubled workplace VO, unstack vote/census/weather, allowlist closer roles**
 - `video/featured_history.py`: maze `(store)` is not an Oak Hill room; collapse spoken place
 - `video/nightly_scar_recipe.py`: Shield still on the win line; census on become-line; Phaser on the cliff
 - `video/nightly_edit_script.py` + `packages/edit-script/src/warnings.ts`: closer roles on the allowlist
 - `video/render_tonight_scar_vo.py`: TTS CLI loads ENG_ROOT `.env.local`

## 2026-08-25 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Closer Episode 1 leftover still gets a weather Phaser hold**
 - `video/run_tonight_scar.py`: load ENG_ROOT `.env.local` before TTS/Imagine
 - `video/nightly_scar_recipe.py`: if unreadability sits only on Cost why-tonight, plant weather Phaser on the cliff/village line
 - `video/test_nightly_scar_recipe.py`: Episode 1 leftover unreadability still emits weather hold

## 2026-08-25 — Ivan — branch: ivan/gather-stay

### Backend

- [x] **Stay at Hobbs until that event fires; vote lock starts at 18:00; stand if seats are full**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: pin leave dests on cafe; leave in-cafe sit/stand/piano; vote window last two hours
   - `reverie/backend_server/survival/controller.py`: stamp `challenge_resolved_date` on fire and resume
   - `tests/test_survival_gather_lock.py`: stay-pin, 18:00 vote window, release stamps

## 2026-08-22 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Remaining video-gen now runs from double-video (opener + facts + capture + gold jobs)**
 - double-video/video/: F1 facts, F2 showrunner/generate_trailer, F3 OpenerTrailer, F4 capture/publish, F5 gold/cohort/highlights/L-Talks
 - Prove: double-video/video/remotion/out/opener_e_migrate_prove.mp4 (~77s). Locked Anya opener and day2/day3/day4 nightly masters were not overwritten. Rebuild still uses ENG_ROOT. Eng ideo/ left on disk.

## 2026-08-22 — Ivan — branch: ivan/headless-inject-intent-path

### Backend

- [x] **Live headless inject no longer sends last walk as this-step path**
   - `reverie/backend_server/headless_visualization.py`: strip `path` / `actual_path` after pixel normalize so FE walks from start
   - `reverie/backend_server/tests/test_headless_lifecycle.py`: pixels leftover path and tiles convert+strip

## 2026-08-22 — Ivan — branch: ivan/e-migrate-video-gen

### Backend

- [x] **Path [E] nightly gen now runs from double-video; first closer bake succeeded**
 - `double-video/video/`: ported schema, Remotion nightly stack, stock media, scar/VO/kit CLIs (slices A–D)
 - `double-video/video/nightly_edit_grammar.py`: looped `cost_leave` may cover last-words VO (cold closer gate)
 - Prove master: `data/20260724-2/trailer_ready_e_migrate_prove/output/trailer_9x16_closer.mp4` (~105s). Locked day2/day3/day4 packages were not overwritten. Post-Production Rebuild still uses `ENG_ROOT`.

## 2026-08-21 — Ivan — branch: ivan/reject-start-jump

### Backend

- [x] **Refuse movement reports that land more than 6 tiles from this step's start**
   - `reverie/backend_server/reverie.py`: measure jump from start only; do not let planned/movement or the 25-tile bar accept a blink
   - `tests/test_movement_report_start_jump.py`: reject the 23-tile and 7-tile cases; keep legal walks, stays, and mid-path cuts

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Closer tonight is the default daily; leftover heat stays on Cost why-tonight**
 - `video/tonight_sku.py` / `video/nightly_craft.py`: default SKU closer; default length-mode long
 - `video/run_tonight_scar.py`: closer auto-locks `vo_locked_long.txt` from the long writer; never `vo_locked.txt`
 - `video/draft_closer_tonight_vo.py`: no mid-body last-night vote recap (`closer_tonight_v4`)

 - `video/nightly_scar_recipe.py`: leftover census recap only if last-night vote is still a lecture; Cost why-tonight stays on habitat; loop `cost_leave` through last-words VO at 1×
 - `video/test_nightly_scar_recipe.py`: folded leftover skips G7 recap; last-words leave covers the spoken line

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Closer leftover recap keeps a picture; ballots only play on tonight's vote**
 - `video/nightly_vo_timing.py`: last-night “went home / tiebreak” before the challenge is stake, not cliff
 - `video/nightly_scar_recipe.py`: fill the leftover hole from the kit; pin G6 ballots to vote-results VO; do not loop ballots as a gap plug
 - `video/test_nightly_scar_recipe.py` / `video/test_nightly_vo_timing.py`: closer leftover + ballots window tests

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Bake Closer as a sibling MP4 so the short master stays put**
 - `video/run_nightly_survival.py`: closer writes `trailer_9x16_closer.mp4`, never `trailer_9x16.mp4`
 - `video/run_tonight_scar.py`: TTS the long lock, then restore short VO/audio
 - `video/nightly_scar_recipe.py`: weather hold matches “can't tell where”

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Daily why-tonight comes from this night's board, not a challenge slogan**
 - `video/draft_tonight_scar_vo.py`: Peak why from `choice_reason_plain` + partner (or skip); cache `tonight_scar_v8`
 - `video/draft_closer_tonight_vo.py`: last words keep the board goodbye; skip engine-clone essays; cache `closer_tonight_v3`
 - `video/build_fact_ledger.py`: persist `final_statement`, `vote_reasons`, and challenge `decisions`

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Daily VO sounds like spoken English; Closer ceiling 180s; Day 2 long lock has a true why + last words**
 - `video/draft_tonight_scar_vo.py`: why-tonight is “won't pick a side / won't lock in,” not “a read she can trust”; cache family `tonight_scar_v7`
 - `video/draft_closer_tonight_vo.py`: Peak’s stated why + Cost last words + absent-from-table; never writes the short lock
 - `video/tonight_sku.py`: Closer runtime 90–140 / warn 165 / hard 180

## 2026-08-21 — Ivan — branch: ivan/survival-realism


### Backend

- [x] **Survival: hold people on Hobbs tiles, score only who sat, stop fake cards and shield-speak**
   - Gather lock uses the actual tile, not a Hobbs address string, so people cannot walk off during the last hour
   - Challenge scoring ignores absentees (no fake cards); Lock-In is a double vote tonight, not a reputation vest
   - Overlay after resolve shows who played, the public board names, last elim, and remaining count
   - Season log records formed alliances; night writes one daily line; chat/vote prompts lead with identity and ban extra ops slang

## 2026-08-21 — Ivan — branch: ivan/closer-tonight

### Backend

- [x] **Closer tonight as a sibling SKU (`--sku closer`), not `--length-mode long`**
 - `video/tonight_sku.py` / `video/run_tonight_scar.py`: `--sku closer` uses `vo_locked_long.txt` and fails closed if that file is missing; `--length-mode` stays a composition clock
 - `video/draft_closer_tonight_vo.py`: long-lock writer with a contradiction pass; never writes `vo_locked.txt`
 - `video/nightly_scar_recipe.py` / `video/validate_nightly_survival.py`: closer weather Phaser hold; cinematic cap 5 and runtime 90–120 / 135 / 150

## 2026-08-21 — Ivan — branch: ivan/dev

### Backend

- [x] **Day 3 wave29 locked as the default later-night auto-gen**
 - `video/assets/nightly/ballots.mp4`: stock G6 so a new sim Episode 1 still gets evening ballots
 - `AGENTS.md`: do not overwrite `20260724-2` day2/day3/day4; next night uses `run_tonight_scar` + `seed_nightly_kit_from_priors`

## 2026-08-21 — Ivan — branch: ivan/dev

### Backend

- [x] **Evening vote uses G6 ballots; habitat intro is clip-only**
 - `video/nightly_scar_recipe.py`: namecard then habitat mp4 (no still freeze); vote bed is ballots/gather from “Then the vote,” with a split tally overlay
 - `video/nightly_craft.py`: seed `ballots.mp4` and draw `vote_split_board.png` on split nights
 - `video/build_nightly_remotion_props.py`: drop the hidden C1 world_plate under the vote

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **Featured intros always include why-tonight, not only job+place**
 - `video/draft_tonight_scar_vo.py`: later nights speak Peak then Cost job+place plus a motive/leftover line; skip leftover if the ledger has no fact
 - `video/nightly_scar_recipe.py`: want HUD sits on that second line (not only Day-1 “plays for cover”)
 - `video/picture_kit_jobs.py`: G1/G2 want_clause follows the spoken why-tonight line

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **Every Double intro uses their own workplace and job task**
 - `video/habitat_lock.py`: job+place keywords map to a Ville interior plate and a busy-at-work clause (not a Hobbs/library special case)
 - `video/picture_kit_jobs.py`: kit files use full-name slugs; G1/G2 refs are face + that workplace plate
 - `video/generate_picture_stills.py` / `video/auto_picture_kit.py`: habitat prompt is the job action on the staged empty interior
 - `video/nightly_scar_recipe.py`: habitat clip gets airtime; teach cards follow spoken lines; vote gap is black, not the wrong store
 - `video/draft_tonight_scar_vo.py` / `video/nightly_vo_timing.py`: later nights speak “That's the challenge. Then the vote.” as a separator, not Peak

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **Later-night trailer pictures follow that night’s VO**
 - `video/draft_tonight_scar_vo.py`: speak Peak then Cost job+place every night; never “is back”; Alliance Lock-In turn beats a weak picker one-liner
 - `video/nightly_vo_timing.py`: first contiguous scar window; teach/peak/census keywords for later nights
 - `video/nightly_scar_recipe.py`: Peak/Cost plates stay on intro lines; challenge clip covers the full teach; Day-1 HUD only when VO says it
 - `video/run_tonight_scar.py`: `--replace-vo-lock` rewrites that package’s lock and re-TTS


 - `video/draft_tonight_scar_vo.py`: speak Doubles + computed N; reject a wrong remaining-count; Peak returnee is “is back”
 - `video/run_tonight_scar.py`: auto-lock `vo_locked.txt` when missing; never overwrite an existing lock
 - `video/test_draft_tonight_scar_vo.py`: Day 3 sibling priors → Thirteen / twelve; “fourteen remain” rewrite

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **G7 identity-card census auto-gens on every later night**
 - `video/nightly_craft.py`: collect prior boots from sibling packages; render Remotion `CensusMatrix` stills into the E bin (skip stale mock copy)
 - `video/census_vacant_matrix.py`: bake helper writes CensusMatrix stills; missing portraits raise ValueError
 - `video/build_fact_ledger.py`: that night’s challenge_results row beats live `active_challenge_id`; Alliance Lock-In teach is double vote, not a reputation shield

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **G7 census cards go into the Day 2 bake (not grey-wash)**
 - `video/nightly_scar_recipe.py`: prefer `census_matrix_pre/post.png`; Alex disconnects after a short hold; leftover stays on C1
 - `video/nightly_craft.py`: copy signed stills from `g7_vacant_mock` into the E bin
 - `video/test_nightly_scar_recipe.py`: Day 2 kit with both grey plate and census stills uses the cards

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **G7 disconnected tile uses the founder silhouette still**
 - `video/remotion/src/components/MatrixIdentityCard.tsx`: gone portrait well is `disconnected_silhouette.jpg`, not a drawn SVG
 - `video/remotion/public/disconnected_silhouette.jpg`: founder still copied for Remotion
 - `video/assets/nightly/disconnected_silhouette.jpg`: same still kept with other nightly stock

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **G7 census matches Anya’s identity-card grid (no bake)**
 - `video/remotion/src/components/MatrixIdentityCard.tsx`: cyan HUD card; gone = fused silhouette + DISCONNECTED + empty SYNC (not red OFFLINE, not a hole)
 - `video/remotion/src/components/MatrixIdentityGrid.tsx`: `CensusMatrix` fills the phone; quiet `14 → 13` on the post frame
 - `video/census_vacant_matrix.py`: members follow seat_map C→B→A; Vincent disconnected first, Alex is the only tile that changes

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **G7 vacant-seat mock (15-cell portraits, no bake)**
 - `video/census_vacant_matrix.py`: 15 locked  cells; gone = empty + floor mark; tonight is the only seat that empties; quiet `14 → 13`
 - `video/test_census_vacant_matrix.py`: vacant is not the portrait; Alex empties only on the post frame

## 2026-08-20 — Ivan — branch: ivan/dev

### Backend

- [x] **Elim grey ovals stay on that Double only — not the neighbors**
 - `video/nightly_craft.py`: head-and-shoulders seat ovals; drop the extra grey halo that washed into the next row
 - `video/test_nightly_craft.py`: ovals stay in their row band; greying Vincent does not tint Owen’s face sample

- [x] **Hook group photo stops when the 15→14→1 HUD starts**
 - `video/nightly_scar_recipe.py`: `hook_census_bed` ends at countdown start so the cast plate does not show through the HUD
 - `video/test_nightly_scar_recipe.py`: bed end matches HUD start on the “voted out every night” line

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Episode 1 of a new sim gets the 15→14→1 countdown from tracked stock**
 - `video/nightly_craft.py`: seed `census_15_to_1.mp4` from `video/assets/nightly/` when there is no prior night kit
 - `video/nightly_scar_recipe.py`: prefer the countdown mp4 over a G7 still or ballots
 - `video/assets/nightly/census_15_to_1.mp4`: Anya HUD clip checked into eng assets

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Day 2: 15→14→1 census HUD, Vincent+Alex grey plate, leftover flyover keeps moving**
 - `video/nightly_craft.py`: copy census HUD + prior grey plate from the previous night’s kit; grey tonight’s Cost on top
 - `video/nightly_scar_recipe.py`: leftover-heat uses C1 (not the 3s Village freeze); door flyover loops
 - `video/build_nightly_remotion_props.py`: seed those kit files before the cold recipe runs

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Hook census uses the 15→14→1 countdown HUD, not ballots-in-bowl**
 - `video/nightly_scar_recipe.py`: resolve `census_15_to_1.mp4` from kit E / nightly public; never stage ballots on “until one remains”
 - `video/test_nightly_scar_recipe.py`: HUD present → countdown dest; HUD missing → do not steal ballots.mp4

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Day 2: Irene habitat clip, Alex on the vote line, picture under leftover-heat cliff**
 - `video/nightly_scar_recipe.py`: vote bed uses Cost habitat (not group photo); leftover-heat VO gets Village, not Shield-is-gone cards
 - `video/auto_picture_kit.py`: generated `irene_habitat.mp4` from the G1 still

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Day 2 cold: Irene/Alex intros, Silent Pact cards on the spoken line, leave clip not used as a plug**
 - `video/nightly_scar_recipe.py`: intro matches `Name is a`; Silent Pact crops the card the VO names; Cost leave is this night’s file only
 - `video/build_nightly_remotion_props.py`: named media miss returns none — do not steal the first leftover mp4
 - `video/draft_tonight_scar_vo.py`: next teach VO follows steps_board top to bottom (Protect → Both Expose → One Exposes)

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Phaser elim capture is on by default; ship halts if local FE/API/sim is down**
 - `video/capture_phaser_elim.py`: probe `:8001` + `:3000` + sim step JSON before Playwright; missing Cost/white frame is a fail
 - `video/run_nightly_survival.py`: `--capture-phaser-elim` default on; stop the nightly if capture is not captured/reuse
 - `video/run_tonight_scar.py`: same default on the daily N6 command

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Silent Pact cold kit: cafe G3 (not card table), VO-synced Peak, later-night habitats**
 - `video/picture_kit_jobs.py`: G3 is challenge_bodies unless Hold-for-Shield; workplace/want come from the locked VO
 - `video/auto_picture_kit.py`: G3/G4 i2v prompts follow the challenge; do not hydrate Day 1 gather into a new game
 - `video/nightly_vo_timing.py`: Silent Pact teach/Peak beats; “ballot” alone is not the Door
 - `video/nightly_scar_recipe.py`: cap Phaser elim bridge at 3.4s; fill the rest with ballots

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Later-night intro: “Survival mode” + drop empty follow teaser**
 - `video/draft_tonight_scar_vo.py`: census scar says Survival mode; later nights skip “following two of them” (Day 1 keeps it)
 - `video/test_draft_tonight_scar_vo.py`: Day 2 kit requires Survival mode and no follow teaser

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Later-night intro names Survival when the night is Survival**
 - `video/draft_tonight_scar_vo.py`: census scar folds to “still in Survival” + “someone is voted out every night”
 - `video/test_draft_tonight_scar_vo.py`: Day 2 kit requires Survival in breath two; still skips the Day-1 “entered until one remains” essay

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Later-night VO kit B: same Doubles concept line every night, then census scar**
 - `video/draft_tonight_scar_vo.py`: later nights speak Day-1 Doubles clause; skip Survival essay; cache family `tonight_scar_v4`
 - `video/test_draft_tonight_scar_vo.py`: Day 2 template starts with Doubles + “Fourteen still in.”

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Later-night VO: spoken scar + specific cliff; Day-1 keeps generic elim pulse**
 - `video/draft_tonight_scar_vo.py`: scar_chip.spoken opens later nights; open_question replaces “another Double will leave” after Day 1
 - `video/test_draft_tonight_scar_vo.py`: Survival Day 2 template has census scar, leftover question, no generic pulse

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **Phaser elim Option C: FE capture of this night’s Cost, not flyover / Anya plate**
 - `video/capture_phaser_elim.py`: Playwright `?recording=true` still at last in-world vote step → `F_phaser/{cost}_leave_phaser.png`
 - `video/nightly_scar_recipe.py`: prefer Cost leave-phaser still over `signature_flyover` for `cost_phaser_bridge`
 - `video/run_nightly_survival.py`: opt-in `--capture-phaser-elim` (needs local FE + API)
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1.9 cold bake; Wave 1.8b archived `*_wave20.mp4`

## 2026-08-19 — Ivan — branch: ivan/dev

### Backend

- [x] **G3 teach: card backs only — Peak owns the winning numeral**
 - `video/generate_picture_stills.py`: `challenge_table` prompt forbids readable ranks (backs / inward)
 - `video/auto_picture_kit.py`: G3 i2v keeps backs; JPEG-named-png coerce; `--challenge-table` still-only regen
 - `video/picture_kit_jobs.py`: G3 notes lock Peak-owns-numeral grammar for later nights
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1.8b cold bake (~98s); Wave 1.8 face-up archived `*_wave19.mp4`

## 2026-08-18 — Ivan — branch: ivan/dev

### Backend

- [x] **Wave 1.8: five unique Doubles at the challenge table (not two Alexis)**
 - `video/generate_picture_stills.py`: G3 `challenge_table` prompt; refs are peak + cost + extras strip only (no duplicate face glob)
 - `video/auto_picture_kit.py`: `--challenge-table` stages 3 remaining cast faces and regen 12s kit clip (not imported)
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1.8 cold bake; Wave 1.7 archived `*_wave18b.mp4`

## 2026-08-18 — Ivan — branch: ivan/dev

### Backend

- [x] **Wave 1.7 watch-fix: poster photo, cafe→table split, no village blink, votes 2×**
 - `video/build_nightly_remotion_props.py`: Poster shows group photo; C1 village plate starts at cliff, not under peak/Talk
 - `video/nightly_scar_recipe.py`: Cafe then table-cards; matte from peak end; votes zoom 2.0→1.0
 - `video/auto_picture_kit.py`: G3 table clip i2v 12s (kit, not imported)
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1.7 cold bake (`--snapshot-tag wave17`)



### Backend

- [x] **Wave 1.6 alliances + Wave 2 kit pictures (longer gather/win, card-11 proof)**
 - `video/nightly_scar_recipe.py`: Talk-only + 1.4×/stronger zoom; text-only votes; black matte; peak prefers kit `*_peak_card11`
 - `video/auto_picture_kit.py`: gather i2v 15s, win 8s, kit-owned card-11 still+clip (`--only-clips` / `--peak-card`; not imported)
 - `video/remotion/src/DailyGoldReplay.tsx` + Live port: full-frame black matte under alliances; drawn votes sit on black
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1.6+2 cold bake; Wave 1.5 archived `*_20260818_202751_wave16.mp4`



### Backend

- [x] **Wave 1.5 leftover assembly (quieter loading, loop cafe, split alliances, walk-then-grey, shorter end)**
 - `video/nightly_scar_recipe.py`: Drop bad challenge overlay; loop gather at 1x; speed-to-fit win clip; split alliances + zoom; flyover fills 01:12 hole; walk on “is gone” then grey; one picture per cliff line
 - `video/nightly_craft.py` + `video/remotion/src/DailyGoldReplay.tsx`: Loading Lag 0.14; end lockup 1.6s; picture layers honor `loop`
 - `video/test_nightly_scar_recipe.py`: Wave 1.5 timing/src regressions

- [x] **Wave 1 cold recipe hygiene (no chat-through-door, no stacked intros, no freeze/flash, loading SFX covers poster)**
 - `video/nightly_scar_recipe.py`: Sequential namecard→still→video; gather spans full teach with speed-to-fit; step bands start on rules phrase; elim uses 3.4s flyover; Talk bed ends before door
 - `video/build_nightly_remotion_props.py`: Loading Lag loops across poster hold and blends into the opener hit
 - `video/test_nightly_scar_recipe.py` + `video/test_build_nightly_remotion_props.py`: Regression tests for the six hygiene checks
 - `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4`: Wave 1 cold bake (~102s); polish snapshot `*_003937_e1_cold.mp4` untouched



### Backend

- [x] **[C] polish→learn E1: promote 8 priors + cold nightly without polish**
   - `video/nightly_craft.py`: E1 constants (scan/wipe/badges/want_cost/door/music duck/end_lockup hold)
   - `video/nightly_scar_recipe.py` + `build_nightly_remotion_props.py` + `run_nightly_survival.py`: wire priors; `--ignore-edit-script` cold path; group_photo exact resolve
   - `data/20260724-2/trailer_ready_day2/output/trailer_9x16_e1_cold.mp4` + `E1_COLD_VERIFY.md`: cold bake evidence (no VO/fact regression)

- [x] **[C] polish→learn E0: rough vs polish diff report only (prd §22.2)**
   - `video/polish_learn.py`: Diff cuts/SFX/FX/poster/captions/VO; tag promote_candidate | package_only | do_not_touch; CLI + markdown/JSON report
   - `video/test_polish_learn.py`: Unit tests for tags, music-duck split, report I/O
   - `data/20260724-2/trailer_ready_day2/polish_learn_e0/`: E0 report on prefer rough snapshot (no recipe writes; stop for founder pick)

## 2026-08-11 — Ivan — branch: ivan/dev

### Backend

- [x] **Opener photo→matrix wipe: stack + delay fix; wipe fields survive Rebuild**
 - `data/20260724-2/trailer_ready_day2/edit_script.json`: Matrix track 1 / photo track 2, wipeDelay 0.1, -0.1→6s; dropped opener photo dupes
 - `video/nightly_edit_script.py`: Pass `wipeDown` / `wipeDelaySec` through apply
 - `video/build_nightly_remotion_props.py`: Only early cast plates get pulled under poster hold
 - `video/test_nightly_edit_script.py`: Wipe fields round-trip on apply

## 2026-08-07 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix broken 4-byte `ivan_leave_phaser.jpg` stub that crashed Remotion mid-encode**
 - `video/remotion/public/nightly_survival/ivan_leave_phaser.jpg` + day2 `clip_kit/bins/F_phaser/`: Restored real JPG from `20260713-1` kit; Rebuild completed (~96.7s)

- [x] **Polish edit_script softens hero-hold gates so Rebuild ships Live holds**
 - `video/validate_nightly_survival.py`: Demote hero-hold/layer errors to `polish:` warnings when `edit_script.json` exists
 - `video/test_run_nightly_survival.py`: Long `cast_photo` fails without polish; warns+passes with polish
 - `AGENTS.md`: Note polish Rebuild soft hero-holds

## 2026-08-07 — Ivan — branch: ivan/dev

### Backend

- [x] **Live↔Rebuild media parity: resolve nightly_survival + sim_cache shelves so soft-miss cuts ship**
 - `video/nightly_edit_script.py`: Shared resolve ladder (`sim_cache/picture|cohort`, bins, gold_replay + nightly_survival, cohort cast plates)
 - `video/test_nightly_edit_script.py`: Tests for survival basename + sim_cache picture/cohort aliases

## 2026-08-02 — Ivan — branch: ivan/affordance-required-loader-plumb

### Backend

- [x] **Plumb maze registry `affordance_required` into loaded object meta (piano/mic gates were starved)**
 - `reverie/backend_server/maze.py`: Copy `affordance_required` in `_load_registry` object_meta
 - `tests/test_maze_registry_loader_contract.py`: Real-loader piano/mic True + getter↔JSON contract + post-validate leave piano on mismatch

## 2026-08-02 — Ivan — branch: railway

### Backend

- [x] **Agent rules cleanup: AGENTS.md domain-only + coding-conventions aligned to Vercel simplicity principles**
 - `AGENTS.md`: Pointer to coding-conventions; trimmed stale Recent Learnings; dual-import gotcha clarified
 - `.cursor/rules/coding-conventions.mdc` (+ `.md` mirror): Engineering principles section matches Vercel wording; kept dual-import + schema-migration exceptions

## 2026-08-01 — Ivan — branch: ivan/pass-a-place-social

### Backend

- [x] **Pass A place+social: place-claim defer, piano parity leaks, chat end-path CD + analyzer honesty**
 - `location_resolver.py`: Defer bathroom/bed/home/kitchen place-claims past GUARD; affordance gate on anchor-first; post-validate drop piano→arena on failed remap
 - `conversation_manager.py`: Floor end-path CD at ≥5 after cafe mod (stops 5−2→3)
 - `reverie.py`: Stable `conversation_id` on greetings
 - `analyze_sim_realism.py`: Pair/step merge for missing conv-ids (gap=0 inflation)
 - Units: travel-defer / affordance / cooldown unification green


## 2026-07-31 — Ivan — branch: ivan/dev

### Backend

- [x] **Tonight's Scar founder notes v3: wipe continuity, habitats, Hobbs crowd, loading SFX**
 - `DailyGoldReplay.tsx` + nightly props: chrome-only poster; cast underlay + delayed wipe; quieter `loading-lag.wav` ~0.3s
 - `nightly_scar_recipe.py`: semi-transparent LIVE/ACTIVE; stamp crop; still→video habitat crossfade; Alexis WANT = PLAYS FOR COVER
 - `build_nightly_remotion_props.py` + craft: gold cohort matrix (no rebuild); world plate after challenge; Hobbs crowd regen

## 2026-07-31 — Ivan — branch: ivan/dev

### Backend

- [x] **Tonight's Scar polish v2: progressive matrix wipe, habitats, challenge gather, Talk end**
 - `video/remotion/src/DailyGoldReplay.tsx`: Thin loading bar + blue wipe line on photo→matrix
 - `video/nightly_scar_recipe.py` + `nightly_edit_grammar.py`: Wipe/stamp/Peak win video timing; hold-gate exemptions
 - `video/picture_kit_jobs.py` + `auto_picture_kit.py`: Hobbs gather + Peak win clip jobs; force regen no longer skips stills
 - Re-rendered `20260724-2` Day-1 long nightly (~99s) with Talk.mp4 end bed

## 2026-07-31 — Ivan — branch: ivan/mvp-residual-pass

### Backend

- [x] **MVP residual pass: piano reseat, travel-guard defer, chat CD floor, Talk status coerce, dorm @ honesty**
 - `reverie/.../location_resolver.py` + `plan.py`: Affordance Tier-1b in-arena repick; contract/sticky reject piano; travel-like GUARD defer
 - `reverie/.../conversation_manager.py`: Repeat same-pair CD floor ≥5 after cafe liveliness
 - `api_gateway/.../post_chat_assessment_validator.py`: Coerce missing/invalid assessor `status` for Path A
 - `action_contract_v1.py` + analyzers: Dorm `@` gate on presence only; survival R8 + incomplete vote window

## 2026-08-01 — Ivan — branch: railway

### Backend

- [x] **Local A/B harness for Tier B Flash vs 0731 on real sim LLM captures**
 - `scripts/ab_tier_b_flash_0731.py`: Extract Tier B complex prompts from `logs/llm`, replay baseline vs `deepseek-v4-flash-0731` no-reasoning
 - `tests/test_ab_tier_b_flash_0731.py`: Offline scoring/request-shape tests (no live API)

## 2026-07-31 — Ivan — branch: ivan/chat-gateway-tier-c-pro

### Backend

- [x] **Chat with Double uses OpenRouter Tier C (DeepSeek V4 Pro) without enabling sim Tier C**
 - `api_gateway/app/core/config.py`: OpenRouter default for `LLM_MODEL_TIER_C` is `deepseek/deepseek-v4-pro`
 - `api_gateway/app/services/chat_with_double_service.py`: OpenRouter request shape (`max_tokens` + Pro reasoning)
 - `api_gateway/app/services/post_chat_learning_service.py`: Assessor reuses the same Tier C kwargs helper
 - `api_gateway/tests/test_chat_tier_c_kwargs.py`: Covers OpenRouter Pro/Flash vs OpenAI rollback kwargs

## 2026-07-31 — Ivan — branch: ivan/dev

### Backend

- [x] **Tonight's Scar polish: VO two-of-them + gold-intensity cut grammar + picture clips**
 - `video/draft_tonight_scar_vo.py` + scar recipe: Peak-then-Cost intro; clean photo→matrix scan; Phaser 2×; stamp on Survival mode
 - `video/picture_kit_jobs.py` + `auto_picture_kit.py`: G1/G2/G5 i2v clips; cast-face G3; tie board; seat grey-out
 - `video/nightly_craft.py` + validate: tie plate, seat grey helper, Phaser speed gate
 - Re-locked/re-rendered `20260724-2` Day-1 long nightly (~97s)

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **VO-timed nightly scar cuts (short holds; no full-film stills)**
 - `video/render_tonight_scar_vo.py`: Line-pause TTS so narration timing is multi-segment
 - `video/nightly_vo_timing.py` + `nightly_scar_recipe.py`: Expand monolithic timing; clamp hero layers to ≤3s VO cues
 - `video/nightly_edit_grammar.py` + `validate_nightly_survival.py`: Fail stretched hero stills; tests cover expand + layer hold
 - Rebuilt/rendered `20260724-2` Day-1 long nightly (~97s, 41 layers) after re-TTS

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix interior gen: no exterior style refs; House6 single beds; classroom no mannequins**
 - `video/generate_missing_interiors.py`: Drop exterior `_style_frame_master`; mannequins only for Supply; House6/classroom captions
 - Regenerated: house1–3 mains, artist studio2, house6 main bed, college classroom

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Re-gen 18 interiors with Phaser view-conversion (keep preferred Supply)**
 - `video/generate_missing_interiors.py`: Default = convert Phaser→eye-level; omit maze LAYOUT when Phaser present; `--dests` / `--exclude`
 - `video/assets/village/interior/`: Regenerated 18 plates; priors in `_pre_phaser_view_batch/`; `supply_int.png` unchanged

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Rollback Supply width-first pass; keep preferred plate**
 - `video/assets/village/interior/supply_int.png`: Restored from `supply_int_pre_width_pass.png`
 - `video/generate_missing_interiors.py`: Reverted to Phaser-caption + Phaser/style stack (no proportion-ref / 50mm defaults)

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Supply Store width-first pass (scalable proportion defaults)**
 - `video/generate_missing_interiors.py`: Shared 50mm/width≥depth camera; archetype proportion refs (e.g. cafe dining); Phaser+style+proportion stack
 - `video/assets/village/interior/supply_int.png`: Regenerated; prior as `supply_int_pre_width_pass.png`

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Supply Store third pass: Phaser caption + view-conversion (no maze LAYOUT fight)**
 - `video/generate_missing_interiors.py`: `PHASER_LAYOUT_CAPTIONS` for `supply_int`; maze LAYOUT omitted; Phaser+style only
 - `video/assets/village/interior/supply_int.png`: Regenerated; prior as `supply_int_pre_phaser_caption.png`

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **N5 Supply Store regen: Phaser-first layout, no three-wall shoebox**
 - `video/generate_missing_interiors.py`: Phaser as IMAGE_0; explicit layout roles; anti-shoebox camera; `--force --only` re-gens on-disk plates
 - `video/assets/village/interior/supply_int.png`: Regenerated; prior saved as `supply_int_pre_layout_fix.png`

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **N5 interior API auto-gen: edits client + missing-plate runner**
 - `video/xai_imagine.py`: Real `/v1/images/edits` multi-ref (≤3); stills with refs route to edits
 - `video/generate_missing_interiors.py`: Plan/generate 19 missing empty interiors from maze + Phaser + style
 - `video/assets/scripts-prompts/generate_interior_prompts.py` + `generate_room_inventory.py`: Disk-honest TODO; house Phaser aliases (`houseN.png`)

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **VO auto-gen: Day-1 role intros + vote tiebreak; scar TTS 1.5×; F_phaser stage**
 - `video/draft_tonight_scar_vo.py` + `build_fact_ledger.py` + `featured_history.py`: Role cards + `tie_then_tiebreak` safe_vo for drafts
 - `video/render_tonight_scar_vo.py` + `tts.py`: Scar voice profile @ 1.5× for locked VO
 - `video/build_clip_kit.py`: Stage `signature_flyover` into F_phaser; skip same-file narration copy

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **N6 one-command Tonight's Scar → nightly (human check = final MP4)**
 - `video/run_tonight_scar.py`: Wrapper — ledger + Peak/Cost + locked VO → clip_kit (auto picture) → nightly
 - `video/test_run_tonight_scar.py`: Orchestration tests (draft-only stop; kit+nightly mocks)

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **N3 auto picture kit: G1–G5 + G8 stills, G3 i2v, sim cache reuse**
 - `video/auto_picture_kit.py`: Orchestrate refs → cache hydrate → stills → READY → G3 i2v → promote cache
 - `video/xai_imagine.py`: Add grok-imagine-video i2v (poll `/v1/videos/{id}`)
 - `video/build_clip_kit.py` + `run_nightly_survival.py`: CLI `--auto-picture` / `--require-picture-ready` default on
 - `video/picture_kit_jobs.py`: G8 priority A; G3_clip required for N3 motion bar

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Restore challenge teach packs + track video/assets; regenerate Soul15 seat_map**
 - `.gitignore`: Drop blanket `video/assets/*` ignore so challenge/cohort plates cannot vanish from git again
 - `video/assets/challenges/`: Restore all 14 teach packs (title/steps/immunity) from Cursor assets cache
 - `video/assets/cohort/soul15_seed_20260224/seat_map.json`: Regen v4.0 C→B→A (Ivan 3.3 / Nick 1.3); utf-8-sig load in `nightly_craft.py`
 - `video/fly-over/COMMISSION_cinematic_pack.md`: Add missing interiors + Phaser crop re-gen list for founder

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Day-1 founder polish A (edit-script path; VO lock held)**
   - `video/assets/edit_scripts/20260713-1_day1_gold_sync.json`: Music from 0, poster 1s, Phaser 2×, habitat bright, objective split, clean→elim group, end trim + craft fx/sfx
   - `video/remotion/src/DailyGoldReplay.tsx`: Loading bar poster, blue wipe / grey veil FX, pre-poster audio wall time
   - `video/build_nightly_remotion_props.py` + `nightly_edit_script.py`: Pass cut speed; script fx/sfx; music under poster; picture-timed energy hits
   - `data/.../trailer_9x16.mp4`: Long remaster (~89.2s) tagged founder_polish_A; VO still two clips @ 1.01

## 2026-07-30 — Ivan — branch: ivan/travel-anchor-destination-authority

### Backend

- [x] **Travel acts keep the named destination; stray anchors can no longer yank people across town**
 - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Block uncorroborated cross-sector repair/anchor-first; partial-name sector shortcircuit
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Orphan-anchor redirect respects travel named dest
 - `tests/test_travel_anchor_destination_authority.py`: Willows/Oak Hill vs park-garden regressions + healthy common-room corroboration

## 2026-07-30 — Ivan — branch: ivan/dev

### Backend

- [x] **Merge Day-1 VO sync to ivan/dev; re-render + verify spoken-word lockstep**
 - `video/nightly_edit_script.py`: Prefer clip_kit / Anya-legend over corrupt staged media; space↔underscore hint match
 - `video/build_nightly_remotion_props.py`: Fall back to `nightly_survival` when `gold_replay` public is missing
 - `data/.../trailer_9x16.mp4`: Long remaster (`edit_script_vo_sync`); VO wall delta vs gold median **0.00s** (±0.01)

## 2026-07-30 — Ivan — branch: ivan/day1-gold-vo-sync

### Backend

- [x] **Day-1 gold VO sync: honor edit-script vo[] + caption/role repairs**
 - `video/nightly_edit_script.py`: Optional `vo[]` validation, `get_script_vo_clips`, expanded `CANONICAL_ROLES`
 - `video/build_nightly_remotion_props.py`: Multi-clip VO + music `startSec` from edit script (not gold 0.658 mix)
 - `video/extract_gold_edit_script.py`: Extract `vo[]`/`music` from gold props; force VO gain 1.0
 - `data/20260713-1/trailer_ready_day2/edit_script.json`: Must #1–#5 vo, captions, cuts, roles
 - `video/assets/edit_scripts/20260713-1_day1_gold_sync.json`: Canonical copy synced with package edit script
 - `.gitignore`: Allow tracking of `video/assets/edit_scripts/**` so the Day-1 gold sync JSON can ship

## 2026-07-29 — Ivan — branch: ivan/survival-reward-lifecycle-fix

### Backend

- [x] **Survival vote rewards expire same night; elim phantoms cannot haunt later tallies**
 - `survival/rewards.py`: Nightly clear drops `expires_day == today`; weight/phantom queries filter by day
 - `survival/controller.py`: Tally weights/phantoms over living players only; sweep all states nightly
 - `survival/voting.py`: Zero-weight ballots omit 0.0 rows from the public tally
 - `video/build_fact_ledger.py`: Alliance/Heist/Pool/Whisper teach copy matches locked magnitudes
 - `tests/test_survival_challenges.py`: Regression for same-night expiry, no cross-day stack, silenced ballot board

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Day-1 gold edit script (sync bar) — extract + nightly prefer**
 - `video/nightly_edit_script.py`: Schema v1, validate/apply, role map + anti-leak stage names
 - `video/extract_gold_edit_script.py`: Gold props → `assets/edit_scripts/20260713-1_day1_gold_sync.json` (50 cuts)
 - `video/build_nightly_remotion_props.py`: Prefer package `edit_script.json` over scar recipes; long re-render

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Nightly Must M1–M12 edit grammar (expert level-up)**
 - `video/nightly_scar_recipe.py`: VO-locked Scar recipes — ≤3s heroes, hook census, stake order, Peak portrait, Phaser elim bridge, NEW TARGETS
 - `video/nightly_edit_grammar.py`: Episode=season day; syllable captions; hero-hold + caption-lock validators
 - `video/build_nightly_remotion_props.py` + `validate_nightly_survival.py`: Wire recipes/gates; Day-1 long re-render

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Nightly energy pass — denser SFX/FX, key-phrase CC, Anya WANT plates**
 - `video/nightly_vo_timing.py`: Key-phrase captions only (drop full-VO dump); soft highlight band 10–22
 - `video/nightly_hud.py`: Day-1 want plates staged as want_peak/cost_hud; anti-leak allows neutral dest names
 - `video/build_nightly_remotion_props.py`: ~23 SFX + more FX on cuts; stacked stake/world; long re-render

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Shared Survival Pool commissioned — catalog teach bank complete**
 - `video/assets/challenges/shared_survival_pool/manifest.json`: status `commissioned`
 - `sot/sot_challenges.md` §5.15: Specimen; §5.2–§5.15 locked slate teach packs done

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Shared Survival Pool: hold ×2; break = half + greed +2**
 - `reverie/backend_server/survival/challenges.py`: hold `weight_up: 2.0`; break stamps half + `phantom_votes: 2` on max taker
 - `reverie/backend_server/survival/controller.py`: Apply secondary PHANTOM when stamped beside WEIGHT_DOWN
 - `video/assets/challenges/shared_survival_pool/`: steps half/+2 / 2×; status **2X VOTE**
 - `sot/sot_challenges.md` §4 Day 14 / §5.15: Option A greed tax + double hold locked

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Claim the Slot commissioned; Shared Survival Pool teach pack draft**
 - `video/assets/challenges/claim_the_slot/manifest.json`: status `commissioned`
 - `video/assets/challenges/shared_survival_pool/`: title Take 0–5, steps Secret take / Over 10 breaks / Least wins, 1.5X status; 3-band VO
 - `sot/sot_challenges.md` §4 Day 14 / §5.15: break=half; hold bonus=1.5× locked

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Vote Heist commissioned; Claim the Slot teach pack draft**
 - `video/assets/challenges/vote_heist/manifest.json`: status `commissioned` (hard steal ×2 / 0)
 - `video/assets/challenges/claim_the_slot/`: title Claim/Yield, steps Claim or Yield / One full slot / Others half, FULL VOTE status; 3-band VO
 - `reverie/backend_server/survival/challenges.py` + SOT §4 Day 13: winner **1.0×**, others **0.5×** stamped

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Vote Heist hard steal = double / zero ballot**
 - `reverie/backend_server/survival/challenges.py`: Heister `weight_up: 2.0`, target `weight_down: 0.0`
 - `video/assets/challenges/vote_heist/`: steps 2×/0 steal; status **2X VOTE / Tonight**
 - `sot/sot_challenges.md` §4 Day 12 / §5.13: hard steal locked in kid teach

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Trial Night commissioned; Vote Heist teach pack draft**
 - `video/assets/challenges/trial_night/manifest.json`: status `commissioned`
 - `video/assets/challenges/vote_heist/`: title Highest steals, steps Name a target / Everyone rolls / Highest steals, 1.5X status; 3-band VO
 - `sot/sot_challenges.md` §4 Day 12 / §5.13: Heister **1.5×** / target **half vote** locked

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Group Betrayal half-vote lock + Trial Night teach pack draft**
 - `sot/sot_challenges.md` §4 Day 10 / §5.11: crowd Defect = **half vote** (0.5×); pack `commissioned`
 - `reverie/backend_server/survival/challenges.py` + `controller.py`: stamp/apply `weight_down: 0.5`
 - `video/assets/challenges/trial_night/`: title Acquit/Convict, steps Random pick / Acquit or Convict / Shield or +2, Shield status; 3-band VO

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Bid for the Vest commissioned; Group Betrayal teach pack draft**
 - `video/assets/challenges/bid_for_vest/manifest.json`: status `commissioned`
 - `video/assets/challenges/group_betrayal/`: title Cooperate/Defect, steps All cooperate / One defects / Many defect, Movable Shield status; 3-band VO
 - `sot/sot_challenges.md` §5.10–§5.11: Bid locked; Group Betrayal VO brief opened

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Leader's Burden commissioned; Bid for the Vest teach pack draft**
 - `video/assets/challenges/leaders_burden/manifest.json`: status `commissioned`
 - `video/assets/challenges/bid_for_vest/`: title Highest wins, steps Secret bid / Bids reveal / Highest wins, Shield status; 3-band VO
 - `sot/sot_challenges.md` §5.9–§5.10: Leader's Burden locked; Bid for the Vest VO brief opened

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Call the Bluff commissioned; Leader's Burden teach pack draft**
 - `video/assets/challenges/call_the_bluff/manifest.json`: status `commissioned`
 - `video/assets/challenges/leaders_burden/`: title Shield·Mark one, steps Name one / Nominees roll / Must mark, Shield status; 3-band VO
 - `sot/sot_challenges.md` §5.8–§5.9: Call the Bluff locked; Leader's Burden VO brief opened

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Whisper Chain commissioned; Call the Bluff teach pack draft**
 - `video/assets/challenges/whisper_chain/manifest.json`: status `commissioned` (3× vote)
 - `video/assets/challenges/call_the_bluff/`: title Claim/Call, steps Secret card / Claim or Pass / Call or Let, Shield status; 3-band VO
 - `sot/sot_challenges.md` §5.7–§5.8: Whisper locked; Call the Bluff VO brief opened

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Whisper Chain reward = 3× vote (not vague “stronger”)**
 - `reverie/backend_server/survival/challenges.py`: Whisper winner `weight_up: 3.0` + copy; controller already applies custom WEIGHT_UP
 - `tests/test_survival_challenges.py`: Assert 3.0× applies at tally
 - `video/assets/challenges/whisper_chain/immunity_status.png`: **3X VOTE / Tonight** chrome
 - `sot/sot_challenges.md` §5.7 + Day-5 kid teach: 3× language locked

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Captain's Pick commissioned + Whisper Chain teach pack draft**
 - `video/assets/challenges/captains_pick/manifest.json`: status `commissioned`
 - `video/assets/challenges/whisper_chain/`: title Relay/Twist, steps Secret line / Relay or Twist / Last true wins, stronger-vote status; 3-band VO

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Captain's Pick teach pack draft**
 - `video/assets/challenges/captains_pick/`: title (Red OR Blue), steps Pick a side / Smaller at risk / Tie coin, At risk status; 3-band VO wired

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Roll for the Shield teach pack commissioned**
 - `video/assets/challenges/roll_for_shield/manifest.json`: status `commissioned` (large-type title+icon steps)

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Outcome cards = title + infographic only (no body copy)**
 - `video/fly-over/COMMISSION_cinematic_pack.md` + `sot_challenges.md` §5.1: Lock copy rule for future packs
 - `video/assets/challenges/roll_for_shield/steps_board.png`: Regen Secret roll / Keep or Risk / Highest wins icons-only

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Nightly energy pass — denser SFX/FX, key-phrase CC, Anya WANT plates**
 - `video/nightly_vo_timing.py`: Key-phrase captions only (drop full-VO dump); soft highlight band 10–22
 - `video/nightly_hud.py`: Day-1 want plates staged as want_peak/cost_hud; anti-leak allows neutral dest names
 - `video/build_nightly_remotion_props.py`: ~23 SFX + more FX on cuts; stacked stake/world; long re-render

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Nightly → gold parity (VO timing, captions, SFX/FX, HUD anti-leak)**
 - `video/nightly_vo_timing.py`: Locked VO = audio + timing; scar beat map; kinetic captions + music duck
 - `video/nightly_hud.py`: VO-indexed HUD windows; drawn WANT/N ACTIVE; anti-leak gate; synthetic Night-2 fixture
 - `video/build_nightly_remotion_props.py`: Wire timing/captions/SFX/FX/HUD; Day-1 long prove via `run_nightly_survival`

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Alliance Lock-In commissioned + Roll for the Shield teach pack draft**
 - `video/assets/challenges/alliance_lock_in/manifest.json`: status `commissioned`
 - `video/assets/challenges/roll_for_shield/`: title, Keep/Risk steps A/B/C, Shield status (draft); 3-band VO wired

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Alliance Lock-In mutual = double vote (×2) tonight**
 - `reverie/.../survival/challenges.py` + `controller.py`: Mutual `WEIGHT_UP` value 2.0 via `weight_up` mutation
 - `video/assets/challenges/alliance_lock_in/`: Steps + status retargeted to Double vote / Tonight
 - `tests/test_survival_challenges.py`: Assert mutual → weight 2.0 at tally

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Alliance Lock-In Option A: mutual = stronger vote tonight**
 - `reverie/.../survival/challenges.py`: Score mutual locks as `WEIGHT_UP` (not `REP_SHIELD`)
 - `video/assets/challenges/alliance_lock_in/`: Retarget steps + status to stronger-vote chrome
 - `tests/test_survival_challenges.py`: Mutual lock → `WEIGHT_UP` assertion

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Silent Pact commissioned + Alliance Lock-In teach pack draft**
 - `video/assets/challenges/silent_pact/manifest.json`: status `commissioned`
 - `video/assets/challenges/alliance_lock_in/`: title, outcome A/B/C, reputation-shield status (draft); 3-band VO wired

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Silent Pact title layout v4**
 - `video/assets/challenges/silent_pact/title.png`: Larger Silent Pact at top; Protect OR Expose one line under figures; remove per-figure captions

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Silent Pact title figures + progressive outcome bands**
 - `video/assets/challenges/silent_pact/title.png`: Protect/Expose cyan wireframe facing figures
 - `video/build_nightly_remotion_props.py`: `silent_pact` uses three STEP bands (Both Protect → Both Expose → One Exposes under VO)

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Challenge visual family lock + Silent Pact art regen v2**
 - `video/fly-over/COMMISSION_cinematic_pack.md`: Portrait 9:16 lock; cyan notched HUD frame family accent
 - `video/assets/challenges/silent_pact/`: Regen title (Protect OR Expose), outcome cards A/B/C, portrait immunity; keep `missing` until accept

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Silent Pact teach-pack draft art (pending taste accept)**
 - `video/assets/challenges/silent_pact/`: Add `title.png`, `steps_board.png`, `immunity_status.png` (Hold-style refs); keep manifest `missing` until accept

## 2026-07-29 — Ivan — branch: ivan/place-language-honesty

### Backend

- [x] **Place-language honesty: serve emit copy + stop exercise mistags cascading to Park**
 - `api_gateway/app/core/action_contract.py`: Prefer emit `description`/`intent` over nested raw act (`PLACE_LANGUAGE_API_PREFER_EMIT`)
 - `reverie/.../action_contract_v1.py` + `reverie.py`: Nested progress gets travel-safe act; `emit_honesty` counter; idempotent `@` strip
 - `reverie/.../plan.py` + `location_resolver.py` + decomp prompts: Travel/home stretch coerced off `exercise` so whitelist does not invent Park

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **#8 Phase E0: Day-1 full nightly Remotion prove (no CapCut)**
 - `run_nightly_survival` on `data/20260713-1/trailer_ready_day2` → `output/trailer_9x16.mp4` (~93s measured)
 - Archive: `video/remotion/out/nightly_20260713-1_day2_short_20260729_phase_e.mp4`
 - Report: `…/output/nightly_run_report.json` (soft warn >90s; under 120s hard)

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **#8 Phase D: one-command nightly Survival CLI**
 - `video/run_nightly_survival.py`: validate → props → literacy/length gates → snapshot → NightlySurvival render → report
 - `video/validate_nightly_survival.py`: fact-lock, VO-lock, clip_kit, scar, literacy, length bands, picture READY
 - `video/test_run_nightly_survival.py`: gate + skip-render orchestration tests

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **#8 Phase C: nightly gold-grade Remotion props (no CapCut)**
 - `video/build_nightly_remotion_props.py`: picker+kit+VO → GoldReplay-shaped plan (teach pack, Cost grey, end lockup, lengthMode)
 - `video/remotion/src/Root.tsx`: register `NightlySurvival` (reuses DailyGoldReplay renderer)
 - `video/nightly_craft.py`: seat_map list-shape lookup for soul15
 - `video/test_build_nightly_remotion_props.py`: emit shape + Peak/Cost fail-closed

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **#8 Phase B: shared nightly craft library**
 - `video/nightly_craft.py`: C-pack / plates / legend roles / SFX floors / challenge packs / Peak-Cost / seats / length modes
 - `video/build_gold_replay_props.py`: import shared craft (behaviour-preserving)
 - `video/build_day_remotion_props.py`: `lengthMode` + bands stub for Phase C
 - `video/test_nightly_craft.py`: pack resolve, Hold-for-Shield specimen, fail-closed Peak/Cost, length modes

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **#8 Phase A/A2: nightly craft gap + Hold-for-Shield teach pack specimen**
 - `video/NIGHTLY_CRAFT_GAP.md`: gold vs day props inventory + nightly checklist
 - `video/assets/challenges/hold_for_shield/`: title / steps / immunity from legend_promoted
 - `video/fly-over/COMMISSION_cinematic_pack.md`: Challenge visual bank ops section

## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **E4 Remotion lock + opener C1–C8 + E5 legend promote + D3 still path**
 - `video/cinematic_pack.py`: shared C1–C8 resolve; opener beds keep Phaser signature
 - `video/compose_trailer.py` / `showrunner.py` / `asset_manifest.py` / `build_anya_package_a_props.py`: opener aerial → pack (not legacy flyovers)
 - `video/promote_legend_assets.py`: 32 CapCut-used legends → `assets/legend_promoted/20260713-1/2/`
 - `video/generate_picture_stills.py` + `mark_picture_jobs.py` + `xai_imagine.py`: still queue / optional Imagine + human READY

## 2026-07-28 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay end stretch: restore VO visuals + animated overhead + lockup pad**
   - `video/build_gold_replay_props.py`: end VO clips full-bleed cover (not empty contain); C3→C2.mp4 animated; end lockup 9x16 black pad; gap-bridge + opacity floor
   - Snapshot: prior cut under `out/gold_replay_day1_*_pre_end_fill.mp4`
## 2026-07-28 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay: simplify Alliances→Votes + grey Ivan-out + seat standard**
   - `video/build_gold_replay_props.py`: votes beat uses `alliances_votes_step.png` (title + graph/votes only); Ivan-out = soft grey wash seat 3.3
   - `video/assets/scripts-prompts/build_soul15_cast_plate.py`: stack C→B→A (Ivan front center 3.3) aligned to seat_map v4
   - Snapshot: `out/gold_replay_day1_20260728_193832_pre_votes_grey.mp4`
## 2026-07-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay alliances Anya layout + end VO pad**
   - `video/build_gold_replay_props.py`: chat beat = panel_under_title; votes = full cascade contain; VO keeps ~1.05s under lockup + 0.25s empty
   - `video/remotion/src/DailyGoldReplay.tsx`: panel_under_title layout (header + width-fit Talk)
   - Snapshot: `out/gold_replay_day1_20260728_184039_pass2.mp4`; tests 11 green
## 2026-07-28 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay founder pass 2 (poster / alliances / Ivan-out / chat fit / end punch)**
   - video/build_gold_replay_props.py: split alliances into chat then votes band; Ivan seat 3.3 out plate; chat/Talk cover-fit; end lockup swoosh + VO hard-cut
   - video/remotion/src/DailyGoldReplay.tsx: brighter pre-play poster matrix
   - Snapshot prior best: `out/gold_replay_day1_20260728_180258_founder_best.mp4`
   - Tests: 11 green
## 2026-07-28 — Ivan — branch: ivan/post-chat-auto-learn

### Backend

- [x] **Post-chat assessor reliability + consent auto-learn on End session**
  - `api_gateway/app/services/post_chat_learning_service.py`: Retry/fallback assessor LLM; skip responses include `skipped:true`; consent ON auto Path A apply shared with confirm; idle thread sweep (16m)
  - `api_gateway/app/services/background_tasks.py`: Periodic idle post-chat assess every 2m
  - `api_gateway/app/api/routes/me.py`: Session/end docs for auto-apply vs pending_review
  - `api_gateway/tests/test_post_chat_session_end.py`: Empty→retry→fallback, skip payload, consent auto-apply, opt-out pending, idle list/sweep, chat untouched on error

**FE handoff:** `ivan/talk-session-auto-close` implements A/B/C client triggers; pair with BE idle sweep.

## 2026-07-28 — Ivan — branch: ivan/place-language-emit-honesty

### Backend

- [x] **Keep named travel destinations through whitelist cascade (Vince Hobbs→Park root cause)**
  - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Skip activity whitelist remap when travel text names the address sector
  - `reverie/backend_server/persona/cognitive_modules/plan.py`: Treat `walking to` as travel; detach inherit when travel names another place; reject ACTION CONTRACT on named-dest mismatch
  - `tests/test_named_destination_travel.py`: Vince-style exercise→Park keep/reject fixtures

- [x] **Emit honest travel status when act text names a different place than planned address**
  - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: Travel-safe rewrite so planned dest owns walking copy; scrub premature in-place verbs while travelling
  - `reverie/backend_server/reverie.py`: Emit `intent` through travel-safe helper (not raw lying act text)
  - `tests/test_action_text_sanitization.py`: Vince-style Hobbs-vs-Park and premature-order fixtures

## 2026-07-28 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay founder HUD pass (poster, badges, progressive STEPs, CC type)**
   - `vvideo/build_gold_replay_props.py`: poster meta (Episode N); DOUBLAND.AI + LIVE top / N ACTIVE bottom; progressive STEP bands 37/39/40/43; pre-cropped survival stamp
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: 2.5s matrix poster; Montserrat Black CC 1.5× word-by-word; label cards + band slots
   - Snapshot rule: prior MP4 saved as `out/gold_replay_day1_20260727_stack_fx.mp4`; script `video/remotion/scripts/snapshot_and_render_gold.ps1`
   - Tests green; still smokes for poster/badge/live/stamp/steps/CC

## 2026-07-27 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay legend HUD stack + CapCut FX + SFX floors (Anya look parity)**
   - `vvideo/build_gold_replay_props.py`: legend HUD role map; full multi-panel STEP/alliances `hud_stack`; want HUDs; FX events; stock SFX palette + volume floors
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: `hud_stack` + cyan bloom; CraftFx (scan/shake/black-hit/radial-zoom)
   - `video/test_build_gold_replay_props.py`: stacking + FX unit coverage (9 tests green)
   - Still smokes: badge / want / stacked STEPs / immunity match Anya chrome; full 88s re-render next for phone-watch

- [x] **Soul15 cast plate + framed roster (identity-safe seat map)**
   - `video/assets/scripts-prompts/build_soul15_cast_plate.py`: deterministic full-body composite → group_photo / matrix / cast_roster_framed + seat_map.json
   - `video/assets/cohort/soul15_seed_20260224/`: regenerated plate assets; old plate in `_archive/pre_regen_20260727/`; Ivan locked at seat 1.3
   - Grok API polish blocked at 3-image cap (documented); framed roster matches Remotion matrix cards

- [x] **Gold replay Phase 1 portrait HUD grammar**
   - `vvideo/build_gold_replay_props.py`: `apply_phase1_hud_grammar` (stamp/step/alliances crops, badge contain, immunity delay) + C3 night plate + end audio fade
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: lower-third kinetic type; layout modes + real `cropTop`/`cropBottom` source crop
   - `video/test_build_gold_replay_props.py`: unit coverage for Phase 1 grammar + fade
   - Docs: `TODO_video.md`, `AGENTS.md` resume notes

## 2026-07-27 — Ivan — branch: ivan/resume-env-handshake

### Backend

- [x] **Hard-fail incomplete intent writes before headless (retry transient 502s)**
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Retry failed persona position writes; return failed names
 - `reverie/backend_server/reverie.py`: Emit `INTENT_PERSIST_INCOMPLETE` and abort before headless when writes stay short
 - `reverie/backend_server/tests/test_intent_persist_gate.py`: Cover retry success, exhausted failure, and hard-fail message
 - `sot/sot_be-fe.md` §4.8 + `sot/sot_observability.md` §4.1 + `sot/ARCHITECTURE.md` headless flow: Document pre-headless completeness gate and metrics
 - VPS: deployed on `railway`; resumed `20260724-2` — recovered 14/14 at steps 3620–3621

## 2026-07-26 — Ivan — branch: ivan/resume-env-handshake

### Backend

- [x] **Unblock Survival resume when pending advances past the last environment file**
 - `reverie/backend_server/reverie.py`: After pending step correction, materialize missing `environment/{step}.json` from the prior step (drop eliminated names) so the step loop does not wait forever

## 2026-07-25 — Ivan — branch: ivan/dev

### Backend

- [x] **Wire C1–C8 cinematic pack into gold replay world plates**
   - `vvideo/build_gold_replay_props.py`: `WORLD_PLATE_REPLACEMENTS` swaps alpine `B604…` still (~30s) + open-roof `Village.mp4` (~59s) → C1; Phaser `signature_flyover` kept; stages canonical `cinematic_ville_*` names
   - `video/test_build_gold_replay_props.py`: unit coverage for swap map + Phaser untouched
   - Docs: `double-ivan/video/TODO_video.md`, `GOLD.md` resume spine updated (D5b done)
## 2026-07-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay end-of-film cleanup (no FX yet)**
   - `vvideo/build_gold_replay_props.py`: After Cost (68.5s) cut long HUD plate, drop face overlays, max 1 hero layer, soft-door tags on tail
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: Per-layer fadeIn/Out, soft-door settle, deeper post-boot vignette
   - `video/test_build_gold_replay_props.py`: Unit coverage for stack thin + door; signature CapCut FX deferred until Doubland plates
## 2026-07-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay music → loopable intrigue bed (Anya volumes kept)**
   - `vvideo/build_gold_replay_props.py`: Collapse CapCut `music_drama` clips into one `music_intrigue_loopable.mp3` loop + 6-step volume envelope from Anya automation
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: `loop` + stepped `volumeEnvelope` on Audio
   - VO source offsets unchanged (second clip `sourceStartSec=7.777`)
## 2026-07-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Gold replay render fix — short kinetic clips crash interpolate**
   - `vvideo/remotion/src/DailyGoldReplay.tsx`: Duration-safe fade envelope (`AND IMMUNITY` = 9 frames); full 88s render OK (~65 MB)
   - Compare stills under `video/remotion/out/compare/` vs master `0720(1).mp4`
## 2026-07-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Remotion gold replay Phase 1 — CapCut Day-1 timeline → DailyGoldReplay**
   - `vvideo/build_gold_replay_props.py`: Edit-plan from CapCut CSVs; stages kit/legend/VO; local SFX stand-ins for CapCut stock
   - `vvideo/remotion/src/DailyGoldReplay.tsx` + `Root.tsx`: Layered media + kinetic type + multi-bus audio composition
   - `video/test_build_gold_replay_props.py`: Unit test for edit-plan builder
   - Smoke: `npx remotion still DailyGoldReplay` frame 90 OK; props 54 layers / 43 texts / 32 audio
# Work Log

> **Last Updated:** 2026-07-24

---

## 2026-07-24 — Ivan — branch: ivan/headless-sim-id-ready

### Backend

- [x] **Headless ready on score runs — always pass sim UUID + VPS FE Supabase align**
 - `reverie/backend_server/reverie.py`: Set `_set_collision_sim_id_override` from score sim UUID after bootstrap (not only read-only)
 - `reverie/backend_server/headless_visualization.py`: Warn when headless URL lacks `sim_id`
 - `reverie/backend_server/tests/test_headless_lifecycle.py`: Override/URL unit tests
 - VPS ops: FE `NEXT_PUBLIC_SUPABASE_*` → BE project; `HEADLESS_STRICT_ABORT=true`; rebuild `double-front`; smoke 15/15 ACCEPTED @ step 183

## 2026-07-23 — Ivan — branch: ivan/headless-memory-hygiene

### Backend

- [x] **Persist FE actual_path into coords movement blob (path-animation slice A)**
 - `supabase/migrations/20260723180000_persist_actual_path_in_movement.sql`: RPC merges `actual_path`+`path`; preserves realized paths on intent rewrites (applied remote)
 - `reverie/backend_server/reverie.py`: Normalize waypoints; skip empty `[]` so RPC does not wipe paths
 - `api_gateway/app/services/supabase_service.py` + tests: Step APIs surface usable `actual_path`
 - `scripts/analyze_travel_path_coverage.py`: ≥95% travel-step path coverage gate for new score sims

- [x] **Reverie RSS creep monitor for next VPS score run**
 - `scripts/monitor_reverie_rss.sh`: 5‑min CSV sampler (reverie/chrome RSS, host, assoc/rendered disk)
 - `scripts/snapshot_sim_chrome_mem.sh`: Optional one-shot Chrome/sim memory forensics

- [x] **Headless memory hygiene — screenshots off by default; recycle Chrome every 500 successful renders**
 - `reverie/backend_server/headless_visualization.py`: Gate PNGs behind `HEADLESS_SCREENSHOT_EVERY_N` (default 0); recycle browser after N completions (`HEADLESS_BROWSER_RECYCLE_EVERY_N`, default 500)
 - `reverie/backend_server/tests/test_headless_lifecycle.py`: Unit coverage for screenshot gating and recycle lifecycle
 - `.cursor/rules/env-flags-and-storage.mdc`: Document both new flags and defaults

## 2026-07-22 — Ivan — branch: ivan/dev

### Backend

- [x] **D8 — auto atlas + map coords on join/finalize; avatar pick APIs**
 - `api_gateway/app/services/persona_sprite_service.py`: Default generalized atlas, seed `personas_coords` from scratch tile, catalog/set helpers
 - `api_gateway/app/services/self_serve_bind_service.py`: Join + finalize call D8 hook so map has a sticker without manual rescue
 - `api_gateway/app/services/owned_double_host_service.py`: Talk host also ensures a default atlas
 - `api_gateway/app/api/routes/me.py`: `GET/POST /api/me/double/avatar` for FE picker
 - `api_gateway/tests/test_persona_sprite_service.py` + bind tests: Unit coverage for parse/assign/seed/routes

## 2026-07-22 — Ivan — branch: ivan/dev

### Backend

- [x] **Map proof for self-serve bind (A) — Double visible on 20260711-1**
 - Seeded `personas_coords` for `ipistsov's Double` at step 2489 (House 2, 30,60); join had no coord history
 - `api_gateway/app/core/validation.py` + tests: Allow apostrophe in persona names (owned Double names)
 - `reverie/backend_server/reverie.py`: Create `temp_storage` before writing curr_sim_code handshake
 - Assigned generalized atlas `m1` on `persona_sprite_assets` for `ipistsov's Double`; sprite-manifest no longer lists them as missing
 - Continuation run of `20260711-1` started (step 2490+); FE can open step 2489 now for sticker

- [x] **D2 options — self-serve fast path (no multi-LLM hang)**
 - `scripts/onboarding_host.py`: When `persona_names` set, build job/home shortlists from roster work areas + maze homes (no classify/rank LLM chain)
 - `tests/test_onboarding_picker.py`: Self-serve filter expects `self_serve_fast_path`
 - Live check: `GET …/bind/20260711-1/options` returns job/home options in ~10s for `ipistsov's Double`

- [x] **D2 options — set persona_scratch.name on join/host seed**
 - `api_gateway/app/services/owned_double_host_service.py`: Always write `name` (and first/last) when seeding/refreshing scratch; options board keys snippets by name
 - `api_gateway/tests/test_owned_double_chat.py`: Cover insert/refresh name write
 - Hotfix: `persona_scratch.name` for `ipistsov's Double` on `20260711-1` so live FE smoke can continue

- [x] **D5 — permanent self-serve BE QA harness (unit + optional live)**
 - `api_gateway/tests/pytest.ini` + bind/owned/post-chat modules: `self_serve_spine` marker
 - `api_gateway/tests/test_self_serve_spine.py` + `scripts/run_self_serve_spine_unit.py`: Always-on unit checklist runner
 - `scripts/self_serve_smoke_common.py` + `smoke_self_serve_spine.py` + `smoke_post_chat_33.py`: Shared live helpers; full-spine smoke (`--live`); post-chat smoke refactored to common

- [x] **D2-B — auto-join + private/open access + allowlist**
 - `supabase/migrations/20260722180000_self_serve_access_allowlist.sql`: Access modes, max roster, allowlist table (applied remote)
 - `api_gateway/app/services/self_serve_bind_service.py`: Shared gates; join links roster + scratch ISS; options/finalize respect allowlist
 - `api_gateway/app/api/routes/onboarding.py` + `me.py`: Operator access/allowlist APIs; JWT join endpoint
 - `api_gateway/tests/test_self_serve_bind.py`: Allowlist, timing, capacity, already_bound, join idempotent/suffix

- [x] **D2-BE v1 — self-serve Phase D bind API (joinable + options + finalize)**
 - `supabase/migrations/20260722140000_self_serve_joinable.sql`: Operator `self_serve_joinable` flag on sims (applied remote)
 - `scripts/onboarding_host.py`: Single-persona board filter + `target_personas` finalize (others unchanged)
 - `api_gateway/app/services/self_serve_bind_service.py` + `me.py` / `onboarding.py`: JWT bind routes; operator mark-joinable; join reserved as 501
 - `api_gateway/tests/test_self_serve_bind.py` + onboarding picker/finalize tests: Gates, options, single-persona write, taken-home block

- [x] **Close Week 3.3 ops — post-chat learning live on shared Supabase**
 - `supabase/migrations/20260717120000_post_chat_learning.sql`: Applied on `kkjhsozszgoorwehhsdg` (consent column + `post_chat_assessments`)
 - `api_gateway/app/services/post_chat_learning_service.py`: Pass `require_auth=True` into thread ownership check on session-end
 - `scripts/smoke_post_chat_33.py`: API live smoke for consent, session-end store, confirm Path A, stale guard, dismiss, restore

---

## 2026-07-14 — Ivan — branch: ivan/challenge-personality-attraction

### Backend

- [x] **Personality attraction layer for Survival challenges (SC bias, not sole scoreboard)**
 - `reverie/backend_server/survival/attraction.py`: weights + weighted pick + soft priors (noise floor)
 - `reverie/backend_server/survival/challenges.py` + `controller.py` + `reverie.py`: wire weighted pool pick / trial centering / choice_reason_plain; flat override
 - `tests/test_challenge_attraction.py`: top-SC ≠ always seated; seed-stable; resolve audit

---

## 2026-07-14 — Ivan — branch: ivan/dev

### Backend

- [x] **Self-serve Double epic Week 1 — Chat v4 identity spine**
   - `api_gateway/app/core/auth.py` + `config.py`: Supabase JWT verify, `CHAT_REQUIRE_AUTH`, `SUPABASE_JWT_SECRET`
   - `chat_with_double_service` + chat route: stamp/enforce `user_id` on threads (401/403)
   - `supabase/migrations/20260714120000_chat_thread_user_id.sql`: nullable `user_id`, RPC `p_user_id`
   - `api_gateway/tests/test_chat_auth.py`: JWT + ownership unit coverage

---

## 2026-07-13 — Ivan — branch: ivan/survival-light-challenge-reasons

### Backend

- [x] **Light challenge soul-conditioned reason slots (8 IDs)**
 - `persona/prompt_template/v2/survival_challenge_{captains_pick,whisper_chain,leaders_burden,bid_for_vest,trial_night,vote_heist,claim_the_slot,shared_survival_pool}_v1.txt`: personal reason + banlist; kill always-max EV bullets
 - `survival_leader_penalize_v1.txt` + `run_gpt_prompt_leader_penalize` + controller: identity block + persist `mark_reasoning`
 - `video/challenge_blind_choice.py` + teach cards: blind sheet + Light `_CHALLENGE_CARDS`

---

## 2026-07-13 — Ivan — branch: ivan/survival-p0-fidelity-director

### Backend

- [x] **Hardcode Challenge Director + mode-agnostic chat soul card**
 - `reverie/backend_server/reverie.py`: director slate hardcoded (no SURVIVAL_CHALLENGE_* envs)
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `_persona_identity_block` on all batch chats (normal + Survival)

- [x] **P0 Survival fidelity + Challenge Director**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: inject soul profile snippets into Survival chat/vote/challenge prompts
 - `reverie/backend_server/survival/controller.py`: strip Overlay strategy grammar; soften seek copy; ship `director` rotation; persist challenge decisions + vote reasons
 - `video/build_fact_ledger.py` / `summarize_cast_day.py` / `recognition_gate.py` / `day_reasoning.py`: Shield teach cards, false-elim quarantine, gate + clone lexicon, day_reasoning package writers

---

## 2026-07-13 — Ivan — branch: railway

### Backend

- [x] **Prevent midnight crash when a day plan is short after a vote**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: pad/trim schedules to 1440, reject empty decomp replaces, safe index reads, skip sleep-time proactive refresh
 - `reverie/backend_server/persona/memory_structures/scratch.py`: clamp empty/overshoot schedule indices
 - `tests/test_schedule_integrity_midnight.py`: Dean-like short-tail + empty-decomp regression coverage

---

## 2026-07-11 — Ivan — branch: ivan/challenge-persist-after-resolve

### Backend

- [x] **Persist Survival challenge results immediately (and fix stop API)**
 - `reverie/backend_server/survival/controller.py`: flush season state after directive pick + challenge resolve; only mark challenge resolved when a result row is written
 - `api_gateway/app/api/routes/simulations.py`: remove undefined `parameters` from stop task payload (was 500ing every stop)
 - `tests/test_survival_challenges.py`: cover persist-on-resolve and no-challenge false return

---

## 2026-07-10 — Ivan — branch: ivan/digest-challenge-card-from-season

### Backend

- [x] **Cast digest challenge card from season results (not cleared scratch)**
 - `video/summarize_cast_day.py`: prefer `challenge_results` for `challenge_today` object (name/winners/claimants); scratch fallback only if missing
 - `video/build_fact_ledger.py`: accept digest challenge object shape
 - `video/test_day_overview_facts.py`: end-of-run Limited Immunity card + grace-day none

---

## 2026-07-10 — Ivan — branch: ivan/survival-locked-challenge-catalog

### Backend

- [x] **Ship locked Survival challenge catalog with random rotation for new sims**
 - `reverie/backend_server/survival/challenges.py`: locked 14-challenge pool + scorers; legacy ids kept; random without-replacement pick
 - `reverie/backend_server/survival/controller.py` + `state.py` + `reverie.py`: default random rotation; used-ids persistence; narrative on results; reward penalties apply when not "won"
 - `persona/prompt_template/v2/survival_challenge_*` + `run_gpt_prompt.py`: new/retuned challenge prompts
 - `tests/test_survival_challenges.py`: scorers + random pool + legacy inference coverage

---

## 2026-07-10 — Ivan — branch: railway

### Backend

- [x] **Expert VO → day-overview auto-gen (teach challenge + thin tallies)**
 - `video/build_fact_ledger.py`: plain challenge fields; winners-only; safe_vo/do_not_say; challenge_job + soft signals helpers
 - `video/showrunner.py`: teach prompts; exposed_leads; 210–250 full-intro budget; CTA; cache story_v8 / narration_v11
 - `video/narration_facts.py`: do_not_say / single-winner / CTA gates + reminder detector
 - `video/test_day_overview_facts.py`: thin-tally, Irene-only winners, golden +/- fixtures

---

## 2026-07-10 — Ivan — branch: railway

### Backend

- [x] **Restitch chat-probe Day 2 scene locations for Remotion (keep locked VO)**
 - `video/restitch_day_script.py`: hydrate timelines from positions; fill `scene.location`; clamp key_steps
 - `data/20260707-chat-probe-v3/trailer_ready_day2/script.json`: locations filled (Oak Hill / Hobbs / etc.)

---

## 2026-07-10 — Ivan — branch: railway

### Backend

- [x] **Spicy ranking + coverage slot + F3 prior-day scar cards**
 - `video/persona_ranker.py`: drama-gap rank_score, location weight 0.05, story-role bonuses, last-slot coverage
 - `video/summarize_cast_day.py`: digest Base/Notes columns + coverage candidate
 - `video/extract_day_log.py`: prior-day summary uses season day for prior engine day
 - `video/day_scar.py` + `supabase/migrations/20260710190000_trailer_day_scar.sql`: scar file + Supabase store
 - `video/lock_day_script.py`: writes scar.json (+ optional Supabase) on lock
 - `video/showrunner.py`: prior_scars in producer/writer; cache story_v7 / narration_v10

---

## 2026-07-10 — Ivan — branch: railway

### Backend

- [x] **F1 first-feature intro memory for day-overview trailers**
 - `supabase/migrations/20260710180000_trailer_featured_history.sql`: history table + load/upsert RPCs
 - `video/featured_history.py`: intro_mode resolution, stamp facts, light gate, lock name set
 - `video/showrunner.py`: Survival Day 1 force-full; producer/writer prompts; establishing cards; cache v6/v9
 - `video/lock_day_script.py`: lock/accept CLI writes history (featured + farewell)
 - `video/extract_day_log.py`: lifestyle/currently/living_area/innate on day-overview protagonists
 - `video/test_day_overview_facts.py`: F1 mode/gate/lock regressions

---

## 2026-07-09 — Ivan — branch: ivan/durable-post-vote-planning

### Backend

- [x] **Durable post-vote planning (RCA-1): recovery stays authoritative after elimination**
 - `reverie/backend_server/persona/cognitive_modules/planning_cache.py`: context fingerprint on daily-plan cache keys
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: post-vote stage skips full-day replan; fingerprint on cache get/put
 - `reverie/backend_server/persona/cognitive_modules/schedule_validator.py`: remove unsafe wake-hour cache probe that forced "First day"
 - `reverie/backend_server/survival/controller.py`: durable `post_vote_date`, resume sync, stall-breaker hold, post-vote overlay
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: gate hourly/daily vote calendar cues after elimination
 - `tests/analyze_20260630_1.py`: paginate positions, fail-closed incomplete window, tighten vote-prep-at-Hobbs gate

---

## 2026-07-09 — Ivan — branch: railway

### Backend

- [x] **Cast ranker soft +2 for eliminated-today (F2b)**
 - `video/persona_ranker.py`: `ELIMINATED_TODAY_BONUS = 2` (replaces zero after F2; never restore +50)
 - `video/test_day_overview_facts.py`: soft-bonus regression
 - Regenerated `trailer_ready_day2/cast_digest.md` after +2

- [x] **F2: stop elimination auto-#1; farewell when boot ∉ top-3**
 - `video/persona_ranker.py`: remove elim +50; score = poignancy + chat_impact + locations + relationship extreme
 - `video/showrunner.py`: farewell guidance when eliminated ∉ protagonists; cache keys story_v5 / narration_v8
 - `video/test_day_overview_facts.py`: F2 ranking + prompt regressions
 - Regenerated `trailer_ready_day2/cast_digest.md` (Max/Olivia/Owen top-3; Vincent #6)

- [x] **Lock chat-probe Day 2 plain-text VO + re-TTS**
 - `trailer_ready_day2/script.json` + `script_used.txt`: locked Vincent/Max/Olivia human VO
 - `trailer_ready_day2/audio/narration.mp3` + timing: warm 1.5×, **106.4s**

- [x] **Fact ledger challenge card + story-first VO prompts (E1+E2)**
 - `video/build_fact_ledger.py`: challenge name/brief/winners card; plain-language facts; story-first writer rules
 - `video/extract_day_log.py` + `generate_trailer.py` + `showrunner.py`: pass season_state into ledger; story-first challenge rules; cache keys v4/v7
 - `video/test_day_overview_facts.py`: challenge card + prompt regressions

- [x] **Cast digest / ranker: score chat content, not chat count**
 - `video/persona_ranker.py`: `chat_impact` from top movement.chat transcripts (depth + vote/alliance cues); count is diagnostic only
 - `video/summarize_cast_day.py`: Moments mix events, thoughts, and substantive chat beats; ranking table shows chat impact
 - `video/test_day_overview_facts.py`: chat scoring + chat-in-moments regressions

- [x] **Survival soft brief + intentional seek-to-person**
 - `reverie/backend_server/survival/controller.py`: soft day brief restores lifestyle in leftover hours; picks ally/trust seek target; sets structured seek fields
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: time-boxed walk-toward `<persona>` seek; keep "try to find" schedule phrasing
 - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt` + `survival_generate_hourly_schedule_v1.txt`: allow seek intent, discourage note-spam
 - `reverie/backend_server/persona/memory_structures/scratch.py`: persist `social_seek_target` / `social_seek_until_step`
 - `tests/test_social_seek.py` + `tests/smoke_social_seek.py`: unit + smoke coverage
 - `double-docs/sot/sot_survival.md`: seek is movement intent; chats still proximity-gated

- [x] **Cast digest: Doubland clock, full-day schedule, thoughts in moments**
 - `video/extract_day_log.py`: schedule/chat times use sim start (06:30 Doubland), not midnight-origin clock
 - `video/summarize_cast_day.py`: collapse sleep runs; keep challenge/vote beats across morning–evening; mix top thoughts into moments
 - `video/persona_ranker.py`: shared day-memory fetch supports event+thought; pass Doubland start into timeline/chats
 - `video/test_day_overview_facts.py`: clock, schedule span, and thought-mix regressions

- [x] **Cast digest: readable per-Double layout + deduped moments**
 - `video/summarize_cast_day.py`: timed schedule/moments lists; `_top_moments` uses same content-dedupe + survival boost as the ranker
 - `video/test_day_overview_facts.py`: format + dedupe regressions

- [x] **Cast digest: keep today's eliminated Double + sort day stories by score**
 - `video/summarize_cast_day.py`: include people voted out today in per-Double stories; markdown order high→low score; day-windowed moments
 - `video/test_day_overview_facts.py`: sort-order regression

- [x] **Ranker top-5 poignancy: dedupe + hard day window + survival-plot boost**
 - `video/persona_ranker.py`: unique content before top-5; day_start/day_end snapshot window (borrow cohort cutoff if eliminated); floor p=9 for vote/elim/token plot text
 - `video/test_day_overview_facts.py`: unit coverage for dedupe, boost, and hard window
 - `double-docs/TODO_post_mvp.md`: PM-MEM-1..5 memory cleanup backlog (post-MVP)

- [x] **Ranker: give +50 elimination bonus on Survival Day 1 (engine day 2)**
 - `video/persona_ranker.py`: `_eliminated_today_names` uses season↔engine day mapping (same fix as vote facts)
 - `video/test_day_overview_facts.py`: regression — season day 1 boot is today on engine day 2 only

## 2026-07-08 — Ivan — branch: railway

### Backend

- [x] **Fix cast-digest vote day mapping (grace vs Survival Day 1)**
 - `video/summarize_cast_day.py`: map `eliminated[].day` (season) onto engine calendar day so Survival Day 1 boots show as today, not yesterday
 - `video/extract_day_log.py`: `_elimination_on_trailer_day` uses season↔engine conversion (grace day never has a boot)
 - `video/build_fact_ledger.py`: same season-day mapping in season-state fallback
 - `video/test_day_overview_facts.py`: regressions for grace / Survival Day 1 / Day 2 vote placement

## 2026-07-08 — Ivan — branch: ivan/class-a-planned-vs-actual

### Backend

- [x] **MVP Class A: stop false hop/patrol bugs + stopword-safe label matching**
 - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: add `attach_actual_tile_address` — record sprite tile without overwriting planned contract address
 - `reverie/backend_server/reverie.py`: emit keeps planned `resolved_address`; tile goes to `actual_tile_address` only
 - `tests/analyze_action-location.py`: Class A scores planned contract address (not empty-arena floor tile)
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: label↔object match ignores stopwords/place tokens; boost exact object-name hits
 - `tests/test_planned_vs_actual_address.py`, `tests/test_label_anchor_reconcile.py`: regressions for bookshelf hop false Class A and computer/desk stopword failures

## 2026-07-08 — Ivan — branch: railway

### Backend

- [x] **Fix truncated location picks scored as hallucinations (Tier 2 RCA cheap fix)**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: raise unified location call `max_tokens` 100 → 800 — the call runs with reasoning effort high on V4 Flash, and thinking tokens were eating the 100-token answer budget
 - `reverie/backend_server/tests/test_complex_allowlist_token_budgets.py`: new regression test — every reasoning-allowlisted function must declare max_tokens ≥ 500

## 2026-07-07 — Ivan — branch: ivan/completed-sim-resume-subprocess

### Backend

- [x] **PL-13: completed/stopped sprint sims resume via fresh subprocess when no local process**
 - `api_gateway/app/services/background_tasks.py`: route completed/stopped + step>0 + no OS process to `start_simulation(fork_from=self)`; stdin continuation only when process exists; no optimistic `running` before spawn
 - `api_gateway/app/api/routes/simulations.py`: PL-13b stale `running` + any step + no process allows `/start` (zombie recovery)
 - `api_gateway/tests/test_completed_sim_continuation.py`, `api_gateway/tests/test_live_scheduler.py`: regression coverage

## 2026-07-07 — Ivan — branch: railway

### Backend

- [x] **P0 persona↔persona chats on VPS — trigger + persistence fix, validated on probe**
 - `reverie/backend_server/reverie.py`: post-step chats stamped `step+1` (`post_step=True`, `_chat_trigger_step`) so greeting sweep / stale-chat guard do not drop payloads before serialization
 - `reverie/backend_server/reverie.py`: extracted `_run_backend_proximity_scan` — runs every step even when `observations/pending.json` is missing/empty; uses end-of-step `personas_tile` (not start-of-step positions)
 - `tests/test_post_step_chat_persistence.py`, `tests/test_proximity_scan_unconditional.py`: regression coverage
 - VPS probe `20260707-chat-probe-v3` @ step 50 on `761f3a0a`: 200 proximity attempts, 16 movement chat rows, 14 chat memories (prior sign-off runs had 0 — root cause was scan gated behind never-created observation queue + old deploy `b2230c51`)

## 2026-07-06 — Ivan — branch: railway

### Backend

- [x] **P0 fix: persona chats triggered post-step were never persisted to movement payload**
 - `reverie/backend_server/reverie.py`: chats triggered in the post-step observation pass are now stamped step+1 so the next step's greeting sweep / stale-chat guard no longer erase them before serialization
 - `tests/test_post_step_chat_persistence.py`: regression tests for the step stamp and the sweep survival

- [x] **Phase 3.0 script grounding — cast digest, fact ledger, narration fact gate**
 - `video/summarize_cast_day.py`: one-fetch all-Double day digest + `cast_digest.md` / `cast_ranking.json`
 - `video/build_fact_ledger.py`: deterministic survival/vote facts for Writer; slim `day_log.json`
 - `video/narration_facts.py` + `validate_trailer.py`: hard gate; Writer retries on ledger mismatch
 - `video/extract_day_log.py`: fix `_elimination_on_trailer_day` (no phantom Day-2 Alex boot)
 - `video/persona_ranker.py`: `rank_all_personas`; `generate_trailer.py` + `showrunner.py` wired
 - `video/test_day_overview_facts.py`: golden bad-script regression (6 tests pass)

---

## 2026-07-06 — Ivan — branch: railway

### Backend

- [x] **Kill LLM location hallucinations at the source (map data + prompt + parse)**
  - `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`: Remove 3 phantom `common room bench` objects (House 4/5/6) that had no map tiles and no Supabase rows — registry now matches tiles/Supabase exactly (222/222/222).
  - `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt`: Add verbatim-copy and named-object grounding rules to the location prompt.
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Normalize LLM picks (case/whitespace/leading world segment) against the valid tree before validation, so formatting slips stop counting as hallucinations.
  - `tests/test_location_pick_normalization.py`: New regression tests for the normalization classes seen in the 20260705 sign-off.

---

## 2026-07-05 — Ivan — branch: ivan/memory-writes

### Backend

- [x] **Restore Supabase memory writes on duplicate OpenRouter project (zero rows since 06-09)**
  - `supabase/migrations/20260705220000_restore_dbl_memory_identity.sql`: Re-add lost `GENERATED ALWAYS AS IDENTITY` on `dbl_memory.memory_id` (dropped during project clone; every insert failed 23502 silently). Applied live — running sim resumed writing rows + embeddings with no code change.
  - `supabase/db_reference.md`: Note identity requirement on `dbl_memory.memory_id`.

---

## 2026-07-05 — Ivan — branch: railway

### Backend

- [x] **Align Cursor agent model policy — Composer default, Fable for hard tasks**
  - `.cursor/rules/model-selection.mdc`: Removed (superseded by global `subagent-delegation.mdc`).
  - `.cursor/agents/*.md`: Six lookup subagents with `model: composer-2.5` (no worklog-writer).
  - `AGENTS.md`: New durable agent memory at repo root.

---

## 2026-07-04 — Ivan — branch: railway

### Backend

- [x] **Stop post-validate guard from bouncing actions that name their own object (Class A Issue 1)**
  - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Add `_action_names_address_object` and exempt `bed_non_sleep`/`whitelist` cascades when the action description names the resolved object; staff_only and affordance gates unchanged.
  - `tests/test_post_validate_object_exemption.py`: New tests — "making bed"/"getting dressed from the closet" survive post-validate; drift and staff_only still bounce.

- [x] **Generalize orphan anchor redirect to handle any home object**
  - `reverie/backend_server/persona/cognitive_modules/plan.py`: Replace `_redirect_orphan_bed_anchor` and `_redirect_orphan_closet_anchor` with single `_redirect_orphan_anchor_object` that redirects absent home-objects to persona's living_area (or nearest accessible arena); skips other personas' private rooms, gender-restricted venues, staff-only objects for non-workers; wired at all 3 call sites.
  - `tests/test_orphan_anchor_redirect.py`: New test file with 11 tests covering real `20260703-or-2` Class A redirect cases.
  - `tests/test_class_a_subaction_redirects.py`: Update assertions for the new generalized wiring.
  - `tests/test_orphan_bed_redirect.py` + `tests/test_orphan_closet_redirect.py`: Delete (superseded by generalized handler).

---

## 2026-07-03 — Ivan — branch: railway

### Backend

- [x] **Tier 1.5 label-object force pass + 18:00 dinner handover rule**
  - `reverie/backend_server/persona/cognitive_modules/plan.py`: New post-contract pass that snaps the resolved object to the object the sub-task label names (guards: travel labels, place-name overlap, staff-only for non-workers); closes 3/6 residual Class A cases from `20260703-or-1` in replay.
  - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt` + `generate_hourly_schedule_v2.txt`: Dedicated 6:00 PM DINNER HANDOVER rule — dinner owns 18:00; end-of-shift chores invalid at that hour.
  - `tests/analyze_action-location.py`: Gap 2 staff bypass now reads per-persona `work_area` from scratch instead of the hardcoded Luba entry.
  - `tests/test_label_anchor_reconcile.py` + `test_hourly_schedule_calendar.py`: 7 new tests; `test_class_a_anchor_repoint.py` + `test_class_a_subaction_redirects.py`: fix stale wiring assertions from the merge rename.

- [x] **Score Run 2 (`20260701-1`) A/B vs Run 1 + push fork-default-sprint fix**
  - `tests/analyze_20260630_1.py`: Accept sim code as CLI argument so the Run-1 scorer can score Run 2 unchanged.
  - `api_gateway/app/api/routes/simulations.py` + `api_gateway/tests/test_parallel_launch_endpoints.py`: Pushed the already-committed fork-default-sprint fix (`0b045c6d`) to origin so the VPS can pull it.

---

## 2026-07-03 — Ivan — branch: ivan/daily-trailer

### Video (L-Talks script_cos VO)

- [x] **One-shot narration for team script_cos.md v2 @ 1.2×**
  - `video/render_ltalk_cos_oneshot.py`: Render `script_cos.md` as single eleven_v3 warm take → `double-ivan/video/l-talk/audio/experiments/script_cos_oneshot_speed12/` (83.4s).


### Video (L-Talks VO experiment)

- [x] **v6 Anya-style phrase overlap mix (one-shot + crossfade)**
  - `video/narration_overlap_mix.py`: Cut v1 one-shot into phrases (bounds from v5 speech weights), re-chain with ffmpeg `acrossfade` (0.18s) instead of silence gaps.
  - `video/render_ltalk_vo_experiment.py`: Add `v6_phrase_overlap` variant → `audio/experiments/v6_phrase_overlap/` (~82.4s, 30 segments).

- [x] **5-way L-Talks narration experiment for pacing/flow decision**
  - `video/render_ltalk_vo_experiment.py`: Render v1–v5 variants (one-shot speed 1.5/1.2, block `[short pause]` tags, six block one-shots, manual segmented) → `double-ivan/video/l-talk/audio/experiments/*/`.
  - `double-ivan/video/l-talk/audio/experiments/README.md` + `manifest.json`: Listening scorecard and measured durations (v4 86.6s/6 segs, v5 80.2s/30 segs, v1–v2 ~87.5s/1 seg).

## 2026-07-02 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Verify L-Talks baseline pre-sim memories in prod Supabase**
  - `supabase/verify_ltalks_baseline_seed.sql`: Reusable SQL check (cast=15, backstory non-empty, legend markers, each persona names the other 14); rerun against child forks by editing the sim-code CTE.
  - Confirmed live on prod project `jawqllnvvlmosxlwjrei`: all 15 personas pass every check (`learned` marker, `currently` marker, non-empty innate/learned/currently, 14/14 cohort names present).

- [x] **Seed L-Talks cohort origin legend into soul15 baseline scratch**
  - `souls/soul15_scenario_legend.json`: Agent-facing Press Play cohort legend (roster-aware, idempotency markers).
  - `scripts/seed_scenario_legend.py`: Patches `learned` (permanent ISS) + premiere `currently` on `soul15_seed_20260224` via Supabase RPC; dry-run/apply, backup, rollback.
  - `tests/test_seed_scenario_legend.py`: Unit tests for merge/idempotency helpers.

### Video (L-Talks opener VO iteration)

- [x] **Tune L-Talks opener VO pacing: drop trailing "What if?", restore + densify pauses**
  - `double-ivan/video/l-talk/script/script.json` + `script.md` + `HANDOFF.md`: Remove trailing "What if?" so narration and final card both end on "what would MY Double do?"; restructure end card so "WHAT WOULD MY DOUBLE DO?" is the final headline with doubland.ai + Episode schedule as supporting lines. Opening hook "WHAT IF…" untouched.
  - `double-ivan/video/l-talk/script/script.json` + `script.md` + `HANDOFF.md` + `README.md` + `brief/scenario-writer-brief.md` + `reference/TODOs-opening-trailer.md`: Restore block-level `[PAUSE]` markers and add `[PAUSE 0.1s]` between every intra-block sentence. Verified hypothesis that explicit short pauses are tighter than eleven_v3's natural inter-sentence breath: 88.71s / 35 segments vs 95.42s / 24 (original) and 96.64s / 1 (no-pause).
  - `audio/narration.mp3` + `narration_timing.json`: Re-rendered via `python -m video.render_ltalk_vo` (eleven_v3 warm @ 1.5×).

### Video (L-Talks opener prep)

- [x] **Prepare L-Talks opener VO render path for Anya handoff**
  - `video/render_ltalk_vo.py`: One-off runner that renders the locked `narrator_script` from `double-ivan/video/l-talk/script/script.json` with the opener `warm` profile (`eleven_v3` @ 1.5×) → `audio/narration.mp3` + `narration_timing.json`. Needed because neither stock CLI applies the warm profile to a user-supplied script.
  - `double-ivan/video/l-talk/audio/README.md`: Replace misleading `generate_trailer` command (regenerates script from wrong sim) with the correct `python -m video.render_ltalk_vo` invocation.
  - `double-ivan/video/l-talk/script/script.md` + `script.json`: Flip status from draft v1 → locked (2026-07-02).
  - `double-ivan/video/l-talk/HANDOFF.md`: Reflect locked script, ready VO runner, simplified next-steps.

## 2026-07-02 — Ivan — branch: railway

### Backend

- [x] **Fix fork defaulting to live mode (chunk-and-stall root cause)**
 - `api_gateway/app/api/routes/simulations.py`: Fork's else-branch (generation_mode unspecified) now defaults to `"sprint"` instead of `"live"`. Previously, with `DEFAULT_OWNER_TIMEZONE` set on the VPS, forked sims silently enrolled in live chunking → stalled when the scheduler didn't re-wake (Run 2 `20260701-1` stalled at step 847 for ~16h). Live is now opt-in via `generation_mode:"live"`.
 - `api_gateway/tests/test_parallel_launch_endpoints.py`: Added `test_fork_defaults_to_sprint_when_mode_unspecified` regression test. Note: 2 pre-existing unrelated failures in this file (`test_fork_resets_status_to_stopped`, `test_fork_live_mode_enrolls` — "mock awaited 0 times") fail on committed code too; not touched.

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Daily-trailer cast panel: baseline-cohort hero-photo fallback for forked sims**
  - `video/showrunner.py`: Added `_baseline_cohort_slug` (walks `double.simulations.parent_simulation_id` fork chain in Supabase to the root baseline, cached) and `_resolve_baseline_hero_path` (resolves hero/portrait image by agent_id from `video/assets/cohort/<baseline>/`); all establishing-scene hero lookups now fall back to the baseline cohort when the fork-named folder is absent.
  - `video/test_hero_baseline_fallback.py`: New tests covering hero-folder hit, portraits fallback, no-baseline, and missing agent_id cases.

- [x] **Day-overview narration now reliably lands inside the <90s word budget**
  - `video/showrunner.py`: Narration Writer budget now reserves the composed intro-card words (arc-only band), per-beat MAX-word caps added to the writer prompt, and over-length retries feed back the exact word count with a hard rewrite target; validator counts against the arc band with the intro reserve explained in the error.

- [x] **C2: editorial-motion + asset-presence validator gates added**
  - `video/validate_trailer.py`: Added `_check_asset_presence` (cross-references scene hero_path/sketch_path against disk; hard-fails on missing files, reports arc scenes with no asset) and `_check_editorial_motion` (samples frames at 2fps, measures visual-change rate ≥16/min and near-static intervals ≤2.5s per SOT §11.2); both wired into day_overview and opener validation paths.
  - `video/test_validate_c2_gates.py`: 5 tests covering asset-presence pass/fail/no-asset cases and editorial-motion skip + real-render smoke check.

- [x] **B1: manual moment-clip drop-in slot for 2D→3D blend**
  - `video/build_day_remotion_props.py`: Added `_resolve_moment_clip` (checks `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4` convention path) and `_day_from_dir_name` helper; arc beats now use a dropped clip as the beat's `video` prop when present, falling back to the generic opener loop when absent.
  - `video/test_moment_clip_dropin.py`: 5 tests covering path resolution, override behavior, and fallback.

- [x] **B2: surface event location — action address → friendly location name**
  - `video/showrunner.py`: Added `_location_from_action` (parses `@ world:sector:arena:tile` from timeline action strings → returns sector as friendly name) and `_resolve_beat_location` (finds driver's nearest timeline entry at the beat's focal_step); arc scenes in `_stitch_overview_script` now carry a resolved `location` field instead of empty string.
  - `video/build_day_remotion_props.py`: Arc beats (pressure/world/turn) now pass `locationLabel` from the scene's `location` field into the Remotion beat dict.
  - `video/test_location_resolver.py`: 7 tests covering sector extraction, nearest-step resolution, missing driver, empty timeline, and malformed addresses.

- [x] **C3: Supabase `trailer_asset` read at render time**
  - `video/trailer_asset_store.py`: New module — `get_asset(sim_code, persona_id, asset_type)` queries `double.trailer_asset` (handles NULL sim_code/persona_id for global rows); `register_asset(...)` upserts on the unique key.
  - `video/showrunner.py`: Added `_resolve_hero_from_trailer_asset` (queries `trailer_asset` for the baseline cohort's `hero_spotlight` row by persona_id, resolves via `metadata.local_path`); `_hero()` in `_stitch_overview_script` now tries Supabase first, then fork-named cohort folder, then baseline-cohort agent_id fallback.
  - `video/test_trailer_asset_read.py`: 6 tests covering metadata.local_path resolution, no-row fallback, qa_status=rejected rejection, missing local file, missing agent_id, missing baseline slug.

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Day-overview trailer under 90s + opener-matched pauses**
 - `video/showrunner.py`: Cut per-scene pause from `[PAUSE 1s]` to `[PAUSE 0.15s]` (matches opener's ~0.1-0.2s pause scale, ~3s total silence vs the prior ~10s). Retuned duration to land <90s: `DAY_OVERVIEW_TARGET_RUNTIME` 100→75, `RUNTIME_BOUNDS` (90,150)→(60,105), `NARRATION_BOUNDS` (210,420)→(130,175) using the empirically-measured 1.5x delivery rate ~2.1 words/sec (from the 007 render: 240 words→117s speech; the Chunk B ~3.0 wps assumption was wrong). Per-beat writer target 2.5→1.8 wps and advisory message ~3.0→~2.1 wps. Writer budget guidance "aim for lower end"→"aim for middle" so it targets ~150 words (~80s video) instead of under-shooting. Writer cache key v5→v6.
 - `video/validate_trailer.py`: Tighten `day_overview` duration band (65,120)→(65,95) to enforce the <90s target (the 134s 007 render was failing even the old 120 cap).

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Day-overview voiceover: warm tone + 1.5x speed to match opener, simpler language, weave in who-each-Double-is**
 - `video/showrunner.py`: Narration writer SYSTEM prompt gains a PLAIN LANGUAGE rule (marketer-simple, banned strategy-jargon shapes) and a WHO THEY ARE rule (attach a few role/trait words on each featured Double's first mention, drawn from status_deltas/personality_summary, to explain why they act). Per-beat word target bumped 1.7→2.5 words/sec and bounds (140,280)→(210,420) to keep narration filling the video at the new 1.5x TTS pace; advisory pacing message updated to ~3.0 words/sec. Writer cache key bumped v4→v5.
 - `video/generate_trailer.py`: Apply the opener warm voice profile (eleven_v3, stability 0.60, speed 1.5) to `day_overview` TTS, not just `opener` — the daily was rendering at 1.0x with default stability, the root of the voiceover mismatch.

## 2026-07-01 — Ivan — branch: railway

### Backend

- [x] **Fix diagnostic_mode dropped on forked-sim start (live_mode continuation branch)**
 - `api_gateway/app/services/background_tasks.py`: Pass `parameters` through to `start_simulation` in the live-mode continuation branch so `diagnostic_mode` (and other params) reach the runner script. Previously forked-then-started sims silently ran `start_server()` instead of `_run_with_log_collection()`, producing no LLM/forensic logs.
 - `api_gateway/tests/test_live_scheduler.py`: Updated `test_live_mode_completed_sim_uses_fresh_subprocess` for the new call signature; added `test_live_mode_passes_diagnostic_mode_through`. Not deployed yet — current Run 2 (`20260701-1`) continues non-diagnostic; fix ships on next VPS deploy.

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 2 fix — ranker respects `--top N` as a minimum; producer decides lead count**
 - `video/persona_ranker.py`: Removed the quiet-day fallback that cut `--top 3` to 1 when the score spread was tight (< 1.5×). The ranker now returns the top `top_n` always; the Day Story Producer (Step 2) decides how many of them to feature (1–4) based on the day's signal. Removed the now-unused `QUIET_DAY_RATIO` constant + updated the module docstring. Decision (Ivan, 2026-07-01): let the producer decide.
 - `video/test_build_day_remotion_props.py`: Reworded the single-protagonist test docstring (N=1 now comes from `--top 1` / small cohort, not the removed fallback). 9 tests pass.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 2 fix — producer gracefully handles N=1 protagonist (no name hallucination)**
 - `video/showrunner.py`: Producer SYSTEM + USER prompts now state the available protagonist count explicitly and bind `featured_doubles` to it ("NEVER more than you were given; NEVER a name not in the valid-drivers list; a single-lead day is fine when only 1 is available"). Strengthened the no-invent-names guardrail. Fixes the real Day-2 crash where a quiet-day ranker cut `--top 3` to 1 protagonist and the LLM hallucinated two extra names ("Max Shoemaker", "Irene Dove") to hit the old 2–4 target.
 - `video/test_build_day_remotion_props.py`: Added `test_producer_single_protagonist_plan` — single-lead plan passes validation; a hallucinated name is still rejected. 9 tests pass.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 2 — multi-lead + moment-driven day story engine + Day≥2 cold-viewer intro**
 - `video/showrunner.py`: Producer prompt rewritten to rank events → select 1–3 moments → select 2–4 `featured_doubles` → draft a flexible 3–6 `beat_plan` (fixed 5-beat template demoted to a fallback shape). Writer prompt threads 2–4 Doubles instead of one lead. `_story_producer_validate` now checks flexible vocabulary + structural rules (yesterday_scar only Day>1 beat#1; elim/non-elim pair exclusivity; driver ∈ featured_doubles) with a soft 2–4 advisory. `_stitch_overview_script` adds a brief Day≥2 cold-viewer intro (concept-reset card + featured-cast card naming today's heroes) before the `yesterday_scar` arc beat; Day-1 keeps the full establishing layer using `featured_doubles`. Bumped cache keys to `day_overview_story_v3` / `day_overview_narration_v4`. Removed the now-unused `_expected_beat_sequence` helper.
 - `video/build_day_remotion_props.py`: Cast panel is multi-lead-aware — each featured Double's portrait is pulled from its cast_intro scene, or from any arc scene where it's the focus_persona (so Day≥2's single cast card still shows all featured Doubles).
 - `video/test_build_day_remotion_props.py`: Added producer-validator (flexible plan accepted; bad counts / driver-not-featured / vote_reveal-without-elim rejected), Day≥2 stitch intro, and multi-lead cast-panel tests. 8 tests pass.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 1 Chunks D–E — opener-styled establishing/bridge + daily questionToUrlTakeover end card**
 - `video/build_day_remotion_props.py`: Day-1 concept-reset beat surfaces the opener poster band (`showBandCaption`); Day≥2 "Previously on" bridge beat carries the opener hook ambient layers (`showAiCore`, `showInkFigures`, `matrixLines`, `subline`). End-card `question` now uses the producer's `dramatic_question` (fallback "What happens tomorrow?") with `cadence` carrying the "DAY N ENDS" label + daily cadence line; removed a dead `day_n` line from Chunk A.
 - `video/test_build_day_remotion_props.py`: Added Day-2 bridge test (asserts Phase2 fields on the hook beat) + end-card test (asserts dramatic_question + cadence/cohortLabel). 5 tests pass.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 1 Chunk C — extend day_overview validator to the opener gate set**
 - `video/validate_trailer.py`: day_overview now checks the 9:16 master (1080×1920) + integrated loudness (reusing the opener's existing checks), drops the legacy 16:9 dimension check; duration rebanded (65–120s) for vertical pacing; `_check_narration_fits_video` probes `trailer_9x16.mp4` first with a tighter 1s headroom (no brand-opener pad on Remotion).
 - `video/test_build_day_remotion_props.py`: Added `test_validate_day_overview_gate_set` asserting the 9:16/LUFS gate presence and 16:9 absence. 3 tests pass.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 1 Chunk B — route day_overview onto the Remotion 9:16 render shell**
 - `video/render_opener_remotion.py`: Extract the npx+poster+loudnorm+copy machinery into a shared `render_remotion_trailer`; `render_opener_trailer` now builds opener props then delegates to it.
 - `video/render_day_remotion.py`: New thin wrapper — builds day-overview props then calls the shared shell; mirrors the opener skip-if-exists guard.
 - `video/generate_trailer.py`: `--mode day_overview` now skips Phaser recording (Step 4) and routes to `render_day_trailer` (Step 5) instead of `compose_trailer`; `--skip-render`/`--voice-profile` extended to day_overview.
 - `video/test_build_day_remotion_props.py`: Added skip-path test for `render_day_trailer`. Both tests pass under pytest.

---

## 2026-07-01 — Ivan — branch: ivan/daily-trailer

### Backend

- [x] **Step 1 Chunk A — day-overview Remotion props builder (migrate daily onto opener 9:16 stack)**
 - `video/build_day_remotion_props.py`: New module maps daily scenes (concept_reset/cast_intro/yesterday_scar/arc beats) onto existing opener Remotion beat types, reuses opener asset-staging + SFX + text-track helpers, emits a TrailerProps JSON the unchanged `OpenerTrailer` composition renders. Daily `questionToUrlTakeover` end card with "Day N ends — What happens tomorrow?" copy.
 - `video/test_build_day_remotion_props.py`: Synthetic-fixture test asserts valid beat types, time ordering, endCard phase order, per-scene text-track captions, SFX roles. Passes standalone.

---

## 2026-07-01 — Ivan — branch: railway

### Backend

- [x] **Merge OpenRouter integration branch into railway (Phase 6)**
 - `railway`: `--no-ff` merge of `ivan/openrouter-railway-merge` (commit `a7cff6bc`); pushed to origin. Brings OpenRouter plumbing (dormant under OpenAI env), work_area auto-assign, Tier 1 label↔anchor reconcile, reindex scripts, WebGL log suppression.
 - Decision: skip Phase 5 separate validation; Run 2 (2,600-step OpenAI, same seed as Run 1) serves as A/B merge-regression check vs `20260630-1`. Investigate residuals after Run 2.

---

## 2026-07-01 — Ivan — branch: ivan/openrouter-railway-merge

### Backend

- [x] **Rebase OpenRouter branch onto railway (Phase 2-3 of merge plan)**
 - `tests/analyze_action-location.py`: Resolved rebase conflict — kept railway Supabase refactor + re-applied OpenRouter CLI-arg (`sys.argv[1]`) and startup print line.
 - `.gitignore`: Resolved rebase conflict — took railway version (strict superset; already had `supabase/_tmp_*` + `exports/*`).
 - `reverie/.../plan.py`, `reverie.py`, `run_gpt_prompt.py`: Auto-merged cleanly (no manual resolution needed).
 - Verified: 39 OpenRouter tests pass, daily_plan_cleanup 6 pass, survival RCA refix 2 pass, label_anchor_reconcile fires.

---

## 2026-06-30 — Ivan — branch: railway

### Backend

- [x] **Fix day-overview premiere day + Story Producer driver validation**
  - `video/extract_day_log.py`: Map survival `eliminated[].day` to engine calendar day (premiere / engine day 1 has no vote-out).
  - `video/showrunner.py`: List allowed beat drivers in Story Producer prompt so LLM cannot pick non-top-3 names (e.g. Mike Hooks).

- [x] **Fix opener render cohort slug for sim codes with hyphens (e.g. 20260628-4)**
  - `video/generate_trailer.py`: Resolve asset folder from `video/assets/cohort/<sim_code>/manifest.json` before falling back to cohort display name (`leadertalks`).

## 2026-06-30 — Ivan — branch: ivan/remove-meal-pass-crutch-20260630

### Backend

- [x] **Remove deterministic meal-pass crutch (C-1) — meals now emerge naturally from the planner**
  - `reverie/backend_server/persona/cognitive_modules/plan.py`: Delete `_ensure_meal_blocks`, its constants, and its call in `_long_term_planning`; meals and sleep now land organically via the daily-plan cleanup fix and the FOLLOW THE PLAN hourly rule.
  - `tests/test_ensure_meal_blocks.py`: Delete test file along with the removed helper.

## 2026-06-30 — Ivan — branch: ivan/hourly-follow-plan-20260630

### Backend

- [x] **Make hourly schedule LLM treat the daily_req breakdown as authoritative**
  - `reverie/backend_server/persona/prompt_template/v2/generate_hourly_schedule_v2.txt`: Add a "FOLLOW THE PLAN" rule at the top of ACTIVITY RULES requiring each hour's activity to match the daily_req breakdown item, including meals and the bedtime/sleep item.
  - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: Same FOLLOW THE PLAN rule for the survival hourly template, with challenge/vote events as the only permitted overrides.
  - `tests/test_daily_planning_prompt_meals.py`: Add tests asserting both hourly templates carry the FOLLOW THE PLAN rule inside ACTIVITY RULES, referencing the sleep/bedtime item.

## 2026-06-30 — Ivan — branch: ivan/daily-plan-cleanup-fix-20260630

### Backend

- [x] **Repair daily-plan cleanup so meals + sleep flow through naturally (RCA-2 / Batch 3b fix)**
  - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Extract cleanup to module-level `_clean_up_daily_plan_response`; add time-anchored fallback so meals and sleep the LLM generates are no longer discarded by the numbered-list-only parser.
  - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: Add RESPONSE FORMAT block before the seed so the model stays in compact numbered-list mode instead of drifting into verbose time-anchored output that truncates at dinner.
  - `tests/test_daily_plan_cleanup.py`: New unit tests covering numbered-list primary path, time-anchored fallback recovering meals + sleep from diag5, preamble skipping, and empty-input edge cases.
  - `tests/test_daily_planning_prompt_meals.py`: Assert the baseline template contains the RESPONSE FORMAT block between ACTIVITY RULES and the seed.
  - `tests/test_survival_rca_refix_20260630.py`: Fix `get_embedding` monkeypatch to `raising=False` to resolve import-order fragility exposed by the new cleanup test.

---

## 2026-06-30 — Ivan — branch: ivan/survival-rca2-meal-pass-20260630

### Backend

- [x] **Add deterministic post-generation meal pass to guarantee lunch and dinner blocks**
  - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add `_ensure_meal_blocks` helper and wire it into `_long_term_planning` after `generate_hourly_schedule`, splitting the covering block to insert a 60-min lunch (~12:00) and dinner (~18:00) whenever the LLM omits them and no challenge/vote/sleep event is in the way.
  - `tests/test_ensure_meal_blocks.py`: New unit tests covering insertion with correct 1440-min sum, skipping existing meals, skipping challenge and sleep blocks at meal times, empty schedule unchanged, and input immutability.

---

## 2026-06-30 — Ivan — branch: ivan/survival-rca2-hourly-meals-20260630

### Backend

- [x] **Add natural meal guidance to hourly schedule prompt templates**
  - `reverie/backend_server/persona/prompt_template/v2/generate_hourly_schedule_v2.txt`: Add ACTIVITY RULES guidance recommending lunch ~12:00 and dinner ~18:00, skippable when urgent commitments arise.
  - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: Same natural meal guidance for the survival day-2+ hourly template, with challenge/vote as the urgent commitments that can displace a meal hour.
  - `tests/test_daily_planning_prompt_meals.py`: Add prompt-shape tests asserting both hourly templates carry natural meal guidance without hard MUST-include language.

---

## 2026-06-30 — Ivan — branch: ivan/survival-rca2-template-fix-20260630

### Backend

- [x] **Add REQUIRED MEAL SLOTS to survival premiere prompt template (RCA-2 fix)**
  - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: Add lunch (~12:00) and dinner (~18:00) meal slot rules above ACTIVITY RULES — the survival premiere routes to this template, not daily_planning_v6.txt, so the earlier RCA-2 meal fix had no effect.
  - `tests/test_daily_planning_prompt_meals.py`: Add two regression tests asserting the survival template contains REQUIRED MEAL SLOTS and that resolve_template routes survival personas to the correct template.

## 2026-06-30 — Ivan — branch: railway

### Backend

- [x] **Typed start parameters in Swagger /docs for simulation control**
  - `api_gateway/app/models/simulation.py`: Add `SimulationStartParameters` and `StartSimulationRequest` so OpenAPI lists max_steps, fork_from, generation_mode, owner_timezone, diagnostic_mode.
  - `api_gateway/app/api/routes/simulations.py`: Wire `/start` to typed request; typed stop `force` param.
  - `api_gateway/tests/test_start_openapi_schema.py`: Assert OpenAPI schema exposes all run parameters.

---

## 2026-06-30 — Ivan — branch: ivan/survival-rca-refix-20260630

### Backend

- [x] **Supersede vote directive in daily_plan_req on post-vote injection (RCA-1 re-fix)**
  - `reverie/backend_server/survival/controller.py`: Replace the morning vote-prep directive with "vote has concluded — return home and rest" at post-vote injection so same-day replan doesn't regenerate vote-prep.
  - `tests/test_survival_rca_refix_20260630.py`: Add integration-style test running the real replan path with mocked LLM asserting no vote-prep schedule past elimination, plus a unit test for the supersession.

- [x] **Promote required meal slots to a dedicated prompt section for salience (RCA-2 re-fix)**
  - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: Add a dedicated "REQUIRED MEAL SLOTS" section above ACTIVITY RULES listing lunch (~12:00) and dinner (~18:00) as structural constraints for greater prompt salience.
  - `tests/test_daily_planning_prompt_meals.py`: Add prompt-shape test asserting REQUIRED MEAL SLOTS section appears before ACTIVITY RULES and before the plan-generation seed.

---

## 2026-06-30 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Tier 1: label↔anchor reconcile on inherit path**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: `_reconcile_anchor_with_label` prefers label-named object over decomp anchor; detach when label points outside parent arena; post-validate on inherit path with lazy-bind for circular-import safety.
 - `tests/test_label_anchor_reconcile.py`: Unit + integration tests (Dean computer/counter case, detach, agree).
 - `.gitignore` + `supabase/_tmp_*`: Removed 37 tracked scratch files; gitignore prevents recurrence.

---

## 2026-06-29 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Run 1c: Flash + selective reasoning on Tier B allowlist**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Re-populate `OPENROUTER_TIER_B_COMPLEX_ALLOWLIST` (6 functions → `reasoning.effort=high`).
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Bump `max_tokens` on decomp, daily plan, replan, conversation batch, and action location prompts.
 - `reverie/backend_server/tests/test_openrouter_reasoning_control.py`: Assert allowlist functions get `effort=high`, routine Tier B stays `none`.

---

## 2026-06-29 — Ivan — branch: railway

### Backend

- [x] **API diagnostic_mode for VPS log-collection test runs**
  - `reverie/backend_server/log_collection_profile.py`: Shared import-time and runtime env for forensic runs.
  - `reverie/backend_server/reverie.py`: `_run_with_log_collection` uses shared profile helpers.
  - `api_gateway/app/services/simulation_control.py`: `parameters.diagnostic_mode` spawns runner with `_run_with_log_collection` + pre-import env (movement JSON, LLM capture).
  - `api_gateway/app/api/routes/simulations.py`: Echo `diagnostic_mode` in start response.
  - `api_gateway/tests/test_simulation_runner_script.py`, `reverie/backend_server/tests/test_log_collection_profile.py`: Runner compile + env profile tests.
  - `log_collection_profile.py` / `simulation_control.py`: Strict opt-in parser (`diagnostic_mode` absent → false); default runner stays `start_server`.

---

## 2026-06-29 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Live sim naturalness report bundle for 20260628-10-openrouter**
 - `tests/analyze_action-location.py`: Resolve storage and maze_registry paths from repo root instead of hardcoded legacy `generative_agents` directory.
 - `tests/reports/20260628-10-openrouter_naturalness_report.md`: Comprehensive realism/survival/action-location/chat-payload report (890 steps, live run).

---

## 2026-06-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Batch 2: open-ended survival seasons (default `total_days=0`); `SURVIVAL_TOTAL_DAYS` env flag removed**
 - `reverie/backend_server/reverie.py`: Drop `total_days` from `SurvivalController` init config (was sourced from removed `SURVIVAL_TOTAL_DAYS`).
 - `reverie/backend_server/survival/state.py`: Default `total_days` to 0 in `__init__` and `from_dict` (open-ended); legacy capped sims keep their cap via the persisted DB column.
 - `reverie/backend_server/survival/controller.py`: Gate the day-cap win path on `total_days > 0`; add stall-safety (stats-winner after 2 dry days) for open-ended sims; add `_days_since_last_elimination` (derived from `season.eliminated`, restart-safe); add `_format_day_label` ("Day N — X players remain" vs "Day N of M") used by `_advance_day` log, identity overlay, and daily-plan req; pass `initial_player_count` (alive + eliminated) to `get_challenge_for_day`.
 - `reverie/backend_server/survival/challenges.py`: `get_challenge_for_day` selects compact-vs-full schedule from `initial_player_count` (≤6 → compact) instead of `total_days`; legacy `total_days`-keyed selection kept as fallback for backwards compat.
 - `.env.local`: Delete `SURVIVAL_TOTAL_DAYS=3` line.
 - `tests/test_survival_open_ended.py`: New — 18 tests covering open-ended default, day-cap gating, stall-safety, `_days_since_last_elimination`, day-label phrasing, overlay/daily-plan-req open-ended text.
 - `tests/test_survival_challenges.py`: Add 4 tests for `initial_player_count`-driven compact schedule selection + legacy fallback.
 - `supabase/db_reference.md`: Add `total_days` to `survival_season_state` column list; document open-ended default and stall-safety.
 - `D:\Coding\double-docs\sot\sot_survival.md`: Replace `SURVIVAL_TOTAL_DAYS` references with open-ended semantics; add season-length/open-ended-default entry.

### Backend

- [x] **Batch 3a: premiere-day meals — required lunch + dinner blocks in the baseline daily-planning prompt**
 - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: Add ACTIVITY RULES making a ~12:00 pm lunch block and a ~6:00 pm dinner block mandatory (not skippable, not pushable past 2/8 pm); clarify breakfast at Home does not satisfy either.
 - `tests/test_daily_planning_prompt_meals.py`: New — 6 prompt-shape tests asserting the required-meal rules, time anchors, late-drift guards, and breakfast-exclusion clause.

## 2026-06-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix post-vote plan lag (§13.1) — survivors stop vote-prep within 1 step of elimination and play a return-home evening sequence instead of snapping to a 1440-min sleep**
 - `reverie/backend_server/survival/controller.py`: `_inject_post_vote_outcome` now builds a compact post-vote evening schedule (padding + head-home → unwind → reflect → get-ready → sleep summing to 1440), invalidates the currently-executing action (`act_address`/`act_start_time`/`act_duration` etc. → None, `force_replan_next_step = True`) so `act_check_finished` returns True next step, and sets a `_post_vote_injected_for[name]` gate so `_apply_survival_lifestyle` doesn't clobber the post-vote schedule same-day. Gate cleared in `_reset_daily_flags` at midnight. Root cause: old code cleared `f_daily_schedule` to `[]` (degenerate `["sleeping", 1440]` fallback) and never touched the running action, so the old vote-prep block ran for its full remaining duration (30–90+ sim min lag in `20260628-4`).
 - `tests/test_survival_rca_20260627.py`: Extended `_Scratch` stub with action-state fields + `get_f_daily_schedule_index` mirror; updated P0-3 test to assert new schedule shape; added tests for action invalidation, schedule-sums-to-1440 + correct index, same-day gate blocks lifestyle rewrite, midnight reset clears gate, and very-late-vote (<60 min to midnight) collapse to single block.

---

## 2026-06-28 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Copy missing baseline tables to new Supabase project (data integrity fix)**
 - `supabase/_tmp_copy_missing.py`: Exported `persona_scratch` (34 rows) and `persona_profile_snippets` (243 rows) from old project via MCP `execute_sql`, inserted via supabase-py upsert. `persona_scratch` was the root cause of `missing work_area` startup failure — it was never copied during the initial project fork.
 - `address_translations`, `maze_bounds`, `maze_instance_tiles`: Verified 0 baseline rows on old project — all runtime data from past simulations, correctly skipped.
 - `simulation_persona_state`: 30 baseline rows exist but table is not referenced anywhere in `reverie/` or `api_gateway/` — sim builds spatial memory from `maze.address_tiles` via `_populate_spatial_memories()`. Skipped as non-critical.

## 2026-06-29 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Fix .env.local + add work_area auto-assign for parallel OpenRouter sim**
 - `.env.local`: Commented out `DBL_WORKER_KEY` (old project's custom secret caused 401 against new project — code uses it before `SUPABASE_SERVICE_ROLE_KEY`). Fixed UTF-8 encoding (em-dash byte broke `load_dotenv`). Set `SUPABASE_ONLY_MODE=false` (baseline lacks Supabase scratch rows).
 - `reverie/backend_server/reverie.py`: Added `_auto_assign_work_areas()` — assigns `work_area` from non-residential maze sectors for personas missing it (analogous to `_auto_assign_living_areas()`). Called in both startup paths. Fixes readiness gate that blocked `run` on baselines created before onboarding.

## 2026-06-29 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Reindex 10K seed memories with Gemini + fork test simulation on new project**
 - `scripts/reindex_embeddings.py`: Switched `_update_embedding` from `.update()` to `.upsert()` so it works on a fresh `dbl_embedding` table (INSERT) as well as on an existing one (UPDATE). Full reindex completed: 10,215/10,215 ok, 0 fail, 768-d vectors, ~80 min.
 - `supabase/`: Forked `base_family_sim` → `20260628-or-test1` via `public.fork_simulation` on the new `double-openrouter` project. 4 personas (Gosha, Ivan, Katya, Luba), status `running`, start 06:30.

## 2026-06-28 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Set up second Supabase project `double-openrouter` for parallel OpenRouter testing**
 - `supabase/`: Created project `kkjhsozszgoorwehhsdg` (us-east-2, $10/mo). Extracted full schema from existing `double` project via `pg_catalog` queries (49 tables, 128 constraints, 87 indexes, 4 sequences, 126 functions, 100 RLS policies, 2 triggers) and applied to new project in sections (tables→sequences→constraints→indexes→RLS→functions via multi-pass for dependencies).
 - `supabase/`: Copied baseline data — maze (14K tiles, 6 chunks, 1 template), 40 personas, 23 profile docs, 34 sprite assets, 4 baseline simulations, 38 agents, 10,215 seed memories (without embeddings). Dropped `dbl_agent_user_id_fkey` (references project-specific `auth.users`) to allow cross-project agent copy.
 - `supabase/`: Exposed `double` schema via PostgREST (`PATCH /v1/projects/{ref}/postgrest` with `db_schema=public,graphql_public,double`). Granted ALL on `double` tables to `service_role` and CRUD to `anon`/`authenticated`. Granted EXECUTE on all `public`/`double` functions.
 - `.env.local`: Updated `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` to point to new project `kkjhsozszgoorwehhsdg` so the OpenRouter worktree uses the parallel database while the legacy worktree keeps the existing `double` project.
 - `scripts/reindex_embeddings.py`: Running real Gemini reindex on 10,215 seed memories to populate `dbl_embedding` with 768-d OpenRouter/Gemini vectors (batch size 100, ~103 API calls).

## 2026-06-28 — Ivan — branch: ivan/survival-rca-20260627-2 → railway

### Backend

- [x] **Deploy + `/survival` endpoint fix + doc status summary**
 - `api_gateway/app/api/routes/simulation_control.py`: Move `/survival` endpoint into the router `main.py` actually mounts (was in the unmounted orphan `app/routes/simulation_control.py`) — commit `07a0aca9`.
 - `api_gateway/app/routes/simulation_control.py`: Remove the dead `/survival` copy (clean up the orphan my earlier edit created).
 - VPS deploy: killed a rogue manual uvicorn process (PID 2589859) holding port 8001 and serving stale code, so systemd `double-api` could bind and serve `07a0aca9`. All four BE surfaces verified live via the remote gateway (`day_label` on highlights, `is_survival`/`current_day_label`/`engine_day` on `/status/current`, `/survival` 200 with `Cache-Control`).
 - `double-docs/15sim-polish.md`: Add top-of-doc Status summary (observed issues / applied fixes / remaining todos); update §9.9 #8 to "Done + deployed (BE + FE)"; changelog entry for the deploy + fix.

## 2026-06-28 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Phase 1 smoke: 20-step sim on OpenRouter + disable Tier B complex allowlist**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Empty `OPENROUTER_TIER_B_COMPLEX_ALLOWLIST` — V4 Flash thinking tokens consume the entire `max_tokens` budget (300–1400) and leave zero output. Phase 1 smoke confirmed `daily_plan` (500 tok), `task_decomp_contextual` (1400 tok), and `task_decomp_contextual_repair` (1200 tok) all returned EMPTY with `effort=high`. All `effort=none` functions produced output. V4 Flash @ none (71.2 GPQA) is still smarter than gpt-5-nano @ minimal.
 - `reverie/backend_server/tests/test_openrouter_reasoning_control.py`: Update tests to reflect empty allowlist — external_replan gets healing+require_parameters but `effort=none`; daily_plan gets `effort=none` with `exclude=true`.
 - Smoke result (sim `20260628-2`, 4 personas, 20 steps): all 20 movement files written, all 4 personas moved (Gosha 23 tiles, Ivan 27, Katya 6, Luba 21). No embedding errors, no 429s, no parse-retries. WebGL console errors are cosmetic (headless Chrome has no GPU; A* pathfinding is CPU-based and worked). STATUS/COMPLETED markers missing because browser session terminated before final bookkeeping — sim data is complete on disk.
- [x] **Suppress headless WebGL console spam + confirm second smoke run**
 - `reverie/backend_server/headless_visualization.py`: Filter Three.js WebGL context-creation errors in `_log_browser_console` — headless Chrome has no GPU so these fire every step but are cosmetic (A* is CPU-based, canvas fallback renders PNGs). Real browser errors still logged.
 - Smoke result (sim `20260628-2-openrouter`, 4 personas, 20 steps): COMPLETED.json written, daily plans non-empty for all 4 personas (838–1779 chars), 0 blocked pathfinding rows, 0 monitoring errors. Smoke `20260628-3-openrouter`: same clean result — 20 steps, COMPLETED marker, all personas with final positions/activities.

## 2026-06-28 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Phase −1 spike run + critical `encoding_format` fix**
 - `tests/openrouter_spike.py`: Add `encoding_format="float"` to all OpenRouter embedding probes (SDK 2.21+ defaults to base64, which OpenRouter's Gemini endpoint doesn't return → `ValueError: No embedding data received`); fix Qwen fallback slug `0.6b` → `4b` (the 0.6b slug doesn't exist on OpenRouter; 4b and 8b do).
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Add `encoding_format="float"` to the OpenRouter embedding path in `_create_embedding_request` — without it, every embedding call via OpenRouter raises `ValueError` because the SDK defaults to base64.
 - `api_gateway/app/services/chat_with_double_service.py`: Same `encoding_format="float"` fix on `_embed_message` OpenRouter path.
 - `scripts/reindex_embeddings.py`: Same fix on `_embed` so the reindex script doesn't hit the same base64 parse failure.
 - Spike results (all critical probes PASS): thinking-disabled via `reasoning.effort=none` ✅, `temperature=0` ✅, `json_schema` strict ✅, response-healing ✅, provider routing ✅, 50-call burst 0 errors ✅, Gemini 768-d ✅, semantic ranking sensible ✅, Qwen3-4b fallback ✅. Tier A p95 ≈ 800–900ms (OpenAI baseline still TBD).

---

## 2026-06-28 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **Pre-reindex safety: multi-target reindex + reverse path + schema fix**
 - `scripts/reindex_embeddings.py`: Extend to cover `dbl_semantic_facts` alongside `dbl_embedding` (TARGETS dict, `--target` flag, default "all"); relax provider guard so `--dry-run` works as a pre-flight check; fix `double` schema access via `supabase.schema("double")` (latent bug — tables live in `double`, not `public`).
 - `scripts/reindex_embeddings_reverse.py`: New sibling script that restores OpenAI `text-embedding-3-small` vectors (1536-d → stride-2 → 768-d) on top of Gemini vectors, so a data rollback path exists in code form. Same targets + guards (refuses unless model is OpenAI and provider is not openrouter).
 - Dry-run confirmed: `dbl_memory`→`dbl_embedding` = 232,024 rows to reindex; `dbl_semantic_facts` = 0 rows (empty table — future-proofed).

---

## 2026-06-28 — Ivan — branch: ivan/survival-rca-20260627-2

### Backend

- [x] **FE contract corrections for survival day-label surfaces (4 fixes)**
 - `supabase/migrations/20260628150000_day_highlights_day_label.sql`: Add `day_label text` to `day_highlights` (applied to remote `double`).
 - `video/build_highlights.py`: `_season_day_labeling` now returns the BE-owned `day_label` string ("Premiere"/"Survival Day N"/"Day N"/null); thread it into the result, `save_highlights` call, and the CDN artifact payload.
 - `video/highlights_store.py`: `save_highlights`/`fetch_highlights` carry `day_label`.
 - `api_gateway/app/services/day_highlights_service.py`: Gateway highlights endpoint now selects + returns `day_label` + season columns (closes the gap where neither path surfaced the season fields).
 - `api_gateway/app/api/routes/simulation_control.py`: `/status/current` now carries `is_survival`, `current_day_label`, `engine_day` (best-effort; survival-RPC failure can't break family-sim status).
 - `api_gateway/app/services/live_scheduler.py`: `build_live_manifest` carries `is_survival`; add cached `is_survival_sim` helper (one existence check per sim per process) and call it from `_publish_pending`.
 - `api_gateway/app/routes/simulation_control.py`: `/survival` endpoint returns `JSONResponse` with `Cache-Control: s-maxage=60, stale-while-revalidate=300` (CDN-cacheable for the `/play` route; already CORS-public + unauthenticated).
 - `tests/test_survival_operator_labeling.py`: Extend labeling tests for `day_label`; add 4 tests for `build_live_manifest.is_survival` + `is_survival_sim` caching/failure.
 - `supabase/db_reference.md`, `double-docs/sot/sot_survival.md`, `double-docs/20260628_fe_inquiry_survival_day_labels.md`: Update contracts to reflect both highlights paths now ship `day_label`, `/status/current` + CDN manifest carry `is_survival`, and `/survival` is CDN-cacheable.

## 2026-06-28 — Ivan — branch: ivan/survival-rca-20260627-2

### Backend

- [x] **P0-6 BE operator surfaces: label engine-day vs survival-season-day everywhere**
 - `supabase/migrations/20260628140000_day_highlights_season_labeling.sql`: Add `season_day_number` (int) + `is_grace_day` (bool) to `day_highlights` (applied to remote `double`).
 - `video/build_highlights.py`: Add `_season_day_labeling` (engine day 1 → grace; N>1 → season day N-1) and thread `season_day_number`/`is_grace_day` into the result + `save_highlights`; add `--season-day N` CLI alias (maps to engine day N+1) with `--day`-on-survival hint.
 - `video/extract_day_log.py`: Add shared `resolve_season_day` helper (season-day→engine-day mapping, survival-sim hint, non-survival error) and wire `--season-day` into the CLI.
 - `video/highlights_store.py`: `save_highlights`/`fetch_highlights` carry the two new season columns.
 - `reverie/backend_server/survival/controller.py`: Qualify elimination + vote-concluded broadcast prose as "Survival Day N (engine Day N+1)".
 - `api_gateway/app/routes/simulation_control.py`: New `GET /api/simulations/{sim_code}/survival` endpoint serving `current_day_label` + `engine_day` + remaining/eliminated counts for the FE HUD.
 - `api_gateway/app/services/supabase_service.py`: Add `get_survival_season_state` returning the full season row (reused by the new endpoint).
 - `tests/test_survival_operator_labeling.py`: New — 10 tests (elimination prose qualifier, season labeling grace/survival/non-survival/full-range, resolve_season_day mapping/hint/error/passthrough).
 - `supabase/db_reference.md`: Document the two new `day_highlights` columns.
 - `double-docs/sot/sot_survival.md`: Add "Operator surfaces (BE-furnished)" subsection under Day indexing.
 - `double-docs/15sim-polish.md`: §9.9 follow-up #8 + changelog entry.

## 2026-06-28 — Ivan — branch: ivan/survival-rca-20260627-2

### Backend

- [x] **Survival RCA fixes for sim 20260627-2 (P0-1, P0-3/P0-5, P0-4, P1)**
 - `reverie/backend_server/survival/controller.py`: Time-box vote spatial gate to `vote_deadline_hour - 1` so the morning challenge gather can't satisfy it; add `_inject_post_vote_outcome` (appends "vote concluded" naming the eliminated Double to each survivor's plan, clears their `f_daily_schedule`, broadcasts a `vote_concluded` memory) called from `_execute_elimination`; clear `_identity_overlay_cache` at elimination; use `season.current_day` in `build_identity_overlay` instead of `days_survived`; persist state in `_advance_day` so `survival_season_state.current_day` stays current.
 - `tests/test_survival_rca_20260627.py`: New — 10 tests covering all four chunks (overlay day/eliminated, cache clear, advance_day persist, gate time-box, post-vote outcome injection + idempotency).

## 2026-06-27 — Ivan — branch: ivan/openrouter-deepseek-v4

### Backend

- [x] **OpenRouter migration Phase 0 — DeepSeek V4 + Gemini embeddings (provider-gated, OpenAI rollback-safe)**
  - `reverie/backend_server/persona/prompt_template/model_router.py`: add `_create_openrouter_client`/`_is_openrouter_provider`, openrouter capability, tier-promotion no-op guard, structured+reasoning+provider-prefs adapters, Gemini embedding default, DeepSeek/Gemini cost buckets.
  - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: route chat+embedding requests through the OpenRouter factory first when `LLM_PROVIDER=openrouter`; thread `input_type` into `get_embedding` via `extra_body`.
  - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: provider-aware embedding defaults, `v3-gemini` index bump, `input_type` plumbing, skip stride-2 compression for OpenRouter (Gemini returns 768-d natively).
  - `api_gateway/app/core/config.py`: add `openrouter_api_key`/`openai_base_url`/`llm_provider`/attribution-header settings.
  - `api_gateway/app/services/chat_with_double_service.py`: provider-aware async client, Gemini embedding model+768-d dimensions, OpenRouter embedding path with no stride-2 compression.
  - `video/showrunner.py`: route direct LLM calls through the OpenRouter factory when provider is openrouter.
  - `scripts/reindex_embeddings.py`: standalone Supabase reindex tool for the Gemini embedding switch (write-only — not run in Phase 0).
  - `tests/openrouter_spike.py`: Phase -1 live probe script (thinking-disabled, json_schema strict, healing plugin, latency/burst, Gemini-768d, OpenAI baseline) — write-only, gated on key.
  - `reverie/backend_server/tests/test_openrouter_*.py` (7 new): unit cover for client factory, provider modes, structured adapter, reasoning control, provider prefs, embedding switch, replay tolerant, cost telemetry; existing `test_model_router_provider_modes.py` extended.

## 2026-06-27 — Ivan — branch: ivan/dev

### Backend

- [x] **Per-sim sprint vs live generation profile on fork/start**
  - `api_gateway/app/services/sim_generation_profile.py`: `generation_mode` (`sprint`|`live`) sets `live_mode` + timezone per sim.
  - `api_gateway/app/api/routes/simulations.py`: fork/start wire-up; legacy fork with env tz defaults to `live`.
  - `reverie.py` + `owner_timezone_bootstrap.py`: respect `live_mode=false` (no auto-enroll, no env tz bootstrap).
  - `perceive.py`: guard null perception subject (step-0 crash on VPS).

- [x] **Supabase-first action/location analyzer with disk fallback**
  - `tests/analyze_action-location.py`: `--source supabase|disk|auto`, pulls coords/scratch/season RPC, rebuilds movement blobs for scan(), skips disk-only monitoring in Supabase mode, Ivan Pitts sleep fix, REPO_ROOT paths.

---

## 2026-06-26 — Ivan — branch: ivan/dev

### Backend

- [x] **Phase 5 polish + soul15 opener VO run (skip-render)**
  - `register_cohort_trailer_assets.py` + `trailer_storage.py`: register/upload `group_anim`.
  - `export_relationship_graph.py`: `--manifest` 15-node ring graph; auto-wire in props builder.
  - `generate_trailer.py`: `--skip-render` for Phase 5-only runs; sim_code as cohort slug.
  - Output: `data/soul15_seed_20260224/opener&001/` — 29 segments, ~98s narration, trailer voice.

- [x] **Rename cohort group motion `family_anim` → `group_anim`; living-cast Grok prompt**
  - `video/asset_manifest.py`, `build_opener_remotion_props.py`, `opener_beat_map.py`: `group_motion` / `group_anim.mp4`; cohort `motion/` override.
  - Remotion: `familyVideo` → `groupVideo` on concept beat props.
  - `prompt_log.md`: v2 prompt — bodies unfreeze, micro-interactions, not camera-only push-in.

---

- [x] **Opener VO default preset → warm (documentary delivery)**
  - `video/tts.py`: `OPENER_VOICE_PROFILE` points at `warm`; comment updated.
  - `video/generate_trailer.py`, `build_opener_remotion_props.py`: CLI `--voice-profile` default `warm`.
  - Canonical warm take: `data/soul15_seed_20260224/opener&003/`.

---

## 2026-06-25 — Ivan — branch: ivan/dev

### Backend

- [x] **Soul15 opener pipeline glue — 15-cast segments, trailer VO, spotlight integrate**
  - `video/opener_beat_map.py`: dynamic cast segment indices + `min_package_a_segments()` (29 for 15 cast).
  - `video/showrunner.py`: trait-only narration for `fifteen_spotlight_montage`; wider duration/word bounds.
  - `video/extract_day_log.py`: manifest-first opener context; `top_n` up to 15.
  - `video/export_cohort_manifest.py`: export Supabase cohort config → JSON.
  - `video/build_opener_remotion_props.py` + `build_fifteen_spotlight_props.py`: dynamic segment gate; integrate-opener stages narration/music.
  - `video/validate_trailer.py`: soul15 runtime band 90–105s from manifest.
  - `video/generate_trailer.py` + `video/tts.py`: `--top` up to 15; default voice `trailer`.
  - `tests/test_fifteen_spotlight_beat_map.py`: `min_package_a_segments(15)` test.

---

- [x] **Decouple content swap from scale in matrix→hero morph**
  - `video/remotion/src/components/matrixGridLayout.ts`: tile content-in → scale-up → scale-down → content-out phases.
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: `MorphTileLayer` swaps card/photo at tile size before/after fullscreen scale.
  - `video/remotion/src/components/MatrixIdentityGrid.tsx`: `skipEntrance` prevents grid re-zoom on spotlight cuts.
  - `video/fifteen_spotlight_beat_map.py`: spotlight beats 2.6s / 3.0s for phased morph.
- [x] **Remove morph glow pulse; versioned spotlight preview outputs**
  - `video/remotion/src/components/matrixGridLayout.ts`: drop animated glow/grid-scale; static roster fade on scale only.
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: no hold pulse or box-shadow beats on morph box.
  - `video/build_fifteen_spotlight_props.py`: `next_spotlight_preview_name()` → `_vN.mp4` iteration.
- [x] **Show name/trait during scale-up and scale-down (not only fullscreen hold)**
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: `SpotlightCaption` on morph scale phases + immediate hold text.
  - `video/remotion/src/components/matrixGridLayout.ts`: `spotlightCaptionOpacity()` timing helper.
## 2026-06-25 — Ivan — branch: ivan/dev

### Backend

- [x] **Supabase cohort trailer manifest + asset registry (Phase 0a–1c)**
  - `supabase/migrations/20260625120000_cohort_trailer.sql`: `cohort_trailer_config`, `cohort_trailer_cast`, `trailer_asset`.
  - `video/cohort_manifest_store.py`, `video/trailer_asset_store.py`, `video/trailer_storage.py`, `video/supabase_client.py`: store + Storage helpers.
  - `video/import_cohort_manifest.py`, `video/register_legacy_trailer_assets.py`, `video/validate_cohort_assets.py`: soul15 seeded (15 cast, 90 assets).
  - `video/showrunner.py`: prefer `cohort_trailer_cast.trait_line` over LLM narration.
  - `video/narration_cache.py`: `put_cached_content` for seeded trait mirror.
  - `supabase/db_reference.md`, `reverie/backend_server/storage_config.py`: bucket + table docs.

- [x] **Soul15 opener cohort manifest for trailer asset pilot**
  - `video/assets/cohort/soul15_seed_20260224/manifest.json`: 15 personas, locked approved trait lines, spotlight order, character-sheet/walkout paths; no manual approval gate in auto-pipeline policy.

- [x] **Move sprite walkout MP4 uploads to trailer-assets bucket**
  - `video/trailer_storage.py`: BUCKET_SPRITE_WALKOUT and persona path use trailer-assets/personas/{id}/sprite-walkout.mp4.
  - `video/register_legacy_trailer_assets.py`: Walkout upload and register target trailer-assets instead of user-sprites.
  - `supabase/migrations/20260625180000_sprite_walkout_trailer_assets_bucket.sql`: Migrate trailer_asset rows to new bucket and path.
  - `supabase/db_reference.md`, `reverie/backend_server/storage_config.py`: Document trailer-assets walkout storage.
  - `tests/test_cohort_trailer_store.py`: Unit test asserts walkout uses trailer-assets bucket.

- [x] **Grok hero + portrait pipeline and cohort upload/register**
  - `video/assets/scripts-prompts/generate_opener_hero_assets.py`: Grok Imagine hero spotlight and portrait crop per persona with optional `--upload`.
  - `video/assets/scripts-prompts/prompts_opener_hero_assets.md`: Locked hero_spotlight and portrait_crop prompts for soul15 Phase 1.
  - `video/register_cohort_trailer_assets.py`: Upload and register cohort hero/portrait assets to trailer-assets bucket.
  - `video/trailer_storage.py`: Add `sim_portrait_path` helper for cohort portrait storage paths.

- [x] **3:4 face-biased portrait post-crop for opener assets**
  - `video/opener_portrait_crop.py`: 3:4 face-biased post-crop to 720×960.
  - `video/assets/scripts-prompts/generate_opener_hero_assets.py`: Post-crop after Grok portrait; `--normalize-portraits` flag.
  - `video/assets/scripts-prompts/prompts_opener_hero_assets.md`: 3:4 prompt + post-process note.
  - `tests/test_cohort_trailer_store.py`: Crop unit tests.

- [x] **Strict validation gates cutout, hero_spotlight, portrait_crop; 14 soul15 cutouts uploaded to Supabase**
  - `video/validate_cohort_assets.py`: Gate cutout, hero_spotlight, and portrait_crop in strict validation with separate global vs cohort type sets.
  - `tests/test_cohort_trailer_store.py`: Test asserts required asset type sets for validation.
  - Generated and uploaded 14 soul15 cutouts to Supabase (cutouts gitignored).

- [x] **Soul15 group photo rows A/B/C via Grok API**
  - `video/assets/scripts-prompts/generate_group_photo_row.py`: Generate soul15 group row A/B/C via Grok multi-image edit API (3-image limit).

- [x] **Soul15 sim-level group photo merge, matrix filter, register and validate**
  - `video/trailer_storage.py`: Add `sim_group_photo_path` and `sim_group_photo_matrix_path` storage helpers.
  - `video/assets/scripts-prompts/generate_group_photo_merge.py`: New Grok script merging rows A/B/C into vertical `group_photo.png`.
  - `video/assets/scripts-prompts/generate_matrix_photo.py`: Add soul15 15-person matrix prompt and cohort-aware Grok prompt selection.
  - `video/register_cohort_trailer_assets.py`: Register sim-level `group_photo` and `group_photo_matrix` to trailer-assets.
  - `video/validate_cohort_assets.py`: Require `group_photo` and `group_photo_matrix` in cohort validation.
  - Generated and uploaded soul15 `group_photo.png` and `group_photo_matrix.png` to Supabase.

- [x] **Cast group layout + matrix poster pipeline for sizes 3–15**
  - `video/cast_group_layout.py`: Row tier and poster layout rules for cast sizes 3–15.
  - `video/assets/scripts-prompts/generate_matrix_photo.py`: Tight crop, shoulder brackets prompt, Pillow HUD text overlay.
  - `video/opener_beat_map.py`: Pass `castSize` and `posterLayout` into opener beats.
  - `video/build_opener_remotion_props.py`: Pass `castSize` and `posterLayout` into Remotion props.
  - `video/remotion/src/beats/ConceptPoster.tsx`: Dual-weighted and sequential poster modes.
  - `video/remotion/src/types.ts`: Poster layout types for dual_weighted and sequential modes.
  - `tests/test_cast_group_layout.py`: Layout unit tests.
  - Regenerated and uploaded soul15 `group_photo_matrix.png` to Supabase.

- [x] **Balanced 6–8 cast row splits + assign_cast_to_rows**
  - `video/cast_group_layout.py`: Balanced 6–8 row splits (3+3, 4+3, 4+4); add `assign_cast_to_rows()`.
  - `tests/test_cast_group_layout.py`: Updated row-size assertions and assign-cast test.

- [x] **Balanced three-row splits for cast sizes 11–15**
  - `video/cast_group_layout.py`: Balanced three-row splits for 11–15 (4+4+3 through 5+5+5).
  - `tests/test_cast_group_layout.py`: Assertions for 11–15 row splits.

- [x] **Remove duplicate HUD overlays from matrix photo pipeline**
  - `video/assets/scripts-prompts/generate_matrix_photo.py`: Skip Pillow HUD overlay on Grok path (was duplicating Grok text); prompt asks for single HUD line only.
  - `video/remotion/src/beats/ConceptPoster.tsx`: Remove Remotion HUD text overlay (baked into matrix asset).
  - Regenerated soul15 `group_photo_matrix.png`.

- [x] **Phase 3a-3c fifteen_spotlight_montage**
  - `video/remotion/src/components/ActiveDoublesGrid.tsx`: 15-person grid panel.
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: Intro, hero spotlight, and full-cast matrix beats.
  - `video/fifteen_spotlight_beat_map.py`: Cast block timing and beat builder.
  - `video/build_fifteen_spotlight_props.py`: Preview props from manifest.
  - `video/build_opener_remotion_props.py`: Auto-replace cast beats when `cast_strategy=fifteen_spotlight_montage`.
  - `video/remotion/src/OpenerTrailer.tsx`: Wire fifteen-spotlight beat sequence into opener trailer.
  - `video/remotion/src/types.ts`: New beat types for fifteen-spotlight montage.
  - `tests/test_fifteen_spotlight_beat_map.py`: Beat map unit tests.

- [x] **3a-v2 matrix identity filmstrip intro**
  - `video/matrix_hud.py`: Rule-based HUD labels/stats from tags+career.
  - `video/remotion/src/components/MatrixIdentityCard.tsx`: Single persona matrix card with portrait and stat bars.
  - `video/remotion/src/components/MatrixIdentityFilmstrip.tsx`: Horizontal scrolling filmstrip of identity cards.
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: Replace 5×3 grid with filmstrip intro.
  - `video/fifteen_spotlight_beat_map.py`: INTRO_SEC 4.5s, pass matrixHud.
  - `video/build_fifteen_spotlight_props.py`: Attach matrix_hud per member.
  - `tests/test_matrix_hud.py`: Unit tests for matrix HUD builder.
  - Regenerated spotlight preview MP4.

- [x] **3a-v3: static 5×3 matrix identity grid (readable full tiles) + morph from grid card to hero spotlight**
  - `video/remotion/src/components/MatrixIdentityGrid.tsx`: Static 5×3 matrix identity grid with readable full tiles.
  - `video/remotion/src/components/matrixGridLayout.ts`: Shared grid geometry and ~0.48s morph-out timing.
  - `video/remotion/src/components/MatrixIdentityCard.tsx`: Responsive grid tile sizing for identity cards.
  - `video/remotion/src/beats/FifteenSpotlight.tsx`: Grid intro plus card-to-hero morph transition.
  - `video/fifteen_spotlight_beat_map.py`: `gridIndex` on hero beats; `INTRO_SEC` 3.5s.
  - `video/remotion/src/OpenerTrailer.tsx`: Pass `castMembers` and `gridIndex` into hero spotlight beat.
  - `video/remotion/src/types.ts`: `castMembers`, `gridIndex`, and `matrixHud` on hero spotlight beats.
  - Dropped `MatrixIdentityFilmstrip` carousel in favor of static grid.
  - Regenerated spotlight preview MP4.

---

## 2026-06-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Master verification addendum + locked product copy (PISTSOV, AI VERSION OF YOU)**
  - `video/opener_visual_planner.py`: Head/tail timing, WHAT IF @ 0.133s, reference→product text corrections in `build_text_track`.
  - `video/opener_beat_map.py`: `MASTER_VISUAL_END_SEC` 76.578, end-card `urlOnly` phase aligned.
  - `video/visual_spec/anya_reference/*.csv`: Synced from teadown master verification.
  - `video/remotion/src/components/AnimatedWordmark.tsx`: Default subtitle matches product copy.
  - `tests/test_opener_phase6a.py`: Head/tail and product-copy assertions.

---

## 2026-06-22 — Ivan — branch: ivan/dev

### Backend

- [x] **Phase 6B–6D visual grammar — poster, end card, cast panel, world/survival/turn UI (`opener&008`)**
  - `video/assets/scripts-prompts/generate_matrix_photo.py`: Matrix filter from cohort group photo (Pillow + Grok).
  - `video/remotion/src/beats/ConceptPoster.tsx`: Matrix/clean tiers, poster flash, deconstruct overlay.
  - `video/remotion/src/components/*`: QuestionToUrlTakeover, ActiveDoublesPanel, CardSelectZoom, MidUrlPlate, RadialObjectMatch, WorldMapHud, UiStateMorph, SurvivalDashboard, TurnDashboard.
  - `video/opener_beat_map.py`: posterFlash beat, END_CARD_TAIL 0.3s, cast/pressure/live/season/turn flags.
  - `tests/test_opener_phase6b.py`, `test_opener_phase6c.py`, `test_opener_phase6d.py`: Phase 6B–6D props tests (23 total with Phase 5/6A).

---

## 2026-06-24 — Ivan — branch: ivan/dev

### Backend

- [x] **Phase 6A visual spec foundation — CSV planner, text overlay, SFX track, section retiming**
  - `video/visual_spec/load_anya_reference.py`: Vendored producer CSVs; typed loader for sub-moments, text, SFX.
  - `video/opener_visual_planner.py`: Section windows, text track, SFX track with lead/lag offsets.
  - `video/opener_beat_map.py`: `build_package_a_beats_v2` retimes macro beats to producer sections; poster @ 12.6s.
  - `video/remotion/src/components/SharedCenterReplace.tsx`: Global center-axis text overlay from `textTrack`.
  - `video/build_opener_remotion_props.py`: Emits `visualSpec`, `subMoments`, `textTrack`, 40 SFX events.
  - `tests/test_opener_phase6a.py`: Loader, retiming, props shape tests (16 total with Phase 5).

---

## 2026-06-23 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix BeatCrossfade fadeIn=false crash and validate_trailer LUFS parsing**
  - `video/remotion/src/components/BeatCrossfade.tsx`: Branch opacity interpolate for fadeIn/fadeOut combos so HookContinuous (fadeIn=false) no longer hits invalid keyframes.
  - `video/validate_trailer.py`: Use final ebur128 I: LUFS summary line from stderr instead of the first progress sample.

---

## 2026-06-22 — Ivan — branch: ivan/dev

### Backend

- [x] **Incorporate loop-engineering improvements into global Cursor rules**
  - `C:\Users\ipist\.cursor\rules\implementation-loop.mdc`: Added Maker-Verifier Separation, Machine-Checkable Task Lists, Stronger Stop Conditions & Monitoring, and Starter Loop Catalog.
  - `C:\Users\ipist\.cursor\rules\coding-conventions.mdc`: Created global file with Maker-Verifier Split, Durable Agent Memory (AGENTS.md), Isolation for Parallel Agents, and Autonomous Loop Safety Defaults.
- [x] **Phase 5 P0 vertical trailer polish**
  - `video/opener_beat_map.py`, `video/build_opener_remotion_props.py`: Decouple beat map from visuals; type-then-hold text, Talk hero hook, end-card hold, poster export.
  - `video/remotion/src/beats/HookContinuous.tsx`, `video/remotion/src/beats/ConceptPoster.tsx`: Hook and concept poster Remotion beats.
  - `video/asset_manifest.py`: Central manifest ensuring Family.mp4 plays once.
  - `video/render_opener_remotion.py`, `video/tts.py`: VO profiles and SFX/loudnorm render wiring.
  - `tests/test_opener_phase5_p0.py`: Phase 5 P0 opener acceptance tests.

---

## 2026-06-22 — Ivan — branch: main

### Backend

- [x] **Trim video/repo junk from Git tracking before push**
  - `.gitignore`: Ignore Remotion generated output, superseded voice takes, cutouts, desktop.ini, and Supabase CLI cache.
  - Untracked generated Remotion props, validation report, cutouts, old narration MP3s, and `supabase/.temp/` (files kept locally).

---

## 2026-06-22 — Ivan — branch: ivan/live-mode-terminal-guards

### Backend

- [x] **Live mode terminal guards (PM-LIVE-1 / spend-leak P0)**
  - `supabase/migrations/20260622120000_live_mode_terminal_guards.sql`: add `sleeping` status; auto-clear `live_mode` on `completed`/`stopped`.
  - `api_gateway/app/services/live_scheduler.py`: wake only `running`/`sleeping`; skip terminal statuses.
  - `reverie/backend_server/reverie.py`: live chunk exit sets `sleeping`; log cost-telemetry flush failures.
  - `api_gateway/app/services/simulation_control.py`: preserve `sleeping` after chunk subprocess exit.
  - `api_gateway/app/api/routes/simulations.py`: `/stop` auto-unenrolls live sims with no local process.
  - `api_gateway/app/services/background_tasks.py`: structured JSON logs for `live_chunk_start`.
  - `reverie/backend_server/persona/prompt_template/cost_telemetry.py`: structured flush-failure log event.
  - `api_gateway/tests/test_live_scheduler.py`, `test_stop_endpoint.py`: scheduler terminal guard + stop un-enroll tests.
  - `supabase/db_reference.md`: document `sleeping` status and migration.

---

## 2026-06-17 — Ivan — branch: ivan/dev

- [x] **Phase 4: wire Remotion into generate_trailer opener pipeline**
   - `video/render_opener_remotion.py`: build Package A props + `npx remotion render` → `output/trailer_9x16.mp4`.
   - `video/generate_trailer.py`: opener Step 4 skips Phaser capture; Step 5 uses Remotion (no 16:9 FFmpeg).
   - `video/validate_trailer.py`: opener validates 9:16 only + integrated loudness (LUFS); duration band 65–95s.
   - `tests/test_validate_trailer_opener.py`: bounds regression test.

- [x] **Phase 2.5 + 3: Anya visual polish + per-cohort opener automation**
   - `video/remotion/src/components/`: `AiCoreRing`, `InkFigures`, `RelationshipGraph`, `GoldTransition`, `ColorGrade`, `PushIn`, `ParticleField`.
   - `video/opener_beat_map.py`, `video/build_opener_remotion_props.py`: shared 18-beat map + generalized props from any opener dir.
   - Rebuilt + rendered `video/remotion/out/pistsov_package_a.mp4` → 1080×1920 / 81.3s / 35.3 MB.
- [x] **Phase 2 motion graphics: wire Anya-style components into Package A trailer**
   - `video/remotion/src/components/`: `GlitchText`, `TypingText`, `MatrixReadout`, `WordSwapTitles`, `PressureGauges`, `LiveHudOverlay`, `AnimatedWordmark`, `BeatCrossfade`.
   - `video/remotion/src/beats/AnyaBeats.tsx`, `OpenerTrailer.tsx`: replace placeholder kinetic text; wrap beats in crossfades.
   - `video/build_anya_package_a_props.py`: emit per-beat `headline`, `matrixLines`, `titlePhrases` metadata.
   - Verified: `video/remotion/out/pistsov_package_a.mp4` → 1080×1920 / 81.3s / 26.8 MB.
- [x] **Package A: wire Anya opener assets into Remotion (18-beat Pistsov render)**
   - `video/build_anya_package_a_props.py`: maps locked `auto_match_v3_warm` narration timing to 18 visual beats; stages `opening-anya` PNGs/B-roll, flyover aerial, Katya character sheet, music + narration.
   - `video/remotion/src/beats/AnyaBeats.tsx`: hook/concept/wordmark/world/season/cast/pressure/live/turn/end-card components using staged assets.
   - `video/remotion/src/types.ts`, `OpenerTrailer.tsx`: Package A beat routing alongside legacy beats.
   - Verified: `video/remotion/out/pistsov_package_a.mp4` → 1080×1920 / 81.3s.

- [x] **Lock opener narration at 1.5× (Anya pacing ~76.7s) — bake into auto-gen**
   - `video/tts.py`: set `OPENER_VOICE_PROFILE` speed to **1.5×** (eleven_v3 / stability 0.60); opener mode only.
   - `double-ivan/20260501_opening-trailer.md`: v3.0 narration lock table + showrunner/tts rows marked DONE.
   - `double-ivan/20260617_vertical-trailer-automation.md`: narration spec + Phase 1b DONE.
- [x] **Tighten opener voiceover toward Anya's 76s cut (drop line, hard pauses, 1.4x → superseded by 1.5x)**
   - `video/showrunner.py`: remove the "And sometimes... you never noticed before" line from `OPENER_CONCEPT_LINE`; cut all baked-in pauses to 0.1–0.2s.
   - `video/tts.py`: bump `OPENER_VOICE_PROFILE` speed from 1.2× to 1.4×.

- [x] **Phase 1: code-driven vertical (9:16) opener-trailer engine to match Anya's hand cut**
   - `video/remotion/`: new Remotion project — data-driven composition (`Root.tsx`/`OpenerTrailer.tsx`), one component per beat (`beats/{ColdOpen,Concept,Cast,Stakes,EndCard}.tsx`), shared `KineticText`/`styles`, narration + ducked-music mix; renders 1080×1920 frame-locked to the voiceover.
   - `video/build_remotion_props.py`: new adapter reading `script.json` + `narration_timing.json`, deriving contiguous beat timings by matching narration lines, staging assets, writing the normalized props file (insulates the renderer from showrunner's script schema).
   - Verified: rendered `data/base_family_sim/opener&004` → 1080×1920 / 120.8s, all beats correct, fully offline.

---


## 2026-06-16 — Ivan — branch: railway

### Backend

- [x] **Add LIVE-mode generation pacing to cap sim run-ahead at ~90 steps in production**
   - `reverie/backend_server/live_pacing.py`: new module with pure pacing helpers — `LIVE_MAX_LEAD_STEPS=90`, `run_ahead_allowed()`, `owner_now_step()`, and `lead_exceeds_buffer()`.
   - `reverie/backend_server/reverie.py`: import live_pacing; add `_init_live_pacing()` (auto-enrolls sim via `set_live_mode` RPC, guards against null-timezone) and `_live_buffer_exceeded()`; main loop exits with `finalize reason="live_buffer"` when buffer is reached.
   - `api_gateway/app/services/live_scheduler.py`: add cross-reference comment noting `CHUNK_STEPS`/`LEAD_MIN_STEPS` must stay in sync with the engine mirror.
   - `reverie/backend_server/tests/test_live_pacing.py`: unit tests for buffer math, all passing.

---

## 2026-06-15 — Ivan — branch: railway

### Backend

- [x] **Fix timezone mismatch that froze live soak `20260613-1` on chunk resume**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: added `_as_naive()` helper and applied it in `_compute_overlap` and `_remaining_minutes` to strip tz-awareness before datetime subtraction, preventing `TypeError` when `act_start_time` is rehydrated as tz-aware from Supabase `timestamptz`.
   - `tests/test_conversation_manager.py`: added `TestTimezoneAwareScratch` regression class (3 tests) reproducing the aware `act_start_time` vs naive `curr_time` scenario.

---

## 2026-06-15 — Ivan — branch: ivan/dev

### Backend

- [x] **Waitlist link attribution + B2B capture (link-tracking Slice 1)**
   - `supabase/migrations/20260615120000_waitlist_source_attribution.sql`: new — adds `source` (default `landing-hero` on insert only), `interest_type` (`generic|b2b_group`), `group_name` + `(source)` / `(interest_type, created_at)` indexes to `double.waitlist`.
   - `api_gateway/app/api/routes/waitlist.py`: accept + sanitize the three fields; omit-to-preserve upsert — `source` last-write-wins, `interest_type`/`group_name` ratchet up only, invalid tags dropped (never 400).
   - `api_gateway/tests/test_waitlist_endpoint.py`: +8 tests (source sanitize/drop, b2b + group_name, generic omitted, truncation).
   - `supabase/db_reference.md`: waitlist row + migration log updated.

- [x] **YouTube description link tracking + watch-live CTA (link-tracking Slice 2 / closes TODO-15)**
   - `video/generate_description.py`: tag each scene link `source={campaign}-s{N}` (emitted-order index, no gaps); replace waitlist CTA with watch-live footer → `doubland.ai/?source={campaign}`; add `--source-campaign` CLI flag.
   - `video/generate_trailer.py`: `_yt_campaign_slug(mode, day, persona)` → passes `yt-d{N}` / `yt-d{N}-{persona}` / `yt-opener` campaign into the description generator.
   - `tests/test_generate_description.py`: +13 tests (scene-tag + no-gap, watch-live footer, campaign slug branches).

## 2026-06-15 — Ivan — branch: ivan/pl10-stop-via-api

### Backend

- [x] **PL-10 — POST /{sim}/stop reliably stops sims the gateway lost track of**
   - `api_gateway/app/services/simulation_control.py`: added `_find_processes_for_sim` (exact-match OS scan for `temp_runner_{sim}.py`), `has_active_process`, `_terminate_process_tree`, `_cleanup_temp_script`, and `_stop_untracked_simulation`; stop now kills untracked/direct/post-restart processes and only writes `status=stopped` when a process is actually terminated (SOT policy preserved when none found); deduped tracked-path force-kill to the shared helper.
   - `api_gateway/app/api/routes/simulations.py`: `/stop` route now does a synchronous process check (registry + OS scan) instead of the brittle `list_running_simulations` pre-check (the original 500 source); no-process → status unchanged + live-mode un-enroll hint; process found → submits the stop task.
   - `api_gateway/tests/test_stop_endpoint.py` (new): 7 tests covering exact-match scan, untracked kill (reproducer), no-process no-mutation, and route behavior.
   - `api_gateway/tests/test_status_sot_policy.py` / `test_simulation_endpoints.py`: reconciled existing stop tests to the new contract.

---

## 2026-06-12 — Ivan — branch: ivan/cdn-click-content

### Backend

- [x] **Step 6a — sprite manifest and day highlights published as CDN artifacts, eliminating per-viewer gateway calls**
   - `api_gateway/app/services/live_scheduler.py`: publish sprite manifest to `{sim}/sprite-manifest.json` in the step-bundles bucket (REST-parity body, 300s cache) with a once-per-process tick backfill for already-live sims.
   - `api_gateway/app/api/routes/simulations.py`: live-enroll branch publishes the sprite manifest on enrollment and reports `sprite_manifest_published` in the response.
   - `reverie/backend_server/step_publisher.py`: hoisted `upload_json` to module level for publisher delegation; added `highlights_path` and `HIGHLIGHTS_CACHE_CONTROL` constant.
   - `video/build_highlights.py`: calls `publish_highlights_artifact` from `main()` after the table write; failure is non-fatal.
   - `api_gateway/tests/test_live_scheduler.py`: 19 new tests covering publish paths/shapes, enroll/tick triggers, non-fatal failures, day-None skip, and main ordering.
   - `reverie/backend_server/tests/test_step_publisher.py`: new tests for the hoisted `upload_json` delegate and highlights publish path.
   - `tests/test_build_highlights.py`: new tests for `publish_highlights_artifact` call site, non-fatal failure, and post-table-write ordering.

---

## 2026-06-12 — Ivan — branch: ivan/p3-1-external-chat-reaction

### Backend

- [x] **P3-1 external inbox — injected gateway user chats now reach agent behavior**
   - `reverie/backend_server/persona/memory_structures/associative_memory.py`: collect externally-injected chat rows (`meta.source`) into an `external_inbox` at Supabase load; declare `external_source` on `ConceptNode`.
   - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: delegate `external_inbox` property to the underlying associative memory.
   - `reverie/backend_server/persona/memory_structures/scratch.py`: add persisted cursor `last_external_inbox_processed` for exactly-once delivery across chunk resumes.
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: drain one fresh inbox message per step into a perceived event, deferred while the agent is already chatting.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: external events get a novelty floor, deterministic selection, and a new `external_replan` reaction that switches the current action or splices a future schedule window.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: new Tier-B structured prompt call (`run_gpt_prompt_external_replan`) returning `{react, activity, duration, start}`; fail-safe leaves the schedule unchanged.
   - `reverie/backend_server/persona/prompt_template/v3_ChatGPT/external_event_replan_v1.txt`: new prompt template for the external-event replan decision.
   - `reverie/backend_server/persona/prompt_template/model_router.py`: register `run_gpt_prompt_external_replan` in `TIER_B_TASKS`.
   - `reverie/backend_server/tests/test_external_inbox.py`: 18 new tests (test-first), all green.

---

## 2026-06-12 — Ivan — branch: ivan/pl12-terminal-manifest

### Backend

- [x] **PL-12: un-enrolling a live sim now stamps a terminal status on the published CDN manifest so viewers don't wait at the live edge of an ended feed**
   - `api_gateway/app/services/live_scheduler.py`: added `TERMINAL_STATUSES`, `finalize_live_manifest_sync` (download manifest, patch `status`+`updated_at`, re-upload), and `publish_terminal_manifest` async wrapper.
   - `api_gateway/app/api/routes/simulations.py`: un-enroll path maps non-terminal row status to `"stopped"`, calls `publish_terminal_manifest` (non-fatal on failure), and includes `final_manifest_status` in the response.
   - `api_gateway/tests/test_live_scheduler.py`: 6 new tests covering manifest patch, never-published no-op, route terminal-status write, `running`→`stopped` mapping, enroll untouched, and failure keeping un-enroll 200.

---

## 2026-06-11 — Ivan — branch: ivan/pl11-fork-owner-timezone

### Backend

- [x] **PL-11 — fork endpoint now anchors owner timezone (DP7) for API/scheduler-started sims**
   - `api_gateway/app/api/routes/simulations.py`: POST /fork calls `set_owner_timezone` RPC immediately after the fork RPC, using the request field or `DEFAULT_OWNER_TIMEZONE` env; failure is non-fatal and the response reports the anchored tz or null.
   - `api_gateway/app/models/simulation.py`: `ForkSimulationRequest` gains an optional `owner_timezone` field.
   - `api_gateway/tests/test_parallel_launch_endpoints.py`: Four new tests covering explicit tz, env default, no-tz, and RPC failure leaving the fork intact; includes a fake-Supabase test helper.

---

## 2026-06-11 — Ivan — branch: ivan/live-chunk-scheduler

### Backend

- [x] **Fix survival analyzer false positives (dp8b vote gathering + ghost agents)**
   - `tests/analyze_sim_survival.py`: Use engine `day_number`/`curr_time` for survival-day grouping; measure gathering at 11:00/20:00 deadlines with `address_label`; ghost check uses survival calendar not step÷1440.
   - `tests/test_analyze_sim_survival_gathering.py`: Unit tests for calendar mapping, gathering pct, and elimination consistency.

---

## 2026-06-11 — Ivan — branch: ivan/live-chunk-scheduler

### Backend

- [x] **Survival game-over updates sim status + API completed inference (dp8b QA follow-up)**
   - `reverie/backend_server/reverie.py`: Unified `_finalize_simulation_run()` for step-budget and Survival exits — writes `movement/COMPLETED.json`, meta, and `update_simulation_status('completed')`.
   - `api_gateway/app/services/supabase_service.py`: Layer-2 override — `running` → `completed` when `survival_season_state.status` is completed.
   - `api_gateway/tests/test_survival_status_override.py`: Unit tests for the override.
- [x] **Fix Run B smoke failures: f-string NameError in temp-runner script and Supabase-first resume on missing env file (PL-6)**
   - `api_gateway/app/services/simulation_control.py`: Escaped `{backend_path}` and `{e}` braces in the runner f-string template so they emit into the generated script rather than being evaluated at build time (was causing NameError on every fresh-subprocess API launch).
   - `reverie/backend_server/reverie.py`: Same-sim resume no longer crashes when `environment/{N}.json` is absent — falls back to the last completed step's actual positions from Supabase and materializes the env handshake file from the SOT before the step loop starts.
   - `api_gateway/tests/test_simulation_runner_script.py`: New regression test that compiles the generated runner script to guard against future template NameErrors.

---

## 2026-06-11 — Ivan — branch: ivan/live-chunk-scheduler

### Backend

- [x] **Live-mode chunk scheduler: 60s reveal-gated bundle publishing from gateway**
   - `api_gateway/app/services/live_scheduler.py`: New stateless 60s tick implementing DP7 reveal-edge math, reveal-gated bundle publishing from Supabase step rows, and low-lead/chat-dirty wake decisions.
   - `supabase/migrations/20260611120000_live_mode_chunk_scheduler.sql`: Adds `simulations.live_mode` + `published_step` columns, a gwchat partial index, and 3 service-role RPCs — committed but NOT applied (human applies).
   - `api_gateway/app/services/background_tasks.py`: Wires the periodic scheduler tick, registers a `live_chunk_start` task type, and adds a live_mode guard so scheduler-owned sims never hit the stdin continuation path.
   - `api_gateway/app/services/supabase_service.py`: Adds 3 RPC wrappers for the new scheduler RPCs and widens the owner_timezone fetch to include live fields.
   - `api_gateway/app/api/routes/simulations.py`: Adds the POST `/{sim}/live` enrollment endpoint.
   - `api_gateway/app/api/routes/simulation_control.py`: Surfaces `live_mode`, `published_step`, and `reveal_step` on the `/status/current` response.
   - `api_gateway/app/models/simulation.py`: Extends the simulation model to carry the new live fields.
   - `reverie/backend_server/step_publisher.py`: Self-disables when the sim is in live_mode so the gateway scheduler owns all publishing.
   - `api_gateway/tests/test_live_scheduler.py`: 39 new unit tests covering reveal-edge math, wake decisions, and bundle publish paths.
   - `reverie/backend_server/tests/test_step_publisher.py`: 12 updated tests confirming the publisher no-ops correctly under live_mode.

---

## 2026-06-10 — Ivan — branch: ivan/step-publish-chat-inject

### Backend

- [x] **Step-bundle publisher + chat-to-memory injection for same-day influence**
   - `reverie/backend_server/step_publisher.py`: New fire-and-forget publisher that uploads the per-step movement bundle and updates a live.json manifest in the public `step-bundles` Supabase Storage bucket, gated behind `PUBLISH_STEP_BUNDLES` (default false).
   - `reverie/backend_server/reverie.py`: Guarded import, publisher init in `ReverieServer.__init__`, and publish hook called after the movement JSON backup write each step.
   - `api_gateway/app/services/chat_with_double_service.py`: Each chat exchange is now injected into `dbl_memory` as a chat node (gwchat_ node_id, 768-d embedding) so the next sim run picks it up as a same-day influence slice.
   - `reverie/backend_server/tests/test_step_publisher.py`: Unit tests for the step publisher covering storage upload and manifest update paths.
   - `api_gateway/tests/test_chat_memory_injection.py`: Unit tests for the chat-to-memory injection covering node creation and embedding upsert.

---

## 2026-06-10 — Ivan — branch: ivan/cost-telemetry

### Backend

- [x] **§S.10 Phase 1 cost telemetry: per-sim-day LLM cost rows in Supabase**
   - `reverie/backend_server/persona/prompt_template/cost_telemetry.py`: New thread-safe per-(sim, sim-day) cost accumulator with delta flush and retry-once + merge-back on failure.
   - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: One guarded hook in PerformanceLogger.log_api_call feeds the accumulator, reusing the already-computed cost_usd value.
   - `reverie/backend_server/reverie.py`: Sets telemetry context at sim start and flushes once per step via new upsert_sim_cost_daily RPC (fire-and-forget).
   - `reverie/backend_server/tests/test_cost_telemetry.py`: 15 unit tests covering concurrent writes, failure merge-back, and day rollover.
   - `supabase/migrations/20260610120000_sim_cost_daily.sql`: New double.sim_cost_daily table, upsert RPC, and fleet view — committed but NOT applied (human applies).
   - `api_gateway/app/services/supabase_service.py`: Supabase query support for the new costs read endpoint.
   - `api_gateway/app/api/routes/simulations.py`: New GET /api/simulations/{sim_code}/costs endpoint returning per-day cost rows.

---

## 2026-06-10 — Nicolas — evening — `double-front` + `generative_agents-local`

### Backend (`generative_agents-local/main`, commit `59b92eb8`)

- [x] **DP7 local bootstrap — owner timezone after fork**
   - `reverie/backend_server/owner_timezone_bootstrap.py`: post-fork `set_owner_timezone` (same RPC as onboarding finalize)
   - `reverie/backend_server/reverie.py`: `_try_bootstrap_owner_timezone()` on **new sim only** (`is_new_simulation`), after `_try_supabase_fork()`; never raises
   - `double_memory_client.py`: `get_owner_timezone` / `set_owner_timezone` helpers
   - `tests/test_owner_timezone_bootstrap.py`: 7 unit tests
   - `api_gateway/.../simulation_control.py`: `/status/current` now returns `start_date` (was fetched but omitted; helps FE reveal cap)
   - **Optional env (local operators only, not required):** `DEFAULT_OWNER_TIMEZONE=<IANA>` in `generative_agents-local/.env.local` (alias `OWNER_TIMEZONE`). If unset, behavior unchanged — `owner_timezone` stays null, UTC legacy. Prod path: `onboardingApi.finalizeOnboardingBinding` (`20786b4`) when operator UI calls finalize. Documented in `double-front/docs-local/LEEME_CORRER_SIM_LOCAL_3_TERMINALES.md`.

## 2026-06-10 — Ivan — branch: ivan/dev

### Backend

- [x] **COMPLETED.json mkdir fix — create movement/ dir before writing completion marker when SKIP_MOVEMENT_JSON_WRITE=true**
   - `reverie/backend_server/reverie.py`: Add create_folder_if_not_there before COMPLETED.json write
   - `reverie/backend_server/tests/test_movement_completion_marker.py`: New unit test for completion marker without existing movement dir

- [x] **Parallel sim launch API (§5/§6) — fork, batch-start, health-probe, stale-fork detection, per-sim log capture**
   - `api_gateway/app/api/routes/simulations.py`: New POST /simulations/fork and POST /simulations/batch/start endpoints; /start skips living-area guard for missing sims (PL-1) and treats running+step0+no-process as stale fork (PL-2).
   - `api_gateway/app/main.py`: New GET /api/generation/health endpoint for frontend probe and concurrency snapshot.
   - `api_gateway/app/services/simulation_control.py`: Subprocess stdout/stderr now redirected to per-sim log file under SIM_LOG_DIR; added read_log_tail helper (PL-4).
   - `api_gateway/app/services/background_tasks.py`: Failed start tasks now include error_log_tail in the error payload.
   - `api_gateway/app/models/simulation.py`: Added ForkSimulationRequest and BatchStartRequest Pydantic models.
   - `api_gateway/tests/test_parallel_launch_endpoints.py`: New endpoint tests (4 passing).

---

## 2026-06-10 — Ivan — branch: railway

### Backend

- [x] **VPS dual-repo deploy runbook in docs portal + FE systemd install script**
   - `double-docs/README.md`: top section § Sim VPS — generation deploy (operators)
   - `double-docs/20260608_FE_MVP_hardening.md`: Nicolas VPS deploy section + cross-refs
   - `scripts/deploy/install-double-front-service.sh`: installs `double-front.service` from repo
- [x] **VPS Item 2 queue acceptance soak + sign-off record**
   - `scripts/soak_item2_queue_vps.sh`: VPS Item 2 queue acceptance script (completed sim 4th POST, action:start, meta output)
   - `scripts/signoff/item2-queue-20260610-meta.json`: sign-off record BE 549d2d41 FE 21371fa queued_at_capacity proof

---

## 2026-06-10 — Nicolas — Item 2: sim cap + overflow queue (H5)

**Context:** Ivan asked for deploy + Item 2 same day. BE orchestrator work per `20260608_FE_MVP_hardening.md` § Item 2.

### Implementation (`generative_agents-local`)

- [x] **`api_gateway/app/services/sim_concurrency.py`** — `MAX_CONCURRENT_SIMS` gate; overflow wait queue; psutil reverie count
- [x] **`simulation_control.py`** — acquire before spawn, release on stop/exit
- [x] **`GET /api/simulations/concurrency`** + start response `queued_at_capacity`
- [x] **`headless_visualization.py`** (gateway) — batch cap reads `MAX_CONCURRENT_SIMS`
- [x] **`scripts/deploy_mvp_vps.sh`** — FE+BE rsync, env flags, `systemctl restart api-gateway`
- [x] **Tests** `test_sim_concurrency.py` — 6/6 pass

### Pending

- [x] VPS deploy (`deploy_mvp_vps.sh`) — rsync + `systemctl restart api-gateway` (2026-06-09)
- [x] Push BE `main` — `cd4e3ac8`
- [ ] 4th-sim queue soak on VPS (3 running + 1 queued via API)

---

## 2026-06-10 — Nicolas — Item 1.5: pre-implementation baseline soak

- [x] **`generative_agents-local/scripts/soak_ram_monitor.sh`** — poll reverie + process-tree RSS → CSV
- [x] **`generative_agents-local/scripts/run_pre15_baseline_soak.sh`** — 1 sim × N steps launcher

- [x] **BE** `HEADLESS_TAB_REUSE` (default `false`) — persistent Playwright page per sim; step 2+ skips `goto`
- [x] **Tests** `test_tab_reuse_default_false` in `test_headless_lifecycle.py`

- [x] Deployed `headless_visualization.py` + FE build with `__headlessPrepareNextStep` to VPS
- [x] BE `fc3e28dd` pushed `generative_agents` `main` (Ivan: merge → `railway`)


## 2026-06-09 — Ivan — branch: railway

### Backend

- [x] **VPS generation deploy topology doc + systemd FE unit template**
   - `double-docs/20260609_vps_generation_deploy_topology.md`: records local `:3000` FE requirement (Vercel playback-only), sign-off checklist, FE commit pinning
   - `scripts/deploy/double-front.service`: systemd unit template for headless prod FE on sim VPS

---

## 2026-06-10 — Ivan — branch: ivan/live-mode-be

### Backend

- [x] **Restrict SECURITY DEFINER RPC EXECUTE to service_role only**
  - `supabase/migrations/20260609130000_rpc_execute_service_role_only.sql`: bulk REVOKE from anon/authenticated, GRANT service_role on public+double definer functions
- [x] **Pin search_path on SECURITY DEFINER RPCs for Supabase Security Advisor**
  - `supabase/migrations/20260609120000_function_search_path_hardening.sql`: ALTER FUNCTION SET search_path on fork/metadata/chat/timezone RPCs

---

## 2026-06-09 — Ivan — branch: ivan/live-mode-be

### Backend

- [x] **Tier 1 RLS lockdown — backend-only writes on 5 `double` tables (applied to prod)**
   - `supabase/migrations/20260609140000_rls_tier1_backend_write_lockdown.sql`: drops permissive `USING(true)` write policies and revokes anon/authenticated write grants on `address_translations`, `maze_bounds`, `dbl_memory`, `dbl_retrieval_metrics`, `maze_chunk_overrides` (keeps a SELECT policy on the last for realtime); FE-verified no direct table access, service_role bypasses RLS so backend writes unaffected.
- [x] **Correct RPC execute-permission migration to preserve anon read access**
   - `supabase/migrations/20260609130000_rpc_execute_service_role_only.sql`: re-grants EXECUTE to anon/authenticated on 13 read-only allowlisted RPCs (maze + playback) after the bulk revoke, keeping all mutating/admin RPCs locked to service_role only.
- [x] **Expose generation activity heartbeat on /status/current for live mode**
   - `supabase/migrations/20260609150000_generation_activity_marker.sql`: add is_generating + last_generated_at columns and extend get/update_simulation_metadata and update_simulation_status RPCs
   - `api_gateway/app/services/supabase_service.py`: pass generation fields from metadata into get_simulation_status
   - `api_gateway/app/api/routes/simulation_control.py`: surface is_generating + last_generated_at on /status/current
   - `supabase/db_reference.md`: document new columns and RPC behavior
   - `api_gateway/tests/test_generation_activity_status.py`: test /status/current exposes new fields

---

## 2026-06-08 — Ivan — branch: ivan/live-mode-be

### Backend

- [x] **DP8 Survival grace day: Survival is dormant on sim day 1, first directive fires on day 2**
   - `reverie/backend_server/survival/controller.py`: `on_step` accepts a `day_number` arg and returns `None` on day 1.
   - `reverie/backend_server/reverie.py`: passes 1-indexed `day_number` into `survival_controller.on_step`; also auto-launches `build_highlights` as a detached subprocess at sim-day-close.
   - `tests/test_survival_grace_day.py`: new — covers day-1 dormancy, day-2 first directive, and backward-compat path.

- [x] **BE-4a Highlights auto-build + dedupe: one highlight per step before capping, launched at day-close**
   - `video/build_highlights.py`: `rank_and_cap` collapses duplicates to one highlight per step before applying the cap (fixes partial-day over-emission).
   - `tests/test_build_highlights.py`: new tests asserting per-step deduplication.

- [x] **DP7 Owner-clock foundation: owner timezone stored and re-anchors the sim clock to 06:30 local (migration pending deploy)**
   - `supabase/migrations/20260608120000_owner_timezone_clock_anchor.sql`: new — adds `simulations.owner_timezone` column and `set_owner_timezone` RPC.
   - `api_gateway/app/api/routes/onboarding.py`: `FinalizeRequest` now accepts `owner_timezone` and forwards it to the engine.
   - `scripts/onboarding_host.py`: finalize calls `set_owner_timezone` after a successful binding.
   - `api_gateway/app/services/supabase_service.py`: new `_get_simulation_owner_timezone` helper.
   - `api_gateway/app/api/routes/simulation_control.py`: `/status/current` now returns `owner_timezone` and `sec_per_step`.
   - `supabase/db_reference.md`: documents the new column and RPC.
   - `tests/test_onboarding_finalize.py`: new tests for owner-timezone wiring through the finalize flow.

---

## 2026-06-08 — Ivan — branch: ivan/dev

### Backend

- [x] **Run-readiness gate: refuse to run a sim until every double is fully wired (job + home + spawn tile)**
   - `scripts/onboarding_host.py`: added `check_readiness` engine function + `--op readiness` bridge op reporting any double missing `work_area`/`living_area`/`curr_tile`.
   - `reverie/backend_server/reverie.py`: `start_server` now aborts a *fresh* run (`self.step == 0`) with a clear per-double message if any double isn't wired; resumes are exempt; checks the in-memory persona scratch (no DB call).
   - `api_gateway/app/api/routes/onboarding.py`: added `GET /onboarding/{sim}/readiness`.
   - `api_gateway/app/api/routes/simulations.py`: start endpoint returns `409 sim_not_ready` for an un-wired fresh start (gated by `ENABLE_ONBOARDING_HOST`, continuations exempt); the reverie engine enforces the same unconditionally as the backstop.
   - `tests/test_onboarding_readiness.py`, `api_gateway/tests/test_onboarding_endpoint.py`: gate-logic + readiness-endpoint passthrough tests.

- [x] **Wired the soul15 baseline so every double has a personality-matched job (homes preserved)**
   - `soul15_seed_20260224` (Supabase, via the onboarding engine): the 15 doubles had homes but **no jobs**; assigned a unique personality-matched job + role to each while keeping their existing homes/spawn tiles, so the baseline (and any fork off it) is fully wired and runnable.

- [x] **Made the map's home/building names generic so the same home is reusable across sims**
   - `maze_address_cache` (Supabase, rebuilt via existing `scripts/migrate_maze_to_supabase.py`): the only stale layer — rebuilt the_ville's address cache from the already-generic layout CSVs; 304 addresses, coordinates identical, 0 character names (grid tiles, asset catalog, and all persona living_area/work_area were already generic).
   - `reverie/backend_server/persona/prompt_template/v2/movement_mode_v1.txt`: replaced the one hardcoded character-named example (`Klaus Mueller's room`) with a generic one (`Dorm Room 1`).

- [x] **Onboarding v2: per-double guided picker (3 ranked options each, unique job + home per sim)**
   - `scripts/assign_soul15_careers.py`: added `rank_career_shortlists` returning per-persona ranked careers (deduped by title, deterministic fill).
   - `scripts/onboarding_home_matcher.py`: added `rank_home_shortlists` returning per-persona ranked homes (depth `N+top_n-1` so late doubles keep ≥3 fresh options after uniqueness removals).
   - `scripts/onboarding_host.py`: `build_board` now emits a `doubles[]` shortlist board with job/home sufficiency gates; rewrote the CLI as a sequential per-double picker (`_fresh_options`/`_undo`/`_assemble_board`) that enforces uniqueness and feeds the unchanged `finalize_binding`; selection accepts a bare `0 1` (job# home#) with a clearer prompt.
   - `api_gateway/app/api/routes/onboarding.py`: typed the finalize request (`AssignmentIn`/`FinalizeBoard`) and made `employment_relevant_spaces` required so the feasibility gate can't be bypassed.
   - `tests/test_career_shortlists.py`, `tests/test_home_shortlists.py`, `tests/test_onboarding_picker.py`: new unit tests for ranking, the uniqueness filter, and the block branches.
   - `api_gateway/tests/test_onboarding_endpoint.py`: updated for the shortlist board shape and finalize validation.

- [x] **First implementation of the onboarding host (sim-binding flow, sot_lifecycle.md §6.5)**
   - `scripts/onboarding_home_matcher.py`: personality-fit ranking of home candidates with uniqueness and private-room preference guardrails, mirroring the career matcher pattern.
   - `scripts/onboarding_host.py`: engine (check_prerequisites, build_board, finalize_binding) plus interactive CLI and a `--op` JSON subprocess bridge; closes write gaps by persisting work_area, living_area, and curr_tile.
   - `api_gateway/app/services/onboarding_service.py`: subprocess bridge from the gateway to the engine, following the same pattern as simulation_control.
   - `api_gateway/app/api/routes/onboarding.py`: REST endpoints (prerequisites / board / regenerate / finalize) gated off by default via ENABLE_ONBOARDING_HOST flag.
   - `api_gateway/app/main.py`: registered the onboarding router with a single include_router call.
   - `tests/test_onboarding_home_matcher.py`, `tests/test_onboarding_prerequisites.py`, `tests/test_onboarding_finalize.py`: engine unit tests with mocked LLM and fake Supabase client.
   - `api_gateway/tests/test_onboarding_endpoint.py`: gateway endpoint tests with mocked subprocess bridge.

- [x] **Bumped FastAPI to unblock all gateway tests (starlette/httpx incompatibility)**
   - `requirements.txt`: upgraded `fastapi` from 0.104.1 to 0.115.14 (pulls starlette 0.46.2), resolving the starlette-0.27/httpx-0.28 `TestClient` breakage.
   - `api_gateway/tests/test_websocket_validation.py`: modernized 4 WebSocket-rejection tests to new starlette `WebSocketDisconnect` semantics (`pytest.raises(WebSocketDisconnect)` + `.code == 1008`); product behavior unchanged.

---

## 2026-06-05 — Nicolas — branch: `main` (`double-front` + `generative_agents-local`)

**Context:** Ivan P0 MVP hardening request — Item 1 (H0): stop headless sim steps from hitting `next dev` + Playwright cache-bust (root cause of compile contention at 3 concurrent sims). Request doc: `20260608_FE_MVP_hardening.md` · analysis SOT: `TODO_production_hardening.md` §4 H0 / §7 Q3.

**Repos:** `double-front` `main` · `544f288` (pushed) · `generative_agents-local` `main` (BE paired changes **local only**, not pushed)

#### `generative_agents-local` — paired BE (local, deploy with FE on VPS)

- [x] **`reverie/backend_server/headless_visualization.py`** — `HEADLESS_PLAYWRIGHT_CACHE_BUST=false` default (opt-in `true` for `next dev` iteration); `HEADLESS_FRONTEND_PORT_ROAM=true` default locally, `false` recommended on VPS; conditional cache-bust headers + Chromium launch args; per-step log of `window.__headlessMetrics`
- [x] **`scripts/test_headless_h0_smoke.py`** — E2E smoke: prod `next start` + local gateway + one headless step
- [x] **`reverie/backend_server/tests/test_headless_lifecycle.py`** — `TestHeadlessH0EnvDefaults` (env default coverage)

### Local verification

Command: `python scripts/test_headless_h0_smoke.py` (`generative_agents-local`)

Setup: prod FE `:3000`, gateway `:8001`, sim `20260407-30-15` step 1, Supabase `sim_id` via collision override, cache-bust off.

| Metric | Value |
|--------|------:|
| `boot_ms` | 465 |
| `preload_ms` | 392 |
| `animation_ms` | 618 |
| **`total_ms`** | **1,114** |
| Status | `pass` · 15/15 movement reports · 4 observations |

Unit tests: `test_headless_lifecycle.py` — **17 / 17 passed**.

**Interpretation:** step time dominated by boot + chunk preload + animation, not dev recompile (~10–30 s baseline with `next dev` + cache-bust). VPS 3-sim soak completed **2026-06-09** — see entry above.

- [ ] Push paired BE changes (`generative_agents-local`) — optional; Ivan `railway` BE sufficient for soak

---

---

## 2026-06-04 — Ivan — branch: `ivan/dev`

### Backend

- [x] **Waitlist via API gateway: optional message, upsert, landing proxy path**
  - `generative_agents/supabase/migrations/20260604120000_waitlist_message.sql`: Add `message` column and anon update policy for email upsert.
  - `generative_agents/api_gateway/app/api/routes/waitlist.py`: Optional `message`, service-role upsert on `email`, IP rate limit unchanged.
  - `generative_agents/api_gateway/tests/test_waitlist_endpoint.py`: Message, truncation, upsert failure coverage.
  - `generative_agents/api_gateway/app/core/config.py`: CORS for `doubland.ai`, `www.doubland.ai`, `localhost:3001`.
  - `generative_agents/supabase/db_reference.md`: `message` column and migration ledger.
  - `double-landing-page/app/api/waitlist/route.ts`: Proxy to `API_GATEWAY_URL` (no Supabase on Vercel).
  - `double-docs/landing/20260529_landing-page_TODO-BE.md`, `20260603_landing-page_v8.md`: Vercel → gateway → Supabase architecture.

- [x] **Sim footprint sampler for parallel-sim sizing**
   - `tests/measure_sim_footprint.py`: new psutil-based tool that samples a running stack and reports per-sim (reverie + headless Chromium) vs shared (frontend + gateway) RAM, system memory, and an N-sim projection (USS floor / RSS ceiling).

---

## 2026-06-03 — Ivan — branch: ivan/dev

### Backend

- [x] **v2.4 "Anya cut" opener narration — Step 2: concept-script structure (narration layer only; compose re-timing is Step 3)**
   - `video/showrunner.py`: replaced the four retired generators (`cold_open`, `social_hook`, `pressure_event`, `vote_dread`) and their system prompts with the v2.4 two-fixed-block structure — `OPENER_HOOK_LINE` + `OPENER_CONCEPT_LINE` (Block 1) and `OPENER_CLOSING_BLOCK` (Block 3) are cohort-agnostic verbatim literals; a new `_generate_season_framing` + `OPENER_SEASON_FRAMING_SYSTEM` (Tier B, cached) writes the cohort introduction; per-persona narration is now a single snappy 4-9-word trait line (`OPENER_PERSONA_NARRATION_SYSTEM` rewritten); cast cards shrunk to ~3s (`OPENER_PER_CAST_INTRO_SEC=3`); total bounds tightened to 45-110s; `season_title` retired; `social_hook` field dropped from cast scenes; `narrator_script` assembler rewritten to the new block order with baked-in pause markers.
   - `video/tts.py`: changed the "Doubland" pronunciation override from "Dubbleland" to "Dub-land" for cleaner TTS rendering.

- [x] **v2.4 "Anya cut" opener visuals — Step 3: compose re-timing + simplified cast cards (validation render Step 4 pending)**
   - `video/compose_trailer.py`: rewired `compose_opener_trailer` timing anchors to season-framing line (C) + closing line (D), removed the cold-open stage and front-matter wordmark gap, moved DOUBLAND wordmark motion to just before the end card, updated stage concat order (intro hook → season bridge → cast → stakes → wordmark → end card); simplified `_compose_persona_card_clip` to a single snappy clip (walkout-or-sketch + name + one spoken trait line) by removing the portrait/walkout A/B split and bio + social-hook overlays.
   - `video/validate_trailer.py`: lowered opener duration bounds from 95-220s to 45-110s for the ~60-70s v2.4 concept cut.
   - `video/generate_trailer.py`: made `--season-title` optional for opener mode (retired; accepted but unused, validation no longer requires it).

---

## 2026-06-02 → 2026-06-05 — Nicolas — branch: `landing-hero-img` (`double-landing-page`)

- [x] **v1 imagery** — `landing-v1-assets.ts`, world gallery tile mapping from generative_agents video assets; v1/v2 navbar brand split (`963d5df2`).

## 2026-06-01 — Ivan — branch: ivan/dev

### Backend

- [x] **9:16 mobile-first opener — native vertical render (keeps 16:9)**
   - `video/compose_trailer.py`: threaded `width`/`height` through `compose_opener_trailer` and every stage (brand-open pads the wordmark into frame; montages + cold-open gained a `fill` crop-to-frame mode; persona-card sketch scales with width); dropped the opener center-crop path; flipped `VERTICAL_9X16_ENABLED=True`.
   - `video/generate_trailer.py`: opener now renders both `trailer_9x16.mp4` (1080×1920, mobile-first primary) and `trailer_16x9.mp4` (1280×720).
   - `video/validate_trailer.py`: validator now checks the 9:16 output (1080×1920); refreshed the stale comment.

- [x] **v2.3.1 opener trailer — script corrections + dynamic opening**
   - `video/showrunner.py`: spaced the three "what if" hook questions with 0.5s beats, changed the cold-open form to "{N} Doubles play the game. One survives.", rewrote the access-reveal line, moved the main-character turn (D) to the closing slot, and dropped the "The game is on." sign-off.
   - `video/compose_trailer.py`: rebuilt the intro-hook as a ken-burns montage of six real cinematic flyovers (the old single-clip path pointed at a missing file and fell back to a static phaser still), and repointed the closing timing anchor from the removed habit-hook to the main-character line.

- [x] **v2.3 opener trailer — concept-frame wrap (four new spoken beats)**
   - `video/showrunner.py`: replaced `concept_seed` / `participation_bridge` locked lines with four new beats (A: `OPENER_HOOK_LINE`, B: `OPENER_CONCEPT_INTRO_LINE`, C: `_opener_season_bridge()` templated on cohort name, D: `OPENER_MAIN_CHARACTER_LINE`) and rewrote `_opener_assemble_narrator_script` to the new A→B→[6s gap]→C→cold-open order.
   - `video/compose_trailer.py`: relocated the DOUBLAND wordmark from Stage 0 into the post-concept gap (Stage 0b), added intro-hook (0a) and season-bridge (0c) stages anchored to the narration timing map, and switched the final concat to `_concat_hardcut` (dropped brand-open prepad and sting time-shift).
   - `video/validate_trailer.py`: refreshed opener duration-bounds and end-card-overlap comments for the no-prepad v2.3 structure; bounds and logic unchanged (95–220s).
   - `video/generate_description.py`: changed the concept-intro field read from `concept_seed` to the renamed `concept_intro` key.

---

## 2026-05-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Fixed Windows rerun collision in trailer scene recording outputs**
 - `generative_agents/video/record_scenes.py`: Replaced `os.rename` with overwrite-safe file replacement so reruns can reuse existing output folders without WinError 183 when `_raw.webm` files already exist.
 - `generative_agents/tests/test_record_scenes_file_replace.py`: Added regression tests proving overwrite behavior and same-path no-op behavior for the recorder file move helper.

### Video — Day-overview trailer v3 (clean opener, AI captions, establishing layer, no truncation)

- [x] **v3 redesign addressing the four `&006` Day-1 render findings** (opening-card clutter, production-artefact scene titles, missing establishing layer/realistic visuals, narration cut off):
   - `video/compose_trailer.py`: brand open uses the clean `opening_wordmark-no-h2.png` still (season + episode in the empty band under DOUBLAND, no mask box; opener motion path untouched); `_compose_day_overview_card_clip` rewritten to drop the "LABEL / Name" overlay and instead show the AI `card_caption` lower-centre + the Double's portrait in an alternating top corner with a name tag; new `_compose_establishing_clip` builds Day-1 concept-reset + cast-intro cards over the realistic `cohort/hero` images; day-overview assembly now dispatches by scene type (composed / bridge / arc, arc clips matched by scene_id) instead of positional clip order; added a tail guard that stretches the end card so the full narration never truncates; fixed a pre-existing `NameError` (orphaned `tinted_paths` in cleanup).
   - `video/showrunner.py`: Narration Writer emits a `card_caption` per beat (schema + advisory check + carried onto each scene); `_stitch_overview_script` prepends the Day-1 establishing layer (locked concept-reset line + one cast intro per Double, intro text derived from the producer's status-delta) on one continuous renumbered timeline and drops the unbudgeted micro-reset; added `_resolve_hero_path`; bumped narration cache key to `_v3`; widened runtime/narration bounds for the longer Day-1 trailer.
   - `video/extract_day_log.py`: `extract_day_overview` now resolves each protagonist's `agent_id` + `sketch_path` (same name→id→file lookup the opener uses) so the composer can draw portraits.
   - `video/record_scenes.py`: `record_all_scenes` skips `composed` scenes (establishing cards have no Phaser footage).
   - `video/generate_trailer.py`: `_expected_clip_names` now excludes `composed` scenes — the orchestrator's recording-skip check + pre-compose guard were waiting for establishing clips that are never recorded, which aborted compose ("Skipping compose — 4 clip(s) still missing").
   - `video/validate_trailer.py`: day-overview duration band → (100,180)s, scene-count ceiling → 12; narration bound auto-syncs from showrunner.
   - `video/showrunner.py`: narration word ceiling 250 → 280 — the writer is budgeted for the arc but the final narrator_script also carries the Day-1 establishing lines, so a legitimate Day-1 total (~230-270) was tripping the gate.
   - Verified by a full live render of `20260528-1` day 1: trailer_16x9.mp4 (140.7s) produced, **all five validator checks PASS** (incl. narration_fits_video — no truncation). Visual QA confirms clean wordmark opener → concept reset over a realistic hero image → cast intros (hero + name + intro line) → arc scenes (Phaser + alternating-corner sketch portrait + AI caption).

---

## 2026-05-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Fixed trailer step-fetch API crash on Windows during recording**
 - `generative_agents/api_gateway/app/services/resilient_service.py`: Replaced emoji-prefixed diagnostic logs in step retrieval with ASCII-safe text so Windows console encoding does not throw and abort step fetches.
 - `generative_agents/api_gateway/app/services/supabase_service.py`: Replaced emoji-prefixed Supabase RPC diagnostic prints/logs in `get_step_positions_from_supabase` with ASCII-safe text to prevent `charmap` encode failures.
 - `generative_agents/api_gateway/app/api/routes/simulations.py`: Removed emoji from step-conversion info log in the `/api/simulations/{sim_code}/step/{step}` response path to keep endpoint logging encoding-safe.

## 2026-05-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Completed Supabase rollout checks for waitlist onboarding and fixed anon insert path under RLS**
 - `generative_agents/api_gateway/app/api/routes/waitlist.py`: Switched write path to insert-with-`returning='minimal'` and kept duplicate email idempotency so anon inserts pass without requiring anon read policy.
 - `generative_agents/api_gateway/tests/test_waitlist_endpoint.py`: Updated waitlist tests for insert behavior and duplicate-signup success handling.
 - `generative_agents/.env.local`: Aligned runtime Supabase URL/anon key to the active `double` project for API gateway waitlist writes.

## 2026-05-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Tightened day-overview trailer narration clarity and end-card timing behavior**
 - `generative_agents/video/showrunner.py`: Enforced first-name-only spoken narration guidance and added advisory feedback when full names appear in voiceover lines.
 - `generative_agents/video/compose_trailer.py`: Removed boxed/gray text highlighting from day-overview overlays and delayed end-card handoff so narration overlap stays under two seconds.
 - `generative_agents/video/validate_trailer.py`: Added a non-blocking day-overview overlap metric check to report how long narration continues after end-card start.
 - `generative_agents/tests/test_day_overview_naming_rule.py`: Added regression tests proving full-name voiceover lines are flagged while first-name lines pass.

## 2026-05-29 — Ivan — branch: ivan/dev

### Backend

- [x] **Implemented waitlist onboarding endpoint in API gateway with migration-backed storage and abuse guardrail**
 - `generative_agents/api_gateway/app/api/routes/waitlist.py`: Added `POST /api/waitlist` with email validation, anon-key Supabase upsert into `double.waitlist`, and per-IP 10-minute rate limiting.
 - `generative_agents/api_gateway/app/main.py`: Registered the new waitlist router under `/api` so FE can call a stable backend endpoint.
 - `generative_agents/supabase/migrations/20260529203000_waitlist_onboarding.sql`: Added formal schema migration for `double.waitlist` plus anon insert-only RLS policy.
 - `generative_agents/api_gateway/tests/test_waitlist_endpoint.py`: Added endpoint tests for success, validation failure, rate limiting, and missing Supabase client paths.
 - `generative_agents/supabase/db_reference.md`: Updated DB reference index and migration ledger for the new waitlist table.

## 2026-05-28 — Ivan — branch: ivan/dev

### Backend / Ops

- [x] **Production API gateway: systemd service + certbot deploy hook**
  - `scripts/deploy/api-gateway.service`: uvicorn on :8001 with Let's Encrypt TLS, restart on failure.
  - `scripts/deploy/certbot-reload-api-gateway.sh`: restarts gateway after `api.ondouble.com` cert renewal.
  - `scripts/deploy/install-api-gateway-service.sh`: one-shot VPS installer (systemd enable, hook, stop manual nohup process).

## 2026-05-27 — Ivan — branch: ivan/dev

### Backend

- [x] **Add baseline scratch sync script (local scratch.json → persona_scratch)**
   - `scripts/sync_baseline_scratch.py`: load/patch/save via RPC with step-0 runtime reset; dry-run previews field diffs before write.

### Backend

- [x] **Day-overview Bucket-1 prompt-edit pass: brand discipline, Day-1 micro-reset line, stitch injection, narration-bound lift**
   - `video/showrunner.py`: added trailer-only carve-out in `DAY_OVERVIEW_BRAND_DISCIPLINE` for "AI Doubles / AI versions of real people" and preposition rule ("in Doubland"); locked new constant `DAY_OVERVIEW_DAY1_MICRO_RESET_LINE`; `_stitch_overview_script` injects the locked line + `[PAUSE 1s]` after beat-1 narrator lines on Day 1 only; `DAY_OVERVIEW_NARRATION_BOUNDS` ceiling raised from 110 to 120 words.

- [x] **BE-5: flow `curr_time`, `day_number`, and `action_family` end-to-end from engine to FE**
   - `reverie/backend_server/reverie.py`: writes `curr_time`, `day_number` (1-indexed from sim start date), and `action_family` (from `persona.scratch.current_action_contract`) into both the step `meta` block and each per-persona Supabase write dict.
   - `api_gateway/app/services/supabase_service.py`: both RPC readers surface the three new fields from the `movement` jsonb, falling back to the synthetic `_compute_step_time` only for legacy pre-BE-5 rows.
   - `api_gateway/app/api/routes/simulations.py`: `/step/{n}` logs a warning instead of silently substituting the integer step when `meta.curr_time`/`day_number` are absent; proximity entries use real `curr_time` instead of the integer-step fallback.
   - `api_gateway/app/services/websocket_manager.py`: dev WS `movement_update` envelope lifts `curr_time` and `day_number` from `data.meta` onto the outer message (dev-only; prod uses Supabase Realtime directly).
   - `api_gateway/app/api/routes/simulation_control.py`: `/status/current` adds `current_day_number` derived from sim start date + `curr_time` and surfaces `curr_time` at the top level.
   - `supabase/db_reference.md`: documents the new BE-5 fields inside the `movement` jsonb for `get_step_positions` / `get_all_step_positions`.

- [x] **Day-overview validator: import narration bounds from showrunner instead of hardcoding**
   - `video/validate_trailer.py`: replaces the hardcoded `(80, 110)` day-overview narration bound (and its 7-line comment block) with an import of `DAY_OVERVIEW_NARRATION_BOUNDS` from `showrunner.py`, mirroring the existing opener pattern so the two files share a single source of truth.

- [x] **Day-overview writer: hard guardrail against surfacing raw step numbers in voiceover**
   - `video/showrunner.py`: adds an explicit rule to `DAY_OVERVIEW_NARRATION_WRITER_SYSTEM` forbidding step numbers, scene IDs, and `focal_step` values in voiceover; writer must use time of day, location, or relative ordering instead. Bumps the prompt hash so the next render regenerates and drops the step-number leak.

- [x] **Centralize tier→model resolution in video pipeline; switch day-overview to Tier B**
   - `video/showrunner.py`: imports `MODEL_CONFIG` from `model_router.py` (dual try/except fallback) and derives module-level `TIER_A/B/C_MODEL` constants; removes the local `_tier_b_model()` / `_tier_c_model()` helpers (one had a stale `"gpt-4o"` fallback polluting `llm_model` cache rows); replaces all seven call sites with `TIER_B_MODEL`; promotes day-overview producer + writer from Tier C → Tier B so intent matches runtime (router was already silently demoting because `TIER_C_ENABLED=false`); `_call_llm_direct` no-routing fallback also switches off the stale literal. Side effect: day-overview cache rows MISS on next render and regen with the correct model string.

- [x] **Day-overview Phase A quick wins: vote-outcome clarity + pronoun ambiguity fix + branded cohort/episode label on opener clip**
   - `video/showrunner.py`: adds VOTE OUTCOME RULE to `DAY_OVERVIEW_NARRATION_WRITER_SYSTEM` forcing a single "X is eliminated by N votes" sentence at the end of `vote_reveal`/`pressure_peak` beats; adds PERSONA NAMING RULE forbidding pronoun-first beat openings — first reference per beat must be a full first name. Writer cache row goes STALE (prompt hash changed); producer cache unaffected.
   - `video/compose_trailer.py`: extends `compose_brand_open()` with optional `cohort_label` and `episode_label` kwargs that overlay drawtext via filter_complex on the existing `brand_opener_motion.mp4` clip (lower-third, DOUBLAND wordmark untouched); day-overview compose path parses cohort from `script.end_card.cohort_label` and day number from `script.end_card.text` (regex on "DAY N ENDS") and passes both to the brand-open stage; opener path unchanged; adds `import re`.

- [x] **Day-overview trailer Phase A.5: audio length fix + "What if?" mask + red-tint removal + grey-box cleanup (&005 review)**
   - `video/showrunner.py`: bumps `DAY_OVERVIEW_TARGET_RUNTIME` 53 → 100 s, `DAY_OVERVIEW_RUNTIME_BOUNDS` (46, 61) → (90, 120), and `DAY_OVERVIEW_NARRATION_BOUNDS` (80, 145) → (140, 200) so the writer's full beat plan fits acoustically; updates comment to reflect 200 words ≈ ~105 s at 1.9 w/s.
   - `video/compose_trailer.py`: (a) `compose_brand_open` prepends a drawbox mask over the baked-in "What if?" tagline and repositions cohort/episode drawtexts to fill that slot — `box=1` removed from both; (b) council-grade tint block removed from `_compose_day_overview` (function stays defined, uncalled); (c) `_compose_day_overview_card_clip` drops `box=1` from protagonist-name and label drawtexts; (d) `generate_opener_end_card` drops `box=1` from all five drawtext stanzas, preserving the two gold-underline drawbox accents.
   - `video/validate_trailer.py`: `DURATION_BOUNDS_SEC["day_overview"]` (58.0, 76.0) → (100.0, 140.0) to match the new 90–120 s scene body + ~14 s brand/end-card envelope; comment updated for Phase A.5.

---

### Video — Opening trailer v2.2 virality layer

- [x] **Opener v2.2: concept seed + access reveal + participation bridge + per-persona social hook + locked "The game is on." closing VO**
   - `video/showrunner.py`: 7-beat narration rewrite — new locked-line constants, social_hook prompt + helper (persona-cached), cold_open prompt restyled, format_lock dropped, habit_hook locked, brand-discipline carve-out for "AI Doubles of real people" + "in Doubland".
   - `video/compose_trailer.py`: cast-card half-B reads `social_hook` (trait_moment fallback); visual-stage anchor swapped `format_lock` → `concept_seed`; end-card cadence default "Episode 1 tomorrow · 18:30".
   - `video/validate_trailer.py`: opener runtime upper bound 180s → 220s to absorb the three new locked beats.
   - `video/generate_description.py`: YouTube description now opens with the brand-locked `concept_seed` line, groups cast scenes under a "Doubles:" header, and prefixes each key-moment line with the persona's first name; key-moment label itself prefers the v2.2 `social_hook` over the truncated narration line. Back-compat fallback preserves the old layout for non-opener modes.

## 2026-05-27 — Nicolas — branch: main

- [x] **Replay smoke on `20260526-3` (completed, 3810 steps) against prod — PASS**
   - **Blocker resolved first:** prod gateway `api.ondouble.com:8001` was unreachable — Let's Encrypt cert expired 2026-05-27 14:35 GMT (auto-renew had failed). Diagnosed from CLI (`curl` → `SSL certificate problem: certificate has expired`; gateway healthy behind it via `curl -k`). Ivan renewed + set auto-update; verified new cert valid through 2026-08-26, TLS handshake clean, `/health` 200.
   - **Validated (manual, browser, prod gateway):** BE-5 `curr_time` flowing end-to-end (REST batches + seek; pill shows real sim time, no `2023-02-13` fabrication) — confirms FE-LIVE-3; paths healthy post-revert; maze chunks + sprites load; scrub forward/back lands on correct step + timestamp. The RPC→REST `curr_time` overlay (FE-LIVE-3) is confirmed working indirectly: pill advanced correctly under `USE_SUPABASE_PLAYBACK=true`, which only happens if the overlay fired.
   - **Still pending for full LIVE sign-off** (need a *running* sim, not completed): Paths A (mount no `?t=`), B (`?t=` → JUMP TO LIVE), C (replay catches up to cushion → auto-LIVE) — watch `realtime:row` / `realtime:stepReady` / `liveLoop:consume`. Plus re-validate FE-LIVE-2 warm-cache on prod (same code as dev). Paths A/B/C were already observed working during yesterday's live generation of `20260526-3`.
   - **Minor polish (post-MVP, not blocking):** cold-start on `/simulations/...` shows a brief sprite "settle" — `usePlaybackBuffering` clears the overlay on `frame_ready` rather than waiting for batch prefetch; the `/sim/.../play` route already gates this via `isPlayModeReady`.
   - **BE follow-up (non-blocking):** project `curr_time` in RPC `get_all_step_positions` so the FE can drop the REST overlay in `usePlayback`.

---


## 2026-05-26 — Ivan — branch: main / vercel

- [x] **BE-5 Path A approved; Path B (Realtime→WS bridge) rejected**
   - Verified against FE code: production has **no** gateway movement WS broadcaster; prod LIVE uses Supabase Realtime on `double.personas_coords` (`useSupabaseCoords.ts`). Dev-only WS envelope contract from 2026-05-23 clarification **superseded** for prod — fields must live in `movement` jsonb (or row columns) and RPC projections.
   - Documented full FE↔BE field contract in `20260519_LIVE_mode.md` §8 ("BE-5 — FE sign-off & implementation contract"): `curr_time` (human-readable OK), `day_number` (1-indexed), `action_family` (`""` when unknown); `/status/current` day_number wanted not blocking.
   - **BE cleared to proceed:** engine Supabase write, RPC migration, REST `/step/{n}` normalization — no FE gate.


## 2026-05-25 — Ivan — branch: ivan/challenge-arrival-buffer

### Backend

- [x] **Add travel-buffer framing to survival challenge prompts to fix Day-1/Day-3 attendance dip**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Reworded fixed-calendar-event injection so challenge and vote times are presented as deadlines ("be at X by HH:MM — arrive 10–15 minutes earlier") rather than activity start times.
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: Replaced the blanket "travel is a separate 60-min hourly activity" rule with a folded-walk rule (5–15 min walk merged into the destination activity) to prevent over-allocation of travel slots.

- [x] **Option-A follow-up: inject typed deadline block into hourly-schedule prompt (first attempt above landed 25%, worse than baseline 50% — root cause: deadlines only in daily_req text, never seen by hourly LLM)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Added `_build_survival_hourly_calendar_block` helper and wired it as a new `prompt_input` entry inside the existing `if survival_mode:` guard in `run_gpt_prompt_generate_hourly_schedule`.
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: Added `!<INPUT 8>!` slot between the survival overlay block and ACTIVITY RULES to receive the typed deadline block; non-survival template is untouched.
   - `tests/test_hourly_schedule_calendar.py`: 10 structural tests covering helper output across deadline combinations, runtime wiring assertion, and non-survival template isolation.

- [x] **Fix cross-sim planning-cache contamination (stale daily plans from shared cache were blocking Option-A verification)**
   - `reverie/backend_server/persona/cognitive_modules/planning_cache.py`: Added `set_cache_dir(new_dir)` that retargets the module-level singleton's cache directory at runtime and flushes the in-memory wake-up cache and counters so a new sim starts cold.
   - `reverie/backend_server/reverie.py`: In `ReverieServer.__init__`, after `self.sim_folder` is established, sets `PLANNING_CACHE_DIR` env var and calls `planning_cache.set_cache_dir` before any planning can fire; also wipes any `planning_cache/` folder carried over by local baseline copy in the new-simulation branch.
   - `reverie/backend_server/replay_origin.py`: Neutralized `_capture_planning_cache_snapshot` to a no-op (returns correct manifest shape with `planning_cache_files_copied: 0`); cross-sim cache-copy logic deleted.
   - `tests/test_planning_cache_per_sim.py`: 9 new cases covering retarget mutation, in-memory flush, per-sim read/write isolation, back-to-back retarget with no leak, and source-grep wiring assertions for reverie.py and replay_origin.py.

- [x] **Option-A rule wording fix: eliminate slot-boundary ambiguity that caused 20260525-4 personas to put arrival activities in the challenge hour instead of the pre-deadline hour**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `_build_survival_hourly_calendar_block` now computes the pre-event hour as `_fmt_clock(h-1)` and emits rules naming an explicit time range (e.g. "10:00 am – 11:00 am") per event, replacing the ambiguous "hour slot ENDING at HH:MM" phrasing.
   - `tests/test_hourly_schedule_calendar.py`: Updated inline helper to match new wording; added `test_explicit_time_range_for_challenge` and `test_explicit_time_range_for_vote` asserting the explicit range strings appear in the rendered block (all 12 tests pass).

---

## 2026-05-24 — Ivan — branch: ivan/rca-class-a-plus-dedup

### Backend

- [x] **Wire Class A resolver guards into sub-action resolution path; add orphan-closet helper**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: New `_redirect_orphan_closet_anchor` helper mirroring orphan-bed; wired all four guards into the sub-action `if resolved_address:` block in `_contextual_rows_to_contract_pairs`, and the new closet helper into both `planner_contract_v1` paths (main + LocationResolutionError fallback).
   - `tests/test_orphan_closet_redirect.py`: 9 unit tests for the new closet redirect helper, mirroring `test_orphan_bed_redirect.py` shape.
   - `tests/test_class_a_subaction_redirects.py`: 5 source-grep wiring assertions verifying all four guards are called inside the sub-action contract-build entry, plus the planner_contract_v1 closet-redirect wiring.

- [x] **Skip durable-broadcast events in pre-compaction flush (fix `dup_factor=2.00` for survival memory)**
   - `reverie/backend_server/persona/cognitive_modules/reflect.py`: New `DEDUP_KEY_PREFIXES` constant and `_has_dedup_key_keyword` helper; `_flush_candidates` now skips nodes carrying `elim_*` / `vote_tally_*` / `challenge_outcome_*` dedup-key keywords (already durable via `add_event_durable` in `broadcast_event_to_personas`).
   - `tests/test_reflect_flush_dedup_skip.py`: 13 unit tests for the new helper (case-insensitive prefix detection) and the flush-skip behaviour, with regression guard verifying non-durable survival nodes (`challenge_participated`, `vote_received`, `vote_cast`) are still flushed.

---

## 2026-05-23 — Ivan — branch: ivan/dev

### Backend

- [x] **Recalibrate Survival Mode daily planning to prevent rest-all-day collapse without restoring directive commands**
   - `reverie/backend_server/survival/controller.py`: Surfaces `vote_deadline_hour` on the survival scratch overlay alongside `challenge_deadline_hour`, and rewords the "whole person" grounding line to cite ordinary activities (eat, move, see people) instead of implying rest.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Builds a "fixed calendar events" block from the deadline hours and gathering location in `scratch.survival`, injects it as INPUT 8 into the daily-plan prompt, and adds a `_fmt_clock` hour-formatting helper.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: Adds an INPUT 8 slot for the fixed-events block and strengthens the output rule so the numbered plan must include a separate item for the challenge and the vote at their stated times.

- [x] **Fix daily-plan cleanup parser crashing on gpt-5-mini responses and dropping items numbered 10+**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Rewrote `__func_clean_up` inside `run_gpt_prompt_daily_plan` to strip all trailing digits (not just one) and guard against empty chunks so responses starting with "2)" no longer raise IndexError.
   - `tests/test_daily_plan_cleanup.py`: New regression test feeding a representative gpt-5-mini response (2)-prefixed, items 10–15) and asserting the cleanup produces the correct items without IndexError.
   - `reverie/backend_server/planning_cache/*.json`: Deleted 166 corrupted plan-cache files written while the fail-safe plan was silently active.

- [x] **Guard insight, keyword, and decomp-schedule cleanup parsers against truncated LLM responses**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` (insight cleanup): Skip lines missing the "(because of ...)" evidence marker so a truncated final line no longer raises IndexError and silently exhausts all retries.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` (keyword cleanup): Guard the `[1]` split on "Emotive keywords:" so collapsed responses don't raise IndexError; removed 3 stray debug `print` statements.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` (decomp-schedule cleanup): Skip per-line on missing " -- " / " ~ " separators or unparseable times instead of aborting the whole parse via tuple-unpacking error.
   - `tests/test_daily_plan_cleanup.py`: Added 4 regression tests covering each sibling parser bug, including the real truncated response from logs/llm/1748.json.

---

## 2026-05-22 — Ivan — branch: ivan/dev

### Backend

- [x] **Add periodic self-check so a persona's mood feeds their daily arc (Step 2 of conversation-quality cognitive fix)**
   - `reverie/backend_server/persona/memory_structures/scratch.py`: Added `self_state` and `last_self_check_step` transient fields to the constructor and Supabase load path.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added `SELF_CHECK_ENABLED` / `SELF_CHECK_INTERVAL_STEPS` flags, new `_maybe_run_self_check` (flag-gated, throttled, sleep-skipping) called at the top of `_determine_action`, and `self_state` injected into the task-decomposition context pack.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Added `run_gpt_prompt_self_check`, a Tier-A introspection call returning the persona's first-person stock-take of their day; new `v2/self_check_v1.txt` prompt template paired with it.
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt` and `survival_task_decomp_contextual_v1.txt`: Instructed the model to let `self_state` genuinely shape sub-activities (survival variant defers to anchor rules during challenge/vote windows).
   - `tests/test_self_check.py`: New test covering the self-check gate, throttle, sleep-skip, and fail-soft paths (7 cases).

- [x] **Give each conversation persona access to their own recent conversation + reflection memory (Step 3 of conversation-quality cognitive fix)**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: Added `_recent_conversations_block`, `_recent_reflections_block`, `_relative_when`, and `_chat_other_party` helpers; `start_conversation` now injects each persona's last ~5 conversations (plus a guaranteed last ~2 with the specific partner) and recent reflections; `ConversationContext.serialize_for_prompt` emits this self-state and drops the `topics_already_discussed` avoid-list.
   - `reverie/backend_server/persona/prompt_template/v2/generate_conversation_batch_v1.txt` and `survival_generate_conversation_batch_v1.txt`: Removed the prescriptive opener/topic rules and re-labelled the per-persona memory inputs so conversation flows from actual memory rather than injected rules.
   - `tests/test_conversation_self_memory.py` and `tests/test_conversation_manager.py`: New file covers the memory helpers and relative-time formatter (14 cases); existing file updated to remove assertions on the now-deleted `topics_already_discussed` emit.

- [x] **Reframe Survival Mode planning from command to context (Step 1 of conversation-quality cognitive fix)**
   - `reverie/backend_server/survival/controller.py`: Reworded the survival identity overlay from a directive into context the persona weighs as themselves, and added a grounding line treating the agent as a whole person with room to rest and reflect.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: Dropped the "allocate survival anchors FIRST" ordering command and removed the now-unused small-cast guidance input slot.
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: Removed the "don't drift from the gathering location" leash so non-anchor hours are planned freely.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Deleted the deterministic `_build_small_cast_guidance` / `_audit_small_cast_plan` machinery, its keyword-list constants, and both call sites.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Refreshed the `_is_small_cast` docstring and call-site comment after small-cast guidance removal (detector itself retained to gate the endgame plan-cache bypass).
   - Tests: Deleted two obsolete small-cast test files, added an overlay-reframe test to `test_identity_overlay.py`, and fixed a stale comment in `test_small_cast_forces_replan.py`.

---

## 2026-05-22 — Nicolas — branch: main

- [x] **Playback background music — shipped MVP (§7.1 / §10 items 1, 8, 9, 10)**
   - **Assets:** trailer masters `music_{intrigue,wholesome}.mp3` (75 s) → seamless loop via mid-section extraction + 3 s auto-crossfade at the seam + −16 LUFS normalization. Exported to `double-front/public/audio/music/playback_{intrigue,wholesome}.{ogg,m4a}` (~3.7 MB). **Dual format on purpose:** OGG (Vorbis) primary + M4A (AAC) fallback because Safari/iOS won't decode Ogg Vorbis even via `decodeAudioData`. WAV masters kept out of the FE repo in `generative_agents-local/video/audio/_raw/`. Loop seam verified in real Chromium (decode + 2.5 cycles in `OfflineAudioContext`; loop jump below the p99.9 of a normal sample step → no click); no `loopStart`/`loopEnd` needed.

## 2026-05-21 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix persona sprite cards on Supabase-only production server**
  - `api_gateway/app/services/supabase_service.py`: Query `double` schema tables via `supabase.schema("double")` instead of invalid `double.table` names so memories/coords load on VPS.

## 2026-05-21 — Ivan — branch: ivan/dev

### Backend

- [x] **BE memory #4 + #5 — model-router housekeeping**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: deleted the dead `self.prompt_cache` attribute (only ever assigned, never read); capped `tier_c_usage_by_step` to the most recent 100 step keys so it stops growing one entry per step over a long sim.

- [x] **Class C2 — dorm rest/tidy actions kept indoors**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added `_redirect_dorm_rest_to_interior()` — a `rest`/`tidy` action that resolves to the exterior dorm garden is redirected to the persona's interior `living_area`; skipped when the description explicitly names the garden. Wired into both planner-contract call sites.
   - `tests/test_dorm_rest_redirect.py`: new unittest file, 7 cases covering the redirect, non-rest actions, explicit-garden descriptions, non-dorm gardens, already-interior addresses, and missing `living_area`.

- [x] **Realism analyzer — OSCILLATION sleep gate**
   - `tests/analyze_sim_realism.py`: `_check_oscillation` now skips a run when ≥80% of its per-step descriptions are sleep/rest-like (token match, so "restaurant" doesn't trip it); overnight sleep bands no longer false-flag. Re-run on 20260520-1: OSCILLATION 6 → 0.
   - `tests/test_oscillation_sleep_gate.py`: new unittest file, 4 cases covering sleep/rest band suppression, genuine oscillation still flagged, and the restaurant non-match.

- [x] **Cross-building bed-action redirect (genuine Class A residual from sim 20260520-1)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added `_redirect_orphan_bed_anchor()` — when a 'bed'-anchored action resolves into an arena with no bed (e.g. "stretch in bed" landing in Hobbs Cafe), redirect to the bed in the persona's `living_area`; the within-arena repoint helper cannot rescue cross-building misses. Wired into both planner-contract call sites after `_repoint_arena_to_anchor_object`.
   - `tests/test_orphan_bed_redirect.py`: new unittest file, 7 cases covering the redirect, no-op when the arena already has a bed, non-bed anchors, missing/invalid `living_area`, and the `arena: object` anchor format.

- [x] **Declared-vs-actual Class A false-positive cleanup (analyzer accuracy)**
   - `tests/analyze_action-location.py`: replaced the plain substring match with `_dva_named_objects()` (word-boundary match + skips reference-preposition mentions like "before bed"/"near the piano") and `_dva_object_satisfied()` (accepts any bathroom fixture for the tile-less 'shower' fixture). Cuts Class A on 20260520-1 from 12 to a truthful 3.
   - `tests/test_dva_classification.py`: new unittest file, 7 cases covering word-boundary exclusion, reference-preposition skipping, genuine-target retention, and shower-fixture acceptance.

## 2026-05-20 — Ivan — branch: ivan/live-mode-updates

### Backend

- [x] **BE-4a Piece 1 — step-gap resolution for the LIVE-mode highlights side-list**
   - `video/extract_day_log.py`: added `_resolve_step_from_created_at()` helper that inverts the `curr_time = start_time + step * sec_per_step` invariant to map a memory's game-clock timestamp to a sim step, with day-range clamping and safe None returns for missing/invalid input; wired into `reflections_fmt` so each reflection now carries `step` and `time` fields.
   - `tests/test_extract_day_log_step_resolution.py`: new unittest file, 13 cases covering exact conversion, rounding, Z-suffix timestamps, missing/garbage input, day-range clamping, and non-default `sec_per_step`.

- [x] **BE-4a Piece 2 — household highlights assembly + phrase synthesis**
   - `video/extract_day_log.py`: added opt-in `include_events` param to `extract_day_log()`; when set, the output gains a step-resolved `events` list matching the reflections shape; default off so the trailer pipeline is unchanged.
   - `video/build_highlights.py`: new module and `python -m video.build_highlights` CLI; runs the extractor once per persona, merges and de-duplicates events/reflections/conversations into one step-ordered candidate pool, ranks by importance and caps to 8, then issues one batched gpt-5-nano LLM call to phrase each as a chapter-style caption; falls back to trimmed raw text if the LLM is unavailable; writes a `{step,time,sentence,personas,kind}` list to highlights.json.
   - `tests/test_build_highlights.py`: new unittest file, 14 cases covering candidate assembly, cross-persona conversation dedup, ranking/capping, the raw-text fallback, and phrase synthesis with a stubbed LLM (including markdown-fenced and partial responses).

- [x] **BE-4a Piece 3b — day-highlights read API endpoint**
   - `api_gateway/app/services/day_highlights_service.py`: new module with async `get_day_highlights(sim_code, day)` that reads the `double.day_highlights` row via the gateway's service-role Supabase client and returns the shaped response dict, or None when not yet generated.
   - `api_gateway/app/api/routes/simulations.py`: added `GET /api/simulations/{sim_code}/day/{day}/highlights` — validates inputs, calls the service, returns 200 with the highlights list or 404 when not yet generated.
   - `api_gateway/app/core/validation.py`: added `validate_day_number()` positive-integer check, mirroring `validate_step_number`.
   - `tests/test_day_highlights_endpoint.py`: new unittest file, 7 cases covering service row-to-response shaping, the not-generated None case, client-unavailable error, and day-number validator rules.

- [x] **BE-4a Piece 3a — Supabase storage for the highlights side-list**
   - `supabase/migrations/20260520140000_day_highlights.sql`: new migration creating `double.day_highlights` — one row per (sim_code, day_number) with a jsonb highlights list; unique index on (sim_code, COALESCE(day_number,-1)); RLS enabled, service-role only; mirrors video_narration_cache (not yet applied to live DB).
   - `video/highlights_store.py`: new module exposing `save_highlights()` (upsert) and `fetch_highlights()` via the service-role Supabase client; mirrors video/narration_cache.py.
   - `video/build_highlights.py`: CLI now persists the assembled highlights list to Supabase via `save_highlights()` in addition to writing the local highlights.json diagnostic file.
   - `supabase/db_reference.md`: added the `day_highlights` table entry.
   - `tests/test_highlights_store.py`: new unittest file, 7 cases covering insert-vs-update upsert branching, NULL-day filtering, sec_per_step defaulting, and the not-yet-generated None case, all against an injected fake Supabase client.

- [x] **Refresh Supabase schema dump and LLM-ready DB reference**
   - `supabase/db_schema.sql`: regenerated from remote via `supabase db dump -s public,double,extensions` (gitignored local artifact; 8 728 lines as of 2026-05-20).
   - `supabase/db_reference.md`: full applied-migrations table through `20260520140000`, `day_highlights` uuid PK, single 10-param `dbl_retrieve_with_rir` only, and canonical dump instructions vs stale `schema.sql`.

---

## 2026-05-20 — Ivan — branch: ivan/dev

### Backend

- [x] **Wire anchor-repoint helper into the planner contract main path (4th and final call site — closes the residual ~7/8 Class A bugs in sim 20260519-1 where anchor=`bed` but sprite ended at closet/desk/computer in the same arena)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added one `_repoint_arena_to_anchor_object` call immediately after a successful `resolve_location`, before the address is sealed into the action contract.
   - `tests/test_class_a_anchor_repoint.py`: added `test_planner_main_path_calls_repoint` wiring test for the 4th site; updated module docstring and class docstring from "three sites" to "four sites".

- [x] **Guarantee `action_family` in 100% of FE movement payloads (BE-1 — unblocks FE skip-on-sleep feature)**
   - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: removed `if self.action_family:` guard in `to_progress_payload()` and `if action_family:` guard in the dict-path of `project_action_contract_payload()` so both always emit the field (empty string when unknown).
   - `reverie/backend_server/persona/memory_structures/scratch.py`: added `progress.setdefault('action_family', '')` after contract payload merge in `calculate_action_progress()` to cover the case where contract build failed and there is no contract payload.
   - `tests/test_spatial_grounding_contract.py`: extended `test_action_family_is_optional_in_v1` to assert `action_family` is always present as an empty string in both payload paths.

- [x] **Supabase client singleton — eliminate per-call-site client allocation to cut memory churn on long simulations (BE memory #2)**
   - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: added `import threading`; added module-level singleton globals and locks; renamed existing factory bodies to private `_build_supabase_client_raw` / `_build_double_memory_client`; `create_supabase_client_raw` / `create_double_memory_client` are now double-checked-locking memoizers that return the process-wide singleton, skipping allocation on the 30+ subsequent call sites per simulation.
   - `tests/test_supabase_client_singleton.py`: new test file asserting each factory builds exactly once, returns the identical object on repeated calls, builds exactly once under a 20-thread concurrent first-use race, and does not cache a None result.

- [x] **Fix survival-memory duplication (~8-20 duplicate rows per elimination event in dbl_memory)**
   - `reverie/backend_server/persona/cognitive_modules/reflect.py`: added `_is_flush_reinsert(node)` helper that detects a JSON-backup re-insert by its `provenance='pre_compaction_flush'` marker; `_flush_candidates` now skips such nodes so the flush loop cannot re-write its own backups on the next reflection cycle.
   - `tests/test_pre_compaction_flush_dedup.py`: added `test_flush_reinsert_copy_is_not_reflushed` and `_make_flush_reinsert_node` mock helper to assert that a re-inserted node with a fresh `node_id` is not re-flushed.

---

## 2026-05-18 — Ivan — branch: ivan/post-20260517-followups

### Backend

- [x] **Embed at flush time so flushed high-value rows land with a matching `dbl_embedding` insert (Branch F — closes Issue 1: 23 elimination + 17 vote_tally rows missing embeddings when `USE_DB_MEMORY_READS=true` initialises `a_mem.embeddings` as `{}`)**
   - `reverie/backend_server/persona/cognitive_modules/reflect.py`: in `_flush_high_value_memories_pre_compaction`, when `embeddings.get(embedding_key)` returns None or non-list, compute fresh via `get_embedding(description)` — same fallback `broadcast_event_to_personas` uses.
   - `tests/test_pre_compaction_flush_embedding.py` (new): 3 tests — empty-dict triggers fresh compute; cached embedding preferred; non-list cached value falls through to fresh compute.

- [x] **Add OPENER STYLE block to batch conversation template (Branch I — closes Issue 3: "Quick thought" opener at 39-42% on Day-1/2 chats; Branch B covered only the iterative template but Day-1/2 full-tier chats route through the batch template)**
   - `reverie/backend_server/persona/prompt_template/v2/generate_conversation_batch_v1.txt`: added OPENER STYLE block mirroring `iterative_convo_v1.txt`, forbidding all four quick-thought/quick-check patterns including the `<Name> — quick X` variant.
   - `tests/test_batch_convo_opener_guidance.py` (new): 4 tests — OPENER STYLE header present; all four forbidden patterns named; `<Name> — quick X` variant covered; positive alternatives offered.

- [x] **Post-process gate ensuring small-cast daily plans include ≥ 3 standalone non-survival entries (Branch H — closes Issue 2: Ivan's Day-3 plan had 0 standalone non-survival entries; Branches C/C' delivered the rule to the LLM but persona-trait pull overrode MUST/REQUIRED prompt phrasing)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: added `_is_standalone_non_survival` classifier, keyword lists, and `_audit_small_cast_plan` helper; wired into `run_gpt_prompt_daily_plan` as a deterministic post-process gate that splices default activities when the LLM output falls short.
   - `tests/test_daily_plan_small_cast_audit.py` (new): 12 tests across classification (meal/leisure/survival/compound) and audit behaviour (compliant plan unchanged; 0→3 splice; 1→2 splice; compounds don't count; no-op when not small-cast or survival off; defaults synced with prompt examples; no re-splice when standalone breakfast already present).

- [x] **Gate bed penalty on anchor intent so resolver respects explicit "bed" anchors (Branch G — closes Class A resolver regression: 22 mismatches vs baseline 11; root cause was `-40` penalty + non-bed filter rewriting Katya's bed anchor to `blackboard`; Class C2 deferred — RCA shows those 5 cases originate upstream in the LLM proposal, not in `_pick_best_object_address`)**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: in `_pick_best_object_address`, gate the `score -= 40` bed penalty and non-bed filter on `not anchor_requests_bed`, derived from `bool(anchor) and "bed" in _anchor_tokens(anchor)`.
   - `tests/test_resolver_anchor_preference.py` (new): 7 tests — explicit bed/closet/computer anchors return the named object; sleep + bed anchor regression guard; non-sleep without bed anchor still avoids bed (preserves original penalty intent); non-bed anchor unchanged.

- [x] **Class A anchor-repoint — generalise depth-3→4 promotion at all three plan.py finalisation sites (RCA follow-up to Branch G; §10 of the 20260517-1 sim report traced 16 of 20 Sub-bug A cases to contract-builder paths that discard the anchor before writing the location address)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new helper `_repoint_arena_to_anchor_object(arena_address, anchor, maze)` promotes a depth-3 arena address to its matching depth-4 object address when the anchor names a real object in that arena (validated against `maze.address_tiles`); no-op when already depth-4, anchor is empty/`local_anchor`, or object is absent; wired into 3 call sites — `inherit_via_fence` branch (parent_location_inherit_v1, ~12 cases), LLM-path arena fallback (llm_location_v1, ~3 cases), and planner-path `LocationResolutionError` fallback (planner_contract_v1, ~1 case); expected closure 16/20 real Class A bugs (80 %).
   - `tests/test_class_a_anchor_repoint.py` (new): 12 tests — 5 helper unit tests (no-op cases, promotion, cross-arena guard, arena:object pair anchor), 3 source-text wiring tests (one per call site), 4 regression-shape tests reproducing the 20260517-1 failing fingerprints (Katya bed/computer/closet, Gosha bed in Dorm Room 1); 81/81 across 10 related suites green, full movement/resolver battery 115/116 (1 pre-existing unrelated failure confirmed on parent branch).

- [x] **Fold declared-vs-actual analysis into the canonical action-location analyzer (so every future sim auto-reports Class A/B/C1/C2 next to V1-V4, Bug A/B/C, pure-LLM readiness — no more per-sim script copies)**
   - `tests/analyze_action-location.py`: added `report_declared_vs_actual()` section invoked from `__main__` after `report_pure_llm_readiness()`; walks `monitoring/step_*.json`, classifies Class A (anchor selection / desc names object not at sprite) / Class B (address_label payload desync, with cross-building + truncated sub-classes) / Class C1 (Apartment N in description) / Class C2 (rest/tidy in dorm → exterior garden); eliminations sourced dynamically from `survival/season_state.json`; Class A output includes per-resolution-source breakdown; new Decision Summary adds `Class A real bugs` trigger gate (target ≤ 5).
   - `tests/analyze_declared_vs_actual_20260517-1.py`: deleted; logic is now in `analyze_action-location.py` and the sim-coded filename would have drifted on future runs.

- [x] **Class A anchor-repoint — depth-4 swap extension (sim 20260518-2 at 3500 steps surfaced 30/39 Class A cases as depth-4 inherit with correct arena but wrong object; the prior helper short-circuited on those by design)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: extended `_repoint_arena_to_anchor_object` to also swap depth-4 → depth-4 when the existing object differs from the anchor's named object and that object exists in `address_tiles`; short-circuit guard changed from "if existing_obj or not arena_name" to "if not arena_name" plus an early-return when the existing object already matches the anchor.
   - `tests/test_class_a_anchor_repoint.py`: renamed `test_no_op_when_address_already_object_level` → `test_no_op_when_depth4_object_already_matches_anchor`; added three new tests — depth-4 swap to different object in same arena (the 20260518-2 dominant case), exhaustive object-swap coverage across all objects in a room, and cross-arena depth-4 no-op guard; updated module docstring; 15/15 in the suite, 91/91 across 12 related suites.
   - `tests/test_parent_arena_inheritance.py`: updated `test_inheriting_rows_reuse_parent_address` assertion to the new contract — inheriting sub-actions resolve to the depth-4 anchor object within the parent's arena rather than the verbatim depth-3 parent address; "no fresh resolver call" invariant preserved.

---

## 2026-05-17 — Ivan — branch: ivan/reflect-event-rewrite

### Backend

- [x] **Drop the survival-elim double-write (Branch E — sim 20250516-2 showed `elimination_witnessed` rows still at 7.00× dup_factor with 71 % missing embeddings, fingerprinting the `tag_event` second path)**
   - `reverie/backend_server/survival/controller.py`: removed the per-survivor `tag_event` loop in `_broadcast_elimination`. `broadcast_event_to_personas` is now the single canonical write path — already provides stable `dedup_key` idempotency, durable embedding via `add_event_durable`, and surfaces the row to Tier-C chat retrieval.
   - `tests/test_broadcast_single_write.py` (new): 3 tests — `tag_event` not called for elimination_witnessed; broadcast called exactly once with correct witnesses + dedup_key; vote_tally broadcast unchanged.

- [x] **Force daily-plan regeneration when survival cast collapses to ≤ 2 (Branch C′ — sim 20250516-2 showed zero `daily_plan` LLM calls during the Day-3 small-cast window; the MUST/REQUIRED guidance from Branch C never reached the LLM because two bypass gates short-circuited planning for survivors)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added `_is_small_cast(persona)` predicate (mirrors `_build_small_cast_guidance`'s alive-count check). `_long_term_planning` now bypasses both `schedule_validator.should_skip_daily_planning` and `planning_cache.get_cached_plan` when small_cast is True, forcing a fresh plan generation.
   - `tests/test_small_cast_forces_replan.py` (new): 9 tests — predicate edge cases (2/1/3-alive, survival off, missing survival dict); skip-gate bypass; cache-gate bypass; normal cast still uses cache.

- [x] **Forbid "Quick thought / Quick check" openers in the conversation prompt (Branch B follow-up — sim 20250516-2 showed cap-at-1 killed the literal `"Quick thought —"` opener but the LLM substituted `"Katya — quick thought:"`, appearing in 8/26 = 31 % of Day-3 openers)**
   - `reverie/backend_server/persona/prompt_template/v3_ChatGPT/iterative_convo_v1.txt`: added an OPENER STYLE block forbidding `"Quick thought —"` / `"Quick thought:"` / `"Quick check —"` / `"Quick check:"` and the `"<Name> — quick X"` variant; tells the LLM to start naturally (greeting / observation / direct question / substance) and vary openers across consecutive same-pair chats.
   - `tests/test_iterative_convo_opener_guidance.py` (new): 5 tests — OPENER STYLE header present; both quick-thought and quick-check forbidden patterns named; name-prefix variant covered; positive alternatives offered.

---

## 2026-05-16 — Ivan — branch: ivan/reflect-event-rewrite

### Backend

- [x] **Stop the periodic memory backup from re-saving the same survival events every ~30 min (Branch A — fixes the 22× dup_factor on `elimination_witnessed` rows seen in 20260515-4)**
   - `reverie/backend_server/persona/cognitive_modules/reflect.py`: added `_get_flushed_node_ids(persona)` (lazy-init `set` on `persona.scratch`, mirrors `_poignancy_score_cache` pattern); `_flush_candidates` skips nodes whose `node_id` is already in the set; `_flush_high_value_memories_pre_compaction` marks nodes post-write. Each high-poignancy node is now backed up at most once per persona lifetime instead of every compaction cycle.
   - `tests/test_pre_compaction_flush_dedup.py` (new): 4 tests covering single-node dedup across cycles, new-node still flushed, all-N nodes skipped after first cycle, below-threshold not marked.

- [x] **Tighten partner-block topic dedup from cap=2 to cap=1 (Branch B — sim 20260515-4 showed cap=2 only reduced "Quick thought" opener rate 36 % → 30 %; target ≤ 20 %)**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: `_PARTNER_BLOCK_PER_TOPIC_CAP: 2 → 1`. Comment cites the 20260515-4 evidence.
   - `tests/test_partner_block_topic_dedup.py`: 3 assertions updated (5-thought test expects 1 match; recency test drops t3 too; thoughts/events independence asserts 1/1). All 11 tests pass.

- [x] **Rewrite small-cast planner guardrail to MUST/REQUIRED form (Branch C — sim 20260515-4 showed Ivan's Day-3 plan was 100 % survival-rehearsal entries; soft "30 %" phrasing was ignored)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `_build_small_cast_guidance` rewritten — header now `SMALL CAST GUIDANCE (REQUIRED — only N players remain today)`. Three bullets: MUST include ≥ 3 non-survival entries with 5 concrete examples (`have breakfast at Home`, `take a quiet walk in Johnson Park`, etc.); each must stand alone (forbids compound `resting AND rehearsing` entries explicitly); variety required.
   - `tests/test_small_cast_planner_guardrail.py`: 4 new assertions — MUST/REQUIRED form, concrete count not percentage, concrete activity examples, anti-compound instruction. All 14 tests pass.

- [x] **Drop the bootstrap-template concept (Branch D — fork-source name is the only input needed; no more "template" crutch)**
   - `reverie/backend_server/reverie.py`: removed `_get_supabase_bootstrap_template` helper and the `SUPABASE_BOOTSTRAP_TEMPLATE` env-var path. `_bootstrap_missing_fork_from_supabase` now constructs the fork's folder structure programmatically (`os.makedirs` for each needed subdir; minimal placeholder JSON files where required); start-time-of-day defaults to 09:00:00 when no baseline meta is reachable. Bootstrap works from an empty `storage/`.

---

## 2026-05-15 — Ivan — branch: ivan/conversation-quality

### Backend

- [x] **Small-cast planner guardrail (Step 2.1) — when ≤ 2 survivors remain, daily plans are steered toward variety**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: added `_build_small_cast_guidance(persona)` and wired it into `run_gpt_prompt_daily_plan` as a new prompt slot. Returns "" when survival_mode off, alive_players ≥ 3, or alive_players empty; renders SMALL CAST GUIDANCE text otherwise. Targets the Day-3 mode collapse in sim 20260514-1 (both survivors converging on the same rehearsal-loop daily plan).
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: appended `!<INPUT 8>!` slot above ACTIVITY RULES; renders the guidance only when the helper returns non-empty.
   - `tests/test_small_cast_planner_guardrail.py` (new): 10 tests covering helper behavior (counts 0/1/2/3/4, survival off, missing scratch) and template wiring (slot present, rendered/omitted correctly).

- [x] **Partner-block topic dedup (Step 2.2) — caps same-topic thoughts at 2 per chat prompt**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: hoisted `_partner_block` and `_node_key` from nested closure to module level so they're unit-testable; added `_extract_topic_signature(text)` (strips ~80 stopwords, returns first 3 content words lowercased) and `_dedup_by_topic(nodes)` (caps at 2 per signature; untaggable nodes get unique fallback keys so they survive). Breaks the recursive Energy-Rationing anchor where 5 same-topic partner-thoughts re-anchored every new chat onto the same pitch.
   - `tests/test_partner_block_topic_dedup.py` (new): 11 tests — signature extraction (stopwords, case-insensitive, short text, stopword-only), dedup behavior (cap at 2, distinct topics survive, recency preserved across dedup), edge cases (empty input, 1-word thoughts, mixed-language, separate caps for thoughts vs events).

- [x] **Analyzer hygiene (Step 2.3) — chat cooldown reporting + OSCILLATION false-positive gate**
   - `tests/analyze_sim_realism.py`: added `_check_chat_cooldown_violations(records)` — groups chat-step records by `(pair, conversation_id)` (so multi-step chat slices count as one conversation), looks up arena `cooldown_mod` from `maze_registry.json`, applies tier-based base cooldowns (5/15/30) and the first-daily-encounter bypass that mirrors `conversation_manager._is_first_daily_encounter`. Also extended `_extract_chat_from_movement` to return `conversation_id` from `chat_metadata`. Gated `_check_oscillation` so long stationary runs aren't flagged when `stationary_intent` is true ≥80% of the run OR ≥3 distinct descriptions appear (varied work in one spot is not oscillation). On `20260514-1`: OSCILLATION 2→0 (matches expected); CHAT_COOLDOWN_VIOLATION reports 211 (vs the verification report's manual recount of 1, which only counted overlapping/negative-gap conversations) — honest count by the cooldown rule, may indicate a runtime bypass path worth a follow-up branch.

---

## 2026-05-15 — Ivan — branch: ivan/survival-retrieval-fix

### Backend

- [x] **Fix survival broadcasts losing embeddings on sim restart; durable write path replaces async for high-poignancy events**
   - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: added `add_event_durable` — sync variant of `add_event` that commits the dbl_memory + dbl_embedding rows via `_write_to_supabase_with_retry` before returning. Mirrors `tag_event`'s blocking write semantics so the embedding row is durable across sim restart (root cause of sim 20260514-1's missing dbl_embedding rows for Day-1/Day-2 elim broadcasts).
   - `reverie/backend_server/persona/cognitive_modules/world_events.py`: `broadcast_event_to_personas` now prefers `add_event_durable` when available, falls back to `add_event` for plain `AssociativeMemory` stores in tests / pre-Hybrid runtimes.
   - `tests/test_broadcast_event_durability.py` (new): 3 tests — durable preferred when present, fallback when absent, idempotency preserved on dedup_key collision.
   - `tests/test_batch_alpha_survival_pipeline.py`: 4 assertions updated from `add_event` to `add_event_durable` to match the new canonical broadcast write path. All 11 pre-existing tests still pass.

- [x] **Guard `_execute_elimination` against re-firing across sim restart (fixes 30+ duplicate Day-2 elim broadcasts in sim 20260514-1)**
   - `reverie/backend_server/survival/controller.py`: added an early-return guard in `_execute_elimination` — if the determined `eliminated` name is already present in the persisted `season.eliminated` list, log and return None instead of re-appending and re-broadcasting. `_pending_elimination` and `_elimination_done` are in-memory only, so a restart resets them and re-runs the voting flow; `season.eliminated` IS persisted, so it's the right source of truth for "has this person already been eliminated this run?"
   - `tests/test_survival_restart_idempotency.py` (new): 3 tests — (1) skip when target already in `season.eliminated`, (2) proceed normally for fresh target, (3) skip even when the original elim was on a different day. 44 tests green across Batch α + Batch β + Batch γ + the two new suites.

- [x] **One-time backfill helper for sim 20260514-1's missing embeddings (two-step SQL-editor workflow)**
   - `tests/diagnose_missing_embeddings_20260514_1.sql` (new): Supabase-editor SELECT that joins `dbl_memory` to `dbl_embedding` and returns rows in this sim with survival keywords but no embedding row. User exports results to CSV.
   - `tests/generate_backfill_sql_20260514_1.py` (new): reads the CSV, computes 768-d embeddings via the same `_get_compressed_embedding` the runtime uses, and emits `tests/backfill_20260514_1.sql` with idempotent `INSERT … WHERE NOT EXISTS` statements wrapped in a transaction. Pure CSV-in/SQL-out — no Supabase client calls (the codebase only uses `.rpc()`, not PostgREST table queries, so we keep the DB round-trips in the editor where the user already has tooling). Enables retrospective verification that the retrieval fix unblocks surfacing on existing data.

- [x] **Drop the 9-param `dbl_retrieve_with_rir` overload — actual root cause of broadcast surfacing failure (PGRST203)**
   - `supabase/migrations/20260515_drop_dbl_retrieve_rir_9param_overload.sql` (new): drops the original 9-parameter overload of `dbl_retrieve_with_rir`. The 10-param variant added in `20260414_dbl_retrieve_rir_sim_scope.sql` had been co-existing alongside the 9-param ever since — PostgreSQL resolves that fine for direct SQL but PostgREST 12+ refuses to dispatch when two overloads share a name and the caller doesn't disambiguate. Every 9-arg call from the cognitive-loop default path (`retrieve_with_pgvector` → `dbl_retrieve_with_rir`) has been failing with PGRST203 since 2026-04-14, then falling back to a "basic retrieval" path that itself errors with "Access denied for agent X". The whole survival broadcast surfacing failure on sim 20260514-1 traces to this. Dropping the 9-param leaves every existing 9-arg call site unambiguously routing to the 10-param overload, which produces byte-identical behavior when `p_simulation_id` defaults to NULL.
   - `tests/count_survival_rows_20260514_1.sql` (new): Q1/Q2/Q3 read-only diagnostic for survival memory counts (per-kind, per-persona, dup_factor) — confirmed pre-dedup 161 elim_witnessed rows / 6 distinct events, and post-dedup 6/6.
   - `tests/dedupe_survival_broadcasts_20260514_1.sql` (new): one-time dedup of the broadcast bloat for sim 20260514-1. PARTITIONs by `(agent_id, content)` and keeps the row that already has an embedding (so the keeper doesn't need backfill). Reduced 161 elim broadcast rows to 6 (1 per logical event).
   - `tests/verify_survival_retrieval_20260514_1.py` (new): end-to-end verification — instantiates a minimal persona, calls `retrieve_with_pgvector` for the survival vote-decision focal points, asserts ≥1 survival-tagged result per focal per persona. PASSed for both Luba and Katya on 2/3 focal points after the migration applied (the third focal — "Who do my allies want gone?" — has no direct memory evidence regardless of retrieval health).
   - `tests/generate_backfill_sql_20260514_1.py`: argv-aware input path (also looks under `test-results/` as a default).

---

## 2026-05-15 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Loosen day-overview narration ceiling so the LLM's natural variance can converge**
   - `video/showrunner.py`: bumped `DAY_OVERVIEW_NARRATION_BOUNDS` (80,105)→(80,110); the LLM's ±10-15 word variance was missing the 105 ceiling by 3-15 words across retries (real-run attempts: 120/143/108). The 108-word attempt actually fit the video cleanly (57s narration + 6s pad in a 65s video) — the bound was overly strict. Also re-targeted the prompt's per-beat hint to 1.7 w/s and made "aim for the lower end of the range" explicit so the LLM targets ~90-95 with variance landing safely under 110.
   - `video/validate_trailer.py`: matched `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (80,110).

- [x] **Recalibrate day-overview narration word bound to measured TTS pace (~1.9 w/s)**
   - `video/showrunner.py`: tightened `DAY_OVERVIEW_NARRATION_BOUNDS` (85,120)→(80,105) and lowered the prompt's per-beat target from 2.0 to 1.9 words/sec. Two real-run measurements landed at 1.90 and 2.06 w/s; the old 120-word ceiling rendered 62s of voiceover that overran the 65s video by ~3s, truncating the cliffhanger. The new ceiling lands ~55s of voiceover with a ~3.7s clean tail and is caught explicitly by the `_check_narration_fits_video` backstop if TTS pace drifts.
   - `video/validate_trailer.py`: matched `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (80,105).

- [x] **Fix Narration Writer oscillating past the total word bound**
   - `video/showrunner.py`: added an explicit "TOTAL WORD BUDGET — non-negotiable" section to `DAY_OVERVIEW_NARRATION_WRITER_SYSTEM` and a `{budget_lo}-{budget_hi}` opening line to the user template, with the bound passed in from `DAY_OVERVIEW_NARRATION_BOUNDS` — the writer was producing 180-285 words with only indirect "~2.0 words/sec" guidance and exhausting retries; relaxed the bound (85,115)→(85,120) for a small safety margin.
   - `video/validate_trailer.py`: matched `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (85,120).

---

## 2026-05-14 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Fix day-overview narration overrunning the video (cliffhanger truncated)**
   - `video/showrunner.py`: recalibrated `DAY_OVERVIEW_NARRATION_BOUNDS` (110,175)→(85,115) to the measured ~2.0 words/sec TTS pace — the old ceiling implied ~85s of voiceover for a ~65s trailer, so the closing beats were silently truncated; updated the Narration Writer prompt's pacing guidance from 2.5 to 2.0 words/sec.
   - `video/validate_trailer.py`: matched `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (85,115); added `_check_narration_fits_video` — a direct backstop that fails validation when the narration audio + brand-opener pad exceeds the trailer length.

- [x] **Fix day-overview Narration Writer crashing on tight per-beat word bands**
   - `video/showrunner.py`: `_narration_writer_validate` now returns `(hard_errors, advisories)` — per-beat word-count drift is an advisory (fed back as retry guidance, widened to 0.8×–4.0× duration) instead of a hard failure; only the total word count, beat structure, and load-bearing content stay hard. `_narration_caller` no longer raises when only per-beat pacing is slightly off, fixing a Day-1 run that exhausted all 3 retries oscillating around an unsatisfiable ~10-word-per-beat window.

- [x] **Day-1-aware day-overview narration**
   - `video/showrunner.py`: added a "Day 1 — the cast's debut" note to the Story Producer and Narration Writer system prompts so that on Day 1 (no `yesterday_scar` beat, trailer opens cold) the opening `today_pressure` beat lightly grounds who the lead is before the day's pressure lands.

- [x] **Rework day-overview narration to two-stage Reality-TV architecture**
   - `video/showrunner.py`: replaced per-scene-isolated narration with a two-stage cached flow — a Day Story Producer LLM stage that decides day thesis, lead, dramatic question, status deltas, and a per-beat plan, followed by a deterministic footage-assignment step, then a single-pass Narration Writer LLM stage that writes the whole narration as one continuous story; introduced a fixed 6-beat template (yesterday_scar→today_pressure→apparent_plan→countermove→vote_reveal→new_imbalance) with pressure_peak/unresolved fallback; retargeted runtime to 53s and narrowed all bounds accordingly.
   - `video/compose_trailer.py`: updated `MODE_DURATIONS_SEC["day_overview"]` from 105 to 53 to match the new runtime target; refreshed stale docstrings.
   - `video/validate_trailer.py`: tightened `DURATION_BOUNDS_SEC["day_overview"]` to (58,76), `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (110,175), and `_check_overview_scene_count` to 3-6 scenes.

---

## 2026-05-14 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Add brand opener and end card to day-overview trailer**
   - `video/showrunner.py`: added `_cohort_label()` helper to derive a family/group label from protagonists' shared surname prefix; `_stitch_overview_script` end-card dict now carries `cohort_label`, `text`, `body_a`, and `body_b` for the opener-style brand end card.
   - `video/compose_trailer.py`: day-overview branch now prepends the brand opener via `compose_brand_open`, renders an end card via `generate_opener_end_card` over the `brand_end_card_motion` background, concatenates brand-open + scenes + end-card, derives real duration via ffprobe, and pre-pads narration by the brand-open length to keep scene VO aligned; added `DAY_OVERVIEW_END_CARD_DUR` constant.
   - `video/validate_trailer.py`: raised `DURATION_BOUNDS_SEC["day_overview"]` ceiling from 120 to 135 to accommodate the ~14s of brand cards added to the scene body.

---

## 2026-05-14 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Retune day-overview trailer to ~105s runtime with duration-paced narration**
   - `video/showrunner.py`: `DAY_OVERVIEW_TARGET_RUNTIME` 165→105, `DAY_OVERVIEW_RUNTIME_BOUNDS` (150,180)→(90,120); shortened spine beat-sheet durations; switched per-scene narration from fixed 35-60 word band to duration-paced (~2.5 words/sec) in system prompt, user template, and `_scene_validate`; `DAY_OVERVIEW_NARRATION_BOUNDS` (200,600)→(150,340); refreshed stale 2:30-3:00 runtime references.
   - `video/compose_trailer.py`: `MODE_DURATIONS_SEC["day_overview"]` 165→105; refreshed stale `_target_duration_sec`/`combine_video_audio` docstring runtime examples.
   - `video/validate_trailer.py`: `DURATION_BOUNDS_SEC["day_overview"]` (150,180)→(90,120); `NARRATION_BOUNDS_BY_MODE["day_overview"]` (200,600)→(150,340); refreshed stale comment runtime examples.

---

## 2026-05-14 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Punchier day-overview trailers: shorter per-scene footage windows, more scenes**
   - `video/showrunner.py`: tightened spine beat sheet (developments 2-3→3-5, scene count 5-7→6-10, shorter per-beat durations); `key_steps` per scene reduced 3-5→1-3; per-scene narration target narrowed to 35-60 words; `_spine_validate`/`_validate_overview_script` scene-count upper bound raised to 10; `DAY_OVERVIEW_NARRATION_BOUNDS` updated to (200, 600).
   - `video/validate_trailer.py`: `NARRATION_BOUNDS_BY_MODE["day_overview"]` updated to (200, 600); `_check_overview_scene_count` bound raised to 4-10; stale comment refreshed.

---

## 2026-05-14 — Ivan — branch: ivan/day-overview-v2

### Backend

- [x] **Phase 2 + 3.1 — day-overview card border/overlay wiring and validator bounds expansion**
   - `video/compose_trailer.py`: added `_compose_day_overview_card_clip` to wrap each scene clip in the brand trading-card border + name/label overlay; wired into the day-overview compose branch before council grade; added guarded `music_tail_fade_sec` param to `mix_audio` (default 0.0, byte-identical to before) with the day-overview call site passing 5.0 for a music tail fade per PRD §4.3.
   - `video/validate_trailer.py`: widened `NARRATION_BOUNDS_BY_MODE["day_overview"]` to (250, 560) to match the 6-beat spine; added `_check_overview_scene_count` validator (4–7 scenes), gated on day_overview mode.

- [x] **Phase 1.1 — day-overview trailer v2 uplift: 6-beat spine, per-role voice prompts, narration cache**
   - `video/showrunner.py`: added `DAY_OVERVIEW_BRAND_DISCIPLINE` and a `DAY_OVERVIEW_ROLE_SYSTEM` dict with six per-role voice system prompts; added `_tier_c_model()` helper; promoted spine to a 6-beat structure (renamed `council_vote`→`vote_fallout`, added `turning_point` role); extended scene-count bounds to 4–7 and narration bounds to 250–560 words; wired `narration_cache.get_or_generate` into per-scene generation in `_generate_day_overview_script`; unified end-card copy in `_stitch_overview_script`.

---

## 2026-05-14 — Ivan — branch: ivan/video

### Backend

- [x] **Fix trailer validator false-FAIL when vertical 9:16 render is disabled**
   - `video/validate_trailer.py`: import `VERTICAL_9X16_ENABLED` from `compose_trailer` and only add the `trailer_9x16.mp4` entry to `EXPECTED_DIMENSIONS` when that flag is true, so an otherwise-clean opener render no longer fails the quality gate for a file the pipeline correctly does not produce; docstring updated to match.

- [x] **Phase 8 — narration-aligned grid cast intros (Steps 1–3); Step 4 trailer tail still pending**
   - `video/tts.py`: changed Doubland TTS pronunciation override from "Dohbland" to "Dubbleland"; `render_narration` now measures each spoken line's duration via a new `_probe_audio_duration` ffprobe helper and, when `timing_path` is supplied, writes a `narration_timing.json` map of every line's start/end second.
   - `video/generate_trailer.py`: audio step passes `timing_path` to `render_narration` and skips the cache only when both the audio file and its timing map are present (a run missing the map re-renders once to produce it).
   - `video/compose_trailer.py`: replaced fixed-15s-slot cast intros with a narration-driven grid section — new `compose_cast_grid_section` shows a 2x2 auto-sizing roster and expands each persona card to full-screen for exactly their narration line's duration (from the timing map), with sprite walkout playing once instead of looping; cold-open and stakes-montage durations are also timing-map-derived; trailer length is now real concatenated length rather than a fixed 130s budget; fixed pre-existing `_ffmpeg_escape_text` apostrophe bug (straight apostrophe broke comma-joined drawtext chains, swapped to U+2019); removed now-unused `compose_cast_intro` and `opener` entry in `MODE_DURATIONS_SEC`; added helpers `_concat_hardcut`, `_render_still_clip`, `_render_roster_png`, `_compose_persona_card_clip`, `_load_narration_timing`.

- [x] **Animated zoom transitions for cast cards; trailer tail shortened to ~113s**
   - `video/compose_trailer.py`: each persona's card now animates out of its roster cell and collapses back into it via a new `_compose_zoom_transition` helper (ffmpeg `scale`/`overlay` with `eval=frame` over a static roster backdrop), seeded by a new `_extract_frame` helper; `_roster_grid_dims` refactored out of `_render_roster_png` so both helpers share it; end-card hold replaced by a fixed `OPENER_END_CARD_TAIL_SEC=5s` tail with music fade-out via new `_apply_audio_fadeout`; narration prepad now compensates for the two crossfades before the cast section so VO lands tighter on its visuals; new constants `ZOOM_TRANSITION_SEC`, `OPENER_END_CARD_TAIL_SEC`, `OPENER_MUSIC_FADE_SEC`, `OPENER_DEFAULT_CROSSFADE_SEC`; verified 20260513-1 re-render at 113.4s.

---

## 2026-05-13 — Ivan — branch: ivan/video

### Backend

- [x] **Phase 6e — brand bookend integration in opener trailer pipeline**
   - `video/compose_trailer.py`: added `BRAND_OPEN_MOTION_PATH` / `BRAND_END_CARD_MOTION_PATH` constants, `compose_brand_open()` (Stage 0 stream-copy with graceful skip when asset absent), `_prepad_narration()` (silence-pad so VO timestamps survive the prepend), 3-tier background loader in `generate_opener_end_card` (motion clip → still PNG → flat color, with freeze-frame extension via `tpad`), and updated `compose_opener_trailer` to prepend `brand_open.mp4` to the concat list, bump `target_duration` by `brand_open_dur`, shift narration + sting overlays by that offset, and clean up new intermediates.

- [x] **Fix 25 fps mismatch that caused silent xfade failure in concat_scenes**
   - `video/compose_trailer.py`: switched `compose_brand_open` from `-c copy` to a libx264 re-encode at `-r 25 -crf 18 -pix_fmt yuv420p` so the brand-open output matches the 25 fps emitted by every other stage; added `-r 25` to `generate_opener_end_card` output args for the same reason.

- [x] **Phase 7 Tier A — cohort-agnostic Phaser bake (steps 1–2 of 5): folder restructure + bake script**
   - `video/assets/phaser/_moodboard/`: new home for the 4 hand-curated reference snapshots (`1-village-birdeye.png`, `2-hobbs-cafe.png`, `3-dorm.png`, `4-oak-hill-library.png`) and the existing `raw/` subfolder, git-renamed so history is preserved.
   - `video/assets/phaser/cohort-agnostic/`: new empty output directory that will receive the baked Tier A assets once Ivan runs the bake script.
   - `video/assets/scripts-prompts/label_phaser_birdeye.py`: updated input path to point at `_moodboard/` after the folder rename.
   - `video/assets/scripts-prompts/bake_cohort_agnostic_phaser.py`: new ~260-LOC idempotent script that bakes 4 cohort-agnostic assets (`village_overhead.png`, `landmark_cafe.png`, `landmark_council.png`, `signature_flyover.webm`), strips player chrome via `addStyleTag`, and supports `--force` / `--only stills|flyover` flags.

---

## 2026-05-13 — Ivan — branch: ivan/dev

### Backend

- [x] **Batch β — conversation realism + survival follow-ups (Edits A + D + E + F + G1 + G2)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Edit A — `run_gpt_prompt_generate_conversation_batch.create_prompt_input` now routes `scratch.get_str_iss()` into desc_a/desc_b so personas anchor on real identity instead of inventing texture.
   - `reverie/backend_server/persona/prompt_template/v2/generate_conversation_batch_v1.txt`: Edit A header update + F1 name discipline (use only the two speaker names; third parties from memories or "someone"/"a stranger").
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_conversation_batch_v1.txt`: same Edit A header + F1 name discipline; F2 — collapsed "ordinary people / voting bloc" steering into one neutral elimination-format line; F3 — softened the "do NOT quote or restate verbatim" overlay clamp.
   - `reverie/backend_server/persona/memory_structures/associative_memory.py`: Edit D — added `retrieve_about(name, top_k, kind)` pure-dict helper against `kw_to_thought` / `kw_to_event` for partner-focused retrieval.
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: Edit D — `start_conversation` prepends partner-focused top-5 thoughts + top-5 events (deduped vs. standard top-30 by node_id) under explicit headers; Edit E — `end_conversation` now picks a 3-tier cooldown (5 / 15 / 30 sim-min for greeting / normal / deep) by exchange count + average `chat_poignancy`, replacing the legacy computed/fallback branches.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Edit E — `_should_react` short-circuits to False when `OBSERVATION_PRIMARY=true`, leaving observation-driven `ConversationManager` as the sole conversation entry point; updated the flag comment to reflect live behaviour.
   - `reverie/backend_server/survival/controller.py`: G1 — added end-of-`on_step` resync of `scratch.survival.alive_players` + new `eliminated_players` for every surviving persona, so post-elimination perceive cycles in the same step see post-step truth (closes the ghost-event leak found in sim 20260512-3).
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: G2 — `_survival_key` filter now also excludes any subject in `scratch.survival.eliminated_players` (defensive belt against alive_set drift within a step).
   - `tests/test_batch_beta.py`: NEW — 15 tests across 6 classes covering Edit A prompt-input wiring, Edit D `retrieve_about` semantics, Edit E cooldown tiers + plan-path short-circuit, and G1+G2 source markers + filter logic.

- [x] **Batch γ — fix HybridMemoryStore kw-index + retrieve_about proxy gap (was silently disabling Edit B idempotency + Edit D partner retrieval)**
   - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: added `kw_to_event`, `kw_to_thought`, `kw_to_chat` @property proxies and a `retrieve_about(name, top_k, kind)` delegation to the underlying JSON store; without these, the broadcast helper's `getattr(persona.a_mem, "kw_to_event", {})` returned `{}` so dedup_key idempotency was a silent no-op (root cause of the 2-4x duplicate elimination_witnessed nodes in sim 20260512-4), and Edit D's `_partner_block` raised AttributeError caught by a broad try/except, returning empty and silently disabling partner-focused retrieval in every live sim.
   - `tests/test_batch_beta.py`: added `TestBatchGamma_HybridProxies` (5 tests) — proxy correctness for each kw index, `retrieve_about` delegation, and an end-to-end broadcast idempotency check; also added UTF-8 stdout reconfigure to avoid cp1252 crashes from emoji-laden HybridMemoryStore init prints on Windows.

- [x] **Vote tally per-voter shape — unlock B′ tally broadcast (was dict-shape no-op since Batch α)**
   - `reverie/backend_server/survival/controller.py`: added `self._pending_vote_tally: Dict[str, str]` to `__init__`; reset in `_reset_daily_flags`; populated in `_collect_and_resolve_votes` from the existing `votes: Dict[str, VoteDecision]` (`{voter: vote.vote_target}`); persisted onto `season.eliminated[-1]["vote_tally"]` in `_execute_elimination` alongside the unchanged scalar `vote_count` (back-compat for `_run_gpt_prompt_final_statement`); `_broadcast_elimination` now reads `vote_tally` (the dict) instead of `vote_count` (the int) and emits "Day N vote tally — <voter> voted <target>, …" lines with voter names added to keywords.
   - `tests/test_batch_beta.py`: added `TestPerVoterVoteTally` (5 tests) — source checks that confirm the eliminated record carries both keys, the per-voter comprehension is in place, the broadcast reads vote_tally, the daily reset clears the pending tally, and the tally line format renders correctly.

- [x] **Pre-sim cleanups — deep-tier unlock + OBSERVATION_PRIMARY unsupported-mode warning**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`: raised `medium_max` 6→8 and `long_max` 8→10 so chats can reach ≥6 exchanges and trigger Edit E's 30-step deep-tier cooldown, which was unreachable in sim 20260512-4 (max observed depth 5).
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added a startup `print` warning under `if not OBSERVATION_PRIMARY:` flagging that the legacy `_should_react` path lacks the post-2026-05 cooldown short-circuit and is unsupported; default `OBSERVATION_PRIMARY=true` path is unchanged.
   - `tests/test_batch_beta.py`: added `TestDeepTierExchangeCaps` (1 test) + `TestObservationPrimaryUnsupportedWarning` (1 test); all 27 Batch β+γ, 11 Batch α, and 7 CHAT-MEMORY-001 tests remain green.

---

## 2026-05-12 — Ivan — branch: ivan/dev

### Backend

- [x] **Fix CHAT-MEMORY-001: chat nodes silently dropped when CHAT_PRESERVES_ACTION=true (Day 0.2 conversation-observations)**
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: `_persist_chat_node_early` now guards on chat state (`chat` + `chatting_with`) rather than `act_event[1] == "chat with"`, and synthesizes the chat tuple from `chatting_with` so the preserved pre-chat act_event no longer causes the guard to fail silently.
   - `tests/test_chat_memory_persistence.py`: new file with 7 tests covering the pre-fix regression, the fixed path, backcompat, three negative-case guards, and an integration test against the real function.

- [x] **Batch α — survival pipeline: broadcast elimination/challenge events into survivor memory, filter eliminated personas from cognitive cycle, full-maze subject sweep (closes Issues 2, 3, 9)**
   - `reverie/backend_server/persona/cognitive_modules/world_events.py`: new `broadcast_event_to_personas` helper writes a described event into each witness's in-process `a_mem.seq_event` via `add_event`; idempotent on `dedup_key`.
   - `reverie/backend_server/survival/controller.py`: `on_step` stashes `_curr_sim_time`; `_broadcast_elimination` and `_resolve_challenge` now also broadcast events to survivor in-process memory alongside the existing Supabase `tag_event` write.
   - `reverie/backend_server/reverie.py`: moves `survival_controller.on_step()` to run before `persona_items_for_step` is built, adds a filter skipping newly-eliminated personas from their last cognitive cycle, and switches post-step maze cleanup to the new full-maze sweep.
   - `reverie/backend_server/maze.py`: new `remove_all_subject_events(subject)` method — full-tile sweep removing every event whose subject matches the given name.
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: `_survival_key` block demotes `alive_set` from sort tie-breaker to hard pre-sort filter; guarded by non-empty `alive_set` so cold-start free-flow is unaffected.
   - `tests/test_batch_alpha_survival_pipeline.py`: 11 tests across 4 classes covering broadcast happy path + idempotency, perceive filter behaviour, maze sweep, and e2e import smoke test.

---

## 2026-05-12 — Ivan — branch: ivan/video

### Backend

- [x] **Brand-voice backport: enforce forbidden vocab and intimate register across all 6 opener prompts**
   - `video/showrunner.py`: added module-level `OPENER_BRAND_DISCIPLINE` constant (forbidden vocab: simulate, agent, AI twin, digital twin, virtual you, imagine, alternate reality, parallel life; intimate-conspiratorial register rules) and appended it to all 6 opener system prompts; fixed "AI Doubles" → "Doubles" in cold-open constraints; added "The version of [Name] that…" signature pivot in persona narration prompt; hardcoded `end_card_block.question` and `subtitle` to bare "What if?" superseding the prior `season_title`-derived value.
   - `video/compose_trailer.py`: updated `generate_opener_end_card` docstring to reflect the bare "What if?" mapping; no rendering logic changed.

- [x] **Fix FFmpeg end-card render failure after libavcodec 62 upgrade**
   - `video/compose_trailer.py`: changed `force_original_aspect_ratio=cover` → `force_original_aspect_ratio=increase` in `generate_opener_end_card`; `cover` was never an officially documented scale-filter value and late-2025 FFmpeg builds reject it with "Undefined constant or missing '(' in 'cover'", halting the opener compose pipeline; visual output is unchanged because the subsequent `crop` step clips the overflow identically.

- [x] **Refactor opener narration to Burnett 6-beat structure with LLM cache**
   - `supabase/migrations/20260511180000_video_narration_cache.sql`: new `double.video_narration_cache` table keyed by (sim_code, scope, artifact_key, persona_id, day_number); prompt_hash + pinned columns drive invalidation; RLS enabled with no policies (service_role bypass only).
   - `supabase/db_reference.md`: added Video Trailer section documenting `video_narration_cache` for LLM-lookup tooling.
   - `video/narration_cache.py`: new `get_or_generate()` module — looks up cached LLM output, returns on hash match or pinned, otherwise calls the LLM and persists. Service-role Supabase client; smoke-tested MISS → HIT → STALE → PINNED behaviors.
   - `video/showrunner.py`: removed hardcoded `_opener_cold_open_line` + monolithic `OPENER_STAKES_SYSTEM`; added 6 new Tier-B system prompts + 6 `_generate_*` helpers that flow through `narration_cache.get_or_generate()` (cold_open, format_lock, persona_narration × N, pressure_event, vote_dread, habit_hook); cast scenes now carry a `narration_line` field; `_opener_assemble_narrator_script` rewritten to weave the 6 beats; `OPENER_NARRATION_BOUNDS` upper bumped 220 → 280.

---

## 2026-05-11 — Ivan — branch: ivan/video

### Backend

- [x] **Ship §TODO-C anthem + wire opener to use it**
   - `video/audio/normalize.sh`: new two-pass ffmpeg `loudnorm` script; supports `--target sting` (−12 LUFS / −1 dBTP) and `--target music` (−16 LUFS / −1 dBTP, default); backs up originals to `<dir>/_raw/`; output format matches input (WAV-in → WAV-out, MP3-in → MP3-out) to avoid lossy double-encode.
   - `video/showrunner.py`: opener script generator now sets `"mood": "anthem"` (was `"drama"`) so `_resolve_music()` picks `music_anthem.mp3` instead of the drama placeholder; `VALID_MOODS` deliberately unchanged so the day-overview LLM can't pick "anthem" for daily recaps.

### Assets

- [x] **§TODO-D archetype stings (4 × WAV) — normalized and shipped**
   - `video/assets/archetypes/sting_{champion,connector,observer,wildcard}.wav`: 4 sting takes accepted from Suno, normalized in place to −12 LUFS / −1 dBTP. Originals preserved in `archetypes/_raw/`. Files auto-overlay via existing `_build_sting_overlays()` compose path.

- [x] **§TODO-C anthem track — trimmed and normalized**
   - `video/audio/music_anthem.mp3`: 163.7s anthem (trimmed externally from 188s raw Suno), normalized to −16 LUFS / −5.4 dBTP, then encoded back to MP3 ~181 kbps; original WAV preserved at `video/audio/_raw/music_anthem.wav`.

---

## 2026-05-09 — Ivan — branch: ivan/video

### Backend

- [x] **Wire §TODO-D archetype-sting playback into the trailer compose path**
   - `video/compose_trailer.py`: added `NAME_CARD_OFFSET_SEC` and `STING_VOLUME` constants, extended `mix_audio()` with an optional `sting_overlays` parameter that builds a multi-input ffmpeg `filter_complex` (each sting delayed via `adelay`, amixed with `normalize=0`), added `_build_sting_overlays(script)` helper that maps each cast-intro scene to its archetype WAV in `ARCHETYPES_DIR` (missing files silently skipped), and updated both compose call sites to pass the overlays. Trailer renders fall through to the legacy mix path until at least one `sting_{archetype}.wav` asset lands.

- [x] **Make interior-prompt generator preserve hand-written notes and auto-mark DONE on regeneration**
   - `video/assets/scripts-prompts/generate_interior_prompts.py`: added `existing_interior_files()` + `parse_preserved_notes()` so each re-run scans `video/assets/village/interior/` for matching `Save as:` filenames (emits `**Status:** DONE` + heading suffix when present) and re-injects any `> ...` blockquote lines from the prior output keyed by filename. Dashboard now reports `{done} DONE / {remaining} remaining` per archetype. Avoids the wipe that happened earlier today when regeneration overwrote manual notes.
   - `video/assets/village/interior/_interior_prompts_TODO.md`: regenerated; counts now read **17 DONE / 24 remaining** out of 41 (all 18 bathrooms except `artist_int_studio1_bath.png` are on disk).

- [x] **Add room-inventory script and its output for interior image-gen prompt writing**
   - `video/assets/scripts-prompts/generate_room_inventory.py`: one-shot tool that reads `arena_maze.csv` and `game_object_maze.csv`, flood-fills object tiles into clusters, and labels each cluster with a 9-zone position and wall adjacency per arena bounding box. Now also carries `EXISTING_INTERIORS` (sector, arena → image files) and `OUTDOOR_ARENAS` (5 outdoor arenas reclassified as N/A) so each room emits a Status line and the file opens with a coverage dashboard + sector-grouped TODO list.
   - `video/assets/village/interior/_room_inventory.md`: 751-line regenerated output. 8 DONE (cafe, library, dorm common+kitchen, Dorm Rooms 1–4), 49 TODO, 6 N/A (hallway + 5 outdoor).

- [x] **Add interior-prompt generator that emits ready-to-paste Grok Imagine prompts for every TODO room**
   - `video/assets/scripts-prompts/generate_interior_prompts.py`: reads the same maze CSVs, classifies each TODO arena into an archetype (bathroom / kitchen / common room / studio living / bedroom / pub / supply store / market+pharmacy / classroom), translates clustered furniture positions into natural-language LAYOUT lines, and pairs them with a per-archetype locked STYLE block + reference stack. Bedrooms are persona-neutral by design (so the village can host different casts without re-commissioning).
   - `video/assets/village/interior/_interior_prompts_TODO.md`: 1066-line script output, 49 prompts grouped by archetype batch (18 bathrooms, 4 kitchens, 4 common rooms, 8 studio/combined living, 11 bedrooms, 1 pub, 1 supply store, 1 market+pharmacy, 1 classroom). Each prompt block carries a `Save as:` filename hint so commissioned files land at the path `EXISTING_INTERIORS` expects on the next inventory re-run.

- [x] **Add Phaser bird's-eye annotator so sectors can be identified at a glance**
   - `video/assets/scripts-prompts/label_phaser_birdeye.py`: reads `sector_maze.csv` + `arena_maze.csv`, computes each sector's and selected arena's tile-bbox center, and overlays two-tier labels on `1-village-birdeye.png` via Pillow — sectors in white-on-black, configured arenas in amber-on-navy at a smaller font. `ARENA_LABELS` list controls which sub-rooms get called out (currently the four Oak Hill Dorm rooms and the five Artists' Co-Living bedrooms). Linear tile→pixel mapping is configurable via `MAZE_X_RANGE` / `MAZE_Y_RANGE` constants for future Phaser captures with different viewport extents.
   - `video/assets/phaser/1-village-birdeye_labeled.png`: regenerable annotated copy with 19 sectors + 9 arenas labeled.

- [x] **Extend integrated kitchen+common-room convention to 4 more sectors (artist co-living, houses 4–6)**
   - `video/assets/scripts-prompts/generate_room_inventory.py`: added 8 new `EXISTING_INTERIORS` entries pointing the kitchen and common-room arenas of artist co-living + house 4 / 5 / 6 to a single `*_int_kitchen.png` per sector (the original dorm pattern, now generalized). Coverage moves from 8 DONE / 49 TODO to 16 DONE / 41 TODO; the prompts file's Kitchens and Common-rooms archetype batches are now empty.

- [x] **Add multi-image hero-pairing script and generate first cohort (Pistsov family) end-to-end**
   - `video/assets/scripts-prompts/generate_hero_pairings.py`: new script that calls xAI's multi-image-edit endpoint (`grok-2-image`, `/v1/images/edits`) with up to 3 source images (room interior + persona front_neutral + optional style frame); reads a cohort scene-config JSON and writes outputs to `video/assets/cohort/hero/{cohort}/{scene_id}.png`; supports `--scenes-config`, `--scene`, `--dry-run`, and `--skip-existing` flags.
   - `video/assets/scripts-prompts/hero_scenes_pistsov_family.json`: cohort scene config defining 4 scenes for the Pistsov family (Ivan in dorm common kitchen late-morning, Luba behind Hobbs Cafe counter mid-morning, Katya in Oak Hill Library blue armchair afternoon, Gosha at his Room 1 desk at night); identity is anchored by the character-sheet image input rather than appearance prose.
   - `video/assets/cohort/hero/pistsov_family/ivan_kitchen_late_morning.png`: generated hero still — Ivan in the dorm common kitchen.
   - `video/assets/cohort/hero/pistsov_family/luba_cafe_morning.png`: generated hero still — Luba behind the Hobbs Cafe counter.
   - `video/assets/cohort/hero/pistsov_family/katya_library_afternoon.png`: generated hero still — Katya in the Oak Hill Library armchair.
   - `video/assets/cohort/hero/pistsov_family/gosha_bedroom_night.png`: generated hero still — Gosha at his Room 1 desk at night.

## 2026-05-08 — Ivan — branch: ivan/video

- [x] **Character-sheet automation script + 95-PNG asset batch (19 personas x 5 views)**
   - `video/assets/scripts-prompts/generate_character_sheets.py`: new script that uses xAI Imagine image-edit API (`/v1/images/edits`) to generate 4 transformation views (`front_smile`, `three_quarter_neutral`, `profile_neutral`, `full_body_standing`) per persona sketch, copies the source sketch as `front_neutral.png` without an API call, reads `XAI_API_KEY` / `XAI_IMAGE_ENDPOINT` / `XAI_IMAGE_MODEL` from `.env.local`, and supports `--persona`, `--view`, `--dry-run`, `--skip-existing` flags; Windows cp1252 unicode crash fixed by replacing arrow/cross symbols with ASCII equivalents.
   - `video/assets/users/character-sheets/`: 95 PNGs commissioned (19 personas x 5 views each, including all 4 Pistsov family members); `front_smile` views for 18 personas were produced via the Grok Imagine consumer UI then relocated into per-UUID folders; the 19th was generated directly by the script.

- [x] **Sprite-walkout automation script + 19-MP4 asset batch (all personas)**
   - `video/assets/scripts-prompts/generate_sprite_walkouts.py`: new script that calls xAI's `grok-imagine-video` model (`/v1/videos/generations` async endpoint, polling `/v1/videos/{request_id}` every 5 s) to produce a 3-second image-to-video walkout per persona from their `full_body_standing.png`; per-persona action and mood are read from an embedded `PERSONA_CONFIG` dict covering all 19 doubles (4 Pistsov family + 15 soul15 cohort); supports `--persona`, `--skip-existing`, `--dry-run` flags; downloads the temporary result URL to `video/assets/users/sprite-walkouts/{uuid}.mp4`.
   - `video/assets/users/sprite-walkouts/`: 19 MP4s produced, one per persona UUID.

---


## 2026-05-07 — Ivan — branch: ivan/video

### Backend

- [x] **Re-point video asset paths to new layout (`video/assets/{phaser,users,village,cohort,archetypes}/`)**
   - `video/capture_static_assets.py`: CLI default `--output-dir` from `video/assets/opening` → `video/assets/phaser`.
   - `video/generate_trailer.py`: hardcoded `opening_assets` path in opener-mode capture call updated to `video/assets/phaser`.
   - `video/compose_trailer.py`: `assets_dir` parameter default in `compose_opener_trailer` updated; one stale path-comment in the same function fixed.

- [x] **Repoint sketch resolver to new location + accept `.jpg` (unblocks soul15 cohort trailer)**
   - `video/extract_day_log.py`: `SKETCH_DIR` from `onboarding/user_photos/double-sketches` → `video/assets/users/sketches`; `_resolve_sketch_path` now tries `.png` then `.jpg` and drops the legacy `(2)` suffix branch (clean-named files post-reorg).

- [x] **Refactor compose_opener_trailer to per-bucket path constants (Option C from doc-debt thread)**
   - `video/compose_trailer.py`: added 5 module-level constants (`PHASER_DIR`, `USERS_SPRITE_WALKOUTS_DIR`, `ARCHETYPES_DIR`, `COHORT_DIR`, `VILLAGE_DIR`); dropped `assets_dir` parameter from `compose_opener_trailer`; replaced 5 internal call sites with bucket-specific constants; commissioned sprite-walkout MP4s now read from `USERS_SPRITE_WALKOUTS_DIR/{agent_id}.mp4` (filename pattern simplified — folder name conveys the type), `.webm` fallback stays in `PHASER_DIR`.
   - `video/showrunner.py`: updated `atmospheric_clips` comment to reference `PHASER_DIR` instead of the old `assets_dir`.

- [x] **Extend action-location analyzer to cover three unvalidated issues from the v2 doc**
   - `tests/analyze_action-location.py`: added persona record-count summary (flags dropouts below 90% of max steps), a Bug C cadence-band detector (same arena, ≥30 consecutive steps with ≥4 address toggles at mean interval ≤5 steps, excluding Bug B wait-wrap hits), and an address-field divergence detector comparing `address_label` to the `@`-suffix in `description` using prefix-aware comparison to avoid false positives.

- [x] **Filter two false-positive sources found after running analyzer on 20260506-5**
   - `tests/analyze_action-location.py`: tracks sleeping steps per persona and suppresses overnight-sleep bands in the tile-flap reporter (>50% sleeping → folded into a summary count); adds stationarity filter to Bug C cadence detector (pos range ≤3 tiles required) to drop false positives where the persona was walking through arena tiles rather than toggling addresses in place.

---

## 2026-05-06 — Ivan — branch: ivan/action-location

### Backend

- [x] **Daily-plan prompt: tell the LLM where the persona LIVES (closes Apartment N leak at the source)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_daily_plan` now derives `home_label` from `persona.scratch.living_area` (formatted `<sector>: <arena>`, e.g. `Dorm for Oak Hill College: Dorm Room 3`) and appends it as INPUT 7 of the daily-plan prompt.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: added `Home: !<INPUT 7>!` line directly after "In general, …" and a new ACTIVITY RULE pinning sleep / wake-up / breakfast / evening wind-down / "in my room" activities to the persona's Home (preserves anonymized asset names like `Apartment N`, just stops the LLM from picking the wrong one as a persona's home).
   - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: same two changes applied to the non-survival template.
   - Why: replay of 20260505-3 daily-plan dumps showed the prompt listed all 19 accessible sectors but never identified which was the persona's home; LLM picked Apartment 2 / Apartment 1 / etc. as Katya's and Gosha's home, leaking "at Apartment 2" into hourly schedule entries → activity text → action_location_unified prompts. Edge cases verified (full address, sector-only, empty, None all map to a sensible label).

- [x] **Curated context: drop staff_only objects from LLM location tree for non-workers**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: `_build_filtered_location_tree` now reads `persona.scratch.work_area` and filters `staff_only` objects out of each arena's object list unless the arena address is prefixed by `work_area` (worker bypass — Luba keeps cafe workspace; Ivan/Gosha/Katya never see `behind the cafe counter`, `cooking area`, `kitchen sink`, `refrigerator`, `behind the bar counter`, `shelf`, etc.). Mirrors the validator's `staff_only` check exactly so the LLM literally cannot pick what the hard gate would reject — defense-in-depth, prevention before rescue. Verified: smoke tests pass (Ivan tree contains zero staff-only objects across all 12 registry-tagged addresses; Luba still sees cafe workspace, not pub); existing test suites green (`test_affordance_required` 5/5, `test_action_text_sanitization` 35/35, `test_movement_realism` exit 0).

- [x] **Removed affordance_repick from post-resolution validator (closes Issue 2 Gap 2 + Gap 1 residual leaks)**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Deleted the soft affordance-repick branch in `_validate_address_post_resolution`; kept the staff_only / bed_non_sleep / activity_whitelist hard gates and the `affordance_required` hard reject. Repick was rewriting safe upstream answers (e.g. `cafe customer seating`) into staff-only zones (e.g. `behind the cafe counter`) on stem-token matches like "prepare". 3000-step replay on 20260505-3 shows ~209 sim-step bypasses eliminated, 0 safety regressions, 14/155 unique guard resolves go from unsafe to safe; LLM-pick replay (151 calls) confirms zero corruption events on the LLM path. Aligns with `sot_action-location.md` §2.3/§2.4 (hard gates only; soft scoring must not override hard gates).

- [x] **Tightened V4 analyzer to only flag display-text stale apartment leaks**
 - `tests/analyze_v1_v4.py`: Removed `current_action` and `resolved_address` from V4 text scanning so structural address-tree values no longer trigger false positives.

## 2026-05-05 — Ivan — branch: ivan/wakeup-sot

### Backend

- [x] **Wake-up-hour SoT moved to schedule-derived runtime reads, with cache semantics preserved**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added `effective_wake_hour(persona)` to derive wake time from leading sleep blocks and removed `persona.scratch.wake_up_hour` scalar write so planner wake stays input-only.
   - `reverie/backend_server/reverie.py`: stall-breaker sleep-window guard now reads `effective_wake_hour(persona)` and keeps the existing minimum wake floor behavior.
   - `tests/test_effective_wake_hour.py`: added coverage for happy path, no-leading-sleep fallback, malformed/empty schedules, contiguous sleep sums, clamping, and wake-floor use in stall-breaker logic.
   - `sot/sot_prompts.md`: documented that wake-up prompt output remains planner input while runtime wake boundary is schedule-derived.
   - `sot/sot_memory.md`: documented wake-hour cache as an optimization/invalidation axis and clarified runtime reads no longer rely on scratch scalar SoT.
   - `sot/sot_realism.md`: clarified realism loop and guardrails now use schedule-derived wake boundary for sleep-window protection.
   - `sot/sot_survival.md`: clarified survival wake override constrains planning input while runtime wake-window reads come from generated schedule.

---

## 2026-05-05 — Ivan — branch: ivan/video

### Backend

- [x] **curr_time cold-start uniformity** (FE V5 support polish)
   - `api_gateway/app/services/supabase_service.py`: switch fabricated-meta fallback at line 2285 from `.isoformat()` to `strftime("%B %d, %Y, %H:%M:%S")` so all production `curr_time` emit sites share the same shape ("May 05, 2026, 12:34:56"). FE V5 normalizer parses both, but uniformity removes one shape from the FE plan's input-shape surface and simplifies future debugging. Path fires only when no `reverie/meta.json` exists yet (orphan / freshly-forked sims before first step writes meta) — no behavior change beyond the string format.

- [x] **V2 + V4 Phase A.5 — surgical follow-ups from sim 20260505-2 validation**
   - `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`: changed piano's affordance entry from `"play piano"` to `"piano"`. The two-token form caused a false token-overlap with action descriptions containing "role-play" (Katya at piano for 26 steps in 20260505-2 doing "role-play defector / cooperator"). Single-token `"piano"` keeps positive matches ("practicing piano", "play piano", "performing at the piano") while eliminating the false overlap with social-action verbs.
   - `reverie/backend_server/reverie.py`: removed the `if self.step == 0:` guard around `relabel_stale_place_text` calls at the per-step emit; also wrapped `realism_trace.act_description` with the same relabel so the trace label matches the user-visible description. Validation sim showed stale "Apartment N" wording persisting through steps 1–20 (~60 hits/persona for Gosha/Katya/Luba) — the gate was too narrow because stale text survives until the first activity transition, not just the spawn frame.
   - `tests/test_affordance_required.py`: added `test_role_play_does_not_falsely_match_play_piano` pinning the V2 fix against the actual sim-20260505-2 step-233 description.
   - `tests/test_action_text_sanitization.py`: added `test_relabel_is_step_independent` pinning the V4 helper as step-number-independent (gating decision lives at the call site, not in the helper).

- [x] **V3 + V4 Phase A — sentinel/truncation scrub at FE-bound emit boundaries, plus step-0 stale-place-name relabel**
   - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: added `sanitize_emit_text(text)` (layers on `strip_action_tags`, scrubs `<waiting> X Y` sentinels + dangling `(waiting to ...` fragments missing closing paren) and `relabel_stale_place_text(text, resolved_address, living_area)` (word-boundary regex rewrites `Apartment N` → "their dorm" when address is dorm-tree). Three module-level compiled regexes added.
   - `reverie/backend_server/reverie.py`: per-step movement emit (`description`, `intent`) now uses `sanitize_emit_text` (was bare `strip_action_tags`); `realism_trace.act_description` now wrapped with the sanitizer too (was emitting raw scratch text); `COMPLETED.json` payload `description` (~line 3482) switched to the same sanitizer for parity. At `step == 0` only, `description` and `intent` additionally pass through `relabel_stale_place_text` against the persona's resolved address + `living_area`.
   - `tests/test_action_text_sanitization.py`: 13 new cases across two new test classes — sentinel scrub, dangling-paren cleanup, closed-paren preservation regression, multi-digit `Apartment 12`, multi-occurrence rewrite, non-dorm passthrough, empty/None passthrough, living-area-alone anchor.

- [x] **V2 affordance hard gate — restricted-use objects (piano, microphone) now reject mismatched action descriptions deterministically**
   - `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`: added `affordance_required: true` to `piano` and `microphone` entries; microphone also gained `affordances: [perform, sing, speak]` so the existing token-overlap check has something to match against.
   - `reverie/backend_server/maze.py`: new `get_object_affordance_required(addr) -> bool` accessor parallel to `get_object_staff_only`.
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: in `_validate_address_post_resolution`, after the soft `affordance_repick` loop fails to find a better in-arena alternative AND the object carries the new flag, cascade out via `_remap_for_forbidden_address` (same mechanism as `staff_only` / `bed-non-sleep`); reason code `"affordance_required"`. Docstring updated to list the new code.
   - `tests/test_affordance_required.py`: 4 cases — piano + "poker face" repicks, piano + "practicing piano" stays put (token overlap), unflagged objects retain soft behavior, cascade target is reachable.

- [x] **Sleep-window protection — stop `proactive_periodic_refresh` and `FORCE_REPLAN_SCHEDULE_ADVANCE` from cycling personas out of bed (Issue 1 v2 root fix)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new `_curr_schedule_entry_is_sleep_like(persona)` helper (delegates to `is_sleep_like_action`); `proactive_periodic_refresh` now skips when the current schedule entry is sleep-like (was firing every ~20 steps regardless), and `FORCE_REPLAN_SCHEDULE_ADVANCE` no longer skips past a still-active sleep block on a forced replan. Together these kill the dorm ↔ Hobbs Cafe ping-pong reported in `20260504_action-location-observations_v2.md` Issue 1.
   - `tests/test_sleep_window_protection.py`: 8 tests pinning the predicate against the canonical `_SLEEP_TOKENS` set, an empty schedule, an out-of-range index, and missing-attribute scratch shapes.

---

## 2026-05-05

- **BE team verification recap** (their grep across `reverie/`, `api_gateway/`):
   - `curr_time` emit is uniform across the production hot path (movement JSON, STATUS.json, COMPLETED.json, fork-bootstrap meta, `_compute_step_time`) — all naive localized.
   - Three non-hot-path edge shapes confirmed safe via my normalizer's null fall-through: cold-start microsecond ISO (`api_gateway/.../supabase_service.py:2285`) → matched and canonicalized cleanly; step-0 mock time-only `09:00:00` (brand-new sims, brief window) → null fall-through, display reverts to step-derived clock; parse-failure empty string → null fall-through.
   - `action_start_time` sourced from `scratch.curr_time` at both assignment sites — same in-fiction time as `curr_time`, naive ISO format only because of `.isoformat()` vs `strftime` stringification.
   - BE offered a one-line cold-start fallback fix to emit naive localized; declined as the FE handles it gracefully and decoupling is a feature.


## 2026-05-04 — Ivan — branch: ivan/video

### Backend

- [x] **Opener trailer copy + end-card v2 layout (PRD §TODO-13)**
   - `video/showrunner.py`: replaced cold-open line template ("{N} friends. {D} days…" + fallback) with fixed "{N} Doubles. One village. One survives.", removed `season_length_days` param, bumped `OPENER_END_CARD_SEC` from 5→8, and updated `end_card_block` to carry five named keys (`title`, `subtitle`, `body_a`, `body_b`, `url`) for the v2 layout.
   - `video/compose_trailer.py`: rebuilt `generate_opener_end_card()` for the five-line v2 layout — new `body_a`/`body_b`/`url` params replace `cta`, default duration 5→8s, drawtext filters re-laid-out (title 64pt, subtitle 32pt, body lines 26pt, url 26pt gold) with centred y-offsets; caller in `compose_opener_trailer` updated to pass the new keys.

- [x] **Opener trailer how-to-watch beat — 5-beat structure landed (PRD §TODO-13)**
   - `video/showrunner.py`: added `OPENER_HOW_TO_WATCH_SEC=18` + `OPENER_HOW_TO_WATCH_LINES` 4-line tuple (per playbook §4.6); inserted `how_to_watch_block` between `stakes_montage` and `end_card` in `_generate_opener_script`; updated `cast_total_sec` floor calc to subtract the new 18s slot; `_validate_opener_script` now requires the `how_to_watch` block and includes its time_range in the total-runtime sum (4-persona target ~124s, 6-persona ~154s — still inside 95-180s window).
   - `video/compose_trailer.py`: new `compose_opener_how_to_watch()` — drawtext-stack on dark background, last line in gold (#C8A86B), font sizes 38pt body / 32pt cadence; `compose_opener_trailer` adds Stage C2 between stakes and end_card and threads `how_to_watch_path` through concat + cleanup; defensive fallback uses a 3-line subset of the recommended copy when the block is missing (legacy script.json compat).

- [x] **Opener stakes montage — Grok Imagine cinematic flyovers wired in (PRD §TODO-I, §0.1 P0)**
   - `video/showrunner.py`: replaced 5 of 6 `establish_*.png` entries in the default `_generate_opener_script` `atmospheric_clips` list with `fly-over/cinematic_flyover_{village_overhead,homes_row_approach,hobbs_cafe_interior,cafe_exterior_pan,village_dusk_wind_down}.mp4` (kept `establish_village_dawn.png` since no dawn flyover was produced; `hobbs_cafe_interior.mp4` replaces `establish_council_zone.png` because the cafe is now the social stage per playbook §3.8).
   - `video/compose_trailer.py`: `compose_opener_trailer` Stage C path resolution now distinguishes bare filenames (joined to `assets_dir = video/assets/opening`) from path-prefixed entries like `fly-over/...` (joined to `video/`), so the two-source PNG/MP4 mix works without code-side hardcoding.

---

## 2026-05-01 — Ivan — branch: ivan/video-trailer-fixes

### Backend

- [x] **PRD §4.2 opener trailer mode — cast intro + cold open + stakes montage + end card, end-to-end verified at 130s**
   - `video/capture_static_assets.py`: new module; Playwright + Phaser camera-API screenshots producing per-persona top-down home stills and 6 named establishing shots (village overhead, cafe, homes row, council, dawn, dusk); idempotent, CLI-runnable.
   - `video/extract_day_log.py`: added `extract_opener_context()` — reads Day-0 scratch only, runs `persona_ranker` for top-N selection, resolves spawn xy from step-0 position rows, and bundles per-persona scratch + sketch_path + home_xy.
   - `video/showrunner.py`: added 4 Tier-B LLM helpers (`_generate_one_line_bio`, `_classify_archetype`, `_generate_trait_moment`, `_generate_stakes_montage_narration`) and `_generate_opener_script` + `_validate_opener_script`; cold-open line is templated, not LLM-generated.
   - `video/record_scenes.py`: added `record_sprite_walkout` + `record_sprite_walkouts`; per-persona 2.5s WebM/vp9 captures via Playwright gated by `__headlessReady && __cameraSettled` and protected by `_assert_first_frame_not_white`; composer prefers `.mp4` then falls back to `.webm`.
   - `video/compose_trailer.py`: added 5 opener-mode composers and orchestrator — `compose_cast_intro` (15s two-subclip crossfade per persona), `compose_opener_cold_open` (slow zoom on establishing shot), `compose_opener_stakes_montage` (6-8 ken-burns subclips), `generate_opener_end_card` (3-line end card), `compose_opener_trailer` (assembly); also fixed `_run_ffmpeg` stderr decoding (`errors='replace'`) and apostrophe escaping in FFmpeg `text=` values.
   - `video/validate_trailer.py`: added opener bounds to mode-aware dicts (95-180s duration, 60-220 word narration); existing modes unchanged.
   - `video/generate_trailer.py`: added `--mode opener`, `--cohort-name`, `--season-title`, `--top` (1-6) CLI args; Stage 1 dispatches to `extract_opener_context`; Stage 4 captures static assets + sprite walkouts (no per-step recording); Stage 5 calls `compose_opener_trailer`.

- [x] **PRD §4.3 day-overview trailer mode — multi-protagonist, 165s, previously-on + council-vote + cliffhanger scenes**
   - `video/persona_ranker.py`: new module; scores personas per day on top-5 poignancy + chats + locations + elimination/relationship bonuses, returning top 1-3 with a quiet-day fallback.
   - `video/extract_day_log.py`: added `extract_day_overview()`, `_build_prior_day_summary()`, `_build_trigger_events()`; trigger-event step anchored on the eliminated persona's last position row (not `day_end_step`) so the spine LLM can't pick `focal_steps` outside the persona's data range.
   - `video/showrunner.py`: added two-stage LLM `_generate_day_overview_script` (spine call on `VIDEO_SPINE_TIER` picks arc + scene assignments; per-scene Tier C calls fill scenes); validator enforces 1-3 protagonists, required previously_on/council_vote/cliffhanger scenes, per-scene `key_steps` coverage, and 50-90 words narration per scene; renamed existing day-in-life entry-point to `_generate_day_in_life_script`.
   - `video/compose_trailer.py`: parameterized trailer duration (60s day_in_life / 165s day_overview); added `generate_previously_on_card()` (WebM/vp9 — switched from libx264/MP4 to fix xfade timebase mismatch) and `apply_council_grade()` (red push + brightness dip on vote/elimination scenes).
   - `video/validate_trailer.py`: mode-aware duration bounds (60s±2 vs 165s±15) and narration word bounds (100-200 vs 300-470); mode detected from `script.json`'s `mode` field.
   - `video/generate_trailer.py`: added `--mode {day_in_life,day_overview}` CLI arg and `--top` for ensemble size; orchestrator dispatches to `extract_day_overview()` or `extract_day_log()` based on mode; `persona_name` is now optional (ignored for day_overview).

---

## 2026-04-30 — Ivan — branch: ivan/video

### Backend

- [x] **Survival rewrites lifestyle + daily_plan_req + invalidates last_planned_date — kills baseline-vs-survival schedule ping-pong (Issue 1 RCA fix)**
   - `reverie/backend_server/survival/controller.py`: added `build_survival_daily_plan_req` + `_apply_survival_lifestyle` + `_restore_baseline_lifestyles`; on_step captures each persona's baseline `lifestyle` AND `daily_plan_req` once, writes survival-themed text into both fields once per day (both flow into the daily-plan + hourly-schedule LLM prompts via `get_str_iss()` and `get_str_lifestyle()`), clears `daily_req` + `f_daily_schedule[_hourly_org]`, and **invalidates `last_planned_date`** so `schedule_validator.is_new_day()` returns "First day" on the next persona.move() — without this, same-day forks short-circuit `_long_term_planning` entirely and the baseline schedule survives intact (sims 20260430-4 and -5 both confirmed). Baselines restored on game-over.
   - `tests/test_survival_daily_plan_rewrite.py`: 11 unit tests pinning text composition, baseline capture, day-boundary trigger, schedule invalidation, last_planned_date invalidation, and restore-on-game-over for both fields (alive + eliminated players).

---

## 2026-04-30 — Ivan — branch: ivan/video-trailer-fixes

### Backend

- [x] **Paginate `_fetch_positions` to bypass PostgREST 1000-row cap in day-log extraction**
   - `video/extract_day_log.py`: replaced single-shot `get_all_step_positions` RPC call with a cursor-based pagination loop (advance cursor to max step in chunk, dedupe boundary rows by `(step, persona_name)`, exit on empty page or chunk < 1000), fixing silent truncation that capped the timeline at step ~245 for 7,982-row sims.

- [x] **Add `protagonist_step_ranges` coverage validator to catch blank-video scenes before render**
   - `video/extract_day_log.py`: emits a `protagonist_step_ranges` field (compact `[[start, end]]` consecutive ranges) derived from the protagonist's actual position rows in the day's range.
   - `video/showrunner.py`: `validate_script` now rejects any scene whose `key_steps` have <80% coverage in `protagonist_step_ranges`, triggering the existing 3-attempt retry loop with the offending scene echoed back; check is skipped when the field is absent for backward compatibility.

- [x] **Hoist wake_up_hour persistence above should_skip_daily_planning early-return (Issue 1 root fix)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: moved `generate_wake_up_hour` + `apply_survival_wake_override` + `persona.scratch.wake_up_hour` assignment above the `should_skip_daily_planning` short-circuit so the field is always written on daily-planning entry, even for forked sims that load a valid baseline schedule.

- [x] **Stall-breaker wake-floor fix — use persona's actual wake hour instead of hardcoded 7**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: persists the post-clamp `wake_up_hour` onto `persona.scratch.wake_up_hour` in `_long_term_planning` so the stall-breaker can read the persona's real planned wake time.
   - `reverie/backend_server/reverie.py`: replaces the hardcoded `hour < 7` night-window check with `hour < max(7, persona.scratch.wake_up_hour)` so sleeping personas are not force-advanced before their actual wake time.

- [x] **Anchor-aware inheritance fence — fix action ↔ sector mismatch (Issue 2)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new `_anchor_compatible_with_parent_arena` helper (~14 LOC) checks whether a sub-task's structured anchor object exists in the parent arena before the inheritance fence pins the address; adds `parent_location_anchor_mismatch_count` observability counter; six wiring lines in `_contextual_rows_to_contract_pairs` invoke the check and override `inherits_parent_location=false` on mismatch (travel sub-tasks exempt).
   - `tests/test_anchor_inheritance_fence.py`: new file — 15 tests covering mismatch-detach (5), compatible-inherit (4), and conservative-default (6) cases; all 15 pass alongside 15 existing regression tests.

- [x] **Fix sleep ↔ morning-routine ping-pong for late-rising survival personas (Issue 1)**
   - `reverie/backend_server/survival/controller.py`: writes `challenge_deadline_hour` (float) into `persona.scratch.survival` each step so the plan module can read the active deadline.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new `apply_survival_wake_override(persona, wake_up_hour)` helper (constant `SURVIVAL_WAKE_BUFFER_HOURS = 2`) caps wake-up at `int(deadline) - 2` when survival mode is on; called once after `generate_wake_up_hour` in `_long_term_planning`.
   - `tests/test_survival_wake_override.py`: new file — 9 tests pinning the clamp logic and the controller deadline-field write; all 9 pass.

- [x] **Mojibake bulk cleanup in plan.py (issue C — corrupted-UTF8 emoji sequences)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: replaced 31 corrupted-UTF8 sequences with correct Unicode emoji across 12 patterns (e.g. `ΓÜá∩╕Å`→`⚠️` ×12, `Γ¥î`→`❌` ×2, `Γ£à`→`✅` ×3, `≡ƒÿÉ`→`😐` ×4, and 8 others); the four `return "😐"` fallbacks in `generate_action_pronunciatio` are FE-bound and now render correctly as the persona's emoji bubble on LLM failure.

- [x] **Audit remaining description-output sites in reverie.py and sanitise**
   - `reverie/backend_server/reverie.py` (line ~3440): sanitises `persona.scratch.act_description` via `strip_action_tags` before writing `COMPLETED.json` so the FE lifecycle-marker JSON is clean on sim completion.
   - `reverie/backend_server/reverie.py` (line ~9043): defensively sanitises `act_desc` on the chat-scoring path when it is reused as the chat-event description.

- [x] **Better fallback for missing `subtitle_card` in YouTube scene labels**
   - `video/generate_description.py`: added `_label_from_narrator(scene)` helper that cuts the first narrator line at the first sentence-end (`.`/`:`/`;`), truncates at a word boundary to 40 chars, then strips trailing punctuation and dangling function-words; `_scene_label` fallback chain is now `subtitle_card → narrator-derived → titlecased label`.
   - `tests/test_generate_description.py`: new file — 11 unit tests covering the fallback chain, sentence-end cuts, word-boundary truncation, and function-word stripping; all 11 pass.

- [x] **Eliminate garbled action text leaking into FE movement JSONs (issue 3)**
   - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: generalised `strip_action_tags` to remove `[...]` directives anywhere in the string (was trailing-only) and collapse resulting whitespace runs; added `extract_wait_target_phrase` helper that produces a clean target phrase from `act_description` — strips directives, prefers parenthesised content, and prevents "waiting to start" double-prepend.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: rewrote `_wait_react` to use `extract_wait_target_phrase` (replacing the `split("(")[-1][:-1]` that silently chopped characters and could duplicate the prefix); replaced mojibake `"Γî¢"` pronunciatio with `"⌛"`.
   - `reverie/backend_server/reverie.py`: added try/except dual-import of `strip_action_tags`; applied it to `description` and `intent` at `movement_data` construction so FE-bound fields are sanitised while `scratch.act_description` retains directives for downstream parsers.
   - `tests/test_action_text_sanitization.py`: new test file — 11 unit tests covering mid-string directive stripping, whitespace collapse, no-paren amputation regression, and prefix double-prepend regression; all 11 pass.

- [x] **TODO-2e: add `shareable_moment` field and day-framing fix to trailer script generation (Step 2)**
   - `video/showrunner.py`: added required `shareable_moment` top-level field to schema and `REQUIRED_TOP_KEYS`; added HARD CONSTRAINT in `SYSTEM_PROMPT` directing the LLM to land the shareable beat in scene 1 or the final scene narration; added validator in `validate_script` that rejects empty values and requires ≥50% of the field's content words (≥5 chars, stopwords filtered) to substring-match scene 1 or final-scene `narrator_lines`, triggering the existing 3-attempt retry-with-feedback loop on failure.
   - `video/showrunner.py` (`_build_identity_block`): added explicit DAY FRAMING line to the IDENTITY block stating the calendar day for the title and narration; when `today_elimination` exists, clarifies that the eliminated persona is still alive during the trailer's events and that the elimination happens at the end of the day, preventing the LLM from inferring an incorrect day from the `eliminated[]` list.
   - `video/extract_day_log.py`: when a snapshot's `day_in_season` disagrees with the trailer's `day_log.day` (post-vote arithmetic boundary mismatch), aligns `survival_context.day_in_season` to `day_log.day` and stashes the original under `snapshot_day_in_season` for diagnostics.

- [x] **Replace arithmetic day-boundary computation with real game-clock midnight crossings in day-log extraction**
   - `video/extract_day_log.py`: `_compute_day_range` now derives boundaries from actual game-clock midnight crossings instead of step-count arithmetic; added `_derive_sim_start_time` helper that recovers the game-clock start time by inverting `curr_time = start_time + step × sec_per_step`; when stored `[day_start_step, day_end_step]` diverges from the recomputed range the extractor logs a warning and surfaces `day_snapshot.status = "boundary_mismatch_recomputed"` while preserving the snapshot's `memory_cutoff_time` for memory filtering; requesting `--day N` with no steps in range now raises a clear `ValueError` instead of silently returning the full sim.

- [x] **Replace arithmetic midnight trigger with real game-clock midnight check in snapshot writer**
   - `reverie/backend_server/reverie.py`: `_maybe_save_persona_day_snapshots` now fires when `prev_step_end_time.date() != curr_time.date()` instead of `next_step % steps_per_day == 0`; recomputes `day` (1-indexed calendar day from sim start) and `day_start_step` from real game-clock dates using `math.ceil((closing_midnight - start_time).total_seconds() / sec_per_step)`; sims starting at exactly midnight are unchanged.

- [x] **Season-state plumbing for per-day elimination data in day-log extraction (Step 0 of scenario-quality batch)**
   - `video/extract_day_log.py`: new `_fetch_season_state(sb, sim_code)` helper calls the `load_survival_season_state` RPC and returns the dict (or None on failure). New `_filter_eliminated_through_day(eliminated_rows, trailer_day)` keeps only entries with `day <= trailer_day` so a Day-N trailer sees every elimination through Day N but never future ones. `extract_day_log()` now fetches season state once after survival_context is built, promotes `sim_mode` to "survival" when a season-state row exists (fixes a real bug: an eliminated protagonist's scratch has `survival` cleared by `_clear_survival_mode`, causing `_detect_sim_mode` to return "standard" and bypass the entire survival pipeline on the most dramatic trailer day), attaches `survival_context.season_eliminated[]` (list of {name, day, vote_count, final_statement} dicts filtered to trailer day), and attaches `survival_context.today_elimination` (the entry where day == trailer_day, or None) so the showrunner has direct access to the farewell quote without re-filtering.

- [x] **Inject protagonist identity + top-poignancy into narration prompt and validator (Step 1, TODO-2d)**
   - `video/showrunner.py`: new `_build_identity_block(day_log)` helper renders a `PROTAGONIST IDENTITY` block from the protagonist's name, personality summary, daily plan (coerced from list or string), and the `max_poignancy_event.content` field; returns the block text and a deduped list of content tokens (≥5 chars, stopwords filtered) for the validator. `USER_PROMPT_TEMPLATE` gains a `{identity_block}` slot prepended before the day-log JSON so the LLM sees persona grounding first. `SYSTEM_PROMPT` adds two hard constraints: at least one narrator line must reference a concrete identity detail (trait, plan element, or poignant-moment phrase), and the most poignant moment must surface in narration. `validate_script` accepts a new `identity_tokens` param and rejects scripts where no token substring-matches the cleaned narration, triggering the existing 3-attempt retry loop; `generate_script` builds tokens once via `_build_identity_block` and threads them through.

- [x] **Survival prominence + farewell quoting — vote_outcome_line field and eliminated-protagonist verbatim check (Step 3, PRD §3 TODO-2c)**
   - `video/showrunner.py`: added required `vote_outcome_line` field to `USER_PROMPT_TEMPLATE` schema (survival-only: one sentence naming who was voted out and the vote count; null on non-vote days); expanded `SURVIVAL_ADDENDUM` with three new hard constraints (vote_outcome_line must surface in final-scene narration, eliminated protagonist's `final_statement` must be quoted close-to-verbatim in closing narrator_lines OR end_card.subtitle, vote-day default top-importance moment is the elimination event); extended `validate_script` with two new params (`today_elimination`, `protagonist_name`) and two new checks (vote_outcome_line non-empty and contains the eliminated persona's name; ≥25% of the final_statement's content words ≥4 chars appear in closing narration or end_card.subtitle combined); relaxed `shareable_moment` placement threshold from 50% (`max(2, len/2)`) to ~33% (`max(1, len//3)`) to prevent retry exhaustion on compressed farewell paraphrases; both params plumbed from `generate_script` via `day_log.survival_context.today_elimination` and `day_log.protagonist.name`.

- [x] **Quality-gate automation — post-render validation script and pipeline integration (Step 4, PRD §3 TODO-5)**
   - `video/validate_trailer.py`: new standalone validator that runs three objective checks on a trailer directory (16:9 MP4 exists + 1920x1080 + 58-62s; 9:16 MP4 exists + 1080x1920 + 58-62s; narration word count 100-200 after stripping `[PAUSE Ns]`/`[SCENE N]` markers from `script.json.narrator_script`); writes `output/validation_report.json` with top-level `passed`, `summary`, and full `checks` array; CLI exits 0 on PASS, 1 on FAIL; uses `[PASS]`/`[FAIL]` ASCII markers to avoid cp1252 emoji crash on Windows console.
   - `video/validate_trailer.py` (`_ensure_ffprobe_available`): lazy, idempotent `static-ffmpeg` path-injection helper — calls `static_ffmpeg.add_paths()` only when `shutil.which("ffprobe")` returns None, degrades gracefully to "ffprobe could not read file" on missing package rather than crashing.
   - `video/generate_trailer.py`: wired validation in as Stage 7 (after Nicolas's Stage 6 YouTube description) in best-effort mode — failures are logged and the pipeline continues so a bad render never blocks artifact delivery; adds `validation_report` path to the returned artifacts dict.
   - `requirements.txt`: added `static-ffmpeg>=3,<4` so a fresh venv has working `ffprobe` without a system install.

- [x] **Simplify pass — hoist shared constants and helpers to eliminate silent-drift risk (Step 4 cleanup)**
   - `video/showrunner.py`: extracted module-level `NARRATION_WORD_BOUNDS = (100, 200)` constant and public `strip_narration_markers(narrator_script: str) -> str` helper (wraps `re.sub(r"\[.*?\]", "", ...)`) so the bound values and marker-stripping regex are defined in one place; replaced their inline counterparts in `validate_script`.
   - `video/validate_trailer.py`: removed local `NARRATION_WORD_BOUNDS` definition and inline `re.sub` marker-stripping; imports both from `video.showrunner` via the project's try/except dual-import pattern; removed now-unused `re` import; moved `DURATION_BOUNDS_SEC` and `EXPECTED_DIMENSIONS` constants to the top of the file after the logger per Python convention; added note to `_ensure_ffprobe_available` docstring that its PATH mutation also benefits `compose_trailer`'s later ffmpeg call in the same process.

- [x] **Align Step-7 validator and SOT to actual 720p master output (contract-alignment, first end-to-end run)**
   - `video/validate_trailer.py`: changed `EXPECTED_DIMENSIONS["trailer_16x9.mp4"]` from `(1920, 1080)` to `(1280, 720)` to match the output `compose_trailer.py` has been producing; added inline comment explaining the 9:16's upscale-from-405×720 path and a forward pointer that true-1080p compose should bump both entries back and update sot_video.md §4 in the same change.
   - `D:\Coding\double-docs\sot\sot_video.md`: updated §4 master-resolution line from `1920×1080` to `1280×720, H.264`, added explicit note that the 9:16 derives from a 405×720 strip of the master then upscales to 1080×1920, and named `validate_trailer.py` as the current contract-enforcement point; SOT updated alongside the validator so contract and code stay in sync.

## 2026-04-30 — Nicolas — branch: nicolas/trailer-mvp

### Backend

- [x] **Add YouTube upload helper (Task 4 / P0 #4)**
   - `video/youtube_upload_helper.py`: new manual-flow CLI — reads `<trailer_dir>/output/youtube_description.txt`, copies it to clipboard (pyperclip → pbcopy fallback), opens `https://youtube.com/@doubland-ai/upload` via `webbrowser`, prints the trailer file paths (16:9 + 9:16), the title (from `script.json.title`, falling back to first line of `summary`), and the tag-convention template. Exit 0 on success, 1 on missing `youtube_description.txt` or `script.json`. No YouTube Data API integration — manual upload by design per MVP gate brief §4.4.

### Validation

- [x] **Manual validation gates 1–6 passed via Playwright (`local_docs/play_mode_gates.py`)**
   - All 7 gate variants render correctly: happy path, minimal, focus coords, three error variants, mobile portrait. Error state surfaces the `/waitlist` CTA with no JS pageerrors. Camera APIs (`__setCameraZoom`, `__followPersona`) are exposed when params are valid. Local CORS blocks live API calls (FE points at `api.ondouble.com:8001` while running on `localhost:3001`), so step advance + persona follow can only be visually validated on a deployed origin — admin viewer has the same limitation under the same env. Screenshots in `local_docs/play_mode_gate_artifacts/`.

---

## 2026-04-29 — Nicolas — branch: nicolas/trailer-mvp

### Backend

- [x] **Add YouTube description generator (Task 2 / P0 #3)**
   - `video/generate_description.py`: new module + CLI that reads a trailer's `script.json` and emits `output/youtube_description.txt` (paste-ready markdown with HTML traceability comment, title, logline, four `M:SS — label` entries each followed by an indented Play-mode deep link, `---` separator, and Founding Host waitlist CTA). URL pattern is `{BASE_URL}/sim/{sim_code}/play?t=&double=&zoom=&focus=&speed=` per the MVP gate brief §4 item 1; optional params (`zoom=1.0`, `speed=1`, missing `pan_to`) are dropped instead of emitted empty, and `focus_persona` is `urllib.parse.quote`-encoded so `Ivan Pistsov` → `Ivan%20Pistsov` (not `+`). Base URL precedence is `--base-url` > `$DOUBLE_PUBLIC_BASE_URL` > `DEFAULT_BASE_URL` (`https://doubland.ai`); `LOCAL_BASE_URL` constant (`http://localhost:3001`) is exposed for dev. Defensive: scenes lacking `key_steps` fall back to `step_range[0]`; missing title/logline get safe fallbacks; malformed `script.json` raises a clear exception.

- [x] **Wire generator as Step 6 of the trailer pipeline**
   - `video/generate_trailer.py`: dual-import block grew a `generate_youtube_description` import; new Step 6 block after compose follows the existing reuse-or-regenerate idempotency pattern (skip when `output/youtube_description.txt` exists and `--force` not passed). Step 6 is best-effort — a failure logs and continues so the trailer MP4 stays the load-bearing artifact, mirroring the brief's instruction that the description can always be regenerated standalone via `python -m video.generate_description`. Final-summary artifact dict gains a `youtube_description` entry with path + size.

---

## 2026-04-29 — Nicolas — branch: nicolas/task1-whitescreen-fix

### Backend

- [x] **Fix wrong-view head at scene start in trailer recording (Bug A, fix α)**
   - `video/record_scenes.py`: `t_payload_start` is now captured AFTER the first key step's `__movementsComplete === true` resolves instead of before the playback loop. In `?recording=true` mode persona sprites only spawn on the first `__executeMovementsForStep`, so the previous capture point landed inside the wrong-view window where the camera was at the default centre with no protagonist; trimming relative to that timestamp left 0.4–1.0 s of wrong-view content as the head of every clip. Validated against `local_docs/transition_artefact_check.py`: `WRONG_VIEW_HEAD` frame count went from 2 → 0 across boundaries 14.0/31.7/49.4, total `CLEAN` frames 150 → 152.

---

## 2026-04-29 — Ivan — branch: ivan/survival

### Backend

- [x] **Fix `_extract_agent_id` per-persona scoping (Stage 3 retrieval P0)**
   - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: dropped the `persona.agent_id` early-return that the 20260428-3 Supabase audit showed was producing a single shared agent UUID across every persona (50/50 survival rows landed under one `user_id`, breaking persona-scoped retrieval). `_extract_agent_id` now resolves every call via `get_agent_id_by_name` with a process-wide cache keyed by persona name; INFO-level logging on first resolution per name surfaces in stdout so the next sim shows whether distinct personas resolve to distinct UUIDs.
   - `tests/test_survival_stage4_5.py`: 3 new regression tests use TWO distinct persona stubs and assert distinct UUIDs (the original Phase 2 tests passed with `MagicMock` because it auto-generates the same return value for every call — a blind spot that masked this bug at unit-test time).

- [x] **Fix Stage 4 alliance trigger over-firing (P1)**
   - `reverie/backend_server/survival/controller.py`: `record_alliance_from_chat` now short-circuits BEFORE the summarize LLM call when both sides already record an alliance for the current day. The 20260428-3 corpus had ~40 `alliance_formed` rows for ~4 unique mutual pairs because the trigger fired every time those personas conversed; same-day duplicate guard collapses that to 1 write per pair per day.
   - `tests/test_survival_stage4_5.py`: 2 new regression tests cover the same-day no-op and the next-day re-fire.

### Onboarding

- [x] **Kind cartoon bust avatars from UUID-named photos (double.personas ids)**
   - `onboarding/user_photos/scrips/generate_double_avatars.py`: Pillow pipeline (smooth, posterize, gentle color/contrast) writes recognizable cartoon-style PNGs; default paths `../photos` → `../double-pics` using `personas_base_family_sim_full.json`.
   - `onboarding/user_photos/double-pics/`: four `{persona_uuid}.png` avatars generated (720px wide).

## 2026-04-29 — Nicolas — branch: nicolas/task1-whitescreen-fix

### Backend

- [x] **Fix white-screen at scene start in trailer recording (Task 1)**
   - `video/record_scenes.py`: gate now waits for `__headlessReady && __cameraSettled` before timing the payload window; captures `t_payload_start` as wall-clock offset from `new_context`; replaces `ffmpeg -t {scene_duration}` with `ffmpeg -ss {head_offset} -t {scene_duration}` so the boot/loading prefix is trimmed instead of preserved (former bug: `-t` kept the first N seconds and discarded actual playback when `Z + 1 > scene_duration`, producing the 47 KB `scene_4_close.webm`); drops the redundant 1 s `wait_for_timeout` band-aid; new `_assert_first_frame_not_white` helper extracts the first frame via ffmpeg and fails if mean RGB ≥ 240 to catch any regression in CI.
   - `video/_inspect_dom.py`, `video/_test_hide.py`: deleted — pre-`?recording=true` ad-hoc dev scripts (SwiftShader override + manual DOM-strip) with no callers in the live pipeline.

## 2026-04-28 — Ivan — branch: ivan/survival

### Backend

- [x] **Stage 4 + Stage 5 — conversation/reflect survival variants, alliance trigger, post-game archive**
   - `reverie/backend_server/persona/prompt_template/loader.py`: `resolve_template` now accepts an optional `secondary_persona`; chat-time selection swaps in the survival variant only when BOTH speakers are flagged.
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_conversation_batch_v1.txt`, `survival_summarize_conversation_v1.txt`, `survival_generate_focal_pt_v1.txt`: three new variants — chat with Identity Overlay + survival framing rules; structured post-chat summarize emitting JSON with `alliance_committed`; reflect focal-point biased toward survival framing.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_generate_conversation_batch` and `run_gpt_prompt_focal_pt` route through `resolve_template`; new `run_gpt_prompt_survival_summarize_conversation` (Tier A) parses `{"summary","alliance_committed"}` and returns `(summary_str, alliance_bool)`.
   - `reverie/backend_server/persona/prompt_template/model_router.py`: registers the new survival summarize call in `TIER_A_TASKS`.
   - `reverie/backend_server/survival/memory.py`: adds `"alliance_formed"` to `VALID_KINDS` so `tag_event(kind="alliance_formed")` is accepted.
   - `reverie/backend_server/survival/controller.py`: new `record_alliance_from_chat(persona_a, persona_b, chat_history)` — runs the survival summarize call, fires `tag_event` for both speakers and updates `alliance_commitments` when committed; new `_clear_survival_mode(persona, archive_state=True)` helper replaces the two inline clearings in `_execute_elimination` and `_nightly_recalibration` (game-over branch).
   - `reverie/backend_server/survival/state.py`: `SurvivalState` carries `archived` / `archived_at` (init/to_dict/from_dict round-trip).
   - `reverie/backend_server/reverie.py`: post-`start_conversation` hook calls `survival_controller.record_alliance_from_chat`; non-survival pairs short-circuit before any LLM call.
   - `tests/test_survival_stage4_5.py`: 14 new tests — loader dual-persona dispatch (4), alliance trigger end-to-end with mocked summarize (3 + VALID_KINDS check), state archive round-trip (2), `_clear_survival_mode` flip+archive+idempotency (3).

- [x] **P0 end-of-day persona snapshots for video trailer generation**
   - `supabase/migrations/20260428125500_persona_day_snapshots.sql`: new `persona_day_snapshots` table with `save_persona_day_snapshot` / `load_persona_day_snapshot` RPCs storing per-day scratch and Survival context keyed by sim, persona, and day number.
   - `reverie/backend_server/reverie.py`: `_maybe_save_persona_day_snapshots` fires at every day boundary to persist each persona's exact scratch state and Survival season context before the next day's planning can overwrite them.
   - `video/extract_day_log.py`: reads the day snapshot to source scratch/survival_context and `memory_cutoff_time`, filters all memory fetches to that cutoff so day-specific trailers don't bleed in future memories; degrades gracefully to latest scratch when no snapshot exists.
   - `video/showrunner.py`: injects `valid_step_start`/`valid_step_end` from `day_step_range` into the LLM prompt and passes the range to `validate_script` so the LLM cannot select steps outside the requested day.
   - `supabase/db_reference.md`: documents the snapshot table and save/load RPCs so future schema lookups include the new trailer data contract.

- [x] **Fix 2 patch: sim_id resolution now hits the real RPC (not a phantom DoubleMemoryClient method)**
   - `reverie/backend_server/survival/memory.py`: `_resolve_simulation_id` was calling `db_client._get_simulation_id(sim_code)`, but that method exists on `SpatialCoordClient`, not `DoubleMemoryClient`. The AttributeError was swallowed by the helper's try/except, the failure sentinel kicked in, and every survival row landed with `simulation_id=NULL` — verified on `20260428-1` (12 rows, every one NULL). Replaced with a direct `client.supabase.rpc("get_simulation_id_by_name", {"p_name": sim_code}).execute()` call, mirroring the working `_extract_agent_id` pattern.
   - `tests/test_survival_stage3_phase2_tag_event.py`: updated `_enabled_client()` to mock the real RPC path; added `test_tag_event_calls_real_rpc_method_not_phantom_attribute` regression that simulates a client with no `_get_simulation_id` attribute and asserts simulation_id is still bound — would have caught the original bug at unit-test time.

- [x] **Analyzer fix: gathering_compliance derived from controller's authoritative absent list**
   - `tests/analyze_sim_survival.py`: new `_load_phase_trigger_absent_map()` reads `survival_phase_trigger.ndjson` and returns `{(day, phase): set(absent)}`; `aggregate_survival_days` accepts an optional `sim_name` and `_gathering_pct` prefers the controller's authoritative absent list (`absent=[]` ⇒ 100%) over the legacy substring heuristic that undercounted (reported 25%/33%/null on `20260427-1-stage3`'s voting days). Heuristic kept as fallback for sims without the NDJSON.

- [x] **Stage 3 Fix 1+2 + defensive fix to store_memory_with_pgvector for the same UPSERT-collision bug class**
   - `reverie/backend_server/survival/memory.py`: stamp every survival memory with a unique `node_id` (`survival_<kind>_<uuid12>`) so writes stop UPSERT-collapsing onto a single shared row per persona via the `(agent_id, node_id, simulation_id)` unique index; resolve sim_code→simulation_id once via a module-level cache instead of per-call (each tag_event creates a fresh client with empty per-instance cache, so a single transient failure used to permanently poison rows to NULL since the ON CONFLICT DO UPDATE clause doesn't refresh simulation_id); failures now log at WARNING and are remembered to suppress repeats.
   - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: defensive — `store_memory_with_pgvector` now also stamps a unique `node_id`. Currently dead code at runtime (live writes route through HybridMemoryStore which generates its own ids), but any future direct caller would have hit the same UPSERT-collision bug `tag_event` just hit.
   - `tests/test_survival_stage3_phase2_tag_event.py`: 3 new regression tests covering unique node_ids across calls, sim_id cache hit semantics (1 RPC for 4 writes), and failure-sentinel suppression.

## 2026-04-27 — Ivan — branch: ivan/survival

### Backend

- [x] **Stage 3 Phases 1–4: survival memories, pgvector vote retrieval, percept tie-break, 37 new unit tests**
   - `reverie/backend_server/survival/memory.py`: new module — `tag_event()` writes survival memories to Supabase via `dbl_store_memory_dev` with canonical `keywords=["survival", kind]`; `build_retrieval_payload()` projects pgvector results into the compact shape the cognitive_capture hook records.
   - `reverie/backend_server/survival/__init__.py`: re-exports `tag_event`, `build_retrieval_payload`, and `VALID_KINDS` for the rest of the package.
   - `reverie/backend_server/survival/controller.py`: replaced `seq_event[-10:]` slop in `_collect_vote_decisions` with pgvector retrieval over three vote-relevant focal points (deduped, capped at 12); added `tag_event` calls in `_apply_vote_consequences` (vote_cast/vote_received), `_resolve_challenge` (challenge_participated), and `_broadcast_elimination` (elimination_witnessed, poignancy=8); `on_step` now writes `alive_players` and `gathering_arena` into `scratch.survival` each step so perceive can read them.
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: survival-mode-only tie-break in the percept sort — alive-player subjects and gathering-arena tiles rank ahead of equal-distance neutrals; non-survival runs are byte-identical.
   - `tests/test_survival_stage3_phase2_tag_event.py`: 12 tests covering tag_event happy paths per kind, poignancy override, unknown-kind guard, write-disabled guard, missing-client guard, exception swallowing, and build_retrieval_payload projection.
   - `tests/test_survival_stage3_phase2_5_retrieval.py`: 9 tests covering retrieval aggregation/dedup/capping/exception handling and prompt-formatter truncation/empty/blank-skip behaviour.
   - `tests/test_survival_stage3_phase3_triggers.py`: 5 tests covering vote_received+vote_cast emission, challenge_participated with correct outcome labels, elimination_witnessed at poignancy=8, and graceful skips on missing personas.
   - `tests/test_survival_stage3_phase4_perceive.py`: 4 tests covering non-survival distance-only baseline, alive-player tie-break, gathering-arena tie-break, and on_step scratch refresh.

## 2026-04-27 — Ivan — branch: ivan/survival

### Backend

- [x] **Stage 3 Phase 0: thread-local retrieval-set instrumentation so LLM dumps can carry the rendered retrieval set without behaviour change**
   - `reverie/backend_server/persona/cognitive_modules/cognitive_capture.py`: added `set_retrieval_payload()` and `consume_retrieval_payload()` thread-local accessors; `set_context()` and `clear_context()` now also reset the retrieval slot.
   - `reverie/backend_server/persona/prompt_template/model_router.py`: `_store_llm_capture` now consumes any staged retrieval payload and attaches it as a `retrieved` field on the captured record when `LLM_CAPTURE_ENABLED=true`.
   - `reverie/backend_server/survival/controller.py`: `_run_survival_llm_call` accepts a new `retrieval=` kwarg and stages it into thread-local storage before invoking the inner function.
   - `tests/test_survival_stage3_phase0.py`: 7 unit tests covering round-trip, single-shot consume, `clear_context` reset, `set_context` reset, and the controller wrapper passthrough.

---

## 2026-04-25 — Ivan — branch: ivan/survival

### Backend

- [x] **Stage 2b/2c: persist phase-trigger and survival-LLM observability so acceptance is measurable without stdout capture; route survival LLM calls into per-step dumps**
   - `reverie/backend_server/survival/controller.py`: added `_append_jsonl` sink writing to `<sim_folder>/logs/survival_phase_trigger.ndjson` and `survival_llm_calls.ndjson`; `_check_gate` and the four `_collect_*_decisions` paths now mirror their `logger.info` lines into structured records. Added `_run_survival_llm_call` wrapper that seeds `cognitive_capture` thread-local context per call so model_router records bucket under `_step_survival_llm_calls[persona]`; `on_step` resets the buffer + tracks the current step; all survival challenge/vote/paired/sequential calls now route through it.
   - `reverie/backend_server/reverie.py`: added `_merge_survival_llm_calls` and called it from both parallel and serial LLM-step write paths so survival captures land in `logs/llm/<step>.json` alongside Stage-B persona captures.

- [x] **Fix self-vote artifact: vote failsafe + per-voter eligible list**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_vote_decision.get_fail_safe` now filters the voter out of `eligible_targets` before picking index 0, so the failsafe can never produce a self-vote (root cause of Ivan's Day-2 ballot in `20260424-2`).
   - `reverie/backend_server/survival/controller.py`: `_collect_vote_decisions` builds a per-voter `voter_eligible` list excluding `name`, passes it to the LLM (so the prompt also never offers the voter as a target), and uses it for the post-call validity check + heuristic fallback.

- [x] **Tests: NDJSON sinks, dump-merge buffer, voter-exclusion failsafe**
   - `tests/test_survival_stage2_cleanup.py`: four new tests covering phase-trigger NDJSON records, survival LLM-call NDJSON entries (success + skipped), `_step_survival_llm_calls` per-persona buffering, and the failsafe never returning the voter. 20/20 tests pass.

---

## 2026-04-24 — Ivan — branch: ivan/survival

### Backend

- [x] **Survival Mode Stage 2 cleanup: remove legacy directive injection, add legacy sweep, add structured phase-trigger and LLM-call logging**
   - `reverie/backend_server/survival/controller.py`: removed `_inject_daily_directive` and its two call sites, replacing them with `_resolve_today_challenge` that preserves bookkeeping without injecting directive text into `daily_plan_req` (Identity Overlay is now the sole survival signal); added `_sweep_legacy_daily_plan_req` (runs once per controller lifetime) to reset contaminated `daily_plan_req` fields on sims forked from dirty baselines; `_check_gate` now emits structured `[survival_phase_trigger]` log lines on both branches for grep-measurable acceptance; `_collect_challenge_decisions` and `_collect_vote_decisions` emit `[survival_llm_call]` entry/skip log lines to surface whether those calls fire or are silently dropped.
   - `tests/test_survival_stage2_cleanup.py`: new 15-test file covering sweep behavior, phase-trigger logging, and LLM-call entry/skip logging; all 88 tests in the existing survival suite pass with no regressions.

---

## 2026-04-24 — Ivan — branch: main

### Backend

- [x] **Guard `sim_code` assignment in local-file resume branch of `SurvivalController.initialize_states`**
   - `reverie/backend_server/survival/controller.py`: added `if sim_name:` guard before `saved_season.sim_code = sim_name` so an empty caller-provided name cannot blank out the loaded season's sim_code, bringing parity with the existing guard on the Supabase branch.

- [x] **Supabase migration: fix fork_simulation clock alignment (P0.2 + P1.4)**
   - `supabase/migrations/20260424120000_fork_simulation_clock_fixes.sql`: new migration that CREATE-OR-REPLACEs `public.fork_simulation`; P0.2 wraps step 7's `persona_scratch.curr_time` SELECT in a CASE so baseline forks inherit the sim-level clock instead of the snapshot time, and P1.4 replaces all three `CURRENT_DATE` references with `(NOW() AT TIME ZONE 'UTC')::date` to make UTC comments truthful regardless of Postgres session timezone.

- [x] **Supabase migration: fix fork_simulation node_id overflow on deep forks (P0.3)**
   - `supabase/migrations/20260424130000_fork_simulation_memory_node_id_uuid.sql`: replaced the accumulating `_fork_<8chars>` suffix scheme (which overflowed varchar(50) at fork depth 3) with a fresh `gen_random_uuid()::text` per copied row, producing fixed 36-char UUIDs that are safe at any depth.

---

## 2026-04-23 — Ivan — branch: main

### Backend

- [x] **Fix forked sim writing survival state to parent's Supabase row due to stale `sim_code` on resumed `SeasonState`**
   - `reverie/backend_server/survival/controller.py`: set `saved_season.sim_code = sim_name` before assigning to `self.season` in both the Supabase and local-file resume branches of `SurvivalController.initialize()`, so `_persist_state()` always targets the current fork's row.

---

## 2026-04-23 — Ivan — branch: ivan/merge-supabase-first

### Backend

- [x] **Migration: backfill and auto-set `start_date` on simulation rows so strict-mode meta load no longer fails on fresh forks**
   - `supabase/migrations/20260423130000_fork_simulation_start_date.sql`: backfills NULL `start_date` values on all existing rows via COALESCE of `curr_time` / `forked_at` / `created_at` / `CURRENT_DATE`, and redefines `public.fork_simulation` to set `start_date` atomically at fork time (baseline forks get today; continuation forks inherit parent's date).

---

## 2026-04-22 — Ivan — branch: ivan/survival

### Backend

- [x] **Fix silent survival agent-state save failure for agents whose int counters drifted to floats at runtime**
   - `supabase/migrations/20260422170000_survival_state_tables.sql`: changed all `::int` casts in `save_survival_agent_state` to `::numeric::int` so JSON values like `"1.0"` pass Postgres type validation instead of raising error 22P02.

---

## 2026-04-22 — Ivan — branch: ivan/supabase-first-cleanup

### Backend

- [x] **Flip code-baked defaults to Supabase-first so a fresh checkout without `.env.local` never silently writes canonical state to ephemeral disk**
   - `reverie/backend_server/persona/memory_structures/runtime_flags.py`: changed `SCRATCH_PRIMARY` fallback default from `"json"` to `"supabase"`.
   - `reverie/backend_server/reverie.py`: changed `SIM_META_PRIMARY` fallback default from `'json'` to `'supabase'`.

- [x] **§2.2a: scratch load is now Supabase-first; JSON is a dev cold-start fallback only (`SUPABASE_ONLY_MODE=true` disables it entirely)**
   - `reverie/backend_server/persona/memory_structures/scratch.py`: added `sim_name`/`persona_name` kwargs and a `_try_load_from_supabase` helper that loads from Supabase first, falls back to JSON only in dev, and raises on any failure when strict mode is active.
   - `reverie/backend_server/persona/persona.py`: added `sim_name=None` kwarg to `Persona.__init__` and threads it through to `Scratch(...)` so the Supabase-first load path is reachable.
   - `reverie/backend_server/reverie.py`: passes `sim_name=self.sim_code` at the `Persona(...)` call site so sim context reaches scratch at init time.

- [x] **§2.2b: reverie-meta load is now Supabase-first; JSON is a dev cold-start fallback only (`SUPABASE_ONLY_MODE=true` disables the fallback entirely)**
   - `reverie/backend_server/persona/memory_structures/runtime_flags.py`: added `sim_meta_primary_mode()` helper mirroring `scratch_primary_mode()`; forces `"json"` in local-only mode, defaults to `"supabase"`.
   - `reverie/backend_server/reverie.py`: replaced inline `os.getenv('SIM_META_PRIMARY', ...)` with the new helper; added `_try_load_meta_from_supabase()` that calls the existing `get_simulation_metadata` RPC, converts ISO timestamps to legacy strftime format using `parse_memory_created` from `memory_compat.py`, returns None on soft failure in dev, and raises `RuntimeError` under `SUPABASE_ONLY_MODE=true`; wired the method into `ReverieServer.__init__` so the JSON read is a cold-start fallback only.

- [x] **§2.2c: associative memory load is now Supabase-first; JSON is a dev cold-start fallback only (`SUPABASE_ONLY_MODE=true` disables the fallback entirely) — completes the §2.2 series**
   - `reverie/backend_server/persona/memory_structures/associative_memory.py`: added `sim_name`/`persona_name` params to `AssociativeMemory.__init__` and a `_try_load_from_supabase()` method that resolves simulation and agent IDs via existing RPCs, reads all rows directly from `dbl_memory`, and reconstructs ConceptNode objects through existing `add_event`/`add_thought`/`add_chat` methods; queries the table directly (not `dbl_get_sim_memories` RPC) to avoid keyword and row-cap loss.
   - `reverie/backend_server/persona/persona.py`: threads `sim_name` and `persona_name` through to the `AssociativeMemory(...)` constructor so the Supabase-first load path is reachable.

- [x] **Fix §2.2c verification finding: 9.5% of memories silently skipped on cold-load due to Python 3.9 `fromisoformat` rejecting Postgres variable-precision fractional seconds**
   - `reverie/backend_server/persona/cognitive_modules/memory_compat.py`: added `_PG_FRACTION_RE` regex and a `.sub()` call in `parse_memory_created` to zero-pad fractional seconds to 6 digits before passing to `fromisoformat`; fixes all callers including §2.2b meta-load. Verified 0/893 parse failures after fix vs. 82/861 before.

---

## 2026-04-22 — Ivan — branch: ivan/survival

### Backend

- [x] **Make Survival Mode state a first-class Supabase entity so fork_simulation carries it across forks**
   - `supabase/migrations/20260422170000_survival_state_tables.sql`: new migration creating `double.survival_season_state` (1 row/sim) and `double.survival_agent_state` (1 row/sim/persona); adds 5 RPCs (`save_survival_season_state`, `load_survival_season_state`, `save_survival_agent_state`, `load_survival_agent_state`, `load_all_survival_agent_states`); extends `fork_simulation` to copy both tables. Applied to live Supabase and verified.
   - `reverie/backend_server/survival/state.py`: replaced the dead `SurvivalState.save_to_supabase` (which wrote to a memory RPC) with typed-table save; added `SurvivalState.load_from_supabase` classmethod, symmetric `SeasonState.save_to_supabase` / `load_from_supabase`, and a module-level `load_all_survival_agent_states_from_supabase` bulk loader.
   - `reverie/backend_server/survival/controller.py`: `initialize()` now tries Supabase → local JSON → fresh start in that order; added `_persist_state()` helper that dual-writes season+agents to both local files and Supabase; swapped three `_save_agent_states` / `season.save_to_file` pair sites (elimination, nightly recalibration, game-over) to use it.
   - `reverie/backend_server/reverie.py`: extended `_bootstrap_missing_fork_from_supabase` to hydrate `{sim}/survival/season_state.json` and `{sim}/survival/agents/<name>.json` from Supabase after the template copy, so local files mirror the DB even when the bootstrap path fires.
   - `supabase/db_reference.md`: documented new tables + RPCs under "Survival Mode (migration 20260422170000)" sections; updated fork_simulation note.
   - `tests/test_survival_supabase_persistence.py`: new integration test covering season+agent round-trip, None-on-missing, and fork propagation. All 4 pass. Local files still authoritative for now; plan to flip/deprecate later.

- [x] **Fix `_bootstrap_missing_fork_from_supabase` to carry `work_area` into local scratch**
   - `reverie/backend_server/reverie.py`: added `work_area` to the `persona_scratch` SELECT column list (~L2019) and to the `scratch_json` dict written to local `bootstrap_memory/scratch.json` (~L2147). Root cause of the `20260421-4-tierB` regression: `fork_simulation` RPC correctly carried `work_area` to the new Supabase row, but `reverie.py`'s bootstrap read omitted the field, wrote a local `scratch.json` without it, and subsequent runtime saves wrote `None` back to Supabase — nulling out the correct baseline value. Verified end-to-end with a throwaway fork + bootstrap cycle: Supabase row, SELECT result, and local `scratch.json` all carry `'the Ville:Hobbs Cafe:cafe'` for Luba.

---

## 2026-04-21 — Ivan — branch: ivan/survival

### Backend

- [x] **Path A: seed Luba's `work_area` in baseline so mini+V2 staff-object picks pass staff_only validation**
   - `environment/frontend_server/storage/base_family_sim/personas/Luba Pistsova/bootstrap_memory/scratch.json`: added `work_area: "the Ville:Hobbs Cafe:cafe"` (field was missing entirely from local bootstrap). Supabase `persona_scratch` row for `base_family_sim`/Luba already had this set via migration `20260418120000_persona_scratch_add_work_area.sql`; local file now matches DB. Verified `fork_simulation` RPC propagates `work_area` to new forks via a throwaway test-fork (deleted after). Fixes the Luba cascade-to-Dorm regression observed at step 0 of `20260421-3-tierB`, where mini picked `Hobbs Cafe | cafe | behind the cafe counter` correctly but `_validate_tuple_post_guard` rejected the staff object because `work_area` was None.

- [x] **Action-location resolver: trim prompt to 4 examples (V2) and route to Tier B**
   - `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt`: replaced the 10-example block with the V2 4-example set (park-run, library-math, cafe-coffee, home-desk); all rules (PRIORITY, FALLBACK, NEVER, "use exact names") retained.
   - `reverie/backend_server/persona/prompt_template/model_router.py`: moved `run_gpt_prompt_action_location_unified` out of `TIER_A_TASKS` and into `TIER_B_TASKS` so the resolver LLM call now runs on `gpt-5-mini` instead of `gpt-5-nano`. Driven by the variant harness: mini + V2 scores 10/11 on the probe set (incl. all four NEVER-rule safety edges), vs nano + V0's 3/11.

- [x] **Prompt/model variation harness for `run_gpt_prompt_action_location_unified`**
   - `tests/test_action_location_variants.py`: new standalone harness that replays the resolver LLM call across a matrix of 4 fully-verbatim prompt variants (V0 baseline, V1 priority-list, V2 cafe-work example, V3 workplace-disambiguation rule) × 2 models (`gpt-5-nano`, `gpt-5-mini`) × 7 activity cases (Luba drift case, cafe/pub workplace variants, and controls). Calls OpenAI Responses API directly with explicit messages; writes per-call CSV + Markdown pass-rate matrix to `tests/output/`.

- [x] **Teach daily-plan and hourly-schedule prompts to use proper-noun place names**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: added `_get_accessible_sector_list_str(persona)` helper that returns a comma-separated list of accessible sector names from `persona.s_mem` with no maze dependency.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_daily_plan` and `run_gpt_prompt_generate_hourly_schedule` thread the sector-list string into `prompt_input` as a new slot before any survival-overlay append.
   - `reverie/backend_server/persona/prompt_template/v2/daily_planning_v6.txt`: added INPUT 5 for accessible places, one rule requiring proper names, and updated examples to use proper nouns.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: added INPUT 5 for accessible places, shifted survival overlay to INPUT 6, added matching rule and examples.
   - `reverie/backend_server/persona/prompt_template/v2/generate_hourly_schedule_v2.txt`: added INPUT 6 for accessible places, one new rule, updated examples to proper nouns.
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: added INPUT 6 for accessible places, shifted survival overlay to INPUT 7, added matching rule and examples.

- [x] **Literal-sector short-circuit in the location resolver**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: added `_find_literal_sector_in_text` and `_narrow_tree_to_sector`; `generate_action_location` now short-circuits when activity text names exactly one accessible sector verbatim (word-boundary, case-insensitive), pinning the sector and narrowing the tree before the LLM call — applies to every resolution path (parent task, sub-activity, survival, routine).
   - `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt`: tightened PRIORITY rule to MUST pick the named place and explicitly overrides FALLBACK.
   - `tests/test_location_resolver.py`: added `TestLiteralSectorPin` (6 tests) covering single-sector pin, no-match fallthrough, multi-sector ambiguity, case-insensitive match, word-boundary safety, and tree narrowing.

---

## 2026-04-20 — Ivan — branch: ivan/survival

### Backend

- [x] **Anchor sub-activities to core-activity location (prevent sub-activity drift)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new `_resolve_parent_setting` pre-resolves the core activity's sector/arena/address once via `generate_action_location` so sub-activities can inherit it. `generate_task_decomp` now builds the filtered location tree and the parent setting before the decomp prompt, feeds them into `_build_contextual_decomp_pack` (new `parent_setting` kwarg), and passes `parent_address` into `_contextual_rows_to_contract_pairs`. Contract-pair builder loses the old textual-extractor branch and now reuses `parent_address` when `inherits_parent_location=true` (or the sub-label is a travel verb), otherwise falls through to `generate_action_location`. Four new observability counters (`parent_location_resolved/missing/inherit/detach_count`). Removed orphaned `_anchor_matches_parent`.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_task_decomp_contextual` and the repair twin accept a new `parent_setting_display` kwarg and append it as the physical-setting INPUT slot.
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt`: added INPUT 7 for the parent physical setting, tightened the `inherits_parent_location` rule (default true for micro-steps; flip false only for genuinely different activities), refreshed examples to show setting-first reasoning.
   - `reverie/backend_server/persona/prompt_template/v2/survival_task_decomp_contextual_v1.txt`: added INPUT 7 for parent setting, shifted survival overlay to INPUT 8, added the same `inherits_parent_location` rule with a survival-anchor caveat.
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_repair_v1.txt`: added INPUT 8 for parent setting and the `inherits_parent_location` rule so repair emissions stay anchored.
   - `tests/test_parent_arena_inheritance.py`: rewrote `TestContextualRowsInheritsParentAddress` for the new flow — asserts inheriting rows reuse `parent_address` without invoking the resolver, and detaching rows (`inherits_parent_location=false`) fall through to `generate_action_location`.

## 2026-04-18 — Ivan — branch: ivan/location-whitelist-soft-001

### Backend

- [x] **RESOLVER-LLM-FIRST-001 Phase 1: context enrichment + observability**
   - `reverie/backend_server/persona/prompt_template/v2/action_location_unified_v2.txt`: new enriched resolver template — same pipe-delimited output contract as v1, four extra INPUT slots (parent task, chatting partner, survival overlay, schedule window). v1 stays untouched.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: new `run_gpt_prompt_action_location_unified_v2` that accepts the four context kwargs + `gpt_param_overrides`. Registered as Tier A in `model_router.TIER_A_TASKS`.
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: new helpers `_harvest_resolver_context`, `_serialize_resolver_schedule_window`, `_classify_misroute`, `_append_resolver_jsonl`, `_dump_resolver_outcome`. `resolve_location` + `generate_action_location` gain `parent_task_label` kwarg; Step 3 now calls v2 with harvested context. Two new `LocationTrace` fields: `misroute_category` (stamped in `_emit_monitoring`) and `context_enrichment_used`. The three dump helpers share the new JSONL append helper.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: builds `_parent_task_label` from the hourly schedule at the resolver call site and forwards it.
   - `tests/analyze_resolver_telemetry.py`: new CLI + pure `summarise()` helper — daily weirdness rate, top-10 offending arena/activity pairs, per-persona outcome histogram, Tier B acceptance rate. Reads the shared `LLM_RESOLVER_DUMP` JSONL (no new env flag).
   - `tests/test_resolver_v2_prompt.py`: 16 tests — harvester, schedule window helper, misroute classification precedence, resolver-to-v2 call-through.
   - `tests/test_resolver_telemetry.py`: 7 tests for the analyzer's summariser — empty input, daily weirdness math, pair grouping, Tier B acceptance rate, per-persona histogram.

- [x] **RESOLVER-TIER-B-001: Tier B escalation on novel anchor**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: new helpers `_is_anchor_novel`, `_rerun_resolver_on_tier_b`, `_tier_b_strictly_better`; new branch in `resolve_location` after the compat gate; 4 new `LocationTrace` fields (`tier_b_attempted/reason/accepted/address`). When an anchor's tokens don't appear anywhere in the filtered tree, re-run the "where" LLM step on Tier B (gpt-5-mini) with the same prompt, re-validate, and swap in only if Tier B has no suspicious flags (post-validator reason or whitelist miss) and Tier A did. Trivial anchors (empty, "home", "local_anchor") short-circuit before the tree build — no cost for the common case. Bounded to one Tier B call per resolve.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_action_location_unified` gains an optional `gpt_param_overrides=None` kwarg that merges into `gpt_param` before routing. Backwards-compatible; all existing callers pass nothing.
   - `tests/test_tier_b_escalation.py`: new 15-test file — 6 novelty-detection unit tests, 5 strictly-better reconciliation unit tests, 4 integration tests with mocked Tier A/Tier B LLMs covering trigger, skip-when-known-anchor, accept-only-when-strictly-better, and one-call-per-resolve budget.

- [x] **OBJECT-STAFF-001: inherit `staff_only` to commercial kitchen objects + preserve arena on rejection**
   - `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`: flagged `cooking area`, `kitchen sink`, `refrigerator` as `staff_only: true` in both Hobbs Cafe and Rose & Crown (6 objects total). Closes the gap exposed by LOCATION-WHITELIST-SOFT-001.
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: added `_repick_non_staff_object_in_arena` helper and taught `_validate_address_post_resolution` to try it before the 4-tier cascade. New `staff_only_inarena` reason code joins the `LocationTrace.post_validated` vocabulary. Keeps the student's `cook` intent at the cafe landing on `cafe customer seating` instead of being bounced out to the dorm kitchen.
   - `tests/test_work_area.py`: two registry-fidelity tests assert the 6 kitchen objects stay `staff_only=true` (drift guard, Chunk-B-style).
   - `tests/test_f2_affordance_guard.py`: extended `_PostValidateMaze` + `_PostValidatePersona` stubs to model per-object staff_only and arena-object lists; added 3 behaviour tests (in-arena repick, worker bypass unchanged, cascade fallback when no alternative).

- [x] **LOCATION-WHITELIST-SOFT-001: soften `activity_whitelist` from hard reject to soft scoring**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: added `_whitelist_score` (1.0 match / 0.7 neutral / 0.0 miss) as a 6th component in `_score_arena` with weight 0.08; rebalanced `W` from `(0.35, 0.25, 0.20, 0.10, 0.10)` to `(0.32, 0.23, 0.19, 0.09, 0.09, 0.08)`. Removed the hard-reject filter inside `_pick_nearest_accessible_arena`, the whitelist branch inside `_validate_address_post_resolution` (now log-only under `SCORING_LOG`), and the whitelist veto inside `_try_anchor_first_route`. Added `_is_whitelist_miss` helper + `LocationTrace.low_whitelist_match` flag as the schema hook RESOLVER-TIER-B-001 will consume later. `staff_only`, privacy, and bed-like-on-non-sleep remain hard gates.
   - `tests/test_f2_affordance_guard.py`: renamed the old hard-reject test to `test_whitelist_softly_demotes_incompatible_activity`; added 4 soft-scoring tests (equi-distance tie-breaker, distance-beats-soft-bias, single-arena-still-resolvable, null-whitelist-regression) plus 2 post-validator tests (whitelist no-op, staff_only still hard-rejects) plus 4 `_is_whitelist_miss` helper tests. New `_equi_distance_setup` fixture and `_PostValidate*` stub trio.
   - `tests/test_anchor_first_guard.py`: inverted `test_anchor_rejected_by_whitelist_falls_through` → `test_anchor_whitelist_miss_no_longer_rejects` — student with cafe anchor doing 'work' now correctly routes to the cafe (emergent-scene behaviour).

---

## 2026-04-18 — Ivan — branch: nicolas/f2-misroute-fixes

### Backend

- [x] **Migration ready: `work_area` column on `persona_scratch` for F2 Tier-3 cascade**
   - `supabase/migrations/20260418120000_persona_scratch_add_work_area.sql`: adds `work_area text`, backfills Luba's row across every sim by persona name, and replaces `save_persona_scratch`/`fork_simulation` RPCs so the column round-trips through the upsert + fork paths. Applied to Supabase.
   - `supabase/db_reference.md`: surfaced `work_area` on the persona_scratch index row.
   - `reverie/backend_server/persona/memory_structures/scratch.py`: removed the `_WORK_AREA_DEFAULTS` Luba-only fallback (24 lines) now that DB column exists and is populated — `scratch_load.get("work_area")` is the single source. Also swapped the `🔄 FRESH PLANNING` emoji print for `[FRESH PLANNING]` bracket tag so `Scratch()` construction no longer crashes unit tests on Windows cp1252 terminals (matches existing `[LIFECYCLE:*]` convention at lines 904/980).

- [x] **Review pass on Nicolas's F2 fix: flip decomp inheritance default, revert Hobbs Cafe whitelist expansion**
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt`: rubric inverted — `inherits_parent_location` now defaults to `true` (sub-tasks inherit parent context by default; LLM justifies detachment for orthogonal sub-tasks).
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: parser default at `_validate_contextual_subactivities` and `_contextual_rows_to_contract_pairs` both flipped from `False` to `True` to match.
   - `environment/frontend_server/static_dirs/assets/the_ville/maze_registry.json`: reverted Hobbs Cafe `activity_whitelist` to `[eat, social, serve, relax]` — Chunk B's commit message said it excluded commercial sectors but the diff silently added `cook` and `play` to the canonical F2 target arena. Apartment/house cook additions remain.

---

## 2026-04-17 — Ivan — branch: feat/survival-cognitive-integration

### Backend

- [x] **Structured Outputs migration (Phases 1–3) for `pronunciatio`, `event_triple`, `act_obj_event_triple`, `act_obj_desc`, `decide_to_react`**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: responses builder now translates `response_schema`/`verbosity` gpt_params into `text.format={json_schema, strict:true}` and `text.verbosity`; defaults `verbosity="low"` only when a strict schema is present so free-form Tier B/C prompts keep natural length.
   - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: new `routed_safe_generate_structured` wrapper — sends prompt as-is, enforces strict JSON Schema, no legacy prose-JSON envelope.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: five functions migrated; added `PRONUNCIATIO_SCHEMA`, `EVENT_TRIPLE_SCHEMA`, `ACT_OBJ_DESC_SCHEMA`, `DECIDE_TO_REACT_SCHEMA` (enum `"1"|"2"`); removed duplicate `__func_clean_up`/`__func_validate` pair (latent bug where `__chat_func_validate` called the duplicate); `repeat` reduced 3→2 (zero retries observed).
   - `v3_ChatGPT/generate_pronunciatio_v1.txt`, `generate_event_triple_v1.txt`, `generate_act_obj_event_triple_v1.txt`, `generate_obj_event_v2.txt`, `decide_to_react_v1.txt`: simplified to task statement + few-shot; shape enforced by schema. Post-sim tightening on `obj_event`/`act_obj_event_triple` (2–6 word predicate, base verb, concrete noun; stronger examples) — addresses Luba's library table producing ("inspect","restocking") in `20260417-4`.
   - `tests/_probe_pronunciatio_structured.py` (8/8) and `_probe_phase2_structured.py` (14/14) pass; 1–53 output tokens per call depending on schema; zero retries.
   - `sot_prompts.md`, `sot_llm.md`: contract rows updated for all five; `sot_llm` → v1.6; Structured Outputs section covers Phases 1–3.

- [x] **Tier A `incomplete:max_output_tokens` — reflection prompts moved to Tier B; earlier pin reverted**
   - `reverie/backend_server/persona/prompt_template/model_router.py`: reverted the chat_completions pin for Tier A — sim `20260417-1` showed `reasoning_tokens:0` on every Tier A failure, so the reasoning-overhead diagnosis was wrong. Kept the Tier A→B move for the 5 reflection prompts.
   - Note: the companion `max_tokens` bumps for `event_triple`/`act_obj_event_triple`/`pronunciatio`/`act_obj_desc` were superseded by the Structured Outputs migration above.

- [x] **Cleanup: prompt-template caching, parallel probes, dead params**
   - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: `_load_prompt_template` now `@lru_cache(maxsize=256)` — eliminates ~144k stat-calls/day at typical sim throughput.
   - `tests/_probe_phase2_structured.py`, `_probe_pronunciatio_structured.py`: `ThreadPoolExecutor(max_workers=4)` with input-order printing — wall-clock ~17s→9.6s and ~10s→5.1s.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: dropped unused `persona`/`act_game_object` params in two inner `get_fail_safe()` helpers.

- [x] **Fix Stage 1 daily plan prose-drift + close Stage 2 contextual-decomp gap**
   - `v2/survival_daily_plan_v1.txt`: overlay reframed as "reference only" + mandatory RESPONSE FORMAT block — fixes Day 2 fail-safe in `20260416-2-surv-stage2` where the 500-tok budget was blown writing a prose preamble.
   - `v2/survival_generate_hourly_schedule_v1.txt`: trimmed rules, "under 15 words, single line" constraint to stay within max_tokens=50.
   - `v2/survival_task_decomp_v1.txt`: "reference only" framing for consistency.
   - `v2/survival_task_decomp_contextual_v1.txt`: new variant for the `TASK_DECOMP_CONTEXTUAL_ENABLED=true` path — closes the gap where Stage 2 survival anchors weren't reaching subtask generation.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: wired `run_gpt_prompt_task_decomp_contextual` through `resolve_template` and appended `persona.survival_overlay` as `!<INPUT 7>!` when survival mode is on.

- [x] **Fix truncated post-conversation memos (Tier B token budget too tight)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: raised `max_tokens` from 15 to 120 for `run_gpt_prompt_memo_on_convo` — the previous budget fit Tier A but silently truncated mid-sentence once the function moved to Tier B (gpt-5-mini), where reasoning tokens count against the same limit.

- [x] **Dead v2-fallback sweep in `run_gpt_prompt.py` (–320 lines, zero behaviour change)**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: removed always-true `if output != False` guards and the unreachable v2 fallback blocks they gated across 11 functions (pronunciatio, summarize_conversation, event/thought/chat_poignancy, focal_pt, two agent_chat summarizers, agent_chat, summarize_ideas, memo_on_convo); also removed two orphaned commented-out ChatGPT-plugin alternates in `generate_hourly_schedule` and `generate_next_convo_line` — `routed_safe_generate_response` and `routed_safe_generate_structured` never return `False` so every fallback was dead by construction.

- [x] **Tighten `act_obj_event_triple` prompt to eliminate "subject echoes object" pattern (observed in sim 20260417-6)**
   - `reverie/backend_server/persona/prompt_template/v3_ChatGPT/generate_act_obj_event_triple_v1.txt`: added four guidance rules — no phrasal verbs for predicates, object must differ from subject, furniture/containers prefer transitive predicates (hold, host, display, store) over intransitive states, and a new closet example; `bed/sleeping` probe now returns `('bed', 'host', 'sleeper')` instead of a subject-echo triple; 14/14 probe suite still passes.

---

## 2026-04-16 — Ivan — branch: feat/survival-cognitive-integration

### Backend

- [x] **Stage 2 — Hourly schedule + task decomp variants; band-aid removal**
   - `reverie/backend_server/persona/prompt_template/v2/survival_generate_hourly_schedule_v1.txt`: new variant forked from `generate_hourly_schedule_v2.txt` adding `!<INPUT 6>!` overlay slot and survival anchor rule (challenge/gathering/voting hour must resolve to the gathering location); single-line activity-phrase output contract preserved.
   - `reverie/backend_server/persona/prompt_template/v2/survival_task_decomp_v1.txt`: new variant forked from `task_decomp_v3.txt` adding `!<INPUT 8>!` overlay slot and rule that every subtask of a survival anchor activity stays at the gathering location; numbered-list/duration-tail parser contract preserved.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_generate_hourly_schedule` and `run_gpt_prompt_task_decomp` now call `resolve_template(...)` and append `persona.survival_overlay` to `prompt_input` when survival mode is on (no-op on baseline path).
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: removed `_inject_gathering_location_hints`, `_inject_voting_gather_override`, `_VOTING_GATHER_START_MIN`, `_VOTING_GATHER_END_MIN` and their four call sites after the social-ref filter; spatial gate + 20:00 deadline untouched.
   - `tests/test_survival_gathering_override.py`, `tests/test_gathering_location_hints.py`: deleted (covered the removed helpers).

- [x] **Verify-on-behaviour-change workflow**
   - `CLAUDE.md`: added "Verify after behaviour-affecting edits" rule with a narrow skip list (docs, comments, renames, dev-ergonomics config, explicit opt-out).
   - `.claude/skills/verify/SKILL.md`: new skill with a diff-driven decision tree for cognition/movement/prompt/API/env checks, finishing with `/simplify`.

- [x] **Stage 1 — Identity Overlay + survival-aware daily plan (first live use of resolver)**
   - `reverie/backend_server/survival/controller.py`: added `build_identity_overlay(persona)` + helpers (`_label_for`, `_format_deadline`, `_format_alliances`, `_format_threats`, `_format_rewards`) producing the §4 schema block; per-day cache invalidated on day advance and after challenge/vote resolution; `on_step` sync loop now also writes `persona.scratch.survival["identity_overlay"]` (try/except degrades to empty on failure).
   - `reverie/backend_server/persona/persona.py`: added read-only `survival_overlay` property reading `scratch.survival["identity_overlay"]`.
   - `reverie/backend_server/persona/prompt_template/v2/survival_daily_plan_v1.txt`: new variant forked from `daily_planning_v6.txt` with `!<INPUT 5>!` overlay slot and survival-anchor activity rules; numbered-list tail preserved for parser compatibility.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `run_gpt_prompt_daily_plan` now calls `resolve_template(...)` and appends `persona.survival_overlay` to `prompt_input` (no-op on baseline path).
   - `tests/test_identity_overlay.py`: 29 tests covering schema content, label thresholds, alliances/threats/rewards formatting, cache invalidation, empty-state graceful edges.
   - `tests/test_survival_daily_plan_wiring.py`: 13 tests covering resolver selection, template file contents, controller overlay write + exception fallback, overlay property contract, day-boundary cache reset.
   - `tests/test_template_resolver.py`: swapped the "missing file" fixture filename now that `survival_daily_plan_v1.txt` ships.

- [x] **Stage 0 — survival_mode flag plumbing + prompt template resolver (no behavior change yet)**
   - `reverie/backend_server/persona/persona.py`: added `survival_mode` property backed by existing `scratch.survival["mode"]` for free round-trip through scratch save/load.
   - `reverie/backend_server/survival/controller.py`: idempotent flag sync at top of `on_step` for all `remaining_players`; clear flag on eliminated persona after `_broadcast_elimination`; clear flag on all personas when `_check_game_over` returns a stop signal.
   - `reverie/backend_server/persona/prompt_template/loader.py`: new `resolve_template(baseline_path, survival_path, persona)` helper; returns survival variant only when flag set and file exists, else baseline. Not yet wired into `run_gpt_prompt.py` (Stage 1).
   - `tests/test_survival_mode_flag.py`: property existence, default, scratch round-trip, controller set/clear hooks, elimination order (flag still True during broadcast), game-over clear.
   - `tests/test_template_resolver.py`: baseline fallback when no survival variant, survival selection when flag + file, absolute path handling, defensive duck-typing.

---

## 2026-04-16 — Ivan — branch: feat/video

### Backend

- [x] **Spatial gate threshold rounds half-up instead of implicit ceil**
   - `reverie/backend_server/survival/controller.py`: `_spatial_gate_met` now computes `threshold = int(n_alive * 0.8 + 0.5)` so a 4-agent cohort gate fires at 3/4 (75%) rather than effectively 4/4. Also affects n=8 (6/8 vs 7/8). No change for n=5/6/7/10.
   - `tests/test_survival_spatial_gate_rounding.py`: 11 parametrized cases covering n=3/4/5/8 boundaries plus a half-exact case (0.5 threshold, n=3 → 2/3).

---

## 2026-04-16 — Nicolas — branch: fix/20260415-survival-gathering-enforcement

### Backend

- [x] **Voting-window gather override (SURVIVAL-003, partial)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new `_inject_voting_gather_override` mirrors `_inject_gathering_location_hints`. Replaces hourly-schedule entries whose start-of-day minute falls in `[19:00, 21:00)` with `"gathering at {SURVIVAL_GATHERING_LOCATION} for voting"`. Wired in `_long_term_planning` after the existing hints pass, before the cache write.
   - `tests/test_survival_gathering_override.py`: 10 unit tests (failing-first for the replacement behavior; regression guards for out-of-window entries, idempotence, empty/whitespace env var, and both schedule variants `f_daily_schedule` and `f_daily_schedule_hourly_org`).

## 2026-04-15 — Nicolas — branch: fix/20260415-survival-vote-history-non-voters

### Backend

- [x] **Persist non-voter entries in vote_history (SURVIVAL-002)**
   - `reverie/backend_server/survival/controller.py`: In `_collect_vote_decisions`, absent agents now append `{voted=False, reason="absent_from_gathering", phantom_applied=True}` to their own `vote_history` before being skipped.
   - `reverie/backend_server/survival/voting.py`: `record_vote_to_state` adds `voted=True` to real-vote entries for schema symmetry; back-compat via `entry.get("voted", True)`.
   - `tests/test_vote_history_non_voters.py`: 2 failing-first tests + 1 regression guard for the back-compat default.

---

## 2026-04-15 — Nicolas — branch: fix/gosha-gathering-location-hint

### Backend

- [x] **Fix survival schedule location drop for Gosha**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added `_inject_gathering_location_hints()` post-processor that re-injects `SURVIVAL_GATHERING_LOCATION` into schedule entries containing survival keywords but missing the gathering location.
   - `tests/test_gathering_location_hints.py`: 10 tests covering injection, no-duplication, no false positives, and env var absent/empty cases.

---

## 2026-04-15 — Nicolas — branch: fix/20260415-address-tiebreaker-tile-count

### Backend

- [x] **Address tiebreaker: tile count instead of string length**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: Changed tiebreaker in `_resolve_anchor_to_address` and `_pick_best_object_address` from `len(address)` to `len(maze.address_tiles[address])`.
   - `tests/test_address_tiebreaker.py`: 4 tests covering old-vs-new behavior, bug case, and score-precedence.

---

## 2026-04-15 — Nicolas — branch: fix/20260415-phase8-multi-tile-capacity

### Backend

- [x] **Phase 8 capacity-aware redistribute with per-persona tile assignment**
   - `reverie/backend_server/reverie.py`: Added `claimed` counter and multi-tile capacity gate in `_redistribute_colocated_object_addresses`; co-located personas now get distinct `zone_anchor` tiles via round-robin over `address_tiles[addr]`.
   - `tests/test_phase8_redistribute.py`: Added 4 unit tests (11-seat co-location, overflow past capacity, single-tile regression, bed fast-path preserved).

---

## 2026-04-15 — Ivan — branch: feat/VIDEO

### Backend + Docs

- [x] **Mode-aware trailer showrunner + TikTok-paced voice rebalance**
   - `generative_agents/video/extract_day_log.py`: Added `_detect_sim_mode` (reads `scratch.survival` per sot_survival.md) and `_extract_survival_context` (pulls eliminated/alive/immune rosters, current phase, challenge, protagonist immunity/vote-weight from the whole cast's scratch); `day_log` now carries `sim_mode` and `survival_context`.
   - `generative_agents/video/showrunner.py`: Rewrote VOICE block — "Attenborough meets TikTok," concrete over poetic, max one metaphor per scene, bumped target pace to 2.7 words/sec (word count 140-170, validator range 100-200); added `SURVIVAL_ADDENDUM` with HOOK→COALITION→VOTE→STINGER beat sheet, required vote scene, named-stakes opening line, and competition vocabulary requirements; `generate_script` appends the addendum only when `day_log.sim_mode == "survival"`.
   - `double-docs/sot/sot_video.md`: Documented mode-aware prompting, Survival context schema, new voice/pace, and tightened script constraints.
   - `double-ivan/video/PRD_video_pipeline.md`: Opened TODO-2c to validate the Survival path end-to-end against a real Survival sim (20260413-1 is a family fork, not true Survival).

- [x] **Stabilize showrunner retries (prompt hardening + tier pinning + scene-specific feedback)**
   - `generative_agents/video/showrunner.py`: Promoted `key_steps 2-5 / consecutive`, `key_dialogue ≤2 total`, `subtitle_card ≤2` to a HARD CONSTRAINTS block at the top of the system prompt; gave each retry a unique `routing_step_id` so `TIER_C_MAX_CALLS_PER_STEP=1` stops silently demoting retries to Tier B; retry feedback now echoes the offending scenes' JSON (scene_id, step_range, key_steps, key_dialogue) so the model sees its own output beside the rule.

- [x] **Importance-threshold chat selection (drops fixed top-10 cut)**
   - `generative_agents/video/extract_day_log.py`: Replaced hard top-10 chat cap with substantive-threshold gate (turns ≥ 3 AND protagonist speaks) + hard ceiling of 25 + floor-backfill of 5, so dense social sims surface more drama automatically while sparse sims still have material.
   - `double-docs/sot/sot_video.md`: Updated chat selection semantics in the memory strategy section.

- [x] **Day-aware chat extraction from movement.chat (trailer pipeline TODO-2a)**
   - `generative_agents/video/extract_day_log.py`: Replaced dbl_memory chat fetch with verbatim transcript extraction from `movement.chat` position rows — deduped by participant-set + opening utterance, trimmed to 6 turns × 25 words, ranked by protagonist participation + turn count; added optional `--day N` scope and `day` / `day_step_range` output fields.
   - `generative_agents/video/generate_trailer.py`: Piped `--day` through the orchestrator into `extract_day_log`.
   - `double-ivan/video/PRD_video_pipeline.md`: Closed TODO-2a (done); opened P1 TODO-2b to diagnose 0 chat rows in `dbl_memory` for sim 20260413-1.
   - `double-docs/sot/sot_video.md`: Updated memory strategy, output schema, and day-awareness notes to reflect the new extractor.

### Docs + Backend

- [x] **Verify TODO-1 (record_scenes.py ?recording=true swap) already shipped; sync docs**
   - `generative_agents/video/record_scenes.py`: Cleaned stale "Director API" reference in module docstring (the swap itself landed in commit 45c9f865).
   - `double-ivan/video/PRD_video_pipeline.md`: Marked TODO-1 complete; updated stage-4 status row to Done.
   - `double-docs/sot/sot_video.md`: Updated "Known Gaps" row for the URL swap to Done.

- [x] **Reorganize video pipeline PRD; add three sim-wide trailer types**
   - `double-ivan/video/PRD_video_pipeline.md`: Compressed completed day-in-life work into shipped-reference sections, ordered open TODOs by urgency (P0-P3), and added full implementation plans for Announce / Opening / Sim-day-overview trailers plus shared infra unlocks.

---

## 2026-04-15 — Ivan — branch: main

### Backend

- [x] **Align Supabase quick-reference doc with latest pulled schema snapshot**
- `generative_agents/supabase/db_reference.md`: Updated schema freshness metadata, added missing schemas/tables (`auth`, `storage`, `extensions`, `areas`, `areas_zones`, `dbl_agent`), and refreshed applied-migration notes to reflect successful 2026-04-15 remote sync.

---

## 2026-04-15 — Ivan — branch: main

### Backend

- [x] **Harden trailer retrieval migration for fresh local shadow DB replay**
- `generative_agents/supabase/migrations/20260414_dbl_retrieve_rir_sim_scope.sql`: Added `CREATE EXTENSION IF NOT EXISTS vector` and migration-level `search_path` so `supabase db pull` can resolve the vector type during local replay.

---

## 2026-04-15 — Ivan — branch: main

### Backend

- [x] **Unblock local Supabase schema pull for trailer retrieval migration**
- `generative_agents/supabase/migrations/20260414_dbl_retrieve_rir_sim_scope.sql`: Switched function overload signatures from `extensions.vector` to `vector` so `supabase db pull` can replay migrations in the local shadow database.

---

## 2026-04-15 — Nicolas — branch: main

### Backend

- [x] **Document CHAT-MEMORY-001: `a_mem.seq_chat` stays empty at runtime despite real conversations**
   - `reverie/backend_server/persona/cognitive_modules/conversation_manager.py`, `reverie/backend_server/persona/cognitive_modules/perceive.py`, `reverie/backend_server/persona/memory_structures/associative_memory.py`: recorded a runtime memory bug where repeated same-pair conversations can happen in the same sim day while the associative chat memory still looks empty. In diagnostic probes, `ConversationManager.build_conversation_context()` can see `times_talked_today >= 1` while `seq_chat_len=0` and `get_last_chat(other_persona)=False`.
   - Root cause: `_persist_chat_node_early()` in `perceive.py` only calls `a_mem.add_chat()` when `persona.scratch.act_event[1] == "chat with"`. But when `CHAT_PRESERVES_ACTION=true`, the conversation start path in `conversation_manager.py` preserves the persona's pre-chat `act_event` instead of switching it to `"chat with"`. That bypasses chat-node persistence into `AssociativeMemory.seq_chat`, so `AssociativeMemory.get_last_chat()` has nothing to return at runtime.
   - Where it can be seen: second-and-later encounters between the same pair on the same day are the clearest case. The runtime state reports "we already talked today" through `times_talked_today`, but any code path that reads `a_mem.seq_chat` or `get_last_chat()` sees no prior chat history. This is visible directly in the diagnostic mismatch (`times_talked_today > 0` with empty chat memory) and explains why conversation continuity can silently degrade for callers that trust associative memory as the source of truth.

---

## 2026-04-14 — Ivan — branch: feat/VIDEO

### Video

- [x] **Wire RIR focal-point retrieval into extract_day_log (Phase 2)**
   - `video/extract_day_log.py`: added `_get_embedding_raw` dual-import (falls back to `None` gracefully), `SHOWRUNNER_FOCAL_POINTS` constant, `_get_query_embedding` (1536→768 compression via `[::2]`), and `_fetch_rir_memories` (multi-focal HNSW query via 10-param `dbl_retrieve_with_rir`, merges by `memory_id` keeping best `combined_score`); thoughts and events now use RIR with automatic fallback to poignancy-only if embeddings unavailable; chats remain on typed fetch; `object_ref` field normalised to `object` in output schema.

- [x] **Add p_simulation_id to dbl_retrieve_with_rir (backward-compatible overload for trailer pipeline)**
   - `supabase/migrations/20260414_dbl_retrieve_rir_sim_scope.sql`: new 10-param overload of `dbl_retrieve_with_rir` with `p_simulation_id uuid DEFAULT NULL`; adds one WHERE condition and a 10× candidate pool when scoped; existing 9-param callers are completely unaffected.
   - `supabase/db_reference.md`: updated RPC signature to document the new optional parameter.

- [x] **Supabase-native context builder: replace raw memory dump with typed, sim-scoped, poignancy-ranked queries**
   - `video/extract_day_log.py`: replaced `_fetch_memories` (mixed raw dump) with `_fetch_typed_memories` (typed `dbl_get_sim_memories` calls per memory type, sorted by poignancy); replaced `_build_timeline` with `_build_sampled_timeline` (activity-transition steps + every-15th grid sample, ~60–100 entries vs 750); extracted `_build_schedule` and `_build_personality` helpers; added `total_steps_full_range` field for showrunner.
   - `video/showrunner.py`: added timeline-sampling note to `USER_PROMPT_TEMPLATE` and `{total_steps}` injection so LLM knows valid step range beyond the sample; backward-compatible fallback for old day_log files without `total_steps_full_range`.

- [x] **Plan B: switch to consecutive-step segments for smooth in-clip animation (2–4 clips instead of 5)**
   - `video/showrunner.py`: replaced 5-beat BEAT SHEET with SEGMENT STRUCTURE (2–4 segments, 8–20s each); updated RULES so key_steps must be consecutive integers; updated validator to enforce 2–4 scene count and consecutive check (`[12,13,14]` valid, `[12,15,19]` rejected); removed fly_over/time_lapse from transitions list.

- [x] **Reduce recording time from ~18 min to ~3.5 min via key-step selection and 720p recording**
   - `video/showrunner.py`: added `key_steps` field to scene schema (2–5 specific steps per scene), updated system prompt to prohibit timecodes/beat labels in narrator_script, added validation (ascending order, within step_range, 2–5 items).
   - `video/record_scenes.py`: switched to key_steps-only recording loop (replaces full step-range iteration); changed DEFAULT_VIEWPORT to 1280×720; reverted playback_speed default to 1.
   - `video/compose_trailer.py`: replaced hard-cut concat demuxer with xfade filter chain (0.3s crossfades via ffprobe duration probing); updated vertical crop math for 720p source.
   - `video/tts.py`: fixed timecode-stripping regex from `r'^\d+:\d{2}-\d+:\d{2}:\s*'` to `r'^\d+:\d{2}-\d+:\d{2}\s*'` so timecodes without a trailing colon are also stripped before TTS render.

- [x] **Fix end-card truncating trailer to 50s instead of 60s**
   - `video/compose_trailer.py`: escape Windows font path as `'C\:/Windows/Fonts/arial.ttf'` so drawtext doesn't fail on filter-colon parsing; switch end-card framerate from 30 to 25 fps to match Playwright scene clips (concat demuxer broke timebase otherwise); compute end-card duration as `60 − last_scene_end` so it bridges the CLOSE narration window.

---


## 2026-04-13 — Nicolas — branch: fix/20260413-hobbs-cafe-multi-agent-settlement

### Backend

- [x] **Fix multi-agent location convergence and tile occupancy for survival gathering**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: added `blocked_tiles` kwarg to `find_nearest_reachable_in_zone` for destination-tile occupancy awareness. Threaded a new `unavailable_addresses` kwarg through `_candidate_address_score`, `_resolve_anchor_to_address`, `_pick_best_object_address`, and `_repair_resolved_action_address` for cross-persona object-level exclusion. Added `_dump_llm_resolver_repair_call` instrumentation behind the existing `LLM_RESOLVER_DUMP` flag.
   - `reverie/backend_server/reverie.py`: new `_collect_other_persona_tiles` helper wired into 4 call sites for tile-level occupancy. New `_redistribute_colocated_object_addresses` post-parallel redistribution pass that detects object-level collisions after parallel `plan()` completes and reassigns duplicates in deterministic order. Also refreshes `scratch.zone_resolution_detail` / `zone_resolution` / `target_zone` so the frontend panel reflects the new per-persona assignment.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: new one-shot `phase8_resolve_override` flag on scratch that skips the contract short-circuit after redistribution, so the sticky short-circuit picks up the reassigned `scratch.act_address` instead of the stale contract row.
   - Validated on `base_family_sim`: 4 agents reach Hobbs Cafe and distribute across 4 different objects (counter, customer seating, cooking area, kitchen sink) at Level 1 (20 steps) and Level 2 (60 steps). No freezes, no regressions, no schedule advancement during the gathering window. Frontend panel correctly reflects per-persona locations.

---

## 2026-04-13 — Nicolas — branch: fix/20260413-walk-to-sector-short-circuit

### Backend

- [x] **Fix `_deterministic_guard_v2` misrouting "walk to Hobbs Cafe" to the persona's dorm common room**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: insert explicit-destination short-circuit in `_deterministic_guard_v2`. When the activity description mentions a non-home public sector by label (word-boundary match against `maze.sector_meta`), the guard returns `None` and defers to the downstream `typed_scorer` / LLM path instead of applying the activity-type registry fallback.
   - Validation: 60-step survival sim from `base_family_sim`, Hobbs Cafe intent misroute rate dropped from **27.3% (202/739) to 0.0% (0/136)**, 6 short-circuit fires across 4 personas, no regressions on sleep/hygiene/study paths.
   - LLM-EXC class (Ivan "run around Oak Hill College" → Johnson Park) is out of scope for this fix and remains pending for the architectural follow-up.

## 2026-04-13 — Nicolas — branch: feat/20260413-llm-resolver-diagnostic-logging

### Backend

- [x] **Add LLM resolver diagnostic logging (LLM_RESOLVER_DUMP flag)**
   - `reverie/backend_server/persona/cognitive_modules/location_resolver.py`: new `_dump_llm_resolver_call()` helper writes a JSONL record per unified-resolver call when `LLM_RESOLVER_DUMP=true`; captures prompt, raw LLM response, anchor_context, activity_type, valid_sectors, and the resolved tuple. Zero cost when flag is off.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: `__func_clean_up` in `run_gpt_prompt_action_location_unified` captures the raw LLM response in a `raw_response_capture` dict and appends it to the returned trace as element [5].

## 2026-04-13 — Ivan — branch: feat/VIDEO

### Backend

- [x] **Make `generate_trailer.py` fully idempotent in one pass**
   - `video/generate_trailer.py`: each step now skips if its artifact already exists (day_log, script, narration, clips); removed `--skip-record`/`--skip-compose` footguns, added `--force` to regenerate from scratch; compose step fails fast if clips incomplete.

- [x] **Swap `record_scenes.py` to `?recording=true` (drop headless-mode workarounds)**
   - `video/record_scenes.py`: URL → `?recording=true&step=N`; removed `HIDE_UI_CSS` + `add_style_tag` (FE owns chrome-hiding); dropped `--use-gl=swiftshader` arg; replaced fixed 20s settle with `wait_for_function(window.__headlessReady === true)`; removed `has_director`/`has_step_api` probes and timed-recording fallback (camera + step API unconditional in recording mode); dropped FFmpeg `-ss 30` head-trim (kept `-t scene_duration` cap).

- [x] **Add progress logging to `record_scenes.py` step loop**
   - `video/record_scenes.py`: per-step `Step N done (i/total)` log, plus markers for end-zoom tween, video finalize, and ffmpeg cap — removes false-hang perception when a scene spans many steps at 1x playback.

- [x] **Unify trailer directory layout across `record_scenes.py` and `generate_trailer.py`**
   - `video/generate_trailer.py`: renamed `_default_output_dir` → `default_trailer_dir` (public), so other entry points can reuse the `data/<sim>/<persona>&NNN/` auto-increment helper.
   - `video/record_scenes.py`: `--output-dir` default changed from `./trailer/raw` to `None`; when omitted, `main()` now auto-creates `data/<sim>/<protagonist>&NNN/raw/` + `audio/`, copies the input `script.json` to the trailer root, and copies `video/audio/music_<mood>.mp3` into `audio/` so `compose_trailer` can be run on the dir with no extra setup. Prints the trailer dir and the ready-to-run compose command on exit.

## 2026-04-13 — Ivan — branch: feat/VIDEO

### Backend

- [x] **Bump vulnerable deps flagged by Dependabot (urllib3, requests, tqdm, aiohttp)**
   - `requirements.txt`: `urllib3 2.2.3→2.5.0`, `requests 2.32.3→2.32.4`, `tqdm 4.62.3→4.66.5`.
   - `railway-requirements.txt`: same three bumps plus `aiohttp==3.11.11→>=3.13.3` to match root.
   - Verified: `pip check` clean, all key imports load (`urllib3 2.5.0`, `requests 2.32.4`, `tqdm 4.66.5`, `aiohttp 3.13.5`).

- [x] **Fix survival persistence defects from 20260412-2: truncated season_state and missing vote_history**
   - `reverie/backend_server/survival/state.py`: replaced `active_challenge` dict field with `active_challenge_id` (str) + rehydrating property from `CHALLENGE_CATALOG`, so `season_state.json` no longer serializes Python type objects; `from_dict` reads legacy dict-form saves.
   - `reverie/backend_server/survival/voting.py`: added `heuristic_vote(voter, state, eligible)` deterministic fallback scoring `perceived_threat + grudge`.
   - `reverie/backend_server/survival/controller.py`: store `challenge.challenge_id` in `_inject_daily_directive`; in `_collect_vote_decisions` replace silent skip-on-LLM-failure with heuristic fallback + end-of-collection invariant log.

- [x] **Stop hoarding embeddings in RAM — route perceive dedup through retrieve_double's LRU cache when DB reads are on**
   - `reverie/backend_server/persona/cognitive_modules/perceive.py`: added `_cached_or_fetch_embedding()` helper + conditional imports + startup mode log; replaced 3 `a_mem.embeddings` lookup sites (early-persist chat, event embed, fallback chat embed) with the helper.
   - `reverie/backend_server/persona/memory_structures/associative_memory.py`: gated `self.embeddings` load/node-pair/save and the 3 dict writes in `add_event`/`add_thought`/`add_chat` behind `_USE_DB`; `embeddings.json` no longer written in DB mode.

---

## 2026-04-12 — Ivan — branch: feat/VIDEO

### Backend

- [x] **Survival baseline guard — refuse SURVIVAL_MODE on sims flagged `is_baseline=true`**
   - `reverie/backend_server/reverie.py`: added `_is_sim_baseline()` Supabase check; raises before `SurvivalController` construction when sim is a baseline.
   - `reverie/backend_server/survival/controller.py`: `__init__` raises `RuntimeError` if `is_baseline=True` in config (defense-in-depth).
   - `tests/test_survival_baseline_guard.py`: 4 unit tests covering refusal, accept-on-non-baseline, backwards compat when kwarg omitted, error message contains sim_code.

- [x] **Trailer output now defaults to `./data/<sim>/<persona>&NNN` with auto-incrementing index**
   - `video/generate_trailer.py`: added `_default_output_dir` helper; replaces old `./trailer_<sim>_<persona>` default
   - `.gitignore`: `data/*` excluded from version control

- [x] **Relocated video trailer pipeline from `reverie/backend_server/video/` to project root `video/`**
   - `video/*`: git mv preserves history; updated docstring usage examples and dual-import fallback to `video.X` / relative
   - `.gitignore`: updated audio/trailer ignore paths
   - `video/trim_sfx.sh`: updated cd path

---

## 2026-04-11 — Nicolas — branch: nicolas

### Backend

- [x] **Fix oscillation regression (settle_ready + zone_anchor sync)**
   - `spatial_occupancy.py`: settle_ready evaluated before sub_mode check; added 10-step arrival_transition timeout
   - `execute.py`: zone_anchor synced to selected object tile on target_selection
   - Validated in `20260411-nosurv-60` (15p, 60 steps): oscillations 4.5/persona → 1.07/persona

---

## 2026-04-10 — Ivan — branch: feat/VIDEO

### Backend

- [x] **First working trailer produced end-to-end (Phase 1 complete)**
   - Sim `20260407-2` / Ivan Pistsov → 5 scene clips with real Phaser tilemap + intrigue music + subtitles + end card → MP4 output

- [x] **Playwright recording: fixed blank screen + UI overlay issues**
   - `reverie/backend_server/video/record_scenes.py`: Switched to normal mode (headless mode skips tilemap rendering); added SwiftShader (`--use-gl=swiftshader`) for software WebGL; inject CSS via `page.add_style_tag()` to hide play button (`.z-50`) and bottom bar; FFmpeg auto-trim of 30s loading screen; timed recording fallback when Director API unavailable

- [x] **TTS fallback: ElevenLabs → OpenAI now works automatically**
   - `reverie/backend_server/video/tts.py`: Fixed per-segment fallback (was choosing backend at init based on key existence, now retries with OpenAI on any ElevenLabs error); fixed concat path resolution to use absolute paths

- [x] **Compose pipeline bug fixes**
   - `reverie/backend_server/video/compose_trailer.py`: Fixed Windows path resolution in concat, stripped MP3 cover art via `-vn`, improved error logging
   - `reverie/backend_server/video/showrunner.py`: Added subtitle card limit to prompt
   - `reverie/backend_server/video/generate_trailer.py`: Added shared music library fallback + auto-copy

---

## 2026-04-10 — Nicolas — branch: nicolas

### Backend

- [x] **Merge main into nicolas (BE)**
   - `reverie.py`: Ivan's survival hooks, resume guard, date splicing merged clean
   - `reflect.py`: took Ivan's reflection trigger fix, kept step-based chat reflection

- [x] **Fix missing `generate_focal_pt_v1.txt` in `v3_ChatGPT/`**
   - `persona/prompt_template/v3_ChatGPT/generate_focal_pt_v1.txt`: restored (copy from `v2/`). Accidentally deleted in April 5 cleanup. Blocked all reflections.

- [x] **Fix address_label mismatch in movement JSON**
   - `reverie.py:4623`: always use `maze.get_authoritative_address(next_tile)` instead of trusting LLM-planned `act_address`

- [x] **Fix action_progress.current_action mismatch**
   - `reverie.py:4458`: override `current_action` and `resolved_address` with real tile address. FE was using this field as first priority for location labels.

- [x] **Fix act_address decomposition losing parent task location**
   - `plan.py`: new `_extract_in_place_location_hint()` extracts locations from "at X"/"in X" prepositions in non-travel actions. Parent task location now propagates to sub-activities as anchor.
   - `location_resolver.py`: `_deterministic_guard_v2()` enriches empty anchor from action description (35% scoring weight)

### Validation

- [x] **Smoke test:** 20 steps, 4 personas, survival ON — 0 errors
- [x] **Regression:** 200 steps, 15 personas, survival OFF — 0 tracebacks, 0 reflection errors, 18 PATH ERRORs (comparable to reference 20)
- [x] **Survival integration:** 800 steps, 4 personas, survival ON — challenge, voting, elimination all worked. Gosha eliminated step 628. 0 tracebacks, 0 reflection errors. 6.5x faster than Ivan's reference.

---
## 2026-04-07 — Ivan — branch: main

### Backend

- [x] **Restore original reflection trigger and task duration parsing**
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Removed importance_ele_n >= 10 bypass to prevent runaway reflections and restore Stanford paper's 150-point importance budget logic
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Removed fabricated 5-minute duration fallback for unparseable LLM outputs to expose prompt issues and match original behavior

## 2026-04-09 — Ivan — branch: local

### Backend

- [x] **Silenced misleading Supabase bootstrap warning for GridBackedMemoryTree personas**
  - Achieves: Eliminates false "coord sync may fail" log noise from AttributeError on read-only tree property (no functional impact; tree computed live from maze).
  - Implementation: Added early `continue` in `reverie/backend_server/reverie.py:_populate_spatial_memories()` using string type check to skip assignment for GridBackedMemoryTree (avoids new imports).

- [x] **Requirements/Dependencies cleanup: Consolidated Dependabot Waves 1-3 — removed ~40 unused legacy/science/ML/media packages, merged API gateway requirements, resolved pin conflicts, applied security bumps**
  - `requirements.txt`: Merged `api_gateway/requirements.txt` (added fastapi/uvicorn/pydantic/etc.); removed orphans (selenium/AWS/botocore/boto/s3transfer/jmespath, matplotlib/seaborn/statsmodels/yellowbrick/patsy/scikit-posthocs/cycler/kiwisolver, pandas/scipy/scikit-learn/sklearn/gensim/nltk/joblib/threadpoolctl/smart-open/trueskill, trio/trio-websocket/outcome/wsproto/async-generator/PySocks/sortedcontainers, Pillow/ffmpeg-python/pytz/sqlparse/python-multipart); unpinned stale transitives (importlib-metadata/zipp/h11); widened ranges (httpx>=0.26,<0.29; websockets>=13.0,<16); bumped security (certifi 2021.10.8→2024.7.4, idna 3.3→3.7, requests 2.26.0→2.32.3, urllib3 1.26.7→2.2.3).
  - `railway-requirements.txt`: Synced with root; removed unused blocks (Django/gunicorn/selenium, matplotlib/seaborn, ML stack, web automation); added bumps (aiohttp 3.8.3→3.11.11, python-multipart 0.0.6→0.0.18).
  - `api_gateway/requirements.txt`: Deleted (merged into root, resolving pre-existing websockets/httpx conflicts).
  - `environment/frontend_server/requirements.txt`: Deleted (unused Django cruft triggering false alerts).
  - `CLAUDE.md`: Updated install instructions to single `pip install -r requirements.txt`.
  - **Verification & fixes:** Repo-wide import greps + `pip check` confirmed zero direct uses for removed packages and transitive integrity; restored 3 missed transitives (tqdm/sortedcontainers/python-dateutil) via `pip check`; broke pyparsing deadlock by dropping matplotlib; no runtime impact (validated via 5+ clean sim runs). Net: Slimmer manifests, fewer alerts, stable deps.
---

## 2026-04-05 → 2026-04-08 — Nicolas — branch: nicolas

### Backend

- [x] **Unified location system (LocationResolver V2)**
   - `location_resolver.py`: Single 5-step pipeline replacing 12 resolution steps / 6 fallbacks / 2 repair passes. -4,500 lines of legacy code.
   - `maze_registry.json`: Structured map metadata (19 sectors, 63 arenas, 225 objects, 14 activity types). Replaces 500+ lines of regex heuristics.
   - `location_helpers.py`: Privacy, gender, distance utilities extracted from plan.py.
- [x] **ConversationManager — single conversation authority**
   - `conversation_manager.py`: `should_converse()` gate, atmosphere-aware proximity thresholds, cooldowns, path intersection detection, session state machine.
   - `greeting_generator.py`: Hardcoded greeting templates for acknowledge/passing paths.
- [x] **6 conversation pipeline bugs fixed**
   - `plan.py`: Chat state cleanup guard (chat_end_step, act_event, has_active_cm_session).
   - `reverie.py`: `0 or float('inf')` Python bug (9 instances), path intersection re-injection, proximity scan fixes.
   - `reflect.py`: Guard for chatting_with=None before get_last_chat().
   - `scratch.py`: Step-based chat (chat_end_step replaces datetime chatting_end_time).
- [x] **Pathfinding fixes**
   - `path_finder.py`: Bidirectional A*, object soft collisions (cost=10, gated behind `OBJECT_COLLISION_ENABLED`).
   - `execute.py`: Path waypoints truncated to MAX_TILES_PER_STEP+1, travel cap seconds→minutes fix.
- [x] **3 production playback bugs fixed**
   - `reverie.py`: proximity_threshold/detail added to Supabase JSONB write path.
   - `supabase_service.py`: `"%Y-%m-%d"` date format for curr_time, proximity fields in read extractor.
   - `double-front/hooks/useSimulation.ts`: localStorage.setItem isolated in own try/catch (2 places).
- [x] **Bootstrap redesign** — 15 personas with campus-coherent roles, gender, age, vague schedules for LLM freedom.

### Validation

- 5 sims run. Best: `20260407-200-15-mod-boot` (200 steps, 15p, 0 crashes, 0 tracebacks).
- Full report: `past-sims-reports/20260407-mod-boot/`
- Handoff: `realism/20260406-handoff-phase1-phase2.md`

---
## 2026-04-07 — Ivan — branch: local

### Backend

- [x] **Restore original Stanford paper reflection trigger (remove `ele_n >= 10` bypass)**
   - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Removed `importance_ele_n >= 10` OR-clause from `reflection_trigger()`. Reflection now fires only when the 150-point importance budget is depleted, matching the paper's design. The bypass (added in `ffd7b9e1`, Aug 2025 for cold-start) caused runaway reflection in chat-heavy sims — LLM calls/step grew from 23 to 83 over 960 steps in survival sim `20260406-3`.
- [x] **Remove fabricated 5-minute duration fallback in task decomposition**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Removed else-branch that injected tasks with made-up 5-minute durations when LLM output lacked `(duration in minutes:)` format. Unparseable lines are now skipped (original behavior). Improved parsing for valid formats (numbered prefixes, robust splitting) is retained.
- [x] **Fix simulation resume: Supabase bootstrap was destroying local state**
   - `reverie/backend_server/reverie.py`: Added resume guard in `_resolve_fork_folder()` — when `fork_sim_code == sim_code` and local `meta.json` exists, skip Supabase bootstrap entirely to preserve step counter, movement files, survival state, and scratch progression. Previously, `_bootstrap_missing_fork_from_supabase()` ran `shutil.rmtree()` on the folder and hardcoded `step: 0`.
- [x] **Fix survival state loss on resume: wire `SeasonState.load_from_file()`**
   - `reverie/backend_server/survival/controller.py`: Modified `initialize()` to check for saved `season_state.json` before creating fresh state. Added `_save_agent_states()` for local per-agent JSON persistence (at initialization, elimination, nightly recalibration, and game over). Added `_load_agent_states()` to restore per-agent states on resume. `SeasonState.load_from_file()` existed but was never called — now it is.

---

## 2026-04-06 — Ivan — branch: local

### Backend

- [x] **Survival Mode: support small-player / short-season games (4 players, 3 days)**
   - `reverie/backend_server/survival/challenges.py`: Lowered `limited_immunity` min_players from 3 to 2 so last-resort fallback works for 2-player endgames. Added missing fallback entries for `silent_pact` and `public_justification`. Fixed `alliance_lock_in` and `group_betrayal_game` fallbacks (were falling to `silent_pact` with same min_players=4, now fall to `limited_immunity` min=2). Added `_COMPACT_SCHEDULES` dict for total_days 3-5 with curated high-drama challenges appropriate for small player counts. Extended `get_challenge_for_day()` with `total_days` parameter — activates compact schedule only for short seasons, full 14-day schedule unchanged for standard sims.
   - `reverie/backend_server/survival/controller.py`: Updated `_get_today_challenge()` to pass `total_days` to `get_challenge_for_day()` for compact schedule selection.
- [x] **Fix survival DIRECTIVE catch-up for mid-day sim starts**
   - `reverie/backend_server/survival/controller.py`: Added `_first_step_done` flag and catch-up logic in `on_step()`. When the sim starts after the DIRECTIVE phase window (past 08:00), the directive is injected on the very first step regardless of current phase. Prevents silent survival-mode failure when `base_family_sim` starts at 09:00.
- [x] **Fix file_watcher step_number NameError**
   - `api_gateway/app/services/file_watcher.py`: Moved `step_number` extraction (via `_extract_step_number`) before its first use in the observations broadcast block. Previously, `step_number` was referenced at line 213 but only defined at line 227, causing `NameError` whenever `observations_processed` was non-empty.
- [x] **Always start new sims from today's date (date splicing)**
   - `reverie/backend_server/reverie.py`: Updated fork logic to set `start_date` to `datetime.now()` unconditionally (no env flag). Splices today's date with the baseline's time-of-day for `curr_time`, preserving the original hour/minute/second. Removed `SIM_USE_CURRENT_DATE` env flag.
- [x] **Persist survival state directory at initialization**
   - `reverie/backend_server/survival/controller.py`: Added `season.save_to_file(sim_folder)` call in `initialize()` so the `survival/` directory and `season_state.json` are written immediately, not deferred to NIGHT phase.
- [x] **Simulation analysis report: 20260406-3**
   - `environment/frontend_server/storage/20260406-3_report.md`: Comprehensive markdown report covering naturalness/realism (movement, conversations, action variety, 10 oscillation warnings), survival flow (Day 1 complete, Gosha eliminated, compact schedule working), and memory overload diagnosis (6.1x slowdown from 11,369 LLM calls scaling linearly with memory accumulation, poignancy evaluations = 49% of all calls).

## 2026-04-04

### Backend — Ivan — branch: local

- [x] **Survival Mode: Create 16 prompt templates for the 14-challenge system**
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_self_selected_teams_v1.txt`: Team A/B selection challenge
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_silent_pact_v1.txt`: Protect/Expose prisoner's dilemma with pair partner
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_secret_intel_drop_v1.txt`: Share/hoard intel with trust/credibility tradeoffs
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_whisper_chain_v1.txt`: Message relay with optional alteration
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_anonymous_accusation_v1.txt`: Anonymous accusation targeting
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_leader_nomination_v1.txt`: Leader nomination with rebound risk
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_alliance_lock_in_v1.txt`: Mutual alliance lock with reputation shield
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_public_justification_v1.txt`: Public vote with spoken justification
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_group_betrayal_game_v1.txt`: N-player cooperate/defect game
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_trial_night_v1.txt`: Acquit/convict verdict with public argument
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_energy_rationing_v1.txt`: Compete for full vote weight
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_shared_survival_pool_v1.txt`: Shared pool point-take game
   - `reverie/backend_server/persona/prompt_template/v2/survival_transfer_immunity_v1.txt`: Keep/gift immunity token decision
   - `reverie/backend_server/persona/prompt_template/v2/survival_trial_defense_v1.txt`: Trial target defense statement
   - `reverie/backend_server/persona/prompt_template/v2/survival_game_director_tiebreak_v1.txt`: Game Director tiebreak (Tier C, no persona)
   - `reverie/backend_server/persona/prompt_template/v2/survival_leader_penalize_v1.txt`: Leader penalty assignment

- [x] **Survival Mode: Full 14-challenge system implementation (Phases A-E)**
   - `reverie/backend_server/survival/rewards.py`: New — reward type registry (9 types), ActiveReward dataclass, apply/expire/query/transfer lifecycle
   - `reverie/backend_server/survival/state.py`: Extended SurvivalState with immunity_type, active_rewards, vote_weight, phantom_votes, reputation_shield_until; added update_reputation(); SeasonState gets winner/ended_day/status
   - `reverie/backend_server/survival/voting.py`: Weighted float vote tallying (vote_weights + phantom_votes params); 6-step resolve_tie_cascade (phantom → social_capital → reputation → days_survived → LLM Game Director → random)
   - `reverie/backend_server/survival/challenges.py`: Full rewrite — 14 challenge definitions in CHALLENGE_CATALOG, CHALLENGE_SCHEDULE (day→ID), 5 resolution dispatchers (individual, paired, group_vote, sequential, computed), 9 per-challenge scoring functions
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Parameterized challenge_decision (challenge_id + extra_context); added 5 new prompt functions (transfer_immunity, trial_defense, leader_penalize, game_director_tiebreak, game_director_evaluate)
   - `reverie/backend_server/persona/prompt_template/model_router.py`: Added 4 entries to TIER_B_TASKS, 1 to TIER_C_TASKS
   - `reverie/backend_server/survival/controller.py`: Challenge rotation (sequential/random/fixed), reward pipeline, transferable immunity flow, 4 collection methods (paired, sequential, group_vote, leader/trial followups), weighted voting integration, 6-step tiebreak cascade with optional LLM, auto-stop with winner declaration
   - `reverie/backend_server/reverie.py`: Updated SurvivalController config (new env flags), stop_simulation signal handler, _handle_survival_completion (writes COMPLETED.json + STATUS.json)
   - `reverie/backend_server/survival/__init__.py`: Added reward module exports
   - `.env.local`: Added SURVIVAL_CHALLENGE_ROTATION, SURVIVAL_TIEBREAK_USE_LLM, SURVIVAL_TRANSFERABLE_IMMUNITY_ENABLED, SURVIVAL_AUTO_STOP
   - `tests/test_survival_challenges.py`: New — 43 tests covering reward lifecycle, weighted tallying, tiebreak cascade, challenge schedule, scoring, auto-stop, state serialization, phase detection. All passing.

## 2026-04-03 — Ivan — branch: local

### Backend

- [x] **Survival Mode: Wire standalone module into simulation loop**
   - `reverie/backend_server/reverie.py`: Added `SURVIVAL_MODE_ENABLED` env flag, `SurvivalController` init after persona loading, step hook in `start_server()` before cognitive pipeline, post-step elimination handler with maze cleanup
   - `reverie/backend_server/persona/memory_structures/scratch.py`: Added `self.survival = {}` field with full serialization (init, bootstrap load, `_save_to_json`, `_to_json_dict`, `_load_from_dict`)
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Added 3 survival prompt functions — `run_gpt_prompt_vote_decision`, `run_gpt_prompt_challenge_decision`, `run_gpt_prompt_final_statement` with `_format_survival_state_for_prompt` helper
   - `reverie/backend_server/persona/prompt_template/model_router.py`: Registered 3 survival functions in `TIER_B_TASKS`
   - `reverie/backend_server/survival/controller.py`: Wired 3 placeholder hooks to actual LLM calls via lazy import pattern — `_collect_challenge_decisions`, `_collect_vote_decisions`, `_broadcast_elimination` (with Supabase memory injection)
   - `reverie/backend_server/persona/prompt_template/v2/survival_vote_decision_v1.txt`: New prompt template
   - `reverie/backend_server/persona/prompt_template/v2/survival_challenge_decision_v1.txt`: New prompt template
   - `reverie/backend_server/persona/prompt_template/v2/survival_final_statement_v1.txt`: New prompt template

---

## 2026-03-30 / 2026-03-31 — Nicolas — branch: integration/20260330-local-hardening-rebuild

### Backend — Runtime hardening rebuild (incremental port from stabilization branch onto client's `local` base)

**Note:** `stabilization/20260329-simulation-runtime-hardening` was used as reference/source for architectural patterns and validated designs, but was not merged directly. All fixes were reimplemented incrementally on `local` base with per-commit validation. The stabilization branch remains available for future architectural reference.

- [x] **Occupancy system port (`spatial_occupancy.py`, `execute.py`)**
   - `spatial_occupancy.py`: Complete new file (584 lines) — semantic tile selection, zone settlement, occupancy target derivation, arrival state machine, stationary plan preservation
   - `execute.py`: Wired occupancy module — semantic zone detection replacing geometric bbox, settle-or-move-to-anchor logic, address specificity filtering
   - `utils.py`: Added `is_collision_cell()` and `is_walkable_cell()` for consistent collision grid interpretation
   - 26 standalone occupancy tests passing

- [x] **Schedule lifecycle fixes (`reverie.py`, `plan.py`)**
   - P2 extension infinite loop: removed counter reset in `action_switch_noop` branch
   - Schedule advance guard: `schedule_has_next_action` check blocks extension when next sub-action differs
   - Proactive refresh: sets `force_replan_next_step = True` when refresh fires
   - Repeat count: clean reset to 0 on signature change (was decaying)
   - Intent hold: freshness update + max age (15 steps)
   - Refresh randomization: ±2 steps per persona to prevent synchronized bursts

- [x] **Location resolution hardening (`plan.py`, `spatial_grounding_typed.py`)**
   - Deterministic guards: shower → bathroom, exercise → park, sleep → bed
   - Gender filter in filtered location tree
   - Semantic rules in LLM location template
   - Grid-backed spatial memory init (personas see all 307+ maze addresses)
   - Post-decomp address validation (defense in depth)
   - `spatial_grounding_typed.py`: Complete port (684 lines) — deterministic token-scoring location resolution without LLM
   - Maze Supabase fallback to local CSV when empty

- [x] **Movement authority (`execute.py`, `reverie.py`)**
   - Movement origin unification (12 callsites → `_movement_origin_tile()`)
   - Distance guard for unreachable destinations
   - A* collision-aware speed clamp (replaces linear interpolation)
   - Stationary intent authoritative: skip `zone_patrol` when `stationary_intent=True`
   - A* candidate pruning by Manhattan lower-bound

- [x] **Conversations enabled (`reverie.py`, `persona.py`, `plan.py`)**
   - Backend proximity detection (Manhattan ≤ 3 tiles, pairwise scan)
   - Tier-aware cooldowns (greeting 3 steps, full chat 20 steps)
   - Chat buffer fix: disabled plan-path legacy, unified cooldown constants
   - Chat state preservation during active chat_queue
   - Gateway storage path fix for cross-platform (Windows path on Mac)
   - Greeting bubble duration: character-based (`len(text)/15`)

- [x] **Object-level spatial precision (`execute.py`, `spatial_occupancy.py`)**
   - Object-tile snap: personas land ON game_object tile, not adjacent
   - Anchor radius by address depth (4-part = exact, 3-part = radius 1)
   - Alternative object fallback when target tile is occupied

- [x] **Speed & spawn realism (`reverie.py`)**
   - Speed preservation across spawn points
   - Waypoint scaling for running personas

- [x] **Test infrastructure**
   - 117 tests passing, 10 skipped (features not ported)
   - Ported from stabilization: movement mode, stall breaker, collision, occupancy tests
   - New tests: stasis bugs, P2 extension lifecycle, schedule advance, proactive refresh, location semantic rules, address validation, chat buffer, proximity chat state, stationary override, duration cupos, grid memory init, phantom social guard

### Validation

- [x] **14 local sim iterations (v21-v33)** — incremental validation after each major port
- [x] **Sim 20260331-1 (60 steps, OpenAI, Supabase + headless)** — first full-stack validation
- [x] **Sim 20260331-3 (200 steps, OpenAI, Supabase + headless)** — full assessment run. Report at `past-sims-reports/20260331-3/`

---


## 2026-04-03 — Ivan — branch: local

### Backend

- [x] **Survival Mode — standalone module (`reverie/backend_server/survival/`)**
   - `survival/state.py`: `Phase` enum (7 phases), `get_current_phase()` time-based detection, `SurvivalState` per-agent class (trust/grudge/perceived_threat dicts, social_capital, reputation, immunity, alliances, vote history, nightly decay), `SeasonState` global class (day tracking, eliminations, challenge results, alliance log), Supabase persistence via `dbl_store_memory_dev`, file persistence for season state
   - `survival/challenges.py`: `Challenge` dataclass, `CHALLENGE_CATALOG` with Limited Immunity archetype, `resolve_challenge()` — handles claims, nominations, social_capital ranking, perceived_threat tiebreak, immunity assignment
   - `survival/voting.py`: `VoteDecision`/`EliminationResult` dataclasses, `tally_votes()` — immunity voiding, absence penalties (+1 phantom vote), tie detection, `resolve_tie_simple()` algorithmic fallback (lowest social_capital eliminated)
   - `survival/controller.py`: `SurvivalController` phase state machine, `on_step()` single integration hook, spatial gate detection (80% threshold at Hobbs Cafe), daily directive injection via `user_interactions["global"]["goal_modification"]["daily_plan"]`, day boundary detection, nightly recalibration with decay + persistence, 4 placeholder hooks for LLM wiring
   - `survival/__init__.py`: re-exports

- [x] **Survival Mode — design playbook (`double-ivan/concept/survival/survival_playbook.md`)**
   - Comprehensive 17-section playbook covering design philosophy, season structure (15 players, 14 days), day loop (7 phases with step-time mapping), Game Director architecture, challenge system, alliance mechanics, voting/elimination, state model, implementation architecture, prompt engineering (vote/challenge/final-statement templates), gathering mechanics (Hobbs Cafe 96 tiles), LLM cost model (~750K tokens/season), frontend integration, narrative output, validation plan, post-MVP roadmap

- [x] **CLAUDE.md correction: SIM_STEP_LENGTH**
   - `CLAUDE.md`: Fixed `SIM_STEP_LENGTH` description from "Simulated minutes per step" to "Simulated seconds per step (60 = 1 min; 1 day = 1 440 steps)"

- [x] **Video Trailer Pipeline — full backend package (`reverie/backend_server/video/`)**
   - `video/__init__.py`: package init
   - `video/extract_day_log.py`: Supabase data extraction — queries `dbl_get_sim_memories`, `get_all_step_positions`, `load_persona_scratch`, assembles `day_log` JSON with timeline, conversations, reflections, highlight_stats. CLI: `python -m reverie.backend_server.video.extract_day_log <sim_code> <persona>`
   - `video/showrunner.py`: Showrunner LLM — system/user prompt for 60s trailer script, JSON schema validation, retry on invalid output, routes through `GPT_request` (Tier C) with direct OpenAI fallback. CLI: `python -m reverie.backend_server.video.showrunner <day_log.json>`
   - `video/record_scenes.py`: Playwright auto-recording — per-scene browser context with `record_video_dir`, applies camera directives via `window.__*` Director API, plays step range via `__executeMovementsForStep`, outputs WebM per scene. CLI: `python -m reverie.backend_server.video.record_scenes <sim_code> <script.json>`
   - `video/compose_trailer.py`: FFmpeg compositing — concat scenes, mix narration+music (ducked), generate SRT from script, burn subtitles, crop 16:9 → 9:16. CLI: `python -m reverie.backend_server.video.compose_trailer <trailer_dir>`
   - `video/tts.py`: TTS narration — ElevenLabs REST API (voice cIO62fcmCSQhE0DE2WS2, stability=0.65, clarity=0.75, style=0.40) + OpenAI tts-1-hd fallback (voice "onyx", speed=0.9). Parses `[PAUSE Ns]` and `[SCENE N]` markers, renders text segments individually, generates silence via FFmpeg, concatenates. CLI: `python -m reverie.backend_server.video.tts <script.json>`
   - `video/generate_trailer.py`: End-to-end CLI orchestrator — runs extract → showrunner → TTS → record → compose. TTS step with graceful fallback (continues without narration on failure). Mood-matched music selection (`music_{mood}.mp3` priority). CLI: `python -m reverie.backend_server.video.generate_trailer <sim_code> <persona>`
   - `video/showrunner.py` (validation additions): FR-2.7 silence marker enforcement (≥1 `[PAUSE Ns]`), FR-2.8 dialogue cap (max 2 excerpts) and subtitle card cap (max 3 including end card)
   - `video/compose_trailer.py` (end card): `generate_end_card()` using FFmpeg drawtext filter — white text on black, no image library dependency. Pipeline updated: concat scenes → append end card → combine video+audio → subtitles → 9:16 crop

## 2026-04-02 / 2026-04-03 — Nicolas — branch: integration/20260330-local-hardening-rebuild → merged to local

### Backend — Checkpoint 1: 6 bug fixes (all validated in 200-step full Supabase sim)

- [x] **Item A — Greeting → full chat escalation (`reverie.py`)**
   - `reverie.py:1242`: Added `pair_greeting_counts` dict to ReverieServer for tracking greetings per pair
   - `reverie.py:7068-7075`: After `classify_chat_tier` returns "greeting", checks if pair has ≥1 prior greeting → promotes to "full". Counter resets after full chat.
   - Result: Greeting at step 8 → full conversation at step 11. 3 pairs converse across 200 steps.

- [x] **Item B — Wrong bed / private room access (`plan.py`)**
   - `plan.py:2566-2576`: Extracted `_is_private_room()` and `_is_private_sector()` helpers from inline logic
   - `plan.py:1557-1565`: Added privacy filter to `_resolve_anchor_to_address()` — skips private sectors/arenas that don't belong to the persona
   - `plan.py:1642`: Added privacy filter to `_candidate_addresses_for_typed_grounding()` with new `persona` param
   - `plan.py:4521-4538`: Added action contract validation — rejects private-room destinations from wrong persona
   - Result: 0 Studio Room violations in 200 steps. Ivan correctly goes to own Dorm Room 1.

- [x] **Item C — Duration overflow on travel feasibility (`plan.py`)**
   - `plan.py:4942-4948`: Cap `needed_min` to maze physical limits before travel extension: `(maze_width + maze_height) / MAX_TILES_PER_STEP * 1.5` = 60 min max travel
   - Result: 0 actions >300 min (was 310 in baseline, max 1487 min). Max duration now 159-180 min.

- [x] **Item D — Social descriptions detached from reality (`plan.py` + prompt templates)**
   - `plan.py:256-305`: Added `_strip_social_refs()` with location-aware replacements ("chatting with friends at cafe" → "having coffee at cafe") and `_filter_schedule_social_refs()` for daily schedule entries
   - `plan.py:598, 827, 1103`: Applied label sanitization at 3 call sites in decomp pipeline
   - `plan.py:4238-4261`: Post-filter on `daily_req` and `f_daily_schedule`
   - `v2/daily_planning_v6.txt`, `v3_ChatGPT/daily_planning_v6.txt`: Anti-social rules (don't name other people)
   - `v3_ChatGPT/generate_hourly_schedule_v2.txt`: Activity rules (describe what persona is DOING, not social interactions)
   - `v2/task_decomp_contextual_v1.txt`: Label must describe a GOAL, not a social interaction
   - Result: 0 social descriptions without active chat in 200 steps.

- [x] **Item E — Object relocation / settlement fixes (`execute.py`, `plan.py`, `spatial_occupancy.py`)**
   - `execute.py:2027-2048`: Settlement override — verifies `curr_tile` is in `maze.address_tiles[act_address]` before allowing settlement on object-level addresses. Falls through to `_find_alternative_object_tile()` if not.
   - `plan.py:5162-5175, 5710-5722`: Aligned `anchor_radius=0` for object-level addresses in both planning sites (initial action + continuation transitions). Matches execute.py behavior.
   - `plan.py:5038-5046`: Removed ±2 padding from `target_zone` for object-level addresses. Prevents zones from extending outside arena boundaries.
   - `spatial_occupancy.py:658`: Added "stationary" to settlement recovery branch — prevents deadlock when persona is stationary + in_zone + not settled.
   - Result: Katya correctly reaches cafe seating. Gosha finds alternative library table chair.

- [x] **Item F — Greeting bubble duration (`persona.py` + FE `SpeechController.tsx`)**
   - `persona.py:789-801`: Populate `per_message_duration` and `timestamps` in `chat_metadata` for greeting tier (was empty → FE used fallback). 6s minimum floor per message.
   - FE `components/SpeechController.tsx:450`: Fixed `if (line.timestamp && line.timestampEnd)` → `if (line.timestamp !== undefined && line.timestampEnd !== undefined)`. `timestamp: 0` is valid but falsy in JS.
   - Result: Greeting bubbles display at readable duration.

### Validation

- [x] **Sim 20260403-3 (200 steps, full Supabase + OpenAI)** — all 6 items validated. Report at `past-sims-reports/20260403-3/`
- [x] **Sim 20260403-final (180 steps, post-merge with Ivan's local)** — 0 regressions. Report at `past-sims-reports/20260403-final/`
- [x] **Sim 20260403-merged (40 steps, verification after merge to local)** — clean, 0 bugs

---


## 2026-04-01

### Backend

- [x] **Remove gender from dorm bathroom names in all assets and code**
   - `environment/frontend_server/static_dirs/assets/the_ville/matrix/special_blocks/arena_blocks.csv`: Renamed arena IDs 32143/32153 from "man's bathroom"/"woman's bathroom" to "bathroom 1"/"bathroom 2"
   - `reverie/backend_server/address_mapper.py`: Removed hardcoded `"woman's bathroom"` entry from `location_mappings`
   - `scripts/diagnose_zone_clustering.py`: Updated `ARENA_NAMES` labels for IDs 32143/32153
   - `scripts/suggest_villa_careers.py`: Updated `_EXCLUDE_EMPLOYMENT_RULES` to match new arena names

## 2026-03-31

### Backend

- [x] **Add `/card-summary` endpoint for Sprite Detail Card redesign**
   - `api_gateway/app/services/card_summary_transforms.py`: New module — pure derived-field formatting (location readable transform, header, overview derived, day section, talk section, conversation excerpt, envelope).
   - `api_gateway/app/services/card_summary_service.py`: New module — LLM orchestration with AsyncOpenAI (Tier A / gpt-5-nano), 3 parallel prompt calls (overview, story, social), in-memory LRU cache keyed by action description, null-safe section defaults for graceful degradation.
   - `api_gateway/app/api/routes/simulations.py`: Added `GET /{sim_code}/personas/{persona_name}/card-summary` route with Cache-Control headers, 404/503/500 error handling.
   - `api_gateway/app/core/config.py`: Added LLM config fields (openai_api_key, llm_model_tier_a, cache TTL/max size).
   - `api_gateway/app/core/exceptions.py`: Added `PersonaNotFoundError`, `LLMServiceUnavailableError` with handler cases.
   - `api_gateway/requirements.txt`: Added `openai>=2.21.0`.

- [x] **Add `POST /chat` endpoint for Chat with Double (v1)**
   - `api_gateway/app/services/chat_with_double_service.py`: New module — main service with user message embedding (text-embedding-3-small → 768-d stride-2 compression), pgvector memory retrieval via `dbl_retrieve_memories_dev` RPC (auth-bypassing SECURITY DEFINER variant) with recency fallback (`dbl_get_recent_memories`), persona ISS-based prompt assembly, Tier C LLM call (gpt-5.2, max_completion_tokens=8000), thread persistence via 5 `chat_*` RPCs in `public` schema (double schema not exposed to PostgREST), 25 msg/thread cap, 2 threads/hour rate limit. JSONB string-parse guard on `dbl_retrieve_memories_dev` response.
   - `api_gateway/app/api/routes/simulations.py`: Added `POST /{sim_code}/personas/{persona_name}/chat` route with 400/404/503/500 error handling.
   - `api_gateway/app/core/config.py`: Added `llm_model_tier_c` config field.
   - `api_gateway/app/models/simulation.py`: Added `ChatMessageRequest` Pydantic model with `field_validator` normalizing Swagger UI's literal `"null"`/`"string"` → `None` for `thread_id`.
   - `supabase/migrations/20260331000001_chat_with_double.sql`: New migration — `user_chat_threads` and `user_chat_messages` tables in `double` schema + 5 `chat_*` RPCs in `public` schema with SECURITY DEFINER.

## 2026-03-30

### Backend

- [x] **Fix bootstrap crash on Nicolas's stabilization branch and comparative assessment**
   - `reverie/backend_server/reverie.py`: Removed `act_address`, `act_description`, `act_start_time`, `act_duration` from `_bootstrap_missing_fork_from_supabase()` Supabase query and scratch.json output — aligned with working `local` branch. Root cause: bootstrap wrote non-None `act_address` without `act_event`, causing `get_curr_event_and_desc()` to return `(None,...)` and crash perceive.py.
   - `environment/frontend_server/storage/20260330-3/20260330-3_report.md`: Realism report for stabilization branch sim (score: 4.7/10). 19 `destination_unresolved` events, tile-bounce oscillation, zero conversations.
   - `D:\Coding\double-docs\realism\20260329_runtime_stabilization_handoff.md`: Added comparative validation section (20260330-1 vs 20260330-3) and comprehensive TODO integration plan. Revised recommendation: use `local` branch as base, cherry-pick Nicolas's movement/spatial modules. Do NOT port his plan.py rewrite (overwrites LLM location fixes).

- [x] **Harden anchor pipeline: eliminate fictional location names from LLM decomp/resolution**
   - `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt`: Replaced 3 fictional few-shot "Planned place:" examples (campus loop, Oak Hill study carrel, dorm kitchenette, park bench) with real maze names verified against game_object_blocks.csv and arena_blocks.csv.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Extracted `_build_filtered_location_tree(persona, maze)` shared helper from `generate_action_location()` so decomp prompt and location resolution LLM see identical privacy-filtered locations. Added `_build_anchor_name_set()` and `_validate_and_correct_anchor()` for post-decomp anchor validation with fuzzy token matching. Integrated into `_validate_contextual_subactivities()` — fictional anchors are corrected to nearest real name or stripped to `local_anchor`. Social_touch mode anchors (persona names) are exempted.
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Updated `_build_location_tree_for_prompt()` to accept pre-built filtered tree. Updated `run_gpt_prompt_task_decomp_contextual()` and repair variant to thread `filtered_tree_str` from shared builder.
   - Config flags: `ANCHOR_FILTER_TREE_ENABLED` (default true), `ANCHOR_VALIDATION_ENABLED` (default true) — both reversible.
   - Root cause: 3 independent sources — (1) prompt template taught fictional names as examples, (2) decomp tree was unfiltered vs location resolution's filtered tree, (3) no post-LLM anchor validation against real location names.
   - `D:\Coding\double-docs\realism\6.llm+contract.md`: Updated Section 5 (Implementation Plan) — marked 5A-5G as DONE with implementation dates and validation results, added 5H (perceive boundaries), 5I (distance-aware contracts), 5J (tile exclusivity) as TODO items assigned to Nicolas.

## 2026-03-29

### Backend

- [x] **Ground decomp anchors in real map locations to fix 10% location misresolution rate**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Added `_build_location_tree_for_prompt(persona)` helper that reads the persona's spatial memory tree and produces a compact text listing of accessible sectors, arenas, and objects. Appended as INPUT 4 to `run_gpt_prompt_task_decomp_contextual` and INPUT 6 to `run_gpt_prompt_task_decomp_contextual_repair`.
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_v1.txt`: Added "Available locations" section with INPUT 4; changed anchor instruction from unconstrained "short anchor string" to "a specific arena or object name from the available locations above. Do NOT invent location names."
   - `reverie/backend_server/persona/prompt_template/v2/task_decomp_contextual_repair_v1.txt`: Same location tree and anchor instruction changes (INPUT 6).
   - `D:\Coding\double-docs\sot\sot_prompts.md`: Updated governance entries for both functions to note new input contract.
   - Root cause: decomp LLM had zero visibility into map locations, producing fictional anchors ("dorm entrance", "mini_kitchenette", "reference desk") that the location LLM (gpt-5-nano) could not reliably resolve. Gender bathroom issue was a symptom — Ivan's spatial memory contains only "man's bathroom", never "woman's bathroom", so map-grounded anchors eliminate cross-gender misresolution automatically.

## 2026-03-27

### Backend

- [x] **Spatial Grounding: Transition Fallback Hardening**
  - `plan.py`
  - contextual decomp fallback is now explicit and noisy instead of quietly
    disappearing into legacy behavior
  - transition fallback now records:
    - fallback reason
    - fallback kind
    - transition fallback count
    - runtime tags for postmortem traceability
  - transition fallback now synthesizes a deterministic
    `prepare -> travel -> arrive`
    plan and routes it back through the contract bridge when a destination can
    be resolved

- [x] **Spatial Grounding: No-Supabase Live Validation**
  - contract-aware transition soak completed:
    - Katya `10/10`
    - Gosha `10/10`
    - Luba `10/10`
  - artifact:
    - `generative_agents-local/tmp/transition_live_contract_probe_soak.json`

- [x] **Spatial Grounding: Artifact-Driven Probe Run**
  - full DB-free probe run completed against:
    - `planning_cache`
    - `scratch.json`
    - `spatial_memory.json`
  - result:
    - `26/29` pass
  - only remaining red probes:
    - `katya_walk_to_library_from_planning_cache`
    - `gosha_heading_to_library_from_planning_cache`
    - `luba_prepare_commute_to_hobbs_from_planning_cache`
  - interpretation:
    - raw coarse hourly row -> location remains a weak diagnostic for
      transition tasks
    - the main contract-aware path is materially healthier than before

- [x] **Upgrade supabase-py to 2.28.3 to support new non-JWT key format**
   - `requirements.txt`: Pinned `supabase==2.28.3` (was `>=2.5.1`) and `websockets>=13.0` (was `==12`). v2.28.3 removed the hard-coded JWT regex check in `_sync/client.py` that rejected the new `sb_publishable_*` / `sb_secret_*` key format, eliminating the "Invalid API key" startup failure.
   - `api_gateway/requirements.txt`: Pinned `supabase==2.28.3` (same change).
   - Removed stale `gotrue 2.9.1` and `supafunc 0.6.0` packages from the venv — both are superseded by `supabase-auth 2.28.3` and `supabase-functions 2.28.3` shipped with the new client.
   - Validation: `api_gateway/app/core/supabase_client.py` `health_check()` now returns `supabase_connected: true`; API gateway starts cleanly with no Supabase fallback warning.

- [x] **Harden transition-row grounding regressions + validate the realistic DB-free path**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added a narrow private-home-room preference in `_resolve_anchor_to_address(...)` so generic anchors such as `dorm room` / `bedroom` stay inside the persona's own room instead of drifting to `common room table` through generic token matching and longer-path tie-breaks.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Hardened `_normalize_decomp_rows(...)` so when an over-cap contextual decomp ends in a destination-bearing trailing `zone_patrol` row, normalization preserves that final travel row instead of silently squashing it into a merged overflow tail. Overflow collapse now degrades to plain tagged text instead of carrying stale structured contracts.
   - `tests/test_spatial_grounding_regressions.py`: Added 3 new red-first regressions for (1) `dorm room` misgrounding to `common room table`, (2) trailing destination-travel preservation under `TASK_DECOMP_MAX_SUBTASKS`, and (3) transition-style hourly rows retaining at least one destination-bearing `zone_patrol` subactivity after contextual decomposition.
   - Validation: `python3 tests/test_spatial_grounding_regressions.py`, `python3 tests/test_spatial_grounding_contract.py`, `python3 tests/test_spatial_grounding_runtime_bridge.py`, `python3 api_gateway/tests/test_action_contract.py`
   - Targeted live DB-free validation artifact: `generative_agents-local/tmp/targeted_live_validation_post_hardening.json`
   - Live findings: the `dorm room` fix now holds in the realistic path, and Katya/Gosha transition rows now decompose into origin prep plus a preserved destination-bearing library travel phase. Remaining follow-up is narrower: Luba's commute-prep row still invents weak anchors such as `bus stop`, and generic local anchors such as `desk` may still resolve to the wrong dorm room without an explicit home-room signal.

## 2026-03-26

### Backend

- [x] **Spatial grounding cleanup / hardening pass — explicit contract downgrade + contract-first runtime projection**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Removed the silent contextual planner fail-open from structured contract to legacy tagged transport. `build_action_contract(...)` downgrade now happens only on explicit contract-validation `ValueError`s, with a warning log, task-decomp observability counters (`contract_downgrade_count` + reason buckets), and runtime tags (`contextual_contract_downgrade`, reason-specific tag) so the fallback is visible and diagnosable.
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Follow-up hardening also split the later planner-side `_build_planner_action_contract(...)` fallback in `_determine_action()` into two explicit paths: validation downgrade (`ValueError`) vs unexpected build error (`Exception`). Each now has distinct planner-contract observability counters/reason buckets and distinct runtime tags (`planner_contract_downgrade*` vs `planner_contract_error*`) so the planner no longer collapses those cases into the same broad fallback.
   - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`, `reverie/backend_server/persona/memory_structures/scratch.py`: Added shared contract-payload projection so `partial_state.action_progress` is populated from the canonical contract payload first instead of manually rebuilding `current_action` / `resolved_address` / `action_description` / `action_id` piecemeal from legacy mirrors.
   - `api_gateway/app/core/action_contract.py`: Tightened API normalization to prefer explicit `resolved_address` over stale `current_action` when both are present but disagree.
   - `tests/test_spatial_grounding_contract.py`, `tests/test_spatial_grounding_regressions.py`, `tests/test_spatial_grounding_runtime_bridge.py`, `api_gateway/tests/test_action_contract.py`: Added deterministic coverage for persisted contract projection, explicit contextual downgrade traceability, explicit planner-side validation downgrade vs unexpected error traceability, contract-first runtime bridge payloads, and API preference for `resolved_address`.
   - Validation: `python3 tests/test_spatial_grounding_contract.py`, `python3 tests/test_spatial_grounding_regressions.py`, `python3 tests/test_spatial_grounding_runtime_bridge.py`, `python3 api_gateway/tests/test_action_contract.py`, `python3 -m unittest tests.replay.test_llm_replay_utils -v`, `python3 -m unittest tests.replay.test_replay_from_docs -v`, `python3 -m unittest tests.replay.test_location_monitor -v`, `python3 -m unittest tests.replay.test_planning_cache_replay -v`, `OPENAI_API_KEY=test-key python3 scripts/replay/replay_from_docs.py 20260326-1 --docs-repo /Users/nicolasdemaria/Desktop/animated-angents/double-docs/past-sims-reports --steps 1 --timeout-sec 120`, `python3 -m py_compile reverie/backend_server/persona/cognitive_modules/action_contract_v1.py reverie/backend_server/persona/cognitive_modules/plan.py reverie/backend_server/persona/memory_structures/scratch.py api_gateway/app/core/action_contract.py`

- [x] **Restore replay compatibility for `action_location_unified` after upstream prompt changes**
   - `reverie/backend_server/persona/prompt_template/llm_replay.py`: Narrowed the replay hash for `run_gpt_prompt_action_location_unified` to the stable dynamic inputs of that prompt (`persona lives at`, location tree, final activity, time), while ignoring the function-specific system prompt and static rules/examples scaffold. This preserves strict matching for the actual location decision inputs without letting the `persona_base` → `action_decision` remap and expanded prompt template break historical cassettes.
   - `tests/replay/test_llm_replay_utils.py`: Added deterministic coverage for legacy-vs-current location prompt scaffolding drift, dynamic-input strictness, and an end-to-end replay-session match across the old and new request shapes.
   - Validation: `python3 -m unittest tests.replay.test_llm_replay_utils -v`, `python3 -m unittest tests.replay.test_replay_from_docs -v`, `python3 -m unittest tests.replay.test_location_monitor -v`, `python3 -m unittest tests.replay.test_planning_cache_replay -v`, `OPENAI_API_KEY=test-key python3 scripts/replay/replay_from_docs.py 20260326-1 --docs-repo /Users/nicolasdemaria/Desktop/animated-angents/double-docs/past-sims-reports --steps 1 --timeout-sec 120`

- [x] **Recalibrate realism analyzer thresholds for 1-minute step duration**
   - `tests/analyze_sim_realism.py`: `SIM_STEP_LENGTH=60` is 60 *seconds* (1 min/step), not 60 minutes. All analyzer thresholds were calibrated for much longer steps, producing false positives on normal behavior.
   - `PLAN_STALL_MAX_RUN`: 15 → 90 (flag >90 min stalls, not >15 min)
   - `OSCILLATION_WINDOW`: 6 → 30 (check 30-min windows, not 6-min)
   - `STATIONARY_CLUSTER_STEPS`: 50 → 120 (check first 2 hours, not 50 min)
   - Added settlement filter to oscillation detector: if most-common position accounts for ≥75% of a run, it's travel+settle (not oscillation). Eliminates false flags on sprites traveling to a destination then sitting still.
   - Result: 20260326-3 goes from 8 issues (4 oscillation, 3 plan stall, 1 stationary cluster) → 0 issues.

- [x] **Reporting-layer localization pass — exported artifact pointers + monitor traceability summary**
   - `reverie/backend_server/persona/cognitive_modules/location_monitor.py`: Added a compact `traceability` block to per-persona monitoring step artifacts, derived from existing movement/environment data. It now exports source artifact refs, selected contract fields, high-value runtime reason codes already present in movement artifacts, and narrow localization signals such as `validation_corrected_ai_address`, `payload_address_label_differs_from_action_progress`, and `environment_address_mismatch`. Also added step-level `traceability_summary` and fixed the misleading `recent_mismatches` monitor summary count.
   - `tests/analyze_sim_realism.py`: `summary.json` exports now include a top-level traceability note plus per-issue `localization_hint` metadata (`classification`, `diagnostic_bucket`, `layer_hint`, `source_artifacts`) so analyzer output points reviewers to the right artifact files immediately.
   - `tests/replay/test_location_monitor.py`, `tests/test_analyze_sim_realism_exports.py`: Added focused regression coverage for monitor traceability export, summary aggregation, and analyzer localization hints.
   - Validation: `python3 -m unittest tests.replay.test_location_monitor -v`, `python3 -m unittest tests.test_analyze_sim_realism_exports -v`, `python3 -m py_compile reverie/backend_server/persona/cognitive_modules/location_monitor.py tests/analyze_sim_realism.py tests/replay/test_location_monitor.py tests/test_analyze_sim_realism_exports.py`

- [x] **Replay reporting hardening — persist replay summary + mismatch diagnostics in docs bundles**
   - `reverie/backend_server/persona/prompt_template/llm_replay.py`: Replay matcher mismatches now export structured diagnostic JSON when `LLM_REPLAY_DIAGNOSTICS_DIR` is set. The detail artifacts keep the high-signal postmortem fields needed later in docs bundles: `reason_code`, `source_layer`, `function_name`, `persona`, `step`, `source_artifact`, concise `expected`/`actual` summaries, and prompt-request payloads for hash drift cases.
   - `scripts/replay/replay_from_docs.py`: Replay-from-docs now writes `replay/summary.json` into the source docs bundle and points it at `replay/mismatches/`. The summary records replay status (`passed` / `failed` / `timeout` / `setup_failed`), counts, source-layered diagnostics, artifact pointers, failure lines, and console tail so postmortems no longer depend on terminal output alone.
   - `tests/replay/test_llm_replay_utils.py`, `tests/replay/test_replay_from_docs.py`: Added deterministic coverage for matcher diagnostic artifact export plus success/failure replay summary generation in docs-bundle paths.
   - Validation: `python3 -m unittest tests.replay.test_llm_replay_utils -v`, `python3 -m unittest tests.replay.test_replay_from_docs -v`, `python3 -m py_compile reverie/backend_server/persona/prompt_template/llm_replay.py scripts/replay/replay_from_docs.py`, `OPENAI_API_KEY=test-key python3 scripts/replay/replay_from_docs.py 20260326-1 --docs-repo /Users/nicolasdemaria/Desktop/animated-angents/double-docs/past-sims-reports --steps 1 --timeout-sec 120`

- [x] **Spatial grounding reconstruction: canonical current-action contract + replay validation**
   - `reverie/backend_server/persona/cognitive_modules/action_contract_v1.py`: Added `ActionContractV1` as the canonical backend current-action record (`action_id`, `action_description`, `duration_min`, `subactivity_mode`, `anchor_text`, `resolved_address`, `resolution_source`) plus semantic helpers for lifecycle continuity and non-sleep/bed validation
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Planner now carries structured action contracts out of contextual decomposition, uses `resolved_address` directly on the happy path, avoids the second semantic location decision when structured intent already resolved the destination, and keeps deterministic semantic repair/validation on the legacy fallback path
   - `reverie/backend_server/persona/memory_structures/scratch.py`: Persist `act_action_id` and `current_action_contract`; `calculate_action_progress()` now prefers canonical contract payload over legacy `act_description` / `act_address` mirrors
   - `api_gateway/app/core/action_contract.py`, `api_gateway/app/services/file_service.py`, `api_gateway/app/services/supabase_service.py`: `/step` and `/details` now prefer `current_action_contract` over stale scratch mirrors, including the Supabase-backed details path
   - `tests/test_spatial_grounding_contract.py`, `tests/test_spatial_grounding_regressions.py`, `tests/test_spatial_grounding_runtime_bridge.py`, `api_gateway/tests/test_action_contract.py`: Added contract, planner-boundary, runtime-bridge, and API normalization regression coverage for the new canonical action/address flow
   - `reverie/backend_server/persona/prompt_template/llm_replay.py`, `reverie/backend_server/persona/cognitive_modules/planning_cache.py`, `scripts/replay/replay_from_docs.py`, `tests/replay/test_llm_replay_utils.py`, `tests/replay/test_planning_cache_replay.py`, `tests/replay/test_replay_from_docs.py`: Added replay compatibility for the contract-first planner flow, preserved stale recorded planning cache in replay mode, and validated end-to-end replay smoke for `20260326-1`
- [x] **Phase 6B: Fix location LLM prompt — expanded rules, examples, and system prompt**
   - `reverie/backend_server/persona/prompt_template/prompt_fragments.py`: Map `run_gpt_prompt_action_location_unified` to `action_decision` system prompt instead of falling through to `persona_base` roleplay prompt
   - `reverie/backend_server/persona/prompt_template/v1/action_location_unified_v1.txt`: Restructured rules into PRIORITY/FALLBACK chain — explicit location in action text ("at the library") takes priority over activity-type inference. Expanded activity-type fallbacks from 3 to 8 categories. Added negative bed rule. Added 4 new few-shot examples including "sketching at the library → library" to override creative→desk default when location is explicit.
   - Root cause: gpt-5-nano with minimal reasoning was pattern-matching 3 examples and defaulting to bed for anything unrecognized. Post-fix regression: "sketching at Oak Hill College library" went to desk because creative work rule fired before "at the [place]" rule. Fixed via PRIORITY/FALLBACK structure.

- [x] **Fix parenthetical stripping in location prompt builder — preserve decomp context**
   - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Remove lines 1729–1732 in `run_gpt_prompt_action_location_unified`'s `create_prompt_input` that blindly stripped all parenthetical content from action descriptions before sending to the location LLM
   - Root cause: decomp produces `"Set up workspace and warm-up (skim formulas & vocabulary)"` but the stripping reduced it to `"Set up workspace and warm-up"`, erasing the study context that would have led the LLM to pick library over bed. Pollution guards for LLM artifacts (`(Certainly!` etc.) and the 150-char length cap remain intact.

- [x] **Phase 6C: Sharpen planning-thought-on-convo prompt for conversation follow-through**
   - `reverie/backend_server/persona/prompt_template/v2/planning_thought_on_convo_v1.txt`: Replace generic "anything to remember for planning" instruction with commitment-focused prompt that asks for specific agreed actions (who/what/where/when) and returns "has no specific plans" when no commitments were made. Same template variables (INPUT 0-3), same 50 max_token budget, same completion format. No architecture or function changes — existing pipeline (reflect.py post-chat hook → run_gpt_prompt_planning_thought_on_convo → _enqueue_reflection_thought → retrieval pool) is already correctly wired.

- [x] **Phase 2D: Anchor short-circuit — wire decomp anchor to location resolution, eliminating bed-fallback for non-sleep actions**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add `_resolve_anchor_to_address()` helper (~35 lines near `_remap_to_compatible_zone()`); searches persona spatial memory using decomp anchor keywords, validates against `maze.address_tiles`
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: In `_determine_action()`, preserve `_act_raw_anchor` from `_extract_subactivity_tags()`; before `generate_action_location()` call, attempt anchor resolution — if successful, use resolved address directly and skip the location LLM call entirely
   - Root cause fixed: `run_gpt_prompt_action_location_unified` was called independently of the decomp anchor, re-inferring location from cleaned prose and returning wrong addresses (e.g. `Dorm Room X:bed` for daytime work actions)

- [x] **Fix noop stall loop — prevent refresh timer from resetting on same-action noop**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Remove `p2_last_action_switch_step = _p2_curr_step(persona)` from `action_switch_noop` branch (~line 4102); timer now only resets on genuine new actions, ending the infinite loop where LLM returns same action → timer resets → repeat (caused 60-step same-action stalls for Katya/Luba in 20260325-3)

- [x] **Phase 5 investigation: embeddings pipeline + soul15 scratch seeding**
   - Embeddings: confirmed working — vectors stored in `dbl_embedding` table (separate from `dbl_memory.embedding` nullable column); retrieval RPC (`public.dbl_retrieve_memories`) correctly JOINs via `USING (memory_id)`. Original audit was false alarm (queried wrong column).
   - `supabase/migrations/20260326000001_seed_soul15_persona_scratch.sql`: Seed all 15 soul15 personas with anonymized `living_area`, `act_address` (bed baseline), identity fields, `daily_plan_req` from career assignments, and `curr_tile` starting positions. Fixes NULL scratch that caused planning failures on fork.

## 2026-03-25

### Backend

- [x] **Phase 3 Analyzer hardening — add oscillation, plan stall, stationary cluster detection**
   - `tests/analyze_sim_realism.py`: Add 5 constants (`OSCILLATION_WINDOW`, `OSCILLATION_MAX_UNIQUE_POS`, `PLAN_STALL_MAX_RUN`, `STATIONARY_CLUSTER_STEPS`, `STATIONARY_CLUSTER_MIN_POS`) and 3 new `_check_*` functions (`_check_oscillation`, `_check_plan_stall`, `_check_stationary_cluster`); wire all three into `validate_all`; fixes analyzer reporting 0 issues on sims with visible regressions
   - `tests/analyze_sim_realism.py`: Fix `_check_oscillation` over-reporting — extend contiguous oscillating windows into a single run before emitting, collapsing a 40-step stall from ~7 issues to 1

- [x] **Fix subactivity tag preservation in _determine_action()**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Pass raw tagged schedule label to `_initialize_subactivity_state()` instead of stripped version; mode/anchor tags now survive to runtime
- [x] **Fix meeting-type actions classified as social_touch**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add "meeting"/"take notes"/"attend" early return before social_touch check in `_infer_subactivity_mode()`
- [x] **Fix details API returning stale baseline data**
   - `api_gateway/app/services/supabase_service.py`: Add staleness guard in `get_persona_detailed_info()` — return None when scratch exists but has no runtime data (step=0, empty memories), triggering FileService fallback

- [x] **Phase 2C: Root-cause oscillation + plan stall fixes**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Bypass 3-step arrival transition for `in_place` actions in both new-action path (~3302) and continuation path (~3863) — sprites now settle to stationary immediately when in zone, eliminating the oscillation loop where waypoint selection during transition pushed sprites out of zone and reset the arrival counter
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Remove `has_stationary_hint` keyword gate from `_compute_stationary_state()` (~665) — when `subactivity_mode` is already `in_place`, the second keyword check was the band-aid pattern that required expanding keyword lists for each new LLM phrasing
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Reset `p2_last_action_switch_step` and `p2_consecutive_extensions` in `action_switch_noop` branch (~4098) — prevents extension counter drift when replanning produces the same action
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Widen arrival transition bypass from `sub_mode == "in_place"` to `sub_mode != "zone_patrol"` in both new-action (~3302) and continuation (~3864) paths — `_build_subactivity_plan()` assigns "workstation_hop" to desk/sketch/draft actions, which the `in_place`-only check missed; only zone_patrol (walk/jog/patrol) now keeps the arrival transition

---

## 2026-03-24

### Backend

- [x] **Replace fragile snapshot/restore with early return in `_determine_action()`**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added same-action early return after address validation (line ~2902) — when re-determination yields identical action+address, skips destructive `add_new_action()` reset, 3 LLM calls, and 240-line movement recompute; only refreshes timing fields
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Removed 12-line `_saved_movement_state` snapshot dict from `plan()` (was lines 4005-4016)
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Simplified `action_switch_noop` branch from 21 lines (9 field restores + print) to 1 line (tag only) — restore is unnecessary because `_determine_action()` no longer clobbers state on same-action

- [x] **MVP realism investigation: root cause analysis of oscillation, plan stall, location mismatch, and analyzer gaps**
   - `double-docs-nicolas/realism/5.mvp.md`: Full MVP release doc with prioritized fix plan, code references, and recommended execution order
   - Investigation findings: within-zone oscillation caused by `PIN_ONE_TARGET_PER_ACTION=false` (execute.py:56); plan stall caused by P2 action persistence extending expired actions (plan.py:3957-3979); location mismatch caused by empty spatial_memory.json bootstrap files; analyzer missing oscillation/stall/cluster detection rules
- [x] **Fix early-sim dead blocks and in-zone oscillation for non-stationary actions (Phase 1 remaining)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add proactive periodic refresh that force-expires actions beyond `P2_ACTION_REFRESH_MAX_STEPS` ceiling even when `act_check_finished()` returns False; seed `p2_last_action_switch_step` on first action assignment so refresh counter is active from step 0
   - `reverie/backend_server/persona/cognitive_modules/execute.py`: Relax in-zone in_place gate to anchor all `in_place` actions at current tile regardless of `stationary_intent`, preventing oscillation for hygiene and other non-keyword-matched actions

- [x] **Fix: spatial memory wiped on every sim start (bootstrap cycle destroys seeded files)**
   - `reverie/backend_server/reverie.py`: `_bootstrap_missing_fork_from_supabase()` deleted the entire baseline folder on every startup (including spatial_memory.json files), then hardcoded `{}` because no Supabase source exists. Fix: save non-empty spatial memory dicts before `shutil.rmtree`, restore them after the per-persona write loop. Spatial memory is now preserved through bootstrap cycles until Phase 2b adds a Supabase table for it.
   - `reverie/backend_server/reverie.py`: Added `import glob` (was missing).

- [x] **Phase 2: Seed spatial memory + add activity-location safety net**
   - `environment/frontend_server/storage/base_family_sim/personas/Ivan Pistsov/bootstrap_memory/spatial_memory.json`: Seeded from `{}` with dorm (Room 1, man's bathroom, common room, kitchen, garden), Oak Hill College (library, classroom), Hobbs Cafe, Johnson Park
   - `environment/frontend_server/storage/base_family_sim/personas/Luba Pistsova/bootstrap_memory/spatial_memory.json`: Same structure, Room 2, woman's bathroom
   - `environment/frontend_server/storage/base_family_sim/personas/Katya Pistsova/bootstrap_memory/spatial_memory.json`: Same structure, Room 3, woman's bathroom
   - `environment/frontend_server/storage/base_family_sim/personas/Gosha Pistsov/bootstrap_memory/spatial_memory.json`: Same structure, Room 4, man's bathroom
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added `_remap_to_compatible_zone()` module-level helper; added activity-location compatibility gate before `add_new_action()` — remaps hygiene actions to bathroom and cooking actions to kitchen when LLM picks a semantically wrong zone; appends `hygiene_location_remapped` / `cooking_location_remapped` to `p2_runtime_tags` for observability

- [x] **Fix oscillation, plan stall, and early-sim dead time (Phase 1 MVP fixes)**
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add same-action state preservation in `execute_plan()` — snapshot 9 movement fields before `_determine_action`, restore on same-action re-determination to prevent reset cycle
   - `.env.local`: Set `PIN_ONE_TARGET_PER_ACTION=true`, `P2_ACTION_REFRESH_MAX_STEPS=8`, `P2_ACTION_MAX_CONSECUTIVE_EXTENSIONS=1`
- [x] **Fix Phase 1 teleport regression — gate authoritative pin on transit mode**
   - `reverie/backend_server/persona/cognitive_modules/execute.py`: Skip `_get_authoritative_target_tile()` at main target selection (line ~1025) when `movement_mode == "travel_to_zone"`. Pin only applies once sprite is in-zone. Fixes 45 teleport events from 2026024-1 test sim.

- [x] **Close Persona panel action-string contamination across BE and FE**
   - `api_gateway/app/core/action_contract.py`, `api_gateway/app/core/validation.py`: Added a shared action-contract normalizer that derives clean reviewer-facing action fields from structured `partial_state.action_progress` / scratch data, and only strips legacy `desc @ address` text when it exactly matches the address already carried in the same payload.
   - `api_gateway/app/services/file_service.py`, `api_gateway/app/services/supabase_service.py`: Updated persona details responses to emit normalized `actionDescription` / `actionAddress` instead of forwarding decorated scratch labels into the panel payload.
   - `api_gateway/tests/test_action_contract.py`, `api_gateway/tests/test_simulation_endpoints.py`: Added backend regression coverage for contract normalization on pure helpers and step endpoint payloads.
## 2026-03-23

### Backend
- [x] **Enhance movement JSON patching and observation metrics tracking**
 - `reverie/backend_server/reverie.py`: Implemented a patching mechanism in `reverie.py` to update the movement JSON with actual positions for improved replay fidelity, preventing teleportation jumps during playback.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Refined the `_extract_subactivity_tags` function in `plan.py` for better parsing of subactivity tags, enhancing the accuracy of action descriptions.

 - [x] **New lean realism analysis script (`tests/analyze_sim_realism.py`)**
   - `tests/analyze_sim_realism.py`: New 1526-line Supabase-first analysis script replacing the 4500-line `analyze_sim.py`. Supabase windowed batch fetching, 6 deterministic integrity checks (teleport, discontinuity, origin, duplicate, gap, chat sanity), 5 export formats (CSV, JSON, summary, LLM prompt bundle, JSONL), optional LLM realism assessment via project stack or OpenAI fallback. CLI: `python tests/analyze_sim_realism.py <sim> [--source supabase|api|compare] [--llm-assess] [--export-only]`.
   - `CLAUDE.md`: Updated Commands section with new script usage and marked old script as deprecated.

- [x] **Fix API gateway event loop deadlock at step ~117**
   - `api_gateway/app/api/routes/simulations.py`: Wrapped `_queue_observations_request()` calls in `asyncio.to_thread()` at both `receive_observation` and `receive_observations_batch` endpoints; added latency logging with 500ms warning threshold
   - `api_gateway/app/api/routes/websockets.py`: Extracted sync file I/O from `_handle_movement_report()` into `_write_movement_report_sync()` helper, called via `asyncio.to_thread()`
   - `api_gateway/app/services/file_watcher.py`: Extracted `_read_movement_file_sync()` and `_find_recent_movement_files_sync()` helpers; async callers now use `asyncio.to_thread()` to avoid blocking the event loop
   - `api_gateway/app/services/supabase_service.py`: Replaced per-request `httpx.AsyncClient()` with shared singleton (connection limits: 20 max, 5 keepalive); added TTL/LRU eviction to `_sim_metadata_cache` (5min TTL, max 50 entries)
   - `api_gateway/app/services/background_tasks.py`: Added `max_task_history=200` with auto-pruning of oldest completed tasks on overflow
   - `api_gateway/app/services/websocket_manager.py`: Added completed background task pruning in `heartbeat_check()` (every 30s)
   - `api_gateway/app/main.py`: Added httpx client shutdown hook; added opt-in asyncio slow callback monitoring (`ASYNCIO_SLOW_CALLBACK_ENABLED=true`)
   - `start.sh`: Added `--limit-max-requests 10000 --timeout-keep-alive 30` uvicorn safety flags


- [x] **Replay matching now tolerates narrow prompt drift without going live** — Hardened cassette matching around timing-sensitive prompt variations so replay stays deterministic across minor prompt-shape drift instead of failing early or falling through to provider calls.

- [x] **Replay no longer depends on live embedding providers** — Replaced replay-time embedding requests with deterministic local vectors so cassette-backed runs stay fully offline even when old embedding paths are still exercised.

- [x] **Replay artifacts now preserve visible movement contract** — Fixed replay feedback loading so recorded `actual_path` and related movement fields are kept from the source run instead of being dropped during replay, and strengthened smoke validation to fail on replay/source movement drift instead of only checking file presence.

- [x] **Replay path contract now survives API transport** — Updated API validation/conversion so `actual_path` is preserved, exposed as frontend `path`, and tagged with `replay_path_source`, preventing the step endpoint from stripping replay paths before FE playback consumes them.

- [x] **Replay bundle completion no longer depends on warm cache timing** — Added a post-step-zero refresh for `replay/planning_cache` so cold-start runs capture planning cache files after startup planning materializes, and hardened replay smoke preflight to fail early when an older bundle is missing that snapshot.

- [x] **Replay setup reduced to a single command** — Added a wrapper that extracts a clean sim bundle from `double-docs-nicolas`, regenerates the cassette from `logs/llm`, and launches replay smoke with the required replay env already wired in.

- [x] **Replay smoke no longer validates over patched artifacts** — Added a raw movement snapshot before replay feedback/visual sync, kept visual overlay limited to frontend-facing path fields, and moved planner drift into a separate non-fatal replay summary instead of hiding it behind synced artifacts.

- [x] **Replay command now defaults to concise output** — The docs replay wrapper now runs in a quiet summary mode by default, disables high-noise replay debug flags, emits heartbeat progress while running, and keeps full backend logs available behind `--verbose`.

### Backend - Nicolas

- [x] **Harden replay smoke against timing-sensitive prompt drift** — Replaced inline persona sorting with `order_persona_items_for_step()`, added `_apply_recorded_replay_feedback()` and `_copy_recorded_replay_environment()` gated behind `LLM_REPLAY_MODE` in `reverie.py`. New module for deterministic persona execution ordering using recorded `meta.json` name order in `persona_ordering.py`. Added 4 tolerance strategies for cassette matching — order-insensitive reordering, step catchup, synthetic poignancy failsafe, optional block skipping in `llm_replay.py`. Added `except ReplayError: raise` before generic `except Exception` blocks to prevent replay errors being swallowed by retry logic in `gpt_structure.py`. Introduced `_with_replay_persona_step()` to attach persona/step metadata to gpt_param for poignancy functions in `run_gpt_prompt.py`. Added env-flag toggles `SHARED_CONTEXT_INCLUDE_FOCAL_POINTS` and `SHARED_CONTEXT_INCLUDE_CURRENT_CONTEXT` (default `true`) in `context_builder.py`. Added replay-path fallback loading profile context from JSON snapshot when Supabase is unavailable in `profile_context_builder.py`. Refactored to `Path` objects, extracted `_ensure_persona_entry()`, added `_backfill_step_from_artifacts()` for replay in `location_monitor.py`. Added 7 new test files (~1,488 lines) covering replay utils, persona ordering, gpt_structure replay, location monitor, profile context, run_gpt_prompt replay context, and launch smoke in `tests/replay/`.

- [x] **Disable live embedding calls in replay mode** — Return deterministic synthetic embeddings (SHA-256 seeded, 1536-dim) instead of calling OpenAI API when `LLM_REPLAY_MODE=true` in `gpt_structure.py`. Tests verifying no live API calls, deterministic output, and correct vector dimensionality in `test_gpt_structure_replay.py`.

- [x] **Harden replay movement fidelity and smoke validation** — New module extracting replay feedback loading with `actual_path` support and `synchronize_replay_movement_artifact()` for motion-fidelity key sync in `replay_feedback.py`. Replaced inline feedback loading with `replay_feedback.py` calls, added `_synchronize_recorded_replay_movement` step in `reverie.py`. Added fidelity validation checking target movement JSON matches source for all motion-fidelity keys in `launch_replay_smoke.py`. New `test_replay_feedback.py` and expanded `test_launch_replay_smoke.py` covering fidelity sync and validation in `tests/replay/`.

- [x] **Preserve replay actual_path through step API** — Convert `actual_path` from tiles to pixels alongside `path` in `coordinate_converter.py`. Prefer `actual_path` over `path` when present, add `replay_path_source` metadata field in `validation.py`. Tests for coordinate conversion and full step endpoint round-trip with `actual_path` in `api_gateway/tests/`.

- [x] **Backfill replay planning cache after step zero** — Added `refresh_replay_planning_cache_snapshot()` to re-capture planning cache files after step 0 completes, updating the manifest in `replay_origin.py`. Call planning cache backfill after `completed_step == 0` in `reverie.py`. Added validation rejecting replays from snapshots with empty planning cache in `launch_replay_smoke.py`. New `test_replay_origin_snapshot.py` and expanded smoke tests covering planning cache lifecycle in `tests/replay/`.

- [x] **Add one-command replay bootstrap from docs sims** — New script `scripts/replay/replay_from_docs.py` to extract sim bundle from double-docs-nicolas via git-archive, normalize LLM logs to cassette NDJSON, and launch replay smoke. Supports custom steps, target sim code, and completed-origin tolerance. New tests in `tests/replay/test_replay_from_docs.py` covering bundle extraction, cassette normalization, and smoke launch orchestration.

- [x] **Harden replay validation and quiet replay wrapper** — Enhanced `launch_replay_smoke.py` with stricter input validation (manifest parsing, planning cache presence), quieter output via env-flag `REPLAY_SMOKE_QUIET=true`, and improved error reporting for cassette mismatches. Expanded `test_launch_replay_smoke.py` with 12 new test cases covering validation edge cases, quiet mode, and manifest-based planning cache rejection.

- [x] **Disable live embedding calls in replay mode** — Return deterministic synthetic embeddings (SHA-256 seeded, 1536-dim) instead of calling OpenAI API when `LLM_REPLAY_MODE=true` in `gpt_structure.py`. Tests verifying no live API calls, deterministic output, and correct vector dimensionality in `test_gpt_structure_replay.py`.

- [x] **Harden replay movement fidelity and smoke validation** — New module extracting replay feedback loading with `actual_path` support and `synchronize_replay_movement_artifact()` for motion-fidelity key sync in `replay_feedback.py`. Replaced inline feedback loading with `replay_feedback.py` calls, added `_synchronize_recorded_replay_movement` step in `reverie.py`. Added fidelity validation checking target movement JSON matches source for all motion-fidelity keys in `launch_replay_smoke.py`. New `test_replay_feedback.py` and expanded `test_launch_replay_smoke.py` covering fidelity sync and validation in `tests/replay/`.

- [x] **Preserve replay actual_path through step API** — Convert `actual_path` from tiles to pixels alongside `path` in `coordinate_converter.py`. Prefer `actual_path` over `path` when present, add `replay_path_source` metadata field in `validation.py`. Tests for coordinate conversion and full step endpoint round-trip with `actual_path` in `api_gateway/tests/`.

- [x] **Backfill replay planning cache after step zero** — Added `refresh_replay_planning_cache_snapshot()` to re-capture planning cache files after step 0 completes, updating the manifest in `replay_origin.py`. Call planning cache backfill after `completed_step == 0` in `reverie.py`. Added validation rejecting replays from snapshots with empty planning cache in `launch_replay_smoke.py`. New `test_replay_origin_snapshot.py` and expanded smoke tests covering planning cache lifecycle in `tests/replay/`.

---

## 2026-03-22

### Backend

- [x] **Enhance location resolution and logging capabilities**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Introduced a unified location resolution method in `run_gpt_prompt.py` to streamline sector, arena, and object retrieval in a single LLM call, improving efficiency and reducing error propagation.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added a new function `generate_action_location` in `plan.py` to build a comprehensive location tree, enhancing the accuracy of location-based actions.
 - `d:\Coding\generative_agents\CLAUDE.md`: Updated `CLAUDE.md` to include a worklog format for documenting code changes, promoting better tracking of updates.
 - `.cursor/settings.local.json`: Expanded Bash commands in `settings.local.json` for improved directory searching related to monitoring and location tracking.

- [x] **Enhance action location generation and logging**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Introduced a deterministic sleep guard in `plan.py` to improve location resolution for sleep actions, ensuring that the persona's home sector and arena are prioritized. Added logging functionality to capture AI suggestions related to sleep locations, enhancing traceability and debugging capabilities.
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Removed unnecessary time formatting in `run_gpt_prompt.py` to streamline the code.
 - `.cursor/settings.local.json`: Updated `settings.local.json` with an additional Bash command for improved exit status reporting.

## 2026-03-21

### Backend

- [x] **Fix index selection logic in Scratch class to correctly return the current block based on elapsed time**
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Adjusted condition to check after adding duration, preventing off-by-one errors when the current time falls within a long block.


## 2026-03-20

### Backend

- [x] **Update observation metrics with additional batch submission and processing entries**
 - `tests/analyze_sim.py`: Expanded the observation metrics JSONL file to include new entries for batch submissions and processing metrics related to multiple personas. Enhanced tracking of observation ingestion, report submissions, and processing times, contributing to a more comprehensive analysis of simulation performance. Updated metrics to reflect the status of observations and handling of movement reports, improving insights into system behavior.

- [x] **Capture planning cache for replay bundles**
 - `reverie/backend_server/reverie.py`: Implemented planning cache capture for replay bundles to support simulation analysis.

- [x] **Normalize legacy living areas to anonymized rooms**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Normalized legacy living area references to anonymized room structures.

- [x] **Replay/local-only integration on shared `local` baseline** — Integrated replay tooling on top of the anonymized backend branch so the shared runtime now includes cassette-driven LLM replay, local-only isolation controls, and automatic per-run origin snapshot capture for future faithful replay baselines.

- [x] **Replay validation hardening** — Strengthened replay request matching to include material request parameters, turned `LLM_REPLAY_STRICT` into a real behavioral switch, and upgraded the smoke preflight to validate cassette structure before launching a replay run.

- [x] **Replay bundle completeness** — Extended replay bundle capture to include per-run planning cache state, restored that cache automatically in replay smoke runs, and isolated replay cache directories so reruns no longer depend on hidden machine-local planning artifacts.

- [x] **Legacy room-name normalization** — Added conservative boot-time normalization from legacy `living_area` room labels to current anonymized dorm-room addresses when the persona's current tile proves the correct private room, preventing valid dorm rooms from being filtered out of prompt options.

## 2026-03-19

### Backend

- [x] **Anonymizer Phases A and B successfully implemented and tested. Enhance persona living area management and update asset catalog**
 - `reverie/backend_server/reverie.py`: Updated `ReverieServer` to dynamically assign living areas to personas based on their scratch data, improving the accuracy of persona location tracking. Implemented functions to populate spatial memory trees for personas with empty trees, enhancing their awareness of the environment.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Refactored the `matches_persona_room` function to support checks against a persona's assigned room using their living area.
 - `environment/frontend_server/static_dirs/assets/the_ville/matrix/*.csv`: Updated CSV files to reflect new naming conventions for rooms and apartments, improving consistency across the asset catalog.
 - `.cursor/settings.local.json`: Added new Bash commands in `settings.local.json` for testing and debugging purposes.

- [x] **Refactor AddressMapper to use dynamic character mappings**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Removed hardcoded character-specific mappings and replaced them with a dynamic approach that builds mappings from the persona's living area at runtime. Introduced a new method `build_character_mapping` to populate character mappings based on the persona's attributes. Updated fallback address retrieval to prioritize dynamic mappings, enhancing flexibility and accuracy in address resolution. Cleaned up unused code related to previous static mappings, improving maintainability.

- [x] **Update observation metrics with detailed batch submission and processing data**
 - `tests/analyze_sim.py`: Added multiple new entries to the observation metrics JSONL file, capturing batch submission statuses and processing metrics for various personas. Enhanced the dataset to include metrics on observation ingestion, report submissions, and processing times, improving analysis capabilities for simulation performance. Updated processing metrics to reflect the handling of movement reports and the status of observations, contributing to a more comprehensive understanding of system behavior.

- [x] **Integrate replay tooling on top of anonymized local**
 - `reverie/backend_server/reverie.py`: Integrated replay tooling enhancements for anonymized local simulations.

- [x] **Harden replay request matching and cassette preflight**
 - `reverie/backend_server/reverie.py`: Hardened replay request matching logic and added cassette preflight checks for improved reliability.
## 2026-03-18

### Backend

- [x] **Phase 25.8 _ Phase 26. Enhance LLM response capture and update settings for improved logging**
 - `reverie/backend_server/reverie.py`: Added new environment variables `LLM_CAPTURE_ENABLED` and `LLM_CAPTURE_PATH` to enable and specify the path for capturing raw LLM responses. Implemented functions to store and retrieve the last LLM call's request and response, facilitating better logging and debugging capabilities. Updated the `ReverieServer` and `ModelRouter` classes to integrate LLM response capture into the existing workflow, ensuring that relevant data is logged for analysis.
 - `.cursor/settings.local.json`: Modified the `settings.local.json` to include new Bash commands for testing LLM capture functionality.

- [x] **Enhance LLM capture functionality and improve persona action logging**
 - `reverie/backend_server/reverie.py`: Updated the `ReverieServer` to capture LLM calls during both parallel and serial processing, writing the data to JSON files for each simulation step.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Introduced thread-local storage for LLM context management within persona cognitive cycles, ensuring accurate tracking of LLM interactions.
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Modified the `gpt_structure.py` to accumulate LLM responses in a structured manner, enhancing the observability of LLM interactions.
 - `.cursor/settings.local.json`: Updated `settings.local.json` to include new Bash commands for testing LLM capture functionality.

- [x] **Refactor logging and capture mechanisms for improved simulation analysis**
 - `reverie/backend_server/reverie.py`: Updated the `ReverieServer` to streamline logging paths and enhance the handling of movement and FE forensics capture, directing outputs to a dedicated logs directory.
 - `reverie/backend_server/headless_visualization.py`: Modified the `headless_visualization.py` to ensure proper output directory assignment based on the presence of a run label.
 - `reverie/backend_server/persona/cognitive_modules/cognitive_capture.py`: Enhanced the `cognitive_capture.py` to clarify context clearing behavior while preserving LLM call data for post-processing.
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Updated the `gpt_structure.py` to remove legacy LLM capture hooks, centralizing capture logic within the model router for better thread safety.
 - `.cursor/settings.local.json`: Added new Bash commands in `settings.local.json` for testing and debugging purposes.

## 2026-03-17

### Backend

- [x] **Enhance persona action handling with arrival transition logic**
 - `reverie/backend_server/reverie.py`: Introduced a new environment variable `ARRIVAL_TRANSITION_EXPIRY_STEPS` to manage the expiration of arrival transitions for personas. Updated the `_determine_action` and `_check_movement_mode_transitions` functions to incorporate logic for transitioning from "in_zone" to "stationary" based on the new expiry steps.
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Added `arrival_transition_step_count` to the `Scratch` class to track the number of steps in the arrival transition, ensuring accurate state management.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Enhanced the handling of movement modes to improve responsiveness and accuracy in persona behaviors during transitions.

## 2026-03-15

### Backend

- [x] **phase 23 sections 1 & 4. Implement movement mode normalization and enhance persona action handling**
 - `reverie/backend_server/reverie.py`: Introduced a new movement mode normalization function to standardize movement modes across various contexts, improving consistency in persona actions. Enhanced to incorporate movement mode logic, allowing for better handling of stationary intents and transitions between movement states.
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Updated the function to include occupancy penalties based on the persona's current tile, refining decision-making in target selection.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added new utility functions for validating target zones and managing movement mode transitions, enhancing overall simulation responsiveness.

## 2026-03-14

### Backend

- [x] **Fixed the issues with speed-multiplier. Enhance stationary intent handling and conflict resolution in persona actions**
 - `reverie/backend_server/reverie.py`: Introduced new environment variables for stationary emit conflict management, allowing for better control over stationary behavior. Updated to include a conflict guard for stationary intent, ensuring accurate persona behavior when stationary conditions are met.
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Enhanced the `_compute_stationary_state` function to incorporate address mismatch checks and anchor distance evaluations, improving decision-making for stationary actions. Added new utility functions for tile normalization and distance calculations, streamlining the logic for determining persona positioning within target zones.

- [x] **Implement in-zone variation handling and enhance movement consumption logic**
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Introduced environment variables to enable in-zone variation for persona actions, allowing for more dynamic behavior when stationary. Enhanced the function to apply a variation filter based on the persona's current position and action duration, improving decision-making in target selection.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Updated the `calculate_movement_consumption` function to allow for non-stationary movement within zones, enhancing flexibility in navigation.

## 2026-03-13

### Backend

- [x] **Refactor FE forensics configuration and enhance persona action handling**
 - `reverie/backend_server/reverie.py`: Removed deprecated environment variables related to FE forensics and replaced them with a consolidated configuration function for better clarity and maintainability. Updated to improve handling of stationary intent and action determination, ensuring accurate persona behavior tracking.
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Enhanced the `_is_in_target_zone` method to check the persona's actual position against the target zone, improving navigation accuracy.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added new keywords for in-place actions to refine intent recognition and prevent unnecessary replanning.

## 2026-03-12
### Backend

- [x] **Code review: verified stationary realism root cause and updated implementation spec**
 - `docs-nicolas/20260310_realism.md`: Verified all 5 technical findings against actual code, identified a self-defeating guardrail loop (`_classify_healthy_persistence` + `_dual_progress_status` + stall breaker) that guarantees forced replan for any stationary persona within ~11 steps, documented why the 03-10 fix attempt failed (P0/P1/P2 are interdependent and inert when applied individually), rewrote the priority order (P2 first, then P1, then P0) with exact before/after code diffs, line references, and an implementation checklist across `reverie.py` and `plan.py`.

- [x] **Implement atomic P2/P1/P0 backend realism guardrail updates**
 - `reverie/backend_server/reverie.py`: Updated stationary in-place dual-progress evaluation to accept task progress, reclassified in-zone stationary intent as healthy persistence (`stationary_desk_work`), and gated no-op movement bypass on explicit `stationary_intent`.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Expanded `local_fallback_stationary_allowed` keywords so legitimate desk/study/work/counter tasks can retain stationary intent when zone resolution uses local fallback.

- [x] **Fix stationary_intent never activating on continuation steps**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added `_recalculate_stationary_on_continuation()` to re-evaluate `stationary_intent` and `speed_multiplier` on every continuation step (action not expired), so personas that arrive in their target zone mid-action correctly transition to stationary mode. Promoted keyword tuples (`TRAVEL_ACTION_KEYWORDS`, `IN_PLACE_ACTION_KEYWORDS`, `LOCAL_FALLBACK_STATIONARY_ALLOWED_KEYWORDS`) to module-level constants shared by both `_determine_action` and the new recalculation function.
 - `docs-nicolas/20260310_realism.md`: Documented `20260312-1` pipeline analysis showing `stationary_intent` never true despite correct P2/P1/P0 deployment, root-caused to `_determine_action` only running on action transitions, and added updated implementation checklist with the new fix.

- [x] **Expand stationary classifier keywords for immediate BE coverage**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Expanded `IN_PLACE_ACTION_KEYWORDS` and `LOCAL_FALLBACK_STATIONARY_ALLOWED_KEYWORDS` with high-frequency stationary task terms (`gather`, `sort`, `organize/organizing`, `sketch`, `file/filing`, `arrange/arranging`, `draft`, `scan`, `review`, `plan`, `prepare/preparing`, `pack`) so continuation-step stationary recalc can classify natural-language desk actions more reliably.
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Mirrored the same expanded in-place keyword set to keep executor in-place activity detection aligned with planner classification.

- [x] **Align API movement rhythm scoring with realized movement continuity**
 - `tests/analyze_sim.py`: Changed API behavior distance input for `update_behavior_state` from within-step `start_pos->movement` delta to cross-step `movement[N-1]->movement[N]` delta, matching Supabase semantics and removing contradictory outputs (e.g., `moving=16` with simultaneous long stationary streaks under duplicate API rows); also updated API behavior summary stationary streak detection to use consecutive movement continuity instead of `start_pos==movement`.

- [x] **Fix stationary_emission misalignment (emission=False despite intent=True)**
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Changed zone-based stationary block to use `current_pos` (actual sprite position from `last_actual_pos`) instead of `curr_tile` (overwritten to destination by plan.py), so `execute()` returns the real position when staying put — matching the same fix pattern already applied at 7 other positions in execute.py.
 - `reverie/backend_server/reverie.py`: When `stationary_intent=True` and `speed_multiplier<=0`, emit `movement=start_position` instead of `target_pos` so `stationary_emission` correctly resolves to `True`, enabling the full P2 guardrail chain (`healthy_reason=stationary_desk_work`).

- [x] **Fix Luba missing from pipeline capture**
 - `.env.local`: Fixed double-space typo in `MOVEMENT_PIPELINE_CAPTURE_PERSONAS` (`Luba  Pistsova` → `Luba Pistsova`).
 - `reverie/backend_server/reverie.py`: Changed pipeline persona name normalization in both `_init_movement_pipeline_capture` and `_movement_pipeline_capture_enabled_for` to use `" ".join(name.split()).lower()` which collapses all internal whitespace, preventing this class of bug from recurring.


## 2026-03-10

### Backend

- [x] **Implement Stage A backend stationary realism hardening (P0-P2)**
 - `reverie/backend_server/reverie.py`: Require explicit `stationary_intent` + `subactivity_mode=in_place` for no-op bypass, and retune guardrail health classification so in-zone intentional stationary work counts as healthy persistence.
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Widen sedentary stationary intent hints (`study/read/review/desk/admin/service-counter` class actions) and relax local-fallback hold-off for clearly sedentary in-zone activities.
 - `.env.local`: Enable `NOOP_MOVEMENT_BYPASS_ENABLED=true` for local validation runs.

## 2026-03-09

### Backend

- [x] **Wire temporary FE forensics capture into headless execution**
 - `reverie/backend_server/headless_visualization.py`: Added temporary FE forensics instrumentation gates and runtime helper loading, captured injected payload before `__executeMovementsForStep`, captured `window.__headlessReports` pathfinding traces after execution each step, and finalized generated forensic audit artifacts into `docs/realism-runs/<run_label>/fe-forensics`.

- [x] **Harden FE forensics helper loading and fail-fast diagnostics**
 - `reverie/backend_server/headless_visualization.py`: Fixed dynamic helper import reliability by registering the runtime module in `sys.modules` before execution (resolving dataclass load failure), and changed FE forensics initialization to raise explicit runtime errors when helper load/capture init fails so misconfiguration cannot silently skip forensic capture.

- [x] **Close remaining Phase 16.8 backend transport + stall-guardrail gaps**
 - `reverie/backend_server/reverie.py`: Preserve `movement` and `planned_pos` in Supabase step writes, widen blocked same-tile repeat signatures to action/zone/start-tile deadlocks, and tighten dual-progress so `feedback_no_actual_movement` suppresses false task-only progress for embodied movement actions.
 - `api_gateway/app/services/supabase_service.py`: Add resilient movement-row extraction helpers and keep `planned_pos`/`start_pos`/`movement` intact for both single-step and step-range Supabase reads (including JSON-string payloads and legacy missing-`planned_pos` rows).
 - `api_gateway/tests/test_supabase_step_transport.py`: Add regression tests proving live-style Supabase step readers preserve non-null `planned_pos` and range playback carries the same contract.
- [x] **Implement Phase 18.3 compare semantics and replay evidence capture wiring**
 - `reverie/backend_server/headless_visualization.py`: Capture replay audit evidence rows from `window.__replayPathAudit` with fallback derivations (`step_data` / `movement_report`) and persist them via FE forensics replay NDJSON output.

## 2026-03-08

### Backend

- [x] **Implement BE headless movement contract cleanup**
 - `reverie/backend_server/reverie.py`: Removed generation-time `path` emission in intent-only mode, kept `movement` / `planned_pos` / `start_pos` as the runtime contract, forced `step 0` spawn snapshots to emit stationary `speed_multiplier=0.0`, and added a repeated same-tile no-op feedback guardrail that escalates to `force_replan_next_step`
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persisted feedback no-op guardrail state across scratch serialization paths
 - `api_gateway/app/services/supabase_service.py`: Preserved top-level `movement` and `planned_pos` from movement JSONB in both single-step and range readers instead of reconstructing intent from row `x,y`
 - `api_gateway/app/core/validation.py`: Preserved validated `planned_pos` and accepted `speed_multiplier=0.0` for legitimate stationary intent
 - `api_gateway/app/core/coordinate_converter.py`: Converted `planned_pos` to pixel coordinates alongside `movement` and `start_pos`
 - `api_gateway/tests/test_coordinate_conversion.py`: Added regression coverage for `planned_pos` and `start_pos` conversion in step payloads
 - `api_gateway/tests/test_coordinate_integration.py`: Added integration coverage for `planned_pos` / `start_pos` pixel conversion
 - `api_gateway/tests/test_simulation_endpoints.py`: Added API regression coverage for no-path headless step payloads preserving `planned_pos` and `speed_multiplier=0.0`
 - Validation: `pytest` targeted endpoint and coordinate conversion regressions passed
- [x] **Implement Phase 16 BE fixes #1-#4 in movement runtime**
 - `reverie/backend_server/reverie.py`: Added blocked same-tile (`no_progress_same_tile`) repeat detection with first-class escalation (`force_replan_next_step`, authoritative-target clear, target reseed, zone-shrink bypass), added feedback-aware no-actual-movement pressure into dual-progress guardrail, and introduced final pre-emit intent validation so `movement` and `planned_pos` remain semantically consistent and corrected to reachable in-zone fallbacks with trace reason.
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persisted blocked-loop guardrail state (`blocked_no_progress_*`) plus zone-shrink bypass/reseed and feedback no-actual-movement fields across JSON/Supabase scratch serialization.

## 2026-03-06

### Backend

- [x] **Analyzed 20260306-3 reachability override patterns**
 - `environment/frontend_server/storage/20260306-3/movement/*.json`: ~198 reachability overrides across 100 steps, all `reroute_to_reachable_tile`
 - Root cause: Oak Hill College missing from `accessible_options` for Mike Hooks, Alex Shepard, Nick Miller; forces fallback to wrong-sector houses
 - Dean Sanford: chronic override in Latoya Williams's bathroom (tile [22,17] unreachable), action-location mismatch ("classroom prep" in bathroom)
 - Alex Shepard: frozen at (21,21) for 95 steps via rest_lock after initial sector fallback
 - Vincent Slater: Hobbs Cafe tile-level overrides (tile [84,22] collision-blocked, reroutes to [77,26])

- [x] **Full RCA on post-P1 static persona behavior (run 20260306-3)**
 - RC-1: Phantom sector "Oak Hill College" — keyword extractor maps to nonexistent sector, LLM keeps suggesting it, fallback cascade dumps personas into random rooms (3+ personas, 80-95% stationarity)
 - RC-2: rest_lock amplifies bad placement — overly broad keyword list (sit/work/review) pins wrongly-placed personas for 90+ steps
 - RC-3: Reroute algorithm favors proximity over quality — finds nearest walkable tile in wrong zone, doesn't detect semantic mismatch
 - RC-4: API realism visibility gap — DUPLICATE_DATA suppresses subactivity switch counting, making API metrics show 0.0 while Supabase shows 76.2
 - Verdict: "planner generating bad targets" is the dominant cause; reroute strictness is a minor contributor
 - Recommendation: stay in P1.5 for routing/visibility fixes before P2 guardrail tuning

- [x] **Implement P1.5 realism visibility gate and target-selection tracing**
 - `tests/analyze_sim.py`: Added realism-trace fallback helpers, compare-mode realism visibility gate, richer forensic/compact exports, and realism-semantic compare columns for stationary intent, subactivity, zone resolution, reachability override, and target selection
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Replaced tiny random tile sampling with preference-ranked candidate sampling, recent-target repeat penalties, and per-step target-selection trace emission
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persisted target tile, recent target history, and target-selection trace across scratch serialization paths
 - `reverie/backend_server/reverie.py`: Added `realism_trace.target_selection` to emitted movement payloads
 - `api_gateway/tests/test_simulation_endpoints.py`: Added regression coverage that step playback preserves realism fields while converting coordinates
 - `tests/test_analyze_sim_realism_fields.py`: Added analyzer regression coverage for stationary-intent fallback and API-vs-Supabase realism mismatch detection

- [x] **Wire backend pinned-target experiment behind env flag**
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Added `PIN_ONE_TARGET_PER_ACTION` support to keep one authoritative exact tile per action, reuse that tile during continuation, and bypass per-step waypoint drift when the same action is still active
 - `reverie/backend_server/reverie.py`: Promoted reachability reroutes into authoritative target updates, cleared stale backend path state after override, and reset pinned state on replan/action changes so the experiment can cleanly falsify reroute-vs-target-quality failures
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persisted authoritative target experiment state across scratch load/save paths so the experiment remains stable across backend step execution
 - `reverie/backend_server/reverie.py`: Added debug logging for `PIN_ONE_TARGET_PER_ACTION` experiment flag verification during startup
- [x] **Stop static in-place work from masking frozen embodiment**
 - `reverie/backend_server/reverie.py`: Tightened the dual-progress and healthy-persistence guardrails so `stationary_intent` + `in_place` work no longer counts elapsed-time subactivity updates as valid progress, allowing flat stationary loops to accumulate toward nudges and forced replans
- [x] **Implement structured movement-pipeline capture artifacts**
 - `reverie/backend_server/reverie.py`: Added opt-in NDJSON and markdown summary capture for per-persona movement pipeline stages, including plan entry, post-plan state, target selection, emitted movement, stall guardrail decisions, movement report feedback, and replan application, writing to `test-results/<sim_id>/`
- [x] **Implement P0 data-truth fixes for realism analysis**
 - `tests/analyze_sim.py`: Replaced Supabase compact range fetch with step-window pagination to avoid row-cap truncation, added compact data-coverage gap detection, and implemented backward-compatible `stationary_intent` extraction (top-level first, then `realism_trace`) for both API and Supabase compact timelines.
 - `reverie/backend_server/reverie.py`: Added top-level `stationary_intent` to emitted `movement_data` for analyzer compatibility while preserving the existing `realism_trace` field.

- [x] **Implement P1 tracing and multi-stage in-place behavior scaffolding**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added multi-stage `in_place` subactivity generation for medium/long tasks, tagged zone-resolution source (`exact_address`, `keyword_fallback`, `local_fallback`), and blocked immediate stationary lock when only local fallback proves "in-zone" for non-rest actions.
 - `reverie/backend_server/reverie.py`: Added `zone_resolution` and `reachability_override` fields to `realism_trace` so stationary outcomes can be attributed to planner intent vs runtime reachability reroute/stay-put behavior.
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persisted new zone-resolution trace state across scratch lifecycle serialization paths.
 - `tests/analyze_sim.py`: Surfaced `REACHABILITY_OVERRIDE` as a compact analysis event and added new realism-trace fields to compact timeline rows for future validation passes.

## 2026-03-05

### Backend

- [x] **Persist and log FE blocked-path diagnostics in observation intake**
 - `api_gateway/app/models/simulation.py`: Extended `ObservationModel` with `blocked_reason` and `blocked_debug` for `movement_report` payloads
 - `api_gateway/app/api/routes/simulations.py`: Added `blocked_reason`/`blocked_debug` persistence in queued observation rows and enriched movement-report logs with blocked reason + debug presence

- [x] **Preserve and surface FE blockage diagnostics across BE pipeline logs**
 - `reverie/backend_server/headless_visualization.py`: Forwarded `blocked_reason` and `blocked_debug` from headless observations into submitted `movement_report` payloads and retained them inside `details`
 - `api_gateway/app/api/routes/simulations.py`: Added fallback extraction of debug fields from `details`, preserved them in queued movement rows, and enriched queue/intake logs with `has_debug`
 - `reverie/backend_server/reverie.py`: Enriched movement report processing logs with blocked reason and blocked-debug summaries (failure reason, neighbor count, blocker sources)

- [x] **Implement center-first spawn seeding with egress-route validation**
 - `reverie/backend_server/reverie.py`: Added center-tile seeding for step 0 using `living_area`, enforced validation for walkability + minimum neighbors + short route-to-egress, and applied staged relocation fallback (small radius -> expanded radius -> hard fallback) with explicit logs

## 2026-02-27

### Backend

- [x] **Soul-15 custom sim foundation**
  - Added the full path to create a new custom simulation with 15 personas in `the_ville` (no baseline residents mixed in).

- [x] **Profile SOT in Supabase (Workstream A)**
  - Added profile tables for:
    - long-form Soul docs,
    - compiled short snippets,
    - sprite asset metadata.
  - Added profile RPCs for runtime context + fingerprint lookup.

- [x] **Ingestion + verification automation (Workstream B)**
  - Built importer script to parse Soul markdown, upsert personas, write docs/snippets/sprite rows, and seed sim.
  - Built verification script to check sim integrity (persona count, maze, docs/snippets/sprite presence).

- [x] **Runtime profile-context usage (Workstream C)**
  - Added backend profile-context builder with caching by persona/fingerprint/task.
  - Integrated into prompt context flow so runtime uses compact snippets (not full Soul docs).
  - Added observability counters.

- [x] **Bootstrap + step-0 seed flow (Workstream D)**
  - Unified bootstrap and scratch seeding flow in one script.
  - Seeds required scratch fields (`living_area`, `daily_plan_req`, identity fields, etc.).
  - Supports deterministic roster enforcement and override manifests.

- [x] **Major Runtime Fixes Included**
   - Reduced park destination collapse.
   - Fixed “in-zone freeze” behavior so agents can move within zone.
   - Disabled no-op movement bypass by default for validation phase.
   - Fixed intent-hold pinning so it applies only to truly stationary intent.
   - Added Home Assignment Phase 1 API + start guard to block missing `living_area`.

- [x] **Anonymized atlas rollout + sprite-manifest runtime path (Phase 1 + Phase 2 foundations)**
  - `scripts/manage_anonymized_sprites.py`: Added operational flow to upload generalized atlases to `shared-assets`, generate randomized sex-matched assignment suggestions, and apply confirmed persona-global assignments to `double.persona_sprite_assets`.
  - `scripts/verify_sprite_assignments.py`: Added preflight verification gate for simulation sprite integrity (one active row/persona, required atlas paths, optional non-placeholder policy, and storage-object existence checks).
  - `api_gateway/app/services/supabase_service.py`: Added simulation sprite-manifest builder sourced from active `persona_sprite_assets` rows with resolved storage URLs.
  - `api_gateway/app/api/routes/simulations.py`: Added `GET /api/simulations/{sim_code}/sprite-manifest` endpoint for frontend/runtime consumption.
  - `double-front/scenes/MainScene.ts`: Added dynamic persona atlas loading from sprite manifest with runtime fallback texture + warning behavior when atlas assets are missing/unloadable.

---
## 2026-02-25

### Backend

- [x] **Restore simulation metadata RPC compatibility to stop missing-function noise under API polling**
 - `supabase/migrations/20260225000001_restore_simulation_metadata_rpcs.sql`: Recreate `public.get_simulation_metadata(p_sim_name text)` and `public.update_simulation_metadata(...)`, include `service_role` execute grants, optional `anon` read grants, add thin `double.*` wrappers that delegate to `public.*`, and trigger `NOTIFY pgrst, 'reload schema'`
 - `supabase/migrations/20260120000002_phase10_fix_updated_at.sql`: Backport the same role-grant and `double` wrapper posture so source migration history matches runtime compatibility expectations

- [x] **Deliver Home Assignment Phase 1 (API-first, flag-gated) for custom simulations**
 - `api_gateway/app/models/simulation.py`: Extend create/assignment request contracts with `sim_type`, `assignment_mode`, `assignments`, and `manual_with_auto_fill`
 - `api_gateway/app/api/routes/simulations.py`: Add `POST /api/simulations/{sim_code}/assign-living-areas`, enforce custom-sim start guard for missing `living_area`, and wire feature gate `ENABLE_HOME_ASSIGNMENT_MVP`
 - `api_gateway/app/services/home_assignment_service.py`: Implement deterministic assignment/coverage logic, walkable-address validation, and persistence to `double.persona_scratch`
 status snapshot

- [x] **Harden custom-sim create/assignment flows against Supabase schema and constraint variance**
 - `api_gateway/app/core/validation.py`: Fix enum-backed `assignment_mode` validation path and align request validation with custom-sim payload semantics
 - `api_gateway/app/services/supabase_service.py`: Replace fragile `double.*` table naming/RPC assumptions, implement explicit `double` schema table operations, and switch persona linking to `select -> insert` path (no `ON CONFLICT` dependency)
 - `api_gateway/app/services/home_assignment_service.py`: Replace scratch upsert conflict path with explicit `select -> update/insert` writes for environments lacking matching unique constraints

- [x] **Complete strict per-person home reassignment for `soul15_seed_20260224` baseline**
 - `double.persona_scratch` (runtime update): Set all 15 personas to non-shared `living_area` values and aligned `curr_tile` anchors using strict room/owner-unit allocation rules
 - `double.personas_coords` (runtime update): Reseed step-0 coordinates for all 15 personas from assigned home anchors to remove shared-park starts

## 2026-02-24

### Backend
- [x] **Complete Workstream A profile-SOT schema and RPC foundation**
 - `supabase/migrations/20260206000001_security_lints_safe.sql`: Apply prerequisite security-lints-safe migration before profile-SOT rollout
 - `supabase/migrations/20260224000001_workstream_a_profile_sot.sql`: Add profile SOT tables (`double.persona_profile_documents`, `double.persona_profile_snippets`, `double.persona_sprite_assets`), RLS posture, and public RPCs for context/fingerprint retrieval
 - `supabase`: Validate applied migration versions in `supabase_migrations.schema_migrations` and confirm table/RPC availability in runtime environment
 - `docs/custom_sims.md`: Mark Workstream A complete with migration IDs, smoke-check outcomes (`get_persona_profile_context`, `get_persona_profile_fingerprint`), and RLS verification notes

- [x] **Complete Workstream B Soul ingestion and deterministic snippet compilation pipeline**
 - `scripts/import_soul_profiles.py`: Implement deterministic Soul markdown import pipeline (persona resolution, document write, snippet compilation, optional sprite placeholder/manifest support)
 - `scripts/verify_soul15_mvp.py`: Implement integrity checks for simulation/maze/persona count plus required document/snippet/sprite records
 - `souls/Ivan_Pitts.md`: Use as parser fixture for voice rules, do/don't guidance, and prompt-ready snippet extraction behavior
 - `souls/Alex_Butcher.md`: Use as parser fixture for metadata, values, and decision-heuristics extraction behavior
 - `docs/custom_sims.md`: Record completed smoke run commands/results and operational repeatability steps for adding additional Soul profiles

- [x] **Implement Workstream C profile-context runtime consumption with cache and observability**
 - `reverie/backend_server/persona/prompt_template/profile_context_builder.py`: Add Profile Context Builder that fetches snippet bundles via RPC, caches by `(persona_id, fingerprint, task_type)`, applies task-type snippet selection, enforces prompt-budget caps, and supports fail-open/fail-closed behavior via config
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Add RPC helper methods `get_persona_id_by_name(...)`, `get_persona_profile_context(...)`, and `get_persona_profile_fingerprint(...)` for profile-context retrieval
 - `reverie/backend_server/persona/prompt_template/context_builder.py`: Integrate profile context into shared prompt context assembly so chat/planning/action/reflection prompts include bounded snippet context
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Extend Section 9 regression bundle with `profile_context_stats` and profile-context cache/failure metrics
 - `reverie/backend_server/reverie.py`: Extend `export verification stats` output with `profile_context_stats` for runtime observability
 - `reverie/backend_server/tests/test_profile_context_builder.py`: Add focused unit tests for task mapping, cache-hit behavior, and fail-open fallback handling

- [x] **Complete Workstream D empty-Ville bootstrap and deterministic step-0 scratch seeding**
 - `scripts/import_soul_profiles.py`: Extend importer to execute Workstream D seed flow with roster controls (`--expected-personas`, `--persona-roster`), scratch override support (`--scratch-manifest`), walkable living-area validation via maze RPCs (`get_address_tiles`, `get_tile_info`), deterministic `curr_tile` assignment, and per-persona `save_persona_scratch(...)` writes
 - `docs/custom_sims.md`: Record approved Workstream D defaults (single-script path, strict roster cardinality, shared-safe spawn default, fail-fast living-area validation with optional fallback, deterministic curr_tile default-on, Workstream D boundary = bootstrap + seed only) and update operator workflow examples
 - `soul15_roster_20260224.json`: Add explicit 15-person roster manifest used for deterministic inclusion/order during seed run
 - `soul15_scratch_20260224.json`: Add optional scratch override manifest (sample per-person day-one overrides) used during seed run
 - `scripts/import_soul_profiles.py` (runtime evidence): Execute real seed command `python scripts/import_soul_profiles.py --sim-code soul15_seed_20260224 --maze the_ville --souls-dir souls --expected-personas 15 --persona-roster soul15_roster_20260224.json --scratch-manifest soul15_scratch_20260224.json` with outcome `Successes: 15, Failures: 0`
 - `scripts/verify_soul15_mvp.py` (runtime evidence): Execute verification command `python scripts/verify_soul15_mvp.py --sim-code soul15_seed_20260224 --expected-personas 15 --expected-maze the_ville` with outcome `Verification PASSED`

- [x] **Enable Supabase-first runtime bootstrap when local fork source is missing**
 - `reverie/backend_server/reverie.py`: Add missing-fork resolution with Supabase bootstrap fallback that hydrates `storage/<fork_sim_code>` from Supabase simulation metadata, linked personas, scratch state, and step-0 coordinate records when local baseline folders are absent
 - `api_gateway/app/api/routes/simulations.py`: Update `/api/simulations/{sim_code}/start` fork selection to prefer Supabase-first continuation (`fork_from=sim_code` when metadata exists) instead of forcing local baseline names
 - `api_gateway/app/services/simulation_control.py`: Set default `fork_from` to `base_family_sim` and pass `SUPABASE_BOOTSTRAP_ON_MISSING_FORK=true` into reverie subprocess environment
 - `docs/custom_sims.md`: Extend Workstream D approved defaults with Supabase-first runtime bootstrap behavior and API start-flow guidance
 - Runtime evidence: `ReverieServer('soul15_seed_20260224', '20260224-supabase-bootstrap-smoke')` successfully initialized after auto-hydrating missing local fork source from Supabase (no filesystem baseline pre-created)

- [x] **Add Workstream A profile SOT Supabase migration**
   - `supabase/migrations/20260224000001_workstream_a_profile_sot.sql`: Create profile document/snippet/sprite tables, add MVP RLS policies and grants, and add `get_persona_profile_context` + `get_persona_profile_fingerprint` RPCs
## 2026-02-23

### Backend

- [x] **Add v0.2 P1 delta to LLM parallelization blueprint for backlog-complete execution**
 - `docs/5.0.llm_parallel.md`: Update metadata to `v0.2` and add a tight P1 delta block defining strict low-risk LLM batching, decomposition run/skip gate rules, async reflection write queue with 1-2 step lag bound, and explicit release gates

- [x] **Implement initial P1 runtime guardrails for decomposition, batching fallback, and reflection lag control**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add decomposition boundary/context gate (`TASK_DECOMP_BOUNDARY_GATE_ENABLED`) with deterministic `DECOMP_GATE=RUN|SKIP` diagnostics and stable reason codes
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Add low-risk poignancy micro-batching with failed-item single retry fallback (`BATCH_FALLBACK_REASON`) and async reflection thought-write queue with bounded lag + forced sync guard (`REFLECTION_LAG_GUARD`)
 - `reverie/backend_server/reverie.py`: Add P1 parallel rollout config defaults (`shadow`, strict determinism/correctness-first posture, per-sprite worker auto-high resolver) and startup telemetry
 - `docs/5.0.llm_parallel.md`: Add approved execution-defaults block matching PM selections (shadow-first, high per-sprite workers, zero-drift gate, failed-item fallback, forced lag flush, correctness-first KPI)

- [x] **Implement true Stage B parallel intent compute path for active mode**
 - `reverie/backend_server/reverie.py`: Add per-step parallel Stage B worker execution (`persona.move`) with bounded worker pool and per-persona start-position snapshot, capture intent outputs before serial commit loop, and enforce correctness-first strict failure handling when active parallel compute is incomplete
 - `reverie/backend_server/reverie.py`: Wire serial commit loop to consume Stage B intent outputs in active mode (`stage_b_active_applied`) and fall back/abort based on strict determinism policy

- [x] **Fix strict movement-report mismatch source with same-step anchor validation**
 - `reverie/backend_server/reverie.py`: Persist per-step movement anchors (`start_pos`, `planned_pos`, `movement`) for each persona and validate headless reports against these same-step anchors before runtime fallback trackers to avoid false `implausible_teleport` rejects in active intent-only flow
 - `reverie/backend_server/reverie.py`: Add configurable `HEADLESS_STRICT_MAX_REPORT_JUMP_TILES` and include expected-source diagnostics in rejection/acceptance logs for easier gate-run forensics

- [x] **Implement P2 conservative continuity controls with novelty budget and attention gating**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add P2 feature flags, novelty budget classifier (`routine_light` vs `novel_full`), context-repeat instrumentation, continuation/extension gate, attention cap with novelty override, lightweight reaction skip path, and per-step decision trace tags/counters
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persist P2 telemetry/state fields across JSON/Supabase scratch paths (switch/decompose/reeval counters, novelty mode/score, context hash repeats, attention window state, extension tracking)
 - `reverie/backend_server/reverie.py`: Extend `realism_trace` movement payload with P2 trace block (mode, novelty, counters, decision tags, extension state) for gate-run observability

- [x] **Enforce Supabase as authoritative simulation status source across API hosts**
 - `api_gateway/app/services/resilient_service.py`: Stop rewriting Supabase `running/paused` status to `stopped` based on host-local process scans; keep runtime process fields as diagnostics-only and add explicit mismatch markers
 - `api_gateway/app/api/routes/simulations.py`: Remove `/stop` stale-status reconciliation path that mutated Supabase to `stopped` when no local managed process was detected
 - `api_gateway/app/services/supabase_service.py`: Harden `update_simulation_status(...)` with retry/backoff and disable filesystem status fallback while `USE_SUPABASE_STEP_SOT=true`
 - `reverie/backend_server/reverie.py`: Add retry/backoff for lifecycle status writes (`running`/`paused`/`completed`/`stopped`) so terminal-driven runs reliably persist status transitions in Supabase
 - `api_gateway/tests/test_status_sot_policy.py`: Add focused regression tests for SOT-preserving status reads, runtime mismatch diagnostics, and non-mutating `/stop` behavior when no local process is present

- **Important final status policy (supersedes 2026-02-22 reconciliation behavior):**
  - Supabase is enforced as the authoritative simulation `status`.
  - API host-local process checks are now diagnostics only (do not rewrite status).
  - `/stop` no longer force-mutates Supabase status just because local host has no process.
  - Added regression tests for this policy.
- **New optional diagnostics for FE (if useful):**
  - Runtime mismatch indicators (e.g., status-vs-local-process mismatch) are available as diagnostics fields.
- **Headless/report strictness improvements**:
  - Better same-step anchor validation and stricter movement-report mismatch handling (stability/quality improvement for replay/live consistency).
- **P2 observability payload expansion**:
  - `realism_trace` / `realism_trace.p2` documented as optional observability-only fields in movement payloads.

## 2026-02-22

### Backend


- [x] **Implement P0 movement/chat/runtime guardrails with compare-mode release gate**
 - `reverie/backend_server/reverie.py`: Add per-persona no-op movement bypass for unchanged in-zone intent, add short-window event-score dedupe cache, tighten observation-primary chat dedupe (20-step + 20-minute windows), and tune STALL BREAKER with higher threshold + repeat decay + healthy-persistence classification
 - `reverie/backend_server/persona/persona.py`: Raise greeting chat buffer default to 20 simulation minutes to match short-window dedupe policy
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Add short-window poignancy cache to avoid repeated score recomputation for identical event/thought/chat descriptions
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Add matching short-window poignancy cache for conversation-side scoring parity
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Tighten format-sensitive parser contracts for sector/arena/object/talk decisions and cap retries via `PARSE_CRITICAL_MAX_RETRIES` with formatting-safe routing hints
 - `tests/analyze_sim.py`: Add compare-mode hard-fail chat persistence gate validating Supabase structured chat (`movement.chat/chatting_with/chat_metadata`) passes through API playback

- [x] **Enforce tiered routing policy in prompt runtime and publish SOT tier map**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Correct Tier A object function mapping to `run_gpt_prompt_action_game_object`, move `run_gpt_prompt_agent_chat_summarize_ideas` to Tier B, and pin `run_gpt_prompt_insight_and_guidance` to Tier B for higher-context output quality
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Migrate remaining active `ChatGPT_safe_generate_response` call sites to `routed_safe_generate_response` so function-level tier routing is honored consistently
 - `docs/sot/sot_prompts.md`: Bump SOT metadata and add full function-by-tier grouping table covering all active prompt functions, including Tier C candidate-only policy notes
- [x] **Complete full Tier-A demotion rollout with explicit routing map**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Expand explicit `TIER_A_TASKS`/`TIER_B_TASKS` to cover all active prompt functions, demote `run_gpt_prompt_summarize_ideas` to Tier A, keep `run_gpt_prompt_insight_and_guidance` plus conversation summarizers on Tier B, and align default Tier C posture to disabled (`TIER_C_ENABLED=false`)
 - `docs/sot/sot_prompts.md`: Update routing tier table to match implemented demotion map and clarify Tier C as candidate-only with explicit enable/allowlist/quota requirements
- [x] **Reduce unnecessary Tier B promotions for valid short outputs**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Add `allow_short_output=True` for `run_gpt_prompt_action_arena` and `run_gpt_prompt_pronunciatio` so valid short contract outputs do not trigger conservative low-confidence promotion

- **Status API behavior work started**:
  - BE introduced runtime/process-aware status handling and extra runtime fields (`backend_process_active`, PID visibility patterns).
  - This day also had logic around reconciling stale running/paused states.
- **Pronunciatio contract hardened for FE stickers**:
  - `/step/{n}` and `/steps` responses now normalize malformed `pronunciatio` into plain emoji.
  - Deterministic fallback emoji is `😐` when invalid/missing.
- **Chat persistence contract reinforced**:
  - BE added checks to ensure `movement.chat`, `chatting_with`, and `chat_metadata` survive through API playback (important for bubbles/timeline).
- **Movement optimization with contract safety note**:
  - BE added no-op bypass optimizations while explicitly preserving FE-safe movement output shape.
- [x] **Reconcile stale running-status reporting when reverie process is no longer active**
 - `api_gateway/app/services/resilient_service.py`: Add local process-state inspection and runtime status reconciliation so stale `running/paused` metadata is surfaced as effective `stopped` with reconciliation hints
 - `api_gateway/app/api/routes/simulation_control.py`: Wire `/status/current` to real runtime process fields (`backend_process_active`, `backend_process_pid`) instead of hardcoded inactive state
 - `api_gateway/app/api/routes/simulations.py`: Apply runtime status reconciliation to `/meta`, surface unmanaged/manual local reverie processes in `/running`, and allow `/start` to actually submit restart tasks when simulation status is `stopped`
 - `docs/README.md`: Update API status note to document runtime reconciliation behavior when metadata and process state diverge
 - `docs/sot/sot_api.md`: Update status/running endpoint notes to reflect reconciliation and unmanaged-process visibility

- [x] **Persist reliable `stopped` status to Supabase on manual simulation shutdown paths**
 - `reverie/backend_server/reverie.py`: Add unified stop-marker helper (`_mark_simulation_stopped`) and invoke it on interactive prompt EOF/KeyboardInterrupt and top-level interrupt so manual stops update Supabase + local meta consistently
 - `reverie/backend_server/reverie.py`: Mark Supabase status as `completed` on `fin/save and finish` path to keep DB and frontend status aligned
 - `api_gateway/app/api/routes/simulations.py`: Enhance `/stop` to reconcile stale `running/paused` metadata to `stopped` when no active process is detected
 - `docs/sot/sot_api.md`: Document stale-status reconciliation behavior for `/stop`

- [x] **Normalize malformed `pronunciatio` payloads in step APIs for FE sticker contract**
 - `api_gateway/app/core/validation.py`: Add robust `pronunciatio` normalizer (handles JSON/object/malformed payloads), emoji extraction, and deterministic fallback (`😐`)
 - `api_gateway/app/core/validation.py`: Enforce `pronunciatio` population during movement validation so each persona returns a plain emoji string
 - `api_gateway/app/api/routes/simulations.py`: Add response-level contract guard for both `/step/{step}` and `/steps` playback payloads
 - `api_gateway/tests/test_simulation_endpoints.py`: Add regression tests for mixed persona payload normalization in single-step and range endpoints

## 2026-02-21

### Backend

- [x] **Implement retrieval-shape root fix for Supabase-first memory reads**
 - `reverie/backend_server/persona/cognitive_modules/memory_compat.py`: Add shared compatibility wrapper/helpers to normalize dict/object retrieval rows into a stable memory-node contract
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Normalize planning retrieval payloads in `revise_identity` and safely parse memory timestamps/content to prevent dict-vs-object crash at new-day planning
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Normalize reflection retrieval payloads before insight generation so reflection path stays compatible with DB retrieval format
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Replace local compatibility implementation with shared memory compatibility helpers to keep one retrieval contract across chat/planning/reflection


## 2026-02-20

### BACKEND

- [x] **Populate persona details API with chat history and memory fallback for Personal card tabs**
 - `api_gateway/app/services/supabase_service.py`: Build `conversationHistory` from persona movement chat signals (`chat`, `chatting_with`, `chat_metadata`) via Supabase with movement-file fallback and normalized message records
 - `api_gateway/app/services/supabase_service.py`: Backfill `memoryEvents` and `thoughts` from file-based persona details when Supabase returns empty memory rows, preserving existing response shape for FE compatibility
- [x] **Add orchestration guardrails to reduce rest-loop realism degradation**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add decomposition controls (nested-task skip, rest-task decomp guard, max subtask cap, label normalization, duration rebalance) to prevent recursive action-string bloat and excessive micro-task fanout
 - `reverie/backend_server/reverie.py`: Add rest-stationary lock and stronger intent-hysteresis/cooldown damping for stationary intents to suppress low-value micro-replans and pacing jitter
- [x] **Finalize realism stabilization commit contents and local validation artifacts**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add decomposition normalization helpers, cap overflow subtasks, enforce nested/rest decomposition skip guards, and rebalance normalized durations to match target windows
 - `reverie/backend_server/reverie.py`: Add shared travel-intent classifier usage, tie stationary intent to cooldown behavior, and expand intent-hold/rest-lock decision reason capture for per-step diagnostics
 - `dumps/double_data_dump.sql`: Add database dump snapshot used during backend validation and evidence review
 - `docs-nicolas`: Add repository symlink to shared frontend documentation workspace for cross-repo reference
 - `supabase/.temp/gotrue-version`: Update local Supabase auth service version marker to `v2.186.0`
 - `supabase/.temp/storage-version`: Update local Supabase storage service version marker to `v1.37.7`
- [x] **Implement ANIM-002 backend hardening for headless report extraction**
 - `reverie/backend_server/headless_visualization.py`: Prioritize canonical `__headlessObservations` movement reports, keep `__headlessReports` as transitional fallback, and only use `__currentPersonaPositions` as degraded fallback with explicit diagnostic reason
 - `reverie/backend_server/headless_visualization.py`: Convert degraded fallback pixel positions to tile coordinates with center-based stable rounding (`round((px-16)/32)`), avoiding floor bias drift
 - `reverie/backend_server/headless_visualization.py`: Add per-step execution diagnostics (`report_source`, source counts, rejected fallback entries, degraded fallback flags/reasons) to improve strict-mode observability

- [x] **Add B1 realism telemetry trace fields to movement payloads**
 - `reverie/backend_server/reverie.py`: Add toggleable `REALISM_TRACE_V2_ENABLED` and emit per-step `realism_trace` diagnostics (`travel_intent`, `stationary_intent`, start/planned/final movement, zone distances, and intent-hold/rest-lock decisions with reasons) without changing movement behavior


---
## 2026-02-17

### BAckend

- [x] **Harden GPT-5 transport reliability with responses-first and explicit chat-empty retry**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Change default API style to `responses`, add explicit transport fallback observability counters/events, map GPT-5 chat reasoning to `reasoning_effort`, and add one-time `chat_completions -> responses` retry when chat output is empty/whitespace
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Align non-router adapter to `responses` default, normalize GPT-5 chat compatibility (`max_completion_tokens`, `reasoning_effort`), and add one-time empty-chat retry to Responses with structured fallback diagnostics
 - `tests/llm_output_function.py`: Add transport fallback count snapshots/deltas in probe output JSON and diagnostics to verify `chat_empty_to_responses` behavior explicitly
- [x] **Expose transport fallback counters even before first routed call**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Include API-style defaults and transport fallback fields in `get_routing_stats()` base payload so diagnostics can read fallback posture without requiring prior traffic

- [x] **Stabilize short-output Responses calls by raising router token floor to 24**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Increase Responses `max_output_tokens` floor from 16 to 24 when mapping from `max_tokens`/`max_completion_tokens` to avoid transport 500 failures on short-output prompts
- [x] **Tighten extract-keywords prompt instruction and re-verify single-function output**
 - `reverie/backend_server/persona/prompt_template/v2/get_keywords_v1.txt`: Add strict output rules requiring exactly two labeled CSV lines and forbidding extra prefixes/explanations
 - [x] **Raise extract-keywords token budget and verify full two-line output**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Increase `run_gpt_prompt_extract_keywords` token budget from `50` to `120` to prevent line-2 truncation under strict two-line output contract


## 2026-02-16
### Backend

- [x] **Add forensic evidence-pack export to simulation analyzer**
 - `tests/analyze_sim.py`: Add `--source evidence` mode plus `--evidence-dir`/`--evidence-steps` flags, export raw API step JSON, raw Supabase table rows (`personas_coords`, `persona_scratch`, `dbl_memory`), API-vs-Supabase compare CSV/JSON, and unified forensic timeline CSV/JSON with deterministic path hashes
- [x] **Add forensic summary metrics and explicit data-gap diagnostics**
 - `tests/analyze_sim.py`: Compute `forensic_summary.json` (duplicate chains, stationary streaks, compare mismatch counts, chat follow-through), load `.env.local` before manifest capture, and surface non-step-granular table limitations (`persona_scratch`, `dbl_memory`) in output notes
- [x] **Harden action lifecycle against repetitive stationary loops**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Fix sleep-tail schedule append guard, add invalid-duration fallback hardening, add forced-replan handling, and add pre/post lifecycle trace logs (`act_check_finished`, action/timing/chat/intent fields)
 - `reverie/backend_server/reverie.py`: Add pre-execution and emit trace logs with `start_pos`, `movement`, and deterministic `path_hash`; add repeated-stationary signature detector that sets `force_replan_next_step` outside intentional sleep windows
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persist stall-breaker fields (`stall_last_signature`, `stall_repeat_count`, `force_replan_next_step`) across JSON and Supabase load/save paths
- [x] **Add investigation-grade lifecycle telemetry for replay correlation windows**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Emit structured before/after planning traces for action timing, chat state, target zone, speed, stationary intent, and force-replan reason
 - `reverie/backend_server/reverie.py`: Emit per-step execution/serialization traces including `act_check_finished`, `start_pos`, `movement`, and `path_hash` to align backend logs with forensic timeline windows (`17-25`, `40-45`, `55-65`)
- [x] **Cap step-0 planning fanout after GPT-5 migration**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Add hard per-persona hourly-schedule call cap (`HOURLY_SCHEDULE_HARD_CALL_CAP`) with bounded fallback carry-forward to prevent step-0 blowups
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Reduce hourly-schedule retry budget via env (`HOURLY_SCHEDULE_LLM_RETRIES`, default 2) and force direct Tier-B routing for hourly schedule generation (`HOURLY_SCHEDULE_FORCE_TIER_B`) to avoid repeated A->B promotions
- [x] **Add tier-forced LLM prompt replay harness for cross-model output review**
 - `tests/llm_output.py`: Add CLI probe script that loads env keys, discovers all `run_gpt_prompt_*` request types, replays exact prompts from JSON/JSONL (or default request-shaped prompts), forces Tier A and Tier B routing, prints outputs for manual comparison, and supports JSON export
- [x] **Harden LLM probe import path for Windows runtime compatibility**
 - `tests/llm_output.py`: Prefer backend-server-local `persona.*` imports and safer `sys.path` ordering to avoid `reverie.py` shadow imports and Unicode console crashes during probe startup
- [x] **Improve LLM probe diagnostics for empty-response forensics**
 - `tests/llm_output.py`: Ignore commented `gpt_param` blocks when discovering token budgets, prefer active max token values, add explicit empty/whitespace markers with output length diagnostics, and expose token override flags for targeted triage runs
- [x] **Hardcode full sample prompts for targeted planning RCA probes**
 - `tests/llm_output.py`: Replace short defaults with fuller template-shaped sample prompts for `run_gpt_prompt_generate_hourly_schedule` and `run_gpt_prompt_task_decomp` based on README/SOT-guided prompt construction flow
- [x] **Disambiguate requested vs final tier in LLM probe output**
 - `tests/llm_output.py`: Capture per-call router promotion signals and emit/store `requested_tier`, `final_producing_tier`, `final_producing_model`, and promotion flags so A→B escalations are explicit in terminal and JSON outputs
- [x] **Tighten prompt output contracts for chat-tier and hourly-schedule generation**
 - `reverie/backend_server/persona/prompt_template/v2/decide_to_talk_v2.txt`: Remove legacy yes/no instruction contradiction and enforce exact single-token output contract (`none|greeting|chat`) to align with runtime parser
 - `reverie/backend_server/persona/prompt_template/v2/generate_hourly_schedule_v2.txt`: Add strict single-line activity-phrase response contract that forbids timestamp/ID/persona-prefix artifacts and constrains output shape for cleaner downstream parsing
 - [x] **Harden wake-up-hour output contract and parser resilience**
 - `reverie/backend_server/persona/prompt_template/v2/wake_up_hour_v1.txt`: Add strict output contract requiring a single 24-hour integer only (no explanation text)
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Reduce wake-up prompt entropy (`temperature=0.0`, lower token budget) and replace fragile `int(...split("am"))` cleanup with robust time/int parsing for `HH:MM AM/PM`, `HH AM/PM`, and strict 24-hour integers
- [x] **Prevent false tier promotion for valid short wake-up responses**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add `allow_short_output` handling in Tier-A promotion logic and pass function/gpt params into promotion checks so short contractual outputs are not auto-promoted unnecessarily
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Mark wake-up-hour request as short-output contract with explicit Tier-A routing reason to keep request behavior deterministic and low-cost


## 2026-02-14

### Backend

- [x] **Harden GPT-5 request shaping by stripping unsupported stop parameter**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Keep legacy `stop` only for non-GPT-5 chat requests so GPT-5 nano/mini routing no longer sends unsupported `stop`
- [x] **Execute safe OpenAI SDK migration with dual-compat request paths**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add SDK-compatible request creators for Chat Completions/Responses (legacy + modern client paths) and route chat calls through compatibility wrapper
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Add compatibility wrappers for responses/chat/completions/embeddings APIs across SDK generations and normalize legacy response extraction for object/dict payloads
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Default GPT-5 Responses requests to `reasoning.effort=minimal` when unset to avoid reasoning-only incomplete outputs under tight token budgets
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Apply the same GPT-5 Responses minimal-reasoning default in non-router adapter path for consistent behavior
 - `requirements.txt`: Bump OpenAI SDK pin from `0.27.0` to `2.21.0`
 - `railway-requirements.txt`: Bump OpenAI SDK pin from `0.27.0` to `2.21.0`
- [x] **Eliminate residual SDK v2 embedding break and Responses token-floor noise**
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Reorder compatibility wrappers to prefer modern SDK APIs before legacy proxies (prevents `openai.Embedding` removed-in-v1 errors on v2)
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Reorder chat-completions compatibility path to prefer modern SDK endpoints and clamp Responses `max_output_tokens` to API minimum (>=16)
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Clamp Responses `max_output_tokens` to API minimum (>=16) in non-router adapter path

---
## 2026-02-13

### Backend

### Backend

- [x] **Mark post-recovery memory verification runbook steps from 2-step baseline evidence**
 - `docs/contracts/!memory.md`: Checked completed preflight/baseline/sections 1-8 items supported by analytics findings, leaving full-run and not-triggered checks open
- [x] **Update memory verification runbook after extended 32-step continuation**
 - `docs/contracts/!memory.md`: Mark full-length Run A completion and Step 11 acceptance from continued-run evidence, while keeping script/metric-dependent checklist items open
- [x] **Close Section 1 SOT fallback inspection from retrieval-traffic evidence**
 - `docs/contracts/!memory.md`: Mark `get_memory_read_sot_stats()` verification complete and record fallback-reason check as N/A because fallback count remained zero
- [x] **Close Section 4 contextual spot-check from extended verbose run evidence**
 - `docs/contracts/!memory.md`: Mark planning/chat contextual grounding spot-check complete based on coherent intent + structured chat samples across steps 3/4/12/13
- [x] **Add temporary live-process verification export for Sections 5-9**
 - `reverie/backend_server/reverie.py`: Add interactive command `export verification stats [hours]` to dump routing, retrieval, sync/migration, cache/flush, and Section 9 guardrail report into `test-results/` from the running simulation process
- [x] **Close Sections 5-9 runbook checks from live-process verification export**
 - `docs/contracts/!memory.md`: Mark Section 5 routing stats, Section 6 repeated-work safeguards, Section 7 sync/index/cache checks, and Section 9 report validation complete with documented non-critical startup token violation and D. CONDITIONAL PASS
- [x] **Convert memory contract into current-state SOT with dedicated tuning guide**
 - `docs/contracts/!memory.md`: Replace backlog/runbook-heavy structure with implementation SOT, operational validation contract, and a clear one-knob-at-a-time tuning section (parameters, order, stop conditions, and acceptance rules)
- [x] **Align GPT-5 transition plan with current memory validation contract**
 - `docs/-3.smart-model.md`: Update rollout gates to require 20-40 baseline runs, add `export verification stats 24` + `analyze_sim` checks, enforce DB-first/fallback health metrics, and replace stale memory-section wording with explicit memory-contract invariants
- [x] **Apply Step 1 Tier A/B model ID cutover for GPT-5 transition**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Change `MODEL_CONFIG` defaults to `TIER_A_MICRO=gpt-5-nano` and `TIER_B_REASONING=gpt-5-mini` while keeping Tier C routing policy/guards unchanged
- [x] **Apply Step 2 centralized GPT-5 request shaping in router**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add shared chat request builder that maps GPT-5 `max_tokens` to `max_completion_tokens`, omits GPT-5 sampling params by default, keeps non-GPT-5 behavior intact, and supports optional `gpt-5.2` reasoning payload injection
- [x] **Apply Step 3 transport adapter for direct GPT utility calls**
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Add unified `llm_text_request(...)` adapter with `OPENAI_API_STYLE=chat_completions|responses`, normalize response text/usage shape for callers, and route direct request helpers through the adapter with safe Responses->Chat Completions fallback
- [x] **Apply Step 4 batch-path GPT-5 request shaping and model pin support**
 - `reverie/backend_server/persona/prompt_template/batch_manager.py`: Add centralized batch request builder to map GPT-5 token key (`max_completion_tokens`), omit GPT-5 sampling params by default, support optional GPT-5.2 reasoning payload, and add `BATCH_MODEL_OVERRIDE` pin for controlled compatibility rollout
- [x] **Apply Step 5 parse-critical hardening for decomposition paths**
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Add bounded parse-critical retry control (`PARSE_CRITICAL_MAX_RETRIES`), mark decomposition flows as formatting-sensitive (`disable_tier_c_for_formatting`), and harden overflow clamp logic in task decomposition cleanup
- [x] **Apply Step 6 cost-table continuity for active GPT-5 routing models**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Extend `MODEL_COSTS` with GPT-5 IDs (`gpt-5-nano`, `gpt-5-mini`, `gpt-5`, `gpt-5.2`) to keep existing token/cost observability rollups stable after model ID migration
- [x] **Rewrite Step 7 runbook section to reflect current validation status**
 - `docs/-3.smart-model.md`: Replace Step 7 checklist block with brief conditional-pass assessment from `20260213-3`, include explicit non-blocking risks, and set guarded go/no-go for Step 8 rollout
### Backend | Tests

- [x] **Compact verification dataset for sim 20260209-7**
 - `tests/analyze_compacted_dataset.py`: Script to collect chat cadence, dorm-stuck windows, stationary activity metrics

- [x] **Supabase verification script for thought memories and agent_id mapping**
 - `supabase/scripts/verify_thought_memory_id_mapping.sql`: SQL to verify dbl_memory thought rows and agent_id vs personas.id match

- [x] **Add phased Responses API rollout controls with rollback**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add API style policy (default, allowlist, denylist), Responses execution path, fail-open fallback, and API-style observability stats for routed Tier A/B/C calls
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Apply matching allowlist/denylist style resolution and configurable fail-open behavior for non-router adapter calls
- [x] **Implement Step 9/10 runtime posture and Step 11 tomorrow test runbook**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Set Tier C default model to `gpt-5.2`, enable Tier C with empty default allowlist posture, default GPT-5.2 reasoning effort to `none`, and add minimal provider seam (`LLM_PROVIDER`, `LLM_MODEL_TIER_A/B/C`) with hard-fail for unsupported providers plus OpenAI-first capability map placeholders
 - `docs/README.md`: Document new LLM/provider env keys, Responses rollout toggles, and updated Tier C defaults (enabled with empty allowlist)
 - `docs/-3.smart-model.md`: Mark Steps 9 and 10 implemented under selected constraints and replace Step 11 with a comprehensive tomorrow execution checklist (preflight, validation runs, acceptance gates, rollback drill, release gate)

## 2026-02-12
### Backend

 - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: Add Supabase-first memory flags, typed memory-write API (`TypedMemoryEntry`), DB-first retrieval path, and fallback observability counters
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Default DB reads to true, add `MEMORY_READ_FALLBACK_ON_DB_ERROR`, and expose fallback telemetry via `get_memory_read_sot_stats()`
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Set `USE_DB_MEMORY_READS` default to true
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Set `USE_DB_MEMORY_READS` default to true
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Set `USE_DB_MEMORY_READS` default to true
 - `reverie/backend_server/reverie.py`: Align `new_retrieve` import with Supabase-first DB read default and JSON fallback
- [x] **Implement Section 2 prompt-memory budget controls**
 - `reverie/backend_server/persona/prompt_template/prompt_budget.py`: Add per-prompt budgets (chat/planning/action/reflection), utility ranking, truncation, two-step recall packing, and hard injected-context caps
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Enforce budgeting in planning/action/chat prompt assembly (schedule/decomp, decide_to_talk/react, chat summarize/iterative utterance inputs)
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Apply budgeted memory statement selection for relationship/idea summarization and reflection idea prompts
- [x] **Implement Section 3 retrieval dedup/diversity + hybrid ranking**
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Add task-type retrieval profiles, candidate expansion, weighted vector+lexical+RIR merge, near-duplicate collapse, and diversity-aware top-N selection
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Pass explicit `task_type="chat"` to retrieval (with backward-compatible fallback)
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Pass explicit `task_type="planning"` to retrieval (with backward-compatible fallback)
 - `reverie/backend_server/persona/cognitive_modules/reflect.py`: Pass explicit `task_type="reflection"` to retrieval (with backward-compatible fallback)
 - `reverie/backend_server/reverie.py`: Pass explicit `task_type="chat"` for runtime one-utterance generation retrieval
 - `reverie/backend_server/persona/persona.py`: Pass explicit `task_type="chat"` in shared-RIR memory pull
 - `docs/README.md`: Document new Section 3 retrieval tuning env flags
- [x] **Implement Section 4 unified context injection for prompt entry points**
 - `reverie/backend_server/persona/prompt_template/context_builder.py`: Add default shared context builder that consistently composes relationship, recency, emotional weight, and location context
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Wire shared context block into planning (`daily_plan`, `generate_hourly_schedule`, `task_decomp`), action (`decide_to_talk`, `decide_to_react`), and chat (`agent_chat_summarize_ideas`, `agent_chat_summarize_relationship`, `run_gpt_generate_iterative_chat_utt`) prompt builders
- [x] **Implement Section 5 agent-based-system routing skeleton (A/B/C)**
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add Tier C routing contract, per-step Tier C quota controls, reason-code observability, allowlist gating, and default Tier C-disabled posture
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Add schema/fmt retry guard to block Tier C on validation retries and route JSON wrappers with Tier C disabled for formatting-sensitive paths
 - `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py`: Mark narrow high-impact prompts (`daily_plan`, `create_conversation`) as Tier C candidates with explicit reason codes (still quota/allowlist guarded)
- [x] **Implement Section 7 memory sync/index reliability + cost controls**
 - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: Add incremental dirty/debounce memory sync queue with delta-threshold/forced flush triggers, batched sync writes, pending flush on save, and sync telemetry
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Key embedding cache by content hash + provider/model fingerprint, add embedding provider fallback flow, and add safe temporary-index reindex + atomic swap/rollback helpers
- [x] **Implement Section 9 memory quality + cost regression checks**
 - `reverie/backend_server/persona/prompt_template/prompt_budget.py`: Track prompt-memory duplicate-rate/selection aggregates and expose `get_prompt_memory_stats()` for regression reporting
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Add retrieval freshness lag metrics, forced fallback rate, embedding fallback/reindex counters, and expose `get_retrieval_quality_stats()`
 - `reverie/backend_server/persona/prompt_template/model_router.py`: Add `tier_counts` in routing stats and Tier C realism feedback API/aggregates via `record_tier_c_realism_delta(...)`
 - `reverie/backend_server/persona/prompt_template/gpt_structure.py`: Extend performance logs with step/conversation/routing metadata and add Section 9 regression guardrail report helpers (`get_section9_regression_report`, `evaluate_section9_guardrails`)
- [x] **Implement Step 10 backend-first headless readiness hardening**
 - `reverie/backend_server/headless_visualization.py`: Enforce FE-confirmed composite readiness gate (`__headlessReady` + execute hook + animation manager + collision manager bound), defer execution when not ready, and emit structured readiness/execution diagnostics in step validation results
 - `reverie/backend_server/reverie.py`: Classify strict failures by readiness root cause, track readiness transitions plus cumulative blocked/deferred step counters, and persist per-step headless integrity snapshot for triage
 - `docs/README.md`: Document composite readiness contract and backend observability counters for headless strict mode operations

- [x] **Implement Step 12 low-risk token savings and retrieval activation observability**
 - `reverie/backend_server/persona/cognitive_modules/planning_cache.py`: Add per-persona/per-day wake-up-hour cache (in-memory + optional persisted sidecar files), compatibility fallback from cached plan files, and wake-up cache telemetry in cache stats
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Use wake-up-hour cache before calling wake-up prompt and store generated wake-up-hour immediately to prevent repeated startup LLM calls
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Add explicit hybrid-retrieval activation counters/log cadence and expose `get_hybrid_retrieval_activation_stats()` + `get_retrieval_quality_stats()` for validation scripts

---
## 2026-02-11

### Backend

- [x] **Align simulation list status with Supabase DB status source**
 - `api_gateway/app/services/supabase_service.py`: Resolve `/api/simulations/` status from `double.simulation_statuses` (with metadata fallback), matching `/api/simulations/{sim_code}/status` behavior

- [x] **Relax over-tight morning chat suppression while keeping anti-spam guards**
 - `reverie/backend_server/reverie.py`: Make pair cooldown env-configurable (default 15), increase brief-chat pass probability (default 0.90), and add first-daily-encounter overrides for buffer/cooldown/sparsity in unified `_attempt_pair_chat`
 - `reverie/backend_server/persona/persona.py`: Split chat buffer cooldowns by tier with env defaults (`GREETING_BUFFER_COOLDOWN_MIN=15`, `FULL_CHAT_BUFFER_COOLDOWN_MIN=45`) so greetings can recur naturally without full-chat spam

- [x] **Sync chat contract SOT with first-daily encounter and cooldown tuning**
 - `docs/contracts/!chats.md`: Update observation-path pre-flight/classification contract, add first-daily encounter override semantics, and document new env defaults (`PAIR_CHAT_COOLDOWN_STEPS`, `BRIEF_CHAT_BASE_PROB`, tiered buffer cooldown minutes)

## 2026-02-10
### Backend - Movement system improvements, Avoid repetetive chats

- [x] **Close chat repetition + memory visibility P0 gaps**
 - `reverie/backend_server/reverie.py`: Add single `_attempt_pair_chat` gate and route proximity + movement-interrupt chat triggers through unified cooldown/buffer/active-chat checks
 - `reverie/backend_server/reverie.py`: Propagate canonical `personas.id` mapping from Supabase bootstrap into persona memory stores
 - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: Resolve `dbl_memory.agent_id` from canonical persona UUID (propagated or DB lookup), remove UUID5 fallback, and cache persona identity
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Expose persona-id resolve/cache helpers for runtime propagation

- [x] **Harden canonical persona-id enforcement for memory writes**
 - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: Validate `persona.agent_id` as UUID before using it; otherwise continue canonical resolution path

- [x] **Refresh movement docs for unified chat gate + canonical memory identity**
 - `docs/README.md`: Update movement architecture/stability sections to document single pair-chat gate across runtime triggers, 60-step cooldown policy, movement-report chat interrupt routing, and canonical persona-id memory visibility note

- [x] **Improve intent correctness and natural stationary micro-movement behavior**
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Prioritize exact `address_tiles` zone resolution, remap Oak Hill College fallback to college-zone semantics, and gate zero-speed stationary intent to in-zone in-place actions
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Restrict sleep/rest/idle zero-speed fallback to in-zone states to avoid freezing while still en route
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: Make short in-place activities truly stationary, add constrained long-activity fidgets with cooldown and anti-reversal memory, and emit idle visual hints
 - `reverie/backend_server/reverie.py`: Include optional `idle_visual_hint` in movement meta for frontend-side in-place animation variation
 - `tests/analyze_sim.py`: Add movement-truth metrics section to compact reports for faster realism regression checks

- [x] **Split oversized tilesets for mobile GPU** — 5 interior tileset PNGs (up to 10642px tall) exceeded Android's 4096px `MAX_TEXTURE_SIZE`, rendering as black squares. Split into 14 chunks ≤4096px using `sharp`, updated tilemap JSON with correct GID ranges, and updated `MainScene.ts` image loads/tileset registrations. Extrusion params preserved per-chunk.

- [x] **Close chat repetition + memory visibility P0 gaps**
 - `reverie/backend_server/reverie.py`: Add single `_attempt_pair_chat` gate and route proximity + movement-interrupt chat triggers through unified cooldown/buffer/active-chat checks
 - `reverie/backend_server/reverie.py`: Propagate canonical `personas.id` mapping from Supabase bootstrap into persona memory stores
 - `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py`: Resolve `dbl_memory.agent_id` from canonical persona UUID (propagated or DB lookup), remove UUID5 fallback, and cache persona identity
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Expose persona-id resolve/cache helpers for runtime propagation

- [x] **Restore proximity-duration fidelity and intentional seek-to-chat behavior**
 - `reverie/backend_server/headless_visualization.py`: Forward top-level observation `duration` while preserving `details.duration` compatibility
 - `api_gateway/app/models/simulation.py`: Extend `ObservationModel` with optional top-level `duration` for proximity payload pass-through
 - `api_gateway/app/api/routes/simulations.py`: Persist proximity `duration` to pending observation queue entries
 - `reverie/backend_server/reverie.py`: Normalize duration/distance extraction from both top-level and `details`, fix proximity dedupe aggregation, and support deliberate pair-intent override to avoid missing intended chats
 - `docs/!chats.md`: Document duration normalization and deliberate-intent override in observation-primary flow

- [x] **Fix proximity chat crashes from dict-backed memory retrieval**
 - `reverie/backend_server/persona/cognitive_modules/converse.py`: Add retrieval normalization/wrappers so Supabase dict rows expose legacy `embedding_key`/`description` fields used by chat summarization and utterance prompts
 - `reverie/backend_server/persona/persona.py`: Harden shared RIR and internal-pressure calculations to support both object and dict memory nodes without attribute errors
 - `reverie/backend_server/reverie.py`: Add safe wrapper for internal-pressure scoring to prevent `_get_internal_pressure_score` NameError in chat tier classification

- [x] **Prevent hard crash on partial/invalid headless movement reports**
 - `reverie/backend_server/reverie.py`: Add configurable headless strictness controls (`HEADLESS_STRICT_MODE`, `HEADLESS_STRICT_ABORT`, minimum accepted ratio/count) and degrade strict failures to warnings unless explicit abort is enabled

---
## 2026-02-09

### Backend

- [x] **Enforce per-step chat emission + pairing metadata**
 - `reverie/backend_server/persona/persona.py`: Set one-step chat slice step when available to prevent repeats
 - `reverie/backend_server/reverie.py`: Gate stale chat slices, infer pairing metadata, omit metadata on empty chat, and clear one-shot chat state after emit
- [x] **Stabilize movement intents for playback**
 - `reverie/backend_server/reverie.py`: Apply replan cooldown, zone clamp, and intent hysteresis for planned_pos
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: Compute zone anchor for target zones
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Persist intent stabilization fields

- [x] **Fix 1: Remove deviation-based replan in INTENT_ONLY mode**
   - `reverie/backend_server/reverie.py`: Remove `deviation > 2` from replan condition in `_handle_movement_report()`; replace deviation-based movement regeneration with replan-based in `process_pending_observations()`; remove unused `DEVIATION_TOLERANCE` constant

- [x] **Fix 2: Add per-pair conversation cooldown (10-step gap)**
   - `reverie/backend_server/reverie.py`: Add `PAIR_CHAT_COOLDOWN_STEPS=10` constant and `pair_chat_cooldowns` dict; insert cooldown check before tier classification in proximity processing; record pair cooldown after `trigger_conversation()` call

- [x] **Fix 3: Remove `remaining_path` dead code (INTENT_ONLY mode)**
   - `reverie/backend_server/reverie.py`: Remove entire continuation block (prev_remaining lookup, CP-3 logging, gap validation); set all `remaining_path_for_write` to `[]`; remove `persona.scratch.remaining_path` and `planned_path` persistence; simplify `final_remaining_path` to always `[]`

- [x] **Fix 4: Fix `pre_interrupt_pos` blend-back via chat state transition**
   - `reverie/backend_server/reverie.py`: Add blend-back check before path planning using `pre_step_chatting_with` snapshot; expire blend-back when action address changes
   - `reverie/backend_server/persona/persona.py`: Store `pre_interrupt_act_address` alongside `pre_interrupt_pos` in `trigger_conversation()`
   - `reverie/backend_server/persona/cognitive_modules/execute.py`: Remove old blend-back code (now handled in `reverie.py` movement generation)

- [x] **Revised movement pipeline investigation request**
 - `docs/!moves.md`: Expanded from 5 to 8 pipeline checkpoints (added remaining_path continuation, chat damping vs interrupt separation, pre_interrupt_pos blend-back, headless report timing); incorporated 20260209-1 sim analysis identifying 3 failure modes (Luba y-drift, Ivan chat oscillation, group clustering lock); added 7 prioritized fix recommendations with specific file/line locations
- [x] **Added 8 diagnostic checkpoint logs across movement pipeline**
 - `reverie/backend_server/reverie.py`: CP-2a (backend path estimate), CP-3 (remaining_path continuation/invalidation), CP-4a (proximity interrupt), CP-4b (chat damping), CP-6 (movement serialization), CP-7 (position resolution source), CP-8 (report timing)
 - `reverie/backend_server/persona/cognitive_modules/plan.py`: CP-1 (intent & planning inputs with zone_anchor, target_zone, cooldown)
 - `reverie/backend_server/persona/persona.py`: CP-5 (pre_interrupt_pos storage on conversation trigger)
 - `reverie/backend_server/persona/cognitive_modules/execute.py`: CP-5 (pre_interrupt_pos blend-back consumption with direction/distance)
 - `reverie/backend_server/headless_visualization.py`: CP-8 (report submit timing), CP-2b console capture prefix

## 2026-02-08

### Backend

- [x] **Harden full-chat continuations and payload consistency**
 - `reverie/backend_server/reverie.py`: Skip retriggering full chats when a continuation is active and track skipped-active stats
 - `reverie/backend_server/reverie.py`: Clear chat metadata when no chat slice, and align sampling cap distance to 5 tiles
- [x] **Stabilize conversation identifiers**
 - `reverie/backend_server/persona/persona.py`: Remove step token from conversation_id to keep IDs stable across steps
- [x] **Backfill chatting_with on continuation slices**
 - `reverie/backend_server/reverie.py`: Infer 1:1 chat partner from the queued transcript when chatting_with is missing
- [x] **Harden chatting_with inference for continuations**
 - `reverie/backend_server/reverie.py`: Prefer the current slice speakers before falling back to the queue

## 2026-02-07
### Backend

- [x] **Refresh chat SOT with current implementation**
 - `docs/!chats.md`: Align triggers, tiers, payload nuance, WS channel usage, and bubble constraints
- [x] **Add full-chat slicing and metadata continuity**
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Add continuation fields for cross-step chat slicing
 - `reverie/backend_server/persona/persona.py`: Store conversation_id, observation metadata, and full-chat queue for slicing
 - `reverie/backend_server/reverie.py`: Slice full chats per step, add sampling-based max_exchanges cap, and merge chat metadata fields
 - `api_gateway/app/core/validation.py`: Allow conversation_id, message_index, and observation metadata in chat_metadata
- [x] **Normalize snapshot timestamps and duration fallback**
 - `reverie/backend_server/reverie.py`: Normalize pre-step chat metadata timestamps to milliseconds
 - `reverie/backend_server/persona/persona.py`: Fallback to observation details.duration for proximity_duration


- [x] **Add full-chat slicing and metadata continuity**
 - `reverie/backend_server/persona/memory_structures/scratch.py`: Add continuation fields for cross-step chat slicing
 - `reverie/backend_server/persona/persona.py`: Store conversation_id, observation metadata, and full-chat queue for slicing
 - `reverie/backend_server/reverie.py`: Slice full chats per step, add sampling-based max_exchanges cap, and merge chat metadata fields
 - `api_gateway/app/core/validation.py`: Allow conversation_id, message_index, and observation metadata in chat_metadata
- [x] **Normalize snapshot timestamps and duration fallback**
 - `reverie/backend_server/reverie.py`: Normalize pre-step chat metadata timestamps to milliseconds
 - `reverie/backend_server/persona/persona.py`: Fallback to observation details.duration for proximity_duration

## 2026-02-06

### Backend

- [x] **Added Supabase MCP to this project**
   - `D:\Coding\generative_agents\.cursor\mcp.json`: Add project_ref query to target jawqllnvvlmosxlwjrei

- [x] **Harden safe Supabase lints without frontend impact**
 - `supabase/migrations/20260206000001_security_lints_safe.sql`: Move extensions to `extensions`, set RPC search_path, and tighten waitlist insert checks

- [x] **Make search_path updates editor-safe**
 - `supabase/migrations/20260206000001_security_lints_safe.sql`: Gate ALTER FUNCTION via `to_regprocedure` to avoid SQL editor syntax errors

## 2026-02-05

### Backend

- [x] **Ensure forked sims copy full step history**
 - `reverie/backend_server/reverie.py`: Request Supabase fork to copy coords
 - `reverie/backend_server/persona/memory_structures/double_memory_client.py`: Default fork copies coord history
 - `supabase/migrations/20260205000001_phase6_fork_copy_coords_default.sql`: Default fork_simulation to copy coords
 - `tests/verify_fork_requirements.py`: Set fork tests to copy coords
 - `tests/validate_phase6_fork_support.py`: Set fork test to copy coords

- [x] **Copy movement payloads during fork**
 - `supabase/migrations/20260205000001_phase6_fork_copy_coords_default.sql`: Include movement JSON in coord copy
 - `supabase/migrations/20260205000002_phase6_fork_copy_movement.sql`: Apply movement copy in fork_simulation

- [x] **Initialize monitoring for resumed sims**
 - `reverie/backend_server/persona/cognitive_modules/location_monitor.py`: Ensure monitor uses the current sim name
 - `reverie/backend_server/reverie.py`: Initialize monitoring on every step with sim code

- [x] **Align simulation status updates with Supabase SOT**
 - `reverie/backend_server/reverie.py`: Sync Supabase status on run, pause/resume, and completion
 - `api_gateway/app/services/supabase_service.py`: Use status RPC and normalize failed → stopped
 - `api_gateway/app/services/simulation_control.py`: Push pause/resume status to Supabase
 - `api_gateway/app/services/background_tasks.py`: Remove premature completion status update

- [x] **Fix Supabase metadata status lookup**
 - `api_gateway/app/services/supabase_service.py`: Remove invalid await so status uses RPC result

- [x] **Use Supabase-aware status/current lookup**
 - `api_gateway/app/api/routes/simulation_control.py`: Read status/current via ResilientService for Supabase forks

- [x] **Detect oscillation, jitter, and efficiency anomalies**
 - `tests/analyze_sim.py`: Add ping-pong cycles, jitter ratio, low efficiency, path overkill, and persistent zone flags

- [x] **Reduce false positives for target-zone drift**
 - `tests/analyze_sim.py`: Normalize zone bounds, add travel grace and buffer, and gate outside-zone flags by action context

- [x] **Enable forked simulations**
Forked simulations now copy full coordinate history and movement payloads by default, so playback/rewind has complete movement context.
Resumed simulations now reinitialize monitoring with the correct sim name each step, reducing stale or mismatched live updates.

- [x] **Proper simulation status for LIVE/default playback**
Simulation status is now synced consistently via Supabase (run/pause/resume/complete), avoiding premature “complete” states.
Supabase status/current lookups were corrected to use the RPC/ResilientService path, fixing stale or failed metadata reads in forked sims.


## 2026-02-04

### Backend
### Backend

- [x] **Refresh primary conversation system docs (observation-primary + tiered chats)**
 - `docs/!chats.md`: Document unified observation-triggered conversation flow, env flags, fallback plan-path, pre-flight checks, and tiered greeting/full exchange limits

- [x] **Document chat bubble visualization pipeline (live WS + Supabase playback)**
 - `docs/!chats.md`: Add end-to-end breakdown of how `chat`/`chatting_with`/`chat_metadata` are produced, serialized into movement payloads, and normalized in `useRealtime` + `usePlayback` for bubble rendering

- [x] **Re-organize chat docs into logical chapters**
 - `docs/!chats.md`: Convert log-style notes into a chaptered reference doc (overview, triggers, tiers, payload contracts, bubbles, debugging) with an appendix for historical implementation details

- [x] **Preserve chat payloads in API validation**
 - `api_gateway/app/core/validation.py`: Allow chat rows with timestamps, retain `chatting_with`, and pass through `chat_metadata` fields (`tier`, `timestamps`, per-message durations)   

- [x] **Fix completion metadata off-by-one for playback**
 - `reverie/backend_server/reverie.py`: Write completed meta current_step/total_steps from last completed step
 - `api_gateway/app/services/supabase_service.py`: Clamp file-based status steps to available movement files

- [x] **Prefer Supabase metadata for status**
 - `api_gateway/app/services/supabase_service.py`: Ignore file meta for status/current_step when Supabase SOT enabled

- [x] **Disable file fallback for status when SOT enabled**
 - `api_gateway/app/services/resilient_service.py`: Skip filesystem status fallback if Supabase SOT is on

- [x] **Profile pgvector collisions and log per-query latency**
 - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Log per-focal retrieval latency for accurate metrics
 - `scripts/profile_pgvector_collisions.py`: Add sample-based collision profiler for dbl_embedding vectors

- [x] **Add collision sampling hooks and richer collision profiling output**
  - `reverie/backend_server/persona/cognitive_modules/retrieve_double.py`: Sample compression collisions with hashed embeddings and summary logs
  - `scripts/profile_pgvector_collisions.py`: Include memory IDs and top near-duplicate pairs in collision reports

- [x] **Fix pgvector profiler Supabase schema handling**
 - `scripts/profile_pgvector_collisions.py`: Support clients without schema() helper

- [x] **Parse string embeddings in pgvector profiler**
 - `scripts/profile_pgvector_collisions.py`: Convert string vectors to float lists and skip mismatched dims

- [x] **Draft natural progression investigation plan**
 - `docs/natural-progression.md`: Add investigation steps tying memory collisions to movement pipeline checks

- [x] **Default analyze_sim to API data source**
 - `tests/analyze_sim.py`: Switch default source to API and update usage/docs to require explicit Supabase mode

- [x] **Draft simulation generation speedup plan**
 - `docs/-sim-gen-speedup.md`: Outline phased plan for headless reuse, resets, instrumentation, and safeguards

- [x] **Respect explicit API URL override in analyze_sim**
 - `tests/analyze_sim.py`: Use CLI/env override for API URL without loading .env.local

- [x] **Refine chat audit signals and reduce false positives**
 - `tests/analyze_sim.py`: Separate structured vs description-only cues, tighten missing-payload flags, and log keyword hits

- [x] **Fix interaction timestamp parsing**
  - `reverie/backend_server/persona/persona.py`: Use local datetime import to avoid module shadowing  

- [x] **Fix completion metadata off-by-one for playback**
 - `reverie/backend_server/reverie.py`: Write completed meta current_step/total_steps from last completed step
 - `api_gateway/app/services/supabase_service.py`: Clamp file-based status steps to available movement files

- [x] **Prefer Supabase metadata for status**
 - `api_gateway/app/services/supabase_service.py`: Ignore file meta for status/current_step when Supabase SOT enabled 

- [x] **Disable file fallback for status when SOT enabled**
 - `api_gateway/app/services/resilient_service.py`: Skip filesystem status fallback if Supabase SOT is on

- [x] **P1: Index Tuning (IVFFlat → HNSW?)**
  - `supabase/migrations/20260110100001_optimize_pgvector_indexes.sql`: Verified HNSW index `dbl_embedding_hnsw_optimized_idx` (m=16, ef_construction=64)

 
## 2026-02-03

### Backend

- [x] **Fix interaction timestamp parsing**
  - `reverie/backend_server/persona/persona.py`: Use local datetime import to avoid module shadowing

- [x] **Enforce Supabase-only reads and disable file fallbacks**
   - `api_gateway/app/services/file_service.py`: Add flag to skip coordinate authority on persona reads
   - `api_gateway/app/services/background_tasks.py`: Guard periodic tasks and skip authority in file sync
   - `api_gateway/app/services/supabase_service.py`: Enforce Supabase-only step reads and metadata fetch
   - `api_gateway/app/services/resilient_service.py`: Disable file fallback when Supabase SOT enforced
   - `tests/analyze_sim_move-api-supa.py`: Improve chat detection and frontend payload audit

- [x] **Update worklog format for structured entries**
   - `.cursor/rules/worklog-own-update.mdc`: Document H2/H3 checklist format with file-level summaries

- [x] **Preserve chat payloads in API validation**
 - `api_gateway/app/core/validation.py`: Allow chat rows with timestamps, retain `chatting_with`, and pass through `chat_metadata` fields (`tier`, `timestamps`, per-message durations)
 
- [x] **Including proper chat record for visualization in chat bubbles**
- api_gateway/app/services/file_service.py: Add flag to skip coordinate authority on persona reads
- api_gateway/app/services/background_tasks.py: Guard periodic tasks and skip authority in file sync
- tests/analyze_sim_move-api-supa.py: Improve chat detection and frontend payload audit

- [x] **P1: Backend Must Send `meta.curr_time` in Step Data (API-009)**
  - api_gateway/app/services/supabase_service.py: Enforce Supabase-only step reads and metadata fetch
  - api_gateway/app/services/resilient_service.py: Disable file fallback when Supabase SOT enforced
   
## 2026-02-02

### Backend: 

- [x] **Enforce greeting cooldown and add interaction affinity features**
   - `reverie/backend_server/persona/persona.py`: Enforced 60-min greeting cooldown buffers
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Enforced 60-min greeting cooldown buffers
   - `reverie/backend_server/persona/persona.py`: Added interaction affinity, topic boost, accidental deep chat override, and interaction tracking
   - `reverie/backend_server/reverie.py`: Added interaction affinity, topic boost, accidental deep chat override, and interaction tracking
   - `reverie/backend_server/persona/cognitive_modules/plan.py`: Added interaction affinity, topic boost, accidental deep chat override, and interaction tracking
   - `reverie/backend_server/persona/memory_structures/scratch.py`: Added interaction affinity, topic boost, accidental deep chat override, and interaction tracking

- [x] **Reset transient chat state and sync simulation time**
   - `reverie/backend_server/reverie.py`: Reset transient chat state on new sims, added debug chat payload log, and aligned reflection queries to thought memories
   - `reverie/backend_server/persona/memory_structures/scratch.py`: Reset transient chat state on new sims, added debug chat payload log, and aligned reflection queries to thought memories
   - `tests/analyze_sim_move-api-supa.py`: Reset transient chat state on new sims, added debug chat payload log, and aligned reflection queries to thought memories
   - `reverie/backend_server/reverie.py`: Sync persona scratch curr_time with simulation time at step start

- [x] **Persist and snapshot chat data for Supabase integration**
   - `reverie/backend_server/reverie.py`: Persist chat in Supabase movement JSON and pass through RPC playback
   - `api_gateway/app/services/supabase_service.py`: Persist chat in Supabase movement JSON and pass through RPC playback
   - `reverie/backend_server/reverie.py`: Snapshot pre-step chats to survive cleanup and serialize into movement payloads

- [x] **Enhance Supabase persona details and RPC handling**
   - `api_gateway/app/services/supabase_service.py`: Add Supabase persona details lookup
   - `api_gateway/app/api/routes/simulations.py`: Use Supabase persona details with file fallback
   - `api_gateway/app/services/supabase_service.py`: Add scratch row fallback + RPC error logging
   - `api_gateway/app/services/supabase_service.py`: Log RPC vs table scratch source
   - `supabase/migrations/20260202000002_fix_load_persona_scratch_rpc.sql`: Fix RPC return shape to avoid arg limit

- [x] **Enabled persona details endpoint**
`api_gateway/app/services/supabase_service.py` - Add Supabase persona details lookup
`api_gateway/app/api/routes/simulations.py`: Use Supabase persona details with file fallback

## 2026-01-31

### Backend

- [x] **Headless fallback normalization + timeout** `headless_visualization.py`
  - Normalize JSON-fallback step data from tiles → pixels before injection
  - Increased API fetch timeout to reduce fallback frequency
- [x] **Movement report idempotency** `api_gateway/app/api/routes/simulations.py`, `headless_visualization.py`
  - Dedupe `movement_report` by (step, persona) when writing `pending.json`
  - Headless submit path dedupes reports + avoids double-submission
- [x] **Continuation step correction (pending.json)** `reverie.py`
  - Infer next step from processed movement reports and bump `meta.json.step`
  - Prevents re-running completed steps under strict mode
- [x] **Continuation env sync guard** `reverie.py`
  - If `environment/<step>.json` missing but `movement/<step-1>.json` exists, create env file and continue (no backward reset)
- [x] **Task decomposition prompt hardening** `persona/prompt_template/v2/task_decomp_v3.txt`, `run_gpt_prompt.py`
  - Completed template, enforced response format, added validation + retry

## 2026-01-30

### Backend

- [x] **Supabase SOT priority + report.step persistence** `reverie.py`
  - Step-start position now sourced from Supabase (P2) before scratch cache
  - Movement reports persist with `report.step` to avoid wrong-step writes
- [x] **Headless strict gating (fail-fast)** `reverie.py`
  - Blocking mode now requires exactly 1 valid movement_report/persona/step
  - Fails fast with screenshot + pending.json pointers on invalid/missing reports

---

## 2026-01-28

### Backend

- [x] **Analytics Team and Frontend Dev Had Different Results**

The stored data gets corrected by post-step observation processing, but the API response sent to frontend has already used the wrong position.

*Root Cause Chain*

1. **Position resolution** sets `scratch.current_pos = [116,40]` (correct) ✅
2. **Action expires** in step 3
3. **plan.py** sets `scratch.curr_tile = [113,37]` (cafe TARGET) - overwrites!
4. **execute.py** uses `scratch.curr_tile` to compute path ❌
5. **API sends** `start_pos = [113,37]` (wrong - should be [116,40])
6. **Frontend** sees discontinuous path, duplicate data

*Fix Applied*

Changed `execute.py` to use `scratch.current_pos` (the authoritative actual position from `last_actual_pos`) instead of `scratch.curr_tile` (which gets overwritten to the TARGET during action planning).

- [x] **FIX: Process pending observations at START of each step**
  - Ensures headless reports from previous step update last_actual_pos
  - BEFORE position resolution, fixing path discontinuity in both blocking and non-blocking modes.

- [x] **Server Config: Playback-Only Mode**
  Local PC (Ivan) → generates sims → Supabase
  Server (api.ondouble.com) → serves playback → Frontend/Users

- [x] **Added missing "start_pos" to batch fetch**
  After this fix, each persona in the API response will have:
  ```json
  {
  "persona": {
    "Luba Pistsova": {
      "movement": [120, 45],     // end position (tiles)
      "start_pos": [123, 48],    // start position (tiles) ← NOW INCLUDED
      "path": [[123,48], [123,47], ...],
      "target_zone": {...},
      "speed_multiplier": 1.5,
      ...
    }
  }
}
```
---

## 2026-01-27

### Backend

- [x] **Coordinate Continuation Fix** - to run existing sim for more steps 

1. COMPLETED.json Creation (line ~1148-1160)
Added last_actual_pos to the saved persona state
Falls back to curr_tile if last_actual_pos not available
2. Continuation Restoration (line ~1218-1231)
Restores last_actual_pos from COMPLETED.json when continuing
Falls back to movement coords if last_actual_pos not in older files

- [x] **P0 Fix Applied**: Added deterministic keyword extraction to `generate_action_sector()` in `plan.py`.

```
Action: "go to library to study for SATs"
         ↓
[PHASE 1] Keyword Check: 'library' found → Oak Hill College
         ↓ (if accessible)
📍 KEYWORD MATCH: 'library' in 'go to library...' → Oak Hill College
         ↓
Return immediately (LLM bypassed)

---

## 2026-01-26

### Backend

- [x] **`TypeError` Fix in `scratch.py`**

**Root Cause**: `act_start_time` was `None` when `act_check_finished()` tried to perform datetime arithmetic. This happened because:
1. Supabase loading can fail silently when parsing `act_start_time` 
2. `act_address` gets loaded independently, creating an inconsistent state
3. No null guards existed in the datetime comparison code

**Fixes Applied** (4 locations in `scratch.py`):

| Location | Issue | Fix |
|----------|-------|-----|
| `act_check_finished()` L647+ | `act_start_time` can be `None` | Auto-recover: set to `curr_time` with warning log |
| `act_check_finished()` L657+ | `chatting_end_time` can be `None` | Return `True` (chat finished) |
| `act_check_finished()` L660+ | `act_duration` can be `None` | Default to 30 min |
| `act_time_str()` L631+ | Calls `.strftime()` on `None` | Fallback to `curr_time` |
| `act_summary_str()` L717+ | Calls `.strftime()` on `None` | Fallback to `curr_time` |
| Supabase loading L979+ | Silent exception + no consistency check | Log parse failures + auto-set `act_start_time` when `act_address` exists |


- [x] **Fixed interrupted sim after 13th step (likely delay from LLM)** 

| File | Change |
|------|--------|
| `tests/analyze_sim.py:331` | Fixed schema bug: `'id'` → `'uuid'` for dbl_memory table query |
| `reverie.py:1634-1660` | Added try/except around `persona.move()` with fallback (stay in place + recovery action) |
| `model_router.py` | Added 60s/90s timeout to Tier A/B LLM calls |
| `gpt_structure.py` | Added 90s timeout to all `openai.ChatCompletion.create()` calls |


- [x] **Fixed fractional target_zone bug** in `reverie.py:_trigger_replan()` — zone shrinking logic used float division creating values like `126.875` instead of integer tile coords. Changed `/` to `//` and wrapped results in `int()`.

- [x] **Fixed missing start_pos in API response** — `start_pos` was stored in Supabase but not passed to frontend. Required 3 fixes:
  1. `supabase_service.py` — extract `start_pos` from movement JSONB
  2. `coordinate_converter.py` — convert tiles→pixels
  3. `validation.py` — whitelist `start_pos` in `validate_movement_data()` (root cause: whitelist validator was dropping the field)

- [x] **Fixed task decomposition prompt pollution** in `task_decomp_v3.txt` — LLM was copying "Kelly Bronson" example into actual persona subtasks. Added explicit `--- END OF EXAMPLE ---` marker and instruction to use only the actual persona's name.

- [x] **P0: Include `target_zone` in Step Data for INTENT_ONLY Mode** `reverie.py`
  - **Problem:** When `BACKEND_INTENT_ONLY_PATH=True`, frontend couldn't compute A* paths because `target_zone` was missing from step data
  - **Root cause 1:** When using **continuation paths** (resuming previous step's remaining_path), `persona.move()` was never called → `plan()` never ran → `target_zone` never set
  - **Root cause 2:** When using **TRANSITION handler** (action switch smoothing), same issue - `plan()` skipped
  - **Fix 1:** Restore `target_zone` from previous step's movement data during continuation (line 1530-1536):
    ```python
    prev_persona_data = prev_move_data.get("persona", {}).get(persona_name, {})
    prev_target_zone = prev_persona_data.get("target_zone")
    if prev_target_zone and not getattr(persona.scratch, 'target_zone', None):
        persona.scratch.target_zone = prev_target_zone
    ```
  - **Fix 2:** Safety net before movement_data write (line 2162-2196) - if INTENT_ONLY mode and `target_zone` still None:
    1. Compute from `act_address` tiles (bounding box + 2 margin)
    2. Fallback: 10x10 zone around `planned_pos`
  - **Coverage:** All code paths (continuation, transition, normal) now populate `target_zone`


- [x] **Analysis Script Improvements (`tests/analyze_sim.py`)**
- **Extended chat detection** (lines 111-122): Added greeting indicators (`greet`, `morning`, `hello`, `hi`, `fancy seeing`, `good to see`, `wave`, `nod`, `acknowledge`)
- **New interaction reflections query** (lines 271-291): Queries `dbl_memory` for content containing "interaction" patterns from the tiered chat system
- **Enhanced summary statistics** (lines 283-295 + 337-341): Counts greetings vs full chats by poignancy threshold (≤5 = greeting, >5 = full)
- **New output section**: "INTERACTION REFLECTIONS" showing detected pseudo-chats with tier classification

- [x] **2. Pathfinding Zone Floor (`reverie/backend_server/reverie.py`)**
**Changes to `_trigger_replan()`** (lines 4010-4088):
- **Minimum zone enforcement**: 3x3 minimum zone size prevents collapse after multiple replans
- **Reachability validation**: Uses `find_nearest_reachable_in_zone()` to verify zone has walkable tiles
- **Fallback mechanism**: If zone is unreachable, expands to 5x5 around current position
- **Bounds clamping**: Ensures zone stays within maze dimensions

- [x] **Chat Storage Fix (`reverie/backend_server/persona/persona.py`)**
**Changes to `trigger_conversation()`** (lines 505-573):
- **Sets `chatting_with`** on both agents' scratch state for all tiers (greeting + full)
- **Stores `chat` utterances** in scratch for analysis visibility
- **Buffer management**: 30s buffer for greetings, 60s for full chats
- **Logging**: Added confirmation log showing utterance count

---

## 2026-01-25

### Backend

- [x] **P1: Path Discontinuity Investigation (TIMELINE-004)** `reverie.py`
  - **Problem:** Replay showed teleportation - sprites jumping 5-6 tiles between steps instead of smooth walking
  - **Investigation:** Traced full `actual_path` storage flow: Headless → API → Backend → Supabase
  - **Finding 1:** Paths ARE being stored correctly in Supabase (movement.path has 2-7 waypoints per step)
  - **Finding 2:** Path discontinuity detected - each step's `path[0]` doesn't match previous step's end position
  - **Root cause:** Headless creates sprites at wrong position (using `movement` field instead of `last_actual_pos`), then computes A* from that wrong position
  - **Example:** Luba Step 0 ends at [119,46], Step 1 path starts at [115,44] → 6-tile gap

- [x] **P1: Add `start_pos` Field for All Steps** `reverie.py:2143-2149`
  - **Problem:** Backend only sent `start_position` for step 0; headless needed authoritative start position for all steps
  - **Fix:** Added `movement_data["start_pos"]` to ALL steps (not just step 0)
  - **Data source:** Uses `scratch.current_pos` which derives from:
    1. `scratch.last_actual_pos` (frontend-reported actual position from previous step)
    2. Supabase SOT (fallback)
    3. `personas_tile` (fallback)
  - **Frontend usage:** Headless should use `start_pos` to position sprites before A* computation

- [x] **P1: Fix `start_pos` Missing from Supabase Write** `reverie.py:2246`
  - **Problem:** After initial fix, `start_pos` was still NULL in Supabase for all rows
  - **Root cause:** The Supabase write path (lines 2246-2254) explicitly listed fields to include, and `start_pos` was NOT in the list
  - **Fix:** Added `"start_pos": pdata.get("start_pos")` to the movement_data dict in Supabase write
  - **Verification:** SQL query `SELECT movement->'start_pos' FROM personas_coords` should now return values

- [x] **P1: Simulation Test (20260125-1) - Identified Remaining Frontend Issues**
  - **Test results:** Backend `start_pos` calculation works (logs show correct values), but...
  - **Finding 1:** All sprites clamped to [139,99] (grid max) due to frontend clamping bug
    - Backend sends correct positions (e.g., Ivan at [131,48])
    - Frontend `pixelToTileClamped()` incorrectly forces valid coords to max boundary
  - **Finding 2:** Collision layer "MISSING" in headless despite chunks loading
    - Chunk data loads (4096 tiles) but collision layer not constructed
    - A*/BFS pathfinding fails 100% → sprites stay stationary
  - **Finding 3:** Chats trigger (greetings logged) but not persisted to `dbl_memory`
  - **Status:** Backend fixes complete; frontend bugs blocking movement

## 2026-01-23

### Backend

- [x] **P1: Personas Spawning Inside Collision Tiles (BUG-003)** `reverie.py`, `plan.py`
  - **Problem:** Some personas (Luba, Gosha) spawned inside walls/colliders, causing 32px snap on animation start and desync on pause
  - **Root cause:** `address_tiles` mapping includes ALL tiles for an address (including colliders); `random.choice()` could pick blocked tiles
  - **Fix:** Added `get_walkable_tiles(maze, address)` helper that filters `address_tiles` against `collision_maze`
  - **Applied to 3 locations:**
    - `reverie.py:504` - Initial spawn position selection (fallback creation)
    - `plan.py:1426` - Target coordinate assignment (`correct_coords`)
    - `plan.py:1546` - Zone bounds computation for pathfinding
  - **Result:** All persona positions now guaranteed walkable; eliminates frontend snap/desync symptoms

- [x] **P1: Forked Sims Inherit Collision Positions (BUG-003 cont.)** `reverie.py:573-604`
  - **Problem:** Forked sims still spawned personas inside colliders (e.g., Luba at [123,52])
  - **Root cause:** Previous fix only applied to fallback path when `environment/0.json` missing; forked sims copy JSON from base sim, so positions loaded directly without validation
  - **Fix:** Added walkability validation after loading positions from JSON - spiral search relocates blocked personas to nearest walkable tile
  - **Data flow:** JSON → `personas_tile` → Supabase (step 0) - fix ensures Supabase gets seeded with valid positions
  - **Result:** All forked sims now validate/correct spawn positions at initialization

- [x] **P2: Chat Metadata NoneType Error** `persona.py:537`
  - **Problem:** `TypeError: 'NoneType' object does not support item assignment` when assigning `chat_metadata['tier']`
  - **Root cause:** `getattr(agent1.scratch, 'chat_metadata', {})` returns `None` when attribute exists but is explicitly `None`
  - **Fix:** Changed to `getattr(..., None) or {}` to coerce `None` to empty dict

- [x] **P3: Supabase Query Syntax Error** `analyze_sim.py:278`
  - **Problem:** `AttributeError: 'SyncSelectRequestBuilder' object has no attribute 'or_'`
  - **Root cause:** `.or_()` method not available on supabase-py query builder
  - **Fix:** Replaced with Python-side filtering for chat keywords

- [x] **P2: Supabase SOT for Initial Coordinates (Phase 11)** `reverie.py`, `double_memory_client.py`
  - **Problem:** Fork initialization still reads step 0 positions from JSON (`environment/0.json`), even though Supabase has correct baseline data
  - **Root cause:** `reverie.py:567` always loads `init_env_file` JSON; Supabase only used for runtime writes
  - **Fix:**
    - Added `INIT_COORDS_PRIMARY` env var (`'supabase'` | `'json'`, default: `'json'`)
    - Added `get_step_positions(sim_code, step)` method to `SpatialCoordClient`
    - Modified init flow: when `INIT_COORDS_PRIMARY=supabase`, fetch step 0 from Supabase first, fallback to JSON if incomplete
  - **Data flow (new):** Supabase `personas_coords` step 0 → `personas_tile` → collision validation → Persona init
  - **Result:** Enables full Supabase SOT - no JSON dependency for position initialization

## 2026-01-22

### Backend

- [x] **P1: 1-Tier Chat Decision System** `plan.py`, `run_gpt_prompt.py`, `decide_to_talk_v2.txt`
  - Replaced 2-tier system (decide_to_talk yes/no → classify_tier) with single LLM call
  - LLM now returns "none"/"greeting"/"chat" directly
  - Fail-safe: defaults to "greeting" on LLM failure (was "no" → silence)
  - New `_greet_react()` routes greetings to hardcoded templates (zero LLM)
  - 68% token savings per greeting interaction

- [x] **P1: Hardcoded Greeting System** `greeting_generator.py` (NEW), `persona.py`
  - 30+ context-aware greeting templates (time, relationship, location)
  - `GreetingTracker` prevents repetitive greetings per pair
  - `trigger_conversation(tier="greeting")` routes to templates, not LLM
  - 100% token savings for greetings (~350 tokens/greeting)

- [x] **P2: Defensive Observation Processing** `reverie.py:process_pending_observations()`
  - Per-observation try/except/finally isolation
  - Failed observations tagged with `processing_error`, always marked `processed`
  - Statistics tracking: success/failed/skipped counts per type
  - Prevents single failure from halting all observation processing

- [x] **P0: Movement Speed Cap (Phase 10.9)** `reverie.py:91-93, 210-253, 1978-1993`
  - Added `MAX_TILES_PER_STEP=6` env var (configurable, default: 6 tiles/minute)
  - Added `clamp_position_to_max_distance()` helper function (Manhattan distance)
  - Clamps `planned_pos` to max 6 tiles from start in intent-only mode
  - Long journeys (e.g., 75-tile house→cafe) now split across ~12 steps
  - Stores `final_destination` + `remaining_distance` in movement_data for tracking
  - Fixes unnatural sprint animations; ensures ~0.6 tiles/sec walking speed

---

## 2026-01-21

### Backend

- [x] **P0: Intent-Only Path Mode (Phase 10.8)** `reverie.py:86-93, 1780-1845`
  - Added `BACKEND_INTENT_ONLY_PATH=true` env var (default: enabled)
  - Backend writes `path: [start_position]` + `planned_pos` (target hint)
  - Frontend computes A* on collision layer — fixes wall-walking
  - `partial_state.remaining_path` cleared in intent-only mode

- [x] **P1: Reachability Validation (Phase 10.8 Fix 6)** `reverie.py:101-202, 1897-1925`
  - Added `is_tile_reachable()` + `find_nearest_reachable_in_zone()` helpers
  - Validates `planned_pos` is reachable before writing to Supabase
  - Reroutes to nearest reachable tile in zone if original target blocked
  - Prevents "isolated pocket" destinations (walkable but surrounded by walls)

- [x] **P1: Position Resolution from Movement Reports (Phase 10.8 Fix 4)** `reverie.py:1243-1301, 3574-3580`
  - Position priority: `scratch.last_actual_pos` → Supabase SOT → env JSON → default
  - Movement reports update `last_actual_pos` for next step continuity
  - Ensures path planning uses actual frontend position, not stale backend estimate
  - Console logs position source (P1/P2/P3/P4) for debugging


## 2026-01-20

### Backend

- [x] **P0: Blocked Destination Tiles** `execute.py:504-550`
  - Added walkability validation, filters blocked tiles
  - Searches 5-tile radius if all tiles blocked

- [x] **P1: path[0] Anchoring** `reverie.py:1765-1772`
  - Uses `personas_tile` instead of stale `scratch.curr_tile`
  - Verified: all 4 personas match `last_actual_pos`

- [x] **P1: Step 0 Start Coordinates** `reverie.py:1743-1770`
  - Added `start_position` field for step 0
  - `path[0]` always equals spawn position

- [x] **P3: camelCase Normalization** `coordinate_converter.py`
  - Added camelCase fields with snake_case fallbacks

---

## File Reference
| File | Changes Made |
|------|--------------|
| `execute.py` | Walkability validation |
| `reverie.py` | path[0] anchoring, step 0 coords |
| `coordinate_converter.py` | camelCase normalization |
