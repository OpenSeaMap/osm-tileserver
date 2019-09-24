#!/bin/bash

docker run \
		--name openstreetmap-tile-server-germany \
		--rm=false \
		-e THREADS=8 \
		-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /nodes/flat_nodes.bin" \
		-e UPDATES=enabled \
		-e NCACHE=4096 \
		--publish 8000:80 \
		--shm-size=3G \
		--restart unless-stopped \
		--detach \
		--memory=32G \
		-v /media/data/openstreetmap-tile-server/volumes/download/germany-latest.osm.pbf:/data.osm.pbf \
		-v openstreetmap-data-germany-latest:/var/lib/postgresql/10/main \
		-v openstreetmap-rendered-tiles-germany-latest:/var/lib/mod_tile \
		-v openstreetmap-flat-germany-latest:/flat \
		openstreetmap-tile-server-germany  \
		run
