#!/usr/bin/env bash
set -euo pipefail

RAW_BASE_URL="https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main"

TARGET_FILE="${HOME}/.XCompose"
PROFILE="${HOME}/.profile"

STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/xcompose-ptbr-us-intl"
ORIGINAL_XCOMPOSE="${STATE_DIR}/original.XCompose"
HAD_ORIGINAL_XCOMPOSE="${STATE_DIR}/had_original_xcompose"
ORIGINAL_INPUT_SOURCES="${STATE_DIR}/original-input-sources"

PROJECT_MARKER="# xcompose-ptbr-us-intl"

if [[ "${EUID}" -eq 0 ]]; then
  echo "Erro: execute este instalador como seu usuário normal, sem sudo."
  exit 1
fi

command -v curl >/dev/null 2>&1 || {
  echo "Erro: curl não está instalado."
  exit 1
}

mkdir -p "${STATE_DIR}"

echo "xcompose-ptbr-us-intl"
echo "===================="
echo

# ---------------------------------------------------------------------------
# Environment information
# ---------------------------------------------------------------------------

OS_NAME="Linux"
OS_VERSION=""

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  OS_NAME="${PRETTY_NAME:-${NAME:-Linux}}"
  OS_VERSION="${VERSION_ID:-}"
fi

SESSION_TYPE="${XDG_SESSION_TYPE:-unknown}"
DESKTOP="${XDG_CURRENT_DESKTOP:-unknown}"

echo "Ambiente detectado:"
echo "  Sistema : ${OS_NAME}"
echo "  Desktop : ${DESKTOP}"
echo "  Sessão  : ${SESSION_TYPE}"
echo

# ---------------------------------------------------------------------------
# Preserve the user's original ~/.XCompose only on the first installation
# ---------------------------------------------------------------------------

if [[ ! -f "${HAD_ORIGINAL_XCOMPOSE}" ]]; then
  if [[ -f "${TARGET_FILE}" ]]; then
    cp -p "${TARGET_FILE}" "${ORIGINAL_XCOMPOSE}"
    printf 'yes\n' > "${HAD_ORIGINAL_XCOMPOSE}"

    echo "Backup do ~/.XCompose atual salvo em:"
    echo "  ${ORIGINAL_XCOMPOSE}"
  else
    printf 'no\n' > "${HAD_ORIGINAL_XCOMPOSE}"
  fi
fi

# ---------------------------------------------------------------------------
# Download and install .XCompose
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Configure XCOMPOSEFILE
# ---------------------------------------------------------------------------

touch "${PROFILE}"

if ! grep -Fqs "${PROJECT_MARKER}" "${PROFILE}"; then
  cat >> "${PROFILE}" <<'EOF'

# xcompose-ptbr-us-intl
export XCOMPOSEFILE="$HOME/.XCompose"
EOF
  echo "XCOMPOSEFILE adicionado ao ~/.profile"
else
  echo "XCOMPOSEFILE já está configurado pelo projeto no ~/.profile"
fi

export XCOMPOSEFILE="${HOME}/.XCompose"

# ---------------------------------------------------------------------------
# GNOME / Zorin / GSettings keyboard configuration
#
# The project expects US International with dead keys:
#   [('xkb', 'us+intl')]
#
# Save the original input sources once so uninstall.sh can restore them.
# ---------------------------------------------------------------------------

if command -v gsettings >/dev/null 2>&1 &&
   gsettings list-schemas 2>/dev/null | grep -qx 'org.gnome.desktop.input-sources'; then

  CURRENT_SOURCES="$(gsettings get org.gnome.desktop.input-sources sources 2>/dev/null || true)"

  if [[ -n "${CURRENT_SOURCES}" ]]; then
    if [[ ! -f "${ORIGINAL_INPUT_SOURCES}" ]]; then
      printf '%s\n' "${CURRENT_SOURCES}" > "${ORIGINAL_INPUT_SOURCES}"
      echo "Layout de teclado original salvo em:"
      echo "  ${ORIGINAL_INPUT_SOURCES}"
    fi

    DESIRED_SOURCES="[('xkb', 'us+intl')]"

    if [[ "${CURRENT_SOURCES}" == "${DESIRED_SOURCES}" ]]; then
      echo "Layout GNOME já está configurado como US International."
    else
      echo
      echo "Configurando layout GNOME para US International..."
      echo "  Antes : ${CURRENT_SOURCES}"

      gsettings set org.gnome.desktop.input-sources sources "${DESIRED_SOURCES}"

      NEW_SOURCES="$(gsettings get org.gnome.desktop.input-sources sources)"
      echo "  Depois: ${NEW_SOURCES}"
    fi
  else
    echo "Aviso: não foi possível ler os layouts do GNOME via gsettings."
  fi
else
  echo "GSettings/GNOME input sources não encontrados; layout não foi alterado."
fi

# ---------------------------------------------------------------------------
# Restart IBus when available
# ---------------------------------------------------------------------------

if command -v ibus >/dev/null 2>&1; then
  echo
  echo "Reiniciando IBus..."
  if ibus restart >/dev/null 2>&1; then
    echo "IBus reiniciado."
  else
    echo "Aviso: não foi possível reiniciar o IBus automaticamente."
    echo "Isso não impede a instalação; logout/login normalmente resolve."
  fi
else
  echo "IBus não encontrado; nenhuma reinicialização necessária."
fi

echo
echo "Verificação:"
echo "  XCOMPOSEFILE=${XCOMPOSEFILE}"

if command -v gsettings >/dev/null 2>&1 &&
   gsettings list-schemas 2>/dev/null | grep -qx 'org.gnome.desktop.input-sources'; then
  echo -n "  Layout GNOME: "
  gsettings get org.gnome.desktop.input-sources sources 2>/dev/null || true
fi

echo
echo "Instalação concluída."
echo
echo "Teste agora combinações como:"
echo "  ' + c  -> ç"
echo "  ' + a  -> á"
echo "  ~ + a  -> ã"
echo "  ^ + o  -> ô"
echo "  ' + m  -> 'm"
echo
echo "Se algum aplicativo ainda estiver usando a configuração anterior,"
echo "faça logout e login novamente."

# ---------------------------------------------------------------------------
# Optional compatibility report
# ---------------------------------------------------------------------------

INPUT_SOURCES="unknown"
if command -v gsettings >/dev/null 2>&1 &&
   gsettings list-schemas 2>/dev/null | grep -qx 'org.gnome.desktop.input-sources'; then
  INPUT_SOURCES="$(gsettings get org.gnome.desktop.input-sources sources 2>/dev/null || echo unknown)"
fi

IBUS_VERSION="not found"
if command -v ibus >/dev/null 2>&1; then
  IBUS_VERSION="$(ibus version 2>/dev/null || echo installed)"
fi

REPORT_BODY="$(cat <<EOF
## Relatório de compatibilidade

- **Distribuição:** ${OS_NAME}
- **Desktop:** ${DESKTOP}
- **Sessão:** ${SESSION_TYPE}
- **Input sources:** ${INPUT_SOURCES}
- **IBus:** ${IBUS_VERSION}

### Resultado da instalação

- [x] install.sh executado
- [ ] ç / Ç
- [ ] á é í ó ú
- [ ] à
- [ ] â ê ô
- [ ] ã õ
- [ ] apóstrofo + consoante
- [ ] aspas duplas + letra

### Observações

Descreva aqui qualquer comportamento diferente do esperado.
EOF
)"

echo
echo "Ajude a melhorar a tabela de compatibilidade do projeto."
echo "Nenhum dado será enviado automaticamente."
echo "Se você aceitar, será aberta uma Issue do GitHub já preenchida"
echo "com informações técnicas deste ambiente para você revisar e enviar."
echo

if [[ -t 0 ]]; then
  read -r -p "Deseja preparar um relatório de compatibilidade? [s/N] " SEND_REPORT
else
  SEND_REPORT="n"
fi

case "${SEND_REPORT:-n}" in
  s|S|sim|SIM|y|Y|yes|YES)
    ISSUE_URL="$(python3 - "${REPORT_BODY}" <<'PY'
import sys
from urllib.parse import urlencode

body = sys.argv[1]
params = urlencode({
    "title": "Compatibility report",
    "body": body
})
print("https://github.com/dbmello75/xcompose-ptbr-us-intl/issues/new?" + params)
PY
)"

    echo
    echo "Relatório preparado."

    if command -v xdg-open >/dev/null 2>&1; then
      echo "Abrindo o GitHub no navegador..."
      xdg-open "${ISSUE_URL}" >/dev/null 2>&1 || {
        echo "Não foi possível abrir o navegador automaticamente."
        echo "Abra este endereço:"
        echo "${ISSUE_URL}"
      }
    else
      echo "Abra este endereço no navegador:"
      echo "${ISSUE_URL}"
    fi
    ;;
  *)
    echo "Relatório não solicitado."
    ;;
esac
