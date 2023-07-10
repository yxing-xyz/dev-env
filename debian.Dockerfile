FROM debian AS bootstrapper
ARG TARGETARCH

RUN apt update && \
    sed -i 's#\w*\.debian\.org#mirrors\.aliyun\.com#g' /etc/apt/sources.list.d/debian.sources