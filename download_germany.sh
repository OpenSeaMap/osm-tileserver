#!/bin/bash
# import germany file

wget -c http://download.geofabrik.de/europe/germany-latest.osm.pbf -P ./volumes/download/
wget -c http://download.geofabrik.de/europe/germany.poly -P ./volumes/download/
wget -c http://download.geofabrik.de/europe/germany-latest.osm.bz2.md5 -P ./volumes/download/
