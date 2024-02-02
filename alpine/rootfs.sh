#!/bin/sh
echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/ >>/etc/apk/repositories
apk update

apk add gcc gdb g++ make automake autoconf libtool perl bash git lrzsz procps tzdata \
    sudo vim tmux htop
apk add openssh-server zlib-dev openssl-dev pcre-dev pcre2-dev
apk add tcpdump lsof net-tools bind-tools mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# china
sed -i 's/dl-cdn.alpinelinux.org/mirrors.nju.edu.cn/g' /etc/apk/repositories
