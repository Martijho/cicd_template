#!/bin/bash

set -e  # Exit on error

# Ensure a version argument is provided
if [[ -z "$1" ]]; then
    echo "❌ Error: No version provided."
    echo "Usage: $0 vX.Y.Z"
    exit 1
fi

VERSION="$1"

# Ensure the version follows the correct format
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: Version must be in the format vX.Y.Z (e.g., v1.2.3)."
    exit 1
fi

# Extract numeric parts
NEW_MAJOR=$(echo "$VERSION" | cut -d'.' -f1 | tr -d 'v')
NEW_MINOR=$(echo "$VERSION" | cut -d'.' -f2)
NEW_PATCH=$(echo "$VERSION" | cut -d'.' -f3)

# Fetch all tags from GitHub
git fetch --tags

# Check if the tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo "❌ Error: Tag $VERSION already exists."
    exit 1
fi

# Get the latest version tag
LATEST_TAG=$(git tag -l 'v*.*.*' | sort -V | tail -n1)

# If there are no previous tags, allow the new one
if [[ -z "$LATEST_TAG" ]]; then
    echo "✅ No existing tags found. Creating first version: $VERSION."
    git tag "$VERSION"
    git push origin "$VERSION"
    exit 0
fi

# Extract numeric parts of the latest tag
LATEST_MAJOR=$(echo "$LATEST_TAG" | cut -d'.' -f1 | tr -d 'v')
LATEST_MINOR=$(echo "$LATEST_TAG" | cut -d'.' -f2)
LATEST_PATCH=$(echo "$LATEST_TAG" | cut -d'.' -f3)

# Compare versions as integers
if [[ "$NEW_MAJOR" -lt "$LATEST_MAJOR" ||
      ("$NEW_MAJOR" -eq "$LATEST_MAJOR" && "$NEW_MINOR" -lt "$LATEST_MINOR") ||
      ("$NEW_MAJOR" -eq "$LATEST_MAJOR" && "$NEW_MINOR" -eq "$LATEST_MINOR" && "$NEW_PATCH" -le "$LATEST_PATCH") ]]; then
    echo "❌ Error: $VERSION is not newer than the latest tag ($LATEST_TAG)."
    exit 1
fi

# Create and push the new tag
git tag "$VERSION"
git push origin "$VERSION"

echo "✅ Successfully created and pushed tag: $VERSION"
