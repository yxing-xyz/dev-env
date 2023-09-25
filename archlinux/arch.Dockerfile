FROM  ccr.ccs.tencentyun.com/yxing-xyz/linux:arch as bootstrapper

COPY ./arch.sh /tmp/
RUN sh /tmp/arch.sh

FROM scratch
COPY --from=bootstrapper / /
