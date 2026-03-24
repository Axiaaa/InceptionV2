FROM alpine:latest

RUN apk --update add redis

COPY redis.conf /usr/local/etc/redis/redis.conf

COPY init.sh ./
RUN chmod +x init.sh

CMD ["sh", "-c", "./init.sh"]
