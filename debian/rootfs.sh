#!/bin/env bash

sed -i 's#\w*\.debian\.org#mirrors\.aliyun\.com#g' /etc/apt/sources.list.d/debian.sources

apt update

apt install -y gcc g++ make automake autoconf libtool perl
apt install -y openssh-server zlib1g-dev libssl-dev libpcre2-dev libpcre3-dev
apt install -y git net-tools lrzsz

sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir /var/run/sshd
ssh-keygen -A

echo 'root:root' | chpasswd
