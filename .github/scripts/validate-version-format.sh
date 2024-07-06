#!/bin/bash

# Check if version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

version="$1"

# Validate version format using regex
if [[ ! "$version" =~ ^v([1-9][0-9]*|0)\.([1-9][0-9]*|0)\.([1-9][0-9]*|0)$ ]]; then
  echo "Invalid version format: $version. Expected format: 'vX.X.X' where X is a non-negative integer without leading 0s."
  exit 1
fi

echo "Version format is valid: $version"
