FROM ccr.ccs.tencentyun.com/yxing-xyz/gentoo:gentoo-builder-2023-03-13 as base

FROM scratch
COPY --from=base / /


# run gentoo-builder
# docker run -dit --name gentoo-builder --privileged --hostname gentoo-builder ccr.ccs.tencentyun.com/yxing-xyz/gentoo:gentoo-builder-2023-03-15 /bin/bash

# run code
# docker run -dit --name code -p 22:22  -v home:/home --privileged --hostname code ccr.ccs.tencentyun.com/yxing-xyz/gentoo:arm-code-2023-03-14 /bin/bash
