FROM php:5.3

MAINTAINER Jakub Zalas <jakub@zalas.pl>

ENV PHP_INI_DIR /usr/local/lib
ENV PHP_EXTRA_BUILD_DEPS ""
ENV PHP_EXTRA_INSTALL_CMD ""

COPY php.ini $PHP_INI_DIR/

RUN buildDeps="zlib1g-dev libmemcached-dev libicu-dev $PHP_EXTRA_BUILD_DEPS" \
    && apt-get update && apt-get install --no-install-recommends -y git libmemcached11 libmemcachedutil2 libicu52 libmysqlclient18 $buildDeps && rm -r /var/lib/apt/lists/* \
    && pecl install intl && echo "extension=intl.so" >> $PHP_INI_DIR"/php.ini" \
    && pecl install zip && echo "extension=zip.so" >> $PHP_INI_DIR"/php.ini" \
    && pecl install memcache && echo "extension=memcache.so" >> $PHP_INI_DIR"/php.ini" \
    && pecl install memcached && echo "extension=memcached.so" >> $PHP_INI_DIR"/php.ini" \
    && curl -SL http://xdebug.org/files/xdebug-2.2.7.tgz -o xdebug.tgz \
    && mkdir -p /usr/src/php-xdebug \
    && tar -xof xdebug.tgz -C /usr/src/php-xdebug && rm xdebug.tgz \
    && cd /usr/src/php-xdebug/xdebug-* \
    && phpize && ./configure --enable-xdebug && make -j"$(nproc)" && make install && make clean \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so" >> $PHP_INI_DIR"/php.ini" \
    && bash -c "$PHP_EXTRA_INSTALL_CMD" \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --disable-tls --install-dir=/usr/local/bin --filename=composer

VOLUME ["/root/.composer/cache"]
