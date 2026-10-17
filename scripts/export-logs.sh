#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

if [[ ! -e logs/access.log ]]; then
    echo "no logs/access.log; is the server running?" >&2
    exit 1
fi

# logrotate 3.19 (Ubuntu 22.04) compresses and shifts rotations before running prerotate, so a
# failed prerotate there leaves a gap in the numbering. Only 3.22+ runs prerotate first.
docker compose exec -T proxy nginx -t

logrotate --force --state logs/.logrotate.state logs/logrotate.conf

for _ in {1..50}; do # 5s timeout
    [[ -e logs/access.log ]] && break
    sleep 0.1
done
if [[ ! -e logs/access.log ]]; then
    echo "logs/access.log did not reappear after rotation" >&2
    exit 1
fi

# GNU tar exits 1 when a file changed while it was being read, which the live logs can do.
(cd logs && tar czf "export-$(date +%F).tar.gz" access.log access.log.[0-9]* error.log) ||
    [[ $? -eq 1 ]]

echo "logs/export-$(date +%F).tar.gz"
