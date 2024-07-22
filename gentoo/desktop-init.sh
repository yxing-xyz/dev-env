#!/bin/sh
source ./common.sh

# swapon
echo '/var/cache/swapfile none swap defaults 0 0' >>/etc/fstab
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
eselect profile set default/linux/amd64/23.0/desktop/systemd
update
app

## terminal app
emerge -u net-wireless/iwd net-misc/networkmanager cmus
## desktop app
emerge -u sys-kernel/gentoo-kernel-bin sys-kernel/linux-firmware
emerge -u x11-drivers/xf86-input-libinput x11-drivers/xf86-video-amdgpu acpi \
       x11-wm/awesome media-sound/alsa-utils x11-apps/xinput x11-apps/xset x11-misc/picom x11-misc/rofi x11-misc/xautolock x11-misc/slock \
       x11-misc/xsel x11-terms/xterm xfce-base/thunar bluez net-wireless/bluez-tools app-office/wps-office media-fonts/ttf-wps-fonts \
       www-client/google-chrome app-editors/vscode app-i18n/ibus-rime rime-luna-pinyin net-im/telegram-desktop-bin feh scrot media-gfx/flameshot \
       gnome-base/gnome-keyring seahorse gnome-extra/nm-applet lxde-base/lxappearance media-fonts/nerd-fonts media-fonts/source-han-mono \
       media-fonts/source-han-sans media-fonts/source-han-serif media-fonts/noto media-fonts/noto-cjk media-fonts/noto-emoji media-fonts/wqy-microhei \
       scrot vlc mpv app-containers/docker docker-cli media-sound/netease-cloud-music \
       peek gnome-extra/zenity

## design
emerge -u krita gimp mypaint

echo 'auth       optional     pam_gnome_keyring.so' >>/etc/pam.d/login
echo 'session    optional     pam_gnome_keyring.so auto_start' >>/etc/pam.d/login
