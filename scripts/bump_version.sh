#!/bin/bash

set -e  # Exit on error

# Get the latest tag (sorts semver tags and picks the highest one)
LATEST_TAG=$(git tag --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)

# Extract version numbers
if [[ $LATEST_TAG =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    MAJOR=${BASH_REMATCH[1]}
    MINOR=${BASH_REMATCH[2]}
    PATCH=${BASH_REMATCH[3]}
else
    echo "No valid version tags found. Starting from v0.0.0."
    MAJOR=0
    MINOR=0
    PATCH=0
fi

# Decide version bump type (default = patch)
case "$1" in
    major) ((MAJOR++)); MINOR=0; PATCH=0 ;;
    minor) ((MINOR++)); PATCH=0 ;;
    patch|*) ((PATCH++)) ;;
esac

# Create the new version tag
NEW_TAG="v$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_TAG"

# Confirm and create the tag
git tag "$NEW_TAG"
git push origin "$NEW_TAG"

echo "✅ Successfully created and pushed tag $NEW_TAG"
