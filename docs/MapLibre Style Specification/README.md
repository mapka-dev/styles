# MapLibre Style Specification — Reference

One file per top-level property of a MapLibre style document. Spec version 8. Source: <https://maplibre.org/maplibre-style-spec/>.

A MapLibre style is a JSON document. At the root it carries camera defaults, asset URLs, and the two things a renderer actually consumes: **sources** (where the data comes from) and **layers** (how it looks). Everything else is optional.

## Required vs. optional

Required: `version`, `sources`, `layers`. Everything else is optional.

| Property | Purpose |
| --- | --- |
| [`version`](version.md) | Spec version — must be `8` (required) |
| [`sources`](sources.md) | Data sources the map can pull from (required) |
| [`layers`](layers.md) | Ordered list of rendered layers (required) |
| [`name`](name.md) | Human-readable style name |
| [`metadata`](metadata.md) | Arbitrary user data (prefix keys) |
| [`center`](camera.md) | Default map center `[lng, lat]` |
| [`centerAltitude`](camera.md) | Default camera altitude (m) |
| [`zoom`](camera.md) | Default zoom |
| [`bearing`](camera.md) | Default bearing (°) — default `0` |
| [`pitch`](camera.md) | Default pitch (°) — default `0` |
| [`roll`](camera.md) | Default roll (°) — default `0` |
| [`state`](state.md) | Defaults for `global-state` expression |
| [`light`](light.md) | Light source for 3D extrusions |
| [`sky`](sky.md) | Sky + fog configuration |
| [`projection`](projection.md) | Map projection (`mercator`, `globe`, …) |
| [`terrain`](terrain.md) | 3D terrain from a `raster-dem` source |
| [`sprite`](sprite.md) | Icon atlas URL(s) |
| [`glyphs`](glyphs.md) | SDF glyph URL template |
| [`font-faces`](font-faces.md) | Web-font style declarations |
| [`transition`](transition.md) | Default transition timing |

## Cross-cutting references

- [`layers/`](layers/) — one file per layer type (`background`, `fill`, `line`, `symbol`, `circle`, `heatmap`, `fill-extrusion`, `raster`, `hillshade`, `color-relief`).
- [`expressions.md`](expressions.md) — operators for data-driven styling.
- [`types.md`](types.md) — primitive and composite value types (`color`, `formatted`, `resolvedImage`, `padding`, …).
- [`deprecations.md`](deprecations.md) — legacy function/filter syntax and migrations.

## Minimal valid style

```json
{
  "version": 8,
  "sources": {
    "osm": {
      "type": "raster",
      "tiles": ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
      "tileSize": 256
    }
  },
  "layers": [
    { "id": "osm", "type": "raster", "source": "osm" }
  ]
}
```

Everything else is layered on top of this shape.
