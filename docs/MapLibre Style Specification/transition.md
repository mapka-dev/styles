# `transition`

Default timing for animated changes to paint properties. Overridden per-property by any `*-transition` field inside a layer's `paint` block.

- **Type:** object
- **Required:** no
- **Default:** `{ "duration": 300, "delay": 0 }`

```json
{
  "transition": {
    "duration": 300,
    "delay": 0
  }
}
```

## Properties

| Prop | Type | Range | Default | Unit | Description |
| --- | --- | --- | --- | --- | --- |
| `duration` | number | [0, ∞) | `300` | ms | Time for a paint-property change to animate to the new value. |
| `delay` | number | [0, ∞) | `0` | ms | Wait before the animation starts. |

## Scope

Applies to any property marked *Transitionable* in the layer docs — most paint properties (colors, opacities, widths). Layout properties are **not** transitionable.

## Per-property override

Every transitionable paint property has a sibling key `<property>-transition`:

```json
{
  "paint": {
    "fill-color": "#334",
    "fill-color-transition": { "duration": 1200, "delay": 50 },

    "fill-opacity": 0.5,
    "fill-opacity-transition": { "duration": 0 }
  }
}
```

- `duration: 0` disables the animation entirely — the value snaps.
- Per-property transitions layer on top of the global `transition`; nothing merges, the per-property block wins outright.

## When transitions fire

- Paint property is set data-driven and the input data changes.
- `map.setPaintProperty(...)` is called.
- A style is swapped with `diff: true` and only paint properties differ.
- Basemap theme switching (light/dark) via paint rewrites.

## Gotchas

- Setting a huge `duration` globally makes interactive editing feel sluggish — every click appears to lag.
- Data-driven color ramps that cross many stops can produce visually jumpy transitions; consider using `interpolate-hcl` for smoother color blends instead of relying on transition timing.
- `transition` does **not** apply to layout changes (e.g. switching `visibility`, `text-field`). Those are step changes.
- Layers added dynamically respect the active global transition.
