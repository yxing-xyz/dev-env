FROM  ccr.ccs.tencentyun.com/yxing-xyz/linux:arch as base
RUN systemd-firstboot --setup-machine-id
RUN pacman -Syu --needed --noconfirm --overwrite '*'
RUN pacman -S hugo --needed --noconfirm --overwrite '*'

FROM scratch
COPY --from=base / /
