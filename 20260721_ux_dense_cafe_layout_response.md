# UX Response: Dense Café Conversation Layout (canonical)

**Date:** 2026-07-21  
**Decision:** Focused Conversation + Perimeter Chips  
**Related:** `20260721_ux_doubland_chat_density_followup.md`, Conversation Anchor spike

## Recommendation (locked)

In a dense local cluster:

- **One** expanded conversation per dense cluster
- Place expanded bubble **outside** the sprite cluster (not at midpoint)
- Other active conversations → **perimeter chips**
- Click chip / pair label → focus; click bubble body → skip line
- New utterances must **not** steal focus
- Dense-scene mode of Shared Conversation Anchor — not a new chat UI

## Placement

1. Midpoint = origin only  
2. Cluster bounds from chatting participants (+ proximity merge)  
3. Eight perimeter candidate slots (TL/TC/TR/L/R/BL/BC/BR)  
4. Score: viewport, no Double overlap, no other expanded bubble, HUD, distance to midpoint, movement cost, connector length  
5. Hysteresis — prefer stable over optimal

## Expanded limit

- Hard max **1 expanded per dense cluster**
- Up to **2** in viewport only if clearly **separate** clusters  
- Default dense café: never “as many as fit”

## Chips

- Content: `A ↔ B · speaking` / `· N new` — **no utterance text**
- Local rail near cluster perimeter  
- Cap ~5 conversations total; optional `+N other` later

## Priority

1. Viewer-selected  
2. Currently expanded  
3. Most recently reopened  
4. Earliest still-active in cluster  
5. Stable `conversation_id`  

Initial: first active stays expanded; later → chips. On end: promote oldest chip (or recent explicit selection).

## Interactions

| Click | Effect |
|-------|--------|
| Bubble body | Skip one line (unchanged) |
| Pair label | Pin/focus expanded |
| Chip | Swap focus; collapse previous; clear unread |
| Minimize control | Chip only; may leave cluster chip-only |
| World click | Do **not** auto-close |

## Size

- Screen-space readable min (~14–16px); do not shrink with zoom  
- Cap width ~260–300px  
- Dense: trim padding/tabs, not body text

## Identity / stickers

- Required: utterance, speaker, pair label  
- Endpoint markers on focused pair; fade long connectors  
- Focused: hide status emojis; chip participants: minimal; local bystanders: name-only dimmed; outside cluster: unchanged  
- Do not dim sprites

## Sprint in / out

**In:** cluster detect, perimeter slots + hysteresis, 1 expanded/cluster, chips, focus/minimize, endpoint markers, bystander simplify, screen-space min size, unread pulse  

**Out:** full occupancy solver, routed connectors, color tokens, group-split anim, APART grace, auto-camera, transcript redesign

## Engineering

Lightweight `ConversationLayoutManager` (~1 sprint). Timing stays in Speech / MultiSpeech controllers.

## Acceptance (café)

One opaque bubble outside people; chips for others; no focus steal; readable at 6×; stable slots; Doubles visible; world keeps moving.

Full narrative response lives in product chat (2026-07-21); this file is the locked decision summary for FE.
