#!/bin/bash

rm -rf /tmp/osm-liberty
git clone https://github.com/maputnik/osm-liberty.git /tmp/osm-liberty

echo "Syncing icons..."
rm -rf ./icons
cp -r /tmp/osm-liberty/svgs/svgs_iconset ./icons

echo "Syncing style.json"
rm style.json 
cp /tmp/osm-liberty/style.json ./style.json
