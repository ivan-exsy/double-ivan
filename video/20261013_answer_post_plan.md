# Answer: Finalized post-production plan from selected facts
**Date:** 2026-10-13 · **From:** Screenwriter, Video Producer, Reality TV (merged by COS) · **Status:** answer, not a publish

## 1. Is the missing step right?
Yes. Add one pass after the facts are chosen. It's a constrained join, not a free rewrite. The craft goes in three cheap places:
- **Upstream, at no cost (Reality TV):** the beat contract names a *carrier*, the person who breaks the promise. The carrier is the first named subject of every story beat: teaser, challenge choice, betrayal, exit, and goodbye. That alone fixes most of the list feel. On this night, Yevgenia comes first in the challenge, before Elfi.
- **The join pass (Screenwriter):** a thin pass governed by a closed grammar. It fixes the three mechanical faults: mixed tenses, a full name repeated where a pronoun would do, and missing handoff words. It also turns direct "I…" quotes into reported speech, which removes the accent trap.
- **Scene, sound and picture (Video Producer):** a fixed lookup from beat to row in the package builder. No model, no cost, and the same output every night. The model's only per-row input is who is on screen and which log step, and both are copied from the selected facts.

## 2. Method
All three agree on one approach: **pass 1 produces the fact lines, then a thin pass 2 bound by the connector grammar.** It can run with no human in the room because the checker does a word-level diff and never has to judge meaning.

Pass 2 may only:
- (a) Put every line in present tense. Exceptions: the earlier promise on the betrayal line ("promised") and "voted against each other tonight."
- (b) Replace a repeated name with a pronoun, **only when exactly one person was named in the sentence before.** (This is stricter than "nearest person of that sex", and it never guesses gender.)
- (c) Turn a direct quote into reported speech, keeping the quoted words.
- (d) Add an allowed connector at the start of a line or clause.
- (e) Join two adjacent fact lines with "and", but never across a picture change.
- (f) Reorder lines within one beat so the carrier comes first. Beat order never changes.

The checker rejects any output with:
- a proper noun, number, place or object that isn't in pass 1;
- a content verb, adjective or adverb that isn't in pass 1 (connectors, "says", "too" and pronouns are exempt);
- a banned connector, or "went to", "lands", or a "you" outside a reported clause;
- a pronoun with no single antecedent;
- a moved beat, or a dropped fact that isn't on the cut list;
- a read outside 70–75 seconds at 2.2 words a second.

**If a line fails, use its pass-1 version unjoined. Never retry freely.**

**Cold-viewer test**, run by the checker on the read alone (Reality TV):
1. The carrier is named in the teaser, the betrayal, and the exit or goodbye.
2. Every pronoun resolves to exactly one person in the sentence before.
3. Every line after the open either shares a named person with the line before it or starts with an allowed connector. Two unlinked lines in a row fail the test.
4. A stranger can answer three questions: who promised, who left, and what she said.
5. Removing any one story line leaves a dangling name or pronoun. If no line breaks when it's removed, the read is still a list.

## 3. Connectors
**Allowed (closed list):** Then · Tonight / "Tonight turns on two of them" · At the challenge, · Before the vote, · When the ballots come in, · After the tiebreak, · On her/his way out, · she/he says · and · too (a second person making the same choice) · Both · Each · Tomorrow, · still (only in "still in").

**Banned:**
- Cause: because, so, that's why, which is why, as a result, after all, that's when.
- Verdict or expected outcome: but, yet, even though, despite, instead, only to, ironically.
- Drama: finally, suddenly, just like that, in the end, too late, everything changes.
- Knowledge or feeling: secretly, behind her back, little does she know, knows, realizes, feels, hopes, wants, fears.
- Feud: betrays, turns on her, backstabs, revenge, payback, rival, feud, alliance crumbles.
- Hype: shocking, stunning, unbelievable, of course.

"Turns on" is allowed only in "Tonight turns on two of them."

## 4. The package: Post-Production obeys **Scene**
All three agree. Scene becomes structured fields. The shot name is derived from Scene in code and is never chosen on its own, so the two can't disagree.

**Per row:**
- `row`
- `beat` (teaser | open | two | challenge_wide | challenge_choice | win | ballot | betrayal | result | goodbye | count | tomorrow | close)
- `spoken` (already joined)
- `subjects[]` (cast ids; at most 2 per generated frame; a lead never shares a generated frame with anyone else; a line that says "she" shows only her)
- `asset` (live_capture | cinematic_two | solo_clip | group_photo | frozen_ref | ballots_clip | greyout | count | door | flyover | end_card)
- `source_ref` (a log step, a cast id, or a row id)
- `motion` (still | move)
- `picture` (generate | reuse | existing)
- `name_chip`
- `bed` (off | in | under | thin | out)
- `hit` + `hit_on` (a word or "cut")
- `min_s`

**Per package:** `bed_track`, `hits_max=3`, `move_max=8`, `black_after_teaser`.

Timing comes from the voice track's word timestamps. Cuts fall on line boundaries, and hits fall on their word's timestamp.

The validator fails the package, and Post refuses to cut it, when:
- an asset is missing;
- the ballots clip is used more than once;
- there are more than 8 moving shots or more than 3 hits;
- a frozen_ref points to a row other than the teaser;
- a generated frame has more than 2 faces;
- a person's first appearance has no name chip.

## 5. This night, rewritten into the package
About 165 words, roughly 75 seconds. It hasn't been read aloud and timed yet.

| # | Spoken | Scene / asset | Motion | Picture | Sound |
|---|---|---|---|---|---|
| 1 | Yevgenia promises Elfi she'll vote with her. | live_capture of Elfi + Yevgenia at PPG Cafe (logged promise step), then cinematic_two of the same pair | move | generate (approve faces first) | bed off, room tone; promise hit on "Elfi"; then 1.0s black |
| 2 | These are Doubles, AI versions of real people. Five of them are playing Survival, and every night, one is voted out, until one remains. | group_photo | still | existing | bed in |
| 3 | Tonight turns on two of them: Yevgenia Pritchard and Elfi. | solo_clip Yevgenia, then solo_clip Elfi, with name chips | move | existing | under |
| 4 | At the challenge, Hold for the Shield, each player holds a secret card or folds. Whoever holds the highest card is safe tonight. | live_capture of all five (fallback: group_photo push) | move | existing | under |
| 5 | Yevgenia holds. She says she doesn't fold on things she's started. | solo_clip Yevgenia | move | existing | under |
| 6 | Elfi folds, to keep her energy for the home and the kid. | solo_clip Elfi | move | existing | under |
| 7 | Ivan holds too, and wins. | solo Ivan + name chip | still | existing | under |
| 8 | Then every Double casts a ballot. | ballots_clip (only use) | move | existing | under |
| 9 | Yevgenia promised to vote with Elfi. Then Yevgenia votes against her. | frozen_ref of row 1 | still | reuse | betrayal hit on "against" |
| 10 | Elfi and Yevgenia tie, two votes each. After the tiebreak, Yevgenia is gone. | greyout of Yevgenia | still | existing | thin |
| 11 | On her way out, she says she showed up and did the work, and that loyalty is a two-way street. | door | move | existing | door hit on the cut, then under |
| 12 | Five become four. | count | still | existing | under |
| 13 | Elfi and Luba voted against each other tonight. Tomorrow, both are still in. | solo Elfi + solo Luba (PPG Cafe, name chip) side by side, then the flyover on "Tomorrow" | move | existing | under |
| 14 | Watch every conversation, challenge, and vote live at doubland.ai. | the same flyover continues into end_card | (continues row 13) | existing | out about 1.5s after the card |

## Open items — resolved in the production lock

Resolved in `20261012_dailyScript.md`, section "Production lock — join pass and package." This table stays a method demo. It is not the script we record.

- **Row 9.** The heard line stays "Then she voted against her." The checker whitelists that shape on the betrayal line only. "She" is the person who promised. "Her" is the person they promised to vote with. Repeating the name, and switching the ballot to present tense, are both rejected.
- **Move count.** The flyover on rows 13 and 14 is one shot. The teaser's capture-plus-cinematic is one shot. The film stays at eight moves.
- **Row 4.** The challenge sentence is a fact line. The join may not change its words. This night keeps "All five play Hold for the Shield…"
- **Win line.** "Too" is not added. The line stays "Ivan holds, and wins."
- **Cut order.** Unchanged: challenge block, then the separate ballot line, then the other lead's reason shortened to the verb.
