FROM debian:12

RUN apt update && apt upgrade -y && apt install -y php-fpm php curl unzip php8.2-mysqli
RUN apt-get install -y netcat-traditional 

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY . .
COPY conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x ./script.sh

EXPOSE 9000

ENTRYPOINT ["./script.sh"]