# Layer names and groups

Reusable prompt for restructuring a Mapka base-map style so its layer IDs are
human-readable and its layers are grouped for the Mapka editor / legend UI.

## Inputs

Set `STYLE_DIR` to one of:

- `maputnik/osm-liberty`
- `openmaptiles/positron-gl-style`
- `openmaptiles/dark-matter-gl-style`
- `openmaptiles/osm-bright-gl-style`

All paths below are relative to the repo root unless noted.

## Required reading before you change anything

1. `docs/Mapka Style Specification/README.md`
2. `docs/Mapka Style Specification/layer-groups.md` — leaf vs. group shape,
   uniqueness, display-vs-render order.
3. `docs/Mapka Style Specification/layers.md` — per-layer `metadata.mapka`.
4. `docs/OpenMapTiles/README.md` and the per-layer pages under
   `docs/OpenMapTiles/layers/` — source-layer semantics (class/subclass
   filters) for the upstream vector tiles this style reads.
5. `docs/MapLibre Style Specification/layers.md` and the per-type pages — only
   the paint / layout / filter properties you may need to reason about.
   **You will not modify them.**
6. `$STYLE_DIR/style.json` — the style you are about to change.
7. `$STYLE_DIR/style-original.json` — the upstream file the importer pulls
   from. Treat as read-only.
8. `bin/import.ts` — the importer that rebuilds `style.json` from
   `style-original.json`. Any renames you make only survive the next
   `yarn import` if they also live here.

## Task

1. **Rename `layers[].id`** to short, descriptive, human-readable names.
   - **Case:** sentence case — first word capitalized, rest lowercase, spaces
     between words (e.g. `Road motorway casing`, `Water name line`,
     `Place city label`, `Building 3d`).
   - **Short and descriptive.** These ids surface directly in the grouped
     editor / legend UI, so optimize for readability at a glance. Two to four
     words is the target.
   - **Unique across the whole style.** Every `layers[].id` must be globally
     unique within the style (MapLibre requires this, and sentence case makes
     collisions easier — e.g. two different "Road" layers are not allowed).
     Disambiguate with a qualifier (`Road motorway`, `Road minor`,
     `Road motorway casing`) rather than numbering.
   - Use a single vocabulary across all four base styles so matching layers
     share the same id — this is the whole point of renaming.
   - Do not change a layer's `type`, `source`, `source-layer`, `filter`,
     `minzoom`, `maxzoom`, `paint`, `layout`, or position in the `layers[]`
     array. **Render order is `layers[]` order and must be preserved.**
2. **Propagate the rename** to every reference:
   - `layers[].id` (new value)
   - `metadata.mapka.layerGroups[...].value` leaves
   - Any `"ref": "<old_id>"` in other layers (MapLibre ref layers are rare in
     these base styles but check)
   - No other reference sites exist in this repo; do not grep outside
     `$STYLE_DIR`.
3. **Build a grouped `metadata.mapka.layerGroups` tree.**
   - Use the shapes in `docs/Mapka Style Specification/layer-groups.md`:
     leaf = `{ value }`, group = `{ value, label, icon, children }`.
   - `value` on groups: a short readable slug, unique within the style
     (e.g. `roads`, `roads_bridges`). Not referenced elsewhere.
   - `label`: Title Case, user-facing.
   - `icon`: must resolve against the active sprite. Use
     `maki:<name>` where the sprite has a maki icon, otherwise pick from
     `$STYLE_DIR/icons/`. When unsure, use `maki:map` for basemap roots,
     `maki:roadblock` for roads, `maki:town` for places, `maki:water`
     for hydrography, `maki:park` for green areas.
   - Target depth: 2–3 levels. Example top level:
     `Basemap > (Land, Water, Roads, Rail, Aviation, Buildings, Boundaries)`
     and `Labels > (Places, Roads, POI, Water names)`.
   - Every renamed layer id must appear exactly once in the tree. No
     duplicates, no missing ids. Ungrouped layers are allowed but discouraged;
     flag any you could not place.
4. **Update `bin/import.ts` so the rename + grouping survive re-sync.**
   - Add a rename map keyed by upstream `style-original.json` id → new Mapka
     id. Apply it when constructing `styleConfig.layers` and when building
     the `layerGroups` tree.
   - Replace the current flat `basemap` wrap at `bin/import.ts:37-47` with the
     same grouped tree you wrote into `style.json`.
   - `yarn import` in `$STYLE_DIR` must produce byte-equivalent output to
     the hand-edited `style.json` (modulo formatting, which `yarn format`
     normalizes).

## Output

Edit files in place:

- `$STYLE_DIR/style.json` — renamed layers + new `metadata.mapka.layerGroups`
- `bin/import.ts` — rename map + grouped-tree builder

Do not create new files.

## Verification

Run from `$STYLE_DIR`:

1. `yarn validate` — MapLibre style spec must pass.
2. `yarn format` — no diff after running twice.
3. `yarn import` — `style.json` must be unchanged (only re-formatted) after
   running. If it changes, the rename map or tree builder in `bin/import.ts`
   is out of sync with the hand-edited `style.json`; fix `bin/import.ts`, not
   `style.json`.
4. Sanity grep: every `layers[].id` appears exactly once as a leaf `value`
   under `metadata.mapka.layerGroups`, and every leaf `value` resolves to an
   existing `layers[].id`.

## Non-goals

- Do not touch `paint`, `layout`, `filter`, `minzoom`, `maxzoom`,
  `source-layer`, or layer order.
- Do not edit MapLibre spec docs, OpenMapTiles docs, or the Mapka style
  spec docs. They are reference only.
- Do not change `sources`, `sprite`, `glyphs`, `terrain`, `sky`, `light`,
  or `projection`.
- Do not add new layers or remove existing ones.
- Do not introduce markers or layer popups — this task is scoped to ids and
  `layerGroups`.

## Rules

- The four base styles share a single vocabulary of layer ids. When you run
  this prompt against the second/third/fourth style, reuse ids from the first
  wherever the same semantic layer exists upstream.
- A Mapka style must remain a valid MapLibre style with `metadata.mapka`
  stripped. Renames must not rely on Mapka-specific semantics.
- If an id can't be cleanly named without changing semantics, leave it and
  note it in your final report.
