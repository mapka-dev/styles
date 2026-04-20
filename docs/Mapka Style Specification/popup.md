# Popups

Mapka defines two related popup shapes:

| Use site | Type | Content accepts |
| --- | --- | --- |
| [Markers](markers.md) (`metadata.mapka.markers[].popup`) | `MapkaMarkerPopupOptions` | Literal content, HTMLElement, or factory function |
| [Layers](layers.md) (`layers[].metadata.mapka.popup`) | `MapkaLayerPopupOptions` | Expression-capable template evaluated per feature |

Both extend MapLibre's [`PopupOptions`](https://maplibre.org/maplibre-gl-js/docs/API/type-aliases/PopupOptions/) (closeButton, closeOnClick, anchor, offset, className, maxWidth, …).

---

## Trigger

`trigger` is shared by both popup types and controls when the popup is shown.

| Value | Behavior |
| --- | --- |
| `"click"` | Opens on click/tap; closes on outside click. Default. |
| `"hover"` | Opens on pointer enter; closes on leave. Desktop only. |
| `"always"` | Pinned to the feature/marker; never dismisses. |

---

## Marker popups — `MapkaPopupOptions`

```ts
interface MapkaPopupOptions extends PopupOptions {
  id?: string;
  lngLat: [number, number];
  trigger?: "hover" | "click" | "always";
  content: MapkaPopupCreator;
}

type MapkaMarkerPopupOptions = Omit<MapkaPopupOptions, "lngLat">;

type MapkaPopupCreator =
  | HTMLElement
  | MapkaPopupContent
  | ((id: string) => HTMLElement)
  | ((id: string) => MapkaPopupContent);
```

Marker popups inherit `lngLat` from the marker, so `MapkaMarkerPopupOptions` omits it.

### `MapkaPopupContent`

Structured popup body rendered by the SDK's default template.

| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| `title` | string | no | Header text. |
| `description` | string | no | Body paragraph. |
| `rows` | `MapkaPopupRow[]` | no | Tabular key/value list. `{ name: string; value: unknown }`. |
| `imageUrls` | `string[]` | no | Image URLs rendered in a strip. |
| `primaryAction` | `MapkaPopupAction` | no | Button shown at the bottom. `{ label, onClick? }`. |

### `MapkaPopupCreator`

| Variant | When to use |
| --- | --- |
| `HTMLElement` | Fully custom DOM built ahead of time. |
| `MapkaPopupContent` | Static structured content rendered by the SDK. |
| `(id) => HTMLElement` | Lazily built custom DOM; `id` is the popup id. |
| `(id) => MapkaPopupContent` | Lazily built structured content. |

Style JSON carries literal values only — function-form creators are only valid when constructing popups programmatically through the SDK.

---

## Layer popups — `MapkaLayerPopupOptions`

Layer popups are evaluated per-feature, so `name` / `value` / `title` / `description` / `id` accept MapLibre expressions in addition to strings.

```ts
interface MapkaLayerPopupOptions {
  id?: ExpressionSpecification | string;
  trigger?: "hover" | "click" | "always";
  content: MapkaLayerPopupContent;
}

interface MapkaLayerPopupContent {
  title: ExpressionSpecification | string;
  description: ExpressionSpecification | string;
  rows?: MapkaLayerPopupRow[];
}

type MapkaLayerPopupRow = {
  name: ExpressionSpecification | string;
  value: ExpressionSpecification | unknown;
};
```

| Property | Type | Required | Notes |
| --- | --- | --- | --- |
| `id` | expression \| string | no | Stable popup id, usually `["get", "osm_id"]` or similar. Used to de-dupe popups between clicks. |
| `trigger` | see [Trigger](#trigger) | no | Defaults to `"click"`. |
| `content.title` | expression \| string | yes | Header. |
| `content.description` | expression \| string | yes | Body paragraph. |
| `content.rows` | `MapkaLayerPopupRow[]` | no | Tabular key/value list. Both `name` and `value` accept expressions. |

### Shorthand

`layers[].metadata.mapka.popup` may be `true` or `false`:

- `true` — enable the SDK default popup. Equivalent to a `click`-triggered popup that renders feature properties with no custom template.
- `false` — disable popup for the layer. Same as omitting the key.

### Example

```json
{
  "popup": {
    "id": ["get", "osm_id"],
    "trigger": "click",
    "content": {
      "title": ["coalesce", ["get", "name:en"], ["get", "name"]],
      "description": ["concat", "Class: ", ["get", "class"]],
      "rows": [
        { "name": "ID", "value": ["get", "osm_id"] },
        { "name": "Rank", "value": ["get", "rank"] }
      ]
    }
  }
}
```

---

## Marker-popup vs. layer-popup in one table

| Aspect | Marker popup | Layer popup |
| --- | --- | --- |
| Anchor | Marker `lngLat` | Clicked/hovered feature position |
| Templating | Literal values only in JSON | Expressions against feature props |
| Dynamic content | Via SDK factory (programmatic) | Inline via expressions (declarative) |
| Toggle shorthand | No | `true` / `false` enables / disables |
| `lngLat` field | Inherited from marker (omitted) | N/A (derived from event) |
