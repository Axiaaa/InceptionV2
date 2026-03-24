FROM debian:bookworm

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install less curl unzip php php-mysql php-fpm mariadb-client -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./www.conf /etc/php/8.2/fpm/pool.d/

COPY ./wp_setup.sh 	/usr/local/bin/wp_setup.sh
RUN chmod +x /usr/local/bin/wp_setup.sh

RUN echo "Starting WordPress"

CMD ["/usr/local/bin/wp_setup.sh"]
