FROM php:latest

MAINTAINER Jakub Zalas <jakub@zalas.pl>

ENV PHP_EXTRA_BUILD_DEPS ""
ENV PHP_EXTRA_INSTALL_CMD ""

RUN buildDeps="zlib1g-dev libicu-dev $PHP_EXTRA_BUILD_DEPS" \
    && apt-get update && apt-get install --no-install-recommends -y git libmemcached11 libmemcachedutil2 libicu52 $buildDeps && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install intl zip \
    && bash -c "$PHP_EXTRA_INSTALL_CMD" \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

COPY php.ini $PHP_INI_DIR/

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

VOLUME ["/root/.composer/cache"]
