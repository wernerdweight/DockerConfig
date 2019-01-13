FROM php:7.3-alpine3.8

# update (-U), upgrade and install timezone data
RUN apk upgrade -U && apk add --no-cache tzdata

# install composer from latest image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 7.3 + Composer"
