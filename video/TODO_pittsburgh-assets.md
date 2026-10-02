# Pittsburgh places — still to shoot

**2026-10-01.** Finished plates are on disk and are not listed again.

- Interiors (2026-09-29 workplaces, 2026-09-30 homes): `double-video/video/assets/pittsburgh/interior/`. Five shops, Penn library + gym, three shared looks (`apt_small_int.jpg`, `apt_mid_int.jpg`, `apt_large_int.jpg`), 19 own home plates, bedrooms for One Gateway and Two PPG. First & Market uses the small look.
- Exteriors already in `double-video/video/assets/pittsburgh/exterior/ref/`: Point wide + lawn door; five shops (street + door; PPG also mass); home streets for Gateway Tower, Roosevelt, Midtown, River Vue, Tower Two-Sixty, 11 Stanwix, Six PPG, USW, PNC Center, One PNC; Encore mass file only    (`encore_on_7th_exterior_ref_full.jpg`); Market Square, Mellon Square, Gateway Center Park, Arts Landing, Firstside Park.

Lookup behavior is in [`TODO_video.md`](TODO_video.md) (LeaderTalks → Code). The room lookup and the PPG Cafe gather plate are on `double-video` `mvp-ready` locally (not pushed).

**Scale lock.** Phaser stays 4:1 so Downtown fits: people read large, and one step covers 4 Pittsburgh metres. Video does not inherit that. Exteriors are real façades, parks, and bridges at photographic scale. Do not shrink a real tower plan by 4. Do not use a Phaser screenshot as an exterior plate.

Do **not** use Tower at PNC Plaza (**300 Fifth Avenue**) for PNC Center or One PNC Plaza. Do **not** say **East Park** on VO.

Portrait or extra headroom for a **9:16** crop. No people in the hero, natural color, no heavy filters. One hero per row; optional second file only where the brief says so.

**Eye level** = camera about as high as a person standing on the sidewalk. **Horizon level** = camera not tilted up or down, so vertical lines stay vertical. A street plate wants both, aimed at that building’s street door. Eye height with the phone tipped up is not horizon level.

---

## Photo prompts

### Street (default)

Convert the attached photo into a photoreal Street plate of this same building. Keep the exact façade, windows, materials, and street door. Camera at sidewalk eye height, horizon level so verticals stay vertical, aimed at this building’s street door. Door zone visible. On a tower the crown may be cut; the street wall still names the building. Extra headroom for a 9:16 crop. Empty of people and hero cars. Natural daylight, natural color, no heavy filters. Fix tilt, remove watermarks, blown glass, and messy crop. Do not invent a different building.

Save as `{slug}_exterior_ref.jpg`

### Mass (PPG crown, Point, bridges, skyline)

Convert the attached photo into a photoreal Mass plate of this same place. Keep the exact landmark: this crown, this glass, this skyline, park, or bridge. Crown and base in one frame so a cold viewer can name it. Camera may step back; a person would read small. Extra headroom for a 9:16 crop. Empty of people. Natural daylight, natural color, no heavy filters. Fix tilt, watermarks, blown glass, and messy crop. Do not invent a different building.

Save as `{slug}_exterior_ref_full.jpg` only when a street file already exists (One PPG Place). Point, the three bridges, and the skyline are the only file for that place, so they stay `{slug}_exterior_ref.jpg`.

### Door (five shops + Point lawn)

Door Mode: The attached photo is identity only — keep this exact door (or this lawn stand-spot) and these ground-floor materials. Rephotograph from a new camera. Do not keep the source framing or distance.

Camera *important!*: 5 metres from the door (or the lawn stand-spot), straight on. Zoom in or out so the shot is taken from that distance (door height is about 2 metres).
Phone main lens at 1× (about 26 mm equivalent), not ultra-wide. Lens at 1.6 m, horizon level, do not tilt up. Vertical 9:16.

Frame: the threshold sits in the lower third. The top of the door sits a little above the centre. The frame top is about 5 m above the ground, so only the ground floor and a sliver of what is above it. A 1.75 m person in the doorway would fill about a quarter of the picture height. Fail if the whole façade still reads, if more than the ground floor is in frame, or if a long plaza or park is the subject.

Empty of people: the Double is added later. Natural daylight, natural color, no heavy filters. Fix tilt, watermarks, blown glass, and messy crop. Do not invent a different building or a different door.

Save as `{slug}_exterior_ref_door.jpg`

### Street - Outside

Convert the attached photo into a photoreal Street plate of this same place.
Keep the exact façades, windows, materials, street plan & objects.
Camera at sidewalk eye height, horizon level so verticals stay vertical.
Tops of the buildings may be cut.
Extra headroom for a 9:16 crop. Empty of people and hero cars.
Natural daylight, natural color, no heavy filters.
Fix tilt, remove watermarks, blown glass, and messy crop. Do not invent a different building.

Save as `{slug}_exterior_ref.jpg`

---

## Still to shoot

ZIP **15222** unless noted. These rows do not block the closer interiors. They are the remaining façades, landmarks, and outdoor plates.

### Home street faces

| Pittsburgh address | Maze Place | Save as | How to shoot |
| --- | --- | --- | --- |
| 100 7th Street, Pittsburgh, PA 15222 | Encore on 7th | `double-video/video/assets/pittsburgh/exterior/ref/encore_on_7th_exterior_ref.jpg` | **Street.** Disk only has `encore_on_7th_exterior_ref_full.jpg`. Rename that file if it is already the street plate. |
| 164 First Avenue, Pittsburgh, PA 15222 | First & Market Apartments | `double-video/video/assets/pittsburgh/exterior/ref/first_and_market_exterior_ref.jpg` | Residential front, full height if the street allows. No file on disk. |
| 225 Fifth Avenue, Pittsburgh, PA 15222 | Three PNC Plaza | `double-video/video/assets/pittsburgh/exterior/ref/three_pnc_plaza_exterior_ref.jpg` | Street face. |
| 444 Liberty Avenue, Pittsburgh, PA 15222 | Four Gateway Center | `double-video/video/assets/pittsburgh/exterior/ref/four_gateway_exterior_ref.jpg` | Gateway tower face. |
| 210 Sixth Avenue, Pittsburgh, PA 15222 | K&L Gates Center | `double-video/video/assets/pittsburgh/exterior/ref/kl_gates_exterior_ref.jpg` | Street face. |
| 401 Liberty Avenue, Pittsburgh, PA 15222 | Three Gateway Center | `double-video/video/assets/pittsburgh/exterior/ref/three_gateway_exterior_ref.jpg` | Street face. |
| 603 Stanwix Street, Pittsburgh, PA 15222 | Two Gateway Center | `double-video/video/assets/pittsburgh/exterior/ref/two_gateway_exterior_ref.jpg` | Street face. |
| 620 Liberty Avenue, Pittsburgh, PA 15222 | Two PNC Plaza | `double-video/video/assets/pittsburgh/exterior/ref/two_pnc_plaza_exterior_ref.jpg` | Street face. |
| 2 PPG Place, Pittsburgh, PA 15222 | Two PPG Place | `double-video/video/assets/pittsburgh/exterior/ref/two_ppg_place_exterior_ref.jpg` | This PPG tower only. |
| 420 Fort Duquesne Boulevard, Pittsburgh, PA 15222 | One Gateway Center | `double-video/video/assets/pittsburgh/exterior/ref/one_gateway_exterior_ref.jpg` | Street face. |

### Landmarks (exterior only, no interiors)

| Pittsburgh address | Maze Place | Save as | How to shoot |
| --- | --- | --- | --- |
| 600 Commonwealth Place, Pittsburgh, PA 15222 | Wyndham Grand Pittsburgh Downtown | `double-video/video/assets/pittsburgh/exterior/ref/wyndham_grand_exterior_ref.jpg` | Hotel face for skyline / flyover. Do not invent an interior. |
| 600 Penn Avenue, Pittsburgh, PA 15222 | Heinz Hall for the Performing Arts | `double-video/video/assets/pittsburgh/exterior/ref/heinz_hall_exterior_ref.jpg` | Hall front. Exterior only. |
| 237 7th Street, Pittsburgh, PA 15222 | Benedum Center | `double-video/video/assets/pittsburgh/exterior/ref/benedum_exterior_ref.jpg` | Theater front. Exterior only. |
| PPG Place plaza, Pittsburgh, PA 15222 | PPG Place Wintergarden | `double-video/video/assets/pittsburgh/exterior/ref/ppg_wintergarden_exterior_ref.jpg` | Plaza / wintergarden glass, not a room interior. |
| 3 PPG Place, Pittsburgh, PA 15222 | Three PPG Place | `double-video/video/assets/pittsburgh/exterior/ref/three_ppg_place_exterior_ref.jpg` | Cluster tower. Exterior only. |
| 4 PPG Place, Pittsburgh, PA 15222 | Four PPG Place | `double-video/video/assets/pittsburgh/exterior/ref/four_ppg_place_exterior_ref.jpg` | Cluster tower. Exterior only. |
| 5 PPG Place, Pittsburgh, PA 15222 | Five PPG Place | `double-video/video/assets/pittsburgh/exterior/ref/five_ppg_place_exterior_ref.jpg` | Cluster tower. Exterior only. |
| 202 Boulevard of the Allies, Pittsburgh, PA 15222 | St. Mary of Mercy Church | `double-video/video/assets/pittsburgh/exterior/ref/st_mary_mercy_exterior_ref.jpg` | Church face. Exterior only. |
| 139 7th Street, Pittsburgh, PA 15222 | Star Loft | `double-video/video/assets/pittsburgh/exterior/ref/star_loft_exterior_ref.jpg` | One clear loft façade. 709 Penn Avenue is the alternate face. Exterior only. |
| 601 Wood Street, Pittsburgh, PA 15222 | Wood Street Studios | `double-video/video/assets/pittsburgh/exterior/ref/wood_street_studios_exterior_ref.jpg` | Gallery front. Exterior only. |
| 201 Wood Street, Pittsburgh, PA 15222 | Academic Hall Dorm | `double-video/video/assets/pittsburgh/exterior/ref/academic_hall_exterior_ref.jpg` | Point Park hall. Exterior only. |
| 305 Wood Street, Pittsburgh, PA 15222 | YWCA Residence | `double-video/video/assets/pittsburgh/exterior/ref/ywca_305_wood_exterior_ref.jpg` | The building, not the org’s new address. Exterior only. |
| Stanwix Street at First Avenue, Pittsburgh, PA 15222 | CityHigh | `double-video/video/assets/pittsburgh/exterior/ref/cityhigh_exterior_ref.jpg` | Only if you can match the downtown campus façade. Skip if unsure. |

### Outdoors

| Pittsburgh address | Maze Place | Save as | How to shoot |
| --- | --- | --- | --- |
| Point State Park, west tip, Pittsburgh, PA 15222 | Point State Park Fountain | `double-video/video/assets/pittsburgh/exterior/ref/point_fountain_exterior_ref.jpg` | The fountain itself, not only the lawn. |
| 601 Commonwealth Place, Pittsburgh, PA 15222 | Fort Pitt Museum | `double-video/video/assets/pittsburgh/exterior/ref/fort_pitt_museum_exterior_ref.jpg` | Grounds and block house. Locked pad — no interior. |
| Fort Pitt Boulevard, Pittsburgh, PA 15222 | Mon Wharf Landing | `double-video/video/assets/pittsburgh/exterior/ref/mon_wharf_exterior_ref.jpg` | River landing. |
| 6th Street Bridge, Pittsburgh, PA 15222 | Roberto Clemente Bridge | `double-video/video/assets/pittsburgh/exterior/ref/bridge_clemente_exterior_ref.jpg` | **Mass.** Bridge over the Allegheny, approach in frame. |
| 7th Street Bridge, Pittsburgh, PA 15222 | Andy Warhol Bridge | `double-video/video/assets/pittsburgh/exterior/ref/bridge_warhol_exterior_ref.jpg` | **Mass.** Same. |
| 9th Street Bridge, Pittsburgh, PA 15222 | Rachel Carson Bridge | `double-video/video/assets/pittsburgh/exterior/ref/bridge_carson_exterior_ref.jpg` | **Mass.** Same. |
| Penn Avenue east of Wood Street, Pittsburgh, PA 15222 | East Park | `double-video/video/assets/pittsburgh/exterior/ref/east_park_cultural_exterior_ref.jpg` | One generic park lawn. Never label this East Park on VO. |
| Downtown overlook, Pittsburgh, PA 15222 | — | `double-video/video/assets/pittsburgh/exterior/ref/downtown_skyline_exterior_ref.jpg` | **Mass.** Same plate as the flyover still below. Do not make a second skyline. |

After polish, street refs copy to `double-video/video/assets/pittsburgh/exterior/{slug}_exterior_wide.png`. Mass refs copy to `{slug}_exterior_full.png`. Door refs copy to `{slug}_exterior_door.png`. Drop `_ref` and use `.png`. Camera originals stay in `ref/`.

---

## Downtown flyover stills - **DONE 2026-10-02**

**2026-10-02.** These are the world shots for a Downtown closer. A frame from a Pittsburgh flyover video is identity only. Polish it in Imagine first. Do not put the raw screenshot in the trailer.

Save under `double-video/video/assets/pittsburgh/flyover/`. The bake still plays the village pack until the recipe points here. Empty of people, crowds, faces, hero cars, and readable signs. Natural color. No watermark.

Rows 1–4 are the day-1 closer. Rows 5–9 finish the pack. This night will not show 5–9.

| # | Save as | Shape | What the still shows |
| --- | --- | --- | --- |
| 1 | `downtown_skyline_exterior_ref.jpg` | Landscape, wider than 16:9 | Day. The Point and the downtown towers in one frame, from the river or from Mount Washington. PPG’s glass castle or the three yellow bridges must be readable. This is also the outdoors skyline row above. |
| 2 | `cinematic_downtown_overhead_day.jpg` | Landscape | Day. The whole downtown triangle from high up. Rivers on two sides. Towers read as a group, not one building. |
| 3 | `cinematic_downtown_plaza_dusk.jpg` | Vertical 9:16 | Dusk. PPG Place plaza or Market Square. The open ground and the glass around it. A person would read small. |
| 4 | `cinematic_downtown_towers_day.jpg` | Vertical 9:16 | Day. One downtown street of towers, Gateway or Liberty. Street wall and a bit of sidewalk. Crowns may be cut. |
| 5 | `cinematic_downtown_overhead_dusk.jpg` | Landscape | Same view as 2, at dusk. Do not change the buildings. |
| 6 | `cinematic_downtown_overhead_night.jpg` | Landscape | Same view as 2, at night. Window light on. Still only. Do not make a video. |
| 7 | `cinematic_downtown_plaza_night.jpg` | Vertical 9:16 | Same plaza as 3, at night. Still only. Do not make a video. |
| 8 | `cinematic_downtown_ppg_street_day.jpg` | Vertical 9:16 | Day. The PPG Cafe street front and the sidewalk in front of it. Not the cafe interior. |
| 9 | `cinematic_downtown_ppg_street_dusk.jpg` | Vertical 9:16 | Same street as 8, at dusk. |

## Still to short video

Attach the polished still. Paste the prompt. Fill `{move}` from the table. Imagine video length is 1–15 seconds. Use the seconds in the table.

```
The attached still is the plate. Animate this same Pittsburgh place. Keep these buildings, this glass, these bridges, and this skyline. Do not invent a different city. Do not add people, crowds, faces, cars, signs, logos, or text. Do not change the time of day. Natural color. One slow camera move only: {move}. No whip pan. No punch zoom. No orbit that loses the landmark.
```

| Still | {move} | Seconds | Save the clip as |
| --- | --- | --- | --- |
| `downtown_skyline_exterior_ref.jpg` | Slow push from the river toward the downtown towers. The Point stays in frame. | 8 | `signature_flyover.mp4` |
| `cinematic_downtown_overhead_day.jpg` | Slow drift across the triangle. The rivers and the tower group stay readable. | 8 | `cinematic_downtown_overhead_day.mp4` |
| `cinematic_downtown_overhead_dusk.jpg` | Same slow drift as the day overhead. | 8 | `cinematic_downtown_overhead_dusk.mp4` |
| `cinematic_downtown_plaza_dusk.jpg` | Slow push in across the plaza. The vertical frame stays full. | 6 | `cinematic_downtown_plaza_dusk.mp4` |
| `cinematic_downtown_ppg_street_day.jpg` | Slow push along the sidewalk toward the cafe front. | 6 | `cinematic_downtown_ppg_street_day.mp4` |
| `cinematic_downtown_ppg_street_dusk.jpg` | Same push as the day street. | 6 | `cinematic_downtown_ppg_street_dusk.mp4` |
| `cinematic_downtown_towers_day.jpg` | Slow glide along the tower street. The street wall stays in frame. | 6 | `cinematic_downtown_towers_day.mp4` |
