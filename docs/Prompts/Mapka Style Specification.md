# Mapka Style Specification docs

Refresh `docs/Mapka Style Specification/` from the canonical SDK types.

## Sources of truth

Canonical types live in `mapka-dev/sdk` under `packages/maplibre-gl-sdk/src/types/`. Fetch individual files via:

```
gh api repos/mapka-dev/sdk/contents/packages/maplibre-gl-sdk/src/types/<file>.ts --jq .content | base64 -d
```

Currently known carriers (expect this list to grow):

- `style.ts`  — `MapkaStyleSpecification`, root `metadata.mapka` shape
- `layer.ts`  — `MapkaLayerTreeConfig`, `MapkaLayerConfig`, `MapkaLayerGroupConfig`, `LayerWithMapkaMetadata`, `MapkaLayerSpecification`
- `marker.ts` — `MapkaMarkerOptions`
- `popup.ts`  — `MapkaPopupOptions`, `MapkaPopupContent`, `MapkaPopupCreator`, `MapkaLayerPopupOptions`, `MapkaLayerPopupContent`, `MapkaMarkerPopupOptions`

Treat these as authoritative. Do not invent fields or defaults; if a property is missing from the types, omit it or mark it explicitly as SDK-side behavior.

## Discovery — find every `metadata.mapka` carrier

Metadata extensions may attach at any level the MapLibre spec permits `metadata` (style root, `sources[…]`, `layers[…]`, `sprite`, `glyphs`, future additions). Before writing, enumerate every such carrier currently defined in the SDK:

1. List the types directory: `gh api repos/mapka-dev/sdk/contents/packages/maplibre-gl-sdk/src/types --jq '.[].name'`.
2. Fetch each `*.ts` file and scan for `metadata` or `mapka` identifiers:
   - Any interface whose `metadata` field narrows to include a `mapka?: { … }` shape.
   - Any type aliased to `<Upstream> & { metadata?: { mapka?: … } }` (e.g. `MapkaLayerSpecification = LayerSpecification & LayerWithMapkaMetadata`).
   - Any top-level `Mapka<Thing>Specification extends <Upstream>Specification`.
3. For each carrier found, note: the carrier (root / source / layer / sprite / glyphs / …), the `mapka` shape, and which upstream type it extends.

Every carrier discovered in step 3 must be documented. Carriers that exist upstream but carry no `mapka` extension yet are out of scope — do not pre-document empty shapes.

## Output

One file per carrier / extension point under `docs/Mapka Style Specification/`. Current files:

- `README.md`        — overview, `MapkaStyleSpecification` shape, **extension-points table covering every carrier** (root, source, layer, sprite, glyphs, …), namespacing note, minimal example
- `metadata.md`      — root `metadata.mapka` object and its children
- `layer-groups.md`  — `MapkaLayerTreeConfig` (leaf vs. group discriminator, rules, nested example)
- `markers.md`       — `MapkaMarkerOptions` (extends MapLibre `MarkerOptions`; document the `color` override and `icon`/`popup` additions)
- `layers.md`        — per-layer `metadata.mapka` (currently `popup: MapkaLayerPopupOptions | boolean`)
- `popup.md`         — marker-popup vs. layer-popup, `trigger` semantics, shorthand `true`/`false`, comparison table

When discovery turns up a new carrier (e.g. `sources[id].metadata.mapka`, `sprite` metadata, a future top-level key), add a dedicated file named after the carrier (`sources.md`, `sprite.md`, …) and:

1. Add a row to the extension-points table in `README.md`.
2. Add a subsection / link in `metadata.md` if the carrier is keyed under `metadata.mapka` rather than a sibling object.
3. Cross-link from the new file back to the matching `../MapLibre Style Specification/*.md` carrier page.

Otherwise edit existing files in place.

## Style

Match `docs/MapLibre Style Specification/` conventions:

- Terse, direct prose. No marketing voice. No emojis.
- Each property documented in a markdown table: `Property | Type | Required/Default | Notes`.
- One JSON sample per file showing a realistic style fragment.
- TypeScript block at the top of each file quoting the relevant interface(s).
- Cross-link to `../MapLibre Style Specification/*.md` where the Mapka extension sits on top of a MapLibre concept (e.g. `metadata`, `MarkerOptions`, `PopupOptions`).
- Close each file with a `## Rules` section for invariants / gotchas (uniqueness, ordering, no-op cases).

## Rules

- Stay strictly within `metadata.mapka` at every carrier (root, `sources[…]`, `layers[…]`, `sprite`, `glyphs`, future additions). Do not document unrelated `metadata` keys from other tools.
- Link to upstream MapLibre types (`MarkerOptions`, `PopupOptions`, `StyleSpecification`) by URL rather than re-documenting them.
- A Mapka style must remain a valid MapLibre style with Mapka keys stripped — state this in `README.md`.
- If the SDK type shape changed since the last refresh, reflect the new shape and remove anything that was deleted upstream. Do not leave stale fields for backwards compatibility.
- Do not create a CHANGELOG or migration doc. Git history covers that.
