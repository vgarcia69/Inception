FROM debian:11

RUN apt update && apt upgrade -y && apt install -y nginx

COPY . /etc/nginx/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
