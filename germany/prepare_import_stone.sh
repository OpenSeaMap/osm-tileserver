#!/bin/bash

docker volume rm openstreetmap-data-germany-latest
docker volume rm openstreetmap-rendered-tiles-germany-latest
docker volume rm openstreetmap-flat-germany-latest

docker volume create openstreetmap-data-germany-latest
docker volume create openstreetmap-rendered-tiles-germany-latest
docker volume create openstreetmap-flat-germany-latest
