import { readFileSync } from "node:fs";
import { validateStyleMin } from "@maplibre/maplibre-gl-style-spec";

const STYLE_JSON = "style.json";
const ENCODING = "utf8";

const style = readFileSync(STYLE_JSON, ENCODING);
const parsed = JSON.parse(style);
const issues = validateStyleMin(parsed);
const errors = issues.filter((issue) => issue.severity === "error");
const warnings = issues.filter((issue) => issue.severity === "warning");

if (warnings.length > 0) {
  console.warn(warnings);
}

if (errors.length > 0) {
  console.error(errors);
  process.exit(1);
} else {
  console.log("Style is valid!");
}
