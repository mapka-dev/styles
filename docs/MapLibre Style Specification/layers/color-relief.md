# `color-relief` layer

Elevation-to-colour ramp applied to a [`raster-dem`](../sources.md#raster-dem) source. Produces a hypsometric tint.

```json
{
  "id": "elevation-tint",
  "type": "color-relief",
  "source": "terrain-dem",
  "paint": {
    "color-relief-opacity": 1,
    "color-relief-color": [
      "interpolate", ["linear"], ["elevation"],
      -500, "#1f3a6b",
         0, "#2f4e7c",
       100, "#becf9c",
       500, "#a39361",
      1500, "#8a6f3b",
      3000, "#c7bfb8",
      5000, "#ffffff"
    ]
  }
}
```

The ramp input is the [`elevation`](../expressions.md) expression — returns metres above the DEM's vertical datum. Mirrors `heatmap-color` + `["heatmap-density"]`. *Since GL JS 5.6.0, Native Android 13.0.0, iOS 6.24.0.*

## Paint properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `color-relief-opacity` | number [0, 1] | `1` | Layer opacity. *transitionable.* |
| `color-relief-color` | color expression | — | Elevation → colour ramp. Typically an `interpolate` on elevation. *transitionable.* |
| `resampling` | `"linear"` \| `"nearest"` | `"linear"` | DEM sampler. |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Composition

`color-relief` typically stacks like this:

1. **`color-relief`** — base hypsometric tint.
2. **`hillshade`** — relief shading on top (with colour alpha, not opacity).
3. **`fill`/`line`/`symbol`** — cartography over the top.

Keep `color-relief-opacity: 1` for a solid tint, then let the hillshade do the dimming with its coloured shadows.

## Design tips

- Start the ramp below sea level (negative) if you display bathymetry; otherwise coastal zeros clamp to the lowest band.
- Smooth ramps: keep stops ~evenly spaced in elevation for natural gradients.
- Steppy ramps: use `["step", ["elevation"], …]` for classified contour-band cartography.
- Preserve colour-blind legibility — avoid green-to-red without a lightness ramp; Colorbrewer's `YlOrBr` is a safe starting point.

## Gotchas

- Requires a valid DEM source; using a plain raster source silently does nothing.
- `color-relief-color` must return a colour; null/transparent at any band leaves gaps.
- Not affected by [`light`](../light.md) — colour ramp is pure data-driven.
- Requires GL JS ≥ 5.6.0 / Native Android ≥ 13.0.0 / Native iOS ≥ 6.24.0. Older SDKs silently ignore the layer.
