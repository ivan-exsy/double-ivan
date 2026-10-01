# Pittsburgh places — video shoot

**2026-09-29** · Sim names stay the occupancy names. Street addresses are the real pads. ZIP **15222** unless noted.

## Shoot these first

This is the Downtown closer set. Point and all five workplaces are on disk (2026-09-29). Home interiors done (2026-09-30): three shared looks, 19 own plates, and bedrooms for One Gateway and Two PPG. First & Market stays on the small look. Home street faces, landmarks, bridges, and skyline stay in the exteriors list below.

| Order | Maze Place | Plate | Save as | Status |
| --- | --- | --- | --- | --- |
| *done* | Point State Park | Mass | `double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref.jpg` | Main outdoor plate. Wide triangle. |
| *done* | Point State Park | Door | `double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref_door.jpg` | Lawn stand-spot. |
| *done* | PPG Cafe | Interior | `double-video/video/assets/pittsburgh/interior/ppg_cafe_int.jpg` | Dining floor, bar, and back-wall kitchen in one frame. No separate counter plate needed. |
| *done* | Fifth Avenue Market | Interior | `double-video/video/assets/pittsburgh/interior/fifth_avenue_market_int.jpg` | Aisle. |
| *done* | EQT Supply Store | Interior | `double-video/video/assets/pittsburgh/interior/eqt_supply_int.jpg` | Supply counter and crates. |
| *done* | O'Reilly Pub | Interior | `double-video/video/assets/pittsburgh/interior/oreilly_pub_int.jpg` | Bar. |
| *done* | Penn College | Interior | `double-video/video/assets/pittsburgh/interior/penn_college_library_int.jpg` + `penn_college_reception-gym_int.jpg` | **Changed:** library, and gym with rest area. No classroom plate. |
| *done* | Six PPG Place | Interior | `double-video/video/assets/pittsburgh/interior/apt_mid_int.jpg` + `six_ppg_place_int.jpg` | Mid one-room look (2026-09-30). Covers 16 of 20 homes. Same file saved as Six PPG's exact plate. |
| *done* | Midtown Tower | Interior | `double-video/video/assets/pittsburgh/interior/apt_small_int.jpg` + `midtown_tower_int.jpg` | Small studio look (2026-09-30). Midtown + First & Market. Example pad is Midtown (First & Market has no bath). Same file saved as Midtown's exact plate. |
| *done* | One Gateway Center | Interior | `double-video/video/assets/pittsburgh/interior/apt_large_int.jpg` + `one_gateway_int.jpg` | Large two-bedroom look, living room (2026-09-30). One Gateway + Two PPG Place. Same file saved as One Gateway's exact plate. |
| *done* | One Gateway Center | Bedroom | `double-video/video/assets/pittsburgh/interior/apt_large_bedroom_int.jpg` + `one_gateway_bedroom_int.jpg` | Main bedroom (2026-09-30). The living plate has no bed, so sleep beats in the two large homes use this. |

**Exteriors** = real photos (façades, landmarks, outdoor plates). **Interiors** = empty ground-floor sim rooms (Imagine plates), not real tower floor plans. The closer needs this set: Point, five workplaces, and three apartment looks. The rest of this file is the full shoot.

**Before the first Downtown bake:** `habitat_lock` still loads Hobbs for any “cafe,” and has no library or gym. Penn College Doubles need their job mapped to the library or the gym plate, or the bake must fail. Code section in [`TODO_video.md`](TODO_video.md) (LeaderTalks → Code).

**Scale lock.** Phaser stays 4:1 so Downtown fits: people read large, and one step covers 4 Pittsburgh metres. Video does not inherit that. Exteriors are real façades, parks, and bridges at photographic scale. Interiors are the hollowed sim ground floor, dressed as a modern empty room. Layout comes from the Phaser crop. Do not shrink a real tower plan by 4. Do not use a Phaser screenshot as an exterior plate.

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

## Exteriors

Order: five shops, 20 homes, landmark façades, outdoor plates. **Maze Place** is the sim name in `maze_registry` (`simName` where the pad is a home or shop).

Most rows are one street face (`{slug}_exterior_ref.jpg`). **Mass** and **Door** are extra rows under that street row. Save as adds `_full` or `_door` before `.jpg`.

- **Mass** (`_full`): crown and base in one frame. A person may be small. Building: One PPG Place only. Point wide, the three bridges, and the skyline are already that shot — marked **Mass**, not a second file.
- **Door** (`_door`): camera 5 m from the door or lawn stand-spot, 1× lens, level. A person there fills about a quarter of the frame. Ground floor only. Empty; the Double is added later. Five shops, plus a closer on the Point lawn. Not a cleaned-up street plate.

Homes and other landmarks stay one street row.

| Pittsburgh address | Maze Place | Save as | How to shoot |
| --- | --- | --- | --- |
*DONE*
| One PPG Place, Pittsburgh, PA 15222 | PPG Cafe | double-video/video/assets/pittsburgh/exterior/ref/ppg_cafe_exterior_ref.jpg | **Street.** Horizon level. Street door in frame. Gothic base names the cafe. Crown may be cut. Avoid blown-out glass. |
| One PPG Place, Pittsburgh, PA 15222 | PPG Cafe | double-video/video/assets/pittsburgh/exterior/ref/ppg_cafe_exterior_ref_full.jpg | **Mass.** Crown and base in one frame. A person may be small. Avoid blown-out glass. |
| One PPG Place, Pittsburgh, PA 15222 | PPG Cafe | double-video/video/assets/pittsburgh/exterior/ref/ppg_cafe_exterior_ref_door.jpg | **Door.** 5 m from the center glass doors. The foot of the center arch frames the door; the arch peak is cut. A person in the doorway fills about a quarter of the frame. |
| 120 Fifth Avenue, Pittsburgh, PA 15222 | Fifth Avenue Market | double-video/video/assets/pittsburgh/exterior/ref/fifth_avenue_market_exterior_ref.jpg | **Street.** Straight-on or slight 3/4 of the tower face and street door. Horizon level. |
| 120 Fifth Avenue, Pittsburgh, PA 15222 | Fifth Avenue Market | double-video/video/assets/pittsburgh/exterior/ref/fifth_avenue_market_exterior_ref_door.jpg | **Door.** Closer on the street door. Horizon level. A person in the entrance reads at life size. |
| 625 Liberty Avenue, Pittsburgh, PA 15222 | EQT Supply Store | double-video/video/assets/pittsburgh/exterior/ref/eqt_supply_exterior_ref.jpg | **Street.** Full façade, door zone in frame, horizon level. |
| 625 Liberty Avenue, Pittsburgh, PA 15222 | EQT Supply Store | double-video/video/assets/pittsburgh/exterior/ref/eqt_supply_exterior_ref_door.jpg | **Door.** Closer on the door zone. Horizon level. A person in the entrance reads at life size. |
| 621 Penn Avenue, Pittsburgh, PA 15222 | O'Reilly Pub | double-video/video/assets/pittsburgh/exterior/ref/oreilly_pub_exterior_ref.jpg | **Street.** Theater front. Frame the entrance; keep signage from filling the shot. |
| 621 Penn Avenue, Pittsburgh, PA 15222 | O'Reilly Pub | double-video/video/assets/pittsburgh/exterior/ref/oreilly_pub_exterior_ref_door.jpg | **Door.** Closer on the theater entrance. Signage does not fill the shot. A person in the entrance reads at life size. |
| 501 Penn Avenue, Pittsburgh, PA 15222 | Penn College | double-video/video/assets/pittsburgh/exterior/ref/penn_college_exterior_ref.jpg | **Street.** One façade only. Same pad is later Penn Avenue Library — do not shoot a second building. |
| 501 Penn Avenue, Pittsburgh, PA 15222 | Penn College | double-video/video/assets/pittsburgh/exterior/ref/penn_college_exterior_ref_door.jpg | **Door.** Closer on the same college entrance. A person in the entrance reads at life size. Do not shoot Penn Avenue Library as a second building. |
| 320 Fort Duquesne Boulevard, Pittsburgh, PA 15222 | Gateway Tower | double-video/video/assets/pittsburgh/exterior/ref/gateway_tower_exterior_ref.jpg | Condo tower face from the street. |
| 609 Penn Avenue, Pittsburgh, PA 15222 | Roosevelt Building | double-video/video/assets/pittsburgh/exterior/ref/roosevelt_building_exterior_ref.jpg | Street face of the Roosevelt. Also 607 Penn. |
| 643 Liberty Avenue, Pittsburgh, PA 15222 | Midtown Tower | double-video/video/assets/pittsburgh/exterior/ref/`midtown_tower_exterior_ref.jpg` | Full façade, door zone visible. |
| 100 7th Street, Pittsburgh, PA 15222 | Encore on 7th | double-video/video/assets/pittsburgh/exterior/ref/encore_on_7th_exterior_ref_full.jpg | **Mass.** On disk. Street plate is still open in the TODO below. Rename this file only if it is already the street face. |
| 300 Liberty Avenue, Pittsburgh, PA 15222 | River Vue Apartments | double-video/video/assets/pittsburgh/exterior/ref/river_vue_exterior_ref.jpg | Apartment tower face. |
| 260 Forbes Avenue, Pittsburgh, PA 15222 | Tower Two-Sixty | double-video/video/assets/pittsburgh/exterior/ref/tower_two_sixty_exterior_ref.jpg | Tower / Market Square gardens face. |
| 11 Stanwix Street, Pittsburgh, PA 15222 | 11 Stanwix Street | double-video/video/assets/pittsburgh/exterior/ref/11_stanwix_exterior_ref.jpg | Former Westinghouse tower, street face. |
| 6 PPG Place, Pittsburgh, PA 15222 | Six PPG Place | double-video/video/assets/pittsburgh/exterior/ref/six_ppg_place_exterior_ref.jpg | This PPG tower only, not One PPG. |
| 60 Boulevard of the Allies, Pittsburgh, PA 15222 | USW \| United Steelworkers | double-video/video/assets/pittsburgh/exterior/ref/usw_exterior_ref.jpg | United Steelworkers / Five Gateway face. |
| 500 First Avenue, Pittsburgh, PA 15219 | PNC Center | double-video/video/assets/pittsburgh/exterior/ref/pnc_center_exterior_ref.jpg | Firstside building. Not 300 Fifth. |
| 249 Fifth Avenue, Pittsburgh, PA 15222 | One PNC Plaza | double-video/video/assets/pittsburgh/exterior/ref/one_pnc_plaza_exterior_ref.jpg | This plaza tower. Not 300 Fifth. |


### *TODO*

Home street faces below are furnished and still missing. They do not block the closer.

| 100 7th Street, Pittsburgh, PA 15222 | Encore on 7th | double-video/video/assets/pittsburgh/exterior/ref/encore_on_7th_exterior_ref.jpg | **Street.** Disk only has `encore_on_7th_exterior_ref_full.jpg`. Rename that file if it is already the street plate. |
| 164 First Avenue, Pittsburgh, PA 15222 | First & Market Apartments | double-video/video/assets/pittsburgh/exterior/ref/first_and_market_exterior_ref.jpg | Residential front, full height if the street allows. No file on disk. |
| 225 Fifth Avenue, Pittsburgh, PA 15222 | Three PNC Plaza | double-video/video/assets/pittsburgh/exterior/ref/three_pnc_plaza_exterior_ref.jpg | Street face. |
| 444 Liberty Avenue, Pittsburgh, PA 15222 | Four Gateway Center | double-video/video/assets/pittsburgh/exterior/ref/four_gateway_exterior_ref.jpg | Gateway tower face. |
| 210 Sixth Avenue, Pittsburgh, PA 15222 | K&L Gates Center | double-video/video/assets/pittsburgh/exterior/ref/kl_gates_exterior_ref.jpg | Street face. |
| 401 Liberty Avenue, Pittsburgh, PA 15222 | Three Gateway Center | double-video/video/assets/pittsburgh/exterior/ref/three_gateway_exterior_ref.jpg | Street face. |
| 603 Stanwix Street, Pittsburgh, PA 15222 | Two Gateway Center | double-video/video/assets/pittsburgh/exterior/ref/two_gateway_exterior_ref.jpg | Street face. |
| 620 Liberty Avenue, Pittsburgh, PA 15222 | Two PNC Plaza | double-video/video/assets/pittsburgh/exterior/ref/two_pnc_plaza_exterior_ref.jpg | Street face. |
| 2 PPG Place, Pittsburgh, PA 15222 | Two PPG Place | double-video/video/assets/pittsburgh/exterior/ref/two_ppg_place_exterior_ref.jpg | This PPG tower only. |
| 420 Fort Duquesne Boulevard, Pittsburgh, PA 15222 | One Gateway Center | double-video/video/assets/pittsburgh/exterior/ref/one_gateway_exterior_ref.jpg | Street face. |
| 600 Commonwealth Place, Pittsburgh, PA 15222 | Wyndham Grand Pittsburgh Downtown | double-video/video/assets/pittsburgh/exterior/ref/wyndham_grand_exterior_ref.jpg | Hotel face for skyline / flyover. Do not invent an interior. |
| 600 Penn Avenue, Pittsburgh, PA 15222 | Heinz Hall for the Performing Arts | double-video/video/assets/pittsburgh/exterior/ref/heinz_hall_exterior_ref.jpg | Hall front. Exterior only. |
| 237 7th Street, Pittsburgh, PA 15222 | Benedum Center | double-video/video/assets/pittsburgh/exterior/ref/benedum_exterior_ref.jpg | Theater front. Exterior only. |
| PPG Place plaza, Pittsburgh, PA 15222 | PPG Place Wintergarden | double-video/video/assets/pittsburgh/exterior/ref/ppg_wintergarden_exterior_ref.jpg | Plaza / wintergarden glass, not a room interior. |
| 3 PPG Place, Pittsburgh, PA 15222 | Three PPG Place | double-video/video/assets/pittsburgh/exterior/ref/three_ppg_place_exterior_ref.jpg | Cluster tower. Exterior only. |
| 4 PPG Place, Pittsburgh, PA 15222 | Four PPG Place | double-video/video/assets/pittsburgh/exterior/ref/four_ppg_place_exterior_ref.jpg | Cluster tower. Exterior only. |
| 5 PPG Place, Pittsburgh, PA 15222 | Five PPG Place | double-video/video/assets/pittsburgh/exterior/ref/five_ppg_place_exterior_ref.jpg | Cluster tower. Exterior only. |
| 202 Boulevard of the Allies, Pittsburgh, PA 15222 | St. Mary of Mercy Church | double-video/video/assets/pittsburgh/exterior/ref/st_mary_mercy_exterior_ref.jpg | Church face. Exterior only. |
| 139 7th Street, Pittsburgh, PA 15222 | Star Loft | double-video/video/assets/pittsburgh/exterior/ref/star_loft_exterior_ref.jpg | One clear loft façade. 709 Penn Avenue is the alternate face. Exterior only. |
| 601 Wood Street, Pittsburgh, PA 15222 | Wood Street Studios | double-video/video/assets/pittsburgh/exterior/ref/wood_street_studios_exterior_ref.jpg | Gallery front. Exterior only. |
| 201 Wood Street, Pittsburgh, PA 15222 | Academic Hall Dorm | double-video/video/assets/pittsburgh/exterior/ref/academic_hall_exterior_ref.jpg | Point Park hall. Exterior only. |
| 305 Wood Street, Pittsburgh, PA 15222 | YWCA Residence | double-video/video/assets/pittsburgh/exterior/ref/ywca_305_wood_exterior_ref.jpg | The building, not the org’s new address. Exterior only. |
| Stanwix Street at First Avenue, Pittsburgh, PA 15222 | CityHigh | double-video/video/assets/pittsburgh/exterior/ref/cityhigh_exterior_ref.jpg | Only if you can match the downtown campus façade. Skip if unsure. |
| 601 Commonwealth Place, Pittsburgh, PA 15222 | Point State Park | double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref.jpg | **Mass.** Wide triangle: lawn, rivers, confluence. Main outdoor plate. A person may be small. |
| 601 Commonwealth Place, Pittsburgh, PA 15222 | Point State Park | double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref_door.jpg | **Door.** Closer on the lawn where a person can stand. A person reads at life size. Not the wide triangle. |
| Point State Park, west tip, Pittsburgh, PA 15222 | Point State Park Fountain | double-video/video/assets/pittsburgh/exterior/ref/point_fountain_exterior_ref.jpg | The fountain itself, not only the lawn. |
| 601 Commonwealth Place, Pittsburgh, PA 15222 | Fort Pitt Museum | double-video/video/assets/pittsburgh/exterior/ref/fort_pitt_museum_exterior_ref.jpg | Grounds and block house. Locked pad — no interior. |

### **STREET:**

*DONE*
| Market Square, Pittsburgh, PA 15222 | Market Square | double-video/video/assets/pittsburgh/exterior/ref/market_square_exterior_ref.jpg | Pedestrian plaza, eye level, people out of the hero if you can wait. |
| Smithfield Street and Sixth Avenue, Pittsburgh, PA 15222 | Mellon Square | double-video/video/assets/pittsburgh/exterior/ref/mellon_square_exterior_ref.jpg | Park plaza, wide. |
| Stanwix Street at Liberty Avenue, Pittsburgh, PA 15222 | Gateway Center Park | double-video/video/assets/pittsburgh/exterior/ref/gateway_center_park_exterior_ref.jpg | Towers-in-a-park lawn. |
| Penn Avenue at 8th Street, Pittsburgh, PA 15222 | Arts Landing | double-video/video/assets/pittsburgh/exterior/ref/arts_landing_exterior_ref.jpg | River-edge plaza. |
| First Avenue at Boulevard of the Allies, Pittsburgh, PA 15222 | Firstside Park | double-video/video/assets/pittsburgh/exterior/ref/firstside_park_exterior_ref.jpg | South-edge park. |

#### *TODO*
| Fort Pitt Boulevard, Pittsburgh, PA 15222 | Mon Wharf Landing | double-video/video/assets/pittsburgh/exterior/ref/mon_wharf_exterior_ref.jpg | River landing. |
| 6th Street Bridge, Pittsburgh, PA 15222 | Roberto Clemente Bridge | double-video/video/assets/pittsburgh/exterior/ref/bridge_clemente_exterior_ref.jpg | **Mass.** Bridge over the Allegheny, approach in frame. |
| 7th Street Bridge, Pittsburgh, PA 15222 | Andy Warhol Bridge | double-video/video/assets/pittsburgh/exterior/ref/bridge_warhol_exterior_ref.jpg | **Mass.** Same. |
| 9th Street Bridge, Pittsburgh, PA 15222 | Rachel Carson Bridge | double-video/video/assets/pittsburgh/exterior/ref/bridge_carson_exterior_ref.jpg | **Mass.** Same. |
| Penn Avenue east of Wood Street, Pittsburgh, PA 15222 | East Park | double-video/video/assets/pittsburgh/exterior/ref/east_park_cultural_exterior_ref.jpg | One generic park lawn. Never label this East Park on VO. |
| Downtown overlook, Pittsburgh, PA 15222 | — | double-video/video/assets/pittsburgh/exterior/ref/downtown_skyline_exterior_ref.jpg | **Mass.** One wide skyline for later flyover. Slightly wider than you need. No single maze sector. |

After polish, street refs copy to `double-video/video/assets/pittsburgh/exterior/{slug}_exterior_wide.png`. Mass refs copy to `{slug}_exterior_full.png`. Door refs copy to `{slug}_exterior_door.png`. Drop `_ref` and use `.png`. Camera originals stay in `ref/`.

---

## Interiors

Empty eye-level plates of the **sim ground floor**. Do not photograph real office or apartment interiors. Look comes from a real photo of that place. Layout comes from the unlabeled Phaser top-down of that room (no `*_labeled.png`). Do not attach the village style frame or Hobbs plates. No people. Prompt is in [Interior prompt](#interior-prompt) below.

### Interior prompt

One single photoreal 9:16 interior photograph of *Fifth Avenue Market*: **Empty market aisle.** One continuous view of one room, filling the whole frame from top to bottom.

IMAGE 1 is a photo of the real place. Use it for look only: architecture, walls, ceiling, windows, floor, materials, light fixtures, light, and color. Ignore its furniture, people, food, signage, clutter, size, and camera angle.

IMAGE 2 is a top-down plan of the same room in a game. Use it for furniture only: which pieces exist, how many, and where they stand. Do not copy its pixel style, its floor, its walls, or its top-down view.

Build exactly the furniture below, no more and no fewer. Every piece takes the real place's materials, except a piece named with a color, which keeps that color.

The camera stands by the entrance door at the eye level and captures inside view .

{ZONE 1 — nearest the camera}
*Rows of fresh produce and packaged goods*

{ZONE 2 — middle}
*Rest area with flowers*

{ZONE 3 — back wall}
*Register counter, sign on the wall behind the counter "Fifth Avenue Market"*

The room is about 15x15m, so every piece reads clearly and none is tiny. Camera at standing eye height, lens about 24 mm, horizon level, far enough back that the whole back wall and every listed piece is in frame. Leave a little open floor between zones.

Empty of people. No furniture beyond the list. No plants in front of furniture. No pixel art, no top-down view.

Output exactly one image: ceiling at the top, floor at the bottom, one camera, one moment. Not two pictures stacked, not a split screen, not a diptych, not a before/after, no collage, no borders or dividing lines, no repeated room.

*Attach:*
- IMAGE 1 = real photo of the place (look). 
- IMAGE 2 = unlabeled Phaser crop (furniture). 
- Fill the `{…}` slots and paste the furniture list. One prompt, one result.


**Filling the slots**

- Camera: stand where customers are, look toward where the job happens, so a worker faces the camera.
- Furniture: copy the Phaser list, check counts against the crop (the crop wins). Write positions as seen from that camera. If the camera stands at the top edge of the crop, the plan's left becomes the frame's right.
- Up to about eight groups per frame. A bath or second room is its own plate.
- Size: shop or pub about 8 × 10 m; cafe or classroom about 10 × 12 m; apartment living room about 5 × 6 m.

**Fix pass** (when one to three pieces are missing). Attach only the best result:

```
Keep this exact room, camera, light, and every object already here. Add only: {missing items, each with its position in the frame}. Do not move, restyle, or duplicate anything else.
```

**Split rescue** (result came back as two stacked views). Crop the better half, attach only that, and run:

```
Extend this exact photograph into one single 9:16 frame: same room, camera, light, and every object, unchanged. Add more ceiling above and more floor below so the room fills the whole frame. One continuous image; no second picture, no dividing line, no repeated room.
```


Interiors save as `.jpg`. Filenames are slugs (no spaces or apostrophes).

#### *DONE* (2026-09-29)

| Pittsburgh address | Maze Place | Save as | What it shows |
| --- | --- | --- | --- |
| One PPG Place, Pittsburgh, PA 15222 | PPG Cafe | `double-video/video/assets/pittsburgh/interior/ppg_cafe_int.jpg` | Glass wintergarden cafe. Dining floor (red and yellow chairs, piano), counter with three stools, back-wall kitchen. One plate covers dining and bar. |
| 120 Fifth Avenue, Pittsburgh, PA 15222 | Fifth Avenue Market | `double-video/video/assets/pittsburgh/interior/fifth_avenue_market_int.jpg` | **Changed.** Produce and packaged-goods rows up front, flower rest area in the middle, register at the back with a “Fifth Avenue Market” sign on the wall. |
| 625 Liberty Avenue, Pittsburgh, PA 15222 | EQT Supply Store | `double-video/video/assets/pittsburgh/interior/eqt_supply_int.jpg` | Empty supply counter and crates. |
| 621 Penn Avenue, Pittsburgh, PA 15222 | O'Reilly Pub | `double-video/video/assets/pittsburgh/interior/oreilly_pub_int.jpg` | Empty pub bar. |
| 501 Penn Avenue, Pittsburgh, PA 15222 | Penn College | `double-video/video/assets/pittsburgh/interior/penn_college_library_int.jpg` | **Changed.** College library, not the classroom. |
| 501 Penn Avenue, Pittsburgh, PA 15222 | Penn College | `double-video/video/assets/pittsburgh/interior/penn_college_reception-gym_int.jpg` | **Changed.** College gym and rest area. |

Penn College has no classroom plate. Make one only if a Double’s job needs a classroom beat.

#### Homes - DONE

**Lookup rule (video bake).** For a Double's home: use that home's own plate `{slug}_int.jpg` if it is on disk. Otherwise use the shared look named in its row below. Fail the bake if neither exists. Never fall back to a village room.

Short term: three shared looks cover all 20 homes. Permanent: one plate per home, filled in over time. Each new home plate replaces its fallback automatically.

##### Shared looks (fallback) = **DONE 20260930**

The 20 homes fall into three sizes (floor cells from `double-docs/R3F/20260909_home-pass.md` and `20260918_wave20-furnishing.md`). One plate per size, built from **one example pad's** Phaser crop and furniture list.

| Look | Save as | Example pad (Phaser crop + list) | Homes that use it | What the frame shows |
| --- | --- | --- | --- | --- |
| **Small studio** (~25 cells) — **on disk 2026-09-30** | `double-video/video/assets/pittsburgh/interior/apt_small_int.jpg` | Midtown Tower (643 Liberty Avenue) | Midtown Tower, First & Market | Camera faces the bed, bath wall behind it: green desk and chair, square bed on a rug. No bath in frame, so it also fits First & Market (no bath). |
| **Mid one-room** (59–116 cells) — **on disk 2026-09-30** | `double-video/video/assets/pittsburgh/interior/apt_mid_int.jpg` | Six PPG Place (6 PPG Place) — plain kit, no signature prop | Gateway Tower, Roosevelt, Encore, River Vue, Tower Two-Sixty, 11 Stanwix, Six PPG, USW, PNC Center, One PNC, Three PNC, Four Gateway, K&L Gates, Three Gateway, Two Gateway, Two PNC | Long room seen from the fridge end: fridge, plant, mustard armchair, bookshelf, coat stand on the left; green desk and closed bath door on the right; table on a rug in the middle; dresser and bed at the glass back wall. Small extras kept: third table chair, nightstand. |
| **Large two-bedroom** (158–194 cells) — **on disk 2026-09-30** | `double-video/video/assets/pittsburgh/interior/apt_large_int.jpg` | One Gateway Center (420 Fort Duquesne Boulevard) | One Gateway Center, Two PPG Place | Living, dining, and kitchen in one frame. Two bedroom doors in the back. |
| **Large bedroom** (extra) — **on disk 2026-09-30** | `double-video/video/assets/pittsburgh/interior/apt_large_bedroom_int.jpg` | One Gateway Center main bedroom | One Gateway Center, Two PPG Place | Bed, dresser, rug, exercise machine. Sleep beats only; every other home beat uses the living plate. |

##### Every home (exact plates — when time permits)

Same interior prompt, with that home's own Phaser crop and furniture list. Keep its signature pieces and palette: they are how a viewer matches the plate to that Double's room in the sim. The three example pads get their exact plate for free: save the shared plate a second time under the home's slug.

Order: homes of Doubles who are about to be featured first, then homes with signature pieces, then the plain ones.

All files go in `double-video/video/assets/pittsburgh/interior/`. Addresses are ZIP 15222 unless noted.

| # | Maze Place | Address | Cells | Fallback look | Exact plate | Signature pieces (from the sim) | Status |
| 3 | Six PPG Place | 6 PPG Place | 94 | mid | `six_ppg_place_int.jpg` | Plain kit | **Done 2026-09-30** — copy of the mid look |
| 2 | Midtown Tower | 643 Liberty Avenue | 26 | small | `midtown_tower_int.jpg` | Square bed, desk, rug, bath wall | **Done 2026-09-30** — copy of the small look |
| 19 | One Gateway Center | 420 Fort Duquesne Boulevard | 195 | large | `one_gateway_int.jpg` | Two bedrooms. Sage and terracotta walls, stocked bar, exercise machine (easel, guitar, globe removed Sept 20) | **Done 2026-09-30** — copy of the large look (living). Bedroom `one_gateway_bedroom_int.jpg` done too |
| 20 | Two PPG Place | 2 PPG Place | 159 | large | `two_ppg_place_int.jpg` | Two bedrooms. Blue walls and mosaic floor, blue dining chairs with fruit centerpiece, blue electric guitar, striped rug, games console (harp and TV not in the Sept 21 crop) | **Done 2026-09-30** (living). Bedroom `two_ppg_place_bedroom_int.jpg` (console room) done too |
| 6 | 11 Stanwix Street | 11 Stanwix Street | 101 | mid | `11_stanwix_int.jpg` | Drum, guitar | **Done 2026-09-30** |
| 11 | Encore on 7th | 100 7th Street | 76 | mid | `encore_on_7th_int.jpg` | Easel, guitar | **Done 2026-09-30** |
| 13 | Four Gateway Center | 444 Liberty Avenue | 75 | mid | `four_gateway_int.jpg` | Harp, urn | **Done 2026-09-30** |
| 14 | K&L Gates Center | 210 Sixth Avenue | 74 | mid | `kl_gates_int.jpg` | Easel, flowers | **Done 2026-09-30** |
| 7 | USW \| United Steelworkers | 60 Boulevard of the Allies | 88 | mid | `usw_int.jpg` | Guitar, music corner, no TV | **Done 2026-09-30** |
| 10 | One PNC Plaza | 249 Fifth Avenue | 77 | mid | `one_pnc_plaza_int.jpg` | Guitar, floor lamp | **Done 2026-09-30** |
| 4 | River Vue Apartments | 300 Liberty Avenue | 116 | mid | `river_vue_int.jpg` | Bookshelf, globe, flowers, floor lamp | **Done 2026-09-30** (flowers are in the bath, not in frame) |
| 5 | Tower Two-Sixty | 260 Forbes Avenue | 114 | mid | `tower_two_sixty_int.jpg` | Sofa, TV, reading chair, floor lamp | **Done 2026-09-30** (living side; bed end not in frame) |
| 8 | PNC Center | 500 First Avenue, **15219** | 86 | mid | `pnc_center_int.jpg` | Plain kit, fridge | **Done 2026-09-30** |
| 9 | Roosevelt Building | 609 Penn Avenue | 80 | mid | `roosevelt_building_int.jpg` | Dresser, armchair, bath wall | **Done 2026-09-30** |
| 12 | Three PNC Plaza | 225 Fifth Avenue | 75 | mid | `three_pnc_plaza_int.jpg` | Bookshelf, flowers, floor lamp | **Done 2026-09-30** |
| 15 | Gateway Tower | 320 Fort Duquesne Boulevard | 73 | mid | `gateway_tower_int.jpg` | Desk with computer, bookcase | **Done 2026-09-30** |
| 16 | Three Gateway Center | 401 Liberty Avenue | 69 | mid | `three_gateway_int.jpg` | Floor lamp, no fridge | **Done 2026-09-30** |
| 17 | Two Gateway Center | 603 Stanwix Street | 66 | mid | `two_gateway_int.jpg` | Sparse: bed, desk, dresser, armchair | **Done 2026-09-30** |
| 18 | Two PNC Plaza | 620 Liberty Avenue | 60 | mid | `two_pnc_plaza_int.jpg` | Flowers, tight bath | **Done 2026-09-30** (flowers are in the bath, not in frame) |

First & Market Apartments (#1, no bath) has no own plate by choice. It uses the small look `apt_small_int.jpg`.

Slugs match the exterior files (`{slug}_exterior_ref.jpg`) so one home has one name across plates. Cells are Phaser floor cells, used only to pick the fallback size. Signature pieces come from the September furnishing notes; the Phaser crop wins if they differ.

Phaser crops (Imagine layout only, not on-screen plates): `double-video/video/assets/phaser/_moodboard/pittsburgh/{slug}.png` — same slug as the interior file, unlabeled top-down.