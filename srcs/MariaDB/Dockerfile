FROM debian:bookworm

# Set the environment variables
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_PASSWORD
ARG MYSQL_USER

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/mysql
RUN chown mysql:mysql /var/log/mysql
# Copy the configuration file
COPY my.cnf /etc/mysql/my.cnf

# Copy the script, set the permissions
COPY setup.sh /usr/bin/setup.sh
RUN chmod +x /usr/bin/setup.sh

RUN curl https://raw.githubusercontent.com/MariaDB/mariadb-docker/refs/heads/master/healthcheck.sh > /bin/healthcheck.sh
RUN chmod +x /bin/healthcheck.sh

RUN echo "Starting MariaDB"

# Run the script
CMD ["/usr/bin/setup.sh"]
