#!/bin/sh
# x86_64系统安装UEFI grub引导
if [ "$(uname -m)" = "x86_64" ]; then
    apk add grub-efi efibootmgr
    grub-install --target=x86_64-efi --boot-directory=/boot \
        --efi-directory=/boot --removable --no-nvram
    update-grub
fi
tee >/etc/apk/repositories <<EOF
http://mirrors.nju.edu.cn/alpine/latest-stable/main
http://mirrors.nju.edu.cn/alpine/latest-stable/community
http://mirrors.nju.edu.cn/alpine/edge/testing/
EOF
rm -rf /var/log/*
rm -rf /var/cache/*
dd if=/dev/zero of=/fill bs=1M count="$(df -m /  | tail -n1 | awk '{print $3}')" 2>/dev/null
rm /fill
