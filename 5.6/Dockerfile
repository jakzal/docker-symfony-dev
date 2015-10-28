FROM php:5.6

MAINTAINER Jakub Zalas <jakub@zalas.pl>

ENV PHP_EXTRA_BUILD_DEPS "libmemcached-dev"
ENV PHP_EXTRA_INSTALL_CMD "pecl install memcache && docker-php-ext-enable memcache && pecl install memcached && docker-php-ext-enable memcached"

RUN buildDeps="zlib1g-dev $PHP_EXTRA_BUILD_DEPS" \
    && apt-get update && apt-get install --no-install-recommends -y git $buildDeps && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install zip \
    && $PHP_EXTRA_INSTALL_CMD \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

COPY php.ini $PHP_INI_DIR/

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

VOLUME ["/root/.composer/cache"]
