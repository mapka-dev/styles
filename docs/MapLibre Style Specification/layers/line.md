# `line` layer

Stroked lines. The most expressive 2D primitive — dashes, patterns, gradients, per-feature width.

```json
{
  "id": "road-primary",
  "type": "line",
  "source": "openmaptiles",
  "source-layer": "transportation",
  "filter": ["==", ["get", "class"], "primary"],
  "layout": { "line-join": "round", "line-cap": "round" },
  "paint": {
    "line-color": "#ffffff",
    "line-width": ["interpolate", ["linear"], ["zoom"], 10, 1, 18, 12]
  }
}
```

**Geometry:** `LineString`, `MultiLineString`, and the boundaries of `Polygon` (rendered as closed rings).

## Paint properties

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `line-opacity` | number [0,1] | `1` | — | *data-driven, transitionable.* |
| `line-color` | color | `"#000000"` | — | Stroke colour. Suppressed by `line-pattern`/`line-gradient`. *data-driven, transitionable.* |
| `line-translate` | `[x, y]` | `[0, 0]` | px | Render-time offset. *transitionable.* |
| `line-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | |
| `line-width` | number [0, ∞) | `1` | px | Stroke thickness. *data-driven, transitionable.* |
| `line-gap-width` | number [0, ∞) | `0` | px | If > 0, draws two parallel strokes `line-gap-width` apart — classic casing effect. *data-driven, transitionable.* |
| `line-offset` | number | `0` | px | Perpendicular offset. Useful for tram lines, dual carriageways. *data-driven, transitionable.* |
| `line-blur` | number [0, ∞) | `0` | px | Gaussian-ish blur. *data-driven, transitionable.* |
| `line-dasharray` | `number[]` | — | px multiples of `line-width` | Dash pattern, pairs of on/off lengths. Suppressed by `line-pattern`. *transitionable.* |
| `line-pattern` | resolvedImage | — | — | Sprite icon tiled along the line. *data-driven (since 0.49.0), transitionable.* |
| `line-gradient` | color expression | — | — | Gradient along line progress. Requires source `lineMetrics: true`. Use `["interpolate", ["linear"], ["line-progress"], 0, c0, 1, c1]`. |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `line-cap` | `"butt"` \| `"round"` \| `"square"` | `"butt"` | End caps. `round` adds a half-circle; `square` extends by half `line-width`. |
| `line-join` | `"bevel"` \| `"round"` \| `"miter"` | `"miter"` | Junction style. *data-driven.* |
| `line-miter-limit` | number | `2` | At miter joins, angles sharper than this are beveled instead. |
| `line-round-limit` | number | `1.05` | At round joins, shallow angles are beveled. |
| `line-sort-key` | number | — | Within-layer draw order for overlaps. *data-driven.* |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Patterns (casings, outlines, dashes)

**Casing** (outer stroke + inner fill): two layers, drawn bottom→top.

```json
[
  { "id": "road-case", "type": "line", "paint": { "line-color": "#999", "line-width": 8 } },
  { "id": "road-fill", "type": "line", "paint": { "line-color": "#fff", "line-width": 6 } }
]
```

or single-layer with `line-gap-width`:

```json
{
  "type": "line",
  "paint": {
    "line-color": "#999",
    "line-width": 2,
    "line-gap-width": 6
  }
}
```

**Dashed + cased** — use two layers, only the top layer dashed.

**Scale-aware dashes** — `line-dasharray` values are multiples of `line-width`. Keep `line-width` zoom-driven and the dash ratio stays constant at every scale.

## Gradients and patterns

- `line-gradient` needs the source's `lineMetrics: true` (geojson) or line-progress support (vector tiles — rarely exposed). On vector tiles it usually silently does nothing.
- `line-pattern` tiles horizontally along the line; image height = `line-width` after scaling. Designed-for-purpose sprites (arrows, railroad ties) work best.

## Gotchas

- Huge `line-width` at high zoom triggers seam artifacts at tile edges because line extents are clipped per-tile. Use `buffer` on the source to hide seams.
- `line-dasharray` with many stops is expensive — keep to 2–4 pair elements.
- `line-offset` on closed rings (polygon boundaries) can produce self-intersections at sharp angles.
- `line-cap: square`/`round` adds visible extent past the endpoint — matters for pixel-perfect placements.
- A `line` layer over a vector source that has polygons renders the polygon *rings* as lines. Use `filter: ["==", ["geometry-type"], "LineString"]` to exclude polygon outlines if you want only true lines.
