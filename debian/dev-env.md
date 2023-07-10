# init
```bash
docker rm -f debian
docker run -dit -p 2222:22 --hostname debian --name debian -v root:/root ccr.ccs.tencentyun.com/yxing-xyz/linux:debian
```
# dev
```bash
if [[ `uname -a` =~ "x86_64" ]];then
wget https://github.com/voidint/g/releases/download/v1.5.0/g1.5.0.linux-amd64.tar.gz
else
wget https://github.com/voidint/g/releases/download/v1.5.0/g1.5.0.linux-arm64.tar.gz
tar -xzvf ./g1.5.0.linux-arm64.tar.gz
fi
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
```

1. 进入开发环境
```bash
ssh root@127.0.0.1 -p 22
password: root
```
2. 生成ssh
```bash
ssh-keygen -t rsa -C "你的邮箱"
```
3. 粘贴ssh信息到git网站中
4. 配置git信息
```bashq
git config --global user.name "你的英文名"
git config --global user.email "你的邮箱"
```
