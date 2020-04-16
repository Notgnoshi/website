#!/bin/bash

docker run \
    --detach \
    --restart unless-stopped \
    --name plex \
    --publish 32400:32400 \
    --expose 32400 \
    --gpus all \
    --env TZ="MDT" \
    --env PLEX_UID=1000 \
    --env PLEX_GID=1000 \
    --env VIRTUAL_HOST=plex.agill.xyz,plex.localhost \
    --env VIRTUAL_PORT=32400 \
    --env LETSENCRYPT_HOST=plex.agill.xyz \
    --env LETSENCRYPT_EMAIL=notgnoshi@gmail.com \
    --mount "type=bind,source=/srv/plex/config,target=/config" \
    --mount "type=bind,source=/srv/plex/transcode,target=/transcode" \
    --mount "type=bind,source=/srv/plex/data,target=/data" \
    plexinc/pms-docker:plexpass

# TODO: Set PLEX_UID and PLEX_GID intelligently.
