FROM debian:11

RUN apt update && apt upgrade -y && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && \
   chown -R mysql:mysql /run/mysqld && \
   chown -R mysql:mysql /var/lib/mysql

COPY script.sh script.sh
COPY config.cnf /etc/mysql/mariadb.conf.d/config.cnf

RUN chmod +x script.sh
RUN chmod 755 /run/mysqld

EXPOSE 3306

CMD ["./script.sh"]
