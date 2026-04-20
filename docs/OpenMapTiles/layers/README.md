# OpenMapTiles Layers — Index

One file per layer. Schema source: <https://openmaptiles.org/schema/>.

For shared conventions (name/language fields, `class`/`subclass`, `rank`, `brunnel`, `intermittent`, buffer sizes, zoom strategy), see `../openmaptiles.md`.

| Layer | Geometry | Buffer | Primary source |
| --- | --- | --- | --- |
| [aerodrome_label](aerodrome_label.md) | point | 64 | OSM |
| [aeroway](aeroway.md) | polygon / line | 4 | OSM |
| [boundary](boundary.md) | line (+ polygon) | 4 | Natural Earth ≤z4, OSM ≥z5 |
| [building](building.md) | polygon | 4 | OSM |
| [housenumber](housenumber.md) | point | 8 | OSM |
| [landcover](landcover.md) | polygon | 4 | Natural Earth (ice) + OSM |
| [landuse](landuse.md) | polygon | 4 | Natural Earth (urban) + OSM |
| [mountain_peak](mountain_peak.md) | point | 64 | OSM |
| [park](park.md) | polygon + point | 4 | OSM |
| [place](place.md) | point (+ polygon) | 256 | Natural Earth + OSM |
| [poi](poi.md) | point | 64 | OSM |
| [transportation](transportation.md) | line | 4 | OSM |
| [transportation_name](transportation_name.md) | line | 8 | OSM (requires `transportation`) |
| [water](water.md) | polygon | 4 | Natural Earth ≤z5, OSM ≥z6 |
| [water_name](water_name.md) | point / line | 256 | OSM + lake_centerline |
| [waterway](waterway.md) | line | 4 | Natural Earth z3–z8, OSM z9+ |
