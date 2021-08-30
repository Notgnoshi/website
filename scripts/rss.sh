#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
    SCRIPT_DIRECTORY="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIRECTORY/$SOURCE"
done
SCRIPT_DIRECTORY="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(readlink --canonicalize --no-newline "$SCRIPT_DIRECTORY/../")"

echo "Checking for virtualenv..."
if [ ! -e "$REPO_ROOT/.venv/bin/activate" ]; then
    echo "Creating virtualenv..."
    python3 -m venv "$REPO_ROOT/.venv/" --prompt website
    echo "Activating virtualenv..."
    source "$REPO_ROOT/.venv/bin/activate"
    echo "Installing dependencies..."
    pip install -r "$REPO_ROOT/requirements.txt"
else
    source "$REPO_ROOT/.venv/bin/activate"
fi

echo "Regenerating RSS feed..."
"$REPO_ROOT/scripts/generate-rss-feed.py" --log-level INFO --output "$REPO_ROOT/root/rss.xml"
echo "Finished generating RSS feed."
