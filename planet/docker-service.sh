#!/bin/bash

# start and stops the osm tile server

set -x

IMAGE_NAME="openstreetmap-tile-server-planet"
VOLUME_TILECACH="openstreetmap-rendered-tiles"

AREA_NAME=planet-latest
VOLUME_PSQL="openstreetmap-data-$AREA_NAME"

VOLUMES_OPTS_Import="
	-v $(pwd)/volumes/download/europe-latest.osm.pbf:/data.osm.pbf \
	-v $(pwd)/volumes/download/:/download \
	-v $VOLUME_PSQL:/var/lib/postgresql/10/main \
	-v $VOLUME_TILECACH:/var/lib/mod_tile "

VOLUMES_OPTS_RUN="
	-v $VOLUME_PSQL:/var/lib/postgresql/10/main \
	-v $VOLUME_TILECACH:/var/lib/mod_tile "

#-v $(pwd)/volumes/postgresql-data:/var/lib/postgresql/10/main \
#	"
PORTS_OPTS=" --publish 8001:80 "
USER_OPTS=" --shm-size=3G --restart unless-stopped "
IMPORT_CMD="docker run -rm -e THREADS=16          --name $IMAGE_NAME $USER_OPTS $PORTS_OPTS $VOLUMES_OPTS $IMAGE_NAME import"
START_CMD="docker  run  -e THREADS=16 --detach --name $IMAGE_NAME $USER_OPTS $PORTS_OPTS $VOLUMES_OPTS_RUN $IMAGE_NAME run"
STOP_CMD="docker container kill $IMAGE_NAME"


case "$1" in
  import)
		docker volume rm $VOLUME_PSQL
		docker volume create $VOLUME_PSQL
		$IMPORT_CMD
	;;
	start)
		$START_CMD
	;;
  stop)
		$STOP_CMD
	;;
  restart|force-reload)
		$STOP_CMD
	sleep 1
		$START_CMD
	;;
  build)
		docker build -t $IMAGE_NAME ./src
	;;
  connect)
		docker exec -i -t $IMAGE_NAME /bin/bash
	;;
  log)
		docker logs -f $IMAGE_NAME
	;;
  *)
	echo "Usage: docker.service.sh {start|stop|restart|build|connect|import|log}" >&2
	exit 1
	;;
esac

exit 0
