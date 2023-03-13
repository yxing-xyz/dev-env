#!/bin/sh
source ./common.sh

init

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
## FEATURES="buildpkg"
## ossfs gentoo-distfiles-yxing-xyz /var/cache/distfiles -o url=http://oss-cn-hangzhou.aliyuncs.com
## PORTAGE_BINHOST="https://gentoo-distfiles-yxing-xyz.oss-cn-hangzhou.aliyuncs.com"
ACCEPT_KEYWORDS="~amd64"
KEYWORDS="~amd64"
VIDEO_CARDS="amdgpu"
MAKEOPTS="-j8"
USE="grub git -selinux X systemd gtk -qt5 networkmanager alsa"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
L10N="zh-CN"
EOF

sync
eselect profile set default/linux/amd64/17.1/desktop/systemd
update
localectl set-keymap us
localectl set-locale LANG=zh_CN.utf8
app
## proxy
wget https://kgithub.com/v2rayA/v2rayA/releases/download/v2.0.1/v2raya_linux_x64_2.0.1 -o ./v2raya
chmod u+x ./v2raya
mv ./v2raya /usr/local/bin/v2raya

## desktop app
emerge -u sys-kernel/gentoo-sources sys-kernel/linux-firmware x11-drivers/xf86-input-libinput x11-drivers/xf86-video-amdgpu \
    x11-wm/awesome media-sound/alsa-utils x11-apps/xinput x11-apps/xset x11-misc/picom x11-misc/rofi x11-misc/xautolock \
    x11-misc/xsel x11-terms/st x11-terms/xterm xfce-base/thunar \
    www-client/google-chrome app-editors/vscode app-i18n/ibus-rime net-im/telegram-desktop-bin feh media-gfx/flameshot \
    gnome-base/gnome-keyring gnome-extra/nm-applet lxde-base/lxappearance media-fonts/nerd-fonts media-fonts/source-han-mono \
    media-fonts/source-han-sans media-fonts/source-han-serif app-text/calibre www-apps/hugo scrot vlc
