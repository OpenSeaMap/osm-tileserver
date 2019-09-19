# Useful commands

## git

### clone the docker container sources
```
# get files from github and create local copy of git repository
git clone https://github.com/Overv/openstreetmap-tile-server.git
cd openstreetmap-tile-server
```

## download osm map files
some samples how to download files from geofabrik
```
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe/isle-of-man-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe/germany-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe/germany/mecklenburg-vorpommern-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  http://download.geofabrik.de/europe-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf
wget -c -P $(pwd)/volumes/download/  https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf.md5
wget -c -P $(pwd)/volumes/download/  https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-190603.osm.pbf
wget -c -P $(pwd)/volumes/download/  https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-190603.osm.pbf.md5
```

## docker

### create local docker image
```
docker build -t openstreetmap-tile-server .
```

### create docker volumes
```
docker volume create openstreetmap-rendered-tiles
docker volume create openstreetmap-data
```

### reset docker volumes
```
docker volume rm openstreetmap-rendered-tiles
docker volume create openstreetmap-rendered-tiles
docker volume rm openstreetmap-data
docker volume create openstreetmap-data
```

### start server and import single map file
The following command imports the osm data for area of berlin/germany. The docker container stops after import.
```
docker run --rm -e THREADS=16 --detach --name openstreetmap-tile-server --publish 8001:80 -v /media/data/docker/openstreetmap-tile-server/volumes/download/berlin-latest.osm.pbf:/data.osm.pbf -v /media/data/docker/openstreetmap-tile-server/volumes/download/:/download -v openstreetmap-data:/var/lib/postgresql/10/main -v openstreetmap-rendered-tiles:/var/lib/mod_tile openstreetmap-tile-server run
```

### start osm tile server
The following command starts the docker container in background.
```
docker run --rm -e THREADS=16 --detach --name openstreetmap-tile-server --publish 8001:80 -v /media/data/docker/openstreetmap-tile-server/volumes/download/berlin-latest.osm.pbf:/data.osm.pbf -v /media/data/docker/openstreetmap-tile-server/volumes/download/:/download -v openstreetmap-data:/var/lib/postgresql/10/main -v openstreetmap-rendered-tiles:/var/lib/mod_tile openstreetmap-tile-server run
```

### debugging

#### show MAP
http://localhost:8001/

#### show single tile
http://localhost:8001/tile/16/32741/21794.png

#### show statistic information
http://localhost:8001/mod_tile

#### attach to docker bash console
```
docker exec -i -t openstreetmap-tile-server /bin/bash
```

#### show logging infos from rendered, apache
docker logs -f openstreetmap-tile-server

## measurements

### measure runtimes
you can use the time command for measurement of runtimes.
```
time docker run --rm -e THREADS=16 --detach --name openstreetmap-tile-server --publish 8001:80 -v /media/data/docker/openstreetmap-tile-server/volumes/download/berlin-latest.osm.pbf:/data.osm.pbf -v /media/data/docker/openstreetmap-tile-server/volumes/download/:/download -v openstreetmap-data:/var/lib/postgresql/10/main -v openstreetmap-rendered-tiles:/var/lib/mod_tile openstreetmap-tile-server run
```

### measure i/o performance (of hard disks)
```
sudo iotop -o
```

### measure cpu load and RAM consumption
```
sudo htop
```
### Performance Monitoring
sysstat allows to monitor the system performance and ressource usage <br>
https://github.com/sysstat/sysstat

### read docker volume size
```
docker system df -v
```

### prerender Tiles
open bash shell on docker and enter following command to prerender zoomlevel 1-8
```
docker exec -i -t openstreetmap-tile-server /bin/bash
render_list -a -m ajt -z 6 -Z 6 -l 800 -n 12

-a, --all            render all tiles in given zoom level range instead of reading from STDIN
-m, --map=MAP        render tiles in this map (defaults to 'default')
-l, --max-load=LOAD  sleep if load is this high (defaults to 16)
-n, --num-threads=N the number of parallel request threads (default 1)
-z, --min-zoom=ZOOM  filter input to only render tiles greater or equal to this zoom level (default is 0)
-Z, --max-zoom=ZOOM  filter input to only render tiles less than or equal to this zoom level (default is 20)
```


# Benchmarks

## i/o performance
```
sysbench --test=fileio --file-total-size=10G --file-num=1024 prepare
sudo su
ulimit -n 100000
sysbench --num-threads=16 --test=fileio --file-total-size=10G --file-num=1024 --file-test-mode=rndrd --max-time=30 --max-requests=0 --file-extra-flags=direct run
sysbench --num-threads=16 --test=fileio --file-total-size=10G --file-num=1024 --file-test-mode=rndrw --max-time=30 --max-requests=0 --file-extra-flags=direct run
sysbench --test=fileio --file-total-size=10G --file-num=1024 cleanup
```
