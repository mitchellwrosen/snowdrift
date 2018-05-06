[![Build Status](https://travis-ci.org/mitchellwrosen/snowdrift.svg?branch=master)](https://travis-ci.org/mitchellwrosen/snowdrift)

#### Building the code

    cabal new-build snowdrift

#### Running the website locally

    cabal new-run snowdrift

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

      docker push mitchellsalad/ghc-8.2.2

* Build the code inside the build container.

      ./scripts/build-snowdrift-in-docker-container.sh

  To make subsequent manual builds faster, this will use two docker volumes for
  the cabal build directory and cabal nix-style store. You can see these by
  running:

      docker volume ls

  It's safe to delete either them at any time by running:

      docker volume rm snowdrift-cabal-dist
      docker volume rm snowdrift-cabal-store

* Build the Docker image to deploy, which contains the `snowdrift` executable at
  `/bin/snowdrift`.

      ./scripts/build-snowdrift-docker-image.sh

* Push the Docker image to DockerHub.

      docker push mitchellsalad/snowdrift

* More steps required... :)

#### Miscellaneous notes

The site is deployed at

    http://45.33.68.74
    http://[2600:3c03::f03c:91ff:fe51:9aeb]

#### Uh oh

Things I've done manually to provision the server. How is devops formed?

* Make an SSH key

* `ssh-copy-id` my laptop's SSH key onto it

* Install docker, docker-compose, runit

* Create log dirs for runit services:

      mkdir /var/log/snowdrift
      mkdir /var/log/snowdrift-control

* Deploy `snowdrift-control` binary and service files:

      ./scripts/deploy-snowdrift-control.sh

* Copy the `snowdrift` service files:

      rsync -r deploy/snowdrift-runit-service/* root@45.33.68.74:/etc/service/snowdrift
