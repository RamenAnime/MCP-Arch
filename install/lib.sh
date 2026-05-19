#!/usr/bin/env bash
# Shared installer helpers (sourced by mcp-arch.sh)

echoinfo() { printf "\e[1;36m[INFO]\e[0m %s\n" "$*"; }
echowarn() { printf "\e[1;33m[WARN]\e[0m %s\n" "$*"; }
echoerr() { printf "\e[1;31m[ERROR]\e[0m %s\n" "$*" >&2; }

confirm() {
  local question="${1:-Are you sure?}"
  local default="${2:-Y}"
  local yn
  while true; do
    read -rp "$question [$default/$( [[ $default =~ ^[Yy] ]] && echo N || echo Y )]: " yn
    yn="${yn:-$default}"
    case "$yn" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "Please answer Y or N." ;;
    esac
  done
}

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    echowarn "Backing up $target -> ${target}.bak.${ts}"
    mv "$target" "${target}.bak.${ts}"
  fi
}

run_pacman() {
  # shellcheck disable=SC2068
  $SUDO_CMD pacman -S --needed --noconfirm "$@"
}

enable_user_services() {
  local user="$1"
  if command -v systemctl >/dev/null 2>&1; then
    $SUDO_CMD systemctl enable NetworkManager.service 2>/dev/null || true
    if [ -f /usr/lib/systemd/system/ly.service ]; then
      $SUDO_CMD systemctl enable ly.service 2>/dev/null || true
    fi
  fi
}
