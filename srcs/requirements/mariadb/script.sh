#!/bin/bash

set -e

# #log in the admin user
# exec mysql -u root -p $MARIADB_ADMIN_PASSWD



envsubst < /init.sql > /tmp/init_tmp.sql

chmod +x /tmp/init_tmp.sql



mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock


mysql -u root -p ${MARIADB_ROOT_PASSWD} < /tmp/init_tmp.sql
