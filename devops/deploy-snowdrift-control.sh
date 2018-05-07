#!/usr/bin/env bash

set -ex

# Copy snowdrift executable out of an ephemeral container into /dist
docker run \
  --rm \
  --mount "type=volume,src=snowdrift-cabal-dist,dst=/tmp/snowdrift" \
  --mount "type=bind,src=$PWD/dist,dst=/dist" \
  ubuntu:16.04 \
  sh -c "cp \$(find /tmp/snowdrift -name snowdrift-control -type f -executable) /dist"

# Copy it to the server
rsync dist/snowdrift-control root@45.33.68.74:/bin/snowdrift-control

# Copy the service files
rsync -r devops/snowdrift-control-runit-service/* root@45.33.68.74:/etc/service/snowdrift-control

# Restart the service
ssh root@45.33.68.74 sv restart snowdrift-control
