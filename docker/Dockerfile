ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine

ARG LANG=en_US
ARG CHARSET=UTF-8

ENV TZ=UTC

WORKDIR /var/www/html

ENV EXT_VIPS_VERSION=1.5.2

ENV COMPOSER_MEMORY_LIMIT=-1

RUN set -ex                                                                                         && \
    mkdir -p /var/run/sshd                                                                          && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime                                                  && \
    echo $TZ > /etc/timezone                                                                        && \       
    # Install Composer/
    curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    chmod +x /usr/bin/composer                                                                      && \
    composer self-update --clean-backups 2.5.2                                                      && \  
    apk update                                                                                      && \
    apk add --no-cache libstdc++ libpq libgomp \
    icu \ 
    imagemagick \
    libpng \
    libwebp \
    libjpeg \
    libzip \
    libxml2 \
    #postgresql-client \
    vips                                                                                       && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev \
    linux-headers postgresql-dev openssl-dev pcre-dev pcre2-dev zlib-dev \
    icu-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    postgresql-dev \
    vips-dev                                                                                        && \
    apk add -u --no-cache shadow                                                                    && \
    docker-php-ext-install pdo_mysql                                                                && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql                                     && \
    docker-php-ext-install pdo_pgsql pgsql                                                          && \
    pecl channel-update pecl.php.net                                                                && \
    pecl install --configureoptions 'enable-redis-igbinary="no" enable-redis-lzf="no" enable-redis-zstd="no"' redis-5.3.7 && \
    pecl install imagick                                                                          && \
    docker-php-ext-enable imagick                                                                 && \
    docker-php-ext-enable redis                                                                   && \
    docker-php-ext-configure gd --enable-gd --with-jpeg                                           && \
    docker-php-ext-install gd                                                                     && \
    docker-php-ext-enable gd                                                                      && \
    docker-php-ext-install bcmath                                                                 && \
    docker-php-ext-install xml                                                                    && \
    docker-php-ext-install zip                                                                    && \
    docker-php-ext-install sockets intl                                                           && \  
    docker-php-ext-enable intl                                                                    && \
    docker-php-ext-configure pcntl --enable-pcntl                                                 && \
    docker-php-ext-install pcntl                                                                  && \ 
    docker-php-source extract                                                                     && \
    mkdir /usr/src/php/ext/swoole                                                                 && \
    curl -sfL https://github.com/swoole/swoole-src/archive/v5.0.3.tar.gz -o swoole.tar.gz         && \
    tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole                         && \
    docker-php-ext-configure swoole \
    --enable-mysqlnd      \
    --enable-swoole-pgsql \
    --enable-openssl      \
    --enable-sockets --enable-swoole-curl                                                         && \
    docker-php-ext-install -j$(nproc) swoole                                                      && \
    rm -f swoole.tar.gz $HOME/.composer/*-old.phar                                                && \
    docker-php-source delete                                                                      && \
    apk del .build-deps                                                                           && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; }     && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/* /var/www/html/* /usr/share/php8 /usr/share/php

RUN sed -i -e "s/upload_max_filesize = .*/upload_max_filesize = 1G/g" \
    -e "s/post_max_size = .*/post_max_size = 1G/g" \
    -e "s/memory_limit = .*/memory_limit = 512M/g" \
    /usr/local/etc/php/php.ini-production \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

RUN echo -e '\
    opcache.interned_strings_buffer=16\n\
    opcache.load_comments=Off\n\
    opcache.max_accelerated_files=16000\n\
    opcache.save_comments=Off\n\
    ' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini