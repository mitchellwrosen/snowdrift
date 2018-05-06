#!/usr/bin/env bash

docker build . -f deploy/DeployDockerfile -t mitchellsalad/snowdrift
