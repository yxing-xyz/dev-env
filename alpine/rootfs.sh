#!/bin/sh

sed -i 's/dl-cdn.alpinelinux.org/mirrors.nju.edu.cn/g' /etc/apk/repositories
echo 'https://mirrors.nju.edu.cn/alpine/edge/testing' >>/etc/apk/repositories

apk update

apk add gcc gdb g++ make automake autoconf libtool perl bash git lrzsz procps tzdata
apk add openssh-server zlib-dev openssl-dev pcre-dev pcre2-dev
apk add tcpdump lsof net-tools bind-tools mtr wget curl

# dev
apk add pipx lazygit mycli pgcli 
pipx install iredis  

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A

echo 'root:root' | chpasswd
