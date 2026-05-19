# Path 1: Install Arch, then Kyoto Learn OS (full desktop)

Use this when Arch is **not** on the machine yet (new VM, new disk, or new PC).

You will:

1. Install **Arch Linux** (minimal, official method).
2. Run the **Kyoto Learn OS installer** for the full desktop (UI + Japanese immersion).

You do **not** get a partial install. Step 2 adds the complete Kyoto Learn desktop experience.

---

## Part A: Install Arch Linux

Follow the official guide: https://wiki.archlinux.org/title/Installation_guide

### VM (VirtualBox, VMware, QEMU)

| Setting | Suggested |
|---------|-----------|
| RAM | 4 GB or more |
| Disk | 25 GB or more |
| Firmware | UEFI if offered |
| 3D acceleration | On |

Minimal Arch steps (summary):

1. Boot the Arch ISO.
2. Partition and format disk (`cfdisk` or `fdisk`).
3. Mount partitions and run `pacstrap base linux linux-firmware networkmanager sudo vim nano git`
4. Generate fstab, `arch-chroot`, set root password.
5. Create your user:

```bash
useradd -m -G wheel -s /bin/zsh YOURNAME
passwd YOURNAME
passwd root
```

6. Enable NetworkManager: `systemctl enable NetworkManager`
7. Install a bootloader (GRUB or systemd-boot per wiki), reboot, remove ISO.

Connect to the network (Ethernet or `nmtui` / `iwctl` for Wi-Fi).

### Physical PC / laptop

Same as the VM steps, but use the wiki sections for **UEFI** or **BIOS** and your real disks. Install **GRUB** (or systemd-boot) before rebooting.

---

## Part B: Install Kyoto Learn OS (full desktop)

Log in as your normal user (not root). Confirm sudo works:

```bash
groups    # must include wheel
sudo pacman -Sy
ping -c1 archlinux.org
```

### One command

```bash
curl -fsSL https://raw.githubusercontent.com/RamenAnime/MCP-Arch/main/easy-install.sh -o easy-install.sh
chmod +x easy-install.sh
./easy-install.sh
```

### Installer questions (Part B)

| Question | If you are on... | Pick |
|----------|------------------|------|
| Situation | Just finished Arch install | **2) Arch ready on physical PC** OR **3) Arch ready in a VM** |
| AUR helper | Default | `yay` |
| Theme | Your taste | `1` green or `2` cyan |

Pick **3** if this Arch install lives inside a virtual machine (adds guest tools). Pick **2** for a real laptop or desktop.

### What you get (complete desktop change)

- i3 desktop with Kyoto Learn keybindings
- polybar status bar
- Login via **ly** (or `startx` if you skipped ly)
- `kyoto-learn` for all three writing systems + Kyoto dialect
- Bilingual shell motd on login
- `system-verify` to confirm everything works

Your old Arch install had no desktop environment from Kyoto Learn until this step. After Part B, the machine is meant to be used as **Kyoto Learn OS**.

---

## Part C: First login

1. Reboot if the installer asked you to (optional on VM).
2. Log in at **ly** (or TTY + `startx`).
3. Select or start **i3**.
4. Run `system-verify`.
5. Press **Mod+Shift+J** or run `kyoto-learn`.

| Key | Action |
|-----|--------|
| Mod+Return | Terminal |
| Mod+Shift+J | Japanese lessons |
| Mod+d | App launcher |

Mod = Super / Windows key.

---

## Troubleshooting (fresh Arch path)

| Problem | Fix |
|---------|-----|
| No boot after Arch install | Revisit GRUB/systemd-boot in the Arch wiki |
| Installer says no network | `nmtui` or `iwctl` |
| Black screen in VM | Install guest tools after login (profile 3), or enable 3D in VM settings |
| Stuck on TTY | `startx` |

Next: [SYSTEM.md](SYSTEM.md), [LEARNING_PATH.md](LEARNING_PATH.md).
