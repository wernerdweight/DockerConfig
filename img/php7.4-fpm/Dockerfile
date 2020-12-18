FROM php:7.4-fpm-alpine AS base

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 7.4 FPM + Composer + PostgreSQL + gRPC + Redis"

# update (-U), upgrade and install basic required packages
RUN apk upgrade -U && \
    apk add --no-cache \
        $PHPIZE_DEPS python3 grpc libuuid icu-dev linux-headers php7-igbinary php7-redis postgresql-dev autoconf \
        bash git openssh grep php7-dev libzip-dev su-exec make g++ freetype-dev libjpeg-turbo-dev libpng-dev tzdata \
        gcc zlib-dev && \
    pecl install protobuf grpc igbinary redis && \
    docker-php-ext-enable grpc protobuf igbinary redis && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install -j$(nproc) pdo pdo_pgsql pgsql zip pcntl exif gd intl
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing php7-pecl-grpc;
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community php7-pecl-protobuf;
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime && \
    echo "Europe/Prague" > /etc/timezone && \
    echo "date.timezone = Europe/Prague" >> /usr/local/etc/php/conf.d/timezone.ini && \
    echo "date.timezone = Europe/Prague" >> /etc/php7/conf.d/timezone.ini && \
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
