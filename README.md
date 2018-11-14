**Install Dotfiles**

Change directory to dotfiles and install using `GNU Stow`:

- `stow x` will sym link the files in the x/ directory to the correct place in $HOME.
- Use install.sh to stow all.

**Install Arch Linux on Lenovo Thinkpad T460s**

Features:
- Encrypted BTRFS filesystem
- systemd-boot and systemd-networkd
- My packages and dotfiles

```bash

# -----------------------------------
# Initial setup
# -----------------------------------

# Temporarily set keymap and font
loadkeys uk
setfont latarcyrheb-sun32

# Verify boot mode, i.e. check directory exists
ls /sys/firmware/efi/efivars

# Connect to the internet
wifi-menu

# Sync system clock with NTP servers
timedatectl set-ntp true

# Create ESP and Linux root partitions:
# 1. nvme0n1p1: 0xEF00: 550MB Primary FAT32 EFI System Partition (ESP)
# 2. nvme0n1p2: 0x8300 Linux root (to be encrypted)
#    https://wiki.archlinux.org/index.php/EFI_system_partition
cgdisk /dev/nvme0n1

# -----------------------------------
# Setup Linux root partition (nvme0n1p2)
# -----------------------------------

# Setup encryption
cryptsetup luksFormat /dev/nvme0n1p2  # Enter good passphrase
cryptsetup open /dev/nvme0n1p2 luks
mkfs.btrfs -L luks /dev/mapper/luks

# Create subvolumes
mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots_root
btrfs subvolume create /mnt/@snapshots_home
umount /mnt

# Mount subvolumes
mount /dev/mapper/luks /mnt -o subvol=@root  # Top-level (subvolid=5)
mkdir /mnt/{home,.snapshots}
mount /dev/mapper/luks /mnt/home -o subvol=@home
mount /dev/mapper/luks /mnt/.snapshots -o subvol=/@snapshots_root
mount /dev/mapper/luks /mnt/home/.snapshots -o subvol=/@snapshots_home

# -----------------------------------
# Setup ESP (nvme0n1p1)
# -----------------------------------

mkfs.fat -F32 /dev/nvme0n1p1
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# -----------------------------------
# Install base system
# -----------------------------------

# Move closer mirror to top
vim /etc/pacman.d/mirrorlist
# Uncomment Color option
vim /etc/pacman.conf
pacstrap /mnt base vim btrfs-progs zsh vim git sudo wpa_supplicant dialog iw intel-ucode

# Generate fstab
genfstab -L /mnt >> /mnt/etc/fstab
# Verify and adjust fstab: for all btrfs filesystems:
# - Change "relatime" to "noatime" to reduce wear on SSD
# - Add "discard" to enable continuous TRIM for SSD
# - Add "autodefrag" to enable online defragmentation
vim /mnt/etc/fstab

# -----------------------------------
# Configure system
# -----------------------------------

arch-chroot /mnt

# Configure timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Generate locales
vim /etc/locale.gen  # en_GB.UTF-8 UTF-8
locale-gen
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf

# Permanently set keymap and font
cat <<EOT >> /etc/vconsole.conf
KEYMAP=uk
FONT=latarcyrheb-sun32
EOT

# Set hostname (e.g. joe-thinkpad)
echo '<hostname>' > /etc/hostname
cat <<EOT >> /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	<hostname>.localdomain <hostname>
EOT

# Configure mkinitcpio with kernel modules needed for the initrd image
# + https://wiki.archlinux.org/index.php/mkinitcpio#Common_hooks
# HOOKS=(base systemd autodetect modconf block keyboard sd-vconsole sd-encrypt filesystems)
vim /etc/mkinitcpio.conf
# Regenerate initrd image
mkinitcpio -p linux

# Setup systemd-boot
bootctl --path=/boot install
# Create bootloader entry
# https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#Using_sd-encrypt_hook
cat <<EOT > /boot/loader/entries/arch.conf
title 		Arch Linux
linux		/vmlinuz-linux
initrd		/intel-ucode.img
initrd		/initramfs-linux.img
options		rw luks.name=luks rd.luks.options=discard root=/dev/mapper/luks rootflags=subvol=@root fan_control=1
EOT
# Set default bootloader entry
cat <<EOT > /boot/loader/loader.conf
#timeout	3
console-mode	2
default 	arch
EOT

# Set password for root
passwd

# Add user
useradd -m -g wheel -s /bin/zsh joenye
passwd joenye
vim /etc/sudoers # Uncomment %wheel ALL=(ALL) ALL

# Reboot
exit
reboot

# -----------------------------------
# Networking
# -----------------------------------

# Uses systemd-networkd
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo cat <<EOT > /etc/systemd/network/20-wired.network
[Match]
Name=enp0s31f6

[Network]
DHCP=yes

[DHCP]
RouteMetric=10
EOT
sudo cat <<EOT > /etc/systemd/network/25-wireless.network
[Match]
Name=wlp4s0

[Network]
DHCP=yes

[DHCP]
RouteMetric=20
EOT
sudo cat <<EOT > /etc/wpa_supplicant/wpa_supplicant-wlp4s0.conf
ctrl_interface=DIR=/run/wpa_supplicant GROUP=wheel
update_config=1
EOT
sudo systemctl enable wpa_supplicant@wlp4s0
sudo systemctl start wpa_supplicant@wlp4s0

# Add new connection
sudo wpa_cli -i wlp4s0
scan
scan_results
add_network
set_network 0 ssid "<ssid>"
set_network 0 psk "<psk>"
enable_network 0
save_config
exit

# -----------------------------------
# Packages
# -----------------------------------

# Configure git
TODO

# Select all
sudo pacman -S base-devel

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Disable package compression
sudo vim /etc/maklepkg.conf
# [...]
# #PKGEXT='.pkg.tar.xz'
# PKGEXT='.pkg.tar'
# [...]

# Install sway
yay termite sway

# Install all other packages
pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort pkglist-clean.txt))

# Configure fonts
# https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
# Uncomment last line
sudo vim /etc/profile.d/freetype2.sh  
sudo cat <<EOT > /etc/fonts/local.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match>
        <edit mode="prepend" name="family"><string>Noto Sans</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>serif</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Serif</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>sans-serif</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Sans</string></edit>
    </match>
    <match target="pattern">
        <test qual="any" name="family"><string>monospace</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Mono</string></edit>
    </match>
</fontconfig>
EOT

cd ~
mkdir Projects
mkdir Github
git clone git@github.com:joenye/Dotfiles.git
.~/Dotfiles/install.sh
git clone git@github.com:joenye/_Dotfiles.git
.~/_Dotfiles/install.sh

# Configure brightnessctl
sudo chmod u+s /usr/bin/brightnessctl

# Configure volume
systemctl --user enable pulseaudio.service
systemctl --user start pulseuadio.service
pactl list sinks short

# Configure TLP
# Set SATA_LINKPWR_ON_BAT=max_performance
sudo vim /etc/default/tlp

# Configure thinkfan
sudo modprobe thinkpad_acpi
sudo modprobe acpi_call
sudo echo "START=yes" > /etc/default/thinkfan
# => Copy thinkfan.conf into /etc/thinkfan.conf
sudo sensors-detect --auto
sudo systemctl enable thinkfan
sudo systemctl enable lm_sensors

# Configure vim
TODO

# systemd-boot pacman hook
yay systemd-boot-pacman-hook

# -----------------------------------
# Snapshots
# -----------------------------------

sudo systemctl enable snapper-cleanup.timer
sudo systemctl enable snapper-timeline.timer
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
# Re-mount @snapshots to /.snapshots as per fstab
sudo mount -a
sudo chmod 750 /.snapshots

sudo snapper -c home create-config /home
sudo rm -r /home/.snapshots
# Re-mount @snapshots to /.snapshots as per fstab
sudo mount -a
sudo chmod 750 /home/.snapshots

# Update /etc/snapper/configs/{root,home}:
# TIMELINE_MIN_AGE="1800"
# TIMELINE_LIMIT_HOURLY="5"
# TIMELINE_LIMIT_DAILY="7"
# TIMELINE_LIMIT_WEEKLY="0"
# TIMELINE_LIMIT_MONTHLY="0"
# TIMELINE_LIMIT_YEARLY="0"

```
