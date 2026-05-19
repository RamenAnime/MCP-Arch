# Install Kyoto Learn OS - pick your path

Kyoto Learn OS is a **full desktop experience**: i3 window manager, polybar, Japanese lessons (`kyoto-learn`), bilingual shell messages, and immersion across the system. Both paths end at the **same desktop**. Only the starting point differs.

| Your situation | Guide |
|----------------|--------|
| **I still need to install Arch Linux** | **[INSTALL-FRESH-ARCH.md](INSTALL-FRESH-ARCH.md)** |
| **Arch is already installed** | **[INSTALL-EXISTING-ARCH.md](INSTALL-EXISTING-ARCH.md)** |

## Same full desktop on both paths

| Included | What it does |
|----------|----------------|
| **i3 + polybar + picom** | Tiling desktop, top bar, compositor |
| **alacritty** | Terminal with theme colors |
| **kyoto-learn** | Hiragana, katakana, kanji, vocab, Kyoto dialect course |
| **kyoto-motd** | Bilingual welcome at shell login |
| **Noto CJK fonts** | Japanese displays correctly |
| **NetworkManager** | Wi-Fi and Ethernet |
| **pacman + AUR** | yay or paru for extra packages |
| **ly login** | Only enabled if you do not already use GDM/SDDM |

No em dashes in UI copy. No "Powered by" watermarks.

## One installer command (both paths)

After Arch is installed and you have a user with **sudo**:

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
```

The installer asks which situation applies (see the guide for your path).

## After any install

```bash
system-verify
kyoto-learn
```

Log into the **i3** session (Mod+Shift+J for lessons). Details in [COMMANDS.md](COMMANDS.md).

## More docs

- [SYSTEM.md](SYSTEM.md) - pacman, AUR, UI stack
- [LEARNING_PATH.md](LEARNING_PATH.md) - study levels
- [HOW-TO-LEARN.md](HOW-TO-LEARN.md) - how to study
- [CONTRIBUTING.md](CONTRIBUTING.md) - text style rules
