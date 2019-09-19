#!/bin/bash

# start and stops the osm tile server

AREA_NAME=planet-latest
IMPORT_FILE="$(pwd)/volumes/download/$AREA_NAME.osm.pbf"
IMAGE_NAME="openstreetmap-tile-server"
VOLUME_TILECACH="openstreetmap-rendered-tiles"
VOLUME_PSQL="openstreetmap-data-$AREA_NAME"

VOLUME_FILE="/var/lib/docker/volumes/openstreetmap-data-$AREA_NAME"
VOLUME_FILE_SSD="/media/ssd2G/openstreetmap-data-$AREA_NAME"


VOLUMES_OPTS=" \
  -v $IMPORT_FILE:/data.osm.pbf \
	-v $VOLUME_PSQL:/var/lib/postgresql/10/main \
	-v $VOLUME_TILECACH:/var/lib/mod_tile "

PORTS_OPTS=" --publish 8001:80 "
USER_OPTS=""
IMPORT_CMD="docker run --rm -e THREADS=16 --name $IMAGE_NAME $USER_OPTS $PORTS_OPTS $VOLUMES_OPTS $IMAGE_NAME import"
STOP_CMD="docker container kill $IMAGE_NAME"

echo "################################################################################"
echo "Benchmark $IMAGE_NAME import"
echo "import file: $IMPORT_FILE"
echo "################################################################################"
git  -C src branch -av
echo ""
echo "date=$(date)"
echo ""
echo "cleanup data in psql data directory"
rm $VOLUME_FILE
docker volume rm $VOLUME_PSQL
rm -fr $VOLUME_FILE_SSD
docker volume create $VOLUME_PSQL
mv $VOLUME_FILE $VOLUME_FILE_SSD
ln -s $VOLUME_FILE_SSD $VOLUME_FILE

echo ""
echo $IMPORT_CMD
echo ""
time $IMPORT_CMD
echo ""
echo "date=$(date)"
echo ""
# print infos for benchmark
docker system df -v | grep 'openstreetmap-data-berlin-latest'
ls -l $IMPORT_FILE

exit 0
