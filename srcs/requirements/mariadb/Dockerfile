FROM debian:12

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY script.sh script.sh
COPY config.cnf /etc/mysql/mariadb.conf.d/config.cnf

RUN chmod +x script.sh

EXPOSE 3306

ENTRYPOINT ["./script.sh"]
