FROM golang:1.23

LABEL image.maintainer="Werner Dweight Solutions <info@wds.blue>"
LABEL image.description="Go 1.23 base image."
LABEL image.version="1.0"

ENV TZ="Europe/Prague"

COPY fetch-dependencies.sh /usr/
RUN chmod u+x /usr/fetch-dependencies.sh
