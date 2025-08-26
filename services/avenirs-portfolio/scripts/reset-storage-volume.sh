#!/bin/bash
# Script to clear the content of the Docker volume "file-storage"

VOLUME_NAME="srv-dev_file-storage"
TARGET_DIR="/workspace/app/target/storage"

echo "=== Resetting Docker volume: $VOLUME_NAME ==="

# Check if the volume exists
if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  echo "Volume '$VOLUME_NAME' does not exist. Please run init-volumes.sh first."
  exit 1
fi

# Clear the content
docker run --rm -v $VOLUME_NAME:$TARGET_DIR busybox sh -c "rm -rf $TARGET_DIR/*"
echo "All content of volume '$VOLUME_NAME' has been deleted."