FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysqli \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-zip \
        curl \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# copy php-fpm pool config
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# copy entrypoint script
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

# create the directory where wordpress files will live
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["wp-setup.sh"]
CMD ["/usr/sbin/php-fpm8.2", "-F"]
