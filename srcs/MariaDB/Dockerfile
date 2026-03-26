FROM alpine:3.22

ARG MARIADB_VERSION=11.4.8-r0

RUN apk add --no-cache \
            mariadb=$MARIADB_VERSION \
            mariadb-client=$MARIADB_VERSION \
            curl \
            bash \
    && rm -f /var/cache/apk/*

RUN mkdir -p /run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /run/mysqld /var/log/mysql

COPY my.cnf /etc/my.cnf

COPY setup.sh /usr/bin/setup.sh
RUN chmod +x /usr/bin/setup.sh

RUN curl -o /bin/healthcheck.sh https://raw.githubusercontent.com/MariaDB/mariadb-docker/refs/heads/master/healthcheck.sh && \
    chmod +x /bin/healthcheck.sh

CMD ["/usr/bin/setup.sh"]