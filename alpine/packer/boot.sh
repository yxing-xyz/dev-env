#!/bin/sh
tee >/etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing/
EOF

apk update
setup-hostname x
setup-interfaces -i <<EOF
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
EOF

setup-keymap us us
setup-timezone -z Asia/Shanghai

apk add openssh
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo 'root:root' | chpasswd
rc-update add sshd
rc-update --quiet add networking boot
ERASE_DISKS=/dev/vda DISKLABEL=gpt BOOTLOADER=grub BOOTFS=vfat ROOTFS=ext4 VARFS=ext4 setup-disk -s 512 -m sys /dev/vda

reboot