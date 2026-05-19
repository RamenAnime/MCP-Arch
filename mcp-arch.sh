#!/usr/bin/env bash
# Kyoto Learn OS - Arch installer (VM or physical)
# Installs pacman + AUR stack, working i3 UI, and kyoto-learn curriculum.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=install/lib.sh
source "${SCRIPT_DIR}/install/lib.sh"
# shellcheck source=install/preflight.sh
source "${SCRIPT_DIR}/install/preflight.sh"
# shellcheck source=install/packages.sh
source "${SCRIPT_DIR}/install/packages.sh"
# shellcheck source=install/desktop-ui.sh
source "${SCRIPT_DIR}/install/desktop-ui.sh"

preflight_run

packages_install_core
packages_install_aur || echowarn "AUR step had errors; you can install yay/paru manually later."

desktop_install_ui "$SCRIPT_DIR"

# Kyoto Learn curriculum
if [ -f "${SCRIPT_DIR}/install/kyoto-learn-setup.sh" ]; then
  bash "${SCRIPT_DIR}/install/kyoto-learn-setup.sh" "$TARGET_USER" "$TARGET_HOME" "$SUDO_CMD" "$SCRIPT_DIR"
fi

# system-verify in path
if [ -f "${SCRIPT_DIR}/bin/system-verify" ]; then
  $SUDO_CMD install -m 0755 "${SCRIPT_DIR}/bin/system-verify" /usr/local/bin/system-verify
fi

echoinfo "Install complete for user ${TARGET_USER}."
echoinfo "Run: system-verify   then log in and: kyoto-learn"
echo ""
echo "  VM:     log in with ly, or run startx"
echo "  Update: ~/bin/update-system.sh"
echo ""

case "${REBOOT_AFTER:-no}" in
  yes|Y|y)
    if confirm "Reboot now?" "N"; then
      $SUDO_CMD reboot
    fi
    ;;
  ask)
    if confirm "Reboot now? (recommended after first install on hardware)" "Y"; then
      $SUDO_CMD reboot
    fi
    ;;
  *)
    echoinfo "Reboot skipped. Log out and back in (or reboot) before using the graphical session."
    ;;
esac

exit 0
