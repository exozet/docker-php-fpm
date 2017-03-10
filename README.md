# docker-php-fpm

This is a docker php fpm image, based on the official php fpm image. It has the following additions:

- extensions
  - memcached
  - gd
  - zip
  - intl
  - mysqli
  - pdo_mysql
  - opcache
- composer cli
- git cli

## Usage

``` console
$ docker run --rm -p 9000:9000 exozet/php-fpm
```

## LICENSE

The docker-php-fpm is copyright by Exozet (http://exozet.com) and licensed under the terms of MIT License.

