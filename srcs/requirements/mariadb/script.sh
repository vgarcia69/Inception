#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --user=mysql &

until mysqladmin ping >/dev/null; do
    sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWD}';
CREATE USER IF NOT EXISTS '${MARIADB_ADMIN}'@'localhost' IDENTIFIED BY '${MARIADB_ADMIN_PASSWD}';
GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${MARIADB_ADMIN}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY ${MARIADB_ADMIN_PASSWD};
FLUSH PRIVILEGES;
EOF

mysqladmin -u root shutdown

exec mysqld --user=mysql --datadir=/var/lib/mysql
