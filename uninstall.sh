#!/usr/bin/env bash
set -euo pipefail

TARGET_FILE="${HOME}/.XCompose"
BACKUP_FILE="${HOME}/.XCompose.backup"
PROFILE="${HOME}/.profile"

if [[ -f "${TARGET_FILE}" ]]; then
  rm "${TARGET_FILE}"
  echo "Removed ~/.XCompose"
else
  echo "~/.XCompose was not present."
fi

if [[ -f "${BACKUP_FILE}" ]]; then
  mv "${BACKUP_FILE}" "${TARGET_FILE}"
  echo "Restored previous ~/.XCompose from ~/.XCompose.backup"
fi

if [[ -f "${PROFILE}" ]]; then
  python3 - "${PROFILE}" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
block = '\n# Use the custom XCompose file installed by xcompose-ptbr-us-intl\nexport XCOMPOSEFILE="$HOME/.XCompose"\n'
if block in text:
    path.write_text(text.replace(block, '\n'))
    print("Removed xcompose-ptbr-us-intl entry from ~/.profile")
PY
fi

echo
echo "Uninstall complete."
echo "Log out of your graphical session and log back in for the change to take effect."
