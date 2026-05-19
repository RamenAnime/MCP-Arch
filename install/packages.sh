#!/usr/bin/env bash
# Package installation: pacman core + AUR. Sourced after preflight.

packages_install_core() {
  echoinfo "Installing core system packages (pacman)..."

  CORE_PACKAGES=(
    base-devel git sudo curl wget reflector
    networkmanager network-manager-applet wireless_tools wpa_supplicant
    iwd dhclient
    linux-firmware
    pipewire pipewire-pulse wireplumber
    xorg-server xorg-xinit xorg-xrandr xorg-xsetroot
    i3-wm i3status i3lock dmenu
    alacritty picom polybar feh rofi
    noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu
    firefox vim nano man-db htop btop jq
    polkit gnome-keyring libsecret
    xdg-utils xdg-user-dirs
    rofi
  )

  DESKTOP_PACKAGES=(
    neofetch fastfetch
    zsh zsh-completions
    pulseaudio-alsa pavucontrol
    ranger
    figlet
  )

  VM_PACKAGES=()
  if [ "$INSTALL_PROFILE" = "existing-vm" ]; then
    VM_PACKAGES=(
      open-vm-tools
      qemu-guest-agent
      spice-vdagent
      xf86-video-vmware
      xf86-video-qxl
      virtualbox-guest-utils
    )
  fi

  PHYSICAL_PACKAGES=()

  # Refresh mirrors (best effort)
  if command -v reflector >/dev/null 2>&1; then
    $SUDO_CMD reflector --country US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null \
      || echowarn "reflector failed; using existing mirrors"
  fi

  $SUDO_CMD pacman -Syu --noconfirm
  run_pacman "${CORE_PACKAGES[@]}"
  run_pacman "${DESKTOP_PACKAGES[@]}" || true

  if [ "${#VM_PACKAGES[@]}" -gt 0 ]; then
    echoinfo "Installing VM guest packages (missing ones are OK to skip)..."
    run_pacman "${VM_PACKAGES[@]}" || echowarn "Some VM packages unavailable; skip if not in a VM."
  fi

  if [ "${#PHYSICAL_PACKAGES[@]}" -gt 0 ]; then
    run_pacman "${PHYSICAL_PACKAGES[@]}" || echowarn "Install GRUB manually if you use BIOS/UEFI boot."
  fi

  # Wheel sudo
  if getent group wheel >/dev/null 2>&1 && id -nG "$TARGET_USER" | grep -qw wheel; then
    echoinfo "User ${TARGET_USER} is in wheel (sudo)."
  else
    echowarn "Add ${TARGET_USER} to wheel for sudo: usermod -aG wheel ${TARGET_USER}"
  fi
}

packages_install_aur() {
  echoinfo "Setting up AUR helper (${AUR_HELPER})..."

  run_pacman base-devel git

  install_aur_helper() {
    local helper="$1"
    if command -v "$helper" >/dev/null 2>&1; then
      echoinfo "${helper} already installed."
      return 0
    fi
    echoinfo "Building ${helper} as ${TARGET_USER} (may take a few minutes)..."
    su - "$TARGET_USER" -c "bash -lc '
      set -e
      cd /tmp
      rm -rf \"${helper}\"
      git clone https://aur.archlinux.org/${helper}.git
      cd ${helper}
      makepkg -si --noconfirm --needed
    '" || {
      echoerr "AUR helper ${helper} build failed. Check base-devel and internet."
      return 1
    }
  }

  if [ "$AUR_HELPER" = "paru" ]; then
    install_aur_helper paru || return 1
    AUR_CMD="paru"
  else
    install_aur_helper yay || return 1
    AUR_CMD="yay"
  fi

  AUR_OPTIONAL=(
    ly
    i3lock-color
    ttf-terminus-nerd
  )

  echoinfo "Installing optional AUR packages..."
  su - "$TARGET_USER" -c "bash -lc '${AUR_CMD} -S --needed --noconfirm ${AUR_OPTIONAL[*]}'" \
    || echowarn "Some AUR packages skipped (optional)."

  enable_user_services "$TARGET_USER"

  packages_configure_login_manager

  if [ "$INSTALL_PROFILE" = "existing-vm" ]; then
    $SUDO_CMD systemctl enable vmtoolsd.service 2>/dev/null || true
    $SUDO_CMD systemctl enable qemu-guest-agent.service 2>/dev/null || true
  fi
}

packages_configure_login_manager() {
  local dm active_dm=""
  for dm in gdm sddm lightdm lxdm; do
    if systemctl is-enabled "$dm.service" 2>/dev/null | grep -q enabled; then
      active_dm="$dm"
      break
    fi
  done

  if [ -n "$active_dm" ]; then
    echoinfo "Keeping ${active_dm} as login manager."
    echoinfo "Log out and choose the i3 session, or run startx from a TTY."
    return 0
  fi

  if [ -f /usr/lib/systemd/system/ly.service ]; then
    $SUDO_CMD systemctl enable ly.service 2>/dev/null || true
    echoinfo "Login manager: ly (select i3 at login)"
  else
    echowarn "ly not installed; use startx after login or install ly from AUR."
  fi
}
