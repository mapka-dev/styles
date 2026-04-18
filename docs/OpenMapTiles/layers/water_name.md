# `water_name`

Labels for water bodies — lake centerlines from the [osm-lakelines](https://github.com/openmaptiles/osm-lakelines) project plus named oceans/seas/bays/straits. Only the most important water bodies carry labels.

- **Geometry:** Line (lake centerline) and point.
- **Buffer size:** `256` px — large, so long labels survive at tile edges.
- **Data sources:**
  - OSM (named water features).
  - `lake_centerline` (derived centerlines for clean along-line labels).
  - Natural Earth: `ne_10m_geography_marine_polys`.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx`. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `class` | enum | See below. |
| `intermittent` | `0` / `1` | Intermittent lake marker. |

### `class` values

- `ocean`
- `sea`
- `bay`
- `strait`
- `lake`

## Styling notes

- Line placement for lakes: `symbol-placement: line` on the centerline; italic serif is traditional.
- Oceans/seas: very large letter spacing, often ALL CAPS, faded/desaturated color.
- Zoom ramp: `ocean` from z0, `sea` z3+, `bay`/`strait` z6+, `lake` z10+.
- Use `symbol-sort-key` with negative `rank` proxies (e.g. feature area) to prefer big bodies.
- `intermittent=1` → italicize the label or desaturate; most styles ignore.
- Anchor halos so white letters read against blue fills.
