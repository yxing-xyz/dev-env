FROM  ccr.ccs.tencentyun.com/yxing-xyz/linux:arch as base
RUN pacman -Syu --needed --noconfirm --overwrite '*'

FROM scratch
COPY --from=base / /
