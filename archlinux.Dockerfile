FROM  ccr.ccs.tencentyun.com/yxing-xyz/archlinux:latest as base

RUN pacman -Syu --needed --noconfirm --overwrite '*' && \
    rm -f /tmp/* || true


FROM scratch
COPY --from=base / /
