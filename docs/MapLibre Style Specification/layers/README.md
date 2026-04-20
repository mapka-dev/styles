# MapLibre Layer Types — Index

One file per layer type. See [`../layers.md`](../layers.md) for the shared (common) layer properties, rendering order, and filter/zoom semantics.

| Type | Geometry | Typical source | File |
| --- | --- | --- | --- |
| `background` | — | — | [background.md](background.md) |
| `fill` | Polygon | vector / geojson | [fill.md](fill.md) |
| `line` | LineString | vector / geojson | [line.md](line.md) |
| `symbol` | Point / LineString | vector / geojson | [symbol.md](symbol.md) |
| `circle` | Point | vector / geojson | [circle.md](circle.md) |
| `heatmap` | Point | vector / geojson | [heatmap.md](heatmap.md) |
| `fill-extrusion` | Polygon | vector / geojson | [fill-extrusion.md](fill-extrusion.md) |
| `raster` | — | raster / image / video | [raster.md](raster.md) |
| `hillshade` | — | raster-dem | [hillshade.md](hillshade.md) |
| `color-relief` | — | raster-dem | [color-relief.md](color-relief.md) |

## Conventions used in each file

- **Paint properties** — pixel colour/opacity/blur. Most are transitionable.
- **Layout properties** — shape/placement/text. Not transitionable.
- Every paint/layout property table row: `name | type | default | unit / range | notes`.
- Property flags (where relevant):
  - *data-driven* — supports `["get", …]`, `["feature-state", …]` etc.
  - *zoom-driven* — supports `["zoom"]` in `interpolate`/`step`.
  - *transitionable* — obeys [`transition`](../transition.md).
