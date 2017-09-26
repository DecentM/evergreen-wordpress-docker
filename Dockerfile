FROM alpine:3.5
MAINTAINER DecentM <decentm@decentm.com>

RUN adduser -D -u 1000 -g 'nginx' nginx

# Install some packages we need
RUN apk update
RUN apk add pwgen nginx perl openssl curl supervisor wget
RUN apk add php7-mysqli php7-pdo php7-mcrypt php7-imap php7-curl php7-zip php7-xml php7-json php7-session php7-exif php7-xmlrpc php7-mbstring php7-fpm php7-openssl

# nginx config
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx.d /etc/nginx/nginx.d
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./php-fpm.conf /etc/php7/php-fpm.conf
COPY ./wp-config.php /usr/share/wp-config-sample.php

COPY ./entry.sh /entry.sh
RUN chmod 555 /entry.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/data"]

CMD ["/bin/ash", "/entry.sh"]
