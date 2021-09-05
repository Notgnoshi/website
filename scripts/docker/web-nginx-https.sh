#!/bin/bash

docker stop nginx-proxy-acme || true
docker rm nginx-proxy-acme || true

# See: https://github.com/nginx-proxy/acme-companion
# Uses a named volume (nginx_certs) from the nginx-proxy container to persist the certificates
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
