# `place`

Populated places and political subdivisions — continents, countries, states, cities, villages, islands, aboriginal lands. One of the two most important label layers (the other is `transportation_name`).

> Upstream: [openmaptiles/layers/place/place.yaml](https://github.com/openmaptiles/openmaptiles/blob/master/layers/place/place.yaml) · [schema page](https://openmaptiles.org/schema/#place)

- **Geometry:** Point (primary), polygon (for islands and aboriginal lands).
- **Buffer size:** `256` px — very large, so big labels don't disappear when their anchor sits outside the tile.
- **Data sources:**
  - Natural Earth: `ne_10m_admin_1_states_provinces`, `ne_10m_admin_0_countries`, `ne_10m_populated_places`.
  - OSM: `place=*`, `boundary=aboriginal_lands`.
- **Requires:** `boundary` layer.

## Fields

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | OSM `name`. Also `name:xx`. |
| `name_en` | string | Deprecated alias for `name:en`. |
| `name_de` | string | Deprecated alias for `name:de`. |
| `capital` | int | Admin level of the boundary for which this place is the capital. Values: `2`, `3`, `4`, `5`, `6`. `2` = national capital. |
| `class` | enum | See below. |
| `iso_a2` | string | ISO 3166-1 alpha-2 code (country class only). |
| `rank` | int | Importance. See below. |

### `class` values

- `continent`
- `country`
- `state`
- `province`
- `city`
- `town`
- `village`
- `hamlet`
- `borough`
- `suburb`
- `quarter`
- `neighbourhood`
- `isolated_dwelling`
- `island`
- `aboriginal_lands`

### `rank`

- Countries / states: `1`–`6`. Combined Natural Earth `scalerank` + `labelrank` + `datarank`.
- Cities: `1`–`10` for globally important cities (NE-scored), then `10+` for local-rank cities derived from population and city class.

Lower `rank` = more important, show earlier.

### `capital`

- `2` — national capital (Paris, Tokyo).
- `3` — capital of a first-order region in federal systems.
- `4` — state/province capital.
- `5` / `6` — lower-order administrative capitals.

## Styling notes

- Build a **text hierarchy**: `country` biggest + tracked, `state` italic SMALL CAPS, `city` bold, `town` regular, `village` lighter, `hamlet` smallest.
- `capital=2` usually gets a star icon or larger size.
- Use `rank` to cap density: filter `rank <= N` per zoom.
- `island` is polygon (for hit-testing) and point (for label placement).
- `iso_a2` is handy for localized label switching or flag icons.
- Always use `coalesce(name:xx, name)` for language switching.
