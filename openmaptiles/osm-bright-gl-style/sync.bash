#!/bin/bash

rm -rf /tmp/osm-bright-gl-style
git clone https://github.com/openmaptiles/osm-bright-gl-style.git /tmp/osm-bright-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/osm-bright-gl-style/icons ./icons

echo "Syncing style.json"
rm style.json
cp /tmp/osm-bright-gl-style/style.json ./style.json
