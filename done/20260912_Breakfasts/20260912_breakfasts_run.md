# Saturday 12 Sep — Breakfasts testers

**Same watch URL.** Do not create a second sim code. Testers keep `https://www.doubland.ai/pittsburgh-business-breakfasts`.

**Reset is done (2026-09-11 evening).** Same watch URL. Village empty, Survival leftover gone, clock stamped for skip-premiere to land on **Saturday 12 Sep**. Testers Join on this **stopped empty** sim, then Start.

Village / Hobbs. Cap **6**. Play on the watch page is **playback only** — it never Starts.

---

## Tonight — done

Pre-test stopped and emptied. Nobody is on Breakfasts. Throwaway test emails were removed from the allowlist (the list is empty — nobody can Join until you insert). Doubles/photos were kept as people; they are just not in this sim.

If you want **your** Double in Saturday’s run, Join again after you insert your real Login email, same as everyone else.

Allowlist: **insert one row per tester.** Never PUT replace (that wipes the whole list).

---

## Tomorrow — testers (you click these)

Do in this order. Nobody Joins while the engine is generating.

### 1. They make a Double (can happen in parallel)

Each person, on **`https://www.doubland.ai`** only (not `app.ondouble.com`):

1. **Login** (magic link — same email you will allowlist).
2. **Onboard** if new: sliders → chat → **Look** (photo must save + sprite) → Meet.
3. Land on **`/account`**. Breakfasts will not show until you add their email.

Photo must actually save (later video). Join waits until photo + sprite exist.

### 2. You unlock Join (per person, as they register)

1. Copy the **exact Login email**.
2. Supabase → `double.self_serve_sim_allowlist`.
3. **Insert** one row: `simulation_id` = Breakfasts (`085f0d5f-56e1-4d8a-97af-0e7b6006ac47`) + email **lowercase**.
4. They refresh `/account` → Join.

If `/account` is empty they can Submit-for-a-seat. That is **not** Join. You still insert the row.

Scratch list of emails you already added. Duplicate email is noise, not a second seat.

### 3. They Join (sim must still be stopped)

They pick **home + job** (role + workplace). You do not Join for them.

Each person hard-refreshes the watch URL and **sees themselves at home**.

Cap is 6. If more than six club members Join, only six bodies land — stop adding when the roster is full.

### 4. You Start (not a portal click)

When the people who should be in this run are on the map and the sim is still **stopped**:

Tell the backend agent: **Start Breakfasts, sprint, skip-premiere, diagnostic off. Clock = Pittsburgh date of Start.**

Default is skip-premiere (Survival morning ~06:00, Hobbs 11:00 / 20:00). Premiere would add an extra intro day — only if you ask.

**Clock (why tonight showed Sep 8):** the watch timer is the **in-world date**, not “forked on.” This sim’s start day was still **Sep 7**. Skip-premiere always skips Premiere by jumping to the **next** calendar morning, so the timer showed **Sep 8**. Starting on Sep 11 does not, by itself, rewrite that.

Start has **no** “today” switch in the Play/Start click. The agent does it on reset + Start:

1. Reset to step 0 on a fresh Premiere morning.
2. Set the hidden start day to **the Pittsburgh calendar date of Start, minus one day** (`America/New_York`).
3. Then skip-premiere. The timer shows **the day you started** (Saturday 12 Sep if you Start on the 12th).

Do not drop skip-premiere just to make the date match — Survival would stay on intro day and 11:00 / 20:00 would not run that morning.

Confirm before Start:

- Survival empty-roster fix is still on the box (tonight’s patch). **Do not `git pull` `railway` on the VPS** — that can wipe the patch and the season ends after one minute again.
- Do not restart the API.

### 5. After Start

Started **2026-09-12** morning: sprint 1000, skip-premiere, diagnostic off. Three Doubles on the map.

- Watch: `https://www.doubland.ai/pittsburgh-business-breakfasts`
- Play = playback of generated minutes.
- **Do not Join.** Late person: **pause → they Join → resume.**
- Do not restart the API.

---

## Later (not a Start gate)

- Group photo
- Individual photos (each Double’s saved Look still)

---

## Do not

| Don’t | Why |
|---|---|
| A new sim name / new watch URL | Allies already have this link |
| Join while generating | Bodies will not land cleanly |
| PUT the whole allowlist | Wipes everyone already added |
| Restart the API mid-run | Kills generation |
| Treat Play as Start | Playback only |
| Downtown / PPG this wave | Village / Hobbs |
| Delete Doubles as people | Unlink from this sim only |

---

## Live notes - Observed from user interactions

Raw dump from 12 Sep (your wording). Open work: [`20260915_TODOs.md`](20260915_TODOs.md). Archive / evidence: [`20260914_Post_breakfasts_todos.md`](20260914_Post_breakfasts_todos.md).

1. Onboarding Quiz
- improve navigation with fingers on mobile: larger elements + text
- before taken for the first time: inform users that honest answers and with detailed explanation into 'why' allows better capture of their personality and better predictions
- Chat section: make it obvious that users can respond in any language

2. Profile finalize
- make it obvious that the first step is to add a photo (e.g. highlight 'take photo' button)
- if user tries to continue by skipping photo & sprite selection - remind them that both photo and sprite selection are required to continue

3. Meet you double page
- ask to verify their profile data below. 
- If they don't like something or want to correct something - they should be able to do so (e.g. go back to quiz and update their original questions OR get into the raw records on their profile ane update directly (verify if it is good/bad idea))
- Make sure that if user goes back - they see their previous answers, nothing should be lost

4. Submit your profile
- Very long wait - investigate the ways to accelerate (maybe transition to the next screen without successful response on completing previous step - and if it never comes - ask user to review/resubmit)

5. Chose Home & Role in a sim
- brief note to explain what is going on and why at this screen
- reduce number of home options (3 is enough) and ensure that only available homes show up
- ideal UX for home selection is visual - pick on a map (or at least show 3 plans)
- sim roles - add Pics - 3 options is enough;  make sure that only available roles are shown (hide those that were already taken)
- ideally - suggested roles should fit user profile (want to avoid LLM calls, probably postponed for later)

6. iPhone navigation - inconsistent (Android is fine)
- map at https://www.doubland.ai/pittsburgh-business-breakfasts did not fit the screen - at first map navigation controls (center-on, -/+) were hidden, finger jestures worked only for zoom in/out - dragging map didnot work
- then something happend - and the right part of the screen (including map controls) showed up, while the left part (Date & Time) were not shown
- then suddenly the map got fully onto the screen and finger gestures started working (zoom in/out + dragging map with one finger)

7. Map
- during first reveal - make a quick tour on the key functionality (e.g. center-on, chat with double) - let users figure out the rest.
Suggest them to have fun by chatting with their double, testing double's knowledge about them and help improve it
- double's name on a map - not what was set by user during account selection, but a part of the email is shown

8. Playback
- after sim was initiated by admin, the map on users' phone switch to loading mode and got stuck there - should have switched to LIVE 6X default playback mode automatically (no page reload required)
- At some point the playback was shown at LIVE 1X mode and I was not able to switch to other speeds, despite sim gen progressed well beyond the current step on the map
- by default, map should always focus on the user's double - including when scrolling through the timeline (dragging the scrubber)

9. Sprite card
- remove disclamer wording, preserve space

10. Chat
- after submitting first message in the chat, it takes forever to receive the first response - how to minimize wait time OR make wait time entertaining?
- enable post-chat review (after chatting with the double's owner) and updating/enhancing personality profile/facts

11. Double's role in the chat (depending on who double is it chatting with) - this is worth a dedicated psy research to establish ground rules:
A. with owner
- Use any chat as an opportunity to learn more about the user and replicate their personality, values, believes (i.e. ask questions, analyze owner responses and update internal settings)
- double should maintain a distinction between real personalty and life of it's owner and double's life in simulation
- it is double's responsibility to help user understand where this distinction lies - between the sim and real life
- users want to influence behavior of their double
- maintain what-if mode (to allow user to try playing their lives with difference settings), where user provides guidance/settings/strategy with which double should operate with - as if taking on a certain role to see how it will play out
- while it is on double to guide discussion with it's owner, double should clearly understand that owner's desire is top priority

B. with others - need to find the balance (research question):
- double should not reveal personal / private / sensitive information
- others should recognize owner personality in discussions with their double
- some users may want to choose what can be revealed about them

12. PSY - research question (how to find the right balance)
- while users mostly interested to watch themselves, they are also interested in learning secrets about others, however they got upset if someone learns something about them they consider private/secrete
- User may view themselves a certain way, but it does not warrant that others see them the same way
- we need to maintain the right balance between double's behavior being recognizable (by owner and other players who know the owner) and the desire of the user to maintain control over actions and behavior of their double - where is this fine line?
- owner should feel control over their double. 
- if owner want to set behavior that it very atypical to them, double can clarify - e.g. 'are your sure? this does not sound like you.' may be have some temp settings that can be turned on/off for a particular situation between being permanently wired


13. General
- users can accidentially leave sim page, and not sure how to get back to sim (can we block exit from sim page)
