FROM alpine:3.22

ARG REDIS_VERSION=8.0.4-r0

RUN apk --no-cache add \
        bash \ 
        redis=$REDIS_VERSION \
    && rm -f /var/cache/apk/* \
    && mkdir -p /data \
    && chown guest:users /data
    
COPY redis.conf /usr/local/etc/redis/redis.conf
RUN chown guest:users -R /var/run/ 

COPY init.sh /init.sh
RUN chmod +x init.sh

USER guest
CMD ["/init.sh"]
