#!/usr/bin/env bash
# MCP Arch Linux Interactive Installer
# Creates an Arch-based MCP themed environment (i3-gaps, cool-retro-term, picom, polybar, ly, etc.)
# Designed to be run on a fresh Arch install (as root or via sudo).
# WARNING: This script will install packages and modify user config files.
# Always review before running. Use at your own risk.

set -euo pipefail
IFS=$'\n\t'

# ---------- Helper functions ----------
echoinfo(){ printf "\e[1;36m[INFO]\e[0m %s\n" "$*"; }
echowarn(){ printf "\e[1;33m[WARN]\e[0m %s\n" "$*"; }
echoerr(){ printf "\e[1;31m[ERROR]\e[0m %s\n" "$*" >&2; }

confirm() {
  # confirm "Question" default
  local question="${1:-Are you sure?}"
  local default="${2:-Y}"
  local yn
  while true; do
    read -rp "$question [$default/$( [[ $default =~ ^[Yy] ]] && echo N || echo Y )]: " yn
    yn="${yn:-$default}"
    case "$yn" in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer Y or N.";;
    esac
  done
}

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    echowarn "Backing up existing $target -> ${target}.bak.${ts}"
    mv "$target" "${target}.bak.${ts}"
  fi
}

# ---------- Environment detection ----------
if [ "$EUID" -ne 0 ]; then
  echowarn "This script is not running as root. It will use sudo where necessary."
  SUDO_CMD="sudo"
else
  SUDO_CMD=""
fi

TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo root)}"
if [ -z "$TARGET_USER" ]; then
  TARGET_USER="root"
fi
TARGET_HOME="$(eval echo "~${TARGET_USER}")"
if [ ! -d "$TARGET_HOME" ]; then
  echoerr "Cannot determine home directory for user ${TARGET_USER}."
  exit 1
fi

echoinfo "Target user: ${TARGET_USER} (home: ${TARGET_HOME})"

# Check network connectivity
if ! ping -c1 -W2 archlinux.org >/dev/null 2>&1; then
  echoerr "No network connectivity to archlinux.org detected. Please ensure internet and try again."
  exit 2
fi

# Confirm it's Arch
if ! grep -qi "arch" /etc/os-release >/dev/null 2>&1; then
  echowarn "This doesn't look like Arch Linux (or derivative). Continue anyway?"
  if ! confirm "Proceed on non-Arch system?" "N"; then
    echoerr "Aborting."
    exit 3
  fi
fi

# ---------- Interactive choices ----------
# AUR helper choice (yay default)
read -rp "Choose AUR helper [yay/paru] (default: yay): " AUR_HELPER
AUR_HELPER="${AUR_HELPER:-yay}"
if [[ "$AUR_HELPER" != "yay" && "$AUR_HELPER" != "paru" ]]; then
  echowarn "Invalid choice, defaulting to yay."
  AUR_HELPER="yay"
fi

# Window manager: fixed to i3-gaps per preference
WM_CHOICE="i3-gaps"
echoinfo "Window manager set to: ${WM_CHOICE}"

# Theme choice
echo ""
echo "Choose theme color:"
echo "  1) MCP Green (default)"
echo "  2) Cyan/Blue"
read -rp "Select theme [1/2] (default: 1): " THEME_CHOICE
THEME_CHOICE="${THEME_CHOICE:-1}"

case "$THEME_CHOICE" in
  2) THEME="cyan";;
  *) THEME="green";;
esac
echoinfo "Selected theme: ${THEME}"

# Extras install: yes by default (per user's request)
INSTALL_EXTRAS="yes"
echoinfo "Extras (figlet, lolcat, cowsay, etc.) will be installed."

# Auto-install & enable ly
AUTO_ENABLE_LY="yes"
echoinfo "ly will be installed and enabled."

# Reboot preference: reboot with 60s timer
REBOOT_AFTER="yes"
REBOOT_DELAY=60

echo ""
if ! confirm "Proceed with installation? This will install packages and modify configs." "Y"; then
  echoerr "User cancelled."
  exit 4
fi

# ---------- Package lists ----------
BASE_PACKAGES=(
  xorg-server xorg-xinit xorg-xrandr
  "${WM_CHOICE}" i3status i3lock dmenu
  cool-retro-term alacritty picom polybar feh
  neofetch htop cmatrix pipes.sh figlet lolcat sl cowsay fortune-mod inxi screenfetch
  iftop nethogs nmap wireshark-cli cava
  ttf-terminus-nerd ttf-ibm-plex ttf-dejavu terminus-font
  ranger mpd ncmpcpp firefox vim neovim gotop bashtop pulseaudio pulseaudio-alsa pavucontrol
  plymouth archiso grub
  zsh zsh-completions
)

AUR_PACKAGES=(
  ttf-vga-font ttf-oldschool-pc-font ttf-commodore-64 plymouth-theme-hexagon-hud grub-theme-vimix i3lock-color ly
)

# Add polybar dependencies if missing (polybar installed from pacman on Arch)
# Extras (already requested)
EXTRA_PACKAGES=(figlet lolcat cowsay)

# ---------- Install pacman packages ----------
echoinfo "Refreshing pacman database and installing packages. You may be prompted for your password for sudo."
$SUDO_CMD pacman -Syu --noconfirm

if ! $SUDO_CMD pacman -S --noconfirm "${BASE_PACKAGES[@]}" ; then
  echoerr "pacman install failed. Aborting."
  exit 5
fi

# ---------- Install AUR helper (yay or paru) ----------
install_yay() {
  if command -v yay >/dev/null 2>&1; then
    echoinfo "yay already installed."
    return 0
  fi
  echoinfo "Installing yay as ${TARGET_USER}..."
  su - "$TARGET_USER" -c "bash -lc 'cd /tmp && rm -rf yay && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm'"
}

install_paru() {
  if command -v paru >/dev/null 2>&1; then
    echoinfo "paru already installed."
    return 0
  fi
  echoinfo "Installing paru as ${TARGET_USER}..."
  su - "$TARGET_USER" -c "bash -lc 'cd /tmp && rm -rf paru && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm'"
}

if [ "$AUR_HELPER" = "yay" ]; then
  install_yay
  AUR_CMD="yay -S --noconfirm"
else
  install_paru
  AUR_CMD="paru -S --noconfirm"
fi

# Install AUR packages
echoinfo "Installing AUR packages: ${AUR_PACKAGES[*]}"
su - "$TARGET_USER" -c "bash -lc '${AUR_CMD} ${AUR_PACKAGES[*]}'"

# Install extras
if [ "$INSTALL_EXTRAS" = "yes" ]; then
  $SUDO_CMD pacman -S --noconfirm "${EXTRA_PACKAGES[@]}" || echowarn "Extras installation failed or some extras missing in repos."
fi

# ---------- Config files creation (back up if exist) ----------
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# cool-retro-term config
CRT_DIR="${TARGET_HOME}/.config/cool-retro-term"
$SUDO_CMD mkdir -p "$CRT_DIR"
backup_if_exists "${CRT_DIR}/cool-retro-term.json"
cat > "${CRT_DIR}/cool-retro-term.json" <<'CRTJSON'
{
    "ambientLight": 0.2,
    "backgroundColor": "#000000",
    "bloom": 0.4,
    "brightness": 0.5,
    "burnIn": 0.45,
    "chromaColor": 0,
    "contrast": 0.85,
    "flickering": 0.1,
    "fontColor": "#0aff0a",
    "fontName": "TERMINUS_SCALED",
    "fontSize": 12,
    "glowingLine": 0.2,
    "horizontalSync": 0.14,
    "jitter": 0.18,
    "profile": "MCP_GREEN",
    "rasterization": 0,
    "rbgShift": 0,
    "saturationColor": 0,
    "scanlineIntensity": 0.4,
    "staticNoise": 0.05,
    "verticalSync": 0.01
}
CRTJSON

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$CRT_DIR"

# Xresources color scheme (choose based on theme)
XRES_FILE="${TARGET_HOME}/.Xresources"
backup_if_exists "$XRES_FILE"

if [ "$THEME" = "cyan" ]; then
  cat > "$XRES_FILE" <<'XRES'
*.foreground:   #6fc3df
*.background:   #001520
*.cursorColor:  #6fc3df
*.color0:       #001520
*.color1:       #1a4a5c
*.color2:       #2e7d9b
*.color3:       #6fc3df
*.color4:       #5eb3d1
*.color5:       #4a9db8
*.color6:       #6fc3df
*.color7:       #a0d9ea
XRES
else
  cat > "$XRES_FILE" <<'XRES'
*.foreground:   #0aff0a
*.background:   #001100
*.cursorColor:  #0aff0a
*.color0:       #001100
*.color1:       #007700
*.color2:       #00aa00
*.color3:       #00ff00
*.color4:       #00aa00
*.color5:       #007700
*.color6:       #0aff0a
*.color7:       #00ff00
*.color8:       #005500
*.color9:       #009900
*.color10:      #00cc00
*.color11:      #00ff00
*.color12:      #00dd00
*.color13:      #00aa00
*.color14:      #0aff0a
*.color15:      #66ff66
XRES
fi

$SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$XRES_FILE"

# neofetch config
NEOFETCH_DIR="${TARGET_HOME}/.config/neofetch"
$SUDO_CMD mkdir -p "$NEOFETCH_DIR"
backup_if_exists "${NEOFETCH_DIR}/config.conf"
cat > "${NEOFETCH_DIR}/config.conf" <<'NEOCONF'
print_info() {
    info "██ MCP SYSTEM ██" title
    info "━━━━━━━━━━━━━━━━━━━━━━" line
    info "HOST" model
    info "SYSTEM" distro
    info "KERNEL" kernel
    info "UPTIME" uptime
    info "SHELL" shell
    info "TERMINAL" term
    info "CPU" cpu
    info "MEMORY" memory
    prin "━━━━━━━━━━━━━━━━━━━━━━"
    prin "STATUS: ACTIVE"
}
ascii_distro="arch"
ascii_colors=(2 2 2 2 2 2)
NEOCONF

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$NEOFETCH_DIR"

# i3 config
I3_DIR="${TARGET_HOME}/.config/i3"
$SUDO_CMD mkdir -p "$I3_DIR"
backup_if_exists "${I3_DIR}/config"
cat > "${I3_DIR}/config" <<'I3CFG'
gaps inner 10
gaps outer 5
smart_gaps on
for_window [class=".*"] border pixel 2
client.focused          #0aff0a #001100 #0aff0a #00ff00
client.focused_inactive #007700 #001100 #007700 #007700
client.unfocused        #003300 #001100 #003300 #003300
client.urgent           #ff0000 #001100 #ff0000 #ff0000
set $mod Mod4
exec --no-startup-id cool-retro-term
exec --no-startup-id feh --bg-scale ~/Pictures/mcp-wallpaper.jpg
exec --no-startup-id picom --config ~/.config/picom/picom.conf
exec_always --no-startup-id ~/.config/polybar/launch.sh
bindsym $mod+Return exec cool-retro-term
bindsym $mod+d exec dmenu_run -fn 'Terminus-12' -nb '#001100' -nf '#0aff0a' -sb '#0aff0a' -sf '#001100'
I3CFG

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$I3_DIR"

# polybar config
POLY_DIR="${TARGET_HOME}/.config/polybar"
$SUDO_CMD mkdir -p "$POLY_DIR"
backup_if_exists "${POLY_DIR}/config.ini"
cat > "${POLY_DIR}/config.ini" <<'POLY'
[bar/mcp]
width = 100%
height = 30
background = #001100
foreground = #0aff0a
border-size = 2
border-color = #0aff0a
font-0 = "Terminus:size=10;2"
font-1 = "Font Awesome 6 Free:style=Solid:size=10;2"
modules-left = i3
modules-center = date
modules-right = cpu memory network
[module/i3]
type = internal/i3
format = <label-state>
label-focused = %name%
label-focused-background = #0aff0a
label-focused-foreground = #001100
label-focused-padding = 2
label-unfocused-padding = 2
[module/date]
type = internal/date
interval = 1
date = %Y-%m-%d
time = %H:%M:%S
label = ▶ %date% %time% ◀
POLY

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$POLY_DIR"

# picom config
PICOM_DIR="${TARGET_HOME}/.config/picom"
$SUDO_CMD mkdir -p "$PICOM_DIR"
backup_if_exists "${PICOM_DIR}/picom.conf"
cat > "${PICOM_DIR}/picom.conf" <<'PIC'
backend = "glx";
vsync = true;
inactive-opacity = 0.9;
active-opacity = 0.95;
frame-opacity = 0.9;
shadow = true;
shadow-radius = 12;
shadow-opacity = 0.75;
shadow-offset-x = -7;
shadow-offset-y = -7;
fading = true;
fade-delta = 4;
fade-in-step = 0.03;
fade-out-step = 0.03;
PIC

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$PICOM_DIR"

# vim colorscheme
VIM_DIR="${TARGET_HOME}/.vim/colors"
$SUDO_CMD mkdir -p "$VIM_DIR"
backup_if_exists "${VIM_DIR}/mcp.vim"
cat > "${VIM_DIR}/mcp.vim" <<'VIMC'
set background=dark
highlight Normal ctermfg=46 ctermbg=0 guifg=#0aff0a guibg=#001100
highlight Comment ctermfg=28 guifg=#007700
highlight Constant ctermfg=82 guifg=#00ff00
highlight Identifier ctermfg=46 guifg=#0aff0a
highlight Statement ctermfg=46 guifg=#0aff0a gui=bold
highlight PreProc ctermfg=82 guifg=#00ff00
VIMC

$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "$VIM_DIR"

# i3 lock script
LOCK_SCRIPT="${I3_DIR}/lock.sh"
backup_if_exists "$LOCK_SCRIPT"
cat > "$LOCK_SCRIPT" <<'LOCK'
#!/bin/bash
i3lock -i ~/Pictures/wallpapers/mcp-lock.png \
  --insidecolor=00110000 \
  --ringcolor=0aff0aff \
  --linecolor=00000000 \
  --keyhlcolor=00ff00ff \
  --ringvercolor=0aff0aff \
  --separatorcolor=00000000 \
  --insidevercolor=00110000 \
  --ringwrongcolor=ff0000ff \
  --insidewrongcolor=00110000 \
  --timecolor=0aff0aff \
  --datecolor=0aff0aff \
  --time-str="%H:%M:%S" \
  --date-str="%Y-%m-%d" \
  --veriftext="ACCESS GRANTED" \
  --wrongtext="ACCESS DENIED"
LOCK

$SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$LOCK_SCRIPT"
$SUDO_CMD chmod +x "$LOCK_SCRIPT"

# feh wallpaper dir
$SUDO_CMD mkdir -p "${TARGET_HOME}/Pictures/wallpapers"
$SUDO_CMD chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/Pictures"

# zshrc additions (append)
ZSHRC_FILE="${TARGET_HOME}/.zshrc"
if [ ! -e "$ZSHRC_FILE" ]; then
  cat > "$ZSHRC_FILE" <<'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_COLOR_SCHEME='dark'
alias matrix='cmatrix -bas -C green'
alias systeminfo='neofetch'
alias mcp='neofetch'
alias grid='pipes.sh -t 1 -R -r 0'
clear
echo "\033[1;32m"
figlet -f banner "MCP SYSTEM"
echo "\033[0;32m"
echo "Master Control Program - ONLINE"
echo "System Status: OPERATIONAL"
echo "User: $(whoami)"
echo "Access Level: ROOT"
echo ""
neofetch
ZSHRC
  $SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$ZSHRC_FILE"
else
  echowarn "$ZSHRC_FILE already exists; appending MCP aliases and startup message."
  cat >> "$ZSHRC_FILE" <<'ZSHAPP'
# MCP additions
alias matrix='cmatrix -bas -C green'
alias systeminfo='neofetch'
alias mcp='neofetch'
alias grid='pipes.sh -t 1 -R -r 0'
# MCP welcome banner
clear
echo "\033[1;32m"
figlet -f banner "MCP SYSTEM"
echo "\033[0;32m"
echo "Master Control Program - ONLINE"
neofetch
ZSHAPP
fi

$SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "$ZSHRC_FILE"

# Install oh-my-zsh and powerlevel10k for target user
echoinfo "Installing Oh-My-Zsh and Powerlevel10k for ${TARGET_USER}..."
su - "${TARGET_USER}" -c "bash -lc 'export RUNZSH=no; sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" || true'"
su - "${TARGET_USER}" -c "bash -lc 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \"\${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k\" || true'"

# Plymouth theme and GRUB tweaks (best-effort; user should verify)
echoinfo "Configuring Plymouth theme and GRUB (best-effort; please verify /boot contents manually)."
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  $SUDO_CMD plymouth-set-default-theme -R hexagon-hud || echowarn "plymouth theme set failed"
else
  echowarn "plymouth-set-default-theme not found; skipping"
fi

# Install and enable ly
echoinfo "Installing and enabling ly login manager..."
# ly installed from AUR_PACKAGES earlier via AUR helper; enable it
$SUDO_CMD systemctl enable ly.service || echowarn "Failed to enable ly.service. You may need to enable it manually."

# Update grub config if grub installed
if command -v grub-mkconfig >/dev/null 2>&1; then
  echoinfo "Updating GRUB config..."
  # append theme lines if not present
  if ! grep -q "GRUB_THEME=" /etc/default/grub 2>/dev/null; then
    $SUDO_CMD bash -c "echo 'GRUB_THEME=\"/usr/share/grub/themes/vimix/theme.txt\"' >> /etc/default/grub"
  fi
  $SUDO_CMD grub-mkconfig -o /boot/grub/grub.cfg || echowarn "grub-mkconfig failed; check /boot/grub"
fi

# Create update script
mkdir -p "${TARGET_HOME}/bin"
cat > "${TARGET_HOME}/bin/update-system.sh" <<'UPD'
#!/bin/bash
clear
echo -e "\033[1;32m"
figlet "MCP SYSTEM UPDATE"
echo -e "\033[0;32m"
echo "Initiating system synchronization..."
sudo pacman -Syu
echo "Checking for orphaned packages..."
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || true
echo "System update complete. MCP status: OPTIMAL"
UPD
$SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/bin/update-system.sh"
$SUDO_CMD chmod +x "${TARGET_HOME}/bin/update-system.sh"

# One-command setup file already written to user's home for review
cat > "${TARGET_HOME}/mcp-setup.sh" <<'MSH'
#!/bin/bash
echo "This file was generated by the MCP installer. Most actions are already performed."
echo "You can review the configs in ~/.config and run ~/bin/update-system.sh to update the system."
MSH
$SUDO_CMD chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/mcp-setup.sh"
$SUDO_CMD chmod +x "${TARGET_HOME}/mcp-setup.sh"

# Final messages
echoinfo "MCP installation steps completed. Some actions may require manual verification (themes, plymouth, grub)."
echoinfo "Configs are placed in ${TARGET_HOME}/.config and backed-up copies (if any) were renamed with .bak.TIMESTAMP"

# Offer reboot with 60s countdown
if [ "$REBOOT_AFTER" = "yes" ]; then
  echo
  echo "System will reboot in ${REBOOT_DELAY} seconds. Press Ctrl-C to cancel."
  echo "Or run 'sudo reboot' to reboot immediately."
  for i in $(seq $REBOOT_DELAY -1 1); do
    printf "\rRebooting in %3d seconds... " "$i"
    sleep 1
  done
  echo
  $SUDO_CMD reboot
else
  echoinfo "Reboot skipped. Please reboot manually to apply some changes."
fi

exit 0
