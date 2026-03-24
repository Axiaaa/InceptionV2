FROM alpine:3.22

RUN apk --update add redis

COPY redis.conf /usr/local/etc/redis/redis.conf

COPY init.sh ./
RUN chmod +x init.sh

USER guest

CMD ["sh", "-c", "./init.sh"]
