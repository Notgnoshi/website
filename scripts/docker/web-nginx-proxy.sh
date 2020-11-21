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

# Run the nginx reverse proxy container.
# See: https://hub.docker.com/r/jwilder/nginx-proxy for documentation.
docker run \
    --detach \
    --name "nginx-proxy" \
    --publish 80:80 \
    --publish 443:443 \
    --volume /etc/nginx/certs \
    --volume "${REPO_ROOT}/config/vhost.d:/etc/nginx/vhost.d:rw" \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    --env DEFAULT_HOST=agill.xyz \
    --restart unless-stopped \
    jwilder/nginx-proxy
