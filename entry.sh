#!/bin/ash

mkdir /etc/nginx/keys
mkdir /data/logs
mkdir /data/wordpress
mkdir /tmp/php-fpm
chown nginx:nginx -R /tmp/php-fpm

if [ ! -f /data/wp-config.php ]; then
  sed -e "s/database_name_here/$WORDPRESS_DB/
  s/username_here/$WORDPRESS_DB/
  s/password_here/$WORDPRESS_PASSWORD/
  /'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /data/wordpress/wp-config-sample.php > /data/wordpress/wp-config.php

  echo "
    define('AUTOSAVE_INTERVAL', 30);
    define('WP_POST_REVISIONS', 10);
    define('DISALOW_FILE_EDIT', true);
    define('FORCE_SSL_ADMIN', true);
    define('AUTOMATIC_UPDATER_DISABLED', false);
    define('WP_AUTO_UPDATE_CORE', true);
    define('IMAGE_EDIT_OVERWRITE', true);
    define('COMPRESS_CSS', true);
    define('COMPRESS_SCRIPTS', true);
    define('CONCATENATE_SCRIPTS', true);
  " >> /data/wordpress/wp-config.php

  chown nginx:nginx -R /data/wordpress
fi

openssl req -new -newkey rsa:2048 \
  -days $(perl -e 'print sprintf("%d",((((2**31)-1)-(time))/86400))') \
  -nodes \
  -x509 \
  -keyout /usr/share/server.key \
  -out /usr/share/server.crt \
  -subj "/C=00/ST=Local/L=Local/O=You/OU=Docker automation/CN=*"

curl https://2ton.com.au/dhparam/2048/$(($RANDOM % 128)) > /etc/nginx/keys/dhparam.pem

/usr/bin/supervisord -n -c /etc/supervisord.conf
