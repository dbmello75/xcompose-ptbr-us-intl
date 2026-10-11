#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="${SOURCE_DIR}/.XCompose"
TARGET_FILE="${HOME}/.XCompose"
BACKUP_FILE="${HOME}/.XCompose.backup"

if [[ ! -f "${SOURCE_FILE}" ]]; then
  echo "Error: ${SOURCE_FILE} not found."
  exit 1
fi

if [[ -f "${TARGET_FILE}" ]]; then
  cp "${TARGET_FILE}" "${BACKUP_FILE}"
  echo "Existing ~/.XCompose backed up to ~/.XCompose.backup"
fi

cp "${SOURCE_FILE}" "${TARGET_FILE}"
echo "Installed ${SOURCE_FILE} to ${TARGET_FILE}"

if ! grep -qs 'XCOMPOSEFILE="$HOME/.XCompose"' "${HOME}/.profile" 2>/dev/null; then
  cat >> "${HOME}/.profile" <<'EOF'

# Use the custom XCompose file installed by xcompose-ptbr-us-intl
export XCOMPOSEFILE="$HOME/.XCompose"
EOF
  echo 'Added XCOMPOSEFILE to ~/.profile'
else
  echo 'XCOMPOSEFILE is already configured in ~/.profile'
fi

echo
echo "Installation complete."
echo "Log out of your graphical session and log back in for the change to take effect."
