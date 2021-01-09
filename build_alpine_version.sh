#!/usr/bin/env bash

set -e

PHP_VERSION=$1

if [ -z "$PHP_VERSION" ]
then
  echo "Error: Missing version name!" >&2
  echo "Correct Usage $0 PHP_VERSION (e.g. $0 7.0.16)" >&2
  exit 1;
fi

FOLDER=`echo $PHP_VERSION | cut -f 1,2 -d '.'`

if [ ! -d $FOLDER ]
then
  echo "Error: Cannot root folder $FOLDER for php version $PHP_VERSION" >&2
  exit 1;
fi

cd $FOLDER

cp ../php.ini php.ini
cp ../start-cron start-cron
cp ../start-cron-alpine start-cron-alpine
cp ../composer.sh composer

echo "Pull latest php:${PHP_VERSION}-fpm-alpine"
docker pull "php:${PHP_VERSION}-fpm-alpine" >> ../build.log

echo "Building exozet/php-fpm:${PHP_VERSION}-alpine"

echo "FROM php:${PHP_VERSION}-fpm-alpine AS base" > version-Dockerfile
cat Dockerfile-alpine | grep -v '^FROM php:' >> version-Dockerfile

docker build -t exozet/php-fpm:${PHP_VERSION}-alpine -f version-Dockerfile . >> ../build.log

rm -f version-Dockerfile

echo "FROM php:${PHP_VERSION}-fpm-alpine AS base" > sudo-Dockerfile
cat Dockerfile-alpine | grep -v '^FROM php:' >> sudo-Dockerfile
echo '' >> sudo-Dockerfile
echo 'RUN apk add --no-cache sudo' >> sudo-Dockerfile
echo "RUN sed -i 's/\/home\/www-data:\/sbin\/nologin/\/home\/www-data:\/bin\/bash/' /etc/passwd" >> sudo-Dockerfile
echo 'RUN echo "www-data ALL = NOPASSWD: ALL" > /etc/sudoers.d/www-data' >> sudo-Dockerfile

echo "Building exozet/php-fpm:${PHP_VERSION}-sudo-alpine"
docker build -t exozet/php-fpm:${PHP_VERSION}-sudo-alpine -f sudo-Dockerfile . >> ../build.log

cp sudo-Dockerfile xdebug-Dockerfile
echo '' >> xdebug-Dockerfile

echo 'COPY --from=build-xdebug /tmp/xdebug.so /tmp/xdebug.so' >> xdebug-Dockerfile
echo "RUN mv /tmp/xdebug.so \`php -i | grep ^extension_dir | cut -f 3 -d ' '\`/ && docker-php-ext-enable xdebug" >> xdebug-Dockerfile

echo "Building exozet/php-fpm:${PHP_VERSION}-xdebug-alpine"
docker build -t exozet/php-fpm:${PHP_VERSION}-xdebug-alpine -f xdebug-Dockerfile . >> ../build.log

rm -f sudo-Dockerfile
rm -f xdebug-Dockerfile

echo "FROM php:${PHP_VERSION}-fpm-alpine AS base" > root-Dockerfile
cat Dockerfile-alpine | grep -v '^FROM php:' >> root-Dockerfile
echo '' >> root-Dockerfile
echo 'USER root' >> root-Dockerfile

echo "Building exozet/php-fpm:${PHP_VERSION}-root-alpine"
docker build -t exozet/php-fpm:${PHP_VERSION}-root-alpine -f root-Dockerfile . >> ../build.log

rm -f root-Dockerfile
rm -f php.ini
