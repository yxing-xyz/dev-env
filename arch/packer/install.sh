#!/bin/sh

echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' >/etc/pacman.d/mirrorlist

sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads|ParallelDownloads|' /etc/pacman.conf
sed -i 's|#MAKEFLAGS.*|MAKEFLAGS="-j17"|' /etc/makepkg.conf

tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.nju.edu.cn/archlinuxcn/\$arch
EOF

parted /dev/vda mklabel gpt
parted /dev/vda mkpart grub_bios 1MiB 2MiB
parted /dev/vda set 1 bios_grub on
parted /dev/vda mkpart ESP 2MiB 102MiB
parted /dev/vda mkpart linux 102MiB 100%

mkfs.vfat /dev/vda2
mkfs.ext4 /dev/vda3
mount /dev/vda3 /mnt
mkdir -p /mnt/boot/ESP
mount /dev/vda2 /mnt/boot/ESP

sed -i 's|^Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist\nSigLevel = Never|g' /etc/pacman.conf
pacman -Sy
pacstrap -i /mnt base base-devel devtools linux linux-firmware linux-headers grub networkmanager dhcpcd vim net-tools squashfs-tools openssh --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt bash -c 'echo "root:root" | chpasswd'
arch-chroot /mnt bash -c 'systemctl enable NetworkManager'
arch-chroot /mnt bash -c 'systemctl enable sshd'
arch-chroot /mnt bash -c "sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config && sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && ssh-keygen -A"
arch-chroot /mnt bash -c 'grub-install --target=x86_64-efi --boot-directory=/boot/ --efi-directory=/boot/ESP --removable --no-nvram'
arch-chroot /mnt bash -c 'grub-install --target=i386-pc --boot-directory=/boot /dev/vda'
arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg'
nohup bash -c "sleep 10 && reboot"