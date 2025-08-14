#!/bin/bash

rm -rf /tmp/dark-matter-gl-style
git clone https://github.com/openmaptiles/dark-matter-gl-style.git /tmp/dark-matter-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/dark-matter-gl-style/icons ./icons

echo "Syncing style.json"
rm style.json
cp /tmp/dark-matter-gl-style/style.json ./style.json
