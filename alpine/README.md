# apk
```bash
# 查看已经安装的包
apk list -I
# 查看包内容
apk info -L busybox
# 查看包 依赖
apk info -R zlib
# 查看包被依赖
apk info -r zlib
# 递归强制删除
apk del -rf tcpdump
# 递归下载apk包
apk fetch -R wget
# 解压apk包
tar -xvf wget.apk
# 修复或者升级已经安装的包
apk fix
# 全面升级
apk update
apk add --upgrade apk-tools
apk upgrade --available
```


# 安装
见packer目录

## aliyun
### 支持shutdown命令,阿里云控制台重启ECS
tee > /sbin/shutdown <<EOF
#!/bin/sh
/sbin/poweroff
EOF
sudo chmod 4777 /sbin/shutdown

### nvme
编辑`etc/mkinitfs/mkinitfs.conf`

添加`features="nvme"` nvme驱动

执行打包
```bash
mkinitfs -c /etc/mkinitfs/mkinitfs.conf -b / $(ls /lib/modules/)
```

### cloud-init
```bash
apk add cloud-init
sed -i 's/disable_root.*/disable_root: false/' /etc/cloud/cloud.cfg
sed -i "s/^datasource_list:.*/datasource_list: ['AliYun']/" /etc/cloud/cloud.cfg
sed -i "s/^ssh_pwauth.*/ssh_pwauth: true/" /etc/cloud/cloud.cfg
rm -rf /var/lib/cloud/*

rc-update add cloud-init-local
rc-update add cloud-init-hotplugd
rc-update add cloud-init
rc-update add cloud-config
rc-update add cloud-final
```

### service
#### agent
```bash
去一台官方镜像阿里云机器拷贝整个agent目录出来，然后放入alpine linux中，将缺失的库拷贝到glibc混合层中
```
#### assist
```bash
wget "https://aliyun-client-assist.oss-accelerate.aliyuncs.com/linux/aliyun_assist_latest_update.zip"
unzip  -o ./aliyun_assist_latest_update.zip -d /usr/local/share/aliyun-assist/
rm -f ./aliyun_assist_latest_update.zip
```
#### 主机监控
```bash
ARGUS_VERSION=3.5.11 /bin/bash -c "$(curl -s https://cms-agent-cn-hangzhou.oss-cn-hangzhou-internal.aliyuncs.com/Argus/agent_install-1.10.sh)"
```
#### init script
```bash
tee <<EOF > /etc/local.d/aliyun-service.start
/usr/local/cloudmonitor/bin/argusagent -d
/usr/local/aegis/aegis_client/aegis_12_11/AliYunDun
/usr/local/aegis/aegis_client/aegis_12_11/AliYunDunMonitor
/usr/local/aegis/aegis_update/AliYunDunUpdate
EOF
chmod a+x /etc/local.d/aliyun-service.start
```
