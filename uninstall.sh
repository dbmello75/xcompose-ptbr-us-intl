#!/usr/bin/env bash
set -euo pipefail

TARGET_FILE="${HOME}/.XCompose"
PROFILE="${HOME}/.profile"

STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/xcompose-ptbr-us-intl"
ORIGINAL_XCOMPOSE="${STATE_DIR}/original.XCompose"
HAD_ORIGINAL_XCOMPOSE="${STATE_DIR}/had_original_xcompose"
ORIGINAL_INPUT_SOURCES="${STATE_DIR}/original-input-sources"

if [[ "${EUID}" -eq 0 ]]; then
  echo "Erro: execute este desinstalador como seu usuário normal, sem sudo."
  exit 1
fi

if [[ -f "${HAD_ORIGINAL_XCOMPOSE}" ]]; then
  if [[ "$(cat "${HAD_ORIGINAL_XCOMPOSE}")" == "yes" && -f "${ORIGINAL_XCOMPOSE}" ]]; then
    cp -p "${ORIGINAL_XCOMPOSE}" "${TARGET_FILE}"
    echo "Seu ~/.XCompose original foi restaurado."
  else
    rm -f "${TARGET_FILE}"
    echo "~/.XCompose instalado pelo projeto foi removido."
  fi
else
  echo "Estado da instalação do ~/.XCompose não encontrado; arquivo não foi alterado."
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

if [[ -f "${ORIGINAL_INPUT_SOURCES}" ]] &&
   command -v gsettings >/dev/null 2>&1 &&
   gsettings list-schemas 2>/dev/null | grep -qx 'org.gnome.desktop.input-sources'; then

  ORIGINAL_SOURCES="$(cat "${ORIGINAL_INPUT_SOURCES}")"

  echo "Restaurando layouts GNOME originais:"
  echo "  ${ORIGINAL_SOURCES}"

  gsettings set org.gnome.desktop.input-sources sources "${ORIGINAL_SOURCES}"

  echo -n "Layout atual: "
  gsettings get org.gnome.desktop.input-sources sources
fi

if command -v ibus >/dev/null 2>&1; then
  ibus restart >/dev/null 2>&1 || true
fi

rm -rf "${STATE_DIR}"

echo
echo "Desinstalação concluída."
echo "Faça logout e login novamente se algum aplicativo continuar usando a configuração anterior."
