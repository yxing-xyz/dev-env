#!/bin/sh

init() {
    ## portage tmp
    echo 'tmpfs /var/tmp/portage tmpfs rw,nosuid,noatime,nodev,size=16G,mode=775,uid=portage,gid=portage,x-mount.mkdir=775 0 0' >>/etc/fstab
    mount /var/tmp/portage

    # 方法一指定特殊包不使用tmpfs
    mkdir -p /etc/portage/env
    echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' >/etc/portage/env/notmpfs.conf
    mkdir -p /var/tmp/notmpfs
    chown portage:portage /var/tmp/notmpfs
    chmod 775 /var/tmp/notmpfs
    echo 'app-admin/sudo notmpfs.conf' >>/etc/portage/package.env

    # profile config
    echo 'hostname="x"' > /etc/conf.d/hostname
    echo 'search yxing.xyz' >>/etc/resolv.conf
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
    echo "zh_CN.UTF-8 UTF-8" >>/etc/locale.gen
    locale-gen
    sed -i 's/enforce=everyone/enforce=none/' /etc/security/passwdqc.conf

    ## sync mirros
    mkdir --parents /etc/portage/repos.conf
    cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
    sed -i "s|rsync://rsync.gentoo.org/gentoo-portage|rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage|" /etc/portage/repos.conf/gentoo.conf

    ## accept keyword
    tee >/etc/portage/package.accept_keywords/x <<EOF
net-im/telegram-desktop-bin **
net-misc/proxychains **
net-proxy/v2rayA **
app-misc/trash-cli **
dev-db/mycli **
dev-vcs/lazygit **
dev-python/cli_helpers **
EOF

    tee >/etc/portage/package.use/x <<EOF
media-fonts/nerd-fonts codenewroman
net-analyzer/mtr -gtk
EOF
}
sync() {
    ## sync, set profile, update world
    emerge-webrsync
    emerge --sync
}

update() {
    emerge --ask --verbose --update --deep --newuse @world
}

app() {
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
        net-misc/proxychains
    sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    eselect locale set zh_CN.utf8
    eselect repository enable guru gentoo-zh
    eix-sync

    ## net
    emerge -u net-analyzer/mtr net-analyzer/netcat net-analyzer/tcpdump net-dialup/lrzsz \
        net-misc/openssh net-misc/rsync net-misc/wget net-wireless/iwd net-misc/networkmanager \
        net-misc/dhcpcd sys-apps/net-tools

    ## dev
    emerge -u dev-lang/go dev-lang/lua nodejs

    ## terminal
    emerge -u app-containers/docker app-shells/zsh app-misc/neofetch app-misc/trash-cli \
        app-shells/fzf app-text/tree dev-db/mycli dev-vcs/lazygit dev-util/git-delta sys-apps/bat \
        sys-apps/fd sys-apps/lsd sys-process/lsof sys-apps/ripgrep sys-process/htop sys-process/iotop
}
