# `mountain_peak`

Natural peaks, volcanoes, saddles, ridges, cliffs, and arêtes from OSM. One of the rare layers with both metric and imperial elevations precomputed.

> Upstream: [openmaptiles/layers/mountain_peak/mountain_peak.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/mountain_peak/mountain_peak.yaml) · [schema page](https://openmaptiles.org/schema/#mountain_peak)

- **Geometry:** Point (primary). `ridge` and `arete` can also come through as lines via `update_mountain_linestring.sql`.
- **Buffer size:** `64` px.
- **Data source:** OSM (`natural=peak`, `natural=volcano`, `natural=saddle`, `natural=ridge`, `natural=cliff`, `natural=arete`); requires `ne_10m_admin_0_countries` to compute `customary_ft`.
- **Typical minzoom:** ~7 (rank-filtered).

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx` per language. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `class` | enum | See below. |
| `ele` | number | Elevation, meters (from OSM `ele`). |
| `ele_ft` | number | Elevation, feet. |
| `customary_ft` | `1` / `NULL` | `1` where feet is the local customary unit (USA). |
| `rank` | int | Importance within tile, `1`=most important. |

### `class` values

- `peak` — standard summit.
- `volcano` — active or dormant volcano.
- `saddle` — pass/col.
- `ridge` — ridge line (may appear as line-like cluster of points).
- `cliff` — cliff edge.
- `arete` — sharp ridge crest.

## Styling notes

- Filter by `rank <= 2` until z10, then relax.
- Triangle icon for `peak`, triangle-with-circle for `volcano`, chevron for `saddle`.
- Use `customary_ft=1` → render `ele_ft` with `′` suffix; otherwise render `ele` in meters.
- Elevation lines under name are common: `name\n{ele} m`.
- `cliff`/`ridge`/`arete` are less typical for basemaps — hide unless you're doing topo.
