#!/bin/sh

set -o errexit

echo '%wheel ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel

su x -c '
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

yay -S trzsz --nouseask --needed --noconfirm --overwrite "*"

yay -Syu --nouseask --needed --noconfirm --overwrite "*"
'

rm -rf /rootfs/var/lib/pacman/sync/*
rm -rf /home/x/.*
rm -rf /home/x/*
rm -rf /tmp/*

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel