#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --user=mysql &

until mysqladmin ping >/dev/null; do
    sleep 1
done

mysql -u root -e << EOF
CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};

CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'localhost' IDENTIFIED BY "${MARIADB_PASSWD}";
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY "${MARIADB_PASSWD}";

CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";

ALTER USER 'root'@'%' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";
ALTER USER 'root'@'localhost' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';

FLUSH PRIVILEGES;
USE ${DATABASE_NAME};
EOF

mysqladmin -u root -p ${MARIADB_ADMIN_PASSWD} shutdown

exec mysqld --user=mysql --datadir=/var/lib/mysql
