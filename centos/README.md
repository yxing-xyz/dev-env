# yum/dnf
```bash
## 清除缓存
yum clean all && yum makecache

## 更新
yum update -y

## 列出已安装包
yum list installed

## 查看包文件
rpm -ql bash
## 查看文件属于哪个包
yum provides /lib64/libc.so.6
## 重新安装包
yum reinstall curl

## 安装远程包
rpm -ivh https://github.com/trzsz/trzsz-go/releases/download/v1.1.7/trzsz_1.1.7_linux_x86_64.rpm
## 删除包
yum remove curl

## 安装库的debuginfo
dnf debuginfo-install libxcrypt
```
