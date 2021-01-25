FROM php:7.4-fpm

RUN apt-get update && apt-get install --no-install-recommends -y libz-dev libmemcached-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pecl install memcached-3.1.5
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# gd extension
# php >=7.0 (use libvpx for php <7.0)
RUN apt-get update && apt-get install --no-install-recommends -y \
  libpng-dev \
  libfreetype6-dev \
  libjpeg-dev \
  libxpm-dev \
  libxml2-dev \
  libxslt-dev \
  librabbitmq-dev \
  libssh-dev \
  libwebp-dev \
  && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd \
    --enable-gd \
    --with-freetype \
    --with-jpeg \
    --with-xpm \
    --with-webp
RUN docker-php-ext-install gd

RUN pecl install amqp-1.9.4
RUN docker-php-ext-enable amqp

RUN apt-get update && apt-get install --no-install-recommends -y libz-dev libzip-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install zip
RUN docker-php-ext-install xsl

RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install sockets

RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

# ldap
RUN apt-get update && apt-get install --no-install-recommends libldap2-dev -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap
# ldap

RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

RUN pecl install xdebug-2.9.0
RUN echo "zend_extension=`php -i | grep ^extension_dir | cut -f 3 -d ' '`/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install soap

ENV COMPOSER_HOME=/composer
COPY --from=composer:1.10.17 /usr/bin/composer /usr/local/bin/composer1
COPY --from=composer:2.0.7 /usr/bin/composer /usr/local/bin/composer2

COPY composer /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer


RUN apt-get update && apt-get install --no-install-recommends -y \
    git vim default-mysql-client rsync sshpass openssh-client bzip2 msmtp unzip \
    && rm -rf /var/lib/apt/lists/*

ADD php.ini /usr/local/etc/php/php.ini

# Cron
RUN apt-get update && apt-get install --no-install-recommends -y cron \
    && rm -rf /var/lib/apt/lists/* \
    && mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron

COPY start-cron /usr/sbin
RUN chmod +x /usr/sbin/start-cron
# Cron

ENV COMPOSER_VERSION=1 \
    PHP_DATE_TIMEZONE="" \
    PHP_LOG_ERRORS_MAX_LEN=1024 \
    PHP_LOG_ERRORS="" \
    PHP_MAX_EXECUTION_TIME=0 \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_MAX_INPUT_VARS=1000 \
    PHP_MEMORY_LIMIT=128M \
    PHP_OPCACHE_PRELOAD="" \
    PHP_OPCACHE_PRELOAD_USER="" \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_REALPATH_CACHE_SIZE=4M \
    PHP_REALPATH_CACHE_TTL=120 \
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
RUN apt-get update && apt-get install --no-install-recommends -y libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick

# Install Postgres PDO
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql

RUN pecl install pcov-1.0.6
RUN docker-php-ext-enable pcov
