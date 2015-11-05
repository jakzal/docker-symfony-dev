FROM debian:squeeze

MAINTAINER Jakub Zalas <jakub@zalas.pl>

ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_VERSION 5.3.3

# persistent / runtime deps
RUN echo "deb http://http.debian.net/debian-backports squeeze-backports main" > /etc/apt/sources.list.d/backports.list \
  && apt-get update \
  && apt-get install -y git ca-certificates curl librecode0 libsqlite3-0 libxml2 libmemcached5 libmemcachedutil0 libicu44 --no-install-recommends && rm -r /var/lib/apt/lists/*

# phpize deps
RUN apt-get update && apt-get install -y autoconf file g++ gcc libc-dev make pkg-config re2c --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN mkdir -p $PHP_INI_DIR/conf.d

RUN buildDeps=" \
    patch \
    bzip2 \
    libcurl4-openssl-dev \
    libreadline6-dev \
    librecode-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libicu-dev \
    libmemcached-dev \
    zlib1g-dev \
  " \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  # PHP
  && curl -SL "http://museum.php.net/php5/php-$PHP_VERSION.tar.bz2" -o php.tar.bz2 \
  && mkdir -p /usr/src/php \
  && tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1 \
  && rm php.tar.bz2* \
  && cd /usr/src/php \
  && ./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    $PHP_EXTRA_CONFIGURE_ARGS \
    --disable-cgi \
    --enable-zip \
    --enable-intl \
    --with-curl \
    --with-openssl \
    --with-readline \
    --with-recode \
    --with-zlib \
  && make -j"$(nproc)" && make install && make clean \
  # xdebug
  && curl -SL http://xdebug.org/files/xdebug-2.2.7.tgz -o xdebug.tgz \
  && mkdir -p /usr/src/php-xdebug \
  && tar -xof xdebug.tgz -C /usr/src/php-xdebug && rm xdebug.tgz \
  && cd /usr/src/php-xdebug/xdebug-* \
  && phpize && ./configure --enable-xdebug && make -j"$(nproc)" && make install && make clean \
  && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so" > $PHP_INI_DIR"/conf.d/xdebug.ini" \
  # memcache
  && pecl install memcache && echo "extension=memcache.so" > $PHP_INI_DIR"/conf.d/memcache.ini" \
  # memcached
  && curl -SL "https://pecl.php.net/get/memcached-2.2.0.tgz" -o memcached.tgz \
  && mkdir -p /usr/src/php-memcached \
  && tar -xof memcached.tgz -C /usr/src/php-memcached && rm memcached.tgz \
  && cd /usr/src/php-memcached/memcached-* \
  && phpize && ./configure --disable-memcached-sasl && make -j"$(nproc)" && make install \
  && echo "extension=memcached.so" > $PHP_INI_DIR"/conf.d/memcached.ini" \
  # cleanup
  && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

COPY php.ini $PHP_INI_DIR/

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

VOLUME ["/root/.composer/cache"]

CMD ["php", "-a"]
