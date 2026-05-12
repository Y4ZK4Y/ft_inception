FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        nginx \
        openssl \
    && rm -rf /var/lib/apt/lists/*

# create directory for SSL certificate
RUN mkdir -p /etc/nginx/ssl

# generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=login.42.fr"

# copy nginx config
COPY conf/nginx.conf /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
