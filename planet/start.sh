#!/bin/bash

docker run \
		--name openstreetmap-tile-server-planet \
		--rm=false \
		-e THREADS=16 \
		-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /nodes/flat_nodes.bin -C 4096" \
		-e UPDATES=disabled \
		-e RENDERERAPP=tirex \
		--publish 8002:80 \
		--publish 5432:5432 \
		--shm-size=6G \
		--restart unless-stopped \
		--detach \
		--memory=32G \
		-v $PWD/volumes/download/planet-190923.osm.pbf:/data.osm.pbf \
		-v openstreetmap-data-planet-latest:/var/lib/postgresql/10/main \
		-v openstreetmap-rendered-tiles-planet-latest:/var/lib/mod_tile \
		-v openstreetmap-flat-planet-latest:/nodes \
		-v $PWD/volumes/transfer:/transfer \
		-v $PWD/volumes/replication:/replication \
		openstreetmap-tile-server-planet \
		run

exit 0
