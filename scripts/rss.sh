#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Regenerating RSS feed..."
"$REPO_ROOT/scripts/generate-rss-feed.py" --log-level INFO --output "$REPO_ROOT/site/rss.xml"
echo "Finished generating RSS feed."
