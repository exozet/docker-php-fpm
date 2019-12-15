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

TAG_SUFFIXES="alpine sudo sudo-alpine root root-alpine xdebug-alpine"

echo "Pushing exozet/php-fpm:${PHP_VERSION}"
docker push exozet/php-fpm:${PHP_VERSION}
docker tag exozet/php-fpm:${PHP_VERSION} quay.io/exozet/php-fpm:${PHP_VERSION}
docker push quay.io/exozet/php-fpm:${PHP_VERSION}

for TAG_SUFFIX in $TAG_SUFFIXES
do
  echo "Pushing exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX}"
  docker push exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX}
  docker tag exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX} quay.io/exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX}
  docker push quay.io/exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX}
done

if [ "$PHP_VERSION_ALIAS" ]
then
  echo "Version alias found!"

  echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS} based on exozet/php-fpm:${PHP_VERSION}"
  docker tag exozet/php-fpm:${PHP_VERSION} exozet/php-fpm:${PHP_VERSION_ALIAS}
  echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}"
  docker push exozet/php-fpm:${PHP_VERSION_ALIAS}

  for TAG_SUFFIX in $TAG_SUFFIXES
  do
    echo "Tagging exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX} based on exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX}"
    docker tag exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX} exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX}
    docker tag exozet/php-fpm:${PHP_VERSION}-${TAG_SUFFIX} quay.io/exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX}
    echo "Pushing exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX}"
    docker push exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX}
    docker push quay.io/exozet/php-fpm:${PHP_VERSION_ALIAS}-${TAG_SUFFIX}
  done
fi
