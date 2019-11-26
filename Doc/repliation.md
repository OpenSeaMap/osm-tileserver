# review giggls tile server scripts

This document describes how to use *giggls* tile server scripts and which modification are needed for usage on another server.

## Workflow
+  initial import of osm database to PostgreSQL
+  determine replication start id / timed
+  prepare replication / load state.txt
+  load differences
+  update database
+  optional: trigger tile expiry process


# prepare workspace and clone replication scripts

sample for system based on ubuntu 18.04

```
apt install curl pip3
pip3 install osmium
mkdir -p /replication
cd /replication
git clone https://github.com/giggls/tileserver-scripts -B scripts
mkdir -p work/data
```

## some background infos

### the initial import
The initial import is done with call of script "initial-import.sh" which is based on osm2psql tool.
note: The option "-s, --slim" is required to support incremental updates [7].  

### update packages
The data packages for import of updates are stored on webservers.
sample: https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/

Each data package has a file which extension xxx.osc.gz and a xxx.state.txt file.

The gz file includes the osm data in xml format.
sample file:
https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/003/757/003.osc.gz

The state txt file includes some meta information for the data packages like
+ sequenceNumber
+ timestamp

sample: https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/003/757/003.state.txt
```
#Wed Nov 13 02:12:03 UTC 2019
sequenceNumber=3757003
txnMaxQueried=2417738622
txnActiveList=
txnReadyList=
txnMax=2417738622
timestamp=2019-11-13T02\:12\:02Z
```

## prepare first update

### determine start point for replication service
note: The incremental updates procedure needs a sequence number for the download of update packages.

This chapter describes how to get the sequence number from your database.
+ in a first step you determine the latest available osm_id in your db
+ in a second step you can use the script To find the whichdiff.pl script to get the sequence number.


#### read out the latest node id from db:

you can use following command to determine the latest available osm_id in your db:
```
sudo -u postgres psql -d gis -c "select max(osm_id) from planet_osm_point;"
```

sample call
```
sudo -u postgres psql -d gis -c "select max(osm_id) from planet_osm_point;"
max     
------------
6816294185
(1 row)
```

#### call script whichdiff.pl to determine the sequence number for replication process

the following sample shows the usage of script whichdiff.pl
```
whichdiff.pl 6816294185

#Mon Sep 23 00:59:03 UTC 2019
sequenceNumber=3683532
txnMaxQueried=2322295664
txnActiveList=
txnReadyList=
txnMax=2322295664
timestamp=2019-09-23T00\:59\:02Z
```

### alternative method to determine the sequence number for replication service

Another method is the usage of replication timestamp given from the imported pbf file.
The following command sequence read out the replication timestamp.

```
osmium fileinfo /data.osm.pbf > ./work/data.osm.pbf.info
cat ./work/data.osm.pbf.info | grep 'osmosis_replication_timestamp=' | cut -b35-44 > ./work/replication_timestamp.txt
REPLICATION_TIMESTAMP=$(cat ./work/replication_timestamp.txt)
wget "http://replicate-sequences.osm.mazdermind.de/?"$REPLICATION_TIMESTAMP"T00:00:00Z" -O ./work/state_mazdermind.txt
```

sample result
```
#original-source: http://planet.openstreetmap.org/replication/minute/003/683/472.state.txt
#generated-by: https://replicate-sequences.osm.mazdermind.de/?2019-09-23T00:00:00Z
#Sun Sep 22 23:59:03 UTC 2019
sequenceNumber=3683472
txnMaxQueried=2322258355
txnActiveList=
txnReadyList=
txnMax=2322258355
timestamp=2019-09-22T23\:59\:02Z
```

note:
the sequence number of first method is 3683532
the sequence number of alternative method is 3683472


The difference time between this sequence number is 60 minutes.

### prepare update scripts

the update script may need updated to your needs

```
+BASE=./work
+FLATNODEFILE=/nodes/flat_nodes.bin
+STYLE=/home/renderer/src/openstreetmap-carto/openstreetmap-carto.style
+LUA=/home/renderer/src/openstreetmap-carto/openstreetmap-carto.lua

+if sudo -u renderer osm2pgsql -G -a -d gis -s --number-processes=1 -C4000 -S $STYLE --flat-nodes $FLATNODEFILE -e $(($MINZOOM-3))-16 -o $EXPIRELOG --expire-bbox-size 20000 -

```
### create sequence file
```
cd /replication
echo 3683532 > ./work/data/sequence_file
scripts/replicate-loop.sh
```

## first call of replication procedure

```
./scripts/replicate-loop.sh
```

after the script is ready we can read out the latest ism_id again and determine the sequence number with the

```
root@253fbf13f644:/replication# sudo -u postgres psql -d gis -c "select max(osm_id) from planet_osm_point;"
    max     
------------
 6827105813
scripts/whichdiff.pl 6827105813

node 6827105813 found in file 003/688/553.osc.gz
therefore, use status file 003/688/543.state.txt:#Thu Sep 26 12:34:03 UTC 2019
sequenceNumber=3688543
txnMaxQueried=2329634329
txnActiveList=
txnReadyList=
txnMax=2329634329
timestamp=2019-09-26T12\:34\:02Z
```

The sequence number for next replication procedure is stored in file ""
```
cat ./work/data/sequence_file
3688541
```


```
root@253fbf13f644:/replication# ./scripts/replicate-loop.sh
+ LANG=C
+ BASE=./work
+ FLATNODEFILE=/nodes/flat_nodes.bin
+ EXPIRELOG=./work/expire.log
+ SEQFILE=./work/data/sequence_file
+ STYLE=/home/renderer/src/openstreetmap-carto/openstreetmap-carto.style
+ LUA=/home/renderer/src/openstreetmap-carto/openstreetmap-carto.lua
+ MINZOOM=13
+ export PGPASSWORD=osm
+ PGPASSWORD=osm
+ '[' -f ./work/data/sequence_file ']'
+ LOCKFILE=./work/data/replicate.lock
+ '[' -f ./work/data/replicate.lock ']'
+ echo 27825
++ date +%s
+ START=1574416296
++ curl -s https://planet.osm.org/replication/minute/state.txt
./scripts/replicate-loop.sh: line 37: curl: command not found
++ grep sequenceNumber
+ eval
++ cat ./work/data/sequence_file
+ local_sequence=3687086
++ expr - 3687086
expr: syntax error
+ LAG=
+ echo 'start update; osmosis replication is  minutes behind upstream'
start update; osmosis replication is  minutes behind upstream
+ THISFILE=./work/data/replicate-1574416296.osc
+ MERGEDFILE=./work/data/merged.osc
+ cp ./work/data/sequence_file ./work/data/sequence_file.old
+ :
+ find ./work/data/ -name 'replicate-*.osc' -mtime +0
+ xargs rm -f
+ pyosmium-get-changes -s 500 -f ./work/data/sequence_file -o ./work/data/replicate-1574416296.osc
+ '[' '!' -f ./work/data/replicate-1574416296.osc ']'
+ '[' -f ./work/data/merged.osc ']'
+ echo 'merging with existing diff'
merging with existing diff
+ '[' -f ./work/data/osmium-mc.stderr ']'
+ mv ./work/data/osmium-mc.stderr ./work/data/osmium-mc.stderr.old
+ osmium merge-changes --no-progress -s -o ./work/data/merged.osc-new.osc ./work/data/replicate-1574416296.osc ./work/data/merged.osc
+ mv ./work/data/merged.osc-new.osc ./work/data/merged.osc
+ '[' -f ./work/data/osm2pgsql.stderr ']'
+ mv ./work/data/osm2pgsql.stderr ./work/data/osm2pgsql.stderr.old
+ sudo -u renderer osm2pgsql -G -a -d gis -s --number-processes=1 -C4000 -S /home/renderer/src/openstreetmap-carto/openstreetmap-carto.style --flat-nodes /nodes/flat_nodes.bin -e 10-16 -o ./work/expire.log --expire-bbox-size 20000 --hstore --tag-transform-script /home/renderer/src/openstreetmap-carto/openstreetmap-carto.lua ./work/data/merged.osc

+ rm ./work/data/merged.osc
++ cat ./work/data/sequence_file
+ local_sequence=3688532
++ expr - 3688532
expr: syntax error
+ LAG=
+ echo 'end update;   osmosis replication is  minutes behind upstream'
end update;   osmosis replication is  minutes behind upstream
+ '[' -f ./work/data/doexpire ']'
+ rm ./work/data/replicate.lock

```



# Bookmarks

* [1] https://github.com/giggls/tileserver-scripts
* [2] https://help.openstreetmap.org/questions/54378/how-to-load-and-apply-planet-osm-diff
* [3] https://lists.openstreetmap.org/pipermail/tile-serving/2016-February/003721.html
* [4] https://help.openstreetmap.org/questions/64848/reset-osmosis-update-process-after-failure-following-server-shutdown
* [5] https://ircama.github.io/osm-carto-tutorials/updating-data
* [6] https://github.com/MaZderMind/replicate-sequences
* [7] https://www.volkerschatz.com/net/osm/osm2pgsql-usage.html
