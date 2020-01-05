# create backup of osm db

# first step - create a link to backup directory
the following sample shows how to create a soft link to backup directory
```
cd src_tileserver_scripts
ln -s /media/NVMe/backup_osmdb ./volumes/backup
```

# second step - start dockercontainer and connect to console
```
cd src_tileserver_scripts
scripts/docker-service.sh start
scripts/docker-service.sh connect
```

# third step - start backup procedure
use following commands to create the backup
```
create_backup.sh
```
