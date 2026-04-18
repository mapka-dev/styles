# `aeroway`

Airport infrastructure polygons and lines based on OSM `aeroway=*`. Airport **buildings** live in the `building` layer — everything else airport-related is here.

> Upstream: [openmaptiles/layers/aeroway/aeroway.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/aeroway/aeroway.yaml) · [schema page](https://openmaptiles.org/schema/#aeroway)

- **Geometry:** Polygon (apron, aerodrome, taxiway area) and line (runway, taxiway linear).
- **Buffer size:** `4` px.
- **Data source:** OpenStreetMap only.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `ref` | string | OSM `ref` on the runway/taxiway (e.g. `09L/27R`). |
| `class` | enum | Raw `aeroway` (or `area:aeroway`) value. |

### `class` values

- `aerodrome` — airport polygon boundary.
- `heliport` — heliport polygon.
- `runway` — main runway.
- `helipad` — helicopter landing surface.
- `taxiway` — taxi paths.
- `apron` — parking/holding area (polygon).
- `gate` — gate point / polygon.

## Styling notes

- Appears from ~z10; runways and aprons at z11+, taxiways at z12+.
- Render aprons as wide filled polygons (light fill), runways as thick dark lines with `ref` label along the line.
- Helipads are small — use a circle marker with a letter `H` icon.
- No `name` field here — airport naming comes from `aerodrome_label`.
