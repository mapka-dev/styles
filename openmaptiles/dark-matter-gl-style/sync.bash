#!/bin/bash

rm -rf /tmp/dark-matter-gl-style
git clone https://github.com/openmaptiles/dark-matter-gl-style.git /tmp/dark-matter-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/dark-matter-gl-style/icons ./icons

echo "Syncing style-original.json"
rm style-original.json
cp /tmp/dark-matter-gl-style/style.json ./style-original.json

echo "Convert to mapka"
yarn update-mapka-url

echo "Validate style spec"
yarn validate

echo "Format style spec"
yarn format