#!/bin/sh
set +e
if [ -n "$COMPOSER_VERSION" ]
then
    /usr/local/bin/composer$COMPOSER_VERSION "$@"
else
    /usr/local/bin/composer1 "$@"
fi
