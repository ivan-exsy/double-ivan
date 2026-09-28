# Pittsburgh sample — 20260923-1

Working note for the first downtown family morning. Ivan’s visual pass is at the bottom. Polish those rough edges before this maze is the primary Doubland map or a landing-page demo. This is a later Downtown world, not the Breakfasts watch. Breakfasts stays the village. Cap 6. Do not resume `20260923-1`. Do not Start `base_family_pittsburgh`.

Sim `20260923-1` finished locally on 2026-09-23. Maze `downtown`, 409 by 437. Clock 06:30 to 11:30 (300 minutes). Headless picture checks were off. Every step was decided from the local Pittsburgh floor, the same floor as the preview. Four people: Gosha Pistsov, Ivan Pistsov, Katya Pistsova, Luba Pistsova. Fork of paused baseline `base_family_pittsburgh`. Village `base_family_sim` was not touched.

The live checklist still says Luba never reached PPG Cafe. That sentence is only the last minute. She worked the cafe earlier, then went home. See Luba below.

---

## Playback

Watched 2026-09-23 on the local Pittsburgh player: `http://localhost:3000/simulations/20260923-1`. Phaser, not the 3D village. The page draws the furnished Downtown floors for this run. `?viewer=gateway` is optional. Without it, the page looks for a public copy, finds none, and reads the local run.

The preview at `/simulations/pittsburgh-preview` still shows the floors only. It does not replay this morning.

---

## Floor, before the people

Checked 2026-09-23 on the published collision. Preview files and engine files match.

- All 25 doors open onto the downtown street network (20 homes plus PPG Cafe, Fifth Avenue Market, EQT Supply Store, O’Reilly Pub, Penn College). Every walkable tile inside those places is reachable from its door.
- Liberty, Penn, Grant, Wood, Stanwix, Market Square, and the Point are one connected walk. Point State Park, East Park, Gateway Center Park, Mellon Square, and Arts Landing sit on that same network.
- All 868 object cells can be stood on and reached. 436 are inside the 25 places. 432 are park objects on Point State Park.
- Bridges do not join the North Shore or Station Square to downtown.
- Rivers are walkable, so a Double can step onto the water. That showed up in Ivan’s morning.

---

## How the four were set up

Each Double woke inside their own apartment, with a job, a life description, and a day plan for 23 Sep. Nothing in those records names the village.

| Double | Home | Job on file | Wake | What this morning’s plan actually does |
| --- | --- | --- | --- | --- |
| Gosha | Gateway Tower | Penn College | 6:00 | Library at Penn College, lunch at PPG later |
| Ivan | Encore on 7th | O’Reilly Pub | 10:00 | Sleep until 10, then a run toward Penn College |
| Katya | First & Market Apartments | EQT Supply Store | 7:00 | Morning at home: summer planning and baking practice |
| Luba | Six PPG Place | PPG Cafe | 6:00 | Open the cafe at 7, then paralegal work at her desk |

Two jobs are stored and are not what this morning uses. Ivan’s job is the pub. His day sends the late morning to Penn College. Katya’s job is the supply store. Her day keeps her at home.

They do not carry a personal map of the Triangle. Supabase has no place-map row for this sim. The places they can name from their lives are their own home, PPG Cafe, and Penn College. Every other apartment, shop, and the park live in the maze file. The engine can send someone to any matching object, including a building that is not theirs.

Memories at the end of the morning: Luba 66, Katya 36, Ivan 11, Gosha 23. Almost all events, one thought each. The thought is the day’s plan, written at 6:30. None of those memories name the village.

---

## How the morning went

No one jumped more than 6 tiles. No one spoke. No meeting was opened.

**Gosha** is the clean morning. Up at Gateway Tower, at Penn College by about 7:15, then studying at a library table with sofa breaks until 11:30. Those hours are in his record: the walk to the library, flashcards, essay notes, and a last break at 11:29.

**Luba** did reach PPG Cafe. She opened it around 7:04, worked the counter and the sink for about an hour, then went home and did paperwork. She walked back to the cafe twice more, for a minute or two each time. She ended at home, texting family about the August reunion.

**Ivan** slept until 10, which matches his wake time, then got ready at Encore. He left around 11:02 toward Penn College, not the pub. At 11:30 he was still on the street outside the college door. His record at that minute says he is in a classroom seat.

**Katya** never went to the supply store. She left First & Market, washed her face inside 11 Stanwix Street, walked home, and spent the rest of the morning practicing cake piping at her own desk.

---

## Obvious mishaps

1. **Katya used someone else’s apartment.** Her plan was to wash her face at her own sink. She walked out along First Avenue, washed up inside 11 Stanwix Street, and came home. “First & Market” was treated as First Avenue on the way out.
2. **Ivan walked on the river.** For eight minutes, about 11:16 to 11:23, the map had him on the Allegheny River while the line still said he was walking to Penn College. His route west from Encore ran along the water.
3. **Ivan’s ending place and his body disagree.** The record says a college classroom seat. The body is on the street outside the door.
4. **Luba’s later cafe trips do not match the line.** The first cafe hour is coherent. The two short returns have lines that describe the opposite errand, such as washing her hands before leaving while she is heading toward the cafe.
5. **Nobody spoke.** Four people, five hours, no conversation.

Gosha’s path, Luba’s first cafe shift, and Ivan’s sleep-until-10 are believable. The floor walk itself held: doors, streets, and objects were usable, and the steps stayed within the 6-tile cap.

---

## Ivan’s visual pass — 2026-09-23 afternoon

Watched the saved morning on the Downtown floors. These notes are what to polish before this maze becomes the primary Doubland map or a landing-page demo. Not a Breakfasts change. Do not resume `20260923-1`.

The wide Triangle is the opening shot: zoom 0.15, centered on tile 378, 264. Point and the park sit on the left, furnished blocks across downtown. People stay small at that zoom. Names stay readable. Done 2026-09-23.

### Movement — all four Doubles

Noticed while following Gosha. Ivan, Katya, and Luba move the same way. This is how playback draws every person on this map, not a Gosha path bug.

1. Each new minute is a jump to the next spot. There is no smooth walk between minutes. **Done as already built.** Playback draws a stored route when one was recorded. This morning has only the landing tile, because headless was off.
2. A straight walk to a place was cut to 3 tiles, then the player left them standing for the rest of the minute. **Done.** A step already inside the 6-tile cap is kept. A real jump is still cut. Do not raise the cap. Do not change 4:1. This morning’s file stays short. The next run writes the full step.

The earlier line “no one jumped more than 6 tiles” is the engine step cap. It does not mean the walk looks smooth.

### Gosha

| Clock | Status on the card | Body | Why now |
| --- | --- | --- | --- |
| 06:52 | Waking up and completing his morning routine at Home | Bathroom in Gateway Tower | Essay outline for college applications. Does not mention the bathroom. |
| 06:56–06:58 | Walking to Penn College library | Still moving inside the apartment | — |
| 06:59–07:13 | Walking to Penn College library | Out the door, on the streets, walking around obstacles. This part is correct. | — |
| about 07:15–07:17 | At Penn College | — | Just finished a scratch-paper essay outline and is reading it back. |

### Luba

| Clock | Status | Body | Why now |
| --- | --- | --- | --- |
| 06:38 | Waking up and completing her morning routine at home. Pass. | The bathroom. Pass. | Quiet moment at the common room table, paralegal work, texting the family about an August reunion in Kazakhstan. Wrong place and wrong errand. |
| 06:54–07:04 | Walking from home to PPG Cafe. Pass. On arrival: At PPG Cafe. Pass. | Left Six PPG Place through the door and continued on the streets. Pass. | Settled at the common room table with tea, rallying the family about the August reunion. Still the wrong place. |

The 07:17 map caption was “Luba preparing the breakfast pastry display at cafe — behind the cafe counter.” That matches the cafe arrival. It does not match the Why now line.

**Why now is done.** The card no longer shows that paragraph. The box is “On their mind”: the newest thought already stored for the minute on screen. No thought, the box is hidden. Each of the four has one thought, the day’s plan from 6:30. Done 2026-09-23.

### Katya — homes need a bathroom

Katya’s apartment has no restroom or shower. That is the likely reason her morning routine left the apartment. Her home has to be a place with a real bathroom.

Next pass: list every stamped home that has no bathroom. Add one, or stop offering that place as a home. A place without a bathroom can still be an office or a workplace. It cannot be where someone wakes up.

11 Stanwix Street is where she washed up this morning. That is someone else’s apartment. Already listed under mishaps. Do not treat it as her bathroom.

### Map readability

- Downtown is larger than the village, so the Doubles stay small at the default wide zoom. That zoom is 0.15, centered on tile 378, 264. Done 2026-09-23.
- Names stay the same readable size at every zoom. Names that would sit on the same spot stack in a short column, with a thin line back to each person. A combined group sticker is still **pending**. Done 2026-09-23.

### Follow a selected Double

Following Gosha does not stay locked.

- Focus and zoom drift off after a while.
- Dragging the timeline scrubber also drops the follow.

What this needs:

- A follow that stays on the selected person through play and through a scrub.
- The center-on button should do that job and stay on. It should take over what “Find My Double” does today.
- Right-click on that button should choose which Double is the default follow target.
- Check this against the camera rules already in the player before changing the button. The camera already has separate modes for dragging, following a target, idle “look at the group” follow, high-impact events, and holding still while a personal card is open. A locked follow must not fight those, and idle group-follow must not pull the camera off the chosen person.

This player also frames all four people once when the morning first appears. That one wide frame is separate from the follow button. Do not let it reset a follow the user already chose.

### Watch page chrome

The Pittsburgh player and the current Doubland map app have diverged. Before promoting this maze, decide which watch-page behaviors to keep, which to merge, and which to drop. Do not promote this page as-is.

- Remove “Bring Doubland to your organization — request an interactive simulation.” Landing owns customer signup. It does not belong on Watch.
- Remove the “Find My Double” button from this page. Keep its behavior on the center-on button, matching the current map app, plus the right-click choice above.

### What this pass does not decide

Commit, Join, Supabase tiles, switching the public Breakfasts watch off the village, a scored PPG Cafe day, building height, and park trees as walls. Those stay separate yeses after the rough edges above are polished.

## DONE:

Resolve these before the next downtown sim, or before continuing this one. Do not upload the Pittsburgh floor to Supabase for this. Do not resume `20260923-1` until the behavior items below are fixed. Cap 6. Do not change 4:1.

Three items wait on Ivan. They are marked **Decision**. The rest can be fixed without that yes.

Nobody spoke. That is not a task. The four were not in the same room long enough to meet.

- [x] **BE + FE — Headless walks the sim’s own floor.** Headless loads the same local Pittsburgh collision the engine already uses, including when it skips the picture. Before the first minute, the player reports the town and the size. The engine continues only when that is the sim’s maze: downtown, 409 by 437. A village route is not stored. Headless opens the player that can switch towns, and does not search nearby ports for a different app. The next downtown run can turn headless movement on. Do not resume `20260923-1`.

  **BE — done 2026-09-23, branch `ivan/downtown-headless-own-floor`.** A downtown run with headless movement on waits for the player’s floor report before the next minute. If that report is missing, or it is not downtown 409 by 437, the run stops and no walk is saved. The engine opens only the configured player. It does not search nearby ports, and it does not hand the player a village map id. Skipping the picture does not skip this check. Headless movement stays off until the player sends the report. A village sim is unchanged.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** Before the player marks itself ready, it publishes `window.__headlessMaze` from the Pittsburgh collision file it will walk: town `downtown`, size measured from that file (409 by 437). It does this when no picture is taken. A village file is reported as the village. A downtown run does not take a village map id. The next downtown run can turn headless movement on. Do not resume `20260923-1`.

- [x] **First & Market is not a home.** There is no room for a bathroom, so nobody can claim it as a place to wake up. The building stays on the map. It is not an office yet. Katya’s family baseline home is Midtown Tower, which already has a bathroom, next to the supply store. The finished morning `20260923-1` still shows her at First & Market. 11 Stanwix Street stays someone else’s apartment. Frontend does not add a bathroom.

- [cancelled] **BE — A morning sink stays inside that person’s own home.** Katya’s plan was her own sink. The walk treated “First & Market” as First Avenue and used the bathroom in 11 Stanwix Street.

- [x] **BE — Other apartments are private, and staff areas stay staff-only.** A Double does not need a personal map of every building. The engine already has the whole floor. The miss is that all 20 homes were open to an object search: downtown homes are not marked private, so the existing “stay out of someone else’s room” rule never fired. A sink, bed, desk, or closet is chosen in that person’s own home, or in a public place. Another resident’s apartment stays off that list. The same village rule applies inside public rooms. Behind the PPG Cafe counter is for the person whose job is that cafe, the way Hobbs keeps customers out of the staff side and lets the cafe worker through. Mark those spots staff-only, and name who may use them: the Double whose job is that place. Luba may stand behind the PPG counter. The other three may not. Do the same for a staff side at the pub, the supply store, and the market where one exists. Walking in does not make someone an employee.

  **BE — done 2026-09-23, branch `ivan/downtown-privacy-labels`.** The 20 apartment rooms are private, and those buildings are homes, so another resident’s apartment drops out of the search. The door and the street stay on the map. A public bathroom, a cafe seat, the college, and a park stay available. Behind the counter at PPG Cafe, O’Reilly Pub, the EQT Supply Store, and Fifth Avenue Market is staff-only. Seating, shelves, the piano, and the shop sinks stay open. Talk timing in those rooms is unchanged. The next floor rebuild keeps these labels. The finished morning was not restarted.

- [x] **Decision — BE — The written day has to honor the job, or the job has to change.** Ivan’s job is O’Reilly Pub. His day said a run at Penn College and startup work at his desk, and that is where he went. Katya’s job is the EQT Supply Store. Her day kept her at home, and that is where she stayed. **Pick: A.** The written day includes one shift at the job on file. A run, a hobby, or time at home can sit around that shift. Wake time stays.

  **BE — done 2026-09-23, branch `ivan/day-honors-job`.** The day writer is shown the workplace and must include one shift there. The same rule applies on the village. Ivan still wakes at 10, runs at Penn College, and codes at his desk, and his story now includes an afternoon shift at O’Reilly Pub. Katya still has school, sailing camp, bakery practice, and nails at home, and her story now includes a shift at the EQT Supply Store. Those lines are on the paused family baseline. The finished morning was not changed. A new Pittsburgh Double already gets a job from that map.

- [x] **BE — A walking route stays off the river.** For eight minutes Ivan’s path was on walkable Allegheny River cells, from Encore toward Penn College. Streets and parks are the walk. The river is not.

  **BE — done 2026-09-23, branch `ivan/downtown-river-walls`.** Routes treat the Allegheny, the Monongahela, and the Ohio as walls. Trails, River Vue, and parks stay open. The picture file was not painted shut. The finished morning was not restarted.

- [x] **FE — The place line is the room the body is actually in.** At 11:30 the grey line under Ivan’s name said a Penn College classroom seat. His body was on the street outside the door. The status sentence was already right: walking from Encore to Penn College. The engine already saved the street on that minute. The card printed the seat he was walking toward, chosen when he left home. Show the place saved for the tile he is standing on. Show that seat only once he is in the same room. A desk or a seat inside the room he is already in can stay, because it is the more specific name. A seat in another building cannot. Do not ask the model. Do not change this morning’s file. Replaying `20260923-1` should show the street at 11:30. Do not resume that run.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** The grey line uses the place saved for that tile. The planned seat shows only when it is an object in that same room. A minute with no saved place keeps the old line. The morning file was not changed.

- [x] **BE — A trip line matches the direction of the walk.** Luba’s first hour at PPG Cafe was coherent. Two later hops back to the cafe described the opposite errand, including washing her hands before leaving while she was heading toward the cafe.

  **BE — done 2026-09-23, branch `ivan/trip-line-matches-walk`.** While someone is still on the way, an errand is not the status line. The line is walking to the place they are actually going. A sentence that starts as the trip stays, including leaving the cafe to walk home. Washing her hands shows once she is in that room. This finished morning still has the old lines. The next run writes the walk. She may still take the short hop. Do not resume `20260923-1`.

- [x] **BE — A full morning is remembered.** Closed 2026-09-23. Gosha’s study is in the saved morning: 22 events from wake through 11:29, plus the same 6:30 day plan the other three have. The count is 23, not 0. No one stored a later thought. A new thought waits for 150 points of “this mattered,” and a quiet morning does not get there. Nothing to build.

- [x] **FE — “On their mind” is the latest thought for this minute.** The old “Why now” line is gone. The box shows the newest thought already stored at the minute on screen. No thought, the box is hidden. It does not use the generated sentence or the life bio.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** The label is “On their mind,” matching the rest of the card (“Who they are”). A fresh sentence for this exact action would be another model call, so this box does not ask for one.

- [x] **FE — Play the stored route.** Once headless has recorded the tiles for a minute, playback draws that walk instead of jumping to the landing tile. Replay does not invent a new route. This finished morning has no route to play.

  **FE — done 2026-09-23.** The player already draws a stored route. This morning jumped because headless was off, so the file only has the landing tile. Nothing new was built. Do not resume `20260923-1`.

- [x] **FE — Names stay readable on the wide downtown view.** First load, and letting go of follow, use zoom 0.15 centered on tile 378, 264. A link that already names a camera is left alone. Dragging the map keeps the user’s view. Names stay the same size on screen at every zoom. Names that would sit on the same spot stack in a short column with a thin line back to each person. A combined group sticker waits until crowds are bigger than this.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** Figures stay small at that zoom. The stack only happens when the labels would actually touch.

- [x] **FE — Follow stays on the selected person.** It holds through play and through a scrub. The center-on button does that job and stays on, including what “Find My Double” does today. Right-click on it chooses who the default follow is. Users that are not logged/don't have their double on the map should see the dropdown for selecting a double to follow - on the first click. Idle “look at the group” must not pull the camera off that person. The one wide frame when the morning first appears must not clear a follow the user already chose.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** The center button remembers one person for this visit. A known Double locks on the first click and the button stays pressed. Otherwise the list opens. The last row is Follow the action: the camera goes to the current moment, and sits on the wide shot between moments. Choosing a person turns that off. A second click returns to the wide shot. Right-click changes who. The separate Find My Double button is gone. The choice is not saved as the user's Double.

- [x] **FE — A locked follow lives with the camera modes already in the player.** Dragging the map, a high-impact moment, and an open personal card each move the camera on their own. Follow must not fight those, and those modes must not quietly turn follow off.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** Drag, a card, and a highlight can borrow the camera. When that moment ends, it returns to the locked person. Clicking the empty map does not clear the lock. The opening wide shot runs only when nobody is locked. A village run with no lock stays as it was.

- [x] **Decision — else — How fast a minute should look.** A straight walk to a place was cut to 3 tiles. The player then left them standing for the rest of that minute. Do not raise the 6-tile cap. Do not change 4:1.

  **BE — done 2026-09-23, branch `ivan/straight-walk-full-step`.** A step already inside 6 tiles is kept, including a straight street. A longer jump is still cut. A short leftover path can still be less than 6. This morning’s file stays as recorded. The next run writes the full step. Do not resume `20260923-1`.

- [x] **FE — A sticker click opens the card and zooms to that person.** The map moves in so that Double is on screen. Closing the card hands the camera back. A locked follow is not replaced.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** The click brings that person up. Closing the card returns to a locked follow, or to the wide shot when nobody is locked.

- [x] **FE — Take the organization signup off Watch.** “Bring Doubland to your organization” belongs on the landing page. Remove it from this player.

  **FE — done 2026-09-23, branch `ivan/pgh-20-homes`.** The work-email box is off this watch page.

## Pending TODOs

- [20260924_pit_2.md] **Decision — FE — What this watch page keeps from the current map app.** The Pittsburgh player and the current Doubland map have diverged. When the time comes, mark each difference keep, merge, or drop. Do not promote the page while that list is open. The organization signup is off this page. Find My Double is already folded into the center button. The rest of the list is still to be written before the pick.