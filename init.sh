#!/bin/sh

## portage tmp
echo 'tmpfs /var/tmp/portage tmpfs rw,nosuid,noatime,nodev,size=32G,mode=775,uid=portage,gid=portage,x-mount.mkdir=775 0 0' >>/etc/fstab
mount /var/tmp/portage

# 方法一指定特殊包不使用tmpfs
mkdir -p /etc/portage/env
echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' >/etc/portage/env/notmpfs.conf
mkdir -p /var/tmp/notmpfs
chown portage:portage /var/tmp/notmpfs
chmod 775 /var/tmp/notmpfs
echo 'app-admin/sudo notmpfs.conf' >>/etc/portage/package.env

# profile config
echo 'hostname="x"' >>/etc/conf.d/hostname
echo 'search yxing.xyz' >>/etc/resolv.conf
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >>/etc/locale.gen
eselect locale set zh_CN.utf8
localectl set v
locale-gen
sed -i 's/enforce=everyone/enforce=none/' /etc/security/passwdqc.conf
localectl set-keymap us

## make.conf
tee >/etc/portage/make.conf <<EOF
COMMON_FLAGS="-march=amd64 -O2 -pipe"
MAKEOPTS="-j8"
USE="grub git -selinux X systemd gtk qt5 networkmanager alsa"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License"
ACCEPT_KEYWORDS="~amd64"
VIDEO_CARDS="amdgpu"
L10N="zh-CN"
KEYWORDS="~amd64"
EOF

## sync mirros
mkdir --parents /etc/portage/repos.conf
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
sed -i "s|rsync://rsync.gentoo.org/gentoo-portage|rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage|" /etc/portage/repos.conf/gentoo.conf

## accept keyword
tee >/etc/portage/package.accept_keywords/x <<EOF
net-im/telegram-desktop-bin **
EOF

tee >/etc/portage/package.use/x <<EOF
media-fonts/nerd-fonts codenewroman
net-analyzer/mtr -gtk
EOF

## sync, set profile, update world
emerge-websync
eselect profile set default/linux/amd64/17.1/desktop/systemd
emerge --ask --verbose --update --deep --newuse @world

## pre app
emerge -u sudo app-eselect/eselect-repository eix gentoolkit eix dev-vcs/git \
    app-text/tree vim emacs dev-vcs/git app-misc/tmux \
    sys-apps/pciutils \
    sys-fs/e2fsprogs \
    sys-fs/xfsprogs \
    sys-fs/dosfstools \
    sys-fs/ntfs3g \
    sys-fs/fuse-exfat \
    sys-fs/exfat-utils \
    net-misc/dhcpcd \
    sys-boot/grub efibootmgr \
    app-alternatives/cpio \
    media-sound/alsa-utils \
    net-misc/proxychains \
    sys-kernel/gentoo-sources \
    sys-kernel/linux-firmware
eselect repository enable guru gentoo-zh
proxychains eix-sync

## net
emerge -u net-analyzer/mtr net-analyzer/netcat net-analyzer/tcpdump net-dialup/lrzsz \
    net-misc/openssh net-misc/rsync net-misc/wget net-wireless/iwd net-misc/networkmanager \
    net-misc/dhcpcd sys-apps/net-tools net-proxy/v2rayA

## terminal
emerge -u app-containers/docker app-shells/zsh app-misc/neofetch app-misc/trash-cli \
    app-shells/fzf app-text/tree dev-db/mycli dev-vcs/lazygit dev-util/git-delta sys-apps/bat \
    sys-apps/fd sys-apps/lsd sys-process/lsof sys-apps/ripgrep sys-process/htop sys-process/iotop

## dev
emerge -u dev-lang/go dev-lang/lua dev-lang/rust-bin dev-util/rustup
## desktop app
emerge -u x11-drivers/xf86-input-libinput x11-drivers/xf86-video-amdgpu x11-wm/awesome \
    x11-apps/xinput x11-apps/xset x11-misc/picom x11-misc/rofi x11-misc/xautolock x11-misc/xsel x11-terms/st x11-terms/xterm xfce-base/thunar \
    www-client/google-chrome app-editors/vscode app-i18n/ibus-rime net-im/telegram-desktop-bin feh media-gfx/flameshot \
    gnome-base/gnome-keyring gnome-extra/nm-applet lxde-base/lxappearance media-fonts/nerd-fonts media-fonts/source-han-mono \
    media-fonts/source-han-sans media-fonts/source-han-serif app-text/calibre www-apps/hugo scrot vlc
