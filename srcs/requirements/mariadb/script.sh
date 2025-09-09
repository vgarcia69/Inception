#!/bin/bash

# recuprer les lignes du .env pour les export dans le container
# export $(cat srcs/.env) 
# ############## ou #######
# set -a
# source /etc/mariadb/.env    
# set +a

cd /etc/mariadb/

./init.sql

echo "mdp: $MARIADB_ADMIN_PASSWD." && sync

mysql -u root -p $MARIADB_ADMIN_PASSWD
