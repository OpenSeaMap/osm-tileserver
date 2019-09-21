#!/bin/bash

#rm /var/lib/docker/volumes/openstreetmap-data-germany-latest
docker volume rm openstreetmap-data-germany-latest
#rm -fr /media/ssd1/docker/volumes/openstreetmap-data-germany-latest/

#rm /var/lib/docker/volumes/openstreetmap-rendered-tiles-germany-latest
docker volume rm openstreetmap-rendered-tiles-germany-latest
#rm -fr /media/ssd1/docker/volumes/openstreetmap-rendered-tiles-germany-latest/

#rm /var/lib/docker/volumes/openstreetmap-flat-germany-latest
docker volume rm openstreetmap-flat-germany-latest
#rm -fr /media/ssd1/docker/volumes/openstreetmap-flat-germany-latest/

docker volume create openstreetmap-data-germany-latest
docker volume create openstreetmap-rendered-tiles-germany-latest
docker volume create openstreetmap-flat-germany-latest

#mv /var/lib/docker/volumes/openstreetmap-data-germany-latest/ /media/ssd1/docker/volumes
#mv /var/lib/docker/volumes/openstreetmap-rendered-tiles-germany-latest/ /media/ssd1/docker/volumes
#mv /var/lib/docker/volumes/openstreetmap-flat-germany-latest /media/ssd1/docker/volumes

#ln -s /media/ssd1/docker/volumes/openstreetmap-data-germany-latest/ /var/lib/docker/volumes/openstreetmap-data-germany-latest
#ln -s /media/ssd1/docker/volumes/openstreetmap-rendered-tiles-germany-latest/ /var/lib/docker/volumes/openstreetmap-rendered-tiles-germany-latest
#ln -s /media/ssd1/docker/volumes/openstreetmap-flat-germany-latest/ /var/lib/docker/volumes/openstreetmap-flat-germany-latest
