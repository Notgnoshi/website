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

# Download skin renders, generate HTML player cards, escape newlines, and replace the content between 'Begin' and 'End' tags.
"${REPO_ROOT}/static/players.py" \
    --renders \
    --html |
    sed ':a;N;$!ba;s/\n/\\n/g' |
    xargs -d'\n' -I '{}' sed -i '/<!-- Begin/,/<!-- End/c{}' "${REPO_ROOT}/html/mc/index.html"
