# MCP Arch Installer

Interactive installer for the MCP-themed Arch environment.

## What it does
- Installs i3-gaps, cool-retro-term, picom, polybar, polybar configs, neofetch, fonts and other utilities.
- Installs AUR packages using `yay` (default) or `paru` if chosen.
- Installs and enables `ly` login manager.
- Applies MCP-themed dotfiles under the target user's home (`~/.config/*`).
- Creates convenience scripts: `~/bin/update-system.sh` and `~/mcp-setup.sh`.

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
- Theme choice (MCP Green or Cyan/Blue)

The script will reboot automatically after a 60 second countdown (you can cancel with Ctrl-C).

## Notes & Safety
- Review the script before running. It installs packages and writes config files.
- The script attempts to back up existing files by renaming them with a `.bak.TIMESTAMP` suffix.
- Some steps (GRUB, Plymouth theme) may require manual verification depending on your system and `/boot` layout.
- The script uses `sudo` where appropriate if not run as root.

## License
MIT — feel free to fork and adapt.

