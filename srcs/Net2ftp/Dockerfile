FROM alpine:3.22

ARG NET2FTP_VERSION=net2ftp_v1.4

RUN apk add --update \
        php \
        php-ftp \
        php-apache2 \
        && \
    rm -f /var/cache/apk/*

RUN cd /tmp/ && \
    wget http://www.net2ftp.com/download/${NET2FTP_VERSION}.zip && \
    unzip ${NET2FTP_VERSION}.zip && \
    chmod 0777 ${NET2FTP_VERSION}b/files_to_upload/temp && \
    # rm -f /var/www/localhost/htdocs/index.html && \
    mv -f ${NET2FTP_VERSION}b/files_to_upload/* /var/www/localhost/htdocs/ && \
    rm -fr /tmp/*


COPY prepend.php /var/www/localhost/htdocs/prepend.php

CMD ["php", "-d", "auto_prepend_file=/var/www/localhost/htdocs/prepend.php", \
     "-S", "[::]:8081", "-t", "/var/www/localhost/htdocs"]