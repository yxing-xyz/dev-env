#!/bin/sh
set -e
echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/ >>/etc/apk/repositories
apk update

apk add linux-headers gcc gdb g++ make automake autoconf libtool perl bash git procps tzdata netcat-openbsd \
    sudo vim tmux htop
apk add openssh-server zlib-dev openssl-dev pcre-dev pcre2-dev
apk add tcpdump lsof net-tools bind-tools mtr wget curl
apk add shadow

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
useradd -m -s /bin/bash x
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# aline setup
apk add alpine-conf

# china
tee >/etc/apk/repositories <<EOF
http://mirrors.nju.edu.cn/alpine/latest-stable/main
http://mirrors.nju.edu.cn/alpine/latest-stable/community
http://mirrors.nju.edu.cn/alpine/edge/testing/
EOF
