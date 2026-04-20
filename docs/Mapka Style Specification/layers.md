# `layers[].metadata.mapka`

Per-layer Mapka extension. Lives under each layer's own `metadata.mapka` namespace alongside any existing metadata.

- **Type:** object
- **Required:** no
- **Default:** —

```ts
interface LayerWithMapkaMetadata {
  metadata?: {
    [key: string]: unknown;
    mapka?: {
      popup?: MapkaLayerPopupOptions | boolean;
    };
  };
}

type MapkaLayerSpecification = LayerSpecification & LayerWithMapkaMetadata;
```

`MapkaLayerSpecification` is the union `LayerSpecification & LayerWithMapkaMetadata`; every MapLibre layer type accepts the same `metadata.mapka` shape.

## Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `popup` | `MapkaLayerPopupOptions \| boolean` | — | Popup bound to feature interactions. `false` disables; `true` enables a default popup driven by feature properties. Object form customizes content via expressions. See [`popup.md`](popup.md#layer-popups). |

Other keys may appear on `metadata` from unrelated tools (Maputnik, OpenMapTiles) — untouched by Mapka.

## Example — expression-driven popup

```json
{
  "id": "poi_z14",
  "type": "symbol",
  "source": "openmaptiles",
  "source-layer": "poi",
  "metadata": {
    "mapka": {
      "popup": {
        "trigger": "click",
        "content": {
          "title": ["get", "name"],
          "description": ["get", "class"],
          "rows": [
            { "name": "Category", "value": ["get", "subclass"] },
            { "name": "Rank",     "value": ["get", "rank"] }
          ]
        }
      }
    },
    "maputnik:renderer": "mlgljs"
  },
  "layout": { "text-field": ["get", "name"] }
}
```

## Example — shorthand toggle

```json
{
  "id": "water_name_point",
  "type": "symbol",
  "source": "openmaptiles",
  "source-layer": "water_name",
  "metadata": {
    "mapka": { "popup": true }
  }
}
```

## Rules

- `metadata.mapka.popup` only fires on layer types that carry interactive geometry (`fill`, `line`, `circle`, `symbol`, `fill-extrusion`, `heatmap`). Setting it on `background`, `raster`, `hillshade` is a no-op.
- Expressions in `title` / `description` / `rows[].name` / `rows[].value` are evaluated against the feature properties at the click/hover point.
- `trigger` defaults to `"click"` if the object form is used without specifying it (see [`popup.md`](popup.md)).
