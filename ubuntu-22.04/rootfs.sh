#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
echo "Asia/Shanghai" >/etc/timezone
if [[ $(uname -a) == *"x86_64"* ]]; then
    sed 's|archive.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
    sed 's|security.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
else
    sed 's|ports.ubuntu.com|mirrors.nju.edu.cn|' -i /etc/apt/sources.list
fi
apt update
apt upgrade

apt install -y gcc g++ make automake autoconf libtool perl bash git lrzsz procps
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y tcpdump lsof net-tools bind9-utils bind9-dnsutils mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
