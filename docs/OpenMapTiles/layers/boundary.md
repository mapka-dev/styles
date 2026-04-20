# `boundary`

Administrative borders as linestrings (countries, states, counties, municipalities) plus aboriginal lands as polygons. Natural Earth powers the lowest zooms; OSM takes over at z5+.

> Upstream: [openmaptiles/layers/boundary/boundary.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/boundary/boundary.yaml) · [schema page](https://openmaptiles.org/schema/#boundary)

- **Geometry:** Line (admin borders), polygon (aboriginal lands).
- **Buffer size:** `4` px.
- **Data sources:**
  - Natural Earth through z4 — `ne_10m/50m/110m_admin_0_boundary_lines_land`.
  - OSM from z5 upward — `boundary=administrative` relations.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `class` | enum | Boundary type (e.g. `aboriginal_lands`). Most borders have no class; use `admin_level`. |
| `name` | string | OSM name (aboriginal-lands polygons only). |
| `admin_level` | int | OSM admin hierarchy — `2`=country, `4`=state, `6`=county, `8`=municipality, etc. |
| `adm0_l` | string | Country name on the **left** side (country borders only). |
| `adm0_r` | string | Country name on the **right** side (country borders only). |
| `disputed` | 0/1 | Whether the border is disputed. |
| `disputed_name` | string | Identifier for the disputed area (e.g. `Crimea`, `Dokdo`, `IndianClaim-North`, `AbuMusaIsland`). `admin_level=2` borders only. |
| `claimed_by` | string | ISO2 country code of the claimant (country borders only). Use to toggle visibility per viewer. |
| `maritime` | 0/1 | Maritime border flag. |

### `admin_level` convention

OSM `admin_level` is country-specific but in OpenMapTiles practice:

- `2` — country border.
- `4` — state / province / top-level region.
- `6` — county / district.
- `8` — municipality / city.
- `10` — suburb (rare in tiles).

## Styling notes

- Dashed strokes for disputed borders; solid for undisputed.
- `maritime=1` → lighter, often dashed, rendered below land borders.
- Filter by `admin_level <= 4` at low zoom; progressively add lower levels at higher zoom.
- `claimed_by` can be used to tailor borders per viewer country (Indian/Chinese/Japanese claims).
- Aboriginal lands polygons are typically rendered as subtle hatched fills.
