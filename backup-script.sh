#!/usr/bin/bash

DATE=`date "+%Y_%B_%T"`
DB_NAME="sh_task"

#  FTP CREDENTAILS

FTP_USER="username"
FTP_PASS="mypass"
FTP_HOST="localhost"
FTP_DIR="/backup"
YEAR=$(date +%Y)
MONTH=$(date +%B)

# LOCAL BACKUP DIRECTORY

BACKUP_FILE_NAME="$DB_NAME-$DATE.sql.gz"
BACKUP_LOCAL_DIR="/root/mysql_backup/$YEAR/$MONTH"
mkdir -p "$BACKUP_LOCAL_DIR"
BACKUP_FILE="$BACKUP_LOCAL_DIR/$DB_NAME-$DATE.sql.gz"
mysqldump  $DB_NAME  | gzip >  $BACKUP_FILE

#  FTP SERVER LOGIN

cd $BACKUP_LOCAL_DIR
ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
cd $FTP_DIR
mkdir $YEAR
cd $YEAR
mkdir $MONTH
cd $MONTH
put $BACKUP_FILE_NAME
quit
END_SCRIPT

# DELETING THE FILE 10 DAYS OLD

find $BACKUP_LOCAL_DIR -type f -name "$DB_NAME-*.sql.gz" -mtime +10 -exec rm {} \; 
