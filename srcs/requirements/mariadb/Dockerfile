FROM debian:11

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY . .

EXPOSE 3306

RUN chmod +x ./script.sh

ENTRYPOINT ["./script.sh"]
