## qemu

### docker的qemu启动命令
```bash
/opt/homebrew/bin/qemu-system-aarch64
-accel hvf
-cpu host
-machine virt,highmem=off
-m 16384
-smp 8
-kernel /Applications/Docker.app/Contents/Resources/linuxkit/kernel
-append page_poison=1 vsyscall=emulate panic=1 nospec_store_bypass_disable noibrs noibpb no_stf_barrier mitigations=off linuxkit.unified_cgroup_hierarchy=1    vpnkit.connect=tcp+bootstrap+client://192.168.65.2:54760/a8f36b5c3f2bb8125044cbdce643cae23bf73557ebc1a3a95ffd87993e1d8516 vpnkit.disable=osxfs-data console=ttyAMA0
-initrd /Applications/Docker.app/Contents/Resources/linuxkit/initrd.img
-serial pipe:/var/folders/hd/sgm8y5kj4g9740whp7b8w37m0000gn/T/qemu-console1934410198/fifo
-drive if=none,file=/Users/x/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw,format=raw,id=hd0
-device virtio-blk-pci,drive=hd0,serial=dummyserial -netdev socket,id=net1,fd=3 -device virtio-net-device,netdev=net1,mac=02:50:00:00:00:01
-vga none
-nographic
-monitor none
```

### podman的qemu启动命令
```bash
qemu-system-aarch64 -m 16384 -smp 8 \
-fw_cfg name=opt/com.coreos/config,file=/Users/x/.config/containers/podman/machine/qemu/podman-machine-default.ign \
-qmp unix:/var/folders/hd/sgm8y5kj4g9740whp7b8w37m0000gn/T/podman/qmp_podman-machine-default.sock,server=on,wait=off \
-netdev socket,id=vlan,fd=3 \
-device virtio-net-pci,netdev=vlan,mac=5a:94:ef:e4:0c:ee \
-device virtio-serial \
-chardev socket,path=/var/folders/hd/sgm8y5kj4g9740whp7b8w37m0000gn/T/podman/podman-machine-default_ready.sock,server=on,wait=off,id=apodman-machine-default_ready \
-device virtserialport,chardev=apodman-machine-default_ready,name=org.fedoraproject.port.0 \
-pidfile /var/folders/hd/sgm8y5kj4g9740whp7b8w37m0000gn/T/podman/podman-machine-default_vm.pid \
-accel hvf -accel tcg -cpu host -M virt,highmem=on \
-drive file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on \
-drive file=/Users/x/.local/share/containers/podman/machine/qemu/podman-machine-default_ovmf_vars.fd,if=pflash,format=raw \
-virtfs local,path=/Users,mount_tag=vol0,security_model=none \
-virtfs local,path=/private,mount_tag=vol1,security_model=none \
-virtfs local,path=/var/folders,mount_tag=vol2,security_model=none \
-drive if=virtio,file=/Users/x/.local/share/containers/podman/machine/qemu/podman-machine-default_fedora-coreos-37.20230322.2.0-qemu.aarch64.qcow2
```
### 创建qcow2磁盘文件
```bash
qemu-img create -f qcow2 gentoo.qcow2 100G
# 复制一块qcow2
qemu-img create -f qcow2 -F qcow2 -b a.qcow2 b.qcow2
```


```bash
### mac m1 qemucd启动
# 桥接网卡参数 -nic vmnet-bridged,ifname=en0 \
# -bios /opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-aarch64-code.fd \
qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -accel tcg \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-arm-vars.fd \
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
    -accel tcg \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-arm-vars.fd \
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
    -accel tcg \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.1/share/qemu/edk2-arm-vars.fd \
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
## GRUB手动引导Window
```bash
menuentry "Windows 10" {
    insmod part_msdos
    insmod ntfs
    set root=(hd0,gpt1)
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    boot
}
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

## wpa_cli
```bash
# 创建网络返回网络ID
wpa_cli -i wlan0 add_network
# 设置ssid
wpa_cli -i wlan0 set_network 0 ssid '"B701"'
# 设置psk
wpa_cli -i wlan0 set_network 0 psk '"nalzj4ka"'
# 启用网络
wpa_cli -i wlan0 enable_network 0
# 保存网络
wpa_cli -i wlan0 save_config
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
dd if=/dev/zero of=/var/cache/swap bs=1024M count=8
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
# 修改USE, 编译所有依赖的包
emerge --update --changed-use @world
# 删除包，如果是顶层包，merge树会移除包，中间包只是移除顶层依赖关系
emerge --ask -c sudo
# 指定版本
emerge "=dev-lang/go-1.19.5"
# 重新构建包管理树
emerge @preserved-rebuild
# 重新安装包，不使用顶层依赖
emerge --oneshot sudo
# 查看已安安装包
eix-installed -a
# 查看依赖的顶层包
eix --color -c --world

# 查看包依赖
equery g bo
# 查看包被依赖
equery d go
# 查看哪些包使用这个标志
equery h llvm
# 查看文件属于哪个包
equery b ls
# 查看包有哪些文件
equery f glibc
# 清除源文件/var/cache/distfiles
eclean-dist --deep
# 清除二进制包/var/cache/binpkgs
eclean-pkg --deep
# 生成分发二进制安装包
quickpkg "*/*"
# 重建二进制包索引
emaint binhost --fix
# 重新安装所有包
emerge -e @world
revdep-rebuild
emerge --ignore-default-opts -va1 $(qdepends -CQqqF'%{CAT}/%{PN}:%{SLOT}' '^dev-libs/boost:0/1.70.0')
# 配置文件更新
etc-update
# 配置文件合并
dispatch-cofn
```

### 5. systemd初始化设置
```bash
systemd-firstboot --prompt --setup-machine-id
systemctl preset-all
```

### 6. merge-usr
```bash
\cp -rv --preserve=all --remove-destination bin/* usr/bin
\cp -rv --preserve=all --remove-destination lib/* usr/lib
\cp -rv --preserve=all --remove-destination lib64/* usr/lib64
\cp -rv --preserve=all --remove-destination sbin/* usr/bin

rm -rf bin lib lib64 sbin
ln -s usr/bin bin
ln -s usr/lib lib
ln -s usr/lib64 lib64
ln -s usr/bin sbin
```