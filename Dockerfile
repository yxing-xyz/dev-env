#FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:builder as base
FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:code as base
RUN rm -r /var/cache/distfiles && \
    rm -r /var/cache/binpkgs


FROM scratch

COPY --from=base / /



# machine
#
# podman machine init --cpus 8 --memory 16384 --disk-size=128 --image-path stable --rootful
# ip addr add 192.168.127.2/24 dev enp0s1
# ip route add default via 192.168.127.1


# code
# 兼容docker
# export DOCKER_HOST=unix:///Users/x/.local/share/containers/podman/machine/podman-machine-default/podman.sock
# podman run -dit --name code -p 2222:22 --privileged --hostname code ccr.ccs.tencentyun.com/yxing-xyz/linux:code /bin/bash
