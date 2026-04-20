# `metadata`

Arbitrary data attached to the style. Opaque to the renderer — keep anything build-time, tooling, or provenance-related here.

- **Type:** object
- **Required:** no
- **Default:** —

```json
{
  "metadata": {
    "maputnik:renderer": "mlgljs",
    "mapka:version": "2026.04.18",
    "openmaptiles:version": "3.x"
  }
}
```

## Conventions

- **Prefix every key** with a namespace (`vendor:name`). The spec recommends this to prevent collisions between tools that inspect metadata (Maputnik, MapTiler, editors, CI).
- Common in-the-wild prefixes: `maputnik:`, `mapbox:`, `maplibre:`, `openmaptiles:`.
- Avoid large blobs — styles are often fetched hot on map load. Put heavy artifacts elsewhere.

`metadata` can also appear on individual **layers** and **sources**; same rules apply. A per-layer `metadata.group` is a common pattern for organizing layers in Maputnik.
