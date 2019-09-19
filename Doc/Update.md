# update and tile expire procedure

## overview
This document describes the singe steps for update of "planet" database.

## precondition
- You need a successful import of planet and a timestamp of data which where used for import.
  sample file: https://planet.openstreetmap.org/pbf/planet-190603.osm.pbf
  timestamp: 2019-06-03
- docker container should run

## attach to console
```
docker exec -i -t openstreetmap-tile-server /bin/bash
```
## Initialise osmosis working directory

The following command initializes the osmosis working directory
```
openstreetmap-tiles-update-expire 2019-06-03
```
The osmosis working directory "/var/lib/mod_tile/.osmosis" includes the files
configuration.txt and state.txt after the initialisation.

## show lag
The following command shows the time difference between osm data stored in local database and latest available osm data.
```
/home/renderer/src/mod_tile/osmosis-db_replag -h
```

## perform update
The following command starts the update procedure:
```
openstreetmap-tiles-update-expire
```

## Bookmarks
- [man page openstreetmap-tiles-update-expire](https://ircama.github.io/osm-carto-tutorials/manpage.html?url=https://raw.githubusercontent.com/openstreetmap/mod_tile/master/docs/openstreetmap-tiles-update-expire.1)
- [Keeping the local database in sync with OSM](https://ircama.github.io/osm-carto-tutorials/updating-data/)
