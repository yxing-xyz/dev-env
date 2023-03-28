#FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:builder as base
FROM ccr.ccs.tencentyun.com/yxing-xyz/linux:code as base
RUN rm -r /var/cache/distfiles && \
    rm -r /var/cache/binpkgs


FROM scratch

COPY --from=base / /



# run builder
# podman run -dit --name builder --privileged --hostname builder ccr.ccs.tencentyun.com/yxing-xyz/linux:builder /bin/bash

# run code
# 兼容docker
# export DOCKER_HOST=unix:///Users/x/.local/share/containers/podman/machine/podman-machine-default/podman.sock
# podman run -dit --name code -p 2222:2222  -v x:/home/x --privileged --hostname code ccr.ccs.tencentyun.com/yxing-xyz/linux:code /bin/bash
