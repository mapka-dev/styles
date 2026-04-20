# `heatmap` layer

Density field from points. Each point contributes a kernel (Gaussian-ish) to a density image, then the image is coloured by a ramp and drawn.

```json
{
  "id": "density",
  "type": "heatmap",
  "source": "incidents",
  "paint": {
    "heatmap-radius": 20,
    "heatmap-weight": ["interpolate", ["linear"], ["get", "severity"], 0, 0, 10, 1],
    "heatmap-intensity": 1,
    "heatmap-opacity": 0.8,
    "heatmap-color": [
      "interpolate", ["linear"], ["heatmap-density"],
      0,    "rgba(0,0,0,0)",
      0.1,  "#3366ff",
      0.5,  "#66ffff",
      0.8,  "#ffff00",
      1.0,  "#ff0000"
    ]
  }
}
```

**Geometry:** `Point`, `MultiPoint`.

## Paint properties

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `heatmap-radius` | number [1, ∞) | `30` | px | Kernel radius. Larger = smoother field, more overlap. *data-driven (per-feature), transitionable.* |
| `heatmap-weight` | number [0, ∞) | `1` | — | Per-point contribution. Typical use: map an attribute (severity, magnitude) through `interpolate`. *data-driven.* |
| `heatmap-intensity` | number [0, ∞) | `1` | — | Global multiplier applied to the entire density field. Often driven by zoom so sparser zooms still look dense. *zoom-driven, transitionable.* |
| `heatmap-color` | color expression | `["interpolate", ["linear"], ["heatmap-density"], 0, "rgba(0,0,255,0)", 0.1, "royalblue", 0.3, "cyan", 0.5, "lime", 0.7, "yellow", 1, "red"]` | — | Maps density [0,1] → colour. Must use `["heatmap-density"]` as input. |
| `heatmap-opacity` | number [0,1] | `1` | — | Layer opacity. *transitionable.* |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## How density is computed

1. For each feature, draw a kernel of radius `heatmap-radius` and amplitude `heatmap-weight`.
2. Sum kernels into a density texture.
3. Multiply the density by `heatmap-intensity`.
4. Clamp to [0, 1] (the max density you can "see" — overlap beyond 1 is capped).
5. For each pixel, look up `heatmap-color[density]` and multiply alpha by `heatmap-opacity`.

Transparency at density 0 is important — leave the ramp starting with `rgba(*, 0)` so empty areas don't get a flat tint.

## Design tips

- **Use zoom-driven `heatmap-intensity`** so the ramp still hits high density at low zoom when points are sparse:

  ```json
  "heatmap-intensity": ["interpolate", ["linear"], ["zoom"], 0, 1, 12, 3]
  ```

- **Use zoom-driven `heatmap-radius`** so the kernel grows with scale (constant world size):

  ```json
  "heatmap-radius": ["interpolate", ["linear"], ["zoom"], 0, 2, 12, 30]
  ```

- **Fade to circles past a zoom** — at high zoom individual points matter more than density; swap to a `circle` layer above zoom `N` and cap the heatmap with `maxzoom: N`.

- **Weighting** — if `heatmap-weight` can exceed 1 per point, you'll oversaturate faster; conversely, very small weights need larger `heatmap-intensity` to register.

## Gotchas

- `heatmap-color` **must** reference `["heatmap-density"]` as its input. Any other expression silently produces transparent output.
- Heatmaps ignore most z-ordering; they're drawn as a single pass per layer.
- Cannot render on polygons or lines — only point geometries are counted.
- `heatmap-opacity` doesn't just dim colours, it dims the whole texture (alpha multiplied). Dropping it below ~0.4 usually looks washed-out.
- Extreme feature density (> ~100k points in view) will still hitch because the kernel-sum pass is per-pixel × per-point. Bin server-side for huge datasets.
