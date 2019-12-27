# osm-tileserver
scripts and documentation for setup, run and maintenance of open streetmap tile server
the tileserver is based on several docker container

## tileserver_db
the image includes the psql database with GIS extensions

## tileserver_scripts
the container includes following scripts
+ initial import of osm database
+ periodical updates of osm database

## tileserver
the image includes following services
+ mapnik renderer and stypesheets
+ tirex, controls the renderer
+ apache - webserver
+ modtile - apache plugin for tileserver

## docker volumes
osm tileserver needs several docker volumes for persistant storage of files

### openstreetmap-db
used from image tileserver_db and stores the psql database

### openstreetmap-flat
used from image tileserver_scripts. Stores part of the database in seperate file to increase database performance during initial import and updates.
The files are required for updates of database.

### openstreetmap-tilecache
this volumes is a storage for rendered tiles

# quickstart instructions
checkout sources
```
git clone git@github.com:OpenSeaMap/osm-tileserver.git
osm-tileserver/
git checkout ubdatedb
git submodule update --init
```

## build tileserver_db image and start sql database
```
cd src_tileserver_db/
./scripts/docker-service.sh build
./scripts/docker-service.sh start
```

## build tileserver_scripts image and import database

download compressed osm database  
```
cd src_tileserver_scripts/
mkdir src_tileserver_scripts$ mkdir -p volumes/download
wget -c https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf     -O volumes/download/planet-latest.osm.pbf
wget -c https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf.md5 -O volumes/download/planet-latest.osm.pbf.md5
```

build container and start import
```
cd src_tileserver_scripts/
./scripts/docker-service.sh build
./scripts/docker-service.sh start
./scripts/docker-service.sh connect
./scripts/initial-import.sh download/planet-latest.osm.pbf
```

## build tileserver image and start tileserver
```
cd src_tileserver
scripts/docker-service.sh build
scripts/docker-service.sh start
```
