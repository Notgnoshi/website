#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO_ROOT="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)/.."
REPO_ROOT="$(readlink --canonicalize --no-newline "${REPO_ROOT}")"

FIGURES=""
# Read the comic page and comic image URLs from a simple comma-separated file.
while IFS=, read -r PAGE_URL IMAGE_URL; do
    # The URL slug for the given comic
    SLUG=$(echo "$PAGE_URL" | sed -En 's|^.*comic/([[:alnum:]_-]+)/$|\1|p')
    IMAGE_URL=${IMAGE_URL//www./}
    # The URL the image will be hosted at
    STATIC_URL="/images/poorly-drawn-lines/$SLUG.png"
    # Download the image if it doesn't already exist.
    DOWNLOAD_URL="$REPO_ROOT/images/poorly-drawn-lines/$SLUG.png"
    if [[ ! -f "$DOWNLOAD_URL" ]]; then
        curl --location --output "$DOWNLOAD_URL" "$IMAGE_URL"
    fi
    # The escaping here was ass to figure out.
    FIGURE="    <figure class=\\\"figure d-block mx-auto w-75\\\">\\
        <a href=\\\"http:\/\/www.poorlydrawnlines.com\/comic\/$SLUG\/\\\" target=\\\"_blank\\\">\\
            <img loading=\\\"lazy\\\" class=\\\"figure-img img-fluid rounded w-100\\\" src=\\\"$STATIC_URL\\\" alt=\\\"$SLUG\\\">\\
        <\/a>\\
        <figcaption class=\\\"figure-caption text-right\\\">$SLUG<\/figcaption>\\
    <\/figure>\n\\"
    FIGURES+="$FIGURE"
done < "$REPO_ROOT/scripts/poorly-drawn-lines.csv"

# Replace the figures between the #start and #end tags
sed -i "/<!-- #start -->/,/<!-- #end -->/c\    <!-- #start -->\n$FIGURES    <!-- #end -->" "$REPO_ROOT/html/root/poorly-drawn-lines.html"
