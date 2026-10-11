#!/usr/bin/env bash
set -euo pipefail

TARGET_FILE="${HOME}/.XCompose"
PROFILE="${HOME}/.profile"
STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/xcompose-ptbr-us-intl"
ORIGINAL_BACKUP="${STATE_DIR}/original.XCompose"
HAD_ORIGINAL="${STATE_DIR}/had_original"

if [[ -f "${HAD_ORIGINAL}" ]]; then
  if [[ "$(cat "${HAD_ORIGINAL}")" == "yes" && -f "${ORIGINAL_BACKUP}" ]]; then
    cp -p "${ORIGINAL_BACKUP}" "${TARGET_FILE}"
    echo "Seu ~/.XCompose original foi restaurado."
  else
    rm -f "${TARGET_FILE}"
    echo "~/.XCompose instalado pelo projeto foi removido."
  fi
else
  echo "Estado da instalação não encontrado; ~/.XCompose não foi alterado."
fi

if [[ -f "${PROFILE}" ]]; then
  python3 - "${PROFILE}" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
block = '\n# xcompose-ptbr-us-intl\nexport XCOMPOSEFILE="$HOME/.XCompose"\n'
if block in text:
    path.write_text(text.replace(block, '\n'))
    print("Entrada do projeto removida de ~/.profile")
PY
fi

rm -rf "${STATE_DIR}"

echo
echo "Desinstalação concluída."
echo "Faça logout e login novamente para garantir que a alteração seja aplicada."
