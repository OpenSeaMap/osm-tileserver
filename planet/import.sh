#!/bin/bash

docker run \
	--name openstreetmap-tile-server-planet \
	--rm=false \
	-e THREADS=8 \
	-e UPDATES=enabled \
	-e AUTOVACUUM=off \
	-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /nodes/flat_nodes.bin -C 32000" \
	-v $PWD/volumes/download/planet-190923.osm.pbf:/data.osm.pbf \
	-v openstreetmap-data-planet-latest:/var/lib/postgresql/10/main \
	-v openstreetmap-rendered-tiles-planet-latest:/var/lib/mod_tile \
	-v openstreetmap-flat-planet-latest:/nodes \
	openstreetmap-tile-server-planet \
	import
