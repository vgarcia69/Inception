FROM debian:11

RUN apt update && apt upgrade -y && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
   chown -R mysql:mysql /var/run/mysqld && \
   chown -R mysql:mysql /var/lib/mysql

COPY script.sh /docker-entrypoint-initdb.d/script.sh
COPY config.cnf /etc/mysql/mariadb.conf.d/config.cnf

RUN chmod +x /docker-entrypoint-initdb.d/script.sh

EXPOSE 3306

CMD ["mysqld"]
