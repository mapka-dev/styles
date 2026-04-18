# `state`

Defaults for values consumed by the `global-state` expression. A cheap way to parameterize a style without forking it.

- **Type:** object
- **Required:** no
- **Default:** `{}`

```json
{
  "state": {
    "chargerType":              { "default": ["CCS", "CHAdeMO", "Type2"] },
    "minPreferredChargingSpeed": { "default": 50 },
    "highlightCountry":          { "default": "PL" }
  }
}
```

## Shape

An object keyed by state variable name. Each value is a sub-object with a `default` key. The default value can be any JSON type (string, number, boolean, array, object).

## Consumption — `global-state` expression

Inside any data expression:

```json
["global-state", "minPreferredChargingSpeed"]
```

Returns the current value. Use it in filters and paint:

```json
{
  "filter": [">=", ["get", "maxSpeedKW"], ["global-state", "minPreferredChargingSpeed"]],
  "paint": {
    "fill-color": [
      "case",
      ["==", ["get", "country"], ["global-state", "highlightCountry"]],
      "#ffcc00",
      "#888888"
    ]
  }
}
```

## Mutating at runtime

MapLibre GL JS (≥ 5.6.0):

```javascript
map.setGlobalStateProperty("minPreferredChargingSpeed", 100);
map.setGlobalState({ highlightCountry: "DE" });
```

Updates are live — all expressions re-evaluate. No layer rebuilds, no tile reloads. This is what makes `state` useful for UI controls (sliders, toggles).

## SDK support

- **MapLibre GL JS** ≥ 5.6.0
- **MapLibre Native Android / iOS** — not yet supported at the time of writing.

On unsupported platforms, `global-state` evaluates to the `default` only; runtime mutation is a no-op.

## Why not feature-state?

- `feature-state` is per-feature, needs an ID, and scopes to a source layer.
- `state` / `global-state` is global, scalar, and cheap to change en masse.

Rule of thumb: user is toggling a style-wide knob → `global-state`. User is hovering one feature → `feature-state`.

## Gotchas

- Missing variable + no default = `null`. Wrap in `coalesce` if callers might not set it.
- Default values are evaluated eagerly on style load. Don't put expensive expressions there.
- Nothing validates types — setting `minPreferredChargingSpeed` to `"fast"` gives you silent comparison failures downstream.
