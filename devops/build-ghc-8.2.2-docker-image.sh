#!/usr/bin/env bash

docker build . -f devops/BuildDockerfile -t mitchellsalad/ghc-8.2.2
