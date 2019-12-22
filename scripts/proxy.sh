#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Run the nginx reverse proxy container.
# See: https://hub.docker.com/r/jwilder/nginx-proxy for documentation.
docker run \
    --detach \
    --name "nginx-proxy" \
    --publish 80:80 \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    jwilder/nginx-proxy
