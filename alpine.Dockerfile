FROM alpine AS bootstrapper
ARG TARGETARCH

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
