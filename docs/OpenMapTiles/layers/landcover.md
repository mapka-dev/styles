# `landcover`

Physical surface coverage — forests, grasslands, rocks, ice, sand, wetlands. Natural Earth supplies glaciers/ice at low zoom; OSM fills in everything else at higher zoom.

- **Geometry:** Polygon.
- **Buffer size:** `4` px.
- **Data sources:**
  - Natural Earth: `ne_10m/50m/110m_glaciated_areas`, `ne_10m/50m_antarctic_ice_shelves_polys`.
  - OSM: `natural=*`, `landuse=*`, `leisure=*`, `wetland=*`.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `class` | enum | High-level bucket for paint color. |
| `subclass` | string | Raw OSM tag value for precise styling. |

### `class` → `subclass` mapping

| `class` | `subclass` values |
| --- | --- |
| `farmland` | `farmland`, `farm`, `orchard`, `vineyard`, `plant_nursery` |
| `ice` | `glacier`, `ice_shelf` |
| `wood` | `wood`, `forest` |
| `rock` | `bare_rock`, `scree` |
| `grass` | `fell`, `flowerbed`, `grassland`, `heath`, `scrub`, `shrubbery`, `tundra`, `grass`, `meadow`, `allotments`, `park`, `village_green`, `recreation_ground`, `garden`, `golf_course` |
| `wetland` | `wetland`, `bog`, `swamp`, `wet_meadow`, `marsh`, `reedbed`, `saltern`, `tidalflat`, `saltmarsh`, `mangrove` |
| `sand` | `beach`, `sand`, `dune` |

## Styling notes

- Drive main color from `class` — one fill per class is usually enough.
- Use `subclass` for overrides: e.g. `wetland` subclasses `mangrove` vs `marsh` warrant different fills.
- Ice and snow should render above water (oceans) when glaciers extend offshore (south pole).
- Hatched/stippled fills for wetlands are common; sand uses pale yellow; wood uses green with darker variant for `forest`.
- No names — label parks and reserves via the `park` layer.
