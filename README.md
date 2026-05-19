# Kyoto Learn OS (MCP-Arch)

Arch Linux desktop for learning **Kyoto dialect Japanese** from zero: hiragana, katakana, kanji, vocabulary, and immersive EN/JA lessons (`kyoto-learn`).

This is a **full desktop experience change** (UI, language integration, lessons), not a small script add-on.

## Two install paths (same desktop at the end)

| You are... | Read this |
|------------|-------------|
| **Need to install Arch first** | [docs/INSTALL-FRESH-ARCH.md](docs/INSTALL-FRESH-ARCH.md) |
| **Already on Arch** | [docs/INSTALL-EXISTING-ARCH.md](docs/INSTALL-EXISTING-ARCH.md) |

Index: [docs/INSTALL.md](docs/INSTALL.md)

## Quick install (Arch + sudo user ready)

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
```

- **Arch not installed yet?** Installer choice **1** points you to the Arch guide, then you run again.
- **Arch ready on a PC?** Choose **2** for full Kyoto Learn desktop.
- **Arch ready in a VM?** Choose **3** for full desktop + guest tools.

Or clone:

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh
sudo ./mcp-arch.sh
```

## What the full install sets up

| Area | Details |
|------|---------|
| **Desktop** | i3, polybar, picom, alacritty, rofi, lock screen |
| **Japanese** | `kyoto-learn`, curriculum, bilingual motd, Mod+Shift+J in i3 |
| **System** | NetworkManager, pipewire, Noto CJK fonts, firefox |
| **AUR** | yay or paru, optional ly and i3lock-color |
| **Existing DE** | GDM/SDDM kept when present; log into i3 when you want the full experience |

## After install

```bash
system-verify
kyoto-learn
```

## Documentation

**[docs/README.md](docs/README.md)** - full index

| Guide | Contents |
|-------|----------|
| [docs/INSTALL-FRESH-ARCH.md](docs/INSTALL-FRESH-ARCH.md) | Install Arch, then full Kyoto Learn OS |
| [docs/INSTALL-EXISTING-ARCH.md](docs/INSTALL-EXISTING-ARCH.md) | Full desktop on existing Arch (safe coexistence) |
| [docs/SYSTEM.md](docs/SYSTEM.md) | pacman, AUR, UI, updates |
| [docs/COMMANDS.md](docs/COMMANDS.md) | Shortcuts and commands |
| [docs/LEARNING_PATH.md](docs/LEARNING_PATH.md) | Levels 0-10 |

Copy style: hyphen `-` between words, not em dashes. No UI watermarks.

## License

MIT - feel free to fork and adapt.
