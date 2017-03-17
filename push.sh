#!/usr/bin/env bash
ls -d */ | while read FOLDER
do

    cd $FOLDER
    PHP_VERSION=`cat Dockerfile | grep '^FROM' | cut -f '2' -d ':' | cut -f '1' -d '-'`
	echo "Pushing exozet/php-fpm:${PHP_VERSION}"
	docker push exozet/php-fpm:${PHP_VERSION}

    if [ "$FOLDER" == "7.1/" ]
    then
    	echo "Pushing exozet/php-fpm"
	    docker push exozet/php-fpm
    fi

	echo "Pushing exozet/php-fpm:${PHP_VERSION}-sudo"
	docker push exozet/php-fpm:${PHP_VERSION}-sudo

	if [ "$FOLDER" == "7.1/" ]
    then
    	echo "Pushing exozet/php-fpm:sudo"
		docker push exozet/php-fpm:sudo
    fi
    cd ..
done