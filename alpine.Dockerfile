FROM alpine AS bootstrapper
ARG TARGETARCH

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories