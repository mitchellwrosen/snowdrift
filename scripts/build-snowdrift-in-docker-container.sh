#!/usr/bin/env bash

# The image to use to build Snowdrift
IMAGE=mitchellsalad/ghc-8.2.2

# The version of the website, served at /version
VERSION=$(git rev-parse HEAD)

# Locations of cabal/ghc executables in the image
CABAL=/opt/cabal/bin/cabal
GHC=/opt/ghc/bin/ghc

# Where to put build artifacts
BUILDDIR=/root/snowdrift-dist

docker run \
  --rm \
  --mount "type=volume,src=snowdrift-cabal-store,dst=/root/.cabal" \
  --mount "type=volume,src=snowdrift-cabal-dist,dst=$BUILDDIR" \
  --mount "type=bind,src=$PWD,dst=/snowdrift" \
  $IMAGE sh -c \
    "cd snowdrift && \
     SNOWDRIFT_VERSION=$VERSION HOME=/root $CABAL new-build -O -w $GHC --builddir $BUILDDIR all"
