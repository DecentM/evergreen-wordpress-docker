FROM alpine:3.5
MAINTAINER DecentM <decentm@decentm.com>

# Install some packages we need
RUN adduser -D -u 1000 -g 'nginx' nginx

RUN apk update
RUN apk add pwgen nginx perl openssl
RUN apk add php7-mysqli php7-pdo php7-mcrypt php7-imap php7-curl php7-zip php7-xml php7-json php7-session php7-exif php7-xmlrpc php7-mbstring php7-fpm php7-openssl

# nginx config
# RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
# RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
# RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
# RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
# RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
# RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx config
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx.d /etc/nginx/nginx.d

# Install Wordpress
ADD https://wordpress.org/latest.tar.gz /data/latest.tar.gz
RUN cd /data && tar xzf latest.tar.gz && rm latest.tar.gz
RUN rm -rf /usr/share/nginx/www
RUN chown -R nginx:nginx /data/wordpress

# Wordpress Initialization and Startup Script
COPY ./entry.sh /entry.sh
RUN chmod 555 /entry.sh

# private expose
EXPOSE 80
EXPOSE 443

# volume for mysql database and wordpress install
VOLUME ["/data"]

CMD ["/bin/ash", "/entry.sh"]
