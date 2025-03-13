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
if [ -z "$1" ]; then
    echo "No version bump type provided. Use 'patch', 'minor' or 'major'"
    exit 1
else
    BUMP_TYPE="$1"
fi

case "$BUMP_TYPE" in
    major) let MAJOR+=1; MINOR=0; PATCH=0 ;;
    minor) let MINOR+=1; PATCH=0 ;;
    patch) let PATCH+=1 ;;
    *) echo "Invalid bump type: $BUMP_TYPE. Use 'major', 'minor', or 'patch'."; exit 1 ;;
esac

# Create the new version tag
NEW_TAG="v$MAJOR.$MINOR.$PATCH"

echo "Previous version: $LATEST_TAG"
echo "New version:      $NEW_TAG"

read -p "Do you want to create the new tag $NEW_TAG? (Y/n): " -r response
response=${response,,}  # tolower
if [[ "$response" != "y" && "$response" != "" ]]; then
    echo "Tag creation aborted."
    exit 1
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

# Check if it's 'main'
if [ "$current_branch" != "main" ]; then
  echo "You are NOT on the main branch. Current branch: $current_branch"
  exit 1  # Failure
fi

# Confirm and create the tag
git tag "$NEW_TAG"
git push origin "$NEW_TAG"

echo "✅ Successfully created and pushed tag $NEW_TAG"
