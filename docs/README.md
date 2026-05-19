# Kyoto Learn OS documentation

All guides for installing, using, and studying on this system. Use a normal hyphen `-` in new copy, not an em dash.

## Start here

| Doc | Who it is for |
|-----|----------------|
| **[EXISTING-ARCH.md](EXISTING-ARCH.md)** | **You already run Arch and want an easy add-on install** |
| [INSTALL.md](INSTALL.md) | First-time install on Arch (VM or main PC) |
| [SYSTEM.md](SYSTEM.md) | pacman, AUR, desktop UI, updates, verification |
| [COMMANDS.md](COMMANDS.md) | Commands and keyboard shortcuts |
| [LEARNING_PATH.md](LEARNING_PATH.md) | Course levels 0-10 and Rosetta-ready goals |
| [HOW-TO-LEARN.md](HOW-TO-LEARN.md) | Study habits (first-language style) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Text style, curriculum, installer notes |

## Quick paths

**Install in a VM**

1. Install Arch Linux (official guide on wiki.archlinux.org).
2. Create a user in `wheel` with sudo.
3. Run [INSTALL.md](INSTALL.md) easy-install or `sudo ./mcp-arch.sh`.
4. Choose profile **1) Virtual machine**.
5. After install: `system-verify`, then log in and run `kyoto-learn`.

**Install on daily hardware**

Same as above, but choose profile **2) Physical PC** and complete GRUB if you have not already.

**Already on Arch (full desktop + lessons)**

See **[EXISTING-ARCH.md](EXISTING-ARCH.md)** or:

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
# profile 3) Desktop only
```

**Lessons only (keep GNOME/KDE/Hyprland, no i3)**

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
sudo ./install/lessons-only.sh
kyoto-learn
```

## What this project includes

- **Installer** (`mcp-arch.sh`): pacman packages, AUR helper, VM guest tools, i3 + polybar UI, ly login.
- **Lessons** (`kyoto-learn`): hiragana, katakana, kanji, vocab, Kyoto dialect, bilingual prompts.
- **Curriculum** (`curriculum/`): JSON lesson data; progress in `~/.local/share/kyoto-learn/progress.json`.

## Repository layout

```
MCP-Arch/
  mcp-arch.sh          Main installer
  easy-install.sh      Clone repo and run installer
  install/             Preflight, packages, desktop UI, Kyoto setup
  config/              i3, polybar, picom templates
  curriculum/          Lesson data
  bin/                 kyoto-learn, kyoto-motd, system-verify
  docs/                This documentation set
```

## Style note for contributors

- No em dashes or en dashes in user-facing English. Use `-` or a comma.
- No branding watermarks or "Powered by" lines in the UI.
- Kyoto dialect copy is intentional; standard Japanese is taught before dialect (level 9).
