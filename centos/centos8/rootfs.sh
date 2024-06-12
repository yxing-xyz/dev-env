#!/bin/sh
set -e
## mirror
sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org|baseurl=https://mirror.nju.edu.cn/centos-vault|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo
yum clean all && yum makecache
yum update -y
yum install epel-release
yum update -y
sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!https\?://download\.fedoraproject\.org/pub/epel!https://mirror.nju.edu.cn/epel!g' \
    -e 's!https\?://download\.example/pub/epel!https://mirror.nju.edu.cn/epel!g' \
    -i /etc/yum.repos.d/epel{,-testing}.repo