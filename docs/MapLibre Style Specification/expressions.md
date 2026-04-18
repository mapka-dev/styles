# Expressions

Inline, JSON-array mini-language used wherever a style value can vary by feature, zoom, time, or viewport. Replaces the legacy `function` syntax.

Shape:

```json
["operator", arg0, arg1, ...]
```

Everything is a single array with the operator as the first element. Nesting is ubiquitous and expected.

```json
["interpolate", ["linear"], ["zoom"],
  8,  ["case", ["==", ["get", "class"], "primary"], 1, 0.5],
  18, 12]
```

## Categories

### Types — assertion & coercion

| Op | Purpose |
| --- | --- |
| `literal` | Wrap an array/object so it's treated as data, not an expression. |
| `array` | Assert input is an array; optional item type and length. |
| `typeof` | `"null"`, `"string"`, `"number"`, `"boolean"`, `"object"`. |
| `string`, `number`, `boolean`, `object` | Assert input type; multi-argument form tries each until one matches. |
| `collator` | Locale-aware comparator for `==`/`!=`. |
| `format` | Multi-segment rich text (see [`symbol.text-field`](layers/symbol.md)). |
| `image` | Resolve a sprite image name, usable in `icon-image` / `fill-pattern`. |
| `number-format` | Format a number per ICU rules (locale, currency, min/max digits). |
| `to-string`, `to-number`, `to-boolean`, `to-color` | Coerce — `to-*` tries multiple inputs in order. |

### Feature data

| Op | Purpose |
| --- | --- |
| `get` | Read a property: `["get", "name"]`. |
| `has` | `true` if the property exists. |
| `properties` | The whole properties object. |
| `feature-state` | Read runtime state attached to a feature ID. |
| `geometry-type` | `"Point"`, `"LineString"`, `"Polygon"`. |
| `id` | Feature identifier. |
| `line-progress` | 0..1 position along a line (needs source `lineMetrics: true`). |
| `accumulated` | Accumulator inside `clusterProperties` aggregation. |

### Lookup

| Op | Purpose |
| --- | --- |
| `at` | Array item by index. |
| `in` | Substring / array-contains check. |
| `index-of` | First index of substring / array item; `-1` if absent. |
| `slice` | Substring / subarray. |
| `length` | Array or string length. |
| `global-state` | Read a [`state`](state.md) value. |
| `get` / `has` | (also listed under Feature data — both forms accept a second object argument.) |

### Decision

| Op | Purpose |
| --- | --- |
| `case` | First-true branch: `["case", <cond1>, <v1>, <cond2>, <v2>, …, <fallback>]`. |
| `match` | Switch-like: `["match", <input>, <k1>, <v1>, …, <fallback>]`. |
| `coalesce` | First non-null. |
| `==`, `!=`, `<`, `<=`, `>`, `>=` | Comparisons; optional trailing collator argument for locale-aware string compare. |
| `all`, `any`, `!` | Booleans; `all`/`any` short-circuit. |
| `within` | Feature fully inside a GeoJSON polygon. |

### Ramps / scales / curves

| Op | Purpose |
| --- | --- |
| `step` | Piecewise-constant: below each stop the previous value holds. |
| `interpolate` | Smooth between stops. Interpolation type: `["linear"]`, `["exponential", <base>]`, `["cubic-bezier", x1, y1, x2, y2]`. |
| `interpolate-hcl` | Colour interpolation in HCL space — smoother hue transitions than linear RGB. |
| `interpolate-lab` | Colour interpolation in CIELAB space — perceptually uniform. |

### Variable binding

| Op | Purpose |
| --- | --- |
| `let` | Bind names: `["let", "h", ["get", "height"], ["result-expr", …]]`. |
| `var` | Reference a bound name. |

### String

| Op | Purpose |
| --- | --- |
| `concat` | Join arguments as strings. |
| `upcase`, `downcase` | Case transforms. |
| `is-supported-script` | True if the input string is renderable by MapLibre's glyph stack. |
| `resolved-locale` | IETF tag from a collator. |
| `split` | Split into array by separator. |
| `join` | Array → string with separator. |

### Colour

| Op | Purpose |
| --- | --- |
| `rgb`, `rgba` | Build a colour from components. |
| `to-rgba` | `[r, g, b, a]` breakdown. |

### Math

Scalar ops: `+`, `-`, `*`, `/`, `%`, `^`, `sqrt`, `abs`, `ceil`, `floor`, `round`, `min`, `max`.
Transcendental: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `ln`, `ln2`, `log2`, `log10`, `exp`-less (no `exp` — use `["^", ["e"], x]`).
Constants: `pi`, `e`, `ln2`.
Geometry: `distance` (shortest distance in metres between input geometry and the feature).

### Zoom / camera

- `zoom` — current zoom as a number. Only valid **inside** a `step`/`interpolate` at the outermost level where the style permits zoom-driven evaluation, or as a filter predicate.

### Heatmap

- `heatmap-density` — density [0,1] at the current pixel. Only valid in `heatmap-color`.

### Camera

No dedicated operators — use `zoom` combined with `interpolate`/`step`.

## Where expressions are valid

| Location | Valid? |
| --- | --- |
| Layer `paint.*` | ✓ |
| Layer `layout.*` (most) | ✓ |
| Layer `filter` | ✓ |
| Source-level `filter` (geojson) | ✓ |
| Source `clusterProperties` | ✓ |
| `center`, `zoom`, `bearing`, `pitch` defaults | ✗ (literals only) |
| `sprite`, `glyphs`, `sources[*]` URLs | ✗ |

## Common pitfalls

- Legacy-filter form `["==", "propName", "value"]` is implicit `["get"]`. New expressions require explicit `["==", ["get", "propName"], "value"]`. See [`deprecations.md`](deprecations.md).
- `["zoom"]` in filters is only allowed at the top level of an `all`/`any`, or inside a `step`/`interpolate`.
- `["feature-state", …]` is not valid in filters. It only applies at paint time.
- Arrays as *data* need `literal`: `["in", "b", ["literal", ["a", "b", "c"]]]`.
- `interpolate` requires **numeric** input. For discrete categories use `match` or `step`.
- Null propagation: most ops propagate `null` through; wrap in `coalesce` at the top of any data-driven expression that might hit a missing property.
