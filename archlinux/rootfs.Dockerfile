FROM alpine AS bootstrapper
ARG TARGETARCH

COPY ./rootfs.sh /tmp/rootfs.sh
RUN sh /tmp/rootfs.sh $TARGETARCH

FROM scratch
COPY --from=bootstrapper /rootfs/ /
ENV LANG=en_US.UTF-8
RUN ln -sf /usr/lib/os-release /etc/os-release && \
	pacman-key --init && \
	pacman-key --populate

CMD ["/usr/bin/bash"]
