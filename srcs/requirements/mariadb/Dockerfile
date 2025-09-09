FROM debian:11

RUN apt update && apt upgrade -y && apt install -y mariadb-server gettext

RUN mkdir /run/mysqld /var/lib/mysql &&\ 
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY init.sql /
COPY script.sh /

RUN chmod +x /script.sh
RUN chmod +x /init.sql

EXPOSE 3306

ENTRYPOINT ["/script.sh"]
