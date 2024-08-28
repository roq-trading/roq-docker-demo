#!/usr/bin/env bash

MANAGER=$(which docker)
if [[ $? != 0 ]]; then
MANAGER=$(which podman)
if [[ $? != 0 ]]; then
echo -e "\033[1;32mERROR!\033[0m"
fi
fi

echo "Using $MANAGER"

$MANAGER image prune --all --force
$MANAGER pull docker.io/condaforge/miniforge3:latest
$MANAGER build --no-cache --tag test:1 .
