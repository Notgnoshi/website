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
    --publish 443:443 \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    --env DEFAULT_HOST=agill.xyz \
    --restart unless-stopped \
    jwilder/nginx-proxy
