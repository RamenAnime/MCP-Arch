# Install Kyoto Learn OS (VM or main PC)

## Already have Arch installed?

If Arch is already on your machine and you only want to add Kyoto Learn OS, use the short guide:

**[EXISTING-ARCH.md](EXISTING-ARCH.md)** - one-command install, profile **3**, no reinstall.

Quick version:

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh | bash
# When asked: profile 3) Desktop only
```

Lessons only (no i3 changes): `sudo ./install/lessons-only.sh` from a cloned repo.

---

## What you need first

1. A working **Arch Linux** base (official install guide: https://wiki.archlinux.org/title/Installation_guide )
2. A normal user in the **wheel** group with **sudo**
3. Internet (Ethernet or Wi-Fi before running the script)

Minimum after official Arch install:

```bash
pacman -Syu
pacman -S sudo git
useradd -m -G wheel -s /bin/zsh yourname
passwd yourname
passwd root
# Wi-Fi if needed: pacman -S iwd ; systemctl enable --now iwd ; iwctl
```

## Easiest path (recommended)

As your user (not root):

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh -o easy-install.sh
chmod +x easy-install.sh
./easy-install.sh
```

Or clone and run:

```bash
git clone https://github.com/RamenAnime/MCP-Arch.git
cd MCP-Arch
chmod +x mcp-arch.sh easy-install.sh
sudo ./mcp-arch.sh
```

## Installer prompts

| Prompt | Fresh VM | Physical PC | **Already on Arch** |
|--------|----------|---------------|---------------------|
| Profile | **1) Virtual machine** | **2) Physical PC** | **3) Desktop only** |
| AUR helper | yay (default) | yay | yay or paru |
| Reboot | Skipped | You choose | Usually not needed |

## After install

1. **Log in** with `ly` (graphical) or run `startx` if you use .xinitrc only
2. Run **`system-verify`** to check pacman, network, i3, polybar, kyoto-learn
3. Run **`kyoto-learn`** or press **Mod+Shift+J** in i3

### i3 shortcuts

| Keys | Action |
|------|--------|
| Mod+Return | Terminal (alacritty) |
| Mod+d | App launcher |
| Mod+Shift+J | Japanese lessons |
| Mod+Shift+X | Lock screen |
| Mod+Shift+e | Exit i3 |

Mod = Super / Windows key

## Virtual machine tips

- **RAM:** 2 GB minimum, 4 GB recommended
- **Disk:** 20 GB+
- Enable **3D acceleration** if the guest tools package matches your hypervisor
- Profile **1** installs open-vm-tools, qemu-guest-agent, and related drivers (safe to skip errors if a package is not found)

## Physical PC tips

- Profile **2** installs GRUB helpers; run `grub-install` and `grub-mkconfig` if you have not already (Arch wiki)
- `linux-firmware` is included for Wi-Fi and graphics

## Updates

```bash
~/bin/update-system.sh
# or
sudo pacman -Syu && yay -Syu
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| No desktop after login | `startx` or enable ly: `sudo systemctl enable ly` |
| No Wi-Fi | `nmtui` or `iwctl` |
| Black screen | Try `startx`; install VM guest tools |
| polybar missing | `~/.config/polybar/launch.sh` ; Mod+Shift+c reload i3 |
| AUR fails | `sudo pacman -S base-devel git` then re-run yay install |
