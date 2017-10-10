#!/usr/bin/env bash

set -e

cat *.*/versions | while read PHP_VERSION
do
  ./build_version.sh $PHP_VERSION
done