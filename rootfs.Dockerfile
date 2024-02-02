FROM ${IMAGE} AS bootstrapper
ARG TARGETARCH

COPY ./rootfs.sh /tmp/rootfs.sh
COPY ./dotfiles /root/workspace/dotfiles

RUN sh /tmp/rootfs.sh $TARGETARCH
RUN rm /tmp/rootfs.sh

CMD ["/usr/sbin/sshd", "-D"]
