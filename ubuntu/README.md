# apt
```bash
# 已安装的包
apt list --installed
dpkg -l
# 手动安装的软件包
apt-mark showmanual
# 自动清理不需要的包
apt autoremove

# 查看包依赖
apt-cache depends gcc-9-aarch64-linux-gnu
# 递归查看包依赖
apt-cache depends --recurse gcc-9-aarch64-linux-gnu

# 查看文件属于哪个包
dpkg -S /usr/aarch64-linux-gnu/lib/libc.so

# 查看包文件
## 方法一
dpkg -L gcc-9-aarch64-linux-gnu
## 方法二
dpkg-deb -c ./gcc-9-aarch64-linux-gnu_9.5.0-5ubuntu1cross1_amd64.deb

# 解包
## 方法一
mkdir extracted_files
dpkg-deb -R qemu-user-static_7.2+dfsg-7+deb12u5_amd64.deb extracted_files
## 方法二
ar -x qemu-user-static_7.2+dfsg-7+deb12u5_amd64.deb
tar -xJvf ./data.tar.xz
```

# flatpak
```bash
# ubuntu下安装
apt-get install flatpak
# 换源
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```