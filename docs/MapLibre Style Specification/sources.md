# `sources`

Where the map gets its data. **Required.** An object keyed by source ID; each value is a source object identified by its `type` discriminant.

```json
{
  "sources": {
    "openmaptiles": {
      "type": "vector",
      "url": "https://example.com/tiles.json"
    },
    "satellite": {
      "type": "raster",
      "tiles": ["https://tiles.example.com/{z}/{x}/{y}.jpg"],
      "tileSize": 256
    }
  }
}
```

Source IDs are how [`layers`](layers.md) reference their data (`"source": "openmaptiles"`). A source with no layer pointing at it is silently unused — the renderer never fetches it.

## Types

| `type` | Payload | Typical use |
| --- | --- | --- |
| `vector` | MVT / MLT tiles | OpenMapTiles, MapTiler, Mapbox Streets |
| `raster` | PNG/JPEG tiles | Satellite, OSM raster, hillshading bakes |
| `raster-dem` | Elevation-encoded raster | Terrain, hillshade inputs |
| `geojson` | GeoJSON URL or inline | Live overlays, clustering |
| `image` | Single image, georeferenced | Floor plans, historical maps |
| `video` | Single video, georeferenced | Live overlays, animations |

---

## `vector`

Mapbox Vector Tile format (or MapLibre Tiles via `encoding: "mlt"`).

| Prop | Type | Default | Notes |
| --- | --- | --- | --- |
| `type` | `"vector"` | — | Required discriminator. |
| `url` | string | — | TileJSON URL. Provides `tiles`, `bounds`, `minzoom`, `maxzoom`, `attribution` automatically. |
| `tiles` | `string[]` | — | Explicit tile URL templates with `{z}`, `{x}`, `{y}`. Use `url` *or* `tiles`, not both. |
| `bounds` | `[w,s,e,n]` | `[-180,-85.051129,180,85.051129]` | Bounding box for pre-filtering tile requests. |
| `scheme` | `"xyz"`\|`"tms"` | `"xyz"` | TMS flips Y. |
| `minzoom` | number | `0` | Tile zoom floor. |
| `maxzoom` | number | `22` | Tile zoom ceiling. Overzooming is handled by the renderer past this. |
| `attribution` | string | — | Shown in the map attribution control. HTML allowed. |
| `promoteId` | string \| object | — | Promote a feature property to the feature `id`. Object form: `{ "layer": "propName", … }`. |
| `volatile` | boolean | `false` | If true, tiles are not persisted in the local cache. **Native only** (Android ≥ 9.3.0, iOS ≥ 5.10.0) — GL JS upstream is `wontfix`, the property is ignored on web. |
| `encoding` | `"mvt"`\|`"mlt"` | `"mvt"` | Tile encoding. `mlt` (MapLibre Tiles) — GL JS ≥ 5.12.0, Native Android ≥ 12.1.0, iOS ≥ 6.20.0. |

---

## `raster`

Generic raster tiles (PNG/JPEG/WebP).

| Prop | Type | Default | Notes |
| --- | --- | --- | --- |
| `type` | `"raster"` | — | Required. |
| `url` | string | — | TileJSON URL. |
| `tiles` | `string[]` | — | Tile URL templates. |
| `bounds` | `[w,s,e,n]` | `[-180,-85.051129,180,85.051129]` | Pre-filter box. |
| `minzoom` | number | `0` | |
| `maxzoom` | number | `22` | |
| `tileSize` | number | `512` | Logical pixel size per tile. Use `256` for OSM-style tiles, `512` for most vendor raster tiles. |
| `scheme` | `"xyz"`\|`"tms"` | `"xyz"` | |
| `attribution` | string | — | |
| `volatile` | boolean | `false` | **Native only** (see `vector.volatile` note). |

---

## `raster-dem`

Elevation-encoded raster tiles for [`terrain`](terrain.md) and `hillshade` layers.

| Prop | Type | Default | Notes |
| --- | --- | --- | --- |
| `type` | `"raster-dem"` | — | Required. |
| `url` | string | — | TileJSON URL. |
| `tiles` | `string[]` | — | Tile URL templates. |
| `bounds` | `[w,s,e,n]` | `[-180,-85.051129,180,85.051129]` | |
| `minzoom` | number | `0` | |
| `maxzoom` | number | `22` | |
| `tileSize` | number | `512` | |
| `attribution` | string | — | |
| `encoding` | `"terrarium"` \| `"mapbox"` \| `"custom"` | `"mapbox"` | Height decoding. `mapbox` = `(R*256² + G*256 + B) * 0.1 − 10000`; `terrarium` = `(R*256 + G + B/256) − 32768`. `"custom"` is **GL JS ≥ 3.4.0 only** — Native tracks [maplibre-native #2783](https://github.com/maplibre/maplibre-native/issues/2783). |
| `redFactor` | number | `1` | Only relevant for `encoding: "custom"`. GL JS ≥ 3.4.0. |
| `greenFactor` | number | `1` | Only relevant for `encoding: "custom"`. GL JS ≥ 3.4.0. |
| `blueFactor` | number | `1` | Only relevant for `encoding: "custom"`. GL JS ≥ 3.4.0. |
| `baseShift` | number | `0` | Only relevant for `encoding: "custom"`. GL JS ≥ 3.4.0. |
| `volatile` | boolean | `false` | **Native only** (see `vector.volatile` note). |

Custom decoding: `height = redFactor*R + greenFactor*G + blueFactor*B + baseShift`.

---

## `geojson`

Inline or remote GeoJSON. Good for live overlays and clustering — not for large static datasets (use vector tiles).

| Prop | Type | Default | Notes |
| --- | --- | --- | --- |
| `type` | `"geojson"` | — | Required. |
| `data` | URL \| GeoJSON | — | **Required.** FeatureCollection, Feature, or Geometry. |
| `maxzoom` | number | `18` | Internal vector-tile generation ceiling. |
| `attribution` | string | — | |
| `buffer` | number (0–512) | `128` | Tile-edge buffer in pixels for rendering continuity. |
| `filter` | filter expression | — | Applied *before* tiling. Cheaper than layer-level filters for drop-the-majority cases. |
| `tolerance` | number | `0.375` | Douglas-Peucker simplification threshold (higher = simpler). |
| `cluster` | boolean | `false` | Enable point clustering. |
| `clusterRadius` | number | `50` | Cluster pixel radius. |
| `clusterMaxZoom` | number | `maxzoom - 1` | Cluster up to this zoom; beyond it, points un-cluster. |
| `clusterMinPoints` | number | `2` | Minimum points to form a cluster. |
| `clusterProperties` | object | — | Aggregations. `{ "sum": ["+", ["get", "weight"]] }`. |
| `lineMetrics` | boolean | `false` | Enables `line-progress` expression and line-gradient. |
| `generateId` | boolean | `false` | Auto-assign numeric feature IDs. Required for `feature-state` on ID-less features. |
| `promoteId` | string \| object | — | Promote a feature property to `id`. |

### Clustering

When `cluster: true`, point features are clustered into super-points with properties:

- `cluster: true`
- `cluster_id: <number>`
- `point_count: <number>`
- `point_count_abbreviated: <string>`
- … plus any aggregations from `clusterProperties`.

Use `["has", "point_count"]` in a layer filter to style clusters vs. leaves.

---

## `image`

A single image positioned by four corner coordinates. No tiling.

| Prop | Type | Notes |
| --- | --- | --- |
| `type` | `"image"` | Required. |
| `url` | string | **Required.** Image URL. |
| `coordinates` | `[[lng,lat], [lng,lat], [lng,lat], [lng,lat]]` | **Required.** Four corners, clockwise from top-left. |

Render with a `raster` layer — the layer type dispatches to whichever source is hooked up.

---

## `video`

A single HTML5 video positioned by four corner coordinates.

| Prop | Type | Notes |
| --- | --- | --- |
| `type` | `"video"` | Required. |
| `urls` | `string[]` | **Required.** Browser picks the first supported format — supply MP4 *and* WebM for coverage. |
| `coordinates` | `[[lng,lat]×4]` | **Required.** Clockwise from top-left. |

Also rendered with a `raster` layer.

---

## Cross-cutting notes

- **`url` vs. `tiles`**: when both are present, `url` (TileJSON) wins. Most engines will still read and merge.
- **TileJSON** is fetched once at style load. If it fails, the source errors; all its layers go silent.
- **`promoteId`** lets a stable property (e.g. `osm_id`) become the feature's identity — needed because vector tiles don't preserve string IDs. Without it, `feature-state` loses its reference after each tile reload.
- **CORS** applies to every URL. If you host tiles privately, send `Access-Control-Allow-Origin: *` or restrict to your map's origin.
- **Attribution** is concatenated across sources in the UI. Keep each terse.
