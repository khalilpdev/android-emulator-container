#!/usr/bin/env bash
# backup-avd-linux.sh
# Backup de AVDs (Linux/Mint/WSL)
# Uso:
#   ./backup-avd-linux.sh            -> backup de todo ~/.android/avd
#   ./backup-avd-linux.sh <AVD_NAME> -> backup só do AVD especificado
#   ./backup-avd-linux.sh <AVD_NAME> /path/to/backups  -> especifica pasta de destino

set -euo pipefail
AVD_NAME="${1:-}"
# Default backup directory for Linux (dual-boot data partition)
BACKUP_DIR="${2:-/media/leandro/DADOS/avd-backups}"
AVD_ROOT="$HOME/.android/avd"

mkdir -p "$BACKUP_DIR"
TS=$(date +"%Y%m%d-%H%M%S")

if [ ! -d "$AVD_ROOT" ]; then
  echo "AVD root not found: $AVD_ROOT" >&2
  exit 1
fi

if [ -z "$AVD_NAME" ]; then
  ARCHIVE="$BACKUP_DIR/avd-backup-$TS.tar.gz"
  echo "Backing up entire AVD folder: $AVD_ROOT -> $ARCHIVE"
  tar -czf "$ARCHIVE" -C "$AVD_ROOT" .
  echo "Backup created: $ARCHIVE"
  exit 0
fi

AVD_DIR="$AVD_ROOT/${AVD_NAME}.avd"
AVD_INI="$AVD_ROOT/${AVD_NAME}.ini"

if [ ! -d "$AVD_DIR" ] && [ ! -f "$AVD_INI" ]; then
  echo "AVD not found: $AVD_NAME in $AVD_ROOT" >&2
  exit 2
fi

ARCHIVE="$BACKUP_DIR/${AVD_NAME}_backup_$TS.tar.gz"
TMPDIR=$(mktemp -d)

if [ -d "$AVD_DIR" ]; then
  cp -a "$AVD_DIR" "$TMPDIR/"
fi
if [ -f "$AVD_INI" ]; then
  cp -a "$AVD_INI" "$TMPDIR/"
fi

tar -czf "$ARCHIVE" -C "$TMPDIR" .
# generate sha256 checksum file
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" > "${ARCHIVE}.sha256"
  echo "Backup criado: $ARCHIVE"
  echo "Checksum criado: ${ARCHIVE}.sha256"
else
  echo "Backup criado: $ARCHIVE (sha256sum não encontrado, sem checksum)"
fi
rm -rf "$TMPDIR"
exit 0
