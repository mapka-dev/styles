# `raster` layer

Displays pixel tiles from a [`raster`](../sources.md#raster), [`image`](../sources.md#image), or [`video`](../sources.md#video) source. No feature geometry, no filtering — you get a picture per tile with paint-level colour adjustments.

```json
{
  "id": "satellite",
  "type": "raster",
  "source": "sat",
  "paint": {
    "raster-opacity": 1,
    "raster-brightness-max": 0.95,
    "raster-saturation": -0.1,
    "raster-contrast": 0.1
  }
}
```

## Paint properties

| Property | Type | Default | Range | Notes |
| --- | --- | --- | --- | --- |
| `raster-opacity` | number | `1` | [0, 1] | Layer opacity. *transitionable.* |
| `raster-hue-rotate` | number | `0` | deg, [0, 360] | Hue rotation applied per-pixel. *transitionable.* |
| `raster-brightness-min` | number | `0` | [0, 1] | Output black level. |
| `raster-brightness-max` | number | `1` | [0, 1] | Output white level. |
| `raster-saturation` | number | `0` | [-1, 1] | -1 = grey, 0 = unchanged, +1 = fully saturated. |
| `raster-contrast` | number | `0` | [-1, 1] | Negative compresses, positive stretches. |
| `raster-resampling` | `"linear"` \| `"nearest"` | `"linear"` | — | Sampler when upscaling/downscaling tiles. `nearest` preserves crisp pixel boundaries (useful for classified rasters). |
| `raster-fade-duration` | number | `300` | ms | Cross-fade time between old and new tile sets when zoom crosses a tile boundary. |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Source compatibility

| Source type | Works? | Notes |
| --- | --- | --- |
| `raster` | ✓ | Primary use. |
| `image` | ✓ | Single-image georeferenced overlay. |
| `video` | ✓ | Video decoded per frame. |
| `raster-dem` | ✗ | Use `hillshade` or `color-relief`. |

## Common recipes

**Darken satellite for overlay** — push `raster-brightness-max` down and `raster-contrast` up:

```json
{ "raster-brightness-max": 0.8, "raster-contrast": 0.2 }
```

**Colour-blind-friendly mute** — `raster-saturation: -0.3`.

**Sharp nearest-neighbor for classified land-cover rasters** — `raster-resampling: "nearest"`.

## Performance

- Raster layers are GPU-cheap — one draw per tile with a single texture sample.
- Many stacked raster layers with partial opacity add overdraw; keep the stack ≤ 3 for good fps.
- `raster-fade-duration: 0` disables the cross-fade; useful when transitioning between precisely aligned source sets.

## Gotchas

- `raster-hue-rotate` is applied before saturation/contrast; colours may land unexpectedly if you combine them.
- `raster-brightness-min > raster-brightness-max` inverts the mapping — technically legal, visually jarring.
- No per-feature data-driven properties: rasters don't have features.
- Changing source tile alignment mid-session (e.g. rotating URL slots) can leave stale tiles — flush via `map.style.sourceCaches[id].clearTiles()`.
