## Daily trailers

Live video SOT. Only locked rules go here. The previous long file is an archive: `SOT-video-dump.md`.

### Script engine

Locked 2026-10-14. Variant `daily-v2`. The writer is `double-video/video/trailer_pipeline/daily_golden.py`.

Each night uses the same named skeleton. The words change. The jobs do not. A line that copies another night, or that misses a locked sentence, fails and is replaced from this night's fact packet.

Length gate: 132–280 words, about 60–120 seconds.

#### Skeleton

| Order | Name | What stays | What changes |
|---|---|---|---|
| 1 | teaser | Both people in tonight's promise, each named once | The hook from this night's quote |
| 2 | open | The Doubles sentence. Night 1 adds the full Survival teach | Later nights add how many started and how many are left |
| 3 | intro | Workplace, then one thing they did today | This person's place and action |
| 4 | intro | Same, for the other featured person | Same |
| 5 | challenge | Night 1: "Tonight every Double faces a challenge." Later: "Tonight the challenge is {name}." | This night's game and the prize it pays |
| 6 | choice | One line per featured play, in their own words | The action and the phrase |
| 7 | win | One line. Every winner. The prize this path paid | Names and prize |
| 8 | afternoon | Zero, one, or two talks. Name who was told | The talk, if one happened after the challenge and before the vote |
| 9 | bridge | The strategies sentence, every Survival night | Nothing |
| 10 | ballot | "By the end of the day, each Double casts a ballot." | Nothing |
| 11 | betrayal | Promised to vote with that person, then voted against them | The pair |
| 12 | result | The named ballots, then who is gone | The tally |
| 13 | farewell | This person's last words only | The phrases from tonight's statement |
| 14 | census | "Just like that - {N} become {N-1}." | The count |
| 15 | tomorrow | Who is still in | The pair, and whether both remain |
| 16 | close | Odd nights: the signature. Even nights: the next Doubland line | Which closer this night is |

An afternoon row is omitted when the day has no real talk in that window. The bridge, ballot, and close still play.

#### Locked sentences

**Open, Survival night 1.** Exact:

> These are Doubles, AI versions of real people. The simulation is running Survival mode. Every night, one is voted out, until one remains.

**Open, later nights.** The first sentence stays. Then the count of who started and who is still in:

> These are Doubles, AI versions of real people. Five started in Survival mode, and now four are left.

**Bridge, every night.** Exact:

> As the day continues, conversations turn into strategies. Strategies turn into votes.

**Ballot, every night.** Exact:

> By the end of the day, each Double casts a ballot.

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

**Result.** Say each named ballot count, then `{Name} is gone.` A tie is `{A} and {B} tie, {count} votes each. After the tiebreak, {Name} is gone.` Do not say "went home on N votes." If the official count is a fraction, speak the named ballots and leave the fraction out.

**Farewell.** Only phrases from this person's final statement. Another night's goodbye does not carry over.

**Tomorrow.** When both people in the pair are still in: `{A} and {B} voted against each other tonight. Tomorrow, both are still in.` When one of them leaves: name the vote, then `{Survivor} is still in.` Do not say both are still in after one has left.

#### Proof

`pittsburgh-demo-2`, variant `daily-v2`.

- Survival night 1, engine day 2, run `20261014-1`. Hold for the Shield. Yevgenia leaves. Five become four.
- Survival night 2, engine day 3, run `20261014-2`. Silent Pact. Elfi and Ivan each cast a vote and a half. Elfi leaves. Four become three. The closer is the chat line.
