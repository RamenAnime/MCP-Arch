# Already on Arch? Install Kyoto Learn OS easily

Use this if Arch is **already installed and working** (VM or bare metal). You do not need to reinstall Arch.

## Before you start (30 seconds)

Run these as your normal user:

```bash
# You need sudo
sudo pacman -Sy

# Confirm you are in wheel
groups
# should list: wheel (among others)

# If not in wheel:
# sudo usermod -aG wheel YOUR_USERNAME
# then log out and back in
```

You need internet (`ping -c1 archlinux.org`).

## Easiest install (recommended)

**Do not run as root.** Run as your everyday user; the script will use `sudo` when needed.

### One command

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh -o easy-install.sh
chmod +x easy-install.sh
./easy-install.sh
```

### Or clone once

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh install/lessons-only.sh
sudo ./mcp-arch.sh
```

## Important prompts for existing Arch

When the installer asks:

| Prompt | What to pick |
|--------|----------------|
| **Install profile** | **3) Desktop only** (skips VM guest tools; keeps your existing Arch setup sensible) |
| **AUR helper** | `yay` unless you already use `paru` |
| **Theme** | `1` green or `2` cyan (your choice) |
| **Proceed?** | `Y` |

Profile 3 still installs the full Kyoto Learn desktop (i3, polybar, lessons, fonts, NetworkManager tools if missing). It does **not** assume a fresh empty Arch install.

## What gets installed on your system

| Component | Notes |
|-----------|--------|
| **pacman packages** | i3, alacritty, polybar, picom, fonts, firefox, jq, pipewire, NetworkManager, etc. |
| **AUR** | yay/paru build if missing; optional `ly`, `i3lock-color` |
| **kyoto-learn** | Full course under `/usr/share/kyoto-learn` |
| **Your configs** | `~/.config/i3`, polybar, picom; old files renamed to `.bak.TIMESTAMP` |

Existing login managers (GDM, SDDM, ly) can coexist. If **ly** is installed, pick the **i3** session at login.

## After install (existing Arch)

```bash
# Health check
system-verify

# Start lessons (any terminal)
kyoto-learn
```

**Graphical session**

1. Log out of your current desktop.
2. Log in again; choose **i3** if ly asks for a session.
3. Or from a TTY: `startx` (uses `~/.xinitrc`).

In i3: **Mod+Shift+J** opens lessons, **Mod+Return** opens the terminal.

No forced reboot on profile 3. Reboot only if you want a clean login session.

## Already using i3 or another desktop?

| Your setup | What happens |
|------------|----------------|
| **No desktop yet** (TTY only) | Perfect. Profile 3 installs i3 + ly. Use `startx` or ly. |
| **Already on i3** | Installer backs up `~/.config/i3/config` then installs Kyoto Learn i3 + polybar. Review diff or restore from `.bak.*` if needed. |
| **GNOME / KDE / Hyprland** | Kyoto Learn adds i3 as another session. Log out and select i3 at ly, or keep your current DE and use lessons in terminal only (see below). |

## Lessons only (no desktop changes)

If you want **only** `kyoto-learn` and not i3/polybar:

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x install/lessons-only.sh
sudo ./install/lessons-only.sh
```

Then run `kyoto-learn` from any terminal on any desktop.

## Updates later

```bash
~/bin/update-system.sh
# or
sudo pacman -Syu && yay -Syu
```

Pull newer curriculum:

```bash
cd MCP-Arch && git pull
sudo ./install/lessons-only.sh
```

## Troubleshooting (existing Arch)

| Issue | Fix |
|-------|-----|
| `yay: command not found` after install | `sudo pacman -S base-devel git` then re-run installer or install yay manually |
| Still boot into old DE | At login pick **i3**, or `sudo systemctl enable ly` and set default session |
| i3 config overwritten | Restore `~/.config/i3/config.bak.*` |
| `kyoto-learn` not found | `sudo ./install/lessons-only.sh` from cloned repo |
| Conflicts with NVIDIA drivers | Install normally; if picom fails, i3 still runs (picom is optional) |

More detail: [INSTALL.md](INSTALL.md), [SYSTEM.md](SYSTEM.md), [COMMANDS.md](COMMANDS.md).
