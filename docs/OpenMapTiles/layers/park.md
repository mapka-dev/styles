# `park`

Large protected/natural areas — national parks, nature reserves, protected areas, selected historic sites. Both polygons (for fills/outlines) and points (for labels).

- **Geometry:** Polygon + point.
- **Buffer size:** `4` px.
- **Data source:** OSM (`boundary=national_park`, `boundary=protected_area`, `leisure=nature_reserve`, selected `historic=*`).

## Fields

| Field | Type | On | Description |
| --- | --- | --- | --- |
| `class` | string | polygon + point | Park type. See below. |
| `name` | string | point only | OSM `name`. Also `name:xx`. |
| `name_en` | string | point only | Deprecated alias for `name:en`. |
| `name_de` | string | point only | Deprecated alias for `name:de`. |
| `rank` | int | point only | 1 = most important. |

### `class` values

Derived from the OSM `protection_title` tag (spaces → underscores), falling back to `protected_area` or the `boundary`/`leisure` tag. Common values:

- `national_park`
- `nature_reserve`
- `protected_area`
- Country/region-specific protection titles (e.g. `national_monument`, `national_forest`, `regional_park`).

Because this is free-form, **don't enumerate exhaustively** in filters — match what you care about and let the rest fall to a default paint.

## Styling notes

- Polygon: subtle green fill with a dashed green outline. Don't compete with `landcover=wood`.
- Point: label at the park centroid, filter by `rank` and zoom.
- Typical zoom ramp: national parks from z4–z5, nature reserves from z10+.
- Use a tree/leaf icon for national parks at higher zooms.
