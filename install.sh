#!/usr/bin/env bash
set -euo pipefail

REPO="KerryRitter/simple-screen-capture"
TMP=$(mktemp /tmp/simple-screen-capture-XXXXXX.deb)
trap 'rm -f "$TMP"' EXIT

echo "Downloading simple-screen-capture..."
curl -fsSL "https://github.com/${REPO}/releases/latest/download/$(
  curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
    | grep '"name".*\.deb' | head -1 | sed 's/.*"name": "\(.*\)".*/\1/'
)" -o "$TMP"

echo "Installing..."
sudo apt install -y "$TMP"

if [[ -n "${CAPTURE_CONFIG:-}" ]]; then
  echo "Setting up shortcut..."
  simple-screen-capture --setup-shortcut
  echo "Importing shared R2 config..."
  simple-screen-capture --import-config "$CAPTURE_CONFIG"
else
  echo "Setting up shortcut..."
  simple-screen-capture --setup
fi

echo ""
echo "Done. Press Ctrl+Shift+Alt+4 to open the capture panel."
