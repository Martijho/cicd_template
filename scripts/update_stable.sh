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

# Get the commit hash of the 'stable' tag, if it exists
current_stable_commit=$(git rev-list -n 1 stable 2>/dev/null)

# If 'stable' tag doesn't exist yet
if [ -z "$current_stable_commit" ]; then
    echo "No 'stable' tag found. Proceeding to create the 'stable' tag."
else
    # Get the commit hash for the provided version
    version_commit=$(git rev-list -n 1 $version)
    
    # Compare the commits, if the stable tag is pointing to an earlier commit
    if [ "$version_commit" != "$current_stable_commit" ]; then
        echo "Current 'stable' tag is pointing to commit $current_stable_commit."
        echo "'$version' tag points to commit $version_commit."

        # Check if the provided version is earlier than the current 'stable' tag
        if git merge-base --is-ancestor $version_commit $current_stable_commit; then
            echo "The provided version is earlier than the current 'stable' tag."
            read -p "Are you sure you want to roll back to this version? (y/N): " confirmation
            if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
                echo "Rollback canceled."
                exit 1
            fi
        fi
    fi
fi

git tag -f stable $version && git push origin stable --force