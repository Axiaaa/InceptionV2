#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ ! -d /var/lib/mysql/mysql ]]; then
    echo -e $BLUE"Installing MariaDB"$NC
    mysql_install_db > /dev/null 2>&1
    mariadbd-safe > /dev/null 2>&1 &

    RET=1
    while [[ RET -ne 0 ]]; do
        echo -e $BLUE"Waiting for service"$NC
        sleep 2
        /usr/bin/mariadb -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    echo -e $BLUE"Initializing db"$NC
    /usr/bin/mariadb -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"
    /usr/bin/mariadb -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
    /usr/bin/mariadb -uroot -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'"
    /usr/bin/mariadb -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION"
    /usr/bin/mariadb -uroot -e "CREATE DATABASE wordpress"
    echo -e $GREEN"Done"$NC
    /usr/bin/mariadb-admin -uroot shutdown
fi

echo -e $GREEN"MariaDB Running"$NC
exec mariadbd-safe --defaults-file=/etc/my.cnf