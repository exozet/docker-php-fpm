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

cp -f ../php.ini php.ini
cp -f ../start-cron start-cron
cp -f ../composer.sh composer

echo "Pull latest php:${PHP_VERSION}-fpm"
docker pull "php:${PHP_VERSION}-fpm" >> ../build.log

echo "Building exozet/php-fpm:${PHP_VERSION}"

echo "FROM php:${PHP_VERSION}-fpm" > version-Dockerfile
cat Dockerfile | grep -v '^FROM' >> version-Dockerfile

docker build -t exozet/php-fpm:${PHP_VERSION} -f version-Dockerfile . >> ../build.log

rm -f version-Dockerfile

echo "FROM php:${PHP_VERSION}-fpm" >> sudo-Dockerfile
cat Dockerfile | grep -v '^FROM' >> sudo-Dockerfile
echo '' >> sudo-Dockerfile
echo 'RUN apt-get update && apt-get install --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*' >> sudo-Dockerfile
echo 'RUN chsh www-data -s /bin/bash' >> sudo-Dockerfile
echo 'RUN echo "www-data ALL = NOPASSWD: ALL" > /etc/sudoers.d/www-data' >> sudo-Dockerfile

echo "Building exozet/php-fpm:${PHP_VERSION}-sudo"
docker build -t exozet/php-fpm:${PHP_VERSION}-sudo -f sudo-Dockerfile . >> ../build.log

rm -f sudo-Dockerfile

echo "FROM php:${PHP_VERSION}-fpm" >> root-Dockerfile
cat Dockerfile | grep -v '^FROM' >> root-Dockerfile
echo '' >> root-Dockerfile
echo 'USER root' >> root-Dockerfile

echo "Building exozet/php-fpm:${PHP_VERSION}-root"
docker build -t exozet/php-fpm:${PHP_VERSION}-root -f root-Dockerfile . >> ../build.log

rm -f root-Dockerfile
rm -f php.ini
