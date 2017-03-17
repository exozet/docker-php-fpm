FROM php:7.1.2-fpm

RUN apt-get update

RUN apt-get install -y libz-dev libmemcached-dev
RUN pecl install memcached-3.0.3
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# gd extension
RUN apt-get install -y libpng-dev
RUN docker-php-ext-install gd

RUN docker-php-ext-install zip

RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install opcache

ENV COMPOSER_HOME=/composer
RUN apt-get install -y wget
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet && mv composer.phar /usr/local/bin/composer

RUN apt-get install -y git vim

WORKDIR /usr/src/app