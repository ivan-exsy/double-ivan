# Implementation Request: Shared Conversation Anchor for In-World Chat

## 1. Objective

Implement a new in-world chat visualization system in Doubland based on the **Shared Conversation Anchor** concept.

The goal is to make conversations understandable when multiple Doubles occupy the same screen area. A viewer should be able to immediately identify:

- Who is currently speaking
- Who is participating in the conversation
- Which speech bubble belongs to which conversation
- Which simultaneous conversations are separate
- How to focus, minimize, reopen, or skip a conversation

The system must preserve the current in-world speech-bubble experience and remain readable while the simulation runs at 1×, 6×, and 15× playback speeds.

This is not a redesign of the transcript or chat-generation system. It is a frontend visualization and spatial-layout improvement.

---

## 2. Core Interaction Model

Each active conversation should become a first-class UI object called a **Conversation Anchor**.

A Conversation Anchor represents the conversation as a whole rather than representing only the current speaker.

For a two-person conversation, the anchor contains:

1. The current utterance
2. The current speaker’s name
3. A participant label such as:

   `Maya ↔ Leo`

4. Short visual connectors from the anchor to both participating Doubles
5. A visual indication of which participant is currently speaking

The speech bubble should be positioned relative to the conversation anchor, not independently relative to the current speaker.

When the speaker changes, the anchor should remain stable. Only the active-speaker styling and bubble content should update.

---

## 3. Default Two-Person Conversation

### Visual structure

For two Doubles sitting or standing near each other:

- Place one Conversation Anchor above or beside the midpoint between the participants.
- Show the latest/current utterance inside the speech bubble.
- Show the current speaker’s name prominently in the bubble header.
- Show both participant names in a persistent pair label:

  `Maya ↔ Leo`

- Draw short connectors from the pair label or anchor base to each participant.
- Emphasize the current speaker’s connector.
- De-emphasize the listener’s connector.

Possible speaker emphasis:

- Increased connector thickness
- Increased opacity
- Small pulse at the participant endpoint
- Speaker-side highlight on the pair label

Do not rely only on color to identify the speaker.

### Status stickers

While a Double is participating in an expanded conversation:

- Hide their normal activity emoji.
- Hide their duplicate full name sticker when the conversation anchor already identifies them.
- Allow the conversation system to own participant identification.
- Do not show both a normal status sticker and a full conversation identity label for the same Double.

Non-chatting bystanders may retain their status stickers unless those stickers conflict with the conversation layout.

---

## 4. Conversation Bubble Content

The expanded bubble should show only the **current utterance**, not a scrollable transcript.

Do not add scrolling inside the in-world bubble.

Reasons:

- Scrolling conflicts with click-to-skip.
- Scrollable bubbles become too large in dense scenes.
- Scrolling is difficult while the world moves at 6×.
- The in-world bubble should remain lightweight and spatial.

### Optional focused context

When a conversation is focused, the bubble may optionally display up to two recent utterances in a visually secondary style above the current utterance.

This is optional for the first implementation.

The complete transcript should remain available through the existing secondary transcript/history experience.

---

## 5. Conversation Anchor Placement

### Participant midpoint

Calculate the conversation’s world-space midpoint from the positions of all active participants.

For two participants:

```text
midpointX = (participantA.x + participantB.x) / 2
midpointY = (participantA.y + participantB.y) / 2
```

For group conversations:

```text
centerX = average(all participant x positions)
centerY = average(all participant y positions)
```

The anchor should be placed near this point but offset into available screen space.

Do not place the bubble directly over the participant midpoint when this would cover faces, bodies, animation, or important scene activity.

### Stable placement

Each conversation should receive a stable layout slot based on its `conversation_id`.

The anchor should not jump between the left, right, top, and bottom of a group every time a participant moves slightly or the speaker changes.

Use:

- Position smoothing
- Layout hysteresis
- Minimum time before changing slots
- Stable ordering based on `conversation_id`

A conversation should move to a new slot only when its current position becomes invalid or clearly worse.

---

## 6. Shared Occupancy and Protected Zones

The chat-bubble system and status-sticker system must share spatial occupancy information.

Currently, bubbles and stickers are composed separately. This allows one system to avoid its own elements while still overlapping elements from the other system.

Create a common layout or occupancy service that knows about:

- Sprite protected zones
- Face/head zones
- Status sticker rectangles
- Conversation anchor rectangles
- Expanded speech-bubble rectangles
- Minimized conversation chips
- Viewport boundaries
- Other important world UI

### Protected zones

Each visible Double should expose a protected rectangle or polygon covering:

- Face/head region
- Most of the visible sprite body
- Any important interaction animation
- Remaining visible name/status sticker

Expanded conversation bubbles must not cover these areas except during a very brief animated transition.

### Placement priority

When searching for an anchor position:

1. Avoid participant face and body zones.
2. Avoid other Doubles’ face and body zones.
3. Avoid other expanded conversation anchors.
4. Avoid important status stickers.
5. Stay inside the viewport.
6. Minimize connector length.
7. Minimize movement from the previous anchor position.

The layout engine should prefer a stable, slightly less optimal position over constant repositioning.

---

## 7. Dense Scene Behavior

Example: three pairs of Doubles chatting in a busy bar.

The system should first attempt to place all three expanded Conversation Anchors around the outside of the sprite cluster.

Possible arrangement:

```text
[A ↔ B conversation]       [C ↔ D conversation]

           busy sprite cluster

              [E ↔ F conversation]
```

Each conversation should have:

- A stable anchor position
- Its own participant label
- Short connectors to its participants
- A stable conversation token

The token may combine:

- Shape
- Small icon
- Accent color
- Line pattern

Color must not be the only distinction.

### Maximum displacement

Conversation anchors may be pushed away from the participant midpoint, but only up to a defined maximum distance.

Recommended initial test range:

- Preferred offset: 50–100 px
- Maximum normal offset: approximately 160–220 px, depending on camera zoom and screen size

Do not allow connectors to become long lines crossing the entire viewport.

### Overflow behavior

If all expanded bubbles cannot be placed without covering protected zones or overlapping heavily:

- Keep the highest-priority conversation expanded.
- Collapse lower-priority conversations into compact Conversation Chips.
- Place chips near the relevant participant cluster or along the nearest free edge of the cluster.
- Preserve participant identity in the chip.

Example:

```text
[A ↔ B · speaking]
[C ↔ D · 2 new]
```

A minimized conversation must never disappear entirely while it remains active.

---

## 8. Conversation Priority

Conversation priority should be deterministic and driven primarily by user intent.

Use the following order:

1. Conversation explicitly focused by the user
2. Conversation most recently reopened by the user
3. Conversation containing a newly displayed utterance
4. Other currently active conversations
5. Temporarily inactive or older conversations

Within the same priority level, use a stable secondary order based on `conversation_id`.

Do not assign priority based on the semantic importance of dialogue content.

The system should not attempt to decide that one fictional conversation is more important than another based on an LLM interpretation.

### Automatic focus

Do not constantly auto-focus whichever conversation receives the newest line.

A new line may raise a conversation’s layout priority, but it should not override an explicit user focus.

User focus remains active until:

- The user focuses another conversation
- The focused conversation ends
- The user manually exits focus

---

## 9. Click and Pointer Behavior

Different clickable regions must have distinct behaviors.

### Bubble body

Clicking the utterance body should preserve the existing behavior:

- Skip the current utterance
- Advance that conversation by one line

Do not use the bubble body to activate focus, because this would conflict with the existing click-to-skip mental model.

### Pair or group label

Clicking the participant label should focus the conversation.

Examples:

- `Maya ↔ Leo`
- `Maya · Leo · Ana`

When focused:

- The conversation receives the best available anchor position.
- The conversation remains expanded.
- Other expanded conversations may collapse into chips if needed.
- Other conversation UI may become slightly less prominent.
- The world continues moving.
- Playback does not pause.
- Participant sprites should remain fully visible.

### Minimize control

Add a small minimize control to the expanded anchor.

The control should be discoverable but visually secondary.

Clicking minimize should:

- Collapse the full bubble
- Preserve the conversation as a compact chip
- Continue the conversation internally
- Preserve unread/new-line state
- Not pause or terminate the conversation

Do not label this action “close” in the UI if the conversation is still active. “Minimize” or a conventional collapse icon is more accurate.

### Optional skip-rest control

A “skip rest of conversation” action may be added later as a secondary control in focused state.

It is not required for the first sprint.

---

## 10. Minimized Conversation Chips

A minimized conversation should remain represented as a compact chip.

For two participants:

`Maya ↔ Leo`

For a group:

`Maya · Leo · Ana`

Optional state indicators:

- `speaking`
- `2 new`
- Small pulse when a new line appears
- Current-speaker indicator
- Small conversation token

### Reopening

Clicking a minimized chip should:

1. Expand the conversation
2. Focus it
3. Give it the highest layout priority
4. Recalculate nearby conversation placement
5. Preserve the current utterance and conversation progress

The chip should remain minimized until:

- The user reopens it
- The conversation ends

Do not automatically reopen a user-minimized conversation when a new line arrives.

A brief pulse or unread counter is sufficient.

### Conversation end

When a minimized conversation ends:

- Keep the chip visible for a short completion grace period.
- Optionally show a subtle completed state.
- Fade the chip out.
- Preserve the transcript in the secondary history system.

---

## 11. Participants Moving Apart

Example: two Doubles meet briefly, exchange several lines, and continue walking while the dialogue remains readable at 6×.

The Conversation Anchor should not immediately follow either individual participant.

Instead:

1. Keep the anchor near the original meeting location or recent shared midpoint.
2. Allow the current utterance to remain readable.
3. Smoothly update the anchor only while the participants remain within a reasonable distance.
4. Stop extending connectors after a maximum distance.
5. Remove or fade connectors once they become misleading.
6. Keep the pair label and speech bubble visible until the remaining dialogue finishes.
7. Collapse the completed conversation into a short-lived chip before fading.

### Connector maximum distance

Connectors should not stretch indefinitely across the map.

Once a participant exceeds the connector threshold:

- Fade that participant’s connector
- Keep their identity in the pair label
- Optionally show a subtle directional marker at the end of the connector
- Do not attach the anchor to only one participant

The conversation UI represents a recently initiated social exchange, not necessarily the participants’ exact current physical location.

### Rejoining or separation

If participants move close again before the conversation ends:

- Connectors may smoothly reappear.
- Do not recreate a new anchor.
- Preserve the same `conversation_id` and anchor state.

---

## 12. Group Conversations

For a conversation with three or more participants, create one shared group anchor.

Example participant label:

`Maya · Leo · Ana`

For longer names or larger groups:

- Allow truncation after a defined number of names.
- Example: `Maya · Leo · Ana +2`
- Full participant names may appear in a tooltip or expanded focus state.

### Connectors

Draw one short connector from the anchor toward each visible participant.

The current speaker’s connector should be emphasized.

Listeners’ connectors should remain visible but secondary.

### Speaker changes

When the speaker changes:

- Keep the anchor position stable.
- Update the bubble header and utterance.
- Shift active styling to the new speaker.
- Do not reposition the full anchor solely because the speaker changed.

### Group splitting

If a group conversation becomes separate conversations:

- End or transition the original group anchor.
- Create new anchors using the new `conversation_id` values.
- Animate the split so the relationship change is understandable.
- Avoid instantly replacing one anchor with several unrelated bubbles.

This may be simplified in the first version if the backend does not currently emit group-split events.

---

## 13. Playback-Speed Behavior

### 1× playback

- Use the standard dwell duration.
- Follow participant movement with normal smoothing.
- Keep full conversation anchors expanded when space allows.

### 6× playback

- Preserve the existing sub-linear readable dwell behavior.
- Do not make the bubble move six times faster.
- Increase anchor-position smoothing.
- Avoid frequent layout changes.
- Allow the conversation anchor to lag behind participant motion.
- Preserve user focus and minimized states.

### 15× playback

- Prefer stability and compact presentation.
- More non-focused conversations may begin or remain collapsed.
- Keep a focused conversation readable.
- Do not auto-zoom the camera.
- Do not pause the simulation.
- Do not rapidly cycle focus between active conversations.

Playback-speed changes should not reset conversation layout or focus state.

---

## 14. Suggested Component Architecture

The exact architecture may vary, but the implementation should introduce a conversation-level display layer rather than extending only the current speaker bubble.

Suggested responsibilities:

### `ConversationAnchor`

Represents one active conversation.

Owns:

- `conversation_id`
- Participant IDs
- Current speaker ID
- Current utterance
- Expanded/minimized state
- Focus state
- Screen-space anchor position
- Connector state
- Conversation token
- Unread/new-line count
- Last interaction time

### `ConversationLayoutManager`

Responsible for:

- Collecting protected zones
- Measuring bubble and chip bounds
- Assigning stable layout slots
- Avoiding collisions
- Applying priority
- Collapsing conversations during overflow
- Keeping anchors inside the viewport
- Applying smoothing and hysteresis

### `ConversationConnectorLayer`

Responsible for:

- Drawing connectors
- Updating participant endpoints
- Emphasizing the current speaker
- Fading connectors when participants move too far away
- Preventing connectors from becoming excessively long

### Existing components

Likely integration points:

- `ChatBubbleHTML`
- `MultiSpeechController`
- `StatusSticker`
- `playbackTiming`

The existing bubble component may remain responsible for rendering the utterance, but it should be hosted and positioned by the new Conversation Anchor.

The `MultiSpeechController` should expose conversation-level state instead of requiring the visualization layer to infer pair ownership from independent bubbles.

The `StatusSticker` system should report its occupied screen rectangle to the shared layout manager and accept suppression/collapse instructions.

---

## 15. Suggested Conversation State Model

Each conversation should support at least these visual states:

```text
ENTERING
EXPANDED
FOCUSED
MINIMIZED
SEPARATED_BUT_READING
COMPLETING
ENDED
```

### ENTERING

- Conversation has just started.
- Anchor appears near the participant midpoint.
- Connectors animate in.
- Participant status stickers transition out.

### EXPANDED

- Current utterance is visible.
- Pair/group label is visible.
- Connectors identify participants.

### FOCUSED

- Highest placement priority.
- Remains expanded.
- Other conversations may collapse if necessary.

### MINIMIZED

- Only the Conversation Chip is shown.
- New utterances increment unread state.
- Does not reopen automatically.

### SEPARATED_BUT_READING

- Participants have moved beyond the normal connector range.
- Anchor remains stable.
- Connectors fade or shorten.
- Remaining dialogue continues.

### COMPLETING

- Final utterance has finished.
- Anchor collapses into a completion chip.
- Short fade-out grace period begins.

### ENDED

- In-world representation is removed.
- Transcript remains available elsewhere.

---

## 16. Animation Guidelines

Animations should clarify state changes, not attract attention away from the world.

Use:

- Smooth anchor movement
- Short fade and scale transition when expanding or minimizing
- Connector emphasis when speaker changes
- Gentle pulse for unread lines in minimized chips
- Crossfade between utterances

Avoid:

- Bouncing bubbles
- Large camera movements
- Fast connector drawing
- Repeated flashing
- Constant repositioning
- Large color changes on every utterance

Anchor movement should be slower and more stable than sprite movement at 6×.

---

## 17. Accessibility and Readability

- Do not use color as the only pair identifier.
- Maintain readable contrast for bubble text, participant labels, and controls.
- Keep minimize and focus targets large enough for mouse and touch interaction.
- Ensure connectors remain visible against different floor and environment colors.
- Provide clear focus styling.
- Avoid very thin lines that disappear at lower resolution.
- Ensure long participant names do not break the bubble layout.
- Test at desktop and mobile viewport sizes.

Recommended minimum interactive target:

- Approximately 36–44 CSS px where practical

---

## 18. Analytics and Debug Instrumentation

Add temporary development instrumentation to evaluate the spike.

Track or log:

- Number of simultaneous conversations
- Number of expanded anchors
- Number of minimized chips
- Number of automatic collapses caused by overflow
- Number of user focus actions
- Number of minimize actions
- Number of reopen actions
- Number of skipped utterances
- Average anchor movement per second
- Number of protected-zone violations
- Number of anchor slot changes
- Maximum connector length

Provide a debug overlay that can display:

- Protected zones
- Occupied rectangles
- Candidate anchor positions
- Selected anchor slot
- Conversation priority
- Connector distance
- Reason for collapse

This overlay should be development-only.

---

## 19. Required Test Scenarios

Create a controlled test scene containing the following cases.

### Scenario A: Seated pair

- Two Doubles sit side by side.
- They exchange 4–6 utterances.
- Speaker changes several times.
- Anchor should remain stable.
- Status stickers should not duplicate participant identity.

### Scenario B: Walking separation

- Two Doubles meet briefly.
- Conversation begins.
- Both continue walking in different directions at 6×.
- Bubble remains readable.
- Connectors stop before becoming excessively long.
- Conversation completes without truncating the visible exchange.

### Scenario C: Three pairs in a busy bar

- Six chatting participants.
- Three simultaneous two-person conversations.
- Several bystanders nearby.
- Expanded anchors should be arranged around the cluster.
- Bubbles should not cover faces or status stickers.
- Overflow should produce minimized chips.
- User should be able to focus any pair.

### Scenario D: Three-person group chat

- Three Doubles participate in one conversation.
- Speaker rotates among all three.
- One shared anchor remains stable.
- Active-speaker connector changes correctly.

### Scenario E: Manual minimize and reopen

- User minimizes conversation A ↔ B.
- Conversation C ↔ D remains focused.
- A ↔ B continues speaking while minimized.
- Chip shows unread/new-line state.
- Clicking the chip restores and focuses A ↔ B.

### Scenario F: Viewport edge

- Conversation occurs near every viewport edge.
- Anchor remains on-screen.
- Connectors remain understandable.
- Bubble does not cover the participants.

### Scenario G: Playback changes

- Conversation begins at 1×.
- User changes to 6× and then 15×.
- Anchor position, focus state, and minimized state persist.
- Bubble remains readable according to existing dwell rules.

---

## 20. Acceptance Criteria

The implementation is successful when:

1. A first-time viewer can identify the current speaker and listener in under two seconds.
2. A viewer can distinguish three simultaneous pairs without assigning an utterance to the wrong pair.
3. Expanded bubbles do not cover participant faces or bodies for more than a brief transition.
4. Participant status stickers do not duplicate names already visible in the Conversation Anchor.
5. Speaker changes do not cause the anchor to jump to a new location.
6. User-focused conversations remain prioritized.
7. Clicking the utterance body skips one line.
8. Clicking the participant label focuses the conversation.
9. Clicking minimize collapses the conversation into a persistent chip.
10. Clicking the chip reopens and focuses the conversation.
11. User-minimized conversations do not reopen automatically.
12. Conversations remain visually understandable when participants move apart.
13. Connectors do not stretch indefinitely across the viewport.
14. A three-person conversation uses one shared anchor rather than three separate bubbles.
15. The system degrades from expanded anchors to chips when there is insufficient space.
16. The world continues moving during focus, minimize, reopen, and reading interactions.
17. No sidebar or transcript becomes the primary conversation experience.
18. Existing click-to-skip behavior remains available.
19. The system works at 1×, 6×, and 15× playback speeds.
20. The implementation does not require changes to LLM dialogue generation.

---

## 21. Out of Scope for This Sprint

Do not include the following unless required to support the core implementation:

- Redesigning the full transcript/history interface
- User-to-Double chat
- Dialogue summarization or paraphrasing
- AI-based conversation importance scoring
- Automatic camera zoom
- Automatic camera panning
- Pausing the simulation while reading
- Replacing the existing dialogue timing system
- Full support for very large group conversations
- Semantic analysis of conversation content
- Major changes to the chat backend
- Polished production animation
- Final visual token or color system

---

## 22. Recommended Delivery Sequence

### Phase 1: Functional spike

Implement:

- Conversation-level state
- Two-person anchor
- Pair label
- Stable midpoint positioning
- Shared protected zones
- Basic connectors
- Speaker emphasis
- Status-sticker suppression

### Phase 2: Dense-scene behavior

Implement:

- Multiple anchor placement
- Priority system
- Overflow detection
- Minimized chips
- Focus, minimize, and reopen interactions

### Phase 3: Movement and group behavior

Implement:

- Separation grace state
- Connector distance limits
- Three-person group anchors
- Playback-speed tuning
- Viewport-edge behavior

### Phase 4: Polish and validation

Implement:

- Animation tuning
- Accessibility pass
- Mobile/touch adjustments
- Debug metrics
- User testing at 6×
- Performance optimization

---

## 23. Primary Product Question for the Spike

The spike should answer:

> Can viewers correctly identify the speaker, listener, and conversation pair in a dense scene at 6× playback without pausing, opening a transcript, or misattributing lines?

The first implementation should optimize for clarity and stability rather than visual polish.
