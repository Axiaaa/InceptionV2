sysctl vm.overcommit_memory=1

# Start redis server
redis-server /usr/local/etc/redis/redis.conf --loglevel verbose
