#!/bin/bash
# Script to initialize the Docker volume "file-storage" and seed it with images

VOLUME_NAME="srv-dev_file-storage"
SEED_DIR="$(cd "$(dirname "$0")/../seed-files" && pwd)"
TARGET_DIR="/workspace/app/target/storage"

info "=== Initializing Docker volume: $VOLUME_NAME ==="

# Check if the volume already exists
if docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  info "Volume '$VOLUME_NAME' already exists."
else
  info "Creating volume '$VOLUME_NAME'..."
  docker volume create "$VOLUME_NAME"
  info "Volume '$VOLUME_NAME' created successfully."
fi

# Seed the volume with initial files
info "Copying seed files into $VOLUME_NAME:$TARGET_DIR..."
docker run --rm \
  -v $VOLUME_NAME:$TARGET_DIR \
  -v $SEED_DIR:/seed \
  busybox sh -c "mkdir -p $TARGET_DIR && cp /seed/* $TARGET_DIR/"
info "Seed files copied successfully."