#!/bin/env bash

###################  mirror ######################
tee >>/etc/pacman.conf <<EOF
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.tencent.com/archlinuxcn/\$arch
EOF

if [[ $(uname -a) == *"x86_64"* ]]; then
  echo 'Server = https://mirrors.tencent.com/archlinux/$repo/os/$arch' >etc/pacman.d/mirrorlist
elif [[ $(uname -a) == *"aarch"* ]]; then
  echo 'Server = https://mirrors.tencent.com/archlinuxarm/$arch/$repo' >/etc/pacman.d/mirrorlist
else
  echo 'unknown architecture'
  exit 1
fi

pacman -Syu --noconfirm &&
  pacman -S glibc musl gcc clang sudo man-pages-zh_cn zsh --noconfirm

###################  etc ######################
mkdir -p /etc/sudoers.d &&
  echo '%wheel ALL=(ALL:ALL) ALL' >/etc/sudoers.d/wheel &&
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&
  sed -i 's/#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen
echo 'LANG=zh_CN.UTF-8' >>/etc/locale.conf &&
  locale-gen

###################  user ######################
## password
echo 'root:root' | chpasswd
useradd -M -G wheel -s /bin/zsh x
echo 'x:x' | chpasswd
## openssh
pacman -S openssh --noconfirm &&
  sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config &&
  sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  ssh-keygen -A

###################  dev ######################
mkdir /opt/x
chmod 777 /opt/x
pacman -S yay bash expect git svn aria2 vim neovim emacs lsof \
  htop lsd sd bat fzf fd zoxide ripgrep lazygit git-delta \
  go rustup \
  tcpdump net-tools dnsutils mtr wget curl zssh lrzsz \
  docker mycli iredis trash-cli \
  hugo --noconfirm
yay trzsz
yay bear2-git

# rustup default stable
# rustup component add rust-analyzer
# rustup component add rust-src
