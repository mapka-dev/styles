# `metadata.mapka.markers`

Declarative marker list. The Mapka SDK instantiates one `maplibregl.Marker` per entry at style-load time, honoring the provided options and optional click-/hover-bound popup.

- **Type:** `MapkaMarkerOptions[]`
- **Required:** no
- **Default:** —

```ts
interface MapkaMarkerOptions extends Omit<MarkerOptions, "color"> {
  id?: string;
  lngLat: [number, number];
  icon?: string;   // e.g. "maki:restaurant"; omit for default pin
  color?: string;  // CSS color for SVG fill; default "#3FB1CE"
  popup?: MapkaMarkerPopupOptions;
}
```

`MarkerOptions` is the upstream MapLibre [`MarkerOptions`](https://maplibre.org/maplibre-gl-js/docs/API/type-aliases/MarkerOptions/) (anchor, offset, draggable, rotation, etc.). Mapka overrides `color` to accept a plain CSS string.

## Properties

| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | string | no | Stable identifier for later lookup / removal. Auto-generated if omitted. |
| `lngLat` | `[number, number]` | yes | Marker position, `[longitude, latitude]`. |
| `icon` | string | no | Mapka icon id (sprite / maki). Omit to render the default teardrop pin. |
| `color` | string | no | CSS color applied to the SVG fill. Default pin uses `#3FB1CE` when unset. Ignored for non-default `icon`s that carry their own styling. |
| `popup` | `MapkaMarkerPopupOptions` | no | Popup bound to the marker. Shape = [`MapkaPopupOptions`](popup.md) without `lngLat` (inherited from the marker). |
| *…MarkerOptions* | | | `anchor`, `offset`, `draggable`, `rotation`, `rotationAlignment`, `pitchAlignment`, `opacity`, `opacityWhenCovered`, `clickTolerance`, … |

## Example

```json
{
  "metadata": {
    "mapka": {
      "markers": [
        {
          "id": "hq",
          "lngLat": [19.9370, 50.0614],
          "icon": "maki:restaurant",
          "color": "#e74c3c",
          "anchor": "bottom",
          "popup": {
            "trigger": "click",
            "content": {
              "title": "Restaurant",
              "description": "Open 10:00 – 23:00",
              "rows": [
                { "name": "Rating", "value": "4.6" },
                { "name": "Price",  "value": "$$"  }
              ]
            }
          }
        },
        {
          "lngLat": [19.9450, 50.0610]
        }
      ]
    }
  }
}
```

## Rules

- Markers are created once per style load. Mutating the array after load requires a style reload or direct SDK calls.
- `lngLat` is `[lng, lat]` — same convention as the rest of MapLibre.
- `popup.lngLat` is **omitted** (typed as `Omit<MapkaPopupOptions, "lngLat">`); the SDK anchors the popup to the marker.
- Marker popups differ from layer popups: marker popups take a full [`MapkaPopupContent`](popup.md#mapkapopupcontent) or an `HTMLElement`; layer popups take expression-capable templates. See [`popup.md`](popup.md).
