FROM ${IMAGE} AS bootstrapper
ARG TARGETARCH

COPY ./rootfs.sh /tmp/rootfs.sh
RUN sh /tmp/rootfs.sh $TARGETARCH
RUN rm /tmp/rootfs.sh

CMD ["/usr/sbin/sshd", "-D"]
