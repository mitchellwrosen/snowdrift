#!/usr/bin/env bash

set -ex

# Copy snowdrift executable out of an ephemeral container into /dist
docker run \
  --rm \
  --mount "type=volume,src=snowdrift-cabal-dist,dst=/tmp/snowdrift" \
  --mount "type=bind,src=$PWD/dist,dst=/dist" \
  ubuntu:16.04 \
  sh -c "cp \$(find /tmp/snowdrift -name snowdrift -type f -executable) /dist"

# Build dockerfile
docker build . -f deploy/DeployDockerfile -t mitchellsalad/snowdrift
