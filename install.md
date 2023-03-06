## qemu
### 创建qcow2磁盘文件
```bash
qemu-img create -f qcow2 gentoo.qcow2 100G
```


```bash
### mac m1 qemucd启动
# 桥接网卡参数 -nic vmnet-bridged,ifname=en0 \
# -bios /opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-arm-vars.fd \
    -drive format=qcow2,file=/Users/x/workspace/demo/gentoo/linux.qcow2 \
    -cdrom  /Users/x/workspace/demo/gentoo/install-arm64-minimal-20230226T234708Z.iso \
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::22-:22

### mac m1 qemu图形化启动
qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-arm-vars.fd \
    -drive format=qcow2,file=/Users/x/workspace/demo/gentoo/linux.qcow2 \
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::22-:22

### mac m1 qemu禁用图形化和串口模拟器
qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-arm-vars.fd \
    -drive format=qcow2,file=/Users/x/workspace/demo/gentoo/linux.qcow2 \
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::22-:22 \
    -display non
### 快照
#### 创建快照
qemu-img snapshot -c 2023-03-01 linux.qcow2
#### 查看快照
qemu-img snapshot -l linux.qcow2
#### 删除快照
qemu-img snapshot -d 2023-03-01 ./linux.qcow2
#### 使用快照
qemu-img snapshot -a 2023-03-01 linux.qcow2
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

3. 进入新环境
```bash
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```
4. make.conf,换源
5.
编辑`/etc/portage/make.conf`,修改增加以下内容
```txt
# march指定了mac m1芯片，如果是amd64请自行修改, -j参数需要考虑内存，小心编译器爆内存
COMMON_FLAGS="-march=armv8-a -O2 -pipe"
MAKEOPTS="-j8"
#- MAKEOPTS="-j20"
USE="grub git -selinux -X systemd"
#- USE="grub git -selinux X systemd gtk qt5"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
ACCEPT_LICENSE="*"
```
执行下面命令换源
```bash
# mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /etc/portage/repos.conf
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
sed -i  "s|rsync://rsync.gentoo.org/gentoo-portage|rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage|" /etc/portage/repos.conf/gentoo.conf
tee > /etc/portage/package.accept_keywords/x <<EOF
sys-fs/fuse-exfat **
sys-fs/exfat-utils **
dev-util/rustup **
dev-db/mycli **
app-misc/trash-cli **
dev-vcs/lazygit **
dev-python/cli_helpers **
dev-python/tabulate **
dev-util/git-delta **
sys-apps/bat **
app-shells/fzf **
www-apps/hugo **
net-misc/zssh **
EOF
```


5. 同步源, 选配置文件, USE
```bash
emerge-webrsyncemerge-webrsync
emerge --syncemerge --sync
eselect profile list
# rm64 nodesktop systemd
eselect profile set default/linux/arm64/17.0/systemd
# amd64 desktop systemd
# eselect profile set default/linux/amd64/17.1/desktop/systemd

emerge --ask --verbose --update --deep --newuse @world
# emerge --ask app-portage/cpuid2cpuflags
# echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
emerge --ask eix gentoolkit app-text/tree vim emacs
emerge --ask sys-apps/pciutils
emerge --ask sys-fs/e2fsprogs     #ext2、ext3、ext4
emerge --ask sys-fs/xfsprogs      #xfs
emerge --ask sys-fs/dosfstools    #fat32
emerge --ask sys-fs/ntfs3g        #ntfs
emerge --ask sys-fs/fuse-exfat    #exfat
emerge --ask sys-fs/exfat-utils   #exfat
```

6. systemd设置时区
```bash
# 设置domain
echo 'search yxing.xyz' >> /etc/resolv.conf
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set zh_CN.utf8
# 重新加载环境
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```
7. 配置内核
7.1 使用 gentoo distribution内核，支持大多数硬件
```bash
# emerge --ask sys-kernel/installkernel-systemd-boot

# grub, lilo传统启动使用
emerge --ask sys-kernel/installkernel-gentoo
# 固件
emerge --ask sys-kernel/linux-firmware
# 分支1 gentoo内核树构建内核
# emerge --config sys-kernel/gentoo-kernel
# 分支2 安装二进制内核
emerge --ask sys-kernel/gentoo-kernel-bin

# 清除旧软件包
emerge --depclean

# 为了节省空间，可以选择清除旧版本内核
# emerge --prune sys-kernel/gentoo-kernel sys-kernel/gentoo-kernel-bin

# 只要内核更新就要重建inittramfs
emerge --ask @module-rebuild
```

7.2 手动编译内核
```bash
emerge --ask sys-kernel/linux-firmware
emerge --ask sys-kernel/gentoo-sources
make ARCH=arm64 defconfig
# make ARCH=x86_64 defconfig
make menuconfig
make -j10
make modules_install
emerge --ask sys-kernel/dracut
dracut --kver=6.1.12-gentoo
make install
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
emerge --ask sys-boot/grub efibootmgr
grub-install --target=arm64-efi --boot-directory=/boot/ESP/ --efi-directory=/boot/ESP --bootloader-id=grub
# 生成的grub.cfg必须放在上面一条命令安装的grub目录中
grub-mkconfig -o /boot/ESP/grub/grub.cfg
```
9.  应用软件
```bash
# sudo
emerge --ask sudo

# overlay
emerge --ask app-eselect/eselect-repository dev-vcs/git app-portage/layman
# eselect repository list
eselect repository enable guru gentoo-zh
emerge --sync


# locale定位
emerge --ask sys-apps/mlocate

# enable sshd
systemctl enable sshd
# tmux
emerge tmux \
rustup dev-lang/lua go nodejs dev-python/pip \
app-containers/docker zsh trash-cli mycli htop mtr lazygit git-delta \
wget htop aria2 lsd bat fzf sys-apps/ripgrep net-tools fd lrzsz netcat tcpdump hugo \
neofetch net-dns/bind-tools sshfs

## desktop
emerge x11-drivers/xf86-video-amdgpu x11-wm/awesome

useradd -m -s /bin/zsh -G wheel x
passwd x
# mycli依赖
pip3 install sqlglot --user
exit

reboot
```


## efibootmgr调整启动顺序
```bash
efibootmgr -o 0,1,2
```
## GRUB手动引导linux
```bash
# 查看uuid
ls (hd0,gpt3)
# 设置root加载linux
linux (hd0,gpt3)/boot/vmlinuz-6.1.12-gentoo-dist root=UUID=cef878343-3434-3fdd-2323343
# 加载initrd
initrd (hd0,gpt3)/boot/initramfs-6.1.12-gentoo-dist.img
# 启动
boot
```


## portage使用内存文件系统加速
提高SSD的寿命
```bash
echo 'tmpfs /var/tmp/portage tmpfs rw,nosuid,noatime,nodev,size=14G,mode=775,uid=portage,gid=portage,x-mount.mkdir=775 0 0' >> /etc/fstab
mount /var/tmp/portage

# 方法一指定特殊包不使用tmpfs
mkdir -p /etc/portage/env
echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' > /etc/portage/env/notmpfs.conf
mkdir /var/tmp/notmpfs
chown portage:portage /var/tmp/notmpfs
mkdir -p /etc/portage/env
echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' > /etc/portage/env/notmpfs.conf
mkdir /var/tmp/notmpfs
chown portage:portage /var/tmp/notmpfs
chmod 775 /var/tmp/notmpfschmod 775 /var/tmp/notmpfs
echo 'www-client/chromium notmpfs.conf' >> /etc/portage/package.env

# 方法二增加tmpfs内存或者交换分区
# mount -o remount,size=N /var/tmp/portage

# 方法三 指定交换文件
# 内存不够解决方法2
## 创建交换文件
touch /swap.img
hmod 600 /swap.img
dd if=/dev/zero bs=1024M of=/swap.img count=8
mkswap /swap.img

## 打开和关闭交换文件
swapon /swap.img
swapoff /swap.img
```
