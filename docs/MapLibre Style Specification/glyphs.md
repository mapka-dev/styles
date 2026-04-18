# `glyphs`

URL template for signed-distance-field (SDF) glyph PBFs. Required if any `symbol` layer has `text-field`, with one exception — see "Local fonts" below.

- **Type:** string
- **Required:** no (required transitively whenever text is rendered, unless using local fonts on GL JS ≥ 5.11.0)
- **Default:** —

## Template

```json
{ "glyphs": "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf" }
```

Two mandatory tokens:

- **`{fontstack}`** — comma-separated list from a layer's `text-font` layout property, URL-encoded. E.g. `text-font: ["Noto Sans Regular", "Arial Unicode MS Regular"]` → `Noto%20Sans%20Regular,Arial%20Unicode%20MS%20Regular`.
- **`{range}`** — a Unicode code-point range of 256, formatted `start-end` (decimal). Covers blocks like `0-255` (Basic Latin + Latin-1), `256-511` (Latin Extended-A), etc.

The renderer requests only the ranges it needs, on demand, as characters come into view.

## Format

Each PBF is a protobuf-encoded collection of SDF glyphs (one per code point in the range). SDFs let the shader render crisp text at any scale. Pre-rendered bitmap fonts are **not** supported.

## Producing glyphs

- `fontnik` (Node): `fontnik convert font.ttf --out ./fonts/FontName/` — emits `0-255.pbf`, `256-511.pbf`, …
- `font-maker` (Rust): batch alternative.
- Off-the-shelf font sets: `@maplibre/maplibre-gl-fonts` bundles Noto variants.

Directory layout on disk:

```
fonts/
  Noto Sans Regular/
    0-255.pbf
    256-511.pbf
    …
```

Serve statically and point `glyphs` at it.

## Local fonts

GL JS ≥ 5.11.0 lets you omit `glyphs` entirely and render every label from the browser's local font stack (effectively delegating to the OS text shaper). Practical when you don't want to host a PBF tree and only need common scripts. Native Android / iOS still require `glyphs` — tracked in [maplibre-native #165](https://github.com/maplibre/maplibre-native/issues/165).

Separately, the GL JS map constructor option `localIdeographFontFamily` replaces only CJK glyphs with a local family — the rest still come from `glyphs`. Orthogonal to the omit-entirely path above.

## Interaction with `font-faces`

[`font-faces`](font-faces.md) is a newer mechanism for pointing at TTF/OTF files instead of pre-baked PBFs. When both are defined, font-faces take priority for matched unicode ranges; unmatched code points fall back to `glyphs`.

## Gotchas

- A style with `text-field` but no `glyphs` silently renders no labels. No error, no warning.
- Font name must match the PBF directory exactly — including spaces and case.
- Large glyph sets (CJK, emoji) can be hundreds of MB on disk. Serve with gzip/brotli — individual PBFs compress well.
- `localIdeographFontFamily` (map constructor option, not the style) lets JS renderers bypass glyph PBFs for CJK and use local system fonts. Reduces bandwidth for Chinese/Japanese/Korean label-heavy maps.
