FROM php:7.3-fpm

RUN apt-get update && apt-get install -y \
  libfreetype6-dev \
  libicu-dev \
  libjpeg-dev \
  libldap2-dev \
  libmagickwand-dev \
  libmemcached-dev \
  libpng-dev \
  libpq-dev \
  librabbitmq-dev \
  libssh-dev \
  libwebp-dev \
  libxml2-dev \
  libxpm-dev \
  libxslt-dev \
  libz-dev \
  libzip-dev \
  git vim default-mysql-client rsync sshpass bzip2 msmtp unzip cron \
  && rm -rf /var/lib/apt/lists/*

RUN pecl install memcached-3.1.2 && docker-php-ext-enable memcached
#RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini
RUN docker-php-ext-configure gd \
  --with-freetype-dir=/usr/include/ \
  --with-jpeg-dir=/usr/include/ \
  --with-xpm-dir=/usr/include \
  --with-webp-dir=/usr/include/ && \
  docker-php-ext-install gd

RUN pecl install amqp-1.9.4 && docker-php-ext-enable amqp
RUN docker-php-ext-install zip
RUN docker-php-ext-install xsl
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install sockets
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap
RUN docker-php-ext-configure pcntl --enable-pcntl && docker-php-ext-install pcntl
RUN pecl install xdebug-2.7.2 && echo "zend_extension=`php -i | grep ^extension_dir | cut -f 3 -d ' '`/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN docker-php-ext-install soap
RUN pecl install imagick && docker-php-ext-enable imagick
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pdo_pgsql pgsql
RUN pecl install pcov-1.0.0 && docker-php-ext-enable pcov

RUN apt-get remove -y \
  libfreetype6-dev \
  libicu-dev \
  libjpeg-dev \
  libldap2-dev \
  libmagickwand-dev \
  libmemcached-dev \
  libpng-dev \
  libpq-dev \
  librabbitmq-dev \
  libssh-dev \
  libwebp-dev \
  libxml2-dev \
  libxpm-dev \
  libxslt-dev \
  libz-dev \
  libzip-dev

ENV COMPOSER_HOME=/composer
COPY --from=composer:1.8.6 /usr/bin/composer /usr/local/bin/composer

ADD php.ini /usr/local/etc/php/php.ini

RUN mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron
COPY start-cron /usr/sbin
RUN chmod +x /usr/sbin/start-cron

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
