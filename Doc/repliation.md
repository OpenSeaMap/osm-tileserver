# review giggls tile server scripts

This document describes how to use *giggls* tile server scripts and which modification are needed for usage on another server.

## Workflow
+  initial import of osm database to PostgreSQL
+  determine replication start id / timed
+  prepare replication / load state.txt
+  load differences
+  update database
+  optional: trigger tile expiry process

# clone scripts
```
git clone https://github.com/giggls/tileserver-scripts
```

## the initial import
The initial import is done with call of script "initial-import.sh" which is based on osm2psql tool.
note: The option "-s, --slim" is required to support incremental updates [7].  

## update packages
The data packages for import of updates are stored on webservers.
sample: https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/

Each data package has a file which extension xxx.osc.gz and a xxx.state.txt file.

The gz file includes the osm data in xml format.
sample: https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/003/757/003.osc.gz

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

## determine start point for replication service
The incremental updates procedure needs a start point for the download of update packages.
There are several methods available to determine the start point of the replication.

### determine last node id in database
this method try to find the latest / highest node id in the database.

#### via tool nodecachefilereader [2]
note: the tool seems to be deprecated [3]

#### via sql query on db [4]
The following commands read out the latest node id from db:
```
sudo -u postgres psql -d gis -c "select max(id) from planet_osm_nodes;"
```
or (if option --flatnodes was used during import)
```
sudo -u postgres psql -d gis -c "select max(osm_id) from planet_osm_point;"
```

sample
```
sudo -u postgres psql -d gis -c "select max(osm_id) from planet_osm_point;"
max     
------------
6816294185
(1 row)
```

### the script whichdiff.pl
generates the state.txt with call of script whichdiff.pl

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

-> 3683531 / first new id=6816270336  
                          6816370892
                        ->6816294185
-> 3683532 / first new id=6816295825
                          6816371220



### determine replication timestamp [6]

Another method is the usage of replication timestamp given from the imported pbf file.
The following command sequence read out the replication timestamp.

```
osmium fileinfo /data.osm.pbf > ./work/data.osm.pbf.info
cat ./work/data.osm.pbf.info | grep 'osmosis_replication_timestamp=' | cut -b35-44 > ./work/replication_timestamp.txt
REPLICATION_TIMESTAMP=$(cat ./work/replication_timestamp.txt)
wget "http://replicate-sequences.osm.mazdermind.de/?"$REPLICATION_TIMESTAMP"T00:00:00Z" -O ./work/state_mazdermind.txt
```
sample
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



# Bookmarks

* [1] https://github.com/giggls/tileserver-scripts
* [2] https://help.openstreetmap.org/questions/54378/how-to-load-and-apply-planet-osm-diff
* [3] https://lists.openstreetmap.org/pipermail/tile-serving/2016-February/003721.html
* [4] https://help.openstreetmap.org/questions/64848/reset-osmosis-update-process-after-failure-following-server-shutdown
* [5] https://ircama.github.io/osm-carto-tutorials/updating-data
* [6] https://github.com/MaZderMind/replicate-sequences
* [7] https://www.volkerschatz.com/net/osm/osm2pgsql-usage.html
