#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

REPO_ROOT=$(git rev-parse --show-toplevel)

if [[ ! "$(basename "${1:-}")" =~ ^export-([0-9]{4}-[0-9]{2}-[0-9]{2})\.tar\.gz$ ]]; then
    echo "usage: $0 logs/export-YYYY-MM-DD.tar.gz" >&2
    exit 1
fi
date="${BASH_REMATCH[1]}"

out="$(dirname "$1")/export-$date"
mkdir -p "$out"
tar xzf "$1" -C "$out"

if [[ -n "${GEOIP_DATABASE:-}" ]]; then
    db=$(realpath "$GEOIP_DATABASE")
else
    month=$(date +%Y-%m)
    db="$REPO_ROOT/logs/dbip-city-lite-$month.mmdb"
    if [[ ! -e "$db" ]]; then
        if curl -fsSL "https://download.db-ip.com/free/dbip-city-lite-$month.mmdb.gz" |
            gunzip >"$db.tmp"; then
            mv "$db.tmp" "$db"
        else
            rm -f "$db.tmp"
            older=("$REPO_ROOT"/logs/dbip-city-lite-*.mmdb)
            if [[ ! -e "${older[-1]}" ]]; then
                echo "$0: cannot download $db and no older database exists" >&2
                exit 1
            fi
            db="${older[-1]}"
            echo "$0: download failed, using older database $db" >&2
        fi
    fi
fi

cd "$out"
# nginx-proxy's vhost format:
#
#    $host $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_addr"
args=(
    --no-progress
    --geoip-database="$db"
    --log-format='%v %h %^[%d:%t %^] "%r" %s %b "%R" "%u" %^'
    --date-format='%d/%b/%Y'
    --time-format='%H:%M:%S'
    --enable-panel=REFERRERS
)
zcat -f access.log access.log.[0-9]* |
    goaccess - "${args[@]}" --invalid-requests=invalid.log --output=report.html
zcat -f access.log access.log.[0-9]* |
    goaccess - "${args[@]}" --ignore-crawlers --unknowns-as-crawlers --output=report-humans.html

wc -l <invalid.log
echo "file://$PWD/report.html"
echo "file://$PWD/report-humans.html"
