#!/usr/bin/env bash

LATEST_VERSION="7.1.3"

echo "Pushing exozet/php-fpm"
docker push exozet/php-fpm
echo "Pushing exozet/php-fpm:sudo"
docker push exozet/php-fpm:sudo

ls -d */ | while read FOLDER
do
    cd $FOLDER
	for PHP_VERSION in `cat versions`
	do
		echo "Pushing exozet/php-fpm:${PHP_VERSION}"
		docker push exozet/php-fpm:${PHP_VERSION}
		echo "Pushing exozet/php-fpm:${PHP_VERSION}-sudo"
		docker push exozet/php-fpm:${PHP_VERSION}-sudo
	done
    cd ..
done