# x86安装
## 写入物理机
```bash
# 1.下载raw.img文件
wget -q -O - 'https://mirrors.aliyun.com/openwrt/releases/23.05.1/targets/x86/64/openwrt-22.05.01-x86-64-generic-ext4-combined.img.gz' | \
gunzip -c > openwrt.img
# 2.lsblk 查看根分区
lsblk
# 3. 覆盖物理磁盘
dd if=openwrt.img of=/dev/vda bs=1M
reboot
```
## 扩容根分区
```bash
sed -i 's_https://downloads.openwrt.org_https://mirrors.aliyun.com/openwrt_' /etc/opkg/distfeeds.conf
opkg update
opkg install parted fdisk gdisk lsblk

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
```




#  取消虚拟网卡
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

# webui
###  中文
```bash
luci-i18n-base-zh-cn
```
### virtio
```bash
kmod-virtio-net
kmod-virtio-blk
```

# 生态
webfilesystem: CloudDrive2(aliyun)
video: emby
download: aria2/ui qbittorrent/ui
