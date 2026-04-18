# `aerodrome_label`

Point labels for airports, heliports, and airfields, derived from OSM `aeroway=aerodrome` features. Use together with the `aeroway` layer, which carries runway/taxiway geometry.

> Upstream: [openmaptiles/layers/aerodrome_label/aerodrome_label.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/aerodrome_label/aerodrome_label.yaml) · [schema page](https://openmaptiles.org/schema/#aerodrome_label)

- **Geometry:** Point (centroid or OSM node).
- **Buffer size:** `64` px (large buffer so labels near tile edges don't clip).
- **Data source:** OpenStreetMap only.
- **SRS:** Web Mercator.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name` tag. Also `name:xx` per language. |
| `name_en` | string | Deprecated alias for `name:en` (falls back to `name`). |
| `name_de` | string | Deprecated alias for `name:de` (falls back to `name:en` / `name`). |
| `class` | enum | Airport importance. See below. |
| `iata` | string | 3-letter IATA code (e.g. `LHR`). |
| `icao` | string | 4-letter ICAO code (e.g. `EGLL`). |
| `ele` | number | Elevation, meters. |
| `ele_ft` | number | Elevation, feet. |

### `class` values

| Value | OSM source |
| --- | --- |
| `international` | `aerodrome=international` or `aerodrome:type=international` |
| `public` | `aerodrome=public` or `aerodrome:type` contains `public` / `civil` |
| `regional` | `aerodrome=regional` or `aerodrome:type=regional` |
| `military` | `aerodrome=military`, `aerodrome:type` contains `military`, or `military=airfield` |
| `private` | `aerodrome=private` or `aerodrome:type=private` |
| `other` | default |

## Styling notes

- Show `international` from low zoom (~z8), then `public`/`regional` from higher zooms.
- Use IATA (when present) as a compact label at low zoom; full name at higher zoom.
- Elevation is useful for aviation/topo styles; most basemaps ignore it.
- Pair with `aeroway` so the runway polygon and label share orientation.
