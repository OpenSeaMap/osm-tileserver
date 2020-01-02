# Tirex

## build instructions
```
  apt install libipc-sharelite-perl libjson-perl libgd-gd2-perl libwww-perl devscripts
  git clone https://github.com/openstreetmap/tirex.git
  tirex/
  make
  make deb
  make install
  make install-example-map
  make install-munin
  make install-nagios  

  mkdir /var/lib/tirex
  chown tirex:tirex /var/lib/tirex
  mkdir /var/log/tirex
  mkdir /var/run/tirex
  chown tirex:tirex /var/run/tirex
  chown tirex:tirex /var/log/tirex/

```

## start tires services
sudo -u tirex tirex-backend-manager
sudo -u tirex tirex-master

## prerender Tiles
```
tirex-batch map=ajt lon=-90,90 lat=-180,180 z=0-1 -f not-exists
tirex-batch map=ajt x=16 y=8 z=5
```

errors:
tirex-master[148]: Job with id=1570546108_94518102623968 timed out on rendering list (map=ajt z=7 x=64 y=40)
tirex-master[148]: Job with id=1570546056_94518102469504 timed out on rendering list (map=ajt z=5 x=16 y=8)
tirex-master[148]: Job with id=1570546107_94518102614976 timed out on rendering list (map=ajt z=6 x=32 y=16)

## RENDER SINGLE tiles
http://213.209.102.17/tile/15/8409/12177.png
http://213.209.102.17/tile/17/33640/48710.png
http://213.209.102.17/tile/14/8795/5375.png

# INSTALL SCRIPT
wget https://raw.githubusercontent.com/giggls/openstreetmap-carto-de/master/scripts/render_single_tile.py

# prerender tiles
sudo -u renderer ./scripts/render_single_tile.py -t -s mapnik.xml -o /transfer/test-z05.png -u /5/15/10.png
sudo -u renderer ./scripts/render_single_tile.py -t -s mapnik.xml -o /transfer/test-15-8409-12177.png -u /15/8409/12177.png
sudo -u renderer ./scripts/render_single_tile.py -t -s mapnik.xml -o /transfer/test-17-33640-48710.png -u /17/33640/48710.png
sudo -u renderer ./scripts/render_single_tile.py -t -s mapnik.xml -o /transfer/test-14-8795-5375.png -u /14/8795/5375.png

### PostgreSQL
sudo -u renderer

scripts/indexes.py  --reindex > reindex.sql
sudo -u postgres psql -d gis -f reindex.sql



## view status of tirex
tirex-status

## Bookmarks
- https://github.com/openstreetmap/tirex
- https://wiki.openstreetmap.org/wiki/Tirex

###

# install carto and generate mapnik.xml file
npm install -g carto@1.2.0
carto project.mml > mapnik.xml

# generate index file
./scripts/indexes.py --fillfactor 100 --osm2pgsql --concurrent > indexes.sql

# create index
sudo -u postgres psql -d gis -f indexes.sql
