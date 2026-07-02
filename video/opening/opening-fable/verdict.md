# Verdict — teardown fitness for automation

**Audit date:** 2026-07-01. Reference `DOUBLAND1.mov` (76.578s) vs auto `20260628-4/overview_day2&002/output/trailer_9x16.mp4` (115.0s).

## Is the teardown sufficient?

**Timing skeleton: yes. Automation spec: no.**

The 65-sub-moment boundaries in `timecode_index.csv` are correct — spot-checked against the master at 0–5s, 27–42s, 41–56s, 52–62s, 71–76.6s; every label lands where the frames say it should. No boundary corrections needed.

But the index is a **narration-shaped clock with prose labels**. It records *when* things happen, not *what is on screen as layers* or *how one composition becomes the next*. An automation pipeline reading it can only produce "one scene per row" — which is exactly what the auto cut did. The missing spec is delivered here as `visual_beat_map.csv` (layer states + transition primitive per beat) and `transition_primitive_catalog.md`.

## Top 3 root causes the auto pipeline missed

1. **Wrong abstraction: narration segment = scene.** Auto renders 1 static composition per VO segment (some held 15–25s: ~11.5–18s, ~28–55s, ~70–83s are near-frozen). Anya packs 2–4 visual micro-beats inside each VO segment — text retypes, a HUD morphs, a background cuts under persisting text. The beat clock must be **visual**, with narration attached loosely (see `narration_visual_coupling.csv`: ~60% of reference VO segments have visuals that keep changing underneath).

2. **No layer persistence / motivated handoffs.** Auto transitions are full-frame replaces (or nothing at all). In the reference, almost every cut keeps ≥1 layer alive across it: the wireframe conversation figures persist under three different UI cards (27–32s), the family photo persists under location cuts (33–35s), the cast selection panel returns between every character (41–53s), text persists across a day→night background cut (60.9–63s). Without a layer-state model, "continuous journey" is impossible.

3. **No hero-scale imagery or cast panel↔character rhythm.** Auto compositions are a dark gradient + small dim thumbnail + large paragraph text. Reference runs full-bleed village/map clips and full-body characters on light gray, with the strict panel(0.6–0.8s) → character(1.8–2.3s) → panel loop. The 43s cast+world block — the largest auto failure — is structurally absent from the auto cut, replaced by static caption cards.

Secondary: auto is 115s vs 76.6s reference (+50%), text is multi-sentence paragraphs instead of ≤6-word type-and-hold phrases, and the brightness curve is flat-dark instead of dark→bright world→gray cast→dark end.
