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

#### Miscellaneous notes

The site is deployed at

    http://45.33.68.74
    http://[2600:3c03::f03c:91ff:fe51:9aeb]

#### Uh oh

Things I've done manually to provision the server. How is devops formed?

* Make an SSH key

* `ssh-copy-id` my laptops' SSH keys onto it

* Install docker, docker-compose, and runit via apt-get

* Create log dirs for runit services:

      mkdir /var/log/snowdrift
      mkdir /var/log/snowdrift-control

* Deploy `snowdrift-control` binary and service files:

      ./devops/deploy-snowdrift-control.sh

* Copy the `snowdrift` service files:

      rsync -r devops/snowdrift-runit-service/* root@45.33.68.74:/etc/service/snowdrift
