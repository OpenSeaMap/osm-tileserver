# osm-tileserver
scripts and documentation for setup, run and maintenance of open streetmap tile server

This example shows the usage of the docker container with following features:
- initial import of the osm database extract
- periodical update of the container
- docker volumes to seperate the database content,
- flat file option

## download osm database
the following commands download the osm database extract for germany, a md5 checksum of the database and a specification of the region ( file with polygon around germany)

## build docker container
```
docker build -t openstreetmap-tile-server-germany ./src
```

## prepare required docker volumes
```
  docker volume create openstreetmap-data-germany-latest
  docker volume create openstreetmap-rendered-tiles-germany-latest
  docker volume create openstreetmap-flat-germany-latest
```

## import osm extract to postgresql database
```
docker run \
	--name openstreetmap-tile-server-germany \
  --rm=false \
	-e THREADS=8 \
	-e NCACHE=4096 \
	-e UPDATES=enabled \
	-e AUTOVACUUM=off \
	-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /flat/flat_nodes.bin" \
	-v $PWD/volumes/download/germany-latest.osm.pbf:/data.osm.pbf \
	-v $PWD/volumes/download/germany.poly:/data.poly \
	-v openstreetmap-data-germany-latest:/var/lib/postgresql/10/main \
	-v openstreetmap-rendered-tiles-germany-latest:/var/lib/mod_tile \
	-v openstreetmap-flat-germany-latest:/flat \
	openstreetmap-tile-server-germany  \
	import
```

## run the tile server first time
```
docker run \
		--name openstreetmap-tile-server-germany \
		--rm=false \
		-e THREADS=8 \
		-e OSM2PGSQL_EXTRA_ARGS="--flat-nodes /flat/flat_nodes.bin" \
		-e UPDATES=enabled \
		-e NCACHE=4096 \
		--publish 8000:80 \
		--shm-size=3G \
		--restart unless-stopped \
		--detach \
		--memory=32G \
		-v /media/data/openstreetmap-tile-server/volumes/download/germany-latest.osm.pbf:/data.osm.pbf \
		-v openstreetmap-data-germany-latest:/var/lib/postgresql/10/main \
		-v openstreetmap-rendered-tiles-germany-latest:/var/lib/mod_tile \
		-v openstreetmap-flat-germany-latest:/flat \
		openstreetmap-tile-server-germany  \
		run

```

## verification of tile tileserver

### check startup messages and logging output from renderd
```
docker logs -f openstreetmap-tile-server-germany
```
### check processes insight container
use the following command to connect to containers bash shell
```
docker exec -i -t openstreetmap-tile-server-germany ps ax
```
sample output
```
PID TTY      STAT   TIME COMMAND
   1 ?        Ss     0:00 /bin/bash /run.sh run
  27 ?        S      0:01 /usr/lib/postgresql/10/bin/postgres -D /var/lib/postg
  29 ?        Ss     0:00 postgres: 10/main: checkpointer process   
  30 ?        Ss     0:00 postgres: 10/main: writer process   
  31 ?        Ss     0:00 postgres: 10/main: wal writer process   
  32 ?        Ss     0:00 postgres: 10/main: autovacuum launcher process   
  33 ?        Ss     0:00 postgres: 10/main: stats collector process   
  34 ?        Ss     0:00 postgres: 10/main: bgworker: logical replication laun
  69 ?        Ss     0:00 /usr/sbin/apache2 -k start
  72 ?        Sl     0:00 /usr/sbin/apache2 -k start
  74 ?        Sl     0:00 /usr/sbin/apache2 -k start
 134 ?        Ss     0:00 /usr/sbin/cron
 135 ?        S      0:00 sudo -u renderer renderd -f -c /usr/local/etc/renderd
 136 ?        Sl     0:13 renderd -f -c /usr/local/etc/renderd.conf
2571 ?        Ss     0:05 postgres: 10/main: renderer gis [local] idle
2837 ?        S      0:00 /usr/sbin/CRON
2838 ?        Ss     0:00 /bin/sh -c    openstreetmap-tiles-update-expire
2839 ?        S      0:00 /bin/sh /usr/bin/openstreetmap-tiles-update-expire
2857 ?        Sl     0:17 java -cp /usr/share/java/plexus-classworlds2.jar -Dap
3104 pts/0    Rs+    0:00 ps ax
```

### load single tiles
you can load a single tile to test apache, renderd and mapnik render engine.
Use following url with web browser or wget command:
```
http://localhost:8000/tile/8/34/5.png
```

the log shows following renderd messages:
```
renderd[136]: DEBUG: Got incoming connection, fd 6, number 1
renderd[136]: DEBUG: Got incoming request with protocol version 2
renderd[136]: DEBUG: Got command RenderPrio fd(6) xml(ajt), z(8), x(34), y(5), mime(image/png), options()
renderd[136]: DEBUG: START TILE ajt 8 32-39 0-7, new metatile
renderd[136]: Rendering projected coordinates 8 32 0 -> -15028131.257100|18785164.071375 -13775786.985675|20037508.342800 to a 8 x 8 tile
renderd[136]: DEBUG: DONE TILE ajt 8 32-39 0-7 in 0.312 seconds
debug: Creating and writing a metatile to /var/lib/mod_tile/ajt/8/0/0/0/32/0.meta

renderd[136]: DEBUG: Sending render cmd(3 ajt 8/34/5) with protocol version 2 to fd 6
renderd[136]: DEBUG: Connection 0, fd 6 closed, now 0 left
```

### check mod_tile statistic
you can check mod_tile statistic with following url:
```
http://localhost:8000/mod_tile
```

### check renderd statistic

renderd generates a statistic witch can be shown with following command
```
docker exec -i -t openstreetmap-tile-server-germany cat /run/renderd/renderd.stats
```

sample output
```
ReqQueueLength: 0
ReqPrioQueueLength: 0
ReqLowQueueLength: 0
ReqBulkQueueLength: 0
DirtQueueLength: 0
DropedRequest: 0
ReqRendered: 0
TimeRendered: 0
ReqPrioRendered: 1
TimePrioRendered: 342
ReqLowRendered: 0
TimeLowRendered: 0
ReqBulkRendered: 0
TimeBulkRendered: 0
DirtyRendered: 0
TimeDirtyRendered: 0
ZoomRendered00: 0
ZoomRendered01: 0
ZoomRendered02: 0
ZoomRendered03: 0
ZoomRendered04: 0
ZoomRendered05: 0
ZoomRendered06: 0
ZoomRendered07: 0
ZoomRendered08: 1
ZoomRendered09: 0
ZoomRendered10: 0
ZoomRendered11: 0
ZoomRendered12: 0
ZoomRendered13: 0
ZoomRendered14: 0
ZoomRendered15: 0
ZoomRendered16: 0
ZoomRendered17: 0
ZoomRendered18: 0
ZoomRendered19: 0
ZoomRendered20: 0
TimeRenderedZoom00: 0
TimeRenderedZoom01: 0
TimeRenderedZoom02: 0
TimeRenderedZoom03: 0
TimeRenderedZoom04: 0
TimeRenderedZoom05: 0
TimeRenderedZoom06: 0
TimeRenderedZoom07: 0
TimeRenderedZoom08: 342
TimeRenderedZoom09: 0
TimeRenderedZoom10: 0
TimeRenderedZoom11: 0
TimeRenderedZoom12: 0
TimeRenderedZoom13: 0
TimeRenderedZoom14: 0
TimeRenderedZoom15: 0
TimeRenderedZoom16: 0
TimeRenderedZoom17: 0
TimeRenderedZoom18: 0
TimeRenderedZoom19: 0
TimeRenderedZoom20: 0
```

### check periodical updates
docker exec -i -t openstreetmap-tile-server-germany cat /var/log/tiles/run.log
```
[2019-09-19 09:17:01] 743 start import from seq-nr 3674832, replag is 2 day(s) and 9 hour(s)
[2019-09-19 09:17:01] 743 downloading diff
[2019-09-19 09:18:01] 815 pid 743 still running
...
[2019-09-19 09:27:01] 1083 pid 743 still running
[2019-09-19 09:27:06] 743 filtering diff
[2019-09-19 09:27:09] 743 importing diff
[2019-09-19 09:27:19] 743 expiring tiles
[2019-09-19 09:27:19] 743 Done with import
[2019-09-19 09:28:01] 1206 start import from seq-nr 3674892, replag is 2 day(s) and 8 hour(s)
[2019-09-19 09:28:01] 1206 downloading diff
[2019-09-19 09:29:01] 1281 pid 1206 still running
...
[2019-09-19 09:35:01] 1495 pid 1206 still running
[2019-09-19 09:35:47] 1206 filtering diff
[2019-09-19 09:35:53] 1206 importing diff
[2019-09-19 09:36:01] 1592 pid 1206 still running
[2019-09-19 09:36:02] 1206 expiring tiles
[2019-09-19 09:36:02] 1206 Done with import
[2019-09-19 09:37:01] 1621 start import from seq-nr 3674952, replag is 2 day(s) and 7 hour(s)
[2019-09-19 09:37:01] 1621 downloading diff
```
The logfile shows the different stages of the periodic update procedure.
first: download diff files (for world)
second: filter diff (filter relevant differences for your selected region / poly file)
third: import differences to postgresql (osm2psql)
forth: expiring tiles (from tile cache)

# optimisations

## prerender tileserver

The render applications needs long runtimes for rendering tiles in low zoom levels.
If a webbrowser request such tiles then the tileserver is not fast enough to render
the tiles on demand.   
The pre render method allows you to render this tiles in background and store them
in tile cache before they are requested.

Here is an example how to prerender tiles for specific zoom levels.
```
docker exec -i -t openstreetmap-tile-server-germany /bin/bash
render_list -a -m ajt -z 1 -Z 2 -l 800 -n 12

-a, --all            render all tiles in given zoom level range instead of reading from STDIN
-m, --map=MAP        render tiles in this map (defaults to 'default')
-l, --max-load=LOAD  sleep if load is this high (defaults to 16)
-n, --num-threads=N the number of parallel request threads (default 1)
-z, --min-zoom=ZOOM  filter input to only render tiles greater or equal to this zoom level (default is 0)
-Z, --max-zoom=ZOOM  filter input to only render tiles less than or equal to this zoom level (default is 20)
```
