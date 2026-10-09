# 20261003 — Pittsburgh demo

This tape does not include the public-card quiz fix. Deploy `ivan/public-card-quiz-sheet` after this demo has stopped. Do not reload the gateway while it is still generating. Check the fix on the next run, not on this one.

## Next run — public card

Signed out, open a Double who took the portal quiz.

- [ ] **The quiz sheet is absent from the two public reads.** `/details` sends an empty `innate` for that person. `/card-summary` sends an empty `traits` list. Neither reply contains `ipip-mini10-portal-v1`, `Disposition snapshot`, or a line like `Openness typical (3.5)`. The card still opens. A person with a plain personality line, such as `curious, friendly`, still shows those chips.