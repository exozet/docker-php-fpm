#!/usr/bin/env bash
set -ev

RELEVANT_FILES=$(git diff --name-only HEAD upstream/${TRAVIS_BRANCH} -- '${PHP_VERSION}/Dockerfile' '.travis.yml')


echo $RELEVANT_FILES

if [[ -z ${RELEVANT_FILES} ]]; then echo -n 'KO'; exit 0; fi;
