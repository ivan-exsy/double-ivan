## Daily trailers

Live video SOT. Only locked rules go here. The previous long file is an archive: `SOT-video-dump.md`.

<WORKFLOW>

1. Sim facts are collected, ranked
2. Featured doubles identified
3. More facts on those Doubles
4. Script drafted as a four-column sheet:
| Stage | VO | Scene Description | Audio/SFX | Video/VFX |
5. Voice generated
6. Existing sound and pictures assigned
7. Missing clips made with Imagine
8. Final production. One film: the Remotion nightly trailer (composition `NightlySurvival`). Picture assignment and the render are that same trailer. Do not stitch a separate one-picture-per-line cut.


### Script engine

Locked 2026-10-14. Variant `daily-v2`. Updated 2026-10-19: the ballot sentence is not spoken, the challenge opens with this morning, and the tally names the leaver, then at most the next close count. The writer is `double-video/video/trailer_pipeline/daily_golden.py`. These sentences stay exact. `daily-v3` is the next section.

Each night uses the same named skeleton. The words change. The jobs do not. A line that copies another night, or that misses a locked sentence, fails and is replaced from this night's fact packet.

Length gate: 132–280 words, about 60–120 seconds.

#### Skeleton

| Order | Name | What stays | What changes |
|---|---|---|---|
| 1 | teaser | Both people in tonight's promise, each named once | The hook from this night's quote |
| 2 | open | The signature, every Survival night | How many entered the season |
| 3 | intro | Workplace, then one thing they did today | This person's place and action |
| 4 | intro | Same, for the other featured person | Same |
| 5 | challenge | Night 1: "This morning, every Double faces a challenge." Later: "This morning the challenge is {name}." | This night's game and the prize it pays |
| 6 | choice | One line per featured play, in their own words | The action and the phrase |
| 7 | win | One line. Every winner. The prize this path paid | Names and prize |
| 8 | afternoon | Zero, one, or two talks. Name who was told | The talk, if one happened after the challenge and before the vote |
| 9 | bridge | The strategies sentence, every Survival night | Nothing |
| 10 | betrayal | Promised to vote with that person, then voted against them | The pair |
| 11 | result | Who leaves and their count, then at most the next close count | The tally |
| 12 | farewell | This person's last words only | The phrases from tonight's statement |
| 13 | census | "Just like that - {N} become {N-1}." | The count |
| 14 | tomorrow | Who is still in | The pair, and whether both remain |
| 15 | close | Odd nights: the signature. Even nights: the next Doubland line | Which closer this night is |

An afternoon row is omitted when the day has no real talk in that window. The bridge and the close still play. Do not speak a line that each Double casts a ballot.

#### Locked sentences

**Open, every Survival night.** Exact shape. `{N}` is how many entered the season, spoken as a word. It does not change on later nights. Who is still in stays on the census line.

> These are Doubles, AI versions of real people, making choices no one wrote for them. Five of them entered Survival mode. Someone is voted out every night, until one remains.

**Bridge, every night.** Exact:

> As the day continues, conversations turn into strategies. Strategies turn into votes.

**Census, every night.** Exact shape. `{N}` is who could still vote at the start of the night, not the season start. `{N-1}` is after tonight's exit.

> Just like that - four become three.

**Close.** Survival night number comes from the ledger. Odd nights use the signature. Even nights rotate, then repeat.

Odd nights, exact:

> Watch every conversation, challenge, and vote live at doubland.ai.

Even nights, in order:

1. Watch every conversation, challenge, and chat with any Double at doubland.ai.
2. Watch every conversation, challenge, or create your own Double at doubland.ai.
3. Watch every conversation, challenge, or create your own world at doubland.ai.

Night 1 is the signature. Night 2 is chat. Night 3 is the signature. Night 4 is create your own Double. Night 6 is create your own world. Night 8 returns to chat.

#### What the night fills in

**Teaser.** This night's promise, not a copied "promises to vote with" line. Both names, each once.

**Intro.** `{Name} works at {place}. Today {name} is {action}.` The action is a real part of the day. Skip sleep, the vote, paying the bill, clearing the table, packing, and preparing to leave. A line that mentions the challenge can still be the action when the rest of it shows the person.

**Challenge.** The game name and how they play, then the prize this path pays. Do not teach "someone is safe" on a night that paid a vote weight.

**Choice.** The featured person's own words. One line each, including a winner.

**Win.** One line names every ledger winner and the prize that path paid.

| Prize | Spoken |
|---|---|
| Shield | `{Name} holds, and wins the Shield. {Name} is safe from tonight's vote.` |
| Silent Pact, both protect | `{A} and {B} each cast a vote and a half tonight.` |
| A vote that counts double | `{Name} casts a vote that counts double tonight.` |
| A vote that counts three times | `{Name} casts a vote that counts three times tonight.` |
| Weaker vote | `{Name} gets a weaker vote tonight.` |
| Shield they can give away | Say the Shield, and that they can give it away |

Say "safe from tonight's vote" only when a Shield was awarded. A person who leaves tonight is not called safe. "Double" and "two votes" are a different prize from a vote and a half.

**Afternoon.** Up to two talks after the challenge and before the vote. Each line names who was told. No talk means no afternoon line.

**Betrayal.** `{Who} promised to vote with {other}. Then she voted against her.` Past tense. Do not say who leaves on this line.

**Result.** Start with But. `{Name} leaves with {count} votes.` Name the next person only when their count is tied or within one vote, and only when one or two people sit at that count. If more than two share it, name none of them. If any other votes remain, say "The rest are scattered." Then `{Name} is gone.` Do not list every name. A tie is `{A} and {B} tie, {count} votes each. After the tiebreak, {Name} is gone.` Do not say "went home on N votes."

**Farewell.** Only phrases from this person's final statement. Another night's goodbye does not carry over.

**Tomorrow.** When both people in the pair are still in: `{A} and {B} voted against each other tonight. Tomorrow, both are still in.` When one of them leaves: name the vote, then `{Survivor} is still in.` Do not say both are still in after one has left.

#### Proof

`pittsburgh-demo-2`, variant `daily-v2`.

- Survival night 1, engine day 2, run `20261015-1`. Hold for the Shield. Yevgenia leaves. Five become four.
- Survival night 2, engine day 3, run `20261015-2`. Silent Pact. Elfi and Ivan each cast a vote and a half. Elfi leaves. Four become three. The closer is the chat line.

The October 14 picture films (`20261014-1`, `20261014-2`) still carry the previous voice and the full-level mix. Do not remix them. The next bake applies the picture and sound rules below.

### Script engine, daily-v3

Locked 2026-10-20. Variant `daily-v3`, chosen with `--variant daily-v3`. The section above stays the locked nightly. Same writer. Same film, composition `NightlySurvival`. A v3 run does not set the daily-v2 flag.

The lines are one narration. A locked sentence that drifts is replaced. A story line is replaced only when a required name, count, or quote is missing.

Length gate: 120–210 words, about 2.1 words a second, about 55–100 seconds. A night near 95 seconds can pass when the goodbye and the pair who are still in earn the time.

#### Skeleton

| Order | Name | What stays | What changes |
|---|---|---|---|
| 1 | teaser | The carrier's own play. Omitted when they have no featured play | The verb and their words |
| 2 | open | Night 1 only. The short Doubles line | Nothing |
| 3 | names | One workplace, the carrier | Place and the trait. The picture holds today's chore |
| 4 | challenge | "Today's challenge is {game}." Then the stake. No rules | This night's prize |
| 5 | choice | Every other featured play, in their words. Same choice when the verb matches | The action and the phrase |
| 6 | win | One line, when someone won. At most 16 words | Names and prize |
| 7 | betrayal | Only when a promise exists | The pair |
| 8 | result | Who leaves, their count, the next close count, the rest scattered, gone | The tally |
| 9 | farewell | One landing sentence, once, after the vote. At most 36 words. Shorter than the afternoon line when that line exists | The sentence they said |
| 10 | census | "{N} become {N−1}." | The count |
| 11 | tomorrow | One sentence. Python picks the cause. A separate Tier C call writes the line. The draft keeps it, and may adjust it when it repeats a line already spoken. Never "For now." | The open consequence |
| 12 | close | "Watch live 24/7 at doubland.ai." Every night | Nothing |

The carrier is the person who leaves, when they made a featured play. Otherwise the first featured person. A second person appears only in a choice line or in the conflict. No second workplace. No strategies slogan. No line that each Double casts a ballot. No "Just like that."

**Afternoon.** After the win and before the tally, one sentence from a talk between noon and 8pm, said by someone already in the trailer. Straight quotes. Skip the line when that talk is missing. The picture always marks the hours: daylight and a talk, then the vote. When the sentence exists, it plays on that afternoon shot and the tally stays the vote card. When it does not, those three pictures play under the tally and nothing new is spoken. Do not speak "As the day continues, conversations turn into strategies. Strategies turn into votes."

#### Locked sentences

**Open, night 1 only.** Later nights do not speak it.

> Doubles are AI versions of real people, living unscripted lives in Doubland.

**Census, every night.** `{N}` is who could still vote at the start of the night. `{N−1}` is after tonight's exit. Both are spoken as words.

> Fifteen become fourteen.

**Close, every night.** No odd/even rotation.

> Watch live 24/7 at doubland.ai.

**Title card.** Type on the first spoken line, about 3 seconds, one phrase at a time. Night 1 reads `Night {n}` and `{Started} entered`. Later nights add the Doubles line. How many entered is type. The card may use a numeral. A spoken line still says the count in words.

#### What the night fills in

**Teaser.** That night's sharpest real choice. It changes every night. The carrier, alone. The scene is that one person. The goodbye is the payoff after the vote.

**Names.** One person: where they work, and the trait on the card. Today's chore stays in the picture and is not spoken. When two people share a first name, speak the full name.

**Challenge.** One line. The game, then the stake this night paid. Do not teach how to play. `The winner is safe tonight` is only for a Shield that was paid: Hold for the Shield, Roll for the Shield, Call the Bluff, Bid for the Vest, and a Trial Night acquittal. Hold for the Shield is `Today's challenge is Hold for the Shield. The winner is safe tonight.` Leader's Burden is `The winner is safe tonight, and puts an extra vote on someone else.` Other nights name the vote that was paid: a weaker vote, a stronger vote, a half vote, a double vote, a vote that counts three times, a Shield they can give away, an extra vote against the smaller side, two extra votes on a conviction, a stolen vote that counts as nothing, one full vote while the rest are cut in half, or the commons pot when it holds or breaks. Do not say the winner is safe tonight on those nights.

**Choice.** The other featured person's verb and a short quote of their first clause. When that verb matches the carrier, end with `Same choice.` When their words say invisible, add `Stay invisible.`

**Win.** The prize phrases in the daily-v2 table still name what was paid. A Shield win is `{Name} {verb}, and wins the Shield.` Safety stays in the challenge.

**Betrayal.** `{Who} promised to vote with {other}. Then she voted against her.` A broken promise is the only glass crack. No promise means no betrayal line and no crack.

**Result.** `Then the votes come in. {Name}, {count}. {Next}, {count}. The rest, scattered. {Name} is gone.` The next name uses the same close-count rule as daily-v2. Say "The rest, scattered" only when other votes remain. The choice is not why they leave. A tie names both, the count, and that a tiebreak sends the leaver home. Do not say how it broke. Do not open this line on But.

**Farewell.** Once, after the vote. One landing sentence from the statement. Drop `I'll keep this brief`, `Good luck`, and other sign-offs. A one-sentence statement stays whole when the night has no afternoon line. When an afternoon line exists, cut the landing at a clause they said so the goodbye is shorter than that line. Still inside 36 words, and it does not mention a handout, houses, or the door. Lead: `On his way out, he says` or `On her way out, she says.` When the pronoun is empty, lead with the full name. The narrator does not say "you". "You" may stay inside the quote.

**Tomorrow.** One sentence, after the census. It is the reason a viewer comes back. Python reads the ledger and picks one cause the records agree on. The cause may be one person, a pair, or a group, and someone in it may already have left. A separate Tier C call writes that one line from a short card. The draft keeps the sentence. It may adjust the wording when the line repeats the tally, the goodbye, or the betrayal. The same card rules still apply. The read-through follows the same rule.

The call is `daily_tomorrow_line`. It requests Tier C. Set `LLM_MODEL_DAILY_TOMORROW` to the smart Tier C model when the script calls are pointed at a cheaper model. When that variable is unset, this call uses the Tier C model. One try, then one retry. If both fail, the bake speaks the plain Python sentence and ships.

The card is the broken promise whose ballot names that person, corroborated by a break when one exists. Else one alliance that has a stored reason. Else two people who voted each other and are both still in. Else the survivor of that kind of vote. A pile of wordless alliances, a pile of kept "I'll flag you" pledges, and the tally sentence stay off the card. A mutual vote may sit on the card as support when the cause is the break. The line does not say who leaves next, does not say "for now", and does not start a vote that already happened with "Tomorrow,".

The plain sentence for a break is `{A} promised {B}, then voted against {B}. {Carrier} is still in.` The plain sentence for a mutual vote is `Today, {A} and {B} voted against each other. Both are still in.` The plain sentence when one of them has left is `{A} and {B} voted against each other tonight. Tomorrow, {Survivor} is still in.`

The system prompt for the Tier C call is:

> You write the last spoken line of one daily trailer. The line is the reason a viewer comes back.
>
> You receive one cause. The records already agree on it. Write one line, one or two short sentences, 32 words or fewer. Use only the facts in the card. Do not add a person, a number, a promise, or a motive.
>
> Name every person under Must name, by their full name. You may name someone under May name. Do not name anyone else. Someone who has already left may be named. One person is enough when they carry what happened. Name a group when the card lists that group.
>
> Do not list the events. Do not recap the tally or the goodbye. Do not say who leaves next. Do not say "for now". Do not say "will leave", "will vote", or "next night".
>
> If the cause is a vote that already happened, do not start that vote with "Tomorrow,".
>
> Return JSON only: {"line":"..."}

The user message names the cause, who must be named, who may be named, who has left, who is still in, the facts, one supporting fact when it shows the consequence is still open, and the tally and goodbye as already spoken.

#### Spine

Rebuilt from the ledgers for this draft. The writer sees open pledges, open alliances, and pairs who voted against each other and are both still in, plus last night's public tally. Closed rows stay off the prompt. The checker still fails a closed name who is not part of tonight.

A past fact is spoken inside tonight's sentence, and only when tonight touches that thread. At most forty words. Night 1 has no Previously. The Tomorrow cause is chosen before this draft, from the ledger, not from the spine. Someone who has already left may be named there when a record still carries them. The draft does not search memory. The previous night's script is not in the prompt.

#### Picture

The picture and sound section below still applies, with these differences.

- The strategies slogan is absent. The Talk clip still marks the hours between the challenge and the vote. The ballots clip does not play. The vote card does.
- The teaser frame is the carrier alone. Do not generate the pair.
- The title card is type on the existing film. It is not a new composition.
- A long open, workplace, or challenge shot is cut into beats of about 1.5–3 seconds. The choice, the tally, the goodbye, the count, and the closer keep their hold.
- Voice stays full through the opening choice, then ducks. A night with no choice open ducks at the workplace line.
- The three-hit cap is not applied. daily-v2 still caps at three. `film_rules.py` is unchanged.

#### Proof

Fixture tests in `double-video/video/test_daily_v3.py` and `double-video/video/test_tomorrow_line.py`. Do not bake or remix `20261009-1` night 1. The October 19 voice stays. There is no engine day 3 ledger on disk for that sim, so a later night is not a proof yet.

### Picture and sound

Locked 2026-10-16 from the Night 1 review. Anya's 88s master is the reference. The writer does not change.

Open `double-video/data/anya/L-talks/Daily_1/final/L-talks Day 1.mp4`. First frame: `double-video/data/anya/L-talks/Daily_1/final/L-talks Day 1-Cover.jpg`. This is the file previously called `0720(1).mp4`.

Shelf is `double-video/data/library/`. Pictures under `assets/`. Sound under `audio/`. Type under `type/`. A bake path that still says `video/assets` or `video/audio` is stale.

#### Sound

Hits land on chosen moments. A whoosh on every cut is wrong. The October 14 whoosh is late and quiet, so the cut itself has no hit.

| Job | File | When |
|---|---|---|
| Glass break | `library/audio/sfx/glass-break.mp3` | Betrayal, as the photo cracks. One crack, under a second, no music tail. |
| Short whoosh | `library/audio/sfx/attack-whoosh-impact.mp3` | A picture change that needs a hit. Loud in the first instant. |
| Low hit | `library/audio/sfx/cinematic-impact-09.mp3` | Challenge title, Shield win, walk-out, end card. About 2 seconds. |
| Scan | `library/audio/sfx/startup-sound-02.mp3` | Group photo into the matrix, and the end card. A digital sweep, not typing. |
| Stakes sting | `library/audio/sfx/horror-trailer-opener.mp3` | Season slam, when that card should hit harder than a whoosh. |

Voice stays at `1.0` through the opening line, then `0.66` from the first workplace scene to the end. On Night 1 that duck starts at Yevgenia at work. Ducking the teaser buries the open. Anya kept that line loud.

Music is a separate ride: about `0.21`, then `0.16`, then `0.06` under the challenge teach, then `0.19`.

#### Type and color

Rubik Bold for kinetic words, step lines we set ourselves, and vote numbers. File: `library/type/Rubik-Bold.ttf`. Words stay white `#FFFFFF`, one phrase at a time, fade up with a soft glow. Designed HUD chips keep their own type.

Palette: navy `#060C1C`, cyan `#78D2FF`, card white `#F5F8FC`. Those are `NAVY`, `CYAN`, and `WHITE`. Kinetic white is a step brighter than the card white. The orange threat accent is the later-night NEW TARGETS cliff. Night 1 does not use it.

#### Challenge cards

Each game lives in `library/assets/challenges/<id>/` and must have `title.png`, `steps_board.png`, and `immunity_status.png`. All 14 catalog games have those three. A ledger id that does not match the folder is aliased. Today that is `group_betrayal_game` → `group_betrayal`.

One steps board. Do not draw a separate chip per step. The board is transparent, so the cards can sit on a photo. A baked-in checkerboard is a broken file.

Reveal the cards in order by cropping that one board. Crop fractions live in the challenge `manifest.json` under `steps` (`cropTop`, `cropBottom`). Hold for the Shield is measured: four cards. A board with no `steps` list uses the shared crop table until it is measured. Silent Pact is a three-card board and is not measured yet.

The title card covers the challenge name. The steps then sit on one still from the challenge place and appear one card at a time with the voice. On Hold for the Shield, cards 1–2 sit under "Choose HOLD or FOLD with your secret card," and cards 3–4 sit under "The highest held card wins the Shield." A short whoosh can mark each card. The gather clip then plays with the cards gone.

The immunity graphic plays only when this path awarded a Shield and someone won it: Hold for the Shield, Roll for the Shield, Bid for the Vest, Call the Bluff, Leader's Burden. It sits on the last frame of the winner's clip, on "safe from tonight's vote." It is not its own grey card.

#### Picture

Same faces. No new people.

- Map teaser: punch in during the first half second, then hold.
- Group photo: a short move from this photo. If that clip fails, punch in during the first half second. Then the existing group-photo matrix. Portraits stand upright. An empty cell stays when the roster does not fill the grid.
- Workplace lines: the workplace clip, once, name on screen.
- Shield win: the winner at the challenge place, celebrating, winning card in hand. Not a frozen workplace shot.
- Strategies sentence: Talk on the first sentence, with "conversations" up for about a second. The ballots clip plays once, on "Strategies turn into votes," with "strategies" up for about a second. Talk plays faster, about 1.65×. No navy STRATEGIES card held for seconds. No Village plate. No spoken line that each Double casts a ballot.
- Betrayal: the frozen two-shot. A glass crack spreads across it at the cut, with the glass-break hit.
- Tally: the same group photo, black and white. Stamp a number on each person who received votes. Zeros stay off the picture. The spoken line only names the counts it speaks. On this Night 1 that is Elfi 2, Yevgenia 2, and Luba 1. Marsha 0 and Ivan 0 stay off.
- Farewell: the person leaving goes out through the door, back to camera, and walks away. Night 1 is the night PPG door, bag in hand, hair down, no glasses. The October 14 clip walked in. That clip is replaced.
- Census, the people still in, and the flyover stay.
- Last 1.5 seconds: `library/assets/nightly/end_lockup_9x16.png`, with the low hit and the scan. Anya's L-TALKS plate is her show mark. This film uses the Doubland lockup.

The season-title card is not locked. Her open slams kinetic words over the group photo. A Doubland mark plus SURVIVAL in about 1.5 seconds is a proposal, not a rule.
