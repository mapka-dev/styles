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
    "hillshade-method": "standard"
  }
}
```

## Paint properties

| Property | Type | Default | Unit / Range | Notes |
| --- | --- | --- | --- | --- |
| `hillshade-illumination-direction` | numberArray | `335` | deg [0, 359] | Compass bearing of the light source. `0` = north. Accepts an array of up to five angles for `hillshade-method: multidirectional`. *transitionable.* |
| `hillshade-illumination-altitude` | numberArray | `45` | deg [0, 90] | Light angle from horizon. Higher = steeper, harder shadows. Array form pairs one altitude per illumination direction for `multidirectional`. *transitionable.* |
| `hillshade-illumination-anchor` | `"map"` \| `"viewport"` | `"viewport"` | — | `map` pins the light to a geographic direction; `viewport` keeps it relative to the screen. |
| `hillshade-exaggeration` | number [0, 1] | `0.5` | — | Strength of the relief effect. *transitionable.* |
| `hillshade-shadow-color` | colorArray | `"#000000"` | — | Colour of shaded slopes. Array form pairs one entry per illumination direction for `multidirectional`. *transitionable.* |
| `hillshade-highlight-color` | colorArray | `"#ffffff"` | — | Colour of illuminated slopes. Array form pairs with directions for `multidirectional`. *transitionable.* |
| `hillshade-accent-color` | color | `"#000000"` | — | Accent tint on steep faces — a subtle second-shadow. *transitionable.* |
| `hillshade-method` | `"standard"` \| `"basic"` \| `"combined"` \| `"igor"` \| `"multidirectional"` | `"standard"` | — | Relief algorithm. *Since GL JS 5.5.0, Native Android 13.0.0, iOS 6.24.0.* |
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

## `hillshade-method` — algorithm variants

- `standard` — legacy default. One light source, classic "sun" look. Ridgelines parallel to the light direction wash out.
- `basic` — simple Lambertian model; reflected intensity scales with the cosine of the angle between the light and the surface normal. Similar to GDAL `gdaldem` default.
- `combined` — intensity scales with slope as well as aspect. Similar to GDAL `gdaldem -combined`.
- `igor` — Igor's relief algorithm. Tries to minimise overwriting other map features — useful when hillshade sits under dense cartography.
- `multidirectional` — averages shading from several azimuths. Softer relief, less directional bias. Feeds arrays of directions via `hillshade-illumination-direction`.

## Gotchas

- No generic `hillshade-opacity`. Use alpha in `hillshade-*-color` to control layer strength.
- `hillshade-exaggeration` clamps to `[0, 1]`; negative values aren't supported.
- `hillshade-method: standard` is the default (older docs / tooling sometimes call this `"default"` — the spec value is `"standard"`).
- `hillshade-illumination-anchor: map` + runtime bearing changes = shadows move with the compass; `viewport` keeps shadows pointing "down-left" regardless. Pick based on whether relief realism or legibility matters more.
- `resampling: nearest` on a low-resolution DEM looks aliased; reserve for special cases.
- Does not interact with [`light`](../light.md). Hillshade has its own lighting model.
