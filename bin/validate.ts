import { readFileSync } from "node:fs";
import { validateStyleMin } from "@maplibre/maplibre-gl-style-spec";

const STYLE_JSON = "style.json";
const ENCODING = "utf8";

const style = readFileSync(STYLE_JSON, ENCODING);
const parsed = JSON.parse(style);
const errors = validateStyleMin(parsed);

if (errors.length > 0) {
  console.error(errors);
  process.exit(1);
} else {
  console.log("Style is valid!");
}
