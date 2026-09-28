# Pittsburgh places — video shoot

**2026-09-26** · Sim names stay the occupancy names. Street addresses are the real pads. ZIP **15222** unless noted.

## Shoot these first

This is the Downtown closer set. Do it when Imagine quota is back. Shops already have street and door plates. Home street faces, landmarks, bridges, and skyline stay in the exteriors list below.

Interiors wait on the unlabeled Phaser crops at the bottom of this file (`video/assets/phaser/_moodboard/pittsburgh/`). Layout comes from that crop.

| Order | Maze Place | Plate | Save as | Why this one |
| --- | --- | --- | --- | --- |
| 1 | Point State Park | Mass | `double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref.jpg` | Main outdoor plate for a closer. Wide triangle. |
| 2 | Point State Park | Door | `double-video/video/assets/pittsburgh/exterior/ref/point_state_park_exterior_ref_door.jpg` | Lawn stand-spot. A person reads at life size. |
| 3 | PPG Cafe | Interior | `double-video/video/assets/pittsburgh/interior/ppg_cafe_int.png` | Street and door exist. Dining floor still missing. |
| 4 | Fifth Avenue Market | Interior | `double-video/video/assets/pittsburgh/interior/fifth_avenue_market_int.png` | Street and door exist. Aisle still missing. |
| 5 | EQT Supply Store | Interior | `double-video/video/assets/pittsburgh/interior/eqt_supply_int.png` | Street and door exist. Counter still missing. |
| 6 | O'Reilly Pub | Interior | `double-video/video/assets/pittsburgh/interior/oreilly_pub_int.png` | Street and door exist. Bar still missing. |
| 7 | Penn College | Interior | `double-video/video/assets/pittsburgh/interior/penn_college_int.png` | Street and door exist. Classroom still missing. |
| 8 | Two Gateway Center | Interior | `double-video/video/assets/pittsburgh/interior/apt_small_int.png` | Shared small home look. One plate for the small pads. |
| 9 | First & Market Apartments | Interior | `double-video/video/assets/pittsburgh/interior/apt_mid_int.png` | Shared mid home look. |
| 10 | One Gateway Center | Interior | `double-video/video/assets/pittsburgh/interior/apt_large_int.png` | Shared large home look. Two PPG Place can reuse it. |

**Exteriors** = real photos (façades, landmarks, outdoor plates). **Interiors** = empty ground-floor sim rooms (Imagine plates), not real tower floor plans. The closer needs this set: Point, five shop rooms, and three apartment looks. The rest of this file is the full shoot.

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
| 643 Liberty Avenue, Pittsburgh, PA 15222 | Midtown Tower | double-video/video/assets/pittsburgh/exterior/ref/midtown_tower_exterior_ref.jpg | Full façade, door zone visible. |
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

Empty eye-level plates of the **sim ground floor**. Do not photograph real office or apartment interiors. Layout ref = unlabeled Phaser top-down of that room (no `*_labeled.png`). Imagine stack: that crop + `double-video/video/assets/village/exterior/_style_frame_master.png` + a continuity plate. No people.

| Pittsburgh address | Maze Place | Save as | How to shoot |
| --- | --- | --- | --- |
| One PPG Place, Pittsburgh, PA 15222 | PPG Cafe | double-video/video/assets/pittsburgh/interior/ppg_cafe_int.png | Empty cafe, dining floor. Optional second: `ppg_cafe_int_counter.png` (bar). Ban Hobbs furniture. |
| 120 Fifth Avenue, Pittsburgh, PA 15222 | Fifth Avenue Market | double-video/video/assets/pittsburgh/interior/fifth_avenue_market_int.png | Empty market aisle. |
| 625 Liberty Avenue, Pittsburgh, PA 15222 | EQT Supply Store | double-video/video/assets/pittsburgh/interior/eqt_supply_int.png | Empty supply counter / crates. |
| 621 Penn Avenue, Pittsburgh, PA 15222 | O'Reilly Pub | double-video/video/assets/pittsburgh/interior/oreilly_pub_int.png | Empty pub bar. |
| 501 Penn Avenue, Pittsburgh, PA 15222 | Penn College | double-video/video/assets/pittsburgh/interior/penn_college_int.png | Empty classroom. Do not make a second library interior until that room is hollowed. |
| 603 Stanwix Street, Pittsburgh, PA 15222 | Two Gateway Center | double-video/video/assets/pittsburgh/interior/apt_small_int.png | Shared small look for the 20 homes. One living room + bath. Example pad only. Not 20 unique units. |
| 164 First Avenue, Pittsburgh, PA 15222 | First & Market Apartments | double-video/video/assets/pittsburgh/interior/apt_mid_int.png | Shared mid look. One open room + bath. Example pad only. |
| 420 Fort Duquesne Boulevard, Pittsburgh, PA 15222 | One Gateway Center | double-video/video/assets/pittsburgh/interior/apt_large_int.png | Shared large look. Larger living + bath. Example pad. Two PPG Place can use this same plate. Not a real tower plan. |

Phaser crops (Imagine layout only, not on-screen plates): `double-video/video/assets/phaser/_moodboard/pittsburgh/{slug}.png` — same slug as the interior file, unlabeled top-down.
