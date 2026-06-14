#!/usr/bin/env bash
# restore-avd-linux.sh
# Restaurar AVDs (Linux / WSL)
# Uso:
#   ./restore-avd-linux.sh /path/to/archive.tar.gz
#   ./restore-avd-linux.sh                    # usa arquivo mais recente em $HOME/Android/avd-backups
#   ./restore-avd-linux.sh /path/to/archive.tar.gz --force

set -euo pipefail
ARCHIVE_PATH="${1:-}"
FORCE=false
if [ "${2:-}" = "--force" ] || [ "${1:-}" = "--force" ]; then FORCE=true; fi
# Default backup directory for Linux (dual-boot data partition)
BACKUP_DIR="${BACKUP_DIR:-/media/leandro/DADOS/avd-backups}"
AVD_ROOT="$HOME/.android/avd"

mkdir -p "$AVD_ROOT"

if [ -z "$ARCHIVE_PATH" ]; then
  if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup dir not found: $BACKUP_DIR" >&2; exit 2
  fi
  ARCHIVE_PATH=$(ls -1t "$BACKUP_DIR"/*.{tar.gz,tgz,zip} 2>/dev/null | head -n1 || true)
  if [ -z "$ARCHIVE_PATH" ]; then
    echo "Nenhum arquivo de backup encontrado em $BACKUP_DIR" >&2; exit 3
  fi
fi

if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "Arquivo de backup não encontrado: $ARCHIVE_PATH" >&2; exit 4
fi

# Verify checksum if present
if [ -f "${ARCHIVE_PATH}.sha256" ]; then
  echo "Verificando checksum ${ARCHIVE_PATH}.sha256..."
  expected=$(cut -d' ' -f1 "${ARCHIVE_PATH}.sha256")
  computed=$(sha256sum "$ARCHIVE_PATH" | cut -d' ' -f1)
  if [ "$expected" != "$computed" ]; then
    echo "Checksum mismatch: ${ARCHIVE_PATH}.sha256 does not match $ARCHIVE_PATH" >&2
    exit 5
  else
    echo "Checksum OK"
  fi
fi

TS=$(date +%Y%m%d-%H%M%S)
TMPDIR=$(mktemp -d -t avd_restore_${TS}_XXXX)

echo "Extraindo $ARCHIVE_PATH para $TMPDIR..."
case "$ARCHIVE_PATH" in
  *.zip) unzip -q "$ARCHIVE_PATH" -d "$TMPDIR" ;;
  *.tar.gz|*.tgz) tar -xzf "$ARCHIVE_PATH" -C "$TMPDIR" ;;
  *) echo "Formato de arquivo não suportado" >&2; rm -rf "$TMPDIR"; exit 5 ;;
esac

shopt -s nullglob
for entry in "$TMPDIR"/*; do
  name=$(basename "$entry")
  if [[ -d "$entry" && "$name" == *.avd ]]; then
    dest="$AVD_ROOT/$name"
    if [[ -d "$dest" && "$FORCE" != "true" ]]; then
      read -p "AVD '$name' já existe. Sobrescrever? (y/N) " ans
      [[ "$ans" =~ ^[Yy]$ ]] || { echo "Pulando $name"; continue; }
    fi
    rm -rf "$dest" || true
    echo "Copiando $name -> $dest"
    cp -a "$entry" "$dest"
  elif [[ -f "$entry" && "$name" == *.ini ]]; then
    destIni="$AVD_ROOT/$name"
    if [[ -f "$destIni" && "$FORCE" != "true" ]]; then
      read -p "Arquivo ini '$name' já existe. Sobrescrever? (y/N) " ans
      [[ "$ans" =~ ^[Yy]$ ]] || { echo "Pulando $name"; continue; }
    fi
    cp -a "$entry" "$destIni"
    echo "Restaurado $name -> $destIni"
  fi
done

rm -rf "$TMPDIR"
echo "Restauração concluída. Verifique com: emulator -list-avds ou abra o AVD Manager." 
exit 0
