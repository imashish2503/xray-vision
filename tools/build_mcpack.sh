#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACK_DIR="$ROOT_DIR/packs/xray-vision"

OUT="$ROOT_DIR/xray-vision.mcpack"

if [ ! -d "$PACK_DIR" ]; then
  echo "Pack directory not found at $PACK_DIR"
  exit 1
fi

# Basic sanity checks
if [ ! -f "$PACK_DIR/manifest.json" ]; then
  echo "manifest.json not found in pack directory"
  exit 1
fi

# Create the .mcpack (just a zip with a special extension)
cd "$PACK_DIR"
zip -r "$OUT" . > /dev/null
echo "Built $OUT"