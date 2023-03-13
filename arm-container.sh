#!/bin/sh
wget https://kgithub.com/v2rayA/v2rayA/releases/download/v2.0.1/v2raya_linux_arm64_2.0.1
mv ./v2raya_linux_arm64_2.0.1 /usr/local/bin/v2raya
chmod u+x /usr/local/bin/v2raya

source ./common.sh
init

## make.conf
tee >/etc/portage/make.conf <<EOF
COMMON_FLAGS="-march=armv8-a -O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult https://wiki.gentoo.org/wiki/Changing_the_CHOST_variable before changing.
CHOST="aarch64-unknown-linux-gnu"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C


## XXXXXX
ACCEPT_KEYWORDS="~arm64"
KEYWORDS="~arm64"
MAKEOPTS="-j8"
USE="-X -qt -gtk -systemd -openrc"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
EOF

sync
eselect profile set default/linux/arm64/17.0
update
app
