# `sky`

Configures the sky dome and distance fog. Most visible when the map is pitched (`pitch > 0`) or uses a globe projection.

- **Type:** object
- **Required:** no
- **Default:** —
- **Status:** the spec describes this as still experimental.

```json
{
  "sky": {
    "sky-color": "#88C6FC",
    "horizon-color": "#ffffff",
    "fog-color": "#ffffff",
    "fog-ground-blend": 0.5,
    "horizon-fog-blend": 0.8,
    "sky-horizon-blend": 0.8,
    "atmosphere-blend": 0.8
  }
}
```

## Properties

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| `sky-color` | color | `"#88C6FC"` | Base color of the sky at zenith. |
| `horizon-color` | color | `"#ffffff"` | Color at the horizon line. |
| `fog-color` | color | `"#ffffff"` | Base fog color. Requires [`terrain`](terrain.md) to be visible. |
| `fog-ground-blend` | number [0,1] | `0.5` | Where fog starts on the ground. `0` = starts at map center, `1` = only at the horizon. Higher = clearer foreground. |
| `horizon-fog-blend` | number [0,1] | `0.8` | Mix of horizon vs. fog color at the horizon line. `0` = horizon only, `1` = fog only. |
| `sky-horizon-blend` | number [0,1] | `0.8` | Where the sky-to-horizon gradient midpoint sits. `1` = gradient ends at sky midpoint, `0` = no gradient, flat sky color. |
| `atmosphere-blend` | number [0,1] | `0.8` | Atmosphere visibility (globe projection). `1` = visible, `0` = hidden. Best for [globe projection](projection.md). |

All properties are **transitionable** and accept interpolate expressions.

## Common configurations

**Daylight flat map (pitched):**

```json
{
  "sky-color": "#a9d3ff",
  "horizon-color": "#fefaf4",
  "sky-horizon-blend": 0.6
}
```

**Night:**

```json
{
  "sky-color": "#0a1220",
  "horizon-color": "#2c2440",
  "sky-horizon-blend": 0.9
}
```

**Atmospheric globe:**

```json
{
  "atmosphere-blend": 1.0,
  "sky-color": "#6ab0ff",
  "horizon-color": "#ffffff"
}
```

## Gotchas

- `fog-color` does nothing without a `terrain` block — it needs real depth to blend against.
- On 2D flat (unpitched) maps, the sky is invisible; the renderer skips the dome entirely.
- `atmosphere-blend` only applies to globe-like projections; on mercator it's ignored.
- If sky + fog + horizon colors clash with the basemap tint, the far-distance fade looks muddy. Pick `horizon-color` close to the dominant basemap color at the horizon.
