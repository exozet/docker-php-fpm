#!/bin/sh
if [ -n "$COMPOSER_MAYOR_VERION" ]
then
    /usr/local/bin/composer$COMPOSER_MAYOR_VERION "$@"
else
    /usr/local/bin/composer1 "$@"
fi


