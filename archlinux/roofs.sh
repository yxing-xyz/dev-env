#!/bin/sh

TARGETARCH=$1
PACKAGE_GROUP='base base-devel'
BOOTSTRAP_EXTRA_PACKAGES=""
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories
apk add arch-install-scripts pacman-makepkg curl zstd
mkdir -p /etc/pacman.d
if [[ "$TARGETARCH" == "arm*" ]]; then
    curl -L https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/master/core/pacman/pacman.conf -o /etc/pacman.conf
    sed -i 's/@CARCH@/auto/g' /etc/pacman.conf
    echo 'Server = https://mirrors.tencent.com/archlinuxarm/$arch/$repo' > /etc/pacman.d/mirrorlist
    curl -L https://github.com/archlinuxarm/archlinuxarm-keyring/archive/refs/heads/master.zip -o /tmp/archlinuxarm-keyring.zip
    unzip d /tmp/archlinuxarm-keyring.zip
    unzip -o -d /tmp/archlinuxarm-keyring /tmp/archlinuxarm-keyring.zip
    mkdir /usr/share/pacman/keyrings
    mv /tmp/archlinuxarm-keyring/archlinuxarm-keyring-master/archlinuxarm* /usr/share/pacman/keyrings/
    BOOTSTRAP_EXTRA_PACKAGES="archlinuxarm-keyring"
else
    curl -L https://gitlab.archlinux.org/archlinux/packaging/packages/pacman/-/raw/main/pacman.conf -o /etc/pacman.conf
    echo 'Server = https://mirrors.tencent.com/archlinux/$repo/os/$arch' > etc/pacman.d/mirrorlist
    mkdir /tmp/archlinux-keyring
    curl -L https://archlinux.org/packages/core/any/archlinux-keyring/download | unzstd | tar -C /tmp/archlinux-keyring -xv
    mv /tmp/archlinux-keyring/usr/share/pacman/keyrings /usr/share/pacman/
fi
tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.tencent.com/archlinuxcn/\$arch
EOF
sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads|ParallelDownloads|' /etc/pacman.conf
pacman-key --init
pacman-key --populate
mkdir -p /rootfs
mkdir -m 0755 -p /rootfs/var/cache/pacman/pkg
mkdir -m 0755 -p /rootfs/var/lib/pacman
mkdir -m 0755 -p /rootfs/var/log
mkdir -m 0755 -p /rootfs/dev
mkdir -m 0755 -p /rootfs/run
mkdir -m 0755 -p /rootfs/etc
mkdir -m 1777 -p /rootfs/tmp
mkdir -m 0555 -p /rootfs/sys
mkdir -m 0555 -p /rootfs/proc
cp /etc/pacman.conf /rootfs/etc/pacman.conf
mkdir /rootfs/etc/pacman.d
cp /etc/pacman.d/mirrorlist /rootfs/etc/pacman.d/mirrorlist
# 临时修复arm key错误
sed -i 's|Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist\nSigLevel = Never|g' /etc/pacman.conf
pacman -r /rootfs -Sy --noconfirm $PACKAGE_GROUP $BOOTSTRAP_EXTRA_PACKAGES
echo "en_US.UTF-8 UTF-8" >> /rootfs/etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /rootfs/etc/locale.gen
echo "LANG=en_US.UTF-8" > /rootfs/etc/locale.conf
chroot /rootfs locale-gen
rm -rf /rootfs/var/lib/pacman/sync/*
