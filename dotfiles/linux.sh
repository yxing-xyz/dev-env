#!/bin/sh

dotfiles_dir=$(dirname "`readlink -f $0`")
home_dir=$(dirname "`readlink -f $0`")/home
source ${dotfiles_dir}/common.sh
# dotfile
ln -sf $home_dir/.xinitrc  ~
ln -sf $home_dir/.Xresources  ~
ln -sf $home_dir/.linux.zshrc  ~
