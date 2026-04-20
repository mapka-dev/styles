# `font-faces`

Newer alternative to [`glyphs`](glyphs.md) — reference actual font files (TTF/OTF) and let the renderer shape them client-side. Primary motivation is support for complex scripts (Devanagari, Khmer, Arabic, …) that SDF glyph PBFs shape incorrectly.

- **Type:** object (font-name → string URL | array of `{url, unicode-range?}`)
- **Required:** no
- **Default:** —

## SDK support

- **MapLibre Native Android** ≥ 11.13.0
- **MapLibre Native iOS** ≥ 6.18.0
- **MapLibre GL JS** — **not supported** (use `glyphs`)

If you ship a style to the web today, `font-faces` is effectively inert.

## Shape

```json
{
  "font-faces": {
    "Noto Sans Devanagari": "https://cdn.example.com/fonts/NotoSansDevanagari.ttf",
    "Noto Sans": [
      {
        "url": "https://cdn.example.com/fonts/NotoSans-Latin.ttf",
        "unicode-range": ["U+0-24F"]
      },
      {
        "url": "https://cdn.example.com/fonts/NotoSans-Cyrillic.ttf",
        "unicode-range": ["U+400-4FF", "U+500-527"]
      }
    ]
  }
}
```

## Sub-properties

| Key | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `url` | string | yes | — | Remote URL of the font file. TTF/OTF recommended. |
| `unicode-range` | `string[]` | no | `["U+0-10FFFF"]` | Which code points this file covers. Use to shard a font across scripts. |

`unicode-range` strings follow the CSS `@font-face` syntax: `"U+<start>-<end>"`, single code points `"U+<cp>"`, or wildcards `"U+4??"`.

## Resolution order

For each character in a label:

1. Walk the layer's `text-font` stack in order.
2. For each font, look at `font-faces[fontName]`. If the character is inside a declared `unicode-range`, use that URL.
3. If no `font-faces` match, fall back to `glyphs` (still useful as a safety net).
4. Unsupported character → tofu / dropped, depending on platform.

## Gotchas

- File format support is implementation-dependent — stick to TTF/OTF. Variable fonts and colored fonts are a coin flip.
- Large fonts slow first-label render; shard with `unicode-range` or pre-subset.
- Current web styles should keep `glyphs` defined and ignore this property until GL JS lands it.
- Font key must match the `text-font` entry exactly (case-sensitive).
