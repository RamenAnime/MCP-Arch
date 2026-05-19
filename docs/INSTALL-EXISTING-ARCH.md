# Path 2: Arch already installed - full Kyoto Learn desktop

Use this when **Arch Linux is already running** on your machine (VM or bare metal). You want the **complete Kyoto Learn OS experience**: new desktop UI, Japanese integration, lessons, and immersion. You are **not** installing a small add-on only.

You do **not** need to reinstall Arch.

---

## What changes on your system

The installer adds the full stack. It does **not** remove pacman, your home files, or other Linux installs.

| Layer | What happens |
|-------|----------------|
| **Packages** | Installs i3, alacritty, polybar, picom, fonts, firefox, jq, audio, NetworkManager tools (skips packages already installed) |
| **AUR** | Installs or uses yay/paru; optional ly and i3lock-color |
| **Desktop UI** | Replaces **only** Kyoto Learn config files; backups saved as `.bak.TIMESTAMP` |
| **Login** | If you use GDM, SDDM, or LightDM, they are **kept**. Enable **ly** only when no other login manager is active |
| **Japanese** | `kyoto-learn`, `kyoto-motd`, curriculum under `/usr/share/kyoto-learn` |
| **Your data** | Documents, SSH keys, and other home files are **not** deleted |

### What a "total desktop experience change" means here

- You **log into i3** (Kyoto Learn layout) instead of GNOME/KDE for daily use, **or** you keep your old desktop and still run lessons from a terminal (see below).
- The terminal, bar, colors, and shortcuts match Kyoto Learn OS.
- Japanese study is built in (Mod+Shift+J, `kyoto-learn`, login motd).
- This is the same end result as [INSTALL-FRESH-ARCH.md](INSTALL-FRESH-ARCH.md) Part B.

---

## Before you start

```bash
sudo pacman -Sy
groups          # need wheel for sudo
ping -c1 archlinux.org
```

Run as your normal user (not root):

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh -o easy-install.sh
chmod +x easy-install.sh
./easy-install.sh
```

Or:

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh
sudo ./mcp-arch.sh
```

---

## Installer questions (existing Arch)

| Question | Pick |
|----------|------|
| **Situation** | **2) Arch ready on physical PC** (laptop/desktop) OR **3) Arch ready in a VM** (adds guest tools) |
| **AUR helper** | `yay` (or `paru` if you already use it) |
| **Theme** | `1` green or `2` cyan |
| **Proceed** | `Y` |

There is **no** "lessons only" prompt. The default path installs the **full desktop**.

---

## Will this break my current setup?

| You use today | What we do | Risk |
|---------------|------------|------|
| **GNOME / KDE / Hyprland** | Install i3 alongside. Log out, pick **i3** at login (or use `startx`). Your old DE remains installed. | Low |
| **i3 already** | Backup `~/.config/i3`, polybar, picom to `.bak.*`, install Kyoto configs. | Low (restore backup if needed) |
| **No graphical desktop** | Install full stack + ly or `startx`. | Low |
| **Server (no GUI)** | Installs X11 and i3; only affects you if you start a graphical session. | Medium (skip if this is a remote server) |

We do **not**:

- Reformat disks
- Remove pacman or your kernel
- Delete `/home` except overwriting specific config files (with backup)
- Force-disable your current display manager

---

## After install: use the new desktop

```bash
system-verify
```

1. **Log out** of your current session.
2. At login:
   - If **ly** is active: choose **i3** session.
   - If **GDM/SDDM** still runs: look for **i3** in the session menu, or run `startx` from a TTY.
3. In i3:
   - **Mod+Return** - terminal
   - **Mod+Shift+J** - `kyoto-learn` (full Japanese course)
   - **Mod+d** - launcher

Reboot is optional. Log out and back in is usually enough.

---

## If you want to stay on GNOME/KDE sometimes

You can keep your current desktop and still install everything. Use your usual session for normal work, and run:

```bash
kyoto-learn
```

For the **full** visual experience, log into **i3** when you study.

---

## Optional: curriculum refresh only

Advanced users only. Skips i3/polybar changes:

```bash
sudo ./install/lessons-only.sh
```

Normal users should use the main installer for the complete desktop.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Still land in GNOME | Session menu: choose **i3**, or `sudo systemctl disable gdm` (only if you want ly/i3 default) |
| i3 config wrong | `cp ~/.config/i3/config.bak.* ~/.config/i3/config` |
| No Wi-Fi | `nmtui` |
| AUR failed | `sudo pacman -S base-devel git`, install yay, re-run installer |
| polybar missing | `~/.config/polybar/launch.sh` ; Mod+Shift+c in i3 |

More: [INSTALL.md](INSTALL.md), [SYSTEM.md](SYSTEM.md), [COMMANDS.md](COMMANDS.md).
