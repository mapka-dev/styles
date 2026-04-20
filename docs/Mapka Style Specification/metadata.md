# `metadata.mapka`

Root-level extension object. Lives under `metadata.mapka` on the style document. Opaque to the MapLibre renderer — consumed by the Mapka SDK.

- **Type:** object
- **Required:** no
- **Default:** —

```json
{
  "metadata": {
    "mapka": {
      "layerGroups": [ /* MapkaLayerTreeConfig */ ],
      "markers":     [ /* MapkaMarkerOptions[] */ ]
    }
  }
}
```

## Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `layerGroups` | `MapkaLayerTreeConfig` | — | Hierarchical tree grouping layer IDs. See [`layer-groups.md`](layer-groups.md). |
| `markers` | `MapkaMarkerOptions[]` | — | Declarative markers rendered by the SDK. See [`markers.md`](markers.md). |

Unknown keys under `metadata.mapka` are reserved for future use — do not write arbitrary data here. Put vendor-specific metadata under its own prefix (e.g. `metadata.maputnik`, `metadata["my-tool"]`).

## Relationship to `metadata`

`metadata` at the style root is an arbitrary object per the [MapLibre spec](../MapLibre%20Style%20Specification/metadata.md). Mapka reserves the single `mapka` key within it. All other keys are untouched and can be freely used by other tools.

```json
{
  "metadata": {
    "maputnik:renderer": "mlgljs",
    "openmaptiles:version": "3.x",
    "mapka": { "layerGroups": [] }
  }
}
```

## Per-layer extension

Layers carry their own `metadata.mapka` namespace for layer-scoped extensions (currently `popup`). Documented in [`layers.md`](layers.md).
