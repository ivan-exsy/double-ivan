# Before LeaderTalks MVP

Product MVP is LeaderTalks in Pittsburgh. Breakfasts was the rehearsal. Cap 6. Do not raise talk-chance, restore linger, or walk-to-person. Downtown occupancy and Join are built. The next engine gate is one scored Downtown Survival day (**PM-BFST-13**). Daily video and the Telegram drop stay in `TODO_post_mvp.md`. Measurement locks stay in `TODO_VC_prep.md`. Breakfasts spec files are archive.

Do not resume `20261001-2`, `20261001-1`, `20260930-2`, `20260930-1`, or `20260929-3`.

## Open

### Video - Ivan

- Auto-generated Daily Trailers
- Auto-generated Opening Trailer

### BE & API - IVAN

| ID | Item | Done when | Fix Applied / date |
|---|---|---|
| **PM-BFST-13** | One scored Downtown Survival day. New sim, not the Breakfasts watch. Cap 6. Do not Start `base_family_pittsburgh`. | 11:00 and 20:00 occupancy on PPG Cafe (at least 80% of tiles), honest leftovers, no fourth wall. Fix A* “no path, arrive anyway” only if that run still jumps walls. | ... |
| **PM-LTALK-8** | Key-moment times on each YouTube and Telegram drop. The old pipeline already writes `M:SS` labels. The daily closer does not call it, and its Watch links are the old `/sim/{code}/play` shape. | A closer package pastes YouTube chapters and a Telegram blurb, and the links open Current Watch. | ... |

**Note to Nicolas — send after PM-DEMO-21 is live**

On `/account`, keep one list. Two groups, highlighted differently (a label or a quieter row is enough):

- **Can join** — towns they are allowed to enter and have not entered yet.
- **Have joined** — towns their Double is already in.

Have joined gets one Watch button. Can join keeps one Join action. If they have joined but cannot watch yet, same row, one short line, no third section. “We’ll email you. You are not in a simulation yet.” only when both groups are empty.

### IVAN

Nicolas builds the screens (`Nicolas-UX_polish.md` § *October 3 demo — your screens*). These are your halves.

| ID | Your part | Done when |
|---|---|---|
| **PM-DEMO-10** | Three account sentences: no sim yet, joined but cannot watch yet, can watch. Set `premiere_date` on a sim once you know the real-world day. | Nicolas has the three sentences. |
| **PM-DEMO-15** | Headline and three short lines under the hero. Same words as the invite. | Nicolas has the words, and the invite uses the same text. |
| **PM-DEMO-13** | Phone test before the group is invited. Not a build. | On your phone, with no help: sign in with the code, finish onboarding, Join, and Watch. |

---

### FE & Landing — Nicolas

October 3 demo screens (**PM-DEMO-1, 3, 5–12, 14, 15**) live in `double-docs/Nicolas-UX_polish.md` § *October 3 demo — your screens*. That checklist is the only live copy. He does not redeploy the API. Do not write “daily,” “coach,” or “predicts you.”

## Built — needs a check

| ID | Item | Done when | Fix Applied / date |
|---|---|---|
| **Realism-1** | The line under a person matches the body. On `20261001-2` the false “walking to Point State Park” line showed up 159 times while people were still on the street. The 30 Sep accept is lifted. This is first for release. | On the street, the line says the street. When they stop, it names the room they are actually in. | *2026-10-03. On the street the line says “on the street,” including after a walk lands there. Stopping in a room names that room. Unit tests pass. Not scored on a new downtown day.* |
| **Realism-3** | The vote number has to match what a viewer can count. On night 3, three ballots name Katya and the record says 8. | The number equals the names, or the extra weight is visible. | *2026-10-03. A stronger vote dies when the day rolls, so it cannot stack on the next night. Elimination still uses the multiplied total. The remembered number, and “times targeted,” count people. Unit tests pass. Not scored on a new downtown day.* |
| **PM-DEMO-7** | Leave call, plus a quiet “moved away” memory for the others. | Leave removes the Double from that sim and keeps the account. The others get a quiet “moved away” memory. | *2026-10-05. `POST /api/me/double/bind/{sim_code}/leave`. The apartment opens, the job on that town is cleared, the account stays. Unit tests pass. Live on the API after the reload the same day.* |
| **PM-DEMO-11** | Owner chat with no live sim, reusing `/api/me/double/*`. | Right after onboarding, with no sim running, a tester asks what the Double knows, corrects one fact, and the next reply uses it. | *2026-10-05. A correction is used in later replies of that conversation and is not saved into the profile. Live on the API after the reload. The account button stays with Nicolas.* |
| **PM-AUTH-3** | Team door. `/docs`, `/redoc`, and `/openapi.json`, plus start, stop, the file watcher, and background tasks, require a team mark on the same login. Playback, status, one person card, signup, and health stay open. Chat, `/api/me`, and onboard stay as they are. | A visit to the docs without a session uses the 6-digit code and returns to the docs. Reload the API only when you name the window. | *2026-10-05. Docs use the 6-digit code and return to the docs. Team list: `ip@ondouble.com`, `nicolasdemaria@gmail.com`. Live after the reload. Playback, the person card, signup, health, chat, account, and onboard stay open.* |
| **PM-CHAT-2** | Neighbor chat for any signed-in visitor. Today only a person who owns a different Double on this same sim gets town memories. A signed-in visitor who does not gets manner plus the current action, and invents the rest. Give that visitor the neighbor pack: manner, home, recent public events, and town memories, with owner-only chats removed. No life story, contact, or real-world job. The clock on the screen is a separate question; do not block this on it. | On `pittsburgh-demo`, a login that is not Luba’s owner asks what she has been doing and hears town events, and still cannot pull her private life. | *2026-10-05. Any signed-in visitor who does not own this Double gets the neighbor pack. The owner still gets the private life. No login stays a stranger. The screen clock was not built. Unit tests pass. Live on the API after the reload (`railway` `82ae70f0`). Not yet asked on `pittsburgh-demo`.* |
| **PM-DEMO-21** | Account list includes a town this login’s Double is already in, even when that town is closed to new people. Today the list only returns towns open for joining, so `ipistsov+20261003@gmail.com` sees “We’ll email you” while Ivan is already on `pittsburgh-demo`. Return that town with joined and the watch link. A finished tape that already plays counts as watchable. | Signed in as that login, the account sim list includes `pittsburgh-demo`, joined, and a watch link. The waiting sentence is only when the list is actually empty. | *2026-10-05. The account list includes every town that Double is already in, including a closed finished tape, marked joined, with a watch link. Towns they were never in stay hidden. Unit tests pass. Live on the API after the reload (`railway` `82ae70f0`). The Can join / Have joined grouping is still Nicolas. Not yet checked on the account page.* |

- **Downtown Join** — live since 2026-09-29 (`railway` `94589b8b`). Not walked on a fresh sim. Check: 20 apartments, one person each, and a taken home leaves the list. PPG Cafe and the four shops stay on the list when someone already works there.
- **Ally and the day’s seek** — on `20261001-2`, Luba and Yevgenia each held a live spare with Nicolás, and both plans named him. No caption was a walk toward a person, so the talk half was never seen. Do not add walk-to-person. On the next day that already has a spare or vote-with with him, check that the seek can still select him.

## Season — locked

Locked 2026-09-18. Pittsburgh Downtown. Survival, plus one premiere day (engine day 1; Survival day 1 is engine day 2). Do not skip the premiere on the show run.

Sixteen posts: one premiere trailer (`tg-survival-premiere`), then fifteen evening drops (`tg-survival-d1`…`d15`). Each drop is a YouTube link to that night’s closer plus a short day description. Night 15 is the winner and a season overview, still one closer, not an encyclopedia. One post per evening.

The same poll three times, “Who do you think wins the season?”: premiere evening, mid-season (night 7 or 8), and the finale. Say it is just for fun. No nightly poll.

Consent is surprise, then Claim or Remove in chat, by hand. You are Showrunner #1. Do not say that title in the first drop.

## Shipped

- **One name** — passed on `20260930-2`. Scratch, the ballot, and prompts say Nicolás. The login is gone. Do not re-score.
- **Live pledges** — passed on `20260930-2`. Only spare or vote-with is stored. A favor is not a betrayal. A pledge to someone already out leaves the next ballot. A broken pledge stays broken. The goodbye says the pledge ended. Do not re-score.
- **20:00 ballots are real choices** — passed on `20261001-2`, nights 1–3. The person’s own sentence comes first and ends on a word. Bodies at 20:00 were on PPG Cafe tiles. Yevgenia’s night-2 line used the backup “No strong preference” once. On that tape the record still says 8 for three names (open, above).
- **PM-AUTH-2** — The sim list, costs, and roster require a sign-in. On the machine as `railway` `50ad1be5` (2026-10-01). Anonymous calls return 401. Nicolas verified anonymous playback of `20261001-1`: the map loads with no list, costs, or roster call, and a guest opens on the center of the floor.
- **PM-LTALK-2** — Season shape locked 2026-09-18. See *Season — locked* above.
- **PM-DEMO-1** — The login email contains a 6-digit code. The person copies it and enters it on www.doubland.ai/login in Safari or Chrome. Subject: “Your Doubland code.” The code is on its own line. It lasts one hour. A new email replaces the previous code. The first email to a new address uses the same words as every later email. The team uses this same email. The returning email has used this since 2026-10-03. The first-time email was set to the same words on 2026-10-05. The code box on `/login` is Nicolas’s, and he has deployed it.
- **PM-DEMO-4** — A sign-in in the same browser has no time limit and no inactivity logout, so it lasts past 30 days, until they sign out. The site refreshes it about every hour. Checked in Supabase 2026-10-03.
- **Supabase health** — Closed 2026-09-30. `double-openrouter` stays Micro. After `20260929-3` stopped, a normal read of that sim’s latest steps was 5 ms and nothing was waiting on disk. The Disk IO warning was the run itself. Disk was auto-grown 12 GB → 18 GB. Do not shrink it.
- **Public API name** — Closed 2026-09-30. `https://api.doubland.ai` is the only public API. Public port 8001 is closed. Docs stay `https://api.doubland.ai/docs`.
- **Spoken Survival promises, first cut** — a full sit stores the promise. On the machine as `railway` `1cea4b3c` (2026-09-29). Name and pledge follow-ups passed on `20260930-2`.
- **Watch keeps accented names** — Nicolás stays on the roster and the map. `railway` `ca653738`. Shipped 2026-09-29.
- **PM-BFST-1** — Downtown occupancy world. Twenty furnished homes, colliders, object ingest. A new sim uses the maze named at creation. Closed 2026-09-28. The scored day is **PM-BFST-13**.
- **PM-BFST-2** — Downtown tiles on the shared shelf (178,733 tiles). A new run reads that shelf. Production `railway` as of 2026-09-29.
- **PM-BFST-3** — Join code is the 20 apartments, one person each; jobs stay open. Production `railway` `94589b8b`. Closed 2026-09-29. The walk is in *Built — needs a check*.
- **PM-BFST-15** — Meet screen before Join: “Your Double keeps your personality. Its schedule adapts to the town it lives in.” Done 2026-09-24.
- **PM-LTALK-7** — Showrunner waitlist door. Done 2026-09-24. Homepage footer: “Run Doubland for Your Group.” Every submit is `b2b_group`. No second form.
- **T-E8 caption vs body** — seek and person destination never drive the sticker. **PASS** `20260916-2` @89. SOT `sot_action-location.md` §5.4 Current.
- **T-E5 lore** — owner and guest Watch Chat do not invent a secret pair. Product “yes, I’m your Double” scored under **B1**.
- **PM-BOOT-1** — bodies at Start; sleep and wake stickers hold (`20260917-1`, `railway` `d4e5e226`). The sleep-sticker miss stays parked.
- **Leftover stay, slice 1** — already-there `walking to {place}` becomes a stay (`railway` `2ef73e11`). **`20260917-2` @100:** cafe `walking to Hobbs Cafe` **0**.
- **Leftover stay, slice 2** — `walk(ing) from` counts as travel (`railway` `bcc9b78b`). **PASS** `20260917-3` @99.
- **PM-AUTH-1 + B1** — Chat requires a sign-in. Watch stays anonymous. Owner means the linked Double. **www PASS 17 Sep.**
- **Village-25 → account** — any `prediction_ready` result goes to `/account` (www `22f20b4`).
- **LLM env-only** — sim and Watch Chat take model and thinking only from env. One knob per tier. Missing env fails hard.
- **Sim jobs thinking off** — all village jobs are Tier A. Watch Chat stays Tier B. **PASS `20260917-4` @299** (`railway` `aa3df08b`). Day plans, places, and the 11:00 cafe hold. Wall clock about 6 seconds a step.

## Not this list

- **PM-DEMO-2** — “Open this in Safari or Chrome” on other pages. Dropped 2026-10-03. The login email is a code only.
- **Pool** — one stored promise still says “pool.” It is not in the step captions. Accepted for MVP. Do not patch.
- **First-sight hello (PM-VIL-10)** and **sleep sticker (T-E7 / PM-VIL-11)** — parked. Do not patch until you say go.
- **B2 “right now”** — the spoken line does not match the card. Postponed 2026-09-29. `TODO_post_mvp.md` **PM-CHAT-1**. Pull it back only if a claimer complains.
- **Realism-2** — clock out of the job. Moved 2026-10-03 to `TODO_post_mvp.md`. A cafe shift may be home, the cafe, and home again. Do not force an errand before release.
- **PM-BFST-4** — daily vertical and the 15-second “your Double’s day.” Stays in `TODO_post_mvp.md`. Not the evening drop.
- **PM-BFST-5** — B2B line on Watch. Dropped 2026-09-24.
- **PM-LTALK-5** — Showrunner is a job you already do. Do not build an Admin product. Do not say the title in the first drop.
- **PM-LTALK-6** — recruit the next hosts after this drop is live and pull is visible. Not this queue.
