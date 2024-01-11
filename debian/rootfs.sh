#!/bin/env bash

# debian 12容器修改了配置文件格式
sed -i 's/deb.debian.org/mirrors.nju.edu.cn/g' /etc/apt/sources.list.d/debian.sources

apt update

apt install -y gcc g++ make automake autoconf libtool perl bash git lrzsz procps
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y tcpdump lsof net-tools bind9-utils bind9-dnsutils mtr wget curl

sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir /var/run/sshd
ssh-keygen -A

echo 'root:root' | chpasswd
