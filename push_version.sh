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
echo "Pushing exozet/php-fpm:${PHP_VERSION}-alpine"
docker push exozet/php-fpm:${PHP_VERSION}-alpine
echo "Pushing exozet/php-fpm:${PHP_VERSION}-sudo"
docker push exozet/php-fpm:${PHP_VERSION}-sudo
echo "Pushing exozet/php-fpm:${PHP_VERSION}-sudo-alpine"
docker push exozet/php-fpm:${PHP_VERSION}-sudo-alpine
echo "Pushing exozet/php-fpm:${PHP_VERSION}-root"
docker push exozet/php-fpm:${PHP_VERSION}-root
echo "Pushing exozet/php-fpm:${PHP_VERSION}-root-alpine"
docker push exozet/php-fpm:${PHP_VERSION}-root-alpine
echo "Pushing exozet/php-fpm:${PHP_VERSION}-xdebug-alpine"
docker push exozet/php-fpm:${PHP_VERSION}-xdebug-alpine

if [ "$PHP_VERSION_ALIAS" ]
then
  echo "Version alias found!"

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS} based on exozet/php-fpm:${PHP_VERSION}"
  docker tag exozet/php-fpm:${PHP_VERSION} exozet/php-fpm:${PHP_VERSION_ALIAS}
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-alpine based on exozet/php-fpm:${PHP_VERSION}-alpine"
  docker tag exozet/php-fpm:${PHP_VERSION}-alpine exozet/php-fpm:${PHP_VERSION_ALIAS}-alpine
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-alpine"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-alpine

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo based on exozet/php-fpm:${PHP_VERSION}-sudo"
  docker tag exozet/php-fpm:${PHP_VERSION}-sudo exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo-alpine based on exozet/php-fpm:${PHP_VERSION}-sudo-alpine"
  docker tag exozet/php-fpm:${PHP_VERSION}-sudo-alpine exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo-alpine
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo-alpine"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-sudo-alpine

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-root based on exozet/php-fpm:${PHP_VERSION}-root"
  docker tag exozet/php-fpm:${PHP_VERSION}-root exozet/php-fpm:${PHP_VERSION_ALIAS}-root
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-root"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-root

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-root-alpine based on exozet/php-fpm:${PHP_VERSION}-root-alpine"
  docker tag exozet/php-fpm:${PHP_VERSION}-root-alpine exozet/php-fpm:${PHP_VERSION_ALIAS}-root-alpine
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-root-alpine"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-root-alpine

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-xdebug-alpine based on exozet/php-fpm:${PHP_VERSION}-xdebug-alpine"
  docker tag exozet/php-fpm:${PHP_VERSION}-xdebug-alpine exozet/php-fpm:${PHP_VERSION_ALIAS}-xdebug-alpine
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-xdebug-alpine"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-xdebug-alpine
fi
