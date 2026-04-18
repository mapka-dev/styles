# `landuse`

Human land use — residential, industrial, commercial, institutional areas, plus a few non-physical things like `place=suburb`/`quarter`/`neighbourhood` polygons. Natural Earth contributes urban areas at low zoom; OSM dominates at higher zoom.

> Upstream: [openmaptiles/layers/landuse/landuse.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/landuse/landuse.yaml) · [schema page](https://openmaptiles.org/schema/#landuse)

- **Geometry:** Polygon.
- **Buffer size:** `4` px.
- **Data sources:**
  - Natural Earth: `ne_50m_urban_areas`.
  - OSM: `landuse=*`, `amenity=*`, `leisure=*`, `tourism=*`, `place=*`, `waterway=dam`.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `class` | enum | Raw OSM tag value used for styling. |

### `class` values

| Value | OSM origin |
| --- | --- |
| `railway` | `landuse=railway` |
| `cemetery` | `landuse=cemetery` |
| `military` | `landuse=military` |
| `residential` | `landuse=residential` |
| `commercial` | `landuse=commercial` |
| `industrial` | `landuse=industrial` |
| `garages` | `landuse=garages` |
| `retail` | `landuse=retail` |
| `bus_station` | `amenity=bus_station` |
| `school` | `amenity=school` |
| `university` | `amenity=university` |
| `kindergarten` | `amenity=kindergarten` |
| `college` | `amenity=college` |
| `library` | `amenity=library` |
| `hospital` | `amenity=hospital` |
| `stadium` | `leisure=stadium` |
| `pitch` | `leisure=pitch` |
| `playground` | `leisure=playground` |
| `track` | `leisure=track` |
| `theme_park` | `tourism=theme_park` |
| `zoo` | `tourism=zoo` |
| `suburb` | `place=suburb` |
| `quarter` | `place=quarter` |
| `neighbourhood` | `place=neighbourhood` |
| `dam` | `waterway=dam` |
| `quarry` | `landuse=quarry` |

## Styling notes

- Desaturated fills at low zoom (residential = pale grey/beige); colors intensify at z13+.
- Education and healthcare (`school`, `hospital`, `university`) often get a distinct tint.
- `pitch`/`track`/`playground` can reuse a sport green with icons at z16+.
- `place=suburb/quarter/neighbourhood` polygons are **not labels** — use `place` layer for that.
- No `name` field — these polygons are painted, not labeled.
