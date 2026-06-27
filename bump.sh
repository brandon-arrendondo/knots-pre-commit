#!/usr/bin/env bash
# Pin this shim to a released knots version.
# Usage: ./bump.sh <version>     e.g. ./bump.sh 1.11.0
#
# The version must already be published to PyPI by the knots repo's wheels.yml
# workflow. After bumping, commit and tag this repo to match (see README.md).
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>   (e.g. $0 1.11.0)" >&2
    exit 1
fi

VERSION="$1"
HERE="$(cd "$(dirname "$0")" && pwd)"

# Rewrite the knots==X pin in pyproject.toml.
sed -i -E "s/\"knots==[0-9][^\"]*\"/\"knots==${VERSION}\"/" "${HERE}/pyproject.toml"

# Keep the README example rev in sync.
sed -i -E "s/rev: v[0-9][^ ]*/rev: v${VERSION}/" "${HERE}/README.md"

echo "Pinned knots==${VERSION}"
grep 'knots==' "${HERE}/pyproject.toml"
