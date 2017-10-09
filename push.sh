#!/usr/bin/env bash

cat *.*/versions | while read PHP_VERSION
do
  ./push_version.sh $PHP_VERSION
done