FROM debian:12

RUN apt update && apt upgrade -y && apt install -y nginx openssl

COPY default.conf etc/nginx/conf.d

RUN openssl genrsa -out vgarcia.key 2048
RUN openssl req -x509 -new -key vgarcia.key -out vgarcia.crt \
    -subj "/C=Fr/ST=Rhone/L=Lyon/O=Inception, Inc./OU=IT/CN=vgarcia.42.fr"

RUN chmod 644 vgarcia.key vgarcia.crt
RUN mv vgarcia.key /etc/nginx/vgarcia.key
RUN mv vgarcia.crt /etc/nginx/vgarcia.crt

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
