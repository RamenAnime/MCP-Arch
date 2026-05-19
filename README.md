# Kyoto Learn OS (mcp-arch)

Arch Linux installer for an immersive **Kyoto dialect Japanese** learning desktop. Teaches reading and writing from zero knowledge through **hiragana**, **katakana**, and **kanji**, with vocabulary and Kyoto-flavored speech, using mixed English and Japanese in the shell and lesson app.

## What it does
- Installs i3-gaps, terminal, polybar, fonts (including CJK), `jq`, and utilities.
- Installs **Kyoto Learn** (`kyoto-learn` CLI) with full curriculum under `/usr/share/kyoto-learn`.
- Immersive login: bilingual motd, **Mod+Shift+J** opens lessons in i3.
- Installs AUR packages using `yay` (default) or `paru` if chosen.
- Optional retro terminal theme (green or cyan).
- Progress saved in `~/.local/share/kyoto-learn/progress.json`.

## Usage
1. Upload `mcp-arch.sh` to your Arch machine (or clone repo).
2. Make it executable:
   ```bash
   chmod +x mcp-arch.sh
   ```
3. Run it as root or with sudo:
   ```bash
   sudo ./mcp-arch.sh
   ```

The installer will prompt for:
- AUR helper choice (yay default)
- Theme choice (green or cyan terminal)

After install, run **`kyoto-learn`** to start lessons. See [docs/LEARNING_PATH.md](docs/LEARNING_PATH.md) and [docs/HOW-TO-LEARN.md](docs/HOW-TO-LEARN.md).

The script may reboot automatically after a 60 second countdown (you can cancel with Ctrl-C).

## Notes & Safety
- Review the script before running. It installs packages and writes config files.
- The script attempts to back up existing files by renaming them with a `.bak.TIMESTAMP` suffix.
- Some steps (GRUB, Plymouth theme) may require manual verification depending on your system and `/boot` layout.
- The script uses `sudo` where appropriate if not run as root.

## License
MIT - feel free to fork and adapt.

