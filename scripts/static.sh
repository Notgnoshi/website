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
REPO_ROOT="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)/../"
REPO_ROOT="$(readlink -f "${REPO_ROOT}")"

# Run the application container for a single subdomain.
# See: https://hub.docker.com/_/nginx for documentation.
docker run \
    --detach \
    --name "nginx-static" \
    --mount "type=bind,source=${REPO_ROOT}/html/static,target=/usr/share/nginx/html,readonly" \
    --mount "type=bind,source=${REPO_ROOT}/config/static.conf,target=/etc/nginx/conf.d/default.conf,readonly" \
    --mount "type=bind,source=${REPO_ROOT}/config/nginx.conf,target=/etc/nginx/nginx.conf,readonly" \
    --env "VIRTUAL_HOST=static.agill.xyz,static.localhost" \
    nginx

# NOTE: It will be necessary to redirect static.agill.xyz to static.localhost when testing static changes.
# I don't know how else to do it, since all the links will be to static.agill.xyz...
