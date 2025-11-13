#!/bin/bash
#
# MCP-Arch Configuration Installer
# Safe installer for existing i3 installations
# Only applies configurations and themes - no package installation
#
# Usage: ./mcp-configure.sh
#

set -e  # Exit on error

#==========================================
# COLORS
#==========================================
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#==========================================
# BANNER
#==========================================
clear
echo -e "${GREEN}"
cat << "EOF"
███╗   ███╗ ██████╗██████╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
████╗ ████║██╔════╝██╔══██╗    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
██╔████╔██║██║     ██████╔╝    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║╚██╔╝██║██║     ██╔═══╝     ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
██║ ╚═╝ ██║╚██████╗██║         ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
╚═╝     ╚═╝ ╚═════╝╚═╝          ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ 
EOF
echo -e "${RESET}"
echo -e "${CYAN}Configuration Installer - Theme Only${RESET}"
echo -e "${CYAN}Safe for existing i3 installations${RESET}"
echo ""

#==========================================
# CHECKS
#==========================================
echo -e "${GREEN}▶ Performing safety checks...${RESET}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}ERROR: Do not run this script as root!${RESET}"
    echo -e "${YELLOW}Run as your regular user: ./mcp-configure.sh${RESET}"
    exit 1
fi

# Check if on Arch
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}ERROR: This script is for Arch Linux only${RESET}"
    exit 1
fi

# Check if i3 is installed
if ! command -v i3 &> /dev/null; then
    echo -e "${RED}ERROR: i3 is not installed${RESET}"
    echo -e "${YELLOW}Please install i3 first: sudo pacman -S i3-wm${RESET}"
    exit 1
fi

echo -e "${GREEN}✓ Safety checks passed${RESET}"
echo ""

#==========================================
# BACKUP EXISTING CONFIGS
#==========================================
BACKUP_DIR="$HOME/.config/mcp-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${GREEN}▶ Backing up existing configurations...${RESET}"
echo -e "${CYAN}Backup location: $BACKUP_DIR${RESET}"

# Backup existing configs if they exist
[ -f "$HOME/.config/i3/config" ] && cp "$HOME/.config/i3/config" "$BACKUP_DIR/i3-config.bak"
[ -f "$HOME/.Xresources" ] && cp "$HOME/.Xresources" "$BACKUP_DIR/Xresources.bak"
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/zshrc.bak"
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/bashrc.bak"

echo -e "${GREEN}✓ Backups created${RESET}"
echo ""

#==========================================
# COLOR SCHEME SELECTION
#==========================================
echo -e "${GREEN}▶ Select your color scheme:${RESET}"
echo -e "${CYAN}1) MCP Green (Classic terminal green)${RESET}"
echo -e "${CYAN}2) MCP Cyan (Cyberpunk blue/cyan)${RESET}"
echo ""
read -p "Enter choice [1-2]: " COLOR_CHOICE

case $COLOR_CHOICE in
    2)
        THEME="cyan"
        echo -e "${CYAN}Selected: MCP Cyan${RESET}"
        ;;
    *)
        THEME="green"
        echo -e "${GREEN}Selected: MCP Green${RESET}"
        ;;
esac
echo ""

#==========================================
# CREATE DIRECTORIES
#==========================================
echo -e "${GREEN}▶ Creating configuration directories...${RESET}"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/i3status"
mkdir -p "$HOME/.config/polybar"
mkdir -p "$HOME/.config/picom"
mkdir -p "$HOME/.config/neofetch"
mkdir -p "$HOME/.vim/colors"
mkdir -p "$HOME/bin"
echo -e "${GREEN}✓ Directories created${RESET}"
echo ""

#==========================================
# XRESOURCES - MCP GREEN
#==========================================
if [ "$THEME" = "green" ]; then
    echo -e "${GREEN}▶ Installing MCP Green color scheme...${RESET}"
    cat > "$HOME/.Xresources" << 'EOF'
! MCP XRESOURCES - GREEN THEME
! DPI Settings
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault

! MCP GREEN COLOR SCHEME
*.foreground:   #0aff0a
*.background:   #001100
*.cursorColor:  #0aff0a

! Black
*.color0:       #001100
*.color8:       #005500

! Red
*.color1:       #007700
*.color9:       #009900

! Green
*.color2:       #00aa00
*.color10:      #00cc00

! Yellow
*.color3:       #00ff00
*.color11:      #00ff00

! Blue
*.color4:       #00aa00
*.color12:      #00dd00

! Magenta
*.color5:       #007700
*.color13:      #00aa00

! Cyan
*.color6:       #0aff0a
*.color14:      #0aff0a

! White
*.color7:       #00ff00
*.color15:      #66ff66
EOF
fi

#==========================================
# XRESOURCES - MCP CYAN
#==========================================
if [ "$THEME" = "cyan" ]; then
    echo -e "${CYAN}▶ Installing MCP Cyan color scheme...${RESET}"
    cat > "$HOME/.Xresources" << 'EOF'
! MCP XRESOURCES - CYAN THEME
! DPI Settings
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault

! MCP CYAN COLOR SCHEME
*.foreground:   #6fc3df
*.background:   #001520
*.cursorColor:  #6fc3df

! Black
*.color0:       #001520
*.color8:       #2a4a5c

! Red
*.color1:       #1a4a5c
*.color9:       #3a6a7c

! Green
*.color2:       #2e7d9b
*.color10:      #4e9dbb

! Yellow
*.color3:       #6fc3df
*.color11:      #8fd3ef

! Blue
*.color4:       #5eb3d1
*.color12:      #7ed3f1

! Magenta
*.color5:       #4a9db8
*.color13:      #6abdd8

! Cyan
*.color6:       #6fc3df
*.color14:      #8fd3ef

! White
*.color7:       #a0d9ea
*.color15:      #c0f9ff
EOF
fi

# Load Xresources
xrdb -merge "$HOME/.Xresources"
echo -e "${GREEN}✓ Color scheme installed${RESET}"
echo ""

#==========================================
# I3 CONFIGURATION
#==========================================
echo -e "${GREEN}▶ Configuring i3 window manager...${RESET}"

# Set colors based on theme
if [ "$THEME" = "green" ]; then
    FOCUSED_COLOR="#0aff0a"
    BG_COLOR="#001100"
    INACTIVE_COLOR="#007700"
    URGENT_COLOR="#ff0000"
else
    FOCUSED_COLOR="#6fc3df"
    BG_COLOR="#001520"
    INACTIVE_COLOR="#2e7d9b"
    URGENT_COLOR="#ff0000"
fi

# FIX: Escaped i3 variables (e.g., $mod -> \$mod) to prevent shell expansion.
cat > "$HOME/.config/i3/config" << EOF
# i3 config - MCP THEME
# Master Control Program Configuration

###################
# THEME SETTINGS  #
###################

# Set gaps (requires i3-gaps)
gaps inner 10
gaps outer 5
smart_gaps on

# Remove title bars
for_window [class=".*"] border pixel 2
default_border pixel 2

# Colors - MCP $THEME Theme
client.focused          $FOCUSED_COLOR $BG_COLOR $FOCUSED_COLOR $FOCUSED_COLOR $FOCUSED_COLOR
client.focused_inactive $INACTIVE_COLOR $BG_COLOR $INACTIVE_COLOR $INACTIVE_COLOR $INACTIVE_COLOR
client.unfocused        $INACTIVE_COLOR $BG_COLOR $INACTIVE_COLOR $INACTIVE_COLOR $INACTIVE_COLOR
client.urgent           $URGENT_COLOR $BG_COLOR $URGENT_COLOR $URGENT_COLOR $URGENT_COLOR
client.background       $BG_COLOR

###################
# BASIC SETTINGS  #
###################

set \$mod Mod4
font pango:monospace 10
floating_modifier \$mod

###################
# KEYBINDINGS     #
###################

# Start terminal
bindsym \$mod+Return exec i3-sensible-terminal

# Kill window
bindsym \$mod+Shift+q kill

# Start dmenu with theme
bindsym \$mod+d exec dmenu_run -fn 'monospace-12' -nb '$BG_COLOR' -nf '$FOCUSED_COLOR' -sb '$FOCUSED_COLOR' -sf '$BG_COLOR'

# Change focus
bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right
bindsym \$mod+Left focus left
bindsym \$mod+Down focus down
bindsym \$mod+Up focus up
bindsym \$mod+Right focus right

# Move windows
bindsym \$mod+Shift+h move left
bindsym \$mod+Shift+j move down
bindsym \$mod+Shift+k move up
bindsym \$mod+Shift+l move right
bindsym \$mod+Shift+Left move left
bindsym \$mod+Shift+Down move down
bindsym \$mod+Shift+Up move up
bindsym \$mod+Shift+Right move right

# Split
bindsym \$mod+b split h
bindsym \$mod+v split v

# Fullscreen
bindsym \$mod+f fullscreen toggle

# Layout
bindsym \$mod+s layout stacking
bindsym \$mod+w layout tabbed
bindsym \$mod+e layout toggle split

# Float
bindsym \$mod+Shift+space floating toggle
bindsym \$mod+space focus mode_toggle

###################
# WORKSPACES      #
###################

set \$ws1 "1"
set \$ws2 "2"
set \$ws3 "3"
set \$ws4 "4"
set \$ws5 "5"
set \$ws6 "6"
set \$ws7 "7"
set \$ws8 "8"
set \$ws9 "9"
set \$ws10 "10"

bindsym \$mod+1 workspace \$ws1
bindsym \$mod+2 workspace \$ws2
bindsym \$mod+3 workspace \$ws3
bindsym \$mod+4 workspace \$ws4
bindsym \$mod+5 workspace \$ws5
bindsym \$mod+6 workspace \$ws6
bindsym \$mod+7 workspace \$ws7
bindsym \$mod+8 workspace \$ws8
bindsym \$mod+9 workspace \$ws9
bindsym \$mod+0 workspace \$ws10

bindsym \$mod+Shift+1 move container to workspace \$ws1
bindsym \$mod+Shift+2 move container to workspace \$ws2
bindsym \$mod+Shift+3 move container to workspace \$ws3
bindsym \$mod+Shift+4 move container to workspace \$ws4
bindsym \$mod+Shift+5 move container to workspace \$ws5
bindsym \$mod+Shift+6 move container to workspace \$ws6
bindsym \$mod+Shift+7 move container to workspace \$ws7
bindsym \$mod+Shift+8 move container to workspace \$ws8
bindsym \$mod+Shift+9 move container to workspace \$ws9
bindsym \$mod+Shift+0 move container to workspace \$ws10

###################
# I3 CONTROL      #
###################

bindsym \$mod+Shift+c reload
bindsym \$mod+Shift+r restart
bindsym \$mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'"

# Resize mode
mode "resize" {
    bindsym h resize shrink width 10 px or 10 ppt
    bindsym j resize grow height 10 px or 10 ppt
    bindsym k resize shrink height 10 px or 10 ppt
    bindsym l resize grow width 10 px or 10 ppt

    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym \$mod+r mode "resize"

###################
# STARTUP         #
###################

# Load Xresources
exec --no-startup-id xrdb -merge ~/.Xresources

# Start i3bar with custom colors
bar {
    status_command i3status --config ~/.config/i3status/config
    position top

    colors {
        background $BG_COLOR
        statusline $FOCUSED_COLOR
        separator  $INACTIVE_COLOR

        focused_workspace  $FOCUSED_COLOR $FOCUSED_COLOR $BG_COLOR
        active_workspace   $INACTIVE_COLOR $INACTIVE_COLOR $BG_COLOR
        inactive_workspace $BG_COLOR $BG_COLOR $FOCUSED_COLOR
        urgent_workspace   $URGENT_COLOR $URGENT_COLOR $BG_COLOR
    }
}
EOF

echo -e "${GREEN}✓ i3 configuration installed${RESET}"
echo ""

#==========================================
# I3STATUS CONFIGURATION
#==========================================
echo -e "${GREEN}▶ Configuring i3status...${RESET}"

# FIX: Dynamically set color_good based on theme
cat > "$HOME/.config/i3status/config" << EOF
# i3status - MCP Theme

general {
    colors = true
    interval = 1
    color_good = "$FOCUSED_COLOR"
    color_degraded = "#ffff00"
    color_bad = "#ff0000"
}

order += "wireless _first_"
order += "ethernet _first_"
order += "disk /"
order += "memory"
order += "cpu_usage"
order += "tztime local"

wireless _first_ {
    format_up = "W: %essid %quality"
    format_down = "W: down"
}

ethernet _first_ {
    format_up = "E: %ip"
    format_down = "E: down"
}

disk "/" {
    format = "DISK: %percentage_used"
}

memory {
    format = "RAM: %percentage_used"
    threshold_degraded = "10%"
    threshold_critical = "5%"
}

cpu_usage {
    format = "CPU: %usage"
}

tztime local {
    format = "%Y-%m-%d %H:%M:%S"
}
EOF

echo -e "${GREEN}✓ i3status configured${RESET}"
echo ""

#==========================================
# VIM COLORSCHEME
#==========================================
echo -e "${GREEN}▶ Installing Vim colorscheme...${RESET}"

# FIX: Create theme-specific vim colorschemes
if [ "$THEME" = "green" ]; then
cat > "$HOME/.vim/colors/mcp.vim" << 'EOF'
" MCP colorscheme for Vim - GREEN
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "mcp"

" Basic colors
hi Normal         ctermfg=46  ctermbg=0   guifg=#0aff0a guibg=#001100
hi Comment        ctermfg=28  guifg=#007700
hi Constant       ctermfg=82  guifg=#00ff00
hi Identifier     ctermfg=46  guifg=#0aff0a
hi Statement      ctermfg=46  guifg=#0aff0a gui=bold
hi PreProc        ctermfg=82  guifg=#00ff00
hi Type           ctermfg=46  guifg=#0aff0a
hi Special        ctermfg=82  guifg=#00ff00
hi LineNr         ctermfg=28  guifg=#007700
hi CursorLine     ctermbg=233 guibg=#003300
hi Visual         ctermfg=0   ctermbg=28  guifg=#001100 guibg=#007700
EOF
else # Cyan theme
cat > "$HOME/.vim/colors/mcp.vim" << 'EOF'
" MCP colorscheme for Vim - CYAN
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "mcp"

" Basic colors
hi Normal         ctermfg=81  ctermbg=17  guifg=#6fc3df guibg=#001520
hi Comment        ctermfg=31  guifg=#2e7d9b
hi Constant       ctermfg=123 guifg=#8fd3ef
hi Identifier     ctermfg=81  guifg=#6fc3df
hi Statement      ctermfg=81  guifg=#6fc3df gui=bold
hi PreProc        ctermfg=123 guifg=#8fd3ef
hi Type           ctermfg=81  guifg=#6fc3df
hi Special        ctermfg=123 guifg=#8fd3ef
hi LineNr         ctermfg=31  guifg=#2e7d9b
hi CursorLine     ctermbg=234 guibg=#1a4a5c
hi Visual         ctermfg=17  ctermbg=31  guifg=#001520 guibg=#2e7d9b
EOF
fi

echo -e "${GREEN}✓ Vim colorscheme installed${RESET}"
echo ""

#==========================================
# SHELL ALIASES
#==========================================
echo -e "${GREEN}▶ Adding MCP aliases to shell...${RESET}"

# Detect shell
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    # Default to .bashrc if we can't be sure
    SHELL_RC="$HOME/.bashrc"
fi

# Add aliases if not already present
if ! grep -q "# MCP Aliases" "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'EOF'

# MCP Aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias grep='grep --color=auto'
EOF
    echo -e "${GREEN}✓ Shell aliases added to $SHELL_RC${RESET}"
else
    echo -e "${YELLOW}Shell aliases already present${RESET}"
fi
echo ""

#==========================================
# FINISH
#==========================================
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}MCP CONFIGURATION COMPLETE!${RESET}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${CYAN}Applied configurations:${RESET}"
echo -e "  ✓ Color scheme ($THEME)"
echo -e "  ✓ i3 window manager theme"
echo -e "  ✓ i3status theme"
echo -e "  ✓ Vim colorscheme"
echo -e "  ✓ Shell aliases"
echo ""
echo -e "${CYAN}Your original configs backed up to:${RESET}"
echo -e "  ${BACKUP_DIR}"
echo ""
echo -e "${YELLOW}To activate changes:${RESET}"
echo -e "  1. Reload i3: ${GREEN}Mod+Shift+r${RESET}"
echo -e "  2. Open new terminal to see colors"
echo -e "  3. For Vim: ${GREEN}:colorscheme mcp${RESET}"
echo ""
echo -e "${CYAN}Optional next steps:${RESET}"
echo -e "  • Install cool-retro-term: ${GREEN}sudo pacman -S cool-retro-term${RESET}"
echo -e "  • Install polybar: ${GREEN}sudo pacman -S polybar${RESET}"
echo -e "  • Install picom: ${GREEN}sudo pacman -S picom${RESET}"
echo ""
echo -e "${GREEN}MCP System Status: ONLINE${RESET}"
echo -e "${GREEN}Access Level: GRANTED${RESET}"
echo ""
