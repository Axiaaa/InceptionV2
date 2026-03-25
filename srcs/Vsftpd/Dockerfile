FROM alpine:3.22

ARG FTP_USER
ARG FTP_PASSWORD

RUN apk add --no-cache vsftpd \
 && echo "/sbin/nologin" >> /etc/shells \
 && adduser -D -u 1001 -h /var/ftp -s /sbin/nologin $FTP_USER \
 && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd \
 && mkdir -p /var/ftp/upload \
 && chown root:root /var/ftp \
 && chmod 755 /var/ftp \
 && chown $FTP_USER:$FTP_USER /var/ftp/upload

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]