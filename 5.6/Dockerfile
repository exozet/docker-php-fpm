FROM php:5.6-fpm

# ssh2
RUN apt-get update && apt-get install -y libssh2-1-dev libssh2-1
RUN pecl install ssh2-0.13
RUN echo extension=ssh2.so >> /usr/local/etc/php/conf.d/ssh2.ini
# ssh2

RUN apt-get update && apt-get install -y libz-dev libmemcached-dev
RUN pecl install memcached-2.2.0
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# gd extension
RUN apt-get update && apt-get install -y \
  libpng-dev \
  libfreetype6-dev \
  libjpeg-dev \
  libxpm-dev \
  libxml2-dev \
  libxslt-dev \
  libmcrypt-dev \
  librabbitmq-dev \
  libssh-dev \
  libvpx-dev  # php <7.0 (use libwebp for php >=7.0)
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-xpm-dir=/usr/include \
    --with-vpx-dir=/usr/include/ # php <7.0 (use webp for php >=7.0)

RUN pecl install amqp-1.9.1
RUN docker-php-ext-enable amqp

RUN docker-php-ext-install gd

RUN docker-php-ext-install zip
RUN docker-php-ext-install xsl

RUN apt-get update && apt-get install -y libicu-dev
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install sockets

RUN pecl install redis \
    && docker-php-ext-enable redis

# ldap
RUN apt-get update && apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap
# ldap    

RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

RUN pecl install xdebug-2.5.5
RUN echo "zend_extension=`php -i | grep ^extension_dir | cut -f 3 -d ' '`/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install soap

ENV COMPOSER_HOME=/composer
COPY --from=composer:1.8.4 /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y git vim mysql-client rsync sshpass bzip2 msmtp unzip

ADD php.ini /usr/local/etc/php/php.ini

# Cron
RUN apt-get update && apt-get install -y cron \
    && mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron

COPY start-cron /usr/sbin
RUN chmod +x /usr/sbin/start-cron
# Cron

ENV PHP_DATE_TIMEZONE="" \
    PHP_LOG_ERRORS_MAX_LEN=1024 \
    PHP_LOG_ERRORS="" \
    PHP_MAX_EXECUTION_TIME=0 \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_MAX_INPUT_VARS=1000 \
    PHP_MEMORY_LIMIT=128M \
    PHP_POST_MAX_SIZE=8M \
    PHP_SENDMAIL_PATH="/usr/sbin/sendmail -t -i" \
    PHP_SESSION_SAVE_HANDLER=files \
    PHP_SESSION_SAVE_PATH="" \
    PHP_UPLOAD_MAX_FILESIZE=2M \
    PHP_XDEBUG_DEFAULT_ENABLE=0 \
    PHP_XDEBUG_IDEKEY=''\
    PHP_XDEBUG_PROFILER_ENABLE=0 \
    PHP_XDEBUG_REMOTE_AUTOSTART=0 \
    PHP_XDEBUG_REMOTE_CONNECT_BACK=0 \
    PHP_XDEBUG_REMOTE_ENABLE=0 \
    PHP_XDEBUG_REMOTE_HOST=0

WORKDIR /usr/src/app

# imagick
RUN apt-get update && apt-get install -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql
