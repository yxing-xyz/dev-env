FROM  ccr.ccs.tencentyun.com/yxing-xyz/linux:arch as bootstrapper

COPY ./archlinux-build.sh /tmp/
RUN sh /tmp/archlinux-build.sh

FROM scratch
COPY --from=bootstrapper / /
