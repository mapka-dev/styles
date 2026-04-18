# `sprite`

URL(s) for the icon atlas used by `symbol` layers (`icon-image`), `fill` patterns (`fill-pattern`), and `line-pattern`. Optional — only required if any layer references an icon.

- **Type:** string, or array of `{ id, url }` objects
- **Required:** no
- **Default:** —

## Single sprite (string)

```json
{ "sprite": "https://example.com/assets/sprite" }
```

The renderer probes four URLs:

- `.../sprite.json` — metadata (icon names, pixel extents)
- `.../sprite.png` — the atlas image
- `.../sprite@2x.json` — high-DPI metadata
- `.../sprite@2x.png` — high-DPI atlas image

Do **not** include the extension in the style — the renderer appends it.

Layers reference icons by name:

```json
{ "layout": { "icon-image": "airport" } }
```

## Multiple sprites (array)

Combine atlases without pre-merging:

```json
{
  "sprite": [
    { "id": "default",   "url": "https://example.com/base-sprite" },
    { "id": "roadsigns", "url": "https://example.com/roadsigns" },
    { "id": "shops",     "url": "https://example.com/shops" }
  ]
}
```

Reference icons with `spriteId:iconName`:

```json
{ "layout": { "icon-image": "roadsigns:stop" } }
```

### Exception: `default`

Icons in the sprite with `id: "default"` can be referenced **without** the prefix — same as the single-sprite case. This is what lets existing styles migrate to the array form without rewriting every `icon-image`.

## Sprite JSON schema

The `.json` file is an object keyed by icon name:

```json
{
  "airport": {
    "width": 24, "height": 24, "x": 0, "y": 0,
    "pixelRatio": 1,
    "sdf": false,
    "content": [4, 4, 20, 20],
    "stretchX": [[8, 16]],
    "stretchY": [[8, 16]],
    "textFitWidth": "stretchOrShrink",
    "textFitHeight": "proportional"
  }
}
```

- **`sdf: true`** — icon is a signed-distance field; `icon-color` / `icon-halo-*` apply. Use for monochrome shapes you want to tint at runtime.
- **`content`, `stretchX`, `stretchY`** — enable 9-slice scaling (useful for label backgrounds via `icon-text-fit`).
- **`textFitWidth`, `textFitHeight`** — per-axis policies for `icon-text-fit` on a stretchable sprite. Values: `"stretchOnly"`, `"proportional"`, or `"stretchOrShrink"` (default; backwards-compatible). Added in GL JS 4.2.0, Native Android 11.4.0, iOS 6.6.0.
- **`pixelRatio`** — set to 2 in the `@2x` JSON so the renderer knows raw pixel sizes.

## Generation

Tools: `spreet` (Rust), `node-spritezero`, `@mapbox/spritezero-cli`. Input is typically a folder of SVGs; output is `sprite.png` + `sprite.json` + `@2x` pair. `osm-liberty` and `openmaptiles` styles ship their sprites in the repo under each style's `sprites/` dir.

## Gotchas

- The style URL and sprite URL must be same-origin or CORS-enabled.
- Missing icons don't error — they silently render nothing. Check the dev-console: MapLibre logs "Image not found".
- Changing `icon-image` at runtime requires the icon to already exist in the atlas or to be added via `map.addImage()`.
