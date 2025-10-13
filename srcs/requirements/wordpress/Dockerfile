FROM debian:11

RUN apt update && apt upgrade -y && apt install -y php-fpm php curl unzip

COPY . .

RUN chmod +x ./script.sh
RUN rm -rf /var/www/html
RUN mkdir -p /var/www/html

RUN curl -LO https://wordpress.org/latest.zip && unzip latest.zip

RUN mv latest.zip /var/www/html


ENTRYPOINT ["./script.sh"]