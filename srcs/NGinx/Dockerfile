FROM alpine:3.22

ARG NGINX_VERSION=1.28.2-r0

RUN apk add --no-cache \
    nginx=$NGINX_VERSION \
    openssl \
    curl

RUN mkdir -p /etc/nginx/ssl /run/nginx

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lcamerly.42.fr/CN=lcamerly.42.fr"

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]