#!/bin/bash

if [ -z "$TAG" ]
then
  TAG=latest
fi

docker build -t exozet/php-fpm:$TAG .
docker push exozet/php-fpm:$TAG
