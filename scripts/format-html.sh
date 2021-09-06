#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIRECTORY="$(cd "$(dirname "$SOURCE")" >/dev/null && pwd)"
REPO_ROOT="$SCRIPT_DIRECTORY/.."

shopt -s extglob
prettier --prose-wrap always --tab-width 4 --html-whitespace-sensitivity css --print-width 120 --write "$REPO_ROOT"/root/**/*.html
