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

## configure mod_tile
```
ModTileRenderdSocketName /var/lib/tirex/modtile.sock
ModTileTileDir           /var/lib/tirex/tiles
AddTileConfig            /tiles/test/ test
```

cat /home/renderer/src/mod_tile/debian/tile.load
    LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so

/etc/apache2/mods-available/tile.conf

```
# file tile.conf
ModTileRenderdSocketName     /var/lib/tirex/modtile.sock
ModTileTileDir               /var/lib/mod_tile
ModTileMaxLoadOld            2
AddTileConfig                /tiles/base/ base
```

find /etc/ -type f -exec grep -H 'ModTileRenderdSocketName' {} \;
  /etc/apache2/sites-available/000-default.conf:    ModTileRenderdSocketName /var/lib/tirex/modtile.sock

######################################################
define map for tirex  
/etc/tirex/renderer/mapnik/ajt.conf  

# symbolic name
name=ajt

#tile directory
tiledir=/var/lib/mod_tile
minz=0
maxz=18
mapfile=/home/renderer/src/openstreetmap-carto/mapnik.xml


/home/renderer/src/openstreetmap-carto/mapnik.xml

## Bookmarks
- https://github.com/openstreetmap/tirex
- https://wiki.openstreetmap.org/wiki/Tirex


## docker build
docker build -t osm-tile-server-tirex src/

## start tirex

sudo -u renderer tirex-backend-manager
sudo -u renderer tirex-master -d -f

## test renderer
tirex-batch --prio=1 map=test z=0 x=0 y=0

tirex-status
