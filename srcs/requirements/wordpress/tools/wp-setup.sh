#!/bin/sh
set -e

# read secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials.txt | grep WP_ADMIN_PASSWORD | cut -d= -f2)
WP_USER_PASSWORD=$(cat /run/secrets/credentials.txt | grep WP_USER_PASSWORD | cut -d= -f2)

# download wp-cli if not present
if [ ! -f /usr/local/bin/wp ]; then
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x /usr/local/bin/wp
fi

# wait for mariadb to be ready
until mysqladmin ping -h mariadb -u root --silent 2>/dev/null; do
    echo "waiting for mariadb..."
    sleep 1
done

# only run wordpress setup on first boot
if [ ! -f /var/www/html/wp-config.php ]; then

    # download wordpress core files
    wp core download --allow-root

    # generate wp-config.php
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    # install wordpress (creates database tables, admin user)
    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root

    # create second user
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root

fi

exec "$@"
