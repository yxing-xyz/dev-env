FROM  ccr.ccs.tencentyun.com/yxing-xyz/archlinux:latest as base
COPY ./build.sh /tmp/
RUN /tmp/build.sh


FROM scratch
COPY --from=base / /
