FROM php:7.1-alpine3.7

# update (-U), upgrade and install timezone data, bash, git, and openssh
RUN apk upgrade -U && apk add --no-cache tzdata bash git openssh

# install composer from latest image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 7.1 + Composer"
