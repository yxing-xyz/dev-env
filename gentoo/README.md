# emerge
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
# search keyword in installed package
eix -I kernel
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
dispatch-conf
```

# 安装步骤
## 1. parted 分区
略
## 2. 挂载分区chroot分区
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

## 3. chroot后执行
```bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```
## 4. 执行desktop-init.sh
略

## 5. 内核和配置grub
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

# grub引导
略，见语雀
```

# 6. 初始化systemd
```bash
# 初始化语言，键盘
systemd-firstboot --prompt --setup-machine-id
# 提供了一个"预设"文件，可用于启用一组合理的默认服务。
systemctl preset-all
```
