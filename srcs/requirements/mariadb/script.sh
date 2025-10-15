#!/bin/bash

set -e

rm -rf /var/lib/apt/lists/* && rm -rf /var/lib/mysql/*

echo "Installing DataBase"
mysql_install_db --user=mysql --datadir=${MARIADB_PATH} --basedir=/usr

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

mysqld_safe --user=mysql --pid-file=/run/mysqld/mysqld.pid &
MYSQLD_PID=$!

until mysqladmin ping >/dev/null 2>&1; do
    echo "Wait for init to be done"
    sleep 1
done

echo "Starting configuration"

mysql -u root << EOF

CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};

CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'localhost' IDENTIFIED BY "${MARIADB_PASSWD}";
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY "${MARIADB_PASSWD}";

CREATE USER IF NOT EXISTS '${MARIADB_ADMIN}'@'%' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";
CREATE USER IF NOT EXISTS '${MARIADB_ADMIN}'@'localhost' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";

GRANT ALL PRIVILEGES ON *.* TO '${MARIADB_ADMIN}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '${MARIADB_ADMIN}'@'%' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${MARIADB_USER}'@'localhost';
GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${MARIADB_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ADMIN_PASSWD}';

DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

FLUSH PRIVILEGES;

EOF

echo "Initialisation Done"

mysqladmin -u ${MARIADB_ADMIN} -p${MARIADB_ADMIN_PASSWD} shutdown

exec mysqld --user=mysql --datadir=${MARIADB_PATH}
