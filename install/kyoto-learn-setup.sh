#!/usr/bin/env bash
# Install Kyoto Learn curriculum and CLI into target system (called from mcp-arch.sh)
set -euo pipefail

echoinfo() { printf "\e[1;36m[INFO]\e[0m %s\n" "$*"; }

TARGET_USER="${1:?target user required}"
TARGET_HOME="${2:?target home required}"
SUDO_CMD="${3:-}"
REPO_ROOT="${4:?repo root required}"

INSTALL_ROOT="/usr/share/kyoto-learn"
BIN_LINK="/usr/local/bin/kyoto-learn"
MOTD_LINK="/usr/local/bin/kyoto-motd"

echoinfo "Installing Kyoto Learn OS to ${INSTALL_ROOT}"

$SUDO_CMD mkdir -p "$INSTALL_ROOT"/{curriculum,lib,bin}
$SUDO_CMD cp -a "${REPO_ROOT}/curriculum/." "$INSTALL_ROOT/curriculum/"
$SUDO_CMD cp -a "${REPO_ROOT}/lib/." "$INSTALL_ROOT/lib/"
$SUDO_CMD cp "${REPO_ROOT}/bin/kyoto-learn" "${REPO_ROOT}/bin/kyoto-motd" "$INSTALL_ROOT/bin/"
$SUDO_CMD chmod +x "$INSTALL_ROOT/bin/"*

$SUDO_CMD ln -sf "$INSTALL_ROOT/bin/kyoto-learn" "$BIN_LINK"
$SUDO_CMD ln -sf "$INSTALL_ROOT/bin/kyoto-motd" "$MOTD_LINK"

# User-local copy for offline edits
USER_COPY="${TARGET_HOME}/kyoto-learn"
$SUDO_CMD rm -rf "$USER_COPY"
$SUDO_CMD cp -a "$INSTALL_ROOT" "$USER_COPY"
$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$USER_COPY"

# Shell login hook
MARKER="# Kyoto Learn OS motd"
ZSHRC="${TARGET_HOME}/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "$MARKER" "$ZSHRC" 2>/dev/null; then
  cat >> "$ZSHRC" <<'ZSHKYOTO'

# Kyoto Learn OS motd
if command -v kyoto-motd >/dev/null 2>&1; then
  kyoto-motd
fi
ZSHKYOTO
  $SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$ZSHRC"
fi

BASHRC="${TARGET_HOME}/.bashrc"
if [ -f "$BASHRC" ] && ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
  cat >> "$BASHRC" <<'BASHKYOTO'

# Kyoto Learn OS motd
if command -v kyoto-motd >/dev/null 2>&1; then
  kyoto-motd
fi
BASHKYOTO
  $SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$BASHRC"
fi

echoinfo "Kyoto Learn installed. Run: kyoto-learn (i3: Mod+Shift+J)"
