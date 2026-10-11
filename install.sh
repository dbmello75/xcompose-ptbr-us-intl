#!/usr/bin/env bash
set -euo pipefail

RAW_BASE_URL="https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main"
TARGET_FILE="${HOME}/.XCompose"
PROFILE="${HOME}/.profile"
STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/xcompose-ptbr-us-intl"
ORIGINAL_BACKUP="${STATE_DIR}/original.XCompose"
HAD_ORIGINAL="${STATE_DIR}/had_original"

command -v curl >/dev/null 2>&1 || {
  echo "Erro: curl não está instalado."
  exit 1
}

mkdir -p "${STATE_DIR}"

# Save the user's original ~/.XCompose only on the first installation.
if [[ ! -f "${HAD_ORIGINAL}" ]]; then
  if [[ -f "${TARGET_FILE}" ]]; then
    cp -p "${TARGET_FILE}" "${ORIGINAL_BACKUP}"
    printf 'yes\n' > "${HAD_ORIGINAL}"
    echo "Backup do ~/.XCompose atual salvo em:"
    echo "  ${ORIGINAL_BACKUP}"
  else
    printf 'no\n' > "${HAD_ORIGINAL}"
  fi
fi

TMP_FILE="$(mktemp)"
trap 'rm -f "${TMP_FILE}"' EXIT

echo "Baixando .XCompose..."
curl -fsSL "${RAW_BASE_URL}/.XCompose" -o "${TMP_FILE}"

if [[ -f "${TARGET_FILE}" ]] && cmp -s "${TMP_FILE}" "${TARGET_FILE}"; then
  echo "~/.XCompose já está atualizado."
else
  install -m 0644 "${TMP_FILE}" "${TARGET_FILE}"
  echo "Instalado em ~/.XCompose"
fi

PROFILE_MARKER="# xcompose-ptbr-us-intl"
PROFILE_EXPORT='export XCOMPOSEFILE="$HOME/.XCompose"'

touch "${PROFILE}"

if ! grep -Fqs "${PROFILE_MARKER}" "${PROFILE}"; then
  cat >> "${PROFILE}" <<'EOF'

# xcompose-ptbr-us-intl
export XCOMPOSEFILE="$HOME/.XCompose"
EOF
  echo "XCOMPOSEFILE adicionado ao ~/.profile"
else
  echo "XCOMPOSEFILE já está configurado pelo projeto no ~/.profile"
fi

echo
echo "Instalação concluída."
echo "Faça logout e login novamente para garantir que a nova configuração seja carregada."
