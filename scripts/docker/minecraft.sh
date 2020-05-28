#!/bin/bash

docker run \
    --detach \
    --interactive \
    --tty \
    --restart unless-stopped \
    --publish 25565:25565 \
    --name mc \
    --env EULA=TRUE \
    --env TZ=America/Chicago \
    --env VERSION=LATEST \
    --env INIT_MEMORY=512M \
    --env MAX_MEMORY=8G \
    --env ENABLE_AUTOPAUSE=TRUE \
    --env AUTOPAUSE_TIMEOUT_EST=1800 \
    --env AUTOPAUSE_TIMEOUT_INIT=300 \
    --env AUTOPAUSE_TIMEOUT_KN=120 \
    --env AUTOPAUSE_PERIOD=10 \
    --mount "type=bind,source=/srv/minecraft/server,target=/data" \
    itzg/minecraft-server
