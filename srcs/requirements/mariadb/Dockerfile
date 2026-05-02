# base layer image is built on top of - gives a bare debian filesystem with apt installed
FROM debian:bookworm

# refreshes package index - -y for auto confirmation - deletes package idnex apt-get update downloaded(to reduce image size)
# happens within the same layer - each RUN creates a layer
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# copy config - takes a file frombuild context(local machine) and puts it in image fs - left is a directory mariadb reads from on startup
COPY conf/mdb.cnf /etc/mysql/conf.d/mdb.cnf

#copy entrypoint script - (goes in PATH)
COPY tools/db-setup.sh /usr/local/bin/db-setup.sh

RUN chmod +x /usr/local/bin/db-setup.sh

# mariadb's default port - metadata - doesnt open a port
EXPOSE 3306

# ENTRYPOINT [script] + CMD [main process]
# the fixed executable that always runs when a container starts(exec form)
ENTRYPOINT["db-setup.sh"]
CMD["mysqld"]
# passes mysqld as an argument to entrypoint - the full startup command: db-setup.sh mysqld
