# docker-php-fpm

This is a docker php fpm image, based on the official php fpm image. It has the following additions:

- extensions
  - memcached (3.1.5)
  - gd (2.1.0)
    - png (1.2.50)
    - jpeg (6b)
    - webp
    - freetype (2.5.2)
    - gif create/read
    - wbmp
    - xpm
    - xbm
  - zip (1.11.0, lib: 0.10.1)
  - imagick (3.5.1)
  - intl (1.1.0, icu: 52.1)
  - mysqli (5.0.11-dev)
  - pdo_mysql (5.0.11-dev)
  - pdo_pgsql
  - pgsql
  - pcov (1.0.6)
  - xdebug (3.1.2)
  - opcache
  - pcntl
  - soap
  - bcmath
  - xml
  - xsl
  - calendar
  - ldap
  - redis (5.3.5)
  - amqp (master)
  - sockets
- composer (1.10.17 & 2.1.9)
- git cli (2.1.4)
- vim (7.4)
- mysql-client (mysql Ver 14.14 Distrib 5.5.58)
- rsync (3.1.1)
- sshpass (1.05)
- bzip2
- msmtp
- unzip
- cron/crontab with `start-cron` executable
- `max_execution_time=0` even in php-fpm (use `PHP_MAX_EXECUTION_TIME` environment variable to override it)
- possibility to override special php ini settings with environment variables: (see included php.ini for a full list, see [this blog post for reasons](https://dracoblue.net/dev/use-environment-variables-for-php-ini-settings-in-docker/)):
```ini
date.timezone=${PHP_DATE_TIMEZONE};
log_errors_max_len=${PHP_LOG_ERRORS_MAX_LEN};
log_errors=${PHP_LOG_ERRORS};
max_execution_time=${PHP_MAX_EXECUTION_TIME};
max_file_uploads=${PHP_MAX_FILE_UPLOADS};
max_input_vars=${PHP_MAX_INPUT_VARS};
memory_limit=${PHP_MEMORY_LIMIT};
opcache.preload=${PHP_OPCACHE_PRELOAD}
opcache.preload_user=${PHP_OPCACHE_PRELOAD_USER}
opcache.memory_consumption=${PHP_OPCACHE_MEMORY_CONSUMPTION}
opcache.max_accelerated_files=${PHP_OPCACHE_MAX_ACCELERATED_FILES}
opcache.validate_timestamps=${PHP_OPCACHE_VALIDATE_TIMESTAMPS}
realpath_cache_size=${PHP_REALPATH_CACHE_SIZE}
realpath_cache_ttl=${PHP_REALPATH_CACHE_TTL}
post_max_size=${PHP_POST_MAX_SIZE};
sendmail_path=${PHP_SENDMAIL_PATH}
session.save_handler=${PHP_SESSION_SAVE_HANDLER};
session.save_path=${PHP_SESSION_SAVE_PATH};
upload_max_filesize=${PHP_UPLOAD_MAX_FILESIZE};
xdebug.default_enable=${PHP_XDEBUG_DEFAULT_ENABLE}
xdebug.idekey=${PHP_XDEBUG_IDEKEY}
xdebug.profiler_enable=${PHP_XDEBUG_PROFILER_ENABLE}
xdebug.remote_autostart=${PHP_XDEBUG_REMOTE_AUTOSTART}
xdebug.remote_connect_back=${PHP_XDEBUG_REMOTE_CONNECT_BACK}
xdebug.remote_enable=${PHP_XDEBUG_REMOTE_ENABLE}
xdebug.remote_host=${PHP_XDEBUG_REMOTE_HOST}
```

## Usage "docker"

### Run PHP-FPM Server

```console
$ docker run --rm -p 9000:9000 -v `pwd`:/usr/src/app exozet/php-fpm:5.5.38
```

### Run PHP-CLI

If you want to launch a shell:

```console
$ docker run --rm -it -v `pwd`:/usr/src/app --user "${UID:www-data}:${GROUPS[0]:www-data}" exozet/php-fpm:5.5.38 bash
```

If you want to run a php command:

```console
$ docker run --rm -it -v `pwd`:/usr/src/app --user "${UID:www-data}:${GROUPS[0]:www-data}" exozet/php-fpm:5.5.38 php -v
PHP 5.5.38 (cli) (built: Aug 10 2016 21:09:37)
Copyright (c) 1997-2015 The PHP Group
Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies
    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2015, by Zend Technologies
```

If you want to run composer:

set ```COMPOSER_VERSION``` to the major version you want to use (default ```COMPOSER_VERSION=2``` ) 

```console
$ docker run --rm -it -v `pwd`:/usr/src/app  exozet/php-fpm:7.4.13 composer --version
Composer version 1.10.17 2020-10-30 22:31:58
$ docker run --rm -it -e COMPOSER_VERSION=1 -v `pwd`:/usr/src/app  exozet/php-fpm:7.4.13 composer --version
Composer version 1.10.17 2020-10-30 22:31:58
$ docker run --rm -it -e COMPOSER_VERSION=2 -v `pwd`:/usr/src/app  exozet/php-fpm:7.4.13 composer --version
Composer version 2.0.7 2020-11-13 17:31:06
```

## Sending E-Mail

Since there is no exim or something like this running in your docker image, it's not possible to send emails with `mail()`
 out of the box on php with docker. But this image ships with [msmtp](https://wiki.archlinux.org/index.php/msmtp) and a configurable sendmail path.

Thus you can configure send mail for instance like this:

```text
PHP_SENDMAIL_PATH=/usr/bin/msmtp -t --host=smtp.example.org --port=1025
```

and `mail('hans@example.org', 'subject', 'message!');` will use the smtp host at `smtp.example.org`.

We recommend to use a service like [mailhog](https://hub.docker.com/r/mailhog/mailhog/) as a service to fetch mails
on development.

This in your `docker-compose.yaml`:

```yaml
services:
  mailhog:
    image: mailhog/mailhog:v1.0.0
    ports:
      - "1025"
      - "8025:8025"
```

makes a mailhog server at `http://127.0.0.1:8025` available. If you set 

```text
PHP_SENDMAIL_PATH=/usr/bin/msmtp -t --host=mailhog --port=1025
```

all your mails will be visible there.

## Using "Cron": Setting `CRONTAB_CONTENT` and `CRONTAB_USER`

You can define the crontab's content with an environment variable like this:

`docker-compose.yml`:
```yaml
services:
  import-data-cron:
    image: exozet/php-fpm:7.1.10
    command: start-cron
    environment:
      - 'CRONTAB_USER=www-data'
      - |
         CRONTAB_CONTENT=
         */10 * * * * cd /usr/src/app && php run-import.php >> /var/log/cron.log 2>&1
    volumes:
      - ./:/usr/src/app:cached
```

It's very important to specify `/var/log/cron.log` as response for all outputs of your
cronjob, since crontab will otherwise try to send the response by email, which cannot work
in this docker setup.

We recommend to use **one** cronjob/container to ensure that your monitoring, restarting, recovery and
 so on works properly. Otherwise you don't **know**, which of your cronjobs is consuming which amount of
 resources.

## Alternative way to use "Cron": Mounting `/etc/cron.d` OR setting `CRON_PATH`

**Hint:** Please use this way only, if the previous way (setting `CRONTAB_CONTENT` Environment variable) does not work for your
project.

Create your crontab directory in project folder and put all your cron files in this directory.

`crontabs` directory:
```text
  - one-cron
  - other-cron
```
`one-cron` file:
```console
*/10 * * * * root php your-command/script >> /var/log/cron.log 2>&1
# Don't remove the empty line at the end of this file. It is required to run the cron job
```

Even though it's possible, we do not recommend to use **multiple** cronjob/container in one crontab file. This makes
monitoring the different cron jobs harder for your operation/monitoring/alerting tools.

Usage in your `docker-compose.yml`:
```yaml
services:
  crontab:
    image: exozet/php-fpm:7.1.10
    command: start-cron
    volumes:
      - ./:/usr/src/app
      - ./crontabs:/etc/cron.d
```

If your cron folder is already part or your project, you can override the
cron location with the `CRON_PATH` environment variable:

```yaml
services:
  crontab:
    image: exozet/php-fpm:7.1.10
    command: start-cron
    environment:
      - CRON_PATH=/usr/src/app/crontabs
    volumes:
      - ./:/usr/src/app
```

## Usage "docker-compose"

Create a `docker-compose.yml`:

```yaml
version: "2.1"

services:
  php-cli:
    image: exozet/php-fpm:5.5.38-sudo
    volumes:
      - ./:/usr/src/app
    user: "${UID-www-data}:${GID-www-data}"
    entrypoint: bash
    depends_on:
      - nginx
  php-fpm:
    image: exozet/php-fpm:5.5.38
    volumes:
      - ./:/usr/src/app
  nginx:
    image: nginx:1.11.10
    depends_on:
      - php-fpm
    ports:
      - "8080:8080"
    volumes:
      - ./:/usr/src/app
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

Create a `nginx.conf`:
```text
server {
    listen 8080 default_server;
    root /usr/src/app;

    location ~ \.php$ {
        fastcgi_pass php-fpm:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
    }
}
```

Create an `index.php`:

``` php
<?php

phpinfo();
```

Launch the php cli bash:

``` console
$ docker-compose run --rm php-cli
Creating network "dockerphpfpm_default" with the default driver
Creating dockerphpfpm_php-fpm_1
Creating dockerphpfpm_nginx_1
www-data@bf4eb5663c05:/usr/src/app$ ls -al
total 592
drwxr-xr-x 8 www-data www-data    510 Mar 17 13:05 .
drwxr-xr-x 3 root     root       4096 Mar 17 13:05 ..
-rw-r--r-- 1 www-data www-data    478 Mar 17 13:02 docker-compose.yml
-rw-r--r-- 1 www-data www-data    350 Mar 17 12:55 nginx.conf
-rw-r--r-- 1 www-data www-data     18 Mar 17 13:03 index.php
```

Open the nginx+php-fpm at <http://localhost:8080/>:

![Screenshot of localhost:8080](./screenshot-php.png)

## Fixing user permissions on linux

Since Docker for MacOS uses osxfs to map from the docker runtime to the osx
 filesystem, all files will be written with the hosts userid on the hots
 filesystem. This is actually not the case on linux.
 
To workaround this, we added:

```
    user: "${UID-www-data}:${GID-www-data}"
```

to the service definition in the `docker-compose.ym`. If you do this, it will
use the systems UID (e.g. 1000) or `www-data` as default user+group if `$UID`
is not set. But you can use a `.env` file with the following
content:

```text
UID=1000
GID=1000
```

and your local linux user (e.g. 1000 is the default uid on ubuntu) will own the files,
which are created in your docker container.

## Use host SSH credentials inside container

You need to use /var/www/... here, since it's the HOME directory of www-data user.

docker-compose.yml

```yaml
#[...]
volumes:
    - ~/.ssh/:/var/www/.ssh
#[...]
```
or add this to your docker run command:

```bash
-v ~/.ssh/:/var/www/.ssh --user www-data
```

## LICENSE

The docker-php-fpm is copyright by Exozet (http://exozet.com) and licensed under the terms of MIT License.
