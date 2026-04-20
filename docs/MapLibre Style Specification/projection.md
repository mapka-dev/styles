# `projection`

Map projection. Default is Web Mercator; MapLibre also supports a globe view and can transition between them.

- **Type:** object (or expression producing a `projectionDefinition`)
- **Required:** no
- **Default:** `{ "type": "mercator" }`

```json
{ "projection": { "type": "mercator" } }
```

## Properties

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| `type` | `projectionDefinition` | `"mercator"` | Projection identifier, transition pair, or interpolate expression. |

## Supported `type` values

| Value | Notes |
| --- | --- |
| `"mercator"` | Classic web map. Distorts area away from equator. |
| `"globe"` | 3D globe. Alias / convenience for `vertical-perspective`. |
| `"vertical-perspective"` | True 3D perspective projection — same visual as `globe`. |

## Transition between projections

`type` accepts an interpolation triple `[from, to, t]` or an `interpolate` expression, letting you animate mercator ↔ globe:

```json
{
  "projection": {
    "type": [
      "interpolate",
      ["linear"],
      ["zoom"],
      0, "vertical-perspective",
      6, "mercator"
    ]
  }
}
```

Below zoom 6 the map renders as a globe; above, it flattens to mercator. The renderer handles the morph.

## Effect on other style features

- **Sky / atmosphere** — `atmosphere-blend` is only visible on `globe`/`vertical-perspective`; flat projections ignore it.
- **Terrain** — works with both, though the terrain mesh at globe scale stays subtle.
- **Text placement** — symbol `text-rotation-alignment: map` looks odd near the poles on mercator; globe projection flips the tradeoffs.
- **Labels** — at globe scale, label placement uses great-circle heuristics; line labels on mercator follow pixel-space tangents.

## Gotchas

- `globe` and `vertical-perspective` are *the same projection* — the spec carries both names for historical reasons.
- Interactive zooming past ~z6 on globe ends up looking like mercator anyway because the camera is close to the surface; the interpolate trick just makes that cheap.
- Custom (non-built-in) projections aren't supported via the style — they require native-layer plumbing.
- Some vendor tile servers pre-reproject or assume mercator bounds; `globe` will still render those tiles, but anything at extreme latitudes (near the poles) will look different from the flat map.
