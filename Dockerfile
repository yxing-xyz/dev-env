FROM ccr.ccs.tencentyun.com/yxing-xyz/gentoo:gentoo-builder-2023-03-13 as base

FROM scratch
COPY --from=base / /

RUN eclean-dist --deep && \
    eclean-pkg --deep

# run builder
# podman run -dit --name builder-2023-03-16-1 --privileged --hostname builder ccr.ccs.tencentyun.com/yxing-xyz/linux:builder-2023-03-16-1 /bin/bash

# run code
# podman run -dit --name code-2023-03-16-1 -p 22:22  -v home:/home --privileged --hostname code ccr.ccs.tencentyun.com/yxing-xyz/linux:code-2023-03-16-1 /bin/bash
