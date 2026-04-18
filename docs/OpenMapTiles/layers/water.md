# `water`

Water polygons — oceans, seas, lakes, ponds, docks, swimming pools. Low zoom comes from Natural Earth; high zoom from [OpenStreetMapData](http://osmdata.openstreetmap.de/) (OSM-derived, pre-split into many smaller polygons for render performance). Covered water (`covered=yes`) is excluded.

- **Geometry:** Polygon.
- **Buffer size:** `4` px.
- **Data sources:**
  - Natural Earth: `ne_10m/50m/110m_lakes`, `ne_10m/50m/110m_ocean`.
  - OSM: `osm_ocean_polygon` + OSM water polygons.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `id` | int | OSM id from z6+. ≤z5 uses Natural Earth lakes (IDs are OSM-propagated at planet scale; NE IDs retained on sub-planet extracts). |
| `class` | enum | Water body type. See below. |
| `intermittent` | `0` / `1` | Intermittent water (`intermittent=yes` in OSM). |
| `brunnel` | enum | `bridge` or `tunnel` — the water crosses over/under something. |

### `class` values

| Value | OSM tag |
| --- | --- |
| `ocean` | ocean polygons from OpenStreetMapData |
| `river` | `water=river`, `water=canal`, `water=stream`, `water=ditch`, `water=drain` (the water-covered area) |
| `dock` | `waterway=dock` |
| `lake` | everything else not matched above |
| `pond` | `water=pond`, `water=basin`, `water=wastewater`, `water=salt_pond` |
| `swimming_pool` | `leisure=swimming_pool` |

## Important rendering notes

- Water polygons are **pre-split** into many smaller polygons. That means you cannot reliably draw a border/outline around the full water body — seam lines will appear. Use `waterway` centerlines or a separate outline source for strokes.
- OSM `class=ocean` is one feature per ocean polygon from OpenStreetMapData, not one feature per tile — still subject to splitting.
- To draw ice shelves correctly over ocean at the south pole, style `landcover` ice above `water=ocean`.

## Styling notes

- One fill per class is usually enough: `ocean` darker blue, `lake`/`pond`/`river` slightly lighter, `swimming_pool` a pale teal.
- `intermittent=1` → lighter/desaturated fill (and often a dashed stroke if you add one from `waterway`).
- `brunnel=bridge` on water polygons is rare but allows styling of water surface under bridges differently.
- Swimming pools only show at z16+ in most styles.
