ARG PHP_VERSION=8.5

ARG SWOOLE_VERSION=6.3

FROM phpswoole/swoole:${SWOOLE_VERSION}-php${PHP_VERSION}-alpine

ARG TZ=UTC
ARG LANG=en_US
ARG CHARSET=UTF-8

WORKDIR /var/www

ENV TZ=${TZ} \
    COMPOSER_ALLOW_SUPERUSER=1

# Runtime libraries
RUN apk add --no-cache \
    tzdata \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# Install build dependencies, the extensions, and clean up in a single layer
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS linux-headers postgresql-dev \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
    grpc \
    protobuf \
    imagick \
    gd \
    bcmath \
    zip \
    pcntl \
    geospatial \
    intl \
    &&  docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql            \
    && docker-php-ext-install pdo_pgsql pgsql \
    && apk del .build-deps \
    && rm /usr/local/bin/install-php-extensions                        \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/* /var/www/html/* /usr/share/php8 /usr/share/php


# Production PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && { \
        echo "date.timezone=${TZ}"; \
        echo "opcache.enable=1"; \
        echo "opcache.enable_cli=1"; \
        echo "opcache.validate_timestamps=0"; \
        echo "expose_php=Off"; \
    } > "$PHP_INI_DIR/conf.d/production.ini"

# Install remaining Laravel dependencies
# COPY . .

# RUN composer install \
#     --no-dev \
#     --prefer-dist \
#     --optimize-autoloader \
#     --no-interaction \
#     --no-progress

# Confirm required extensions and HTTP/2 build support
RUN php -m \
    && php --ri swoole \
    && php --ri redis \
    && php --ri grpc \
    && php --ri protobuf \
    && php --ri imagick \
    && php --ri pdo_pgsql \
    && php --ri pgsql \
    && php -r 'echo "Timezone: ", date_default_timezone_get(), PHP_EOL;'

# EXPOSE 8000

# CMD ["php", "artisan", "octane:start", \
#      "--server=swoole", \
#      "--host=0.0.0.0", \
#      "--port=8000"]
