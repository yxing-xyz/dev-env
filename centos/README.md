# yum
```bash
## 清除缓存
yum clean all && yum makecache

## 更新
yum update -y

## 列出已安装包
yum list installed

## 查看包文件
rpm -ql bash
## 重新安装包
yum reinstall curl

## 安装远程包
rpm -ivh https://github.com/trzsz/trzsz-go/releases/download/v1.1.7/trzsz_1.1.7_linux_x86_64.rpm
## 删除包
yum remove curl
```