#!/bin/bash

# Check if a parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <version_string>"
    exit 1
fi

version="$1"

# Regular expression to match vX.Y.Z where X, Y, and Z are whole numbers
if [[ $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Valid version string."
else
    echo "Invalid version string."
    exit 1
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)
# Check if it's 'main'
if [ "$current_branch" != "main" ]; then
  echo "You are NOT on the main branch. Current branch: $current_branch"
  exit 1  # Failure
fi

# Check if a GitHub release with the tag exists using git CLI
if ! git ls-remote --tags origin | grep -q "refs/tags/$version"; then
    echo "GitHub release with tag $version does not exist."
    exit 1
fi

git tag -f stable $version && git push origin stable --force