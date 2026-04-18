# Layer specification cleanup

Reusable prompt for consolidating and modernizing the `layers[]` of a Mapka
base-map style: merge redundant siblings into single filter/expression-driven
layers, upgrade legacy function/filter syntax to the current MapLibre
expression form, and drop layers whose visual contribution is negligible.

## Inputs

Set `STYLE_DIR` to one of:

- `maputnik/osm-liberty`
- `openmaptiles/positron-gl-style`
- `openmaptiles/dark-matter-gl-style`
- `openmaptiles/osm-bright-gl-style`

All paths below are relative to the repo root unless noted.

## Required reading before you change anything

1. `docs/MapLibre Style Specification/layers.md` and every page under
   `docs/MapLibre Style Specification/layers/` for the types you touch.
2. `docs/MapLibre Style Specification/expressions.md` — `match`, `case`,
   `interpolate`, `step`, `coalesce`, `let`/`var`, `concat`, `format`,
   `geometry-type`, zoom expressions.
3. `docs/MapLibre Style Specification/deprecations.md` — legacy `{base,
   stops}` functions, legacy filter short form, `raster-resampling` →
   `resampling`.
4. `docs/MapLibre Style Specification/types.md` — filter syntax and data vs.
   zoom-and-feature expression distinctions.
5. `docs/OpenMapTiles/README.md` and the per-layer pages under
   `docs/OpenMapTiles/layers/` — which `class` / `subclass` / `brunnel` /
   `ramp` / `oneway` attributes are available per source-layer, so your
   merged `match`/`case` expressions are grounded in the schema.
6. `docs/Mapka Style Specification/layer-groups.md` and `.../layers.md` —
   invariants that govern what `metadata.mapka.layerGroups` and per-layer
   `metadata.mapka` must still look like after the cleanup.
7. `$STYLE_DIR/style.json` — the file you will edit.
8. `$STYLE_DIR/style-original.json` — upstream; read-only reference for what
   the importer will regenerate.
9. `bin/import.ts` — the importer that rebuilds `style.json`. Any merges,
   deletions, or rewrites you make only survive the next `yarn import` if
   they also live here.

## Task

### 1. Mechanical modernization pass first

Do this before merging or deleting anything, so subsequent diffs are minimal.

- Run `npx @maplibre/maplibre-gl-style-spec gl-style-migrate < style.json >
  style.json.tmp && mv style.json.tmp style.json` on `$STYLE_DIR/style.json`.
  This rewrites legacy `{base, stops}` functions, `type: "categorical"`
  functions, and legacy filter shorthand into expression form.
- Hand-audit everything `gl-style-migrate` did not catch:
  - Replace any surviving legacy filter shorthand (`["==", "k", v]`) with
    expression form (`["==", ["get", "k"], v]`).
  - Replace `raster-resampling` with `resampling` on `raster` layers.
  - Replace zoom functions of the shape `{ "stops": [[z, v], ...] }` with
    explicit `["interpolate", ["linear"|"exponential", base], ["zoom"], ...]`.
  - Replace `$type` / `$id` in filters with `["geometry-type"]` / `["id"]`.
  - Promote `case`/`match` where a long chain of zoom-gated layers duplicates
    styling differing only by a single attribute.
- Prefer `match` over `case` when the discriminator is a single property
  compared against disjoint values. Prefer `case` for boolean predicates.
- Use `let`/`var` to deduplicate a repeated sub-expression (e.g. a zoom
  ramp applied to both `line-width` and `line-gap-width`).

### 2. Merge candidates

A pair (or group) of layers is a merge candidate when **all** of the
following hold:

- Same `type` (don't merge `line` into `fill`, or `symbol` into `line`).
- Same `source` and same `source-layer`.
- Same `minzoom` / `maxzoom` effective range, **or** ranges that can be
  expressed as a zoom-gated expression on the differentiating property.
- The filters are disjoint over a single (or small set of) property values —
  the classic case is `class` or `subclass` on OpenMapTiles `transportation`
  / `landuse` / `landcover` / `poi`.
- The differing paint/layout properties can be expressed as a `match` / `case`
  / `step` / `interpolate` expression on that same property.
- Render order is not visually load-bearing between the two — i.e. no
  other layer renders between them in `layers[]`. If another layer sits
  between them they **cannot** be merged.

When merging:

- The merged layer takes the **lowest** `layers[]` index of the originals,
  so anything that used to render above the group still renders above it.
- Combine filters with `any`/`in` on the differentiating property, then
  push the per-class differences into the paint/layout expression.
- Preserve every paint/layout property that differed between originals.
  If a property appears on some originals and not others, treat the missing
  ones as the MapLibre default for that property and make the expression
  fall through to that default.
- The resulting layer's `id` replaces all originals. Pick the most general
  id (e.g. `Road motorway`) and drop the specific ones.

Do **not** merge when:

- Casing and fill are separate layers — they must stay separate because
  casing has to render first. Merge sibling casing layers with each other,
  and sibling fills with each other, but never a casing with its fill.
- A bridge/tunnel `brunnel` variant visually requires a distinct render
  position relative to non-bridge/tunnel siblings.
- The merge would require more than two levels of nested `match`/`case` to
  stay readable. Optimize for reviewability, not minimum layer count.

### 3. Deletion candidates

Flag for deletion any layer where at least one is true:

- **No visible output** at any zoom across any representative area: empty
  filter match against the current tileset schema, or `paint` that reduces
  it to transparent/zero-width (e.g. `fill-opacity: 0`, `line-width: 0`).
- **Visibility `none`** with no runtime toggle in `bin/import.ts` or the
  SDK — a dead layer.
- **Source-layer missing** from the tileset (cross-reference with
  `docs/OpenMapTiles/layers/`).
- **Duplicate** of another layer with the same filter and near-identical
  paint (< a handful of pixels of visual difference at any zoom).
- **Marginal contribution** — the layer is technically visible but removing
  it produces no perceivable change in a representative viewport at the
  style's intended zoom range. Examples: decorative overlays below 10% opacity
  stacked on top of identical features, stub layers for never-populated
  subclasses.

Do **not** delete without flagging:

- Water, major roads (motorway/trunk/primary), administrative boundaries,
  place labels, country labels — these are load-bearing even when subtle.
  If you believe one qualifies for deletion, stop and ask the user.

Emit a short report at the end of your run listing each deleted layer with
a one-line justification.

### 4. Propagate every change

For each merge and deletion, update:

- `layers[]` — remove merged/deleted entries, keep merged result at the
  lowest original index.
- `metadata.mapka.layerGroups` — remove leaves that pointed at deleted or
  now-absent ids; for a merge, collapse the originals into a single leaf
  with the merged id; verify no duplicate `value` and no dangling leaves.
- Any `"ref": "<old_id>"` in other layers (uncommon in these styles, but
  check).
- `bin/import.ts` — update the rename map **and** the grouped tree builder
  introduced by `docs/Prompts/Layer names and groups.md` so `yarn import`
  reproduces the post-cleanup `style.json` byte-for-byte.

## Output

Edit files in place:

- `$STYLE_DIR/style.json` — merged/deleted/modernized layers and updated
  `metadata.mapka.layerGroups`.
- `bin/import.ts` — reflect the same merges, deletions, and rename map so
  re-syncs don't undo the cleanup.

Do not create new files.

At the end of your run, print:

1. Count of layers before and after.
2. Bulleted list of merges: `[old_id_1, old_id_2, …] → new_id`.
3. Bulleted list of deletions with one-line justification each.
4. Bulleted list of modernization rewrites worth calling out (anything
   beyond `gl-style-migrate`'s mechanical output).

## Verification

Run from `$STYLE_DIR`:

1. `yarn validate` — must pass against the current MapLibre style spec.
2. `yarn format` — no diff after running twice.
3. `yarn import` — `style.json` must be unchanged afterward. If it changes,
   the merge/delete/rename logic in `bin/import.ts` is out of sync with
   `style.json`; fix `bin/import.ts`, not `style.json`.
4. Visual parity check at zooms `{0, 4, 8, 12, 15, 17}` on three viewports:
   a dense urban center, a mixed park/water edge, and a motorway junction.
   A merged layer must be visually indistinguishable from the originals.
   A deleted layer must not produce a visible regression.
5. Sanity grep: every `layers[].id` appears exactly once as a leaf `value`
   under `metadata.mapka.layerGroups`; every leaf `value` resolves to an
   existing `layers[].id`; no `id` is used twice.

## Non-goals

- **Not a re-skin.** Do not change the palette, line weights, font stacks,
  icon choices, or label placement rules. Visual output before/after the
  cleanup must match.
- Do not change `sources`, `sprite`, `glyphs`, `terrain`, `sky`, `light`,
  or `projection`.
- Do not introduce new layers, new features, markers, or layer popups.
- Do not modify docs under `docs/MapLibre Style Specification/`,
  `docs/OpenMapTiles/`, or `docs/Mapka Style Specification/`.
- Do not rename ids. If `docs/Prompts/Layer names and groups.md` has
  already run, keep its sentence-case ids as the canonical vocabulary; if
  it hasn't, leave ids alone and let that prompt run after.

## Rules

- Changes must be justifiable from either MapLibre spec behavior or visible
  rendering. No stylistic rewrites for their own sake.
- When two correct forms exist (e.g. `match` vs. `case`), pick the one that
  reads most directly against the OpenMapTiles schema the filter is
  discriminating on.
- If a merge grows a single paint property into a >20-line expression, it's
  probably not a merge — split it back out.
- A Mapka style must remain a valid MapLibre style with `metadata.mapka`
  stripped.
- Stop and ask before: deleting any load-bearing layer (water, major roads,
  boundaries, place/country labels); restructuring that loses visual parity
  that you can't fully justify.
