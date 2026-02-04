#!/bin/bash

# Sync imsg-agent folder to remote server
# Usage: ./sync-to-remote.sh

REMOTE_USER="onkay"
REMOTE_HOST="34.1.20.35"
REMOTE_PATH="~/workspace/Mac-Hardware-Info/"
LOCAL_PATH="$(dirname "$0")"

rsync -avz --progress \
    -e "ssh" \
    "$LOCAL_PATH/" \
    "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"

echo "Sync complete!"
