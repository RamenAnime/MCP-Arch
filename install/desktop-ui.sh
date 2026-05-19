#!/usr/bin/env bash
# Desktop UI: i3, polybar, picom, wallpaper, xinit. Sourced by mcp-arch.sh.

desktop_install_ui() {
  local repo_root="$1"
  local fg bg inactive urgent
  if [ "$THEME" = "cyan" ]; then
    fg="#6fc3df" bg="#001520" inactive="#2e7d9b" urgent="#ff5555"
  else
    fg="#0aff0a" bg="#001100" inactive="#007700" urgent="#ff5555"
  fi

  echoinfo "Installing desktop UI configs (${THEME})..."

  # Wallpaper (solid color, no missing image files)
  $SUDO_CMD mkdir -p "${TARGET_HOME}/Pictures/wallpapers"
  $SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/Pictures"

  # Xresources
  backup_if_exists "${TARGET_HOME}/.Xresources"
  if [ "$THEME" = "cyan" ]; then
    cat > "${TARGET_HOME}/.Xresources" <<'XRES'
*.foreground: #6fc3df
*.background: #001520
*.cursorColor: #6fc3df
XRES
  else
    cat > "${TARGET_HOME}/.Xresources" <<'XRES'
*.foreground: #0aff0a
*.background: #001100
*.cursorColor: #0aff0a
XRES
  fi
  $SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.Xresources"

  # i3 (backup existing configs before replace)
  local i3_dir="${TARGET_HOME}/.config/i3"
  $SUDO_CMD mkdir -p "$i3_dir"
  backup_if_exists "${i3_dir}/config"
  backup_if_exists "${i3_dir}/lock.sh"
  if [ -f "${repo_root}/config/i3/config" ]; then
    $SUDO_CMD cp "${repo_root}/config/i3/config" "${i3_dir}/config"
    $SUDO_CMD sed -i "s/@FG@/${fg}/g; s/@BG@/${bg}/g; s/@INACTIVE@/${inactive}/g; s/@URGENT@/${urgent}/g" "${i3_dir}/config"
    $SUDO_CMD cp "${repo_root}/config/i3/lock.sh" "${i3_dir}/lock.sh"
    $SUDO_CMD chmod +x "${i3_dir}/lock.sh"
  else
    echoerr "Missing config/i3/config in repo"
    return 1
  fi

  # polybar
  local poly_dir="${TARGET_HOME}/.config/polybar"
  $SUDO_CMD mkdir -p "$poly_dir"
  backup_if_exists "${poly_dir}/config.ini"
  backup_if_exists "${poly_dir}/launch.sh"
  $SUDO_CMD cp "${repo_root}/config/polybar/config.ini" "${poly_dir}/config.ini"
  $SUDO_CMD cp "${repo_root}/config/polybar/launch.sh" "${poly_dir}/launch.sh"
  $SUDO_CMD sed -i "s/@FG@/${fg}/g; s/@BG@/${bg}/g" "${poly_dir}/config.ini"
  $SUDO_CMD chmod +x "${poly_dir}/launch.sh"

  # picom
  $SUDO_CMD mkdir -p "${TARGET_HOME}/.config/picom"
  $SUDO_CMD cp "${repo_root}/config/picom/picom.conf" "${TARGET_HOME}/.config/picom/picom.conf" 2>/dev/null \
    || cat > "${TARGET_HOME}/.config/picom/picom.conf" <<'PIC'
backend = "glx";
vsync = true;
fading = true;
PIC

  # Fallback startx
  if [ ! -f "${TARGET_HOME}/.xinitrc" ]; then
    cat > "${TARGET_HOME}/.xinitrc" <<'XINIT'
#!/bin/sh
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
exec i3
XINIT
    $SUDO_CMD chmod +x "${TARGET_HOME}/.xinitrc"
  fi

  # Default shell zsh if installed
  if command -v zsh >/dev/null 2>&1; then
    $SUDO_CMD chsh -s /bin/zsh "$TARGET_USER" 2>/dev/null || true
  fi

  # Minimal zshrc if missing
  if [ ! -f "${TARGET_HOME}/.zshrc" ]; then
    cat > "${TARGET_HOME}/.zshrc" <<'ZSH'
export PATH="$HOME/bin:$PATH"
alias learn='kyoto-learn'
[ -f ~/.zshrc.kyoto ] && source ~/.zshrc.kyoto
ZSH
  fi
  if ! grep -q "kyoto-motd" "${TARGET_HOME}/.zshrc" 2>/dev/null; then
    cat >> "${TARGET_HOME}/.zshrc" <<'ZSHM'

# Kyoto Learn OS
command -v kyoto-motd >/dev/null 2>&1 && kyoto-motd
ZSHM
  fi

  $SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.config" "${TARGET_HOME}/.xinitrc" "${TARGET_HOME}/.zshrc" 2>/dev/null || true

  # Update script
  $SUDO_CMD mkdir -p "${TARGET_HOME}/bin"
  cat > "${TARGET_HOME}/bin/update-system.sh" <<'UPD'
#!/bin/bash
set -e
echo "Syncing pacman..."
sudo pacman -Syu
if command -v yay >/dev/null 2>&1; then
  yay -Syu --noconfirm
elif command -v paru >/dev/null 2>&1; then
  paru -Syu --noconfirm
fi
echo "Done."
UPD
  $SUDO_CMD chmod +x "${TARGET_HOME}/bin/update-system.sh"
  $SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/bin/update-system.sh"
}
