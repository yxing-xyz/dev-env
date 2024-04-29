# x86安装
## 写入物理机
```bash
# 1.下载raw.img文件
mkdir /mem
mount -t tmpfs -o size=512M tmpfs /mem
cd /mem
wget -q -O - 'https://mirrors.aliyun.com/openwrt/releases/22.03.0/targets/x86/64/openwrt-22.03.0-x86-64-generic-ext4-combined-efi.img.gz' | \
gunzip -c > openwrt.img
# 2.lsblk 查看根分区
lsblk
# 3. 覆盖物理磁盘,如果磁盘包含正在使用的根分区，那么需要到initramfs阶段去覆盖
dd if=openwrt.img of=/dev/vda
reboot
```

## 换源
```bash
sed -i 's_https://downloads.openwrt.org_https://mirrors.aliyun.com/openwrt_' /etc/opkg/distfeeds.conf
```

## 扩容根分区
```bash
opkg update
opkg install parted fdisk gdisk lsblk blkid

# gdisk修复gpt
gdisk /dev/vdb
# 输入 r 进入 Recovery & Transformation menu。
# 输入 b 以重建GPT分区表备份。
# 输入 w 保存更改并退出。这将自动把新的备份GPT分区放在磁盘的末尾。

# 扩容分区
parted -f -s /dev/vda resizepart 2 100%
# 扩容文件系统
opkg install losetup resize2fs
losetup /dev/loop0 /dev/vda2
resize2fs -f /dev/loop0
losetup -d /dev/loop0
```

# x86升级
```bash
# 下载
mkdir /mem
mount -t tmpfs -o size=512M tmpfs /mem
cd /mem
wget -q -O - 'https://mirrors.aliyun.com/openwrt/releases/23.05.2/targets/x86/64/openwrt-23.05.2-x86-64-generic-ext4-combined.img.gz' | \
gunzip -c > openwrt.img
# 创建loop设备
losetup /dev/loop0 ./openwrt.img
# 创建分区设备文件
partx -av /dev/loop0
# 导出分区 也可以直接从raw文件中分割分区
dd if=/dev/loop0p1 of=./openwrt-boot.img
dd if=/dev/loop0p2 of=./openwrt-rootfs.img
# 删除分区设备文件
partx -d /dev/loop0
# 删除loop设备
losetup -d /dev/loop0

dd if=./openwrt-boot.img of=/dev/vda1
ROOT_BLK="$(readlink -f /sys/dev/block/"$(awk -e \
'$9=="/dev/root"{print $3}' /proc/self/mountinfo)")"
ROOT_DISK="/dev/$(basename "${ROOT_BLK%/*}")"
ROOT_DEV="/dev/${ROOT_BLK##*/}"
ROOT_UUID="$(partx -g -o UUID "${ROOT_DEV}" "${ROOT_DISK}")"
sed -i -r -e "s|(PARTUUID=)\S+|\1${ROOT_UUID}|g" /boot/grub/grub.cfg

dd if=./openwrt-rootfs.img of=/dev/vda2
```


# 用户空间
##  取消虚拟网卡
```bash
uci delete network.@device[0]
uci delete network.globals
uci delete network.lan
uci add network interface
uci set network.@interface[-1].name='eth0'
uci set network.@interface[-1].proto=dhcp
uci commit network
/etc/init.d/network reload
```

## webui
###  中文
```bash
luci-i18n-base-zh-cn
```
### virtio
```bash
kmod-virtio-net
kmod-virtio-blk
```

## 生态
webfilesystem: CloudDrive2(aliyun)
video: emby
download: aria2/ui qbittorrent/ui
