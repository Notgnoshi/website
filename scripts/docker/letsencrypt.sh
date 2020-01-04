#!/bin/bash

docker run \
	--detach \
    --name nginx-proxy-letsencrypt \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env "DEBUG=true" \
    --env "DEFAULT_EMAIL=notgnoshi@gmail.com" \
    --restart unless-stopped \
    jrcs/letsencrypt-nginx-proxy-companion
