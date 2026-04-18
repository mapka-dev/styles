#!/bin/bash

rm -rf /tmp/osm-liberty
git clone https://github.com/denniskuijs/osm-liberty.git /tmp/osm-liberty
(cd /tmp/osm-liberty && git checkout new-maki-icons)          


echo "Syncing icons..."
rm -rf ./icons
cp -r /tmp/osm-liberty/svgs/svgs_iconset ./icons

echo "Syncing style.json"
rm style.json 
cp /tmp/osm-liberty/style.json ./style.json

echo "Convert to mapka"
yarn import

echo "Validate style spec"
yarn validate

echo "Format style spec"
yarn format