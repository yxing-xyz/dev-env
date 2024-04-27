#!/bin/sh
source ./common.sh
init

## make.conf
tee >/etc/portage/make.conf <<EOF
COMMON_FLAGS="-march=armv8-a -O2 -pipe"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"
# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult https://wiki.gentoo.org/wiki/Changing_the_CHOST_variable before changing.
CHOST="aarch64-unknown-linux-gnu"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C


## XXXXXX
FEATURES="buildpkg nostrip"
MAKEOPTS="-j8"
USE="binary -test -X -qt -gtk systemd -openrc -selinux"
ACCEPT_LICENSE="linux-fw-redistributable no-source-code google-chrome Microsoft-vscode Vic-Fieger-License"
GENTOO_MIRRORS="http://mirrors.tencent.com/gentoo/"
L10N="zh-CN"
UNINSTALL_IGNORE="/bin /lib /lib64 /sbin"
EOF

echo 'app-editors/emacs dynamic-loading games gif gmp gpm gui gzip-el jit jpeg json lcms libxml2 png source svg threads tiff toolkit-scroll-bars wide-int zlib imagemagick harfbuzz xft' >> /etc/portage/package.use/x

sync
eselect profile set default/linux/arm64/23.0/systemd
update
app
