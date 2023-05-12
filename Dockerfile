#FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:builder as base
FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:code as base
RUN rm -r /var/cache/distfiles && \
    rm -r /var/cache/binpkgs


FROM scratch

COPY --from=base / /



# machine
#
# 兼容docker
# export DOCKER_HOST=unix:///Users/x/.local/share/containers/podman/machine/podman-machine-default/podman.sock

# podman machine init --cpus 8 --memory 16384 --disk-size=128 --image-path stable --rootful --now
# ip addr add 192.168.127.2/24 dev enp0s1
# ip route add default via 192.168.127.1



# arch desktop
# podman run -it --name arch-amd64 --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" docker.io/archlinux


# 整理amd64 code
url="ccr.ccs.tencentyun.com/yxing-xyz/linux:code-amd64"
podman commit -s -a "yxing.xyz" code ${url}
podman push ${url}
podman rm -f code
podman run -dit --name code -p 22:22  -v home:/home/x --privileged --hostname code ${url} /bin/bash


# 整理arm64 code
url="ccr.ccs.tencentyun.com/yxing-xyz/linux:code-arm64"
docker commit -a "yxing.xyz" code ${url}
tee >> Dockerfile <<EOF
FROM ${url} as base
RUN rm -r /var/cache/distfiles && \
    rm -r /var/cache/binpkgs

FROM scratch

COPY --from=base / /
EOF
docker build -t ${url} .
rm ./Dockerfile
docker rm -f code
docker run -dit --name code -p 22:22  -v home:/home/x --privileged --hostname code ${url} /bin/bash
docker push ${url}
