#!/usr/bin/env bash
# Preflight checks and install profile (VM / physical). Sourced by mcp-arch.sh.

INSTALL_PROFILE="${INSTALL_PROFILE:-}"
REBOOT_AFTER="${REBOOT_AFTER:-no}"
REBOOT_DELAY="${REBOOT_DELAY:-30}"

preflight_run() {
  if [ "$EUID" -ne 0 ]; then
    echowarn "Not running as root; using sudo for system changes."
    SUDO_CMD="sudo"
  else
    SUDO_CMD=""
  fi

  if ! ping -c1 -W3 archlinux.org >/dev/null 2>&1; then
    echoerr "No network. Connect (Wi-Fi: iwctl / nmtui) and retry."
    exit 2
  fi

  if ! grep -qi "arch" /etc/os-release 2>/dev/null; then
    echowarn "This may not be Arch Linux."
    confirm "Continue anyway?" "N" || exit 3
  fi

  # Target user: required for AUR and desktop configs
  if [ "$EUID" -eq 0 ] && [ -z "${SUDO_USER:-}" ]; then
    echo ""
    echoinfo "Enter the normal username for this desktop (not root)."
    read -rp "Username: " TARGET_USER
    if [ -z "$TARGET_USER" ] || ! id "$TARGET_USER" &>/dev/null; then
      echoerr "User '$TARGET_USER' does not exist. Create with: useradd -m -G wheel -s /bin/zsh NAME"
      exit 4
    fi
  else
    TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo "$USER")}"
  fi

  TARGET_HOME="$(eval echo "~${TARGET_USER}")"
  if [ ! -d "$TARGET_HOME" ]; then
    echoerr "Home directory missing for ${TARGET_USER}"
    exit 5
  fi

  echoinfo "Target user: ${TARGET_USER} (${TARGET_HOME})"

  if ! $SUDO_CMD pacman -Sy --noconfirm >/dev/null 2>&1; then
    echoerr "pacman database sync failed."
    exit 6
  fi

  echo ""
  echo "Install profile:"
  echo "  1) Virtual machine (guest tools, safe defaults, no auto-reboot)"
  echo "  2) Physical PC / laptop (firmware, optional GRUB theme)"
  echo "  3) Desktop only (skip guest tools; you already have a base Arch install)"
  read -rp "Profile [1/2/3] (default 1): " _prof
  _prof="${_prof:-1}"
  case "$_prof" in
    2) INSTALL_PROFILE="physical" ; REBOOT_AFTER="ask" ;;
    3) INSTALL_PROFILE="desktop" ; REBOOT_AFTER="no" ;;
    *) INSTALL_PROFILE="vm" ; REBOOT_AFTER="no" ;;
  esac
  echoinfo "Profile: ${INSTALL_PROFILE}"

  read -rp "AUR helper [yay/paru] (default yay): " AUR_HELPER
  AUR_HELPER="${AUR_HELPER:-yay}"
  [[ "$AUR_HELPER" == "yay" || "$AUR_HELPER" == "paru" ]] || AUR_HELPER="yay"

  echo ""
  echo "Theme: 1) Green  2) Cyan"
  read -rp "Theme [1/2] (default 1): " THEME_CHOICE
  THEME_CHOICE="${THEME_CHOICE:-1}"
  [ "$THEME_CHOICE" = "2" ] && THEME="cyan" || THEME="green"

  echo ""
  if ! confirm "Proceed with install?" "Y"; then
    echoerr "Cancelled."
    exit 7
  fi
}
