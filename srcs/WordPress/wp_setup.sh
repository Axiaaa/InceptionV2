#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


if [[ ! -d /usr/share/nginx/wp-admin  ]]; then

    echo -e $BLUE"Installing wp-cli"$NC
    wget https://github.com/wp-cli/wp-cli/releases/download/v$WP_VERSION/wp-cli-$WP_VERSION.phar
    mv ./wp-cli-$WP_VERSION.phar wp-cli.phar
    chmod +x wp-cli.phar
    echo $(ls -l)

    echo -e $BLUE"Downloading wordpress"$NC
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ core download

    echo -e $BLUE"Fixing permissions"$NC
    chown -R www-data:www-data /usr/share/nginx

    echo -e $BLUE"Waiting for DB"$NC
    sleep 5

    echo -e $BLUE"Installing wordpress"$NC
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ config create \
        --dbname="$DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$DB_HOST"

    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ core install \
        --url="$DOMAIN" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USERNAME" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ user create 'test_user' 'test_user@student.42lyon.fr' \
        --user_pass='test_user' \
        --role='editor'

    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ config set WP_REDIS_HOST redis
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ config set WP_REDIS_PORT 6379 --raw
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ config set WP_CACHE true --raw
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ plugin install redis-cache --activate
    ./wp-cli.phar --allow-root --path=/usr/share/nginx/ redis enable

    echo -e $GREEN"Done"$NC
fi

echo -e $GREEN"WP is running"$NC
exec /usr/sbin/php-fpm82 --nodaemonize
