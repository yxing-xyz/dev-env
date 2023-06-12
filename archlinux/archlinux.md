
# init
```bash
systemd-firstboot --setup-machine-id
if [[ `uname -a` =~ "x86_64" ]];then
    echo 'Server = https://mirrors.tencent.com/archlinux/$repo/os/$arch' > etc/pacman.d/mirrorlist
else
    echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo' > etc/pacman.d/mirrorlist
fi

tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.tencent.com/archlinuxcn/\$arch
EOF


sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads|ParallelDownloads|' /etc/pacman.conf

pacman -Syy && \
    pacman -S glibc sudo git svn aria2 zsh lsd sd bat fzf zoxide lua ripgrep vim neovim emacs net-tools fd man-pages-zh_cn fakeroot make --noconfirm && \
    mkdir -p /etc/sudoers.d && \
    echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'LANG=zh_CN.UTF-8' >> /etc/locale.conf && \
    locale-gen

# password
echo 'root:x' | chpasswd
useradd -m -G wheel -s /bin/zsh x
echo 'x:x' | chpasswd

# update
pacman -Syu --noconfirm && \
    pacman -Fyy && \
    pacman -S yay --noconfirm

# openssh
pacman -S openssh --noconfirm && \
    sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

# dev
pacman -S gcc go rustup --noconfirm && \
    rustup install stable && \
    rustup component add rls-preview rust-analysis rust-src && \
    pacman -S docker mycli iredis trash-cli htop git-delta mtr wget tree lazygit \
    zssh lrzsz podman hugo --noconfirm


## user
## su x -c "yay -S trzsz --noconfirm"
```