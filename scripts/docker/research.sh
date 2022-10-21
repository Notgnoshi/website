#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

docker run \
    --interactive \
    --tty \
    --detach \
    --restart unless-stopped \
    --name research-api \
    --mount "type=bind,source=/home/nots/services/research,target=/app" \
    --workdir=/app \
    --expose 80 \
    --env WEB_CONCURRENCY=1 \
    --env HTTPS_METHOD=nohttps \
    --env VIRTUAL_HOST=api.localhost \
    notgnoshi/api
