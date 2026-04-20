# `transportation`

All linear transport: roads, railways, aerial ways, ferries, shipping lines. Directly derived from the OSM road hierarchy. **Labels live in `transportation_name`** — this layer carries only geometry and attributes.

> Upstream: [openmaptiles/layers/transportation/transportation.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/transportation/transportation.yaml) · [schema page](https://openmaptiles.org/schema/#transportation)

- **Geometry:** Line.
- **Buffer size:** `4` px.
- **Data source:** OSM; requires `ne_10m_admin_0_countries` (for ferry/shipping hints).
- **Typical minzoom:** 4 (motorways) → 14 (service/track/path).

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `class` | enum | Road/rail importance. See below. |
| `subclass` | string | Specific railway/path types. See below. |
| `network` | string | OSM `network`. Distinguishes `us-interstate`, etc. (Fuller list in `transportation_name`.) |
| `brunnel` | enum | `bridge`, `tunnel`, `ford`. |
| `oneway` | `1` / `0` / `-1` | `1` = forward oneway, `-1` = backward oneway, `0` = not oneway. |
| `ramp` | `1` / `0` | Link (on/off ramp) or steps. |
| `service` | enum | See below. |
| `access` | enum | `no`, `private` — restricted or private access. |
| `toll` | `0` / `1` | Toll road. |
| `expressway` | `1` | Expressway flag (can coexist with any class). |
| `layer` | int | OSM `layer` — stacking order, negative = below surface. |
| `level` | string | OSM `level` — indoor floor (steps/footways only). |
| `indoor` | `1` | Indoor indicator (experimental). |
| `bicycle` | string | Raw `bicycle` access tag (highways only). |
| `foot` | string | Raw `foot` access tag (highways only). |
| `horse` | string | Raw `horse` access tag (highways only). |
| `mtb_scale` | string | Mountain bike difficulty (highways only). |
| `official` | `0` / `1` | Official/unofficial trail. |
| `surface` | enum | `paved` or `unpaved`. |

### `class` values

- Roads: `motorway`, `trunk`, `primary`, `secondary`, `tertiary`, `minor`, `service`, `track`, `path`, `raceway`.
- Other transport: `busway`, `bus_guideway`, `ferry`.
- Construction variants: `motorway_construction`, `trunk_construction`, `primary_construction`, `secondary_construction`, `tertiary_construction`, `minor_construction`, `service_construction`, `track_construction`, `path_construction`, `raceway_construction`.

Note railway classes are not in `transportation.class` — they surface via `subclass` under an (absent) rail class or in `transportation_name`.

### `subclass` values

- Rail: `rail`, `narrow_gauge`, `preserved`, `funicular`, `subway`, `light_rail`, `monorail`, `tram`.
- Paths: `pedestrian`, `path`, `footway`, `cycleway`, `steps`, `bridleway`, `corridor`, `platform`.
- **Deprecated:** `ferry` — retained for backward compatibility; styles should match `class=ferry` instead.

### `service` values

`spur`, `yard`, `siding`, `crossover`, `driveway`, `alley`, `parking_aisle`.

### `brunnel`

Drive stacking and casing: tunnels go under water, bridges sit on top with a wider casing.

## Styling notes

- Core technique: draw each road class twice (casing line under, fill line over). Order by zoom + `layer` + `brunnel`.
- Motorway green/blue shields + wide width; trunk slightly narrower; primary yellow/white; secondary/tertiary lighter.
- `brunnel=bridge` → add casing width, darker stroke; `brunnel=tunnel` → dashed pattern or muted color.
- `oneway=1` / `oneway=-1` → render an arrow symbol along the line at z15+.
- `surface=unpaved` → dashed pattern.
- `construction` classes usually get a hatched or dotted pattern.
- `ramp=1` → thinner than parent class; often drawn only at z13+.
- Use `access=no` to suppress private roads at low zooms.
- `expressway=1` can upgrade styling of trunk roads to look motorway-like.
- `service=parking_aisle` should hide until z16+ if at all.
