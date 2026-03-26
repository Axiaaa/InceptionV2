FROM alpine:3.2

ARG NET2FTP_VERSION=net2ftp_v1.4

RUN apk add --no-cache \
            php82 \
            apache2 \
            php-apache2 \
    && rm -f /var/cache/apk/*

RUN cd /tmp/ && \
    wget http://www.net2ftp.com/download/${NET2FTP_VERSION}.zip && \
    unzip ${NET2FTP_VERSION}.zip && \
    chmod 0777 ${NET2FTP_VERSION}b/files_to_upload/temp && \
    mv -f ${NET2FTP_VERSION}b/files_to_upload/* /var/www/localhost/htdocs/ && \
    rm -fr /tmp/*

COPY php_value.conf /etc/apache2/conf.d/

ENTRYPOINT ["apachectl"]
CMD ["-D", "FOREGROUND"]
