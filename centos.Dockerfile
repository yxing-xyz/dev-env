FROM centos AS bootstrapper
ARG TARGETARCH

RUN sed -i.bak \
    -e 's|^mirrorlist=|#mirrorlist=|' \
    -e 's|^#baseurl=|baseurl=|' \
    -e 's|http://mirror.centos.org|https://mirrors.aliyun.com|' \
    /etc/yum.repos.d/CentOS-*.repo   && \
yum clean all && \
yum makecache && \
yum update -y && \
yum install -y openssh-server wget git lrzsz && \
sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config && \
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
ssh-keygen -A && \
echo 'root:root' | chpasswd