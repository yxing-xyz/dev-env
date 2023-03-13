FROM ccr.ccs.tencentyun.com/yxing-xyz/gentoo:gentoo-builder-2023-03-13 as base

FROM scratch
COPY --from=base / /
