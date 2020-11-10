FROM node:15-alpine

LABEL image.maintainer="Werner Dweight Solutions <info@wds.blue>"
LABEL image.description="Node.js 15 base image."
LABEL image.version="1.0"

RUN set -e; \
  \
  # required packages
  apk update; \
  apk upgrade; \
  apk add --no-cache bash git openssh grep su-exec curl; \
  \
  # timezone fix (see https://github.com/gliderlabs/docker-alpine/issues/136)
  apk add --update --no-cache tzdata; \
  cp /usr/share/zoneinfo/Europe/Prague /etc/localtime; \
  echo "Europe/Prague" > /etc/timezone; \
  apk del tzdata; \
  \
  # clean unnecessary tmp cache
  rm -rf /var/cache/apk/*; \
  \
  # smoke test
  su-exec nobody true;

COPY fetch-dependencies.sh /usr/
RUN chmod u+x /usr/fetch-dependencies.sh
