# MapLibre Style Specification — Reference

One file per top-level property of a MapLibre style document. Spec version 8. Upstream root reference: <https://maplibre.org/maplibre-style-spec/root/> (`/camera/` is not a separate upstream page — camera-pose properties live on `/root/`; kept as a standalone [`camera.md`](camera.md) here for readability).

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

## What's new vs. early v8

Spec version has stayed at `8`, but the shape has grown. Additions relevant to existing styles:

- `centerAltitude`, `roll` — GL JS ≥ 5.0.0.
- `pitch` extended to 0–180° — GL JS ≥ 5.0.0.
- `state` root + `global-state` expression — GL JS ≥ 5.6.0.
- `font-faces` — MapLibre Native only (Android ≥ 11.13.0, iOS ≥ 6.18.0); GL JS still `glyphs`-only.
- `projection` with mercator↔globe transitions — GL JS ≥ 5.0.0.
- `color-relief` layer + `elevation` expression — GL JS ≥ 5.6.0 / Native ≥ 13.0.0 (Android) / 6.24.0 (iOS).
- `vector.encoding: "mlt"` (MapLibre Tiles) — GL JS ≥ 5.12.0, Native Android ≥ 12.1.0, iOS ≥ 6.20.0.
- `resampling` (replaces `raster-resampling`) — GL JS ≥ 5.20.0.
- Hillshade methods `basic` / `combined` / `igor` / `multidirectional` — GL JS ≥ 5.5.0 / Native ≥ 13.0.0 / 6.24.0.

## Version-annotation policy

These docs annotate a property with "Since GL JS X.Y.Z" only when it is **recently added** or **SDK-split** (one platform ahead of another). Long-stable v8 primitives (`fill-color`, `line-width`, etc.) are left unannotated. Upstream carries full version matrices for every property; follow the per-property links there if you need the full table.
