# init
```bash
docker rm -f centos
docker run -dit -p 22:22 --hostname centos --name centos -v root:/root centos /bin/bash
```
# dev
```bash
docker exec -it centos /bin/bash
sed -i.bak \
    -e 's|^mirrorlist=|#mirrorlist=|' \
    -e 's|^#baseurl=|baseurl=|' \
    -e 's|http://mirror.centos.org|https://mirrors.tencent.com|' \
    /etc/yum.repos.d/CentOS-*.repo    #要修改的对象文件
yum clean all
yum makecache
yum update -y
yum install -y openssh-server wget git lrzsz
sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen -A
echo 'root:root' | chpasswd
wget https://github.com/voidint/g/releases/download/v1.5.0/g1.5.0.linux-arm64.tar.gz
tar -xzvf ./g1.5.0.linux-arm64.tar.gz
mv ./g /usr/local/bin/
g install 1.15.15
g install 1.17.13
go env -w GO111MODULE=on
go env -w GOPRIVATE=git.woa.com
go env -w GOPROXY=https://goproxy.woa.com,https://goproxy.cn,direct
echo 'export GOROOT="${HOME}/.g/go"' >> ~/.bashrc
echo 'PATH="${HOME}/.g/bin:${GOROOT}/bin:$PATH"' >> ~/.bashrc
tee > ~/.gitconfig <<EOF
[url "git@git.woa.com:"]
    insteadOf = https://git.woa.com
[url "git@git.woa.com:"]
    insteadOf = http://git.woa.com
EOF
source ~/.bashrc
# 启动sshd
/usr/sbin/sshd
# 退出容器
exit
```

1. 进入开发环境
```bash
ssh root@127.0.0.1 -p 22
password: root
```
2. 生成ssh
```bash
ssh-keygen -t rsa -C "你的腾讯邮箱"
```
3. 粘贴ssh信息到git网站中
4. 配置git信息
```bashq
git config --global user.name "你的腾讯英文名"
git config --global user.email "你的腾讯邮箱"
```
