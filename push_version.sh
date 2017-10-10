#!/usr/bin/env bash

set -e

PHP_VERSION=$1

if [ -z "$PHP_VERSION" ]
then
  echo "Error: Missing version name!" >&2
  echo "Correct Usage $0 PHP_VERSION (e.g. $0 7.0.16)" >&2
  exit 1;
fi

echo "Pushing exozet/php-fpm:${PHP_VERSION}"
docker push exozet/php-fpm:${PHP_VERSION}
echo "Pushing exozet/php-fpm:${PHP_VERSION}-sudo"
docker push exozet/php-fpm:${PHP_VERSION}-sudo
echo "Pushing exozet/php-fpm:${PHP_VERSION}-root"
docker push exozet/php-fpm:${PHP_VERSION}-root
