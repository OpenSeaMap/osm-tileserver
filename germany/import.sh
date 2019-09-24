#!/bin/bash

docker run \
	--name openstreetmap-tile-server-germany \
  --rm=false \
	-e THREADS=8 \
	-e NCACHE=4096 \
	-e UPDATES=enabled \
	-e AUTOVACUUM=off \
	-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /nodes/flat_nodes.bin" \
	-v $PWD/volumes/download/germany-latest.osm.pbf:/data.osm.pbf \
	-v $PWD/volumes/download/germany.poly:/data.poly \
	-v openstreetmap-data-germany-latest:/var/lib/postgresql/10/main \
	-v openstreetmap-rendered-tiles-germany-latest:/var/lib/mod_tile \
	-v openstreetmap-flat-germany-latest:/flat \
	openstreetmap-tile-server-germany  \
	import