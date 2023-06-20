FROM  ccr.ccs.tencentyun.com/yxing-xyz/linux:arch as bootstrapper

COPY ./build.sh /tmp/
RUN sh /tmp/build.sh

FROM scratch
COPY --from=bootstrapper / /
