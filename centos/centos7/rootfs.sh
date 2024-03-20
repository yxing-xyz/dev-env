#!/bin/bash
set -e
yum clean all && yum makecache
yum update -y

yum install -y gcc gcc-c++ make automake autoconf libtool perl bash git lrzsz procps psmisc epel-release sudo vim tmux
yum install -y openssh-server zlib-devel openssl-devel pcre-devel
yum install -y tcpdump lsof net-tools bind-utils mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# china
if [[ $(uname -a) == *"x86_64"* ]]; then
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.nju.edu.cn/centos|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
else
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/altarch/|baseurl=https://mirror.nju.edu.cn/centos-altarch/|g' \
        -e 's|^#baseurl=http://mirror.centos.org/$contentdir/|baseurl=https://mirror.nju.edu.cn/centos-altarch/|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo
fi
sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!https\?://download\.fedoraproject\.org/pub/epel!https://mirror.nju.edu.cn/epel!g' \
    -e 's!https\?://download\.example/pub/epel!https://mirror.nju.edu.cn/epel!g' \
    -i /etc/yum.repos.d/epel{,-testing}.repo
