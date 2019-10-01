# used versions

mapnik
-  libmapnik-dev/bionic,now 3.0.19+ds-1 amd64 [installed]
-  libmapnik3.0/bionic,now 3.0.19+ds-1 amd64 [installed,automatic]
-  mapnik-utils/bionic,now 3.0.19+ds-1 amd64 [installed]
-  python-mapnik/bionic,now 1:0.0~20180130-804a7947d-1 amd64 [installed]

apache2
-  Server version: Apache/2.4.29 (Ubuntu)
-  Server built:   2019-09-16T12:58:48

carto
-  carto 1.1.0 (Carto map stylesheet compiler)
-  optional (0.18.2)

mod_tile
-  https://github.com/SomeoneElseOSM/mod_tile.git
-  commit id: aa3d8edd778220e8e701e56d8bc7f16286060520
-  branch switch2osm

openstreetmap-carto
-  https://github.com/gravitystorm/openstreetmap-carto.git
-  commit id: 85a58e0cd18fe5d8c53b40b2c98f07f92174017f
-  master

osm2pgsql
-  https://github.com/openstreetmap/osm2pgsql.git
-  commit id: 08de8ced4ff819dab5b3728b3e87d3932dc6d06d
-  master

regional
-  https://github.com/zverik/regional
-  commit id: 612fe3e040d8bb70d2ab3b133f3b2cfc6c940520
-  HEAD


# version info commands
the following commands read out versions of the docker container

```
apt list --installed | grep mapnik
apache2 -v
carto -v

git -C mod_tile/ remote -v
git -C mod_tile/ log --format="%H" -n 1
git -C mod_tile/ branch | grep \* | cut -d ' ' -f2

git -C openstreetmap-carto/ remote -v
git -C openstreetmap-carto/ log --format="%H" -n 1
git -C openstreetmap-carto/ branch | grep \* | cut -d ' ' -f2

git -C osm2pgsql/ remote -v
git -C osm2pgsql/ log --format="%H" -n 1
git -C osm2pgsql/ branch | grep \* | cut -d ' ' -f2

git -C regional/ remote -v
git -C regional/ log --format="%H" -n 1
git -C regional/ branch | grep \* | cut -d ' ' -f2
```
