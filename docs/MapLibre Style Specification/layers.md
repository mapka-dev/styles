# `layers`

An **ordered array** of layer objects. **Required.** This is the biggest and most-edited part of a style: every visual choice lives here.

```json
{
  "layers": [
    { "id": "bg",       "type": "background", "paint": { "background-color": "#f5f5f5" } },
    { "id": "water",    "type": "fill", "source": "openmaptiles", "source-layer": "water",
      "paint": { "fill-color": "#a0c8f0" } },
    { "id": "roads",    "type": "line", "source": "openmaptiles", "source-layer": "transportation",
      "paint": { "line-color": "#ffffff", "line-width": 1.5 } },
    { "id": "labels",   "type": "symbol", "source": "openmaptiles", "source-layer": "place",
      "layout": { "text-field": ["get", "name"], "text-font": ["Noto Sans Regular"] } }
  ]
}
```

## Rendering rules

- **Order matters.** Layers are drawn bottom-up — the first element paints first; later ones paint on top.
- Within a single layer, features are drawn in source order unless `*-sort-key` is set.
- Layers of different types don't interleave features; a `line` layer fully renders before the next layer starts.

## Common properties

These apply to all layer types (some restrictions noted).

| Prop | Type | Default | Required | Notes |
| --- | --- | --- | --- | --- |
| `id` | string | — | yes | Unique within the style. Used for API references and `map.getLayer(id)`. |
| `type` | enum | — | yes | Discriminator. See [Layer types](#layer-types). |
| `metadata` | object | — | no | Arbitrary data; prefix keys. |
| `source` | string | — | yes (except `background`) | Source ID. |
| `source-layer` | string | — | required for vector sources | Vector-tile sublayer name. |
| `minzoom` | number 0–24 | — | no | Hidden below this zoom (inclusive at `minzoom`). |
| `maxzoom` | number 0–24 | — | no | Hidden at or above this zoom (exclusive at `maxzoom`). |
| `filter` | expression | — | no | Per-feature include/exclude. Evaluated against feature properties, zoom, geometry-type. |
| `layout` | object | — | no | Non-colour styling (placement, alignment, text, icon content). Not transitionable. |
| `paint` | object | — | no | Colour / stroke / opacity. Most are transitionable. |

### `id`

Layer identity across the whole style. Changing it breaks any `beforeLayerId` references and any external code that interacts with the layer (JS `map.addLayer`, native `mapView.style`).

### `type`

Fixed set:

- [`background`](layers/background.md)
- [`fill`](layers/fill.md)
- [`line`](layers/line.md)
- [`symbol`](layers/symbol.md)
- [`circle`](layers/circle.md)
- [`heatmap`](layers/heatmap.md)
- [`fill-extrusion`](layers/fill-extrusion.md)
- [`raster`](layers/raster.md)
- [`hillshade`](layers/hillshade.md)
- [`color-relief`](layers/color-relief.md)

### `source` & `source-layer`

- `source` — ID from the top-level [`sources`](sources.md) object.
- `source-layer` — only meaningful for vector sources; names the sublayer inside the MVT.
- Raster, raster-dem, image, video, geojson sources have no sublayers; omit `source-layer`.
- `background` has no source at all.

### `minzoom` / `maxzoom`

- Inclusive at `minzoom`, exclusive at `maxzoom` (classic half-open interval).
- A layer with `minzoom: 10, maxzoom: 14` renders at zooms 10, 11, 12, 13 — not at 14.
- These are enforced before `filter` and before any paint evaluation. Cheap to use.

### `filter`

A boolean expression. Only features for which it evaluates truthy render in the layer.

```json
{
  "filter": [
    "all",
    ["==", ["geometry-type"], "LineString"],
    ["in", ["get", "class"], ["literal", ["primary", "secondary"]]],
    [">=", ["zoom"], 8]
  ]
}
```

- Prefer expressions (`["==", ["get", "k"], v]`) over the legacy short form (`["==", "k", v]`). See [`deprecations.md`](deprecations.md).
- Filters can reference `["zoom"]` but only in top-level position of an `all`/`any` wrapper or inside `step`/`interpolate` — renderers are strict about this.
- `filter` cannot reference `feature-state`.

### `layout` vs `paint`

- **Layout** — where/how the primitive is built. Changing it re-tessellates geometry (expensive). Not transitionable.
- **Paint** — colour/opacity/blur applied during draw. Most are transitionable and cheap to change.

Rule of thumb: anything that affects collision, placement, text shaping, icon fit → layout. Anything that affects pixels only → paint.

### `visibility`

Present in `layout` for every layer type: `"visible"` or `"none"`. Toggling it is the cheapest way to hide a layer (no rebuild).

---

## Layer types at a glance

| Type | Geometry needed | Data-driven | Typical source | Summary |
| --- | --- | --- | --- | --- |
| [`background`](layers/background.md) | none | — | — | Solid colour / pattern behind everything. |
| [`fill`](layers/fill.md) | Polygon | yes | vector / geojson | Flat polygon fills with optional pattern and outline. |
| [`line`](layers/line.md) | LineString | yes | vector / geojson | Stroked lines; dashes, gradients, patterns. |
| [`symbol`](layers/symbol.md) | Point / LineString | yes | vector / geojson | Icons + text. Collision-aware placement. |
| [`circle`](layers/circle.md) | Point | yes | vector / geojson | Filled circles with strokes. Cheap points. |
| [`heatmap`](layers/heatmap.md) | Point | yes | vector / geojson | Density field rendered via kernel. |
| [`fill-extrusion`](layers/fill-extrusion.md) | Polygon | yes | vector / geojson | 3D extruded polygons (buildings). |
| [`raster`](layers/raster.md) | — | no (paint-only) | raster / image / video | Raster tiles / images / videos. |
| [`hillshade`](layers/hillshade.md) | — | no | raster-dem | Client-side terrain shading. |
| [`color-relief`](layers/color-relief.md) | — | no | raster-dem | Elevation → colour ramp. |

See `layers/<type>.md` for full paint and layout property tables.

---

## Ordering tips

1. **Background** at the bottom.
2. Then polygons low-to-high detail: water, land cover, land use, parks.
3. Then line features: waterways, admin boundaries, roads (bottom casings → top road surfaces).
4. Then extrusions (buildings).
5. **Symbols and labels last**, so they sit on top of everything they label.

Bucket by `metadata.group` in Maputnik if you have dozens of layers — the group attribute has no runtime effect but keeps the editor UI navigable.

## Data-driven vs zoom-driven

Every non-layout, non-transition property in a layer is an expression — but a plain literal (`2`, `"#fff"`, `[0, 0]`) is also a valid expression. *Data-driven* / *zoom-driven* tags in the per-type docs describe what **additional** expression shapes the property accepts; the constant form is always allowed. Four common shapes:

```json
"line-width": 2                                        // constant
"line-width": ["get", "width"]                         // data-driven
"line-width": ["interpolate", ["linear"], ["zoom"],    // zoom-driven
               10, 1, 15, 6]
"line-width": ["interpolate", ["linear"], ["zoom"],    // zoom + data-driven
               10, ["*", 0.5, ["get", "cls"]],
               15, ["*", 3.0, ["get", "cls"]]]
```

Not every property supports every shape — see per-property "Expression" rows in the layer docs (the MapLibre website calls these out under each property with badges like *data-driven*, *zoom-driven*).

## Common pitfalls

- Missing `source-layer` on a vector source: nothing renders, no warning.
- Layer on a non-existent source: entire layer is skipped silently on some builds, errors on others.
- `filter` without `["get", …]`: legacy shorthand works but is formally deprecated; new filters should use explicit `get`.
- Paint property on an unsupported type (e.g. `fill-color` on a `line` layer): style validator warns; renderer ignores.
- Very large numbers of layers (> ~300) hurt startup time — consolidate via data-driven paint rather than forking layers by category.
