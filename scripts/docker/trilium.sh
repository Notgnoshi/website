#!/bin/bash


docker run \
    --tty \
    --detach \
    --expose 80 \
    --expose 443 \
    --expose 8080 \
    --name trilium \
    --restart unless-stopped \
    --volume /srv/trilium/trilium-data:/srv/trilium/trilium-data \
    --env TRILIUM_DATA_DIR=/srv/trilium/trilium-data \
    --env "VIRTUAL_HOST=notes.agill.xyz" \
    --env "VIRTUAL_PORT=8080" \
    --env "LETSENCRYPT_HOST=notes.agill.xyz" \
    --env "LETSENCRYPT_EMAIL=notgnoshi@gmail.com" \
    zadam/trilium
