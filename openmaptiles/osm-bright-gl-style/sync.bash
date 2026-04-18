#!/bin/bash

rm -rf /tmp/osm-bright-gl-style
git clone https://github.com/openmaptiles/osm-bright-gl-style.git /tmp/osm-bright-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/osm-bright-gl-style/icons ./icons

echo "Syncing style-original.json"
rm style-original.json
cp /tmp/osm-bright-gl-style/style.json ./style-original.json

echo "Convert to mapka"
yarn import

echo "Validate style spec"
yarn validate

echo "Format style spec"
yarn format