# `metadata.mapka.layerGroups`

Hierarchical grouping of layer IDs, used by the Mapka editor and legend/control UI to render collapsible layer trees. Purely organizational — has no effect on render order, which is still governed by the position of each entry in `layers[]`.

- **Type:** `MapkaLayerTreeConfig` — array of `MapkaLayerConfig | MapkaLayerGroupConfig`
- **Required:** no
- **Default:** —

```ts
type MapkaLayerTreeConfig = (MapkaLayerConfig | MapkaLayerGroupConfig)[];

interface MapkaLayerConfig {
  value: string; // layer id (must exist in layers[])
}

interface MapkaLayerGroupConfig {
  value: string;                 // unique group id (randomly generated)
  label: string;                 // human-readable label
  icon: string;                  // icon id (sprite/maki)
  children: MapkaLayerTreeConfig;
}
```

## Discriminator

Items in a tree are distinguished structurally:

| Shape | Meaning |
| --- | --- |
| `{ value }` | Leaf — reference to a layer by `id` |
| `{ value, label, icon, children }` | Group — container with nested children |

A layer ID must appear **at most once** across the entire tree. A layer that is not referenced is still rendered; it simply won't show up in the grouped UI.

## Example

```json
{
  "metadata": {
    "mapka": {
      "layerGroups": [
        {
          "value": "basemap",
          "label": "Basemap",
          "icon": "maki:map",
          "children": [
            { "value": "background" },
            { "value": "water" },
            {
              "value": "roads",
              "label": "Roads",
              "icon": "maki:roadblock",
              "children": [
                { "value": "road_minor" },
                { "value": "road_motorway" }
              ]
            }
          ]
        },
        {
          "value": "labels",
          "label": "Labels",
          "icon": "maki:town",
          "children": [
            { "value": "place_city" },
            { "value": "country_1" }
          ]
        }
      ]
    }
  }
}
```

## Properties — `MapkaLayerConfig` (leaf)

| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| `value` | string | yes | Must equal an `id` in `layers[]`. A layer can belong to at most one group. |

## Properties — `MapkaLayerGroupConfig` (group)

| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| `value` | string | yes | Unique group id. Generated randomly by tooling; not referenced from anywhere else. |
| `label` | string | yes | Human-readable name shown in the layer tree. |
| `icon` | string | yes | Icon identifier for the group header (e.g. `maki:map`). Resolved against the active sprite / icon set. |
| `children` | `MapkaLayerTreeConfig` | yes | Nested leaves and groups. May be empty. Groups may nest arbitrarily deep. |

## Rules

- **Order is display order** in the group tree, not render order. Reordering `layerGroups` has no visual effect on the map.
- **Render order is `layers[]`.** If a group's children are re-ordered for UI purposes the corresponding `layers[]` entries are not moved — keep them in sync if visual order matters.
- **No duplicate `value` on leaves.** A layer referenced twice is undefined behavior.
- **Missing references are ignored.** A leaf pointing at a non-existent layer id is silently skipped by the SDK.
