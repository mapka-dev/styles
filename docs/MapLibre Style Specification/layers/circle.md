# `circle` layer

Cheap point rendering. Just a filled circle with optional stroke. Drawn by the shader — no sprite, no collision, no labels.

```json
{
  "id": "chargers",
  "type": "circle",
  "source": "ev",
  "paint": {
    "circle-radius": 5,
    "circle-color": "#ff7a00",
    "circle-stroke-width": 1,
    "circle-stroke-color": "#ffffff"
  }
}
```

**Geometry:** `Point`, `MultiPoint`.

## Paint properties

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `circle-radius` | number [0, ∞) | `5` | px | Radius. *data-driven, transitionable.* |
| `circle-color` | color | `"#000000"` | — | Fill colour. *data-driven, transitionable.* |
| `circle-blur` | number | `0` | — | Fractional blur relative to radius. `1` ≈ fully soft edge. *data-driven, transitionable.* |
| `circle-opacity` | number [0,1] | `1` | — | Fill opacity. *data-driven, transitionable.* |
| `circle-translate` | `[x, y]` | `[0, 0]` | px | *transitionable.* |
| `circle-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | |
| `circle-pitch-scale` | `"map"` \| `"viewport"` | `"map"` | — | `map` scales with zoom/pitch. `viewport` keeps constant screen size. |
| `circle-pitch-alignment` | `"map"` \| `"viewport"` | `"viewport"` | — | `map` tilts with the world (ellipses when pitched). `viewport` stays circular. |
| `circle-stroke-width` | number [0, ∞) | `0` | px | Outline width. *data-driven, transitionable.* |
| `circle-stroke-color` | color | `"#000000"` | — | Outline colour. *data-driven, transitionable.* |
| `circle-stroke-opacity` | number [0,1] | `1` | — | Outline opacity. *data-driven, transitionable.* |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `circle-sort-key` | number | — | Draw-order key inside the layer. Lower = drawn first. *data-driven.* |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Pitch behaviour matrix

Combines `circle-pitch-scale` × `circle-pitch-alignment`:

| Scale | Alignment | Result when pitched |
| --- | --- | --- |
| `viewport` | `viewport` | Always the same screen size and shape. Best for data-viz markers. |
| `viewport` | `map` | Constant size, but elliptical at high pitch. Rare. |
| `map` | `viewport` | Scales with zoom, always circular. **Default.** |
| `map` | `map` | Scales with zoom and flattens to an ellipse when pitched. Looks glued to the ground. |

## When to use

- ✅ Thousands of undifferentiated points (transit stops, chargers, sensor readings).
- ✅ Clusters from `geojson` sources (style with `["has", "point_count"]`).
- ✅ Data-driven size/colour bubbles.
- ❌ Anything with a recognisable icon → use [`symbol`](symbol.md).
- ❌ Density visualisation → use [`heatmap`](heatmap.md).

## Gotchas

- `circle-blur` is unitless and relative to radius — huge radii with small blur look like hard circles; small radii with blur ≥ 0.5 look like smudges.
- `circle-stroke-*` is drawn **outside** the fill's `circle-radius`, i.e. the hit target grows by `circle-stroke-width`.
- Stacking hundreds of thousands of circles is cheap on the GPU but can still hitch if every feature is data-driven across many properties — prefer paint-expression constants where possible.
- Circles don't collide with labels — they'll happily render under a `symbol` layer's text.
