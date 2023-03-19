FROM registry.cn-hangzhou.aliyuncs.com/yuxing1994/archlinux:base-devel

# init
RUN echo 'Server = https://mirrors.tencent.com/archlinux/$repo/os/$arch' > etc/pacman.d/mirrorlist && \
tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.tencent.com/archlinuxcn/\$arch
EOF

RUN pacman -Syy && \
    pacman -S sudo git svn aria2 zsh lsd bat fzf lua ripgrep vim emacs net-tools fd --noconfirm && \
    sed -i '/# %wheel/a\%wheel ALL=(ALL) ALL' /etc/sudoers && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'LANG=zh_CN.UTF-8' >> /etc/locale.conf && \
    locale-gen

# update
RUN pacman -Syu --noconfirm && \
    pacman -Fyy && \
    pacman -S yay --noconfirm

# openssh
RUN pacman -S openssh --noconfirm && \
    sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

# dev
RUN pacman -S gcc go rustup nvm --noconfirm && \
    rustup install stable && \
    rustup component add rls-preview rust-analysis rust-src && \
    pacman -S docker mycli iredis trash-cli htop git-delta mtr wget tree lazygit zssh lrzsz --noconfirm

# user
RUN echo 'root:root' | chpasswd && \
    chsh -s /bin/zsh

WORKDIR /root

CMD [ "/usr/sbin/sshd", "-D"]
# docker build . -t registry.cn-hangzhou.aliyuncs.com/yuxing1994/archlinux:latest
# docker run -dit --name dev --restart=always --net=host --pid=host -v /var/run/docker.sock:/var/run/docker.sock -v /root/x:/root -v /root/workspace:/root/workspace -u root registry.cn-hangzhou.aliyuncs.com/yuxing1994/archlinux:latest /usr/sbin/sshd -D