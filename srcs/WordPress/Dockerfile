FROM alpine:3.22

RUN apk add --no-cache  php82 \
                        php82-phar \
                        php82-pdo \
                        php82-pdo_mysql \
                        php82-mysqli \
                        php82-mbstring \
                        php82-tokenizer \
                        php82-json \
                        php82-opcache \
                        php82-ctype \
                        php82-curl \
                        php82-fpm \
                        mariadb-client \
                        curl \
                        unzip \
                        bash

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN addgroup -S www-data 2>/dev/null || true && \
    adduser -S -D -G www-data www-data 2>/dev/null || true
    
RUN sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php82/php.ini

COPY ./www.conf /etc/php82/php-fpm.d/www.conf

COPY ./wp_setup.sh /wp_setup.sh
RUN chmod +x /wp_setup.sh

CMD ["/wp_setup.sh"]
