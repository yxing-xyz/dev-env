#!/bin/sh

# gnome-keyring
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

[[ -f ~/.Xresources ]] && xrdb -merge -I ~/.Xresources

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export GOROOT=/usr/lib/go
export GOPATH=$HOME/.local/lib/gopath
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

exec awesome --search $HOME/.config/awesome/awesome-copycats/
