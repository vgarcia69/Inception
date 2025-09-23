# # FROM debian:11

# # RUN apt update && apt upgrade -y && apt install -y php7.4-fpm php7.4-mbstring mariadb-client

# # COPY . .

# # RUN chmod +x ./script.sh

# # ENTRYPOINT ["script.sh"]

# # Utilise une image Debian slim comme base pour une taille réduite

# FROM debian:stable-slim

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         apache2 \
#         php \
#         php-mysql \
#         php-cli \
#         php-json \
#         php-gd \
#         php-curl \
#         php-mbstring \
#         php-xml \
#         php-zip \
#         php-imagick \
#         php-common \
#         php-fpm \
#         mariadb-client \
#         git \
#         unzip \
#     && rm -rf /var/lib/apt/lists/*

# RUN a2enmod rewrite \
#             headers \
#             proxy_fcgi \
#             setenvif \
#             dir

# COPY default.conf /etc/apache2/sites-available/000-default.conf
# RUN a2ensite 000-default.conf

# WORKDIR /var/www/html
# RUN rm -rf /var/www/html/* && \
#     curl -o wordpress.zip https://wordpress.org/latest.zip && \
#     unzip wordpress.zip && \
#     mv wordpress/* . && \
#     rm -r wordpress wordpress.zip

# RUN chown -R www-data:www-data /var/www/html && \
#     chmod -R 755 /var/www/html

# EXPOSE 80

# COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# CMD ["docker-entrypoint.sh"]