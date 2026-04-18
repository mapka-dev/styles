# Deprecations

Legacy syntax that still parses but has been superseded by [expressions](expressions.md). Automated migration: `gl-style-migrate` (Mapbox) or hand-port per the tables below.

## Functions → expressions

Old `function` style (deprecated since v0.41.0):

```json
{
  "line-width": {
    "property": "class",
    "type": "categorical",
    "stops": [["primary", 3], ["secondary", 2], ["tertiary", 1]],
    "default": 0.5
  }
}
```

Rewrite as `match`:

```json
{
  "line-width": [
    "match", ["get", "class"],
    "primary", 3,
    "secondary", 2,
    "tertiary", 1,
    0.5
  ]
}
```

Zoom ramp:

```json
{
  "line-width": { "stops": [[10, 1], [14, 4]], "base": 1.2 }
}
```

Becomes:

```json
{
  "line-width": [
    "interpolate", ["exponential", 1.2], ["zoom"],
    10, 1,
    14, 4
  ]
}
```

Legacy keys: `stops`, `property`, `base`, `type`, `default`, `colorSpace`.

- `type: "identity"` → `["get", "prop"]`
- `type: "exponential"` → `["interpolate", ["exponential", base], …, …]`
- `type: "interval"` → `["step", …]`
- `type: "categorical"` → `["match", …]`
- `colorSpace: "hcl"` → `["interpolate-hcl", …]`
- `colorSpace: "lab"` → `["interpolate-lab", …]`

## Filter short form → expression form

Style-spec v8 still parses the short form. Prefer the explicit form in new styles; validators and some linters warn on it.

| Short | Expression |
| --- | --- |
| `["has", "k"]` | `["has", ["get", "k"]]` |
| `["==", "k", v]` | `["==", ["get", "k"], v]` |
| `["!=", "k", v]` | `["!=", ["get", "k"], v]` |
| `[">", "k", v]` | `[">", ["get", "k"], v]` |
| `[">=", "k", v]` | `[">=", ["get", "k"], v]` |
| `["<", "k", v]` | `["<", ["get", "k"], v]` |
| `["<=", "k", v]` | `["<=", ["get", "k"], v]` |
| `["in", "k", v0, v1, …]` | `["in", ["get", "k"], ["literal", [v0, v1, …]]]` |
| `["!in", "k", v0, …]` | `["!", ["in", ["get", "k"], ["literal", [v0, …]]]]` |

Boolean combinators (`all`, `any`, `none`) are fine in the new form; just convert their children.

## Special-case values

- `$type` in legacy filters → `["geometry-type"]`.
- `$id` → `["id"]`.

```json
// Legacy
["==", "$type", "Polygon"]

// New
["==", ["geometry-type"], "Polygon"]
```

## Why migrate

- Expression form is strictly more expressive: `case`, `coalesce`, `let/var`, `global-state`.
- Editor support (Maputnik, code-assist) targets the new form.
- Some new properties (e.g. `text-variable-anchor-offset`) only accept expression values.
- Future removals: MapLibre hasn't pulled support for the legacy forms, but there's no commitment to keep them forever.

## Tool

```
npx @maplibre/maplibre-gl-style-spec gl-style-migrate < old.json > new.json
```

Applies the transforms above mechanically and produces a valid v8 style.
