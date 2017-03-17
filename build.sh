#!/usr/bin/env bash

LATEST_VERSION="7.1"

ls -d */ | while read FOLDER
do

    cd $FOLDER
    PHP_VERSION=`cat Dockerfile | grep '^FROM' | cut -f '2' -d ':' | cut -f '1' -d '-'`
    echo "Building exozet/php-fpm:${PHP_VERSION}"
    docker build -t exozet/php-fpm:${PHP_VERSION} . >> ../build.log

    if [ "$FOLDER" == "${LATEST_VERSION}/" ]
    then
	    echo "Building exozet/php-fpm"
	    docker build -t exozet/php-fpm . >> ../build.log
    fi

    cat Dockerfile > sudo-Dockerfile
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
    cd ..
done