#!/bin/bash

versions=( */ )
versions=( "${versions[@]%/}" )

declare PHP_EXTRA_BUILD_DEPS=()
PHP_EXTRA_BUILD_DEPS["54"]="libmemcached-dev"
PHP_EXTRA_BUILD_DEPS["55"]=${PHP_EXTRA_BUILD_DEPS["54"]}
PHP_EXTRA_BUILD_DEPS["56"]=${PHP_EXTRA_BUILD_DEPS["54"]}
PHP_EXTRA_BUILD_DEPS["70"]=""

declare PHP_EXTRA_INSTALL_CMD=()
PHP_EXTRA_INSTALL_CMD["54"]="
    pecl install memcache && docker-php-ext-enable memcache
 && pecl install memcached && docker-php-ext-enable memcached
 && pecl install xdebug && docker-php-ext-enable xdebug"
PHP_EXTRA_INSTALL_CMD["55"]=${PHP_EXTRA_INSTALL_CMD["54"]}
PHP_EXTRA_INSTALL_CMD["56"]=${PHP_EXTRA_INSTALL_CMD["54"]}
PHP_EXTRA_INSTALL_CMD["70"]=""

for version in "${versions[@]}"; do
    if [ "$version" == "5.3" ]; then echo "Skipping 5.3"; continue; fi

    echo "Updating $version"
    var=$(echo $version|sed -e 's/\.//g')
    php_extra_install_cmd=$(echo ${PHP_EXTRA_INSTALL_CMD[$var]} | sed -e 's/[\/&]/\\&/g')
    php_extra_build_deps=${PHP_EXTRA_BUILD_DEPS[$var]}
    cat Dockerfile \
        | sed -e 's/FROM php:.*/FROM php:'$version'/' \
              -e "s/ENV PHP_EXTRA_BUILD_DEPS.*/ENV PHP_EXTRA_BUILD_DEPS \"$php_extra_build_deps\"/" \
              -e "s/ENV PHP_EXTRA_INSTALL_CMD.*/ENV PHP_EXTRA_INSTALL_CMD \"$php_extra_install_cmd\"/" > $version/Dockerfile
    cp php.ini $version/
done
