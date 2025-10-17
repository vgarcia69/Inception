#!/bin/bash

set -e

if [ ! -d /usr/local/bin/wp/wp-cli.phar ]; then

    echo "installing wp-client"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

fi

set +e

i=0
until netcat -z "$DBHOST" 3306; do
    if [ $i == 10 ]; then
        exit 1
    fi
    echo "Waiting for MariaDB port 3306..."
    sleep 1
    let i++
done

set -e

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "Building config"
    wp core download --path=$WP_PATH --allow-root

    wp config create --allow-root \
        --dbname=$DATABASE_NAME \
        --dbuser=$MARIADB_USER \
        --dbpass=$MARIADB_PASSWD \
        --dbhost=$DBHOST \
        --path=$WP_PATH

    wp core install --allow-root \
        --url=https://$DOMAIN_NAME \
        --title=$TITLE \
        --admin_user=$MARIADB_ADMIN \
        --admin_password=$MARIADB_ADMIN_PASSWD \
        --path=$WP_PATH  \
        --admin_email=$WP_MAIL_ADMIN

    wp user create --allow-root --role=author \
        $MARIADB_USER \
        $WP_MAIL \
        --user_pass=$MARIADB_PASSWD \
        --path=$WP_PATH

    chown -R www-data:www-data $WP_PATH
else
    echo "Config already existing"
fi

exec php-fpm8.2 -F