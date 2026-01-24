#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Build a debug binary, copy it to the repo root, then run it.
swift build >/dev/null
BIN_SRC="$SCRIPT_DIR/.build/debug/MacHardwareInfoCLI"
BIN_DST="$SCRIPT_DIR/MacHardwareInfoCLI"
cp "$BIN_SRC" "$BIN_DST"
exec "$BIN_DST"
