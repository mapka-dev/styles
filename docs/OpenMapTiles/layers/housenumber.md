# `housenumber`

Features with `addr:housenumber` tags, for labeling street numbers. Adds significant weight to z14 tiles.

- **Geometry:** Point (building centroid when the tag is on a building polygon).
- **Buffer size:** `8` px.
- **Data source:** OpenStreetMap only.
- **Typical minzoom:** 14 (z14 only in practice).

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `housenumber` | string | `addr:housenumber`. If multiple values are `;`-separated, the first and last are joined with a dash (e.g. `5;7;9` → `5-9`). |

No street or city fields — those come from OSM indirectly, and styles usually don't need them to label numbers.

## Deduplication

Duplicates on the same street or block number within a single tile are dropped. Records without `name` are **prioritized for preservation** (a named POI with a number overrides a plain address point).

## Styling notes

- Show from z16 in most basemaps; z14 is rarely useful because the labels are too dense.
- Keep the font small and desaturated so numbers sit under POI/road labels.
- No collision group beyond `symbol-sort-key` — typical pattern is to use a low priority and a small text-padding.
