# `background` layer

Solid or patterned colour drawn behind every other layer. No `source`.

```json
{
  "id": "bg",
  "type": "background",
  "paint": {
    "background-color": "#efe9e1"
  }
}
```

## Paint properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `background-color` | color | `"#000000"` | Fill colour. Ignored if `background-pattern` is set. *Transitionable.* |
| `background-pattern` | resolvedImage | — | Sprite icon name for a tiled pattern fill. Wins over `background-color`. *Transitionable.* |
| `background-opacity` | number [0,1] | `1` | Layer opacity. *Transitionable.* |

## Layout properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `visibility` | `"visible"` \| `"none"` | `"visible"` | Cheap hide/show. |

## Usage notes

- Put as the first layer in the style to act as the canvas colour.
- A transparent `background-color` (e.g. `rgba(0,0,0,0)`) is rarely what you want — the map canvas behind it is implementation-defined (often transparent, sometimes white).
- `background-pattern` must name an icon already present in the [`sprite`](../sprite.md) atlas, or be added via `map.addImage`.
- Changing `background-color` at runtime is a single paint update — instant.
