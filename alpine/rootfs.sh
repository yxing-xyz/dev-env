#!/bin/sh

sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
echo 'https://mirrors.aliyun.com/alpine/edge/testing' >>/etc/apk/repositories

apk update

apk add gcc g++ make automake autoconf libtool perl bash
apk add openssh-server zlib-dev openssl-dev pcre-dev pcre2-dev
apk add git net-tools lrzsz

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
