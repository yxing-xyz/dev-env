# apk
```bash
# 安装包
apk add linux-virt
# 查看已经安装的包
apk list -I
# 查看包内容
apk info -L busybox
# 升级
apk update
apk add --upgrade apk-tools
apk upgrade --available
```

# 安装
```bash
# alpine的setup脚本
tee >/etc/apk/repositories <<EOF
http://mirrors.nju.edu.cn/alpine/latest-stable/main
http://mirrors.nju.edu.cn/alpine/latest-stable/community
http://mirrors.nju.edu.cn/alpine/edge/testing/
EOF
apk add alpine-conf
/sbin/setup-alpine
```
# 常用package
```bash
apk add ripgrep fd fzf
```


# 滚动升级
```bash
setup-apkrepos
# e 编辑文件
# 将版本号改latest-stable,保存退出
apk update
apk add --upgrade apk-tools
apk upgrade --available
sync
reboot
```