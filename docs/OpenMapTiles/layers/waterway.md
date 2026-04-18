# `waterway`

Linear water features — rivers, streams, canals, drains, ditches. Natural Earth at low zoom, OSM from z9 upward. Unnamed short linestrings are filtered out at low zoom to reduce noise.

- **Geometry:** Line.
- **Buffer size:** `4` px.
- **Data sources:**
  - Natural Earth: `ne_110m_rivers_lake_centerlines` (z3–z5), `ne_50m_rivers_lake_centerlines` (z6–z8).
  - OSM: `waterway=*` from z9+.
- **Requires:** `water` layer.

## Generalization by zoom

| Zoom | Includes |
| --- | --- |
| z3–z8 | Natural Earth rivers + lake centerlines only |
| z9–z11 | OSM `class=river` |
| z12 | OSM `class=river` + `class=canal` |
| z13+ | No class generalization — streams, drains, ditches included |

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx`. May be empty for Natural Earth data or short OSM streams. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `class` | enum | Raw OSM `waterway` tag value. See below. |
| `brunnel` | enum | `bridge` or `tunnel`. |
| `intermittent` | `0` / `1` | Intermittent waterway. |

### `class` values

- `stream`
- `river`
- `canal`
- `drain`
- `ditch`

No `subclass` field on this layer.

## Styling notes

- Line width ramp: `river` > `canal` > `stream` > `drain` / `ditch`.
- Pair with `water` polygons for rivers wide enough to be polygons — both layers render the same feature from different geometries.
- `brunnel=tunnel` → dashed or hidden; `brunnel=bridge` rarely visible (use `transportation.brunnel=bridge` for the road over the river).
- `intermittent=1` → dashed stroke (classic OSM style).
- Labels: use `transportation_name`-like line placement on `river` from z10+, `canal` at z12+, names on smaller waterways only at z15+.
- Unnamed waterways have no label feature — consider this when building label expressions.
