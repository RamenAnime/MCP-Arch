#!/usr/bin/env bash
# Install only Kyoto Learn curriculum + CLI (no i3/desktop changes).
# For users who already have Arch and their own desktop environment.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=install/lib.sh
source "${SCRIPT_DIR}/install/lib.sh"

if [ "$EUID" -ne 0 ]; then
  SUDO_CMD="sudo"
else
  SUDO_CMD=""
fi

TARGET_USER="${SUDO_USER:-${USER:-}}"
if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
  read -rp "Username to own kyoto-learn files: " TARGET_USER
fi
if ! id "$TARGET_USER" &>/dev/null; then
  echoerr "User not found: $TARGET_USER"
  exit 1
fi
TARGET_HOME="$(eval echo "~${TARGET_USER}")"

echoinfo "Installing lessons only for ${TARGET_USER} (no i3/polybar changes)."

run_pacman jq git

if [ -f "${SCRIPT_DIR}/install/kyoto-learn-setup.sh" ]; then
  bash "${SCRIPT_DIR}/install/kyoto-learn-setup.sh" "$TARGET_USER" "$TARGET_HOME" "$SUDO_CMD" "$SCRIPT_DIR"
else
  echoerr "kyoto-learn-setup.sh missing"
  exit 1
fi

if [ -f "${SCRIPT_DIR}/bin/system-verify" ]; then
  $SUDO_CMD install -m 0755 "${SCRIPT_DIR}/bin/system-verify" /usr/local/bin/system-verify
fi

echoinfo "Done. Run: kyoto-learn"
