FROM debian:11

RUN apt update && apt upgrade -y && apt install -y php7.4-zip php7.4-mbstring mariadb-client 

EXPOSE 9000

RUN chmod +x script.sh

ENTRYPOINT ["script.sh"]