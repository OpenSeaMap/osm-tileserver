#!/bin/bash

docker volume rm openstreetmap-data-planet-latest
docker volume rm openstreetmap-rendered-tiles-planet-latest
docker volume rm openstreetmap-flat-planet-latest

docker volume create openstreetmap-data-planet-latest
docker volume create openstreetmap-rendered-tiles-planet-latest
docker volume create openstreetmap-flat-planet-latest
