#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

if [[ -e logs/access.log || -e logs/access.log.1 || -e logs/access.log.1.gz ]]; then
    echo "access logs already exist. Refusing to overwrite." >&2
    exit 1
fi

trap 'rm -f logs/access.log.1' ERR

docker compose logs --no-color --no-log-prefix proxy |
    sed -En 's/\x1b\[[0-9;]*m//g; s/^nginx\.1 +\| //p' |
    { grep -E '^[^ ]+ [[:xdigit:].:]+ - [^ ]+ \[[0-9]{2}/[A-Z][a-z]{2}/[0-9]{4}:' || true; } |
    cat >logs/access.log.1

if [[ ! -s logs/access.log.1 ]]; then
    rm logs/access.log.1
    echo "no access lines found in container log" >&2
    exit 1
fi

echo "$(wc -l <logs/access.log.1) access lines written to logs/access.log.1"
