#!/bin/sh
source ./common.sh

# swapon
echo '/var/cache/swapfile none swap defaults 0 0' >> /etc/fstab
dd if=/dev/zero of=/var/cache/swap bs=1024M count=8
chmod 600 /var/cache/swap
mkswap /var/cache/swap

# init
init

## make.conf
tee >/etc/portage/make.conf <<EOF
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
COMMON_FLAGS="-march=x86-64 -O2 -pipe"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C

#### x
FEATURES="buildpkg nostrip"
## PORTAGE_BINHOST="https://gentoo-distfiles-yxing-xyz.oss-cn-hangzhou.aliyuncs.com"
#ACCEPT_KEYWORDS="~amd64"
#KEYWORDS="~amd64"
VIDEO_CARDS="amdgpu radeonsi"
MAKEOPTS="-j4"
USE="binary -test grub git -selinux X systemd gtk -qt5 networkmanager alsa"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License WPS-EULA NetEase as-is"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
L10N="zh-CN"
UNINSTALL_IGNORE="/bin /lib /lib64 /sbin"
EOF

sync
eselect profile set default/linux/amd64/17.1/desktop/systemd/merged-usr
update
app

## terminal app
emerge -u net-wireless/iwd net-misc/networkmanager cmus
## desktop app
emerge -u sys-kernel/gentoo-sources sys-kernel/linux-firmware
emerge -u x11-drivers/xf86-input-libinput x11-drivers/xf86-video-amdgpu acpi \
       x11-wm/awesome media-sound/alsa-utils x11-apps/xinput x11-apps/xset x11-misc/picom x11-misc/rofi x11-misc/xautolock x11-misc/slock \
       x11-misc/xsel x11-terms/xterm xfce-base/thunar bluez net-wireless/bluez-tools app-office/wps-office media-fonts/ttf-wps-fonts \
       www-client/google-chrome app-editors/vscode app-i18n/ibus-rime net-im/telegram-desktop-bin feh scrot media-gfx/flameshot \
       gnome-base/gnome-keyring seahorse gnome-extra/nm-applet lxde-base/lxappearance media-fonts/nerd-fonts media-fonts/source-han-mono \
       media-fonts/source-han-sans media-fonts/source-han-serif media-fonts/noto media-fonts/noto-cjk media-fonts/noto-emoji media-fonts/wqy-microhei \
       scrot vlc mpv app-containers/podman media-sound/netease-cloud-music \
       peek

## design
emerge -u krita gimp mypaint


# wpa 守护进程, 或者手动自己启动也可以
#tee > /etc/wpa_supplicant/wpa_supplicant.conf-wlan0 <<EOF
## Allow users in the 'wheel' group to control wpa_supplicant
#ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
#
## Make this file writable for wpa_gui / wpa_cli
#update_config=1
#EOF
#cd /etc/systemd/system/multi-user.target.wants
#ln -s /lib/systemd/system/wpa_supplicant@.service wpa_supplicant@wlan0.service

localectl set-keymap us
localectl set-locale LANG=zh_CN.utf8

## 调整声卡顺序, lspci -nn | grep -i audio, 修改后面两个ID
tee > /etc/modprobe.d/alsa-base.conf <<EOF
options snd-hda-intel index=0 model=auto vid=1022 pid=15e3
options snd-hda-intel index=1 model=auto vid=1002 pid=1637
EOF
## 插入鼠标禁用触摸板
tee >/etc/udev/rules.d/01-touchpad.rules <<EOF
SUBSYSTEM=="input", ATTRS{name}=="RAPOO BT4.0 Mouse", ACTION=="add", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/x/.Xauthority", RUN+="/usr/bin/xinput --disable 'UNIW0001:00 093A:0255 Touchpad'"
SUBSYSTEM=="input", ATTRS{name}=="RAPOO BT4.0 Mouse", ACTION=="remove", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/x/.Xauthority", RUN+="/usr/bin/xinput --enable 'UNIW0001:00 093A:0255 Touchpad'"
EOF

# 关机之前记住网卡和蓝牙锁状态
rfkill unlock all
systemctl restart systemd-rfkill
systemctl enable systemd-rfkill
systemctl restart  NetworkManager.service
systemctl enable  NetworkManager.service
systemctl enable NetworkManager-wait-online.service
systemctl start  alsa-restore
systemctl enable alsa-restore

## systemd配置
echo 'HandlePowerKey=hibernate' >> /etc/systemd/logind.conf
tee >>/etc/systemd/system.conf <<EOF
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
EOF

## systemd.serivce
tee >>/etc/systemd/system/slock@.service <<EOF
[Unit]
Description=Lock X session using slock for user %i
Before=sleep.target

[Service]
User=%i
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/xset dpms force suspend
ExecStart=/usr/bin/slock

[Install]
WantedBy=sleep.target
EOF
systemctl enable slock@x

## proxy
wget https://kgithub.com/v2rayA/v2rayA/releases/download/v2.0.1/v2raya_linux_x64_2.0.1 -o ./v2raya
chmod u+x ./v2raya
mv ./v2raya /usr/local/bin/v2raya
## proxychains
echo 'socks5  127.0.0.1 1080' >> /etc/proxychains.conf

## user
useradd -m -G wheel,pcap,plugdev,audio -s /bin/zsh x
echo 'x:x' | chpasswd

## xorg config
cp -f ./config/00-myinput.conf /etc/X11/xorg.conf.d
# tty key map
cp -f ./config/us.map.gz /usr/share/keymaps/i386/qwerty/us.map.gz
# xorg key map
cp -f ./config/pc /usr/share/X11/xkb/symbols/pc
### 声卡
cp -f  ./config/.asoundrc /home/x

echo 'auth       optional     pam_gnome_keyring.so' >> /etc/pam.d/login
echo 'session    optional     pam_gnome_keyring.so auto_start' >> /etc/pam.d/login

# rustup
# rustup-init
# rustup-init-gentoo -s