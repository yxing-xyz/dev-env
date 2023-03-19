#!/bin/sh
source ./common.sh
init
tee >>/etc/portage/profile/profile.bashrc <<EOF
export PATH="/opt/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:\$PATH"
EOF

## make.conf
tee >/etc/portage/make.conf <<EOF
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
COMMON_FLAGS="-march=amd64 -O2 -pipe"
COMMON_FLAGS="-O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C

#### x
FEATURES="buildpkg"
## PORTAGE_BINHOST="https://gentoo-distfiles-yxing-xyz.oss-cn-hangzhou.aliyuncs.com"
ACCEPT_KEYWORDS="~amd64"
KEYWORDS="~amd64"
VIDEO_CARDS="amdgpu radeonsi"
MAKEOPTS="-j8"
USE="binary -test grub git -selinux X systemd gtk -qt5 networkmanager alsa"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License WPS-EULA NetEase as-is"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
L10N="zh-CN"
EOF

sync
eselect profile set default/linux/amd64/17.1/desktop/systemd
update
localectl set-keymap us
localectl set-locale LANG=zh_CN.utf8
app


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

# 关机之前记住网卡和蓝牙锁状态
rfkill unlock all
systemctl restart systemd-rfkill
systemctl enable systemd-rfkill
systemctl restart  NetworkManager.service
systemctl enable  NetworkManager.service
systemctl enable NetworkManager-wait-online.service
## proxy
wget https://kgithub.com/v2rayA/v2rayA/releases/download/v2.0.1/v2raya_linux_x64_2.0.1 -o ./v2raya
chmod u+x ./v2raya
mv ./v2raya /usr/local/bin/v2raya

## desktop app
### 解决循环依赖
emerge -u sys-kernel/gentoo-sources sys-kernel/linux-firmware
emerge -u  x11-drivers/xf86-input-libinput x11-drivers/xf86-video-amdgpu \
    x11-wm/awesome media-sound/alsa-utils x11-apps/xinput x11-apps/xset x11-misc/picom x11-misc/rofi x11-misc/xautolock \
    x11-misc/xsel x11-terms/st x11-terms/xterm xfce-base/thunar bluez net-wireless/bluez-tools app-office/wps-office media-fonts/ttf-wps-fonts \
    www-client/google-chrome app-editors/vscode app-i18n/ibus-rime net-im/telegram-desktop-bin feh scrot media-gfx/flameshot \
    gnome-base/gnome-keyring seahorse gnome-extra/nm-applet lxde-base/lxappearance media-fonts/nerd-fonts media-fonts/source-han-mono \
    media-fonts/source-han-sans media-feonts/source-han-serif scrot vlc mpv app-containers/podman media-sound/netease-cloud-music \
    app-text/calibre krita gimp mypaint


## group
# gpasswd -a x pcap
# gpasswd -a x wheel
# gpasswd -a x plugdev

## grub cmdline
# quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3
