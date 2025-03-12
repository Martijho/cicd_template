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

git tag -f latest $version && git push origin latest --force