#!/bin/sh

init() {
    mkdir -p -m 777 /opt/x
    ## portage tmp
    echo 'tmpfs /var/tmp/portage tmpfs rw,nosuid,noatime,nodev,size=8G,mode=775,uid=portage,gid=portage,x-mount.mkdir=775 0 0' >>/etc/fstab
    mount /var/tmp/portage

    # 方法一指定特殊包不使用tmpfs
    mkdir -p /etc/portage/env
    echo 'PORTAGE_TMPDIR = "/var/tmp/notmpfs"' >/etc/portage/env/notmpfs.conf
    mkdir -p /var/tmp/notmpfs
    chown portage:portage /var/tmp/notmpfs
    chmod 775 /var/tmp/notmpfs
    echo 'app-admin/sudo notmpfs.conf' >>/etc/portage/package.env

    # profile config
    echo 'hostname="x"' >/etc/conf.d/hostname
    echo 'search yxing.xyz' >>/etc/resolv.conf
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
    echo "zh_CN.UTF-8 UTF-8" >>/etc/locale.gen
    locale-gen
    sed -i 's/enforce=everyone/enforce=none/' /etc/security/passwdqc.conf

    ## sync mirros
    mkdir --parents /etc/portage/repos.conf
    cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
    sed -i "s|rsync://rsync.gentoo.org/gentoo-portage|rsync://mirrors.tuna.nju.edu.cn/gentoo-portage|" /etc/portage/repos.conf/gentoo.conf

    ## accept keyword
    tee >>/etc/portage/package.accept_keywords/x <<EOF
EOF
    ## use
    tee >>/etc/portage/package.use/x <<EOF
media-fonts/nerd-fonts codenewroman ubuntumono
net-analyzer/mtr -gtk
dev-lang/ghc -llvm
net-wireless/wpa_supplicant tkip
EOF
    ## profile
    mkdir -p /etc/portage/profile/package.provided
    #    tee >/etc/portage/profile/package.provided/x <<EOF
    #net-libs/nodejs-18.14.2
    #    tee > /etc/portage/profile/profile.bashrc <<EOF
    #    export PATH=/opt/.nvm/versions/node/v18.15.0/bin:$PATH
    #EOF
    tee >>/etc/portage/profile/use.mask <<EOF
split-usr
EOF

    echo 'dev-lang/rust' >>/etc/portage/package.mask/x
    echo 'dev-qt/qtwebengine' >>/etc/portage/package.mask/x
    echo 'net-libs/nodejs' >>/etc/portage/package.mask/x
}
sync() {
    ## sync, set profile, update world
    emerge-webrsync
    emerge --sync
}

update() {
    emerge -u merge-usr
    merge-usr
    emerge app-portage/cpuid2cpuflags
    echo "*/* $(cpuid2cpuflags)" >/etc/portage/package.use/00cpu-flags

    emerge --ask --verbose --update --deep --newuse @world
}

app() {
    emerge -u --autounmask-write sudo app-eselect/eselect-repository eix gentoolkit dev-vcs/git \
        app-text/tree vim emacs dev-vcs/git app-misc/tmux \
        sys-apps/pciutils \
        sys-fs/e2fsprogs \
        sys-fs/xfsprogs \
        sys-fs/dosfstools \
        sys-fs/ntfs3g \
        sys-boot/grub efibootmgr \
        app-alternatives/cpio \
        app-arch/p7zip \
        gdb \
        usbutils
    ACCEPT_KEYWORDS='~arm64 ~amd64' emerge -u zellij sys-fs/fuse-exfat sys-fs/exfat-utils net-misc/proxychains eclean-kernel

    eselect editor set emacs
    mkdir -p /etc/sudoers.d
    echo '%wheel ALL=(ALL:ALL) ALL' >/etc/sudoers.d/wheel
    eselect locale set zh_CN.utf8
    eselect repository enable guru gentoo-zh
    eix-sync

    ## net
    emerge -u --autounmask-write net-analyzer/mtr net-analyzer/netcat net-analyzer/tcpdump \
        net-dialup/lrzsz net-misc/openssh net-misc/rsync net-misc/wget \
        net-misc/dhcpcd sys-apps/net-tools net-dns/bind-tools

    # rust binary
    echo 'dev-lang/rust' >>/etc/portage/package.mask/x
    ## dev
    emerge -u dev-lang/go dev-lang/lua sys-devel/clang
    USE='clippy rust-analyzer rust-src rustfmt' emerge -u dev-lang/rust-bin

    ## terminal
    emerge -u app-containers/docker-cli app-shells/zsh app-misc/neofetch app-misc/trash-cli \
        app-shells/fzf app-text/tree dev-util/git-delta sys-apps/bat \
        sys-apps/fd sys-apps/lsd sys-process/lsof sys-apps/ripgrep sys-process/htop sys-process/iotop \
        strace cloc dev-util/shellcheck-bin app-admin/helm exa sshfs app-misc/jq caddy \
        ntp stress
    ACCEPT_KEYWORDS='~arm64 ~amd64' emerge -u dev-db/mycli dev-vcs/lazygit sys-apps/sd bear \
        diff-so-fancy difftastic www-apps/hugo v2ray-bin rustup zoxide dev-util/marksman-bin crosstool-ng
}
