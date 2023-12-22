#!/bin/sh

sed -i -e 's|^metalink=|#metalink=|' /etc/yum.repos.d/*.repo

sed -i '/\[baseos\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/BaseOS/$basearch/os/\' /etc/yum.repos.d/centos.repo
sed -i '/\[baseos-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/BaseOS/$basearch/debug/tree\' /etc/yum.repos.d/centos.repo
sed -i '/\[baseos-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/BaseOS/source/tree/\' /etc/yum.repos.d/centos.repo

sed -i '/\[appstream\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/AppStream/$basearch/os\' /etc/yum.repos.d/centos.repo
sed -i '/\[appstream-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/AppStream/$basearch/debug/tree/\' /etc/yum.repos.d/centos.repo
sed -i '/\[appstream-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/AppStream/source/tree/\' /etc/yum.repos.d/centos.repo

sed -i '/\[crb\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/CRB/$basearch/os\' /etc/yum.repos.d/centos.repo
sed -i '/\[crb-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/CRB/$basearch/debug/tree/\' /etc/yum.repos.d/centos.repo
sed -i '/\[crb-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/CRB/source/tree/\' /etc/yum.repos.d/centos.repo

###############################
sed -i '/\[highavailability\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/HighAvailability/$basearch/os/\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[highavailability-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/HighAvailability/$basearch/debug/tree\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[highavailability-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/HighAvailability/source/tree/\' /etc/yum.repos.d/centos-addons.repo

sed -i '/\[nfv\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/NFV/$basearch/os/\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[nfv-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/NFV/$basearch/debug/tree\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[nfv-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/NFV/source/tree/\' /etc/yum.repos.d/centos-addons.repo

sed -i '/\[rt\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/RT/$basearch/os/\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[rt-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/RT/$basearch/debug/tree\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[rt-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/RT/source/tree/\' /etc/yum.repos.d/centos-addons.repo

sed -i '/\[resilientstorage\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/ResilientStorage/$basearch/os/\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[resilientstorage-debuginfo\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/ResilientStorage/$basearch/debug/tree\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[resilientstorage-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/$releasever-stream/ResilientStorage/source/tree/\' /etc/yum.repos.d/centos-addons.repo

sed -i '/\[extras-common\]/abaseurl=https://mirrors.aliyun.com/centos-stream/SIGs/$releasever-stream/extras/$basearch/extras-common\' /etc/yum.repos.d/centos-addons.repo
sed -i '/\[extras-common-source\]/abaseurl=https://mirrors.aliyun.com/centos-stream/SIGs/$releasever-stream/extras/source/extras-common\' /etc/yum.repos.d/centos-addons.repo

yum clean all && yum makecache

yum update -y

yum install -y gcc gcc-c++ make automake autoconf libtool perl bash git lrzsz
yum install -y openssh-server zlib-devel openssl-devel pcre-devel
yum install -y tcpdump lsof net-tools bind-utils mtr wget curl

sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
