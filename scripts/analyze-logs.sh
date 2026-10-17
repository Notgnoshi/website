#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

if [[ ! "$(basename "${1:-}")" =~ ^export-([0-9]{4}-[0-9]{2}-[0-9]{2})\.tar\.gz$ ]]; then
    echo "usage: $0 logs/export-YYYY-MM-DD.tar.gz" >&2
    exit 1
fi
date="${BASH_REMATCH[1]}"

out="$(dirname "$1")/export-$date"
mkdir -p "$out"
tar xzf "$1" -C "$out"

cd "$out"
# nginx-proxy's vhost format:
#
#    $host $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_addr"
zcat -f access.log access.log.[0-9]* |
    goaccess - \
        --no-progress \
        --log-format='%v %h %^[%d:%t %^] "%r" %s %b "%R" "%u" %^' \
        --date-format='%d/%b/%Y' \
        --time-format='%H:%M:%S' \
        --enable-panel=REFERRERS \
        --invalid-requests=invalid.log \
        --output=report.html

wc -l <invalid.log
echo "file://$PWD/report.html"
