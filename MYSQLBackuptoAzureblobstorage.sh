#!/bin/bash
###################################
#
# MYSQL Backup to Azure blob storage.
#
###################################
db_name="" #which databases to backup
dest="" #where to store the backup file
azure_shared_access_signature=""
host="" #mysqldump filename

#create archive filenames
day=$(date +%y-%m-%d)
archive_file="$host-$day.tar"
mysql_file="$host-mysql-$day.tar"

#database backup & compressing
mysqldump --user root --databases $db_name > "$dest/sql_dump.sql"
tar czfP $dest/$mysql_file "$dest/sql_dump.sql" && rm $dest/sql_dump.sql

#copy database dump to azure container
azcopy cp "$dest/$mysql_file" "$azure_shared_access_signature"

#remove database dump
rm -r -f $dest/$mysql_file

#echo generated files
echo "Files generated"
ls -lh $dest
