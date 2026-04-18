# `fill-extrusion` layer

3D polygons. Extrudes 2D polygons into prisms with real side-wall shading from [`light`](../light.md).

```json
{
  "id": "3d-buildings",
  "type": "fill-extrusion",
  "source": "openmaptiles",
  "source-layer": "building",
  "minzoom": 15,
  "paint": {
    "fill-extrusion-color": "#dddddd",
    "fill-extrusion-height": ["get", "render_height"],
    "fill-extrusion-base": ["get", "render_min_height"],
    "fill-extrusion-opacity": 0.85,
    "fill-extrusion-vertical-gradient": true
  }
}
```

**Geometry:** `Polygon`, `MultiPolygon`.

## Paint properties

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `fill-extrusion-opacity` | number [0,1] | `1` | — | Layer opacity. *transitionable.* Not data-driven (uniform per layer). |
| `fill-extrusion-color` | color | `"#000000"` | — | Base colour. Suppressed by `fill-extrusion-pattern`. *data-driven, transitionable.* |
| `fill-extrusion-translate` | `[x, y]` | `[0, 0]` | px | *transitionable.* |
| `fill-extrusion-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | |
| `fill-extrusion-pattern` | resolvedImage | — | — | Tiled sprite texture mapped to top + sides. *transitionable.* |
| `fill-extrusion-height` | number [0, ∞) | `0` | metres | Top elevation (above [`terrain`](../terrain.md) surface if terrain enabled, else sea level). *data-driven, transitionable.* |
| `fill-extrusion-base` | number [0, ∞) | `0` | metres | Bottom elevation. Must be ≤ `fill-extrusion-height`. *data-driven, transitionable.* |
| `fill-extrusion-vertical-gradient` | boolean | `true` | — | Adds a subtle top-to-bottom brightness gradient to side walls so flat tall geometry reads 3D. |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

## Height / base conventions (OpenMapTiles example)

The property names below are specific to OpenMapTiles. Other schemas (MapTiler Planet, Protomaps basemaps, custom tiles) use their own attributes — check the schema's `building` layer docs.

OpenMapTiles `building` layer exposes:

- `render_height` — preferred extrusion top in metres.
- `render_min_height` — preferred extrusion base (floating buildings, skywalks).

Example:

```json
"fill-extrusion-height": ["coalesce", ["get", "render_height"], 10],
"fill-extrusion-base":   ["coalesce", ["get", "render_min_height"], 0]
```

Zoom-fade-in is a common pattern:

```json
"fill-extrusion-height": [
  "interpolate", ["linear"], ["zoom"],
  14.5, 0,
  15.5, ["coalesce", ["get", "render_height"], 10]
]
```

## Lighting

- Extrusion sides are lit from the global [`light`](../light.md) direction. Flat rooftops always render at full `fill-extrusion-color`; side walls get a cosine-weighted shade.
- `light.anchor: "viewport"` keeps the light "over-your-shoulder" — which makes it look natural as you pan/rotate, but unrealistic as a sun model.
- `fill-extrusion-vertical-gradient: true` adds a fake occlusion gradient — usually on.

## Rendering order

- All `fill-extrusion` layers are drawn after all 2D layers by default — they compete with each other but not with flat geometry.
- Within a layer, the renderer depth-sorts triangles so nearer walls occlude farther ones.
- If you need a 2D layer *over* extrusions (e.g. highlighted road), set it later in the style order; the renderer respects layer order over 3D depth at the layer level.

## Performance

- Expensive per-triangle. A city-wide buildings layer at z14 can be tens of millions of triangles — use `minzoom: 14–15` and a zoom-interpolated height to fade in.
- Data-driven `fill-extrusion-color` adds ~10–20% to shader cost; for large layers, prefer constants.
- `fill-extrusion-pattern` tiles across side walls — great for windows effects, but adds texture fetches per fragment.

## Gotchas

- `fill-extrusion-opacity` < 1 disables depth writes; overlapping buildings render in incorrect order (transparent artifacts). Stick with 1 for production.
- `fill-extrusion-base > fill-extrusion-height` silently renders nothing.
- Without [`terrain`](../terrain.md), heights are relative to the sphere-local ground plane — zero difference in practice from your-feet-on-the-map. With terrain, heights are measured above the local surface.
- `fill-extrusion-pattern` requires the sprite entry to not be SDF.
