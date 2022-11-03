FROM php:8.1-alpine3.16 AS base

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 8.1 + Composer + PostgreSQL"

# update (-U), upgrade and install basic required packages
RUN apk upgrade -U && \
    apk add --no-cache \
        bash git openssh grep php8-dev libzip-dev su-exec make g++ freetype-dev libjpeg-turbo-dev libpng-dev tzdata \
        postgresql-dev && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install -j$(nproc) pdo pdo_pgsql pgsql zip pcntl exif gd && \
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime && \
    echo "Europe/Prague" > /etc/timezone && \
    echo "date.timezone = Europe/Prague" >> /usr/local/etc/php/conf.d/timezone.ini && \
    echo "date.timezone = Europe/Prague" >> /etc/php8/conf.d/timezone.ini && \
    # clean unnecessary tmp cache
    rm -rf /var/cache/apk/* && \
    # smoke test
    su-exec nobody true

# alpine Linux iconv hack
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# install composer from latest image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN su-exec www-data composer clear-cache

WORKDIR /var/www/html
