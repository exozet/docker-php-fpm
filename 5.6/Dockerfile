FROM php:5.6-fpm

RUN apt-get update

RUN apt-get install -y libz-dev libmemcached-dev
RUN pecl install memcached-2.2.0
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# gd extension
RUN apt-get install -y \
  libpng-dev \
  libfreetype6-dev \
  libjpeg-dev \
  libxpm-dev \
  libxml2-dev \
  libvpx-dev  # php <7.0 (use libwebp for php >=7.0)
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-xpm-dir=/usr/include \
    --with-vpx-dir=/usr/include/ # php <7.0 (use webp for php >=7.0)
RUN docker-php-ext-install gd

RUN docker-php-ext-install zip

RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install opcache

RUN pecl install xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install soap

ENV COMPOSER_HOME=/composer
RUN curl -sS https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer | php -- --quiet && mv composer.phar /usr/local/bin/composer

RUN apt-get install -y git vim

ADD php.ini /usr/local/etc/php/php.ini

ENV PHP_MEMORY_LIMIT=128M \
    PHP_POST_MAX_SIZE=8M \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_UPLOAD_MAX_FILESIZE=2M \
    PHP_SESSION_SAVE_HANDLER=files \
    PHP_SESSION_SAVE_PATH="" \
    PHP_MAX_INPUT_VARS=1000

WORKDIR /usr/src/app