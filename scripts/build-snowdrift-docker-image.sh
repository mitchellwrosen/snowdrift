#!/usr/bin/env bash

set -ex

docker run \
  --name snowdrift \
  --mount "type=volume,src=snowdrift-cabal-dist,dst=/tmp/snowdrift" \
  --mount "type=bind,src=$PWD/dist,dst=/dist" \
  phusion/baseimage:0.10.1 \
  sh -c "cp \$(find /tmp/snowdrift -name snowdrift -type f -executable) /bin/snowdrift"

docker commit snowdrift mitchellsalad/snowdrift

docker rm snowdrift
