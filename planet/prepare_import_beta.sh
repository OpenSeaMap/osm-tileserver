#!/bin/bash


rm /var/lib/docker/volumes/openstreetmap-data-planet-latest
docker volume rm openstreetmap-data-planet-latest
rm -fr /media/ssd1/docker/volumes/openstreetmap-data-planet-latest/

rm /var/lib/docker/volumes/openstreetmap-rendered-tiles-planet-latest
docker volume rm openstreetmap-rendered-tiles-planet-latest
rm -fr /media/ssd1/docker/volumes/openstreetmap-rendered-tiles-planet-latest/

rm /var/lib/docker/volumes/openstreetmap-flat-planet-latest
docker volume rm openstreetmap-flat-planet-latest
rm -fr /media/ssd1/docker/volumes/openstreetmap-flat-planet-latest/

docker volume create openstreetmap-data-planet-latest
docker volume create openstreetmap-rendered-tiles-planet-latest
docker volume create openstreetmap-flat-planet-latest

mv /var/lib/docker/volumes/openstreetmap-data-planet-latest/ /media/ssd1/docker/volumes
mv /var/lib/docker/volumes/openstreetmap-rendered-tiles-planet-latest/ /media/ssd1/docker/volumes
mv /var/lib/docker/volumes/openstreetmap-flat-planet-latest /media/ssd1/docker/volumes

ln -s /media/ssd1/docker/volumes/openstreetmap-data-planet-latest/ /var/lib/docker/volumes/openstreetmap-data-planet-latest
ln -s /media/ssd1/docker/volumes/openstreetmap-rendered-tiles-planet-latest/ /var/lib/docker/volumes/openstreetmap-rendered-tiles-planet-latest
ln -s /media/ssd1/docker/volumes/openstreetmap-flat-planet-latest/ /var/lib/docker/volumes/openstreetmap-flat-planet-latest
