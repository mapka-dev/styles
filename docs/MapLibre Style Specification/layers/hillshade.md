# `hillshade` layer

Client-side hillshading from a [`raster-dem`](../sources.md#raster-dem) source. Cheaper and more flexible than pre-baked hillshade rasters, and respects current map tilt and bearing.

```json
{
  "id": "hillshade",
  "type": "hillshade",
  "source": "terrain-dem",
  "paint": {
    "hillshade-exaggeration": 0.5,
    "hillshade-illumination-direction": 335,
    "hillshade-illumination-altitude": 45,
    "hillshade-shadow-color": "#4a4033",
    "hillshade-highlight-color": "#fffaf0",
    "hillshade-accent-color": "#2e241a",
    "hillshade-method": "default"
  }
}
```

## Paint properties

| Property | Type | Default | Unit / Range | Notes |
| --- | --- | --- | --- | --- |
| `hillshade-illumination-direction` | number | `335` | deg [0, 360) | Compass bearing of the light source. `0` = north. *transitionable.* |
| `hillshade-illumination-altitude` | number | `45` | deg [0, 90] | Light angle from horizon. Higher = steeper, harder shadows. *transitionable.* |
| `hillshade-illumination-anchor` | `"map"` \| `"viewport"` | `"viewport"` | — | `map` pins the light to a geographic direction; `viewport` keeps it relative to the screen. |
| `hillshade-exaggeration` | number [0, 1] | `0.43` | — | Strength of the relief effect. *transitionable.* |
| `hillshade-shadow-color` | color | `"#000000"` | — | Colour of shaded slopes. *transitionable.* |
| `hillshade-highlight-color` | color | `"#ffffff"` | — | Colour of illuminated slopes. *transitionable.* |
| `hillshade-accent-color` | color | `"#000000"` | — | Accent tint on steep faces — a subtle second-shadow. *transitionable.* |
| `hillshade-method` | `"default"` \| `"multidirectional"` | `"default"` | — | Multidirectional lights from several azimuths, producing softer relief that doesn't wash out along the principal light direction. |
| `resampling` | `"linear"` \| `"nearest"` | `"linear"` | — | DEM sampler. `nearest` looks blocky. |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Common recipes

**Classic relief** — white highlights, black shadows, moderate exaggeration:

```json
{
  "hillshade-exaggeration": 0.5,
  "hillshade-highlight-color": "#ffffff",
  "hillshade-shadow-color": "#000000"
}
```

**Warm cartographic relief** — tinted highlights and shadows to match a printed-map aesthetic:

```json
{
  "hillshade-exaggeration": 0.4,
  "hillshade-highlight-color": "rgba(255, 247, 230, 0.7)",
  "hillshade-shadow-color":    "rgba(60, 40, 20, 0.7)",
  "hillshade-accent-color":    "rgba(80, 50, 20, 0.5)"
}
```

**Stack under terrain colour** — place the `color-relief` layer first, then `hillshade` above with moderate alpha (done via colour alpha, not `opacity`).

## `hillshade-method` — single vs. multidirectional

- `default` — one light source; classic "sun" look. Ridgelines parallel to the light direction wash out.
- `multidirectional` — averages shading from several azimuths. More even, less directional.

## Gotchas

- No generic `hillshade-opacity`. Use alpha in `hillshade-*-color` to control layer strength.
- `hillshade-exaggeration` is capped at 1 — higher values silently clamp.
- `hillshade-illumination-anchor: map` + runtime bearing changes = shadows move with the compass; `viewport` keeps shadows pointing "down-left" regardless. Pick based on whether relief realism or legibility matters more.
- `resampling: nearest` on a low-resolution DEM looks aliased; reserve for special cases.
- Does not interact with [`light`](../light.md). Hillshade has its own lighting model.
