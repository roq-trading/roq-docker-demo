#!/usr/bin/env bash

MANAGER=$(which docker)
if [[ $? != 0 ]]; then
MANAGER=$(which podman)
if [[ $? != 0 ]]; then
echo -e "\033[1;32mERROR!\033[0m"
fi
fi

echo "Using $MANAGER"

$MANAGER run -it \
    --publish 9001:9001 \
    --publish 1234:1234 \
    --volume ./config:/etc/roq:ro \
    --volume ./data:/var/lib/roq \
    test:1
