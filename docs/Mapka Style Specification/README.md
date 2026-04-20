# Mapka Style Specification — Reference

Mapka extends the [MapLibre Style Specification](../MapLibre%20Style%20Specification/README.md) with a small set of non-rendering extensions carried under the `mapka` namespace in `metadata`. The renderer ignores them; the [Mapka SDK](https://github.com/mapka-dev/sdk) consumes them to drive layer-group UI, popups, and declarative markers.

Upstream type source: [`@mapka/maplibre-gl-sdk/src/types/style.ts`](https://github.com/mapka-dev/sdk/blob/master/packages/maplibre-gl-sdk/src/types/style.ts).

```ts
interface MapkaStyleSpecification extends StyleSpecification {
  metadata?: {
    mapka?: {
      layerGroups?: MapkaLayerTreeConfig;
      markers?: MapkaMarkerOptions[];
    };
  };
  layers: MapkaLayerSpecification[];
}
```

A Mapka style is a superset — strip the `mapka` keys and it is a valid MapLibre style.

## Extension points

| Location | Property | Purpose |
| --- | --- | --- |
| [`metadata.mapka.layerGroups`](layer-groups.md) | `MapkaLayerTreeConfig` | Hierarchical grouping of layer IDs for editor / legend UI |
| [`metadata.mapka.markers`](markers.md) | `MapkaMarkerOptions[]` | Declarative markers added alongside the map |
| [`layers[].metadata.mapka.popup`](layers.md) | `MapkaLayerPopupOptions \| boolean` | Feature-click popup bound to a layer |

## Namespacing

All Mapka-specific data lives under a single `mapka` key at each extension point. This keeps the style forward-compatible with other tools (Maputnik, MapTiler) and satisfies the MapLibre convention of prefixing metadata entries (see [`metadata.md`](../MapLibre%20Style%20Specification/metadata.md)).

## Minimal Mapka-enabled style

```json
{
  "version": 8,
  "name": "Example",
  "metadata": {
    "mapka": {
      "layerGroups": [
        { "value": "basemap", "label": "Basemap", "children": [{ "value": "background" }] }
      ]
    }
  },
  "sources": {
    "osm": {
      "type": "raster",
      "tiles": ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
      "tileSize": 256
    }
  },
  "layers": [
    { "id": "background", "type": "background", "paint": { "background-color": "#fff" } }
  ]
}
```
