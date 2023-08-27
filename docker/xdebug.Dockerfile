ARG PHP_VERSION=
ARG BASE_VERSION
FROM magosla/np-php${PHP_VERSION}:${BASE_VERSION}
#USER root

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev \
    linux-headers && \
    pecl channel-update pecl.php.net && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-source delete                          && \
    apk del -f .build-deps   && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/* /var/www/html/* /usr/share/php8 /usr/share/php

#USER www-data

#RUN echo -e