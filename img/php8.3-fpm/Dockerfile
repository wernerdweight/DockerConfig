FROM php:8.3-fpm-alpine AS base

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 8.3 FPM + Composer + PostgreSQL + gRPC + Redis"

# update (-U), upgrade and install basic required packages
RUN apk upgrade -U && \
    apk add --no-cache \
        $PHPIZE_DEPS python3 grpc libuuid icu-dev linux-headers php83-pecl-igbinary php83-redis postgresql-dev autoconf \
        bash git openssh grep php83-dev libzip-dev su-exec make g++ freetype-dev libjpeg-turbo-dev libpng-dev tzdata \
        gcc zlib-dev && \
    pecl install protobuf-beta grpc igbinary redis && \
    docker-php-ext-enable grpc protobuf igbinary redis && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install -j$(nproc) pdo pdo_pgsql pgsql zip pcntl exif gd intl
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing php83-pecl-grpc;
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community php83-pecl-protobuf;
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime && \
    echo "Europe/Prague" > /etc/timezone && \
    echo "date.timezone = Europe/Prague" >> /usr/local/etc/php/conf.d/timezone.ini && \
    echo "date.timezone = Europe/Prague" >> /etc/php83/conf.d/timezone.ini && \
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

COPY fetch-dependencies.sh /usr/
RUN chmod u+x /usr/fetch-dependencies.sh

COPY ./php-fpm-default.ini /usr/local/etc/php/conf.d/default.ini

WORKDIR /var/www/public
