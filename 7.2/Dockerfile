FROM php:7.2-fpm

RUN apt-get update

RUN apt-get install -y libz-dev libmemcached-dev
RUN pecl install memcached-3.0.3
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# gd extension
RUN apt-get install -y \
  libpng-dev \
  libfreetype6-dev \
  libjpeg-dev \
  libxpm-dev \
  libxml2-dev \
  libxslt-dev \
  libwebp-dev  # php >=7.0 (use libvpx for php <7.0)
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-xpm-dir=/usr/include \
    --with-webp-dir=/usr/include/ # php >=7.0 (use libvpx for php <7.0)
RUN docker-php-ext-install gd

RUN docker-php-ext-install zip
RUN docker-php-ext-install xsl

RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install ldap

RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

RUN pecl install xdebug-2.6.0
RUN echo "zend_extension=`php -i | grep ^extension_dir | cut -f 3 -d ' '`/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install soap

ENV COMPOSER_HOME=/composer
COPY --from=composer:1.6.3 /usr/bin/composer /usr/local/bin/composer

RUN apt-get install -y git vim mysql-client rsync sshpass bzip2

ADD php.ini /usr/local/etc/php/php.ini

# Cron
RUN apt-get install -y cron \
    && mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron

COPY start-cron /usr/sbin
RUN chmod +x /usr/sbin/start-cron
# Cron

ENV PHP_MEMORY_LIMIT=128M \
    PHP_POST_MAX_SIZE=8M \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_UPLOAD_MAX_FILESIZE=2M \
    PHP_SESSION_SAVE_HANDLER=files \
    PHP_SESSION_SAVE_PATH="" \
    PHP_MAX_INPUT_VARS=1000 \
    PHP_MAX_EXECUTION_TIME=0 \
    PHP_DATE_TIMEZONE="" \
    PHP_LOG_ERRORS="" \
    PHP_LOG_ERRORS_MAX_LEN=1024 \
    PHP_XDEBUG_IDEKEY=''\
    PHP_XDEBUG_DEFAULT_ENABLE=0 \
    PHP_XDEBUG_REMOTE_ENABLE=0 \
    PHP_XDEBUG_REMOTE_AUTOSTART=0 \
    PHP_XDEBUG_REMOTE_CONNECT_BACK=0 \
    PHP_XDEBUG_PROFILER_ENABLE=0 \
    PHP_XDEBUG_REMOTE_HOST=0

WORKDIR /usr/src/app

# imagick
RUN apt-get install -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick
