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
![](/Automating-BackUp-From-MySQL-To-PURE-FTPD-Server/.my.cnf)
