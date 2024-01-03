#!/bin/sh

sed -i 's/dl-cdn.alpinelinux.org/mirrrors.nju.edu.cn/g' /etc/apk/repositories
echo 'https://mirrrors.nju.edu.cn/alpine/edge/testing' >>/etc/apk/repositories

apk update

apk add gcc g++ make automake autoconf libtool perl bash git lrzsz
apk add openssh-server zlib-dev openssl-dev pcre-dev pcre2-dev
apk add tcpdump lsof net-tools bind-tools mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
