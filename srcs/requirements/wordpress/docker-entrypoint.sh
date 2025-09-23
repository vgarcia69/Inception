#!/bin/bash
set -e

# Fonction pour générer des clés aléaoires WordPress
generate_wp_keys() {
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ 2>/dev/null || cat <<EOF
define('AUTH_KEY',         '$(openssl rand -base64 32)');
define('SECURE_AUTH_KEY',  '$(openssl rand -base64 32)');
define('LOGGED_IN_KEY',    '$(openssl rand -base64 32)');
define('NONCE_KEY',        '$(openssl rand -base64 32)');
define('AUTH_SALT',        '$(openssl rand -base64 32)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 32)');
define('LOGGED_IN_SALT',   '$(openssl rand -base64 32)');
define('NONCE_SALT',       '$(openssl rand -base64 32)');
EOF
}

# Fonction pour attendre que la base de données soit disponible
wait_for_db() {
    echo "🔄 En attente de la base de données sur $WORDPRESS_DB_HOST..."
    
    # Extraire l'host et le port
    DB_HOST=$(echo $WORDPRESS_DB_HOST | cut -d: -f1)
    DB_PORT=$(echo $WORDPRESS_DB_HOST | cut -d: -f2)
    
    # Si pas de port spécifié, utiliser 3306 par défaut
    if [ "$DB_PORT" = "$DB_HOST" ]; then
        DB_PORT=3306
    fi
    
    # Attendre que le port soit ouvert
    while ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/$DB_HOST/$DB_PORT" 2>/dev/null; do
        echo "⏳ Base de données non disponible, nouvelle tentative dans 2 secondes..."
        sleep 2
    done
    
    echo "✅ Base de données disponible !"
}

# Créer wp-config.php si il n'existe pas
if [ ! -f wp-config.php ]; then
    echo "📝 Création de wp-config.php..."
    
    # Attendre que la DB soit disponible
    if [ "$WORDPRESS_DB_HOST" ]; then
        wait_for_db
    fi
    
    # Générer les clés de sécurité
    echo "🔑 Génération des clés de sécurité WordPress..."
    WP_KEYS=$(generate_wp_keys)
    
    # Générer wp-config.php avec les bonnes variables d'environnement
    cat > wp-config.php <<EOF
<?php

define('DB_NAME', '${WORDPRESS_DB_NAME:-wordpress}');
define('DB_USER', '${WORDPRESS_DB_USER:-wordpress}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD:-wordpress}');
define('DB_HOST', '${WORDPRESS_DB_HOST:-localhost}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$WP_KEYS



\$table_prefix = '${WORDPRESS_TABLE_PREFIX:-wp_}';


define('WP_DEBUG', ${WORDPRESS_DEBUG:-false});
define('WP_DEBUG_LOG', ${WORDPRESS_DEBUG_LOG:-false});
define('WP_DEBUG_DISPLAY', ${WORDPRESS_DEBUG_DISPLAY:-false});


define('WPLANG', '${WORDPRESS_LOCALE:-fr_FR}');

define('WP_AUTO_UPDATE_CORE', ${WORDPRESS_AUTO_UPDATE:-true});

ini_set('memory_limit', '${WORDPRESS_MEMORY_LIMIT:-256M}');


define('WP_MEMORY_LIMIT', '${WORDPRESS_MEMORY_LIMIT:-256M}');

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

EOF

    chown www-data:www-data wp-config.php
    chmod 644 wp-config.php
    echo "✅ wp-config.php créé avec succès"
fi

chown -R www-data:www-data /var/www/wordpress
find /var/www/wordpress -type d -exec chmod 755 {} \;
find /var/www/wordpress -type f -exec chmod 644 {} \;

if [ ! -d wp-content/uploads ]; then
    echo "📁 Création du dossier uploads..."
    mkdir -p wp-content/uploads
    chown www-data:www-data wp-content/uploads
    chmod 755 wp-content/uploads
fi

exec "$@"