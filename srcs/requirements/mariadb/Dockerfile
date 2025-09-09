FROM debian:11

RUN apt update && apt upgrade -y && apt install -y mariadb-server sudo

COPY init.sql /docker-entrypoint-initdb.d/
COPY script.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/script.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306
