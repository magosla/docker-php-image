ARG PHP_VERSION=8.2
ARG BASE_VERSION
FROM magosla/np-php${PHP_VERSION}:${BASE_VERSION}
#USER root

RUN apk add -u --no-cache openssh-client

#USER www-data

#RUN echo -e