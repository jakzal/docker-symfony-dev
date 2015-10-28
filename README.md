# Docker images for Symfony framework development

[![Build Status](https://travis-ci.org/jakzal/docker-symfony-dev.svg?branch=master)](https://travis-ci.org/jakzal/docker-symfony-dev)

These PHP docker images are configured for Symfony framework development.
The aim is to be able to easily run Symfony tests on various versions
and configurations of PHP.

    docker run -it -v ~/Projects/symfony:/symfony -w=/symfony jakzal/symfony-dev:7.0 ./phpunit
