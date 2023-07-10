FROM debian AS bootstrapper
ARG TARGETARCH

RUN apt update && apt install -y openssh-server wget git lrzsz && \
    sed -i 's/[# ]*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    echo 'root:root' | chpasswd
RUN mkdir -p /run/sshd

RUN sed -i 's#\w*\.debian\.org#mirrors\.aliyun\.com#g' /etc/apt/sources.list.d/debian.sources

CMD ["/usr/sbin/sshd", "-D"]