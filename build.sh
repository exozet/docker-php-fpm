#!/usr/bin/env bash

LATEST_VERSION="7.1.3"

ls -d */ | while read FOLDER
do

    cd $FOLDER
    FOLDER=`echo $FOLDER | cut -f 1 -d '/'`
#    PHP_VERSION=`cat Dockerfile | grep '^FROM' | cut -f '2' -d ':' | cut -f '1' -d '-'`

	echo "Pull latest php:${FOLDER}-fpm"
	docker pull "php:${FOLDER}-fpm" >> ../build.log

	for PHP_VERSION in `cat versions`
	do
		echo "Building exozet/php-fpm:${PHP_VERSION}"

		echo "FROM php:${PHP_VERSION}-fpm" >> version-Dockerfile
		cat Dockerfile | grep -v '^FROM' >> version-Dockerfile

		docker build -t exozet/php-fpm:${PHP_VERSION} -f version-Dockerfile . >> ../build.log

		if [ "$FOLDER" == "${LATEST_VERSION}/" ]
		then
			echo "Building exozet/php-fpm"
			docker build -t exozet/php-fpm -f version-Dockerfile . >> ../build.log
		fi

		rm -f version-Dockerfile

		echo "FROM php:${PHP_VERSION}-fpm" >> sudo-Dockerfile
		cat Dockerfile | grep -v '^FROM' >> sudo-Dockerfile
		echo '' >> sudo-Dockerfile
		echo 'RUN apt-get install sudo' >> sudo-Dockerfile
		echo 'RUN chsh www-data -s /bin/bash' >> sudo-Dockerfile
		echo 'RUN echo "www-data ALL = NOPASSWD: ALL" > /etc/sudoers.d/www-data' >> sudo-Dockerfile

		echo "Building exozet/php-fpm:${PHP_VERSION}-sudo"
		docker build -t exozet/php-fpm:${PHP_VERSION}-sudo -f sudo-Dockerfile . >> ../build.log

		if [ "$FOLDER" == "${LATEST_VERSION}/" ]
		then
			echo "Building exozet/php-fpm:sudo"
			docker build -t exozet/php-fpm:sudo -f sudo-Dockerfile . >> ../build.log
		fi

		rm -f sudo-Dockerfile

	done
    cd ..
done