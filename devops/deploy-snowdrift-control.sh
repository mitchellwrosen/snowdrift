#!/usr/bin/env bash

set -ex

docker run \
  --rm \
  --mount "type=volume,src=snowdrift-cabal-store,dst=/root/.cabal" \
  --mount "type=bind,src=$PWD/dist,dst=/dist" \
  --mount "type=bind,src=$PWD/snowdrift-control,dst=/snowdrift" \
  mitchellsalad/ghc-8.2.2 \
  sh -c \
    "cd /snowdrift && \
     cabal new-update && \
     cabal new-build && \
     cp \$(find dist-newstyle -name snowdrift-control -type f -executable) /dist"

# Copy it to the server
rsync dist/snowdrift-control root@45.33.68.74:/bin/snowdrift-control

# Copy the service files
rsync -r devops/snowdrift-control-runit-service/* root@45.33.68.74:/etc/service/snowdrift-control

# Restart the service
ssh root@45.33.68.74 sv restart snowdrift-control
