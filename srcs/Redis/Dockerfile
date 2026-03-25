FROM alpine:3.22

ARG REDIS_VERSION=8.0.4-r0

RUN apk --no-cache add bash redis=$REDIS_VERSION

RUN sysctl vm.overcommit_memory=1
COPY redis.conf /usr/local/etc/redis/redis.conf

USER guest
CMD ["redis-server", "/usr/local/etc/redis/redis.conf", "--loglevel", "verbose", "--bind", "0.0.0.0" ]