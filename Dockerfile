FROM alpine:3.7

WORKDIR /usr/src/wordpress

RUN apk add --no-cache nginx supervisor bash curl git ca-certificates \
    php7 php7-fpm php7-xdebug php7-mysqli php7-json php7-simplexml php7-xmlreader \
    php7-xmlwriter php7-mbstring php7-ctype php7-curl php7-gd php7-phar \
    php7-tokenizer \
    && mkdir -p /run/nginx

# PHP
COPY conf/php-fpm/php-fpm.conf /etc/php7/php-fpm.conf
COPY conf/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf

RUN sed -i -e 's/post_max_size = 8M/post_max_size = 100M/g' /etc/php7/php.ini \
    && sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php7/php.ini \
    && sed -i -e 's/;date.timezone =/date.timezone = UTC/g' /etc/php7/php.ini \
    && sed -i -e 's/max_execution_time = 30/max_execution_time = 90/g' /etc/php7/php.ini

# Install Composer
COPY scripts/install-composer.sh /tmp/install-composer.sh
RUN sh /tmp/install-composer.sh \
    && rm /tmp/install-composer.sh

# Configure Nginx
COPY conf/nginx/wordpress.conf /etc/nginx/conf.d/default.conf

# Configure Supervisor
COPY conf/supervisor/nginx.ini /etc/supervisor.d/nginx.ini
COPY conf/supervisor/php-fpm.ini /etc/supervisor.d/php-fpm.ini

# Setup Wordpress
RUN composer create-project roots/bedrock /usr/src/wordpress \
    && composer install --prefer-dist --optimize-autoloader --no-progress \
    --classmap-authoritative --no-interaction --no-ansi --no-scripts

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
