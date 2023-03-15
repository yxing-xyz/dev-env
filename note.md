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
```
### qemu启动内核
编写init程序
> gcc -o init init.c -static
```c
#include<unistd.h>
#include<stdio.h>
#include<linux/reboot.h>
#include<sys/reboot.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    printf("this is the init program !\n");
    sleep(60);
    reboot(LINUX_REBOOT_CMD_RESTART);
    return 0;
}
```
```bash
# 制作initramfs
./make_initramfs.sh rootfs initramfs.cpio.gz
# 解压initramfs， initramfs可能被压缩，需要提前解压缩一次
cpio -idmv < ./initramfs-6.1.12-gentoo.imgv

qemu-system-x86_64 \
-smp 1 \
-m 512 \
-kernel bzImage \
-append "root=/dev/ram0 rootfstype=ramfs rw init=/init" \
-initrd initramfs.cpio.gz
```

### qemu snapshot
```bash
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


## 制作rootfs
```bash
mkfs -t ext4 livecd.img
mount -o loop livecd.img /mnt
cp -ax /{bin,etc,lib,lib64,opt,sbin,usr,var} /mnt
mkdir -p /mnt/{proc,sys,dev,run,tmp,home,media}

# 打压缩包
# tar --xattrs-include='*.*' --numeric-owner -czvf ./rootfs.targ.gz /mnt
```

##  分区扩容
```bash
growpart /dev/vdb 1
e2fsck -f /dev/vdb1
resize2fs /dev/vdb1
```





## install gentoo
下载livecd进入, 或者使用docker进入
### 1. parted分区
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
# umount -R 可以递归解除挂载
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

### 2. portage使用内存文件系统加速
`提高SSD的寿命`
```bash
# 方法一指定特殊包不使用tmpfs
mkdir -p /etc/portage/env
echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' > /etc/portage/env/notmpfs.conf
mkdir -p /var/tmp/notmpfs
chown portage:portage /var/tmp/notmpfs
chmod 775 /var/tmp/notmpfs
echo 'www-client/chromium notmpfs.conf' >> /etc/portage/package.env

# 方法二增加tmpfs内存或者交换分区
# mount -o remount,size=N /var/tmp/portage

# 方法三 指定交换文件
# 内存不够解决方法2
## 创建交换文件
dd if=/dev/zero of=/var/cache/swap bs=1024M count=20
chmod 600 /var/cache/swap
mkswap /var/cache/swap
swapon /var/cache/swap

swapoff /var/cache/swap
```
### 3. gentoo linux内核
```bash
# 生成默认内核
emerge --ask sys-kernel/linux-firmware  sys-firmware/intel-microcode
emerge --ask sys-kernel/gentoo-sources
emerge --ask sys-kernel/dracut
make ARCH=x86_64 defconfig
make -j17
make modules_install
make install
dracut --early-microcode --kver=6.1.12-gentoo

grub-install --target=arm64-efi --boot-directory=/boot/ --efi-directory=/boot/ESP --bootloader-id=grub
# 生成的grub.cfg必须放在上面一条命令安装的grub目录中
grub-mkconfig -o /boot/grub/grub.cfg
```

### 4. 更新世界, 常用包管理命令
```bash
emerge --ask --update --deep --newuse @world
# 深度清理
emerge --ask --depclean
# 删除包
emerge --ask -c sudo
# 指定版本
emerge "=dev-lang/go-1.19.5"
# 重新构建包管理树
emerge @preserved-rebuild
# emerge将包转为间接依赖或者孤立包(可以深度自动清理掉)
emerge --oneshot sudo
# 查看已安安装包
eix-installed -a
# 查看字符串属于哪个包
equery b ls
# 查看包依赖
equery g bo
# 查看包被依赖
equery d go
# 查看哪些包使用这个标志
equery h llvm
```

### 5. systemd初始化设置
```bash
systemd-firstboot --prompt --setup-machine-id
systemctl preset-all
```