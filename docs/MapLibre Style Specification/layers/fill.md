# `fill` layer

Flat polygon fills. Optional outline stroke and sprite pattern.

```json
{
  "id": "water",
  "type": "fill",
  "source": "openmaptiles",
  "source-layer": "water",
  "paint": {
    "fill-color": "#a0c8f0",
    "fill-outline-color": "#6faad2"
  }
}
```

**Geometry:** `Polygon`, `MultiPolygon`. Other geometries are skipped.

## Paint properties

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `fill-antialias` | boolean | `true` | — | Edge smoothing. Turning off gives blocky but faster fills. |
| `fill-opacity` | number [0,1] | `1` | — | Layer opacity. *data-driven, transitionable.* |
| `fill-color` | color | `"#000000"` | — | Fill colour. Ignored if `fill-pattern` set. *data-driven, transitionable.* |
| `fill-outline-color` | color | matches `fill-color` | — | Outline colour. Requires `fill-antialias: true`. *data-driven, transitionable.* |
| `fill-translate` | `[x, y]` | `[0, 0]` | px | Pixel offset applied at draw time. *transitionable.* |
| `fill-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | Whether translation rotates with the map. |
| `fill-pattern` | resolvedImage | — | — | Sprite icon name for tiled pattern. Suppresses `fill-color`. *transitionable.* |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `fill-sort-key` | number | — | Draw order for overlapping features within this layer. Lower = drawn first. *data-driven.* |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Semantics and gotchas

- **Outline without `fill-antialias: true` is invisible.** This is the spec's most common footgun.
- `fill-outline-color` is drawn as a 1-pixel line at the polygon edge regardless of zoom. For thicker or zoom-scaled outlines, add a separate `line` layer — that's the canonical pattern.
- `fill-pattern` is tiled at its native size. Patterns with transparency let `fill-color` bleed through behind (on some renderers).
- Pre-split polygons (e.g. OpenMapTiles water) produce visible seams if you try to outline them. Source a dedicated edge layer instead.
- `fill-translate` is a render-time offset, not a geometry change. Useful for faked drop shadows.
- No per-vertex or per-edge colouring — for gradient fills, bake into `fill-pattern` or use `fill-extrusion` with height 0 and a lit surface.
