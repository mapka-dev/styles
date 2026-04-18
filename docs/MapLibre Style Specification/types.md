# Types

Primitive and composite value types referenced throughout the spec.

## Primitives

| Type | Notes |
| --- | --- |
| `string` | JSON string. |
| `number` | JSON number. Float-precision internally. |
| `boolean` | `true` / `false`. |
| `null` | Sentinel for "missing"; most ops propagate it. |
| `array` | Typed or untyped. `array<number, 3>` = length-3 numeric. |
| `enum` | String restricted to a fixed set. |

## Composite types

### `color`

CSS-ish colour strings. Accepted forms:

- Hex: `#rgb`, `#rrggbb`, `#rrggbbaa`.
- RGB/RGBA: `rgb(255, 128, 0)`, `rgba(255, 128, 0, 0.5)`.
- HSL/HSLA: `hsl(30, 100%, 50%)`, `hsla(30, 100%, 50%, 0.7)`.
- Named: `red`, `dodgerblue`, etc. (CSS named colours).

Transparent: `"rgba(0,0,0,0)"` is the conventional spelling. `"transparent"` is accepted by most engines.

### `formatted`

Return value of the `format` expression. Used by `symbol.text-field` for mixed-style labels.

```json
["format",
  ["get", "name"],   { "font-scale": 1.0, "text-font": ["literal", ["Noto Sans Bold"]] },
  "\n", {},
  ["get", "subname"],{ "font-scale": 0.75, "text-color": "#888" }
]
```

Options per segment: `font-scale`, `text-font`, `text-color`, `vertical-align`.

### `resolvedImage`

Return value of the `image` expression. Used by `icon-image`, `fill-pattern`, `line-pattern`, `background-pattern`, `fill-extrusion-pattern`.

```json
["coalesce", ["image", "icon-a"], ["image", "icon-b"]]
```

Passing a plain string like `"icon-a"` works for most of these properties as a shortcut; wrap in `image` when you need fallbacks.

### `padding`

CSS-like padding: single number or array of 1–4 values.

- `4` → `[4, 4, 4, 4]`
- `[2, 3]` → top/bottom = 2, left/right = 3
- `[1, 2, 3]` → top = 1, left/right = 2, bottom = 3
- `[1, 2, 3, 4]` → top, right, bottom, left

Used by `icon-text-fit-padding`, `text-padding`, `icon-padding`.

### `point`

2-element numeric array `[x, y]`. Used for offsets, translations, centre coordinates.

### `projectionDefinition`

String (a projection name), a `[from, to, t]` triple, or an `interpolate` expression. See [`projection.md`](projection.md).

### `numberArray`

Array of numbers — used for e.g. `line-dasharray`.

### `colorArray`

Array of colours. Rare; a few advanced properties.

### `variableAnchorOffsetCollection`

Flat array pairing each anchor with its own offset:

```json
"text-variable-anchor-offset": [
  "top",       [0,  0.8],
  "bottom",    [0, -0.8],
  "left",      [0.8, 0],
  "right",     [-0.8, 0]
]
```

Anchors are tried in array order; first non-colliding wins.

### `promoteId`

Value of the `promoteId` source option. Either:

- A string — property name to promote on a single-layer (geojson) source.
- An object — `{ "<sourceLayerName>": "<propertyName>", … }` — per source-layer promotion for vector sources.

```json
"promoteId": { "admin": "osm_id", "water": "osm_id" }
```

Needed because vector tiles don't preserve string/long IDs, and `feature-state` needs a stable ID.

### `filter expression`

Alias for any boolean-valued expression. Used by `layer.filter` and `geojson` source `filter`. See [`expressions.md`](expressions.md).

Cannot reference `feature-state` or `global-state` that isn't present at filter time.

## Expression value types

Inside expressions, values are one of: `null`, `boolean`, `number`, `string`, `color`, `array<T, N>`, `object`, `formatted`, `resolvedImage`, `collator`. The renderer infers types, but you can force with `string`/`number`/`boolean`/`to-color`/`to-string`/`to-number`/`to-boolean`.
