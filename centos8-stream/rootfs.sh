#!/bin/sh

sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo

yum clean all && yum makecache

yum update -y

yum install -y gcc gcc-c++ make automake autoconf libtool perl procps
yum install -y openssh-server zlib-devel openssl-devel pcre-devel
yum install -y git net-tools

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
