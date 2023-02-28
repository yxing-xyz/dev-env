## qemu
### 创建qcow2磁盘文件
```bash
qemu-img create -f qcow2 gentoo.qcow2 100G
```

### mac m1 cd启动
```bash
# 桥接网卡参数 -nic vmnet-bridged,ifname=en0 \
sudo qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 4096 \
    -bios /opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive format=qcow2,file=linux.qcow2 \
    -cdrom  install-arm64-minimal-20230226T234708Z.iso\
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::3022-:22
```
### mac m1磁盘启动
```bash
sudo qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 4096 \
    -bios /opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive format=qcow2,file=linux.qcow2 \
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::3022-:22
```


### install gentoo
下载livecd进入
1. parted分区
```bash
##
paretd
mklabel gpt
mkparted ESP 1M 100M
mkparted Linux 100M 100G
exit
```
2. 格式化分区, 挂载分区, 解压stage3
```bash
mkfs.vfat /dev/vda1
mkfs.ext4 /dev/vda2
mount /dev/vda2 /mnt/gentoo
mount /dev/vda1 /mnt/gentoo/boot/ESP
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
```

3. make.conf,换源
编辑`/mnt/gentoo/etc/portage/make.conf`,修改增加以下内容
```txt
# march指定了mac m1芯片，如果是amd64请自行修改, -j参数需要考虑内存，小心编译器爆内存
COMMON_FLAGS="-march=armv8-a -O2 -pipe"
MAKEOPTS="-j8"
USE="-X"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
```
执行下面命令换源
```bash
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
sed "s|rsync://rsync.gentoo.org/gentoo-portage|rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage|" /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
```

4. 进入新环境
```bash
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

5. 同步源, 选配置文件, USE
```bash
emerge-webrsyncemerge-webrsync
emerge --syncemerge --sync
eselect profile list
# 这里选的systemd无桌面，带桌面的自行修改
eselect profile set 14
emerge --ask --verbose --update --deep --newuse @world
# emerge --ask app-portage/cpuid2cpuflags
# echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
emerge --ask eix gentoolkit app-text/tree vim emacs
```

6. systemd设置时区
```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set zh_CN.utf8
# 重新加载环境
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```
7. 配置内核
7.1 使用 distribution内核，支持大多数硬件
```bash
# grub, lilo传统启动使用
# emerge --ask sys-kernel/installkernel-gentoo

emerge --ask sys-kernel/installkernel-systemd-boot

# 安装源码编译内核
# emerge --ask sys-kernel/gentoo-kernel

# 安装二进制内核
emerge --ask sys-kernel/gentoo-kernel-bin
# 清除旧软件包
emerge --depclean
# 为了节省空间，可以选择清除旧版本内核
# emerge --prune sys-kernel/gentoo-kernel sys-kernel/gentoo-kernel-bin

# 只要内核更新就要重建inittramfs
emerge --ask @module-rebuild
```

8. 挂载表和主机，网络，系统信息
```bash
## UUID用blk命令看， 找到root分区

echo "UUID=590a4b06-dcee-4761-b1f1-eb34810523cd		/		        ext4		noatime		0 1" >> /etc/fstab
echo "UUID=C1D9-5170		                        /boot/ESP		vfat		noatime		0 1" >> /etc/fstab
echo 'hostname="x"' >> /etc/conf.d/hostname
emerge --ask net-misc/dhcpcd
systemctl enable --now dhcpcd
# 设置root密码
passwd
# systemd
systemd-firstboot --prompt --setup-machine-id
systemctl preset-all
emerge --ask grub2 efibootmgr
grub-install --target=arm64-efi --boot-directory=/boot/ESP/EFI/ --efi-directory=/boot/ESP --bootloader-id=grubgrub-install --target=arm64-efi --boot-directory=/boot/ESP/EFI/ --efi-directory=/boot/ESP --bootloader-id=grub
/usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg
```
9.  应用软件
```bash
# locale定位
emerge --ask sys-apps/mlocate
# enable sshd
systemctl enable sshd
emerge --ask go ssh zsh nvm docker
exit
reboot
```