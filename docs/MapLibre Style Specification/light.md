# `light`

The global light source. Affects `fill-extrusion` layers (for side-wall shading) and 3D hillshade-like behavior. No effect on flat 2D geometry.

- **Type:** object
- **Required:** no
- **Default:** —

```json
{
  "light": {
    "anchor": "viewport",
    "position": [1.15, 210, 30],
    "color": "#ffffff",
    "intensity": 0.5
  }
}
```

## Properties

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| `anchor` | `"map"` \| `"viewport"` | `"viewport"` | Whether light direction tracks the map (rotates with bearing/pitch) or the viewport (stable on screen). |
| `position` | `[r, a, p]` | `[1.15, 210, 30]` | Spherical coordinates: radial distance (unitless), azimuth angle in degrees, polar angle in degrees. |
| `color` | color | `"#ffffff"` | Light tint. |
| `intensity` | number [0,1] | `0.5` | Contrast of lit vs. shadowed surfaces. Higher = more extreme. |

All four are **transitionable** and accept interpolate expressions.

## `position` in detail

`[radial, azimuthal, polar]`:

- **radial** — distance from the geometry. Practically has little visible effect; leave at `1.15`.
- **azimuthal** — compass bearing of the light in degrees. `0` = from north, `90` = from east, `180` = from south, `210` = northwest-ish (default).
- **polar** — angle above the geometry from its up-axis. `0` = directly overhead, `90` = grazing horizontal. Default `30°` gives believable building shadows.

When `anchor: "viewport"`, azimuthal is measured relative to the screen's top; when `"map"`, relative to geographic north.

## Typical uses

- Turn `anchor` to `"map"` when you want sunlight-like directionality that respects the compass, e.g. morning vs. afternoon looks with different azimuths.
- Lower `intensity` to `~0.3` for subtle extrusion shading; push to `0.8+` for dramatic.
- Animate `position[1]` (azimuth) over a day cycle for a "sun sweep" effect.

## Gotchas

- `light` is global — you can't have per-layer light. Multi-light setups require hacks (duplicated geometry with different styles, or external post-processing).
- No shadows are cast onto flat geometry; the light only shades extrusion side walls via the dot product with their normals.
- `color` mixes multiplicatively with the layer's base color, so a red light on a red wall looks near-black on the shadowed side. Keep it near white unless you want the effect.
