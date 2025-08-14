#!/bin/bash

rm -rf /tmp/maptiler-toner-gl-style
git clone https://github.com/openmaptiles/maptiler-toner-gl-style.git /tmp/maptiler-toner-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/maptiler-toner-gl-style/icons ./icons

echo "Syncing style.json"
rm style.json
cp /tmp/maptiler-toner-gl-style/style.json ./style.json
