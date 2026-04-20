# OpenMapTiles — Overview

OpenMapTiles is an open vector-tile schema over OpenStreetMap (OSM) data, augmented with Natural Earth at low zoom levels. It defines how OSM features are partitioned into thematic **layers**, which **attributes** they expose, and which **values** those attributes can take. Styles (MapLibre / Mapbox GL JSON) target these layers and attributes — which is why the schema is the contract a style depends on.

This repo consumes OpenMapTiles tiles (self-hosted or via a provider like MapTiler) and ships several styles (`osm-liberty`, `osm-bright-gl-style`, `positron-gl-style`, `dark-matter-gl-style`). Any style edit reads features out of these layers. If an attribute or value below doesn't exist in a tile, the filter silently matches nothing.

## Schema at a glance

- **Source:** <https://openmaptiles.org/schema/> (canonical), layer YAMLs in <https://github.com/openmaptiles/openmaptiles/tree/master/layers>
- **Projection:** Web Mercator (`EPSG:3857` / SRID `900913`)
- **Format:** Mapbox Vector Tiles (MVT) — `.pbf` protobuf, one tile per `(z, x, y)`
- **Licence:** Schema CC-BY; code BSD; OSM data ODbL; Natural Earth public domain
- **Origins:** Klokan Technologies, inspired by CARTO Positron, refined with Wikimedia and Paul Norman

## The 16 layers

| Layer | Geometry | Purpose |
| --- | --- | --- |
| [aerodrome_label](layers/aerodrome_label.md) | point | Airport labels |
| [aeroway](layers/aeroway.md) | line / polygon | Runways, taxiways, aprons, helipads |
| [boundary](layers/boundary.md) | line (polygon for aboriginal lands) | Admin borders |
| [building](layers/building.md) | polygon | OSM buildings with 3D attributes |
| [housenumber](layers/housenumber.md) | point | Address numbers |
| [landcover](layers/landcover.md) | polygon | Physical surface (wood, grass, ice, sand…) |
| [landuse](layers/landuse.md) | polygon | Human land use (residential, military, retail…) |
| [mountain_peak](layers/mountain_peak.md) | point | Peaks, volcanoes, saddles |
| [park](layers/park.md) | polygon + point | Protected areas, nature reserves |
| [place](layers/place.md) | point (polygon for islands / aboriginal) | Countries, states, cities, villages |
| [poi](layers/poi.md) | point | Shops, amenities, tourism, transport stops |
| [transportation](layers/transportation.md) | line | Roads, rails, aerialways, ferries |
| [transportation_name](layers/transportation_name.md) | line | Road labels and route shields |
| [water](layers/water.md) | polygon | Oceans, lakes, ponds, docks, pools |
| [water_name](layers/water_name.md) | point / line | Labels for water bodies |
| [waterway](layers/waterway.md) | line | Rivers, streams, canals |

## Data sources and zoom strategy

OpenMapTiles blends two sources to balance tile size and detail:

- **Natural Earth** — low zoom (z0–z5ish), simplified global coverage, public domain.
- **OpenStreetMap** — higher zoom (z5+), detail dense and crowd-sourced, ODbL.

Concretely:

- `water` uses Natural Earth lakes/oceans through z5, then OSM polygons (via [OpenStreetMapData](http://osmdata.openstreetmap.de/)) from z6+.
- `waterway` uses Natural Earth centerlines z3–z8, OSM from z9+.
- `boundary` uses Natural Earth admin borders through z4, OSM from z5+.
- `landcover` uses Natural Earth ice/glaciers at low zoom, OSM at higher zoom.
- `landuse` uses Natural Earth urban areas at low zoom, OSM at higher zoom.
- `place` uses Natural Earth populated places/countries/states blended with OSM (rank combines NE `scalerank`/`labelrank`/`datarank` with OSM data).
- OSM-only: `aerodrome_label`, `aeroway`, `building`, `housenumber`, `mountain_peak`, `park`, `poi`, `transportation`, `transportation_name`, `water_name` (the latter also uses the `lake_centerline` project).

Because ID spaces differ, the `water.id` field keeps OSM ids from z6 and Natural Earth ids below z5 (at planet scale, OSM ids are propagated onto NE lakes; sub-planet extracts keep NE ids).

## Zoom ranges per layer (approximate)

The schema page does not publish explicit minzoom for every layer, but empirically and from layer SQL:

| Layer | Typical minzoom | Notes |
| --- | --- | --- |
| water, landcover, landuse, boundary, waterway, place | 0 | Seeded from Natural Earth |
| park | 4–6 | National parks first, then reserves |
| mountain_peak | 7 | Filtered by importance / rank |
| transportation | 4 (motorways) → 14 (service, track, path) | Class-dependent |
| transportation_name | 8 (motorway refs) → 14 | Class-dependent |
| aerodrome_label | 8 | International airports start lower |
| aeroway | 10 | Runways, taxiways |
| water_name | 0 (ocean) → 14 (ponds) | Class-dependent |
| poi | 12 → 14 | Filtered by `rank` |
| building | 13 | Full detail at z14 |
| housenumber | 14 | z14 only, adds significant tile weight |

Use `rank` (where present) to cap label density at a given zoom.

## Conventions

### Names and localization

Every labeled layer exposes:

- `name` — raw OSM `name` tag (primary/local language).
- `name:xx` — one field per language present on the feature (e.g. `name:en`, `name:de`, `name:fr`, `name:ja`, `name:pl`, …). These live in the tile as individual fields; style filters use `get`/`coalesce`.
- `name_en` / `name_de` — **deprecated** fallback fields (`name:en` or `name`, `name:de` or `name:en` or `name`). Retained for old styles; new styles should read `name:xx` directly.

Typical MapLibre expression for multi-language labels:

```json
["coalesce", ["get", "name:en"], ["get", "name"]]
```

### `class` vs `subclass`

- `class` — a small, stable set of high-level buckets. Drive paint (colour, line-width, visibility) from `class`.
- `subclass` — the raw OSM tag value (or close to it). Drive exceptions and icon lookups from `subclass`.

### `rank`

Present on label-producing layers (`place`, `poi`, `park`, `mountain_peak`). `rank=1` is most important; density increases as rank grows. Use with zoom steps:

```json
["step", ["zoom"], false, 7, ["<=", ["get", "rank"], 2], 10, true]
```

### `brunnel`

On linework that can cross other linework — `transportation`, `transportation_name`, `waterway`, `water`. Values: `bridge`, `tunnel`, `ford`. Drive rendering order (casings under water for tunnels, casings over for bridges) and line styling.

### `intermittent`

On water layers. `0` = permanent, `1` = intermittent. Typically rendered with dashed strokes for streams or lighter fill for lakes.

## Tile buffer sizes

Buffer is the pixel margin each tile carries beyond its `(z, x, y)` bounds, used for smooth edge rendering (labels and lines that cross tile seams). Larger buffer = larger tiles.

| Buffer (px) | Layers |
| --- | --- |
| 4 | `aeroway`, `boundary`, `building`, `landcover`, `landuse`, `park`, `transportation`, `water`, `waterway` |
| 8 | `housenumber`, `transportation_name` |
| 64 | `aerodrome_label`, `mountain_peak`, `poi` |
| 256 | `place`, `water_name` |

Large buffers on labeling layers (`place`, `water_name`) let big labels anchor off-tile so they don't disappear when the anchor is beyond the tile edge.

## Imposm3 and SQL pipeline

OpenMapTiles generates tiles with a pipeline:

1. **Import** with [imposm3](https://github.com/omniscale/imposm3) using `mapping.yaml` per layer — filters OSM keys into Postgres tables.
2. **Transform** with per-layer SQL (`*.sql`) — computes `class`, `subclass`, `rank`, generalizations.
3. **Query at render time** via `layer_<name>(!bbox!, z(!scale_denominator!))` PL/pgSQL functions.
4. **Encode** into MVT (typically with [tilelive](https://github.com/mapbox/tilelive) / [t-rex](https://t-rex.tileserver.ch/) / Tileserver).

You never need to touch this stack to style tiles — the attributes above are the only contract. But if a style asks for a value that the schema doesn't expose, this is where it would have to be added.

## Versioning and compatibility notes

- `name_en` / `name_de` fields are marked deprecated in favor of `name:en` / `name:de`; plan migrations accordingly.
- `agg_stop` on `poi` is marked experimental — do not rely on it in production styles.
- `level` / `layer` / `indoor` on `transportation_name` are experimental, steps/footways only.
- Some providers (MapTiler) may expose small extensions (e.g., additional POI classes or route tagging); test styles against the exact source you render from.

## References

- Schema docs: <https://openmaptiles.org/schema/>
- Source (pinned): <https://github.com/openmaptiles/openmaptiles/tree/v3.16> — canonical layer YAMLs. Upstream `master` may have diverged; bump the tag before re-verifying.
- OSM wiki — Map features: <https://wiki.openstreetmap.org/wiki/Map_features>
- Natural Earth: <https://www.naturalearthdata.com/>
- OSM polygons (water): <http://osmdata.openstreetmap.de/>
- Lake centerlines: <https://github.com/openmaptiles/osm-lakelines>
