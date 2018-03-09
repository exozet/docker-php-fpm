#!/usr/bin/env bash

set -e

PHP_VERSION=$1
PHP_VERSION_ALIAS=$2

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

if [ "$PHP_VERSION_ALIAS" ]
then
  echo "Version alias found!"

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS} based on exozet/php-fpm:${PHP_VERSION}"
  docker tag exozet/php-fpm:${PHP_VERSION} exozet/php-fpm:${PHP_VERSION_ALIAS}
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo based on exozet/php-fpm:${PHP_VERSION}-sudo"
  docker tag exozet/php-fpm:${PHP_VERSION}-sudo exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-root based on exozet/php-fpm:${PHP_VERSION}-root"
  docker tag exozet/php-fpm:${PHP_VERSION}-root exozet/php-fpm:${PHP_VERSION_ALIAS}-root
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-root"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-root
fi
