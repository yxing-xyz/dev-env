#!/bin/bash
read -d '' content <<EOF
$(date +"%Y-%m-%d %H:%M:%S")

EOF

echo "$content" >./url.txt
echo >>./url.txt

tee >>./url.txt <<EOF
docker run -dit --name code --hostname code --restart always \\
    --privileged --pull always --platform linux/amd64 \\
    -p 22:22 -p 80:80 -p 443:443 -p 8080:8080 \\
    -v /data:/data \\
    registry.cn-hangzhou.aliyuncs.com/yxing-xyz/linux:ubuntu-devel bash -c "mkdir -p /run/sshd && /usr/sbin/sshd -D"
EOF
echo >>./url.txt
RepoLatestRelease() {
    owner=$1
    repo=$2
    list=$(curl -s https://api.github.com/repos/${owner}/${repo}/releases/latest | grep browser_download_url)
    array=($(echo "$list" | grep -Eo "\"https://.+\""))
    for element in ${array[@]}; do
        element=${element:1}
        element=${element%?}
        echo "$element"
    done
}

githubReleaseURL() {
    owner=$1
    repo=$2
    filepath="${owner}-${repo}.txt"
    content="$(RepoLatestRelease "${owner}" "${repo}" )"
    echo "$content" >> "$filepath"
    printf "%s\n\n" "$filepath" >> url.txt
}
githubReleaseURL yxing-xyz scripts
githubReleaseURL trzsz trzsz-go
githubReleaseURL derailed k9s
githubReleaseURL jesseduffield lazygit
githubReleaseURL tsenart vegeta
githubReleaseURL FiloSottile mkcert
githubReleaseURL version-fox vfox
githubReleaseURL jesseduffield lazydocker
githubReleaseURL v2fly v2ray-core
githubReleaseURL v2rayA v2rayA
githubReleaseURL localsend localsend
githubReleaseURL FelisCatus SwitchyOmega
githubReleaseURL wagoodman dive