#!/bin/bash

# Check if required arguments are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <ECR repository> <version>"
  exit 1
fi

ecr_repository="$1"
version="$2"

# Check if version exists in ECR repository
if ! aws ecr describe-images --repository-name "${ecr_repository}" --image-ids imageTag="${version}" &> /dev/null; then
  echo "Version $version not found in AWS ECR repository $ecr_repository."
  exit 1
fi

echo "Version $version found in AWS ECR repository $ecr_repository."
