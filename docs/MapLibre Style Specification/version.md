# `version`

Style specification version. **Required.** Must be the integer `8`.

- **Type:** enum
- **Required:** yes
- **Default:** —

```json
{ "version": 8 }
```

Any other value causes the style to be rejected at load time. MapLibre has not bumped this since forking from Mapbox GL — treat `8` as an invariant, not a switch.
