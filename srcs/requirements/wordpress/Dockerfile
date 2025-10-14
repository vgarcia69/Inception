FROM debian:11

RUN apt update && apt upgrade -y && apt install -y php-fpm php curl unzip php7.4-mysqli

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY . .
COPY conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x ./script.sh

EXPOSE 9000

ENTRYPOINT ["./script.sh"]