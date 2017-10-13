# Evergreen Wordpress

Whenever this image is built, it grabs the latest Wordpress, applies my custom config to php-fpm, nginx and Wordpress itself, so that it's perfect for small to medium sizes websites.
This container is meant to be run behind a reverse proxy like Traefik.

# Features  
- Lightning fast caching with nginx
- Original IP restoration from reverse proxies using the X-Forwarded-For header
- Full HTTPS support

# Installation notes
You must manually create the database, which must have the same name as the user. After that, go to https://yoursite.com/wp-admin/install.php if the site is new.

# Labels
decentm/evergreen-wordpress:latest - amd64

# Volumes
/data

# Environment variables  
All environment variables are mandatory

| Name | Description |  
| ---- | --- |  
| DB_HOST | The hostname or IP address of the MariaDB host |  
| WORDPRESS_DB | The database name and username (temporarily, this must be the site URL par https://) |  
| WORDPRESS_PASSWORD | The database password |  
