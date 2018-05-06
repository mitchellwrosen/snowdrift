#!/usr/bin/env bash

docker build . -f deploy/BuildDockerfile -t mitchellsalad/ghc-8.2.2
