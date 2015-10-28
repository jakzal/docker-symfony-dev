#!/bin/bash

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi

printf "%s\n" "${versions[@]%/}" | xargs -I% docker build -t jakzal/symfony-dev:% %/

docker images jakzal/symfony-dev
