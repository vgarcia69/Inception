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

CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'localhost' IDENTIFIED BY "${MARIADB_PASSWD}";
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY "${MARIADB_PASSWD}";

CREATE USER IF NOT EXISTS '${MARIADB_ADMIN}'@'%' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";
CREATE USER IF NOT EXISTS '${MARIADB_ADMIN}'@'localhost' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";

GRANT ALL PRIVILEGES ON *.* TO  '${MARIADB_ADMIN}'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO  '${MARIADB_ADMIN}'@'%';


ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIADB_ADMIN_PASSWD}');
ALTER USER '${MARIADB_ADMIN}'@'localhost' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";
ALTER USER '${MARIADB_ADMIN}'@'%' IDENTIFIED BY "${MARIADB_ADMIN_PASSWD}";

GRANT ALL PRIVILEGES ON `${DATABASE_NAME}`.* TO '${MARIADB_USER}'@'%';
CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};

DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db LIKE 'test%';
FLUSH PRIVILEGES;

EOF

mysqladmin -u root -p ${MARIADB_ADMIN_PASSWD} shutdown

exec mysqld --user=mysql --datadir=/var/lib/mysql
