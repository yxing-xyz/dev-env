#!/bin/env bash

if [[ $(uname -a) == *"x86_64"* ]]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
else
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/altarch/|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-altarch/|g' \
        -e 's|^#baseurl=http://mirror.centos.org/$contentdir/|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-altarch/|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
fi

yum update -y

yum install -y gcc gcc-c++ make automake autoconf libtool perl
yum install -y openssh-server zlib-devel openssl-devel pcre-devel
yum install -y git net-tools

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
