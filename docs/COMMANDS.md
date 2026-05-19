# Commands and shortcuts

## Installer (once)

**Already on Arch** (see [EXISTING-ARCH.md](EXISTING-ARCH.md)):

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
# profile 3) Desktop only
```

**Lessons only** (no i3):

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
sudo ./install/lessons-only.sh
```

**Full install** (clone):

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh install/lessons-only.sh
sudo ./mcp-arch.sh
```

## Daily use

| Command | What it does |
|---------|----------------|
| `kyoto-learn` | Interactive Japanese course (all writing systems) |
| `kyoto-motd` | Bilingual welcome and progress summary |
| `system-verify` | Check pacman, network, UI, and lessons |
| `~/bin/update-system.sh` | Upgrade pacman + AUR |
| `nmtui` | Network manager (Wi-Fi) |
| `startx` | Start i3 if ly is not used |

## i3 shortcuts (Mod = Super key)

| Keys | Action |
|------|--------|
| Mod+Return | Terminal (alacritty) |
| Mod+d | Launcher (rofi or dmenu) |
| Mod+Shift+J | **kyoto-learn** lessons |
| Mod+Shift+X | Lock screen |
| Mod+Shift+c | Reload i3 config |
| Mod+Shift+e | Exit i3 |
| Mod+1 / 2 / 3 | Workspaces (learn / web / term) |
| Mod+h j k l | Focus direction |

## kyoto-learn menu

| # | Drill |
|---|--------|
| 1 | Guided level (follows your progress) |
| 2 | Hiragana |
| 3 | Katakana |
| 4 | Kanji |
| 5 | Vocabulary |
| 6 | Kyoto dialect patterns |
| 7 | How to learn (methods) |
| 8 | Progress stats |
| 9 | Quit |

## Japanese input (optional, after kana)

```bash
sudo pacman -S fcitx5-mozc fcitx5-configtool
```

Configure with `fcitx5-configtool` and add to i3 autostart when ready.
