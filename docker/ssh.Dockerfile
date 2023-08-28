ARG BASE_VERSION
FROM magosla/php-swoole:${BASE_VERSION}
#USER root

RUN apk add -u --no-cache openssh-client

#USER www-data

#RUN echo -e