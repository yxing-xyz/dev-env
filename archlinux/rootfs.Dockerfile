FROM ccr.ccs.tencentyun.com/yxing-xyz/alpine AS bootstrapper
ARG TARGETARCH
COPY ./rootfs.sh /tmp/rootfs.sh

RUN sh /tmp/rootfs.sh $TARGETARCH


FROM scratch
COPY --from=bootstrapper /rootfs/ /
ENV LANG=en_US.UTF-8
RUN \
	ln -sf /usr/lib/os-release /etc/os-release && \
	pacman-key --init && \
	pacman-key --populate && \
    systemd-firstboot --setup-machine-id && \
	rm -rf /etc/pacman.d/gnupg/{openpgp-revocs.d/,private-keys-v1.d/,pubring.gpg~,gnupg.S.}*

CMD ["/usr/bin/bash"]