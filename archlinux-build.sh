#!/bin/sh

set -o errexit

echo '%wheel ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel


su x -c '
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
pacman -Sy
pacman -S archlinux-keyring
sudo pacman-key --init
sudo pacman-key --populate
yay -Syu --nouseask --needed --noconfirm --overwrite "*"
'

rm -rf /rootfs/var/lib/pacman/sync/* || true
rm -rf /home/x/.* || true
rm -rf /home/x/* || true
rm -rf /tmp/* || true



echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
