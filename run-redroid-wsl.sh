#!/bin/bash
# run-redroid-wsl.sh - start Redroid inside WSL2 (FedoraLinux-43)
# Run inside the distro: ./run-redroid-wsl.sh
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Quick check
./check-kvm.sh || true

echo "Starting Redroid (requires Docker Desktop + WSL2 integration /dev/kvm)..."
# Use docker compose v2 (docker compose) or fallback to docker-compose
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose -f android-container-docker-compose.yml up -d redroid
else
  docker-compose -f android-container-docker-compose.yml up -d redroid
fi

echo "Redroid started. Connect with: adb connect 127.0.0.1:5555"
