import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { loadEnvFile } from "node:process";
import type { StyleSpecification } from "@maplibre/maplibre-gl-style-spec";

if (existsSync(".env")) {
  loadEnvFile();
}

const mapConfig = JSON.parse(readFileSync("map.json", "utf8"));
const styleConfig: StyleSpecification = JSON.parse(
  readFileSync("style.json", "utf8"),
);

const { key } = mapConfig;

const MAPKA_API_URL = process.env.MAPKA_API_URL || "https://api.mapka.dev";
const MAPKA_ACCOUNT_NAME = process.env.MAPKA_ACCOUNT_NAME || "default";

styleConfig.glyphs = `${MAPKA_API_URL}/v1/${MAPKA_ACCOUNT_NAME}/fonts/{fontstack}/{range}.pbf`;
styleConfig.sprite = `${MAPKA_API_URL}/v1/${MAPKA_ACCOUNT_NAME}/styles/${key}/sprite`;

if (styleConfig.sources.openmaptiles) {
  if ("url" in styleConfig.sources.openmaptiles) {
    styleConfig.sources.openmaptiles.url = `${MAPKA_API_URL}/v1/mapka/tilesets/planetiler_openmaptiles-v1/tile.json`;
  }
}

if(styleConfig.sources.natural_earth_shaded_relief) {
  if ("tiles" in styleConfig.sources.natural_earth_shaded_relief) {
    styleConfig.sources.natural_earth_shaded_relief.maxzoom = 5;
    styleConfig.sources.natural_earth_shaded_relief.tiles = [
      `${MAPKA_API_URL}/v1/naturalearth/datasets/ne_shaded_relief/tilesets/v3_10m_hr_lc_sr_w/{z}/{x}/{y}.png`,
    ]
  }
}

writeFileSync("style.json", JSON.stringify(styleConfig, null, 2));
