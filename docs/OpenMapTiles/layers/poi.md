# `poi`

Points of interest: shops, amenities, sport, tourism, transport stops. Dense — must be rank-filtered aggressively at each zoom level.

> Upstream: [openmaptiles/layers/poi/poi.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/poi/poi.yaml) · [schema page](https://openmaptiles.org/schema/#poi)

- **Geometry:** Point (primary). Some POIs are polygons — building footprints or polygon-tagged amenities promoted via `update_poi_polygon.sql`.
- **Buffer size:** `64` px.
- **Data source:** OSM — `amenity`, `barrier`, `historic`, `information`, `landuse`, `leisure`, `railway`, `shop`, `sport`, `station`, `religion`, `tourism`, `aerialway`, `building`, `highway`, `office`, `waterway`.
- **Typical minzoom:** 12 → 14 depending on `rank`.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx`. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `class` | enum | High-level bucket. |
| `subclass` | string | Raw OSM tag value. |
| `rank` | int | Importance within the grid cell at z14 — use to thin labels. |
| `agg_stop` | `1` / null | **Experimental**. Marks the main platform among aggregated public-transit nodes. |
| `level` | string | Raw OSM `level` tag (indoor floor). |
| `layer` | int | Raw OSM `layer` tag. |
| `indoor` | `1` / null | Indoor POI marker. |

### `class` values

`shop`, `office`, `town_hall`, `golf`, `fast_food`, `park`, `bus`, `railway`, `aerialway`, `entrance`, `campsite`, `laundry`, `grocery`, `library`, `college`, `lodging`, `ice_cream`, `post`, `cafe`, `school`, `alcohol_shop`, `bar`, `harbor`, `car`, `hospital`, `cemetery`, `attraction`, `beer`, `music`, `stadium`, `art_gallery`, `clothing_store`, `swimming`, `castle`, `atm`, `fuel`, `zoo`.

> Providers (MapTiler, Stadia) sometimes add classes. Don't assume this list is closed.

### `subclass`

Original OSM tag value — e.g. `restaurant`, `supermarket`, `pharmacy`, `bus_stop`, `hotel`, `fuel`, `pharmacy`, `atm`, `museum`. Use this to pick the icon, and `class` to decide whether to render at all at a given zoom.

### `rank`

Computed per z14 grid cell. Use it as the primary zoom gate:

```json
["all", ["<=", ["get", "rank"], 3]]
```

at z14, relaxing to `rank <= 5` at z15 and unfiltered at z17.

## Styling notes

- Assign icons by `subclass` (fallback to `class`, then to a generic dot).
- Text + icon collisions: use `text-optional: true` for dense areas.
- `layer` and `indoor` are useful for indoor maps; most outdoor basemaps ignore them.
- Do not rely on `agg_stop` — experimental, may change.
- Filter by `class in [...]` for curated POI visibility (common in minimalist styles like Positron).
