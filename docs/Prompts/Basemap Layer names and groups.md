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
   - `value` on groups: a random id, unique within the style. Not
     human-readable and not referenced from anywhere else — generate one
     per group with `yarn id` (see `bin/id.ts`).
   - `label`: Title Case, user-facing.
   - `icon`: required on every group (spec-mandated) and must resolve
     against the active sprite.
     - **Category groups** use `maki:<name>` or `temaki:<name>`
      https://github.com/mapbox/maki/tree/main/icons
      https://github.com/rapideditor/temaki/tree/main/icons
     - **The `Basemap` root** uses a non-maki icon basemap
   - **Depth: exactly 3 levels** — `Basemap` (single root) → category →
     layer leaf. Categories must contain only leaves; no nested groups.
   - **Single root, labels merged into categories.** There is no top-level
     `Labels` group. Label layers live inside the matching category: road
     labels under `Roads`, place labels under `Places`, water name labels
     under `Water`, POI labels under `POI`
   - Every renamed layer id must appear exactly once in the tree. No
     duplicates, no missing ids. Ungrouped layers are allowed but discouraged;
     flag any you could not place.

## Output

Edit files in place:

- `$STYLE_DIR/style.json` — renamed layers + new `metadata.mapka.layerGroups`

Do not create new files.

## Verification

Run from `$STYLE_DIR`:

1. `yarn validate` — MapLibre style spec must pass.
2. `yarn format` — no diff after running twice.`.
3. Sanity grep: every `layers[].id` appears exactly once as a leaf `value`
   under `metadata.mapka.layerGroups`, and every leaf `value` resolves to an
   existing `layers[].id`.
4. Depth check: exactly two tiers of groups. The single top-level `Basemap`
   group contains only category groups; each category group contains only
   leaves. No group is nested three deep.

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

- `metadata.mapka.layerGroups` has a fixed shape: one `Basemap` root whose
  children are category groups, whose children are layer leaves. No deeper
  nesting. Labels live inside the matching category — never in a separate
  top-level `Labels` group. Only category groups use `maki:` icons; the
  `Basemap` root uses a non-maki sprite icon from `$STYLE_DIR/icons/`.
- The four base styles share a single vocabulary of layer ids. When you run
  this prompt against the second/third/fourth style, reuse ids from the first
  wherever the same semantic layer exists upstream.
- A Mapka style must remain a valid MapLibre style with `metadata.mapka`
  stripped. Renames must not rely on Mapka-specific semantics.
- If an id can't be cleanly named without changing semantics, leave it and
  note it in your final report.
