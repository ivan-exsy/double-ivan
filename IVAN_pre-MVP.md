# Before LeaderTalks MVP — 17 Sep (Watch honesty + owner Chat)

**Product MVP is LeaderTalks in Pittsburgh** (Telegram group; Downtown world). Breakfasts was a rehearsal, not the MVP. Village gather + talk is a closed engine gate, not the product MVP.

Talk unmute is Current (`sot_chats.md` §3c). Score tape: `double-docs/20260912_Breakfasts/20260915-3_TODOs.md`. Do not raise talk-chance. Do not restore linger. Do not walk-to-person (**PM-VIL-1**).

This cut is Watch honesty, then one scored Downtown Survival day (**PM-BFST-13**). Downtown occupancy is built. Daily video, B2B on Watch, and the Telegram drop stay in `TODO_post_mvp.md`. Work after LeaderTalks is in that file’s **After LeaderTalks** table.

Breakfasts spec files (`BREAKFASTS-BOARD.md`, `MVP-breakfasts.md`, `MVP-breakfasts_ivan.md`, `MVP-0.1.md`) are rehearsal archive — moving to `done/`. Do not treat them as the live list.

## *Built-needs verified:*
- **B2 Chat** — three-way scored **2026-09-28** on the finished Breakfasts watch (playback only). Who-is-talking **PASS**. “What are you doing right now” **MISS** on all three (reply does not match the card). **Postponed to After LeaderTalks (2026-09-29).** Pull it back only if a claimer complains. Privacy picker **out**.
- **First-sight hello** — watch list. `20260917-3`: nobody reached Hobbs; 0 village talks. Do not patch until you say go.
- **T-E7** — **observed miss** on `20260917-3`. Ivan spawn off-bed, 8 min `sleeping` while walking to `Dorm Room 4:bed`, then stays. Luba `lying awake in bed` in the common room 4 min. Same family as Watch snaps (**T-W10** / **PM-VIL-11**). Do not patch until you say go.
- **20:00 vote on next full sim day** — confirm ballots are real (not fail-safe). No extra Start; piggyback the next day that reaches evening. Cap 6.

---

## *NEXT — open*

- **Downtown real sim** — **PM-BFST-13** scored PPG Survival day. New Downtown sim — not the Breakfasts watch URL. On that run, fix A* “no path → arrive anyway” only if it still jumps walls. Cap 6.
- **LeaderTalks play** — Season Spec **locked** (premiere opener + 15 evening drops). soul_15 → Pittsburgh maze, operator log + Showrunner, **PM-LTALK-8** timecodes, daily 15s clips optional, drop.
- **Public sim list** — **PM-AUTH-2**, next pass. FE ships the homepage and the landing camera first. BE then locks the list, costs, and the roster. Do not reload `api-gateway` while `20260929-3` is the live iframe unless Ivan names the window.
- **Team door** — **PM-AUTH-3**. Same Supabase login. Docs and operator calls require a team mark. Watch playback, status, one person card, signup, and health stay open. List, costs, and roster stay **PM-AUTH-2**.

---

## Open todos

### Public sim list — next pass (PM-AUTH-2)

UX-04. `GET /api/simulations/`, `GET /api/simulations/{sim}/costs`, and `GET /api/simulations/{sim}/personas` answer with no login. The public homepage lists every sim. Costs have no client. The landing calls the roster only to aim the camera.

The live iframe stays `20260929-3`: `https://double-front.vercel.app/simulations/20260929-3?embed=1&t=2&zoom=0.899`. Watch production is `4c6dfa6`. Landing production is `42087a6`. FE agreed 2026-09-29. No code yet.

Anyone who knows that sim can still read names and locations from the step payload and from a person's card. That iframe is the public demo.

**Order:** FE on Vercel first. BE branch with no deploy. Reload `api-gateway` only when Ivan names the window. A normal restart drains a sim the gateway launched.

#### Frontend

- [ ] **Homepage stops calling the full list.** `double-front.vercel.app` links `20260929-3` and does not call `GET /api/simulations/`. The connection test on that page goes with it.
- [ ] **Landing stops calling the roster.** No `GET /api/simulations/{sim}/personas`. Follow only a name the page already has: the viewer's own Double, or the `double` on a share link.
- [ ] **No name means the center of the floor.** Omit `zoom` and `focus` when there is no name. Watch then opens on the center, a little closer than the whole map. Today `zoom=0.899` is treated as a saved view, so the camera stays in the corner.
- [ ] **Leave playback alone.** Step bundles, the CDN manifest, and `/status/current` stay as they are for `20260929-3`.
- [ ] **Leave the person card alone.** A click still calls that person's `/personas/{name}/details` and `card-summary`.
- [ ] **Leave the signed-in lookup alone.** Watch still calls `GET /api/me/sims/{sim}/persona` with the session token.

#### Backend

- [ ] **Lock the three open reads.** `GET /api/simulations/`, `GET /api/simulations/{sim}/costs`, and `GET /api/simulations/{sim}/personas` require an admin Supabase JWT or a service token. The personas lock is the roster collection only.
- [ ] **Lock the second roster route.** `app/routes/simulation_control.py` registers the same `GET /personas`. It is registered second, so it does not answer today. Close it in the same change.
- [ ] **Leave the engine path alone.** No change to observation posts, start, stop, or reverie. No sim-env change.
- [ ] **Do not reload `api-gateway` in this pass** unless Ivan names the window. `20260929-3` is the running sim and the iframe.
- [ ] **Leave the admin list alone.** `/admin/simulations` reads `double.simulations` with the browser Supabase client. Tightening anonymous access there takes that page down. Public Watch does not use it.

### Team door — docs and operator calls (PM-AUTH-3)

One login, the one people already use. Ivan and Nicolas carry a team mark on that Supabase user. No second password.

The docs page is the map. Start, stop, the file watcher, and background tasks are the open controls. Both require the team mark. Visiting `https://api.doubland.ai/docs` without a session goes through the magic link and returns to the docs. Same rule for `/redoc` and `/openapi.json`.

Watch playback, sim status, one person’s card, signup, and health stay open. Chat, `/api/me`, and onboard stay as they are.

The full sim list, costs, and roster stay **PM-AUTH-2**. Lock those after the homepage and landing stop calling them.

Reload `api-gateway` only when Ivan names the window. The public demo iframe still plays `20260929-3`.

- [ ] **Team mark** on Ivan and Nicolas. Same login as Chat.
- [ ] **Docs require the team mark.** `/docs`, `/redoc`, and `/openapi.json`. A browser visit uses the magic link and returns to the docs.
- [ ] **Operator calls require the team mark.** Start, stop, file watcher, background tasks.
- [ ] **Leave the public product open.** Playback, status, one person card, signup, health.
- [ ] **Leave signed-in product routes as they are.** Chat, `/api/me`, onboard.
- [ ] **List, costs, and roster stay PM-AUTH-2.** After that front end ships.
- [ ] **Update the API how-to** in `double-docs/sot/sot_api.md` once the docs page asks for the team login.
- [ ] **Reload `api-gateway` only when Ivan names the window.**

### 20:00 vote — confirm on next full sim day

**Locked:** all village LLM jobs stay **Tier A** (thinking off). Watch Chat stays **Tier B + thinking**, cap 8,000. Do not reopen a job-by-job thinking list.

**Still to confirm (observe only):** `20260917-4` stopped at **11:30**, so the 8:00 vote never ran. On the **next sim that reaches evening**, check: each remaining Double writes a real ballot (parseable target + a personal reason), not the fail-safe first name; they don’t all pile onto one person for no reason; Hobbs occupancy at 20:00 is honest. No extra Start for this. Do not turn vote thinking back on unless that night fails.

### B2 — known peer / secrets / control

**Status:** scored **2026-09-28** on the finished Breakfasts watch (`pittsburgh-business-breakfasts`, playback only, sim stayed stopped). Same Double: `Ipistsov+20260908`. Code already live (`railway` `bcc9b78b`).

- **Owner** (the login that owns this Double). Card had drifted to ~06:33, walking toward Ivan App at the common-room sofa. Who-am-I **PASS** (“the person I’m based on”). Right-now **MISS** (said settling into bed). Off-map life allowed (cafe, family, a startup — facts not checked). Unlike-them **PASS** (refused to be cruel and asked if you were sure; that prompt was not confirmed).
- **Someone they know** (Ivan App’s login, a different Double on this watch). Fresh chat. Card at 05:55: sleeping, House 3 main room. Who-am-I **PASS** (“someone from around town”; did not claim to be your Double). Off-map life **PASS** (Hobbs and being home; did not repeat the owner’s private chapter). Right-now soft miss (getting ready for bed while the card said already sleeping).
- **Stranger** (founder inbox, no Double on this watch). Card held at 06:01: waking up and sitting up in bed, House 3. Who-am-I **PASS** (not sure, have we met). Off-map life **PASS** (refused; stayed on here and now). Right-now **MISS** (turning down the covers while the card said waking up).

**Postponed (2026-09-29):** the spoken “right now” does not match the card. After LeaderTalks (`TODO_post_mvp.md` **PM-CHAT-1**). Pull it back only if a claimer complains. Do not Start this watch.

Side, same card: the owner status line showed a raw tag, `Walking to <persona>Ivan App`. Do not patch until you say go.

**Want:** the Double’s role depends on **who** is talking.

**Already shipped (owner class — T-E5 + B1):** www **PASS** 17 Sep.

**This cut (locked):** three talker classes in prompt + memory filter. Life-chapter fields stay **private** (no Public/Friends/Private picker). Unlike-them = one check, this thread only. Leave out: parse chat → `innate`; S3 propose-updates card.

**Plan:** `leftover_b2_chat_b2d36308`. Spec: `done/20260912_Breakfasts/20260914_Post_breakfasts_todos.md` §B1 **RQ-B1a–c** / §B2 **RQ-B2a–b**.
<plan - C:\Users\ipist\.cursor\plans\leftover_b2_chat_b2d36308.plan.md>

Ticket **B2**.

### First-sight hello

**Want:** first pass in the dorm this morning at least nods.

**Seen:** named rooms ~3 tiles apart stayed silent (`20260916-1` 0 chats). Current gate is same 3-part room (or 3 tiles on a street with **no** room). **`20260916-2`:** cafe hello Gosha↔Luba ~07:21. **`20260917-3`:** 0 cafe occupancy, 0 village talks — no first-sight chance. **`20260917-4`:** cafe hellos + talks once people reached Hobbs (8 encounters). **Watch list, not a fail.** Sleeping person stays silent.

**Do:** keep watching. Do not patch until you say go. No mill, no walk-to-person.

Ticket **PM-VIL-10**.

### T-E7 body vs sleeping sticker

**Want:** sleeping sticker matches a body on the bed.

**Do:** observed on `20260917-3`. Ivan: planner bed `Dorm Room 4:bed`, spawn `[130, 48]`, walks `sleeping` through the common room to `[106, 61]` by 06:38, then stays. Luba: `lying awake in bed` in the common room 06:30–06:33, on bed 06:34. Katya step 0 `sleeping` labeled closet, same tile later `bed`. Do not patch until you say go. Same family as Watch snaps (**T-W10** / **PM-VIL-11**).

### Pittsburgh — real sim (PM-BFST-13)

Map, shelf, and Join are built. Detail: `double-docs/Pittsburgh_TODOs.md`. Do **not** reuse `pittsburgh-business-breakfasts` / village Hobbs. Cap 6. Do not Start `base_family_pittsburgh`. Do not resume `20260926-2` or the earlier Pittsburgh runs.

- [ ] **Scored Downtown Survival day.** New sim. 11:00 / 20:00 occupancy on **PPG Cafe** (≥80% tiles), honest leftovers, fourth wall. Headless tab-reuse already Current on village.
- [ ] **A\* “no path → arrive anyway”** — engine fix only if that run still jumps walls.

### LeaderTalks play — living list (doctrine in `TODO_VC_prep.md`)

**VC metrics (2026-09-17):** log **pull** + **retention** (Andrew Chen / a16z lens + HPVP bar). Spelling: **Chen**, not Chan. Product levers that promote those metrics → Engagement / Andrew Chen specialist after Season Spec; not this eng cut.

June raise paper + Showrunner *locks* stay at `TODO_VC_prep.md` (**§10** Chen lens, **§11** hard side). **Do not add todos there.** Open work lives here. Do not rebuild what already ships. Target KB: `cos/agents/vc/kb/raw/user-provided/a16z-andreessen-horowitz.md`.

**Current (do not re-open):** waitlist `source` + B2B `interest_type` / `group_name`; landing CTA routing. Proof: `double-docs/sot/sot_api.md` §10.

**Hero signals for the raise:** **retention** (come back night after night) + **pull** (need more — join/claim, forwards, time with Watch/show, inbound *“build one for my group”*) + completion where available — **not** vanity view count at ~15/300.

**Showrunner (hard side, locked `TODO_VC_prep.md` §11):** organizers, not viewers. Ivan = Showrunner #1 on this season. Success for the raise is a **few named** “run this for my team” asks (1–3), not a blast of the word *Showrunner* on night 1. Split the log: (a) claim / “that’s me” = soft side; (b) “build one for my company/group” = Showrunner-sourced pull — screenshot (b). Do not pitch cash. School/campus later. Do not stand up empty parallel groups.

**Season Spec (locked 2026-09-18):** Pittsburgh Downtown maze (occupancy is built; the remaining gate is **PM-BFST-13**). **15 Doubles** already on **soul_15** — re-init on the new maze; do not rebuild souls. Survival + **1 premiere / grace day** (engine day 1; Survival day 1 = engine day 2). Do **not** skip-premiere on the show run.

**Posts (locked):**
1. **Premiere evening** — opening trailer **[A]** (one YouTube). Tag: `tg-survival-premiere`.
2. **Then 15 evenings, one Telegram drop each** — YouTube link to **that night’s closer** + a short day description. Tag: `tg-survival-d{N}` for N=1…15. One drop per calendar evening (wall-clock 2× is for generating tape ahead, not two posts a day).
3. **Night 15 (last evening)** — winner celebration + whole-season overview (still one closer-shaped video, **not** encyclopedia `[C]`).

**Named poll (locked 2026-09-29):** same question three times, “Who do you think wins the season?” with public votes: premiere evening (second message after the opener), mid-season (night 7 or 8), and finale. Say “just for fun — the Doubles decide.” Poll voters are the named cohort for the retention slide. Log poll nights as nudge days; votes are not unprompted pull. No nightly poll.

That is **16 posts** (opener + 15 nights), plus the three polls. Engine: premiere + 14 elim nights + dedicated finale evening. **Not** 15 personal YouTube uploads every night — per-Double 15s clips stay **PM-BFST-4** (optional inside the drop later).

**Consent (live, not the June triage):** surprise the group, then **Claim double / Remove double** in chat. You handle it by hand — no product build. `TODO_VC_prep.md` §5 brief-first is **not** the SOP. June gate archive: `done/TODO_mvp-release-gate.md` §4.

**Operator runbook**
1. **Claim** — member DMs or emails → identify their Double → link the account → optional profile tune via existing scripts if they send corrections.
2. **Remove** — member DMs or emails → take them out of the sim → skip them in later daily videos (honor within ~24h). No-questions-asked.
3. Portrayals stay affectionate / flattering.

**Still open**

| ID | Item | Notes |
|---|---|---|
| **PM-LTALK-2** | Season Spec before a tagged drop | **Locked 2026-09-18:** opener on premiere (`tg-survival-premiere`); then **15** evening drops (`tg-survival-d1`…`d15`); night 15 = winner + season overview; one Telegram post per evening (YouTube link + short day copy). Without the tag, signups look like generic landing traffic. |
| **PM-LTALK-3** | Tone pass + maze init (cast exists) | The 15 are **soul_15** — do not re-pick. Affectionate / flattering, not exposé. Initiate those personas on Downtown after the scored Survival day. Claim/Remove path above. |
| **PM-LTALK-4** | Operator log during the season | **Retention:** who returns night N after night 1 (same people / “ask for tomorrow”). **Pull:** join/claim, forwards, time with Watch/show. **Showrunner rows (§11):** named hosts; roster finished test+profile; personal share; screenshot every “run this for my group” + episode; whether returners sit in a named Showrunner roster. Honest zeros OK. Manual is enough. |
| **PM-LTALK-5** | Showrunner identity + one job | Flintstone OK. You are Showrunner #1. The job: invite → roster done (test + profile) → watch together. Do not build an Admin product. Do not say the title in the first drop; use it when someone asks for their own team. |
| **PM-LTALK-8** | Key-moment timecodes on each YouTube / Telegram drop | **Reuse, do not rebuild.** Old pipeline already writes `M:SS — label` + Watch deep links from `script.json` `key_steps` (`generative_agents/video/generate_description.py`, Step 6 of `generate_trailer.py`). Daily closer (`run_tonight_scar` / SOT-video §11.4) does **not** call it. Watch URLs in that module are stale (`/sim/{code}/play`). Coding: hook closer packages → paste-ready YouTube chapters + Telegram blurb; point links at Current Watch. |
| **PM-BFST-4** | Daily 9:16 + 15s “your Double’s day” + end-card CTA | Already on `TODO_post_mvp.md`. Vertical + tracked link to Watch. **Not** the evening drop (that is one ensemble closer). Optional later inside the post. |
| **PM-LTALK-6** | Recruit 1–3 next Showrunners | From this alumni group, for **their** work/friends groups (school later). After the drop is live and pull is visible — not a night-1 blast. Target a few named yeses. |
| **PM-LTALK-1** | Show it to the alumni group | The actual ~300 chat. Product pieces above; this is the drop. |

**Hold until numbers justify:** serialized cliffhangers, Survival “that’s so them” fidelity (**PM-VIL-2**), group influence / vote. Not this cut. Campus/Tinder-style party distribution = **After LeaderTalks** (Engagement) — Legal before any campus/minor-targeting public claim.

## Dropped

- **PM-BFST-5** — B2B line on Watch. Dropped 2026-09-24. Irrelevant. Do not add “Bring Doubland to your organization” on Watch or in the video description.

## Shipped

- **Supabase health** — Closed 2026-09-30. `double-openrouter` stays Micro. After `20260929-3` stopped, a normal read of that sim’s latest steps was 5 ms and nothing was waiting on disk. The Disk IO warning was the run itself (138 statement timeouts, 2–4 PM Eastern on 2026-09-29; about 600 MB still in swap). Disk was 88% of 12 GB. Supabase auto-grew it 12 GB → 18 GB when the old-sim delete crossed 90%. Do not shrink it. The files still use about 12 GB; the extra 6 GB is about $0.75/month. A smaller disk is not a dashboard control.
- **Public API name** — Closed 2026-09-30. `https://api.doubland.ai` is the only public API. Landing production `API_GATEWAY_URL` and the landing fallback are that host (`a6f51bb` on www). Watch production uses the same host, including the debug step links (`b8afb18d` on `vercel`). Public port 8001 is closed on the box firewall. Health and this sim’s status answered after the close. The API process was not restarted. Docs stay `https://api.doubland.ai/docs`.
- **Spoken Survival promises reach the vote** — a full sit stores the promise; the 20:00 ballot lists it; betrayal fires when the voter promised. `railway` `1cea4b3c`. Score on `20260929-3`. Shipped 2026-09-29.
- **Watch keeps accented names** — Nicolás stays on the roster and the map. `railway` `ca653738`. Shipped 2026-09-29.
- **PM-BFST-1** — Downtown occupancy world. Twenty furnished homes, colliders, object ingest. Breakfasts watch stays `the_ville`. A new sim uses the maze named at creation; default is Downtown. Closed 2026-09-28 pending the real sim (**PM-BFST-13**).
- **PM-BFST-2** — Downtown tiles on the shared shelf (178,733 tiles, matches `20260926-2`). A new run reads that shelf. Production `railway` as of 2026-09-29.
- **PM-BFST-3** — Join is the 20 apartments, one person each; jobs stay open (PPG Cafe can be shared). Fifth Avenue Market, EQT Supply Store, O'Reilly Pub, Penn College. A `Residence` home cannot be chosen. Production `railway` `94589b8b`. Closed 2026-09-29. No re-quiz.
- **PM-BFST-15** — Meet screen before Join: “Your Double keeps your personality. Its schedule adapts to the town it lives in.” Done 2026-09-24. Review Meet unchanged.
- **PM-LTALK-7** — Showrunner waitlist door. Done 2026-09-24. Founder yes on the live homepage footer: “Run Doubland for Your Group,” the Showrunner lede, email, name, and group name. Every submit is `b2b_group`. Already on www.doubland.ai. No second form.
- **T-E8 caption vs body** — seek / person dest never drive the sticker; place walks still name the place. **PASS** `20260916-2` @89. SOT `sot_action-location.md` §5.4 Current. Plan: `t-e8_t-e5_pass_554c710a`. Ticket **PM-VIL-8**.
- **T-E5 lore** — owner and guest Watch Chat never invent a secret pair / in-game twin. Same plan as T-E8. Product “yes, I’m your Double” scored under **B1**.
- **PM-BOOT-1** — bodies at Start; sleep/wake stickers hold (`20260917-1`, `railway` `d4e5e226`). Same-room leftover dest is not rewritten into a walk. T-E7 body-vs-bed still open.
- **Leftover stay, slice 1** — emit-only `walking to {place}` → stay when already there (`railway` `2ef73e11`). **`20260917-2` @100:** `walking to Hobbs Cafe` on cafe tiles **0**; en-route walks still walking; Ivan sticker `sleeping`; person-name walks **0**. Residual `walking from … to` closed on slice 2.
- **Leftover stay, slice 2** — `walk(ing) from` counts as travel (`railway` `bcc9b78b`). **PASS** `20260917-3` @99: `walking from … to` **0/400**; cafe `walking to Hobbs` **0**; person-name **0**; persist >6 **0**. Cafe leftover sit did not occur (0 Hobbs tiles). Residual: Luba frozen `walking to Hobbs Cafe` 10 min at dorm. Same plan as B2.
- **PM-AUTH-1 + B1** — Chat requires magic-link; Watch stays anonymous; owner = linked Double. Guest gate: **Email me a link** on open, chips/input off, Chat→`/login` skips Leave Site (www `e93f7e9`, map `8100533`). **www PASS 17 Sep:** guest login returned to Breakfasts Watch; send worked; owner asked “do you know who I am?” → *person I’m based on / creator*. Thread stamped to owner email of `Ipistsov+20260908`. Auto-open Chat tab **out**. Optional later: one thread across the magic-link retry. SOT Chat-require / B1 stamp when you want it Current.
- **Village-25 → account** — any `prediction_ready` (including `IPIP-BFM-25`) → `/account` (www `22f20b4`). Empty login still Welcome. Optional: Back to account on **main Gmail**.
- **LLM env-only** — sim + Watch Chat take model and thinking only from env (one knob per tier). Missing env = hard fail. Local/VPS: A/B `deepseek/deepseek-v4-flash-0731`, C `deepseek/deepseek-v4.1-flash`; thinking A off / B high / C high. Plan: `llm_env-only_0f40394d`.
- **Sim jobs thinking OFF (locked)** — all village LLM jobs **Tier A**; Watch Chat stays **B / 8,000 thinking**. **PASS `20260917-4` @299** (`railway` `aa3df08b`) vs `20260917-3`: Day plan is a full list (not a one-line stub); where-they-go **34/34** places (was **2/47**); challenge JSON **4/4**; Hobbs **4/4** at 11:00; memories **380 vs 28**; cafe talks happened (8 encounters, 4 talked). Wall clock **~6s/step** vs **~26s**. Persist >6 **0**. Duplicate wake line is parser noise, not a fail. **20:00 vote** still to confirm on the next full sim day (see open todo).
<plan - C:\Users\ipist\.cursor\plans\llm_env-only_0f40394d.plan.md>
