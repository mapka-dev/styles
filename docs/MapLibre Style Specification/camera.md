# Camera defaults — `center`, `centerAltitude`, `zoom`, `bearing`, `pitch`, `roll`

Initial camera pose baked into the style. All are applied **only** when the hosting map has not been positioned by other means (programmatic `setCenter`/`setZoom`, URL hash, user gesture before style load, …).

| Property | Type | Range / Unit | Default |
| --- | --- | --- | --- |
| `center` | `[lng, lat]` array | WGS84 degrees | — |
| `centerAltitude` | number | metres above sea level | — |
| `zoom` | number | typically 0–24 | — |
| `bearing` | number | degrees, 0–360 | `0` |
| `pitch` | number | degrees, 0–60 (renderer-capped) | `0` |
| `roll` | number | degrees | `0` |

## Semantics

- **`center`** — `[longitude, latitude]`. Order is lng-lat, the opposite of most geocoders.
- **`centerAltitude`** — camera look-at altitude in metres. Useful with [`terrain`](terrain.md) so the default pose doesn't clip through mountains.
- **`zoom`** — MapLibre zoom scale; each unit doubles resolution. Fractional values are fine.
- **`bearing`** — compass direction of "up". `90°` rotates the map so east is up.
- **`pitch`** — tilt from straight-down. `0` is top-down; `60°` looks toward the horizon. The web renderer caps around 60°, native around 85°.
- **`roll`** — rotation about the camera boresight, counterclockwise. Rarely set outside AR/special cases.

## Example

```json
{
  "center": [19.9450, 50.0647],
  "centerAltitude": 220,
  "zoom": 12.5,
  "bearing": -17.6,
  "pitch": 45,
  "roll": 0
}
```

## Gotchas

- These are **defaults**, not constraints. A caller can still move the camera anywhere. To constrain, use map-SDK options like `maxBounds`, `minZoom`, `maxZoom` — not the style.
- `center` + `zoom` coming from the style can race with a URL hash plugin. If the hash wins, style values are silently ignored.
- `bearing` and `pitch` transitions are not automatic between style reloads; the map just snaps.
