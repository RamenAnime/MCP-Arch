# Kyoto Learn OS documentation

Kyoto Learn OS is a **full Arch desktop** for learning Japanese (hiragana, katakana, kanji, vocabulary, Kyoto dialect). Two install paths, same end result.

## Pick your path

| Path | Guide | When |
|------|-------|------|
| **1 - Fresh Arch** | **[INSTALL-FRESH-ARCH.md](INSTALL-FRESH-ARCH.md)** | You still need to install Arch Linux |
| **2 - Existing Arch** | **[INSTALL-EXISTING-ARCH.md](INSTALL-EXISTING-ARCH.md)** | Arch is already installed |

Overview and links: [INSTALL.md](INSTALL.md)

## Quick install (Arch already working)

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
```

In the installer: **2** for a PC/laptop, **3** if Arch runs inside a VM. Both install the **full** desktop.

## Other guides

| Doc | Contents |
|-----|----------|
| [SYSTEM.md](SYSTEM.md) | pacman, AUR, UI stack, updates, verification |
| [COMMANDS.md](COMMANDS.md) | Commands and keyboard shortcuts |
| [LEARNING_PATH.md](LEARNING_PATH.md) | Levels 0-10, Rosetta-ready goals |
| [HOW-TO-LEARN.md](HOW-TO-LEARN.md) | Study habits |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Text style (no em dashes, no watermarks) |

## What the full install includes

- **Installer** (`mcp-arch.sh`): packages, AUR, i3 + polybar UI, Japanese tools
- **Lessons** (`kyoto-learn`): bilingual drills and progress tracking
- **Curriculum** (`curriculum/`): JSON lesson data
- **Shell** (`kyoto-motd`): bilingual login message

## Repository layout

```
MCP-Arch/
  mcp-arch.sh              Main installer
  easy-install.sh          Clone repo and run installer
  install/                 Preflight, packages, desktop UI, Kyoto setup
  config/                  i3, polybar, picom templates
  curriculum/              Lesson data
  bin/                     kyoto-learn, kyoto-motd, system-verify
  docs/                    This documentation set
```

## Style note for contributors

- No em dashes or en dashes in user-facing English. Use `-` or a comma.
- No branding watermarks or "Powered by" lines in the UI.
- Kyoto dialect copy is intentional; standard Japanese comes before dialect (level 9).
