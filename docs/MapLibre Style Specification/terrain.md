# `terrain`

Binds a [`raster-dem`](sources.md#raster-dem) source to the renderer's 3D terrain pass. Turns the flat map into an elevation surface — layers drape over it, symbols sit on top of it, pitch reveals relief.

- **Type:** object
- **Required:** no
- **Default:** —

```json
{
  "sources": {
    "terrain-dem": {
      "type": "raster-dem",
      "url": "https://example.com/terrain/tiles.json",
      "encoding": "terrarium"
    }
  },
  "terrain": {
    "source": "terrain-dem",
    "exaggeration": 1.2
  }
}
```

## Properties

| Prop | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `source` | string | yes | — | ID of a `raster-dem` source declared in `sources`. |
| `exaggeration` | number [0, ∞) | no | `1` | Vertical scale multiplier. `0` = flat, `2` = twice as tall. |

## Behaviour

- Every layer that isn't `sky`, `background`, or `hillshade` is re-projected onto the terrain mesh.
- Labels (`symbol` layers) are positioned at the terrain elevation at their anchor coordinate. Use `text-pitch-alignment: viewport` to keep them readable.
- `line` layers get slight vertex jitter when crossing steep gradients — expected; use `line-width` / `line-emissive-strength` (where supported) to mitigate visual artefacts.
- `fill-extrusion` heights are measured from the terrain surface, not from sea level. Use `fill-extrusion-base` to float geometry.

## Data sources

- **Mapbox Terrain-RGB** — `encoding: "mapbox"`.
- **Mapzen/AWS Terrarium** — `encoding: "terrarium"`.
- **Self-hosted DEM tiles** — generate with `rio-rgbify` or `gdal2tiles`. Use `encoding: "custom"` + `redFactor/greenFactor/blueFactor/baseShift` to match your encoding.

See [`sources.md`](sources.md#raster-dem) for the full raster-dem source spec.

## Performance notes

- Terrain cost scales with pitch: top-down map costs nothing extra; `pitch: 60` re-renders the world as a heightmap mesh.
- Raster layers over terrain are draped cheaply; vector layers are re-tessellated — avoid dense polygon layers if terrain is always-on.
- Hillshade-only use cases (no 3D, just shading) should use a `hillshade` layer on the same `raster-dem` source — the [`terrain`](terrain.md) block is not required for that.

## Gotchas

- `terrain` without a pitch looks identical to a flat map. Set a default [`pitch`](camera.md) > 0 to make it visible on first load.
- Switching `terrain` on/off at runtime (`map.setTerrain(null)`) is cheap; changing `exaggeration` animates smoothly.
- No `"visibility"` property — remove the block to disable.
