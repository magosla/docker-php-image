ARG BASE_VERSION
FROM magosla/php-swoole:${BASE_VERSION}

RUN apk add -u --no-cache openssh-client