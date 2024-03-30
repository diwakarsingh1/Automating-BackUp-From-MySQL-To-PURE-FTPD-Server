# Automating-BackUp-From-MySQL-To-PURE-FTPD-Server
# About the Project -

This project implements a full automation of generating a timestamped backup of a specified MySQL database, compressing it into a ZIP file, and storing it locally. The compressed backup is then uploaded to an FTP server using provided credentials. Additionally, it deletes local backup files older than 10 days, ensuring efficient storage management.

# Step 1: Update the system

    sudo apt update

# Step 2: Install MySql

    sudo apt install mysql-server

# Step 3: Check the Status of MySql (Active or Inactive)

    sudo systemctl status mysql

# Step 4: Login to MySql as a root

    sudo mysql

# Step 5: Update the password for the MySql Server

    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'place-your-password-here';
    FLUSH PRIVILEGES;

# Step 6: Test the MySql server if it is working by running sample sql queries

    CREATE DATABASE my_database;
    USE my_database;
    CREATE TABLE table1 (id INT, name VARCHAR(45));
    INSERT INTO table1 VALUES(1, 'Rahul'), (2, 'Varun'), (3, 'Vishal'), (4, 'Harsh');
    SELECT * FROM table1;

# Step 7: Create the file with name [ .my.cnf ] for storing the mysql credentials.

    [ client ]

    username=root
    password=my_pass

# Step 8: Using Docker Compose configure pure-ftpd server locally.
<h4> Here is the full docker-compose file.</h4>

    version: '3'
    services:
      ftpd_server:
        image: stilliard/pure-ftpd
        container_name: pure-ftpd
        ports:
          - "21:21"
          - "30000-30009:30000-30009"
        volumes: 
          - "/root/ftp_data:/home/username"
          - "./passwd:/etc/pure-ftpd/passwd"
        environment:
          PUBLICHOST: "localhost"
          FTP_USER_NAME: username
          FTP_USER_PASS: mypass
          FTP_USER_HOME: /home/username
        restart: always

<h4>Now run the below command in your terminal to run the container.</h4>

    docker-compose up -d

# Step 9: Now write the full bash script for automating the back-up.

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

# Step 10: Now set-up the cron job for automating the execution of the script.
<h4>Now write the below command in your terminal.</h4>

    crontab -e

<h4>Cron Job Scheduler, to write inside the above.</h4>

    0 22 * * * /root/backup-script.sh

# Voila!💥 Your automation of generating a timestamped backup of a specified MySQL database is ready.
