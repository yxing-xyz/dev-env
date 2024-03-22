#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
echo "Asia/Shanghai" >/etc/timezone

apt -y update
apt -y upgrade

apt install -y gcc g++ make automake autoconf libtool perl bash git lrzsz procps \
    sudo vim tmux bsdmainutils bison
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y tcpdump lsof net-tools bind9-utils bind9-dnsutils mtr wget curl iputils-arping iputils-ping iputils-tracepath

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# dev
apt install -y mycli pgcli iredis trash-cli xz-utils

apt install -y zsh
chsh -s /usr/bin/zsh root

apt install -y emacs fzf delta bat ripgrep zoxide lsd fd-find mkcert p7zip-full p7zip-rar rsync pax-utils patchelf cmake
ln -sf /usr/bin/batcat /usr/bin/bat

apt install -y golang
go install github.com/derailed/k9s@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/trzsz/trzsz-go/cmd/trz@latest
go install github.com/trzsz/trzsz-go/cmd/tsz@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/tsenart/vegeta@latest
rm -rf ~/go/pkg
rm -rf ~/.cache/*

# vfox
curl -sSL https://raw.githubusercontent.com/version-fox/vfox/main/install.sh | bash

## dotfiles
git clone https://github.com/yxing-xyz/scripts --recurse-submodules ~/workspace/github/scripts
bash /root/workspace/github/scripts/dotfiles/linux.sh
zsh -i -c "zinit update"
zsh -i -c "zinit lucid light-mode for lukechilds/zsh-nvm"
zsh -i -c "zinit lucid for zdharma-continuum/fast-syntax-highlighting"
zsh -i -c "zinit lucid for zsh-users/zsh-completions"
zsh -i -c "zinit lucid for zsh-users/zsh-autosuggestions"

## china
if [[ $(uname -a) == *"x86_64"* ]]; then
    sed -i 's|^URIs: http://archive.ubuntu.com/ubuntu/|URIs: http://mirror.nju.edu.cn/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
    sed -i 's|^URIs: http://security.ubuntu.com/ubuntu/|URIs: http://mirror.nju.edu.cn/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
else
    sed -i 's|^URIs: http://ports.ubuntu.com/ubuntu-ports/|URIs: http://mirror.nju.edu.cn/ubuntu-ports/|g' /etc/apt/sources.list.d/ubuntu.sources
fi
go env -w GO111MODULE=on
go env -w GOPROXY="https://repo.nju.edu.cn/repository/go/,direct"
