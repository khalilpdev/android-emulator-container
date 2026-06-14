#!/bin/bash
# run-docker-android-wsl.sh - start interactive docker-android (VNC/noVNC)
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Starting docker-android (web VNC)."
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose -f android-container-docker-compose.yml up -d docker-android
else
  docker-compose -f android-container-docker-compose.yml up -d docker-android
fi

echo "Open http://localhost:6080 in your browser. Connect adb: adb connect 127.0.0.1:5556"
