# `symbol` layer

Icons and labels. By far the most complex layer type — it handles placement, collision, wrapping, line following, anchors, and halo rendering.

```json
{
  "id": "place-label",
  "type": "symbol",
  "source": "openmaptiles",
  "source-layer": "place",
  "filter": ["in", ["get", "class"], ["literal", ["city", "town"]]],
  "layout": {
    "text-field": ["get", "name:en"],
    "text-font": ["Noto Sans Bold"],
    "text-size": ["interpolate", ["linear"], ["zoom"], 4, 10, 12, 16],
    "text-anchor": "top",
    "text-offset": [0, 0.5]
  },
  "paint": {
    "text-color": "#202020",
    "text-halo-color": "#ffffff",
    "text-halo-width": 1.2
  }
}
```

**Geometry:** `Point`, `MultiPoint`, `LineString`, `MultiLineString` (line placement).

---

## Layout properties

### Symbol-wide placement

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `symbol-placement` | `"point"` \| `"line"` \| `"line-center"` | `"point"` | How each symbol is anchored. `point` = one per Point geometry. `line` = repeated along the line. `line-center` = one at the midpoint. |
| `symbol-spacing` | number [1, ∞) | `250` | Distance in px between placements on `symbol-placement: line`. |
| `symbol-avoid-edges` | boolean | `false` | Drop symbols whose bbox crosses a tile edge. Reduces duplicate labels near tile seams; can leave gaps. |
| `symbol-sort-key` | number | — | Collision priority; lower is higher priority. *data-driven.* |
| `symbol-z-order` | `"auto"` \| `"viewport-y"` \| `"source"` | `"auto"` | Within-layer draw order. `viewport-y` sorts by screen Y for nice stacking on tilted maps. *Since 0.49.0.* |

### Icon

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `icon-image` | resolvedImage | — | Sprite icon name, or `["image", <expr>]`, or `["concat", …]` for per-feature icons. *data-driven.* |
| `icon-size` | number [0, ∞) | `1` | Scale factor on the native sprite size. `2` = double size. *data-driven, transitionable at runtime.* |
| `icon-rotation-alignment` | `"map"` \| `"viewport"` \| `"auto"` | `"auto"` | Rotation reference. `auto` → follows `symbol-placement`. |
| `icon-pitch-alignment` | `"map"` \| `"viewport"` \| `"auto"` | `"auto"` | Tilt reference. |
| `icon-rotate` | number | `0`° | Rotation. *data-driven.* |
| `icon-padding` | padding | `[2]` px | Collision padding around the icon's bbox. Accepts single number (all sides) or CSS-style 1–4 element array; see [`padding`](../types.md#padding). |
| `icon-keep-upright` | boolean | `false` | Flip line-anchored icons so they stay right-side-up. |
| `icon-offset` | `[x, y]` | `[0, 0]` | Offset from anchor in multiples of icon size. *data-driven.* |
| `icon-anchor` | enum (`center`, `left`, `right`, `top`, `bottom`, `top-left`, `top-right`, `bottom-left`, `bottom-right`) | `"center"` | Which part of the icon sits on the anchor point. *data-driven.* |
| `icon-allow-overlap` | boolean | `false` | Render even when overlapping other symbols. *data-driven* (in later specs). |
| `icon-overlap` | `"never"` \| `"always"` \| `"cooperative"` | — | Fine-grained overlap control. Supersedes `icon-allow-overlap` where supported. *Since 2.1.0.* |
| `icon-ignore-placement` | boolean | `false` | If true, this icon doesn't block placement of other symbols. |
| `icon-optional` | boolean | `false` | If icon collides but text doesn't, keep the text. |
| `icon-text-fit` | `"none"` \| `"width"` \| `"height"` \| `"both"` | `"none"` | Scale the icon to fit the text. Requires a sprite with `content` / `stretchX` / `stretchY` metadata. Used for pill-shaped label backgrounds. |
| `icon-text-fit-padding` | `[top, right, bottom, left]` | `[0,0,0,0]` | Padding applied when `icon-text-fit` is active. |

### Text

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `text-field` | formatted | `""` | The label. Typical: `["get", "name"]` or a `format` expression for rich text. *data-driven.* |
| `text-font` | `string[]` | `["Open Sans Regular", "Arial Unicode MS Regular"]` | Font stack. Must match a directory under the [`glyphs`](../glyphs.md) URL. |
| `text-size` | number [0, ∞) | `16` px | Glyph size. *data-driven, transitionable.* |
| `text-max-width` | number [0, ∞) | `10` em | Line wrap threshold, in ems. |
| `text-line-height` | number | `1.2` em | Multi-line leading. |
| `text-letter-spacing` | number | `0` em | Tracking. |
| `text-justify` | `"auto"` \| `"left"` \| `"center"` \| `"right"` | `"center"` | Alignment within wrapped lines. `auto` picks based on `text-anchor`. *data-driven.* |
| `text-radial-offset` | number | `0` em | Radial distance from anchor. Interacts with `text-variable-anchor`. *data-driven.* |
| `text-variable-anchor` | `string[]` | — | List of anchors to try in order; the renderer picks the first non-colliding one. |
| `text-variable-anchor-offset` | `variableAnchorOffsetCollection` | — | `[anchor, offset, anchor, offset, …]`. Pair anchors with their own offsets. *Since 3.3.0.* |
| `text-anchor` | enum (same as `icon-anchor`) | `"center"` | Fallback anchor when `text-variable-anchor` is unset. *data-driven.* |
| `text-max-angle` | number | `45`° | Max bend between consecutive glyphs on line placement. Above this, the label is dropped. |
| `text-rotation-alignment` | `"map"` \| `"viewport"` \| `"viewport-glyph"` \| `"auto"` | `"auto"` | Whole-label rotation reference. |
| `text-pitch-alignment` | `"map"` \| `"viewport"` \| `"auto"` | `"auto"` | Tilt behaviour. |
| `text-writing-mode` | `string[]` — any of `"horizontal"`, `"vertical"` | — | Permit vertical text (CJK). Renderer picks best fit. |
| `text-rotate` | number | `0`° | Whole-label rotation. *data-driven.* |
| `text-transform` | `"none"` \| `"uppercase"` \| `"lowercase"` | `"none"` | Case transform. *data-driven.* |
| `text-offset` | `[x, y]` | `[0, 0]` | Anchor offset in ems. Don't combine with `text-radial-offset`. *data-driven.* |
| `text-padding` | number | `2` px | Collision-box padding. |
| `text-keep-upright` | boolean | `true` | Flip line labels to stay readable. |
| `text-allow-overlap` | boolean | `false` | Render even when overlapping. *data-driven.* |
| `text-overlap` | `"never"` \| `"always"` \| `"cooperative"` | — | Replacement for `text-allow-overlap` with a middle option. *Since 2.1.0.* |
| `text-ignore-placement` | boolean | `false` | Don't block other symbols. |
| `text-optional` | boolean | `false` | Keep icon if text collides. |

### Universal

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | — |

---

## Paint properties

### Icon

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `icon-opacity` | number [0,1] | `1` | — | *data-driven, transitionable.* |
| `icon-color` | color | `"#000000"` | — | Tint — only applies to SDF icons. *data-driven, transitionable.* |
| `icon-halo-color` | color | `"rgba(0,0,0,0)"` | — | SDF-only halo. *data-driven, transitionable.* |
| `icon-halo-width` | number [0, ∞) | `0` | px | Halo radius. *data-driven, transitionable.* |
| `icon-halo-blur` | number [0, ∞) | `0` | px | Halo fade. *data-driven, transitionable.* |
| `icon-translate` | `[x, y]` | `[0, 0]` | px | *transitionable.* |
| `icon-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | |

### Text

| Property | Type | Default | Unit | Notes |
| --- | --- | --- | --- | --- |
| `text-opacity` | number [0,1] | `1` | — | *data-driven, transitionable.* |
| `text-color` | color | `"#000000"` | — | *data-driven, transitionable.* |
| `text-halo-color` | color | `"rgba(0,0,0,0)"` | — | *data-driven, transitionable.* |
| `text-halo-width` | number [0, ∞) | `0` | px | Halo radius. Capped at ~¼ of `text-size`. *data-driven, transitionable.* |
| `text-halo-blur` | number [0, ∞) | `0` | px | Halo fade. *data-driven, transitionable.* |
| `text-translate` | `[x, y]` | `[0, 0]` | px | *transitionable.* |
| `text-translate-anchor` | `"map"` \| `"viewport"` | `"map"` | — | |

---

## Placement and collision

- **Priority** — `symbol-sort-key` + style order. Lower sort key wins; within equal keys, earlier features beat later ones.
- **Overlap** — by default, if a symbol collides with one already placed, it's dropped. Use `text-allow-overlap`/`icon-allow-overlap` (or the newer `*-overlap` variants) to force it.
- **Variable anchors** — set `text-variable-anchor: ["top", "bottom", "left", "right"]` and the renderer tries each anchor until it finds one that fits. Great for POIs near the map edge.
- **Cooperative overlap** — `text-overlap: "cooperative"` lets adjacent symbols render even when they touch, as long as their centres don't coincide. Useful for dense point clusters.

## `text-field` expressions

Typical shapes:

```json
"text-field": ["get", "name"]

"text-field": ["coalesce", ["get", "name:en"], ["get", "name"]]

"text-field": [
  "format",
  ["get", "name"], { "font-scale": 1.0 },
  "\n", {},
  ["get", "ele"], { "font-scale": 0.7, "text-color": "#666" }
]
```

`format` supports `font-scale`, `text-font`, `text-color` overrides per span.

## Common patterns

**Road shields / pill labels** — use `icon-text-fit: both` with a sprite designed with `stretchX`/`stretchY` regions; attach `text-field` on top.

**Line-follow labels** — `symbol-placement: "line"`, `text-keep-upright: true`, `text-max-angle: 35`. For long roads, also set `symbol-spacing` lower than default to prevent huge gaps.

**Country labels with curved placement** — use `symbol-placement: "point"` on a centroid, not `line`; country boundaries zigzag too much for smooth line placement.

## Performance

- `symbol` is the most expensive layer type. Collision detection runs each frame when the camera moves.
- Keep label-density work to the tile pipeline where possible (pre-ranked features, a `rank` attribute, early `minzoom`).
- Reduce `symbol-spacing` carefully — halving it ~quadruples collision candidates.
- `text-field` as a complex expression with `case`/`coalesce` over many keys is fine at feature count ≤ 50k; beyond that, simplify or prepare fields server-side.

## Gotchas

- Missing font → no label, no warning. Verify the font stack exists at the `glyphs` endpoint.
- Missing icon → no icon, also silent.
- `text-variable-anchor` ignores `text-anchor` + `text-offset` — use `text-radial-offset` or `text-variable-anchor-offset`.
- On pitched maps, `text-pitch-alignment: map` makes labels lie on the ground (good for street names on roads, bad for place labels which need to stay readable).
- `icon-color` only tints SDF sprites. Non-SDF (regular PNG) icons ignore the colour.
- `symbol-avoid-edges: true` with small tile buffers causes visible gaps; leave it false unless you see duplicate labels you can't solve with `text-ignore-placement: false`.
