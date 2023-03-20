FROM ccr.ccs.tencentyun.com/yxing-xyz/gentoo:gentoo-builder-2023-03-13 as base

FROM scratch
COPY --from=base / /

RUN eclean-dist --deep && \
    eclean-pkg --deep

# run builder
# podman run -dit --name builder --privileged --hostname builder ccr.ccs.tencentyun.com/yxing-xyz/linux:builder-2023-03-16-1 /bin/bash

# run code
# podman run -dit --name code -p 2222:2222  -v x:/home/x --privileged --hostname code ccr.ccs.tencentyun.com/yxing-xyz/linux:code-2023-03-20 /bin/bash