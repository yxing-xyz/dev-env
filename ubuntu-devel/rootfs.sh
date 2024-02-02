#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
echo "Asia/Shanghai" >/etc/timezone

apt update
apt upgrade

apt install -y gcc g++ make automake autoconf libtool perl bash git lrzsz procps \
    sudo vim tmux
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y tcpdump lsof net-tools bind9-utils bind9-dnsutils mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# dev
apt install -y mycli pgcli iredis trash-cli xz-utils libncurses-dev

apt install -y zsh
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
chsh -s /usr/bin/zsh root

apt install -y emacs fzf delta bat ripgrep zoxide lsd fd-find mkcert

apt install -y golang
go install github.com/derailed/k9s@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/trzsz/trzsz-go/cmd/trz@latest
go install github.com/trzsz/trzsz-go/cmd/tsz@latest
go install github.com/trzsz/trzsz-go/cmd/tszsz@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/tsenart/vegeta@latest

sh /root/workspace/dotfiles/linux.sh
## china
if [[ $(uname -a) == *"x86_64"* ]]; then
    sed 's|archive.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
    sed 's|security.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
else
    sed 's|ports.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
fi

go env -w GO111MODULE=on
go env -w GOPROXY="https://repo.nju.edu.cn/repository/go/,direct"
