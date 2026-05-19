#!/usr/bin/env bash
# Preflight checks and install path. Sourced by mcp-arch.sh.

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
  echo "Kyoto Learn OS installs the FULL desktop (i3, polybar, Japanese lessons, shell immersion)."
  echo ""
  echo "Which situation matches you?"
  echo ""
  echo "  1) I still need to install Arch Linux first"
  echo "     (read docs/INSTALL-FRESH-ARCH.md, then run this installer again)"
  echo ""
  echo "  2) Arch is already installed - full Kyoto Learn desktop (PC or laptop)"
  echo ""
  echo "  3) Arch is already installed in a VM - full desktop + guest tools"
  echo ""
  read -rp "Choice [1/2/3] (default 2): " _path
  _path="${_path:-2}"

  case "$_path" in
    1)
      echo ""
      echoinfo "Install Arch first, then return here for the full Kyoto Learn desktop."
      echo "  Guide: docs/INSTALL-FRESH-ARCH.md"
      echo "  Wiki:  https://wiki.archlinux.org/title/Installation_guide"
      echo ""
      echo "After Arch is ready, run: ./easy-install.sh  (pick 2 or 3)"
      exit 0
      ;;
    3)
      INSTALL_PROFILE="existing-vm"
      REBOOT_AFTER="no"
      ;;
    *)
      INSTALL_PROFILE="existing"
      REBOOT_AFTER="no"
      ;;
  esac

  echoinfo "Profile: ${INSTALL_PROFILE} (full desktop + Japanese integration)"

  read -rp "AUR helper [yay/paru] (default yay): " AUR_HELPER
  AUR_HELPER="${AUR_HELPER:-yay}"
  [[ "$AUR_HELPER" == "yay" || "$AUR_HELPER" == "paru" ]] || AUR_HELPER="yay"

  echo ""
  echo "Theme: 1) Green  2) Cyan"
  read -rp "Theme [1/2] (default 1): " THEME_CHOICE
  THEME_CHOICE="${THEME_CHOICE:-1}"
  [ "$THEME_CHOICE" = "2" ] && THEME="cyan" || THEME="green"

  echo ""
  if ! confirm "Proceed with full Kyoto Learn OS install?" "Y"; then
    echoerr "Cancelled."
    exit 7
  fi
}
