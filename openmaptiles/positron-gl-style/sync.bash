#!/bin/bash

rm -rf /tmp/positron-gl-style
git clone https://github.com/openmaptiles/positron-gl-style.git /tmp/positron-gl-style

echo "Syncing icons svg"
rm -rf ./icons
cp -r /tmp/positron-gl-style/icons ./icons

echo "Syncing style.json"
rm style.json
cp /tmp/positron-gl-style/style.json ./style.json
