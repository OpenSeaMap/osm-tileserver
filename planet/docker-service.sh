#!/bin/bash

# start and stops the osm tile server

set -x

IMAGE_NAME="openstreetmap-tile-server-planet"


case "$1" in
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
