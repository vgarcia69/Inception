#!/bin/bash

set -e

mkdir -p $WP_PATH

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

sleep 5

wp core download --path=$WP_PATH --allow-root

wp config create --allow-root \
    --dbname=$DATABASE_NAME \
    --dbuser=$MARIADB_USER \
    --dbpass=$MARIADB_PASSWD \
    --dbhost=$DBHOST \
    --path=$WP_PATH


wp core install \
    --url=https://$DOMAIN_NAME \
    --title=$TITLE \
    --admin_user=$MARIADB_ADMIN \
    --admin_password=$MARIADB_ADMIN_PASSWD \
    --path=$WP_PATH  \
    --admin_email="admin@example.com" \
    --allow-root

chown -R www-data:www-data $WP_PATH

exec php-fpm7.4 -F