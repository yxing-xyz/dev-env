#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt -y update
apt -y upgrade

apt install -y gcc g++ make automake autoconf libtool perl bash git lrzsz procps netcat-openbsd \
    sudo vim tmux htop
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y tcpdump lsof net-tools bind9-utils bind9-dnsutils mtr wget curl

sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir /var/run/sshd
ssh-keygen -A

echo 'root:root' | chpasswd
useradd -m -s /bin/bash x
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

## china
# debian 12容器修改了配置文件格式
sed -i 's/deb.debian.org/mirrors.nju.edu.cn/g' /etc/apt/sources.list.d/debian.sources
