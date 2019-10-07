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
tirex-batch map=ajt lon=-90,90 lat=-180,180 z=0-13 -f not-exists
```

## view status of tirex
tirex-status

## Bookmarks
- https://github.com/openstreetmap/tirex
- https://wiki.openstreetmap.org/wiki/Tirex
