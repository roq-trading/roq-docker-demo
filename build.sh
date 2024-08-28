#!/usr/bin/env bash

IMAGE=test:1

MANAGER=$(which docker)
if [[ $? != 0 ]]; then
MANAGER=$(which podman)
if [[ $? != 0 ]]; then
echo -e "\033[1;32mERROR!\033[0m" && exit 1
fi
fi

echo "Using $MANAGER"

$MANAGER image prune --all --force
$MANAGER pull docker.io/condaforge/miniforge3:latest
$MANAGER build --no-cache --tag $IMAGE .
