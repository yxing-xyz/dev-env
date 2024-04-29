# 安装系统核心命令
```bash
# 安装archlinux基本包
pacstrap -i /mnt base base-devel linux linux-firmware linux-headers grub networkmanager dhcpcd vim net-tools squashfs-tools
# 保存新系统分区表到/mnt/etc/fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
# arch-chroot切换
arch-chroot /mnt /bin/bash
# amdgpu驱动
pacman -S xf86-video-amdgpu --needed --noconfirm --overwrite '*'
```

# pacman
```bash
# 列出仓库中的所有包
pacman -Sl extra
# 列出所有单独指定安装的软件包
pacman -Qe
# 删除软件包
pacman -R nvm --noconfirm
# 清空未使用的包
pacman -R $(pacman -Qtdq)
# 安装构建包
pacman -U ./构建包名
# 检查文件属性
pacman -Qkk | grep mime
# 解决keyring过期问题
pacman -S archlinux-keyring
pacman-key --init
pacman-key --populate
```

# asp
```bash
# 下载gcc的PKGBUILD
asp checkout gcc
```

# makepkg
makepkg可以在PKGBUILD文件目录下执行，构建arch包

● --ignorearch 忽略arch

● --nodeps  忽略依赖

● --skippgpcheck 忽略pgp检查

● --skipchecksums 忽略hash检查

# aur自动更新脚本
确保有一个x名称的普通用户
```bash
set -e
echo '%wheel ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel

if [[ $(uname -a) == *"x86_64"* ]]; then
  echo 'Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch' > etc/pacman.d/mirrorlist
else
  echo 'Server = https://mirrors.nju.edu.cn/archlinuxarm/$arch/$repo' > /etc/pacman.d/mirrorlist
fi

pacman -Sy
pacman -S archlinux-keyring --needed --noconfirm
pacman -Su --needed --noconfirm
pacman-key --init
pacman-key --populate
su x -c '
export GO111MODULE=on
export GOPROXY=https://repo.nju.edu.cn/repository/go/,direct
yay -Syu --nouseask --needed --noconfirm --overwrite "*"
'
rm -rf /var/lib/pacman/sync/* || true
rm -rf /home/x/.* || true
rm -rf /home/x/* || true
rm -rf /tmp/* || true

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
```
# 软件包
```bash
#!/usr/bin/sh
# set -euxo pipefail
set -o errexit
set -o nounset
set -o pipefail
################################
# 蓝牙
pacman -S bluez bluez-utils pulseaudio-bluetooth --needed --noconfirm --overwrite '*'
systemctl start bluetooth.service
systemctl enable bluetooth.service
# 安装图形界面                     剪切板 窗口特效 合并X11配置   xorg-xev查看x的输入事件   setxkbmap设置键盘
pacman -S xorg-server xorg-xinit xclip xsel picom xorg-xrdb  xorg-xinput light xorg-xev xorg-setxkbmap --needed --noconfirm --overwrite '*'
# awesome
pacman -S awesome --needed --noconfirm --overwrite '*'

# gnome密码环  密码环管理工具 清除密码 gnome-keyring-daemon -r -d
pacman -S gnome-keyring seahorse --needed --noconfirm --overwrite '*'

# 导入CPG key/
pacman -S archlinux-keyring --needed --noconfirm --overwrite '*'
pacman -S archlinuxcn-keyring --needed --noconfirm --overwrite '*'
# 安装 yay    asp   降级
pacman -S yay asp downgrade --needed --noconfirm --overwrite '*'
# 用户态依赖
pacman -S glibc musl gcc clang --needed --noconfirm --overwrite '*'

# 常用开发工具
# 编辑
pacman -S emacs vim nvim --needed --noconfirm --overwrite '*'
# language
pacman -S go rustup nvm pyenv --needed --noconfirm --overwrite '*'
# 打印进程调用 修改elf
pacman -S strace patchelf pax-utils --needed --noconfirm --overwrite '*'
# 数据库命令行
yay -S iredis mycli pgcli-git litecli --needed --noconfirm --overwrite '*'
# 手册
yay -S man-pages man-pages-zh_cn--needed navi --noconfirm --overwrite '*'
# 代码行数统计
pacman -S cloc --needed --noconfirm --overwrite '*'
# shell脚本检查
pacman -S shellcheck --needed --noconfirm --overwrite '*'
# Makefile生成clangd提示配置文件
pacman -S bear --needed --noconfirm --overwrite '*'
# cosmo编译器
yay -S cosmocc-bin --noconfirm --overwrite '*'

############# 虚拟机相关 ##############
# rdesktop -f 222.240.148.238:50010 -u administrator -p hngat2015 -a 32 -r clipboard:PRIMARYCLIPBOARD -r disk:h=/home/x
# x0vncserver -display :0 -passwordfile ~/.vnc/passwd
# xfreerdp /bpp:32 /gfx +aero +fonts /d:192.168.44.118 /u:x /p:x /v:192.168.44.118
#         启动vnc服务端 win远程桌面客户端
pacman -S tigervnc freerdp --needed --noconfirm --overwrite '*'


############## 资源监控 ###############
# 硬件信息lshw lscpu lsblk lspci 模块 lsmod 模块信息modinfo dmi信息解码 smartmontools磁盘信息
pacman -S lshw hardinfo dmidecode --needed smartmontools --noconfirm --overwrite '*'
# 系统信息
pacman -S neofetch --needed --noconfirm --overwrite '*'
# 实时查看网络、cpu、内存、磁盘等多功能实时监控, sysstat多单功能瞬时查看
pacman -S nmon dstat sysstat --needed --noconfirm --overwrite '*'
# 资源监控
pacman -S glances htop --needed --noconfirm --overwrite '*'
# 实时cpu监控
pacman -S s-tui --needed --noconfirm --overwrite '*'
# 内存
pacman -S smem --needed --noconfirm --overwrite '*'

################## 压力 #################
pacman -S stress --needed --noconfirm
##################  net工具 ##############
# ifconfig、route在net-tools包中，nslookup、dig在dnsutils包中，ftp、telnet等在inetutils包中，ip命令在iproute2包中
pacman -S net-tools dnsutils inetutils iproute2 bridge-utils --needed --noconfirm
# 网卡网速监控 conntrack-tools:  conntrack -L -j查看连接跟踪, ipvsadm查看ipvs aircrack-ng 网卡混合监听和破解wifi密码
pacman -S bmon bwm-ng nload iftop conntrack-tools ipvsadm aircrack-ng --needed --noconfirm --overwrite '*'
# 进程统计网络带宽
pacman -S nethogs bandwhich --needed --noconfirm --overwrite '*'
# 查看ip连接 端口扫描namp、端口netcat、端口数据发送端口转发socat、http测试 nmap -Pn -v -A www.baidu.com  -p 0-10000 websocket客户端
pacman -S iptstate nmap openbsd-netcat socat httpie websocat --needed --noconfirm --overwrite '*'
# 测试本机发送tcp/udp最大带宽 时延 丢包, 路由测试工具mtr
pacman -S iperf mtr --needed --noconfirm --overwrite '*'
# 抓包
pacman -S iptraf-ng wireshark-qt wireshark-gtk ngrep --needed --noconfirm --overwrite '*'
# 内网穿透
# sshuttle --dns -vr root@114.215.181.234 192.168.0.0/16 --ssh-cmd 'ssh -i /home/x/workspace/juewei/k8s/cert/品牌中心密钥对.key'
pacman -S frp localtunnel sshuttle --needed --noconfirm --overwrite '*'
# 网络管理服务, 界面和插件
# nmcli dev wifi list
# nmcli device wifi connect "x" password "qwer1234"
# nmcli connection import type openvpn file openvpn.ovpn
pacman -S networkmanager network-manager-applet networkmanager-openvpn networkmanager-strongswan --needed --noconfirm --overwrite '*'
################## 磁盘和文件系统工具 ###############
# 进程磁盘读写监控iotop  磁盘和cpu负载iostat
pacman -S iotop --needed --noconfirm --overwrite '*'
# 查看磁盘使用
pacman -S ncdu --needed --noconfirm --overwrite '*'
# 文件系统扩容 resize2fs fsck检查文件系统错误
pacman -S e2fsprogs --needed --noconfirm --overwrite '*'
# 文件读写测试
pacman -S fio --needed --noconfirm --overwrite '*'
# lsof
pacman -S lsof --needed --noconfirm --overwrite '*'
# kpartx创建loop设备子设备 mkinitcpio,dracut是initramfs工具
pacman -S multipath-tools mkinitcpio dracut --needed --noconfirm --overwrite '*'



################### 终端神器 #####################
# shell
pacman -S zsh --needed --noconfirm --overwrite '*'
# 终端复用
pacman -S zellij tmux --needed --noconfirm --overwrite '*'
# 终端文件管理
pacman -S ranger vifm nnn mc --needed --noconfirm --overwrite '*' # 终端文件管理
pacman -S atool --needed --noconfirm --overwrite '*'              # 用于预览各种压缩文件
pacman -S highlight --needed --noconfirm --overwrite '*'          # 用于在预览代码，支持多色彩高亮显示代码
pacman -S w3m --needed --noconfirm --overwrite '*'                # lynx, w3m 或 elinks：这三个东西都是命令行下的网页浏览器，都用于htm
pacman -S poppler poppler-data --needed --noconfirm --overwrite '*'            # PDF阅读
pacman -S mediainfo --needed --noconfirm --overwrite '*'          # mediainfo 或 perl-image-exiftool ： audio/video
# nnn
sudo pacman -S nnn atool libarchive trash-cli rclone fustrashe2 xdg-utils
# 命令模糊搜索 fzf
pacman -S fzf --needed --noconfirm --overwrite '*'
# 目录文件搜索 fd
pacman -S fd --needed --noconfirm --overwrite '*'
# 文件内容搜索 rg ag ack
pacman -S ripgrep the_silver_searcher ack --needed --noconfirm --overwrite '*'
# 彩色ls 彩色cat、彩色日志、彩色diff
pacman -S lsd bat ccze  --noconfirm --needed --overwrite '*'
# 文件系统空间计算类似du
pacman -S erdtree  --noconfirm --needed --overwrite '*'
#         diff
pacman -S difftastic --noconfirm --needed --overwrite '*'
#         sed
pacman -S sd --noconfirm --needed --overwrite '*'
#         shell任务管理器
pacman -S pueue --noconfirm --needed --overwrite '*'
# 终端表格、文本三神器
pacman -S awk sed grep --needed --noconfirm --overwrite '*'
# TERM=screen-256color sshpass -p 'fm09j#Ojiogj32i' ssh -p 2222 -o ServerAliveInterval=60 root@127.0.0.1
pacman -S sshpass mosh --needed --noconfirm --overwrite '*'
# 查看进度
pacman -S progress --needed --noconfirm --overwrite '*'
# 目录树形结构
pacman -S exa tree --needed --noconfirm --overwrite '*'
# 回收站
yay -S trash-cli --needed --noconfirm --overwrite '*'
# 解压软件
pacman -S p7zip-natspec rar zip unzip-natspec --needed --noconfirm
# 支持NTFS文件系统
pacman -S ntfs-3g dosfstools --needed --noconfirm
# 挂载远程ssh目录
pacman -S sshfs --needed --noconfirm --overwrite '*'
# 终端音乐
pacman -S cmus --needed --noconfirm --overwrite '*'
# 终端二维码 echo "http://baidu.com" | qrencode -o - -t UTF8
pacman -S qrencode --needed --noconfirm --overwrite '*'
# 局域网的ip二维码上下传文件
yay -S qrcp --needed --noconfirm --overwrite '*'
# 传输文件
# zenity拉起文件管理  trzsz lrzsz zssh croc中继服务器传输文件
yay -S zenity trzsz croc --needed --noconfirm --overwrite '*'
# HTTP代理, 梯子客户端
pacman -S squid v2raya proxychains --needed --noconfirm --overwrite '*'
# http共享
sudo npm install -g serve
# youtube、youku下载工具、BT下载工具
pacman -S wget curl axel aria2 transmission-cli you-get youtube-dl --needed --noconfirm --overwrite '*'
# 翻译
pacman -S translate-shell  --needed --noconfirm --overwrite '*'
# 交互式shell自动化
pacman -S expect  --needed --noconfirm --overwrite '*'
# 假装很忙
pacman -S genact  --needed --noconfirm --overwrite '*'
# 视频网站资源下载器
yay -S lux-dl --needed --noconfirm --overwrite '*'
# 终端查看markdown
pacman -S glow --needed --noconfirm --overwrite '*'
# ssl
pacman -S openssl easy-rsa mkcert --needed --noconfirm --overwrite '*'
# 图片处理
pacman -S  imagemagick --needed --noconfirm --overwrite '*'
# 终端GIF,终端录屏
pacman -S asciinema --needed --noconfirm --overwrite '*'
# 文本转图表
pacman -S graphviz --needed --noconfirm --overwrite '*'
# 文档转换
pacman -S pandoc --needed --noconfirm --overwrite '*'
# 终端艺术字体
pacman -S figlet --needed --noconfirm --overwrite '*'
# 字体集格式转换  sudo python -m fontTools.ttLib ./CodeNewRomanNerdFont-Regular.otf -o ./CodeNewRomanNerdFont-Regular.ttf
pacman -S fonttools --needed --noconfirm --overwrite '*'
# 处理 Excel 或 CSV ，csvkit 提供了 in2csv，csvcut，csvjoin，csvgrep 等方便易用的工具
yay -S csvkit --needed --noconfirm --overwrite '*'
# json文件处理以及格式化显示
pacman -S jq --needed --noconfirm --overwrite '*'
# 计算工具
pacman -S datamash --needed --noconfirm --overwrite '*'
# 监听文件变更运行命令
pacman -S entr --needed --noconfirm --overwrite '*'
# 文件传输
pacman -S rsync restic --needed --noconfirm --overwrite '*'
# cpu限速
pacman -S cpulimit --needed --noconfirm --overwrite '*'
# 网络限速
yay -S wondershaper-git --needed --noconfirm --overwrite '*'
# 邮件伪造
pacman -S swaks --needed --noconfirm --overwrite '*'
# 暴力破解工具
pacman -S hydra hashcat fcrackzip --needed --noconfirm --overwrite '*'
# 制作ISO镜像
# xorriso -as mkisofs -R -J -T -v --no-emul-boot --boot-load-size 4 --boot-info-table -V "CentOS" \
# -c isolinux/boot.cat -b isolinux/isolinux.bin -o ./boot.iso ./centos7-cdrom/
pacman -S xorriso mkisolinux --needed --noconfirm --overwrite '*'
# git tui
pacma lazygit --needed --noconfirm --overwrite '*'
# docker工具 dive查看镜像层 slim合并镜像层
pacma lazydocker dive --needed --noconfirm --overwrite '*'
yay -S docker-slim-bin --needed --noconfirm --overwrite '*'
# k8s
pacman -S k9s helm tekton-cli --needed --noconfirm --overwrite '*'
# android
pacman -S android-apktool --needed --noconfirm --overwrite '*'

############### GUI  ###########
# 文件管理
yay -S sigma-file-manager --needed --noconfirm --overwrite '*'
# 启动工具
pacman -S rofi --needed --noconfirm --overwrite '*'
# 截图
pacman -S scrot flameshot maim --needed --noconfirm --overwrite '*'
# 显示键盘按键, eudev键盘原始事件
pacman -S screenkey evtest --needed --noconfirm --overwrite '*'
# 图像预览
pacman -S feh --noconfirm --overwrite '*' --needed
# 输入法
pacman -S librime ibus-rime --needed --noconfirm --overwrite '*'
# 字体
pacman -S nerd-fonts-complete otf-font-awesome ttf-dejavu powerline-fonts noto-fonts-cjk --needed --noconfirm --overwrite '*'
# 主题
pacman -S lxappearance-gtk3 deepin-gtk-theme gtk-engine-murrine deepin-icon-theme --needed --noconfirm --overwrite '*'
# wqy
pacman -S `sudo pacman -Ssq 'wqy-*'` --needed --noconfirm --overwrite '*'
# adobe
pacman -S `sudo pacman -Ssq 'adobe-source-*'` --needed --noconfirm --overwrite '*'
# 浏览器
yay -S google-chrome ungoogled-chromium-bin chromium firefox firefox-i18n-zh-cn pepper-flash --needed --noconfirm
# Telegram
pacman -S telegram-desktop --needed --noconfirm --overwrite '*'
# 影音播放
pacman -S vlc mpd mpv kodi ffmpeg mplayer smplayer --needed --noconfirm --overwrite '*'
# 下载
pacman -S qbittorrent amule --needed --noconfirm --overwrite '*'
# FTP
pacman -S filezilla --needed --noconfirm --overwrite '*'
# 截图转Latex语法
yay -S mathpix-snipping-tool --needed --noconfirm --overwrite '*'
# 图像编辑
pacman -S krita gimp --needed --noconfirm --overwrite '*'         #图像编辑
pacman -S inkscape --needed --noconfirm --overwrite '*'           #矢量图形编辑软件
pacman -S rawtherapee --needed --noconfirm --overwrite '*'        #跨平台图片处理
# 绘图
pacman -S mypaint --needed --noconfirm --overwrite '*'            #绘画涂鸦软件
pacman -S blender --needed --noconfirm --overwrite '*'            #3D工具
# 文档查看
pacman -S evince foxitreader --needed --noconfirm --overwrite '*' # PDF
pacman -S kchmviewer --needed --noconfirm --overwrite '*'         # CHM
pacman -S calibre --needed --noconfirm --overwrite '*'            # 图书转换器
# 开源CAD
pacman -S kicad --needed --noconfirm --overwrite '*'
```
