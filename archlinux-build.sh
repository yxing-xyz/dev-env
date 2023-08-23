#!/bin/sh
set -e

if [[ $(uname -a) == *"x86_64"* ]]; then
  echo 'Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' > etc/pacman.d/mirrorlist
else
  echo 'Server = https://mirrors.aliyun.com/archlinuxarm/$arch/$repo' > /etc/pacman.d/mirrorlist
fi

pacman -Sy --needed --noconfirm
pacman -S archlinux-keyring --needed --noconfirm
pacman -Su --needed --noconfirm

rm -rf /rootfs/var/lib/pacman/sync/* || true
rm -rf /tmp/* || true
