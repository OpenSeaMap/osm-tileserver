#!/bin/bash

set -x

date

docker run \
	--name openstreetmap-tile-server-germany \
  --rm=false \
	-e THREADS=8 \
	-e UPDATES=enabled \
	-e AUTOVACUUM=off \
	-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /flat/flat_nodes.bin -C 4096" \
	-v $PWD/volumes/download/germany-latest.osm.pbf:/data.osm.pbf \
	-v $PWD/volumes/download/germany.poly:/data.poly \
	-v openstreetmap-data-germany-latest:/var/lib/postgresql/10/main \
	-v openstreetmap-rendered-tiles-germany-latest:/var/lib/mod_tile \
	-v openstreetmap-flat-germany-latest:/flat \
	openstreetmap-tile-server-germany  \
	import

date

echo "size of docker container"
docker system df -v | grep germany-latest
