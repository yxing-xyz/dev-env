#!/bin/sh

if [[ $(uname -a) == *"x86_64"* ]]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.nju.edu.cn/centos|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
else
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/altarch/|baseurl=https://mirrors.nju.edu.cn/centos-altarch/|g' \
        -e 's|^#baseurl=http://mirror.centos.org/$contentdir/|baseurl=https://mirrors.nju.edu.cn/centos-altarch/|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
fi

yum update -y

yum install -y gcc gcc-c++ make automake autoconf libtool perl bash git lrzsz procps
yum install -y openssh-server zlib-devel openssl-devel pcre-devel
yum install -y tcpdump lsof net-tools bind-utils mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
