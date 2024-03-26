# 1. parted 分区
略
# 2. 挂载分区chroot分区
```bash
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

mkfs.vfat /dev/vda1
mkfs.ext4 /dev/vda2
mount /dev/vda2 /mnt/gentoo
mount /dev/vda1 /mnt/gentoo/boot/EFI

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --bind /mnt/gentoo /mnt/gentoo
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
chroot /mnt/gentoo /bin/bash
```

# 3. chroot后执行
```bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```
# 4. 执行desktop-init.sh
略

# 5. 内核和配置grub
```bash
# 方法一 手动编译内核
emerge --ask sys-kernel/linux-firmware  sys-firmware/intel-microcode
emerge --ask sys-kernel/gentoo-sources
emerge --ask sys-kernel/dracut
make ARCH=x86_64 defconfig
make -j17
make modules_install
make install
dracut --early-microcode --kver=6.1.12-gentoo

# 方法二 二进制内核
emerge --ask gentoo-kernel-bin

# 安装UEFI grub
grub-install --target=x86_64-efi --recheck --boot-directory=/boot/ --efi-directory=/boot/EFI --bootloader-id=grub
# 安装BIOS gurb
grub-install --target=i386-pc --recheck --boot-directory=/boot /dev/vda

# 生成的grub.cfg必须放在上面一条命令安装的grub目录中
grub-mkconfig -o /boot/grub/grub.cfg
```

# 6. 初始化systemd
```bash
# 初始化语言，键盘
systemd-firstboot --prompt --setup-machine-id
# 提供了一个"预设"文件，可用于启用一组合理的默认服务。
systemctl preset-all
```
