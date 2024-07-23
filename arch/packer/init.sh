#!/bin/sh
echo 'Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads|ParallelDownloads|' /etc/pacman.conf
sed -i 's|#MAKEFLAGS.*|MAKEFLAGS="-j17"|' /etc/makepkg.conf

tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.nju.edu.cn/archlinuxcn/\$arch
EOF

rm -rf /var/log/*
rm -rf /var/cache/*
dd if=/dev/zero of=/fill bs=1M count="$(df -m /  | tail -n1 | awk '{print $3}')" 2>/dev/null
rm /fill
echo "success"