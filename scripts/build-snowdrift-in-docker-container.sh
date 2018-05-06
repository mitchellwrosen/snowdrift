#!/usr/bin/env bash

# The image to use to build the site
IMAGE=mitchellsalad/ghc-8.2.2

# The version of the website, served at /version
VERSION=$(git rev-parse HEAD)

# Locations of cabal/ghc executables in the image
CABAL=/opt/cabal/bin/cabal
GHC=/opt/ghc/bin/ghc

# Where cabal puts the snowdrift binary
TARGET=/snowdrift-1/dist-newstyle/build/x86_64-linux/ghc-8.2.2/snowdrift-1/x/snowdrift/build/snowdrift/snowdrift

docker run \
  --rm \
  --mount "type=bind,src=$PWD/dist,dst=/dist" \
  $IMAGE \
  /sbin/my_init -- sh -c \
    "tar xf dist/snowdrift-1.tar.gz -C . && \
     cd snowdrift-1 && \
     SNOWDRIFT_VERSION=$VERSION HOME=/root $CABAL new-build -w $GHC &&
     cp $TARGET /dist"
