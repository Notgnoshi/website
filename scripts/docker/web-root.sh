#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    # resolve $SOURCE until the file is no longer a symlink
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO_ROOT="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)/../../"
REPO_ROOT="$(readlink -f "${REPO_ROOT}")"

# Run the application container for a single subdomain.
# See: https://hub.docker.com/_/nginx for documentation.
docker run \
    --detach \
    --name "nginx-root" \
    --expose 80 \
    --expose 443 \
    --mount "type=bind,source=${REPO_ROOT}/html/root,target=/usr/share/nginx/html,readonly" \
    --mount "type=bind,source=${REPO_ROOT}/config/root.conf,target=/etc/nginx/conf.d/default.conf,readonly" \
    --mount "type=bind,source=${REPO_ROOT}/config/nginx.conf,target=/etc/nginx/nginx.conf,readonly" \
    --env "VIRTUAL_HOST=www.agill.xyz,agill.xyz,www.localhost,localhost" \
    --env "LETSENCRYPT_HOST=agill.xyz" \
    --env "LETSENCRYPT_EMAIL=notgnoshi@gmail.com" \
    --restart unless-stopped \
    nginx
