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

echo "Setting up shortcut..."
simple-screen-capture --setup

echo ""
echo "Done. Press Ctrl+Shift+Alt+4 to open the capture panel."
