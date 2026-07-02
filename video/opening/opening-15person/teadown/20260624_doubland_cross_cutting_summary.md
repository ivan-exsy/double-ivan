# Doubland Anya reference — cross-cutting rebuild rules

**Runtime:** 76.578 s on the **2160×3840 native 9:16 master** (`DOUBLAND1.mov`).

> The original master confirms the same transition grammar, text-settle behavior, cast rhythm, clip framing, and end-card sequence. No additional scene, alternate cut, or hidden full-opacity layer was found.

## Core motion grammar

1. **Keep the eye on one center axis.** WHAT IF, answer lines, DOUBLE, section captions and the final URL repeatedly replace one another in the same central band.
2. **Use motivated handoffs, not generic crossfades.** Ring becomes a system, word becomes logo, conversation card becomes decision card, selected identity card expands into a character, character blur becomes a gauge, question yields to URL.
3. **Text types once, then stops.** The underscore cursor/glitch exists only while text is entering. After the last character, text is motionless for roughly 0.6–1.4 seconds.
4. **Hero video stays prominent.** Village/map clips run at full or near-full opacity; local gradients and corner HUDs create space for copy.
5. **Cast rhythm is panel → character → panel.** Each character reveal is ~1.8–2.3 seconds, with a ~0.6–0.8 second selection-screen bridge.
6. **Persistent anchors make dense sequences coherent.** Lower conversation figures remain while upper UI changes; the family remains while location changes; the active-double row remains while evidence panels change.
7. **Color has semantic jobs.** White = narration/copy; cyan/blue = AI, identity and brand; copper/red = danger, Survival and pressure.
8. **End quickly.** Scenic setup (~2.1s) → final question (~1.5s) → overlapping URL takeover (~0.7s) → isolated URL hold (~0.58s). No post-settle bounce or pulse.

## Energy curve

Dark minimal hook → increasingly layered AI interface → bright world reveal → dense social UI → dramatic Survival warning → clean gray cast portraits → pressure/map peak → live/replay feature montage → proof dashboards → quiet foggy reflection → dark final question and blue URL.

## Rebuild priorities

- Implement phrase-level type-and-hold timing as a reusable component.
- Implement named transition primitives: `sharedCenterReplace`, `persistentLayerSwap`, `cardSelectZoom`, `radialObjectMatch`, `textHoldAcrossBackgroundCut`, and `questionToUrlTakeover`.
- Keep clips at hero scale and place HUD around the center text channel.
- Treat the selection panel and cursor as required cast-section beats, not optional decoration.
- Preserve the mid-trailer URL plate and the separate, cleaner final URL treatment.
- Opening head: three-frame poster flash (~50 ms) → black reset → WHAT IF readable ~0.133 s (30 fps: poster frames 0–1, black 2–3, WHAT IF by frame 4).
