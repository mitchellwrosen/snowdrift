[![Build Status](https://travis-ci.org/mitchellwrosen/snowdrift.svg?branch=master)](https://travis-ci.org/mitchellwrosen/snowdrift)

#### Building the code

    cabal new-build

#### Deploying the code

* Build the container that runs Ubuntu 16.04 and contains ghc and cabal-install.
  This image will be used to build the code.

    ./scripts/build-ghc-8.2.2-docker-image.sh

* Tarball the code. This creates a tarball in `/dist` that the build image will
  have access to.

    cabal sdist

* Build the code inside the build container. This places a `snowdrift` binary
  inside the `/dist` dir on the host.

    ./scripts/build-snowdrift-in-docker-container.sh

* More steps required... :)

#### Running the website

    cabal new-run

This will run the website on http://localhost:8000.
