#!/bin/bash

# See: https://github.com/nginx-proxy/acme-companion
docker run \
    --detach \
    --name nginx-proxy-acme \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume nginx_acme:/etc/acme.sh \
    --env "DEFAULT_EMAIL=notgnoshi@gmail.com" \
    --restart unless-stopped \
    nginxproxy/acme-companion
    # --env "DEBUG=true" \
