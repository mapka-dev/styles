import { readFileSync, writeFileSync } from "node:fs";
import { format } from "@maplibre/maplibre-gl-style-spec";

const STYLE_JSON = "./style.json";
const ENCODING = "utf8";

const style = readFileSync(STYLE_JSON, ENCODING);
const parsed = JSON.parse(style);
const formatted = format(parsed);

writeFileSync(STYLE_JSON, formatted);
