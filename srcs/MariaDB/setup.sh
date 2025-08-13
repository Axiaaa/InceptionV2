#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ ! -d /usr/share/mariadb/mysql ]]; then
    echo -e $BLUE"Installing MariaDB"$NC
    mysql_install_db > /dev/null 2>&1
    /usr/bin/mysqld_safe > /dev/null 2>&1 &


    RET=1
    while [[ RET -ne 0 ]]; do
        echo -e $BLUE"Waiting for service"$NC
        sleep 2
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    echo -e $BLUE"Initializing db"$NC
    mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
    mysql -uroot -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION"
    mysql -uroot -e "CREATE DATABASE wordpress"
    echo -e $GREEN"Done"$NC
    mysqladmin -uroot shutdown
fi

echo -e $GREEN"MariaDB Running"$NC
exec mysqld_safe --defaults-file=/etc/mysql/my.cnf