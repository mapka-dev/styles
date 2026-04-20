# `building`

Every OSM feature with `building=*`, excluding features explicitly tagged underground (`location=underground`). Supports 2D extrusion-free rendering and 3D extrusions via `render_height`.

> Upstream: [openmaptiles/layers/building/building.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/building/building.yaml) · [schema page](https://openmaptiles.org/schema/#building)

- **Geometry:** Polygon.
- **Buffer size:** `4` px.
- **Data source:** OpenStreetMap only.
- **Key field:** `osm_id`.
- **Typical minzoom:** ~13 (full detail at z14).

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `render_height` | number | Approximate total height (meters), derived from `height` or `building:levels` (`levels × 3m`). |
| `render_min_height` | number | Approximate bottom height (meters), for `building:part` that sit on top of another part. |
| `colour` | string | Building color (from `building:colour` / `building:material`). CSS-style. |
| `hide_3d` | bool | `true` for building outlines that should not be extruded (to avoid doubling with `building:part` layers). |

No name or address on this layer — names live in `poi`, addresses in `housenumber`.

## Styling notes

- 2D: single fill paint with a subtle outline. Show from z13.
- 3D extrusion: `fill-extrusion-height` = `render_height`, `fill-extrusion-base` = `render_min_height`, `fill-extrusion-color` = `coalesce(colour, default)`. Filter out `hide_3d=true`.
- Fade in extrusions between z14 and z15 to avoid a visual "pop".
- Use `feature-state` for hover/highlight — `osm_id` is stable across tiles.
