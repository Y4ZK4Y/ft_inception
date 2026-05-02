#!/bin/sh

# make script exit immediately if commands fail - good to use in entrypoint scripts
set -e

# read secrets - read password out of a file into a shell variable -(not in env var)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# only initialize if this is a fresh start
# /var/lib/mysql/mysql is the system database directory
# if it exists, mariadb was already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then

    # initialize the data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # start a temporary instance to run setup SQL
    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;

-- set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- create wordpress database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- create wordpress user
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';

-- grant full access to wordpress database
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

fi

# hand off to mysqld as PID 1
exec "$@"
