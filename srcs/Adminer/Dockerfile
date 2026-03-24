FROM alpine:latest

RUN apk add --no-cache  php \
                        php-pdo \
                        php-pdo_mysql \
                        php-pdo_pgsql \
                        php-session wget

RUN mkdir /var/www/

RUN wget -O /var/www/index.php https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php

CMD [  "php", "-S", "[::]:8080", "-t", "/var/www"]


