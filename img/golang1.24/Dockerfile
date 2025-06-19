FROM golang:1.24

LABEL image.maintainer="Werner Dweight Solutions <info@wds.blue>"
LABEL image.description="Go 1.24 base image."
LABEL image.version="1.0"

ENV TZ="Europe/Prague"

COPY fetch-dependencies.sh /usr/
RUN chmod u+x /usr/fetch-dependencies.sh
