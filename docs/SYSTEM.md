# System stack (pacman, AUR, UI)

How Kyoto Learn OS is built on Arch and how to maintain it.

## Package manager (pacman)

The installer uses official Arch repositories only for core software:

- **Base:** `base-devel`, `git`, `sudo`, `reflector`
- **Network:** `networkmanager`, `network-manager-applet`, `iwd`, `wpa_supplicant`
- **Audio:** `pipewire`, `pipewire-pulse`, `wireplumber`, `pulseaudio-alsa`, `pavucontrol`
- **Graphics:** `xorg-server`, `xorg-xinit`, `linux-firmware`
- **Desktop:** `i3-wm`, `alacritty`, `polybar`, `picom`, `feh`, `rofi`, `firefox`
- **Fonts:** `noto-fonts`, `noto-fonts-cjk`, `noto-fonts-emoji`
- **Learn:** `jq` (lesson progress and curriculum)

Sync and update:

```bash
sudo pacman -Sy          # refresh databases
sudo pacman -Syu         # full upgrade
~/bin/update-system.sh   # pacman + AUR helper upgrade
```

## AUR (yay or paru)

Arch User Repository builds are run as your normal user, not root.

**Installed at setup**

1. `base-devel` and `git` (pacman)
2. Build **yay** or **paru** from aur.archlinux.org
3. Optional AUR packages: `ly`, `i3lock-color`, `ttf-terminus-nerd`

If AUR fails:

```bash
sudo pacman -S base-devel git
cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S ly i3lock-color
```

Never run `yay` with `sudo`.

## Virtual machine packages

Profile **1** or **2** may install (skipped if not in repos):

- `open-vm-tools` (VMware)
- `qemu-guest-agent` (QEMU/KVM)
- `spice-vdagent`
- `xf86-video-vmware`, `xf86-video-qxl`
- `virtualbox-guest-utils`

Enable guest services when present:

```bash
sudo systemctl enable --now vmtoolsd
sudo systemctl enable --now qemu-guest-agent
```

## Desktop UI

| Piece | Role |
|-------|------|
| **ly** | Graphical login (AUR); pick i3 session |
| **i3** | Tiling window manager; config in `~/.config/i3/config` |
| **polybar** | Top bar; `~/.config/polybar/launch.sh` |
| **picom** | Compositor (transparency, fading) |
| **alacritty** | Default terminal |
| **rofi / dmenu** | App launcher (Mod+d) |
| **xsetroot** | Solid background color (no broken wallpaper file) |

Fallback without ly:

```bash
startx
```

Uses `~/.xinitrc` which runs `exec i3`.

Reload UI after config edits: **Mod+Shift+c** in i3.

## Kyoto Learn services

| Path | Purpose |
|------|---------|
| `/usr/share/kyoto-learn/` | Curriculum and `kyoto-learn` scripts |
| `/usr/local/bin/kyoto-learn` | Lesson command |
| `/usr/local/bin/kyoto-motd` | Login message |
| `/usr/local/bin/system-verify` | Health check |
| `~/.local/share/kyoto-learn/progress.json` | Your progress |

## Verification

After install or major changes:

```bash
system-verify
```

Checks: pacman, NetworkManager, i3, alacritty, polybar, jq, kyoto-learn, AUR helper, config files.

## Physical PC boot

Profile **2** installs `grub` and `efibootmgr` helpers. You still run Arch install steps for your disk:

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

See Arch wiki if you use BIOS instead of UEFI.
