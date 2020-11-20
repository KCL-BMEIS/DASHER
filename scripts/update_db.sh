#!/usr/bin/env bash

source /data/xnat/home/xnat.cfg
export PGPASSWORD=$psql_pwd

for folder in /pg_backup/*
do
   sql_file=$(find "$folder" -exec stat \{} --printf="%n \n" \; | sort -n -r  | head -1)
   echo "sql file: $sql_file"
done
if [ -f $sql_file ]; then 
    echo "Windows: Backup database file detected. Restoring database." >> /data/xnat/scripts/logs/setup-xnat.log
	gunzip -k -f $sql_file
	sql_unpacked="${sql_file/.gz/}" 
	echo "doing this sql file: $sql_file - unpacked: $sql_unpacked "
    psql -h xnat-db1 -p 5432 -U xnat  -f $sql_unpacked -L /data/xnat/scripts/logs/sql_restore.log
fi