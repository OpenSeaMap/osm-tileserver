#!/bin/bash

docker run \
	--name openstreetmap-tile-server-planet \
        --rm=false \
	-e THREADS=16 \
	-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /nodes/flat_nodes.bin -C 4096" \
        -e UPDATES=disabled \
        --publish 8002:80 \
        --shm-size=3G \
        --restart unless-stopped \
        --detach \
        --memory=32G \
	-v /media/data/openstreetmap-tile-server/volumes/download/planet-190923.osm.pbf:/data.osm.pbf \
	-v openstreetmap-data-planet-latest:/var/lib/postgresql/10/main \
	-v openstreetmap-rendered-tiles-planet-latest:/var/lib/mod_tile \
	-v openstreetmap-flat-planet-latest:/nodes \
	openstreetmap-tile-server-planet \
	run

exit 0

