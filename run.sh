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

$MANAGER run -it \
    --publish 9001:9001 \
    --publish 1234:1234 \
    --volume ./config:/config:ro \
    --volume ./data:/data \
    $IMAGE \
    $@