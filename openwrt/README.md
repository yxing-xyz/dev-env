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
# mirror
```bash
sed -i 's_https://downloads.openwrt.org_https://mirrors.aliyun.com/openwrt_' /etc/opkg/distfeeds.conf
opkg update

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
