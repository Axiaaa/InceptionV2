FROM alpine:3.22

ARG ADMINER_VERSION=5.4.2

RUN apk add --no-cache \
        php82 \
        php82-pdo \
        php82-pdo_mysql \
        php82-pdo_pgsql \
        php82-session \
        curl \
    && rm -f /var/cache/apk/*

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN	addgroup -S adminer \
    &&	adduser -S -G adminer adminer \
    &&	mkdir -p /var/www/html \
    &&	chown -R adminer:adminer /var/www/html

WORKDIR /var/www/html

RUN curl -fsSL https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -o index.php

USER adminer
CMD [ "php", "-S", "[::]:8080", "-t", "/var/www/html"]


