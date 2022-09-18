#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

REPO_DIR=$(git rev-parse --show-toplevel)
MD2HTML="$REPO_DIR/scripts/md2html.py"
TEMPLATE="$REPO_DIR/templates/page.html"

for draft in "$REPO_DIR/drafts/"*.md; do
    echo -n "Processing: $draft ..."
    slug="$(basename "$draft")"
    slug="${slug%.md}"
    slug="${slug// /-}"

    output="$REPO_DIR/root/drafts/$slug.html"

    $MD2HTML --input "$draft" --output "$output" --page-template "$TEMPLATE"
    echo " done"
done

echo "Finished rendering drafts. See: http://localhost/drafts"
