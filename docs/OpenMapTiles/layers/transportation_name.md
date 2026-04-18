# `transportation_name`

Label layer for named highways. Only roads that are named **and** long enough for text placement appear here. Roads with identical names are stitched together for cleaner long-road labels.

- **Geometry:** Line.
- **Buffer size:** `8` px.
- **Data source:** OSM; requires the `transportation` layer and `highway_class()` logic.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx`. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `ref` | string | OSM `ref` — shield content (e.g. `I-95`, `A1`). |
| `ref_length` | int | Length of `ref` — useful to pick shield width. |
| `network` | string | Network classification. See below. |
| `class` | enum | Road importance. See below. |
| `subclass` | string | Specific path types. |
| `brunnel` | enum | `bridge`, `tunnel`, `ford`. |
| `layer` | int | OSM `layer` (experimental, steps/footways only). |
| `level` | string | OSM `level` (experimental, steps/footways only). |
| `indoor` | `1` | Indoor marker (experimental, steps/footways only). |
| `route_1_network` … `route_6_network` | string | Concurrency — up to 6 overlapping route networks. |
| `route_1_ref` … `route_6_ref` | string | Corresponding route refs. |
| `route_1_name` … `route_6_name` | string | Corresponding route names. |
| `route_1_colour` … `route_6_colour` | string | Corresponding route colors. |

### `network` values

- US: `us-interstate`, `us-highway`, `us-state`
- Canada: `ca-transcanada`, `ca-provincial-arterial`, `ca-provincial`
- UK: `gb-motorway`, `gb-trunk`, `gb-primary`
- Ireland: `ie-motorway`, `ie-national`, `ie-regional`
- Default: `road`

### `class` values

- Roads: `motorway`, `trunk`, `primary`, `secondary`, `tertiary`, `minor`, `service`, `track`, `path`, `raceway`.
- Construction variants of each.
- Other: `rail`, `transit`, `motorway_junction`.

### `subclass` values

`pedestrian`, `path`, `footway`, `cycleway`, `steps`, `bridleway`, `corridor`, `platform`, `junction`.

## Route concurrency

A single road can be part of multiple numbered routes (e.g. I-95 + US-1 + State 9 overlap). `route_N_*` fields carry up to six concurrent routes so a style can stack shields vertically next to the road name.

## Styling notes

- Labels: place `name` along the line (`symbol-placement: line`). Use `text-letter-spacing` slightly positive for highway feel.
- Shields: use the 6 `route_N_*` fields; render each as an icon with `ref` text overlaid. Width from `ref_length`.
- Typical zoom ramp: motorway ref shields from z8, motorway names z10, primary z11, secondary z12, minor z14.
- `network` determines shield graphic. Provide a fallback for unknown networks.
- `class=motorway_junction` is for exit/junction numbers — render as a small numbered marker.
