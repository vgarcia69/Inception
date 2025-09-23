# # Utiliser Debian comme image de base
# FROM debian:bullseye-slim

# # Définir les variables d'environnement
# ENV DEBIAN_FRONTEND=noninteractive
# ENV WORDPRESS_VERSION=6.4.2
# ENV WORDPRESS_SHA1=6e3704d3a906330e1a71d9e4b8f2b1b6c1c0b8ac

# # Mettre à jour les packages et installer les dépendances
# RUN apt-get update && apt-get install -y \
#     nginx \
#     php8.1-fpm \
#     php8.1-mysql \
#     php8.1-curl \
#     php8.1-gd \
#     php8.1-intl \
#     php8.1-mbstring \
#     php8.1-soap \
#     php8.1-xml \
#     php8.1-xmlrpc \
#     php8.1-zip \
#     php8.1-cli \
#     curl \
#     ca-certificates \
#     supervisor \
#     && rm -rf /var/lib/apt/lists/*

# # Configuration PHP-FPM
# RUN sed -i 's/listen = \/run\/php\/php8.1-fpm.sock/listen = 127.0.0.1:9000/' /etc/php/8.1/fpm/pool.d/www.conf

# # Créer les répertoires nécessaires
# RUN mkdir -p /var/log/supervisor /var/run/php

# # Télécharger et installer WordPress
# WORKDIR /tmp
# RUN curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
#     && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
#     && tar -xzf wordpress.tar.gz -C /var/www/ \
#     && rm wordpress.tar.gz \
#     && chown -R www-data:www-data /var/www/wordpress

# # Copier les configurations
# COPY ../nginx/default.conf /etc/nginx/sites-available/default
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# # Exposer le port 80
# EXPOSE 80

# # Définir le répertoire de travail
# WORKDIR /var/www/wordpress

# # Variables d'environnement pour WordPress
# ENV WORDPRESS_DB_HOST=db:3306
# ENV WORDPRESS_DB_NAME=wordpress
# ENV WORDPRESS_DB_USER=wordpress
# ENV WORDPRESS_DB_PASSWORD=wordpress

# # Point d'entrée
# ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]