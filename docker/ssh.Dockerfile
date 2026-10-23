ARG BASE_VERSION=8.5
FROM magosla/php-swoole:${BASE_VERSION}

RUN mkdir -p /var/run/sshd               && \
    apk add -u --no-cache openssh-client