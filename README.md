# Kyoto Learn OS (MCP-Arch)

Arch Linux desktop for learning **Kyoto dialect Japanese** from zero: hiragana, katakana, kanji, vocabulary, and immersive EN/JA lessons (`kyoto-learn`).

Designed for an **easy install in a VM** or as a **daily driver** after a standard Arch base install.

## Already on Arch?

You do not need to reinstall. See **[docs/EXISTING-ARCH.md](docs/EXISTING-ARCH.md)** for the fastest path (one command, pick profile **3**).

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
```

## Quick install (fresh Arch base)

**You need Arch Linux installed first** (user with sudo). Then:

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh
sudo ./mcp-arch.sh
```

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
```

Full guide: [docs/INSTALL.md](docs/INSTALL.md)

## What the installer sets up

| Area | Details |
|------|---------|
| **pacman** | NetworkManager, firmware, pipewire, fonts, i3, alacritty, polybar, picom, firefox, jq |
| **AUR** | yay or paru, ly login, i3lock-color (optional packages skip safely) |
| **VM** | open-vm-tools, qemu-guest-agent, spice, guest video drivers |
| **UI** | Working i3 config, polybar, lock screen, solid wallpaper (no broken image paths) |
| **Lessons** | `kyoto-learn` CLI + curriculum in `/usr/share/kyoto-learn` |

## After install

```bash
system-verify    # check pacman, network, UI, lessons
kyoto-learn      # start course (or Mod+Shift+J in i3)
```

## Documentation (full index)

**[docs/README.md](docs/README.md)** - start here

| Guide | Contents |
|-------|----------|
| [docs/EXISTING-ARCH.md](docs/EXISTING-ARCH.md) | **Already on Arch:** easy install, profile 3, lessons-only |
| [docs/INSTALL.md](docs/INSTALL.md) | VM or main PC install, prerequisites, troubleshooting |
| [docs/SYSTEM.md](docs/SYSTEM.md) | pacman, AUR, UI stack, updates, verification |
| [docs/COMMANDS.md](docs/COMMANDS.md) | Commands and i3 / kyoto-learn shortcuts |
| [docs/LEARNING_PATH.md](docs/LEARNING_PATH.md) | Levels 0-10, three writing systems, Rosetta-ready |
| [docs/HOW-TO-LEARN.md](docs/HOW-TO-LEARN.md) | First-language study habits |

Copy style: use `-` between words, not em dashes. No UI watermarks.

## License

MIT - feel free to fork and adapt.
