# Top 10 visual gaps v2 — REF vs opener&009 (79.8s)

Re-ranked: cast rhythm and duration are largely fixed; layer persistence and dead-static blocks now dominate. Flags: **[real opener gap]** vs **[daily-only artifact — resolved]**.

| # | Gap | Timecode range (REF / o9) | Reference does | opener&009 does | Fix type |
|---|---|---|---|---|---|
| 1 | No anchor-layer persistence [real] | REF 11–18.5, 27–32, 33–35 / o9 ~11–32 | Family band persists under 3 feature cards; wireframe figures persist under 3 UI morphs; family persists across location cuts | Family photo flashes ~2s then vanishes; feature captions and "every conversation" block sit on empty dark gradients | primitive (`persistentLayerSwap`, layer manager) |
| 2 | Dead-static section interiors [real] | REF 27–41 / o9 ~25–41 | UI cards morph, figures pulse, plate scan-animates — something always moves | "Every conversation" ~7s and Survival copper plate ~8s with only text typing over frozen bg | spec (idle-motion requirement per beat) + asset |
| 3 | Double-exposed / colliding text [real, bug] | o9 ~4.2, ~18.5, ~36, ~55 | One text event at a time; type→hold→exit | Two text layers render simultaneously, garbled overlap | spec (text scheduler bug — enforce no overlapping text events) |
| 4 | Missing tile-map world register [real] | REF 24–27.2, 60.9–66.4 / o9 ~24–27, 60–66 | Overhead game map + portrait stack; day→night map cut under held text | Dark gradient + lens flare + placeholder icons; live block reuses one village still | asset + spec |
| 5 | Pressure gauge scale + morph [real] | REF 52.5–55.9 / o9 ~52–58 | Character radial-blurs into full-width gauge; needle sweeps LOW→CRITICAL | Luba shrinks to thumbnail; two small dials on black; big gauge appears only with URL plate | primitive (`radialObjectMatch`, `gaugeStateAnim`) + layout |
| 6 | End card sequence missing [real] | REF 71.7–76.6 / o9 71–79.8 | Foggy porch scenic → question over wireframe figure → 0.7s overlapping URL takeover → 0.58s hold, hard end | Dark gradient throughout; no scenic, no figure, no overlap; URL fades then ~4.5s dead black tail | asset + primitive (`questionToUrlTakeover`) + spec (trim tail) |
| 7 | Placeholder/broken portrait assets [real] | o9 ~24–27, 66–71 | Real portraits in map cards and dashboard strips | Gray icon boxes render where portraits should load | asset (path resolution/registration) |
| 8 | Hook missing ring + poster flash [real] | REF 0–4.2 / o9 0–11 | 50ms poster flash → black → WHAT IF; rotating ring accretes HUD lines | Chat-bubble frames + card object + scan lines (decent density) but no ring, no poster flash, text small and off the center band | asset + layout |
| 9 | Luminance curve shape [real, partial] | whole runtime | Bright village + light-gray cast = clear luma peaks; dark bookends | Cast block is bright ✓ but village register dimmer than ref and Survival plate is a flat brown mid | spec (per-section luminance targets) |
| 10 | One-scene-per-VO [daily-only — largely resolved] | — | 2–4 micro-beats per VO segment | Text-level cadence now matches; remaining deficit is covered by gaps 1–2 | — |

Dropped from v1 (resolved in opener&009): paragraph text (#6), absent cast rhythm (#1), runtime +50% (duration now in envelope aside from the dead tail), flat-dark whole-video luma (#5, now partial).
