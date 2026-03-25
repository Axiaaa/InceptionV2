sysctl vm.overcommit_memory=1

redis-server /usr/local/etc/redis/redis.conf --loglevel verbose --bind 0.0.0.0
