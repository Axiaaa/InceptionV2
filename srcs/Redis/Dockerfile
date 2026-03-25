FROM alpine:3.22

ARG REDIS_VERSION=8.0.4-r0

RUN apk --no-cache add redis=$REDIS_VERSION

COPY redis.conf /usr/local/etc/redis/redis.conf

COPY init.sh ./
RUN chmod +x init.sh

USER guest

CMD ["sh", "-c", "./init.sh"]
