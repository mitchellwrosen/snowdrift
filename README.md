[![Build Status](https://travis-ci.org/mitchellwrosen/snowdrift.svg?branch=master)](https://travis-ci.org/mitchellwrosen/snowdrift)

#### Building the code

    cabal new-build

#### Running the website locally

    cabal new-run

This will run the website on http://localhost:8000.

#### Configuring the build

You may want to configure the build locally with a `cabal.project.local`. For
example, to disable optimization for faster builds, use

    package snowdrift
      optimization: False

#### Manually deploying the code

* (Optional) Build the container that runs Ubuntu 16.04 and contains ghc and
  cabal-install. This image will be used to build the code.

      ./scripts/build-ghc-8.2.2-docker-image.sh

  Alternatively, you can pull this image from DockerHub if it's been built and
  pushed recently enough.

      docker pull mitchellsalad/ghc-8.2.2

* (Optional) push the ghc-8.2.2 image to DockerHub, if built locally and the
  public version needs updating.

      ./scripts/push-ghc-8.2.2-docker-image.sh

* Tarball the code. This creates a tarball in `/dist` that the build image will
  have access to via a Docker `--mount`.

    cabal sdist

* Build the code inside the build container. This places a `snowdrift` binary
  inside the `/dist` dir on the host.

    ./scripts/build-snowdrift-in-docker-container.sh

* Build the Docker image to deploy, which contains the snowdrift executable.

    ./scripts/build-snowdrift-docker-image.sh

* Push the Docker image to DockerHub.

    ./scripts/push-snowdrift-docker-image.sh

* More steps required... :)

#### Miscellaneous notes

The site is deployed at

    http://45.33.68.74
    http://[2600:3c03::f03c:91ff:fe51:9aeb]
